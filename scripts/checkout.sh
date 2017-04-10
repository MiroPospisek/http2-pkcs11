#!/bin/sh
if [ ! -d "build" ]; then
  mkdir build
fi
cd build
wget https://github.com/nghttp2/nghttp2/releases/download/v1.20.0/nghttp2-1.20.0.tar.gz
tar xzf nghttp2-1.20.0.tar.gz
mv nghttp2-1.20.0 nghttp2
wget http://www-eu.apache.org/dist//httpd/httpd-2.4.25.tar.gz
tar xzf httpd-2.4.25.tar.gz
mv httpd-2.4.25 httpd
wget http://mirrors.ibiblio.org/apache/apr/apr-1.5.2.tar.gz
tar xzf apr-1.5.2.tar.gz
mv apr-1.5.2 apr
git clone https://github.com/openssl/openssl.git
git clone https://github.com/OpenSC/libp11.git
git clone https://github.com/nghttp2/nghttp2.git
git clone https://github.com/apache/tomcat-native.git
cd ..
