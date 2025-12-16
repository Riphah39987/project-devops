# Google Cloud Platform (GCP) Free Tier Setup Guide

## Overview
GCP offers $300 credit for 90 days and Always Free tier services. This guide covers account creation and infrastructure setup.

## Prerequisites
- Google account (Gmail or Google Workspace)
- Valid credit/debit card (for verification)
- Phone number for verification

## Step 1: Create GCP Account

1. Visit [Google Cloud Free Tier](https://cloud.google.com/free)
2. Click "Get started for free"
3. Sign in with Google account
4. Select country and agree to terms
5. Complete verification:
   - Account type (Individual/Business)
   - Payment method (card won't be charged during trial)
6. Click "Start my free trial"

## Step 2: Understand GCP Free Tier

### $300 Credit (90 Days)
- Valid for 90 days from signup
- Can be used for any GCP service
- No automatic charges after expiration

### Always Free Tier
- **Compute Engine**: 1 f1-micro instance/month (US regions)
- **Cloud Storage**: 5GB-months Standard storage
- **Cloud Functions**: 2M invocations/month
- **BigQuery**: 1TB queries/month, 10GB storage

## Step 3: Create a Project

```bash
# Using gcloud CLI (install first - see below)
gcloud projects create devops-multicloud-project --name="DevOps Multi-Cloud"

# Set as default project
gcloud config set project devops-multicloud-project

# Enable billing (required even for free tier)
# Do this via Console: Billing > Link a billing account
```

## Step 4: Install Google Cloud CLI

```bash
# Download and install gcloud CLI
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh

# Initialize gcloud
gcloud init

# Login
gcloud auth login

# Set project
gcloud config set project devops-multicloud-project

# Verify
gcloud config list
```

## Step 5: Enable Required APIs

```bash
# Enable Compute Engine API
gcloud services enable compute.googleapis.com

# Enable Kubernetes Engine API
gcloud services enable container.googleapis.com

# Enable Cloud SQL API
gcloud services enable sqladmin.googleapis.com

# Enable Cloud Storage API
gcloud services enable storage.googleapis.com

# List enabled APIs
gcloud services list --enabled
```

## Step 6: Set Up Authentication for Terraform

```bash
# Create service account for Terraform
gcloud iam service-accounts create terraform-sa \
    --description="Terraform Service Account" \
    --display-name="terraform-sa"

# Grant necessary roles
gcloud projects add-iam-policy-binding devops-multicloud-project \
    --member="serviceAccount:terraform-sa@devops-multicloud-project.iam.gserviceaccount.com" \
    --role="roles/editor"

# Create and download key
gcloud iam service-accounts keys create ~/gcp-terraform-key.json \
    --iam-account=terraform-sa@devops-multicloud-project.iam.gserviceaccount.com

# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/gcp-terraform-key.json"
```

## Step 7: Configure Default Region and Zone

```bash
# Set default region
gcloud config set compute/region us-central1

# Set default zone
gcloud config set compute/zone us-central1-a

# View available regions
gcloud compute regions list

# View available zones
gcloud compute zones list
```

## GCP Services in This Project

### Virtual Private Cloud (VPC)
```yaml
Free Tier: Included (no charge for VPC itself)
Our Setup: 1 VPC with auto-mode subnets
IP Range: Auto-assigned
```

### Google Kubernetes Engine (GKE)
```yaml
Cost: 
  - Control plane: $0.10/hour (~$73/month)
  - Worker nodes: Use $300 credit
Free Alternative: GKE Autopilot has free tier
Our Setup: 
  - 1 cluster
  - 2 e2-small nodes (uses credit)
```

### Cloud Storage
```yaml
Free Tier: 5GB Standard storage
Our Setup: 1 bucket in us-central1
Storage Class: Standard
```

### Cloud SQL
```yaml
Free Tier: Not available
Cost: ~$10-50/month depending on instance type
Our Setup: 
  - Postgres instance
  - db-f1-micro (shared CPU, 0.6GB RAM)
```

## Cost Management Setup

### 1. Set Up Budget Alerts

```bash
# Via Console (recommended):
# 1. Navigate to Billing > Budgets & alerts
# 2. Create budget
# 3. Set amount: $50
# 4. Set thresholds: 50%, 80%, 100%
# 5. Add email notifications
```

### 2. Enable Cost Table in BigQuery

```bash
# Export billing to BigQuery for analysis
# Console: Billing > Billing export > BigQuery export
```

## Cost-Saving Best Practices

1. **Stop GKE cluster when not in use**:
   ```bash
   gcloud container clusters resize devops-cluster --num-nodes=0 --zone=us-central1-a
   ```

2. **Delete cluster completely**:
   ```bash
   gcloud container clusters delete devops-cluster --zone=us-central1-a
   ```

3. **Use Preemptible VMs** (up to 80% cheaper):
   ```bash
   gcloud compute instances create my-instance --preemptible
   ```

4. **Set auto-deletion for resources**:
   ```bash
   # Use terraform lifecycle blocks
   ```

## Free Tier Service Limits

| Service | Free Tier Limit | Our Usage | Status |
|---------|----------------|-----------|--------|
| Compute | 1 f1-micro VM | Not used | ✓ |
| GKE Control | ❌ Not free | $73/month | ⚠️ Uses credit |
| GKE Nodes | ❌ Not free | 2 e2-small | ⚠️ Uses credit |
| Storage | 5GB | <1GB | ✓ Safe |
| Cloud SQL | ❌ Not free | db-f1-micro | ⚠️ Uses credit |
| Bandwidth | 1GB egress | Minimal | ✓ Safe |

## GKE Autopilot Alternative (Free Tier Friendly)

```bash
# Create GKE Autopilot cluster (more cost-effective)
gcloud container clusters create-auto devops-autopilot-cluster \
    --region=us-central1

# Autopilot charges only for pods running
# First cluster autopilot has credits
```

## Important Notes

> [!WARNING]
> - GKE standard clusters incur charges even when idle
> - Always delete clusters after testing to avoid costs
> - Your $300 credit expires after 90 days

> [!IMPORTANT]
> After free trial:
> - Must upgrade to paid account manually
> - No automatic charges without explicit upgrade
> - Free tier services continue to work

> [!TIP]
> Use GKE Autopilot instead of standard GKE for better cost control and free tier compatibility

## Verification Checklist

- [ ] GCP account created with $300 credit
- [ ] Project created and billing enabled
- [ ] gcloud CLI installed and configured
- [ ] Required APIs enabled
- [ ] Service account created with key downloaded
- [ ] Budget alerts configured
- [ ] Default region/zone set

## Common Commands Reference

```bash
# View current project
gcloud config get-value project

# List all projects
gcloud projects list

# View billing account
gcloud billing accounts list

# Check quota limits
gcloud compute project-info describe --project=devops-multicloud-project

# Monitor costs
gcloud billing budgets list --billing-account=YOUR_BILLING_ACCOUNT_ID
```

## Next Steps

1. Navigate to `terraform/gcp/` directory
2. Update `terraform.tfvars` with your project ID
3. Ensure `GOOGLE_APPLICATION_CREDENTIALS` is set
4. Initialize Terraform: `terraform init`
5. Review plan: `terraform plan`
6. Apply infrastructure: `terraform apply`

## Additional Resources

- [GCP Free Tier Details](https://cloud.google.com/free/docs/gcp-free-tier)
- [GCP Pricing Calculator](https://cloud.google.com/products/calculator)
- [GKE Pricing](https://cloud.google.com/kubernetes-engine/pricing)
- [GCP Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations)
