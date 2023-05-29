/**
 * Scripts para los parametros que permiten el ingreso de las tareas del producto SAFE ENTRY
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 09-12-2022
 */
--**************************************
--************ DB SOPORTE **************
--**************************************
--Tarea para el retiro de equipos ELECTRICO
INSERT
INTO DB_SOPORTE.ADMI_PROCESO
  (
    ID_PROCESO,
    NOMBRE_PROCESO,
    DESCRIPCION_PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    VISIBLE,
    PLANMANTENIMIENTO
  )
  VALUES
  (
  DB_SOPORTE.SEQ_ADMI_PROCESO.NEXTVAL,
  'TAREAS DE ELECTRICO - RETIRO DE EQUIPOS',
  'Tareas de retiro de equipos de clientes solicitadas al departamento electrico',
  'Activo',
  'lemero',
  SYSDATE,
  'lemero',
  SYSDATE,
  'SI',
  'N'
  );
INSERT
INTO DB_SOPORTE.ADMI_PROCESO_EMPRESA VALUES
  (
    DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,
    (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_proceso where NOMBRE_PROCESO = 'TAREAS DE ELECTRICO - RETIRO DE EQUIPOS' AND ESTADO ='Activo'),
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    ),
    'Activo',
    'lemero',
    SYSDATE
  );
INSERT
INTO DB_SOPORTE.ADMI_TAREA
  (
    ID_TAREA,
    PROCESO_ID,
    NOMBRE_TAREA,
    DESCRIPCION_TAREA,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    REQUIERE_FIBRA,
    VISUALIZAR_MOVIL
  )
  VALUES
  (
  DB_SOPORTE.SEQ_ADMI_TAREA.NEXTVAL,
  (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_proceso where NOMBRE_PROCESO = 'TAREAS DE ELECTRICO - RETIRO DE EQUIPOS' AND ESTADO ='Activo'),
  'RETIRO DE EQUIPOS SAFE ENTRY',
  'Tarea para solicitar el retiro de los equipos instalados del producto SAFE ENTRY',
  'Activo',
  'lemero',
  SYSDATE,
  'lemero',
  SYSDATE,
  'N',
  'N'
  );

--Tarea para el retiro de las bases de hormigón de la torre SAFE ENTRY, los bolardos y mástiles
INSERT
INTO DB_SOPORTE.ADMI_PROCESO
  (
    ID_PROCESO,
    NOMBRE_PROCESO,
    DESCRIPCION_PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION ,
    USR_ULT_MOD,
    FE_ULT_MOD,
    VISIBLE,
    PLANMANTENIMIENTO
  )
  VALUES
  (
  DB_SOPORTE.SEQ_ADMI_PROCESO.NEXTVAL,
  'TAREAS DE OBRAS CIVILES - RETIRO DE BASES',
  'Tarea de retiro de las bases de hormigón de la torre SAFE ENTRY, los bolardos y mástiles a Obras Civiles',
  'Activo',
  'lemero',
  SYSDATE,
  'lemero',
  SYSDATE,
  'SI',
  'N'
  );
INSERT
INTO DB_SOPORTE.ADMI_PROCESO_EMPRESA VALUES
  (
    DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,
    (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_proceso where NOMBRE_PROCESO = 'TAREAS DE OBRAS CIVILES - RETIRO DE BASES' AND ESTADO ='Activo'),
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    ),
    'Activo',
    'lemero',
    SYSDATE
  );
INSERT
INTO DB_SOPORTE.ADMI_TAREA
  (
    ID_TAREA,
    PROCESO_ID,
    NOMBRE_TAREA,
    DESCRIPCION_TAREA,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    REQUIERE_FIBRA,
    VISUALIZAR_MOVIL
  )
  VALUES
  (
  DB_SOPORTE.SEQ_ADMI_TAREA.NEXTVAL,
  (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_proceso where NOMBRE_PROCESO = 'TAREAS DE OBRAS CIVILES - RETIRO DE BASES' AND ESTADO ='Activo'),
  'RETIRO BASES OC',
  'Tarea de retiro de las bases de hormigón de la torre SAFE ENTRY, los bolardos y mástiles a Obras Civiles generada automaticamente',
  'Activo',
  'lemero',
  SYSDATE,
  'lemero',
  SYSDATE,
  'N',
  'N'
  );

--Actualizar la visualizacion de la fibra 
UPDATE DB_SOPORTE.ADMI_TAREA
SET REQUIERE_FIBRA = 'N'
WHERE ID_TAREA  =
  (SELECT ID_TAREA
  FROM DB_SOPORTE.ADMI_TAREA
  WHERE NOMBRE_TAREA = 'SEGUIDAD ELECTRONICA- IMPLEMENTACION SAFE ENTRY'
  );

COMMIT;
/

