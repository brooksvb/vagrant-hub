<?php

// MailHog allows you to route to it either by specifying port 1025, or using the /usr/local/bin/mhsendmail binary instead of sendmail
return array(
	'mailer' => 'mail',
	'mailfrom' => 'webmaster@ed11f485244a',
	'fromname' => 'example',
	'smtpauth' => '0',
	'smtphost' => 'localhost',
	// Port for MailHog
	'smtpport' => '1025',
	'smtpuser' => '',
	'smtppass' => '',
	'smtpsecure' => 'none',
	'sendmail' => '/usr/sbin/sendmail',
);