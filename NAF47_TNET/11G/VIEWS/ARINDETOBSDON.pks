CREATE  FORCE VIEW "NAF47_TNET"."ARINDETOBSDON" ("NO_CIA", "CENTRO", "NO_DOCU", "NO_ARTI", "UNID_SOLIC", "UNID_APROBADAS", "UNID_ENTREGADAS", "APLICA_PROV", "COSTO_ARTICULO", "NO_APLICA_PROV", "USUARIO_AUTORIZA") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "NO_DOCU",
           "NO_ARTI",
           "UNID_SOLIC",
           "UNID_APROBADAS",
           "UNID_ENTREGADAS",
           "APLICA_PROV",
           "COSTO_ARTICULO",
           "NO_APLICA_PROV",
           "USUARIO_AUTORIZA"
      FROM NAF47_TNET.ARINDETOBSDON@GPOETNET;