#!/bin/sh
#DIR=$(cd "$(dirname $0)" && pwd)
DIR="workspace/packages/xroad-e2e-client/redhat"
cd $DIR
ROOT=`pwd`
RELEASE=1
DATE=$(date --utc --date @$(git show -s --format=%ct || date +%s) +'%Y%m%d%H%M%S')
HASH=$(git show -s --format=git%h || echo 'local')
SNAPSHOT=$DATE$HASH
FILES=${1-'xroad-*.spec'}
CMD="-ba"

rm -rf ${ROOT}/RPMS/*



rpmbuild \
    --define "xroad_e2e_client_version 0.1.0" \
    --define "rel $RELEASE" \
    --define "snapshot .$SNAPSHOT" \
    --define "_topdir $ROOT" \
    -${CMD} SPECS/xroad-e2e-client.spec



