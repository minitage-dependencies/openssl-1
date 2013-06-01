#!/usr/bin/env bash
W=$(dirname $0)
pushd $W
W=$PWD
c="$1"
i="$2"
mkdir -pv $i
pushd $i >/dev/null
if [[ -e $c ]];then
    cp -v $c $i
fi
#chmod +x $W/splitter.pl
#perl $W/splitter.pl $i/$(basename $c)
popd>/dev/null
