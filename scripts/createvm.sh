name='greatagain'
network='br1'
mac='de:ad:57:57:09:09'
diskpathdir='/var/VM'
diskpath="$diskpathdir/$name"
cdrom='/home/jgreulich/SIMP-6.0.0-RC2-CentOS-7.0-x86_64.iso'
disksize=50
ram=4096
numcpu=2

virt-install \
  --name=$name \
  --ram $ram \
  --vcpu=$numcpu \
  --graphics vnc \
  --os-type=linux  \
  --network=bridge:$network,mac=$mac \
  --disk path=$diskpath,size=$disksize,sparse='true' \
  --cdrom=$cdrom
