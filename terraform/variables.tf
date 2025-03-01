variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu recommended)"
  default     = "ami-0e1bed4f06a3b463d"  # Ubuntu 22.04 LTS in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key name for the instance"
  default     = "numbers"
}

variable "domain_name" {
  description = "Domain name to be managed in Route53"
  default     = "oluwatobiloba.tech"
}