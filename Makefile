# Makefile for Terraform commands

# Variables
TF_PLAN_dev := dev.tfplan
dev_VARS := dev.tfvars
TF_PLAN_PRODUCTION := prod.tfplan
PRODUCTION_VARS := prod.tfvars
dev_BRANCH := dev
PRODUCTION_BRANCH := prod

# Hardcoded example passwords
DB_PASSWORD_dev := "devPa$$wOrd123!"
DB_PASSWORD_PRODUCTION := "ProdPa$$wOrd987@"

.PHONY: init validate plan-dev apply-dev destroy-dev all-dev plan-prod apply-prod destroy-prod all-prod checkout-dev checkout-prod

init:
	terraform init

validate:
	terraform validate

checkout-dev:
	git checkout $(dev_BRANCH) || git checkout -b $(dev_BRANCH)

checkout-prod:
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
plan-prod: checkout-prod init validate
	terraform workspace select prod || terraform workspace new prod
	terraform plan -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -out=$(TF_PLAN_PRODUCTION)

apply-prod: checkout-prod
	terraform workspace select prod
	terraform apply -auto-approve $(TF_PLAN_PRODUCTION)

destroy-prod: checkout-prod
	terraform workspace select prod
	terraform destroy -var-file=$(PRODUCTION_VARS) -var="db_password=$(DB_PASSWORD_PRODUCTION)" -auto-approve

all-prod: checkout-prod init validate plan-prod apply-prod
