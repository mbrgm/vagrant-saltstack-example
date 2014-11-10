# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.hostmanager.enabled = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    if vm.id
      `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
    end
  end
  config.vm.provision :hostmanager

  config.vm.network :private_network, type: "dhcp"


  config.vm.define "master1" do |node|

    node.vm.box      = "ubuntu-14.10-server-64"
    node.vm.hostname = "master1"
    node.hostmanager.aliases = %w(salt)

    node.vm.synced_folder "./salt/roots/salt", "/srv/salt"

    node.vm.provision :salt do |salt|

      salt.install_master = true
      salt.seed_master = {
        "master1" => "./salt/keys/master1/minion.pub",
        "minion1" => "./salt/keys/minion1/minion.pub"
      }

      salt.minion_key = "./salt/keys/master1/minion.pem"
      salt.minion_pub = "./salt/keys/master1/minion.pub"

    end

  end


  config.vm.define "minion1" do |node|

    node.vm.box      = "ubuntu-14.10-server-64"
    node.vm.hostname = "minion1"

    node.vm.provision :salt do |salt|
      salt.minion_key = "./salt/keys/minion1/minion.pem"
      salt.minion_pub = "./salt/keys/minion1/minion.pub"
    end

  end

end
