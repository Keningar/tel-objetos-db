CREATE  FORCE VIEW "NAF47_TNET"."PL_LOCALIDADES" ("NO_CIA", "LOCALIDAD", "DESCRIPCION") AS 
  SELECT "NO_CIA", "LOCALIDAD", "DESCRIPCION"
      FROM NAF47_TNET.PL_LOCALIDADES@GPOETNET;