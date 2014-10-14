#! /bin/bash

echo                       | systemd-cat -t cucumber
echo "Cucumber on $(date)" | systemd-cat -t cucumber
echo "$@"                  | systemd-cat -t cucumber
echo                       | systemd-cat -t cucumber
