#! /bin/bash

echo "post-up $2" >> /tmp/tests/results
ip a s eth0 | grep "inet " >> /tmp/tests/results
