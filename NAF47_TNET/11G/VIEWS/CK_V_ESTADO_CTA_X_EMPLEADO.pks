
CREATE  FORCE VIEW "NAF47_TNET"."CK_V_ESTADO_CTA_X_EMPLEADO" ("NO_CIA", "ANO", "MES", "CUENTA", "EMPLEADO", "DESCRI", "TIPO", "MONTO", "DEBITO", "CREDITO") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "CUENTA",
           "EMPLEADO",
           "DESCRI",
           "TIPO",
           "MONTO",
           "DEBITO",
           "CREDITO"
      FROM NAF47_TNET.CK_V_ESTADO_CTA_X_EMPLEADO@GPOETNET;