CREATE  FORCE VIEW "NAF47_TNET"."TAPHISTORICO_REEMPLAZOS" ("NO_CIA", "MODULO", "NO_EMPLE", "NO_EMPLE_REEMP", "MOTIVO", "FECHA_DESDE", "FECHA_HASTA", "ACTIVO", "COMENTARIO", "USUARIO_INGRESA", "FECHA_INGRESA", "USUARIO_MODIFICA", "FECHA_MODIFICA") AS 
  SELECT "NO_CIA",
           "MODULO",
           "NO_EMPLE",
           "NO_EMPLE_REEMP",
           "MOTIVO",
           "FECHA_DESDE",
           "FECHA_HASTA",
           "ACTIVO",
           "COMENTARIO",
           "USUARIO_INGRESA",
           "FECHA_INGRESA",
           "USUARIO_MODIFICA",
           "FECHA_MODIFICA"
      FROM NAF47_TNET.TAPHISTORICO_REEMPLAZOS@GPOETNET;