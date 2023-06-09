/**
 * @author Alex Gomez <algomez@telconet.ec>
 * @version 1.0
 * @since 22-09-2022
 * Se crea parametros de configuraciones para reingreso automático de servicios adicionales y modificación de datos edificio
 */
SET DEFINE OFF; 

iNSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB(ID_PARAMETRO, NOMBRE_PARAMETRO, DESCRIPCION, MODULO, PROCESO,ESTADO, USR_CREACION, FE_CREACION, IP_CREACION)
VALUES (
DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
'REINGRESO_SERVICIOS_ADICIONALES',
'Parámetros para procesos de reingreso automático de servicios adicionales',
'COMERCIAL',
'COMERCIAL',
'Activo',
'algomez',
SYSDATE,
'127.0.0.1'
);


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD)
VALUES (
DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
(select s.ID_PARAMETRO from DB_GENERAL.ADMI_PARAMETRO_CAB s where s.NOMBRE_PARAMETRO='REINGRESO_SERVICIOS_ADICIONALES'),
'Verificación de estados permitidos para reingreso',
'ESTADOS_PERMITIDOS',
'Rechazada|Anulado',
'Activo',
'algomez',
SYSDATE,
'127.0.0.1',
'18'
);

iNSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB(ID_PARAMETRO, NOMBRE_PARAMETRO, DESCRIPCION, MODULO, PROCESO,ESTADO, USR_CREACION, FE_CREACION, IP_CREACION)
VALUES (
DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
'CONSULTA_DATOS_EDIFICIO',
'Parámetros para procesos de consulta y modificación de datos edificio',
'COMERCIAL',
'COMERCIAL',
'Activo',
'algomez',
SYSDATE,
'127.0.0.1'
);


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD)
VALUES (
DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
(select s.ID_PARAMETRO from DB_GENERAL.ADMI_PARAMETRO_CAB s where s.NOMBRE_PARAMETRO='CONSULTA_DATOS_EDIFICIO'),
'Verificación de estados permitidos para grid de servicio',
'ESTADOS_PERMITIDOS',
'AsignadoTarea',
'Activo',
'algomez',
SYSDATE,
'127.0.0.1',
'18'
);


COMMIT;

/