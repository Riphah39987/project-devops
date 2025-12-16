# Complete Deployment Guide
## Docker → Kubernetes → CI/CD Pipeline

This guide walks you through the complete deployment process from building a Docker image to running it in Kubernetes with automated CI/CD.

---

## 🐳 Step 1: Build and Run Docker Image Locally

### Build the Docker Image

```bash
cd /home/umer/.gemini/antigravity/scratch/devops-multicloud-project

# Build the image
docker build -t devops-sample-app:latest app/

# Verify the image was created
docker images devops-sample-app
```

**Expected Output:**
```
REPOSITORY           TAG       IMAGE ID       CREATED         SIZE
devops-sample-app    latest    abc123def456   5 seconds ago   187MB
```

### Run the Docker Container Locally

```bash
# Run the container
docker run -d \
  --name devops-app \
  -p 8000:8000 \
  devops-sample-app:latest

# Check if it's running
docker ps

# View logs
docker logs devops-app

# Test the application
curl http://localhost:8000/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-12-16T...",
  "version": "1.0.0"
}
```

### Test All Endpoints

```bash
# Root endpoint
curl http://localhost:8000/

# Health check
curl http://localhost:8000/health

# Create an item
curl -X POST http://localhost:8000/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","description":"Test","price":99.99}'

# List items
curl http://localhost:8000/items

# Access interactive docs
xdg-open http://localhost:8000/docs
```

### Stop and Clean Up

```bash
# Stop the container
docker stop devops-app

# Remove the container
docker rm devops-app

# Remove the image (optional)
docker rmi devops-sample-app:latest
```

---

## ☸️ Step 2: Deploy to Kubernetes

### Option A: Using Minikube (Local Kubernetes)

#### Install Minikube

```bash
# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
minikube start --driver=docker

# Verify
kubectl get nodes
```

#### Deploy Application to Minikube

```bash
cd /home/umer/.gemini/antigravity/scratch/devops-multicloud-project

# Build image in Minikube's Docker daemon
eval $(minikube docker-env)
docker build -t devops-sample-app:latest app/

# Deploy ConfigMap and Secrets
kubectl apply -f k8s/configmap.yaml

# Update deployment image (use local image)
kubectl apply -f k8s/deployment.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services

# Get the service URL
minikube service devops-sample-app --url
```

#### Test the Deployment

```bash
# Get the URL
APP_URL=$(minikube service devops-sample-app --url)

# Test health endpoint
curl $APP_URL/health

# Test API
curl $APP_URL/items
```

#### View Logs and Debug

```bash
# Get pod name
kubectl get pods

# View logs
kubectl logs -f <pod-name>

# Describe pod
kubectl describe pod <pod-name>

# Execute into pod
kubectl exec -it <pod-name> -- /bin/sh

# Port forward for debugging
kubectl port-forward svc/devops-sample-app 8000:80
curl http://localhost:8000/health
```

### Option B: Using kind (Kubernetes in Docker)

```bash
# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create cluster
kind create cluster --name devops-cluster

# Load image into kind
kind load docker-image devops-sample-app:latest --name devops-cluster

# Deploy
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml

# Port forward to access
kubectl port-forward svc/devops-sample-app 8000:80
```

### Option C: Deploy to Cloud Kubernetes (GKE/EKS/AKS)

#### Prerequisites: Deploy Infrastructure First

```bash
# Deploy GKE cluster (recommended - free credit)
cd terraform/gcp
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Set your project_id

# Authenticate
gcloud auth login
gcloud auth application-default login

# Deploy
terraform init
terraform apply

# Get cluster credentials
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a

# Verify
kubectl get nodes
```

#### Push Image to Container Registry

```bash
# Tag image for GitHub Container Registry
docker tag devops-sample-app:latest ghcr.io/riphah39987/devops-sample-app:v1.0.0

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u riphah39987 --password-stdin

# Push
docker push ghcr.io/riphah39987/devops-sample-app:v1.0.0
```

#### Deploy to Cloud Kubernetes

```bash
# Update k8s/deployment.yaml with your image
# Change image: to ghcr.io/riphah39987/devops-sample-app:v1.0.0

# Deploy
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml

# Wait for LoadBalancer IP
kubectl get svc devops-sample-app -w

# Test
curl http://<EXTERNAL-IP>/health
```

---

## 🔄 Step 3: CI/CD Pipeline Setup

### GitHub Actions Pipeline (Active)

Your pipeline is already configured at `.github/workflows/ci-cd.yml`

#### How It Works:

```
On Push to main:
├─ 1. Setup Python 3.11
├─ 2. Install Dependencies
├─ 3. Run Tests (9 tests)
├─ 4. Build Docker Image
├─ 5. Push to ghcr.io
└─ 6. Success! ✅
```

#### Check Pipeline Status

**Go to:** https://github.com/Riphah39987/project-devops/actions

#### Pipeline Features:

✅ **Automatic Triggers:**
- Push to `main` or `develop`
- Pull requests to `main`
- Manual trigger (workflow_dispatch)

✅ **Automated Steps:**
- Code checkout
- Dependency installation
- Test execution (9 tests)
- Docker build
- Image push to GHCR
- Success notification

✅ **Artifacts:**
- Docker image: `ghcr.io/riphah39987/devops-sample-app:latest`
- Tagged with commit SHA

### Enable Kubernetes Deployment in Pipeline

