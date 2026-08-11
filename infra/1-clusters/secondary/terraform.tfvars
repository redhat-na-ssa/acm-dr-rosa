cluster_name         = "secondary-cluster"
aws_region           = "us-east-2"
vpc_name             = "secondary"
vpc_cidr             = "192.168.0.0/20"
pod_cidr             = "10.130.0.0/18"
service_cidr         = "172.30.128.0/18"
account_role_prefix  = "rosa-account"
operator_role_prefix = "rosa-secondary-operator"

# Optional: Override OpenShift version if needed
openshift_version    = "4.22.8"
