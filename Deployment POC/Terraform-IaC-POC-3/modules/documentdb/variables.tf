variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_master_username" {
  description = "Username for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_master_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}
