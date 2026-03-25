output "frontend_repository_url" {
  description = "URL of the frontend repository"
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_repository_url" {
  description = "URL of the backend repository"
  value       = aws_ecr_repository.backend.repository_url
}

output "registry_url" {
  description = "The URL of the ECR registry"
  value       = split("/", aws_ecr_repository.frontend.repository_url)[0]
}
