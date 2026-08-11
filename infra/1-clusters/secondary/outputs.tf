output "cluster_id" {
  value       = module.rosa_hcp_cluster.cluster_id
  description = "ROSA cluster ID"
}

output "api_url" {
  value       = module.rosa_hcp_cluster.cluster_api_url
  description = "Private API server endpoint"
}

output "console_url" {
  value       = module.rosa_hcp_cluster.cluster_console_url
  description = "OpenShift web console URL"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Created VPC ID"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnet IDs created for the cluster"
}

output "cluster_admin_username" {
  value       = module.rosa_hcp_cluster.cluster_admin_username
  description = "The username of the admin user."
  sensitive   = true
}

output "cluster_admin_password" {
  value       = module.rosa_hcp_cluster.cluster_admin_password
  description = "The password of the admin user."
  sensitive   = true
}
