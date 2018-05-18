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

case $version in
42) cdrom="${cdromdir}/42DVD.iso"
;;
51) cdrom="${cdromdir}/51DVD.iso"
;;
7)  cdrom="/net/ISO/Distribution_ISOs/CentOS-7-x86_64-DVD-1708.iso"
;;
6)  cdrom="/net/ISO/Distribution_ISOs/CentOS-6.9-x86_64-bin-DVD1.iso"
;;
66)  cdrom="${cdromdir}/simp6-centos6.iso"
;;
67)  cdrom="${cdromdir}/simp6-centos7.iso"
;;
R7)  cdrom="/net/ISO/Distribution_ISOs/rhel-server-7.4-x86_64-dvd.iso"
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


name="libvirtjmg$1-$2-$addr"
diskpath="$vmdir/DISK-$name"
if [ -d $diskpath ]; then
  mv $diskpath $diskpath`date +%Y%j%H%M`
fi

if (( $1 < 10 )) ; then
 fill="0"
 mac="$macprefix$fill$1"
command="virt-install --name=$name -r 4096 --vcpu=2 --vnc --os-type=linux --network=bridge:$nw -m $mac --disk path=$diskpath,size=150,sparse='true' -v --accelerate --cdrom=$cdrom"
# command="virt-install --name=$name -r 4096 --vcpu=2 --vnc --os-type=linux --network=bridge:virbr0 -m $mac --import --disk path=$diskpath -v --accelerate"
else
 fill=""
 mac="$macprefix$fill$1"
 command="virt-install --name=$name --memory 4096 --vcpus=2 --vnc --os-type=linux --network bridge=$nw,mac=$mac,model=rtl8139 --disk path=$diskpath,size=50,sparse='true' -v --accelerate --pxe"
fi

echo $command
exec $command
