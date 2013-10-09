# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV['BOX_NAME'] || "ubuntu"
BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64.box"
VF_BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64_vmware_fusion.box"
AWS_REGION = ENV['AWS_REGION'] || "us-east-1"
AWS_AMI    = ENV['AWS_AMI'] || "ami-d0f89fb9"
INITIAL_RUN = ENV['INITIAL_RUN']

Vagrant.configure("2") do |config|
    # Setup virtual machine box. This VM configuration code is always executed.
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI

    config.vm.provision "puppet" do |puppet|
        puppet.module_path = "modules"
    end

    if INITIAL_RUN.nil?
        config.vm.provision :shell, :inline => "rm -rf /home/vagrant/docker"
        config.vm.provision :shell, :inline => "cp -rf /vagrant/docker /home/vagrant/"
        config.vm.provision :shell, :inline => "bash /home/vagrant/docker/start-tc.sh"
    end

    config.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
        aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
        aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]
        override.ssh.private_key_path = ENV["AWS_SSH_PRIVKEY"]
        override.ssh.username = "ubuntu"
        aws.region = AWS_REGION
        aws.ami    = AWS_AMI
        aws.instance_type = "t1.micro"
    end

    config.vm.provider :rackspace do |rs|
        config.ssh.private_key_path = ENV["RS_PRIVATE_KEY"]
        rs.username = ENV["RS_USERNAME"]
        rs.api_key  = ENV["RS_API_KEY"]
        rs.public_key_path = ENV["RS_PUBLIC_KEY"]
        rs.flavor   = /512MB/
        rs.image    = /Ubuntu/
    end

    config.vm.provider :vmware_fusion do |f, override|
        override.vm.box = BOX_NAME
        override.vm.box_url = VF_BOX_URI
        override.vm.synced_folder ".", "/vagrant", disabled: true
        f.vmx["displayName"] = "docker"
    end

    config.vm.provider :virtualbox do |vb|
        config.vm.box = BOX_NAME
        config.vm.box_url = BOX_URI
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    # Forward TeamCity Server port
    config.vm.network :forwarded_port, :host => 8111, :guest => 8111
end
