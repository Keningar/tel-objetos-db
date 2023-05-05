CREATE  FORCE VIEW "NAF47_TNET"."ARINMA" ("NO_CIA", "BODEGA", "NO_ARTI", "CLASE", "CATEGORIA", "UBICACION", "SAL_ANT_UN", "COMP_UN", "OTRS_UN", "VENT_UN", "CONS_UN", "SAL_PEND_UN", "ENT_PEND_UN", "PEDIDOS_PEND", "MANIFIESTOPEND", "SAL_ANT_MO", "COMP_MON", "OTRS_MON", "VENT_MON", "CONS_MON", "COSTO_UNI", "PROCESO_SOLI", "NO_SOLIC", "ULT_COSTO", "AFECTA_COSTO", "FEC_U_VEN", "PROCESO_TOMA", "EXIST_PREP", "COSTO_PREP", "CANT_NO_INV", "ACTIVO", "FEC_U_COMP", "COSTO2", "MONTO2", "ULT_COSTO2") AS 
  SELECT "NO_CIA",
           "BODEGA",
           "NO_ARTI",
           "CLASE",
           "CATEGORIA",
           "UBICACION",
           "SAL_ANT_UN",
           "COMP_UN",
           "OTRS_UN",
           "VENT_UN",
           "CONS_UN",
           "SAL_PEND_UN",
           "ENT_PEND_UN",
           "PEDIDOS_PEND",
           "MANIFIESTOPEND",
           "SAL_ANT_MO",
           "COMP_MON",
           "OTRS_MON",
           "VENT_MON",
           "CONS_MON",
           "COSTO_UNI",
           "PROCESO_SOLI",
           "NO_SOLIC",
           "ULT_COSTO",
           "AFECTA_COSTO",
           "FEC_U_VEN",
           "PROCESO_TOMA",
           "EXIST_PREP",
           "COSTO_PREP",
           "CANT_NO_INV",
           "ACTIVO",
           "FEC_U_COMP",
           "COSTO2",
           "MONTO2",
           "ULT_COSTO2"
      FROM NAF47_TNET.ARINMA@GPOETNET;