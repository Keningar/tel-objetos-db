CREATE  FORCE VIEW "NAF47_TNET"."ARCSEA_H" ("NO_CIA", "ANO", "MES", "NO_ASIENTO", "FECHA", "DESCRI1", "ESTADO", "T_DEBITOS", "T_CREDITOS", "TIPO_ASIENTO", "COD_ASIENTO") AS 
  SELECT "NO_CIA",
           "ANO",
           "MES",
           "NO_ASIENTO",
           "FECHA",
           "DESCRI1",
           "ESTADO",
           "T_DEBITOS",
           "T_CREDITOS",
           "TIPO_ASIENTO",
           "COD_ASIENTO"
      FROM NAF47_TNET.ARCSEA_H@GPOETNET;