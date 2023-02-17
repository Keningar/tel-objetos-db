/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear cabecera y detalle de parametros para microservicios derecho legal
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 20-01-2023 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL, 'PARAMETROS_DLEGAL', 'PARAMETROS AUXILIARES QUE INTERACTUAN COMP CREDENCIALES','SEGURIDAD', NULL,'Activo','wdsanchez',SYSDATE,'127.0.0.1', NULL, NULL, NULL);




INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'),
'DATOS_CORREO_CIFRAR',
'Proceso Cifrado',
'notificacionesnetlife@netlife.info.ec',
'plantillaDLCifradoDatos',
'¡Hola {$nombre}!, tu solicitud de atención de derechos de datos personales fue procesada exitosamente.', 
'Activo', 
'wdsanchez', 
SYSDATE, 
'127.0.0.1', 
NULL, 
NULL, 
NULL, 
NULL, 
18, 
'parametro',
NULL, 
NULL,
NULL,
NULL);


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'),
'TAREA_ENTREGA_EQUIPO',
'Tarea ejecutada para entrega de equipo',
'4239',
null,
null, 
'Activo', 
'wdsanchez', 
SYSDATE, 
'127.0.0.1', 
NULL, 
NULL, 
NULL, 
NULL, 
18, 
'parametro',
NULL, 
NULL,
NULL,
NULL);




INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'),
'TAREA_PAGO_EQUIPO',
'Tarea ejecutada para pago de equipos no entregados',
'4239',
null,
null, 
'Activo', 
'wdsanchez', 
SYSDATE, 
'127.0.0.1', 
NULL, 
NULL, 
NULL, 
NULL, 
18, 
'parametro',
NULL, 
NULL,
NULL,
NULL);



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'),
'BANDERA_FINALIZA_TAREA',
'Bandera para comprobar el estado al tarea finalizada',
'S',
null,
null, 
'Activo', 
'wdsanchez', 
SYSDATE, 
'127.0.0.1', 
NULL, 
NULL, 
NULL, 
NULL, 
18, 
'parametro',
NULL, 
NULL,
NULL,
NULL);


COMMIT;


/
     
