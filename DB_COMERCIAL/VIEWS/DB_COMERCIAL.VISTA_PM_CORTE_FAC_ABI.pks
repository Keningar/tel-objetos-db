/* Formatted on 5/2/2023 9:54:44 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_COMERCIAL.VISTA_PM_CORTE_FAC_ABI
(
    ID_PERSONA,
    NOMBRE_CLIENTE,
    EMPRESA_COD,
    ID_OFICINA,
    NOMBRE_OFICINA,
    ID_PUNTO,
    LOGIN,
    ID_TIPO_NEGOCIO,
    NOMBRE_TIPO_NEGOCIO,
    ID_FORMA_PAGO,
    DESCRIPCION_FORMA_PAGO,
    SALDO,
    ULTIMA_MILLA,
    BANCO_ID,
    DESCRIPCION_BANCO,
    TIPO_CUENTA_ID,
    DESCRIPCION_CUENTA,
    ES_TARJETA,
    ROL,
    CICLO_ID
)
BEQUEATH DEFINER
AS
    SELECT DISTINCT
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
           EMPRESA_ROL.EMPRESA_COD,
           OFICINA_GRUPO.ID_OFICINA,
           (SELECT NOMBRE_OFICINA
              FROM DB_COMERCIAL.INFO_OFICINA_GRUPO
             WHERE ID_OFICINA = OFICINA_GRUPO.ID_OFICINA)
               NOMBRE_OFICINA,
           PUNTO.ID_PUNTO,
           PUNTO.LOGIN,
           TIPO_NEGOCIO.ID_TIPO_NEGOCIO,
           (SELECT NOMBRE_TIPO_NEGOCIO
              FROM DB_COMERCIAL.ADMI_TIPO_NEGOCIO
             WHERE ID_TIPO_NEGOCIO = TIPO_NEGOCIO.ID_TIPO_NEGOCIO)
               NOMBRE_TIPO_NEGOCIO,
           FORMA_PAGO.ID_FORMA_PAGO,
           (SELECT DESCRIPCION_FORMA_PAGO
              FROM DB_GENERAL.ADMI_FORMA_PAGO
             WHERE ID_FORMA_PAGO = FORMA_PAGO.ID_FORMA_PAGO)
               DESCRIPCION_FORMA_PAGO,
           VISTA_SALDOS.SALDO,
           (SELECT ATM.NOMBRE_TIPO_MEDIO
              FROM DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM
             WHERE     ATM.CODIGO_TIPO_MEDIO =
                       (CASE
                            WHEN    (EMPRESA_ROL.EMPRESA_COD) = '18'
                                 OR (EMPRESA_ROL.EMPRESA_COD) = '33'
                            THEN
                                (SELECT TM.CODIGO_TIPO_MEDIO
                                   FROM DB_COMERCIAL.INFO_SERVICIO    ISR,
                                        DB_COMERCIAL.INFO_PLAN_CAB    IPC,
                                        DB_COMERCIAL.INFO_PLAN_DET    IPD,
                                        DB_COMERCIAL.ADMI_PRODUCTO    AP,
                                        DB_COMERCIAL.INFO_SERVICIO_TECNICO ST,
                                        DB_COMERCIAL.ADMI_TIPO_MEDIO  TM
                                  WHERE     ISR.PLAN_ID = IPC.ID_PLAN
                                        AND IPC.ID_PLAN = IPD.PLAN_ID
                                        AND IPD.PRODUCTO_ID = AP.ID_PRODUCTO
                                        AND AP.NOMBRE_TECNICO = 'INTERNET'
                                        AND ISR.PUNTO_ID = PUNTO.ID_PUNTO
                                        AND ISR.ID_SERVICIO = ST.SERVICIO_ID
                                        AND ST.ULTIMA_MILLA_ID =
                                            TM.ID_TIPO_MEDIO
                                        AND ROWNUM < 2)
                            ELSE
                                (SELECT TM.CODIGO_TIPO_MEDIO
                                   FROM DB_COMERCIAL.INFO_SERVICIO    ISR,
                                        DB_COMERCIAL.INFO_SERVICIO_TECNICO
                                        SRT,
                                        DB_COMERCIAL.ADMI_TIPO_MEDIO  TM,
                                        DB_COMERCIAL.ADMI_PRODUCTO    AP
                                  WHERE     ISR.PRODUCTO_ID = AP.ID_PRODUCTO
                                        AND AP.NOMBRE_TECNICO = 'INTERNET'
                                        AND AP.ESTADO = 'Activo'
                                        AND ISR.PUNTO_ID = PUNTO.ID_PUNTO
                                        AND ISR.ID_SERVICIO = SRT.SERVICIO_ID
                                        AND SRT.ULTIMA_MILLA_ID =
                                            TM.ID_TIPO_MEDIO
                                        AND ROWNUM < 2)
                        END)
                   AND ATM.ESTADO = 'Activo')
               AS ULTIMA_MILLA,
           CUENTAS_TARJETAS.BANCO_ID,
           CUENTAS_TARJETAS.DESCRIPCION_BANCO,
           CUENTAS_TARJETAS.TIPO_CUENTA_ID,
           CUENTAS_TARJETAS.DESCRIPCION_CUENTA,
           CUENTAS_TARJETAS.ES_TARJETA,
           ROL.DESCRIPCION_ROL
               AS ROL,
           (SELECT MAX (PER_CARACT.VALOR)
              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC  PER_CARACT
                   INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
                       ON CARACT.ID_CARACTERISTICA =
                          PER_CARACT.CARACTERISTICA_ID
             WHERE     PER_CARACT.PERSONA_EMPRESA_ROL_ID =
                       PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
                   AND PER_CARACT.ESTADO = 'Activo'
                   AND CARACT.DESCRIPCION_CARACTERISTICA =
                       'CICLO_FACTURACION')
               AS CICLO_ID
      FROM DB_COMERCIAL.INFO_PERSONA  PERSONA
           INNER JOIN
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL
               ON PERSONA_EMPRESA_ROL.PERSONA_ID = PERSONA.ID_PERSONA
           INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL
               ON EMPRESA_ROL.ID_EMPRESA_ROL =
                  PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID
           INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA_GRUPO
               ON OFICINA_GRUPO.ID_OFICINA = PERSONA_EMPRESA_ROL.OFICINA_ID
           INNER JOIN DB_GENERAL.ADMI_ROL ROL
               ON ROL.ID_ROL = EMPRESA_ROL.ROL_ID
           INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
               ON PUNTO.PERSONA_EMPRESA_ROL_ID =
                  PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
           INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO TIPO_NEGOCIO
               ON TIPO_NEGOCIO.ID_TIPO_NEGOCIO = PUNTO.TIPO_NEGOCIO_ID
           INNER JOIN DB_COMERCIAL.INFO_CONTRATO CONTRATO
               ON CONTRATO.PERSONA_EMPRESA_ROL_ID =
                  PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
           INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO FORMA_PAGO
               ON FORMA_PAGO.ID_FORMA_PAGO = CONTRATO.FORMA_PAGO_ID
           INNER JOIN DB_COMERCIAL.INFO_PUNTO_SALDO VISTA_SALDOS
               ON VISTA_SALDOS.PUNTO_ID = PUNTO.ID_PUNTO
           LEFT JOIN
           (SELECT CONTRATO_FORMA_PAGO.CONTRATO_ID,
                   BANCO_TIPO_CUENTA.BANCO_ID,
                   BANCO.DESCRIPCION_BANCO,
                   BANCO_TIPO_CUENTA.TIPO_CUENTA_ID,
                   TIPO_CUENTA.DESCRIPCION_CUENTA,
                   TIPO_CUENTA.ES_TARJETA
              FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  CONTRATO_FORMA_PAGO
                   INNER JOIN
                   DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BANCO_TIPO_CUENTA
                       ON BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA =
                          CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID
                   LEFT JOIN DB_GENERAL.ADMI_BANCO BANCO
                       ON BANCO.ID_BANCO = BANCO_TIPO_CUENTA.BANCO_ID
                   LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA TIPO_CUENTA
                       ON TIPO_CUENTA.ID_TIPO_CUENTA =
                          CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID
             WHERE CONTRATO_FORMA_PAGO.ESTADO = 'Activo') CUENTAS_TARJETAS
               ON CUENTAS_TARJETAS.CONTRATO_ID = CONTRATO.ID_CONTRATO
           LEFT OUTER JOIN
           (SELECT DET.PUNTO_ID
              FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB  CAB
                   INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET
                       ON CAB.ID_PROCESO_MASIVO_CAB =
                          DET.PROCESO_MASIVO_CAB_ID
             WHERE     CAB.ESTADO IN
                           (SELECT PARAM_DET.VALOR4
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB  PARAM_CAB
                                   INNER JOIN
                                   DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                       ON PARAM_DET.PARAMETRO_ID =
                                          PARAM_CAB.ID_PARAMETRO
                             WHERE     PARAM_CAB.NOMBRE_PARAMETRO =
                                       'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
                                   AND PARAM_CAB.ESTADO = 'Activo'
                                   AND PARAM_DET.VALOR1 = 'CORTE_MASIVO'
                                   AND PARAM_DET.VALOR2 =
                                       'FILTROS_REGISTROS_PM_NO_PERMITIDOS'
                                   AND PARAM_DET.VALOR3 =
                                       'ESTADOS_INFO_PROCESO_MASIVO_CAB'
                                   AND PARAM_DET.ESTADO = 'Activo')
                   AND CAB.TIPO_PROCESO IN
                           (SELECT PARAM_DET.VALOR4
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB  PARAM_CAB
                                   INNER JOIN
                                   DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                       ON PARAM_DET.PARAMETRO_ID =
                                          PARAM_CAB.ID_PARAMETRO
                             WHERE     PARAM_CAB.NOMBRE_PARAMETRO =
                                       'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
                                   AND PARAM_CAB.ESTADO = 'Activo'
                                   AND PARAM_DET.VALOR1 = 'CORTE_MASIVO'
                                   AND PARAM_DET.VALOR2 =
                                       'FILTROS_REGISTROS_PM_NO_PERMITIDOS'
                                   AND PARAM_DET.VALOR3 =
                                       'TIPOS_PROCESO_INFO_PROCESO_MASIVO_CAB'
                                   AND PARAM_DET.ESTADO = 'Activo')
                   AND DET.ESTADO IN
                           (SELECT PARAM_DET.VALOR4
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB  PARAM_CAB
                                   INNER JOIN
                                   DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                       ON PARAM_DET.PARAMETRO_ID =
                                          PARAM_CAB.ID_PARAMETRO
                             WHERE     PARAM_CAB.NOMBRE_PARAMETRO =
                                       'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
                                   AND PARAM_CAB.ESTADO = 'Activo'
                                   AND PARAM_DET.VALOR1 = 'CORTE_MASIVO'
                                   AND PARAM_DET.VALOR2 =
                                       'FILTROS_REGISTROS_PM_NO_PERMITIDOS'
                                   AND PARAM_DET.VALOR3 =
                                       'ESTADOS_INFO_PROCESO_MASIVO_DET'
                                   AND PARAM_DET.ESTADO = 'Activo'))
           T_REGISTROS_PM_NO_PERMITIDOS
               ON T_REGISTROS_PM_NO_PERMITIDOS.PUNTO_ID = PUNTO.ID_PUNTO
     WHERE     CONTRATO.ESTADO = 'Activo'
           AND T_REGISTROS_PM_NO_PERMITIDOS.PUNTO_ID IS NULL
           AND EXISTS
                   (SELECT NULL
                      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_PUNTO
                     WHERE     SERVICIO_PUNTO.PUNTO_ID = PUNTO.ID_PUNTO
                           AND SERVICIO_PUNTO.ESTADO = 'Activo'
                           AND SERVICIO_PUNTO.ES_VENTA = 'S');
/
