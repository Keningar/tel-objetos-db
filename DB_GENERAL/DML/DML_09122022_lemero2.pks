/**
 * Scripts para los parametros que permiten la validacion del producto, las tareas de ingreso y cancelacion
 * elementos permitidos relacionadas al producto SAFE ENTRY
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 09-12-2022
 */


--**************************************
--************ DB GENERAL **************
--**************************************

--Parametro para no mostrar el boton de cancelar deL servicio SAFE ENTRY
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET VALOR1 = VALOR1||',SAFE ENTRY'
WHERE ID_PARAMETRO_DET =
  (SELECT ID_PARAMETRO_DET
  FROM DB_GENERAL.ADMI_PARAMETRO_DET
  WHERE PARAMETRO_ID =
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'NO_VISUALIZAR_BOTON_DE_CANCELAR'
    )
  );
  

--Mapeo de estados para validar las ordenes de servicios requeridas
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'CONFIG SAFE ENTRY', --CONFIG ORDEN SAFE ENTRY
    'Parametros para validar el servicio',
    'COMERCIAL',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );
--Ingreso de la caracteristica ROLES_CONTACTO
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,--Rol para validar el tipo de contacto
    VALOR2, --Correo electronico
    VALOR3, --Telefono
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'CONTACTO_SAFE_ENTRY',
    '["Contacto Tecnico"]',
    'Correo Electronico',
    'Contacto Teléfono Móvil',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de la caracteristica SERVICIOS_ADICIONALES
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,--Servicios requeridos por la descripcion del producto
    VALOR2,--Estados validos para ingresar el servicio SE
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'SERVICIOS_REQUERIDOS',
    '["Internet Small Business","SAFE ENTRY","Cableado Estructurado"]',
    '["Factible","FactibilidadEnProceso","PrePlanificada","Pre-servicio","AsignadoTarea","Asignada","Planificada","Activo"]',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Nombre label
    VALOR2, --Es requerido
    VALOR3, --Id
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'ARCHIVOS_REQUERIDOS',
    'Informes de inspección',
    'N',
    'informes_de_inspeccion',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Nombre label
    VALOR2, --Es requerido
    VALOR3, --Id
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'ARCHIVOS_REQUERIDOS',
    'Correo del cliente',
    'S',
    'correo_del_cliente',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Nombre label
    VALOR2, --Es requerido
    VALOR3, --Id
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'ARCHIVOS_REQUERIDOS',
    'Checklist de seguridad electrónica',
    'N',
    'checklist_seguridad_electronica',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Nombre label
    VALOR2, --Es requerido
    VALOR3, --Id
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'ARCHIVOS_REQUERIDOS',
    'Proforma',
    'S',
    'proforma',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );


--Parametrizacion de las tareas para el producto SAFE ENTRY
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'CONFIG TAREAS SAFE ENTRY',
    'Parametros para configurar las tareas necesarias para el producto SAFE ENTRY',
    'COMERCIAL',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );
--Ingreso de los parametros CONFIG_TAREA_IMPLEMENTACION
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG TAREAS SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'CONFIG_TAREA_IMPLEMENTACION',
    'SEGUIDAD ELECTRONICA- IMPLEMENTACION SAFE ENTRY',
    'Tarea de implementacion SAFE ENTRY generada automaticamente',
    'PLANIFICACION Y LOGISTICA',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros CONFIG_TAREA_ELECTRICO
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG TAREAS SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'CONFIG_TAREA_ELECTRICO',
    'RETIRO DE EQUIPOS SAFE ENTRY',
    'Tarea de retiro de equipos SAFE ENTRY generada automaticamente',
    'ELECTRICO',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros CONFIG_TAREA_OBRAS_CIVILES
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG TAREAS SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'CONFIG_TAREA_OBRAS_CIVILES',
    'RETIRO BASES OC',
    'Tarea  generada automaticamente para el retiro de las bases de hormigón que tiene la torre SAFE ENTRY, los bolardos y mástiles',
    'Obras Civiles',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros CONFIG_TAREA_RETIRO_BODEGGA
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG TAREAS SAFE ENTRY'
    AND MODULO             = 'COMERCIAL'
    AND ESTADO             = 'Activo'
    ),
    'CONFIG_TAREA_RETIRO_BODEGA',
    'Retiro de Material de Bodega',
    'Tarea de retiro de equipos para cambio de equipos SAFE ENTRY generada automaticamente',
    'ELECTRICO',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );  
    
