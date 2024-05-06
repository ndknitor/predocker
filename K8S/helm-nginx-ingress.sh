#On master install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm
#Setup Nginx as external load balancer
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl get ingressclass nginx
kubectl delete ingressclass nginx
helm install nginx-ingress ingress-nginx/ingress-nginx

helm install nginx-ingress ingress-nginx/ingress-nginx
