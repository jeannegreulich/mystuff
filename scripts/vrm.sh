#/sbin/bash

machine=$1

virsh destroy $machine
virsh undefine --nvram $machine
virsh vol-delete DISK-$machine libvirtVM

if [ -d /var/jmg/VM/$machine ]; then
  rm -rf /var/jmg/VM/$machine
fi
