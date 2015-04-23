#!/bin/bash

action=$1 ; shift
case $action in
start)
	echo "$action: $@" 2>&1 | logger -t tcpdump
	checkproc -v /usr/sbin/tcpdump 2>&1 | logger -t tcpdump
	/usr/sbin/tcpdump "$@" &
	sleep 1
	disown -a
	checkproc -v /usr/sbin/tcpdump 2>&1 | logger -t tcpdump
;;
stop)
	echo "$action: $@" 2>&1 | logger -t tcpdump
	killproc -v /usr/sbin/tcpdump | logger -t tcpdump
;;
read)
	echo "$action: $@" 2>&1 | logger -t tcpdump
	checkproc -v /usr/sbin/tcpdump 2>&1 | logger -t tcpdump
	sync
	/usr/sbin/tcpdump "$@" &> /tmp/tcpdump.$$.txt
	RC=${PIPESTATUS[0]}
	cat   /tmp/tcpdump.$$.txt 2>&1 | logger -t tcpdump
	cat   /tmp/tcpdump.$$.txt
	exit $RC
;;
*)
	echo "$action: $@" 2>&1 | logger -t tcpdump
	exit 1
;;
esac

