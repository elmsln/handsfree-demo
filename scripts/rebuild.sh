#!/bin/bash
# This is pretty evil but it makes sure our demo is completely destroyed

# drop elmsln
rm -rf /var/www/elmsln
# reinstall mysql to empty it
/etc/init.d/mysqld stop
killall -9 mysql
killall -9 mysqld
yum remove --purge mysql-server mysql-client mysql-common mysql
yum autoremove
yum autoclean
deluser mysql
rm -rf /var/lib/mysql
yum purge mysql-server-core-5.5
yum purge mysql-client-core-5.5
rm -rf /var/log/mysql
rm -rf /etc/mysql

# install mysql again now that it's completely empty
yes | yum -y --enablerepo=remi install mysql mysql-server
/etc/init.d/mysqld restart
# get the repo again
git clone https://github.com/elmsln/elmsln.git /var/www/elmsln
# reinstall the system
bash /var/www/elmsln/scripts/install/elmsln-install.sh
# restart apache / mysql just for fun
/etc/init.d/httpd restart
/etc/init.d/mysqld restart
