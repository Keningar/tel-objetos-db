
CREATE  FORCE VIEW "NAF47_TNET"."CONCEPTOS_SUBCONCEPTOS" ("CODIGO", "NOMBRE_CONCEPTO", "DESCRIPCION_CONCEPTO", "CODIGO_SUBCONCEPTO", "NOMBRE_SUBCONCEPTO", "CNO_GCINGREGRESO", "CNO_GCAFECNOMINA", "CNO_GCCONTABILIZA", "CNO_GCIESSCAN", "CNO_GCSUELDO", "CNO_GCPROVISION", "CNO_GCMUESTRACONCEPTOREPORTE", "CNO_GNBENEFSOCIAL", "CNO_GCGRAVAIR", "CNO_GCAFECTABILIQUIDACION", "NO_CIA") AS 
  SELECT "CODIGO",
           "NOMBRE_CONCEPTO",
           "DESCRIPCION_CONCEPTO",
           "CODIGO_SUBCONCEPTO",
           "NOMBRE_SUBCONCEPTO",
           "CNO_GCINGREGRESO",
           "CNO_GCAFECNOMINA",
           "CNO_GCCONTABILIZA",
           "CNO_GCIESSCAN",
           "CNO_GCSUELDO",
           "CNO_GCPROVISION",
           "CNO_GCMUESTRACONCEPTOREPORTE",
           "CNO_GNBENEFSOCIAL",
           "CNO_GCGRAVAIR",
           "CNO_GCAFECTABILIQUIDACION",
           "NO_CIA"
      FROM NAF47_TNET.CONCEPTOS_SUBCONCEPTOS@GPOETNET;