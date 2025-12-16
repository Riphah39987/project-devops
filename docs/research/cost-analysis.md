# Multi-Cloud Cost Analysis
## AWS vs Azure vs GCP Infrastructure Comparison

**Author:** DevOps Engineering Team  
**Date:** December 2025  
**Document Type:** Cost Analysis Report

---

## Executive Summary

This report provides a detailed cost comparison of deploying identical infrastructure across three major cloud providers: Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP). We analyze costs for a standard DevOps infrastructure setup including networking, Kubernetes, storage, and database components.

**Key Findings:**
- **Monthly Cost Range**: $73 - $180 depending on provider and configuration
- **Most Expensive**: AWS ($145-180/month primarily due to EKS)
- **Most Affordable**: GCP ($110-140/month with committed use discounts)
- **Best Free Tier**: GCP ($300 credit for 90 days vs AWS  $0 or Azure $200 for 30 days)
- **Hidden Costs**: Data transfer and load balancers add 15-30% to base costs

### Cost Summary Table

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| **Networking** | $40-50 | $30-40 | $25-35 |
| **Kubernetes** | $73-90 | $40-60 | $35-55 |
| **Storage** | $1-5 | $1-5 | $1-5 |
| **Database** | $15-30 | $15-30 | $15-25 |
| **Data Transfer** | $5-15 | $5-10 | $5-10 |
| **TOTAL/month** | **$134-190** | **$91-145** | **$81-130** |

---

## 1. Infrastructure Specifications

### 1.1 Common Architecture

For fair comparison, we deploy identical infrastructure on each cloud:

