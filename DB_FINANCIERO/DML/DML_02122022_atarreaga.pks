/** 
 * @author Alex Arreaga <atarreaga@telconet.ec>
 * @version 1.0 
 * @since 02-12-2022
 * Se crea DML de configuraciones para validaciones a clientes.
 */
 
--Parámetros para flujo de Cliente validaciones
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'PARAM_CLIENTE_VALIDACIONES',
    'Parámetro para flujo de validaciones para cliente',
    'FINANCIERO',
    '',
    'Activo',
    'atarreaga',
    SYSDATE,
    '127.0.0.1',
    'atarreaga',
    SYSDATE,
    NULL
  );  
 
--Megadatos
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET 
SET PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'),
    VALOR7 = 'PUNTO_ADICIONAL'
WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS')
AND usr_creacion NOT IN ('jacarrillo') AND EMPRESA_COD = '18'; 

--Ecuanet
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET 
SET PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'),
    VALOR7 = 'PUNTO_ADICIONAL'
WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS')
AND descripcion not in ('TIPO_DOCUMENTO_DEFECTO', 'FORMA_PAGO_SOPORTE_BANCARIO') AND EMPRESA_COD = '33'; 


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_PROD_ADICIONAL', 'S', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   
    
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALOR_DEUDA', '8', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Valor de deuda de contratación para producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_FACT_VENCIDAS', '1', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Cantidad facturas para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Activo', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Factible', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'PrePlanificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Planificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Detenido', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Replanificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'AsignadoTarea', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Asignada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_CONTRATO', 'Activo', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Estado de contrato para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 
        
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FAC', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Tipo documento factura para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FACP', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Tipo documento factura para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_VALIDACION_PROD_ADICIONAL', 'No cumple evaluación para contratación de producto adicional.', 'Deuda cliente: $SALDO', 'Cant. facturas vencidas: CANTFAC', NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Mensaje de validación para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_SERVICIO_INTERNET', 'El servicio de internet dedicado del login debe estar [ESTADO_SERV] para continuar.', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Mensaje de validación para servicio internet dedicado; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_CONTRATO', 'El estado de contrato del cliente debe estar [ESTADO_CONTRATO] para continuar.', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Mensaje de validación para contrato; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_CAMBIO_PLAN_UPGRADE', 'S', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   
    
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALOR_DEUDA', '8', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Valor de deuda de contratación para cambio de plan; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_FACT_VENCIDAS', '1', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Cantidad facturas para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FAC', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Tipo documento factura para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FACP', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Tipo documento factura para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_VALIDACION_CAMBIO_PLAN_UPGRADE', 'No cumple evaluación para contratación cambio de plan upgrade.', 'Deuda cliente: $SALDO', 'Cant. facturas vencidas: CANTFAC', NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Mensaje de validación para contratación de cambio de plan; VALO7: Tipo de proceso a validar');  





--perfil que omiten validacion saldo
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Calidad',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Facturacion',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
   
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_IPCC',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       
   

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Ip_Contact_Center',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Jefe_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Jefe_IPCC',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Bancario',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Jr',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Sr',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Abogado_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

--fin perfil

--Parametros Ecuanet.

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_PROD_ADICIONAL', 'N', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   
    
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALOR_DEUDA', '8', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Valor de deuda de contratación para producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_FACT_VENCIDAS', '1', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Cantidad facturas para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Activo', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

--estados de servicios 
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Factible', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'PrePlanificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Planificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Detenido', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Replanificada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'AsignadoTarea', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_SERVICIO', 'Asignada', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de servicio internet para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_CONTRATO', 'Activo', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Estado de contrato para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 
        
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FAC', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Tipo documento factura para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FACP', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Tipo documento factura para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_VALIDACION_PROD_ADICIONAL', 'No cumple evaluación para contratación de producto adicional.', 'Deuda cliente: $SALDO', 'Cant. facturas vencidas: CANTFAC', NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Mensaje de validación para contratación de producto adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_SERVICIO_INTERNET', 'El servicio de internet dedicado del login debe estar [ESTADO_SERV] para continuar.', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Mensaje de validación para servicio internet dedicado; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_CONTRATO', 'El estado de contrato del cliente debe estar [ESTADO_CONTRATO] para continuar.', NULL, NULL, NULL, NULL,
    NULL, 'PRODUCTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Mensaje de validación para contrato; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_CAMBIO_PLAN_UPGRADE', 'N', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   
    
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALOR_DEUDA', '8', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Valor de deuda de contratación para cambio de plan; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_FACT_VENCIDAS', '1', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Cantidad facturas para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FAC', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Tipo documento factura para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_DOCUMENTO', 'FACP', NULL, NULL, NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Tipo documento factura para contratación de cambio de plan adicional; VALO7: Tipo de proceso a validar'); 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'MSJ_VALIDACION_CAMBIO_PLAN_UPGRADE', 'No cumple evaluación para contratación cambio de plan upgrade.', 'Deuda cliente: $SALDO', 'Cant. facturas vencidas: CANTFAC', NULL, NULL,
    NULL, 'CAMBIO_PLAN_UP', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Mensaje de validación para contratación de cambio de plan; VALO7: Tipo de proceso a validar');  





--perfil que omiten validacion saldo
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Calidad',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_Facturacion',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar'); 
   
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Coordinador_IPCC',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       
   

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Ip_Contact_Center',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Jefe_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Jefe_IPCC',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Bancario',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Jr',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');
     
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Asistente_Cobranzas_Sr',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'PERFIL',
    'Md_Abogado_Cobranzas',  
     NULL, NULL, NULL, NULL, NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: Nombre de perfil; VALO7: Tipo de proceso a validar');       

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_PERFIL', 'S', NULL, NULL, NULL, NULL,
    NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '18', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   
   

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    VALOR6,
    VALOR7,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
      AND ESTADO             = 'Activo'
    ),
    'VALIDACION_PERFIL', 'S', NULL, NULL, NULL, NULL,
    NULL, 'PUNTO_ADICIONAL', 'Activo', 'atarreaga', SYSDATE, '127.0.0.1', '33', 'VALOR1: S=> habilitado, N=> deshabilitado; VALO7: Tipo de proceso a validar');   

COMMIT;
/
