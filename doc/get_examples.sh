#!/bin/sh

if [ "$1" = "--download" ]; then
  # Fetch list of references
  cat toc.dump \
    | grep http:// \
    | grep /API/ \
    | awk '{print $NF}' \
    | sort -u \
    > refs.list

  # Download references
  cat refs.list \
    | while read line; do
        echo ":: Fetching ${line}"
        name="$(basename $line)"
        wget -c "$line" -O i/$name
    done
fi

# Get example from references
ls i/* \
  | while read file; do
      echo ":: Parsing ${file}"
      name="$(basename $file .html).eg"
      cat $file \
        | ./source2example.rb \
        | tidy -xml -i --indent-spaces 2 2>/dev/null \
        > o/$name
      grep -q '<' o/$name || rm -fv o/$name
  done
