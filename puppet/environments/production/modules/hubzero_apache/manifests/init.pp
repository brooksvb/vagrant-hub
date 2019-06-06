class hubzero_apache {

	package { 'apache2':
			ensure => installed
	}

	service { 'apache2':
			require => Package['apache2'],
			ensure => running,
			enable => true
	}

	# Make sure default vagrant user is in www-data group
	exec { 'vagrant in www-data':
		require => Package['apache2'],
		command => '/usr/sbin/usermod -a -G www-data vagrant',
		# Test if vagrant in www-data
		unless => '/usr/bin/id -nG vagrant | grep -qw "www-data"'
	}

	# mpm_event needs to be disabled before enabling mpm_prefork
	# There is no particular reason to use mpm_prefork besides that mpm_event was causing issues
	# with php and apache wouldn't start
	file {'mpm_event.load':
		path => '/etc/apache2/mods-enabled/mpm_event.load',
		ensure => absent,
		notify => Service['apache2']
	}

	# Enable modules
	define loadmodule ($module = $title) {
		exec { "a2enmod $module" :
			# Using real a2enmod command errors saying it cannot read /etc/apache2/envvars
			cwd => '/etc/apache2/mods-enabled',
			command => "/bin/ln -s ../mods-available/${module}.load ./",
			unless => "/bin/readlink -e /etc/apache2/mods-enabled/${module}.load",
			notify => Service['apache2']
		}
	}

	$modules = ['slotmem_shm', 'rewrite', 'ssl', 'proxy', 'socache_shmcb', 'mpm_prefork']

	hubzero_apache::loadmodule { $modules: }

	# Set default values for following resources
	File {
		owner => 'root',
		group => 'root',
		mode => '0644' # rw for owner, r otherwise
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
		source => 'puppet:///modules/hubzero_apache/hubzero-dev.conf',
		notify => Service['apache2']
	}
	file { 'hubzero-ssl.conf':
		path => '/etc/apache2/sites-available/hubzero-dev-ssl.conf',
		ensure => present,
		source => 'puppet:///modules/hubzero_apache/hubzero-dev-ssl.conf',
		notify => Service['apache2']
	}

	# Link to hubzero conf to enable site
	#file { 'hubzero.conf.link':
	#	require => File['hubzero.conf'],
	#	path => '/etc/apache2/sites-enabled/hubzero-dev.conf',
	#	ensure => link,
	#	target => '../sites-available/hubzero-dev.conf',
	#	notify => Service['apache2']
	#}
	file { 'hubzero-ssl.conf.link':
		path => '/etc/apache2/sites-enabled/hubzero-dev-ssl.conf',
		ensure => link,
		target => '../sites-available/hubzero-dev-ssl.conf',
		notify => Service['apache2']
	}

}