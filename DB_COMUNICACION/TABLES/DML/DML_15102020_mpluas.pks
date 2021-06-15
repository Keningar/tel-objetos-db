/*
 * Insert para contrato digital web.
 */

SET DEFINE OFF

INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA VALUES (DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,'Notificación Pin','NOTIF_PIN','COMERCIAL',TO_CLOB('<html>
    <head>
        <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
    </head>
    <body>
        <table align="center" width="100%" cellspacing="0" cellpadding="5">

            <td style="border:1px solid #6699CC;">
                <table width="100%" cellspacing="0" cellpadding="5">
                    <tr>
                        <td colspan="2">
                            El presente correo es para indicarle el PIN de Instalaci&oacute;n:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <strong>Cedula # {{strCedula}}</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <strong>Pin # {{strPin}}</strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td><strong><font size=''2'' face=''Tahoma''>Telcos + Sistema del Grupo Telconet</font></strong></p>
            </td>
        </tr>
    </table>
</body></html>'),'Activo',sysdate,'mpluas',NULL,NULL,NULL);

COMMIT;
/
