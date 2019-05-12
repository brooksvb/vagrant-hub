node default {
  include hubzero_apache
  include hubzero_php
  include hubzero_mysql

  include hubzero_cms_setup
  include hubzero_database_seed
}