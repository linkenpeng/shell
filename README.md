# shell
some linux web server useful shell bash script, some component auto start when linux is restart.
support all of you component's install path is /usr/local

usage example for zookeeper on CentOS6:

```
cd /etc/init.d/
vim zookeeper
chmod 755 zookeeper
service zookeeper status
chkconfig --add zookeeper
chkconfig --list
chkconfig zookeeper on
```

component name list:
- zookeeper
- kafka
- redis
- mysql
- nginx
- php-fpm
- tomcat
- memcache

remove auto start:
```
chkconfig zookeeper off
```


