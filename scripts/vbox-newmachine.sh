#!/bin/bash
# usage:  vbox-newmachine.sh <ip number> <version> <network>
#
#  ip number:  if 1-9 it will build a server from an iso.
#              if 10-99 it will spawn off a server to kick start.
#              The mac address are set according to version and network
#              they are specific to my set up. You might want to change these.
#              At some time I will configure them to match the packer
#              vagrant boxes.
#            Note: you have to configure your machine to this ip, it just helps me
#            distinguish which machine is which.
#  version : What iso do you want to use?
#            This doesn't matter for a kickstart server but is used in the name.
#           42 = "$isodir/42DVD.iso"
#           51 = "$isodir/51DVD.iso"
#           6  = "/net/ISO/Distribution_ISOs/CentOS-6.9-x86_64-bin-DVD1.iso"
#           7  = "/net/ISO/Distribution_ISOs/CentOS-7-x86_64-DVD-1611.iso"
#           66 = "$isodir/simp6-centos6.iso"
#           67 = "$isodir/simp6-centos7.iso"
#           R7 = "$isodir/rhel-server-7.3-x86_64-dvd.iso"
# network   the number of the virtualbox network ie 1 = vboxnet1
version=$2
num=$1
#
# Where the virtual disk will be created
vmdir="/var/jmg/vms"
# Where you keep your isos
isodir="/var/jmg/ISO"
# An identifier for the name of the virtual machine
# which will be <nameprefix><ip addr>-<version>-<network>
nameprefix="jmg"

case $3 in
br|0)  NW="br1"
     vport=5833
     addr=x
     macprefix="BADC0FFEE3"
;;
v1|1)  NW="vboxnet1"
     vport=5100
     addr=1
     if [[ $version == "67" ]]; then
       macprefix="AABBCCAA00"
     else
       macprefix="AABBCCAA00"
     fi
;;
v4|4)  NW="vboxnet4"
     vport=5400
     addr=4
     if [[ $version == "67" ]]; then
       macprefix="AABBCCDD00"
     else
       macprefix="AABBCCDD00"
     fi
;;
v3|3)  NW="vboxnet3"
     vport=5300
     addr=3
     if [[ $version == "67" ]]; then
       macprefix="AACCCCAA00"
     else
       macprefix="AABBCCCC00"
     fi
;;
v2|2)  NW="vboxnet2"
     vport=5200
     addr=2
     if [[ $version == "67" ]]; then
       macprefix="AACCCCBB00"
     else
       macprefix="AACCCCBB00"
     fi
;;
*)  NW="vboxnet0"
     vport=5000
     addr=0
     if [[ $version == "67" ]]; then
       macprefix="AABBCCDD00"
     else
       macprefix="AABBBBDD00"
     fi
;;
esac

vrdeport=$(($vport + $num))
echo "Using vrdeport $vrdeport"
case $version in
6)  CDROM="/net/ISO/Distribution_ISOs/CentOS-6.9-x86_64-bin-DVD1.iso"
;;
7)  CDROM="/net/ISO/Distribution_ISOs/CentOS-7-x86_64-DVD-1708.iso"
;;
8)  CDROM="/net/ISO/Distribution_ISOs/CentOS-8-x86_64-1905-dvd1.iso"
;;
66)  CDROM="$isodir/simp6-centos6.iso"
;;
67)  CDROM="$isodir/simp6-centos7.iso"
;;
68)  CDROM="$isodir/simp6-centos7.iso"
;;
R7)  CDROM="$isodir/rhel-server-7.3-x86_64-dvd.iso"
;;
W)  CDROM="$isodir/windows-2012-server-eval.iso"
;;
*)  echo "No match for version"
    echo "Version = $2"
   exit
;;
esac

if (( $1 >= 99 || $1 <= 0 )); then
    echo  "first parameter must be 1-99\n"
    echo   "You entered $1."
    exit
fi


