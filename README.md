# 360Moms Infrastructure

This repository contains the infrastructure code for the 360Moms project, built using Terraform. The infrastructure is designed to support both staging and production environments on AWS.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── provider.tf             # Provider configuration
└── modules/
    ├── network/            # Network module
    │   ├── variables.tf    # Network variables
    │   ├── vpc.tf          # VPC configuration
    │   └── outputs.tf      # Network outputs 
    ├── environment/        # Environment module (staging/production)
    │   ├── variables.tf    # Environment variables
    │   ├── ec2.tf          # EC2 instance configuration
    │   ├── rds.tf          # RDS database configuration
    │   ├── redis.tf        # Redis cache configuration
    │   └── outputs.tf      # Module outputs
    └── cloudwatch/         # Monitoring module
        ├── variables.tf    # CloudWatch variables
        ├── cloudwatch_alarm.tf      # CloudWatch alarms
        ├── cloudwatch_log_groups.tf # CloudWatch log groups
        └── cloudwatch_dashboard.tf  # CloudWatch dashboards
```

## Infrastructure Components

The infrastructure includes the following components for both staging and production environments:

- **Network Module**: 
  - Custom VPC with public and private subnets
  - Internet Gateway, NAT Gateway
  - Security Groups

- **Environment Module**:
  - **EC2 Instances**: Application servers with Docker and Nginx
  - **RDS Database**: MySQL managed database service 
  - **Redis Cache**: ElastiCache for Redis

- **CloudWatch Module**: 
  - Comprehensive monitoring and alerting
  - Log groups for application, Nginx, system, RDS, and Redis logs
  - Metric filters and alarms for critical resources

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

3. Set the required variables in a `terraform.tfvars` file:
   ```bash
   # AWS region
   aws_region = "us-east-1"
   
   # Networking
   vpc_cidr = "10.0.0.0/16"
   public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   availability_zones = ["us-east-1a", "us-east-1b"]
   
   # Staging environment
   stag_instance_type = "t2.micro"
   stag_ami_id = "ami-xxxxxxxxxxxxxxxxx"
   stag_db_instance_class = "db.t3.micro"
   stag_db_storage = 20
   stag_db_username = "admin"
   stag_db_password = "your-secure-password"
   stag_redis_node_type = "cache.t3.micro"
   
   # Production environment
   prod_instance_type = "t2.micro"
   prod_ami_id = "ami-xxxxxxxxxxxxxxxxx"
   prod_db_instance_class = "db.t3.micro"
   prod_db_storage = 20
   prod_db_username = "admin"
   prod_db_password = "your-secure-password"
   prod_redis_node_type = "cache.t3.micro"
   ```

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
   - Separate EC2, RDS, and Redis instances
   - Full CloudWatch monitoring

2. **Production Environment**
   - Configured for production workloads
   - Separate EC2, RDS, and Redis instances
   - Full CloudWatch monitoring

## Security

- Network security is implemented through VPC and security groups
- IAM roles for EC2 to access CloudWatch
- Database credentials are managed securely
- Private subnets for database and cache resources

## Monitoring

The CloudWatch module provides comprehensive monitoring:

- **CloudWatch Log Groups**: Collects logs from applications, Nginx, system logs, RDS, and Redis
- **Metric Filters**: Extracts patterns from logs to create metrics
- **CloudWatch Alarms**: Configured for:
  - EC2: CPU utilization, status checks, memory, disk usage
  - RDS: CPU utilization, freeable memory, storage, connections
  - Redis: CPU utilization, freeable memory, cache hit rate
- **SNS Notifications**: Alerts sent to specified email addresses
