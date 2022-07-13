/**
 * @author Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0
 * @since 06-07-2022  
 * Se crea parametros de configuraciones para transferencia de documentos
 */
SET DEFINE OFF; 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'REGULARIZA_DOCUMENTOS_CD',
    'Parametros para la regularización de documentos de CD',
    'COMERCIAL',
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '172.17.0.1'
  );

   
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REGULARIZA_DOCUMENTOS_CD'
      AND ESTADO             = 'Activo'
    ),
    'REGULARIZAR CONTRATO DE PRODUCTO ADICIONALES',
    q'(SELECT
    inad.tipo TIPO,
    inct.persona_empresa_rol_id personaEmpresaRolId, 
    DB_COMERCIAL.CMKG_REGULARIZACION_MASIVA_DOC.F_ES_CRS(inad.punto_id) cambioRazonSocial,
    inad.punto_id, 
    NVL(inad.numero,0) numeroAdendum,  
    inad.contrato_id contratoId
    FROM DB_COMERCIAL.info_adendum inad, DB_COMERCIAL.info_contrato inct, DB_COMERCIAL.info_servicio insr
    where inad.contrato_id = inct.id_contrato
    and inad.SERVICIO_ID = insr.ID_SERVICIO
    and insr.producto_id is not null
    and inad.estado = 'Activo'
    and insr.estado = 'Activo'
    and (inad.usr_modifica <> 'TELCOS_REGULA' OR inad.usr_modifica is null)
    and inad.fe_creacion BETWEEN to_date('17/06/2022 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and to_date('30/06/2022 23:59:59', 'dd/mm/yyyy hh24:mi:ss')
    GROUP BY inct.persona_empresa_rol_id, inad.punto_id, inad.numero, inad.tipo, inad.contrato_id)',    
    NULL,
    NULL,    
    NULL,    
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '172.17.0.1',
    '18',
    NULL
  );

COMMIT; 
/


