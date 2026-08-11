cluster_name         = "primary-cluster"
aws_region           = "us-east-1"
vpc_name             = "primary"
vpc_cidr             = "10.0.0.0/20"
pod_cidr             = "10.128.0.0/18"
service_cidr         = "172.30.0.0/18"
account_role_prefix  = "rosa-account"
operator_role_prefix = "rosa-primary-operator"

# Optional: Override OpenShift version if needed
openshift_version    = "4.22.8"
