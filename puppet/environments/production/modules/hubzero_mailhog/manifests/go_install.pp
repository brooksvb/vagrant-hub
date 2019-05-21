class hubzero_mailhog::go_install {

  # Each resource has a check to not execute if go is already installed
  Exec['wget go'] -> Exec['extract go']

  # Download
  exec { 'wget go':
    path => '/usr/bin/wget',
    cwd => '/tmp',
    command => 'wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz',
    creates => '/tmp/go1.12.5.linux-amd64.tar.gz'
  }

  # Extract
  exec { 'extract go':
    path => '/bin/tar',
    cwd => '/tmp',
    command => 'tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz',
    creates => '/usr/local/go'
  }

  # Add to path
  file { 'go_path.sh':
    ensure => present,
    path => '/etc/profile.d/go_path.sh',
    content => "export PATH=\$PATH:/usr/local/go/bin:/usr/local/go-pkg/bin; export GOPATH=${gopath}",
  }
}