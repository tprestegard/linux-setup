#!/bin/bash

# check that the path to a tarball to upload has been specified
if [[ -z "$1" ]]
then
  echo "Provide path to tarball to upload"
  exit 2
fi
TARBALL=$1

# get basename
FILENAME=${TARBALL##*/}

## local server settings
LOCALPORT=8730
LOCALDIR=source

## server where the repo is stored
REMOTEPORT=873
REMOTEDIR=/repos/lscsoft/source
REMOTEHOST=software.cgca.uwm.edu

## rsync settings
# the export is important so that it is in environment when rsync runs
RSYNC_MODULE=lscsrc
RSYNC_USER=lscsrc
export RSYNC_PASSWORD=8FtcG8Swes42

# This forwards what the $REMOTEHOST calls "localhost" to the $LOCALPORT on
# the localhost running this script. The issue is that rsync may be bound
# on $REMOTEHOST to 127.0.0.1, not the public IP.
SKTFILE=`mktemp --dry-run`
gsissh -C -MS $SKTFILE -fN -L $LOCALPORT:localhost:$REMOTEPORT $REMOTEHOST

# sync the specified file
rsync -RvaHWx --delete \
  --port $LOCALPORT \
  ${TARBALL} $RSYNC_USER@localhost::$RSYNC_MODULE/$FILENAME

# This closes the SSH tunnel
gsissh -S $SKTFILE -O exit $REMOTEHOST
