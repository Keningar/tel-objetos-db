CREATE  FORCE VIEW "NAF47_TNET"."ARPLACOM" ("NO_CIA", "CODIGO", "TIPO", "TIPO_ID_TRIBUTARIO", "CEDULA", "NOMBRE", "FECHA_INGRESO", "PAGA_UTILIDAD", "FECHA_SALIDA", "DIAS_LABORADOS", "SEXO", "ID_TIPO_RUC", "RUC") AS 
  SELECT "NO_CIA",
           "CODIGO",
           "TIPO",
           "TIPO_ID_TRIBUTARIO",
           "CEDULA",
           "NOMBRE",
           "FECHA_INGRESO",
           "PAGA_UTILIDAD",
           "FECHA_SALIDA",
           "DIAS_LABORADOS",
           "SEXO",
           "ID_TIPO_RUC",
           "RUC"
      FROM NAF47_TNET.ARPLACOM@GPOETNET;