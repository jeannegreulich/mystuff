#!/bin/sh

editxml() {
  file=$1
  mac=$2
  disk=$3
  kvmid=$4
  vnc=$5
  mtap=$6
  name=$7

  myuuid=`uuid -m`
  sed -i "s@<name>.*</name>@<name>$name</name>@g" $file
  sed -i "s/<uuid>.*<\/uuid>/<uuid>$myuuid<\/uuid>/g" $file
  sed -i "s@<source file=\(.*\)/>@<source file=\'$disk\'/>@g" $file
  sed -i -e "s@<mac address=\(.*\)/>@<mac address=\'$mac\'/>@g" $file
  sed -i -e "s@<target dev=\'macvtap0\'/>@<target dev=\'$mtap\'/>@g" $file
  sed -i -e "s@<domain type='kvm' id=\(.*\)>@<domain type='kvm' id=\'$kvmid\'>@g" $file
  sed -i -e "s@type=\'vnc\' port=\(.*\) autoport@type=\'vnc\' port=\'$vnc\' autoport@g" $file
}
#  Edit these numbers for IP Address.  It will create the files for machine 
#  clienty1-x1 through clienty2-x2.  
x1=1
x2=3
y1=122
y2=123 
kvmid=50
vncport=5900
#remote_dir="172.16.1.1:/data2/cr8_data"
remote_dir="root@172.18.101.10:/scratch2/cr8_data"
temp_dir="/data2/cr8_data"
v6temp="v6.template.xml"
v6disk="v6.disk"
v7temp="v7.temp.xml"
v7disk="v7.disk"

if [ ! -d $temp_dir ]; then
	mkdir $temp_dir
fi

for (( y=$y1; y <= $y2 ; ++y ))
do
#Determine what templates to use and copythem from the remote server if you have to
   if [ $y -lt 128 ]; then
     template="$temp_dir/$v6temp"
     disktemp="$temp_dir/$v6disk"
     if [ ! -f $template ]; then
	echo "copy the XML file from server"
	scp $remote_dir/$v6temp $temp_dir/$v6temp
     fi
     if [ ! -f $disktemp ]; then
        echo "Copy the disk from server"
	scp $remote_dir/$v6disk $temp_dir/$v6disk
     fi
   else
     template=$v7temp
     disktemp=$v7disk
     if [ ! -f $template ]; then
       scp $remote_dir/$v7temp $temp_dir/$v7temp
     fi
     if [ ! -f $disktemp ]; then
     scp $remote_dir/$v7disk $temp_dir/$v7disk
     fi
  fi

  for (( x=$x1; x <= $x2 ; ++x ))
  do
    xx="00$x"
    yy="00$y"
    mac="${yy: -3}${xx: -3}"
    mtap="macvtap$mac"
    macadd="CC:CC:CC:${mac:0:2}:${mac:2:2}:${mac:4:2}"
    clientname="client$y-$x"
    echo "Configuring $clientname"
    mod=$(( $x % 11 )) 
    mod="0$mod"
    dir="${mod: -2}"
    diskpath="/hdfs/$dir/$clientname"
    if [ ! -d $diskpath ]; then
	mkdir -p $diskpath
    fi
    disk="$diskpath/disk$y-$x"
    xmlfile="$diskpath/${clientname}.xml"
#   Copy over the template and edit it.
    cp -f $template $xmlfile 
    editxml $xmlfile $macadd $disk $kvmid $vncport $mtap $clientname
    cp -f $disktemp $disk
    virsh create $xmlfile
    ((kvmid+=1))
    ((vncport+=1))
    echo "Done with $clientname"
  done
done

