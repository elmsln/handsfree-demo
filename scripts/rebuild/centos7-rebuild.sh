#!/bin/bash
# todo add support for ubuntu/deb and other systems
# This is pretty evil but it makes sure our demo is completely destroyed

# move cfg to a safe place
cp /var/www/elmsln/config/scripts/drush-create-site/config.cfg /root/config.cfg
source ~/.bashrc
# reinstall mysql to empty it
service mysql stop
killall -9 mysql
killall -9 mysqld
yes | yum remove mysql-server mysql-client mysql-common mysql
yes | yum autoremove
userdel mysql
rm -rf /var/lib/mysql
rm -rf /var/log/mysql
rm -rf /etc/mysql

# install mysql again now that it's completely empty
yes | yum -y install mysql mysql-server
service mysql restart

# blow it awway
rm -rf /var/www/elmsln
# get the repo again
git clone https://github.com/elmsln/elmsln.git /var/www/elmsln
# we assume you install it in the place that we like
cd /var/www/elmsln
# blow away old repo
rm -rf config
# make git not track filemode changes
git config core.fileMode false
# ensure it doesn't track filemode changes in the future
git config --global core.filemode false
git clone https://github.com/elmsln/elmsln-config-example.git config
# move our temp config gile back into place
mv /root/config.cfg /var/www/elmsln/config/scripts/drush-create-site/config.cfg
# source the config setup
source /var/www/elmsln/config/scripts/drush-create-site/config.cfg
# make the root user secure again
char=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V X W Y Z)
max=${#char[*]}
# generate a random 30 digit password
pass=''
for i in `seq 1 30`
do
  let "rand=$RANDOM % 62"
  pass="${pass}${char[$rand]}"
done
# make mysql secure so no one knows the password except this script
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$pass') WHERE User = 'root'"
# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
mysql -e "DROP DATABASE test"
# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"
# now make an elmslndbo
cat <<EOF | mysql -u root --password=$pass
CREATE USER 'elmslndbo'@'localhost' IDENTIFIED BY '$dbsupw';
GRANT ALL PRIVILEGES ON *.* TO 'elmslndbo'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
EOF
# reinstall the system
bash /var/www/elmsln/scripts/install/elmsln-install.sh
# restart apache / mysql just for fun
service mysql restart
service httpd restart
service php-fpm restart

# now we need to run our standard drush commands to unify the UX on this
# while being secure which means we don't want to actually give people admin
# we want to switch the admin user's password to something else
# then we want to create a user account for a staff member
# spider it everywhere so they can do anything, and then we need to test
source .bashrc
bash /var/www/handsfree-demo/scripts/cleanup.sh
