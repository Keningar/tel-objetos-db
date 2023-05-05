CREATE  FORCE VIEW "NAF47_TNET"."ARIN_EMPRESA_EXTERNA" ("NO_CIA", "NO_CIA_EXTERNA", "AREA", "DEPARTAMENTO", "ESTADO", "USUARIO_CREA", "FECHA_CREA", "USUARIO_ACT", "FECHA_ACT", "CENTRO_COSTO") AS 
  SELECT "NO_CIA",
           "NO_CIA_EXTERNA",
           "AREA",
           "DEPARTAMENTO",
           "ESTADO",
           "USUARIO_CREA",
           "FECHA_CREA",
           "USUARIO_ACT",
           "FECHA_ACT",
           "CENTRO_COSTO"
      FROM NAF47_TNET.ARIN_EMPRESA_EXTERNA@GPOETNET;