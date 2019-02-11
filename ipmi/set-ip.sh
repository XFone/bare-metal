#!/bin/bash

DEV=lo0

alias() {
    echo "set ip alias $1 on $DEV"
    sudo ifconfig $DEV alias $1 255.255.255.0
}

unalias() {
    echo "unset ip alias $1 on $DEV"
    sudo ifconfig $DEV -alias $1
}

case "${1}" in
  start)
    alias 127.0.1.1
    alias 127.0.1.2
  ;;

  stop)
    unalias 127.0.1.1
    unalias 127.0.1.2
  ;;

  *)
    echo "Usage: ${0} {start|stop}"
    exit 2

esac

ifconfig $DEV

exit $?
