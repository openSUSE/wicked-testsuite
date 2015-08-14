#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

sh ./check_for_root.sh || exit 1
source ./include.sh || exit 1

#-----------------------------------------------------------------------------
# create /var/run/twopence (first time)
#-----------------------------------------------------------------------------
echo " * create twopence directory '${twopence_dir}'..."
mkdir -p "${twopence_dir}"
chown qemu:qemu "${twopence_dir}"

exit 0
