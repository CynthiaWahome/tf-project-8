output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_instance_ip" {
  value = aws_instance.private_instance.private_ip
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private-subnet[*].id
}

output "whiz_key_private_key" {
  value     = tls_private_key.whiz_key.private_key_pem
  sensitive = true
}