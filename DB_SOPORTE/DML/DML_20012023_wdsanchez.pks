/**
* DEBE EJECUTARSE EN DB_SOPORTE.
* Script para insertar la tarea nuevo que se va a generar para
* Derecho legal eliminacion.
* @author William Sanchez <wdsanchez@telconet.ec>
* @version 1.0 20-01-2023 - Versión Inicial.
*/

INSERT INTO DB_SOPORTE.admi_tarea (ID_TAREA,PROCESO_ID,ROL_AUTORIZA_ID,TAREA_ANTERIOR_ID,TAREA_SIGUIENTE_ID,PESO,ES_APROBADA,NOMBRE_TAREA,DESCRIPCION_TAREA,TIEMPO_MAX,UNIDAD_MEDIDA_TIEMPO,COSTO,PRECIO_PROMEDIO,ESTADO,USR_CREACION,FE_CREACION,USR_ULT_MOD,FE_ULT_MOD,AUTOMATICA_WS,CATEGORIA_TAREA_ID,PRIORIDAD,REQUIERE_FIBRA,VISUALIZAR_MOVIL) VALUES 
(
DB_SOPORTE.SEQ_ADMI_TAREA.NEXTVAL,
(SELECT ID_PROCESO from DB_SOPORTE.admi_proceso WHERE NOMBRE_PROCESO = 'PROCESOS DERECHOS DEL TITULAR'),
null,
null,
null,
1,
'0',
'SOLICITUD DE ELIMINACION',
'Solicitud de eliminacion',
1,
'MINUTOS',
1,
1,
'Activo',
'wdsanchez',
sysdate,
'wdsanchez',
sysdate,
null,
null,
null,
'N',
'N'
);

commit;

/
