#!/bin/bash

clear
echo "This script will install docker, portainer and watchtower"
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
sudo docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
clear
sudo docker run  -d -v /var/run/docker.sock:/var/run/docker.sock --name watchtower containrrr/watchtower

# Option to install open-webui and ollama
clear
echo "Do you want to install Artificial Intelligence (y/N)"
read option
if [ $option == "y" ]
then
    sudo docker run -d -p 3000:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
    sudo docker exec -it ghcr.io/open-webui/open-webui:ollama ollama pull gemma3:1b
    sudo docker exec -it ghcr.io/open-webui/open-webui:ollama apt install -y net-tools
    clear && "OpenWebUI is available at "$(ip a | grep '172' | grep -v flags | awk '{print $2}')":3000"
fi

# Check Containers
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
sleep 2
exit
