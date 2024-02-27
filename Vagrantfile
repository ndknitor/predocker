# vagrant plugin install vagrant-libvirt
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  (1..3).each do |i|
    config.vm.define "d#{i}" do |node|
      # Set the hostname and VM name
      node.vm.hostname = "debian#{i}"
      node.vm.provider "libvirt" do |libvirt|
        libvirt.memory = 1024
        libvirt.cpus = 1
      end

      #node.vm.network "private_network", type: "dhcp" 
      node.vm.network "private_network", type: "static", ip: "192.168.122.#{i + 100}"

      node.vm.provision "shell", inline: <<-SHELL

        sudo apt-get update
        sudo apt-get install -y openssh-server net-tools

        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDVqQbPFNqxA9+pMx5vGayek6KmDru+ZCKK+uckQVL0TRt7Tms6DdtRSyRovQdV8Ey4kBq3wYWyX/qWbq20V338f4qK8h/q3L3lkcxQEwtUYT6WVbW51ZEPmUs0sGrFjErvaaXEwAqlVz4K9PG3JBzgRp4WgytBddo42P+69gQXTQ== kn@ndkn" >> /home/vagrant/.ssh/authorized_keys
        echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAIEA1akGzxTasQPfqTMebxmsnpOipg67vmQiivrnJEFS9E0be05rOg3b
UUskaL0HVfBMuJAat8GFsl/6lm6ttFd9/H+KivIf6ty95ZHMUBMLVGE+llW1udWRD5lLNL
BqxYxK72mlxMAKpVc+CvTxtyQc4EaeFoMrQXXaONj/uvYEF00AAAIAuIctBLiHLQQAAAAH
c3NoLXJzYQAAAIEA1akGzxTasQPfqTMebxmsnpOipg67vmQiivrnJEFS9E0be05rOg3bUU
skaL0HVfBMuJAat8GFsl/6lm6ttFd9/H+KivIf6ty95ZHMUBMLVGE+llW1udWRD5lLNLBq
xYxK72mlxMAKpVc+CvTxtyQc4EaeFoMrQXXaONj/uvYEF00AAAADAQABAAAAgBRwF7ulVg
oKwdFQl3+vKAj/PFbAIAtlTryWpZedPA8sdQ2FgdJK0wjitDfkpRf+ZYheGIAtXdmjPrg3
HBydJerdktHFm4I/1Cwy+eKZbc/QcCR15RMDvkNAXbWbj+ZcjNQNfvYhPSJcAXjI1kDllK
4Pi33on1CVKY97YmowYcPBAAAAQQCH9nE46WBgb950tlBN6RprVC0fCqXESSHraYBbw1Fq
ByJSPhD7Wq6NysitDCth05JVK2N2bSiAApy4ANDltm7LAAAAQQDvgCc1AI6M8y6Ntvtt+t
JKZ7/ZewXwed7cHJMbPjrwW9gSGj1kO9xJMXM+KcgJQqeBBVa5tz/y4EheoCqquclRAAAA
QQDkYSbVxqFPfSAphr/JBiqwteMvBxcCzsnjfN+u1soMtv+5wTPM3xhkqz+eUZpBNu8N0B
AwJW3pTh3ZUiVk5W89AAAAB2tuQG5ka24BAgM=
-----END OPENSSH PRIVATE KEY-----" > /home/vagrant/.ssh/id_rsa
        
        mkdir -p $HOME/.bin
        echo 'export PATH=$PATH:/sbin:$HOME/.bin' >> /home/vagrant/.bashrc
        source /home/vagrant/.bashrc
     
      SHELL
    end
  end
end
