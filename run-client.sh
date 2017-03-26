export OPENSSL_CONF=./etc/pkcs11-linux.cfg
export OPENAAA_HANDLER=/usr/local/bin/aducid
export OPENAAA_PROTOCOL=aaa
java -Djava.library.path=/opt/aaa/lib -cp "lib/tomcat-native-1.1.30.jar:lib/TLSTest.jar" \
          com.openaaa.tls.Test localhost 443 /
