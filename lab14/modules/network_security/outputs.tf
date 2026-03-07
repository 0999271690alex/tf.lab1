output "ssh_sg" {
  value = aws_security_group.ssh.id
}

output "public_http_sg" {
  value = aws_security_group.public_http.id
}

output "private_http_sg" {
  value = aws_security_group.private_http.id
}
