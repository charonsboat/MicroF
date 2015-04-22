#!/bin/bash

printf "Running Vagrant Provisioning..."

printf "Updating Box..."
# make sure the box is fully up to date
apt-get update

# comment out the line below to disallow the system to upgrade
apt-get upgrade -y && apt-get dist-upgrade -y

printf "Installing Server Tools..."
# installing server tools
apt-get install -y git

printf "Installing Docker..."
# download and install docker package
wget -qO- https://get.docker.com/ | sh

# add vagrant user to the docker group
usermod -aG docker vagrant

printf "Downloading and Running the NSQ Docker Image..."
# pull down the image
docker pull nsqio/nsq

# store host IP for Docker
dockerHostIP=$(ifconfig docker0 | grep 'inet addr' | grep -Eo '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | head -1)

# run the nsqlookupd server
docker run -d --name nsqlookupd -p 4160:4160 -p 4161:4161 nsqio/nsq /nsqlookupd

# run the nsqd server
docker run -d --name nsqd -p 4150:4150 -p 4151:4151 nsqio/nsq /nsqd --broadcast-address=$dockerHostIP --lookupd-tcp-address=$dockerHostIP

printf "Making sure ownership rights are correct in vagrant user directory..."
# make sure everything in the vagrant directory is owned by vagrant
chown -R vagrant:vagrant /home/vagrant --quiet
