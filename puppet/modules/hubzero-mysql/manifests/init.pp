class hubzero-mysql {
	$packages = [
	    'mysql-server', 'mysql-client'
	]

	package { $packages:
        		ensure => 'installed'
    }

    service { 'mysql':
        require => Package['mysql-server'],
        ensure => running,
        enable => true
    }
}