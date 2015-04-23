#! /bin/bash
# Wait for command to fail
# Parameters: "<shell-command>"
# Returns 0 if failed in less than 30 seconds

for ((i = 0; i < 300; i++)); do
  echo $@ | /bin/bash
  if [ $? -ne 0 ]; then
    echo "Command \"$@\" failed"
    exit 0
  fi
  usleep 100000
done

echo "Giving up."
exit 1
