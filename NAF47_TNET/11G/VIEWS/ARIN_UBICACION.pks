CREATE  FORCE VIEW "NAF47_TNET"."ARIN_UBICACION" ("NO_CIA", "CENTRO", "BODEGA", "UBICACION", "DESCRIPCION", "ANCHO", "LARGO", "ALTO", "CAPACIDAD", "USUARIO", "FECHA_REGISTRO") AS 
  SELECT "NO_CIA",
           "CENTRO",
           "BODEGA",
           "UBICACION",
           "DESCRIPCION",
           "ANCHO",
           "LARGO",
           "ALTO",
           "CAPACIDAD",
           "USUARIO",
           "FECHA_REGISTRO"
      FROM NAF47_TNET.ARIN_UBICACION@GPOETNET;