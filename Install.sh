#!/bin/bash

clear
echo "This script will install docker and portainer"
echo "Press enter to begin or ctrl+c to exit"
read junk

sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sleep 3
sudo usermod -aG docker $USER
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
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
