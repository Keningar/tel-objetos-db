
CREATE  FORCE VIEW "NAF47_TNET"."ARGEPAR" ("PARAMETRO_ID", "ETIQUETA", "TIPO_DATO", "DATO", "FORMAT_MASK") AS 
  SELECT "PARAMETRO_ID",
           "ETIQUETA",
           "TIPO_DATO",
           "DATO",
           "FORMAT_MASK"
      FROM NAF47_TNET.ARGEPAR@GPOETNET;