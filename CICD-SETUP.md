# GitHub Actions CI/CD Setup Guide

This guide will help you enable the CI/CD pipeline for your project.

## ✅ Step 1: GitHub Actions is Already Configured!

The workflow file has been placed at: `.github/workflows/ci-cd.yml`

This will automatically trigger on:
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual trigger (workflow_dispatch)

## 🔑 Step 2: Configure GitHub Secrets

You need to add these secrets to your GitHub repository:

### How to Add Secrets:

1. Go to your repository: https://github.com/Riphah39987/project-devops
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret below:

### Required Secrets:

#### For Docker Registry (GitHub Container Registry - GHCR):
- **Secret Name:** `GITHUB_TOKEN`
- **Value:** Automatically available (no need to add)

#### For SonarQube (Optional - for code quality):
- **Secret Name:** `SONAR_TOKEN`
- **Value:** Get from your SonarQube instance
- **How to get:**
  - Sign up at https://sonarcloud.io (free for public repos)
  - Create a project
  - Generate a token: Account → Security → Generate Tokens
  
- **Secret Name:** `SONAR_HOST_URL`
- **Value:** `https://sonarcloud.io` (or your SonarQube server URL)

#### For Kubernetes Deployment (Optional - only if deploying):
- **Secret Name:** `KUBE_CONFIG`
- **Value:** Your kubeconfig file (base64 encoded)
- **How to get:**
  ```bash
  cat ~/.kube/config | base64 -w 0
  ```

- **Secret Name:** `APP_URL`
- **Value:** Your application URL after deployment (e.g., `http://your-loadbalancer-ip`)

## 📋 Step 3: Simplified Pipeline (Start Here)

Since you may not have all services set up yet, I'll create a simplified version that works immediately!

### What the Basic Pipeline Does:
✅ Runs on every push  
✅ Tests the Python code  
✅ Builds Docker image  
✅ Pushes to GitHub Container Registry  
✅ Runs security scan  

### What's Optional (you can enable later):
⚠️ SonarQube code quality (needs account)  
⚠️ Kubernetes deployment (needs cluster)  

## 🚀 Step 4: Test the Pipeline

Once secrets are configured, test it:

1. Make a small change to README.md:
   ```bash
   echo "## Testing CI/CD Pipeline" >> README.md
   ```

2. Commit and push:
   ```bash
   git add README.md
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```

3. Check pipeline status:
   - Go to: https://github.com/Riphah39987/project-devops/actions
   - You should see your workflow running!

## 📊 What Happens in the Pipeline:

```
1. Code Quality Check (1-2 min)
   └─ Linting, formatting checks
   
2. Run Tests (2-3 min)
   └─ pytest with coverage
   
3. Build Docker Image (2-3 min)
   └─ Multi-stage Docker build
   
4. Security Scan (1-2 min)
   └─ Trivy vulnerability scan
   
5. Push to Registry (30 sec)
   └─ GitHub Container Registry
   
Total: ~8-10 minutes
```

## 🎯 Quick Start (No Extra Setup Required)

The basic pipeline will work immediately without any secrets! It will:
- ✅ Run tests automatically
- ✅ Build Docker images
- ⚠️ Skip deployment (no cluster configured yet)

Just push code and it runs!

## 🔧 Advanced: Enable Full Pipeline

### 1. SonarQube Setup (Optional):
```bash
# Sign up at SonarCloud
https://sonarcloud.io

# Import your GitHub repo
# Get your token and add to GitHub Secrets
```

### 2. Kubernetes Deployment Setup:

After you deploy infrastructure with Terraform:

```bash
# Get kubeconfig
# For GKE:
gcloud container clusters get-credentials devops-gke-cluster --zone us-central1-a

# Encode it
cat ~/.kube/config | base64 -w 0

# Add to GitHub Secrets as KUBE_CONFIG
```

### 3. Container Registry:

Your images will be pushed to:
```
ghcr.io/riphah39987/devops-sample-app:latest
ghcr.io/riphah39987/devops-sample-app:sha-abc123
```

## 📱 Pipeline Notifications

You can add Slack/Discord notifications by adding this to workflow:

```yaml
- name: Notify on Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## ❌ Troubleshooting

### Pipeline Fails on Tests:
- Check test logs in Actions tab
- Run tests locally: `cd app && pytest test_main.py -v`

### Docker Build Fails:
- Check Dockerfile syntax
- Ensure requirements.txt is valid

### Deployment Fails:
- Verify KUBE_CONFIG secret is set
- Check cluster is accessible
- Confirm kubectl works: `kubectl get nodes`

## 🎓 Learning Resources

- GitHub Actions Docs: https://docs.github.com/actions
- Docker Build: https://docs.docker.com/build/
- Kubernetes Deployment: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

## ✅ Success Checklist

- [ ] .github/workflows/ci-cd.yml exists
- [ ] Make a test commit
- [ ] Check Actions tab on GitHub
- [ ] See green checkmarks ✓
- [ ] View build logs
- [ ] (Optional) Add SonarQube token
- [ ] (Optional) Add Kubernetes config
- [ ] (Optional) Set up deployment
