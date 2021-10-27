#!/bin/sh
cd /var/VM/
ISO="$1"
VMNAME="$2";
MACADDR="$3";
RHEL="${4:-7}"
# [ "`file $ISO | grep -o ISO | head -1`" != "ISO" ]
test -r ${ISO} > /dev/null
ISO_EXISTS=$? 

if { [ "$ISO" !=  "--" ] && [ "$ISO_EXISTS" = 1 ]; } || [ "$2" == ""  ] || [ "$3" == "" ]; then
  echo "  Run in the format 'spawn-vm.sh <iso> <VM name> <MAC Address>'.";
  echo "  ex. spawn-vm.sh SIMP-5.6-1.3.0-rc4-x86_64.iso server1 00:11:22:33:A1:FF";
  exit
fi

if [ "${RHEL}x" == "x" ]; then
  RHEL=`echo $ISO | awk -F RHEL '{print $2}'  |awk -F- '{print $2}' | awk -F. '{print $1}'`;
fi
echo "'${ISO}'"

if [ $RHEL == 5 ]; then RHEL="5.4"; fi
EXISTS=`virsh list --all | grep $VMNAME`
EXISTSOFF=`virsh list --all | grep $VMNAME | grep "shut off"`;
ignore='false'

echo
echo "Using the following values:"
echo "  ISO:     $ISO"
echo "  VMNAME:  $VMNAME"
echo "  MACADDR: $MACADDR"
echo "  RHEL:    $RHEL"
echo "  EXISTS:  $EXISTS"
echo

still_running () { ps -f -C qemu-kvm | grep $VMNAME | grep 'no-reboot' >& /dev/null; return $?; }

if [ "$1" == '-i' ]; then
  ignore='true'
fi

DISK_ROOT="/dev/shm"
DISK_ROOT="/var/VM"
DISK="${DISK_ROOT}/$VMNAME/Disk1.qcow2"
DISK_DIR=$(dirname "${DISK}")

if [ "$ignore" == 'true' ] || [ ! -d "${DISK_DIR}" ]; then
  echo "Creating directory '${DISK_DIR}' ... "
  mkdir -p "${DISK_DIR}"
elif [ -f "${DISK}" ] && [ ! "$EXISTS" == "" ]; then
  echo "VM $VMNAME already exists, overwriting with the latest..."
  if [ "$EXISTSOFF" == "" ]; then
    echo "Destroying $VMNAME"
    virsh destroy $VMNAME
  fi
  if [ -f "${DISK}/Disk1.base" ]; then
    echo "Removing old snapshots"
    rm -rf ${DISK} ${DISK_ROOT}/$VMNAME/Disk1 ${DISK}_Test
    mv ${DISK_ROOT}/$VMNAME/Disk1.base ${DISK_ROOT}/$VMNAME/Disk1
  fi
  echo "Undefining $VMNAME"
  virsh undefine $VMNAME;
else
  echo "Creating VM..."
fi

echo "Calling virt-install"
echo "--------------------------------------------------------------------------------"
mkdir -p "${DISK_DIR}" 
cat /dev/null > "${DISK}"
chmod -R 775 "${DISK_DIR}"
chown -R root:kvm  "${DISK_DIR}"
qemu-img create -f qcow2 "${DISK}" ${DISK_SIZE:-50G}
[ $? -gt 0 ] && exit
chmod 600 "${DISK}"
INSTALL_METHOD=--cdrom="$ISO"
[ $ISO == -- ] && INSTALL_METHOD="--pxe"
#/usr/bin/virt-install -n "$VMNAME" --memory 4096 --vcpus=2 --vnc --noautoconsole --os-variant="rhel$RHEL" --os-type=linux -w bridge:br1 -m "$MACADDR" --disk=path="${DISK}",size=50,sparse='true',format=qcow2,cache=writeback -v --accelerate ${INSTALL_METHOD} --boot uefi
/usr/bin/virt-install -n "$VMNAME" --memory 4096 --vcpus=2 --vnc --noautoconsole --os-variant="rhel$RHEL" --os-type=linux --network  bridge=br1,mac="$MACADDR" --disk=path="${DISK}",size=50,sparse='true',format=qcow2,cache=writeback -v --accelerate --pxe 
[ $? -gt 0 ] && exit
echo "--------------------------------------------------------------------------------"

wait;

SUCCESS=`/usr/bin/virsh autostart $VMNAME`;
echo $SUCCESS
echo "Installing $VMNAME"
if [ "$SUCCESS"=="Domain $VMNAME marked as autostarted" ]; then
  VNCDISPLAYNUM=`/usr/bin/virsh vncdisplay $VMNAME`
  echo "$VMNAME is using VNC display $VNCDISPLAYNUM"

  while still_running; do
      echo -n '>';
      sleep 5;
  done

  echo

  sleep 5;

  echo "Starting $VMNAME";

  /usr/bin/virsh start $VMNAME;
  echo "VM is starting up, please wait ..."
  sleep 60;
  exit 0;
else
  exit 1;
fi

