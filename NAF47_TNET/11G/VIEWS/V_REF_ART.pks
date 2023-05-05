CREATE  FORCE VIEW "NAF47_TNET"."V_REF_ART" ("NO_CIA", "DESC_LINEA", "DESC_MARCA", "DESC_DIVISION", "DESC_SUBDIVISION", "DESC_TIPOITEM", "DESC_AREA", "DESC_COMSUMIDOR", "DESC_PRESENTACION", "DESC_CLASE", "DESC_CATEGORIA", "NO_ARTI", "DESCRIPCION", "TIPO_ASTERISCO", "IND_ACTIVO", "IMP_VEN", "APLICA_IMPUESTO", "UNIDAD", "GRUPO", "PRECIOBASE", "ESPECIFICACION", "DESCRIPCION_ALTERNA") AS 
  SELECT "NO_CIA",
           "DESC_LINEA",
           "DESC_MARCA",
           "DESC_DIVISION",
           "DESC_SUBDIVISION",
           "DESC_TIPOITEM",
           "DESC_AREA",
           "DESC_COMSUMIDOR",
           "DESC_PRESENTACION",
           "DESC_CLASE",
           "DESC_CATEGORIA",
           "NO_ARTI",
           "DESCRIPCION",
           "TIPO_ASTERISCO",
           "IND_ACTIVO",
           "IMP_VEN",
           "APLICA_IMPUESTO",
           "UNIDAD",
           "GRUPO",
           "PRECIOBASE",
           "ESPECIFICACION",
           "DESCRIPCION_ALTERNA"
      FROM NAF47_TNET.V_REF_ART@GPOETNET;