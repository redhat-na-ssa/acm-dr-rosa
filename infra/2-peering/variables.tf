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
