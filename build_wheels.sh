#!/bin/bash

#
# Build manylinux wheels inside manylinux docker image
#

set -e -u -x

function repair_wheel {
    wheel="$1"
    if ! auditwheel show "$wheel"; then
        echo "Skipping non-platform wheel $wheel"
    else
        auditwheel repair "$wheel" --plat "$PLAT" -w /io/dist
    fi
}


#LAST=$(git tag --sort version:refname | grep -v rc | tail -1)

#echo "Building wheels for: $LAST"
#git checkout $LAST

PYVERS="36 37 38"
#PYVERS="38"

for v in $PYVERS; do
  cd /io

  if [ $v -eq "38" ] ; then
    m=""
  else
    m="m"
  fi

  pypath="/opt/python/cp$v-cp$v$m"
  pip="$pypath/bin/pip"
  py="$pypath/bin/python"

  echo "Building for Python $v in $pypath"
  $py --version
  $py -c "import struct; print(struct.calcsize('P') * 8)"

  echo "Installing dependencies via $pip"
  $pip install wheel
  $pip install -r requirements.txt
  $pip install -r test-requirements.txt

  echo "Generating wheel"
  make cython
  $py setup.py clean
  mkdir -p dist/tmp
  $py setup.py bdist_wheel --dist-dir dist/tmp
done


for whl in `ls dist/tmp/*.whl`; do
  echo "Bundling external shared libraries into the wheel $whl"

  repair_wheel $whl
done

rm -r dist/tmp

for v in $PYVERS; do
  cd /io

  if [ $v -eq "38" ] ; then
    m=""
  else
    m="m"
  fi

  pypath="/opt/python/cp$v-cp$v$m"
  pip="$pypath/bin/pip"
  py="$pypath/bin/python"

  echo "Installing wheel for testing Python $v"
  $pip install --pre --no-index -f dist/ ldafork

  mkdir -p tmp
  cd tmp
  $py -m unittest discover lda
  cd ..
  rm -r tmp
done

