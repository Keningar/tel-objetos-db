/* Formatted on 5/2/2023 9:54:13 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW DB_COMERCIAL.V_SEGURIDAD_ECUCERT
(
    ID_SERVICIO,
    FECHA_ACTIVACION,
    ESTADO,
    RAZON_SOCIAL_CLIENTE,
    LOGIN,
    LOGIN_AUX,
    GRUPO,
    PRODUCTO,
    TIPO_ENLACE,
    TIPO_MEDIO,
    CAPACIDAD_KB,
    NOMBRE_ELEMENTO,
    NOMBRE_INTERFACE_ELEMENTO,
    IP,
    TIPO_IP,
    MASCARA,
    SUBRED,
    NOMBRE_PE,
    NOMBRE_RUTA,
    RED_LAN,
    MASCARA_RED_LAN,
    TIPO_RED,
    PUNTO_COBERTURA,
    CONTACTO_TECNICO,
    TIENE_ASIGNADO_VIP,
    INGENIERO_VIP,
    SERVICIOS_GESTIONADOS,
    EMPRESA
)
BEQUEATH DEFINER
AS
    SELECT INFOSERVICIO.ID_SERVICIO,
           (SELECT FE_CREACION
              FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
             WHERE ID_SERVICIO_HISTORIAL =
                   (SELECT MIN (ID_SERVICIO_HISTORIAL)
                      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                     WHERE     SERVICIO_ID = INFOSERVICIO.ID_SERVICIO
                           AND ESTADO = 'Activo'))
               AS FECHA_ACTIVACION,
           INFOSERVICIO.ESTADO,
           (CASE
                WHEN (INFOPERSONA.NOMBRES IS NULL)
                THEN
                    INFOPERSONA.RAZON_SOCIAL
                ELSE
                    INFOPERSONA.NOMBRES || ' ' || INFOPERSONA.APELLIDOS
            END)
               AS RAZON_SOCIAL_CLIENTE,
           INFOPUNTO.LOGIN
               AS LOGIN,
           INFOSERVICIO.LOGIN_AUX,
           (SELECT GRUPO
              FROM DB_COMERCIAL.ADMI_PRODUCTO
             WHERE ID_PRODUCTO = INFOSERVICIO.PRODUCTO_ID)
               AS GRUPO,
           (SELECT DESCRIPCION_PRODUCTO
              FROM DB_COMERCIAL.ADMI_PRODUCTO
             WHERE ID_PRODUCTO = INFOSERVICIO.PRODUCTO_ID)
               AS PRODUCTO,
           (SELECT TIPO_ENLACE
              FROM DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO
             WHERE SERVICIO_ID = INFOSERVICIO.ID_SERVICIO)
               AS TIPO_ENLACE,
           (SELECT NOMBRE_TIPO_MEDIO
              FROM DB_COMERCIAL.ADMI_TIPO_MEDIO
             WHERE ID_TIPO_MEDIO =
                   (SELECT ULTIMA_MILLA_ID
                      FROM DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO
                     WHERE SERVICIO_ID = INFOSERVICIO.ID_SERVICIO))
               AS TIPO_MEDIO,
           (SELECT VALOR
              FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
             WHERE     ISPC.PRODUCTO_CARACTERISITICA_ID IN
                           (SELECT APC.ID_PRODUCTO_CARACTERISITICA
                              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
                                   APC
                             WHERE     APC.CARACTERISTICA_ID IN
                                           (SELECT ID_CARACTERISTICA
                                              FROM DB_COMERCIAL.ADMI_CARACTERISTICA
                                             WHERE     UPPER (
                                                           DESCRIPCION_CARACTERISTICA) =
                                                       'CAPACIDAD1'
                                                   AND ESTADO = 'Activo')
                                   AND APC.ESTADO = 'Activo')
                   AND ISPC.ESTADO = 'Activo'
                   AND ISPC.SERVICIO_ID = INFOSERVICIO.ID_SERVICIO)
               AS CAPACIDAD_KB,
           (SELECT NOMBRE_ELEMENTO
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
             WHERE ID_ELEMENTO =
                   (SELECT ELEMENTO_ID
                      FROM DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO
                     WHERE SERVICIO_ID = INFOSERVICIO.ID_SERVICIO))
               AS NOMBRE_ELEMENTO,
           (SELECT NOMBRE_INTERFACE_ELEMENTO
              FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
             WHERE ID_INTERFACE_ELEMENTO =
                   (SELECT INTERFACE_ELEMENTO_ID
                      FROM DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO
                     WHERE SERVICIO_ID = INFOSERVICIO.ID_SERVICIO))
               AS NOMBRE_INTERFACE_ELEMENTO,
           INFOIP.IP
               AS IP,
           INFOIP.TIPO_IP
               AS TIPO_IP,
           INFOIP.MASCARA
               AS MASCARA,
           (SELECT SUBRED
              FROM DB_INFRAESTRUCTURA.INFO_SUBRED
             WHERE ID_SUBRED = INFOIP.SUBRED_ID)
               AS SUBRED,
           (SELECT NOMBRE_ELEMENTO
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
             WHERE ID_ELEMENTO = ((SELECT ELEMENTO_ID
                                     FROM DB_INFRAESTRUCTURA.INFO_SUBRED
                                    WHERE ID_SUBRED = INFOIP.SUBRED_ID)))
               AS NOMBRE_PE,
           INFORUTAELEMENTO.NOMBRE
               AS NOMBRE_RUTA,
           INFORUTAELEMENTO.RED_LAN
               AS RED_LAN,
           INFORUTAELEMENTO.MASCARA_RED_LAN
               AS MASCARA_RED_LAN,
           INFORUTAELEMENTO.TIPO
               AS TIPO_RED,
           ADMIJURISDICCION.NOMBRE_JURISDICCION
               AS PUNTO_COBERTURA,
           (SELECT LISTAGG (
                       REGEXP_SUBSTR (
                           FC.VALOR,
                           '[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,4}'),
                       '|')
                   WITHIN GROUP (ORDER BY FC.VALOR DESC)    AS CONTACTO_TECNICO
              FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO          PC,
                   DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO  FC,
                   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL     PER,
                   DB_COMERCIAL.INFO_EMPRESA_ROL             ER,
                   DB_COMERCIAL.ADMI_ROL                     R
             WHERE     PC.PUNTO_ID = INFOSERVICIO.PUNTO_ID
                   AND PER.ID_PERSONA_ROL = PC.PERSONA_EMPRESA_ROL_ID
                   AND PER.EMPRESA_ROL_ID = ER.ID_EMPRESA_ROL
                   AND ER.ROL_ID = R.ID_ROL
                   AND PC.CONTACTO_ID = FC.PERSONA_ID
                   AND FC.FORMA_CONTACTO_ID = 5
                   AND FC.ESTADO = 'Activo'
                   AND PC.ESTADO = 'Activo'
                   AND R.DESCRIPCION_ROL = 'Contacto Tecnico')
               AS CONTACTO_TECNICO,
           (SELECT CASE WHEN (COUNT (P.NOMBRES) = 0) THEN 'NO' ELSE 'SI' END
              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC  PERC
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                       ON PER.ID_PERSONA_ROL =
                          COALESCE (
                              TO_NUMBER (REGEXP_SUBSTR (PERC.VALOR, '^\d+')),
                              0)
                   INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                       ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA P
                       ON P.ID_PERSONA = PER.PERSONA_ID
                   INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C
                       ON C.ID_CARACTERISTICA = PERC.CARACTERISTICA_ID
             WHERE     PERC.PERSONA_EMPRESA_ROL_ID =
                       INFOPUNTO.PERSONA_EMPRESA_ROL_ID
                   AND C.DESCRIPCION_CARACTERISTICA = 'ID_VIP'
                   AND PERC.ESTADO = 'Activo'
                   AND ER.EMPRESA_COD = '10')
               AS TIENE_ASIGNADO_VIP,
           (SELECT LISTAGG (UPPER (P.NOMBRES || ' ' || P.APELLIDOS), '|')
                       WITHIN GROUP (ORDER BY NOMBRES DESC)    AS INGENIERO_VIP
              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC  PERC
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                       ON PER.ID_PERSONA_ROL =
                          COALESCE (
                              TO_NUMBER (REGEXP_SUBSTR (PERC.VALOR, '^\d+')),
                              0)
                   INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                       ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA P
                       ON P.ID_PERSONA = PER.PERSONA_ID
                   INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C
                       ON C.ID_CARACTERISTICA = PERC.CARACTERISTICA_ID
             WHERE     PERC.PERSONA_EMPRESA_ROL_ID =
                       INFOPUNTO.PERSONA_EMPRESA_ROL_ID
                   AND C.DESCRIPCION_CARACTERISTICA = 'ID_VIP'
                   AND PERC.ESTADO = 'Activo'
                   AND ER.EMPRESA_COD = '10')
               AS INGENIERO_VIP,
           (SELECT CASE
                       WHEN (COUNT (vScanning.id_servicio) = 0) THEN 'NO'
                       ELSE 'SI'
                   END
              FROM DB_COMERCIAL.V_SCANNING_FIREWALL VSCANNING
             WHERE     VSCANNING.LOGIN = INFOPUNTO.LOGIN
                   AND VSCANNING.ESTADO_SERVICIO = 'Activo')
               AS SERVICIOS_GESTIONADOS,
           (SELECT NOMBRE_EMPRESA
              FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
             WHERE COD_EMPRESA =
                   (SELECT EMPRESA_ID
                      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO
                     WHERE ID_OFICINA =
                           (SELECT OFICINA_ID
                              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
                             WHERE ID_PERSONA_ROL =
                                   (SELECT PERSONA_EMPRESA_ROL_ID
                                      FROM DB_COMERCIAL.INFO_PUNTO
                                     WHERE ID_PUNTO = INFOSERVICIO.PUNTO_ID))))
               AS EMPRESA
      FROM DB_COMERCIAL.INFO_IP                   INFOIP,
           DB_COMERCIAL.INFO_SERVICIO             INFOSERVICIO,
           DB_INFRAESTRUCTURA.INFO_RUTA_ELEMENTO  INFORUTAELEMENTO,
           DB_COMERCIAL.INFO_PUNTO                INFOPUNTO,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  INFOPERSONAEMPRESAROL,
           DB_COMERCIAL.INFO_PERSONA              INFOPERSONA,
           DB_COMERCIAL.ADMI_JURISDICCION         ADMIJURISDICCION
     WHERE     INFOIP.SERVICIO_ID = INFOSERVICIO.ID_SERVICIO
           AND INFOSERVICIO.PUNTO_ID = INFOPUNTO.ID_PUNTO
           AND INFORUTAELEMENTO.SERVICIO_ID = INFOSERVICIO.ID_SERVICIO
           AND INFOPUNTO.PERSONA_EMPRESA_ROL_ID =
               INFOPERSONAEMPRESAROL.ID_PERSONA_ROL
           AND INFOPERSONAEMPRESAROL.PERSONA_ID = INFOPERSONA.ID_PERSONA
           AND INFOPUNTO.PUNTO_COBERTURA_ID =
               ADMIJURISDICCION.ID_JURISDICCION
           AND INFOIP.ESTADO = 'Activo'
           AND INFOPUNTO.PERSONA_EMPRESA_ROL_ID IN
                   ((SELECT ID_PERSONA_ROL
                       FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
                      WHERE OFICINA_ID IN
                                (SELECT ID_OFICINA
                                   FROM DB_COMERCIAL.INFO_OFICINA_GRUPO
                                  WHERE EMPRESA_ID IN (10, 18))));

/
