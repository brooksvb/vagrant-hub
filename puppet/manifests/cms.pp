
class cms {
	require packages
	require services
	require firewall

	exec { 'clone cms':
		command => 'git clone https://github.com/hubzero/hubzero-cms /var/www/dev --depth=1',
		require => Package['git']
	}

	
}
