/**
 *
 * Se crean plantillas para la empresa ECUANET con el flujo de Cancelacion y PreCancelacion.
 *	 
 * @author Jonathan Mazon <jmazon@telconet.ec>
 * @version 1.0 03-03-2023
 */


SET DEFINE OFF
--PLANTILLAS CORREO CANCELACION
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA
(ID_PLANTILLA, NOMBRE_PLANTILLA, CODIGO, MODULO, PLANTILLA, ESTADO, FE_CREACION, USR_CREACION, FE_ULT_MOD, USR_ULT_MOD, EMPRESA_COD)
VALUES
 ( DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL, 'Acta de Cancelacion de Servicios EN', 'ACTA_CANCEL_EN', 'COMERCIAL',
TO_CLOB('<html lang="en" style="margin:0;padding:0"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="format-detection" content="telephone=no"><title></title><style type="text/css"> @media screen and (max-width: 480px) {
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
                max-width: 100% !important;
            }
        }') || TO_CLOB('
</style></head><body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0;padding:0;background-color:#ffffff">
    <table class="mailpoet_template" border="0" width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td class="mailpoet_preheader" style="border-collapse:collapse;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#333333;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;-webkit-text-size-adjust:none" height="1">
                
            </td>
        </tr><tr><td align="center" class="mailpoet-wrapper" valign="top" style="border-collapse:collapse;background-color:#ffffff"><!--[if mso]>
                <table align="center" border="0" cellspacing="0" cellpadding="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" cellpadding="0" cellspacing="0" style="border-collapse:collapse;background-color:#f7f7f7;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;max-width:660px;width:100%" bgcolor="#f7f7f7"><tbody><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#f7f7f7!important" bgcolor="#f7f7f7">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://www.netlife.ec/wp-content/uploads/2023/03/HEADER-ECUANET-FACTURA_.png" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr></tbody></table></td>') || TO_CLOB('
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
           
          </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:left">
            <strong> Estimado/a {{ cliente }}</strong><br><p>Mediante el ACTA DE CANCELACI&Oacute;N N&#730; {{numeroTarea}}, se procedi&oacute; a cancelar su servicio bajo el login {{loginCliente}}, ubicado en la direcci&oacute;n {{direccionCliente}}.
            <br><br>') || TO_CLOB('
            Valores pendientes a pagar: {{valorTotalPagal}}
            Si desea revisar el detalle del valor a pagar, descargue el PDF adjunto.
          </p>
        </td>
        </tr><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
          <br><strong>www.ecuanet.ec - visita nuestros canales de pago
            <br>
            GRACIAS POR SER PARTE DE ECUANET.      <br>
            EQUIPO ECUANET</strong>
          
        </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>') || TO_CLOB('
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://ecuanet.ec/wp-content/uploads/2023/03/ecuanefooter.png" width="150" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;"></img></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#023b9e!important" bgcolor="#023b9e">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td style="width: 100px;">
            <div style="background: #ce1d24;
            padding-left: 5px;') || TO_CLOB('
            border-radius: 10px;
            height: 40px;">
            <a href="https://www.facebook.com/ecuanet.ec" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/facebookIconmail.png"></img></a>
            <a href="https://www.instagram.com/ecuanet.ec/" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/InstagramIconmail.png"></img></a>
            <a href="https://www.tiktok.com/@ecuanet.ec" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/tiktokIconmail.png"></img></a>
            </div>
          </td>
          <td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
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
'), 'Activo', SYSDATE, 'jmazon', NULL, NULL, NULL);

--PLANTILLA CORREO PRECANCELACION
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA
(ID_PLANTILLA, NOMBRE_PLANTILLA, CODIGO, MODULO, PLANTILLA, ESTADO, FE_CREACION, USR_CREACION, FE_ULT_MOD, USR_ULT_MOD, EMPRESA_COD)
VALUES
 ( DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL, 'Acta de PreCancelacion de Servicios EN', 'ACTA_PRECAN_EN', 'COMERCIAL',
TO_CLOB('<html lang="en" style="margin:0;padding:0"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="format-detection" content="telephone=no"><title></title><style type="text/css"> @media screen and (max-width: 480px) {
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
                max-width: 100% !important;
            }
        }
</style></head><body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0;padding:0;background-color:#ffffff">
    <table class="mailpoet_template" border="0" width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td class="mailpoet_preheader" style="border-collapse:collapse;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#333333;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;-webkit-text-size-adjust:none" height="1">
') || TO_CLOB('                
            </td>
        </tr><tr><td align="center" class="mailpoet-wrapper" valign="top" style="border-collapse:collapse;background-color:#ffffff"><!--[if mso]>
                <table align="center" border="0" cellspacing="0" cellpadding="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" cellpadding="0" cellspacing="0" style="border-collapse:collapse;background-color:#f7f7f7;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;max-width:660px;width:100%" bgcolor="#f7f7f7"><tbody><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#f7f7f7!important" bgcolor="#f7f7f7">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://www.netlife.ec/wp-content/uploads/2023/03/HEADER-ECUANET-FACTURA_.png" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>') || TO_CLOB('
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
           
          </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:left">
            <strong>Estimado/a {{ cliente }}</strong><br><p> Seg&uacute;n tarea interna {{numeroTarea}}, se recepta la solicitud de cancelaci&oacute;n del servicio bajo el login {{loginCliente}}, ubicado en la direcci&oacute;n {{direccionCliente}}. Se notificar&aacute; por correo cuando el servicio se encuentre cancelado.
          </p>') || TO_CLOB('
        </td>
        </tr><tr><td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
          <br><strong>www.ecuanet.ec - visita nuestros canales de pago
            <br>
            GRACIAS POR SER PARTE DE ECUANET.      <br>
            EQUIPO ECUANET</strong>
          
        </td>
        </tr></tbody></table></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody></tbody></table></td>
      </tr></tbody></table></td>') || TO_CLOB('
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://ecuanet.ec/wp-content/uploads/2023/03/ecuanefooter.png" width="150" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;"></img></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#023b9e!important" bgcolor="#023b9e">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td style="width: 100px;">
            <div style="background: #ce1d24;
            padding-left: 5px;
            border-radius: 10px;
            height: 40px;">') || TO_CLOB('
            <a href="https://www.facebook.com/ecuanet.ec" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/facebookIconmail.png"></img></a>
            <a href="https://www.instagram.com/ecuanet.ec/" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/InstagramIconmail.png"></img></a>
            <a href="https://www.tiktok.com/@ecuanet.ec" target="_blank"><img src="https://ecuanet.ec/wp-content/uploads/2023/03/tiktokIconmail.png"></img></a>
            </div>
          </td>
          <td class="mailpoet_paragraph" style="border-collapse:collapse;mso-ansi-font-size:16px;color:#000000;font-family:Arial,&#39;Helvetica Neue&#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center">
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
'), 'Activo', SYSDATE, 'jmazon', NULL, NULL, NULL);


COMMIT;

/
