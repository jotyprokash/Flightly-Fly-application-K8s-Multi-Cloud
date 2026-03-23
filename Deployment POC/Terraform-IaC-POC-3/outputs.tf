output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API Server Endpoint"
  value       = module.eks.cluster_endpoint
}

output "documentdb_endpoint" {
  description = "DocumentDB Cluster Endpoint"
  value       = module.documentdb.cluster_endpoint
}

output "ecr_frontend_url" {
  description = "ECR Frontend URL"
  value       = module.ecr.frontend_repository_url
}

output "ecr_backend_url" {
  description = "ECR Backend URL"
  value       = module.ecr.backend_repository_url
}
