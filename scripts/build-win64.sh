#!/bin/sh
SSLPKCS11_BUILD_PREFIX=/opt/aaa
BUILD_PREFIX=x86_64-w64-mingw32
#export CC=$BUILD_PREFIX-gcc
#export CXX=$BUILD_PREFIX-g++
#export CPP=$BUILD_PREFIX-cpp
#export RANLIB=$BUILD_PREFIX-ranlib
export PATH="/usr/$BUILD_PREFIX/bin:$PATH"
export WINDRES="$BUILD_PREFIX-windres"
export LD_LIBRARY_PATH=$SSLPKCS11_BUILD_PREFIX/lib
export PKG_CONFIG_PATH=$SSLPKCS11_BUILD_PREFIX/lib/pkgconfig
#export LDFLAGS="-static-libgcc -static-libstdc++ -Wl,-no-undefined -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic"

cd build
cd openssl
git checkout -b OpenSSL_1_0_2-stable origin/OpenSSL_1_0_2-stable
./Configure mingw64 --cross-compile-prefix=$BUILD_PREFIX- --prefix=$SSLPKCS11_BUILD_PREFIX --openssldir=$SSLPKCS11_BUILD_PREFIX shared  
make
sudo make install
cd ..

cd libp11
./bootstrap
./configure --host=$BUILD_PREFIX --build=x86_64-redhat-linux --prefix=$SSLPKCS11_BUILD_PREFIX --with-ssl=$SSLPKCS11_BUILD_PREFIX --with-enginesdir=$SSLPKCS11_BUILD_PREFIX/lib/engines shared
#make
#make  openssl_version fork-test evp-sign rsa-testpkcs11.softhsm \
#      rsa-testfork.softhsm rsa-testlistkeys.softhsm rsa-evp-sign.softhsm \
#      ec-testfork.softhsm rsa-cert.der rsa-prvkey.der rsa-pubkey.der \
#      ec-cert.der ec-prvkey.der ec-pubkey.der
#sudo make install
