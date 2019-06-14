#!/bin/bash

set -xeuo pipefail

CUDA_CONFIG_ARG=""
if [ ${ucx_proc_type} == "gpu" ]; then
    export CFLAGS="${CFLAGS} -I${CUDA_HOME}/include"
    CUDA_CONFIG_ARG="--with-cuda"
fi

cd "${SRC_DIR}/ucx-py"
$PYTHON setup.py build_ext ${CUDA_CONFIG_ARG} install
