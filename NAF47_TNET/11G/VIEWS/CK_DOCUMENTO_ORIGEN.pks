
CREATE  FORCE VIEW "NAF47_TNET"."CK_DOCUMENTO_ORIGEN" ("COMPANIA", "TIPO_DOCUMENTO", "NO_DOCUMENTO", "TIPO_DOCUMENTO_ORIGEN", "NO_DOCUMENTO_ORIGEN", "MONTO", "USUARIO_CREACION", "FECHA_CREACION") AS 
  SELECT "COMPANIA",
           "TIPO_DOCUMENTO",
           "NO_DOCUMENTO",
           "TIPO_DOCUMENTO_ORIGEN",
           "NO_DOCUMENTO_ORIGEN",
           "MONTO",
           "USUARIO_CREACION",
           "FECHA_CREACION"
      FROM NAF47_TNET.CK_DOCUMENTO_ORIGEN@GPOETNET;