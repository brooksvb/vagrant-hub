
class hubconfig::apache {
	require hubconfig::packages

	# Make sure default vagrant user is in www-data group
	exec { 'vagrant in www-data':
		require => Package['apache2'],
		command => '/usr/sbin/usermod -a -G www-data vagrant',
		# Test if vagrant in www-data
		unless => '/usr/bin/id -nG vagrant | grep -qw "www-data"'
	}

	# Enable modules
	define hubconfig::apache::loadmodule ($module = $title) {
		exec { "a2enmod $module" :
			# Using real a2enmod command errors saying it cannot read /etc/apache2/envvars
			cwd => '/etc/apache2/mods-enabled',
			command => "/bin/ln -s ../mods-available/${module}.load ./",
			unless => "/bin/readlink -e /etc/apache2/mods-enabled/${module}.load",
			notify => Service[apache2]	
		}
	}

	$modules = ['slotmem_shm', 'rewrite', 'ssl', 'proxy']

	hubconfig::apache::loadmodule { $modules: }

	# Set default values for following resources
	File {
		owner => 'root',
		group => 'root',
		mode => 0644 # rw for owner, r otherwise
	}

	# Disable default apache site conf
	file { 'default.conf':
		path => '/etc/apache2/sites-enabled/000-default.conf',
		ensure => absent,
		notify => Service['apache2']
	}

	file { 'hubzero.conf':
		path => '/etc/apache2/sites-available/hubzero-dev.conf',
		ensure => present,
		source => "puppet:///modules/hubconfig/apache-conf/hubzero-dev.conf",
		notify => Service['apache2']
	}
	file { 'hubzero-ssl.conf':
		path => '/etc/apache2/sites-available/hubzero-dev-ssl.conf',
		ensure => present,
		source => "puppet:///modules/hubconfig/apache-conf/hubzero-dev-ssl.conf",
		notify => Service['apache2']
	}

	# Link to hubzero conf to enable site
	file { 'hubzero.conf.link':
		require => File['hubzero.conf'],
		path => '/etc/apache2/sites-enabled/hubzero-dev.conf',
		ensure => link,
		target => '../sites-available/hubzero-dev.conf',
		notify => Service['apache2']
	}
	#file { 'hubzero-ssl.conf.link':
	#	path => '/etc/apache2/sites-enabled/hubzero-dev-ssl.conf',
	#	ensure => link,
	#	target => '../sites-available/hubzero-dev-ssl.conf',
	#	notify => Service['apache2']
	#}

}
