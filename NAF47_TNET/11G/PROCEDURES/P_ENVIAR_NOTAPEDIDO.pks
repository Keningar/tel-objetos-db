create or replace procedure            P_ENVIAR_NOTAPEDIDO
                              (pCia in VARCHAR2,
                               pPedido  NUMBER,
                               pSender  VARCHAR2,
                               pError out varchar2) is

  conn      utl_smtp.connection;
  --req       utl_http.req;
  --resp      utl_http.resp;
  --data      RAW(200);
  vHTML VARCHAR2(3000);
  vMail1 ARCPMP.EMAIL1%TYPE;
  vMail2 ARCPMP.EMAIL2%TYPE;
  vProv ARIMENCPEDIDO.NO_PROVE%TYPE;
  vTo VARCHAR2(80);

begin
   vHTML := F_CREAR_PEDIDO_HTML(pCia, pPedido);
  BEGIN
    SELECT NO_PROVE INTO vProv
    FROM ARIMENCPEDIDO
    WHERE NO_CIA = pCia
          AND NO_PEDIDO = pPedido;
    EXCEPTION
      WHEN No_Data_Found THEN
        NULL;
  END;
  BEGIN
    SELECT EMAIL1, EMAIL2 INTO vMail1, vMail2
    FROM ARCPMP
    WHERE NO_CIA = pCia
          AND NO_PROVE = vProv;
    EXCEPTION
      WHEN No_Data_Found THEN
        NULL;

  END;
  vTo := '';
  IF vMail1 IS NOT NULL THEN
    vTo := 'Proveedor: <'||vMail1||'>';
  END IF;
  IF vMail2 IS NOT NULL AND vMail1 IS NOT NULL THEN
      vTo := vTo||',Proveedor: <'||vMail2||'>';
    ELSE IF vMail2 IS NOT NULL AND vMail1 IS NULL THEN
      vTo := vTo||'Proveedor: <'||vMail2||'>';
    END IF;
  END IF;

  IF vHTML IS NOT NULL THEN

    conn := demo_mail.begin_mail(
      sender     => pSender,
      recipients => vTo,
      subject    => 'Pedido de importacion',
      mime_type  => demo_mail.MULTIPART_MIME_TYPE);

    demo_mail.attach_text(
      conn      => conn,
      data      => vHTML,
      mime_type => 'text/html',
      inline       => TRUE,
      filename     => 'pedido_'||pPedido||'.html' ----nombre del archivo
      );
    demo_mail.end_attachment( conn => conn );
    demo_mail.end_mail( conn => conn );
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      pError := sqlerrm;
end P_ENVIAR_NOTAPEDIDO;