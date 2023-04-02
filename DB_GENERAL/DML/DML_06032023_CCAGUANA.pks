/**
 * creación de parametros de remitente de email
 *
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 * @version 1.0 06-03-2023
 */

 

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET PARAMETRO_ID=772,
VALOR2='REMITENTE_CORREO'
WHERE ID_PARAMETRO_DET=5832;

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET PARAMETRO_ID=772, 
VALOR2='REMITENTE_CORREO'
WHERE ID_PARAMETRO_DET=5833;



INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'remitente' AND estado = 'Activo')
      ,'remitente Ecuanet'
      ,'notificacionesecuanet@ecuanet.info.ec'
      ,'REMITENTE_CORREO'
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' AND RAZON_SOCIAL='ECUANET'),
          VALOR6,
          VALOR7,        
     OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'remitente'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';

/
COMMIT;
