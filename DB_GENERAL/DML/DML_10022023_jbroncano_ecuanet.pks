INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'COD_FORMA_CONTACTO' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'COD_FORMA_CONTACTO'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';

--------------------------------------CANAL--------------------------------------

INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'CANALES_PUNTO_VENTA' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
         VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CANALES_PUNTO_VENTA'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';

            
  ------------------------EMPRESA_APLICA_PROCESO-------------------------------- 

      INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'EMPRESA_APLICA_PROCESO' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
         VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'EMPRESA_APLICA_PROCESO'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';
-----------------------------------------FRECUENCIA_FACTURACION--------------------        

 INSERT INTO DB_GENERAL.admi_parametro_det 
      VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
       (SELECT
                  id_parametro
              FROM
                  db_general.admi_parametro_cab
              WHERE        
            nombre_parametro = 'FRECUENCIA_FACTURACION'
            AND estado = 'Activo'),
          'MENSUAL',
          '1',
          'Mensual',
          '',
          '',
          'Activo',
          'jbroncano',
          SYSDATE,
          '0.0.0.0',
          null,
          null,
          null,
          null,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          null,
          null,
          null,
          null,
          null);  


          
INSERT INTO DB_GENERAL.admi_parametro_det 
      VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
       (SELECT
                  id_parametro
              FROM
                  db_general.admi_parametro_cab
              WHERE        
            nombre_parametro = 'FRECUENCIA_FACTURACION'
            AND estado = 'Activo'),
          'UNICA',
          '1',
          'UNICA',
          '',
          '',
          'Activo',
          'jbroncano',
          SYSDATE,
          '0.0.0.0',
          null,
          null,
          null,
          null,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          null,
          null,
          'CONTIENE LAS FRECUENCIAS DE FACTURACION PERMITIDAS POR EMPRESA:
    VALOR1: 0 FRECUENCIA O CICLO UNICO
    VALOR2: Unica (DESCRIPCION DEL TIPO DE FRECUENCIA)',
          null,
          null);  

-----------------------------------CONTRATO_FISICO_VALIDACION-----------------------------------------
             INSERT INTO DB_GENERAL.admi_parametro_det 
      VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
       (SELECT
                  id_parametro
              FROM
                  db_general.admi_parametro_cab
              WHERE        
            nombre_parametro = 'CONTRATO_FISICO_VALIDACION'
            AND estado = 'Activo'),
          'Parámetro con validaciones de contrato fisico validaciones VALOR1: -PREGUNTA1-, VALOR2: -RESPUESTA1- VALOR3: -PREGUNTA2-, VALOR4: -RESPUESTA2-, VALOR5: -RESPUESTA POR default-',
          'FIRMA DIGITAL',
          'No Acepta',
          'TÍTULO DE FACTURACIÓN',
          'ELECTRÓNICA',
          'Activo',
          'jbroncano',
          SYSDATE,
          '0.0.0.0',
          null,
          null,
          null,
          'Acepta',
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          null,
          null,
          null,
          null,
          null);  



-----------------------------------------FRECUENCIA_FACTURACION--------------------  
  INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'ESTADOS_GRID_SERVICIOS' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
         VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ESTADOS_GRID_SERVICIOS'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';


-----------------------------------------Admi_Gestion_Directorios-------------------- 

            INSERT INTO DB_GENERAL.Admi_Gestion_Directorios 
      VALUES(DB_GENERAL.SEQ_Admi_Gestion_Directorios.nextval
        ,4
          , (select MAX(CODIGO_PATH)+1 from DB_GENERAL.Admi_Gestion_Directorios where CODIGO_APP=4)
          ,'TelcosWeb'
          ,'593'
          ,'EN'
          ,'Comercial'
          ,'ContratoDocumentoDigital'
          ,'Activo'
          ,SYSDATE
          ,NULL
          ,'jbroncano'
          ,NULL);  


 INSERT INTO DB_GENERAL.Admi_Gestion_Directorios 
      VALUES(DB_GENERAL.SEQ_Admi_Gestion_Directorios.nextval
        ,4
          , (select MAX(CODIGO_PATH)+1 from DB_GENERAL.Admi_Gestion_Directorios where CODIGO_APP=4)
          ,'TelcosWeb'
          ,'593'
          ,'EN'
          ,'Comercial'
          ,'PuntoArchivoDigital'
          ,'Activo'
          ,SYSDATE
          ,NULL
          ,'jbroncano'
          ,NULL);  
          
    
  -----------------------------------------PORCENTAJE_DESCUENTO_INSTALACION--------------------           
               INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'PORCENTAJE_DESCUENTO_INSTALACION' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
        VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PORCENTAJE_DESCUENTO_INSTALACION'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';
  -----------------------------------------VALORES_OBSERVACIONES_CONTRATO_DIGITAL--------------------           
 

 INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'VALORES_OBSERVACIONES_CONTRATO_DIGITAL' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'VALORES_OBSERVACIONES_CONTRATO_DIGITAL'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';
            
  ---------------------------------------DEPARTAMENTOS_VENDEDORES----------------------------------------------
        INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'DEPARTAMENTOS_VENDEDORES' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,
          OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'DEPARTAMENTOS_VENDEDORES'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';           
  -------------------------------------------------CAMBIO FORMA PAGO------------------------------------------
INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'CAMBIO FORMA PAGO' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,        
     OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CAMBIO FORMA PAGO'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';          


-------------------------------------------------ESTADOS_RESTRICCION_PLANES_ADICIONALES------------------------------------------
           
            
INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'ESTADOS_RESTRICCION_PLANES_ADICIONALES' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,        
     OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ESTADOS_RESTRICCION_PLANES_ADICIONALES'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo';          

            
            
--##############################################################################
--#########################  ADMI_PARAMETRO_DET  ###############################
--##############################################################################
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
    VALOR6,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CORREOS_ADMINISTRACION_CONTRATOS'
    ),
    'CORREO ADMINISTRACIÓN CONTRATOS GYE',
    'admcontratosgye@ecuanet.com.ec',
    NULL,
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '33'
  );
--
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
    VALOR6,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CORREOS_ADMINISTRACION_CONTRATOS'
    ),
    'CORREO ADMINISTRACIÓN CONTRATOS UIO',
    'admcontratosuio@ecuanet.com.ec',
    NULL,
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '33'
  );
-----------------------------------------------PARAMETROS_REINGRESO_OS_AUTOMATICA-------------------------------------------------------------
INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'PARAMETROS_REINGRESO_OS_AUTOMATICA' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET' ),
          VALOR6,
          VALOR7,        
     OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_REINGRESO_OS_AUTOMATICA'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo' AND DESCRIPCION='ESTADO_PUNTO';   



   -----------------------------------------COMMIT--------------------           

 COMMIT; 
 /