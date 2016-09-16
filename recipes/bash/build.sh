#!/usr/bin/env bash

./configure \
              --prefix="${PREFIX}" \
              --enable-alias \
              --enable-arith-for-command \
              --enable-array-variables \
              --enable-directory-stack \
              --enable-history \
              --enable-job-control \
              --enable-readline \
              --enable-select \
	      --with-libiconv-prefix \
	      --with-included-gettext \
	      # --with-libintl-prefix \
              --with-installed-readline \

make
make check
make install
