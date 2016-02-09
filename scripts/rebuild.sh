#!/bin/bash
# todo add support for ubuntu/deb based demo systems
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

# now we need to run our standard drush commands to unify the UX on this
# while being secure which means we don't want to actually give people admin
# we want to switch the admin user's password to something else
# then we want to create a user account for a staff member
# spider it everywhere so they can do anything, and then we need to test
source .bashrc
bash /var/www/handsfree-demo/scripts/cleanup.sh
