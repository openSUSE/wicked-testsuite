#! /bin/bash

for vm in suites-sut-SLES_12_SP0-x86_64 \
          suites-sut-openSUSE_13_2-x86_64 \
          suites-sut-openSUSE_13_2-i586 \
          suites-sut-openSUSE_Factory-x86_64 \
          suites-sut-openSUSE_Tumbleweed-x86_64 \
          suites-ref-openSUSE_13_1-x86_64; do
  virsh -c qemu:///system destroy ${vm}
  virsh -c qemu:///system undefine ${vm}
  virsh -c qemu:///system define vm-files/${vm}.xml
  virsh -c qemu:///system start ${vm}
done

virsh -c qemu:///system list
