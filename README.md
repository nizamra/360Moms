# 360Moms Infrastructure

This repository contains the infrastructure code for the 360Moms project, built using Terraform. The infrastructure is designed to support both staging and production environments on AWS.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── provider.tf             # Provider configuration
├── values.auto.tfvars      # Environment-specific variables
└── modules/
    └── environment/        # Environment module
        ├── main.tf         # Main environment configuration
        ├── variables.tf    # Environment variables
        ├── ec2.tf          # EC2 instance configuration
        ├── rds.tf          # RDS database configuration
        ├── redis.tf        # Redis cache configuration
        ├── cloudwatch_alarm.tf  # CloudWatch alarms
        └── outputs.tf      # Module outputs
```

## Infrastructure Components

The infrastructure includes the following components for both staging and production environments:

- **VPC Network**: Custom VPC with public and private subnets
- **EC2 Instances**: Application servers
- **RDS Database**: Managed database service
- **Redis Cache**: In-memory data store
- **CloudWatch Alarms**: Monitoring and alerting

## Prerequisites

- Terraform (v1.0.0 or later)
- AWS CLI configured with appropriate credentials
- Access to AWS services (EC2, RDS, ElastiCache, etc.)

## Setup and Deployment

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd 360Moms
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the variables in `values.auto.tfvars` and update as needed:
   - Environment-specific configurations
   - Instance types
   - Database settings
   - Redis configurations

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Environment Configuration

The infrastructure supports two environments:

1. **Staging Environment**
   - Configured for testing and development
   - Uses smaller instance types
   - Separate database and cache instances

2. **Production Environment**
   - Configured for production workloads
   - Uses larger instance types
   - High availability setup
   - Production-grade database and cache configurations

## Security

- All sensitive variables should be managed through secure means (AWS Secrets Manager, environment variables, etc.)
- Network security is implemented through VPC and security groups
- Database credentials are managed securely

## Monitoring

- CloudWatch alarms are configured for:
  - CPU utilization
  - Memory usage
  - Disk space
  - Database metrics
  - Cache metrics
