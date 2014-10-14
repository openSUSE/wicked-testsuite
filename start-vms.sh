#! /bin/bash
# Script to start the VMs - To be run as root

mkdir /var/run/twopence
chown qemu:qemu /var/run/twopence
chmod g+w /var/run/twopence

virsh start build
virsh start sut
virsh start reference

chmod g+w /var/run/twopence/*
