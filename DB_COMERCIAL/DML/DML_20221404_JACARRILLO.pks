/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-14-2022  
 * Se crea parametros de configuraciones para transferencia de documentos
 */
SET DEFINE OFF; 

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
    'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA',
    'Parametros definidos para transferencia de documentos en security data',
    'COMERCIAL',
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1'
  );

   
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'DOCUMENTOS_SD',
    'CED,FOT,CEDR',    
    'CED,FOT,CEDR,NBR,RUC',
    'formularioSecurityData,contratoSecurityData',    
    'formularioSecurityData,contratoSecurityData',    
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'documentos a transferir: VALOR1=>CODIGO DOC PARA PERSONA NATURAL, VALOR2=>CODIGO DOC PARA PERSONA JURIDICA, VALOR3=>OTROS DOC PARA PERSONA NATURAL, VALOR4=>OTROS DOC PARA PERSONA JURIDICA'
  );

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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'RESPUESTA_WS_SD',
    'Documento enviado con exito',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'Respuesta exitosa de security data.'
  );
   

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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'ESTADOS_CONTRATO',
    'Activo,PorAutorizar',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'Válida el estado del contrato y adendum de los documentos a ser procesados o enviados a notificar.'
  );
   


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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'DIA_PROCESADO',
    '0',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'filtra el registro por numero dias desde la fecha de ejecucion del ultimo procesamiento, para enviar el reporte al finalizar el dia'
  );
   
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'REPORTE_SEPARADORS_CSV',
    ',',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'Separador para documento csv para el envio a security data.'
  );
  
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'WS_NOMBRE_USUARIO',
    'S3curity',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'Nombre usuario web service.'
  );


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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'ESTADOS_PROCESO',
    'Procesado',
    'S',
    'No procesado',
    'N',   
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'info para indexar el estado que adquiere un proceso despu&eacute;s de ser procesado; VALOR1=>PROCESADO CORRECTAMENTE, VALOR2=> PREFIJO DE ESTADO PROCESADO CORRECTAMENTE, VALOR3=>FALLO AL EJECUTAR PROCESO, VALOR4=>PREFIJO DEL ESTADO FALLIDO'
  );


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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'TIPO_PERSONA',
    'PERSONA NATURAL',
    'PN',
    'PERSONA JURIDICA',
    'RL',   
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'info para indexar el estado que adquiere un proceso después de ser procesado; VALOR1=>NOMBRE TIPO PERSONA , VALOR2=> PREFIJO TIPO PERSONA, VALOR3=>NOMBRE TIPO PERSONA , VALOR4=>PREFIJO TIPO PERSONA'
  );
 


--PARAMETROS PARA ENVIO DE CORREO ELECTRONICO

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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_FALLO_GENERAL',
    'HA OCURRIDO UN FALLO GENERAL EN EL PROCESO DE EJECUCIÓN AUTOMÁTICO DE TRANSFERENCIA DE ARCHIVOS A SD',
    'PR-COM-FALLO',
    'sistemas@telconet.ec',
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'info para envio de correo notificando una fallo general a sistemas; VALOR1=>ASUNTO, VALOR2=> CODIGO_PLANTILLA, VALOR3=>DESTINATARIOS, VALOR4=>COPIADOS'
  );
    
 
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_DOC_PROCESADOS',
    'REGISTROS PROCESADOS CON SECURITY DATA',
    'PR-COM-DOC-PROC',
    'informaticos@netlife.net.ec,smurillo@netlife.net.ec,dronquillo@netlife.net.ec,ppaz@netlife.net.ec,lmonte@netlife.net.ec,ljacho@netlife.net.ec',
    'lenin.vasquez@securitydata.net.ec',
    'documentos_procesados.csv',   
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'info para envio de correo documentos procesados; VALOR1=>ASUNTO, VALOR2=> CODIGO_PLANTILLA, VALOR3=>DESTINATARIOS, VALOR4=>COPIADOS, VALOR5=>NOMBRE_DOCUMENTO'
  );



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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_DOC_FALLIDOS',
    'PROBLEMAS DE CONSUMO DE WEB SERVICE NO EXITOSO CON SECURITY DATA',
    'PR-COM-DOC-FALL',
    'incidentes@securitydata.net.ec',
    'informaticos@netlife.net.ec',
     NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'info para envio de correo documentos no procesados; VALOR1=>ASUNTO, VALOR2=> CODIGO_PLANTILLA, VALOR3=>DESTINATARIOS, VALOR4=>COPIADOS'
  );


--CREACION DE PLANTILLA PARA ENVIO DE CORREO ELECTRONICO 

