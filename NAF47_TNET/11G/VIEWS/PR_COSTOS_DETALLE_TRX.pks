CREATE  FORCE VIEW "NAF47_TNET"."PR_COSTOS_DETALLE_TRX" ("ID_COSTO_DETALLE_TRX", "COSTO_RESUMEN_ID", "LLAVE_TRANSACCION", "MONTO_TRANSACCION", "ESTADO", "USR_CREACION", "FE_CREACION", "USR_ULT_MOD", "FE_ULT_MOD", "ORIGEN") AS 
  SELECT "ID_COSTO_DETALLE_TRX",
           "COSTO_RESUMEN_ID",
           "LLAVE_TRANSACCION",
           "MONTO_TRANSACCION",
           "ESTADO",
           "USR_CREACION",
           "FE_CREACION",
           "USR_ULT_MOD",
           "FE_ULT_MOD",
           "ORIGEN"
      FROM NAF47_TNET.PR_COSTOS_DETALLE_TRX@GPOETNET;