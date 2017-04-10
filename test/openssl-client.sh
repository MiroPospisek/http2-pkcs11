#!/bin/sh
openssl s_client -tlsextdebug -no_ticket -connect www.cyberciti.biz:443 <<<EOF\
        | grep -i 'pkcs\|SSL\|Session\|Protocol\|key\|tls\|extension'
