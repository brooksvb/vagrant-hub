class hubzero_mailhog::daemonize_install {
  exec { 'download archive':
    cwd => '/tmp',
    command => 'wget https://github.com/bmc/daemonize/archive/release-1.7.8.tar.gz',
    creates => '/tmp/release-1.7.8.tar.gz'
  }


}