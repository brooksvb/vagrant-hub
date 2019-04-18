
# Followed this guide to install vboxguestadditions, then need to run `vagrant reload --provision`
# @url https://www.linuxbabe.com/desktop-linux/how-to-install-virtualbox-guest-additions-on-debian-step-by-step

Vagrant.configure(2) do |config|
	config.vm.box = "debian/jessie64"
	
	config.vm.network "forwarded_port", guest: 80, host: 8080

	config.vm.synced_folder ".", "/home/vagrant/project/"
	
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
		apt-get update
		apt-get upgrade -y
		apt-get install puppet -y
	SHELL

	config.vm.provision :puppet do |puppet|
		#puppet.working_directory = "/home/vagrant/project/puppet"
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file = "init.pp"
		puppet.options = "--verbose"
	end
end

