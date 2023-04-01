/**
 *
 * Nuevos parámetros para empresa ecuanet
 *
 * @author Alex Gómez <algomez@telconet.ec>
 * @version 1.0 23-02-2023 
 *
 * Parametros ecuanet
 **/

INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1482,
    'NATURAL',
    'FOT,CED,CEDR',
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'VALOR1=[CODIGOS TIPO DOCUMENTOS]',
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1482,
    'JURIDICA',
    'FOT,CED,CEDR,NBR,RUC',
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'VALOR1=[CODIGOS TIPO DOCUMENTOS]',
    NULL,
    NULL
  );



----------------------

INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'BANDERA_NUEVO_CONSUMO_WS',
    'S',
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'PARAMSQUERY_NEW',
    'M3gadato5',
    'http://172.24.25.213:8080/CertificadoElectronicoClienteMegadatos_V1/webresources/usuario_pn/emision_pn',
    'p12',
    '/archivo_cert',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '172.24.25.171',
    '33',
    'archivo_cert',
    'rch#PFX2015',
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'PARAMSQUERYJUR_NEW',
    'M3gadato5',
    'http://172.24.25.213:8080/CertificadoElectronicoClienteMegadatos_V1/webresources/usuario_rl/emision_rl',
    'p12',
    '/archivo_cert',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '172.24.25.171',
    '33',
    'archivo_cert',
    'rch#PFX2015',
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'MEDIO_DESCARGA_CERTIFICADO',
    'SFTP_WS',
    'SECURITYDATA_SERVER_DESCARGA',
    'SECURITYDATA_SERVER_SUBIDA',
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'VALOR1: SFTP_DIRECTO o SFTP_WS, para la descarga del certificado con conexión directa desde Telcos o por medio del web service sftp. VALOR2: Nombre del servidor remoto configurado en tabla ADMI_CONFIGURACION',
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'OPERACION_SUBIDA_DOCUMENTOS',
    'sftpupload',
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'RUTA_SUBIDA_DOCUMENTOS',
    '/archivo_pfx/documentacion_sd/',
    '/archivo_pfx/documentacion_sd/',
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    null,
    null,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'PARAMSQUERYJUR',
    'M3gadato5',
    'http://172.24.25.213:8080/CertificadoElectronicoClienteMegadatos/webresources/usuario_rl/emision_rl',
    'p12',
    '/sftp/rlegal/archivo_cert',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '172.24.25.213',
    '33',
    'archivo_cert',
    'T3ll320**20Sd',
    NULL,
    NULL,
    NULL
  );
INSERT
INTO db_general.admi_parametro_det
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1185,
    'PARAMSQUERY',
    'M3gadato5',
    'http://172.24.25.213:8080/CertificadoElectronicoClienteMegadatos/webresources/usuario_pn/emision_pn',
    'p12',
    '/sftp/pnatural/archivo_cert',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '172.24.25.213',
    '33',
    'archivo_cert',
    'T3ll320**20Sd',
    NULL,
    NULL,
    NULL
  );





-------------------------
UPDATE
	DB_GENERAL.ADMI_PARAMETRO_DET
SET
	USR_ULT_MOD = 'algomez',
	FE_ULT_MOD = SYSDATE ,
	VALOR5 = '1000',
	VALOR6 = 'COMPOSE_MESSAGE',
	VALOR7 = 'CONDIG-PIN',
	OBSERVACION = 'En valor2 debe configurarse el nombre del proveedor de envío de sms (INFOBIP o MASSEND). valor3: Habilitar envio por Whatsapp(S,N),valor4: Prioridad envio Whatsapp(S,N)(opcional). valor5:apiSMS-IdMessage. valor6:apiSMS - SIMPLE_MESSAGE O COMPOSE_MESSAGE, valor7:apiSMS: codProcess'
WHERE
	ID_PARAMETRO_DET = 9791;

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1067,
    'ENVIO_POR_SMS',
    'SMS',
    'MASSEND',
    'N',
    'N',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    null,
    null,
    '172.24.15.76',
    '1002',
    '33',
    'COMPOSE_MESSAGE',
    'CONDIG-PIN',
    'En valor2 debe configurarse el nombre del proveedor de envío de sms (INFOBIP o MASSEND). valor3: Habilitar envio por Whatsapp(S,N),valor4: Prioridad envio Whatsapp(S,N)(opcional)',
    NULL,
    NULL
  );
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,1067,
    'ENVIO_POR_MAIL',
    'MAIL',
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'null',
    NULL,
    NULL
  );

------------------------------------
INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1798,
'TIEMPO DE VIGENCIA MIN',
'30',
'LINK_BANCARIO',
NULL,
NULL,
'Activo',
'algomez',
sysdate,
'127.0.0.1',
NULL,
NULL,
NULL,
NULL,
'33',
NULL,
NULL,
NULL,
NULL,
NULL);


INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1798,
'MOSTRAR CLAUSULA',
'S',
'CLAUSULA_CONTRATO',
NULL,
NULL,
'Activo',
'algomez',
sysdate,
'127.0.0.1',
NULL,
NULL,
NULL,
NULL,
'33',
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1798,
'MOSTRAR DATOS BANCARIO',
'S',
'LINK_BANCARIO',
NULL,
NULL,
'Activo',
'algomez',
sysdate,
'127.0.0.1',
NULL,
NULL,
NULL,
NULL,
'33',
NULL,
NULL,
NULL,
NULL,
NULL);

------------------------

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1024,
'CERTIFICADO_SD',
'1792261848001',
'1',
'2',
'27/04/2021',
'Activo',
'algomez',
sysdate,
'127.0.0.0',
NULL,
NULL,
NULL,
'certificadosEmpresa',
'33',
NULL,
NULL,
NULL,
NULL,
NULL);

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1024,
'CERTIFICADO_MD',
'1791287541001',
'1',
'2',
'27/04/2021',
'Activo',
'algomez',
sysdate,
'127.0.0.0',
NULL,
NULL,
NULL,
'certificadosEmpresa',
'33',
NULL,
NULL,
NULL,
NULL,
NULL);

--------------------------
INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1835,
'PRODUCTO_NO_APLICA_ADENDUM',
'VOZ',
NULL,
NULL,
NULL,
'Activo',
'algomez',
sysdate,
'127.0.0.1',
NULL,
NULL,
NULL,
NULL,
'33',
NULL,
NULL,
NULL,
NULL,
NULL);


--------------------------------------


INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(db_general.seq_admi_parametro_det.nextval,
1743,
'CONTRATO_DIGITAL',
'10',
'1.33333',
NULL,
NULL,
'Activo',
'algomez',
sysdate,
'0.0.0.0',
NULL,
NULL,
NULL,
NULL,
'33',
NULL,
NULL,
NULL,
NULL,
NULL);


-------NUEVOS PARAMETROS ------------
INSERT
INTO db_general.admi_parametro_cab
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
    db_general.seq_admi_parametro_cab.nextval,
    'DOCUMENTOS_CONTRATO_EMPRESA',
    'Define los documentos desde el ms de contrato según la empresa',
    'COMERCIAL',
    'CONTRATO_DIGITAL',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL
  );


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoSecurityData', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'formularioSecurityData', --cod documento
    'OTR', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoMegadatos', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'adendumMegaDatos', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    'FO-VEN-01',
    'ver-08 | Dic-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'terminosCondicionesMegadatos', --cod documento
    'TCSP', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    'FO-VEN-01',
    'ver-07 | Ene-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
 
----ecuanet
 
 
 INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoSecurityData', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '33',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'formularioSecurityData', --cod documento
    'OTR', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '33',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoEcuanet', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'adendumEcuanet', --cod documento
    'CONT', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    'FO-VEN-01',
    'ver-08 | Dic-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'terminosCondicionesEcuanet', --cod documento
    'TCSP', --codigo tipo documento
    'DIGITAL', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    'FO-VEN-01',
    'ver-07 | Ene-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOC_CONTRATO_ADHESION',
    'Contrato de adhesión', --cod documento
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'Nombre del documento contrato de adhesion por empresa. Usado en la app movil , app angular,telcos',
    NULL,
    NULL
  );

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOC_CONTRATO_ADHESION',
    'Contrato de adhesión', --cod documento
    NULL,
    NULL,
    NULL,
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'Nombre del documento contrato de adhesion por empresa. Usado en la app movil , app angular,telcos',
    NULL,
    NULL
  );
 
 
 -------crs megadatos
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_CRS_MS_CONTRATO',
    'contratoSecurityData', --cod documento
    'CONT', --codigo tipo documento
    'GENERAL', --aplica por punto o GENERAL
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):GENERAL,POR PUNTO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_CRS_MS_CONTRATO',
    'formularioSecurityData', --cod documento
    'OTR', --codigo tipo documento
    'GENERAL', --aplica por punto o GENERAL
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):GENERAL,POR PUNTO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_CRS_MS_CONTRATO',
    'contratoMegadatos', --cod documento
    'CONT', --codigo tipo documento
    'POR PUNTO', --aplica por punto o GENERAL
    'C,AP,AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):GENERAL,POR PUNTO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
  
-------contrato físico
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoEcuanet', --cod documento
    'CONT', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'adendumEcuanet', --cod documento
    'CONT', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    'FO-VEN-01',
    'ver-08 | Dic-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'terminosCondicionesEcuanet', --cod documento
    'TCSP', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '33',
    'FO-VEN-01',
    'ver-07 | Ene-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );

