#/sbin/bash

machine=$1

virsh destroy $machine
virsh undefine $machine
virsh pool-destroy $machine
virsh pool-undefine $machine

if [ -d /var/jmg/VM/$machine ]; then
  rm -rf /var/jmg/VM/$machine
fi
