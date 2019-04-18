
class services {
	require packages

	service { 'apache2':
		ensure => running,
		enable => true
	}

	service { 'mysqld':
		ensure => running,
		enable => true
	}
}
