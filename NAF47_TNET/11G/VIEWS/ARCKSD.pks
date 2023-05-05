CREATE  FORCE VIEW "NAF47_TNET"."ARCKSD" ("NO_CIA", "NO_CTA", "DIA_CIERRE", "SALDO_DIA") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "DIA_CIERRE",
           "SALDO_DIA"
      FROM NAF47_TNET.ARCKSD@GPOETNET;
CREATE  FORCE VIEW "NAF47_TNET"."ARCKTB" ("BANCO", "DESCRIP", "CTA_D", "CTA_H", "TIP_D", "TIP_H", "NUM_D", "NUM_H", "MON_D", "MON_H", "FEC_D", "FEC_H", "FOR_F", "SALTO", "CODIGO_TERCERO", "SER_D", "SER_H", "DIGITOS_CONCILIAR", "TIPO_CARGA", "DELIMITADOR", "SALTO_FIN", "MON2_D", "MON2_H", "MONTOS", "FACTOR") AS 
  SELECT "BANCO",
           "DESCRIP",
           "CTA_D",
           "CTA_H",
           "TIP_D",
           "TIP_H",
           "NUM_D",
           "NUM_H",
           "MON_D",
           "MON_H",
           "FEC_D",
           "FEC_H",
           "FOR_F",
           "SALTO",
           "CODIGO_TERCERO",
           "SER_D",
           "SER_H",
           "DIGITOS_CONCILIAR",
           "TIPO_CARGA",
           "DELIMITADOR",
           "SALTO_FIN",
           "MON2_D",
           "MON2_H",
           "MONTOS",
           "FACTOR"
      FROM NAF47_TNET.ARCKTB@GPOETNET;