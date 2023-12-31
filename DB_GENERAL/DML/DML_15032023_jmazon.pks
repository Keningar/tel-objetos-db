/**
 *
 * Se crean Parametros para la empresa ECUANET con el flujo de Cancelacion y PreCancelacion.
 *	 
 * @author Jonathan Mazon <jmazon@telconet.ec>
 * @version 1.0 15-03-2023
 */

--FLUJO ACTA DE CANCELACIÓN
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'codigoPlantillaCancelacionProdAdicional', 'actaCancelacionProdAdicionalEn', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'ActivarActaCancelacionProdAdicional', 'S', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'codigoPlantillaCancelacion', 'actaPreCancelacionEn', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'estadoFlujoCancelacion', 'Activo', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'estadosEquiposCancelacion', 'Bueno|Dañado|No entrega', 'PreCancelacion', 'INTERNET', 'N/A', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'MensajeCancelacion', 'se ha iniciado la tarea de precancelacion de servicio correctamente', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'NombreTarea', 'Cancelar contrato', 'PreCancelacion', 'PROCESOS TAREAS ATC', 'N', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'lyambay', '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'OrigenTarea', 'WEB-TN', 'PreCancelacion', 'empleado', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'OrigenComunicacionTarea', 'Interno', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'ClaseTarea', 'Requerimientos de Clientes', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'PuntoTarea', 'COLONCORP', 'PreCancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'equiposFacturacion', 'RETIRO_EQUIPOS_SOPORTE', 'PreCancelacion', 'FACTURACION_RETIRO_EQUIPOS', 'FINANCIERO', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'TareaCancelacion', 'DESCRIPCION TAREA', 'PreCancelacion', 'Se finaliza por tarea de solicitud de cancelacion creada', 'Tarea fue Finalizada Obs : Se finaliza por tarea de solicitud de cancelacion creada', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, '225', '33', 'ECUANET – SOLICITUD DE PRECANCELACION DE SERVICIO', 'T', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'MensajesPredeterminados', '+ iva', 'PreCancelacion', 'CLIENTE SE ACERCA A CANCELAR EL SERVICIO POR MOTIVO', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'codigoPlantillaCancelacion', 'actaCancelacionEn', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'ActivarActaCancelacion', 'S', 'Cancelacion', 'INTERNET', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'estadoFlujoCancelacion', 'Activo', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'estadosEquiposCancelacion', 'Bueno|Dañado|No entrega', 'Cancelacion', 'INTERNET', 'N/A', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'MensajeCancelacion', 'se ha iniciado la tarea de cancelacion de servicio correctamente', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'NombreTarea', 'Cancelar contrato', 'Cancelacion', 'PROCESOS TAREAS ATC', 'S', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'lyambay', '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'OrigenTarea', 'WEB-TN', 'Cancelacion', 'empleado', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'OrigenComunicacionTarea', 'Interno', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'ClaseTarea', 'Requerimientos de Clientes', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'PuntoTarea', 'COLONCORP', 'Cancelacion', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'equiposFacturacion', 'RETIRO_EQUIPOS_SOPORTE', 'Cancelacion', 'FACTURACION_RETIRO_EQUIPOS', 'FINANCIERO', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'TareaCancelacion', 'DESCRIPCION TAREA', 'Cancelacion', 'Se finaliza por tarea de solicitud de cancelacion creada', 'Tarea fue Finalizada Obs : Se finaliza por tarea de solicitud de cancelacion creada', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, '225', '33', 'ECUANET - CANCELACION DE SERVICIO', 'T', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 1695, 'MensajesPredeterminados', '+ iva', 'Cancelacion', 'CLIENTE SE ACERCA A CANCELAR EL SERVICIO POR MOTIVO', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

