Puppet Chocolatey Provider Hands On Lab
==================================

## Prerequisites

 * [Vagrant 1.2.7](http://downloads.vagrantup.com/tags/v1.2.7) - I'm pretty sure you'll need the latest version (we tried 1.2.2 and it didn't work)
 * [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads) or VMWare Fusion 5
    * If you want to use VMWare Fusion you will also need the vagrant-vmware-fusion plugin for vagrant (which is not free).
 * Vagrant-Windows 1.2.0 - included here in SetupFiles directory
 * At least 20GB free on the host box.

## Setup

 1. Install/upgrade Vagrant to 1.2.7.
 1. Install/upgrade VirtualBox/VMWare to versions listed above.
 1. Install/upgrade required plugins for vagrant (if using VMWare you will need the non-free vagrant-vmware-fusion or equivalent).
 1. Install/upgrade vagrant-windows vagrant plugin. Open terminal/command line, head to the directory where the plugin is `vagrant plugin install vagrant-windows-1.2.0.gem`

## Labs

 * At any time if you need to close down a box, you can just type `vagrant halt` and then come back later.

### Lab 1 (adapted from original slides)

#### Exercise 1 - Vagrant Provisioning/Familiarization

 1. Open a command line and head into Lab1 directory.
 1. For VMWare: edit the VagrantFile to point to the second url for the vmware box instead of the virtualbox.
 1. Call `vagrant up`. For VMWare call `vagrant up --provider=vmware_fusion`.
 1. Wait for it. The first time down it is going to be copying around 2.38GB, so it could take a little while.
    * **Special Note:** This box is provided for **evaluation purposes only**. It should not be used for any production purposes or outside of the lab in general.
 1. While you are waiting, take a tour of the code. In the VagrantFile notice we call the shell provisioner (vagrant has providers and provisioners, the latter being things that can take a box from a predefined state to an end state or goal). The box we are pulling down has nothing installed aside from what is required for vagrant to work.
 1. We allow the shell provisioner (in shell/main.cmd) to install
    * .NET Framework 4.0 (which takes some time)
    * Chocolatey and the latest prerelease of Chocolatey (required for puppet provider to work properly)
    * Puppet 3.2.4
    * librarian-puppet to install/update required modules
 1. Notice the resources folder has some local packages in it.
 1. Notice the puppet/PuppetFile and the modules that it contains for Puppet.
 1. Open the puppet/manifests/site.pp in an editor. Don't edit it yet.
 1. Wait for vagrant up to finish...
 1. Once it has finished, on the host (not the box) type `vagrant ssh`.
 1. Now type `cd c:\chocolatey\lib`
 1. Type `dir`. Note that `roundhouse` is installed.
 1. Type `exit`. This should bring you out of the box.
 1. Type `vagrant reload`. This should restart the box (necesary step after installing .NET Framework). This may have issues, so you may need to type `vagrant halt` and wait for the box to finish, then `vagrant up --no-provision` to get rebooted.

#### Exercise 2 - Add Packages

 1. In the site.pp file (puppet/manifests/site.pp), please add `putty` and `warmup` packages.
 1. **Note:** You already have a good example in the `roundhouse` package.
 1. Run `vagrant provision`.
 1. On the guest box, note that these packages are installed.

#### Exercise 3 - Remove Packages

 1. In the site.pp file (puppet/manifests/site.pp), please set `roundhouse` to be removed.
 1. **Hint:** with puppet, `ensure => absent` is what you use to remove things.
 1. On the guest box, note that the package is removed from `c:\chocolatey\lib`. **Special Notice**: There was a bit of a bug on this but this is how it would work and will work once the updated module releases.

#### Exercise 4 - Create Packages

 1. With the Windows box running (call `vagrant up --no-provision` if not), please type `vagrant ssh` to access the box.
 1. Type `cd \` followed by `mkdir temp` and `cd temp`.
 1. Now type `warmup chocolatey mypkg`.
 1. Now in the windows box (GUI) please access that folder (c:\temp\mypkg) in explorer.
 1. Right click on `mypkg.nuspec` and select `Open with Notepad++`.
 1. Note all of the work that the template has already completed. 
    * Change `version` from `__REPLACE__` to `1.0.0`.
    * Set `licenseUrl` to `http://nowhere.com`
 1. Close mypkg.nuspec and go into the `tools` directory. Note the contents of the `chocolateyInstall.ps1` file.
 1. When you are done looking at `chocolateyInstall.ps1`, close and DELETE the file (we are not going to be using it for this part of the demo).
 1. Go to `C:\Chocolatey\lib\warmup.0.6.5.1\bin` folder and copy everything here to `c:\temp\mypkg\tools`.
 1. Rename `warmup.exe` to `warmup2.exe`, `warmup.pdb` to `warmup2.pdb` and `warmup.exe.config` to `warmup2.exe.config`.
 1. On the host terminal/command line (which should still be open on this folder), type `cpack`.
 1. Note that this has created `mypkg.1.0.0.nupkg` which is a nuget package (the packaging infrastructure that chocolatey uses).

#### Exercise 5 - Inspect a Package

 1. On the Windows box, open a command line ([Start] button, `run...`, `cmd`, [Enter]).
 1. Type `choco install nugetpackageexplorer`. This will install [NuGet Package Explorer](http://chocolatey.org/packages/nugetpackageexplorer) so you can inspect your just built package (or a package from somewhere else local or on a feed).
 1. When that finishes, double click on `mypkg.1.0.0.nupkg`. This should open the nuget package explorer so you can inspect the package and note its contents.
 1. When you are finished, close the inspector without saving your file.

#### Exercise 6 - Install Your Own Package

 1. In the Windows box, copy `mypkg.1.0.0.nupkg` to `c:\vagrant\resources\packages` directory.
 1. In the site.pp file (puppet/manifests/site.pp), please add this package to your manifest.
 1. Set ensure to `ensure => '1.0.0'`.
 1. Run `vagrant provision`.
 1. Note that the box now has your package installed.
 1. Type `vagrant ssh`. You should now be able to type `warmup2` and receive feedback.
 1. Type `exit` to exit from the box.

#### Exercise 7 - Update A Package

 1. On the Windows box, open `c:\temp\mypkg\mypkg.nuspec` in an editor.
 1. Change `version` to `1.1.0`.
 1. Save and close the file.
 1. On the command line (with this folder as the working directory) type `cpack`.
 1. Copy the resulting `mypkg.1.1.0.nupkg` file to `c:\vagrant\resources\packages` directory.
 1. On the host box, please run `vagrant provision`. Note that nothing is changed.
 1. On the guest box, note that a new version has not been installed. This is because we told puppet we wanted 1.0.0 installed.
 1. In the site.pp file (puppet/manifests/site.pp) please set mypkg to `ensure => latest`. Save the file.
 1. Run `vagrant provision`. Note that we get a note that the package was updated from 1.0.0 to 1.1.0. 
 1. On the guest box, note that a new version has been installed in `c:\chocolatey\lib`.
