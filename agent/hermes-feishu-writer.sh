#!/bin/bash

PROFILE="feishu-writer"
LOG_FILE="$HOME/logs/hermes-feishu-writer.log"
CMD="hermes -p $PROFILE gateway run"

start() {
    echo "启动 Hermes $PROFILE..."
    pkill -f "$CMD"
    nohup $CMD > $LOG_FILE 2>&1 &
    sleep 1
    echo "启动完成！"
}

stop() {
    echo "停止 Hermes $PROFILE..."
    pkill -f "$CMD"
    sleep 1
    echo "已停止"
}

restart() {
    echo "重启 Hermes $PROFILE..."
    pkill -f "$CMD"
    sleep 2
    nohup $CMD > $LOG_FILE 2>&1 &
    sleep 1
    echo "重启完成！"
}

log() {
    tail -f $LOG_FILE
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) restart ;;
    log) log ;;
    *)
        echo "使用方法："
        echo "  $0 start   启动"
        echo "  $0 stop    关闭"
        echo "  $0 restart 重启"
        echo "  $0 log     查看日志"
    ;;
esac