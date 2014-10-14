#! /bin/bash

for vm in build reference sut; do
  virsh -c qemu:///system destroy ${vm}
  virsh -c qemu:///system undefine ${vm}
  virsh -c qemu:///system define vm-files/${vm}.xml
  virsh -c qemu:///system start ${vm}
done

virsh -c qemu:///system list
