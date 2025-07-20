#!/bin/bash

clear
echo "This script will install docker and portainer"
echo "Press enter to begin or ctrl+c to exit"
read junk

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
sleep 2

echo "a reboot is needed for all changes to take effect."
echo "The system will reboot in 10 seconds"
echo "press ctrl+c to prevent reboot now"
sleep 10
sudo reboot now &
exit
