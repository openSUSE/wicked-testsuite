#! /bin/bash

set -e


echo
echo "### Setup the system under test ###"
sut="virtio:/var/run/twopence/sut-wicked-master.sock"
cflags="-m64"
#cflags="-m32 -L /usr/lib"

twopence_command $sut "rm -f /core*"
twopence_command $sut "rm -rf /var/log/journal/*"
twopence_command $sut "rm -f /root/*wicked*.rpm"
twopence_command $sut "rm -f /tmp/test"
twopence_command $sut "rm -f /tmp/wicked-log.tgz"
twopence_command $sut "rm -rf /var/log/testsuite"

IFS=$'\r\n' paths=($(cat paths-sut.txt))
for ((i=0; i<${#paths[@]}; i++)); do
  IFS=" " fields=(${paths[i]})
  src=${fields[0]}
  dst=${fields[1]}
  twopence_inject $sut files-sut/$src $dst
done

gcc $cflags files-sut/check_macvtap.c -o /tmp/a.out
twopence_inject $sut "/tmp/a.out" "/usr/local/bin/check_macvtap"
rm /tmp/a.out

twopence_command $sut "chmod ugo+rx /usr/local/bin/*.sh"
twopence_command $sut "chmod ugo+rx /usr/local/bin/check_macvtap"

twopence_command $sut "ln -sf /etc/sysconfig/network/dhcp-keep-leases /etc/sysconfig/network/dhcp"

echo
echo "### Please reboot the machine ###"
echo "It is needed to activate the new configuration."
