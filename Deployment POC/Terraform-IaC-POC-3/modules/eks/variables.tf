variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the EKS cluster role"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the EKS node role"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}
