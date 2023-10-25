Vagrant.configure("2") do |config|
  # Define a base box for Debian
  config.vm.box = "debian/buster64"

  # Loop to create four VMs
  (1..2).each do |i|
    config.vm.define "debian#{i}" do |node|
      # Set the hostname and VM name
      node.vm.hostname = "debian#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      # Create a private network to allow VMs to communicate
      node.vm.network "private_network", type: "dhcp"

      # Shell provisioning to update the system and install SSH
      node.vm.provision "shell", inline: <<-SHELL

	sudo apt-get update
	sudo apt-get install -y openssh-server net-tools
	
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPCPNAORR9i8FMfFYndTMui4YkpP2XJT14jSAzGjV1lJoY4CzHOdlIgVeiaFFywtak+6QNltG/NcjOHmJ7luZOEI43mzXgQSF5MuTeWz0G+Nmz1JbcEOYrqXli43zWiFdOScY7VAarrDFvbTMIPMDHTv2iGtexJpwncocQoHz5RJFixhuoIDAfGRKBAmY1m8zo+IrInW8bQmYIuAb/7IMeMzs2+LIEhjC7D+SnnA8DZ9n5JLzlIV5JpXHOCsKgYEQ6R9Z0JxSOOjyn2ZzsZHEeecBen5vTU3sfN6pssR3MCsPrNyceuONe3h0pYkcD2sthcU45HR9Bci/57EnrRyTB vagrant@debian1" >> /home/vagrant/.ssh/authorized_keys
	echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAzwjzQDkUfYvBTHxWJ3UzLouGJKT9lyU9eI0gMxo1dZSaGOAsxznZ
SIFXomhRcsLWpPukDZbRvzXIzh5ie5bmThCON5s14EEheTLk3ls9BvjZs9SW3BDmK6l5Yu
N81ohXTknGO1QGq6wxb20zCDzAx079ohrXsSacJ3KHEKB8+USRYsYbqCAwHxkSgQJmNZvM
6PiKyJ1vG0JmCLgG/+yDHjM7NviyBIYwuw/kp5wPA2fZ+SS85SFeSaVxzgrCoGBEOkfWdC
cUjjo8p9mc7GRxHnnAXp+b01N7HzeqbLEdzArD6zcnHrjjXt4dKWJHA9rLYXFOOR0fQXIv
+exJ60ckwQAAA8hNtNjaTbTY2gAAAAdzc2gtcnNhAAABAQDPCPNAORR9i8FMfFYndTMui4
YkpP2XJT14jSAzGjV1lJoY4CzHOdlIgVeiaFFywtak+6QNltG/NcjOHmJ7luZOEI43mzXg
QSF5MuTeWz0G+Nmz1JbcEOYrqXli43zWiFdOScY7VAarrDFvbTMIPMDHTv2iGtexJpwnco
cQoHz5RJFixhuoIDAfGRKBAmY1m8zo+IrInW8bQmYIuAb/7IMeMzs2+LIEhjC7D+SnnA8D
Z9n5JLzlIV5JpXHOCsKgYEQ6R9Z0JxSOOjyn2ZzsZHEeecBen5vTU3sfN6pssR3MCsPrNy
ceuONe3h0pYkcD2sthcU45HR9Bci/57EnrRyTBAAAAAwEAAQAAAQAXbXPZOJxQ+JePCCLX
pDN+eNtdGi54BAbItW+HWNfjzkUBu5xVjv4/biN0hUlyKwoO8UrHHuHtOTDX4ihSw+ibvN
PbBv05uyUGifPMFZb6Sv6Xkt7fWCozlqHdxtBBlnwKp95+qCt5EasmaLz1mapW42FgDpmJ
ukzBSfxurTp3Gk7n519bw0U0tPJuLK0e6sBUU/qf7L27kAzUrdSgi+Mu5PhAm/Z2Ar+1aP
QE7iNW+ncdCK7Go3Lh0cG6pYMbKkEbzg/NsJm/oVWC7gFZ4q+34LnNxtyBU+LaEX4Gax6d
pJRJiy4D1R0R4IGWnyFnPJplDajBpt9LQOCLpiVVjkXhAAAAgQDHIz2RRKR6GsXa5rYrmf
Y+JOdbLoc6UHkKvIQmX9rAoJY0NfsE4WPNE4S4+f9SVzlQHXh+fbXf54mgQ13fRkO6bkOl
XrdEQnIAujrB5NT7gezbrL9dt+cYTu44ZETDHkIlQnZpJzeTG4peuIJi+ZWWF7zUBPVBE2
CLr3UYxuUNDwAAAIEA/B4oKCed66S4k/ROfrxjv0coodok/M/cAOAOZnrL/x7nv97EcVf4
D0eMeuQ9PcnEX8tJtADdWHxcPNzTtGxOXhpBsyPHkmXOVUaUPpbOxMQIG0kuktVlBQ7C7C
dhcm8sDSPWYnbPlxQaBKchUL3uVfRhUQpODPyGk4Jfu0eNxTcAAACBANI5E+WV9WSDandC
/7v+DmEQZ0gSZKTSPg/wO/JRvlmmFwp6lBy0haYAm6p1JInMoZwp/xSDiHUwRGO8xVrz0N
qX5+l3kuS9KkbItZ4hhvs/FrrzuiN/KSOQKwFhcKJ/1PtUykbC3fG/HOZHIXqcJ4AjmiT5
PyjXR3D0JGk672HHAAAAD3ZhZ3JhbnRAZGViaWFuMQECAw==
-----END OPENSSH PRIVATE KEY-----" > /home/vagrant/.ssh/id_rsa


	echo 'export PATH=$PATH:/sbin' >> /home/vagrant/.bashrc
	source /home/vagrant/.bashrc
     
      SHELL
    end
  end
end
