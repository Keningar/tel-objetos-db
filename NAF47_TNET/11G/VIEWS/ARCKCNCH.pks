CREATE  FORCE VIEW "NAF47_TNET"."ARCKCNCH" ("NO_CIA", "NO_CTA", "ANO", "MES", "PROCEDENCIA", "TIPO_DOC", "NO_DOCU", "FECHA", "BENEFICIARIO", "MONTO", "MENSAJE", "MONTO_BCO", "DIFERE", "COD_MSG") AS 
  SELECT "NO_CIA",
           "NO_CTA",
           "ANO",
           "MES",
           "PROCEDENCIA",
           "TIPO_DOC",
           "NO_DOCU",
           "FECHA",
           "BENEFICIARIO",
           "MONTO",
           "MENSAJE",
           "MONTO_BCO",
           "DIFERE",
           "COD_MSG"
      FROM NAF47_TNET.ARCKCNCH@GPOETNET;