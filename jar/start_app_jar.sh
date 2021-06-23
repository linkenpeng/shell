#!/usr/bin/env bash
# /bin/sh

source /etc/profile

debugport=12000
jarname=app
logdir=/data/java/logs/app
pdir=/data/wars/app
MaxMem=512m

penv=dev
sleepNum=10

echo "-----------------------------------------------"
echo "ps -ef | grep java | grep '$pdir/$jarname.jar' | grep -v grep"

for id in `ps -ef | grep java | grep "$pdir/$jarname.jar" | grep -v grep | awk '{print $2}'`; do echo "try kill $id"; done;


for id in `ps -ef | grep java | grep "$pdir/$jarname.jar" | grep -v grep | awk '{print $2}'`; do
  echo "kill $id ..."
  kill $id;

  echo "Check the survival of the process $id ..."
  forceKill=1
  while [ $sleepNum -ge 1 ]; do
    sleep 1
    ps -p $id >/dev/null 2>&1
    if [ $? -eq 0 ] ; then
      echo "Server($id) still run；reminder times：$sleepNum .... （don't stop shell）"
    else
      echo "Server($id) has stop"
	  forceKill=0
	  break
    fi
	sleepNum=`expr $sleepNum - 1`
  done;

  if [ "$forceKill"x == "1x" ]; then
    echo "Server process $id is not stop yet，will force stop this process."
    kill -9 $id;
  fi

  echo "kill $id end."
done;


sleep 2
echo "***********************************************"

cd $pdir
if [ -f ${jarname}_new.jar ]; then
  rm -rf $jarname.jar
  echo "delete old finish"
  cp ${jarname}_new.jar $jarname.jar
  echo "copy new file end"
fi

sleep 1
mkdir -p $logdir

# jdk
JParams="-DPOD_NAME=$jarname -Dspring.profiles.active=$penv -Xms$MaxMem -Xmx$MaxMem -DWatchdog=WSServer-#Watchdog# -Dlogging.path=$logdir"
JParams="$JParams -XX:+UseParallelGC -XX:+UseParallelOldGC -verbose.gc -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$logdir/gc.log"
if [ "$debugport"x != "x" ]; then
  JParams="$JParams -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=$debugport"
fi

# skywalking config
if [ -f /data/wars/skywalking.server ]; then
  skps=`cat /data/wars/skywalking.server`
  skps="-DSW_AGENT_NAME=$jarname -DSW_AGENT_COLLECTOR_BACKEND_SERVICES=$skps -javaagent:/data/skywalking-agent/skywalking-agent.jar"
  JParams="$JParams $skps"
fi

nohup java -jar $JParams $pdir/$jarname.jar > $logdir/catalina.out 2>&1 &

echo "start~"

