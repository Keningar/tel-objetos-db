CREATE  FORCE VIEW "NAF47_TNET"."CG_M_ASIENTO_CONTABLE" ("COMPANIA", "ID_ASIENTO", "FECHA", "CONCEPTO", "TOTAL_DEBITOS", "TOTAL_CREDITOS", "ID_ASIENTO_NAF", "TIPO_ASIENTO", "CODIGO_ASIENTO", "NUMCHE", "MIGRADO", "BENEFICIARIO") AS 
  SELECT "COMPANIA",
           "ID_ASIENTO",
           "FECHA",
           "CONCEPTO",
           "TOTAL_DEBITOS",
           "TOTAL_CREDITOS",
           "ID_ASIENTO_NAF",
           "TIPO_ASIENTO",
           "CODIGO_ASIENTO",
           "NUMCHE",
           "MIGRADO",
           "BENEFICIARIO"
      FROM NAF47_TNET.CG_M_ASIENTO_CONTABLE@GPOETNET;