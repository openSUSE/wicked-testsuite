#! /bin/bash

set -e


echo
echo "### Setup the system under test ###"
sut="virtio:/var/run/twopence/sut-wicked-master.sock"
cflags="-m64"
#cflags="-m32 -L /usr/lib"

echo "Configure core dumps and logs"
twopence_inject $sut "files-sut/sysctl.conf" "/etc/sysctl.conf"
twopence_command $sut "rm -f /core*"
twopence_inject $sut "files-sut/journald.conf" "/etc/systemd/journald.conf"
twopence_command $sut "rm -rf /var/log/journal/*"

echo "Other cleanup"
twopence_command $sut "rm -f /root/*wicked*.rpm"
twopence_command $sut "rm -f /tmp/test"
twopence_command $sut "rm -f /tmp/wicked-log.tgz"
twopence_command $sut "rm -rf /var/log/testsuite"

echo "Install client-side utilities"
twopence_inject $sut "files-sut/wic.sh" "/usr/local/bin/wic.sh"
twopence_inject $sut "files-sut/ifbind.sh" "/usr/local/bin/ifbind.sh"
twopence_inject $sut "files-sut/log.sh" "/usr/local/bin/log.sh"
twopence_inject $sut "files-sut/wait_for_cmd_success.sh" "/usr/local/bin/wait_for_cmd_success.sh"
twopence_inject $sut "files-sut/wait_for_cmd_failure.sh" "/usr/local/bin/wait_for_cmd_failure.sh"
twopence_inject $sut "files-sut/create_many_bridges.sh" "/usr/local/bin/create_many_bridges.sh"
twopence_inject $sut "files-sut/delete_many_bridges.sh" "/usr/local/bin/delete_many_bridges.sh"
twopence_inject $sut "files-sut/check_many_bridges.sh" "/usr/local/bin/check_many_bridges.sh"
twopence_command $sut "chmod ugo+rx /usr/local/bin/*.sh"
gcc $cflags files-sut/check_macvtap.c -o /tmp/a.out
twopence_inject $sut "/tmp/a.out" "/usr/local/bin/check_macvtap"
rm /tmp/a.out
twopence_command $sut "chmod ugo+rx /usr/local/bin/check_macvtap"

echo "Configure the addresses and routes"
twopence_inject $sut "files-sut/config" "/etc/sysconfig/network/config"
twopence_inject $sut "files-sut/dhcp-keep-leases" "/etc/sysconfig/network/dhcp-keep-leases"
twopence_inject $sut "files-sut/dhcp-release-leases" "/etc/sysconfig/network/dhcp-release-leases"
twopence_command $sut "ln -sf /etc/sysconfig/network/dhcp-keep-leases /etc/sysconfig/network/dhcp"
twopence_inject $sut "files-sut/ifcfg-eth0" "/etc/sysconfig/network/ifcfg-eth0"
twopence_inject $sut "files-sut/ifcfg-eth1" "/etc/sysconfig/network/ifcfg-eth1"
twopence_inject $sut "files-sut/ifroute-eth1" "/etc/sysconfig/network/ifroute-eth1"

echo
echo "### Please reboot the machine ###"
echo "It is needed to activate the new configuration."
