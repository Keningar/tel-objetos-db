CREATE  FORCE VIEW "NAF47_TNET"."TAPPRODU" ("NO_CIA", "NO_PROVE", "CODIGO_NI", "NO_ARTI", "COD_ART_PROV", "MEDIDA", "PRECIO", "FECHA_RIGE", "PRECIO_NUEVO", "MONEDA", "DESCUENTO", "P_PRINCIPAL", "PRECIO_ANTERIOR") AS 
  SELECT "NO_CIA",
           "NO_PROVE",
           "CODIGO_NI",
           "NO_ARTI",
           "COD_ART_PROV",
           "MEDIDA",
           "PRECIO",
           "FECHA_RIGE",
           "PRECIO_NUEVO",
           "MONEDA",
           "DESCUENTO",
           "P_PRINCIPAL",
           "PRECIO_ANTERIOR"
      FROM NAF47_TNET.TAPPRODU@GPOETNET;