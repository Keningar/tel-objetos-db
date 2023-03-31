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
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
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
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET'),
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
            nombre_parametro = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';

COMMIT;
/