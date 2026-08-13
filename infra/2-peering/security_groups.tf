# ==============================================================================
# HUB CLUSTER INGRESS RULES
# ==============================================================================

# 1. Hub Control Plane: Allow Managed Clusters + Bastion to hit API 443 (ROSA HCP PrivateLink)
resource "aws_vpc_security_group_ingress_rule" "hub_cp_api_access" {
  for_each          = toset([data.aws_vpc.primary.cidr_block, data.aws_vpc.secondary.cidr_block])
  provider          = aws.hub
  security_group_id = data.aws_security_group.hub_control_plane_sg.id

  cidr_ipv4   = each.value
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow API 443 access from Primary/Secondary VPC CIDRs for Managed Clusters and Bastion"
}

# 2. Hub Compute Nodes: Allow Ingress Router 443 (for Managed Clusters & Bastion Web Console)
# TODO - Verify if Managed Clusters need OCP router access
resource "aws_vpc_security_group_ingress_rule" "hub_compute_ingress_443" {
  for_each          = toset([data.aws_vpc.primary.cidr_block, data.aws_vpc.secondary.cidr_block])
  provider          = aws.hub
  security_group_id = data.aws_security_group.hub_compute_sg.id

  cidr_ipv4   = each.value
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow 443 Web Console and Managed Clusters traffic from Primary/Secondary VPCs"
}

# ==============================================================================
# PRIMARY CLUSTER INGRESS RULES
# ==============================================================================

# 1. Primary Control Plane: Allow Hub Cluster + Bastion Host to hit API 443 (ROSA HCP PrivateLink)
# Primary CIDR block can be replaced with Bastion {SG,Subnet,Host IP} if desired
resource "aws_vpc_security_group_ingress_rule" "primary_cp_api_access" {
  for_each          = toset([data.aws_vpc.hub.cidr_block, data.aws_vpc.primary.cidr_block])
  provider          = aws.primary
  security_group_id = data.aws_security_group.primary_control_plane_sg.id

  cidr_ipv4   = each.value
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow API 443 access from Hub VPC and local bastion"
}

# 2. Primary Compute Nodes: Allow Bastion Web Console Access (443)
# Primary CIDR block can be replaced with Bastion {SG,Subnet,Host IP} if desired
resource "aws_vpc_security_group_ingress_rule" "primary_compute_ingress_443" {
  provider          = aws.primary
  security_group_id = data.aws_security_group.primary_compute_sg.id

  cidr_ipv4   = data.aws_vpc.primary.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow 443 Web Console access from local bastion"
}

# 3. Primary Compute Nodes: SUBMARINER MESH ONLY (Strictly Primary <---> Secondary)
# AWS does not allow cross region SG referencing in VPC peering
resource "aws_vpc_security_group_ingress_rule" "primary_compute_submariner_mesh" {
  provider          = aws.primary
  security_group_id = data.aws_security_group.primary_compute_sg.id

  cidr_ipv4   = data.aws_vpc.secondary.cidr_block
  ip_protocol = "-1"
  description = "Submariner data plane and application mesh strictly from Secondary VPC"
}

# ==============================================================================
# SECONDARY CLUSTER INGRESS RULES
# ==============================================================================

# 1. Secondary Control Plane: Allow Hub Cluster + Primary Bastion to hit API 443 (ROSA HCP PrivateLink)
# Primary CIDR block can be replaced with Bastion Subnet or Bastion Host IP if desired
resource "aws_vpc_security_group_ingress_rule" "secondary_cp_api_access" {
  for_each          = toset([data.aws_vpc.hub.cidr_block, data.aws_vpc.primary.cidr_block])
  provider          = aws.secondary
  security_group_id = data.aws_security_group.secondary_control_plane_sg.id

  cidr_ipv4   = each.value
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow API 443 access from Hub VPC and Bastion Host (Primary VPC)"
}

# 2. Secondary Compute Nodes: Allow Primary Bastion Web Console Access (443)
# Primary CIDR block can be replaced with Bastion Subnet or Bastion Host IP if desired
resource "aws_vpc_security_group_ingress_rule" "secondary_compute_ingress_443" {
  provider          = aws.secondary
  security_group_id = data.aws_security_group.secondary_compute_sg.id

  cidr_ipv4   = data.aws_vpc.primary.cidr_block
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow 443 Web Console access from Primary VPC (Bastion)"
}

# 3. Secondary Compute Nodes: SUBMARINER MESH ONLY (Strictly Secondary <---> Primary)
# AWS does not allow cross region SG referencing in VPC peering
resource "aws_vpc_security_group_ingress_rule" "secondary_compute_submariner_mesh" {
  provider          = aws.secondary
  security_group_id = data.aws_security_group.secondary_compute_sg.id

  cidr_ipv4   = data.aws_vpc.primary.cidr_block
  ip_protocol = "-1"
  description = "Submariner data plane and application mesh strictly from Primary VPC"
}
