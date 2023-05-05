create or replace procedure            InCierreDiario_Mail_Job (pv_novedad       IN VARCHAR2,
                                                                             pv_dia_proceso  in varchar2,
                                                                             pv_compania      in varchar2,
                                                                             pv_centro          in varchar2)   is

  smtp_server     varchar2(100)      := '192.168.2.1';
  x_mail_to       varchar2(255)      := 'prueba@yoveri.com';--MODIFICAR POR EL DESTINATARIO REAL DEL MAIL,
  x_mail_from     varchar2(100)      := 'prueba@yoveri.com';
  x_mail_subject  varchar2(255)      := 'Generacion del proceso automatico de Cierre Diario de Inventarios';
  x_mail_body     varchar2(2000);
  l_mail_conn     utl_smtp.connection;
  Error_proceso   exception;
  lv_error        varchar2(1000);

BEGIN
  -- Mensaje del mail
  x_mail_body := UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Estimada,' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Se procede a correr el proceso automatico de Cierre Diario de Inventarios para Compania: '||pv_compania||' Centro: '||pv_centro|| ' para la fecha:  '||pv_dia_proceso || UTL_TCP.CRLF;

  if pv_novedad is not null then
        x_mail_body := x_mail_body || 'con la siguiente novedad :' || UTL_TCP.CRLF;
        x_mail_body := x_mail_body || UTL_TCP.CRLF;
        x_mail_body := x_mail_body || 'Se actualizaron los siguientes documentos al generar el proceso automatico de Cierre Diario: ' || pv_novedad || UTL_TCP.CRLF;
        x_mail_body := x_mail_body || UTL_TCP.CRLF;
   else
        x_mail_body := x_mail_body || 'No existieron novedades que reportar' || UTL_TCP.CRLF;
        x_mail_body := x_mail_body || UTL_TCP.CRLF;

  end if;

  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Cordialmente.' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'Departamento de Sistemas' || UTL_TCP.CRLF;
  x_mail_body := x_mail_body || 'L. Henriques S.A.' || UTL_TCP.CRLF;

  -- Envio del mail
  l_mail_conn := utl_smtp.open_connection(smtp_server, 25);
  --
  utl_smtp.helo(l_mail_conn, smtp_server);
  utl_smtp.mail(l_mail_conn, x_mail_from);
  utl_smtp.rcpt(l_mail_conn, x_mail_to);
  utl_smtp.open_data(l_mail_conn );
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'From' || ': ' || x_mail_from || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'To' || ': ' || x_mail_to || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(l_mail_conn, 'Subject' || ': ' || nvl(x_mail_subject,'(no subject)') || UTL_TCP.CRLF);
  utl_smtp.write_data(l_mail_conn, x_mail_body);
  utl_smtp.close_data(l_mail_conn );
  utl_smtp.quit(l_mail_conn);
  --

  exception
    when others then
    lv_error:=sqlerrm;

end InCierreDiario_Mail_Job;