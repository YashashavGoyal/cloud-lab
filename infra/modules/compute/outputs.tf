output "instance_ids" {
  description = "List of IDs of the provisioned EC2 application instances"
  value       = aws_instance.app[*].id
}

output "private_ips" {
  description = "List of private IP addresses assigned to the EC2 instances"
  value       = aws_instance.app[*].private_ip
}

output "ami_id_used" {
  description = "The AMI ID used to launch the EC2 instances"
  value       = aws_instance.app[0].ami
}
