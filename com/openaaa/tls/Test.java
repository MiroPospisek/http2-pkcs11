package com.openaaa.tls;

import java.util.Arrays;
import java.nio.file.*;
import javax.activation.MimeType;
import javax.activation.MimetypesFileTypeMap;

import org.apache.tomcat.jni.Address;
import org.apache.tomcat.jni.Error;
import org.apache.tomcat.jni.Library;
import org.apache.tomcat.jni.Pool;
import org.apache.tomcat.jni.SSL;
import org.apache.tomcat.jni.SSLContext;
import org.apache.tomcat.jni.SSLSocket;
import org.apache.tomcat.jni.Socket;
import org.apache.tomcat.jni.Status;

public class Test {
  public static String sep = System.getProperty("line.separator");

  public static void main(String[] args) throws Exception {

	byte[] buf = new byte[128000];
	int id, rc, off, end, port = Integer.parseInt(args[1]);
	long pool, client, addr, sock, index;

	Library.initialize(null);
	SSL.initialize(null);
	pool = Pool.create(0);

	System.out.println("SSL version=" + SSL.versionString());

	client = SSLContext.make(pool, SSL.SSL_PROTOCOL_ALL, SSL.SSL_MODE_CLIENT);
        SSLContext.setVerify(client, SSL.SSL_CVERIFY_NONE, 10);

	addr = Address.info(args[0], Socket.APR_INET, port, 0, pool);
	sock = Socket.create(Socket.APR_INET, Socket.SOCK_STREAM, Socket.APR_PROTO_TCP, pool);
	SSLSocket.attach(client, sock);

	/* Initiate TLS connection and wait for TLS handshake */
	if ((rc = Socket.connect(sock, addr)) != 0)
		throw new Exception(Error.strerror(rc));
	if ((rc = SSLSocket.handshake(sock)) != 0)
		throw new Exception(SSL.getLastError());

	Thread.sleep(2000);

	Socket.close(sock);
  }
}