VM="${nameprefix}$1-$2-$3"
VMPATH="$vmdir/$VM"
if [ -d $VMPATH ]; then
  mv $VMPATH $VMPATH.`date +%Y%j%H%M`
fi
mkdir -p $VMPATH
chmod 775 $VMPATH

VMDISK=$VMPATH/$VM.vdi

# Create the machine
VBoxManage createhd --filename $VMDISK --size 52468 --format VDI
VBoxManage createvm --name $VM --ostype "Linux_64" --register --basefolder $VMPATH
echo "adding disk drive"
#VBoxManage storagectl $VM --name "SATA Controller" --controller IntelAhci --add sata  --bootable on
VBoxManage storagectl $VM --name "IDE Controller" --add ide  --bootable on
#VBoxManage storagectl $VM --name "SATA Controller" --add sata  --bootable on
#VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VMDISK
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $VMDISK
echo "turn on vrde"
VBoxManage modifyvm $VM --vrde on
VBoxManage modifyvm $VM --vrdeauthtype null
if [ -z $4 ]; then
  VBoxManage modifyvm $VM --firmware bios
else
  VBoxManage modifyvm $VM --firmware efi
fi

#Check if you need to attach the DVD and set the mac address
if (( $1 < 10 )) ; then
 fill="0"
 MACADDR="$macprefix$fill$1"
 RAM=4096
 echo "setting up dvd drive"
 echo "$CDROM"
 VBoxManage storagectl $VM --name "IDE Controller" --add ide --bootable on
 VBoxManage storageattach $VM --storagectl "IDE Controller" --port 1   --device 0 --type dvddrive --medium $CDROM
 VBoxManage modifyvm $VM --boot1 disk --boot2 dvd --boot3 net --boot4 none
elif (( $1 > 70 )) ; then
  fill=""
  MACADDR="$macprefix$fill$1"
  RAM=8192
  echo "setting up dvd drive"
  echo "$CDROM"
  VBoxManage storagectl $VM --name "IDE Controller" --add ide --bootable on
  VBoxManage storageattach $VM --storagectl "IDE Controller" --port 1   --device 0 --type dvddrive --medium $CDROM
  VBoxManage modifyvm $VM --boot1 disk --boot2 dvd --boot3 net --boot4 none
else
 fill=""
 MACADDR="$macprefix$fill$1"
 RAM=2048
 VBoxManage modifyvm $VM --boot1 disk --boot2 net --boot3 net --boot4 none
fi

VBoxManage modifyvm $VM --memory $RAM --vram 128
VBoxManage modifyvm $VM --nic1 hostonly
#VBoxManage modifyvm $VM --nictype1='virtio'
VBoxManage modifyvm $VM --audio none

#set the network boot priority so it use the hostonly network to PXE
#VBoxManage modifyvm $VM --nicbootprio1 4
#VBoxManage modifyvm $VM --nicbootprio2 1
VBoxManage modifyvm $VM --macaddress1 $MACADDR
VBoxManage modifyvm $VM --hostonlyadapter1 $NW
#VBoxManage modifyvm $VM --vrdemulticon on
VBoxManage modifyvm $VM --vrdeaddress 127.0.0.1
VBoxManage modifyvm $VM --vrdeport $vrdeport
VBoxManage modifyvm $VM --vrdeauthtype 'null'
#VBoxManage modifyvm $VM --vrdeproperty "Security/Method=negotiate"
#VBoxManage modifyvm $VM --vrdeproperty "Security/CACertificate=/etc/pki/simp/x509/cacerts/cacerts.pem"
#VBoxManage modifyvm $VM --vrdeproperty "Security/ServerCertificate=/etc/pki/simp_apps/packer/packer-vagrant.pub"
#VBoxManage modifyvm $VM --vrdeproperty "Security/ServerPrivateKey=/etc/pki/simp_apps/packer/packer-vagrant.pem"

VBoxManage startvm $VM --type headless
