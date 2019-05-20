node default {
  include hubzero_php
  include hubzero_mysql
  include hubzero_apache

  include hubzero_cms_setup

  include hubzero_xdebug

  Class[hubzero_php] -> Class[hubzero_cms_setup] -> Class[hubzero_mysql] -> Class[hubzero_apache] -> Class[hubzero_xdebug]
}