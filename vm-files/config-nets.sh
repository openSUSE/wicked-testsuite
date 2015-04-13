#! /bin/bash

[ -d defs ] || mkdir defs

id=1
for name in wicked-master \
            wicked-master-nanny \
            wicked-sle12 \
            wicked-sle12-nanny \
            wicked-testing \
            wicked-testing-nanny \
            playground-master \
            playground-master-nanny \
            playground-sle12 \
            playground-sle12-nanny \
            playground-testing \
            playground-testing-nanny; do

  ethn=0
  script=$(printf "s/@@ETHN@@/%d/; s/@@NAME@@/%s/; s/@@ID@@/%02d/\n" $ethn $name $id)
  sed "$script" net-template.xml > defs/net-$name-$ethn.xml
  ((id++))

  ethn=1
  script=$(printf "s/@@ETHN@@/%d/; s/@@NAME@@/%s/; s/@@ID@@/%02d/\n" $ethn $name $id)
  sed "$script" net-template.xml > defs/net-$name-$ethn.xml
  ((id++))
done
