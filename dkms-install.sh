#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  exit 1
else
  echo "About to run dkms install steps..."
fi

DRV_NAME=rtl88x2eu
DRV_VERSION=5.15.0.1

cp -r "$(realpath "$(pwd)")" /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

if [ $RESULT -ne 0 ]; then
  echo "Failed to install driver."
  exit $RESULT
fi

echo "Finished running dkms install steps."

SYSCTL_DIR="/etc/sysctl.d"

[ ! -d ${SYSCTL_DIR} ] && mkdir /etc/sysctl.d

if echo "#Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" > ${SYSCTL_DIR}/${DRV_NAME}.conf; then
	sysctl -p ${SYSCTL_DIR}/${DRV_NAME}.conf
	echo "Disabled IPv6 Successfuly"
else
	echo "Could not disable IPv6"
fi

exit $RESULT
