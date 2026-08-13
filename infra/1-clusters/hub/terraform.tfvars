cluster_name         = "hub-cluster"
aws_region           = "us-west-2"
vpc_name             = "hub"
vpc_cidr             = "10.1.0.0/20"
account_role_prefix  = "rosa-account"
operator_role_prefix = "rosa-hub-operator"

# Optional: Override OpenShift version if needed
openshift_version = "4.22.8"
