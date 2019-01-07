#!/bin/bash

# Test that Vagrant version is greater than 1.9.1
VERSION=`vagrant --version | cut -f2 -d" " | tr -d "."`

if test $VERSION -lt 192
then
   echo "Version of Vagrant needs to be 1.9.2 or greater!!!"
   echo "Exiting...."
   exit 99

fi

# Test to ensure that Vagrant plugins are available
echo "#### Checking that required Vagrant plugins are installed. ####"
vagrant plugin list | grep vagrant-vbguest
GUEST=`echo $?`
vagrant plugin list | grep vagrant-share
SHARE=`echo $?`
vagrant plugin list | grep vagrant-proxyconf
PROXYCONF=`echo $?`

TOTAL=`expr $GUEST + $SHARE + $PROXYCONF`

if test $TOTAL -gt 0
then
   echo "#### Missing Vagrant plugins, ensure vagrant-vbguest and vagrant-share are installed...."
   exit 2
fi

# Spin up Salt Master
echo "#### Bringing up Salt Master ####"
vagrant up saltmaster

# Spin up initial Salt minion box
echo "#### Bringing up initial Salt minion ####"
vagrant up saltminion

# Sign the Salt minion cert on Salt Master
echo "#### Signing Salt minion cert on Salt Master ####"
vagrant ssh saltmaster -c 'sudo /usr/bin/salt-key -A -y'

# Sleep for minion 
sleep 15

# Sync the modules with the minions - require if highstate is not performed
echo "#### Sync the modules with the Salt minions ####"
vagrant ssh saltmaster -c 'sudo /usr/bin/salt '*' saltutil.sync_all'
