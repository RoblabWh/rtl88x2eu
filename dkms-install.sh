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

exit $RESULT
