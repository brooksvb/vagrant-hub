##########
# This code is for converting the config files into a vhost. In development
##########
apache::vhost { 'hubzero_ssl':
  port => '443',
  ssl => true,
  docroot => '/var/www/dev',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  manage_docroot => false,

  block => 'scm', # Blocks access to all source control

  directories => [
    {
      path => '/',
      deny => 'from all'
    },

    {
      path => '/var/www/dev/api',
      rewrites => {
        rewrite_cond => [
          '%{REQUEST_FILENAME} !-f',
          '%{REQUEST_FILENAME} !-d'
        ],
        rewrite_rule => '(.*) index.php'
      }
    },

    {
      path => '/var/www/dev'
    },

    {
      path => '/var/www/dev/site/protected'
    },


  ],
  rewrites => {

  },
}