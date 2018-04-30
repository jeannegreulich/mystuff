#!/bin/bash

puppet agent --disable

mv /etc/yum.repos.d/simp.repo /etc/yum.repos.d/simp.repo.bak
cat <<EOF > /etc/yum.repos.d/simp.repo
[simp]
name=All CentOS 7 x86_64 base packages and updates
baseurl=https://tastypuppet.tasty.bacon/yum/SIMP/x86_64
enabled=1
gpgcheck=1
gpgkey=https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-puppet
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-puppetlabs
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-SIMP
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-elasticsearch
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-grafana-legacy
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-grafana
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-PGDG-94
    https://tastypuppet.tasty.bacon/yum/SIMP/GPGKEYS/RPM-GPG-KEY-EPEL-7
enablegroups=0
keepalive=0
metadata_expire=3600
sslverify=0
EOF

mv /var/lib/puppet/ssl /var/lib/puppet/ssl-puppet38
yum -y install puppet-agent
host=`hostname`
echo "Sleep after puppet agent install"
sleep 30

cat <<EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
trusted_server_facts = true
freeze_main = false
splay = false
syslogfacility = local6
srv_domain = tasty.bacon
certname = $host
vardir = /opt/puppetlabs/puppet/cache
classfile = $vardir/classes.txt
confdir = /etc/puppetlabs/puppet
logdir = /var/log/puppetlabs/puppet
rundir = /var/run/puppetlabs
runinterval = 1800
ssldir = /etc/puppetlabs/puppet/ssl
ca_server = tastypuppet.tasty.bacon
masterport = 8140
ca_port = 8141
stringify_facts = false
digest_algorithm = sha256
server = tastypuppet.tasty.bacon

[agent]
daemonize = false
report = false
EOF

/opt/puppetlabs/bin/puppet agent -t
