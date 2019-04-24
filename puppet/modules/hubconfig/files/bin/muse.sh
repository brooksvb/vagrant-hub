#!/bin/sh
mysqld --user=mysql &
sleep 5
mysqlcheck --repair --all-databases -p 94B5FQN3fW8qZ4
echo "running muse"
sleep 5
cd /var/www/dev/
php5 ./muse migration -i -f
echo "done"
