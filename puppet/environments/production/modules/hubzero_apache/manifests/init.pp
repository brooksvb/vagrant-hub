class hubzero_apache {

	# Make sure default vagrant user is in www-data group
	exec { 'vagrant user in www-data':
		require => Class['apache'],
		command => '/usr/sbin/usermod -a -G www-data vagrant',
		# Test if vagrant in www-data
		unless => '/usr/bin/id -nG vagrant | grep -qw "www-data"'
	}
	#, 'mpm_prefork'
	$included_modules = ['rewrite', 'ssl', 'proxy']
	$other_modules = ['slotmem_shm', 'socache_shmcb']

	class { 'apache':
		default_vhost     => false,
		default_ssl_vhost => false,
	}

	$included_modules.each |String $mod| {
		class { "apache::mod::$mod": }
	}

	define loadmodule ($module = $title) {
		exec { "a2enmod $module" :
			# Using real a2enmod command errors saying it cannot read /etc/apache2/envvars
			cwd => '/etc/apache2/mods-enabled',
			command => "/bin/ln -s ../mods-available/${module}.load ./",
			unless => "/bin/readlink -e /etc/apache2/mods-enabled/${module}.load",
			notify => Service[apache2]
		}
	}

	hubzero_apache::loadmodule { $other_modules: }

	apache::vhost::custom { 'hubzero_ssl':
		content => 'puppet:///modules/hubzero_apache/hubzero-dev-ssl.conf',
		verify_config => true,
	}

}