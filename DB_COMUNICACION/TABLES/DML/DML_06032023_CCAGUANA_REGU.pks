/**
 * Creación de la plantilla de regularización
 *
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 * @version 1.0 06-03-2023
 */


SET DEFINE OFF;
SET SERVEROUTPUT ON ;
  DECLARE 
  Ln_Id NUMBER ;
  Lv_EmpresaCod VARCHAR2(100);
  Lv_Codigo VARCHAR2(100);
  Lv_Nombre VARCHAR2(100);
  Lv_Modulo VARCHAR2(100);
  Lc_Plantilla  CLOB:=' '; 

  CURSOR C_VerificarExistencia (Cv_Codigo VARCHAR2,Cn_EmpresaCod  NUMBER ,Cv_Estado VARCHAR2) IS 
   SELECT ID_PLANTILLA  FROM DB_COMUNICACION.ADMI_PLANTILLA t
   WHERE t.CODIGO = Cv_Codigo
   AND   t.ESTADO = Cv_Estado 
   AND   t.EMPRESA_COD = Cn_EmpresaCod;
	   
      

BEGIN
    


    Lv_Nombre  := 'regularización de cliente'; 
    Lv_Codigo  := 'REGULARIZA_CLI'; 
    Lv_Modulo :=  'COMERCIAL';
    Lv_EmpresaCod := '33'; 

    DBMS_LOB.APPEND(Lc_Plantilla, '<html lang="en" style="margin:0;padding:0"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title></title><style type="text/css"> @media screen and (max-width: 480px) {
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
</style></head><body style="margin:0;padding:0;background-color:#ffffff">
    <table border="0" width="100%"><tbody><tr><td align="center" valign="top" style="background-color:#ffffff"><!--[if mso]>
                <table align="center" border="0"
                       width="660">
                    <tr>
                        <td class="mailpoet_content-wrapper" align="center" valign="top" width="660">
                <![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" style="background-color:#f7f7f7;"><tbody><tr><td align="center" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff">
          <table width="100%" border="0"><tbody><tr><td>
                  <table width="100%" border="0"><tbody><tr><td class="mailpoet_image " align="center" valign="top">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxPzs0NDU8O2hvajQ4bTo1aj01Pz9pPTQ5ND45aTltbTU4NTlqNG0/Pyp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xOT4qZGhgMTw=&url=https%3a%2f%2fwww.netlife.ec%2fwp-content%2fuploads%2f2023%2f03%2fECUANET-PLANTILLA-REGISTRO-CREDENCIALESBANNER2.png&fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td>
      </tr></tbody></table></td>
              </tr></tbody></table></td>
      </tr><tr><td valign="top">
          <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:&#39;Trebuchet MS&#39;,&#39;Lucida Grande&#39;,&#39;Lucida Sans Unicode&#39;,&#39;Lucida Sans&#39;,Tahoma,sans-serif;font-size:22px;line-height:35.2px;mso-line-height-alt:36px;margin-bottom:0;text-align:center;padding:0;font-style:normal;font-weight:normal"><strong>Hola<br>{{nombreCliente}}</strong></h3>
        </td>
      </tr><tr><td align="center">
          <table width="100%" border="0"><tbody><tr><td>
                    <div style="background: #fff;
                    border-radius: 10px;
                    width: 500px;
                    border: 2px solid #ccc;
                    margin: 0 auto;padding: 10px;">
                  <table width="100%" border="0"><tbody><tr><td valign="top">
          <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:&#39;Trebuchet MS&#39;,&#39;Lucida Grande&#39;,&#39;Lucida Sans Unicode&#39;,&#39;Lucida Sans&#39;,Tahoma,sans-serif;font-size:16px;line-height:35.2px;mso-line-height-alt:36px;text-align:center;padding:0;font-style:normal;font-weight:normal">Nos tomamos muy en serio el cuidarte, y nos encanta compartir contigo informaci&oacute;n que sentimos te va a interesar, por esta raz&oacute;n necesitamos que nos ayudes aceptando las opciones en las que quieres ser parte de nosotros para estar siempre actualizado con todo lo que ocurre en el mundo de Ecuanet.</h3>
        </td>
      </tr></tbody></table></div>
                </td>
              </tr><tr><td align="center" style="text-align: center;">
                 <a href="<<linkProspecto>>"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxbThqam4/O2ppO284bz8+OWg0P2g1bjg6Ozw9ajU9bm46NTw6bT9uaip4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xODUqZGhgMTw=&url=https%3a%2f%2fecuanet.ec%2fwp-content%2fuploads%2f2023%2f03%2fECUANET-PLANTILLA-ACEPTAR-OPCIONES.png&fmlBlkTk" width="200"></img></a> </td>
              </tr></tbody></table></td>
      </tr><tr><td class="mailpoet_image " align="center" valign="top" style="border-collapse:collapse">
          <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxaTlqPTs+amo4b25uaT5qOT5qPjRtbT87bmk7aDttPjk8NT1tOD0+OCp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xODUqZGhgMTw=&url=https%3a%2f%2fecuanet.ec%2fwp-content%2fuploads%2f2023%2f03%2fecuanefooter.png&fmlBlkTk" width="150" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;"></img></td>
      </tr><tr><td class="mailpoet_content" align="center" style="border-collapse:collapse;background-color:#023b9e!important" bgcolor="#023b9e">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0"><tbody><tr><td style="border-collapse:collapse;padding-left:0;padding-right:0">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="mailpoet_cols-one" style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0;table-layout:fixed;margin-left:auto;margin-right:auto;padding-left:0;padding-right:0"><tbody><tr><td class="mailpoet_text mailpoet_padded_vertical mailpoet_padded_side" valign="top" style="border-collapse:collapse;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;word-break:break-word;word-wrap:break-word">
          <table style="border-collapse:collapse;border-spacing:0;mso-table-lspace:0;mso-table-rspace:0" width="100%" cellpadding="0"><tbody><tr><td style="width: 100px;">
            <div style="background: #ce1d24;
            padding-left: 5px;
            border-radius: 10px;
            height: 40px;">
            <a href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxNG05ND8/aWo+aW86Om45PG1uNDw7bmpvNDo0PTs6bWk9OT46amo/byp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xPzsqZGhgMTw=&url=https%3a%2f%2fwww.facebook.com%2fecuanet.ec" target="_blank"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxOjU9OzhuPTVvajVuaGpuPj80NThubWk7PDlvajw7bzVpPjVuOT9pNCp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xODUqZGhgMTw=&url=https%3a%2f%2fecuanet.ec%2fwp-content%2fuploads%2f2023%2f03%2ffacebookIconmail.png&fmlBlkTk"></img></a>
            <a href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxNTQ/O281am5uOTs5NG9pOWk/ODg9amo4NDtoOzw8OT81P2poaTQ7PSp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xPzsqZGhgMTw=&url=https%3a%2f%2fwww.instagram.com%2fecuanet.ec%2f" target="_blank"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxbTw9aTs6b249NT1uPWo1ajg9OW1oOj84OztoPj89PW09O2k7ND01byp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xODUqZGhgMTw=&url=https%3a%2f%2fecuanet.ec%2fwp-content%2fuploads%2f2023%2f03%2fInstagramIconmail.png&fmlBlkTk"></img></a>
            <a href="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxPz1vPzw+OW01NDQ7ODg9P25vbTU+b21vOj5vb248PzlpPGo1PD85aSp4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xPzsqZGhgMTw=&url=https%3a%2f%2fwww.tiktok.com%2f%40ecuanet.ec" target="_blank"><img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVI2PT88Nip6MT4iPCplaDE8PTY8PSp/ZWtibXh5fmkxOz87aTo7PD9qPDU7PDtoaTQ1PDxvPmpoPTg5P2k9PTltPm5tajttOip4MT06NDw+ND40PzwqfWVoMT8+WkRIYzxWPDw1NDs5IT8+WkRIYzxuPDw1NDs5Kn5vfHgxKm8xODUqZGhgMTw=&url=https%3a%2f%2fecuanet.ec%2fwp-content%2fuploads%2f2023%2f03%2ftiktokIconmail.png&fmlBlkTk"></img></a>
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

  ');
  


      OPEN C_VerificarExistencia ( Lv_Codigo ,  Lv_EmpresaCod , 'Activo'); 
	    FETCH C_VerificarExistencia  INTO Ln_Id;  
	    CLOSE C_VerificarExistencia ;
	   
	   
     IF  Ln_Id IS NULL THEN
       INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (ID_PLANTILLA,NOMBRE_PLANTILLA,CODIGO,MODULO,PLANTILLA,ESTADO,FE_CREACION,USR_CREACION,EMPRESA_COD) 
       VALUES (DB_COMUNICACION.SEQ_ADMI_PLANTILLA.NEXTVAL, Lv_Nombre ,  Lv_Codigo, Lv_Modulo, Lc_Plantilla , 'Activo', SYSDATE, 'ccaguana', Lv_EmpresaCod);
     ELSE 
        UPDATE DB_COMUNICACION.ADMI_PLANTILLA t  SET
        t.PLANTILLA = Lc_Plantilla , 
        t.FE_ULT_MOD = TO_CHAR( SYSDATE,'YYYY-MM-DD HH24:MI:SS'),
        t.USR_ULT_MOD ='jacarrillo'
        WHERE t.ID_PLANTILLA = Ln_Id ; 
     END IF; 

  
  
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 2000));
END;
  