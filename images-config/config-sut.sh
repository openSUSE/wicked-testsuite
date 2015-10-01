#! /bin/bash

rm -f /core*
rm -rf /var/log/journal/*
rm -f /root/*wicked*.rpm
rm -f /tmp/test
rm -f /tmp/wicked-log.tgz
rm -rf /var/log/testsuite

cp ./files-sut/sysctl.conf             /etc/sysctl.conf
cp ./files-sut/journald.conf           /etc/systemd/journald.conf
cp ./files-sut/wic.sh                  /usr/local/bin/wic.sh
cp ./files-sut/ifbind.sh               /usr/local/bin/ifbind.sh
cp ./files-sut/log.sh                  /usr/local/bin/log.sh
cp ./files-sut/wait_for_cmd_success.sh /usr/local/bin/wait_for_cmd_success.sh
cp ./files-sut/wait_for_cmd_failure.sh /usr/local/bin/wait_for_cmd_failure.sh
cp ./files-sut/create_many_bridges.sh  /usr/local/bin/create_many_bridges.sh
cp ./files-sut/delete_many_bridges.sh  /usr/local/bin/delete_many_bridges.sh
cp ./files-sut/check_many_bridges.sh   /usr/local/bin/check_many_bridges.sh
cp ./files-sut/config                  /etc/sysconfig/network/config
cp ./files-sut/dhcp-keep-leases        /etc/sysconfig/network/dhcp-keep-leases
cp ./files-sut/dhcp-release-leases     /etc/sysconfig/network/dhcp-release-leases
cp ./files-sut/ifcfg-eth0              /etc/sysconfig/network/ifcfg-eth0
cp ./files-sut/ifcfg-eth1              /etc/sysconfig/network/ifcfg-eth1
cp ./files-sut/ifroute-eth1            /etc/sysconfig/network/ifroute-eth1

chmod ugo+rx /usr/local/bin/*.sh
chmod ugo+rx /usr/local/bin/check_macvtap

ln -sf /etc/sysconfig/network/dhcp-keep-leases /etc/sysconfig/network/dhcp
