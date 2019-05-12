class hubzero_database_seed {

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

    exec { 'muse setup':
        require => [Exec['clone cms']],
        cwd => '/var/www/dev',
        command => '/usr/bin/php5 ./muse migration -i -f',
    }
}