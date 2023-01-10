/**
 *Creación de la plantilla de correo para confirmacion de prospecto`
 *
 *
 * @author Edgar Pin Villavicencio <epin@telconet.ec>
 * @version 1.0 08-11-2022
 */


SET DEFINE OFF;
SET SERVEROUTPUT ON ;

DECLARE
  registro_correo   DB_COMUNICACION.ADMI_PLANTILLA%ROWTYPE;
  plantilla_links CLOB;

BEGIN
    

  
  INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (ID_PLANTILLA,NOMBRE_PLANTILLA,CODIGO,MODULO,PLANTILLA,ESTADO,FE_CREACION,USR_CREACION,EMPRESA_COD) 
  VALUES (DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL,'Consentimiento Informado de Prospecto', 'PROSPECTO_INFOR', 'COMERCIAL', '', 'Activo', SYSDATE, 'epin', '18');

  plantilla_links := '<html lang="en" style="margin:0;padding:0"><head><script async="false" type="text/javascript" src="chrome-extension://fnjhmkhhmkbjkkabndcnnogagogbneec/in-page.js"></script><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="format-detection" content="telephone=no"><title></title><style type="text/css"> @media screen and (max-width: 480px) {
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
</style><meta id="dcngeagmmhegagicpcmpinaoklddcgon"></head><body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="margin:0;padding:0;background-color:#ffffff">
    <table class="mailpoet_template" border="0" width="100%" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td class="mailpoet_preheader" style="border-collapse:collapse;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#333333;line-height:1px;max-height:0;max-width:0;opacity:0;overflow:hidden;-webkit-text-size-adjust:none" height="1">
                
            </td>
        </tr><tr><td align="center" class="mailpoet-wrapper" valign="top" style="border-collapse:collapse;background-color:#ffffff"><!--[if mso]>
                <table align="center" border="0" cellspacing="0" cellpadding="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" cellpadding="0" cellspacing="0" style="border-collapse:collapse;background-color:#ffffff;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;max-width:660px;width:100%"><tbody><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+Mzo6MTc1NWEzYjpmZzI7O2AwOjBhN2VlOjA3NmVlYWU6OjRlNzJhNyV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2flopdp%2fbackground0_1.jpg&fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <h3 style="margin:0 0 6.6px;mso-ansi-font-size:20px;color:#333333;font-family:&#39;Trebuchet MS&#39;,&#39;Lucida Grande&#39;,&#39;Lucida Sans Unicode&#39;,&#39;Lucida Sans&#39;,Tahoma,sans-serif;font-size:22px;line-height:35.2px;mso-line-height-alt:36px;text-align:center;padding:0;font-style:normal;font-weight:normal"></h3>
