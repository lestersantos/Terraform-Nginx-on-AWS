output "vpc_id" {
    value = aws_vpc.ls-vpc.id #export values
    description = "Returns VPC ID"
}

output "vpc_public_subnets" {
    value = aws_subnet.public[*].id #export values
    description = "Returns an array of public subnets"
}

output "vpc_private_subnets" {
    value = aws_subnet.private[*].id #export values
    description = "Returns an array of public subnets"
}