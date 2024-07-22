#!/bin/sh

cd ./ACVP-Server
rm Directory.Build.props
rm Directory.Packages.props
ln -s ./_config/Directory.Build.props
ln -s ./_config/Directory.Packages.props
