class hubzero-php {
    $packages = [
		'php5', 'php5-curl', 'php5-mysql', 'php5-gd'
	]

	package { $packages:
    		ensure => 'installed'
    }
}