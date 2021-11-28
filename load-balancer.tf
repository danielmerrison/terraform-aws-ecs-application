data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "alb_destination" {
  description = "Security group that should be attached to targets for the external and internal loadbalancers.  This might be changed."
  name        = join("-", [var.application_name, "alb", "destination"])
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "internal_alb" {
  description = "Allow access from any ip in the vpc & connections form the alb to services with the security group ${aws_security_group.alb_destination.name}"
  name        = join("-", [var.application_name, "alb", "internal"])
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [
      aws_security_group.alb_destination.id
    ]
  }
}

resource "aws_security_group" "external_alb" {
  description = "Allow access from anywhere & connections form the alb to services with the security group ${aws_security_group.alb_destination.name}"
  name        = join("-", [var.application_name, "alb", "external"])
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [
      aws_security_group.alb_destination.id
    ]
  }
}

resource "aws_lb" "internal" {
  name               = join("-", [var.application_name, "alb", "internal"])
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  access_logs {
    bucket  = module.log_bucket.id
    enabled = true
    prefix  = join("-", [var.application_name, "alb", "internal"])
  }

}

resource "aws_lb" "external" {
  name               = join("-", [var.application_name, "alb", "external"])
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  access_logs {
    bucket  = module.log_bucket.id
    enabled = true
    prefix  = join("-", [var.application_name, "alb", "external"])
  }
}
