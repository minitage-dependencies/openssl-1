#!/usr/bin/env bash
# stolen from the gentoo ca-certificates ebuild : ca-certificates-20090709.ebuild
cd $(dirname $0)
if [[ ! -f sys/share/minitage/minitage.env ]];then
    ../../bin/paster create -t minitage.instances.env --no-interactive openssl-1
fi
. sys/share/minitage/minitage.env
TOP=$PWD
DATA="$TOP/ca-certificates"
P=$TOP/parts/part/ssl


FN="ca-certificates_20111025_all.deb"
SRC="http://ftp.de.debian.org/debian/pool/main/c/ca-certificates/$FN"
uco="$TOP/tmp/usr/sbin/update-ca-certificates"
uc="$TOP/update-ca-certificates"

sed=$(which gsed)
if [[ -z $sed ]];then sed=sed;fi
mkdir tmp
cd tmp
curl -O $SRC
dpkg-deb -x $FN .
[[ -f  data.tar.gz ]] && tar xzf data.tar.gz
rm -f control.tar.gz data.tar.gz debian-binary
pushd usr/share/ca-certificates/
# | $sed -re s:^:$DATA/:g 
find . -name '*.crt' | sort | cut -b3-  > $TOP/ca-certificates.conf
cp -rf . $DATA
cp -f $uco $uc
$sed -re 's:^CERTSCONF=.*:cd $(dirname $0);TOP="$PWD";CERTSCONF=$TOP/ca-certificates.conf:g' -i $uc
$sed -re 's:^CERTSDIR=.*:CERTSDIR=$TOP/ca-certificates:g' -i $uc
$sed -re 's:^LOCALCERTSDIR=.*:LOCALCERTSDIR=$TOP/ca-certificates:g' -i $uc
$sed -re 's:^ETCCERTSDIR=.*:ETCCERTSDIR=$TOP/etc/certs:g' -i $uc
$sed -re 's:^HOOKSDIR=.*:HOOKSDIR=$TOP/tmp/etc/ca-certificates/update.d:g' -i $uc
#$sed -re 's:^CERTBUNDLE=.*:CERTBUNDLE=$:g' -i $uc
popd
$uc
