CREATE  FORCE VIEW "NAF47_TNET"."ARRHHI" ("COD_INSTITU", "DESCRIP", "CONTACTO", "TELEFONO") AS 
  SELECT "COD_INSTITU",
           "DESCRIP",
           "CONTACTO",
           "TELEFONO"
      FROM NAF47_TNET.ARRHHI@GPOETNET;