<h3 style="margin:0 0 6.6px;mso-ansi-font-size:20px;color:#333333;font-family:&#39;Trebuchet MS&#39;,&#39;Lucida Grande&#39;,&#39;Lucida Sans Unicode&#39;,&#39;Lucida Sans&#39;,Tahoma,sans-serif;font-size:20px;line-height:35.2px;mso-line-height-alt:36px;margin-bottom:0;text-align:center;padding:0;font-style:normal;font-weight:normal">Hola, Est&aacute;s a un paso de formar parte de la comunidad de NETLIFE &ldquo;Internet Seguro de Ultra Alta Velocidad&rdquo;.
 <br> Agradecemos confirmes tu consentimiento para el env&iacute;o de informaci&oacute;n comercial por medios digitales.
  </h3>
        </td>
      </tr><tr><td class="mailpoet_image mailpoet_padded_vertical mailpoet_padded_side" align="center" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px">
          <a href="<<linkProspecto>>" style="color:#21759B;text-decoration:underline"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+Njs2MjRlNWI3MGU1MjE6MTdgMjU3OjsxYDVgZzFiOjc7MTZmZzo1ZyV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2fbotonEnviar.jpg&fmlBlkTk" width="260" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center"></img></a>
        </td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <a href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+MzY7MGdmZWI0MGEzNGU0NTUzMTszMTtmN2c0YjdmYmFgNjRiMTsxYSV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fonelink.to%2fvkxtda" style="color:#21759B;text-decoration:underline"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZTUzOzNnZWU3MmA3YTMwMTE2MTpmNDdiYTU1YGAzMWYwNmcyMWEyYCV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2flopdp%2fCierre-AccessDc.jpg&fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></a>
        </td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff"><td align="center" style="border-collapse: collapse; font-size: 0;"><!--[if mso]>
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
              <tbody>
                <tr>
    <td width="440" valign="top">
    <![endif]-->
    <div style="display: inline-block; max-width: 440px; vertical-align: top; width: 100%;">
    <table width="440" class="mailpoet_cols-two" border="0" cellpadding="0" cellspacing="0" align="left" style="border-collapse: collapse; width: 100%; max-width: 440px; border-spacing: 0; mso-table-lspace: 0; mso-table-rspace: 0; table-layout: fixed; margin-left: auto; margin-right: auto; padding-left: 0; padding-right: 0;"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse: collapse; word-break: break-word; word-wrap: break-word; padding: 10px 20px 10px 20px;">
    <table style="border-collapse: collapse; border-spacing: 0; mso-table-lspace: 0; mso-table-rspace: 0;" width="100%" cellpadding="0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse: collapse; word-break: break-word; word-wrap: break-word; text-align: center; padding: 28px 20px 10px 20px;">
    <p style="margin: 0 0 9px; color: #ffffff; font-family: &#39;Trebuchet MS&#39;,&#39;Lucida Grande&#39;,&#39;Lucida Sans Unicode&#39;,&#39;Lucida Sans&#39;,Tahoma,sans-serif; font-size: 12px; line-height: 15px; margin-bottom: 0; text-align: center; padding: 0; font-style: normal; font-weight: normal;"></p>
    <a target="_blank" id="41724291" href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+YDMyMWUyZWJhZTowZmIzNTo1ZmFiN2ZgZjYyMzYxMDBgZjY7MGZnZyV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+MDQla2dvPjM=&url=https%3a%2f%2fwww.facebook.com%2fnetlife.ecuador" rel="noopener noreferrer"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZjMwYjthO2A7YGFhYTNiYmcyNWI3OjVhYjJgZjM2Njs7O2BgYWU1ZSV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2ffb-blaack.png&fmlBlkTk" width="30"></img></a> <a target="_blank" id="41724292" href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZTU2ZzJiNzIzMTo6MzU2NDpgYDA0YDNhZzpnNmJmMjE2NmdiMjEyOiV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+MDQla2dvPjM=&url=https%3a%2f%2ftwitter.com%2fnetlifeecuador" rel="noopener noreferrer"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZjJmOmYxMzEzMWVnYmdhNDYyYWJhZmUwYTQzNTBlYTY3NDM1YWc3OiV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2ftw-blaack.png&fmlBlkTk" width="30"></img></a> <a target="_blank" id="41724294" href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+MWYxN2c2MmBiNTYyNjpgOjphNTpmNTQzYTVgNGFiMmFhMDA1MWdlZiV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+MDQla2dvPjM=&url=https%3a%2f%2fwww.instagram.com%2fnetlife_ecuador" rel="noopener noreferrer"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+YjFgZjJiNmUyOjtnOjZgNjAyN2U3NTNgYTNgMjA0NDY6NWZgYTplMCV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2figg-blaack.png&fmlBlkTk" width="30"></img></a> <a target="_blank" id="41724295" href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZjM1ZWE0YTAxOzoxYTUzNDMyNjcyOjQ2ZmJhYGYyOzAzMjs7YDVmNyV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+Nzola2dvPjM=&url=https%3a%2f%2fwww.linkedin.com%2fcompany%2fnetlife-ecuador%2f" rel="noopener noreferrer"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+YDM7Zzo3YmBhNDthNTJgZmJiZWEyMzRiMDplYmBgZ2Y0MDI3MmUzNyV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2fin-blaack.png&fmlBlkTk" width="32"></img></a><a target="_blank" id="41724299" href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+ZjozNDRiMGY0MmVnMjIwM2ExOjM3YDdiMTNiM2c2ZWdmYTowZjYzYSV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+MDQla2dvPjM=&url=https%3a%2f%2fwww.tiktok.com%2f%40netlifeecuador" rel="noopener noreferrer"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+M2I0M2A3Zjs2YTI7MDFiYTczYDI1NDcyYjphNGc2YGc0MmI2YTA2YSV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2ftk-blaack.png&fmlBlkTk" width="32"></img></a></td>
    </tr></tbody></table></td>
    </tr></tbody></table></div>
    <!--[if mso]>
    </td>
    <td width="220" valign="top">
    <![endif]-->
    <div style="display: inline-block; max-width: 220px; vertical-align: top; width: 100%;">
    <table width="220" class="mailpoet_cols-two" border="0" cellpadding="0" cellspacing="0" align="left" style="border-collapse: collapse; width: 100%; max-width: 220px; border-spacing: 0; mso-table-lspace: 0; mso-table-rspace: 0; table-layout: fixed; margin-left: auto; margin-right: auto; padding-left: 0; padding-right: 0;"><tbody><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse: collapse;"><br><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVs5MjAzOSV1PjEtMyVqZz4zMjkzMiVwamRtYnd2cWY+NWBgYmBlMWdnM2cyZzBmMzFgZmc1N2UyNjowMmFnOzEzYTNiNTtnOiV3PjI1NDI1NzY3OjAlcmpnPjFBT0t0RzNCMzE6Nzs1LjFBT0t0RzNAMzE6Nzs1JXFgc3c+JWA+NjEla2dvPjM=&url=https%3a%2f%2fcdnnetlife.konibit.com.mx%2fPROD_ENV%2fimagenes%2fmailing%2fFOOTERUAV.png&fmlBlkTk" width="220" alt="Internet de Ultra Alta Velocidad" style="height: auto; max-width: 100%; -ms-interpolation-mode: bicubic; border: 0; display: block; outline: none; text-align: center; width: 100%;"></img></td>
    </tr></tbody></table></div>
    <!--[if mso]>
    </td>
            </tr>
          </tbody>
        </table>
      <![endif]--></td>
                        </tr></tbody></table><!--[if mso]>
                    </td>
                    </tr>
                    </table>
                    <![endif]--></td>
            </tr></tbody></table></body></html>
  ';
  
  
  UPDATE DB_COMUNICACION.ADMI_PLANTILLA t SET t.PLANTILLA = plantilla_links WHERE t.CODIGO = 'PROSPECTO_INFOR' AND t.ESTADO = 'Activo';
  --------------------
  
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 2000));
END;