--PLANTILLA DOCUMENTOS FALLO EN PROCESO
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (
ID_PLANTILLA,
NOMBRE_PLANTILLA,
CODIGO,
MODULO,
PLANTILLA,
ESTADO,
FE_CREACION,
USR_CREACION,
FE_ULT_MOD,
USR_ULT_MOD,
EMPRESA_COD
) VALUES(
DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL, 
'FALLO EN EL PROCESO DE EJECUCION BATCH',
'PR-COM-FALLO', 
'COMERCIAL',
 TO_CLOB('<html>

<head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>

<body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
        <tr>
            <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                <img alt="" src="http://images.telconet.net/others/telcos/logo.png" />
            </td>
        </tr>
        <tr>
            <td style="border:1px solid #6699CC;">
                <table width="100%" cellspacing="0" cellpadding="5">
                    <tr>
                        <td colspan="2">Estimados,</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Se ha producido un fallo en el proceso automatico de transferencia de documentos a Security Data porfavor contactese con sistemas.
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>Fallo:</strong>
                        </td>
                        <td>
                            {{fallo}}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><br /></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td><strong>
                    <font size="2" face="Tahoma">Telcos + Sistema del Grupo Telconet</font>
                </strong></p>
            </td>
        </tr>
    </table>
</body>

</html>'), 
'Activo',
TIMESTAMP'2021-04-22 12:27:06',
'jacarrillo',
'2021-04-22 12:27:06',
'jacarrillo',
NULL); 


--PLANTILLA DOCUMENTOS PROCESADOS
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (
ID_PLANTILLA,
NOMBRE_PLANTILLA,
CODIGO,
MODULO,
PLANTILLA,
ESTADO,
FE_CREACION,
USR_CREACION,
FE_ULT_MOD,
USR_ULT_MOD,
EMPRESA_COD
) VALUES(
DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL, 
'DOCUMENTOS PROCESADOS EN TRANSFERENCIA SD',
'PR-COM-DOC-PROC', 
'COMERCIAL',
 TO_CLOB('<html>
<head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
        <tr>
            <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                <img alt="" src="http://images.telconet.net/others/telcos/logo.png" />
            </td>
        </tr>
        <tr>
            <td style="border:1px solid #6699CC;">
                <table width="100%" cellspacing="0" cellpadding="5">
                    <tr>
                        <td colspan="2">Estimados,</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Se env&iacute;a reporte de registros procesados con Security Data.
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>PROCESADOS:</strong>
                        </td>
                        <td>
                            {{totalProcesados}}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>NO PROCESADOS:</strong>
                        </td>
                        <td>
                            {{totalNoProcesados}}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><br /></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td><strong>
                    <font size="2" face="Tahoma">Telcos + Sistema del Grupo Telconet</font>
                </strong></p>
            </td>
        </tr>
    </table>
</body>
</html>'), 
'Activo',
TIMESTAMP'2021-04-22 12:27:06',
'jacarrillo',
'2021-04-22 12:27:06',
'jacarrillo',
NULL); 

--PLANTILLA DOCUMENTOS FALLIDOS
INSERT INTO DB_COMUNICACION.ADMI_PLANTILLA (
ID_PLANTILLA,
NOMBRE_PLANTILLA,
CODIGO,
MODULO,
PLANTILLA,
ESTADO,
FE_CREACION,
USR_CREACION,
FE_ULT_MOD,
USR_ULT_MOD,
EMPRESA_COD
) VALUES(
DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL, 
'DOCUMENTOS FALLIDOS EN TRANSFERENCIA SD',
'PR-COM-DOC-FALL', 
'COMERCIAL',
 TO_CLOB('<html>

<head>
    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>

<body>
    <table align="center" width="100%" cellspacing="0" cellpadding="5">
        <tr>
            <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                <img alt="" src="http://images.telconet.net/others/telcos/logo.png" />
            </td>
        </tr>
        <tr>
            <td style="border:1px solid #6699CC;">
                <table width="100%" cellspacing="0" cellpadding="5">
                    <tr>
                        <td colspan="2">Estimados,</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Se ha producido un incidente Nivel 2 en el proceso de transferencia de archivos con web service de Security Data.
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>Nombres de contacto:</strong>
                        </td>
                        <td>
                            Ing. Lenin V&aacute;squez, MSc.
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>Correo del contacto:</strong>
                        </td>
                        <td>
                            lenin.vasquez@securitdata.net.ec y soporten3@securitydata.net.ec
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>Descripci&oacute;n del incidente:</strong>
                        </td>
                        <td>
                            {{fallo}}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><br /></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td><strong>
                    <font size="2" face="Tahoma">Telcos + Sistema del Grupo Telconet</font>
                </strong></p>
            </td>
        </tr>
    </table>
</body>

</html>'), 
'Activo',
TIMESTAMP'2021-04-22 12:27:06',
'jacarrillo',
'2021-04-22 12:27:06',
'jacarrillo',
NULL); 

COMMIT; 
/


