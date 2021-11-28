resource "aws_cloudwatch_log_group" "this" {
  name = var.application_name
}

module "log_bucket" {
  source = "git::https://github.com/danielmerrison/terraform-aws-private-s3-bucket.git?ref=v0.0.1"

  bucket_name = var.application_name
}

resource "aws_ecs_cluster" "this" {
  name = var.application_name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  configuration {
    execute_command_configuration {
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
      logging = "OVERRIDE"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
