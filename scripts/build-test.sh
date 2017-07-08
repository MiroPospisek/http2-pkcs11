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
export CFLAGS="-g -O0 -DDEBUG"
export CFLAG="-g -O0 -DDEBUG"
export LDFLAGS="-static-libgcc -static-libstdc++ -Wl,-no-undefined -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic"

cd build
#cd openssl
#git checkout -b OpenSSL_1_0_2-stable origin/OpenSSL_1_0_2-stable
#./Configure no-asm -g3 -O0 -fno-omit-frame-pointer -fno-inline-functions mingw64 --cross-compile-prefix=$BUILD_PREFIX- --prefix=$SSLPKCS11_BUILD_PREFIX --openssldir=$SSLPKCS11_BUILD_PREFIX shared 
#make clean
#make
#sudo make install
#cd ..

#cd libp11
#./bootstrap
#./configure --enable-debug --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw32 --enable-shared --prefix=/opt/aaa threads shared mingw PKG_CONFIG_PATH=/opt/aaa/lib/pkgconfig LDFLAGS=$LDFLAGS CFLAGS="$CFLAGS  -fpack-struct=1"
#./configure --host=$BUILD_PREFIX --build=x86_64-redhat-linux --prefix=$SSLPKCS11_BUILD_PREFIX --with-ssl=$SSLPKCS11_BUILD_PREFIX --with-enginesdir=$SSLPKCS11_BUILD_PREFIX/lib/engines shared LDFLAGS=$LDFLAGS
#make clean
#make
#sudo make install
#cd ..
cd apr                                                                          
./configure --prefix=$SSLPKCS11_PREFIX --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw32 --disable-shared --disable-wchar_t CFLAGS="-s -mms-bitfields -DCOM_NO_WINDOWS_H=1"\
	ac_cv_sizeof_long_long=8 ac_cv_sizeof_ssize_t=8 ac_cv_sizeof_size_t=8 ac_cv_sizeof_long=8 apr_cv_mutex_robust_shared="no"
make && sudo make install                                                       
cd ..                                                                           

cd apr-util                                                                     
./configure --prefix=$SSLPKCS11_PREFIX --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw32 --disable-shared --with-apr=../apr
make && sudo make install                                                       
cd ..                                                                           

unset LDFLAGS
cd tomcat-native                                                                
cd native                                                                       
cp -R ../../apr srclib/                                                         
cp -R ../../apr-util srclib/                                                    
./buildconf --with-apr=srclib/apr                                               
./configure --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw32 --disable-shared --prefix=$SSLPKCS11_PREFIX --with-apr=srclib/apr --with-ssl=$SSLPKCS11_PREFIX CFLAGS="-DOPENSSL_LOAD_CONF=1 -Isrclib/apr/include/arch/win32" LDFLAGS="-static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic" 
make                                                                            
sudo make install                                                               
cd ..                                                                           
cd ..
