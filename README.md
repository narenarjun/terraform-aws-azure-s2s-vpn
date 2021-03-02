# Creating Site to Site VPN Multi-Cloud with Terraform

# Sign in to Azure CLI

This is to authenticate and let terraform cli to create resources in the azure.

```
az login
```

## AWS credentials

Since aws credentials are sensitive info, they are not added in the `provider.tf` file,
they are set and exported in the environment variable in bash.

```bash
export AWS_ACCESS_KEY_ID=<value>
export AWS_SECRET_ACCESS_KEY=<value>
```

# Run Terraform init

```
terraform init
```

# Run Terraform apply

```
terraform apply
```
