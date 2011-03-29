#!/usr/bin/env bash
# stolen from the gentoo ca-certificates ebuild : ca-certificates-20090709.ebuild
cd $(dirname $0)
TOP=$PWD
DATA="$TOP/ca-certificates"
P=$TOP/parts/part/ssl
FN="ca-certificates_20090814+nmu3_all.deb"
SRC="http://ftp.de.debian.org/debian/pool/main/c/ca-certificates/$FN"
uco="$TOP/tmp/usr/sbin/update-ca-certificates"
uc="$TOP/update-ca-certificates"
CERTSCONF='$(dirname $0)/ca-certificates.conf'
CERTSDIR='$(dirname $0)$/ca-certificates'
LOCALCERTSDIR='$(dirname $0)/ca-certificates'
CERTBUNDLE='ca-certificates.crt'
ETCCERTSDIR='$(dirname $0)/parts/part/ssl/certs'
sed=$(which gsed)
if [[ -z $sed ]];then sed=sed;fi
mkdir tmp
cd tmp
curl -O $SRC
tar xjf $FN
tar xzf data.tar.gz
rm -f control.tar.gz data.tar.gz debian-binary
pushd usr/share/ca-certificates/
find . -name '*.crt' | sort | cut -b3- | $sed -re s:^:$DATA/:g  > $TOP/parts/part/ssl/ca-certificates.conf
cp -rf . $DATA
cp -f $uco $uc
$sed -re "s:^CERTSCONF=.*:CERTSCONF=$CERTSCONF:g" -i $uc
$sed -re "s:^CERTSDIR=.*:CERTSDIR=$CERTSDIR:g" -i $uc
$sed -re "s:^LOCALCERTSDIR=.*:LOCALCERTSDIR=$LOCALCERTSDIR:g" -i $uc
$sed -re "s:^CERTBUNDLE=.*:CERTBUNDLE=$CERTBUNDLE:g" -i $uc
$sed -re "s:^ETCCERTSDIR=.*:ETCCERTSDIR=$ETCCERTSDIR:g" -i $uc
popd
$uc
