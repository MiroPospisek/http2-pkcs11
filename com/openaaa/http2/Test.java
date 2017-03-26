package com.openaaa.wsdl;

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
  public static String fmt = (
	"%s https://%s%s HTTP/1.1\r\nHost: %s\r\n"
	+ "Connection: keep-alive\r\nCache-Control: no-cache\r\n"
	+ "Pragma: no-cache\r\n\r\n");
  public static String sep = System.getProperty("line.separator");
  public static String hts = "\r\n\r\n";
  public static String hth = "\r\n";
  public static String htc = "0\r\n\r\n";
  public static String responseLine;
  public static String transferEncoding;
  public static int contentLength;
  public static int responseSize;
  public static int messageType;

  public static final byte[] copy(byte[] data, int pos, int len) {
	byte[] trn = new byte[len];
	System.arraycopy(data, pos, trn, 0, len);
	return trn;
  }

  public static final void httpHeadersParse(byte[] data, int len) {
	  String[] h = new String(data).split("\r\n");
	  responseLine = h[0];
	  if (!responseLine.startsWith("HTTP/1.1"))
		  return;

	  for (int i = 0; i < h.length; i++) {
		if (h[i].startsWith("Content-Length: ")) {
			int index = new String("Content-Length: ").length();
			contentLength = Integer.parseInt(h[i].substring(index));
			responseSize = contentLength + len;
		} else if (h[i].startsWith("Content-Length: ")) { 
		}
	  }
  }

  public static void main(String[] args) throws Exception {

	byte[] buf = new byte[128000];
	int id, rc, off, end, port = Integer.parseInt(args[1]);
	String url = args[2];
	long pool, client, addr, sock, index;
        byte[] get  = String.format(fmt, "GET",  args[0], url, args[0]).getBytes();
        byte[] post = String.format(fmt, "POST", args[0], url, args[0]).getBytes();	

	Library.initialize(null);
	SSL.initialize(null);
	pool = Pool.create(0);

	System.out.println(new String(get));

	client = SSLContext.make(pool, SSL.SSL_PROTOCOL_ALL, SSL.SSL_MODE_CLIENT);
	SSLContext.setVerify(client, SSL.SSL_CVERIFY_OPTIONAL_NO_CA, 0);

	addr = Address.info(args[0], Socket.APR_INET, port, 0, pool);
	sock = Socket.create(Socket.APR_INET, Socket.SOCK_STREAM, Socket.APR_PROTO_TCP, pool);
	SSLSocket.attach(client, sock);

	/* Initiate TLS connection and wait for TLS handshake */
	if ((rc = Socket.connect(sock, addr)) != 0)
		throw new Exception(Error.strerror(rc));
	if ((rc = SSLSocket.handshake(sock)) != 0)
		throw new Exception(SSL.getLastError());

	/* Waiting for authentication and checks for authorization metadata */
	for (int i = 0; i < 10; i++) {
		if ((rc = Socket.send(sock, get, 0, get.length)) < 1)
			break;
		Arrays.fill(buf, (byte)0);
		responseLine = "";
		responseSize = 0;

		for (messageType = off = rc = 0;; off += rc) {
			rc = Socket.recv(sock, buf, off, buf.length);
			if (rc < 1)
				break;

			byte[] chunk = copy(buf, off, rc);
			String report = new String(chunk);
			if ((index = new String(chunk).indexOf(htc)) != -1)
				break;

			if ((index = new String(chunk).indexOf(hts)) != -1) {
				if (messageType == 0) {
					httpHeadersParse(buf, off + rc);
					messageType = 1;
					continue;
				} else if (messageType == 1) {

				}
			}

			if (responseSize > 0 && responseSize == (off + rc))
				break;

		}

		if (rc > 0)
			System.out.println(responseLine);
		else
			System.out.println("RESULT: " + rc);
		
		Thread.sleep(2000);
	}
	Socket.close(sock);
  }
}
