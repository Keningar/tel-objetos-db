CREATE  FORCE VIEW "NAF47_TNET"."ARPLTEL" ("NO_CIA", "AREA", "DEPA", "DIVISION", "SECCION", "COD_EDIF", "PISO", "INTERNO", "DIRECTO") AS 
  SELECT "NO_CIA",
           "AREA",
           "DEPA",
           "DIVISION",
           "SECCION",
           "COD_EDIF",
           "PISO",
           "INTERNO",
           "DIRECTO"
      FROM NAF47_TNET.ARPLTEL@GPOETNET;