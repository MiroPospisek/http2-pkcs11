#!/bin/sh
cd build
wget https://github.com/nghttp2/nghttp2/releases/download/v1.20.0/nghttp2-1.20.0.tar.gz
tar xzvf nghttp2-1.20.0.tar.gz
wget http://www-eu.apache.org/dist//httpd/httpd-2.4.25.tar.gz
tar xzvf httpd-2.4.25.tar.gz
git clone https://github.com/openssl/openssl.git
git clone https://github.com/OpenSC/libp11.git
git clone https://github.com/nghttp2/nghttp2.git
git clone https://github.com/apache/tomcat-native.git
cd tomcat-native
./download_deps.sh
cd ..
cd ..
