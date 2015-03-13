#! /bin/bash
# Wait for command to succeed
# Parameters: "<shell-command>"
# Returns 0 if succeeded in less than 30 seconds

for ((i = 0; i < 300; i++)); do
  echo $@ | /bin/bash
  if [ $? -eq 0 ]; then
    echo "Command \"$@\" succeeded"
    exit 0
  fi
  usleep 100000
done

echo "Giving up."
exit 1
