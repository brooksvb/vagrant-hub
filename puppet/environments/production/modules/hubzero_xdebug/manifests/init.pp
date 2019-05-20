class hubzero_xdebug {
  package { 'php5-xdebug':
    ensure => present
  }

  $apache_php_ini = '/etc/php5/apache2/php.ini'

  ini_setting { 'xdebug_extension':
    ensure => present,
    path => $apache_php_ini,
    section => 'xdebug',
    setting => 'zend_extension',
    value => 'xdebug.so'
  }

  ini_setting { 'xdebug_remote_enable':
    ensure => present,
    path => $apache_php_ini,
    section => 'xdebug',
    setting => 'xdebug.remote_enable',
    value => '1'
  }

  ini_setting { 'xdebug_remote_host':
    ensure => present,
    path => $apache_php_ini,
    section => 'xdebug',
    setting => 'xdebug.remote_host',
    # This is the default gateway for Vagrant
    value => '10.0.2.2'
  }

  ini_setting { 'xdebug_remote_port':
    ensure => present,
    path => $apache_php_ini,
    section => 'xdebug',
    setting => 'xdebug.remote_port',
    value => '9000'
  }
}