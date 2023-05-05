/* Formatted on 5/2/2023 10:01:29 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_FINANCIERO.ESTADO_CUENTA_OG
(
    ID_DOCUMENTO,
    PUNTO_ID,
    OFICINA_ID,
    NUMERO_FACTURA_SRI,
    TIPO_DOCUMENTO_ID,
    VALOR_TOTAL,
    FE_CREACION,
    USR_CREACION,
    REFERENCIA,
    CODIGO_FORMA_PAGO,
    ESTADO_IMPRESION_FACT,
    NUMERO_REFERENCIA,
    NUMERO_CUENTA_BANCO,
    REFERENCIA_ID,
    NUM_FACT_MIGRACION
)
BEQUEATH DEFINER
AS
    SELECT idfc.id_documento,
           idfc.punto_id,
           idfc.oficina_id,
           idfc.numero_factura_sri,
           idfc.tipo_documento_id,
           idfc.valor_total,
           idfc.fe_emision                  AS fe_creacion,
           idfc.usr_creacion,
           ''                               AS referencia,
           ''                               AS codigo_forma_pago,
           idfc.estado_impresion_fact,
           ''                               AS numero_referencia,
           ''                               AS numero_cuenta_banco,
           idfc.referencia_documento_id     AS referencia_id,
           idfc.num_fact_migracion
      FROM db_financiero.info_documento_financiero_cab  idfc
           JOIN db_comercial.info_oficina_grupo iog
               ON iog.id_oficina = idfc.oficina_id
           JOIN db_comercial.info_empresa_grupo ieg
               ON iog.empresa_id = ieg.cod_empresa
     WHERE     idfc.estado_impresion_fact NOT IN ('Inactivo',
                                                  'Anulado',
                                                  'Anulada',
                                                  'Rechazada',
                                                  'Pendiente',
                                                  'Eliminado',
                                                  'Rechazado',
                                                  'Aprobada')
           AND ieg.prefijo = 'TTCO'
           AND idfc.num_fact_migracion IS NOT NULL
    UNION ALL                                            -- Pagos de migracion
    SELECT ipc.id_pago,
           ipc.punto_id,
           ipc.oficina_id,
           ipc.numero_pago,
           ipc.tipo_documento_id,
           ipd.valor_pago,
           ipc.fe_creacion,
           ipc.usr_creacion,
           ''                         AS numero_factura_sri,
           afp.codigo_forma_pago,
           ipc.estado_pago,
           ipd.numero_referencia,
           ipd.numero_cuenta_banco,
           ipd.referencia_id,
           ipc.num_pago_migracion     AS migracion
      FROM db_financiero.info_pago_cab  ipc
           JOIN db_financiero.info_pago_det ipd ON ipc.id_pago = ipd.pago_id
           JOIN db_general.admi_forma_pago afp
               ON ipd.forma_pago_id = afp.id_forma_pago
           JOIN db_comercial.info_oficina_grupo iog
               ON iog.id_oficina = ipc.oficina_id
           JOIN db_comercial.info_empresa_grupo ieg
               ON iog.empresa_id = ieg.cod_empresa
     WHERE     ipc.estado_pago NOT IN ('Inactivo', 'Anulado', 'Asignado')
           AND ieg.prefijo = 'TTCO'
           AND ipc.num_pago_migracion IS NOT NULL
    UNION ALL                            --Pagos de Telcos a facturas migradas
    SELECT ipc.id_pago,
           ipc.punto_id,
           ipc.oficina_id,
           ipc.numero_pago,
           ipc.tipo_documento_id,
           ipd.valor_pago,
           ipc.fe_creacion,
           ipc.usr_creacion,
           ''                         AS numero_factura_sri,
           afp.codigo_forma_pago,
           ipc.estado_pago,
           ipd.numero_referencia,
           ipd.numero_cuenta_banco,
           ipd.referencia_id,
           ipc.num_pago_migracion     AS migracion
      FROM db_financiero.info_pago_cab  ipc
           JOIN db_financiero.info_pago_det ipd ON ipc.id_pago = ipd.pago_id
           JOIN db_general.admi_forma_pago afp
               ON ipd.forma_pago_id = afp.id_forma_pago
           JOIN db_comercial.info_oficina_grupo iog
               ON iog.id_oficina = ipc.oficina_id
           JOIN db_comercial.info_empresa_grupo ieg
               ON iog.empresa_id = ieg.cod_empresa
     WHERE     ipc.estado_pago NOT IN ('Inactivo', 'Anulado', 'Asignado')
           AND ieg.prefijo = 'TTCO'
           AND ipd.referencia_id IN
                   (SELECT idfc.id_documento
                      FROM db_financiero.info_documento_financiero_cab  idfc
                           JOIN db_comercial.info_oficina_grupo iog
                               ON iog.id_oficina = idfc.oficina_id
                           JOIN db_comercial.info_empresa_grupo ieg
                               ON iog.empresa_id = ieg.cod_empresa
                     WHERE     idfc.estado_impresion_fact NOT IN
                                   ('Inactivo',
                                    'Anulado',
                                    'Anulada',
                                    'Rechazada',
                                    'Pendiente',
                                    'Eliminado',
                                    'Rechazado',
                                    'Aprobada')
                           AND ieg.prefijo = 'TTCO'
                           AND idfc.num_fact_migracion IS NOT NULL)
    ORDER BY fe_creacion;
/
