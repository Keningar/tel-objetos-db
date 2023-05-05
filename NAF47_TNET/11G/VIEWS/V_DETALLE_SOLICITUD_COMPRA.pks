CREATE  FORCE VIEW "NAF47_TNET"."V_DETALLE_SOLICITUD_COMPRA" ("NO_CIA", "NO_SOLIC", "FECHA", "FECHA_VENCE", "ESTADO", "OBSERV", "EMPLEADO", "CODIGO_NI", "NO_ARTI", "CANTIDAD", "DESCRIPCION", "MEDIDA") AS 
  SELECT "NO_CIA",
           "NO_SOLIC",
           "FECHA",
           "FECHA_VENCE",
           "ESTADO",
           "OBSERV",
           "EMPLEADO",
           "CODIGO_NI",
           "NO_ARTI",
           "CANTIDAD",
           "DESCRIPCION",
           "MEDIDA"
      FROM NAF47_TNET.V_DETALLE_SOLICITUD_COMPRA@GPOETNET;