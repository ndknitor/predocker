ask_master_node() {
    while true; do
        read -p "Is this a master node? (Y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) return 0;;
            * ) echo "Please answer Y/y for yes or N/n for no.";;
        esac
    done
}

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

is_master_node=false
if ask_master_node; then
    is_master_node=true
fi

apt-get update &&  apt -y upgrade
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

swapoff -a
cp -f /etc/fstab /etc/fstab.bak
sed -e '/swap/ s/^#*/#/' -i /etc/fstab

curl -fsSL https://download.docker.com/linux/debian/gpg |  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y containerd.io

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
if [ "$is_master_node" = true ]; then
    apt-get install -y kubeadm
    apt-mark hold kubeadm
else
    apt-get install -y kubelet
    apt-mark hold kubelet
fi
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

if [ "$is_master_node" = true ]; then
  echo "This script won't run init command because you should be the one who run it, just run this command and customize pod's CIDR as your requirments:"
  echo "sudo kubeadm init --pod-network-cidr=10.244.0.0/16"
else
