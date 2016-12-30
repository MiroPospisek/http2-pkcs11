#!/bin/sh
cd build
git clone https://github.com/openssl/openssl.git
git clone https://github.com/OpenSC/libp11.git
git clone https://github.com/nghttp2/nghttp2.git
git clone https://github.com/apache/tomcat-native.git
cd tomcat-native
./download_deps.sh
cd ..
cd ..
