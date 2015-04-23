#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

version="0.0.1"
baseurl="http://download.suse.de/ibs/home:/jloeser:/wicked-testsuite/images"
destination="/tmp"

sut_images=
ref_images=
other_images=
direct=

print_help() {
    echo "$0 [-l|--list] [-i|--image] [-d|--destination]"
}

images=`wget -qO - ${baseurl} | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
      sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | uniq -i | grep -E "^((\bref\b)|(\bsut\b))*(.*)qcow2$"`

for image in $images; do
    sut_images="${sut_images} `echo $image | grep -e \"^sut\"`"
    ref_images="${ref_images} `echo $image | grep -e \"^ref\"`"
    other_images="${other_images} `echo $image | grep -vE \"^((\bsut\b)|(\bref\b))\"`"
done

while test $# -gt 0
do
    case $1 in

    -h | --help)
        # usage and help
        print_help
        exit 0
        ;;

    -i | --image)
        if test $# -lt 2; then
            echo "$1 needs a value"
        fi
        direct="$2"
        ;;
    -l | --list)
        echo "System Under Test (sut) images:"
        echo
        for sut in $sut_images; do
            echo "  $sut"
        done
        echo
        echo "Reference images:"
        echo
        for ref in $ref_images; do
            echo "  $ref"
        done
        echo
        if [ ! "$other_images" == "" ]; then
        echo "Other images:"
        echo
        for other in $other_images; do
            echo "  $other"
        done
        echo
        fi
        echo "from: ${baseurl}"
        exit 0
        ;;
    -d | --destination)
        if test $# -lt 2; then
            echo "$1 needs a value"
        fi
        destination="$2"
        if [ ! -d "$destination" ]; then
            echo "create directory '${destination}'..."
            mkdir -p "$destination"
        fi
        ;;
    esac

    shift
done

if [ ! "$direct" == "" ]; then
    all_images="$direct"
else
    all_images="$sut_images $ref_images"
fi

for image in $all_images; do
    url="${baseurl}/${image}"
    filename="$(echo $image | grep -oE "^((\bref\b)|(\bsut\b))*(.*)((\bx86_64\b)|(\bi686\b)|(\bi586\b))")"
    filename="$(echo $filename | sed 's#\.#-#').qcow2"
    wget -q "$url" -O "${destination}/${filename}"
    if [ "$?" -eq 0 ]; then
        sync
        size=`du -m "${destination}/${filename}" | cut -f1`
        echo "found ${url} -> ${destination}/${filename} (${size}M)"
    else
        exit 1
    fi
done
