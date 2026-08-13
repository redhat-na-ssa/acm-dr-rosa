variable "hub_vpc_name" {
  type    = string
  default = "hub"
}

variable "primary_vpc_name" {
  type    = string
  default = "primary"
}

variable "secondary_vpc_name" {
  type    = string
  default = "secondary"
}

variable "hub_region" {
  type        = string
  description = "AWS region for Hub Cluster"
  default     = "us-west-2"
}

variable "primary_region" {
  type        = string
  description = "AWS region for Primary Cluster (plus Bastion)"
  default     = "us-east-1"
}

variable "secondary_region" {
  type        = string
  description = "AWS region for Secondary Cluster"
  default     = "us-east-2"
}
