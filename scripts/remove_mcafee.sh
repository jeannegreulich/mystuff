#! /bin/sh

systemctl stop cma ma nails
puppet agent --disable

rpm -e McAfeeFilesForVSE
rpm -e McAfeeVSEForLinux
rpm -e ISecGRt

rpm -e MFEdx
rpm -e MFEcma
rpm -e MFErt

if [ -d /opt/McAfee ]; then
  rm -rf /opt/McAfee
fi

if [ -d /var/McAfee ]; then
  rm -rf /var/McAfee
fi

puppet agent --enable

