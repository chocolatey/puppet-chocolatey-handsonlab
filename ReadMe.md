PuppetConf Chocolatey Hands On Lab
==================================

## Prerequisites

 * [Vagrant 1.2.7](http://downloads.vagrantup.com/tags/v1.2.7) - I'm pretty sure you'll need the latest version (we tried 1.2.2 and it didn't work)
 * [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads) or VMWare Fusion 5
    * If you want to use VMWare Fusion you will also need the vagrant-vmware-fusion plugin for vagrant (which is not free).
 * Vagrant-Windows 1.2.0 - included here in SetupFiles directory


## Setup

 1. Install/upgrade Vagrant to 1.2.7.
 1. Install/upgrade VirtualBox/VMWare to versions listed above.
 1. Install/upgrade required plugins for vagrant (if using VMWare you will need the non-free vagrant-vmware-fusion or equivalent).
 1. Install/upgrade vagrant-windows vagrant plugin. Open terminal/command line, head to the directory where the plugin is `vagrant plugin install vagrant-windows-1.2.0.gem`

## Labs

### Lab 1

 1. Open a command line and head into Lab1 directory.
 1. For VMWare: edit the VagrantFile to point to the second url for the vmware box instead of the virtualbox.
 1. Call `vagrant up`. For VMWare call `vagrant up --provider=vmware_fusion`.
 1. Wait for it. The first time down it is going to be copying around 2.38GB, so it could take a little while.
 1. While you are waiting, take a tour of the code. In the VagrantFile notice we call the shell provisioner (vagrant has providers and provisioners, the latter being things that can take a box from a predefined state to an end state or goal). The box we are pulling down has nothing installed aside from what is required for vagrant to work.
 1. Notice the resources folder has some local packages in it.
 1. Notice the puppet/PuppetFile and the modules that it contains for Puppet.
 1. Open the puppet/manifests/site.pp in an editor. Don't edit it yet.
 1. Wait for vagrant up to finish...