#! /bin/bash

for ((i = 0; i < 100; i++)); do
  file=/tmp/tests/ifcfg-br$i
  if [ ! -e $file ]; then
    echo "BOOTPROTO=none"                >  $file
    echo "BRIDGE=yes"                    >> $file
    echo "BRIDGE_FORWARDDELAY=0"         >> $file
    echo "BRIDGE_PORTS="                 >> $file
    echo "BRIDGE_STP=off"                >> $file
    echo "BROADCAST="                    >> $file
    #echo "IPADDR=192.168.3.$i"          >> $file
    echo "DHCLIENT_SET_DEFAULT_ROUTE=no" >> $file
    echo "CHECK_DUPLICATE_IP=no"         >> $file
    #echo "ETHTOOL_OPTIONS=''"           >> $file
    #echo "MTU=''"                       >> $file
    #echo "NETMASK=''"                   >> $file
    #echo "NETWORK=''"                   >> $file
    #echo "REMOTE_IPADDR=''"             >> $file
    echo "STARTMODE=auto"                >> $file
  fi
done
