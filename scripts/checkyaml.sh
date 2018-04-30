#!/bin/sh
for x in `find hieradata -name "*.yaml"`; do
  echo "checking $x"
  ruby -ryaml -e "YAML.parse_file('$x')"
done
