CREATE OR REPLACE VIEW "DB_FINANCIERO"."ESTADO_CUENTA_CLIENTE" ("ID_DOCUMENTO", "PUNTO_ID", "OFICINA_ID", "NUMERO_FACTURA_SRI", "TIPO_DOCUMENTO_ID", "VALOR_TOTAL", "FE_CREACION", "FEC_CREACION", "FEC_EMISION", "FEC_AUTORIZACION", "USR_CREACION", "REFERENCIA", "CODIGO_FORMA_PAGO", "ESTADO_IMPRESION_FACT", "NUMERO_REFERENCIA", "NUMERO_CUENTA_BANCO", "REFERENCIA_ID", "MIGRACION", "REF_ANTICIPO_ID") AS 
  SELECT   idfc.id_documento,
            idfc.punto_id,
            idfc.oficina_id,
            idfc.numero_factura_sri,
            idfc.tipo_documento_id,
            idfc.valor_total,            
            idfc.fe_emision as fe_creacion,                     
            TO_CHAR(IDFC.FE_CREACION, 'DD/MM/YYYY HH24:MI') AS FEC_CREACION,
            TO_CHAR(IDFC.FE_EMISION, 'DD/MM/YYYY HH24:MI') AS FEC_EMISION,
            TO_CHAR(IDFC.FE_AUTORIZACION, 'DD/MM/YYYY HH24:MI') AS FEC_AUTORIZACION,
            idfc.usr_creacion,
            '' AS referencia,
            '' AS codigo_forma_pago,
            idfc.estado_impresion_fact,
            '' AS numero_referencia,
            '' AS numero_cuenta_banco,
            idfc.referencia_documento_id AS referencia_id,
            case 
            when ieg.prefijo='MD' then null
            else idfc.num_fact_migracion
            end as migracion,
            0 AS ref_anticipo_id
     FROM   db_financiero.info_documento_financiero_cab idfc
     JOIN   db_comercial.info_oficina_grupo iog on iog.id_oficina=idfc.oficina_id
     JOIN   db_comercial.info_empresa_grupo ieg on iog.empresa_id=ieg.cod_empresa
    WHERE   idfc.estado_impresion_fact NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Pendiente','Eliminado','Rechazado','Aprobada')
   UNION
     SELECT   ipd.id_pago_det,
              ipc.punto_id,
              ipc.oficina_id,
              ipc.numero_pago,
              ipc.tipo_documento_id,
              ipd.valor_pago,
              case
                when ipc.fe_cruce is null then ipc.fe_creacion
                else ipc.fe_cruce  
              end as fe_creacion,
              case
                when ipc.fe_cruce is null then TO_CHAR(IPC.FE_CREACION, 'DD/MM/YYYY HH24:MI')
                else TO_CHAR(IPC.FE_CRUCE, 'DD/MM/YYYY HH24:MI')
              end as FEC_CREACION,                 
              '' AS FEC_EMISION,
              '' AS FEC_AUTORIZACION,
              ipc.usr_creacion,
              '' AS numero_factura_sri,
              afp.codigo_forma_pago,
              ipc.estado_pago,
              ipd.numero_referencia,
              ipd.numero_cuenta_banco,
              ipd.referencia_id,
              case 
              when ieg.prefijo='MD' then null
              else ipc.num_pago_migracion
              end as migracion,
              ipc.ANTICIPO_ID  AS ref_anticipo_id
       FROM    db_financiero.info_pago_cab ipc
              JOIN db_financiero.info_pago_det ipd on ipc.id_pago = ipd.pago_id
              JOIN db_general.admi_forma_pago afp on ipd.forma_pago_id = afp.id_forma_pago 
              JOIN   db_comercial.info_oficina_grupo iog on iog.id_oficina=ipc.oficina_id
              JOIN   db_comercial.info_empresa_grupo ieg on iog.empresa_id=ieg.cod_empresa
      WHERE   ipc.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
   ORDER BY   fe_creacion;