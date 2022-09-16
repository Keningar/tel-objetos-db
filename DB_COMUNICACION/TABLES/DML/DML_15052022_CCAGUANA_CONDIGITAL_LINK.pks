/**
 *Creación de la plantilla de correo para credenciales temporales
 *
 *
 * @author Carlos Caguana  <ccaguana@telconet.ec>
 * @version 1.0 01-03-2022
 */


SET DEFINE OFF;
SET SERVEROUTPUT ON ;

DECLARE
  registro_correo   DB_COMUNICACION.ADMI_PLANTILLA%ROWTYPE;
  plantilla_links CLOB;

BEGIN
    

  
  INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (ID_PLANTILLA,NOMBRE_PLANTILLA,CODIGO,MODULO,PLANTILLA,ESTADO,FE_CREACION,USR_CREACION,EMPRESA_COD) 
  VALUES (DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,'Notificacion Contrato Digital Link Cláussulas y Datos Bancarios', 'CONDIGITAL_LINK', 'COMERCIAL', '', 'Activo', SYSDATE, 'ccaguana', NULL);

  plantilla_links := '<html>

<head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>

<body>
    <table align="center" width="40%" cellspacing="0" cellpadding="5">
        <tr>
            <td align="center">
                <img alt="" height="250" width="600" src="https://gallery.mailchimp.com/ecceab7377f33e3b122ec2a74/images/26d2b77d-827c-43de-b27b-f9f3e9e5bb75.png" />
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%" cellspacing="0" cellpadding="5" align="center" style="font-family:arial;text-align: justify;">
                    <tr>
                        <td colspan="2" align="center">
                            <h2>Hola {{nombrecliente}}</h2>
                            <hr>
                        </td>
                    </tr>




                    <table role="module" cellpadding="0" cellspacing="0" width="100%" style="table-layout:fixed">
                        <tbody>
                            <tr>
                                <td style="padding:0px 0px 0px 0px;line-height:20px;text-align:inherit" height="100%" valign="top" role="module-content">
                                    <div>
                                        <div style="font-family:inherit;text-align:inherit">
                                            <span style="font-family:Arial,sans-serif;font-size:16px">Ingresa a tu cuenta de
                                                <a href="{{url}}">netlife</a> con las credenciales generadas  para continuar el proceso de contrataci&oacute;n.
                                            </span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <br>
                    <br>

                    <div style="font-family:inherit;text-align:center">

                        <div style="font-family:inherit;">
                            <span style="font-family:Arial,sans-serif;font-size:16px">
                                <strong>Usuario:</strong> {{usuario}}
                            </span>
                        </div>


                        <div style="font-family:inherit;">
                            <span style="font-family:Arial,sans-serif;font-size:16px">
                                <strong>Contrase&ntilde;a:</strong> {{password}}
                            </span>
                        </div>
                    </div>




                    <br><br>

                    <tr>
                        <td colspan="2">
                            <strong> EQUIPO NETLIFE</strong> <br> 1-700-683-543 | 3920000
                        </td>
                    </tr>


                    <tr>
                        <td colspan="2" height="30"></td>
                    </tr>

                    <tr>
                        <td colspan="2">

                            <table style="  background-color: #202124; width: 100%;">
                                <tr>
                                    <td width="140">
                                    </td>
                                    <td width="20">
                                        <a href="https://www.facebook.com/netlife.ecuador?ref=ts&fref=ts" target="_blank">
                                            <img width=24 height=24 src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-facebook-48.png">
                                        </a>
                                    </td>
                                    <td style="padding:0cm 0cm 0cm 3.75pt">
                                        <a href="https://www.facebook.com/netlife.ecuador?ref=ts&fref=ts" target="_blank">/NetlifeEcuador</a>
                                        <td>
                                </tr>

                                <tr>
                                    <td>
                                    </td>
                                    <td>
                                        <a href="https://twitter.com/NetlifeEcuador" target="_blank">
                                            <img width=24 height=24 src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-twitter-48.png">
                                        </a>
                                    </td>
                                    <td style="padding:0cm 0cm 0cm 3.75pt">
                                        <a href="https://twitter.com/NetlifeEcuador" target="_blank">@NetlifeEcuador</a>
                                        <td>
                                </tr>

                                <tr>
                                    <td>
                                    </td>
                                    <td>
                                        <a href="https://www.youtube.com/user/NetlifeEcuador" target="_blank">
                                            <img width=24 height=24 src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-youtube-48.png">
                                        </a>
                                    </td>
                                    <td style="padding:0cm 0cm 0cm 3.75pt">
                                        <a href="https://www.youtube.com/user/NetlifeEcuador" target="_blank">/NetlifeEcuador</a>
                                        <td>
                                </tr>


                            </table>

                            </td>
                    </tr>


                </table>
</body>

</html>';
  
  
  UPDATE DB_COMUNICACION.ADMI_PLANTILLA t SET t.PLANTILLA = plantilla_links WHERE t.CODIGO = 'CONDIGITAL_LINK' AND t.ESTADO = 'Activo';
  --------------------
  
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 2000));
END;

/