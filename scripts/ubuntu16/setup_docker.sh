#!/bin/bash
# Install docker-ce (docker Comunity Edition) in Ubuntu16.04
#

sudo apt install -y apt-transport-https ca-certificates curl \
     software-properties-common

# install docker-ce
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# grant current user (vagrant) right for accessing docker
# sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
