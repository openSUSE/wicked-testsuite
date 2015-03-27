#! /bin/bash
# Script to start the VMs - To be run as root

mkdir /var/run/twopence
chown qemu:qemu /var/run/twopence
chmod g+w /var/run/twopence

virsh start suites-sut-SLES_12_SP0-x86_64
virsh start suites-sut-openSUSE_13_2-x86_64
virsh start suites-sut-openSUSE_13_2-i586
virsh start suites-sut-openSUSE_Factory-i586
virsh start suites-sut-openSUSE_Tumbleweed-i586
virsh start suites-ref-openSUSE_13_1-x86_64

chmod g+w /var/run/twopence/*
