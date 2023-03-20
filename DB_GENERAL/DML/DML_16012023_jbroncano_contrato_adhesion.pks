/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones bandera para utilizacion de enviar correo o whtssap
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 12-01-2023 - Versión Inicial.
 */



            
INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
 (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE        
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'),
'NOTIFICACION_WHATSAPP','S',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null,null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
 (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'),
'PLANTILLA_WHATSAPP','netsopp006_v2',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null,null,null);

COMMIT;
/



