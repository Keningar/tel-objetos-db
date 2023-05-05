CREATE  FORCE VIEW "NAF47_TNET"."PREST_CAB_DEDUCCIONES" ("NO_CIA", "NO_EMPLE", "TIPO_EMP", "CEDULA", "NO_DEDU", "NO_OPERA", "COD_PLA", "FECHA_INICIO", "SALDO", "CUOTA", "PAGOS", "CERRADO", "DESCRIPCION") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "TIPO_EMP",
           "CEDULA",
           "NO_DEDU",
           "NO_OPERA",
           "COD_PLA",
           "FECHA_INICIO",
           "SALDO",
           "CUOTA",
           "PAGOS",
           "CERRADO",
           "DESCRIPCION"
      FROM NAF47_TNET.PREST_CAB_DEDUCCIONES@GPOETNET;