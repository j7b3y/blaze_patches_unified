#!/bin/bash

set +e

patches="$(readlink -f -- $1)"
trees=`ls -l $1 | grep ^d | awk '{print $9}'`
for tree in $trees; do
    for project in $(cd $patches/$tree; echo *); do
        p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
        [ "$p" == build ] && p=build/make
        [ "$p" == treble/app ] && p=treble_app
        [ "$p" == vendor/hardware/overlay ] && p=vendor/hardware_overlay
        pushd $p
        for patch in $patches/$tree/$project/*.patch; do
            git am $patch
        done
        popd
    done
done