-----------------------

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'contratoMegadatos', --cod documento
    'CONT', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    NULL,
    NULL,
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'adendumMegaDatos', --cod documento
    'CONT', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'AS', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    'FO-VEN-01',
    'ver-08 | Dic-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'DOCUMENTOS_CONTRATO_EMPRESA'),
    'DOCS_MS_CONTRATO',
    'terminosCondicionesMegadatos', --cod documento
    'TCSP', --codigo tipo documento
    'FISICO', --tipo contrato : DIGITAL - FISICO
    'C,AP', --tipo proceso: C:Nuevo contrato ; AS:Adendum de Servicio
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'MD', --define certificado a utilizar: SD, MD
    '18',
    'FO-VEN-01',
    'ver-07 | Ene-2021',
    'valor3(tipo contrato):DIGITAL,FISICO; valor4(tipo proceso):C-nuevo contrato, AS-Adendum de servicio, AP-Adendum de punto, TODOS; valor5: SD, MD',
    NULL,
    NULL
  );

-----------------parametros de aprobación contrato

INSERT
INTO db_general.admi_parametro_cab
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
    db_general.seq_admi_parametro_cab.nextval,
    'APROBACION_CONTRATO_COMMAND',
    'Define parametros para proceso de aprobación por crontab',
    'COMERCIAL',
    'CONTRATO',
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL
  );
  
 
 INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'APROBACION_CONTRATO_COMMAND'),
    'PREFIJOS_EMPRESA',
    'MD,EN', 
    NULL, 
    NULL, 
    NULL, 
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'Prefijos de empresas para consulta de contratos en crontab',
    NULL,
    NULL
  );
  
 INSERT
 INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'APROBACION_CONTRATO_COMMAND'),
    'OBSERVACION_HISTORIAL_APROBACION',
    'Se aprueba contrato desde proceso automático', 
    NULL, 
    NULL, 
    NULL, 
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL, 
    '18',
    NULL,
    NULL,
    'Mensaje para historial por aprobación de contrato',
    NULL,
    NULL
  ); 
 
 
 INSERT
 INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD,
    VALOR6,
    VALOR7,
    OBSERVACION,
    VALOR8,
    VALOR9
  )
  VALUES
  (
    db_general.seq_admi_parametro_det.nextval,
    (select s.id_parametro from db_general.admi_parametro_cab s where s.nombre_parametro = 'APROBACION_CONTRATO_COMMAND'),
    'OBSERVACION_HISTORIAL_APROBACION',
    'Se aprueba contrato desde proceso automático', 
    NULL, 
    NULL, 
    NULL, 
    'Activo',
    'algomez',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL, 
    '33',
    NULL,
    NULL,
    'Mensaje para historial por aprobación de contrato',
    NULL,
    NULL
  ); 

commit;

/



declare

  cursor c_valida_empresa_rol(cv_rol varchar2, cv_empresaCod varchar2) is
    SELECT ier2.id_empresa_rol
      FROM DB_COMERCIAL.INFO_EMPRESA_ROL ier2
     WHERE ier2.empresa_cod = cv_empresaCod
       AND ier2.rol_id = ((SELECT ID_ROL
                             FROM DB_GENERAL.ADMI_ROL
                            WHERE DESCRIPCION_ROL = cv_rol));

  lc_empresa_rol c_valida_empresa_rol%rowtype;
  lb_valida      boolean;

begin

  OPEN c_valida_empresa_rol('blanca', 33);
  fetch c_valida_empresa_rol
    into lc_empresa_rol;
  lb_valida := c_valida_empresa_rol%notfound;
  close c_valida_empresa_rol;

  if lb_valida then
    INSERT INTO DB_COMERCIAL.INFO_EMPRESA_ROL
      (id_empresa_rol,
       empresa_cod,
       rol_id,
       estado,
       usr_creacion,
       fe_creacion,
       ip_creacion)
    VALUES
      (DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
       33,
       (SELECT ID_ROL
          FROM DB_GENERAL.ADMI_ROL
         WHERE DESCRIPCION_ROL = 'blanca'),
       'Activo',
       'algomez',
       sysdate,
       '127.0.0.1');
       
       dbms_output.put_line('La empresa rol -blanca- insertado');
  else
    dbms_output.put_line('La empresa rol -blanca- ya existe con el id: ' ||
                         lc_empresa_rol.id_empresa_rol);
  end if;

  OPEN c_valida_empresa_rol('negra', '33');
  fetch c_valida_empresa_rol
    into lc_empresa_rol;
  lb_valida := c_valida_empresa_rol%notfound;
  close c_valida_empresa_rol;

  if lb_valida then
    --
    INSERT INTO DB_COMERCIAL.INFO_EMPRESA_ROL
      (id_empresa_rol,
       empresa_cod,
       rol_id,
       estado,
       usr_creacion,
       fe_creacion,
       ip_creacion)
    VALUES
      (DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
       33,
       (SELECT ID_ROL
          FROM DB_GENERAL.ADMI_ROL
         WHERE DESCRIPCION_ROL = 'negra'),
       'Activo',
       'algomez',
       sysdate,
       '127.0.0.1');
       
       dbms_output.put_line('La empresa rol -negra- insertado');
  
  else
    dbms_output.put_line('La empresa rol -negra-  ya existe con el id: ' ||
                         lc_empresa_rol.id_empresa_rol);
  
  end if;

  commit;

exception
  when others then
    rollback;
    dbms_output.put_line('Error general: ' || sqlerrm);
  
end;

/
