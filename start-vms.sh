#! /bin/bash
# Script to start the VMs - To be run as root

mkdir /var/run/twopence
chown qemu:qemu /var/run/twopence
chmod g+w /var/run/twopence

virsh start almond04-build
virsh start almond05-reference
virsh start almond06-sut

chmod g+w /var/run/twopence/*
