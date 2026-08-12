# ==============================================================================
# HUB CLUSTER DATA LOOKUPS
# ==============================================================================
data "aws_vpc" "hub" {
  provider = aws.hub

  filter {
    name   = "tag:Name"
    values = ["rosa-vpc-${var.hub_region}"]
  }
}

data "aws_route_tables" "hub" {
  provider = aws.hub
  vpc_id   = data.aws_vpc.hub.id
}

data "aws_security_group" "hub_control_plane_sg" {
  provider = aws.hub
  filter {
    name   = "tag:Name"
    values = ["rosa-hub-control-plane-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }
}

data "aws_security_group" "hub_compute_sg" {
  provider = aws.hub
  filter {
    name   = "tag:Name"
    values = ["rosa-hub-compute-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }
}

# ==============================================================================
# PRIMARY CLUSTER DATA LOOKUPS
# ==============================================================================
data "aws_vpc" "primary" {
  provider = aws.primary

  filter {
    name   = "tag:Name"
    values = ["rosa-vpc-${var.primary_region}"]
  }
}

data "aws_route_tables" "primary" {
  provider = aws.primary
  vpc_id   = data.aws_vpc.primary.id
}

data "aws_security_group" "primary_control_plane_sg" {
  provider = aws.primary
  filter {
    name   = "tag:Name"
    values = ["rosa-primary-control-plane-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary.id]
  }
}

data "aws_security_group" "primary_compute_sg" {
  provider = aws.primary
  filter {
    name   = "tag:Name"
    values = ["rosa-primary-compute-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary.id]
  }
}

# ==============================================================================
# SECONDARY CLUSTER DATA LOOKUPS
# ==============================================================================
data "aws_vpc" "secondary" {
  provider = aws.secondary

  filter {
    name   = "tag:Name"
    values = ["rosa-vpc-${var.secondary_region}"]
  }
}

data "aws_route_tables" "secondary" {
  provider = aws.secondary
  vpc_id   = data.aws_vpc.secondary.id
}

data "aws_security_group" "secondary_control_plane_sg" {
  provider = aws.secondary
  filter {
    name   = "tag:Name"
    values = ["rosa-secondary-control-plane-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.secondary.id]
  }
}

data "aws_security_group" "secondary_compute_sg" {
  provider = aws.secondary
  filter {
    name   = "tag:Name"
    values = ["rosa-secondary-compute-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.secondary.id]
  }
}
