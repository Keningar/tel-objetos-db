CREATE  FORCE VIEW "NAF47_TNET"."TAPPROYECCION" ("NO_CIA", "NO_ARTI", "TIEMPO_ENTREGA", "CANTIDAD_SOLICITADA", "STOCK", "PEDIDO_SUGERIDO", "USUARIO", "VENTAS_PERIODO", "ROTACION_DIARIA", "MINIMO", "REORDEN", "MAXIMO", "FECHA_GENERACION") AS 
  SELECT "NO_CIA",
           "NO_ARTI",
           "TIEMPO_ENTREGA",
           "CANTIDAD_SOLICITADA",
           "STOCK",
           "PEDIDO_SUGERIDO",
           "USUARIO",
           "VENTAS_PERIODO",
           "ROTACION_DIARIA",
           "MINIMO",
           "REORDEN",
           "MAXIMO",
           "FECHA_GENERACION"
      FROM NAF47_TNET.TAPPROYECCION@GPOETNET;