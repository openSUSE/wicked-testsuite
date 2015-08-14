#! /bin/bash

# Remove the many bridges created by create-many-bridges.sh

[ -z "$1" ] && exit 1
number=$1

for ((i = 0; i < $number; i++)); do
  file=/tmp/tests/ifcfg-br$i
  wic.sh ifdown --delete br$i
  [ $? -ne 0 ] && exit $?
  rm $file
done

exit 0