To add Kubernetes deployment to your CI/CD pipeline:

#### 1. Get Your Kubeconfig

```bash
# For GKE
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a

# For Minikube
minikube kubectl -- config view --flatten > kubeconfig.yaml

# Encode to base64
cat ~/.kube/config | base64 -w 0
```

#### 2. Add GitHub Secret

1. Go to: https://github.com/Riphah39987/project-devops/settings/secrets/actions
2. Click "New repository secret"
3. Name: `KUBE_CONFIG`
4. Value: (paste the base64 encoded kubeconfig)
5. Click "Add secret"

#### 3. Update Workflow

The workflow will automatically deploy to Kubernetes when `KUBE_CONFIG` secret is set.

### Manual Deployment Trigger

```bash
# Trigger pipeline manually from GitHub UI
# Or push a commit:

echo "# Test deployment" >> README.md
git add README.md
git commit -m "Trigger deployment"
git push origin main

# Watch the pipeline
# https://github.com/Riphah39987/project-devops/actions
```

---

## 🎯 Complete End-to-End Deployment Workflow

### Workflow 1: Local Development

```bash
# 1. Make code changes
cd app/
nano main.py

# 2. Run tests locally
python -m pytest test_main.py -v

# 3. Build Docker image
docker build -t devops-sample-app:latest .

# 4. Test locally
docker run -p 8000:8000 devops-sample-app:latest
curl http://localhost:8000/health

# 5. Commit and push
git add .
git commit -m "Update feature"
git push origin main

# 6. CI/CD automatically:
#    - Runs tests
#    - Builds image
#    - Pushes to registry
```

### Workflow 2: Production Deployment

```bash
# 1. Deploy infrastructure (one-time)
cd terraform/gcp
terraform apply

# 2. Configure kubectl
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a

# 3. Deploy application
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml

# 4. Get LoadBalancer IP
kubectl get svc devops-sample-app

# 5. Test production
curl http://<EXTERNAL-IP>/health

# 6. Updates: Just push to GitHub
#    CI/CD builds and pushes new image
#    Then update deployment:
kubectl set image deployment/devops-sample-app \
  app=ghcr.io/riphah39987/devops-sample-app:latest

# 7. Monitor
kubectl rollout status deployment/devops-sample-app
kubectl get pods -l app=devops-sample-app
```

---

## 📊 Monitoring and Verification

### Check Docker

```bash
# List running containers
docker ps

# View logs
docker logs -f <container-id>

# Check resource usage
docker stats

# Inspect container
docker inspect devops-sample-app
```

### Check Kubernetes

```bash
# Check all resources
kubectl get all

# Check specific deployment
kubectl get deployment devops-sample-app
kubectl get pods -l app=devops-sample-app
kubectl get svc devops-sample-app

# View logs
kubectl logs -f deployment/devops-sample-app

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Check HPA status
kubectl get hpa
```

### Check CI/CD Pipeline

```bash
# Via GitHub CLI (if installed)
gh run list --repo Riphah39987/project-devops

# Watch latest run
gh run watch --repo Riphah39987/project-devops

# Or visit:
# https://github.com/Riphah39987/project-devops/actions
```

---

## 🐛 Troubleshooting

### Docker Issues

**Container not starting:**
```bash
docker logs devops-app
docker inspect devops-app
```

**Port already in use:**
```bash
# Find process using port 8000
sudo lsof -i :8000
# Or use different port
docker run -p 8080:8000 devops-sample-app:latest
```

### Kubernetes Issues

**Pods not starting:**
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

**ImagePullBackOff error:**
```bash
# For Minikube, rebuild image in Minikube's Docker
eval $(minikube docker-env)
docker build -t devops-sample-app:latest app/

# Update deployment to use imagePullPolicy: Never
```

**Service not accessible:**
```bash
# Check service
kubectl get svc devops-sample-app

# For Minikube, use tunnel
minikube tunnel

# Or port-forward
kubectl port-forward svc/devops-sample-app 8000:80
```

### CI/CD Pipeline Issues

**Tests failing:**
- Check Actions tab for error logs
- Run tests locally: `cd app && pytest test_main.py -v`

**Docker build failing:**
- Check Dockerfile syntax
- Verify all files exist

**Permission denied pushing to registry:**
- Check GITHUB_TOKEN permissions
- Ensure repository is public or you have proper access

---

## ✅ Success Checklist

- [ ] Docker image builds successfully
- [ ] Container runs locally on port 8000
- [ ] Health endpoint responds: `curl http://localhost:8000/health`
- [ ] Kubernetes cluster is running
- [ ] Application deployed to Kubernetes
- [ ] Pods are running and healthy
- [ ] Service is accessible
- [ ] CI/CD pipeline runs successfully
- [ ] Tests pass (9/9)
- [ ] Docker image pushed to registry
- [ ] Can access deployed application

---

## 🎉 Summary

You now have:

1. ✅ **Docker image** built and tested locally
2. ✅ **Local deployment** verified working
3. ✅ **Kubernetes deployment** configured and ready
4. ✅ **CI/CD pipeline** automated and functional

**Next Steps:**
- Deploy to cloud (GCP recommended for free credit)
- Set up monitoring (Prometheus/Grafana)
- Configure auto-scaling
- Add alerts and notifications

---

**Created:** December 16, 2025  
**Status:** Ready for Production
