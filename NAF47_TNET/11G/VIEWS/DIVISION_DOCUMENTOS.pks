

CREATE  FORCE VIEW "NAF47_TNET"."DIVISION_DOCUMENTOS" ("DOCUMENTO", "DIVISION", "SUB_DIVISION", "NO_CIA", "ESTADO", "FE_CREACION", "USU_CREACION", "FE_ACTUALIZA", "USU_ACTUALIZA") AS 
  SELECT "DOCUMENTO",
           "DIVISION",
           "SUB_DIVISION",
           "NO_CIA",
           "ESTADO",
           "FE_CREACION",
           "USU_CREACION",
           "FE_ACTUALIZA",
           "USU_ACTUALIZA"
      FROM NAF47_TNET.DIVISION_DOCUMENTOS@GPOETNET;