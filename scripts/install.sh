#!/bin/bash
# run the cent 6 installation routine
# tokenized values so this can also be setup with 1 line
# since we'll be spinning up multiple boxes
if [[ $1 = 'ubuntu' ]]; then
  yes | apt-get -y install git wget
  yes | apt-get update
elif [[ $1 = 'centos' ]]; then
  yes | yum -y install git wget
  yes | yum update
  wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
  rpm -Uvh remi-release-6*.rpm
  wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  rpm -Uvh epel-release-6*.rpm
else
  yes | yum -y install git wget
  yes | yum update
fi
git clone https://github.com/elmsln/elmsln.git /var/www/elmsln && bash /var/www/elmsln/scripts/install/handsfree/$1/$1-install.sh $2 $3 $4 $5 admin@elmsln.dev no
# make it executable
chmod 744 /var/www/handsfree-demo/scripts/*
# modify cron to apply the script that kills itself nightly
# make it configurable based on arg $6
bash /var/www/handsfree-demo/scripts/crontab.sh $6
source .bashrc
# perform clean up tasks as far as user accounts to create and what not for the standard User experience
bash /var/www/handsfree-demo/scripts/cleanup.sh
