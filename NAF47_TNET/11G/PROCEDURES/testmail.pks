create or replace procedure            testmail
(fromm varchar2,too varchar2,sub varchar2,body varchar2,port number)
is
objConnection utl_smtp.connection;
vrData varchar2(32000);
BEGIN
objConnection := UTL_smtp.open_connection('sissmtp-int.telconet.net',port);
UTL_smtp.helo(objConnection, 'sissmtp-int.telconet.net');
UTL_smtp.mail(objConnection, fromm);
UTL_smtp.rcpt(objConnection, too);
UTL_smtp.open_data(objConnection);
/* ** Sending the header information */
UTL_smtp.write_data(objConnection, 'From: '||fromm || UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection, 'To: '||too || UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection, 'Subject: ' || sub || UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection, 'MIME-Version: ' || '1.0' || UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection, 'Content-Type: ' || 'text/html;');
UTL_smtp.write_data(objConnection, 'Content-Transfer-Encoding: ' || '"8Bit"' ||
UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection,UTL_tcp.CRLF);
UTL_smtp.write_data(objConnection,UTL_tcp.CRLF||'');UTL_smtp.write_data(objConnection,UTL_tcp.CRLF||'');
UTL_smtp.write_data(objConnection,UTL_tcp.CRLF||'<span style="color: red; font-family: Courier New;">'||body||'</span>');
UTL_smtp.write_data(objConnection,UTL_tcp.CRLF||'');UTL_smtp.write_data(objConnection,UTL_tcp.CRLF||'');
UTL_smtp.close_data(objConnection);
UTL_smtp.quit(objConnection);
EXCEPTION
WHEN UTL_smtp.transient_error OR UTL_smtp.permanent_error THEN
UTL_smtp.quit(objConnection);
dbms_output.put_line(sqlerrm);
WHEN OTHERS THEN
UTL_smtp.quit(objConnection);
dbms_output.put_line(sqlerrm);
END testmail;