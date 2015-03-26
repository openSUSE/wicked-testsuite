#! /bin/bash
# Script to start the VMs - To be run as root

mkdir /var/run/twopence
chown qemu:qemu /var/run/twopence
chmod g+w /var/run/twopence

virsh start jung05-reference
virsh start jung06-sut

chmod g+w /var/run/twopence/*
