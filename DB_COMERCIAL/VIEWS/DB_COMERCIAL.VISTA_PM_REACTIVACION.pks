/* Formatted on 5/2/2023 9:59:09 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_COMERCIAL.VISTA_PM_REACTIVACION
(
    ID_VISTA,
    ID_PERSONA,
    NOMBRE_CLIENTE,
    OFICINA_ID,
    LOGIN,
    NOMBRE_OFICINA,
    FORMA_PAGO_ID,
    DESCRIPCION_FORMA_PAGO,
    ID_PUNTO,
    SALDO,
    EMPRESA_COD,
    FE_ULT_MOD,
    ULTIMA_MILLA,
    ROL
)
BEQUEATH DEFINER
AS
      SELECT ROW_NUMBER () OVER (ORDER BY PERSONA.ID_PERSONA)
                 AS ID_VISTA,
             PERSONA.ID_PERSONA,
             CASE
                 WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                 THEN
                     PERSONA.RAZON_SOCIAL
                 ELSE
                        NVL (PERSONA.NOMBRES, '')
                     || ' '
                     || NVL (PERSONA.APELLIDOS, '')
             END
                 AS NOMBRE_CLIENTE,
             PERSONA_EMPRESA_ROL.OFICINA_ID,
             PUNTO.LOGIN,
             OFICINA_GRUPO.NOMBRE_OFICINA,
             CONTRATO.FORMA_PAGO_ID,
             FORMA_PAGO.DESCRIPCION_FORMA_PAGO,
             PUNTO.ID_PUNTO,
             VISTA_ESTADO_CUENTA.SALDO,
             EMPRESA_ROL.EMPRESA_COD,
             PUNTO.FE_ULT_MOD,
             (SELECT NOMBRE_TIPO_MEDIO
                FROM ADMI_TIPO_MEDIO
               WHERE     CODIGO_TIPO_MEDIO =
                         TECNK_SERVICIOS.FNC_GET_MEDIO_POR_PUNTO (
                             PUNTO.ID_PUNTO,
                             'INTERNET')
                     AND ESTADO = 'Activo')
                 ULTIMA_MILLA,
             ROL.DESCRIPCION_ROL
                 AS ROL
        FROM DB_COMERCIAL.INFO_PUNTO                   PUNTO,
             DB_COMERCIAL.INFO_PERSONA                 PERSONA,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL     PERSONA_EMPRESA_ROL,
             DB_COMERCIAL.INFO_EMPRESA_ROL             EMPRESA_ROL,
             DB_COMERCIAL.INFO_OFICINA_GRUPO           OFICINA_GRUPO,
             DB_COMERCIAL.INFO_CONTRATO                CONTRATO,
             DB_GENERAL.ADMI_FORMA_PAGO                FORMA_PAGO,
             DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VISTA_ESTADO_CUENTA,
             DB_GENERAL.ADMI_ROL                       ROL
       WHERE     VISTA_ESTADO_CUENTA.PUNTO_ID = PUNTO.ID_PUNTO
             AND PUNTO.PERSONA_EMPRESA_ROL_ID =
                 PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
             AND PERSONA_EMPRESA_ROL.PERSONA_ID = PERSONA.ID_PERSONA
             AND PERSONA_EMPRESA_ROL.OFICINA_ID = OFICINA_GRUPO.ID_OFICINA
             AND PERSONA_EMPRESA_ROL.ID_PERSONA_ROL =
                 CONTRATO.PERSONA_EMPRESA_ROL_ID
             AND PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID =
                 EMPRESA_ROL.ID_EMPRESA_ROL
             AND EMPRESA_ROL.ROL_ID = ROL.ID_ROL
             AND CONTRATO.FORMA_PAGO_ID = FORMA_PAGO.ID_FORMA_PAGO
             AND EXISTS
                     (SELECT NULL
                        FROM info_servicio SERVICIO
                       WHERE     SERVICIO.punto_id = PUNTO.ID_PUNTO
                             AND SERVICIO.estado = 'In-Corte'
                             AND SERVICIO.ES_VENTA = 'S')
             AND NOT EXISTS
                     (SELECT NULL
                        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET
                       WHERE     DET.PUNTO_ID = PUNTO.ID_PUNTO
                             AND DET.ESTADO = 'Pendiente'
                             AND ROWNUM = 1)
    ORDER BY PUNTO.LOGIN;
/
