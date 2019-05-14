
class hubconfig::packages {

	exec { 'apt-get update':
		command => '/usr/bin/apt-get update',
		# Allow for 100 return if some index files fail to download
		returns => [0, 100]
	}

	$packages = [
		'apache2', 'php5', 'php5-curl', 
		'php5-mysql', 'php5-gd', 'mysql-server', 
		'mysql-client', 'git', 'vim'
	]

	package { $packages:
		ensure => 'installed',
		require => Exec['apt-get update']
	}
}
