CREATE OR REPLACE PROCEDURE DB_FINANCIERO.DOCUMENTOS_RELACIONADOS (id_factura IN number , pagos OUT SYS_REFCURSOR) AS
BEGIN
--Listado de Pagos asociados a la factura
  OPEN pagos FOR
    SELECT
    ATDF.codigo_tipo_documento,
    IPC.numero_pago,
    IPC.estado_pago,
    IPD.valor_pago,
    AFP.codigo_forma_pago,
    case 
    when ipc.FE_CRUCE is null then to_char(IPD.fe_creacion,'dd/MM/yyyy')
    else to_char(ipc.FE_CRUCE,'dd/MM/yyyy')
    end  as fe_creacion,
    case
    when IPD.numero_referencia is null then IPD.NUMERO_CUENTA_BANCO
    else IPD.numero_referencia
    end as numero_referencia,
    AB.descripcion_banco,
    ABB.descripcion_banco as descripcion_contable,
    ipd.id_pago_det
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
    LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPC.ID_PAGO = IPD.PAGO_ID
    LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF on ATDF.id_tipo_documento=IPC.tipo_documento_id
    LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON IPD.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
    LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA=IPD.BANCO_TIPO_CUENTA_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO=ABTC.BANCO_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCCC ON ABCCC.ID_BANCO_CTA_CONTABLE=IPD.BANCO_CTA_CONTABLE_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTCC ON ABTCC.ID_BANCO_TIPO_CUENTA=ABCCC.BANCO_TIPO_CUENTA_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO ABB ON ABB.ID_BANCO=ABTCC.BANCO_ID
    WHERE IPC.ESTADO_PAGO NOT IN ('Inactivo', 'Anulado','Asignado')
    AND IPD.REFERENCIA_ID=id_factura
  UNION--Notas de Debito
    SELECT
    atdf.codigo_tipo_documento,
    idfc.numero_factura_sri,
    idfc.estado_impresion_fact,
    idfd.precio_venta_facpro_detalle,
    '',
    to_char(idfc.fe_emision,'dd/MM/yyyy') as fe_creacion,
    '',
    '',
    '',
    idfc.ID_DOCUMENTO
    from info_documento_financiero_cab idfc
    join info_documento_financiero_det idfd on idfc.id_documento=idfd.documento_id
    join admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
    and atdf.codigo_tipo_documento in ('ND','NDI','DEV')
    and idfc.estado_impresion_fact NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente')
    and idfd.pago_det_id in
    (
      select id_pago_det
      from info_pago_det
      where referencia_id=id_factura
    )
  UNION--Nota de Credito
    SELECT
    atdf.codigo_tipo_documento,
    idfc.numero_factura_sri,
    idfc.estado_impresion_fact,
    idfc.valor_total,
    '',
    to_char(idfc.fe_emision,'dd/MM/yyyy') as fe_creacion,
    '',
    '',
    '',
    idfc.ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
    LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF on ATDF.id_tipo_documento=idfc.tipo_documento_id
    WHERE idfc.REFERENCIA_DOCUMENTO_ID=id_factura
    AND idfc.estado_impresion_fact
    NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','PendienteSri','PendienteError','Eliminado')
  order by fe_creacion;
END DOCUMENTOS_RELACIONADOS;
/