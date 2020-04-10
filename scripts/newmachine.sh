version=$2
num=$1

vmdir="/var/jmg/libvirtVM"
cdromdir="/var/jmg/ISO"

case $3 in
br|0)  nw="br1"
     addr=x
     macprefix="BA:DC:0F:FE:E3:"
;;
v1|1)  nw="virbr1"
     addr=1
     if [[ $version == "67" ]]; then
       macprefix="AA:BB:CC:AA:00:"
     else
       macprefix="AA:BB:BB:AA:00:"
     fi
;;
v3|3)  nw="virbr3"
     addr=3
     if [[ $version == "67" ]]; then
       macprefix="AA:BB:CC:CC:00:"
     else
       macprefix="AA:BB:BB:CC:00:"
     fi
;;
v2|2)  nw="virbr2"
     addr=2
     if [[ $version == "67" ]]; then
       macprefix="AA:BB:CC:BB:00:"
     else
       macprefix="AA:BB:BB:BB:00:"
     fi
;;
*)  nw="virbr0"
     addr=0
     if [[ $version == "67" ]]; then
       macprefix="BA:DC:0F:FE:E3:"
     else
       macprefix="AA:BB:BB:DD:00:"
     fi
;;
esac
# Shift pass the three required params
shift;shift;shift

#set default tye for dick bus type to IDE for BIOS systems
bustype='ide'

EXTRA_OPTIONS=''
while [[ $# -gt 0 ]]
do
  key=$1
  case $key in
    -u| --uefi)
      EXTRA_OPTIONS="--boot uefi"
      bustype='sata'
      shift
      ;;
  esac
done

force_boot_cdrom='no'
case $version in
42) cdrom="${cdromdir}/42DVD.iso"
    osvar="rhel6"
;;
51) cdrom="${cdromdir}/51DVD.iso"
    osvar="rhel7"
;;
7)  cdrom="/var/jmg/ISO/CentOS-7-x86_64-DVD-1810.iso"
    osvar="rhel7"
    force_boot_cdrom='yes'
;;
6)  cdrom="/net/ISO/Distribution_ISOs/CentOS-6.10-x86_64-bin-DVD1.iso"
    osvar="rhel6"
    force_boot_cdrom='yes'
;;
66) cdrom="${cdromdir}/simp6-centos6.iso"
    osvar="rhel6"
;;
67) cdrom="${cdromdir}/simp6-centos7.iso"
    osvar="rhel7"
;;
77) cdrom="${cdromdir}/bridge-centos7.iso"
    osvar="rhel7"
    force_boot_cdrom='yes'
;;
R7) cdrom="/net/ISO/Distribution_ISOs/rhel-server-7.4-x86_64-dvd.iso"
    osvar="rhel7"
    force_boot_cdrom='yes'
;;
*)  echo "No match for version"
    echo "Version = $version"
   exit
;;
esac

if (( $num >= 99 || $num <= 0 )); then
    echo  "first parameter must be 1-99\n"
    echo   "You entered $num"
    exit
fi


name="libvirtjmg$num-$version-$addr"
diskpath="${vmdir}/DISK-${name}"
if [ -d $diskpath ]; then
  mv $diskpath ${diskpath}`date +%Y%j%H%M`
fi


if (( $num < 10 )) ; then
 fill="0"
 mac="${macprefix}${fill}${num}"
#command="virt-install --name=$name -r 4096 --vcpu=2 --vnc --os-variant=$osvar --os-type=linux --network=bridge:$nw -m $mac --disk path=$diskpath,bus=${bustype},size=75,sparse='true' --disk device=cdrom,bus=${bustype},path=$cdrom -v --accelerate $EXTRA_OPTIONS"
command="virt-install --name $name --ram 4096 --vcpu=2 --graphics vnc --os-variant=$osvar --os-type=linux --network bridge=$nw,mac=$mac,model=rtl8139 --disk path=$diskpath,bus=${bustype},size=75,sparse='true' --disk device=cdrom,bus=${bustype},path=$cdrom -v --accelerate $EXTRA_OPTIONS"
# command="virt-install --name=$name -r 4096 --vcpu=2 --vnc --os-type=linux --network=bridge:virbr0 -m $mac --import --disk path=$diskpath -v --accelerate"
else
 fill=""
 mac="${macprefix}${fill}${num}"
  if [ $force_boot_cdrom == 'yes' ]; then
    command="virt-install --name $name --ram 4096 --vcpu=2 --graphics vnc --os-variant=$osvar --os-type=linux --network bridge=$nw,mac=$mac,model=rtl8139 --disk path=$diskpath,bus=${bustype},size=75,sparse='true' --disk device=cdrom,bus=${bustype},path=$cdrom -v --accelerate $EXTRA_OPTIONS"
  else
    command="virt-install --name $name --ram 512 --vcpus=2 --graphics vnc --os-variant=$osvar --os-type=linux --network bridge=$nw,mac=$mac,model=rtl8139 --disk path=$diskpath,size=50,sparse='true',bus=${bustype} -v --accelerate  $EXTRA_OPTIONS --pxe"
  fi
fi

echo $command
exec $command
