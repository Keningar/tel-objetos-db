/* Formatted on 5/2/2023 9:46:22 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW NAF47_TNET.V_ACTIVOS_FIJOS
(
    NO_CIA,
    NO_ACTI,
    DESC_ACTIVO,
    DESC_LARGA_ACTIVO,
    DESC_AREA,
    DESC_DEPARTAMENTO,
    SECCION,
    SERIE,
    MODELO,
    DESC_TIPO,
    DESC_GRUPO,
    DESC_SUBGRUPO,
    F_INGRE,
    FECHA_FIN_VIDA_UTIL,
    DESC_CC,
    DESC_MARCA,
    DURACION,
    DEPACUM_VO_INICIAL,
    VALOR,
    DESECHO,
    DEPACUM,
    VALOR_NETO
)
BEQUEATH DEFINER
AS
    SELECT ARAFMA.NO_CIA,
           ARAFMA.NO_ACTI,
           ARAFMA.DESCRI                                    DESC_ACTIVO,
           ARAFMA.DESCRI1                                   DESC_LARGA_ACTIVO,
           (SELECT DESCRI
              FROM ARPLAR
             WHERE     ARPLAR.AREA = ARAFMA.AREA
                   AND ARPLAR.NO_CIA = ARAFMA.NO_CIA)       DESC_AREA,
           (SELECT DESCRI
              FROM ARPLDP
             WHERE     ARPLDP.DEPA = ARAFMA.NO_DEPA
                   AND ARPLDP.AREA = ARAFMA.AREA
                   AND ARPLDP.NO_CIA = ARAFMA.NO_CIA)       DESC_DEPARTAMENTO,
           ARAFMA.SECCION,
           ARAFMA.SERIE,
           ARAFMA.MODELO,
           ARAFMT.DESCRI                                    DESC_TIPO,
           ARAFGR.DESCRI                                    DESC_GRUPO,
           ARAFSG.DESCRI                                    DESC_SUBGRUPO,
           ARAFMA.F_INGRE,
           ARAFMA.FECHA_FIN_VIDA_UTIL,
           (SELECT DESCRIP_CC
              FROM ARCGCECO
             WHERE     ARCGCECO.CENTRO = ARAFMA.CENTRO_COSTO
                   AND ARCGCECO.NO_CIA = ARAFMA.NO_CIA)     DESC_CC,
           (SELECT DESCRIPCION
              FROM AF_MARCAS
             WHERE     AF_MARCAS.COD_MARCA = ARAFMA.COD_MARCA
                   AND AF_MARCAS.NO_CIA = ARAFMA.NO_CIA)    DESC_MARCA,
           ARAFMA.DURACION,
           ARAFMA.DEPACUM_VO_INICIAL,
             NVL (ARAFMA.VAL_ORIGINAL, 0)
           + NVL (ARAFMA.MEJORAS, 0)
           + NVL (ARAFMA.REV_TECS, 0)                       VALOR,
           ARAFMA.DESECHO,
             NVL (ARAFMA.DEPACUM_VALORIG, 0)
           + NVL (ARAFMA.DEPACUM_MEJORAS, 0)
           + NVL (DEPACUM_REVTECS, 0)                       DEPACUM,
             (  NVL (ARAFMA.VAL_ORIGINAL, 0)
              + NVL (ARAFMA.MEJORAS, 0)
              + NVL (ARAFMA.REV_TECS, 0))
           - (  NVL (ARAFMA.DEPACUM_VALORIG, 0)
              + NVL (ARAFMA.DEPACUM_MEJORAS, 0)
              + NVL (DEPACUM_REVTECS, 0))                   VALOR_NETO
      FROM ARAFMA,
           ARAFMT,
           ARAFGR,
           ARAFSG
     WHERE     ARAFMA.NO_CIA = ARAFMT.NO_CIA
           AND ARAFMA.TIPO = ARAFMT.TIPO
           AND ARAFMA.NO_CIA = ARAFGR.NO_CIA
           AND ARAFMA.TIPO = ARAFGR.TIPO
           AND ARAFMA.GRUPO = ARAFGR.GRUPO
           AND ARAFMA.NO_CIA = ARAFSG.NO_CIA
           AND ARAFMA.TIPO = ARAFSG.TIPO
           AND ARAFMA.GRUPO = ARAFSG.GRUPO
           AND ARAFMA.SUBGRUPO = ARAFSG.SUBGRUPO;
/
