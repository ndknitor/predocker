#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Update the system
apt update
apt upgrade -y

# Install necessary dependencies
apt install -y curl apt-transport-https software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# Add Kubernetes repository and install kubeadm, kubelet, and kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubeadm kubelet kubectl

# Initialize the master (run this on one machine)
kubeadm init

# Configure kubectl for the current user
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Join worker nodes to the cluster (run this on each worker machine)
# Replace with the actual token from the kubeadm init output
kubeadm join <master-ip>:<master-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>

# Install a network plugin for pod networking (e.g., Calico or Flannel)
# This example uses Calico
kubectl apply -f https://docs.projectcalico.org/v3.17/manifests/calico.yaml

# On the master, you can check the status of nodes
kubectl get nodes

# To make the master node available for scheduling pods (not recommended for a production setup):
# kubectl taint nodes --all node-role.kubernetes.io/master-

# To deploy applications, create and apply Kubernetes YAML files

# Note: You may need to handle security, firewall rules, and other configurations based on your setup.

echo "Kubernetes cluster setup is complete."
