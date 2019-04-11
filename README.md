# shell
some linux web server useful shell bash script, support some component auto start when linux is restart.

usage example for zookeeper:

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




