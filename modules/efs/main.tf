locals {
  mytags ={
    Name = "${var.project_name}"
    Owner = "Lester Santos"
  }
}

resource "aws_efs_file_system" "efs" {
    creation_token = "${var.project_name}-efs"
    
    tags = merge(local.mytags, {Name = "${local.mytags.Name}-efs"})
    encrypted = false
    throughput_mode = "bursting"
    performance_mode = "generalPurpose"

}

# resource "aws_efs_backup_policy" "policy" {
#   file_system_id = aws_efs_file_system.efs.id

#   backup_policy {
#     status = "DISABLED"
#   }
# }

resource "aws_efs_mount_target" "mount_tg" {
    count = length(var.subnets)
    file_system_id = aws_efs_file_system.efs.id
    subnet_id      = var.subnets[count.index]
    security_groups = [aws_security_group.mount_sg.id]
}

#-------------AWS SECURITY GROUP --------------------------
resource "aws_security_group" "mount_sg" {
  name        = "${var.project_name}-efs-mount-sg"
  description = "Allows access from the Backend security group on TCP port 2049"
  vpc_id      = var.vpc_id
  tags = merge(local.mytags, {Name = "${local.mytags.Name}-efs-mount-sg"})

  ingress {
    description = "NFS access from Backend sg"
    from_port   = 2049
    to_port     = 2049 
    protocol    = "tcp"
    security_groups = [var.backend_sg_id]
  }

  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-----------------------------------------------------------
