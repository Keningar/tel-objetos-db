CREATE    OR REPLACE VIEW "NAF47_TNET"."V_DEV_VENTAS_SRI" ("NO_CIA", "MES_ANIO", "CEDULA", "TIPO_ID_TRIBUTARIO", "PARTE_RELACIONADA", "SUBTOTAL", "IVA", "TOTAL_COMPROBANTES_EMITIDOS", "TIPO", "GRAVADO", "EXENTO") AS 
  SELECT a.no_cia,
       TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) mes_anio,
       b.cedula,
       b.tipo_id_tributario,
       b.parte_relacionada,
       SUM(NVL(abs(a.tot_lin), 0) - NVL(abs(a.descuento), 0)) subtotal,
       SUM(abs(a.impuesto)) iva,
       COUNT(*) total_comprobantes_emitidos,
       'FA' tipo,
       SUM(NVL(abs(a.gravada), 0)) gravado,
       SUM(NVL(abs(a.exento), 0)) exento
  FROM arfafe a,
       arccmc b,
       arfact c
 WHERE NVL(a.ind_anu_dev, 'X') != 'A'
   AND a.estado != 'P'
   AND c.ind_fac_dev = 'D'
   AND a.no_cia = b.no_cia
   AND a.grupo = b.grupo
   AND a.no_cliente = b.no_cliente
   AND a.no_cia = c.no_cia
   AND a.tipo_doc = c.tipo
 GROUP BY a.no_cia,
          TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')),
          b.cedula,
          b.tipo_id_tributario,
          b.parte_relacionada
UNION
SELECT a.no_cia,
       TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')) mes_anio,
       b.cedula,
       b.tipo_id_tributario,
       b.parte_relacionada,
       SUM(NVL(subtotal, 0)) subtotal,
       SUM(abs(a.tot_imp)) iva,
       COUNT(*) total_comprobantes_emitidos,
       'CC',
       SUM(NVL(a.gravado, 0)) gravado,
       SUM(NVL(a.exento, 0)) exento
  FROM arccmd a,
       arccmc b,
       arcctd c
 WHERE NVL(a.anulado, 'N') = 'N'
   AND a.estado != 'P'
   AND c.codigo_tipo_comprobante = '4'
   AND a.origen = 'CC'
   AND a.no_cia = b.no_cia
   AND a.grupo = b.grupo
   AND a.no_cliente = b.no_cliente
   AND a.no_cia = c.no_cia
   AND a.tipo_doc = c.tipo
 GROUP BY a.no_cia,
          TO_NUMBER(TO_CHAR(a.fecha, 'MMYYYY')),
          b.cedula,
          b.tipo_id_tributario,
          b.parte_relacionada;