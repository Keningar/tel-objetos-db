CREATE  FORCE VIEW "NAF47_TNET"."ARINSTD" ("NO_CIA", "CENTRO", "BOD_ORIG", "BOD_DEST", "PERIODO", "NO_DOCU", "NO_ARTI", "CANTIDAD", "PRECIO_PVP", "DESCUENTO", "IMPUESTO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "BOD_ORIG",
           "BOD_DEST",
           "PERIODO",
           "NO_DOCU",
           "NO_ARTI",
           "CANTIDAD",
           "PRECIO_PVP",
           "DESCUENTO",
           "IMPUESTO"
      FROM NAF47_TNET.ARINSTD@GPOETNET;