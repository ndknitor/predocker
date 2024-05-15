# sudo ./etcd-setup.sh etcd1 10.0.0.1 etcd1=http://10.0.0.1:2380,etcd2=http://10.0.0.2:2380,etcd3=http://10.0.0.3:2380 etcd-token new

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 NAME IP INITIAL_CLUSTER TOKEN [CLUSTER_STATE]"
    exit 1
fi

NAME=$1
IP=$2
INITIAL_CLUSTER=$3
TOKEN=$4
NAME=$1
IP=$2
INITIAL_CLUSTER=$3
TOKEN=$4

# Set CLUSTER_STATE to "new" if not provided
CLUSTER_STATE=${5:-existing}

if [ ! -f "/usr/local/bin/etcd" ]; then
  wget https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz -P /tmp
  tar -xvf /tmp/etcd-v3.5.2-linux-amd64.tar.gz
  mv /tmp/etcd-v3.5.2-linux-amd64/etcd /usr/local/bin/
  mv /tmp/etcd-v3.5.2-linux-amd64/etcdctl /usr/local/bin/
fi

sudo groupadd --system etcd
sudo useradd --system -g etcd -s /bin/false -d /var/lib/etcd etcd
mkdir -p /var/lib/etcd
chown -R etcd:etcd /var/lib/etcd
mkdir -p /etc/etcd
chown -R etcd:etcd /etc/etcd

echo "
name: $NAME
data-dir: /var/lib/etcd
listen-peer-urls: http://$IP:2380
listen-client-urls: http://$IP:2379
initial-advertise-peer-urls: http://$IP:2380
advertise-client-urls: http://$IP:2379
initial-cluster: $INITIAL_CLUSTER
initial-cluster-token: $TOKEN
initial-cluster-state: $CLUSTER_STATE" > /etc/etcd/etcd.conf.yml

echo "
[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
User=etcd
Group=etcd
Type=notify
ExecStart=/usr/local/bin/etcd --config-file=/etc/etcd/etcd.conf.yml
Restart=on-failure
LimitNOFILE=40000
ProtectSystem=full
ProtectHome=true
ReadOnlyPaths=/usr
ReadWritePaths=/var/lib/etcd /etc/etcd

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/etcd.service
systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
