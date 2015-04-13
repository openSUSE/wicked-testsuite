#! /bin/bash

name="$1"
id="$2"
case "$3" in
  "x86_64")
     arch="x86_64"
     ;;
  "i586")
     arch="i686"
     ;;
esac

scripts=$(dirname $0)

sudo virsh destroy sut-$name 2> /dev/null
sudo virsh undefine sut-$name 2> /dev/null

script=$(printf "s/@@NAME@@/%s/; s/@@ID@@/%02d/; s/@@ARCH@@/%s/\n" $name $id $arch)
sed "$script" $scripts/config-sut.template > $WORKSPACE/wicked-sut.xml

sudo virsh define $WORKSPACE/wicked-sut.xml
[ $? -eq 0 ] || exit $?
sudo virsh start sut-$name
[ $? -eq 0 ] || exit $?

rm $WORKSPACE/wicked-sut.xml
