CREATE  FORCE VIEW "NAF47_TNET"."MIGRA_CONSIGNACION" ("NO_DOCU", "CLIENTE", "VENDEDOR", "FECHA_EMISION", "FECHA_VENCE", "CODIGO_ANTERIOR", "UNI_APROBADAS", "UNI_FACTURADAS", "UNI_DEVUELTAS", "DIFERENCIA", "SOBRANTE", "PRECIO_PVP", "TOTAL") AS 
  SELECT "NO_DOCU",
           "CLIENTE",
           "VENDEDOR",
           "FECHA_EMISION",
           "FECHA_VENCE",
           "CODIGO_ANTERIOR",
           "UNI_APROBADAS",
           "UNI_FACTURADAS",
           "UNI_DEVUELTAS",
           "DIFERENCIA",
           "SOBRANTE",
           "PRECIO_PVP",
           "TOTAL"
      FROM NAF47_TNET.MIGRA_CONSIGNACION@GPOETNET;