#!/bin/bash
##
# Copyright 2026 Ghent University
#
# This file is part of opennebula-dashboard-vsc,
# originally created by the HPC team of the University of Ghent (http://ugent.be/hpc).
#
#
# https://github.com/hpcugent/opennebula-dashboard-vsc
#
# opennebula-dashboard-vsc is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation v3.
#
# opennebula-dashboard-vsc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with opennebula-dashboard-vsc. If not, see <http://www.gnu.org/licenses/>.
##
if [[ -z "$1" || -d "$1" ]];then
    echo "You didn't specify anything to build";
    if [ -d "$1" ]
    then
        cd $1
    fi
    spec=`ls *spec | head -1`
    if [ -z "$spec" ]
    then
        echo "No spec file found. Exiting."
        exit 1;
    else
        reg='Name: '
        name=`grep "$reg" $spec |sed "s/$reg//" | sed "s/ //g"`
        reg='Version: '
        vers=`grep "$reg" $spec |sed "s/$reg//" | sed "s/ //g"`
        echo "Found spec $spec: name $name version $vers"
    fi
else
    spec=$1.spec
    name="$1"
fi

if [ -z "$2" ]; then
    if [ -z "$vers" ]
    then
        echo "You didn't specify a version to build";
        exit 1;
    fi
else
    vers="$2"
    echo "Using spec $spec: name $name version $vers"
fi

if grep -qE 'Fedora|release [6-9]' /etc/redhat-release 2>/dev/null || \
   grep -qi 'ubuntu\|debian' /etc/os-release 2>/dev/null; 
then
  myrpmbasedir=$HOME/rpmbuild
else
  myrpmbasedir=/usr/src/redhat
fi

rpmbasedir=${BDISTRPMBASEDIR:-$myrpmbasedir}

echo "----> Building rpm for $name"
src_dir_main=$rpmbasedir/SOURCES/
src_dir=$rpmbasedir/SOURCES/${name}-${vers}
echo "----> Using $src_dir"
mkdir -pv $src_dir

# delete older versions of the rpm since there's no point having old
# versions in there when we still have the src.rpms in the SRPMS dir
echo "----> Cleaning up older packages"
find $rpmbasedir/RPMS -name ${name}-[0-9]\* -exec rm -vf {} \;

echo "----> Copying files"
cp -vr files/* $src_dir
if [ -d data ]
then
  cp -vr data/* $src_dir
fi

# if there's a directory containing the source, as there will be
# for all our own packages, then delete any .tar.gz file that may exist
# for the package and create a new one.
echo "----> Creating new tar"
if [ -d $src_dir ] ;then
   rm -f $src_dir.tar.gz;
   cd $src_dir_main
   tar zcvf ${name}-${vers}.tar.gz ${name}-${vers};
   cd -
fi


echo "----> Building the package"

## -ba: source and binary
## no debuginfo
rpmbuild --define "_topdir $rpmbasedir" -ba --without debuginfo $spec
ec=$?

echo "----> Cleanup"
# if there is a directory, then delete the .tar.gz again
if [ -d ${src_dir} ] ;then
   rm -vf ${src_dir}.tar.gz;
fi

exit $ec
