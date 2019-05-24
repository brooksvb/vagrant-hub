class hubzero_xdebug {
  #require Service[apache2]
  #require Package[php5]

  package { 'php5-xdebug':
    ensure => present
  }

  #$apache_php_ini = '/etc/php5/apache2/php.ini'
  $php_conf_xdebug_ini = '/etc/php5/cli/conf.d/20-xdebug.ini'

  $defaults = {
    'ensure' => present,
    'path' => $php_conf_xdebug_ini,
    'notify' => Service[apache2]
  }
  $xdebug_section = {
    '' => {
      'zend_extension' => 'xdebug.so',
      'xdebug.remote_enable' => '1',
      # This is the default gateway for Vagrant
      'xdebug.remote_host' => '10.0.2.2',
      'xdebug.remote_port' => '9000'
    }
  }
  create_ini_settings($xdebug_section, $defaults)

}