#! /bin/bash

name="$1"
id="$2"
ethn="$3"

scripts=$(dirname $0)

sudo virsh net-destroy $name-$ethn 2> /dev/null
sudo virsh net-undefine $name-$ethn 2> /dev/null

script=$(printf "s/@@NAME@@/%s/; s/@@ID@@/%02d/; s/@@ETHN@@/%d/\n" $name $id $ethn)
sed "$script" $scripts/config-net.template > $WORKSPACE/wicked-net.xml

sudo virsh net-define $WORKSPACE/wicked-net.xml
[ $? -eq 0 ] || exit $?
sudo virsh net-start $name-$ethn
[ $? -eq 0 ] || exit $?

rm $WORKSPACE/wicked-net.xml
