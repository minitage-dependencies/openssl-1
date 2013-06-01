#!/usr/bin/env bash
W=$(dirname $0)
pushd $W
W=$PWD
c="$1"
i="$2"
mkdir -pv $i
pushd $i >/dev/null
cp -v $c $i
#cat cacert.pem | awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "cert" n ".pem"}'
"chmod +x $W/splitter.pl
"perl $W/splitter.pl $i/$(basename $c)
popd>/dev/null
