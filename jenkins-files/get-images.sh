#!/bin/bash
#
# Author Jan Löser <jloeser@suse.de>
# Published under the GNU Public Licence 2

version="0.0.1"
baseurl="http://download.suse.de/ibs/home:/wicked-maintainers:/testsuite:/stable:/images/images"
destination="/tmp"

sut_images=
sut_packages=
ref_images=
ref_packages=
other_images=
other_packages=
direct=

print_help() {
    echo "$0 [-l|--list] [-i|--image] [-d|--destination]"
}

images=`wget -qO - ${baseurl} | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
      sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | uniq -i | grep -E "^((\bref\b)|(\bsut\b))*(.*)(qcow2|packages)$"`

for image in $images; do
    case $image in
    sut-*.packages)	sut_packages="$sut_packages $image";;
    ref-*.packages)	ref_packages="$ref_packages $image";;
    sut-*.qcow2)	sut_images="${sut_images} $image" ;;
    ref-*.qcow2)	ref_images="${ref_images} $image" ;;
    *.packages)		other_packages="$other_packages $image" ;;
    *.qcow2)		other_images="${other_images} $image" ;;
    esac
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
        if [ ! -d "$destination/files" ]; then
            echo "create directory '${destination}'..."
            mkdir -p "$destination/files"
        fi
        ;;
    esac

    shift
done

if [ ! "$direct" == "" ]; then
    all_images="$direct"
else
    all_images="$sut_images $sut_packages $ref_images $ref_packages"
fi

for image in $all_images; do
    url="${baseurl}/${image}"
    filename="$(echo $image | grep -oE "^((\bref\b)|(\bsut\b))*(.*)((\bx86_64\b)|(\bi686\b)|(\bi586\b))")"
    case $image in
	*.packages) filename="$(echo $filename | sed 's#\.#-#').packages" ;;
	*.qcow2)    filename="$(echo $filename | sed 's#\.#-#').qcow2"    ;;
    esac
    tmpfile=`mktemp -q "${destination}/files/${image}.XXXXXXXXXX"`
    if [ "x$tmpfile" != x ] && wget -q "$url" -O "${tmpfile}" ; then
        sync
	case $image in
	*.packages)
		rm -f `readlink -e "${destination}/files/${filename}"` \
			"${destination}/files/${filename}"
		ln -sf "$image" "${destination}/files/${filename}"
		mv -f "$tmpfile" "${destination}/files/${image}" || exit 1
	;;
	*.qcow2)
		rm -f `readlink -e "${destination}/${filename}"` \
			"${destination}/${filename}"
		ln -sf "files/$image" "${destination}/${filename}"
		mv -f "$tmpfile" "${destination}/files/${image}" || exit 1
	    	echo " * found ${filename}..."
	        size=`du -m "${destination}/files/${image}" | cut -f1`
	        echo "${url} -> ${destination}/${filename} (${size}M)"
	;;
	esac
    else
        exit 1
    fi
done
