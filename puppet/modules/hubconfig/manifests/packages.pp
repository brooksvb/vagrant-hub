
class hubconfig::packages {

	exec { 'apt-get update':
		command => '/usr/bin/apt-get update'
	}

	$packages = ['apache2', 'php5', 'php5-curl', 'php5-mysql', 'mysql-server', 'mysql-client', 'git', 'vim']

	package { $packages:
		ensure => 'installed',
		require => Exec['apt-get update']
	}
}
