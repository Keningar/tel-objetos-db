CREATE  FORCE VIEW "NAF47_TNET"."ARFA_VIA_PEDIDO" ("CODIGO", "DESCRIPCION", "NO_CIA", "MODIFICABLE", "VIENE_PROFORMA", "VIENE_CONSIGNACION") AS 
  SELECT "CODIGO",
           "DESCRIPCION",
           "NO_CIA",
           "MODIFICABLE",
           "VIENE_PROFORMA",
           "VIENE_CONSIGNACION"
      FROM NAF47_TNET.ARFA_VIA_PEDIDO@GPOETNET;