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
}

provider "rhcs" {
  token = var.rhcs_token
}

variable "account_role_prefix" {
  type    = string
  default = "rosa-account"
}

variable "rhcs_token" {
  type        = string
  description = "Red Hat Cloud Services offline API token"
  sensitive   = true
}

module "account_iam_resources" {
  source  = "terraform-redhat/rosa-hcp/rhcs//modules/account-iam-resources"
  version = "1.7.4"

  account_role_prefix = var.account_role_prefix
}

output "account_role_prefix" {
  value = module.account_iam_resources.account_role_prefix
}

