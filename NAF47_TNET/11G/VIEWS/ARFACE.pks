
CREATE  FORCE VIEW "NAF47_TNET"."ARFACE" ("NO_CIA", "CENTROD", "NO_FACTU", "NO_PEDIDO", "NO_CLIENTE", "FECHA", "P_DESPACHA", "T_DESPACHA", "COD_T_DESPACHA", "NO_GUIA", "P_RECIBE", "FECHA_ENTREGA", "ESTADO", "OBSERVACION", "FECHA_IN", "FECHA_UP") AS 
  SELECT "NO_CIA",
           "CENTROD",
           "NO_FACTU",
           "NO_PEDIDO",
           "NO_CLIENTE",
           "FECHA",
           "P_DESPACHA",
           "T_DESPACHA",
           "COD_T_DESPACHA",
           "NO_GUIA",
           "P_RECIBE",
           "FECHA_ENTREGA",
           "ESTADO",
           "OBSERVACION",
           "FECHA_IN",
           "FECHA_UP"
      FROM NAF47_TNET.ARFACE@GPOETNET;