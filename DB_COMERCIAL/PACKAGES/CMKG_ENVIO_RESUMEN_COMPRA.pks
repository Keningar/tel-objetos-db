CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_ENVIO_RESUMEN_COMPRA IS


/**
 * Documentación para el procedimiento P_OBTENER_SERVICIOS
 *Metodo se encargara de consultar los  servicios y los datos necesarios como forma de pago
    * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idServicio              := Id del servicio //opcional
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
 PROCEDURE P_OBTENER_SERVICIOS(   Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);

/**
 * Documentación para el procedimiento P_TER_COND_PRODUCTO
 *Metodo se encargara de consultar los  terminos y condiciones actuales de los productos
 * vendidos durante el dia 
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
 PROCEDURE P_TER_COND_PRODUCTO(    Pcl_Request  IN  VARCHAR2,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);

/**
 * Documentación para el procedimiento P_OBTENER_DOC_DIGITALES
 *Metodo se encargara de consultar la ruta de los docuementos digitales del serviciol
   * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idServicio              := Id del servicio
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
  PROCEDURE P_OBTENER_DOC_DIGITALES(Pcl_Request  IN  VARCHAR2,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);

    /**
  * Documentación para el procedimiento P_OBTENER_PROMOCION_SERVICIO
  *
  * Método encargado de retornar las promociones del servicio en la tabla INFO_SERVICIO_HISTORIAL
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   servicioId            := número de servicios
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Joel Broncano<jbroncano@telconet.ec>
  * @version 1.0 10-06-2022
  */
  PROCEDURE P_OBTENER_PROMOCION_SERVICIO(Pcl_Request  IN  VARCHAR2,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);

     /**
    * Documentación para la función P_GENERAR_SECUENCIA
    * Procedimiento que genera secuencia adendum
    *
    * @param  
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    *
    * @author Joel Broncano <jbroncano@telconet.ec>
    * @version 1.0 15-06-2022
    */

  PROCEDURE P_GENERAR_SECUENCIA(  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER);
      /**
    * Obtiene la forma de pago del cliente
    *
    *      @param  
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Descripcion      -  Data Respuesta
    *
    * @author Joel Broncano <jbroncano@telconet.ec>
    * @version 1.0 15-06-2022
    */
    PROCEDURE P_OBTENER_FORMA_PAGO( Pcl_Request  IN  VARCHAR2, 
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Descripcion       OUT VARCHAR2);


       /**
    * SE VALIDA SI EL SERVICIO TIENE PROMOCION
    * S si esta libre de promocioines
    * N si no esta libre de promociones
    *      @param  
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Descripcion      -  Data Respuesta
    *
    * @author Joel Broncano <jbroncano@telconet.ec>
    * @version 1.0 15-06-2022
    */
    PROCEDURE P_VALIDA_PROMOCION( Pcl_Request  IN  VARCHAR2, 
                              Pv_Mensaje        OUT VARCHAR2,
                              Pv_Status         OUT VARCHAR2,
                              Pv_Descripcion       OUT VARCHAR2);




     /**
    * SE OBTIENE LOS SERVICIOS DE LAS FECHAS ESPESIFICAS PARA REENVIAR DOCUMENTO
    *      @param  
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Descripcion      -  Data Respuesta
    *
    * @author Joel Broncano <jbroncano@telconet.ec>
    * @version 1.0 13-03-2023
    */                          
   PROCEDURE P_REGU_OBTENER_SERVICIOS(   Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);                                                              
END;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_ENVIO_RESUMEN_COMPRA IS

