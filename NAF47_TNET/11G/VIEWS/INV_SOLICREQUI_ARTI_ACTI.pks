CREATE  FORCE VIEW "NAF47_TNET"."INV_SOLICREQUI_ARTI_ACTI" ("NO_CIA", "CENTRO", "NUMERO_SOLICITUD", "NUMERO_LINEA", "NO_ARTI", "NO_ACTI", "SERIE", "TIPO", "GRUPO", "SUBGRUPO", "MARCA", "MAC", "UNIDADES", "CANTIDAD_SEGMENTO", "SERIE_ORIGINAL") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NUMERO_SOLICITUD",
           "NUMERO_LINEA",
           "NO_ARTI",
           "NO_ACTI",
           "SERIE",
           "TIPO",
           "GRUPO",
           "SUBGRUPO",
           "MARCA",
           "MAC",
           "UNIDADES",
           "CANTIDAD_SEGMENTO",
           "SERIE_ORIGINAL"
      FROM NAF47_TNET.INV_SOLICREQUI_ARTI_ACTI@GPOETNET;