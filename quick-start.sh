#!/bin/bash

# DevOps Multi-Cloud Project - Quick Start Script
# This script helps you quickly test and validate the project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}DevOps Multi-Cloud Project Quick Start${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

MISSING_DEPS=0

if ! command_exists python3; then
    echo -e "${RED}✗ Python 3 not found${NC}"
    MISSING_DEPS=1
else
    echo -e "${GREEN}✓ Python 3 found${NC}"
fi

if ! command_exists docker; then
    echo -e "${RED}✗ Docker not found${NC}"
    MISSING_DEPS=1
else
    echo -e "${GREEN}✓ Docker found${NC}"
fi

if ! command_exists terraform; then
    echo -e "${YELLOW}⚠ Terraform not found (optional for app testing)${NC}"
else
    echo -e "${GREEN}✓ Terraform found${NC}"
fi

echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "${RED}Missing required dependencies. Please install them first.${NC}"
    exit 1
fi

# Menu
echo -e "${GREEN}What would you like to do?${NC}"
echo "1) Run application tests"
echo "2) Build Docker image"
echo "3) Run application locally (Docker)"
echo "4) Start full stack (docker-compose)"
echo "5) Validate Terraform code"
echo "6) Display project structure"
echo "7) Exit"
echo ""
read -p "Enter your choice [1-7]: " choice

case $choice in
    1)
        echo -e "${YELLOW}Running application tests...${NC}"
        cd app
        
        if [ ! -d "venv" ]; then
            echo "Creating virtual environment..."
            python3 -m venv venv
        fi
        
        source venv/bin/activate
        pip install -q -r requirements.txt
        pip install -q -r requirements-test.txt
        
        echo ""
        pytest test_main.py -v --cov=. --cov-report=term-missing
        
        echo ""
        echo -e "${GREEN}✓ Tests completed!${NC}"
        ;;
        
    2)
        echo -e "${YELLOW}Building Docker image...${NC}"
        docker build -t devops-sample-app:latest app/
        echo ""
        echo -e "${GREEN}✓ Docker image built successfully!${NC}"
        echo ""
        echo "Image details:"
        docker images devops-sample-app:latest
        ;;
        
    3)
        echo -e "${YELLOW}Running application in Docker...${NC}"
        
        # Build if not exists
        if ! docker images devops-sample-app:latest | grep -q devops-sample-app; then
            echo "Building image first..."
            docker build -t devops-sample-app:latest app/
        fi
        
        echo "Starting container on port 8000..."
        docker run --rm -p 8000:8000 --name devops-app devops-sample-app:latest &
        
        sleep 3
        echo ""
        echo -e "${GREEN}✓ Application running!${NC}"
        echo ""
        echo "Access the application:"
        echo "  - API: http://localhost:8000"
        echo "  - Docs: http://localhost:8000/docs"
        echo "  - Health: http://localhost:8000/health"
        echo ""
        echo "Press Ctrl+C to stop the application"
        
        # Wait for user interrupt
        wait
        ;;
        
    4)
        echo -e "${YELLOW}Starting full stack with docker-compose...${NC}"
        docker-compose up --build
        ;;
        
    5)
        echo -e "${YELLOW}Validating Terraform code...${NC}"
        echo ""
        
        for cloud in aws azure gcp; do
            echo "Validating ${cloud}..."
            cd terraform/${cloud}
            terraform init -backend=false > /dev/null 2>&1
            if terraform validate; then
                echo -e "${GREEN}✓ ${cloud} Terraform code is valid${NC}"
            else
                echo -e "${RED}✗ ${cloud} Terraform validation failed${NC}"
            fi
            cd ../..
            echo ""
        done
        
        echo -e "${GREEN}✓ Validation complete!${NC}"
        ;;
        
    6)
        echo -e "${YELLOW}Project structure:${NC}"
        echo ""
        tree -L 2 -I '__pycache__|*.pyc|venv|.terraform' . || find . -maxdepth 2 -not -path '*/\.*' -not -path '*/__pycache__*' | sort
        ;;
        
    7)
        echo "Goodbye!"
        exit 0
        ;;
        
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Done!${NC}"
