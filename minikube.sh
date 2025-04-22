
#!/bin/bash

set -e

# Update and install required packages
sudo apt-get update
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release conntrack

# Install Docker if not present
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
fi

# Install kubectl
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
fi

# Install Minikube
if ! command -v minikube &> /dev/null; then
  echo "Installing Minikube..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi

# Install Helm
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Start Minikube
minikube start --memory=7302 --cpus=4
eval $(minikube docker-env)

# Clone the repo
if [ ! -d "ai-code-assistant" ]; then
  git clone https://github.com/tariklafci/ai-code-assistant.git
fi
cd ai-code-assistant

# Build Docker image inside Minikube
docker build -t tariklafci/ai-code-assistant:latest .

# Deploy using Helm
helm install ai-code ./chart

# Open the service in the browser (this will download 3.6GBs model, so it will take some time to website get running)
minikube service ai-code-assistant-service
