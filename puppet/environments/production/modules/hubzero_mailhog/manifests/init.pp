class hubzero_mailhog {
  # Path for go package installs, not for base go installation
  $gopath = '/usr/local/go-pkg';
  $gocache = '/tmp/go/cache';

  # Install Go
  class { 'hubzero_mailhog::go_install': }

  # Install MailHog through Go
  exec { 'install_mailhog':
    require => Class[hubzero_mailhog::go_install],
    # Need git in path for 'go get'
    path => ['/usr/local/go/bin', '/usr/bin'],
    environment => ["GOPATH=${gopath}", "GOCACHE=${gocache}"],
    command => "/usr/local/go/bin/go get github.com/mailhog/MailHog",
    creates => "${gopath}/bin/MailHog"
  }

  # Configure daemon as a service
  file { 'systemd/mailhog.service':
    path => '/etc/systemd/system/mailhog.service',
    ensure => present,
    source => 'puppet:///modules/hubzero_mailhog/mailhog.service',
    owner => 'root',
    group => 'root',
    mode => '0755',
  }

  service { 'mailhog':
    # TODO: Use a template for inserting a dynamic gopath for binary
    require => File['systemd/mailhog.service'],
    ensure => running,
    enable => true,
    provider => 'systemd'
  }

  Class['hubzero_mailhog::go_install'] -> Exec['install_mailhog'] -> Service['mailhog']
}