--Configuracion de los elementos de activacion SAFE ENTRY
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'CONFIG ELEMENTOS SAFE ENTRY',
    'Parametros para ingresar los elementos para la activacion del producto SAFE ENTRY',
    'TECNICO',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );  
  
--Ingreso de los parametros del elemento SWITCH
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'Switch',
    '["SWITCH"]',
    'Switch',
    'Switch',
    'S',
    '0',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento CAMARA VISITANTE
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'CAMARA VISITANTE',
    '["CAMARA","CAMARA IP"]',
    'Camaras',
    'CamaraVisitante',
    'S',
    '1',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento CAMARA IDENTIFICACION
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'CAMARA IDENTIFICACION',
    '["CAMARA","CAMARA IP"]',
    'Camaras',
    'CamaraIdentificacion',
    'S',
    '2',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento CAMARA AUTO
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'CAMARA AUTO',
    '["CAMARA","CAMARA IP"]',
    'Camaras',
    'CamaraAuto',
    'S',
    '3',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento CAMARA PLACA
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'CAMARA PLACA',
    '["CAMARA","CAMARA IP"]',
    'Camaras',
    'CamaraPlaca',
    'S',
    '4',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento CAMARA MOTO
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'CAMARA MOTO',
    '["CAMARA","CAMARA IP"]',
    'Camaras',
    'CamaraMoto',
    'S',
    '5',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento RASPBERRY
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'RASPBERRY PI',
    '["RASPBERRY"]',
    'Raspberry',
    'Raspberry',
    'N',
    '6',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento UPS
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'UPS',
    '["UPS"]',
    'Ups',
    'Ups',
    'N',
    '8',
    'N',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
--Ingreso de los parametros del elemento NVR
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1, --Producto
    VALOR2, --Nombre equipo
    VALOR3, --Tipo de equipos validos
    VALOR4, --Agrupacion
    VALOR5, --Id label
    VALOR6, --Muestra mac
    VALOR7, --Index
    VALOR8, --Requiere enlace
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CONFIG ELEMENTOS SAFE ENTRY'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'ELEMENTOS_SAFE_ENTRY',
    'SAFE ENTRY',
    'NVR',
    '["NVR"]',
    'nvr',
    'Nvr',
    'S',
    '7',
    'S',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );

-- INGRESO LOS DETALLES DE LA CABECERA 'VISUALIZAR_PANTALLA_FIBRA'
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
(
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD
)
VALUES
(
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE NOMBRE_PARAMETRO = 'VISUALIZAR_PANTALLA_FIBRA'
            AND ESTADO = 'Activo'
        ),
        'Productos que deben visualizar la pantalla de fibra',
        'SAFE ENTRY',
        'Activo',
        'lemero',
        SYSDATE,
        '127.0.0.1',
        (
            SELECT COD_EMPRESA
            FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
            WHERE PREFIJO = 'TN'
        )
);
-- Validacion para ingresar el UPS como equipo sin MAC
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    '1563',
    'EQUIPO PERMITIDO QUE NO REQUIERE MAC PARA REALIZAR UNA INSTALACION O CAMBIO DE EQUIPO',
    'UPS',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );

  -- Validacion para ingresar el NVR como equipo sin MAC
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    '1563',
    'EQUIPO PERMITIDO QUE NO REQUIERE MAC PARA REALIZAR UNA INSTALACION O CAMBIO DE EQUIPO',
    'NVR',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );

  -- Validacion para ingresar el RASPBERRY como equipo sin MAC
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    '1563',
    'EQUIPO PERMITIDO QUE NO REQUIERE MAC PARA REALIZAR UNA INSTALACION O CAMBIO DE EQUIPO',
    'RASPBERRY',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );
  -- Validacion para ingresar el RASPBERRY como equipo sin MAC
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    '1563',
    'EQUIPO PERMITIDO QUE NO REQUIERE MAC PARA REALIZAR UNA INSTALACION O CAMBIO DE EQUIPO',
    'SWITCH',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );

--Se agrega la caracteristica ELEMENTO_CLIENTE_ID del producto SAFE ENTRY
INSERT INTO DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA VALUES
(
    DB_COMERCIAL.SEQ_ADMI_PRODUCTO_CARAC.NEXTVAL,
    ( SELECT ID_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO
      WHERE NOMBRE_TECNICO = 'SAFE ENTRY' AND ESTADO = 'Activo' ),
    ( SELECT ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = 'ELEMENTO_CLIENTE_ID' AND ESTADO = 'Activo' ),
    SYSDATE,
    NULL,
    'lemero',
    NULL,
    'Activo',
    'NO'
);

COMMIT;
/




  