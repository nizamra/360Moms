terraform {
  required_version = "1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }

  backend "s3" {
    bucket       = "threesixtymom-state"
    key          = "tfstate/ThreeSixtyMom.tfstate"
    region       = "me-south-1"
    use_lockfile = true
    encrypt      = true
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
