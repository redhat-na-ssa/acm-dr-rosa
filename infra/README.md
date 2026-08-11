1. Access AWS account
2. Configure ROSA in AWS account and OCM account
3. Download terraform and awscli
4. Set ROSA OCM token

```bash
export AWS_PROFILE=rosa
export TF_VAR_rhcs_token=
```

5. Account Roles 

6. Hub

```bash
terraform --chdir=1-clusters/hub init
terraform --chdir=1-clusters/hub plan -out=hub-cluster.tfplan
terraform --chdir=1-clusters/hub apply hub-cluster.tfplan
```

7. Primary

8. Secondary

9. Peering

10. Bastion

