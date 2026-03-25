variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC provider"
  type        = string
}

variable "policy_arn" {
  description = "The ARN of the IAM policy for the LB controller"
  type        = string
  default     = "arn:aws:iam::434562741459:policy/AWSLoadBalancerControllerIAMPolicy"
}
