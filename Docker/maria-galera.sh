#Cluster
docker run -d --name cluster -p 3306:3306 -e MARIADB_GALERA_CLUSTER_ADDRESS=gcomm:// -e MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes -e MARIADB_GALERA_CLUSTER_BOOTSTRAP=yes -e ALLOW_EMPTY_PASSWORD=yes -v galera_data:/bitnami/mariadb  bitnami/mariadb-galera:latest
#Other node
docker run -d --name node2 -p 3307:3306 -e MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://<Cluster Ip>  -e ALLOW_EMPTY_PASSWORD=yes bitnami/mariadb-galera:latest
