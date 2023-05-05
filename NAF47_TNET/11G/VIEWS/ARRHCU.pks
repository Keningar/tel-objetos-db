
CREATE  FORCE VIEW "NAF47_TNET"."ARRHCU" ("NO_CIA", "NO_EMPLE", "NO_CLASE", "NO_GRUPO", "CODIGO", "FECHA_INI", "FECHA_FIN", "CALIFICA", "DURACION", "EVALUACION", "TIPO", "COSTO", "DESCRIP1", "DESCRIP2", "DESCRIP3", "COMENTARIO", "FECHA_COMPR") AS 
  SELECT "NO_CIA",
           "NO_EMPLE",
           "NO_CLASE",
           "NO_GRUPO",
           "CODIGO",
           "FECHA_INI",
           "FECHA_FIN",
           "CALIFICA",
           "DURACION",
           "EVALUACION",
           "TIPO",
           "COSTO",
           "DESCRIP1",
           "DESCRIP2",
           "DESCRIP3",
           "COMENTARIO",
           "FECHA_COMPR"
      FROM NAF47_TNET.ARRHCU@GPOETNET;