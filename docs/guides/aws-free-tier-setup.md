# AWS Free Tier Setup Guide

## Overview
This guide walks you through creating an AWS Free Tier account and setting up the necessary services for this DevOps project.

## Prerequisites
- Valid email address
- Credit/debit card (required for verification, won't be charged for free tier usage)
- Phone number for verification

## Step 1: Create AWS Account

1. Navigate to [AWS Free Tier](https://aws.amazon.com/free/)
2. Click "Create a Free Account"
3. Provide:
   - Email address
   - Account name
   - Root user password
4. Select "Personal" account type
5. Enter contact information and billing details
6. Complete phone verification
7. Choose "Basic Support - Free" plan

## Step 2: Enable Required Services

### IAM User Setup (Best Practice)
1. Navigate to IAM console
2. Create new IAM user with administrator access
3. Enable MFA (Multi-Factor Authentication) for security
4. Download access keys for programmatic access
5. Save credentials securely

### Enable Services Used in This Project

#### VPC (Virtual Private Cloud)
- Free tier: Default VPC included
- Our setup: 1 VPC with 2 subnets (public/private)

#### EKS (Elastic Kubernetes Service)
- **Cost Note**: EKS control plane costs $0.10/hour (~$73/month)
- **Alternative**: Use minikube locally or single EC2 instance
- Free tier includes 750 hours of t2.micro/t3.micro instances

#### S3 (Simple Storage Service)
- Free tier: 5GB storage
- 20,000 GET requests
- 2,000 PUT requests

#### RDS (Relational Database Service)
- Free tier: 750 hours of db.t2.micro, db.t3.micro, or db.t4g.micro
- 20GB of General Purpose (SSD) storage
- 20GB backup storage

## Step 3: Configure AWS CLI

```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure credentials
aws configure
# Enter:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Default output format (json)
```

## Step 4: Install Terraform

```bash
# Download and install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Step 5: Set Up Budget Alerts

1. Navigate to AWS Billing Dashboard
2. Create a budget alert for $5-10 threshold
3. Enter email for notifications
4. This prevents unexpected charges

## Free Tier Limitations to Watch

| Service | Free Tier Limit | Our Usage |
|---------|----------------|-----------|
| EC2 | 750 hrs/month t2.micro | 2 instances = ~1500 hrs ⚠️ |
| S3 | 5GB storage | <1GB ✓ |
| RDS | 750 hrs/month db.t2.micro | 750 hrs ✓ |
| EKS | ❌ Not free | $73/month ⚠️ |

## Cost-Saving Tips

1. **Stop resources when not in use**:
   ```bash
   # Stop EC2 instances
   aws ec2 stop-instances --instance-ids i-xxxxx
   
   # Stop RDS
   aws rds stop-db-instance --db-instance-identifier mydb
   ```

2. **Use CloudWatch alarms** to auto-stop resources
3. **Delete resources** after testing with:
   ```bash
   terraform destroy
   ```

## Important Notes

> [!WARNING]
> EKS is NOT included in free tier. Consider using:
> - Local minikube for development
> - Single EC2 instance with K3s
> - Cloud provider Kubernetes alternatives (GKE has free tier)

> [!IMPORTANT]
> Always run `terraform plan` before `terraform apply` to review costs

## Next Steps

After account setup:
1. Navigate to `terraform/aws/` directory
2. Update `terraform.tfvars` with your preferences
3. Run terraform initialization and apply
4. See main README.md for detailed instructions

## Resources

- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [AWS Pricing Calculator](https://calculator.aws/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
