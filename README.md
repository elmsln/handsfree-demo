# handsfree-demo
This is a modified version of elmsln's one-line "handsfree" installer that's segregated for 1 key reason -- it sets in motion a system that forcibly destroys and rebuilds itself on an interval. This is how our demonstration environments come into existance, setting in motion a series of events doom the server (by design) on an interval (either daily or weekly).

This was created because of the dangerous nature of giving someone a certain level of access account to ones system that can automatically produce websites. This is useful for demonstration purposes only.

Here's an example of how you can use this to setup a server that kills itself daily
```
yes | yum -y install git && git clone https://github.com/elmsln/handsfree-demo.git /var/www/handsfree-demo && bash /var/www/handsfree-demo/scripts/install.sh centos elmsln ln elmsln.dev http day
```

Here's an example of how you can use this to setup a server that kills itself weekly
```
yes | yum -y install git && git clone https://github.com/elmsln/handsfree-demo.git /var/www/handsfree-demo && bash /var/www/handsfree-demo/scripts/install.sh amazon elmsln ln elmsln.dev http week
```