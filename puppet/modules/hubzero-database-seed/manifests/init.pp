class hubzero-database-seed {

    $db_user_breadcrumb = '/etc/.hubzero_db_usr_first_time_setup'
    $db_create_breadcrumb = '/etc/.hubzero_db_create_first_time_setup'
    $db_seed_breadcrumb = '/etc/.hubzero_db_seed_first_time_setup'

    /**************
    # TODO:
    # Temporarily disable password set. This should be done better using Hiera and Puppet Mysql module
    exec { 'cms root password':
        before => File["${breadcrumb}"], # Ensure this runs before breadcrumb is created
        command => "/usr/bin/mysqladmin -u root -h localhost password '94B5FQN3fW8qZ4'",
        creates => "${breadcrumb}" # Don't run if breadcrumb exists
    }
    ***************/

    exec { 'mysql user create':
        before => [File["${db_user_breadcrumb}"]],
        # TODO: Temporarily removed password, see above: -p94B5FQN3fW8qZ4
        command => "/usr/bin/mysql -u root --execute=\"
            CREATE USER 'example'@'localhost' IDENTIFIED BY 'YMx7ZE35jw45f9';
            \"
        ",
        creates => ["${db_user_breadcrumb}"]
    }

    file { "${db_user_breadcrumb}":
        path => "${db_user_breadcrumb}",
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0111'
    }

    exec { 'mysql db create':
        require => Exec['mysql user create'],
        before => [File["${db_create_breadcrumb}"]],
        # TODO: Temporarily removed password, see above: -p94B5FQN3fW8qZ4
        command => "/usr/bin/mysql -u root --execute=\"
            GRANT ALL PRIVILEGES ON example.* TO 'example'@'localhost';
            CREATE DATABASE example;
            \"
        ",
        creates => ["${db_create_breadcrumb}"]
    }

    file { "${db_create_breadcrumb}":
        path => "${db_create_breadcrumb}",
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0111'
    }

    # Create tables, seed data
    exec { 'mysql db seed':
        require => Exec['mysql db create'],
        before => [File["${db_seed_breadcrumb}"]],
        # TODO: Temporarily removed password, see above: -p94B5FQN3fW8qZ4
        command => "/usr/bin/mysql -u root example \
            < /vagrant/puppet/modules/hubconfig/files/bin/setup.sql
        ",
        creates => ["${db_seed_breadcrumb}"]
    }

    file { "${db_seed_breadcrumb}":
        path => "${db_seed_breadcrumb}",
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0111'
    }

    exec { 'muse setup':
        require => [Exec['clone cms'], Exec['mysql db seed']],
        cwd => '/var/www/dev',
        command => '/usr/bin/php5 ./muse migration -i -f',
    }
}