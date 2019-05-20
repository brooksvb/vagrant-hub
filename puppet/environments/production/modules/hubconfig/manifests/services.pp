
class hubconfig::services {
	require hubconfig::packages

	service { 'apache2':
		ensure => running,
		enable => true
	}

	service { 'mysql':
		ensure => running,
		enable => true
	}
}
