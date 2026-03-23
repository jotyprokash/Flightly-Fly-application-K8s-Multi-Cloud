variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "flightly"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "poc3"
}

variable "db_master_username" {
  description = "Username for the DocumentDB master user"
  type        = string
  sensitive   = true
}

variable "db_master_password" {
  description = "Password for the DocumentDB master user"
  type        = string
  sensitive   = true
}
