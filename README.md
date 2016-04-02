#Galaxy Nexus Build Environment For CyanogenMod Custom ROMs

This is an Ubuntu based VM with all the necessary dependencies to build a custom Android ROM. 
On first start it will clone the relevant git repositories to build CyanogenMod for Galaxy Nexus.

For more info on the build steps that this is automating for you see the [CyanogenMod wiki].

## Requirements

* The host machine needs at least 4 GB of RAM.
* You need to have [Vagrant] installed. ~100 MB Download
* You need to have [VirtualBox] installed. ~100 MB Download
* You can optionally install [Graphviz] to visualise the dependencies of the puppet files. After running vagrant up you will find the dot files in the .vagrant/graphs directory
* The first run will download an Ubuntu Server 14.04 base box. ~320 MB

## Installation

* Clone the repo (or download as zip from GitHub)
 
        git clone git@github.com:opticyclic/cyanogenmod-vagrant.git
        cd cyanogenmod-vagrant

* Install [VirtualBox]:

* Install [Vagrant]:

* Install vbguest plugin for Vagrant:

        vagrant plugin install vagrant-vbguest

* Install vagrant-cachier plugin for Vagrant (this caches the apt-get update packages to save bandwidth and allows offline development):

        vagrant plugin install vagrant-cachier --plugin-version 0.5.1

* Start VirtualBox

* Run `vagrant up` from the base directory of this project. 

##Forwarding adb

It is possible to run an adb server on your host and forward that to the VM.

On the VM make sure the server isn't already running.

    adb kill-server

Then on the host

    adb devices # you should see your device
    vagrant ssh -- -nNR127.0.0.1:5037:127.0.0.1:5037

Now back on the VM you should be able to run adb commands and connect to your phone as you normally would from your host.

## Using A GUI
If you want to launch any GUI applications on the Vagrant box then you need to do the following:

* Install [Xming] on Windows 
* Use putty to connect instead of vagrant ssh
  * 127.0.0.1 2222
  * Connection - Data - Auto-Login Username = vagrant
  * Connection - SSH - X11 - Enable X11 Forwarding 
  * Session - Give it a name - Save
  * Open - password vagrant
* Once logged in, you need to execute the following commands in order to forward as the buildbot user as well as the vagrant user
  * xauth list
  * copy the last line
  * sudo su - buildbot
  * xauth add {paste the last line}
  * Run Xlaunch from desktop, use default settings	


#Acknowledgements
Thanks to the efforts of [CyanogenModBuildEnv] that got me going.




[CyanogenModBuildEnv]: https://github.com/farproc/CyanogenModBuildEnv

[CyanogenMod wiki]: http://wiki.cyanogenmod.org/w/Build_for_maguro#Initialize_the_CyanogenMod_source_repository

[duplicate]: https://help.github.com/articles/duplicating-a-repository/

[Graphviz]: http://www.graphviz.org/Download.php

[Puppet]: http://puppetlabs.com/

[Vagrant]: http://www.vagrantup.com/

[VirtualBox]: https://www.virtualbox.org/wiki/downloads/

[Xming]: http://www.straightrunning.com/XmingNotes/

