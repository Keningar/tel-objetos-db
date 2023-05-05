CREATE  FORCE VIEW "NAF47_TNET"."PVBANCOS" ("NO_CIA", "BANCO", "MONEDA", "ACEPTA_CHEQUE", "ACEPTA_TARJETA", "PORC_COMISION", "GRUPO_CLIENTE", "NO_CLIENTE", "TIPO_DOC_CXC", "TSTAMP", "IND_CALC_RETEFTEP", "CUENTA_COMISION", "LOTE_TARJETA", "NO_PROVE", "CLAVE_RETENCION", "IND_DIFERIDO", "SUB_CLIENTE") AS 
  SELECT "NO_CIA",
           "BANCO",
           "MONEDA",
           "ACEPTA_CHEQUE",
           "ACEPTA_TARJETA",
           "PORC_COMISION",
           "GRUPO_CLIENTE",
           "NO_CLIENTE",
           "TIPO_DOC_CXC",
           "TSTAMP",
           "IND_CALC_RETEFTEP",
           "CUENTA_COMISION",
           "LOTE_TARJETA",
           "NO_PROVE",
           "CLAVE_RETENCION",
           "IND_DIFERIDO",
           "SUB_CLIENTE"
      FROM NAF47_TNET.PVBANCOS@GPOETNET;