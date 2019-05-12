
Vagrant.configure(2) do |config|
	#config.vm.box = "debian/jessie64"
	# Using Vagrant officially recommended bento boxes
	config.vm.box = "bento/debian-8.11"
	
	#config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.network "forwarded_port", guest: 443, host: 8080

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
			cd /tmp
			wget https://apt.puppetlabs.com/puppet5-release-jessie.deb
            dpkg -i puppet5-release-jessie.deb
            rm puppet5-release-jessie.deb

            apt-get update
            apt-get upgrade -y
            apt-get install puppet-agent -y

            # Add link to bin
            ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin
		fi
	SHELL

	config.vm.provision :puppet do |puppet|
		puppet.environment_path = "puppet/environments"
		puppet.environment = "production"
		puppet.module_path = ["puppet/environments/production/modules","puppet/forge_modules"]
		puppet.options = "--verbose"
	end
end

