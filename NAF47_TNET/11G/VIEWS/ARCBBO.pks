CREATE  FORCE VIEW "NAF47_TNET"."ARCBBO" ("NO_CIA", "NO_PROVE", "NO_DOCU", "NO_FISICO", "SERIE_FISICO", "CONCEPTO", "CLAVE", "PORCENTAJE", "MONTO", "BASE", "NO_FISICO_BOLETA", "FECHA_BOLETA", "ESTATUS_BOLETA", "NO_CTA", "CHEQUE", "NO_SECUENCIA", "NO_DOCU_PAGO") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "NO_DOCU",
           "NO_FISICO",
           "SERIE_FISICO",
           "CONCEPTO",
           "CLAVE",
           "PORCENTAJE",
           "MONTO",
           "BASE",
           "NO_FISICO_BOLETA",
           "FECHA_BOLETA",
           "ESTATUS_BOLETA",
           "NO_CTA",
           "CHEQUE",
           "NO_SECUENCIA",
           "NO_DOCU_PAGO"
      FROM NAF47_TNET.ARCBBO@GPOETNET;