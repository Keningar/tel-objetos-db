CREATE  FORCE VIEW "NAF47_TNET"."ARPLAPPP" ("NO_CIA", "NO_EMPLE", "TIPO_MOV", "CLASE_MOV", "NO_MOV", "FECHA", "COD_PLA", "DIAS", "HORAS", "IND_ACT", "GOCE_SUELDO", "NO_INGRE", "PERIODO", "NO_PLANI") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "TIPO_MOV",
           "CLASE_MOV",
           "NO_MOV",
           "FECHA",
           "COD_PLA",
           "DIAS",
           "HORAS",
           "IND_ACT",
           "GOCE_SUELDO",
           "NO_INGRE",
           "PERIODO",
           "NO_PLANI"
      FROM NAF47_TNET.ARPLAPPP@GPOETNET;