#!/bin/bash

LOG_FILE="$HOME/logs/openclaw.log"
CMD="openclaw gateway run"

start() {
    echo "后台启动 OpenClaw Gateway（非阻塞）"
    pkill -f "$CMD"
    nohup $CMD > $LOG_FILE 2>&1 &
    echo "启动成功！日志：$LOG_FILE"
}

stop() {
    echo "停止 OpenClaw"
    pkill -f "$CMD"
}

restart() {
    stop
    sleep 1
    start
}

log() {
    tail -f $LOG_FILE
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) restart ;;
    log) log ;;
    *) echo "用法：$0 start|stop|restart|log" ;;
esac