#!/bin/bash
# hook into cron the script that kills itself on an interval
case "$1" in
  # reset at 4am every day
  'day')  ct="* 4 * * *"
      ;;
  # reset every monday at 4am
  'week')  ct="* 4 * * 1"
      ;;
esac
echo "# ELMSLN handsfree-demo rebuild script" >> /etc/crontab
echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin:/root/.composer/vendor/bin" >> /etc/crontab
echo "$ct root bash /var/www/handsfree-demo/scripts/rebuild/${2}-rebuild.sh" >> /etc/crontab
