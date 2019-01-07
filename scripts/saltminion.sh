#!/bin/bash

# Add fixed hosts entries to /etc/hosts
echo "Updating the /etc/hosts file with fixed data...."
sudo cat /vagrant/files/hostsfile >> /etc/hosts

# Install the SaltStack repo and key
echo "Installing SaltStack repo and install Salt Minion...."
sudo yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm

# Clear the yum cache
sudo yum clean expire-cache

# Install SaltStack Minion
sudo yum -y install salt-minion

# Point the Minion to the Master
echo "Update minion file to point to Salt Master...."
sudo cp /etc/salt/minion /etc/salt/minion.copy
sudo cat /etc/salt/minion.copy | sed -e s/'#master: salt'/'master: 172.28.128.18'/ > /etc/salt/minion
sudo rm -f /etc/salt/minion.copy

# Start the Minion
echo "Start minion service...."
sudo service salt-minion start

