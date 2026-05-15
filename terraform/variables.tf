variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "AWS EC2 key pair name for SSH access"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Your public IP address allowed for SSH access"
  type        = string
}