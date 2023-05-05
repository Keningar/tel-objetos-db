CREATE  FORCE VIEW "NAF47_TNET"."ARPLMADE" ("NO_CIA", "NO_EMPLE", "HORARIO", "D_ENTRA", "H_ENTRA", "TIPO_HORA", "TASA_MULT", "CANTIDAD") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "HORARIO",
           "D_ENTRA",
           "H_ENTRA",
           "TIPO_HORA",
           "TASA_MULT",
           "CANTIDAD"
      FROM NAF47_TNET.ARPLMADE@GPOETNET;