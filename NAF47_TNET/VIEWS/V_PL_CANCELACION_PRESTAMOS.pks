CREATE    OR REPLACE VIEW "NAF47_TNET"."V_PL_CANCELACION_PRESTAMOS" ("NO_CIA", "NO_EMPLE", "ANO", "MES", "COD_PLA", "CODIGO", "NO_OPERA", "MONTO", "F_PAGO", "USUARIO", "FECHA", "OBSERVACION", "CUOTA_ANT", "CUOTA_NUEVA", "COD_PLA_ANT", "COD_PLA_NUEVA") AS 
  select a.no_cia, a.no_emple, a.ano, a.mes, a.cod_pla, a.codigo, a.no_opera, a.monto, NULL f_pago,
       a.usuario, a.fecha, a.observacion, NULL cuota_ant, NULL cuota_nueva, NULL cod_pla_ant, NULL cod_pla_nueva
FROM arplhs a, arplmd b
where b.tipo = '5'
and   a.tipo_m = 'D'
and   a.no_cia = b.no_cia
and   a.codigo = b.no_dedu
UNION
SELECT p.no_cia, p.no_emple, p.ano, p.mes, NULL cod_pla, p.no_dedu codigo, p.no_opera, p.monto,
       DECODE(tipo_fpago,'C','Caja','O','Movimiento','S','Saldar') f_pago,
             p.usuario, p.fecha, p.observacion, p.cuota_ant, p.cuota_nueva, p.cod_pla_ant, p.cod_pla_nueva
FROM ARPL_OTROS_PAGOS p WHERE P.TIPO_FPAGO <> 'O';