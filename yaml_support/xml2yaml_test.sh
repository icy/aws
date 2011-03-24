#!/bin/sh

_f_2yaml="../xml2yaml.pl"

mkdir -pv ./p/
ls o/*.eg \
  | while read file; do
      name="$(basename $file .eg).yaml"
      echo >&2 ":: Converting $file to YAML"
      $_f_2yaml < $file > ./p/$name
  done

echo >&2 ":: Flush all outputs to $0.yaml"
for f in ./p/*; do
  echo "# path = $f"
  cat $f
done \
  > $0.yaml
