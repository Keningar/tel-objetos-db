CREATE  FORCE VIEW "NAF47_TNET"."ARPL_OTROS_PAGOS" ("NO_CIA", "NO_EMPLE", "ANO", "MES", "TIPO_FPAGO", "NO_DEDU", "NO_OPERA", "MONTO", "CUOTA_ANT", "CUOTA_NUEVA", "OBSERVACION", "USUARIO", "FECHA", "NO_ASIENTO", "COD_PLA_ANT", "COD_PLA_NUEVA") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "ANO",
           "MES",
           "TIPO_FPAGO",
           "NO_DEDU",
           "NO_OPERA",
           "MONTO",
           "CUOTA_ANT",
           "CUOTA_NUEVA",
           "OBSERVACION",
           "USUARIO",
           "FECHA",
           "NO_ASIENTO",
           "COD_PLA_ANT",
           "COD_PLA_NUEVA"
      FROM NAF47_TNET.ARPL_OTROS_PAGOS@GPOETNET;