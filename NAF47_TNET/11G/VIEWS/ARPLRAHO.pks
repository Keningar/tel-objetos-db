
CREATE  FORCE VIEW "NAF47_TNET"."ARPLRAHO" ("NO_CIA", "NO_HORA", "CODIGO", "TIPO_HORA", "HORA_INI", "HORA_FIN", "TASA_INGRESO", "ORDEN", "REQUERIDO", "DIA_MARCA_INI") AS 
  SELECT "NO_CIA",
           "NO_HORA",
           "CODIGO",
           "TIPO_HORA",
           "HORA_INI",
           "HORA_FIN",
           "TASA_INGRESO",
           "ORDEN",
           "REQUERIDO",
           "DIA_MARCA_INI"
      FROM NAF47_TNET.ARPLRAHO@GPOETNET;