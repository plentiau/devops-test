locals {
  tags = {
    Owner       = "DevOps"
    Contact     = "minhcuong271197@gmail.com"
    Application = var.stack_id
    Environment = var.environment
  }
}