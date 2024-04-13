#!/usr/bin/env bash
set -e
set -x

BUILD_HOME=/build
mkdir -p "$BUILD_HOME"

cd "$BUILD_HOME"
mkdir zlib openssl openssh
wget -q -c https://github.com/madler/zlib/releases/download/v1.3/zlib-1.3.tar.gz -O- | tar zx --strip-components=1 -C zlib
wget -q -c https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz -O- | tar zx --strip-components=1 -C openssl
wget -q -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.6p1.tar.gz -O- | tar zx --strip-components=1 -C openssh

cd "$BUILD_HOME"/zlib
./configure --prefix=/usr/local/openssh --static
make && make install

cd "$BUILD_HOME"/openssl
./config no-asm no-shared --prefix=/usr/local/openssh
make && make install

cd "$BUILD_HOME"/openssh
export CFLAGS="-I/usr/local/openssh/include/"
export LDFLAGS="-L/usr/local/openssh/lib/"
./configure --prefix=/usr/local/openssh --with-ldflags=-static --with-default-path=/usr/bin:/bin:/usr/sbin:/sbin:/sbin:/usr/sbin:/bin:/usr/bin:/data/bin --without-zlib-version-check
make && make install
