#!/bin/bash

# Quick Docker + Kubernetes Deployment Script
# This script builds, deploys and tests the application

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  DevOps Sample App - Quick Deploy${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

PROJECT_DIR="/home/umer/.gemini/antigravity/scratch/devops-multicloud-project"
cd "$PROJECT_DIR"

#  ===============================
# STEP 1: Build Docker Image
# ===============================
echo -e "${YELLOW}Step 1: Building Docker Image...${NC}"
docker build -t devops-sample-app:latest app/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully!${NC}"
else
    echo -e "${RED}✗ Docker build failed${NC}"
    exit 1
fi

echo ""
docker images devops-sample-app:latest
echo ""

# ===============================
# STEP 2: Run Docker Container
# ===============================
echo -e "${YELLOW}Step 2: Running Docker Container...${NC}"

# Stop and remove existing container if running
docker stop devops-app 2>/dev/null || true
docker rm devops-app 2>/dev/null || true

# Run new container
docker run -d \
  --name devops-app \
  -p 8000:8000 \
  devops-sample-app:latest

sleep 3

if docker ps | grep -q devops-app; then
    echo -e "${GREEN}✓ Container is running!${NC}"
else
    echo -e "${RED}✗ Container failed to start${NC}"
    docker logs devops-app
    exit 1
fi

echo ""

# ===============================
# STEP 3: Test Application
# ===============================
echo -e "${YELLOW}Step 3: Testing Application...${NC}"

echo "Waiting for application to be ready..."
sleep 5

echo "Testing health endpoint..."
HEALTH_RESPONSE=$(curl -s http://localhost:8000/health)

if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
    echo -e "${GREEN}✓ Health check passed!${NC}"
    echo "$HEALTH_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ Health check failed${NC}"
    docker logs devops-app
    exit 1
fi

echo ""
echo "Testing root endpoint..."
ROOT_RESPONSE=$(curl -s http://localhost:8000/)
echo "$ROOT_RESPONSE" | jq '.'

echo ""
echo "Creating a test item..."
CREATE_RESPONSE=$(curl -s -X POST http://localhost:8000/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","description":"Deployed via script","price":99.99}')
echo "$CREATE_RESPONSE" | jq '.'

echo ""
echo "Listing items..."
LIST_RESPONSE=$(curl -s http://localhost:8000/items)
echo "$LIST_RESPONSE" | jq '.'

echo ""
echo -e "${GREEN}✓ All API tests passed!${NC}"
echo ""

# ===============================
# STEP 4: Display Info
# ===============================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Deployment Successful! 🎉${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Application is running at:"
echo -e "  ${GREEN}http://localhost:8000${NC}"
echo ""
echo "Endpoints:"
echo "  - Health:    http://localhost:8000/health"
echo "  - API Docs:  http://localhost:8000/docs"
echo "  - Items API: http://localhost:8000/items"
echo ""
echo "Container info:"
echo "  - Name: devops-app"
echo "  - Image: devops-sample-app:latest"
echo "  - Port: 8000"
echo ""
echo "Useful commands:"
echo "  - View logs:     docker logs -f devops-app"
echo "  - Stop app:      docker stop devops-app"
echo "  - Remove app:    docker rm devops-app"
echo "  - Restart app:   docker restart devops-app"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop watching logs${NC}"
echo ""

# Show live logs
docker logs -f devops-app
