#! /bin/bash

# Check many bridges

[ -z "$1" ] && exit 1
number=$1

[ "$2" != "UP" -a "$2" != "deleted" ] && exit 1
state=$2

if [ "$state" = "UP" ]; then

  for ((i = 0; i < $number; i++)); do
    ip a s br$i 2>&1 | grep -q "state UP"
    [ $? -ne 0 ] && exit 2
  done

else

  for ((i = 0; i < $number; i++)); do
    ip a s br$i 2>&1 | grep -q "does not exist"
    [ $? -ne 0 ] && exit 2
  done

fi

exit 0