--RETIRO_EQUIPOS_SOPORTE

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'CAMARA EZVIZ CS-C2C-A0-1E2WF', NULL, '45', '1950', 'VISEG', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '45', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'CAMARA EZVIZ CS-C3N-A0-3G2WFL1', NULL, '75', '1949', 'NLCO', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '75', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'TARJETA MICRO SD 32 GB KINGSTON', NULL, '6', '1618', 'NLCO', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '6', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'CS-C1C-D0-1D1WFR', NULL, '45', '1616', 'VISEG', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '45', '78', NULL, 'EQUIPO', NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'CS-CV206(MINI-O)', NULL, '35', '1617', 'VISEG', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '35', '78', NULL, 'EQUIPO', NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'MICRO SD 32GB KINGSTON', NULL, '6', '1618', 'VISEG', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '6', '78', NULL, 'EQ_ADICIONAL', NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'CPE ADSL', 'ADSL', '30', '1225', NULL, 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '30', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'FUENTE DE PODER', 'ADSL', '10', '1222', 'D', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '10', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'FUENTE DE PODER AP CISCO', 'CISCO', '90', '1226', 'D', 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '90', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'SMARTWIFI', 'CISCO', '300', '1227', NULL, 'Inactivo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '300', NULL, NULL, NULL, NULL);

--zte
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'ZXHN H196A V9', 'ZTE', '75', '2017', NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, '172.17.0.1', 'N', '33', '75', '1232', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'CPE ONT', 'ZTE', '85', '1781', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '85', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'ROSETA', 'ZTE', '10', '1224', 'D', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '10', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'FUENTE DE PODER', 'ZTE', '10', '1222', 'D', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '10', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

---huawey
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'WA8M8011VW09', 'HUAWEI', '75', '2018', NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, '172.17.0.1', 'N', '33', '75', '1232', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,  847, 'WA8011V', 'HUAWEI', '75', '2019', NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, '172.17.0.1', 'N', '33', '75', '1232', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'WIFI DUAL BAND', 'HUAWEI', '175', '1374', NULL, 'Inactivo', 'jmazon', SYSDATE, '172.0.0.1', NULL, NULL, NULL, 'S', '33', '175', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'EXTENDER DUAL BAND', 'HUAWEI', '75', '1375', NULL, 'Inactivo', 'jmazon', SYSDATE, '172.0.0.1', NULL, NULL, NULL, 'S', '33', '75', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'CPE', 'HUAWEI', '125', '1223', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'N', '33', '125', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'CPE ONT', 'HUAWEI', '125', '1223', NULL, 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '125', NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'ROSETA', 'HUAWEI', '10', '1224', 'D', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '10', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 847, 'FUENTE DE PODER', 'HUAWEI', '10', '1222', 'D', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', '33', '10', 'EQUIPOS DEFAULT DIFERENTE TECNOLOGIA', NULL, NULL, NULL);

--CANCELACION VOLUNTARIA
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 858, 'Tiempo en meses de permanencia mínima del servicio mandatorio Internet ', 'PERMANENCIA MINIMA 36 MESES', '36', '01/05/2019', NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 858, 'Tiempo en meses de permanencia mínima del servicio mandatorio Internet', 'PERMANENCIA MINIMA 24 MESES', '24', '30/04/2019', NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 858, 'Contiene los destinatarios a los que se debe enviar reporte de cancelaciones no facturadas', 'DESTINATARIOS RPT CANCELACION NO FACTURADA', 'sistemas-qa@telconet.ec', NULL, NULL, 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, NULL, NULL, '33', NULL, NULL, NULL, NULL, NULL);


--PROM_PRECIO_INSTALACION
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 857, 'VALOR DE LA INSTALACION DEPENDIENDO DE LA ULTIMA MILLA DEL SERVICIO', 'FO', 'INSTALACION HOME', '100', '50', 'Activo', 'jmazon', SYSDATE, '172.17.0.1', NULL, NULL, '172.0.0.1', NULL, '33', NULL, NULL, 'V3= PRECIO DE INST 100% FO; V4= PRECIO DE INST 50% FO', NULL, NULL);

--FACTURACION_SOLICITUDES
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, USR_ULT_MOD, FE_ULT_MOD, IP_ULT_MOD, VALOR5, EMPRESA_COD, VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9)
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 846, 'Cancelacion voluntaria', 'SOLICITUD CANCELACION VOLUNTARIA', NULL, '1230', 'CANCELACION VOLUNTARIA', 'Activo', 'jmazon', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'telcos_cancel_volun', '33', 'N', NULL, NULL, NULL, NULL);

COMMIT;

/
