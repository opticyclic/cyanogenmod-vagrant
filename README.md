#Galaxy Nexus Build Environment For CyanogenMod Custom ROMs

This is an Ubuntu based VM with all the necessary dependencies to build a custom Android ROM. 
On first start it will clone the relevant git repositories to build CyanogenMod for Galaxy Nexus.

For more info on the build steps that this is automating for you see the [CyanogenMod wiki].

## Requirements

* The host machine needs at least 4 GB of RAM <sup>[1](#footnote1)</sup>.
* You need to have [Vagrant] installed <sup>[2](#footnote2)</sup>. ~100 MB Download
* You need to have a minimum of [VirtualBox 5] installed <sup>[3](#footnote3)</sup>. ~100 MB Download
* You can optionally install [Graphviz] to visualise the dependencies of the puppet files. After running vagrant up you will find the dot files in the .vagrant/graphs directory
* The first run will download an Ubuntu Server 14.04 base box. ~320 MB

<sub>
<a name="footnote1">1</a>: If you only have 4GB of RAM you need to modify this line in the Vagrantfile to 2750 `vb.customize ["modifyvm", :id, "--memory", "4096"]`
<br/>
<a name="footnote2">2</a>: You need at least Vagrant version 1.8.5 or you will hit this [vagrant issue]
<br/>
<a name="footnote3">3</a>: Earlier versions of Virtualbox wont work due to the vagrant plugin that creates the extra disk
</sub>

## Installation

* Clone the repo (or download as zip from GitHub)
 
        git clone git@github.com:opticyclic/cyanogenmod-vagrant.git
        cd cyanogenmod-vagrant

* Install [VirtualBox 5]:

* Install [Vagrant]:

* Install vbguest plugin for Vagrant:

        vagrant plugin install vagrant-vbguest

* Install vagrant-cachier plugin for Vagrant (this caches the apt-get update packages to save bandwidth and allows offline development):

        vagrant plugin install vagrant-cachier --plugin-version 0.5.1

* Install vagrant-persistent-storage vagrant plugin for Vagrant (this creates and mounts an extra disk as the base box doesn't have enough space):

        vagrant plugin install vagrant-persistent-storage
		
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

## Errors

If you are on Windows 10 with Git Bash you might get the following error:

    The box 'ubuntu/trusty64' could not be found or
    could not be accessed in the remote catalog. If this is a private
    box on HashiCorp's Atlas, please verify you're logged in via
    `vagrant login`. Also, please double-check the name. The expanded
    URL and error message are shown below:
    
    URL: ["https://atlas.hashicorp.com/ubuntu/trusty64"]
    Error:

The way to fix it is to copy curl from your git bash dir to the vagrant dir.

    mv /c/HashiCorp/Vagrant/embedded/bin/curl.exe /c/HashiCorp/Vagrant/embedded/bin/curl.exe.bak
    cp /mingw64/bin/curl.exe /c/HashiCorp/Vagrant/embedded/bin/curl.exe

#Acknowledgements
Thanks to the efforts of [CyanogenModBuildEnv] that got me going.




[CyanogenModBuildEnv]: https://github.com/farproc/CyanogenModBuildEnv

[CyanogenMod wiki]: http://wiki.cyanogenmod.org/w/Build_for_maguro#Initialize_the_CyanogenMod_source_repository

[duplicate]: https://help.github.com/articles/duplicating-a-repository/

[Graphviz]: http://www.graphviz.org/Download.php

[Puppet]: http://puppetlabs.com/

[Vagrant]: http://www.vagrantup.com/

[vagrant issue]: https://github.com/mitchellh/vagrant/issues/5572

[VirtualBox 5]: https://www.virtualbox.org/wiki/downloads/

[Xming]: http://www.straightrunning.com/XmingNotes/
