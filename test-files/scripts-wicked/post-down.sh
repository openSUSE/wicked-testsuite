#! /bin/bash

echo "post-down $2" >> /tmp/tests/results
ip a s eth0 | grep "inet " >> /tmp/tests/results
