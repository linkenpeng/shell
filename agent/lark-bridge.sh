#!/bin/bash

NAME="lark-channel-bridge"
LOG="$HOME/logs/lark-bridge.log"
PID=$(pgrep -f "$NAME")

start() {
    if [ -n "$PID" ]; then
        echo "已在运行，PID: $PID"
        return
    fi
    echo "🔧 启动 $NAME（后台非阻塞）"
    nohup $NAME run > $LOG 2>&1 &
    sleep 1
    echo "启动成功，日志：$LOG"
}

stop() {
    if [ -z "$PID" ]; then
        echo "ℹ未运行"
        return
    fi
    echo "停止 $NAME（PID: $PID）"
    kill $PID
}

restart() {
    stop
    sleep 1
    start
}

log() {
    tail -f $LOG
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) restart ;;
    log) log ;;
    *) echo "用法：$0 start|stop|restart|log" ;;
esac