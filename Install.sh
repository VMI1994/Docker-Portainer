#!/bin/bash

clear
echo "This script will install docker and portainer"
echo "Press enter to begin or ctrl+c to exit"
read junk

# Update the system
sudo apt-get update
sudo apt install -y curl

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
exit
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
sudo service docker start
sudo service docker enable
sleep 3
sudo usermod -aG docker $USER
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
clear
sudo docker run  -v /var/run/docker.sock:/var/run/docker.sock --name upgrade-images containrrr/watchtower --run-once
clear
echo "We will now check running docker containers"
sudo docker ps
echo \n\n\n
if [ $? == 0];
  echo "Docker Install Successful"
else:
  echo "Docker Install Failed"
exit
