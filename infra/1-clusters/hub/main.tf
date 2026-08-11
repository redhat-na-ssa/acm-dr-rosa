terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.38.0"
    }
    rhcs = {
      source  = "terraform-redhat/rhcs"
      version = ">= 1.7.7"
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
  source = "terraform-redhat/rosa-hcp/rhcs//modules/vpc"
  version = "1.7.4"

  name_prefix              = var.vpc_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = 3
}

# ------------------------------------------------------------------------------
# 2. ROSA HCP Cluster Module
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

  # IAM STS & Role Prefixes
  create_account_roles = false
  account_role_prefix  = var.account_role_prefix

  create_oidc           = true
  create_operator_roles = true
  operator_role_prefix  = var.operator_role_prefix

  # Compute Configuration (3 replicas for multi-AZ high availability)
  replicas = 3

  # Users
  create_admin_user = true
}
