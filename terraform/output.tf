output "instance_public_ip" {
  description = "The public IP of the provisioned EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "domain_name" {
  description = "The domain name managed in Route53"
  value       = var.domain_name
}

output "ansible_inventory" {
  description = "The path to the Ansible inventory file"
  value       = local_file.ansible_inventory.filename
}

output "ssh_command" {
  description = "The SSH command to connect to the provisioned EC2 instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}