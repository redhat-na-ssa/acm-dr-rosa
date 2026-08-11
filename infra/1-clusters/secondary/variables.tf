variable "rhcs_token" {
  type        = string
  description = "Red Hat Cloud Services offline API token"
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the ROSA cluster"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_name" {
  type        = string
  description = "Name prefix for the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "service_cidr" {
  type        = string
  default     = null
  description = "Block of IP addresses for services, for example \"172.30.0.0/16\"."
}

variable "pod_cidr" {
  type        = string
  default     = null
  description = "Block of IP addresses from which Pod IP addresses are allocated, for example \"10.128.0.0/14\"."
}

variable "account_role_prefix" {
  type        = string
  description = "User-defined prefix for AWS account roles"
}

variable "operator_role_prefix" {
  type        = string
  description = "User-defined prefix for ROSA operator IAM roles"
}

variable "openshift_version" {
  type        = string
  description = "OpenShift version"
  default     = "4.21.27"
}

variable "create_admin_user" {
  type        = bool
  default     = null
  description = "To create cluster admin user with default username `cluster-admin` and generated password. It will be ignored if `admin_credentials_username` or `admin_credentials_password` is set. (default: false)"
}
