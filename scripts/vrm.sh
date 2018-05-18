#/sbin/bash

machine=$1

virsh destroy $machine
virsh undefine $machine
virsh pool-destroy DISK-$machine
virsh pool-undefine DISK-$machine

if [ -d /var/jmg/VM/$machine ]; then
  rm -rf /var/jmg/VM/$machine
fi
