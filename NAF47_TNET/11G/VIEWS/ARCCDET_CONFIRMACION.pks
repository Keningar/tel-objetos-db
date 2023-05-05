CREATE  FORCE VIEW "NAF47_TNET"."ARCCDET_CONFIRMACION" ("NO_CIA", "CENTRO", "SECUENCIA_LOTE", "NO_SECUENCIA", "NO_LINEA", "FORMA_PAGO", "VALOR_LINEA", "VALOR_CONFIRMADO", "NO_FISICO", "NO_BANCO", "NO_CUENTA_CORRIENTE", "FECHA_CHEQUE", "PORCENTAJE", "CLAVE", "BASE", "SECUENCIA_DEPOSITO", "NO_AUTORIZACION", "FECHA_VIGENCIA", "IND_RECHAZADO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "SECUENCIA_LOTE",
           "NO_SECUENCIA",
           "NO_LINEA",
           "FORMA_PAGO",
           "VALOR_LINEA",
           "VALOR_CONFIRMADO",
           "NO_FISICO",
           "NO_BANCO",
           "NO_CUENTA_CORRIENTE",
           "FECHA_CHEQUE",
           "PORCENTAJE",
           "CLAVE",
           "BASE",
           "SECUENCIA_DEPOSITO",
           "NO_AUTORIZACION",
           "FECHA_VIGENCIA",
           "IND_RECHAZADO"
      FROM NAF47_TNET.ARCCDET_CONFIRMACION@GPOETNET;