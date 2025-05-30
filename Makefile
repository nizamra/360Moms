# Makefile for Terraform commands

# Variables
TF_PLAN_STAGING := staging.tfplan
STAGING_VARS := staging.tfvars
TF_PLAN_PRODUCTION := production.tfplan
PRODUCTION_VARS := production.tfvars
STAGING_BRANCH := staging
PRODUCTION_BRANCH := production

# Hardcoded example passwords
DB_PASSWORD_STAGING := "StagingPa$$wOrd123!"
DB_PASSWORD_PRODUCTION := "ProdPa$$wOrd987@"

.PHONY: init validate plan-staging apply-staging destroy-staging all-staging plan-production apply-production destroy-production all-production checkout-staging checkout-production

init:
	terraform init

validate:
	terraform validate

checkout-staging:
	git checkout $(STAGING_BRANCH) || git checkout -b $(STAGING_BRANCH)

checkout-production:
	git checkout $(PRODUCTION_BRANCH)

# Staging Workspace
plan-staging: checkout-staging init validate
	terraform workspace select staging || terraform workspace new staging
	terraform plan -var-file=$(STAGING_VARS) -var="db_password=$(DB_PASSWORD_STAGING)" -out=$(TF_PLAN_STAGING)

apply-staging: checkout-staging
	terraform workspace select staging
	terraform apply -auto-approve $(TF_PLAN_STAGING)

destroy-staging: checkout-staging
	terraform workspace select staging
	terraform destroy -var-file=$(STAGING_VARS) -var="db_password=$(DB_PASSWORD_STAGING)" -auto-approve

all-staging: checkout-staging init validate plan-staging apply-staging

# Production Workspace
plan-production: checkout-production init validate
	terraform workspace select production || terraform workspace new production
	terraform plan -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -out=$(TF_PLAN_PRODUCTION)

apply-production: checkout-production
	terraform workspace select production
	terraform apply -auto-approve $(TF_PLAN_PRODUCTION)

destroy-production: checkout-production
	terraform workspace select production
	terraform destroy -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -auto-approve

all-production: checkout-production init validate plan-production apply-production 