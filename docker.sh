#!/bin/bash

# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y ca-certificates curl git

# Set up Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's apt repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt-get update

# Install Docker Engine and associated plugins
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Clone the repository
git clone https://github.com/tariklafci/ai-code-assistant.git
cd ai-code-assistant

# Build the Docker image (fixed the wrong flag `-t` position)
sudo docker build -t tariklafci/ai-code-assistant:latest .

# Run the container (this will download 3.6GBs model, so it will take some time to website get running)
sudo docker run --rm -p 5000:5000 tariklafci/ai-code-assistant:latest
