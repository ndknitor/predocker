# Apply Calico CNI: kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
# Print join command: kubeadm token create --print-join-command
# Join worker: kubeadm join <ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
# Upload cert to get key: kubeadm init phase upload-certs --upload-certs
# Join master: kubeadm join <ip>:6443 --token <token> --apiserver-advertise-address=<ip-address> --discovery-token-ca-cert-hash sha256:<hash> --control-plane --certificate-key <key>

# Drain node: kubectl drain <node-name> --delete-emptydir-data --force --ignore-daemonsets
# Delete node: kubectl delete node <node-name>
# Stop k8s service on node: kubeadm reset

MAX_PODS_PER_NODE=110
NETWORK_INTERFACE=eth1
VIP=192.168.56.100
SANS="192.168.56.100,192.168.56.101,192.168.56.102,192.168.56.103"

get_ip_from_iface() {
    local iface="$1"

    if [[ -z "$iface" ]]; then
        echo "Usage: get_ip_from_iface <interface>"
        return 1
    fi

    # Get the first IPv4 address assigned to the interface
    ip addr show "$iface" 2>/dev/null \
        | awk '/inet / {print $2}' \
        | cut -d/ -f1 \
        | head -n1
}

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi


node_ip=$(get_ip_from_iface $NETWORK_INTERFACE)

apt-get update &&  apt -y upgrade
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

swapoff -a
cp -f /etc/fstab /etc/fstab.bak
sed -e '/swap/ s/^#*/#/' -i /etc/fstab

curl -fsSL https://download.docker.com/linux/debian/gpg |  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y containerd.io

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubeadm kubelet
apt-mark hold kubeadm kubelet

echo "KUBELET_EXTRA_ARGS=\"--node-ip=$node_ip\" --max-pods=$MAX_PODS_PER_NODE" > /etc/default/kubelet

cat <<EOF |  tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

cat <<EOF |  tee /etc/sysctl.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

mkdir -p /etc/containerd
containerd config default |  tee /etc/containerd/config.toml
sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

echo "If this is the first control plane node, run this command:"
echo "kubeadm init --apiserver-advertise-address=$node_ip --apiserver-cert-extra-sans "$SANS" --control-plane-endpoint "$VIP:6443" --pod-network-cidr=10.244.0.0/16"

echo "If this is a joining control plane node, run this command, get information from existing control plane node first:"
echo "kubeadm join :6443 --apiserver-advertise-address=$node_ip --token <token> --discovery-token-ca-cert-hash sha256:<hash> --control-plane --certificate-key <key>"
