#!/bin/bash

TESTTOOLS=1
EPASSWORD="EP@ssw0rdP@ssw0rd"
LPASSWORD="LP@ssw0rdP@ssw0rd"
OPASSWORD="OP@ssw0rdP@ssw0rd"
# Check if the tpm is enable on the system

export PATH="/usr/sbin:/sbin:/usr/bin:/bin:${PATH}"

lsmod | grep --quiet tpm_crb

if [ $? != 0 ]; then
  echo "TPM not enabled on system, exiting"
  exit 100
fi

yum install -y -q --enablerepo=base tpm2-tss
yum install -y -q --enablerepo=base tpm2-tools

# If you want edvel tools which contain tests for TPM then install this

if [ $TESTTOOLS == 1 ]; then
  yum install  -y -q --enablerepo=base tpm2-tss-utils
fi

systemctl enable resourcemgr
systemctl start resourcemgr

if [ $? != 0 ]; then
  echo "unable to start resource manager"
  exit 200
fi

tpm2_takeownership -o ${OPASSWORD} -l ${LPASSWORD} -e ${EPASSWORD}
