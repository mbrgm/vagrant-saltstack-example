# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #===================
  # Package cache
  #===================

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  
  #================
  # Networking
  #================

  config.vm.network :private_network, type: "dhcp"

  config.hostmanager.enabled = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if vm.id
      `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
    end
  end
  config.vm.provision :hostmanager

  
  #==============
  # Machines
  #==============
  
  # Set array of hostnames
  minions = [ 'minion1' ]

  #-----------------
  # Salt master
  #-----------------

  config.vm.define "master1" do |node|

    node.vm.box      = "ubuntu-14.10-server-64"
    node.vm.hostname = "master1"
    node.hostmanager.aliases = %w(salt)

    node.vm.synced_folder "./salt/roots/salt", "/srv/salt"

    node.vm.provision :salt do |salt|

      salt.install_master = true

      master_keys_hash = { "master1" => "./salt/keys/master1/minion.pub" }
      minion_keys_hash = Hash[minions.map{
        |hostname| [hostname, "./salt/keys/#{hostname}/minion.pub"]
      }]

      salt.seed_master = master_keys_hash.merge(minion_keys_hash)

      salt.minion_key = "./salt/keys/master1/minion.pem"
      salt.minion_pub = "./salt/keys/master1/minion.pub"

    end

  end

  
  #------------------
  # Salt minions
  #------------------

  # Create a machine for each hostname
  minions.each do |hostname|
    config.vm.define hostname do |node|

      node.vm.box      = "ubuntu-14.10-server-64"
      node.vm.hostname = hostname 

      node.vm.provision :salt do |salt|
        salt.minion_key = "./salt/keys/#{hostname}/minion.pem"
        salt.minion_pub = "./salt/keys/#{hostname}/minion.pub"
      end

    end
  end

end
