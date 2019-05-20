class hubzero_php (
	String $version = '5'
){
	$packages = [
		'php5', 'php5-curl', 'php5-mysql', 'php5-gd'
	]

	package { $packages:
    		ensure => 'installed'
	}

	# class { '::php::globals':
	# 	php_version => '5.6'
	# }
	# class { '::php':
	# 	ensure => present,
	# 	extensions => {
	# 		curl => {
	# 			provider => 'apt',
	# 			package_prefix => 'php5-'
	# 		},
	# 		mysql => {
	# 			provider => 'apt',
	# 			package_prefix => 'php5-'
	# 		},
	# 		gd => {
	# 			provider => 'apt',
	# 			package_prefix => 'php5-'
	# 		}
	# 	}
	# }
}