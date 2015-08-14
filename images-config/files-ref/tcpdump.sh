#! /bin/bash

action=$1
shift

case $action in
  start)
    /usr/sbin/tcpdump "$@" > /dev/null 2>&1 &
    # leave enough time for tcpdump to start (race condition):
    sleep 1
    disown -a
    ;;
  stop)
    killproc -v /usr/sbin/tcpdump
    ;;
  read)
    sync
    /usr/sbin/tcpdump "$@"
    rc=$?
    exit $rc
    ;;
  *)
    exit 1
    ;;
esac
