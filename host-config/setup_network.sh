#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

echo " * setup network..."
defaultroute=$(ip route show |grep "^default" |awk '{print $5}')
dir="/sys/class/net/$bridge/bridge"
if [ -d "$dir" ]; then
    echo "WARNING: bridge '${bridge}' already exists. Exit."
    exit 0
fi

cp ./files-host/ifcfg* /etc/sysconfig/network

cp ./files-host/iptables  /etc/init.d/iptables
chmod 744 /etc/init.d/iptables

if test -f "/etc/ip4tablesrc" ; then
    echo "WARNING: file '/etc/ip4tablesrc' exists. Skip."
else
    sed "s/@@default@@/${defaultroute}/g" ./files-host/ip4tablesrc > /etc/ip4tablesrc
fi

if test -f "/etc/ip6tablesrc" ; then
    echo "WARNING: file '/etc/ip6tablesrc' exists. Skip."
else
    sed "s/@@default@@/${defaultroute}/g" ./files-host/ip6tablesrc > /etc/ip6tablesrc
fi

insserv iptables

echo " * restart iptables..."
/etc/init.d/iptables restart

echo " * bring up '$bridge'..."
ifup $bridge

echo " * bring up '$dummy'..."
ifup $dummy

echo " * bring up '$dummy_out'..."
ifup $dummy_out

sed "s/@@default@@/${defaultroute}/g;\
    s/@@bridge@@/${bridge}/g;\
    s/@@dummy@@/${dummy}/g;\
    s/@@dummy_out@@/${dummy_out}/g" ./files-host/50-wicked-ifsysctl.conf > /etc/sysctl.d/50-wicked-ifsysctl.conf

cp ./files-host/10-kernel-sysrq.conf /etc/sysctl.d/10-kernel-sysrq.conf

sysctl -p /etc/sysctl.d/10-kernel-sysrq.conf
sysctl -p /etc/sysctl.d/50-wicked-ifsysctl.conf

exit 0
