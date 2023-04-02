/**
 * DEBE EJECUTARSE EN DB_BUSPAGOS.
 * Creacion de data para nuevo Canal de pago Activa Ecuador Ecuanet
 * Creacion de Parametros de Inicializacion 
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 02/03/2023
 */

DECLARE

    CURSOR c_getdata IS
        select a.* from DB_BUSPAGOS.info_config_ent_rec_emp a where a.entidad_rec_empresa_id = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'activaecuador');
    
    Lr_InfoConfEntRecEmp    DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP%ROWTYPE;
   
BEGIN
    INSERT INTO DB_BUSPAGOS.admi_empresa VALUES (
    db_buspagos.seq_admi_empresa.nextval,
    sysdate,
    null,
    '127.0.0.1',
    'jihidalgo',
    null,
    'Ecuanet',
    33,
    'ecuanet',
    'http://telcos-ws-ext-lb.telconet.ec/rs/financiero/ws/rest',
    'S',
    'Activo'
    );

    INSERT INTO DB_BUSPAGOS.admi_entidad_recaudadora VALUES (
    DB_BUSPAGOS.SEQ_ADMI_ENTIDAD_RECAUDADORA.NEXTVAL,
    sysdate,
    null,
    '127.0.0.1',
    'wdsanchez',
    null,
    null,
    'activaecuadoren',
    'Activa Ecuador Ecuanet',
    'Activo'
    );

    INSERT INTO DB_BUSPAGOS.info_entidad_rec_empresa VALUES (
    DB_BUSPAGOS.SEQ_INFO_ENTIDAD_REC_EMPRESA.NEXTVAL,
    sysdate,
    null,
    '127.0.0.1',
    'wdsanchez',
    null,
    (select ID_ENTIDAD_RECAUDADORA from DB_BUSPAGOS.admi_entidad_recaudadora where codigo = 'activaecuadoren'),
    (select ID_EMPRESA from DB_BUSPAGOS.admi_empresa where codigo = 'ecuanet'),
    'activaecuadoren',
    'NOrH22mvML9o1J68Jor5xg==',
    'activaecuadoren',
    'NOrH22mvML9o1J68Jor5xg==',
    null,
    'https://servicios.redesactiva.com/ActivaTransferSystem/Collection/NETLIFE_Cobranzas.asmx?wsdl',
    'S',
    'S',
    '5',
    '1',
    'Activo',
    '60'
    );

    IF c_getdata%ISOPEN THEN
        CLOSE c_getdata;
    END IF;
    
    FOR Lr_InfoConfEntRecEmp IN c_getdata
    LOOP
        
        INSERT INTO DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP VALUES (
            DB_BUSPAGOS.SEQ_INFO_CONFIG_ENT_REC_EMP.NEXTVAL,
            SYSDATE,
            NULL,
            Lr_InfoConfEntRecEmp.IP_CREACION,
            'jihidalgo',
            NULL,
            (select n.id_entidad_rec_empresa from db_buspagos.info_entidad_rec_empresa n where n.usuario_bus = 'activaecuadoren'),
            Lr_InfoConfEntRecEmp.PARAMETRO,
            Lr_InfoConfEntRecEmp.VALOR,
            Lr_InfoConfEntRecEmp.ESTADO
        );
        
        
    END LOOP;
    
    IF c_getdata%ISOPEN THEN
        CLOSE c_getdata;
    END IF;

    UPDATE db_buspagos.info_config_ent_rec_emp
    SET
        valor = '<html lang="en" style="margin:0;padding:0"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title></title><style type="text/css"> @media screen and (max-width: 480px){.mailpoet_button{width:100% !important;}}@media screen and (max-width: 599px){.mailpoet_header{padding: 10px 20px;}.mailpoet_button{width: 100% !important; padding: 5px 0 !important; box-sizing:border-box !important;}div, .mailpoet_cols-two, .mailpoet_cols-three{max-width: 100% !important;}}</style></head><body style="margin:0;padding:0;background-color:#ffffff"> <table border="0" width="100%"><tbody><tr><td align="center" valign="top" style="background-color:#ffffff"><!--[if mso]> <table align="center" border="0" width="660"> <tr> <td class="mailpoet_content-wrapper" align="center" valign="top" width="660"><![endif]--><table class="mailpoet_content-wrapper" border="0" width="660" style="background-color:#f7f7f7;"><tbody><tr><td align="center" style="border-collapse:collapse;background-color:#ffffff!important" bgcolor="#ffffff"> <table width="100%" border="0"><tbody><tr><td> <table width="100%" border="0"><tbody><tr><td class="mailpoet_image " align="center" valign="top"> <img src="https://fm.telconet.net/fmlurlsvc/?fewReq=:B:JVE3PD49Nyt7MD8jPStkaTA9PDc9PCt+ZGpjbHl4f2gwND07ND07PTo6OD86bG48Pjtubm5rNThuPGhrOj5sbmlsNGluNW5vOCt5MDw7OjQ7NT00OzkrfGRpMD4/QkQ/ZFU/PT04Oz47ID4/QkQ/ZFU5PT04Oz47K39ufXkwK24wOD8rZWlhMD0='
                || CHR(38)
                || 'url=https%3a%2f%2fwww.netlife.ec%2fwp-content%2fuploads%2f2023%2f03%2fECUANET-PLANTILLA-REGISTRO-CREDENCIALESBANNER2.png'
                || CHR(38)
                || 'fmlBlkTk" width="660" alt="" style="height:auto;max-width:100%;-ms-interpolation-mode:bicubic;border:0;display:block;outline:none;text-align:center;width:100%"></img></td></tr></tbody></table></td></tr></tbody></table></td></tr><tr><td valign="top"> <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:'
                || CHR(38)
                || '#39;Trebuchet MS'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Grande'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Sans Unicode'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Sans'
                || CHR(38)
                || '#39;,Tahoma,sans-serif;font-size:22px;line-height:35.2px;mso-line-height-alt:36px;margin-bottom:0;text-align:center;padding:0;font-style:normal;font-weight:normal"><strong>Estimado [CLIENTE]</strong></h3> </td></tr><tr><td align="center"> <table width="100%" border="0"><tbody><tr><td> <div style="background: #fff; border-radius: 10px; width: 500px; border: 2px solid #ccc; margin: 0 auto;padding: 10px;"> <table width="100%" border="0"><tbody><tr><td valign="top"> <h3 style="margin:0 0 6.6px;mso-ansi-font-size:22px;color:#333333;font-family:'
                || CHR(38)
                || '#39;Trebuchet MS'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Grande'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Sans Unicode'
                || CHR(38)
                || '#39;,'
                || CHR(38)
                || '#39;Lucida Sans'
                || CHR(38)
                || '#39;,Tahoma,sans-serif;font-size:16px;line-height:35.2px;mso-line-height-alt:36px;text-align:center;padding:0;font-style:normal;font-weight:normal">Se ha generado el evento de [ACCION] por un valor de <strong>[VALOR_PAGO]</strong> a trav'
                || CHR(38)
                || 'eacute;s del recaudador <strong>Western Union</strong>.</h3> </td></tr></tbody></table></div></td></tr></tbody></table></td></tr><tr><td align="center" style="background-color:#023b9e!important" bgcolor="#023b9e"> <table width="100%" border="0"><tbody><tr><td> <table width="100%" border="0"><tbody><tr><td valign="top"> <table width="100%"><tbody><tr><td style="mso-ansi-font-size:16px;color:#000000;font-family:Arial,'
                || CHR(38)
                || '#39;Helvetica Neue'
                || CHR(38)
                || '#39;,Helvetica,sans-serif;font-size:15px;line-height:24px;mso-line-height-alt:24px;word-break:break-word;word-wrap:break-word;text-align:center"> <span style="color: #ffffff;"><strong>Call center: 7201200 | www.ecuanet.ec</strong></span> </td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table><!--[if mso]> </td></tr></table><![endif]--></td></tr></tbody></table></body></html>'
    WHERE
            parametro = 'MAIL_NOTIFICATION_BODY'
        AND entidad_rec_empresa_id = (
            SELECT
                d.id_entidad_rec_empresa
            FROM
                db_buspagos.info_entidad_rec_empresa d
            WHERE
                d.usuario_bus = 'activaecuadoren'
        );

    UPDATE DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP SET 
        VALOR = 'pagolinea@ecuanet.ec;dbravo@netlife.net.ec;apgarcia@netlife.net.ec;vherrerav@netlife.net.ec;ssalazar@netlife.net.ec;cobranzas@ecuanet.net.ec'
    WHERE PARAMETRO = 'REPORT_CONCILIACION_TO' 
    AND ENTIDAD_REC_EMPRESA_ID = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'activaecuadoren');

    UPDATE DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP SET 
        VALOR = 'pagolinea@ecuanet.net.ec'
    WHERE PARAMETRO = 'MAIL_NOTIFICATION_FROM' 
    AND ENTIDAD_REC_EMPRESA_ID = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'activaecuadoren');

    UPDATE DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP SET 
        VALOR = 'pagolinea@ecuanet.net.ec'
    WHERE PARAMETRO = 'REPORT_CONCILIACION_FROM' 
    AND ENTIDAD_REC_EMPRESA_ID = (select d.ID_ENTIDAD_REC_EMPRESA from DB_BUSPAGOS.info_entidad_rec_empresa d where d.USUARIO_BUS = 'activaecuadoren');

    COMMIT;

END;
/





