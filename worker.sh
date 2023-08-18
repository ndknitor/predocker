#!/bin/bash

# Update the system
sudo apt update
sudo apt upgrade -y

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Install necessary packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common docker.io

#Add user to docker group
sudo groupadd docker
sudo usermod -aG docker ${USER}

# Add Kubernetes repository (if not added already)
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo sh -c 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt update

# Install Kubernetes components
sudo apt-get install -y kubelet kubeadm kubectl

# Run the kubeadm join command (replace with the command from your master node)
echo "Please run the following command on your worker nodes to join the cluster:

sudo kubeadm join <master-ip>:<master-port> --token <token> --discovery-token-ca-cert-hash <token-ca-cert-hash>"
