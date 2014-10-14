#! /bin/bash

rm -f ~/rpmbuild/RPMS/x86_64/*.rpm

cd ~/workspace
./autogen.sh
make rpmbuild
