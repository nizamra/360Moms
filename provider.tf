# Provider Configuration File
# This file configures the Terraform providers and backend storage for state management

# Terraform Block
# Specifies the required Terraform version and provider requirements
terraform {
  required_version = ">= 1.11.2" # Specific Terraform version requirement

  # Required Provider Configurations
  # Defines the source and version of providers needed for this infrastructure
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official HashiCorp AWS provider
      version = "5.94.1"        # Specific AWS provider version for consistency
    }
  }

  # Backend Configuration
  # Configures S3 as the backend for storing Terraform state
  backend "s3" {
    bucket       = "terraform-state-360moms"       # S3 bucket for state storage
    key          = "tfstate/ThreeSixtyMom.tfstate" # Path to state file within bucket
    region       = "eu-central-1"                  # AWS region for the state bucket
    use_lockfile = true                            # Enable state locking to prevent concurrent modifications
    encrypt      = true                            # Enable server-side encryption of state file
  }
}

# AWS Provider Configuration
# Configures the AWS provider with region and default resource tags
provider "aws" {
  region = var.aws_region # Use the region specified in variables

  # Default Tags
  # These tags will be automatically applied to all resources created by this configuration
  default_tags {
    tags = {
      repo    = var.github_repo  # Repository where this configuration is stored
      creator = var.creator_name # Person responsible for this infrastructure
      Project = var.project_name # Project identifier
    }
  }
}
