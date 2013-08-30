# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config| 
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
 
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # Unable to use due to issue https://github.com/mitchellh/vagrant/issues/1777
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # Without the use of this, eZ Publish won't be able to get the site packages using Windows and Mac OS Hosts
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
  # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #  vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.


  config.vm.define :web1 do |web1_config|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web1_config.vm.network :forwarded_port, guest: 80, host: 8080
    web1_config.vm.network :forwarded_port, guest: 22, host: 8022
    web1_config.vm.box = "ezdfs1.ezp5"
    web1_config.vm.hostname = "ezdfs1.ezp5.vagrant"
    
    # Unable to use due to issue https://github.com/mitchellh/vagrant/issues/1777
    # There are errors in the configuration of this machine. Please fix
    # the following errors and try again:
    # vm:
    # * Static IPs cannot end in ".1" since that address is always
    # reserved for the router. Please use another ending.
    web1_config.vm.network :private_network, ip: "10.0.5.2"
    # Without the use of this, eZ Publish won't be able to get the site packages using Windows and Mac OS Hosts
    web1_config.vm.network :public_network
    web1_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    web1_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "base_ezdfs1_xdebug.pp"
    end
  end

  config.vm.define :web2 do |web2_config|
    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    web2_config.vm.network :forwarded_port, guest: 80, host: 8081
    web2_config.vm.network :forwarded_port, guest: 22, host: 8023
    web2_config.vm.box = "ezdfs2.ezp5"
    web2_config.vm.hostname = "ezdfs2.ezp5.vagrant"

    # Unable to use due to issue https://github.com/mitchellh/vagrant/issues/1777
    # There are errors in the configuration of this machine. Please fix
    # the following errors and try again:
    # vm:
    # * Static IPs cannot end in ".1" since that address is always
    # reserved for the router. Please use another ending.
    web2_config.vm.network :private_network, ip: "10.0.5.3"
    # Without the use of this, eZ Publish won't be able to get the site packages using Windows and Mac OS Hosts
    web2_config.vm.network :public_network    
    web2_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    web2_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "base_ezdfs2_xdebug.pp"
    end
  end

  config.vm.define :db do |db_config|
    db_config.vm.box = "db.ezp5"
    db_config.vm.hostname = "db.ezp5.vagrant"
    db_config.vm.network :forwarded_port, guest: 22, host: 8024

    # Unable to use due to issue https://github.com/mitchellh/vagrant/issues/1777
    # There are errors in the configuration of this machine. Please fix
    # the following errors and try again:
    # vm:
    # * Static IPs cannot end in ".1" since that address is always
    # reserved for the router. Please use another ending.
    db_config.vm.network :private_network, ip: "10.0.5.4"
    # Without the use of this, eZ Publish won't be able to get the site packages using Windows and Mac OS Hosts
    db_config.vm.network :public_network     
    db_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
    db_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "base_db.pp"
    end
  end
end