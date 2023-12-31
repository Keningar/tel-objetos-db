/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear detalle de parametros de Actividad para planificación HAL de la empresa Ecuanet.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/* SE INSERTA ACTIVIDAD SEGÚN EMPRESA */


--ECUANET
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IT', 'Instalaciones_TN', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IM', 'Instalaciones_MD', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'CO', 'Centros comerciales', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'LE', 'Liberación de edificios', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'AC', 'Arreglo de cajas', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'FI', 'Fiscalizaciones', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'S', 'Soporte', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'I', 'Instalación', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'O', 'Operativa', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'SI', 'Instalación y Soporte', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'RE', 'Retiro Equipo', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IU', 'Inter Urbanas', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IE', 'Instalaciones_EN', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

-- TELCONET
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IE', 'Instalaciones_EN', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '10', NULL, NULL, NULL, NULL, NULL);

--MEGADATOS
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES( DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1087, 'PREFERENCIA CUADRILLA SOPORTE', 'IE', 'Instalaciones_EN', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '18', NULL, NULL, NULL, NULL, NULL);



COMMIT;


/
