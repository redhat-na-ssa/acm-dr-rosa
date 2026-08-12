output "peering_connection_ids" {
  description = "VPC Peering Connection IDs across all 3 regions"
  value = {
    hub_to_primary       = aws_vpc_peering_connection.hub_to_primary.id
    hub_to_secondary     = aws_vpc_peering_connection.hub_to_secondary.id
    primary_to_secondary = aws_vpc_peering_connection.primary_to_secondary.id
  }
}
