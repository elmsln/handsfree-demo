#!/bin/bash
# clean up after installation. This ensures we lock down certain aspects of our demo
# and prevents people from being able to do whatever they want from a drupal admin
# perspective. While innovate allows this, it's silo'ed quite well for these purposes.

# used for random password generation
char=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V X W Y Z)
max=${#char[*]}
# generate a random 30 digit password
pass=''
for i in `seq 1 30`
do
  let "rand=$RANDOM % 62"
  pass="${pass}${char[$rand]}"
done
# set the admin password to something no one knows
drush @elmsln upwd admin --password=$pass --y
# staff user account with password of staff
drush @elmsln ucrt staff --mail=staff@elmsln.dev --password=staff --y
drush @elmsln urol staff staff --y
# student user account with password student
drush @elmsln ucrt student --mail=student@elmsln.dev --password=student --y
drush @elmsln urol student student --y
# ensure the module exists since this directory gets rebuilt all the time
cp -R /var/www/handsfree-demo/modules/ /var/www/elmsln/config/shared/drupal-7.x/modules/contrib/
# enable the module
drush @online en handsfree_demo --y
