#!/bin/bash
chown -R apache:apache /var/www/dev/
cd /var/www/dev/core/
echo "adding composer token"
php5 ./bin/composer config -g github-oauth.github.com 1494e134d21100c55fcd4f0f65bf07b2e551e745
echo "updating composer"
php5 ./bin/composer update
echo "Composer updated"
sleep 5
php5 ./bin/composer require firebase/php-jwt
echo "firebase installed"
echo "appling hack"
mv /var/www/dev/app/config/User.php /var/www/dev/core/vendor/hubzero/framework/src/User/User.php

#[DEFAULT]
#HUBDB=YMx7ZE35jw45f9
#JOOMLA-ADMIN=STbKCZunzu2vz9
#MYSQL-ROOT=94B5FQN3fW8qZ4
#MYSQL-ROOT-USER=root
