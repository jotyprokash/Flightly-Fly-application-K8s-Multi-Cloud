variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the certificate"
  type        = string
}

variable "zone_id" {
  description = "The Route53 zone ID for DNS validation"
  type        = string
}
