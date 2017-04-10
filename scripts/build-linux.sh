#!/bin/sh
SSLPKCS11_PREFIX=/opt/aaa
#export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
OPENSSL_DIR=`openssl version -a | grep OPENSSLDIR`
OPENSSL_VERSION=`openssl version`
PKG_CONFIG_PATH=/opt/aaa/lib/pkgconfig
export LD_LIBRARY_PATH=/opt/aaa/lib
export PATH=/opt/aaa/bin:$PATH
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

cd nghttp2
#./configure --prefix=/opt/aaa --with-ssl=/opt/aaa --enable-app
./configure --prefix=/opt/aaa --with-ssl=/opt/aaa 
make && sudo make install
cd ..

cd apr
./configure --prefix=$SSLPKCS11_PREFIX
make && sudo make install
cd ..

cd apr-util
./configure --prefix=$SSLPKCS11_PREFIX
make && sudo make install
cd ..

cd tomcat-native
cd native
cp -R ../../apr srclib/
cp -R ../../apr-util srclib/
./buildconf --with-apr=srclib/apr
./configure --prefix=$SSLPKCS11_PREFIX --with-apr=srclib/apr --with-ssl=$SSLPKCS11_PREFIX CFLAGS=-DOPENSSL_LOAD_CONF=1
make
sudo make install
cd ..

cd httpd
./configure --prefix=/opt/aaa --enable-http2 --enable-ssl=shared --with-included-apr --enable-mpms-shared=all
make && sudo make install
