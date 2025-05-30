# Network Infrastructure Configuration
# This file defines the VPC and associated networking components for the application infrastructure

#----------------------VPC Configuration----------------------#
# Main VPC resource with DNS support enabled
resource "aws_vpc" "private_cloud" {
  cidr_block           = var.vpc_cidr # IP address range for the VPC
  enable_dns_support   = true         # Enable DNS resolution
  enable_dns_hostnames = true         # Enable DNS hostnames

  tags = {
    Name = "vpc"
  }
}

#----------------------Subnet Configuration----------------------#
# Public Subnets - Used for resources that need direct internet access
resource "aws_subnet" "public" {
  count             = length(var.public_subnets) # Create multiple subnets based on the input list
  vpc_id            = aws_vpc.private_cloud.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index] # Distribute across AZs

  tags = {
    Name = "public-${count.index}"
  }
}

# Private Subnets - Used for resources that don't need direct internet access
resource "aws_subnet" "private" {
  count             = length(var.private_subnets) # Create multiple subnets based on the input list
  vpc_id            = aws_vpc.private_cloud.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index] # Distribute across AZs

  tags = {
    Name = "private-${count.index}"
  }
}

#----------------------Internet Connectivity----------------------#
# Internet Gateway - Enables internet access for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.private_cloud.id

  tags = {
    Name = "igw"
  }
}

# Elastic IPs for NAT Gateways - Static public IPs
resource "aws_eip" "nat" {
  count  = length(var.public_subnets) # One EIP per NAT Gateway
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateways - Enable internet access for private subnets
resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)        # One NAT Gateway per public subnet
  allocation_id = aws_eip.nat[count.index].id       # Associate with Elastic IP
  subnet_id     = aws_subnet.public[count.index].id # Place in public subnet

  tags = {
    Name = "nat"
  }
}

#----------------------Routing Configuration----------------------#
# Private Route Tables - Route traffic from private subnets through NAT Gateways
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.private_cloud.id

  route {
    cidr_block     = "0.0.0.0/0"                         # Route all external traffic
    nat_gateway_id = aws_nat_gateway.nat[count.index].id # Through the NAT Gateway
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Public Route Tables - Route traffic from public subnets through Internet Gateway
resource "aws_route_table" "public" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.private_cloud.id

  route {
    cidr_block = "0.0.0.0/0"                 # Route all external traffic
    gateway_id = aws_internet_gateway.igw.id # Through the Internet Gateway
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

#----------------------Subnet Groups----------------------#
# RDS Subnet Group - Groups private subnets for RDS deployment
resource "aws_db_subnet_group" "rds" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id # Use all private subnets
}

# ElastiCache Subnet Group - Groups private subnets for Redis deployment
resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.name_prefix}-redis-subnet-group"
  subnet_ids = aws_subnet.private[*].id # Use all private subnets
}

#----------------------Security Groups----------------------#
# EC2 Security Group - Controls inbound/outbound traffic for EC2 instances
resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.private_cloud.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "ec2-sg"
  }
}

# RDS Security Group - Controls access to RDS instances
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow inbound traffic to RDS from EC2"
  vpc_id      = aws_vpc.private_cloud.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id] # Allow access only from EC2 instances
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

# Redis Security Group - Controls access to Redis clusters
resource "aws_security_group" "redis" {
  name        = "${var.name_prefix}-redis-sg"
  description = "Allow inbound traffic to Redis from EC2"
  vpc_id      = aws_vpc.private_cloud.id

  ingress {
    description     = "Redis from EC2"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id] # Allow access only from EC2 instances
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.name_prefix}-redis-sg"
  }
}
