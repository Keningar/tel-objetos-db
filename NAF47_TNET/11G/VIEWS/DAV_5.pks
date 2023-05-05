CREATE  FORCE VIEW "NAF47_TNET"."DAV_5" ("NO_CIA", "NUM_FAC", "NO_ARTI", "NO_LINEA", "CODIGO_ARANCEL", "TRADUCCION", "DESCRIPCION", "PAIS", "MARCA", "ESTADO", "CANTIDAD", "UNIDAD", "FOB") AS 
  SELECT "NO_CIA",
           "NUM_FAC",
           "NO_ARTI",
           "NO_LINEA",
           "CODIGO_ARANCEL",
           "TRADUCCION",
           "DESCRIPCION",
           "PAIS",
           "MARCA",
           "ESTADO",
           "CANTIDAD",
           "UNIDAD",
           "FOB"
      FROM NAF47_TNET.DAV_5@GPOETNET;