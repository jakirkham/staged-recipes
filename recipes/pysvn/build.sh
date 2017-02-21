#!/bin/bash

export PYTHON_FRAMEWORK=""

pushd Source
python setup.py configure \
	--apr-inc-dir="${PREFIX}/include/apr-1" \
	--apu-inc-dir="${PREFIX}/include/apr-1" \
	--apr-lib-dir="${PREFIX}/lib" \
	--svn-inc-dir="${PREFIX}/include/subversion-1" \
	--svn-lib-dir="${PREFIX}/lib"
make
popd

pushd Test
make
popd

pushd Source
mkdir "${SP_DIR}/pysvn"
cp pysvn/__init__.py "${SP_DIR}/pysvn/"
cp pysvn/_pysvn*.so "${SP_DIR}/pysvn/"
popd
