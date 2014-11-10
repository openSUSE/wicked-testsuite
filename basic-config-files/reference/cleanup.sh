#! /bin/bash

for int_file in $(ls /etc/sysconfig/network/ifcfg-*); do
  if [ -L $int_file ]; then
    echo "Removing $int_file ..."
    rm $int_file
    rc=$?
    [ $rc -eq 0 ] || exit $rc
  else
    echo "Skipping $int_file ..."
  fi
done
