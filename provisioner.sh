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

printf "Downloading and Installing RabbitMQ..."
# download and add rabbitmq signing key
wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc

# set package url for rabbitmq
deb http://www.rabbitmq.com/debian/ stable main

# update box after adding rabbitmq signing key
apt-get update

# run install of rabbitmq server
apt-get install -y rabbitmq-server

printf "Installing Docker..."
# download and install docker package
wget -qO- https://get.docker.com/ | sh

# add vagrant user to the docker group
usermod -aG docker vagrant

printf "Making sure ownership rights are correct in vagrant user directory..."
# make sure everything in the vagrant directory is owned by vagrant
chown -R vagrant:vagrant /home/vagrant --quiet
