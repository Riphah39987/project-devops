# Quick Reference Commands

## Local Development

### Run Application Locally
```bash
cd app/
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

### Run Tests
```bash
cd app/
source venv/bin/activate
pip install -r requirements-test.txt
pytest test_main.py -v --cov
```

### Docker Commands
```bash
# Build image
docker build -t devops-sample-app:latest app/

# Run container
docker run -p 8000:8000 devops-sample-app:latest

# Run with docker-compose
docker-compose up --build

# Stop and clean up
docker-compose down -v
```

## Terraform Commands

### AWS
```bash
cd terraform/aws/
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit your values

terraform init
terraform plan
terraform apply
terraform destroy  # When done
```

### Azure
```bash
az login
cd terraform/azure/
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

terraform init
terraform plan
terraform apply
```

### GCP
```bash
gcloud auth login
gcloud auth application-default login

cd terraform/gcp/
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Set your project_id

terraform init
terraform plan
terraform apply
```

## Kubernetes Commands

### Configure kubectl
```bash
# AWS EKS
aws eks update-kubeconfig --region us-east-1 --name devops-eks-cluster

# Azure AKS
az aks get-credentials --resource-group devops-multicloud-rg --name devops-aks-cluster

# GCP GKE
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a
```

### Deploy Application
```bash
# Update image in k8s/deployment.yaml first
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml

# Check status
kubectl get pods
kubectl get svc
kubectl logs -f deployment/devops-sample-app

# Get LoadBalancer IP
kubectl get svc devops-sample-app
```

## Ansible Commands

```bash
cd ansible/

# Update inventory/hosts with your IPs first

# Install Docker
ansible-playbook playbooks/install-docker.yml -i inventory/hosts

# Setup users
ansible-playbook playbooks/setup-users.yml -i inventory/hosts

# Configure Kubernetes
ansible-playbook playbooks/configure-k8s.yml -i inventory/hosts

# Dry run
ansible-playbook playbooks/install-docker.yml -i inventory/hosts --check
```

## CI/CD

### GitHub Actions
1. Copy workflow to your repo:
   ```bash
   cp ci-cd/github-actions/workflow.yml .github/workflows/ci-cd.yml
   ```

2. Set GitHub Secrets:
   - `SONAR_TOKEN`
   - `KUBE_CONFIG`
   - `APP_URL`

3. Push to trigger:
   ```bash
   git add .
   git commit -m "Add CI/CD"
   git push origin main
   ```

### Jenkins
1. Create new pipeline job in Jenkins
2. Point to `ci-cd/jenkins/Jenkinsfile`
3. Configure credentials:
   - `dockerhub-credentials`
   - `kubeconfig`
   - SonarQube token

## Useful One-Liners

```bash
# Quick start script
./quick-start.sh

# View project structure
tree -L 3 -I '__pycache__|*.pyc|venv|.terraform'

# Check Terraform formatting
terraform fmt -recursive -check

# Validate all Terraform
for d in terraform/*/; do (cd $d && terraform validate); done

# Test API endpoints
curl http://localhost:8000/health
curl http://localhost:8000/items

# Get Kubernetes cluster info
kubectl cluster-info
kubectl get all -A

# View Terraform outputs
terraform output -json | jq

# Clean up Docker
docker system prune -a --volumes
```

## Troubleshooting

### Terraform Issues
```bash
# Reset state lock
terraform force-unlock <LOCK_ID>

# Refresh state
terraform refresh

# Import existing resource
terraform import aws_instance.example i-abcd1234
```

### Docker Issues
```bash
# View logs
docker logs devops-app

# Execute into container
docker exec -it devops-app /bin/bash

# Check resource usage
docker stats
```

### Kubernetes Issues
```bash
# Describe pod
kubectl describe pod <pod-name>

# View events
kubectl get events --sort-by='.lastTimestamp'

# Port forward for debugging
kubectl port-forward svc/devops-sample-app 8000:80

# Restart deployment
kubectl rollout restart deployment/devops-sample-app
```

## Cost Management

```bash
# AWS cost estimate
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan | terraform-cost-estimation

# Azure cost estimate
az consumption usage list

# GCP cost estimate
gcloud billing accounts list
gcloud billing budgets list --billing-account=<ACCOUNT_ID>
```

## Security Scanning

```bash
# Trivy container scan
trivy image devops-sample-app:latest

# Terraform security scan
tfsec terraform/aws/

# Ansible security
ansible-lint playbooks/
```
