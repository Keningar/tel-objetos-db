/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear detalle de parametros para flujo de Rechazar orden de trabajo y anulacion para internet con empresa Ecuanet.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 02-03-2023 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(
  ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7,
  ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD, OBSERVACION
)
VALUES
(
  db_general.seq_admi_parametro_det.nextval,
  (
    SELECT id_parametro FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	WHERE NOMBRE_PARAMETRO = 'PROMOCION ANCHO BANDA'
  ),
  'Datos para webservices de detener promocion', 'PROM_BW', 'VALIDAR_PROMOCIONES', 'DETENER_PROMOCIONES', null, null, null, null,
  'Activo', 'emartillo', SYSDATE, '127.0.0.1', '33', 'valor1 = Codigo del tipo de promocion, valor2 = opcion valida promocion, valor3 = Opcion detiene promocion'
);



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(
  ID_PARAMETRO_DET, PARAMETRO_ID, DESCRIPCION, VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7,
  ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD, OBSERVACION
)
VALUES
(
  db_general.seq_admi_parametro_det.nextval,
  (
    SELECT id_parametro FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	  WHERE NOMBRE_PARAMETRO = 'PROMOCION ANCHO BANDA'
    AND ESTADO = 'Activo'
  ),
  'Estados permitidos para anular la promocion', 'PROM_BW', 'Programado', 'Anulado', null, null, null, null,
  'Activo', 'emartillo', SYSDATE, '127.0.0.1', '33',
  'Valor1 = Codigo del tipo de promocion, Valor2 = Estado permitido, Valor3 = Estado que tomara'
);

COMMIT;
/