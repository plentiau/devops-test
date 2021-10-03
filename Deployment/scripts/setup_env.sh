#!/bin/bash

if command -v terraform &>/dev/null; then
  echo "Terraform already installed"

else
  echo 'Installing Terraform...'
  sudo wget https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip -P /tmp/
  sudo unzip /tmp/terraform_0.14.6_linux_amd64.zip -d /tmp/
  sudo mv -f /tmp/terraform /usr/bin
  sudo chmod +x /usr/bin/terraform
fi

if command -v jq &>/dev/null; then
  echo "jq already installed"
else
  echo 'Installing jq'
  JQ=/usr/bin/jq
  curl https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 > $JQ && chmod +x $JQ
  ls -la $JQ
fi

if command -v aws &>/dev/null; then
  echo "AWS CLI already installed"
else
  echo 'Installing AWS CLI...'
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
fi

if command -v docker &>/dev/null; then
  echo "Docker CLI already installed"
else
  echo 'Installing Docker CLI...'
  sudo apt-get update
  sudo apt-get install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
fi