CREATE  FORCE VIEW "NAF47_TNET"."CALENDARIO" ("NO_CIA", "ANO", "SEMANA", "INDICADOR", "FECHA1", "FECHA2", "MES", "DIAS_HABILES") AS 
  SELECT "NO_CIA",
           "ANO",
           "SEMANA",
           "INDICADOR",
           "FECHA1",
           "FECHA2",
           "MES",
           "DIAS_HABILES"
      FROM NAF47_TNET.CALENDARIO@GPOETNET;