variable "name" {
  description = "Name of the repository."
  default = "weather-service"
}
variable "tags" {
  description = "Tags."
  type        = map(string)
  default = {
    weather-service = "image-1234"
    weather-service = "image-4567"
  }
}
variable "mutable" {
  default = false
}
variable "scan" {
  default = true
}
variable "share_with_accounts" {
  type    = list(string)
  default = []
}
data "aws_region" "current" {}

locals {
  name       = var.name
  region     = data.aws_region.current.name
  title      = title(replace(replace(local.name, "-", ""), " ", ""))
  mutability = var.mutable ? "MUTABLE" : "IMMUTABLE"
  scan       = var.scan
  accounts   = formatlist("arn:aws:iam::%s:root", var.share_with_accounts)
  tags = merge({
    Name          = local.name
    Module        = "ECR Repository"
    ModuleVersion = "v0.2.2"
    ModuleSource  = "https://github.com/jetbrains-infra/terraform-aws-ecr/"
  }, var.tags)
}