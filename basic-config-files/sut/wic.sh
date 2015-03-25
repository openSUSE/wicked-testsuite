#! /bin/bash

/usr/sbin/wicked --debug all --log-target syslog "$@"
