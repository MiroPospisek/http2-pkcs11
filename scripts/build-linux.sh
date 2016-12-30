#!/bin/sh
SSLPKCS11_PREFIX=/opt/aaa
JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
OPENSSL_DIR=`openssl version -a | grep OPENSSLDIR`
OPENSSL_VERSION=`openssl version`
echo "OPENSSL_DIR=$OPENSSL_DIR"
echo "OPENSSL_VERSION=$OPENSSL_VERSION"
echo "JAVA_HOME=$JAVA_HOME"

cd build

cd openssl
git checkout -b OpenSSL_1_0_2-stable origin/OpenSSL_1_0_2-stable
./Configure linux-x86_64 shared --prefix=$SSLPKCS11_PREFIX --openssldir=$SSLPKCS11_PREFIX
make
sudo make install
cd ..

cd libp11
./bootstrap
./configure --prefix=$SSLPKCS11_PREFIX --with-ssl=$SSLPKCS11_PREFIX --with-enginesdir=$SSLPKCS11_PREFIX/lib/engines
make
make  openssl_version fork-test evp-sign rsa-testpkcs11.softhsm \
      rsa-testfork.softhsm rsa-testlistkeys.softhsm rsa-evp-sign.softhsm \
      ec-testfork.softhsm rsa-cert.der rsa-prvkey.der rsa-pubkey.der \
      ec-cert.der ec-prvkey.der ec-pubkey.der
sudo make install
cd ..

cd tomcat-native
./download_deps.sh
cd deps/src/apr
./configure --prefix=$SSLPKCS11_PREFIX
make
cd ../../../
cd native
./buildconf --with-apr=../deps/src/apr/
./configure --prefix=$SSLPKCS11_PREFIX --with-apr=../deps/src/apr/ --with-ssl=$SSLPKCS11_PREFIX --with-java-home=$JAVA_HOME --enable-shared --disable-static
make
sudo make install
cd ..
