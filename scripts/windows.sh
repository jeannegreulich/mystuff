#!/bin/bash

# Where the virtual disk will be created
vmdir="/var/jmg/VM"
# Where you keep your isos
isodir="/var/jmg/ISO"
nameprefix="jmg"

macprefix="AABBCCCCCC"
vrdeport=5999
echo "Using vrdeport $vrdeport"
CDROM="$isodir/windows-server-2012-eval.iso"
VM="windows2012"
VMPATH="$vmdir/$VM"
if [ -d $VMPATH ]; then
  rm -rf $VMPATH 
fi
mkdir -p $VMPATH
chmod 775 $VMPATH

VMDISK=$VMPATH/$VM.vdi

# Create the machine
VBoxManage createhd --filename $VMDISK --size 32768 --format VDI
VBoxManage createvm --name $VM --ostype "Windows2012_64" --register --basefolder $VMPATH
echo "adding disk drive"
VBoxManage storagectl $VM --name "SATA Controller" --controller IntelAhci --add sata  --bootable on
#VBoxManage storagectl $VM --name "IDE Controller" --add ide  --bootable on
#VBoxManage storagectl $VM --name "SATA Controller" --add sata  --bootable on
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VMDISK
#VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $VMDISK
echo "turn on vrde"
VBoxManage modifyvm $VM --vrde on
VBoxManage modifyvm $VM --vrdeauthtype null
VBoxManage modifyvm $VM --firmware bios
NW="vboxnet5"
MACADDR="${macprefix}99"
RAM=4096
echo "setting up dvd drive"
echo "$CDROM"
VBoxManage storagectl $VM --name "IDE Controller" --add ide --bootable on
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 1   --device 0 --type dvddrive --medium $CDROM
VBoxManage modifyvm $VM --boot1 disk --boot2 dvd --boot3 net --boot4 none

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
VBoxManage modifyvm $VM --vrdeproperty "Security/Method=negotiate"
VBoxManage modifyvm $VM --vrdeproperty "Security/CACertificate=/etc/pki/simp/x509/cacerts/cacerts.pem"

VBoxManage modifyvm $VM --vrdeproperty "Security/ServerCertificate=/etc/pki/simp_apps/packer/packer-vagrant.pub"

VBoxManage modifyvm $VM --vrdeproperty "Security/ServerPrivateKey=/etc/pki/simp_apps/packer/packer-vagrant.pem"

VBoxManage startvm $VM --type headless
