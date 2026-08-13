output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_pem_path" {
  description = "Path to the bastion host private key PEM file"
  value       = local_file.bastion_private_key.filename
}
