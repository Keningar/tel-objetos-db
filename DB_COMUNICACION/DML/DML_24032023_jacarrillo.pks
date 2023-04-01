


/**
 *Creación de la plantilla de correo para credenciales temporales
 *
 *
 * @author Jefferson Carrrillo  <jacarrillo@telconet.ec>
 * @version 1.0 24-03-2023
 */


SET DEFINE OFF;
SET SERVEROUTPUT ON ;

DECLARE
  plantilla_links CLOB;

BEGIN
    

 UPDATE DB_COMUNICACION.ADMI_PLANTILLA
 SET EMPRESA_COD = 18,
 FE_ULT_MOD = TO_CHAR( SYSDATE,'YYYY-MM-DD HH24:MI:SS'),
 USR_ULT_MOD ='jacarrillo'
 where CODIGO = 'CONDIGITAL_LINK'
 AND EMPRESA_COD IS NULL;


  
  INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (ID_PLANTILLA,NOMBRE_PLANTILLA,CODIGO,MODULO,PLANTILLA,ESTADO,FE_CREACION,USR_CREACION,EMPRESA_COD) 
  VALUES (DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,'Notificacion Contrato Digital Link Cláussulas y Datos Bancarios', 'CONDIGITAL_LINK', 'COMERCIAL', '', 'Activo', SYSDATE, 'jacarrillo', 33);

  plantilla_links := ' 
<html lang="en" style="margin:0;padding:0"><head><script async="false" type="text/javascript" src="chrome-extension://fnjhmkhhmkbjkkabndcnnogagogbneec/in-page.js"></script><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="format-detection" content="telephone=no"><title></title><style type="text/css"> @media screen and (max-width: 480px) {
            .mailpoet_button {width:100% !important;}
        }
 @media screen and (max-width: 599px) {
            .mailpoet_header {
                padding: 10px 20px;
            }
            .mailpoet_button {
                width: 100% !important;
                padding: 5px 0 !important;
                box-sizing:border-box !important;
            }
            div, .mailpoet_cols-two, .mailpoet_cols-three {
            }
        }
</style></head><body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0;padding:0;background-color:#ffffff">
    <table class="mailpoet_template" border="0" width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td class="mailpoet_preheader" style="border-collapse:collapse;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#333333;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;-webkit-text-size-adjust:none" height="1">

            </td>
        </tr><tr><td align="center" class="mailpoet-wrapper" valign="top" style="border-collapse:collapse;background-color:#ffffff"><!--[if mso]>
                <table align="center" border="0" cellspacing="0" cellpadding="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" cellpadding="0" cellspacing="0" style="border-collapse:collapse;background-color:#f7f7f7;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;max-width:660px;width:100%"><tbody><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVo+NTc0PiJyOTYqNCJtYDk0NT40NSJ3bWNqZXBxdmE5YTQyMWAyYDE9ZTYxZTc2PDRmNmJlNmAwMWdlNGZmNzE0NTBnYDFlZiJwOTUyMzw8Nz03MDIidW1gOTc2QjRCb3RHNDU3NDE1KTc2QjRCb3RBNDU3NDE1InZndHA5Imc5MTYibGBoOTQ='||chr(38)||'url=http%3a%2f%2fwww.netlife.ec%2fwp-content%2fuploads%2f2023%2f03%2fECUANET-PLANTILLA-REGISTRO-CREDENCIALESBANNER2.png'||chr(38)||'fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:'||chr(38)||'#39;Trebuchet MS'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Grande'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Sans Unicode'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Sans'||chr(38)||'#39;,Tahoma,sans-serif;font-size:22px;line-height:35.2px;mso-line-height-alt:36px;margin-bottom:0;text-align:center;padding:0;font-style:normal;font-weight:normal">
            
            <strong>Hola {{nombrecliente}}</strong>
          </h3>
        </td>
      </tr>
      <tr>
        
        <td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                    <div style="background: #fff;
                    border-radius: 10px;
                    width: 570px;
                    border: 2px solid #ccc;
                    margin: 0 auto;padding: 10px;">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:'||chr(38)||'#39;Trebuchet MS'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Grande'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Sans Unicode'||chr(38)||'#39;,'||chr(38)||'#39;Lucida Sans'||chr(38)||'#39;,Tahoma,sans-serif;font-size:16px;line-height:25.2px;mso-line-height-alt:36px;text-align:center;padding:0;font-style:normal;font-weight:normal">
            <span style="font-family:Arial,sans-serif;font-size:16px">
               Ingresa a tu cuenta de <a href="{{url}}">ecuanet</a> 
               con las credenciales generadas  para continuar el proceso de contrataci'||chr(38)||'oacute;n.
            </span> 
           </h3>

           <tr><td class="mailpoet_image mailpoet_padded_vertical mailpoet_padded_side" align="center" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px">
       
            <div style="font-family:inherit;text-align:center">

              <div style="font-family:inherit;">
                  <span style="font-family:Arial,sans-serif;font-size:16px">
                      <strong>Usuario:</strong> {{usuario}}
                  </span>
              </div>


              <div style="font-family:inherit;">
                  <span style="font-family:Arial,sans-serif;font-size:16px">
                      <strong>Contrase'||chr(38)||'ntilde;a:</strong> {{password}}
                  </span>
              </div>
          </div>

</td>
</tr>

      </td>

      </tr>
    
    </tbody></table></div>
                </td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#023b9e!important" bgcolor="#023b9e">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVo+NTc0PiJyOTYqNCJtYDk0NT40NSJ3bWNqZXBxdmE5N2Y2Mz08ZjxiYWBlNzIzYDBmMTM9ZTxlNjIxMTFgNTM9PDxgMmJhPCJwOTUyMzw8Nz03MDIidW1gOTc2QjRCb3RHNDU3NDE1KTc2QjRCb3RBNDU3NDE1InZndHA5Imc5MTYibGBoOTQ='||chr(38)||'url=http%3a%2f%2fwww.netlife.ec%2fwp-content%2fuploads%2f2023%2f03%2fECUANET-PLANTILLA-REGISTROFOOTER.png'||chr(38)||'fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,'||chr(38)||'#39;Helvetica Neue'||chr(38)||'#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
            <span style="color: #ffffff;"><strong>Call center: 7201200 | www.ecuanet.ec</strong></span>
          </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr></tbody></table><!--[if mso]>
                </td>
                </tr>
                </table>
                <![endif]--></td>
        </tr></tbody></table></body></html>
';
  
  
 UPDATE DB_COMUNICACION.ADMI_PLANTILLA t SET t.PLANTILLA = plantilla_links
 WHERE t.CODIGO = 'CONDIGITAL_LINK' 
 AND EMPRESA_COD = 33
 AND t.ESTADO = 'Activo';
  --------------------
 COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 2000));
END;

/