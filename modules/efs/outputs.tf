output "efs_id" {
    value = aws_efs_file_system.efs.id
    description = "Returns the ID that identifies the file system"
}