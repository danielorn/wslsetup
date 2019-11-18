#!/usr/bin/env bash
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install kubectl
sudo apt-get install -y --allow-unauthenticated  kubectl

# Install k8stail
mkdir -p /tmp/k8stail
curl -L https://github.com/dtan4/k8stail/releases/download/v0.6.0/k8stail-v0.6.0-linux-amd64.tar.gz -o /tmp/k8stail/k8stail.tar.gz
tar -xzf /tmp/k8stail.tar.gz -C /tmp/k8stail
mv /tmp/k8stail/linux-amd64/k8stail $HOME/bin/k8stail
chmod +x $HOME/bin/k8stail
rm -rf /tmp/k8stail