```
┌─────────────────────────────────────────────────────┐
│                 Cloud Infrastructure                 │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌────────────────────────────────────────────┐   │
│  │  VPC/VNet (10.x.0.0/16)                    │   │
│  │  ├── Public Subnet (10.x.1.0/24)           │   │
│  │  └── Private Subnet (10.x.2.0/24)          │   │
│  └────────────────────────────────────────────┘   │
│                                                      │
│  ┌────────────────────────────────────────────┐   │
│  │  Kubernetes Cluster                         │   │
│  │  ├── Control Plane (managed)                │   │
│  │  └── 2x Worker Nodes (e2-medium/B2s/t3.medium)│ │
│  └────────────────────────────────────────────┘   │
│                                                      │
│  ┌────────────────────────────────────────────┐   │
│  │  Object Storage                             │   │
│  │  └── 5GB standard storage                   │   │
│  └────────────────────────────────────────────┘   │
│                                                      │
│  ┌────────────────────────────────────────────┐   │
│  │  Relational Database                        │   │
│  │  └── Small instance (db.t3.micro/S0/db-f1-micro)││
│  │      └── 20GB storage                        │   │
│  └────────────────────────────────────────────┘   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 1.2 Specification Details

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| **VPC** | VPC with IGW, NAT Gateway | VNet with NAT Gateway | VPC with Cloud NAT |
| **K8s Control Plane** | EKS | AKS | GKE Standard |
| **K8s Worker Nodes** | 2x t3.medium | 2x Standard_B2s | 2x e2-medium |
| **Worker RAM** | 2x 4GB | 2x 4GB | 2x 4GB |
| **Worker vCPUs** | 2x 2 cores | 2x 2 cores | 2x 2 cores |
| **Storage Bucket** | S3 Standard | Blob Storage (LRS) | Cloud Storage Standard |
| **Database** | RDS PostgreSQL (db.t3.micro) | Azure SQL (S0) | Cloud SQL (db-f1-micro) |
| **DB Storage** | 20GB gp3 | 2GB included | 10GB SSD |

---

## 2. Detailed Cost Breakdown

### 2.1 AWS Cost Analysis

#### Networking Components

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| VPC | 1 VPC | $0.00 |
| Internet Gateway | 1 IGW | $0.00 |
| NAT Gateway | 1 NAT (single AZ) | $32.40 |
| NAT Gateway Data | 10GB processed | $0.45 |
| Elastic IP | 1 EIP (in use) | $0.00 |
| **Networking Subtotal** | | **$32.85** |

#### Kubernetes (EKS)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| EKS Control Plane | 1 cluster | $72.00 |
| EC2 Instances | 2x t3.medium (730 hrs) | $60.40 |
| EBS Volumes | 2x 20GB gp3 | $3.20 |
| Data Transfer (Intra-AZ) | 50GB | $0.00 |
| **EKS Subtotal** | | **$135.60** |

#### Storage (S3)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| S3 Standard Storage | 5GB | $0.12 |
| PUT Requests | 1,000 requests | $0.01 |
| GET Requests | 10,000 requests | $0.00 |
| **S3 Subtotal** | | **$0.13** |

#### Database (RDS)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| db.t3.micro Instance | PostgreSQL, 730 hrs | $12.41 |
| Storage (gp3) | 20GB | $2.30 |
| Backup Storage | 20GB | $0.95 |
| **RDS Subtotal** | | **$15.66** |

#### **AWS TOTAL: $184.24/month**

> [!IMPORTANT]
> EKS control plane ($72/month) significantly increases AWS costs. Consider alternatives:
> - Self-managed Kubernetes on EC2
> - AWS Fargate (pay-per-pod)
> - ECS as alternative container orchestration

---

### 2.2 Azure Cost Analysis

#### Networking Components

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Virtual Network | 1 VNet | $0.00 |
| NAT Gateway | 1 NAT | $32.85 |
| NAT Data Processed | 10GB | $0.45 |
| Public IP | 1 Static IP | $3.65 |
| **Networking Subtotal** | | **$36.95** |

#### Kubernetes (AKS)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| AKS Control Plane | 1 cluster | $0.00 |
| Virtual Machines | 2x Standard_B2s (730 hrs) | $60.74 |
| Managed Disks | 2x 30GB Standard SSD | $4.80 |
| Load Balancer | Standard LB | $18.25 |
| **AKS Subtotal** | | **$83.79** |

> [!TIP]
> AKS control plane is FREE, significantly reducing costs compared to AWS EKS

#### Storage (Blob)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Blob Storage (LRS) | 5GB | $0.10 |
| Write Operations | 10,000 operations | $0.10 |
| Read Operations | 100,000 operations | $0.00 |
| **Blob Storage Subtotal** | | **$0.20** |

#### Database (Azure SQL)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| SQL Database (S0) | 10 DTUs | $15.00 |
| Storage | Included in tier | $0.00 |
| Backup Storage | 2GB included | $0.00 |
| **SQL Database Subtotal** | | **$15.00** |

#### **AZURE TOTAL: $135.94/month**

---

### 2.3 GCP Cost Analysis

#### Networking Components

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| VPC | 1 VPC | $0.00 |
| Cloud NAT | 1 NAT gateway | $32.85 |
| NAT Data Processed | 10GB | $0.45 |
| External IP | 1 Static IP | $7.30 |
| **Networking Subtotal** | | **$40.60** |

#### Kubernetes (GKE)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| GKE Control Plane | 1 zonal cluster | $0.00 |
| Compute Instances | 2x e2-medium (730 hrs) | $49.20 |
| Persistent Disks | 2x 20GB Standard | $1.60 |
| Load Balancing | Network LB | $18.26 |
| **GKE Subtotal** | | **$69.06** |

> [!TIP]
> GKE Autopilot offers even lower costs ($0.00 control plane + pay-per-pod)

#### Storage (Cloud Storage)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| Standard Storage | 5GB | $0.10 |
| Class A Operations | 1,000 ops | $0.01 |
| Class B Operations | 10,000 ops | $0.00 |
| **Cloud Storage Subtotal** | | **$0.11** |

#### Database (Cloud SQL)

| Resource | Specification | Monthly Cost |
|----------|--------------|--------------|
| db-f1-micro Instance | PostgreSQL, 730 hrs | $7.67 |
| SSD Storage | 10GB | $1.70 |
| Backup Storage | 10GB | $0.80 |
| **Cloud SQL Subtotal** | | **$10.17** |

#### **GCP TOTAL: $119.94/month**

---

## 3. Cost Optimization Strategies

### 3.1 AWS Optimizations

#### Option 1: Replace EKS with Self-Managed K8s
- **Savings**: $72/month
- **New Total**: ~$112/month
- **Trade-off**: Increased management overhead

#### Option 2: Use Fargate Instead of EC2 for EKS
- **Cost**: Variable, ~$40-80/month for similar workload
- **Savings**: ~$30-50/month
- **Benefit**: No node management

#### Option 3: Reserved Instances (1-year)
- **Savings**: 30-40% on EC2/RDS
- **New Total**: ~$130/month with EKS, ~$80 without
- **Commitment**: 1-3 years

#### Option 4: Use RDS Free Tier
- **Savings**: $15/month for first 12 months
- **Limitation**: 750 hours/month db.t2.micro

### 3.2 Azure Optimizations

#### Option 1: Azure Reserved Instances (1-year)
- **Savings**: 40% on VMs
- **New Total**: ~$105/month
- **Commitment**: 1-3 years

#### Option 2: Use Azure Spot VMs for Worker Nodes
- **Savings**: Up to 90% on compute
- **New Total**: ~$60/month
- **Trade-off**: Nodes can be evicted

#### Option 3: Azure Hybrid Benefit
- **Savings**: Up to 40% with existing Windows licenses
- **Requirement**: Existing Microsoft licenses

### 3.3 GCP Optimizations

#### Option 1: Committed Use Discounts (1-year)
- **Savings**: 25-35% on compute
- **New Total**: ~$90/month
- **Commitment**: 1-3 years

#### Option 2: GKE Autopilot
- **Cost**: Pay-per-pod pricing
- **Estimate**: $40-70/month
- **Savings**: ~$20-30/month
- **Benefit**: Fully managed nodes

#### Option 3: Preemptible VMs
- **Savings**: Up to 80% on compute
- **New Total**: ~$65/month
- **Trade-off**: Nodes can be preempted

#### Option 4: GCP Free Tier
- **Credit**: $300 for 90 days
- **Coverage**: Covers entire infrastructure
- **Duration**: 90 days

---

## 4. Hidden Costs Analysis

### 4.1 Data Transfer Costs

| Scenario | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Intra-region (same AZ) | Free | Free | Free |
| Intra-region (cross-AZ) | $0.01/GB | $0.01/GB | Free |
| Internet egress (1TB) | $90 | $87 | $120 |
| Inter-region (100GB) | $2 | $2 | $1 |

> [!WARNING]
> Data transfer can significantly increase costs, especially for high-traffic applications

### 4.2 Support Plans

| Plan Level | AWS | Azure | GCP |
|------------|-----|-------|-----|
| Basic/Free | $0 | $0 | $0 |
| Developer | $29/mo | $29/mo | $29/mo |
| Business | $100/mo (min) | $100/mo | $150/mo |
| Enterprise | $15,000/mo | $1,000/mo | Custom |

### 4.3 Additional Services

| Service | AWS | Azure | GCP | Impact |
|---------|-----|-------|-----|--------|
| Monitoring | CloudWatch $10-30 | Azure Monitor $10-20 | Cloud Monitoring $10-20 | +10-30% |
| Log Management | $0.50/GB | $2.76/GB | $0.50/GB | Variable |
| Secrets Management | $0.40/secret | $0.031/10k ops | $0.06/10k ops | +$5-15/mo |
| Container Registry | $0.10/GB | $0.167/GB | $0.10/GB | +$1-5/mo |

---

## 5. Free Tier Comparison

### 5.1 AWS Free Tier

**Duration**: 12 months  
**Credit**: None (service-specific free tiers)

| Service | Free Tier Offering |
|---------|-------------------|
| EC2 | 750 hrs/mo t2.micro (12 months) |
| RDS | 750 hrs/mo db.t2.micro (12 months) |
| S3 | 5GB storage, 20k GET, 2k PUT |
| EKS | ❌ Not included ($72/month) |
| VPC | NAT Gateway ❌ Not free ($32/month) |

**Estimated Monthly Cost (Our Setup)**: $100-110/month (NAT + EKS not free)

### 5.2 Azure Free Tier

**Duration**: 12 months  
**Credit**: $200 for first 30 days

| Service | Free Tier Offering |
|---------|-------------------|
| Virtual Machines | 750 hrs/mo B1S (12 months) |
| Storage | 5GB LRS blob storage |
| SQL Database | 250GB SQL Database (12 months) |
| AKS | ✅ Control plane always free |
| Load Balancer | ❌ Not free (~$18/month) |

**Estimated Monthly Cost (Our Setup)**: $50-60/month after $200 credit

### 5.3 GCP Free Tier

**Duration**: 90 days  
**Credit**: $300 for new accounts

**Always Free Tier** (beyond 90 days):

| Service | Always Free Offering |
|---------|---------------------|
| Compute Engine | 1 f1-micro instance/month |
| Cloud Storage | 5GB-months regional storage |
| CloudSQL | ❌ Not included |
| GKE | ✅ One zonal cluster free |

**Estimated Monthly Cost (Our Setup)**:
- **First 90 days**: $0 (covered by $300 credit)
- **After 90 days**: $110-120/month

> [!TIP]
> GCP's $300 credit for 90 days is the most generous, covering the entire infrastructure for 2-3 months

---

## 6. Total Cost of Ownership (TCO)

### 6.1 Year 1 Costs (Including Free Tiers)

| Month | AWS | Azure | GCP |
|-------|-----|-------|-----|
| 1-3 | $180 | $0 ($200 credit) | $0 ($300 credit) |
| 4-12 | $180 | $60 | $120 |
| **Year 1 Total** | **$2,160** | **$540** | **$1,080** |

### 6.2 Year 2-3 Costs (No Free Tier)

| Provider | Monthly (On-Demand) | Monthly (Reserved) | Year 2-3 Total |
|----------|---------------------|-------------------|----------------|
| AWS | $180 | $120 | $2,880 (reserved) |
| Azure | $135 | $85 | $2,040 (reserved) |
| GCP | $120 | $80 | $1,920 (committed) |

### 6.3 3-Year TCO Summary

| Provider | Year 1 | Year 2-3 | 3-Year Total |
|----------|--------|----------|--------------|
| **AWS** | $2,160 | $2,880 | **$5,040** |
| **Azure** | $540 | $2,040 | **$2,580** |
| **GCP** | $1,080 | $1,920 | **$3,000** |

**Winner (3-year TCO)**: **Azure** ($2,580)  
**Runner-up**: **GCP** ($3,000)

---

## 7. Price-Performance Analysis

### 7.1 Cost per vCPU-Hour

| Provider | Worker Node Type | vCPUs | Cost/Month | Cost per vCPU-Hour |
|----------|-----------------|-------|------------|-------------------|
| AWS | t3.medium | 2 | $30.20 | $0.021 |
| Azure | Standard_B2s | 2 | $30.37 | $0.021 |
| GCP | e2-medium | 2 | $24.60 | $0.017 |

**Winner**: **GCP** (19% cheaper per vCPU)

### 7.2 Cost per GB Storage (Object Storage)

| Provider | Storage Type | Cost per GB/Month |
|----------|-------------|-------------------|
| AWS | S3 Standard | $0.023 |
| Azure | Blob LRS | $0.020 |
| GCP | Cloud Storage | $0.020 |

**Winner**: **Tie (Azure/GCP)** (13% cheaper than AWS)

### 7.3 Kubernetes Cost Efficiency

| Provider | Control Plane | 2x Workers | Total K8s Cost | Cost Efficiency |
|----------|--------------|-----------|----------------|----------------|
| AWS | $72 | $63.60 | $135.60 | Least efficient |
| Azure | $0 | $65.54 | $65.54 | Most efficient |
| GCP | $0 | $50.80 | $50.80 | Most efficient |

**Winner**: **GCP** (62% cheaper than AWS)

---

## 8. Recommendations

### 8.1 By Use Case

#### For Development/Testing
**Recommendation**: **GCP**
- Best free tier ($300 credit)
- Covers entire infrastructure for 2-3 months
- **Estimated Cost**: $0 for 3 months, then $80-120/month

#### For Production with Multi-Cloud Strategy
**Recommendation**: **GCP or Azure**
- Lower baseline costs
- Free Kubernetes control plane
- **Estimated Cost**: $85-135/month

#### For AWS-Committed Organizations
**Recommendation**: **Optimize AWS setup**
- Use self-managed K8s or Fargate
- Leverage Reserved Instances
- **Optimized Cost**: $80-120/month

#### For Cost-Sensitive Startups
**Recommendation**: **Azure**
- Best 3-year TCO
- Free AKS control plane
- Good $200 initial credit
- **Estimated Cost**: $0 first month, $85-135 thereafter

### 8.2 By Cloud Provider Preference

| If you prefer... | Choose | Why |
|-----------------|--------|-----|
| AWS | AWS (optimized) | Use self-hosted K8s, Reserved Instances |
| Azure | Azure | Free AKS, good TCO |
| GCP | GCP | Best free tier, low ongoing costs |
| Multi-cloud | Terraform | Consistent tooling across clouds |

### 8.3 Cost Optimization Priority List

1. **Eliminate unnecessary resources** (do you really need NAT Gateway?)
2. **Use managed Kubernetes with free control plane** (AKS, GKE)
3. **Right-size instances** (start small, scale up)
4. **Leverage free tiers maximally**
5. **Commit to Reserved/Committed pricing** (1-year minimum)
6. **Monitor and optimize data transfer**
7. **Use auto-scaling** (pay only for what you use)
8. **Consider Spot/Preemptible instances** for stateless workloads

---

## 9. Conclusion

### Key Findings

1. **GCP offers best value** for standard setups ($120/month)
2. **AWS is most expensive** primarily due to EKS ($180/month)
3. **Azure provides best long-term TCO** ($2,580 over 3 years)
4. **Free tiers vary significantly**:
   - GCP: Best ($300 for 90 days)
   - Azure: Good ($200 for 30 days)
   - AWS: Limited (service-specific, no credit)

5. **Hidden costs** (data transfer, monitoring) add 15-30%
6. **Optimization** can reduce costs by 30-50%
7. **Kubernetes costs** vary dramatically:
   - AWS EKS: $72/month control plane
   - Azure AKS: $0 control plane
   - GCP GKE: $0 control plane

### Final Recommendation

For the specified infrastructure:

**Best Overall Value**: **Google Cloud Platform (GCP)**
- Monthly cost: $120 (on-demand), $80 (committed)
- Free tier: $300 credit covers 2-3 months
- Kubernetes: Free GKE control plane
- Price-performance: Best compute value

**Best for Long-Term (3+ years)**: **Microsoft Azure**
- 3-year TCO: $2,580
- Free AKS control plane
- Good integration for Microsoft-centric orgs

**For AWS-Committed Organizations**: **Optimize AWS**
- Use self-managed K8s or Fargate
- Reserved Instances (1-3 years)
- Optimized cost: ~$100/month

---

## Appendix A: Pricing Sources

- AWS Pricing: https://aws.amazon.com/pricing/
- Azure Pricing Calculator: https://azure.microsoft.com/pricing/calculator/
- GCP Pricing Calculator: https://cloud.google.com/products/calculator
- Pricing accurate as of: December 2025
- Region used: US East (us-east-1, eastus, us-central1)

---

**Document Version**: 1.0  
**Last Updated**: December 2025  
**Next Review**: March 2026
