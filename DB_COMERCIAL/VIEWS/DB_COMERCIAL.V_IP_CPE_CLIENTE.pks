/* Formatted on 5/2/2023 9:57:23 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_COMERCIAL.V_IP_CPE_CLIENTE
(
    NOMBRE_OFICINA,
    CLIENTE,
    LOGIN,
    OFICINA_COBERTURA,
    IP_INTERFACE,
    NOMBRE_CPE,
    MARCA_CPE,
    MODELO_CPE,
    ID_SERVICIO,
    ULTIMA_MILLA_ID,
    CPE_DIRECTO,
    DESCRIPCION_ROL,
    TIPO_IDENTIFICACION,
    IDENTIFICACION_CLIENTE
)
BEQUEATH DEFINER
AS
    SELECT (SELECT ofi.NOMBRE_OFICINA
              FROM INFO_OFICINA_GRUPO ofi
             WHERE ofi.ID_OFICINA = iper.OFICINA_ID)
               AS NOMBRE_OFICINA,
           (CASE
                WHEN (   (pers.RAZON_SOCIAL LIKE '')
                      OR (pers.RAZON_SOCIAL IS NULL))
                THEN
                    (pers.NOMBRES || ' ' || pers.APELLIDOS)
                ELSE
                    pers.RAZON_SOCIAL
            END)
               AS CLIENTE,
           p.LOGIN,
           (SELECT jur.NOMBRE_JURISDICCION
              FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION jur
             WHERE jur.ID_JURISDICCION = p.PUNTO_COBERTURA_ID)
               AS OFICINA_COBERTURA,
           serALL.ip
               AS IP_INTERFACE,
           ele.NOMBRE_ELEMENTO
               AS NOMBRE_CPE,
           marE.NOMBRE_MARCA_ELEMENTO
               AS MARCA_CPE,
           modeloE.NOMBRE_MODELO_ELEMENTO
               AS MODELO_CPE,
           serALL.ID_SERVICIO,
           serALL.ULTIMA_MILLA_ID,
           serALL.CPE_DIRECTO,
           rol.DESCRIPCION_ROL,
           pers.TIPO_IDENTIFICACION,
           pers.IDENTIFICACION_CLIENTE
      FROM (SELECT SER2.*,
                   (CASE
                        WHEN (SER2.CANT_ENLACES = 0)
                        THEN
                            SER2.ELEMENTO_CLIENTE_ID
                        ELSE
                            DB_COMERCIAL.COMEK_CONSULTAS.F_GET_ID_ELEMENTO_PRINCIPAL (
                                SER2.INTERFACE_ELEMENTO_CLIENTE_ID,
                                'CPE')
                    END)                                                          AS ID_CPE,
                   (CASE WHEN (SER2.CANT_ENLACES = 0) THEN 'SI' ELSE 'NO' END)    AS CPE_DIRECTO
              FROM (SELECT ser.ID_SERVICIO,
                           ipS.IP,
                           serT.INTERFACE_ELEMENTO_CLIENTE_ID,
                           serT.ULTIMA_MILLA_ID,
                           ser.PUNTO_ID,
                           serT.ELEMENTO_CLIENTE_ID,
                           (SELECT COUNT (*)
                              FROM INFO_ENLACE
                             WHERE INTERFACE_ELEMENTO_INI_ID =
                                   serT.INTERFACE_ELEMENTO_CLIENTE_ID)    AS CANT_ENLACES
                      FROM (SELECT SERVICIO_ID, ip
                              FROM INFO_IP
                             WHERE     SERVICIO_ID IS NOT NULL
                                   AND ESTADO = 'Activo') ipS
                           JOIN
                           (SELECT s.ID_SERVICIO, s.PUNTO_ID
                              FROM (SELECT ID_SERVICIO, PRODUCTO_ID, PUNTO_ID
                                      FROM INFO_SERVICIO
                                     WHERE     PRODUCTO_ID IS NOT NULL
                                           AND ESTADO IN
                                                   ('Activo',
                                                    'In-Corte',
                                                    'EnPruebas')) s
                                   JOIN ADMI_PRODUCTO p
                                       ON s.PRODUCTO_ID = p.ID_PRODUCTO
                             WHERE p.EMPRESA_COD = '10') ser
                               ON ipS.SERVICIO_ID = ser.ID_SERVICIO
                           JOIN INFO_SERVICIO_TECNICO serT
                               ON ser.ID_SERVICIO = serT.SERVICIO_ID
                     WHERE     serT.ELEMENTO_CLIENTE_ID IS NOT NULL
                           AND serT.ULTIMA_MILLA_ID IN (1, 2, 104)) SER2)
           serALL
           JOIN INFO_ELEMENTO ele ON serALL.ID_CPE = ele.ID_ELEMENTO
           JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloE
               ON modeloE.ID_MODELO_ELEMENTO = ele.MODELO_ELEMENTO_ID
           JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO marE
               ON marE.ID_MARCA_ELEMENTO = modeloE.MARCA_ELEMENTO_ID
           JOIN INFO_PUNTO p ON p.ID_PUNTO = serALL.PUNTO_ID
           JOIN INFO_PERSONA_EMPRESA_ROL iper
               ON p.PERSONA_EMPRESA_ROL_ID = iper.ID_PERSONA_ROL
           JOIN (SELECT er.ID_EMPRESA_ROL, ar.DESCRIPCION_ROL
                   FROM INFO_EMPRESA_ROL er, ADMI_ROL ar
                  WHERE ar.ID_ROL = er.ROL_ID) rol
               ON rol.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
           JOIN INFO_PERSONA pers ON pers.ID_PERSONA = iper.PERSONA_ID;
/
