CREATE  FORCE VIEW "NAF47_TNET"."ARRHBE" ("NO_CIA", "NO_EMPLE", "TIPO_BECA", "BECARIO", "CLASE", "F_INICIO", "F_FIN", "INSTITUCION", "CARRERA", "PROM_ACT", "FECHA_ULT", "CHEQUE", "FECHA_PROX", "MONTO", "DURAC_MESES") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "TIPO_BECA",
           "BECARIO",
           "CLASE",
           "F_INICIO",
           "F_FIN",
           "INSTITUCION",
           "CARRERA",
           "PROM_ACT",
           "FECHA_ULT",
           "CHEQUE",
           "FECHA_PROX",
           "MONTO",
           "DURAC_MESES"
      FROM NAF47_TNET.ARRHBE@GPOETNET;