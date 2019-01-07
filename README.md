# Demo-VB-Salt-Compliance

This repo spins up a Salt Master-Minion environment, within VirtualBox via Vagrant.

The repo:
 * creates a Salt Master instance on Centos 7
 * creates a Salt Minion instance on Centos 7
 * will sign the minion key on both the Master and Minion so that the Salt stack is ready for immediate use
 * install the `Development Tools` group (which includes git), and `gitpython` (and its pre-requisites) on the Salt Master
 * configures access to the Hubblestack GitHub repo by a gitfs_remotes statement (see /etc/salt/master.d/hubblestack.conf)
 * syncs the module to enable minion access

## Background

SaltStack utilises an opensource solution called HubbleStack (see https://hubblestack.io/) to provide compliance reviews against the minions. The HubbleStack code utilises Python to create Salt state files. The reviews are against profiles for CIS and CVE known issues sourced from Adobe. Output, by default, is standard out, however modules exist to report (`Quasar`) to `Slack`, `Splunk` or home-grown dashboards, monitor filesystems (`Pulsar`) via beacons, reporting to `Quasar` destinations, or to enable auditing (`Nebula`) via a data repository.

This demo sources the HubblesStack code from the site's public GitHub repo, and uses the default profiles. It is however possible to source the code to a `file_root` and create additional profiles, as required.

## Demo Setup

This demo utilises `VirtualBox` and `Vagrant` to build and provision the environment. This software will need to be installed and configured before the demo can be run. The ability to 'sync' the present working folder, and download software over the Internet, requires that the Vagrant plug-ins - `vagrant-share`, `vagrant-vbguest` and `vagrant-proxyconf` have already been installed (use: `vagrant plugin install <plugin>` in install as required). The setup script checks for these plug-ins and that Vagrant is version 1.9.2, or above (required to resolve a private network interface issue with RH Linux versions).

This repo provides the `Vagrantfile` and provisioning scripts required. The environment needs to know the FQDN/IP addresses for each server, and this is controlled via the `Vagrantfile`, provisioning scripts, and a file called `hostsfile`. The repo at present has the domain hard coded to `americas.hpqcorp.net` - change this in the `Vagrantfile` and `hostsfile` accordingly, but all are on a private network.


**Setup the environment**

    1. `Git clone` this GitHub repo.
    2. Change directory into the `Demo_VB_Salt-Compliance` folder
    3. Run the command: `./setup_demo.sh`
Note: the setup takes about 10-15 minutes to configure, expect some additional time if the Centos 7.3 image needs to be initially downloaded (or the Vagrant GuestAdditions do not match).

## Script

Once the module has been successfully sync'ed to the minions, the `Hubblestack` compliance states are available. To execute a full compliance review via the rules within the `Hubblestack` GitHub repo, run `salt \saltminion* hubble.top`. To review, what is being reviewed for in the profiles, run `salt \saltminion* hubble.audit verbose=True`.

For more defined options, see https://github.com/hubblestack/hubble-salt#usage for more details.
