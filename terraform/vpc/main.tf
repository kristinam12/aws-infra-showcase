# Defines the virtual private cloud and basic networking components
# (Minimal setup to run public-facing resources like EC2, EKS, ALB)
# Creates a VPC, public subnet in a specified AZ, an internet gateway, a route table that sends outbound traffic to the internet and a connection between the subnet and route table

# Set the AWS region for all resources
provider "aws" {
  region = var.aws_region
}

# Create the main VPC with DNS support and hostname resolution 
# VPC created with a specified CIDR block, enables DNS so instances can resolve domain names & enables DNS hostnames (required for using public IPs or ALBs)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create and attach an Internet Gateway to the VPC for outbound internet access 
# (for traffic/resources like EC2 OR ALBs to reach the internet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create a public subnet in a specific AZ in the VPC; EC2 will get a public IP, and it will be associated with the IGW later via routing
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.aws_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Create a route table for public internet access  (to direct traffic to the internet from within the VPC)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Add a default route to route table that sends outbound traffic to the internet (all internet-bound traffic routed through the IGW)
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate the public subnet to the route table (applies 'internet access' to the subnet)
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
