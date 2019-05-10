node default {
  include hubzero-apache
  include hubzero-php
  include hubzero-mysql

  include hubzero-cms-setup
  include hubzero-database-seed
}