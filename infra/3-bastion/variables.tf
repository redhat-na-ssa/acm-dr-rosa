variable "primary_vpc_name" {
  type    = string
  default = "primary"
}

variable "primary_region" {
  type        = string
  description = "AWS region for Primary Cluster (plus Bastion)"
  default     = "us-east-1"
}

variable "allowed_my_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR notation for SSH access (e.g. 203.0.113.5/32)"
}
