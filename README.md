# DevOps Multi-Cloud Project
## Complete Infrastructure as Code & CI/CD Implementation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple.svg)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://www.ansible.com/)

A comprehensive DevOps project demonstrating multi-cloud infrastructure provisioning and CI/CD pipeline implementation across AWS, Azure, and GCP.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Phase 1: Infrastructure Setup](#phase-1-infrastructure-setup)
- [Phase 2: CI/CD Implementation](#phase-2-cicd-implementation)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This project provides production-ready Infrastructure as Code (IaC) and CI/CD configurations for deploying applications across multiple cloud providers. It includes:

### Phase 1 - Infrastructure & IaC
- ✅ Multi-cloud Terraform configurations (AWS, Azure, GCP)
- ✅ Complete VPC/VNet networking setup
- ✅ Managed Kubernetes clusters (EKS, AKS, GKE)
- ✅ Object storage (S3, Blob, Cloud Storage)
- ✅ Managed databases (RDS, Azure SQL, Cloud SQL)
- ✅ Ansible playbooks for configuration management
- ✅ Comprehensive research papers and cost analysis

### Phase 2 - CI/CD Pipelines
- ✅ Jenkins and GitHub Actions workflows
- ✅ Code quality checks (SonarQube)
- ✅ Automated testing (pytest)
- ✅ Container security scanning (Trivy)
- ✅ Docker image build and push
- ✅ Kubernetes deployment automation
- ✅ Sample FastAPI application

---

## 📁 Project Structure

```
devops-multicloud-project/
├── terraform/                    # Infrastructure as Code
│   ├── aws/                     # AWS resources
│   │   ├── provider.tf          # AWS provider configuration
│   │   ├── variables.tf         # Input variables
│   │   ├── vpc.tf               # VPC and networking
│   │   ├── eks.tf               # EKS cluster
│   │   ├── s3.tf                # S3 buckets
│   │   ├── rds.tf               # RDS database
│   │   ├── outputs.tf           # Output values
│   │   └── terraform.tfvars.example
│   ├── azure/                   # Azure resources
│   │   ├── provider.tf          # Azure provider configuration
│   │   ├── variables.tf         # Input variables
│   │   ├── vnet.tf              # Virtual Network
│   │   ├── aks.tf               # AKS cluster
│   │   ├── storage.tf           # Blob storage
│   │   ├── sql.tf               # Azure SQL
│   │   ├── outputs.tf           # Output values
│   │   └── terraform.tfvars.example
│   └── gcp/                     # GCP resources
│       ├── provider.tf          # GCP provider configuration
│       ├── variables.tf         # Input variables
│       ├── vpc.tf               # VPC and networking
│       ├── gke.tf               # GKE cluster
│       ├── storage.tf           # Cloud Storage
│       ├── cloudsql.tf          # Cloud SQL
│       ├── outputs.tf           # Output values
│       └── terraform.tfvars.example
│
├── ansible/                     # Configuration Management
│   ├── inventory/
│   │   └── hosts                # Ansible inventory
│   └── playbooks/
│       ├── install-docker.yml   # Docker installation
│       ├── setup-users.yml      # User management
│       └── configure-k8s.yml    # Kubernetes setup
│
├── ci-cd/                       # CI/CD Pipeline Configurations
│   ├── jenkins/
│   │   └── Jenkinsfile          # Jenkins pipeline
│   └── github-actions/
│       └── workflow.yml         # GitHub Actions workflow
│
├── app/                         # Sample Application
│   ├── main.py                  # FastAPI application
│   ├── test_main.py             # Unit tests
│   ├── requirements.txt         # Python dependencies
│   ├── requirements-test.txt    # Test dependencies
│   └── Dockerfile               # Container image
│
└── docs/                        # Documentation
    ├── guides/                  # Setup guides
    │   ├── aws-free-tier-setup.md
    │   ├── azure-free-tier-setup.md
    │   └── gcp-free-tier-setup.md
    └── research/                # Research papers
        ├── iac-comparison.md
        ├── cost-analysis.md
        ├── artifact-management-strategy.md
        ├── cicd-tools-comparison.md
        └── performance-metrics-report.md
```

---

## 🛠️ Prerequisites

### Required Tools

| Tool | Version | Installation |
|------|---------|-------------|
| Terraform | ≥ 1.0 | [Download](https://www.terraform.io/downloads) |
| Ansible | ≥ 2.9 | `pip install ansible` |
| Docker | ≥ 20.10 | [Download](https://docs.docker.com/get-docker/) |
| kubectl | ≥ 1.28 | [Download](https://kubernetes.io/docs/tasks/tools/) |
| AWS CLI | ≥ 2.0 | [Download](https://aws.amazon.com/cli/) |
| Azure CLI | ≥ 2.0 | [Download](https://docs.microsoft.com/cli/azure/install-azure-cli) |
| Google Cloud CLI | Latest | [Download](https://cloud.google.com/sdk/docs/install) |

### Cloud Provider Accounts

You'll need accounts on at least one of these platforms:
- [AWS Free Tier](https://aws.amazon.com/free/)
- [Azure Free Account](https://azure.microsoft.com/free/)
- [Google Cloud Free Trial](https://cloud.google.com/free/)

See the [setup guides](docs/guides/) for detailed account creation instructions.

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd devops-multicloud-project
```

### 2. Choose Your Cloud Provider

Select one or more cloud providers to deploy infrastructure:

#### **Option A: AWS**

```bash
cd terraform/aws

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables with your values
nano terraform.tfvars

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply infrastructure
terraform apply
```

#### **Option B: Azure**

```bash
cd terraform/azure

# Login to Azure
az login

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables
nano terraform.tfvars

# Initialize and apply
terraform init
terraform plan
terraform apply
```

#### **Option C: Google Cloud**

```bash
cd terraform/gcp

# Authenticate with GCP
gcloud auth login
gcloud auth application-default login

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables (set your project_id!)
nano terraform.tfvars

# Initialize and apply
terraform init
terraform plan
terraform apply
```

### 3. Configure Kubernetes Access

After infrastructure is created, configure kubectl:

**AWS:**
```bash
aws eks update-kubeconfig --region us-east-1 --name devops-eks-cluster
```

**Azure:**
```bash
az aks get-credentials --resource-group devops-multicloud-rg --name devops-aks-cluster
```

**GCP:**
```bash
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a
```

### 4. Verify Deployment

```bash
# Check nodes
kubectl get nodes

# Check namespaces
kubectl get namespaces

# Check all resources
kubectl get all --all-namespaces
```

---

## 📦 Phase 1: Infrastructure Setup

### Multi-Cloud Setup Guides

Detailed guides for creating cloud accounts and setting up credentials:

- [AWS Free Tier Setup](docs/guides/aws-free-tier-setup.md)
- [Azure Free Tier Setup](docs/guides/azure-free-tier-setup.md)
- [GCP Free Tier Setup](docs/guides/gcp-free-tier-setup.md)

### Terraform Infrastructure

Each cloud provider includes:

#### **Network Infrastructure**
- VPC/VNet with public and private subnets
- NAT gateways for outbound internet access
- Security groups and network ACLs
- Route tables and internet gateways

#### **Kubernetes Cluster**
- Managed Kubernetes (EKS/AKS/GKE)
- Auto-scaling node groups
- RBAC configuration
- Network policies

#### **Storage**
- Object storage buckets
- Versioning and lifecycle policies
- Encryption at rest
- Access controls

#### **Database**
- Managed PostgreSQL/SQL instances
- Automated backups
- High availability options
- Security group rules

### Ansible Configuration

Run Ansible playbooks to configure your infrastructure:

```bash
cd ansible/

# Update inventory with your server IPs
nano inventory/hosts

# Install Docker on all hosts
ansible-playbook playbooks/install-docker.yml -i inventory/hosts

# Setup users and SSH access
ansible-playbook playbooks/setup-users.yml -i inventory/hosts

# Configure Kubernetes (if using self-managed K8s)
ansible-playbook playbooks/configure-k8s.yml -i inventory/hosts
```

---

## 🔄 Phase 2: CI/CD Implementation

### Sample Application

A production-ready FastAPI REST API is included:

```bash
cd app/

# Install dependencies
pip install -r requirements.txt

# Run locally
python main.py

# Run tests
pip install -r requirements-test.txt
pytest test_main.py -v

# Build Docker image
docker build -t devops-sample-app:latest .

# Run container
docker run -p 8000:8000 devops-sample-app:latest
```

**Access the API**: http://localhost:8000  
**Interactive Docs**: http://localhost:8000/docs

### Jenkins Pipeline

Setup Jenkins and run the CI/CD pipeline:

```bash
# Deploy Jenkins to Kubernetes
kubectl apply -f k8s/jenkins-deployment.yaml

# Access Jenkins (get LoadBalancer IP)
kubectl get service jenkins -n jenkins

# Create new pipeline job
# - Point to ci-cd/jenkins/Jenkinsfile
# - Configure credentials:
#   - dockerhub-credentials
#   - kubeconfig
#   - sonarqube token
```

**Pipeline Stages:**
1. Code checkout
2. SonarQube code quality scan
3. Run automated tests
4. Build Docker image
5. Security scan with Trivy
6. Push to Docker registry
7. Deploy to Kubernetes
8. Smoke tests

### GitHub Actions Workflow

For GitHub-hosted projects:

```bash
# Copy workflow to your repo
cp ci-cd/github-actions/workflow.yml .github/workflows/ci-cd.yml

# Configure GitHub Secrets:
# Settings → Secrets → Actions → New repository secret
# Required secrets:
# - SONAR_TOKEN
# - SONAR_HOST_URL
# - KUBE_CONFIG (base64 encoded)
# - APP_URL

# Push to GitHub
git add .github/workflows/ci-cd.yml
git commit -m "Add CI/CD workflow"
git push origin main
```

Workflow triggers automatically on:
- Push to `main` or `develop`
- Pull requests to `main`
- Manual trigger via `workflow_dispatch`

---

## 📚 Documentation

### Research Papers

Comprehensive analysis and comparisons:

1. **[IaC Comparison: Terraform vs CloudFormation vs ARM](docs/research/iac-comparison.md)**
   - Feature comparison
   - Use case analysis
   - Decision matrix

2. **[Multi-Cloud Cost Analysis](docs/research/cost-analysis.md)**
   - AWS vs Azure vs GCP pricing
   - TCO calculations
   - Optimization strategies

3. **[Artifact Management Strategy](docs/research/artifact-management-strategy.md)**
   - Registry management
   - Versioning policies
   - Security best practices

4. **[CI/CD Tools Comparison](docs/research/cicd-tools-comparison.md)**
   - Jenkins vs GitHub Actions vs GitLab CI
   - Performance benchmarks
   - Cost analysis

5. **[Pipeline Performance Metrics](docs/research/performance-metrics-report.md)**
   - Build time analysis
   - Resource utilization
   - Optimization recommendations

---

## 🔧 Common Tasks

### Destroy Infrastructure

**⚠️ Warning**: This will delete all resources. Make sure you have backups!

```bash
# AWS
cd terraform/aws
terraform destroy

# Azure
cd terraform/azure
terraform destroy

# GCP
cd terraform/gcp
terraform destroy
```

### Update Infrastructure

```bash
# Make changes to .tf files
nano vpc.tf

# Review changes
terraform plan

# Apply changes
terraform apply
```

### View Terraform Outputs

```bash
# Show all outputs
terraform output

# Show specific output
terraform output eks_cluster_endpoint
```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
terraform plan

# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt -recursive

# Ansible dry run
ansible-playbook playbook.yml --check

# kubectl debugging
kubectl logs <pod-name>
kubectl describe pod <pod-name>
kubectl get events --sort-by='.lastTimestamp'
```

---

## 💰 Cost Considerations

### Free Tier Usage

| Provider | Free Tier | Our Usage | Covered? |
|----------|-----------|-----------|----------|
| AWS | 750 hrs EC2 | ~1500 hrs | ⚠️ Partial |
| Azure | $200 credit (30d) | ~$60/mo | ✅ Month 1 only |
| GCP | $300 credit (90d) | ~$120/mo | ✅ First 2-3 months |

### Estimated Monthly Costs

After free tier exhaustion:

- **AWS**: $134-190/month
- **Azure**: $91-145/month
- **GCP**: $81-130/month

**Recommendation**: Use GCP for best value or leverage free tier, then destroy resources.

See [Cost Analysis](docs/research/cost-analysis.md) for detailed breakdown.

---

## 🎓 Learning Path

### Beginner (Week 1-2)
1. Read cloud provider setup guides
2. Deploy basic infrastructure (VPC + S3)
3. Understand Terraform basics
4. Run sample application locally

### Intermediate (Week 3-4)
1. Deploy full stack (Kubernetes + database)
2. Configure Ansible playbooks
3. Set up CI/CD pipeline
4. Deploy application to Kubernetes

### Advanced (Week 5+)
1. Implement multi-cloud strategy
2. Set up monitoring and alerting
3. Implement security scanning
4. Optimize for cost and performance
5. Contribute improvements

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- HashiCorp for Terraform
- Red Hat for Ansible
- Cloud providers (AWS, Azure, GCP)
- Open-source community

---

## 📧 Support

For questions or issues:
- Open an issue on GitHub
- Refer to documentation in `docs/`
- Check provider documentation

---

## 🗺️ Roadmap

- [ ] Add Kubernetes manifests and Helm charts
- [ ] Implement GitOps with ArgoCD
- [ ] Add monitoring stack (Prometheus/Grafana)
- [ ] Implement service mesh (Istio)
- [ ] Add disaster recovery procedures
- [ ] Expand to more cloud providers
- [ ] Add cost optimization automation

---

**Made with ❤️ for the DevOps community**

**Last Updated**: December 2025  
**Version**: 1.0.0
