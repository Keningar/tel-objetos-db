CREATE  FORCE VIEW "NAF47_TNET"."ARCKCNC" ("NO_CIA", "NO_CTA", "PROCEDENCIA", "TIPO_DOC", "NO_DOCU", "FECHA", "BENEFICIARIO", "MONTO", "MENSAJE", "MONTO_BCO", "DIFERE", "COD_MSG") AS 
  SELECT "NO_CIA",
           "NO_CTA",
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
      FROM NAF47_TNET.ARCKCNC@GPOETNET;