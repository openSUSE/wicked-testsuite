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
  script=$(printf "s/@@NAME@@/%s/; s/@@ID@@/%02d/\n" $name $id)
  sed "$script" ref-template.xml > defs/ref-$name.xml
  sed "$script" sut-template.xml > defs/sut-$name.xml
  ((id++))
done
