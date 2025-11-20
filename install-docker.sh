#!/bin/bash

set -e

echo "[1/5] Updating packages..."
sudo apt update

echo "[2/5] Installing required packages..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg

echo "[3/5] Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "[4/5] Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[5/5] Installing Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Done! Docker installed successfully."

echo "Optional: Add current user to docker group..."
sudo usermod -aG docker $USER

echo "You may need to log out and back in for group changes to apply."