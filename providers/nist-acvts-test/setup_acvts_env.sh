#!/bin/sh

if [ -z "$1" ]; then
    workingdir="./"
else
    workingdir=$1
fi


rm $workingdir/Directory.Build.props 2>&1 > /dev/null
rm $workingdir/Directory.Packages.props 2>&1 > /dev/null
ln -s $workingdir/_config/Directory.Build.props
ln -s $workingdir/_config/Directory.Packages.props
