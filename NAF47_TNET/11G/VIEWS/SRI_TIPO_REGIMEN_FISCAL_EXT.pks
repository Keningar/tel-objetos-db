CREATE  FORCE VIEW "NAF47_TNET"."SRI_TIPO_REGIMEN_FISCAL_EXT" ("ID_TIPO_REGIMEN", "DESCRIPCION", "ESTADO", "FE_CREACION", "USR_CREACION", "FE_ULT_MOD", "USR_ULT_MOD") AS 
  SELECT "ID_TIPO_REGIMEN",
           "DESCRIPCION",
           "ESTADO",
           "FE_CREACION",
           "USR_CREACION",
           "FE_ULT_MOD",
           "USR_ULT_MOD"
      FROM NAF47_TNET.SRI_TIPO_REGIMEN_FISCAL_EXT@GPOETNET;