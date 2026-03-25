output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "certificate_validation_id" {
  description = "Validation ID for dependency tracking"
  value       = aws_acm_certificate_validation.main.id
}
