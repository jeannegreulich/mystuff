#! /bin/bash
rm -f ~/7list.output
rm -f ~/7list.found.output

touch ~/7list.output

if $? > 0; then
  echo "cant open output file"
  exit
fi
for x in `cat /tmp/7list`; do
  n="${x}-[0123456789]*"
  echo "listing ${n}"
  ls /mnt/iso/Packages/$n
  if [ $? != 0 ]; then
    echo "${x}" >> ~/7list.output
  else
    echo "${x}" >> ~/7list.found.output
  fi
done
