
# Followed this guide to install vboxguestadditions, then need to run `vagrant reload --provision`
# @url https://www.linuxbabe.com/desktop-linux/how-to-install-virtualbox-guest-additions-on-debian-step-by-step

Vagrant.configure(2) do |config|
	#config.vm.box = "debian/jessie64"
	# Using Vagrant officially recommended bento boxes
	config.vm.box = "bento/debian-8.11"
	
	config.vm.network "forwarded_port", guest: 80, host: 8080

	# This is a default synced folder
	#config.vm.synced_folder ".", "/vagrant/"
	
	# Settings for virtualbox provider
	config.vm.provider "virtualbox" do |vb|
		# Don't display GUI
		vb.gui = false

		# Set memory and cpu limit
		vb.memory = "2048"
		vb.cpus = "2"
	end

	# Ensure puppet is installed on guest machine
	config.vm.provision "shell", inline: <<-SHELL
		# Everything here is sudo-ed
		# Don't run apt-get updates and upgrade unless necessary
		if ! [ -x "$(command -v puppet)" ]; then
			echo 'Puppet not installed, installing...' >&2
			apt-get update
			apt-get upgrade -y
			apt-get install puppet -y
		fi
	SHELL

	config.vm.provision :puppet do |puppet|
		#puppet.working_directory = "/home/vagrant/project/puppet"
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file = "site.pp"
		puppet.module_path = "puppet/modules"
		puppet.options = "--verbose"
	end
end

