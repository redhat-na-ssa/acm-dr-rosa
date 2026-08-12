1. Download utilties

* awscli
* rosa
* terraform
  
2. Configure ROSA in AWS account and OCM account

3. Link OCM Role (this is [required](https://access.redhat.com/articles/7137057))

```bash
rosa create ocm-role --no-console -y
```

4. Set ROSA OCM token

```bash
export AWS_PROFILE=rosa
export TF_VAR_rhcs_token=
```

5. Account Roles 

```bash
terraform -chdir=0-account-roles init
terraform -chdir=0-account-roles plan -out=account-roles.tfplan
terraform -chdir=0-account-roles apply account-roles.tfplan
```

6. Hub

```bash
terraform -chdir=1-clusters/hub init
terraform -chdir=1-clusters/hub plan -out=hub-cluster.tfplan
terraform -chdir=1-clusters/hub apply hub-cluster.tfplan
```

7. Primary

```bash
terraform -chdir=1-clusters/primary init
terraform -chdir=1-clusters/primary plan -out=primary-cluster.tfplan
terraform -chdir=1-clusters/primary apply primary-cluster.tfplan
```

8. Secondary

```bash
terraform -chdir=1-clusters/secondary init
terraform -chdir=1-clusters/secondary plan -out=secondary-cluster.tfplan
terraform -chdir=1-clusters/secondary apply secondary-cluster.tfplan
```

9. Peering

```bash
terraform -chdir=2-peering init
terraform -chdir=2-peering plan -out=vpc-peering.tfplan
terraform -chdir=2-peering apply vpc-peering.tfplan
```

10. Bastion

