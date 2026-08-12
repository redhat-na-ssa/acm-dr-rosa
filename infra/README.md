1. Download utilties

* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [rosa](https://docs.redhat.com/en/documentation/red_hat_openshift_service_on_aws/4/html/cli_tools/rosa-cli#rosa-setting-up-cli_rosa-getting-started-cli)
* [terraform](https://developer.hashicorp.com/terraform/install)
  
2. Configure AWS and ROSA

[Enable ROSA Service in AWS Console](https://docs.aws.amazon.com/rosa/latest/userguide/set-up.html#enable-rosa)

[Get a OCM offline token](https://console.redhat.com/openshift/token/rosa)

> Note: OCM tokens are being deprecrated but needed by the Terraform modules currently

Configure AWS profile

```sh
aws configure --profile rosa
```

Login to ROSA

```sh
rosa login --token=
```

Verify

```sh
rosa whoami
```

3. Link OCM Role (this is [required](https://access.redhat.com/articles/7137057))

```sh
rosa create ocm-role --no-console -y
```

4. Set env vars (note: `rhcs_token` is your OCM offline token)

```sh
export AWS_PROFILE=rosa
export TF_VAR_rhcs_token=
```

5. Account Roles 

```sh
terraform -chdir=0-account-roles init
terraform -chdir=0-account-roles plan -out=account-roles.tfplan
terraform -chdir=0-account-roles apply account-roles.tfplan
```

6. Hub

```sh
terraform -chdir=1-clusters/hub init
terraform -chdir=1-clusters/hub plan -out=hub-cluster.tfplan
terraform -chdir=1-clusters/hub apply hub-cluster.tfplan
```

7. Primary

```sh
terraform -chdir=1-clusters/primary init
terraform -chdir=1-clusters/primary plan -out=primary-cluster.tfplan
terraform -chdir=1-clusters/primary apply primary-cluster.tfplan
```

8. Secondary

```sh
terraform -chdir=1-clusters/secondary init
terraform -chdir=1-clusters/secondary plan -out=secondary-cluster.tfplan
terraform -chdir=1-clusters/secondary apply secondary-cluster.tfplan
```

9. Peering

```sh
terraform -chdir=2-peering init
terraform -chdir=2-peering plan -out=vpc-peering.tfplan
terraform -chdir=2-peering apply vpc-peering.tfplan
```

10. Bastion

> TODO

11. Test

```sh
export HUB_API_URL=$(terraform -chdir=1-clusters/hub output -raw api_url)
export HUB_CONSOLE_URL=$(terraform -chdir=1-clusters/hub output -raw console_url)
export HUB_ADMIN_USERNAME=$(terraform -chdir=1-clusters/hub output -raw cluster_admin_username)
export HUB_ADMIN_PASSWORD=$(terraform -chdir=1-clusters/hub output -raw cluster_admin_password)
```

```sh
export PRIMARY_API_URL=$(terraform -chdir=1-clusters/primary output -raw api_url)
export PRIMARY_CONSOLE_URL=$(terraform -chdir=1-clusters/primary output -raw console_url)
export PRIMARY_ADMIN_USERNAME=$(terraform -chdir=1-clusters/primary output -raw cluster_admin_username)
export PRIMARY_ADMIN_PASSWORD=$(terraform -chdir=1-clusters/primary output -raw cluster_admin_password)
```

```sh
export SECONDARY_API_URL=$(terraform -chdir=1-clusters/secondary output -raw api_url)
export SECONDARY_CONSOLE_URL=$(terraform -chdir=1-clusters/secondary output -raw console_url)
export SECONDARY_ADMIN_USERNAME=$(terraform -chdir=1-clusters/secondary output -raw cluster_admin_username)
export SECONDARY_ADMIN_PASSWORD=$(terraform -chdir=1-clusters/secondary output -raw cluster_admin_password)
```

