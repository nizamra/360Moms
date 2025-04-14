terraform {
  required_version = "1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }

  backend "remote_bucket" {
    bucket         = "backend-bucket-name"
    key            = "terraform-state/ThreeSixtyMom.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamo-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      repo        = var.github_repo
      creator     = var.creator_name
      Project     = var.project_name
      Environment = var.environment
    }
  }
}