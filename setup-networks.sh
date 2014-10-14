#! /bin/bash

for network in private1 private2; do
  virsh -c qemu:///system net-destroy ${network}
  virsh -c qemu:///system net-undefine ${network}
  virsh -c qemu:///system net-define vm-files/${network}.xml 
  virsh -c qemu:///system net-autostart ${network}
  virsh -c qemu:///system net-start ${network}
done

virsh -c qemu:///system net-list
