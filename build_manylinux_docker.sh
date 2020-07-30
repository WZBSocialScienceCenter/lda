#!/bin/bash

#
# Start the manylinux wheel building process on docker
# Set the correct user and group for the generated wheels
#

if ! [ `id -u` -eq 0 ]; then
   echo "you should run this as root"
   exit 1
fi

docker run --rm -e PLAT=manylinux1_x86_64 -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/build_wheels.sh
docker run --rm -e PLAT=manylinux1_i686 -v `pwd`:/io quay.io/pypa/manylinux1_i686 /io/build_wheels.sh

setuser=`stat -c '%U:%G' .`
chown $setuser dist/*.whl
