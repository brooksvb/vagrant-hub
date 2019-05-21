class hubzero_mailhog {
  # Path for go package installs, not for base go installation
  $gopath = '/usr/local/go-pkg';

  # Install Go if it does not exist
  class { 'hubzero_mailhog::go_install': }

  # Install MailHog through Go
  exec { 'install_mailhog':
    require => Class['hubzero_mailhog::go_install'],
    path => '/usr/local/go/bin/go',
    environment => "GOPATH=${gopath}",
    command => 'go get github.com/mailhog/MailHog'
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
    require => File['systemd/mailhog.service'],
    ensure => running,
    enable => true,
    provider => 'systemd'
  }

  Class['hubzero_mailhog::go'] -> Exec['install_mailhog']
}