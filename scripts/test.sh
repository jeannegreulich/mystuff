#!/bin/bash

x=${1}
y=${@}
z=${1+"$@"}

echo "x = ${x} \n y = ${y} \n z = ${z}"

shift

q=${@}

echo "q = ${q}"
