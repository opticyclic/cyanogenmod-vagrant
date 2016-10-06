Vagrant.require_version ">= 1.4.0"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "buildenv"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  
  config.vm.provider :virtualbox do |vb|
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    # Work around OS X 10.10 host networking slowdowns
    # https://github.com/coreos/coreos-vagrant/issues/124#issuecomment-49481032
    vb.auto_nat_dns_proxy = false
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end

  # Cache apt packages on the host to save bandwidth
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  else
    error = "\n"
    error += "############################################## \n"
    error += "  vagrant-cachier is not installed. \n"
    error += "  Install it with: \n"
    error += "    vagrant plugin install vagrant-cachier --plugin-version 0.5.1 \n"
    error += "##############################################"
    raise error
  end

  # In order to clone and compile we need more space than the base box has
  if Vagrant.has_plugin?("vagrant-persistent-storage")
    config.persistent_storage.enabled = true
    config.persistent_storage.location = 'disk.vdi'
    config.persistent_storage.size = 60000
    config.persistent_storage.mountname = 'android'
    config.persistent_storage.filesystem = 'ext4'
    config.persistent_storage.mountpoint = '/home/buildbot/android'
    config.persistent_storage.use_lvm = false
  else
    error = "\n"
    error += "############################################## \n"
    error += "  vagrant-persistent-storage is not installed. \n"
    error += "  Install it with: \n"
    error += "    vagrant plugin install vagrant-persistent-storage \n"
    error += "##############################################"
    raise error 
  end
  
  # Mount a directory for saving the puppet graphs to help visualise the dependencies
  config.vm.synced_folder ".vagrant/graphs/", "/home/vagrant/graphs", create: true

  # Mount a directory for install files
  config.vm.synced_folder "installers/", "/tmp/installers/", create: true
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = ['--verbose', '--debug', '--trace', '--graph', '--graphdir ./graphs']
  end  

end
