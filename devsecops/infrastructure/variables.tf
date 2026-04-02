variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type for the DevSecOps monolith"
  type        = string
  default     = "t3a.2xlarge"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "flightly-devsecops-key"
}
