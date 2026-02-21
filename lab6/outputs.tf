output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "public_subnet_cidr_block" {
  description = "CIDR blocks of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "public_subnet_availability_zone" {
  description = "Availability zones of public subnets"
  value       = [for subnet in aws_subnet.public : subnet.availability_zone]
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "routing_table_id" {
  description = "Route Table ID"
  value       = aws_route_table.public_rt.id
}
