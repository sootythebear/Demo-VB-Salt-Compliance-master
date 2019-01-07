#!/bin/bash

# Add fixed hosts entries to /etc/hosts
echo "Updating the /etc/hosts file with fixed data...."
sudo cat /vagrant/files/hostsfile >> /etc/hosts

# Install the SaltStack repo and key
echo "Sourcing and Installing all Salt Master services...."
sudo yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm

# Clear the yum cache
sudo yum clean expire-cache

# Install SaltStack Master
sudo yum -y install salt-master

# Install SaltStack Minion
sudo yum -y install salt-minion

# Install SaltStack SSH
sudo yum -y install salt-ssh

# Install SaltStack Cloud
sudo yum -y install salt-cloud

# Install SaltStack api
sudo yum -y install salt-api

# Point the Minion to the Master
echo "Configuring the Salt-master minion to point to the Salt-master...."
sudo cp /etc/salt/minion /etc/salt/minion.copy
sudo cat /etc/salt/minion.copy | sed -e s/'#master: salt'/'master: 172.28.128.18'/ > /etc/salt/minion
sudo rm -f /etc/salt/minion.copy

# Start the Master and Minion
echo "Restarting the Salt-master and minion services...."
sudo service salt-master start 
sudo service salt-minion start

# Sleep to allow services to start
echo "Sleeping for minion key to be generated...."
sleep 15

# Sign the key for the Salt Master's minion
echo "Signing the Master's minion key...."
sudo salt-key -A -y

# Configure Python and Git
echo "Configuring Python for Git access...."
sudo yum -y group install "Development Tools"
sudo yum -y install epel-release
sudo yum -y install python-pip
sudo pip install gitpython

# Move all GitFS location under /etc/salt/master.d
echo "Moving master.d files into place...."
sudo cp /vagrant/files/master.d/* /etc/salt/master.d/

# Restart the Salt Master service for changes to take
echo "Restarting the Salt-master service...."
sudo service salt-master restart 

