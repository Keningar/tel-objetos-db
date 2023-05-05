CREATE  FORCE VIEW "NAF47_TNET"."TAPCIA" ("NO_CIA", "NOMBRE", "MAX_LIN_ORD", "CLASE_CAMBIO", "FORMULARIO_SOLIC", "FORMULARIO_COTIZ", "FORMULARIO_ORDEN", "NOTIFICA", "TIPO_FLUJO") AS 
  SELECT "NO_CIA",
           "NOMBRE",
           "MAX_LIN_ORD",
           "CLASE_CAMBIO",
           "FORMULARIO_SOLIC",
           "FORMULARIO_COTIZ",
           "FORMULARIO_ORDEN",
           "NOTIFICA",
           "TIPO_FLUJO"
      FROM NAF47_TNET.TAPCIA@GPOETNET;