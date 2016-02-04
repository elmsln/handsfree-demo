#!/bin/bash
# run the cent 6 installation routine
yes | yum -y install wget
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6*.rpm
# tokenized values so this can also be setup with 1 line
# since we'll be spinning up multiple boxes
git clone https://github.com/elmsln/elmsln.git /var/www/elmsln && bash /var/www/elmsln/scripts/install/handsfree/centos/centos-install.sh $1 $2 $3 $4 admin@elmsln.dev no

# modify cron to apply the script that kills itself nightly
# make it configurable based on arg $5
bash crontab.sh $5
