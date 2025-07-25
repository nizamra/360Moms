# 360Moms Infrastructure

This repository contains the infrastructure code for the 360Moms project, built using Terraform. The infrastructure is designed to support both dev and production environments on AWS.

## Environment Management

The infrastructure is managed using both Git branches and Terraform workspaces:

- **dev Environment**:
  - Git Branch: `dev`
  - Terraform Workspace: `dev`
  - Configuration: `dev.tfvars`

- **Production Environment**:
  - Git Branch: `production`
  - Terraform Workspace: `production`
  - Configuration: `production.tfvars`

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── provider.tf             # Provider configuration
├── dev.tfvars         # dev environment variables
├── production.tfvars      # Production environment variables
├── Makefile              # Automation for deployment workflows
└── modules/
    ├── network/            # Network module
    │   ├── variables.tf    # Network variables
    │   ├── vpc.tf          # VPC configuration
    │   └── outputs.tf      # Network outputs
    ├── ec2/               # EC2 module
    │   ├── variables.tf    # EC2 variables
    │   ├── main.tf         # EC2 instance configuration
    │   └── outputs.tf      # EC2 outputs
    ├── rds/               # RDS module
    │   ├── variables.tf    # RDS variables
    │   ├── main.tf         # RDS configuration
    │   └── outputs.tf      # RDS outputs
    ├── redis/             # Redis module
    │   ├── variables.tf    # Redis variables
    │   ├── main.tf         # Redis configuration
    │   └── outputs.tf      # Redis outputs
    └── cloudwatch/         # Monitoring module
        ├── variables.tf    # CloudWatch variables
        ├── main.tf         # CloudWatch configuration
        └── outputs.tf      # CloudWatch outputs
```

## Infrastructure Components

The infrastructure includes the following components:

- **Network Module**:
  - Custom VPC with public and private subnets
  - Internet Gateway, NAT Gateway
  - Security Groups for EC2, RDS, and Redis

- **EC2 Module**:
  - Application servers in private subnets
  - Integration with RDS and Redis endpoints
  - Security group configuration

- **RDS Module**:
  - MySQL managed database service
  - Configurable instance class and storage
  - Private subnet deployment
  - Security group configuration

- **Redis Module**:
  - ElastiCache for Redis
  - Configurable node type
  - Private subnet deployment
  - Security group configuration

- **CloudWatch Module**:
  - Comprehensive monitoring and alerting
  - Metric collection for EC2, RDS, and Redis
  - Email notifications for alerts

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

2. Choose your target environment:

   For dev:
   ```bash
   make checkout-dev
   ```

   For production:
   ```bash
   make checkout-production
   ```

3. Initialize Terraform:
   ```bash
   make init
   ```

4. Configure your environment-specific variables in either `dev.tfvars` or `production.tfvars`:
   ```hcl
   aws_region = "us-east-1"

   # Network configuration
   vpc_cidr = "10.0.0.0/16"
   public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   availability_zones = ["us-east-1a", "us-east-1b"]

   # EC2 configuration
   ami_id = "ami-xxxxxxxxxxxxxxxxx"
   instance_type = "t2.micro"

   # RDS configuration
   db_engine = "mysql"
   db_instance_class = "db.t3.micro"
   db_storage = 20
   db_storage_type = "gp2"
   max_db_storage = 100
   db_username = "admin"
   ```

5. Deploy the infrastructure:

   For dev:
   ```bash
   make all-dev
   ```

   For production:
   ```bash
   make all-production
   ```

   Or deploy individual components:
   ```bash
   # dev
   make plan-dev     # Review changes
   make apply-dev    # Apply changes

   # Production
   make plan-production  # Review changes
   make apply-production # Apply changes
   ```

6. To destroy infrastructure:

   For dev:
   ```bash
   make destroy-dev
   ```

   For production:
   ```bash
   make destroy-production
   ```

## Security

- Network security through VPC and security groups
- Private subnets for database and cache resources
- Secure credential management
- IAM roles for service access

## Monitoring

The CloudWatch module provides monitoring for:

- EC2 instances: CPU, memory, and disk metrics
- RDS instances: CPU, memory, storage, and connection metrics
- Redis clusters: CPU, memory, and cache metrics
- Email notifications for critical alerts

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

[Add your license information here]
