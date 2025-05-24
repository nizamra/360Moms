# Makefile for Terraform commands

# Variables
TF_PLAN_STAGING := staging.tfplan
STAGING_VARS := staging.tfvars
TF_PLAN_PRODUCTION := production.tfplan
PRODUCTION_VARS := production.tfvars

# Hardcoded example passwords
DB_PASSWORD_STAGING := "StagingPa$$wOrd123!"
DB_PASSWORD_PRODUCTION := "ProdPa$$wOrd987@"

.PHONY: init validate plan-staging apply-staging destroy-staging all-staging plan-production apply-production destroy-production all-production

init:
	terraform init

validate:
	terraform validate

# Staging Workspace
plan-staging: init validate
	terraform workspace select staging || terraform workspace new staging
	terraform plan -var-file=$(STAGING_VARS) -var="db_password=$(DB_PASSWORD_STAGING)" -out=$(TF_PLAN_STAGING)

apply-staging:
	terraform workspace select staging
	terraform apply -auto-approve $(TF_PLAN_STAGING)

destroy-staging:
	terraform workspace select staging
	terraform destroy -var-file=$(STAGING_VARS) -var="db_password=$(DB_PASSWORD_STAGING)" -auto-approve

all-staging: init validate plan-staging apply-staging

# Production Workspace
plan-production: init validate
	terraform workspace select production || terraform workspace new production
	terraform plan -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -out=$(TF_PLAN_PRODUCTION)

apply-production:
	terraform workspace select production
	terraform apply -auto-approve $(TF_PLAN_PRODUCTION)

destroy-production:
	terraform workspace select production
	terraform destroy -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -auto-approve

all-production: init validate plan-production apply-production 