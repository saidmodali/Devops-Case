output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.devops_case.public_ip
}

output "frontend_url" {
  description = "Frontend NodePort URL"
  value       = "http://${aws_instance.devops_case.public_ip}:30080"
}

output "backend_healthcheck_url" {
  description = "Backend healthcheck URL"
  value       = "http://${aws_instance.devops_case.public_ip}:30050/healthcheck"
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = "ssh -i <your-key.pem> ubuntu@${aws_instance.devops_case.public_ip}"
}