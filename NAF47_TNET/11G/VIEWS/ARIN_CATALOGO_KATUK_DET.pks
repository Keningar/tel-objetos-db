CREATE  FORCE VIEW "NAF47_TNET"."ARIN_CATALOGO_KATUK_DET" ("ID_CATALOGO_DET", "NOMBRE", "NIVEL", "TIPO", "CODIGO", "CATALOGO_ID", "ESTADO", "FECHA_CREACION", "USUARIO_CREACION", "FECHA_ACTUALIZA", "USUARIO_ACTUALIZA") AS 
  SELECT "ID_CATALOGO_DET","NOMBRE","NIVEL","TIPO","CODIGO","CATALOGO_ID","ESTADO","FECHA_CREACION","USUARIO_CREACION","FECHA_ACTUALIZA","USUARIO_ACTUALIZA"
FROM NAF47_TNET.ARIN_CATALOGO_KATUK_DET@GPOETNET;