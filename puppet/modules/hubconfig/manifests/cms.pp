
class hubconfig::cms {
	require hubconfig::packages
	require hubconfig::services
	require hubconfig::firewall

	file { '/var/www/dev':
		ensure => directory,
		owner => 'www-data',
		group => 'www-data',
		mode => '2664', # setgid rw rw r

		# Too slow VVV
		#recurse => true # Recursively apply file attributes
	}

	$breadcrumb = '/etc/.hubzero_cms_first_time_setup' # path to breadcrumb
	
	exec { 'clone cms':
		before => File["${breadcrumb}"],
		path => '/usr/bin/',
		command => 'git clone https://github.com/hubzero/hubzero-cms /var/www/dev --depth=1',
		creates => "${breadcrumb}", # This makes the command only run if this file doesn't exist
		require => Package['git']
	}	

	# Directly executing the command once seems faster than recursive puppet file resource
	exec { 'chmod /var/www/dev':
		require => Exec['clone cms'],
		command => '/bin/chmod 2664 /var/www/dev -R',
		creates => "${breadcrumb}"
	}

	exec { 'cms root password': 
		before => File["${breadcrumb}"], # Ensure this runs before breadcrumb is created
		command => "/usr/bin/mysqladmin -u root -h localhost password '94B5FQN3fW8qZ4'",
		creates => "${breadcrumb}" # Don't run if breadcrumb exists
	}

	exec { 'mysql database create': 
		before => File["${breadcrumb}"],
		command => "/usr/bin/mysql -u root -p94B5FQN3fW8qZ4 --execute=\"
			CREATE USER 'example'@'localhost' IDENTIFIED BY 'YMx7ZE35jw45f9';
			GRANT ALL PRIVILEGES ON example.* TO 'example'@'localhost';
			CREATE DATABASE example;
			\"
		",
		creates => "${breadcrumb}"
	}

	exec { 'composer setup':
		before => File["${breadcrumb}"],
		require => Exec['clone cms'],
		cwd => '/var/www/dev/core',
		command => '/usr/bin/php5 ./bin/composer config -g github-oauth.github.com \
				1494e134d21100c55fcd4f0f65bf07b2e551e745 && \
				/usr/bin/php5 ./bin/composer update',
		creates => "${breadcrumb}"
	}

	exec { 'composer install':
		before => File["${breadcrumb}"],
		require => Exec['clone cms'],
		cwd => '/var/www/dev/core',
		command => '/usr/bin/php5 ./bin/composer require firebase/php-jwt',
		creates => "${breadcrumb}"
	}

	exec { 'muse setup':
		before => File["${breadcrumb}"],
		require => Exec['clone cms'],
		cwd => '/var/www/dev',
		command => '/usr/bin/php5 ./muse migration -i -f',
		creates => "${breadcrumb}"
	}

	# Leave breadcrumb to indicate first-time setup is done
	file { "${breadcrumb}":
		path => "${breadcrumb}",
		ensure => present,
		owner => 'root',
		group => 'root',
		mode => '0111'
	}
}
