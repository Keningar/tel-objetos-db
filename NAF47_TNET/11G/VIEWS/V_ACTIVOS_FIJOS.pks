CREATE  OR REPLACE  VIEW "NAF47_TNET"."V_ACTIVOS_FIJOS" ("NO_CIA", "NO_ACTI", "DESC_ACTIVO", "DESC_LARGA_ACTIVO", "DESC_AREA", "DESC_DEPARTAMENTO", "SECCION", "SERIE", "MODELO", "DESC_TIPO", "DESC_GRUPO", "DESC_SUBGRUPO", "F_INGRE", "FECHA_FIN_VIDA_UTIL", "DESC_CC", "DESC_MARCA", "DURACION", "DEPACUM_VO_INICIAL", "VALOR", "DESECHO", "DEPACUM", "VALOR_NETO") AS 
  SELECT "NO_CIA",
           "NO_ACTI",
           "DESC_ACTIVO",
           "DESC_LARGA_ACTIVO",
           "DESC_AREA",
           "DESC_DEPARTAMENTO",
           "SECCION",
           "SERIE",
           "MODELO",
           "DESC_TIPO",
           "DESC_GRUPO",
           "DESC_SUBGRUPO",
           "F_INGRE",
           "FECHA_FIN_VIDA_UTIL",
           "DESC_CC",
           "DESC_MARCA",
           "DURACION",
           "DEPACUM_VO_INICIAL",
           "VALOR",
           "DESECHO",
           "DEPACUM",
           "VALOR_NETO"
      FROM NAF47_TNET.V_ACTIVOS_FIJOS@GPOETNET;