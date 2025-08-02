#!/bin/bash

clear
echo "This script will install docker and portainer"
echo "Press enter to begin or ctrl+c to exit"
read junk

# Install curl
sudo apt install -y curl

# Install Docker
clear
echo "Installing Docker"
sleep 2
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh

# Enable and start Docker
clear
echo "Enabling and starting docker"
sleep 2
sudo systemctl enable docker
sudo systemctl start docker
sudo service docker start
sudo service docker enable
sudo usermod -aG docker $USER

# Install portainer and watchtower
clear
echo "Install portainer and watchtower"
sleep 2
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
clear
sudo docker run  -v /var/run/docker.sock:/var/run/docker.sock --name upgrade-images containrrr/watchtower --run-once

# Check Containers
clear
echo "We will now check running docker containers"
sudo docker ps
sleep 2

# Check install
which docker > /dev/null
if [ $? == 0 ]
then
  echo "Docker Install Successful"
else
  echo "Docker Install Failed"
fi
exit
