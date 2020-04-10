#
rm -rf /var/lib/puppet/ssl
chkconfig puppet_wait on
sed -i -e 's/^HOSTNAME=.*$//g' /etc/sysconfig/network
rm -rf /var/lib/dhclient
sed -i -e '/^HWADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i -e '/^certname =/d' /etc/puppet/puppet.conf
sed -i -e '/^PermitRootLogin\(.*\)/PermitRootLogin=yes/g' /etc/ssh/sshd_config
sed -i -e '/^certname =/d' /etc/puppet/puppet.conf
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
  rm -f /etc/udev/rules.d/70-persistent-net.rules
  ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
fi
shutdown -h now
