#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

exit 0
