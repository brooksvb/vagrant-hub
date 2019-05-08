class hubzero-cms-setup {
	file { '/var/www/dev':
		ensure => directory,
		owner => 'www-data',
		group => 'www-data',
		mode => '2664', # setgid rw rw r

		# Too slow VVV
		#recurse => true # Recursively apply file attributes
	}

	$breadcrumb = '/etc/.hubzero_cms_first_time_setup' # path to breadcrumb
	$repo_clone_breadcrumb = '/etc/.hubzero_clone_first_time_setup'

	exec { 'clone cms':
		require => [Package['git'], File['/var/www/dev']],
		before => [File["${repo_clone_breadcrumb}"], File["${breadcrumb}"]],
		path => '/usr/bin/',
		command => 'git clone https://github.com/hubzero/hubzero-cms /var/www/dev --depth=1',

		# This makes the command only run if this file doesn't exist
		creates => ["${repo_clone_breadcrumb}", "${breadcrumb}"],
	}

	file { "${repo_clone_breadcrumb}":
		path => "${repo_clone_breadcrumb}",
		ensure => present,
		owner => 'root',
		group => 'root',
		mode => '0111'
	}

	file { 'default app conf':
		require => Exec['clone cms'],
		before => File["${breadcrumb}"],
		path => '/var/www/dev/app/config/',
		source => 'puppet:///modules/hubconfig/cms-conf',
		group => 'www-data',

		# Recurse will make this directory mirror the whole source directory
		recurse => true,
		recurselimit => 1
	}

	# Directly executing the command once seems faster than recursive puppet file resource
	# Only apply to files
	exec { 'file chown /var/www/dev':
		require => Exec['clone cms'],
		command => '/usr/bin/find /var/www/dev -type f -print0 | \
			/usr/bin/xargs -0 /bin/chmod 0664',
		creates => "${breadcrumb}"
	}

	# Only apply to dirs
	exec { 'dir chown /var/www/dev':
		require => Exec['clone cms'],
		command => '/usr/bin/find /var/www/dev -type d -print0 | \
			/usr/bin/xargs -0 /bin/chmod 2774',
		creates => "${breadcrumb}"
	}

	exec { 'composer setup':
		before => File["${breadcrumb}"],
		require => Exec['clone cms'],
		cwd => '/var/www/dev/core',
		# This env var is needed for composer run
		environment => ['COMPOSER_HOME=/home/vagrant'],
		# Need to add a github key for future composer commands to not fail
		command => '/usr/bin/php5 ./bin/composer config -g github-oauth.github.com \
				1494e134d21100c55fcd4f0f65bf07b2e551e745',
		creates => "${breadcrumb}"
	}

	exec { 'composer install':
		before => File["${breadcrumb}"],
		require => Exec['clone cms'],
		cwd => '/var/www/dev/core',
		environment => ['COMPOSER_HOME=/home/vagrant'],
		# TODO: The current HZ repo composer.lock is invalid and update is needed.
		# This shouldn't be the case; cloning and running "install" should be what
		# is necessary to get running.
		command => '/usr/bin/php5 ./bin/composer update',
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
