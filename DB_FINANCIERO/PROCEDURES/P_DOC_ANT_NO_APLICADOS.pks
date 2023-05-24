CREATE OR REPLACE PROCEDURE DB_FINANCIERO.P_DOC_ANT_NO_APLICADOS(id_pag_pendiente IN INFO_PAGO_DET.ID_PAGO_DET%TYPE , nd_noapp OUT SYS_REFCURSOR) 
AS
BEGIN
 OPEN nd_noapp FOR 
    select 
      idfc.id_documento as id_pago_det,
      idfc.numero_factura_sri,
      idfc.estado_impresion_fact,
      case
      when idfd.precio_venta_facpro_detalle < 1 then to_char(idfd.precio_venta_facpro_detalle,'0.99')
      else to_char(idfd.precio_venta_facpro_detalle,'999999999999999.99')
      end as precio,
      to_char(idfc.fe_emision,'dd/MM/yyyy') as fe_creacion,
      '' AS numero_referencia,
      '' AS descripcion_banco,
      '' AS descripcion_contable,
      atdf.codigo_tipo_documento,
      '' AS codigo_forma_pago
    from info_documento_financiero_cab idfc
      join info_documento_financiero_det idfd on idfc.id_documento=idfd.documento_id
      join admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
      and atdf.codigo_tipo_documento in ('ND','NDI','DEV')
      and idfc.estado_impresion_fact NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','PendienteError','PendienteSri')
      and idfd.pago_det_id=id_pag_pendiente
  UNION
      SELECT
        IPD.id_pago_det,
        IPC.numero_pago,
        IPC.estado_pago,
        case
          when IPD.valor_pago < 1 then to_char(IPD.valor_pago,'0.99')
          else to_char(IPD.valor_pago,'999999999999999.99')
        end as precio,
        to_char(IPD.fe_creacion,'dd/MM/yyyy') as fe_creacion,
        case 
         when IPD.numero_referencia is null then IPD.NUMERO_CUENTA_BANCO
         else IPD.numero_referencia
        end as numero_referencia,
        AB.descripcion_banco,
        ABB.descripcion_banco as descripcion_contable,
        ATDF.codigo_tipo_documento,
        AFP.codigo_forma_pago
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
        AND IPD.REFERENCIA_ID in
        (
          select 
            idfc.id_documento
          from info_documento_financiero_cab idfc
            join info_documento_financiero_det idfd on idfc.id_documento=idfd.documento_id
            join admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
            and atdf.codigo_tipo_documento in ('ND','NDI','DEV')
            and idfc.estado_impresion_fact NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','PendienteError','PendienteSri')
            and idfd.pago_det_id=id_pag_pendiente
        );
END P_DOC_ANT_NO_APLICADOS;
/