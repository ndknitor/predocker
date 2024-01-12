# Install Apache Utils (provides htpasswd)
sudo apt-get install apache2-utils

# Create the htpasswd file
htpasswd -Bc /path/to/htpasswd username

#Add more user to file
htpasswd -b /path/to/htpasswd new_username new_password

# Run the Docker Registry with Authentication
docker run -d -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /path/to/htpasswd:/etc/docker/registry/htpasswd \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e "REGISTRY_AUTH_HTPASSWD_PATH=/etc/docker/registry/htpasswd" \
  registry:2



mkdir certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key -x509 -days 365 -out certs/domain.crt


docker run -d -p 5000:5000 \
    --restart=always \
    --name registry \
    -v /home/vagrant/registry/certs:/certs \
    -v /home/vagrant/registry/config.yml:/etc/docker/registry/config.yml \
    -v /home/vagrant/registry/htpasswd:/etc/docker/registry/htpasswd \
    -e "REGISTRY_AUTH=htpasswd" \
    -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
    -e "REGISTRY_AUTH_HTPASSWD_PATH=/etc/docker/registry/htpasswd" \
    registry:2
