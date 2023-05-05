CREATE  FORCE VIEW "NAF47_TNET"."V_PL_PRESTAMOS" ("NO_CIA", "NO_EMPLE", "CEDULA", "NO_DEDU", "NO_OPERA", "COD_PLA", "DESCRIPCION", "PRESTAMO", "SALDO", "ESTATUS", "CUOTA", "FECHA", "F_PRORROGA", "TIPO", "DESC_VARIACION", "PRESTAMO_TERCEROS") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "CEDULA",
           "NO_DEDU",
           "NO_OPERA",
           "COD_PLA",
           "DESCRIPCION",
           "PRESTAMO",
           "SALDO",
           "ESTATUS",
           "CUOTA",
           "FECHA",
           "F_PRORROGA",
           "TIPO",
           "DESC_VARIACION",
           "PRESTAMO_TERCEROS"
      FROM NAF47_TNET.V_PL_PRESTAMOS@GPOETNET;