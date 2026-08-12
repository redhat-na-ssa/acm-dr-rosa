terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.51.0"
    }
    rhcs = {
      version = ">= 1.7.7"
      source  = "terraform-redhat/rhcs"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "rhcs" {
  token = var.rhcs_token
}

# ------------------------------------------------------------------------------
# 1. VPC Module (Submodule from official repo)
# ------------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-redhat/rosa-hcp/rhcs//modules/vpc"
  version = "1.7.4"

  name_prefix              = var.vpc_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = 3

  # REQUIRED - terraform files for VPC peering filter on VPC tags
  vpc_tags = {
    Name = "rosa-vpc-${var.aws_region}"
  }

}

# ==============================================================================
# 2. CUSTOM SECURITY GROUPS
# ==============================================================================

# 1. Custom Control Plane Security Group
resource "aws_security_group" "primary_control_plane_sg" {
  name        = "rosa-primary-control-plane-sg"
  description = "Custom SG for Primary Control Plane"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rosa-primary-control-plane-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "primary_cp_allow_all_outbound" {
  security_group_id = aws_security_group.primary_control_plane_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# 2. Custom Compute Nodes Security Group
resource "aws_security_group" "primary_compute_sg" {
  name        = "rosa-primary-compute-sg"
  description = "Custom SG for Primary Compute Nodes"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rosa-primary-compute-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "primary_compute_allow_all_outbound" {
  security_group_id = aws_security_group.primary_compute_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ------------------------------------------------------------------------------
# 3. ROSA HCP Cluster Module
# ------------------------------------------------------------------------------
module "rosa_hcp_cluster" {
  source  = "terraform-redhat/rosa-hcp/rhcs"
  version = "1.7.4"

  # Cluster Identification
  cluster_name      = var.cluster_name
  openshift_version = var.openshift_version

  # Networking (Private Cluster + Multi-AZ)
  private                = true
  machine_cidr           = module.vpc.cidr_block
  aws_subnet_ids         = module.vpc.private_subnets
  aws_availability_zones = module.vpc.availability_zones

  # Pod and Service CIDRs (Submariner)
  pod_cidr     = var.pod_cidr
  service_cidr = var.service_cidr

  # IAM STS & Role Prefixes
  create_account_roles = false
  account_role_prefix  = var.account_role_prefix

  create_oidc           = true
  create_operator_roles = true
  operator_role_prefix  = var.operator_role_prefix

  # Compute Configuration (3 replicas for multi-AZ high availability)
  replicas = 3

  # Custom Control Plane SG
  aws_additional_control_plane_security_group_ids = [
    aws_security_group.primary_control_plane_sg.id
  ]

  # Custom Compute Nodes SG
  aws_additional_compute_security_group_ids = [
    aws_security_group.primary_compute_sg.id
  ]

  # Users
  create_admin_user = true
}
