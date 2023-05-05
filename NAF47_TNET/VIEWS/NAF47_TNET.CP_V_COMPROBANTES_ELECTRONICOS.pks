/* Formatted on 5/2/2023 9:51:17 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW NAF47_TNET.CP_V_COMPROBANTES_ELECTRONICOS
(
    NO_COMPANIA,
    NO_PROVEEDOR,
    RAZON_SOCIAL,
    TIPO_DOCUMENTO,
    NO_DOCUMENTO,
    COMPROBANTE_VENTA,
    FECHA_DOCUMENTO,
    GRAVADO,
    EXCENTOS,
    SUBTOTAL,
    IMPUESTOS,
    TOTAL,
    RETENCIONES,
    POR_PAGAR,
    ESTADO,
    DESC_ESTADO,
    TIPO_RETENCION,
    XML_GENERADO,
    COMPROBANTE_RETENCION,
    FECHA_RETENCION,
    DETALLE_RECHAZO,
    NOMBRE_ARCHIVO,
    RUTA_ARCHIVO,
    IND_REGION,
    TOT_RET
)
BEQUEATH DEFINER
AS
    SELECT a.no_cia                             no_compania,
           a.no_prove                           no_proveedor,
           b.nombre                             razon_social,
           a.tipo_doc                           tipo_documento,
           a.no_docu                            no_documento,
              SUBSTR (a.serie_fisico, 1, 3)
           || '-'
           || SUBSTR (a.serie_fisico, 4, 3)
           || '-'
           || a.no_fisico                       comprobante_venta,
           a.fecha_documento,
           a.gravado,
           a.excentos,
           a.subtotal,
           a.tot_imp                            impuestos,
           (a.subtotal + a.tot_imp)             total,
           a.tot_ret                            retenciones,
           a.monto                              por_pagar,
           a.ind_act                            estado,
           DECODE (a.ind_act,
                   'C', 'PENDIENTE ENVIAR',
                   'Z', 'ENVIADO SRI',
                   'X', 'RECHAZADO E-BILLING',
                   'I', 'INICIADO',
                   'F', 'RECHAZADO SRI',
                   'R', 'RECIBIDO',
                   'N', 'NO AUTORIZADO')        desc_estado,
           a.tipo_ret                           tipo_retencion,
           NVL (a.ind_impresion_ret, 'N')       xml_generado,
           DECODE (
               a.comp_ret,
               NULL, NULL,
                  SUBSTR (a.comp_ret_serie, 1, 3)
               || '-'
               || SUBSTR (a.comp_ret_serie, 4, 3)
               || '-'
               || LPAD (a.comp_ret, 9, '0'))    comprobante_retencion,
           a.fecha_retencion,
           a.detalle_rechazo,
           a.nombre_archivo,
           c.ruta                               ruta_archivo,
           e.ind_region,
           a.tot_ret
      FROM arcpmd       a,
           arcpmp       b,
           arcptd       c,
           tasgusuario  d,
           arplme       e
     WHERE     a.no_prove = b.no_prove
           AND a.no_cia = b.no_cia
           AND a.tipo_ret = c.tipo_doc
           AND a.no_cia = c.no_cia
           AND a.usuario = d.usuario
           AND a.no_cia = d.no_cia
           AND d.id_empleado = e.no_emple
           AND d.no_cia = e.no_cia
           AND a.ind_act IN ('C',
                             'Z',
                             'X',
                             'I',
                             'F',
                             'R',
                             'N')
    UNION
    SELECT a.no_cia                             no_compania,
           a.no_prove                           no_proveedor,
           b.nombre                             razon_social,
           a.tipo_doc                           tipo_documento,
           a.no_docu                            no_documento,
              SUBSTR (a.serie_fisico, 1, 3)
           || '-'
           || SUBSTR (a.serie_fisico, 4, 3)
           || '-'
           || a.no_fisico                       comprobante_venta,
           a.fecha_documento,
           a.gravado,
           a.excentos,
           a.subtotal,
           a.tot_imp                            impuestos,
           (a.subtotal + a.tot_imp)             total,
           a.tot_ret                            retenciones,
           a.monto                              por_pagar,
           a.estado_sri                         estado,
           DECODE (a.estado_sri,
                   'P', 'PENDIENTE',
                   'G', 'GENERADO',
                   '-4', 'DUPLICADO',
                   '-3', 'VERSION OBSOLETA',
                   '-2', 'ERROR DE AUTENTICACION',
                   '-1', 'NO SE RECIBIO',
                   '0', 'ERROR XML',
                   '1', 'INICIADO',
                   '2', 'RECHAZADO',
                   '3', 'RECIBIDO',
                   '4', 'NO AUTORIZADO',
                   '5', 'AUTORIZADO',
                   '8', 'ANULADO EN SRI')       desc_estado,
           a.tipo_ret                           tipo_retencion,
           NVL (a.ind_impresion_ret, 'N')       xml_generado,
           DECODE (
               a.comp_ret,
               NULL, NULL,
                  SUBSTR (a.comp_ret_serie, 1, 3)
               || '-'
               || SUBSTR (a.comp_ret_serie, 4, 3)
               || '-'
               || LPAD (a.comp_ret, 9, '0'))    comprobante_retencion,
           a.fecha_retencion,
           a.detalle_rechazo,
           a.nombre_archivo,
           c.ruta                               ruta_archivo,
           NVL (
               (SELECT e.ind_region
                  FROM tasgusuario d, arplme e
                 WHERE     d.id_empleado = e.no_emple
                       AND d.no_cia = e.no_cia
                       AND a.usuario = d.usuario
                       AND a.no_cia = d.no_cia),
               'T')                             ind_region,
           a.tot_ret
      FROM arcpmd a, arcpmp b, arcptd c
     WHERE     a.no_prove = b.no_prove
           AND a.no_cia = b.no_cia
           AND a.tipo_ret = c.tipo_doc
           AND a.no_cia = c.no_cia
           AND a.ind_act = 'P'
           AND a.estado_sri IN ('P',
                                'G',
                                '-4',
                                '-3',
                                '-2',
                                '-1',
                                '0',
                                '1',
                                '2',
                                '3',
                                '4',
                                '8');
/
