#!/bin/bash
echo "seeding mysql"
/usr/bin/mysqladmin -u root -h localhost password '94B5FQN3fW8qZ4'
mysql -u root -p94B5FQN3fW8qZ4 --execute="CREATE USER 'example'@'localhost' IDENTIFIED BY 'YMx7ZE35jw45f9';"
mysql -u root -p94B5FQN3fW8qZ4 --execute="GRANT ALL PRIVILEGES ON example.* TO 'example'@'localhost';"
mysql -u root -p94B5FQN3fW8qZ4 --execute="CREATE DATABASE example;"
mysql -u root -p94B5FQN3fW8qZ4 example < /config/bin/setup.sql
