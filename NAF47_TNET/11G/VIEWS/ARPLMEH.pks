CREATE  FORCE VIEW "NAF47_TNET"."ARPLMEH" ("NO_CIA", "NO_EMPLE", "NOMBRE", "PARENTESCO", "SEXO", "FECHA_NAC", "CARGA", "CARGA_TRIBU", "CARGA_EMPRE", "CARGA_SUBS", "CARGA_EDUCA", "CARGA_UTIL", "CEDULA", "FORMA_PAGO", "CTA_BCO", "TIPO_CTA", "NUM_CUENTA", "TELEFONO", "DIRECCION", "IND_ORDEN_JUDICIAL", "TIPO_DISCAPACIDAD", "PORDISCAPACIDAD") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "NOMBRE",
           "PARENTESCO",
           "SEXO",
           "FECHA_NAC",
           "CARGA",
           "CARGA_TRIBU",
           "CARGA_EMPRE",
           "CARGA_SUBS",
           "CARGA_EDUCA",
           "CARGA_UTIL",
           "CEDULA",
           "FORMA_PAGO",
           "CTA_BCO",
           "TIPO_CTA",
           "NUM_CUENTA",
           "TELEFONO",
           "DIRECCION",
           "IND_ORDEN_JUDICIAL",
           "TIPO_DISCAPACIDAD",
           "PORDISCAPACIDAD"
      FROM NAF47_TNET.ARPLMEH@GPOETNET;