#! /bin/bash

sut=suites-sut-SLES_12_SP0-x86_64
ref=suites-ref-openSUSE_13_1-x86_64

if [ "$1" = "--restart" ]; then
  echo "Restarting virtual machines..."
  sudo virsh snapshot-revert $ref sane
  sudo virsh snapshot-revert $sut sane
  shift
fi

export TARGET_SUT=virtio:/var/run/twopence/$sut.sock
export TARGET_REF=virtio:/var/run/twopence/$ref.sock

cucumber -n "$@"
