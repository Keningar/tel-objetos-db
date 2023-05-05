CREATE  FORCE VIEW "NAF47_TNET"."V_PL_CANCELACION_PRESTAMOS" ("NO_CIA", "NO_EMPLE", "ANO", "MES", "COD_PLA", "CODIGO", "NO_OPERA", "MONTO", "F_PAGO", "USUARIO", "FECHA", "OBSERVACION", "CUOTA_ANT", "CUOTA_NUEVA", "COD_PLA_ANT", "COD_PLA_NUEVA") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "COD_PLA",
           "CODIGO",
           "NO_OPERA",
           "MONTO",
           "F_PAGO",
           "USUARIO",
           "FECHA",
           "OBSERVACION",
           "CUOTA_ANT",
           "CUOTA_NUEVA",
           "COD_PLA_ANT",
           "COD_PLA_NUEVA"
      FROM NAF47_TNET.V_PL_CANCELACION_PRESTAMOS@GPOETNET;