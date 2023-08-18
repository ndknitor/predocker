#!/bin/bash

# Update the system
sudo apt update
sudo apt upgrade -y

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Install necessary packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo sh -c 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt update

# Install Kubernetes components
sudo apt-get install -y kubelet kubeadm kubectl docker.io

#Add user to docker group
sudo groupadd docker
sudo usermod -aG docker ${USER}

# Initialize the Kubernetes master
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin - Calico in this example
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Display kubeadm join command for worker nodes
echo "Please run the following command on your worker nodes to join the cluster:

sudo $(sudo kubeadm token create --print-join-command)"
