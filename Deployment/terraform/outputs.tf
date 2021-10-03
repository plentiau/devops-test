output "ecr_repo" {
  value = aws_ecr_repository.weather_service.repository_url
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}