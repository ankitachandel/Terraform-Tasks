#!/bin/bash

# Ensure script runs with superuser privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Install dependencies required to build amazon-efs-utils from source
sudo apt-get update -y
sudo apt-get install build-essential

# Install unzip utility
sudo apt-get install -y unzip


# Install AWS CLI using snap
sudo snap install aws-cli --classic

# Install NVM and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Source NVM and install the latest LTS version of Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts

# Install PM2 globally
npm install -g pm2

# Create the default directory
mkdir -p /var/www/html && cd /var/www/html

# Ensure server.js exists in /var/www/html
if [ ! -f server.js ]; then
  echo "Error: server.js not found in /var/www/html"
  exit 1
fi

# Start server.js using PM2
pm2 start server.js

# Save the PM2 process list so it restarts on reboot
pm2 save

# Set PM2 to start on boot
pm2 startup systemd -u $(whoami) --hp $(eval echo ~$USER)

# If PM2 to restart
pm2 restart 

