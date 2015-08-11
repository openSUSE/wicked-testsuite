#! /bin/bash

echo "pre-up eth0" >> /tmp/tests/results
ip a s eth0 | grep "inet " >> /tmp/tests/results

exit 0
