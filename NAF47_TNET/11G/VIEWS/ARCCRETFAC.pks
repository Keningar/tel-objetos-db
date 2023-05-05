CREATE  FORCE VIEW "NAF47_TNET"."ARCCRETFAC" ("NO_CIA", "NO_DOCU", "NO_DOCU_REFE", "NO_SERIE", "NO_FISICO", "NO_AUTORIZACION", "FECHA_EMISION", "FECHA_VIGENCIA", "BASE", "PORCENTAJE", "MONTO_RETENIDO", "CODIGO_RET", "USUARIO_REGISTRA", "FECHA_CONFIRMACION", "IND_MOVIL") AS 
  SELECT "NO_CIA",
           "NO_DOCU",
           "NO_DOCU_REFE",
           "NO_SERIE",
           "NO_FISICO",
           "NO_AUTORIZACION",
           "FECHA_EMISION",
           "FECHA_VIGENCIA",
           "BASE",
           "PORCENTAJE",
           "MONTO_RETENIDO",
           "CODIGO_RET",
           "USUARIO_REGISTRA",
           "FECHA_CONFIRMACION",
           "IND_MOVIL"
      FROM NAF47_TNET.ARCCRETFAC@GPOETNET;