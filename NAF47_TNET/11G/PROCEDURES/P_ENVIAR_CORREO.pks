create or replace procedure            P_ENVIAR_CORREO
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
  vTo VARCHAR2(200);

begin
  vHTML := '<table border=1 width=500px heigth= 100%>
            <tr><td ALIGN = "CENTER" VALIGN="CENTER"><img align="absmiddle" WIDTH=120 HEIGHT=50 src="q:/comun/logo/logo.jpg"/>
            </td><td WIDTH=350><h4>PROVEEDOR:</h4>';
  vHTML := vHTML||'Manuel Osvaldo Yuquilima'||'</td>
           <td WIDTH=100><h4>FECHA DE ENVIO:</h4>'||'30-oct-2008'||'</td>
           </tr>
           <tr>
           <td WIDTH=500 colspan=3>
           <h4>OBSERVACIONES:</h4>'||'Prueva de Envio de Correo'||'</td>
           </tr>
           <tr>
           <th>ARTICULO</th>
           <th>DESRIPCION</th>
           <th>CANTIDAD</th>
          </tr>';
  FOR I IN 1..10 LOOP
       vHTML:=vHTML||'<TR><TD>'||'001-008'||'</TD><TD>'||'ARTICULO DE PRUEBA'||'</TD><TD>'||'10000'||'</TD></TR>';
  END LOOP;
  vHTML:=vHTML||'<TR>
         <td></td>
         <td ALINGN = "CENTER"><H4>TOTAL:</H4></td>
         <td><h4>'||'150000'||'</h4></td>
         </TR>
         </table>';

  vMail1 := 'manueloyuquilimach@yahoo.com';
  vMail2 := 'lobo_solitario_1974@hotmail.com';

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
      filename     => 'pedido_'||'001'||'.html' ----nombre del archivo
      );
    demo_mail.end_attachment( conn => conn );
    demo_mail.end_mail( conn => conn );
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      pError := sqlerrm;
end P_ENVIAR_CORREO;