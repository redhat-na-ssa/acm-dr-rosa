# ==============================================================================
# 1. PEERING MESH: HUB <---> PRIMARY
# ==============================================================================
resource "aws_vpc_peering_connection" "hub_to_primary" {
  provider    = aws.hub
  vpc_id      = data.aws_vpc.hub.id
  peer_vpc_id = data.aws_vpc.primary.id
  peer_region = var.primary_region
  auto_accept = false

  tags = { Name = "peering-hub-to-primary" }
}

resource "aws_vpc_peering_connection_accepter" "primary_accept_hub" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_primary.id
  auto_accept               = true

  tags = { Name = "accept-peering-from-hub" }
}

resource "aws_vpc_peering_connection_options" "hub_to_primary_requester_opts" {
  provider                  = aws.hub
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_primary.id

  requester { allow_remote_vpc_dns_resolution = true }
}

resource "aws_vpc_peering_connection_options" "hub_to_primary_accepter_opts" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.primary_accept_hub.id

  accepter { allow_remote_vpc_dns_resolution = true }
}

# Routes
resource "aws_route" "hub_to_primary_routes" {
  for_each                  = toset(data.aws_route_tables.hub.ids)
  provider                  = aws.hub
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.primary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_primary.id
}

resource "aws_route" "primary_to_hub_routes" {
  for_each                  = toset(data.aws_route_tables.primary.ids)
  provider                  = aws.primary
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.hub.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_primary.id
}

# ==============================================================================
# 2. PEERING MESH: HUB <---> SECONDARY
# ==============================================================================
resource "aws_vpc_peering_connection" "hub_to_secondary" {
  provider    = aws.hub
  vpc_id      = data.aws_vpc.hub.id
  peer_vpc_id = data.aws_vpc.secondary.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = { Name = "peering-hub-to-secondary" }
}

resource "aws_vpc_peering_connection_accepter" "secondary_accept_hub" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_secondary.id
  auto_accept               = true

  tags = { Name = "accept-peering-from-hub" }
}

resource "aws_vpc_peering_connection_options" "hub_to_secondary_requester_opts" {
  provider                  = aws.hub
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_secondary.id

  requester { allow_remote_vpc_dns_resolution = true }
}

resource "aws_vpc_peering_connection_options" "hub_to_secondary_accepter_opts" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.secondary_accept_hub.id

  accepter { allow_remote_vpc_dns_resolution = true }
}

# Routes
resource "aws_route" "hub_to_secondary_routes" {
  for_each                  = toset(data.aws_route_tables.hub.ids)
  provider                  = aws.hub
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.secondary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_secondary.id
}

resource "aws_route" "secondary_to_hub_routes" {
  for_each                  = toset(data.aws_route_tables.secondary.ids)
  provider                  = aws.secondary
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.hub.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.hub_to_secondary.id
}

# ==============================================================================
# 3. PEERING MESH: PRIMARY <---> SECONDARY
# ==============================================================================
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = data.aws_vpc.primary.id
  peer_vpc_id = data.aws_vpc.secondary.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = { Name = "peering-primary-to-secondary" }
}

resource "aws_vpc_peering_connection_accepter" "secondary_accept_primary" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = { Name = "accept-peering-from-primary" }
}

resource "aws_vpc_peering_connection_options" "primary_to_secondary_requester_opts" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  requester { allow_remote_vpc_dns_resolution = true }
}

resource "aws_vpc_peering_connection_options" "primary_to_secondary_accepter_opts" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.secondary_accept_primary.id

  accepter { allow_remote_vpc_dns_resolution = true }
}

# Routes
resource "aws_route" "primary_to_secondary_routes" {
  for_each                  = toset(data.aws_route_tables.primary.ids)
  provider                  = aws.primary
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.secondary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}

resource "aws_route" "secondary_to_primary_routes" {
  for_each                  = toset(data.aws_route_tables.secondary.ids)
  provider                  = aws.secondary
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.primary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}
