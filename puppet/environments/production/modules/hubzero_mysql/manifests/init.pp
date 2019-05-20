class hubzero_mysql {

  class { '::mysql::server':
    root_password           => '',
    remove_default_accounts => true
  }

  # Copy the seed sql to the machine because mysql::db sql param doesn't support puppet URI
  file { 'hubzero_seed.sql':
    path => '/etc/mysql/hubzero_seed.sql',
    ensure => present,
    source => 'puppet:///modules/hubzero_mysql/seed.sql'
  }

  mysql::db { 'exampledb':
    require => File['hubzero_seed.sql'],
    user     => 'example',
    password => 'YMx7ZE35jw45f9',
    host     => 'localhost',
    grant    => ['ALL'],
    sql => "/etc/mysql/hubzero_seed.sql"
  }

  exec { 'muse setup':
    require => [Exec['clone cms'], Mysql::Db['exampledb']],
    cwd => '/var/www/dev',
    command => '/usr/bin/php5 ./muse migration -i -f',
  }

}