PROCEDURE P_OBTENER_SERVICIOS(   Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR) 
                                                                  
     IS
      Lv_servicios              INTEGER;
      Ln_fecha                  INTEGER;
   BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
    SELECT  PDET.VALOR1  INTO Ln_fecha FROM DB_GENERAL.admi_parametro_Det PDET
                      where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                            WHERE PCA.NOMBRE_PARAMETRO = 'CRC_FECHA_REENVIO_CORREO' AND PCA.ESTADO='Activo') 
                      AND PDET.ESTADO='Activo' AND PDET.DESCRIPCION='CRC_FECHA_REGULARIZACION_CORREO_RESUMEN';                      
    OPEN Pcl_Response FOR SELECT ISV.ID_SERVICIO AS  servicioId, ISV.PUNTO_ID AS  puntoId, ISV.PRODUCTO_ID AS  productoId
    ,trim(to_char(ISV.PRECIO_VENTA,'99,999,999,990.99')) AS  precioVenta
             ,APRO.DESCRIPCION_PRODUCTO AS  descripcionProducto,FPR.ID_PERSONA_ROL personaEmpresaRolId,IER.EMPRESA_COD empresaId,APRO.FRECUENCIA AS frecuencia
             ,TO_CHAR(ISV.FE_CREACION,'DD/MM/YYYY') AS fechaServicio, ISV.ESTADO AS ESTADO, ISV.ORIGEN AS ORIGEN
             ,DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI('DESCRIPCION_FORMA_PAGO',FPR.ID_PERSONA_ROL,FPR.ESTADO) AS formaPago
          FROM INFO_SERVICIO ISV 
          INNER JOIN DB_COMERCIAL.INFO_PUNTO IFP ON  IFP.ID_PUNTO=ISV.PUNTO_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL FPR ON IFP.PERSONA_EMPRESA_ROL_ID=FPR.ID_PERSONA_ROL
           INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL =FPR.EMPRESA_ROL_ID
             AND IER.EMPRESA_COD IN (SELECT
                    REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
                    FROM(
                           SELECT 
                              PDET.VALOR1
                           FROM DB_GENERAL.admi_parametro_Det PDET
                               where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                                     WHERE PCA.NOMBRE_PARAMETRO = 'CRC_EMPRESA_RESUMEN_CORREO' AND PCA.ESTADO='Activo') 
                              AND PDET.ESTADO='Activo'
                           ) T1
                           CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL

                 )
          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = ISV.PRODUCTO_ID
          WHERE   (ISV.FE_CREACION) >= (DECODE(Lv_servicios,null,TRUNC(SYSDATE-Ln_fecha),TRUNC(ISV.FE_CREACION)))
         AND ISV.PRODUCTO_ID is not null 
         AND ISV.ESTADO in (SELECT
          REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
          FROM(
                 SELECT 
                    PDET.VALOR1
                 FROM DB_GENERAL.admi_parametro_Det PDET
                     where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                           FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                           WHERE PCA.NOMBRE_PARAMETRO = 'CRC_ESTADOS_PRODUCTOS_ADICIONALES' AND PCA.ESTADO='Activo') 
                    AND PDET.ESTADO='Activo'
                 ) T1
                 CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL

                 )
         and ISV.ID_SERVICIO =DECODE(Lv_servicios,null,ISV.ID_SERVICIO,Lv_servicios)
         AND  ISV.ID_SERVICIO  NOT IN  ( SELECT ISVH.SERVICIO_ID FROM  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISVH 
          WHERE ISVH.SERVICIO_ID=ISV.ID_SERVICIO 
          AND  INSTR(ISVH.ACCION ,'feOrigServicioTrasladado') >0)
          AND DB_COMERCIAL.CMKG_REGULARIZACION_MASIVA_DOC.F_ES_CRS(ISV.PUNTO_ID)='N';
         Pv_Status     := 'OK';
         Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
     WHEN OTHERS THEN 
      Pv_Status     := 'Error';
      Pv_Mensaje := SQLERRM;                         
 END P_OBTENER_SERVICIOS;

 PROCEDURE P_TER_COND_PRODUCTO(    Pcl_Request  IN  VARCHAR2,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR) 
   IS
    Lv_servicios              INTEGER;
    Ln_fecha                  INTEGER;
   BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
    SELECT  PDET.VALOR1  INTO Ln_fecha FROM DB_GENERAL.admi_parametro_Det PDET
                      where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                            WHERE PCA.NOMBRE_PARAMETRO = 'CRC_FECHA_REENVIO_CORREO' AND PCA.ESTADO='Activo') 
                      AND PDET.ESTADO='Activo' AND PDET.DESCRIPCION='CRC_FECHA_REGULARIZACION_CORREO_RESUMEN'; 
    OPEN Pcl_Response FOR  SELECT APRO.ID_PRODUCTO AS productoId, APRO.TERMINO_CONDICION AS terminosCondiciones 
      FROM  DB_COMERCIAL.ADMI_PRODUCTO APRO
          INNER JOIN  (SELECT DISTINCT APRO.ID_PRODUCTO productoId FROM DB_COMERCIAL.ADMI_PRODUCTO APRO 
          INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISV  ON APRO.ID_PRODUCTO = ISV.PRODUCTO_ID  
          AND ISV.ESTADO in (SELECT
            REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
            FROM(
                  SELECT 
                      PDET.VALOR1
                  FROM DB_GENERAL.admi_parametro_Det PDET
                      where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                            WHERE PCA.NOMBRE_PARAMETRO = 'CRC_ESTADOS_PRODUCTOS_ADICIONALES' AND PCA.ESTADO='Activo') 
                      AND PDET.ESTADO='Activo'
                  ) T1
                  CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL

                  )
                AND ISV.ID_SERVICIO =DECODE(Lv_servicios,null,ISV.ID_SERVICIO,Lv_servicios)
              WHERE  (ISV.FE_CREACION) >=DECODE(Lv_servicios,null,TRUNC(SYSDATE-Ln_fecha),TRUNC(ISV.FE_CREACION))) APRO2 ON APRO2.productoId=APRO.ID_PRODUCTO
              AND APRO.TERMINO_CONDICION  IS NOT NULL
              AND APRO.EMPRESA_COD IN (SELECT
                    REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
                    FROM(
                           SELECT 
                              PDET.VALOR1
                           FROM DB_GENERAL.admi_parametro_Det PDET
                               where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                                     WHERE PCA.NOMBRE_PARAMETRO = 'CRC_EMPRESA_RESUMEN_CORREO' AND PCA.ESTADO='Activo') 
                              AND PDET.ESTADO='Activo'
                           ) T1
                           CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL

                 );
           Pv_Status     := 'OK';
         Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
     WHEN OTHERS THEN 
      Pv_Status     := 'Error';
      Pv_Mensaje := SQLERRM;       
 END P_TER_COND_PRODUCTO;

      PROCEDURE P_OBTENER_DOC_DIGITALES(Pcl_Request  IN  VARCHAR2,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)
        IS
      Lv_servicios              INTEGER;
      Ln_CodEmpresa              INTEGER;
      Ln_ContratoId              INTEGER;
      Ln_count                  NUMBER;
       Ln_tipo                  VARCHAR(4);
      Begin
      APEX_JSON.PARSE(Pcl_Request);
      Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
      Ln_CodEmpresa  := APEX_JSON.get_number(p_path => 'idEmpresa');
      SELECT nvl(count(*),0) into Ln_count 
                FROM   DB_COMUNICACION.info_documento_relacion  IDR 
                INNER JOIN DB_COMUNICACION.info_documento  IFD ON IFD.ID_DOCUMENTO=IDR.DOCUMENTO_ID AND  IFD.ESTADO='Activo' 
                AND IFD.EMPRESA_COD=Ln_CodEmpresa  AND IDR.ESTADO='Activo'
                 WHERE IDR.SERVICIO_ID=Lv_servicios  
                  AND INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'adendumMegaDatos') >0
                  AND ROWNUM <=1  ORDER BY IFD.FE_CREACION DESC ;
        IF (Ln_count >0)THEN
              OPEN Pcl_Response FOR  
              SELECT SB.nombreDoc AS nombreDoc ,SB.ubicacionDoc AS ubicacionDoc, SB.tipoDocumento AS tipoDocumento  FROM (
               SELECT SB.nombreDoc AS nombreDoc ,SB.ubicacionDoc AS ubicacionDoc, SB.tipoDocumento AS tipoDocumento 
                FROM (SELECT IFD.NOMBRE_DOCUMENTO AS nombreDoc ,IFD.UBICACION_FISICA_DOCUMENTO AS ubicacionDoc, 'A' AS tipoDocumento 
                FROM   DB_COMUNICACION.info_documento_relacion  IDR 
                INNER JOIN DB_COMUNICACION.info_documento  IFD ON IFD.ID_DOCUMENTO=IDR.DOCUMENTO_ID AND  IFD.ESTADO='Activo' 
                AND IFD.EMPRESA_COD=Ln_CodEmpresa  AND IDR.ESTADO='Activo'
                 WHERE IDR.SERVICIO_ID=Lv_servicios  
                  AND INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'adendumMegaDatos') >0 ORDER BY IFD.FE_CREACION DESC ) SB ) SB WHERE ROWNUM <=1;
           END IF; 

          select IFD.TIPO into Ln_tipo from DB_COMERCIAL.info_adendum IFD where  IFD.servicio_id=Lv_servicios; 
          IF (Ln_tipo='C')THEN
              SELECT nvl(count(*),0) into Ln_count FROM DB_COMUNICACION.info_documento IFD
                 INNER JOIN DB_COMERCIAL.INFO_CONTRATO IFC ON IFC.ID_CONTRATO=IFD.CONTRATO_ID
                 INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL FPR ON FPR.ID_PERSONA_ROL=IFC.PERSONA_EMPRESA_ROL_ID
                 INNER JOIN DB_COMERCIAL.INFO_PUNTO IFP ON  IFP.PERSONA_EMPRESA_ROL_ID=FPR.ID_PERSONA_ROL
                 INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISV  ON  IFP.ID_PUNTO=ISV.PUNTO_ID  
                 where ISV.ID_SERVICIO=Lv_servicios  AND IFD.EMPRESA_COD=Ln_CodEmpresa and  ifd.estado not in ('Eliminado') 
                 AND (INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'contratoMegadatos') >0  OR INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'terminosCondicionesMegadatos')>0);
               IF (Ln_count >0)THEN
                   OPEN Pcl_Response FOR   
                     SELECT IFD.NOMBRE_DOCUMENTO AS nombreDoc ,IFD.UBICACION_FISICA_DOCUMENTO AS ubicacionDoc, 'C' AS tipoDocumento FROM DB_COMUNICACION.info_documento IFD
                     INNER JOIN DB_COMERCIAL.INFO_CONTRATO IFC ON IFC.ID_CONTRATO=IFD.CONTRATO_ID
                     INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL FPR ON FPR.ID_PERSONA_ROL=IFC.PERSONA_EMPRESA_ROL_ID
                     INNER JOIN DB_COMERCIAL.INFO_PUNTO IFP ON  IFP.PERSONA_EMPRESA_ROL_ID=FPR.ID_PERSONA_ROL
                     INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISV  ON  IFP.ID_PUNTO=ISV.PUNTO_ID  
                     where ISV.ID_SERVICIO=Lv_servicios  AND IFD.EMPRESA_COD=Ln_CodEmpresa and  ifd.estado not in ('Eliminado') 
                     AND (INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'contratoMegadatos') >0  OR INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'terminosCondicionesMegadatos')>0);
                END IF;         
          END IF;
      SELECT nvl(count(*),0) into Ln_count
            FROM DB_COMERCIAL.info_adendum IFA  
            INNER JOIN DB_COMUNICACION.info_documento_relacion  IDR ON IDR.numero_adendum=IFA.NUMERO AND IDR.ESTADO='Activo'
            INNER JOIN DB_COMUNICACION.info_documento  IFD ON IFD.ID_DOCUMENTO=IDR.DOCUMENTO_ID AND  IFD.ESTADO='Activo' AND IFD.EMPRESA_COD=Ln_CodEmpresa
             WHERE IFA.SERVICIO_ID=Lv_servicios AND  IFA.ESTADO='Activo' 
              AND INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'adendumMegaDatos') >0
               AND ROWNUM <=1 ORDER BY IFA.FE_CREACION DESC ;  
       IF (Ln_count >0)THEN   
        OPEN Pcl_Response FOR   
            SELECT SB.nombreDoc AS nombreDoc  ,SB.ubicacionDoc AS ubicacionDoc, SB.tipoDocumento AS tipoDocumento   from (
             SELECT SB.nombreDoc AS nombreDoc  ,SB.ubicacionDoc AS ubicacionDoc, SB.tipoDocumento AS tipoDocumento  
             FROM (SELECT IFD.nombre_documento AS nombreDoc ,IFD.UBICACION_FISICA_DOCUMENTO AS ubicacionDoc, 'A' AS tipoDocumento 
              FROM DB_COMERCIAL.info_adendum IFA  
              INNER JOIN DB_COMUNICACION.info_documento_relacion  IDR ON IDR.numero_adendum=IFA.NUMERO AND IDR.ESTADO='Activo'
              INNER JOIN DB_COMUNICACION.info_documento  IFD ON IFD.ID_DOCUMENTO=IDR.DOCUMENTO_ID AND  IFD.ESTADO='Activo' AND IFD.EMPRESA_COD=Ln_CodEmpresa
               WHERE IFA.SERVICIO_ID=Lv_servicios AND  IFA.ESTADO='Activo' 
                AND INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'adendumMegaDatos') >0 ORDER BY IFA.FE_CREACION DESC ) SB ) SB WHERE ROWNUM <=1;
        END IF;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
      WHEN OTHERS THEN 
      Pv_Status     := 'Error';
      Pv_Mensaje := SQLERRM;     
  END P_OBTENER_DOC_DIGITALES;

  PROCEDURE P_OBTENER_PROMOCION_SERVICIO( Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR) 

     IS
       Lv_servicios              INTEGER;
       Ln_CodEmpresa              INTEGER;
        Ln_count                  NUMBER;
   BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
    Ln_CodEmpresa  := APEX_JSON.get_number(p_path => 'idEmpresa');

     SELECT  nvl(count(*),0) into Ln_count FROM DB_COMERCIAL.INFO_EVALUA_TENTATIVA  ift
     WHERE ift.SERVICIO_ID=Lv_servicios
      AND ift.CODIGO_GRUPO_PROMOCION='PROM_MENS'
      AND ift.EMPRESA_COD=Ln_CodEmpresa
      AND ift.ESTADO='Activo';

      if Ln_count >0 THEN
        OPEN Pcl_Response FOR  SELECT  TO_CHAR(ift.Observacion) AS obervacionPromo FROM DB_COMERCIAL.INFO_EVALUA_TENTATIVA  ift
             WHERE ift.SERVICIO_ID=Lv_servicios
              AND ift.CODIGO_GRUPO_PROMOCION='PROM_MENS'
              AND ift.EMPRESA_COD=Ln_CodEmpresa
              AND ift.ESTADO='Activo';
      ELSE
           OPEN Pcl_Response FOR  SELECT TO_CHAR(ISH.OBSERVACION )  AS obervacionPromo
              FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
              WHERE ISH.SERVICIO_ID= Lv_servicios AND ISH.USR_CREACION IN (SELECT
              REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) AS VALORES
              FROM(
                     SELECT 
                        PDET.VALOR1
                     FROM DB_GENERAL.admi_parametro_Det PDET
                         where PDET.PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCA
                                               WHERE PCA.NOMBRE_PARAMETRO = 'CRC_USUARIOS_PROMOCION_PRODUCTO' AND PCA.ESTADO='Activo') 
                        AND PDET.ESTADO='Activo'
                     ) T1
                     CONNECT BY REGEXP_SUBSTR(T1.VALOR1, '[^,]+', 1, LEVEL) IS NOT NULL
                     );       
      END IF;
         Pv_Status     := 'OK';
         Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
     WHEN OTHERS THEN 
      Pv_Status     := 'Error';
      Pv_Mensaje := SQLERRM;                         
 END P_OBTENER_PROMOCION_SERVICIO;


  PROCEDURE P_GENERAR_SECUENCIA(  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER)
    IS

   CURSOR C_RESUMEN_COMPRA_SEC(Cn_CodEmpresa        INTEGER,
                               Cv_EstadoActivo      VARCHAR2,                            
                               Cv_CodigoNumeraEmpr   VARCHAR2)
    IS
      SELECT
        AN.ID_NUMERACION,AN.NUMERACION_UNO,AN.NUMERACION_DOS
        FROM DB_COMERCIAL.ADMI_NUMERACION AN
        WHERE AN.ESTADO     = Cv_EstadoActivo
          AND AN.CODIGO     = Cv_CodigoNumeraEmpr
          AND AN.EMPRESA_ID = Cn_CodEmpresa;

    --Numeracion
    Lv_NumeracionUno           VARCHAR2(400);
    Lv_NumeracionDos           VARCHAR2(400);
    Lv_SecuenciaAsig           VARCHAR2(400);
    Lv_NumeroContrato          VARCHAR2(400);
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';

  BEGIN
         --Secuencia del contrato
        OPEN C_RESUMEN_COMPRA_SEC (18,Lv_EstadoActivo,'ARC');
            FETCH C_RESUMEN_COMPRA_SEC INTO Pn_IdNumeracion,Lv_NumeracionUno,Lv_NumeracionDos;
            CLOSE C_RESUMEN_COMPRA_SEC;

        Pn_Secuencia :=SEQ_CORREO_RESUMEN_COMPRA.nextval;
        dbms_output.put_line('id_Caracterisitica ->'|| Pn_Secuencia);

        IF Pn_Secuencia IS NOT NULL AND Lv_NumeracionUno IS NOT NULL AND Lv_NumeracionDos IS NOT NULL
        THEN
            --Actualización de la númeracion
            Lv_SecuenciaAsig  := LPAD(Pn_Secuencia,7,'0');
            Pn_Secuencia      := Pn_Secuencia + 1;

            Lv_NumeroContrato := CONCAT(CONCAT(CONCAT(Lv_NumeracionUno,CONCAT('-',Lv_NumeracionDos)),'-'),Lv_SecuenciaAsig);
        END IF;
        Pv_NumeroCA:= Lv_NumeroContrato;

        Pv_Mensaje   := 'Proceso realizado con exito';
        Pv_Status    := 'OK';
  EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status    := 'ERROR';
        Pv_Mensaje   := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        Pv_NumeroCA  := NULL;
        Pn_Secuencia := NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_GENERAR_SECUENCIA',
                                              Pv_Mensaje,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');


    END P_GENERAR_SECUENCIA;

            /**
    * Obtiene la forma de pago del cliente
    *
    *      @param  
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Descripcion      -  Data Respuesta
    *
    * @author Joel Broncano <jbroncano@telconet.ec>
    * @version 1.0 15-06-2022
    */
   PROCEDURE P_OBTENER_FORMA_PAGO( Pcl_Request  IN  VARCHAR2, 
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Descripcion       OUT VARCHAR2)
         IS
        CURSOR C_OBTENER_FORMA_PAGO(Lv_servicios      INTEGER)   IS                       
               SELECT fp.DESCRIPCION_FORMA_PAGO FROM db_general.admi_forma_pago fp 
                  INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO iprf  on iprf.forma_pago_id=fp.id_forma_pago
                  INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL FPR ON FPR.ID_PERSONA_ROL=iprf.PERSONA_EMPRESA_ROL_ID
                  INNER JOIN DB_COMERCIAL.INFO_PUNTO IFP ON IFP.PERSONA_EMPRESA_ROL_ID=FPR.ID_PERSONA_ROL
                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISV ON  IFP.ID_PUNTO=ISV.PUNTO_ID  AND ISV.ID_SERVICIO=Lv_servicios 
                  where iprf.estado='Activo';  

      Lv_servicios              INTEGER;
      Ln_CodEmpresa              INTEGER;
      Ln_FormaPago             VARCHAR2(20);


      Begin
      APEX_JSON.PARSE(Pcl_Request);
      Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');

        OPEN C_OBTENER_FORMA_PAGO (Lv_servicios);
            FETCH C_OBTENER_FORMA_PAGO INTO Ln_FormaPago;
            CLOSE C_OBTENER_FORMA_PAGO;
      Pv_Descripcion :=Ln_FormaPago;
       Pv_Status     := 'OK';
         Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
     WHEN OTHERS THEN 
      Pv_Status     := 'Error';
      Pv_Mensaje := SQLERRM;                     
    END P_OBTENER_FORMA_PAGO;

      PROCEDURE P_VALIDA_PROMOCION( Pcl_Request  IN  VARCHAR2, 
                          Pv_Mensaje        OUT VARCHAR2,
                          Pv_Status         OUT VARCHAR2,
                          Pv_Descripcion       OUT VARCHAR2)
        IS
      Lv_servicios              INTEGER;
      Ln_CodEmpresa              INTEGER;
      Ln_TipoPromo            VARCHAR2(20); 
      Begin
      APEX_JSON.PARSE(Pcl_Request);
      Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
      Ln_CodEmpresa  := APEX_JSON.get_number(p_path => 'idEmpresa');
      Ln_TipoPromo  := APEX_JSON.get_varchar2(p_path => 'tipoPromo');

      SELECT DB_COMERCIAL.CMKG_PROMOCIONES.F_VALIDA_SERVICIO(Lv_servicios,Ln_TipoPromo,Ln_CodEmpresa) INTO Pv_Descripcion FROM DUAL;
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';
      EXCEPTION
      WHEN OTHERS THEN 
        Pv_Status     := 'Error';
        Pv_Mensaje := SQLERRM;      
      END P_VALIDA_PROMOCION;



    PROCEDURE P_REGU_OBTENER_SERVICIOS(   Pcl_Request  IN  VARCHAR2,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR) 
       IS
      Ld_FechaDesde VARCHAR2(20);
      Ld_FechaHasta VARCHAR2(20);
      Ln_CodEmpresa INTEGER;
      Lv_servicios INTEGER;
      Begin
      APEX_JSON.PARSE(Pcl_Request);
      dbms_output.put_line('id_Caracterisitica ->'|| Ld_FechaHasta);
      Ln_CodEmpresa:=APEX_JSON.get_number(p_path => 'codEmpresa');
      Ld_FechaDesde:=APEX_JSON.get_varchar2(p_path => 'feDesde');
      Ld_FechaHasta:=APEX_JSON.get_varchar2(p_path => 'feHasta');
      Lv_servicios  := APEX_JSON.get_number(p_path => 'idServicio');
      OPEN Pcl_Response FOR  SELECT IDR.SERVICIO_ID from DB_COMUNICACION.info_documento IFD--2176
            inner join DB_COMUNICACION.info_documento_relacion  IDR  on IFD.ID_DOCUMENTO=IDR.DOCUMENTO_ID 
             WHERE   INSTR(IFD.UBICACION_FISICA_DOCUMENTO ,'/ResumenCompra/Comercial/DocResumenCompra/') >0 
             AND TRUNC(IFD.FE_CREACION) >= (DECODE(Ld_FechaDesde,null,TRUNC(IFD.FE_CREACION),TRUNC((to_date(Ld_FechaDesde , 'dd/mm/yyyy')))))
             AND TRUNC(IFD.FE_CREACION) <= (DECODE(Ld_FechaHasta,null,TRUNC(IFD.FE_CREACION),TRUNC((to_date(Ld_FechaHasta , 'dd/mm/yyyy')))))
             AND IFD.EMPRESA_COD =Ln_CodEmpresa
             and IDR.SERVICIO_ID =DECODE(Lv_servicios,null,IDR.SERVICIO_ID,Lv_servicios);
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';      
      EXCEPTION
      WHEN OTHERS THEN 
        Pv_Status     := 'Error';
        Pv_Mensaje := SQLERRM;      
      END P_REGU_OBTENER_SERVICIOS;   
END;
/