# Azure Free Tier Setup Guide

## Overview
Microsoft Azure offers $200 credit for 30 days and 12 months of free services. This guide covers account creation and service setup.

## Prerequisites
- Microsoft account (or create new one)
- Valid credit/debit card (for verification only)
- Phone number for verification

## Step 1: Create Azure Account

1. Visit [Azure Free Account](https://azure.microsoft.com/free/)
2. Click "Start free"
3. Sign in with Microsoft account or create new one
4. Complete identity verification:
   - Phone verification
   - Credit card verification (no charges for free services)
5. Agree to terms and conditions

## Step 2: Understand Azure Free Tier

### 12 Months Free Services
- **Virtual Machines**: 750 hours/month of B1S Linux VM
- **Storage**: 5GB LRS File or Blob storage
- **Database**: 250GB SQL Database
- **Bandwidth**: 15GB outbound data transfer

### Always Free Services
- App Service: 10 web/mobile apps
- Functions: 1 million requests/month
- Container Instances: Limited usage

### $200 Credit (30 Days)
- Use for any Azure service
- Includes AKS (Azure Kubernetes Service)
- Expires after 30 days

## Step 3: Install Azure CLI

```bash
# Install Azure CLI on Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Set default subscription (if multiple)
az account set --subscription "Your Subscription Name"

# Verify login
az account show
```

## Step 4: Create Service Principal for Terraform

```bash
# Create service principal with Contributor role
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Output will contain:
# - appId (client_id)
# - password (client_secret)
# - tenant (tenant_id)
# Save these for terraform.tfvars
```

## Step 5: Set Up Resource Group

```bash
# Create resource group
az group create --name devops-project-rg --location eastus

# List available locations
az account list-locations -o table
```

## Step 6: Install Terraform

```bash
# Same as AWS setup (if not already installed)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Step 7: Set Up Cost Management

1. Navigate to **Cost Management + Billing**
2. Create budget alert:
   - Budget name: "DevOps Project Budget"
   - Amount: $50
   - Alert threshold: 80%, 100%
3. Add email notifications

## Azure Services in This Project

### Virtual Network (VNet)
```yaml
Free Tier: Included
Our Setup: 1 VNet with 2 subnets
Address Space: 10.1.0.0/16
```

### Azure Kubernetes Service (AKS)
```yaml
Cost: Uses $200 credit
Control Plane: Free
Worker Nodes: B2s VM (uses credit/free tier hours)
Alternative: Use local minikube
```

### Blob Storage
```yaml
Free Tier: 5GB LRS
Our Setup: 1 storage account with blob container
```

### Azure SQL Database
```yaml
Free Tier: 250GB for 12 months
Our Setup: S0 tier (10 DTU)
```

## Authentication Methods

### Option 1: Service Principal (Recommended for Terraform)
```bash
# Set environment variables
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Option 2: Azure CLI Authentication
```bash
# Already logged in via 'az login'
# Terraform will use CLI credentials automatically
```

## Cost-Saving Best Practices

1. **Deallocate VMs when not in use**:
   ```bash
   az vm deallocate --resource-group devops-project-rg --name myVM
   ```

2. **Use auto-shutdown for dev VMs**:
   ```bash
   az vm auto-shutdown --resource-group devops-project-rg --name myVM --time 1900
   ```

3. **Delete resources after testing**:
   ```bash
   terraform destroy
   # or
   az group delete --name devops-project-rg --yes
   ```

## Free Tier Limitations

| Service | Free Tier Limit | Our Usage | Status |
|---------|----------------|-----------|--------|
| B1S VM | 750 hrs/month | 2 nodes = 1500 hrs | ⚠️ Uses credit |
| Storage | 5GB | <1GB | ✓ Safe |
| SQL DB | 250GB, 12 months | S0 tier | ✓ Safe |
| AKS | Free control plane | 1 cluster | ✓ Safe |
| Bandwidth | 15GB outbound | Minimal | ✓ Safe |

## Important Notes

> [!WARNING]
> Your $200 credit expires after 30 days. Plan resource usage accordingly.

> [!IMPORTANT]
> After 30 days or credit exhaustion:
> - Free services continue on pay-as-you-go
> - You must explicitly upgrade to pay-as-you-go
> - No automatic charges without upgrade

> [!TIP]
> Use Azure Cost Management to track spending in real-time

## Verification Checklist

- [ ] Azure account created
- [ ] Azure CLI installed and logged in
- [ ] Service principal created with credentials saved
- [ ] Budget alerts configured
- [ ] Resource group created
- [ ] Terraform installed

## Next Steps

1. Navigate to `terraform/azure/` directory
2. Update `terraform.tfvars` with your service principal credentials
3. Initialize Terraform: `terraform init`
4. Review plan: `terraform plan`
5. Apply infrastructure: `terraform apply`

## Additional Resources

- [Azure Free Account FAQ](https://azure.microsoft.com/free/free-account-faq/)
- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)
