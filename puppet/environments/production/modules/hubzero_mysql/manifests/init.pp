class hubzero_mysql {
	# $packages = [
	#     'mysql-server', 'mysql-client'
	# ]
  #
	# package { $packages:
  #       		ensure => 'installed'
  #   }
  #
  # service { 'mysql':
  #     require => Package['mysql-server'],
  #     ensure => running,
  #     enable => true
  # }
  class { '::mysql::server':
    root_password           => '',
    remove_default_accounts => true
  }

  mysql::db { 'exampledb':
    user     => 'example',
    password => 'YMx7ZE35jw45f9',
    host     => 'localhost',
    grant    => ['ALL'],
    sql => "puppet:///modules/hubzero_mysql/seed.sql"
  }

}