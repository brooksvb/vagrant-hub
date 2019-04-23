
class hubconfig::cms {
	require hubconfig::packages
	require hubconfig::services
	require hubconfig::firewall

	exec { 'clone cms':
		path => '/usr/bin/',
		command => 'git clone https://github.com/hubzero/hubzero-cms /var/www/dev --depth=1',
		creates => '/var/www/dev', # This makes the command only run if this file doesn't exist
		require => Package['git']
	}

	
}
