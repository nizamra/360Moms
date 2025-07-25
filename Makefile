# Makefile for Terraform commands

# Variables
TF_PLAN_dev := dev.tfplan
dev_VARS := dev.tfvars
TF_PLAN_PRODUCTION := production.tfplan
PRODUCTION_VARS := production.tfvars
dev_BRANCH := dev
PRODUCTION_BRANCH := production

# Hardcoded example passwords
DB_PASSWORD_dev := "devPa$$wOrd123!"
DB_PASSWORD_PRODUCTION := "ProdPa$$wOrd987@"

.PHONY: init validate plan-dev apply-dev destroy-dev all-dev plan-production apply-production destroy-production all-production checkout-dev checkout-production

init:
	terraform init

validate:
	terraform validate

checkout-dev:
	git checkout $(dev_BRANCH) || git checkout -b $(dev_BRANCH)

checkout-production:
	git checkout $(PRODUCTION_BRANCH)

# dev Workspace
plan-dev: checkout-dev init validate
	terraform workspace select dev || terraform workspace new dev
	terraform plan -var-file=$(dev_VARS) -var="db_password=$(DB_PASSWORD_dev)" -out=$(TF_PLAN_dev)

apply-dev: checkout-dev
	terraform workspace select dev
	terraform apply -auto-approve $(TF_PLAN_dev)

destroy-dev: checkout-dev
	terraform workspace select dev
	terraform destroy -var-file=$(dev_VARS) -var="db_password=$(DB_PASSWORD_dev)" -auto-approve

all-dev: checkout-dev init validate plan-dev apply-dev

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
