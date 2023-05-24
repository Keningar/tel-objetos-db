CREATE OR REPLACE PACKAGE NAF47_TNET.INKG_GUIAS_REMISION AS

 
   /**
  * Documentacion para NAF47_TNET.INKG_GUIAS_REMISION
  * Paquete que contiene procedimientos para generar guias de remision por transferencias de articulos
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 10/07/2019
  */
  /**
  Definicion de variables globales
  */
  Lv_TipoEmision       VARCHAR2(1):='1';--tipo emision

  /**
  * Documentacion para P_INSERTA_ARINENCREMISION
  * Procedimiento para insertar cabecera de guia de remision
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 10/07/2019
  *
  * Se agrega columna NO_CIA_TRANSP
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.1 03/06/2021
  * 
    * 
  * @author Elvis Munoz <emnoz@telconet.ec>
  * Se procede al cambio de la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la sentencia LOWER(USER)
  * @version 1.2 15/01/2023
  * 
  * @param Pt_Arinencreremision IN  ARINENCREMISION%ROWTYPE  Recibe valores para registro de cabecera de remision
  * @param Pv_Error             OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */


  PROCEDURE P_INSERTA_ARINENCREMISION (Pt_Arinencreremision     NAF47_TNET.ARINENCREMISION%ROWTYPE,
                                       Pv_Error      OUT VARCHAR2) ;


 /**
  * Documentacion para P_INSERTA_ARINDETREMISION
  * Procedimiento para insertar detalle de guia de remision
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 12/07/2019
  * 
  * @param Pt_Arindetreremision IN  ARINDETREMISION%ROWTYPE  Recibe valores para registro de cabecera de remision
  * @param Pv_Error             OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */                                      
  PROCEDURE P_INSERTA_ARINDETREMISION (Pt_Arindetreremision  NAF47_TNET.ARINDETREMISION%ROWTYPE,
                                       Pv_Error              OUT VARCHAR2) ; 
   /**
  * Documentacion para P_GENERA_CLAVE_ACCESO
  * Procedimiento que genera clave de acceso de la guia de remision
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 17/07/2019
  * 
  * @param Pn_NoTransa IN  NAF47_TNET.ARINENCREMISION.NO_TRANSA%TYPE numero de transaccion
  * @param Pn_NoCia    IN  NAF47_TNET.ARINENCREMISION.NO_CIA%TYPE
  * @param Pv_Error    OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */                                     
  PROCEDURE P_GENERA_CLAVE_ACCESO ( Pn_NoTransa   NAF47_TNET.ARINENCREMISION.NO_TRANSA%TYPE,
                                    Pn_NoCia      NAF47_TNET.ARINENCREMISION.NO_CIA%TYPE,
                                    Pv_Error      OUT VARCHAR2) ; 


 /**
  * Documentacion para P_ENVIA_GUIA_ELECTRONICA
  * Procedimiento para ingresar documento de guia de remision en DB_COMPROBANTES.INFO_DOCUMENTO
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 30/07/2019
  * 
   */ 

  /**
  * Se ajusta para que considere todos los correos del proveedor de transporte
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 22/01/2020
  * 
  * Se ajusta para que considere la compania del transportista interno
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.1 04/06/2021
   */                                   
  PROCEDURE P_ENVIA_GUIA_ELECTRONICA  ;  

  /**
  * Documentacion para P_CONSULTA_COMP_GUIA
  * Procedimiento que consulta estado de los documentos que han sido enviados al SRI
  * 
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 30/07/2019
  * 
  */
  PROCEDURE P_CONSULTA_COMP_GUIA ;

  /**
  * Documentacion para P_ANULA_GUIA_REMISION
  * Procedimiento que anula la guia de reimision en NAF verificando que este anulado en comprobantes
  ** @author Byron Anton <banton@telconet.ec>
  * @version 1.0 30/08/2019
  */                                     
  PROCEDURE P_ANULA_GUIA_REMISION ;

/**
  * Documentacion para P_ENVIA_CORREO
  * Procedimiento que envia correo
  ** @author Byron Anton <banton@telconet.ec>
  * @version 1.0 30/08/2019
  * 
  * @param Pv_Remitente    VARCHAR2 correo remitente
  * @param Pv_Destinatario VARCHAR2 correo de destinatarios si es mas de uno debe separarse con ;
  * @param Pv_Copia    VARCHAR2  copia de correos si es mas de uno debe separarse con ;
  * @param pv_Asunto VARCHAR2 asunto del correo
  * @param pv_Mensaje VARCHAR2 mensaje del correo
  * @param Pv_Error    OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */                                     
  PROCEDURE P_ENVIA_CORREO (Pv_Remitente    VARCHAR2,
                            Pv_Destinatario VARCHAR2,
                            Pv_Copia        VARCHAR2,
                            pv_Asunto       VARCHAR2,
                            pv_Mensaje      VARCHAR2,
                            Pv_Error        OUT VARCHAR2) ;                                    


END INKG_GUIAS_REMISION;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.INKG_GUIAS_REMISION AS

  PROCEDURE P_INSERTA_ARINENCREMISION (Pt_Arinencreremision     NAF47_TNET.ARINENCREMISION%ROWTYPE,
                                       Pv_Error      OUT VARCHAR2)  AS
  BEGIN

    INSERT INTO NAF47_TNET.ARINENCREMISION (
        NO_CIA,
        CENTRO,
        NO_TRANSA,
        NO_FISICO_GUIA,
        FECHA_REGISTRO,
        GUIA_FACTURA,
        ESTADO,
        OBSERVACION,
        NO_DOCU_REFE,
        IMPRESO,
        USUARIO_IMPRIME,
        FECHA_IMPRIME,
        BODEGA_ORIGEN,
        BODEGA_DESTINO,
        MOTIVO_TRASLADO,
        FECHA_LLEGADA,
        CODIGO_TRANSPORTISTA,
        CODIGO_DESTINATARIO,
        DIRECCION_DESTINATARIO,
        NOMBRE_DESTINATARIO,
        CED_DESTINATARIO,
        CED_TRANSPORTISTA,
        PUNTO_ENTREGA,
        NOMBRE_COMERCIAL,
        TSTAMP,
        TIPO_GUIA,
        PLACA,
        ID_TIPO_TRANSPORTISTA,
        RAZON_SOCIAL_TRANSP,
        NUMERO_ENVIO_SRI,
        CED_TRANSP_EXTERNO,
        RAZON_SOC_TRANSP_EXT,
        CORREO_TRANSPORTISTA,
        NO_CIA_TRANSP
    ) VALUES (
        PT_ARINENCREREMISION.NO_CIA,
        PT_ARINENCREREMISION.CENTRO,
        PT_ARINENCREREMISION.NO_TRANSA,
        PT_ARINENCREREMISION.NO_FISICO_GUIA,
        SYSDATE,
        PT_ARINENCREREMISION.GUIA_FACTURA,
        'P',
        PT_ARINENCREREMISION.OBSERVACION,
        PT_ARINENCREREMISION.NO_DOCU_REFE,
        'N',
        PT_ARINENCREREMISION.USUARIO_IMPRIME,
        PT_ARINENCREREMISION.FECHA_IMPRIME,
        PT_ARINENCREREMISION.BODEGA_ORIGEN,
        PT_ARINENCREREMISION.BODEGA_DESTINO,
        PT_ARINENCREREMISION.MOTIVO_TRASLADO,
        PT_ARINENCREREMISION.FECHA_LLEGADA,
        PT_ARINENCREREMISION.CODIGO_TRANSPORTISTA,
        PT_ARINENCREREMISION.CODIGO_DESTINATARIO,
        PT_ARINENCREREMISION.DIRECCION_DESTINATARIO,
        PT_ARINENCREREMISION.NOMBRE_DESTINATARIO,
        PT_ARINENCREREMISION.CED_DESTINATARIO,
        PT_ARINENCREREMISION.CED_TRANSPORTISTA,
        PT_ARINENCREREMISION.PUNTO_ENTREGA,
        PT_ARINENCREREMISION.NOMBRE_COMERCIAL,
        SYSDATE,
        PT_ARINENCREREMISION.TIPO_GUIA,
        PT_ARINENCREREMISION.PLACA,
        PT_ARINENCREREMISION.ID_TIPO_TRANSPORTISTA,
        PT_ARINENCREREMISION.RAZON_SOCIAL_TRANSP,
        0,
        PT_ARINENCREREMISION.CED_TRANSP_EXTERNO,
        PT_ARINENCREREMISION.RAZON_SOC_TRANSP_EXT,
        PT_ARINENCREREMISION.CORREO_TRANSPORTISTA,
        PT_ARINENCREREMISION.NO_CIA_TRANSP
    );

  EXCEPTION
  WHEN OTHERS THEN
    Pv_Error:='Error en P_INSERTA_ARINENCREMISION: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                   'NAF47_TNET.INKG_GUIAS_REMISION.P_INSERTA_ARINENCREMISION',
                                    Pv_Error,
                                    --GEK_CONSULTA.F_RECUPERA_LOGIN,          emunoz 11012023
                                    LOWER(USER),                                     -- emunoz 11012023
                                    SYSDATE,
                                    GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARINENCREMISION;


  PROCEDURE P_INSERTA_ARINDETREMISION (Pt_Arindetreremision     NAF47_TNET.ARINDETREMISION%ROWTYPE,
                                       Pv_Error      OUT VARCHAR2)  AS
  BEGIN

    INSERT INTO NAF47_TNET.ARINDETREMISION 
        (NO_CIA,
         NO_TRANSA,
        ANIO,
        MES,
        NO_LINEA,
        NO_ARTI,
        CANTIDAD,
        NO_DOCU
    ) VALUES (
        Pt_Arindetreremision.NO_CIA,
        Pt_Arindetreremision.NO_TRANSA,
        Pt_Arindetreremision.ANIO,
        Pt_Arindetreremision.MES,
        Pt_Arindetreremision.NO_LINEA,
        Pt_Arindetreremision.NO_ARTI,
        Pt_Arindetreremision.CANTIDAD,
        Pt_Arindetreremision.NO_DOCU
    );

  EXCEPTION
  WHEN OTHERS THEN
    Pv_Error:='Error en P_INSERTA_ARINDETREMISION: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                   'NAF47_TNET.INKG_GUIAS_REMISION.P_INSERTA_ARINDETREMISION',
                                    Pv_Error,
                                    --GEK_CONSULTA.F_RECUPERA_LOGIN,             emunoz 11012023
                                    LOWER(USER),                                        -- emunoz 11012023
                                    SYSDATE,
                                    GEK_CONSULTA.F_RECUPERA_IP);
  END P_INSERTA_ARINDETREMISION;

  PROCEDURE P_GENERA_CLAVE_ACCESO ( Pn_NoTransa     NAF47_TNET.ARINENCREMISION.NO_TRANSA%TYPE,
                                    Pn_NoCia      NAF47_TNET.ARINENCREMISION.NO_CIA%TYPE,
                                    Pv_Error      OUT VARCHAR2) AS

    CURSOR C_GUIA_REMISION  IS
     SELECT d.id_tributario rucEmpresa,
           U.USUARIO_WS USUARIO,
           U.CLAVE_WS CLAVE,
           SUBSTR(F.SERIE,1,3) ESTABLECIMIENTO,
           SUBSTR(F.SERIE,4,6) PUNTO_EMISION,
           LPAD(C.NO_FISICO_GUIA , 9, '0') SECUENCIAL_GUIA,
           C.NUMERO_ENVIO_SRI,
           C.CENTRO,
           C.NO_CIA,
           C.CLAVE_ACCESO,
           C.FECHA_REGISTRO,
           C.NO_FISICO_GUIA,
           F.SERIE
     FROM NAF47_TNET.ARINENCREMISION C ,NAF47_TNET.ARCGMC D,NAF47_TNET.ARCPCT U, NAF47_TNET.CONTROL_FORMU F
     WHERE  C.NO_TRANSA=Pn_NoTransa
     AND C.NO_CIA=D.NO_CIA
     AND C.NO_CIA=U.NO_CIA
     AND C.NO_CIA=Pn_NoCia
     AND U.GENERA_DOC_ELECTRONICO = 'S'
     AND U.TIPO_GENERACION = 'WS'
     AND C.NO_CIA=F.NO_CIA
     AND F.ACTIVO = 'S'
     AND F.FORMULARIO='FRM-GUIA'||C.CENTRO;
    
    
    CURSOR C_VERIFICA_FORMULARIO (Cv_Centro VARCHAR2) IS
    SELECT COUNT(*)EXISTE
    FROM NAF47_TNET.CONTROL_FORMU C
    WHERE C.NO_CIA=Pn_NoCia
    AND C.ACTIVO = 'S'
    AND C.FORMULARIO='FRM-GUIA'||Cv_Centro;



    -- Cursores para obtener parametros a enviar en funcion DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERATORCLAVE
    CURSOR C_PARAMETROEMPRESA is
      SELECT AE.AMBIENTE_ID
      FROM   DB_COMPROBANTES.ADMI_EMPRESA AE, 
             DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
      WHERE EG.COD_EMPRESA = Pn_NoCia 
      AND   EG.PREFIJO     = AE.CODIGO;   

    CURSOR C_PARAMETROTIPOCOMPROBANTE is        
      SELECT CODIGO 
      FROM  DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO 
      WHERE DESCRIPCION='guiaRemision';


    Lc_GuiaRemision      C_GUIA_REMISION%ROWTYPE;
    Ln_AmbienteId         DB_COMPROBANTES.ADMI_EMPRESA.AMBIENTE_ID%type; 
    Lv_TipoComprobanteSRI DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO.CODIGO%type;
    l_request            SOAP_API.T_REQUEST;
    L_Response           SOAP_API.T_RESPONSE;
    Lv_Url               VARCHAR2(32767);
    Lv_Namespace         VARCHAR2(32767);
    Lv_Method            VARCHAR2(32767);
    Lv_SoapAction        VARCHAR2(32767);
    Lv_PathCert          VARCHAR2(32767);
    Lv_PswCert           VARCHAR2(32767);
    Lv_AuxCia            VARCHAR2(2) := '@';
    Lv_noDocuError       ARCPMD.NO_DOCU%TYPE := NULL;
    Lv_noCiaError        ARCPMD.NO_CIA%TYPE := null;
    Lv_noRetError        VARCHAR2(1000) := NULL;
    Lv_NombreArchivo     VARCHAR2(250);
    Lv_ClaveAcceso       VARCHAR2(100):=NULL;
    Lv_NoFisicoGuia      VARCHAR2(15);
    Ln_ExisteCentro      NUMBER;
    Le_Error             EXCEPTION;

   BEGIN

     OPEN C_PARAMETROEMPRESA;
     FETCH C_PARAMETROEMPRESA INTO Ln_AmbienteId;
     CLOSE C_PARAMETROEMPRESA;

      OPEN C_PARAMETROTIPOCOMPROBANTE;
      FETCH C_PARAMETROTIPOCOMPROBANTE INTO Lv_TipoComprobanteSRI;
      CLOSE C_PARAMETROTIPOCOMPROBANTE;

     

      OPEN C_GUIA_REMISION;
      FETCH C_GUIA_REMISION INTO Lc_GuiaRemision;
      CLOSE C_GUIA_REMISION;

      OPEN C_VERIFICA_FORMULARIO (Lc_GuiaRemision.CENTRO);
      FETCH C_VERIFICA_FORMULARIO INTO Ln_ExisteCentro;
      CLOSE C_VERIFICA_FORMULARIO;

      IF Ln_ExisteCentro=0 THEN
       Pv_Error:= 'No existe formulario FRM-GUIAS'||Lc_GuiaRemision.CENTRO;
       RAISE Le_Error;
      END IF;

      Lv_NoFisicoGuia := LPAD(FORMULARIO.SIGUIENTE(Lc_GuiaRemision.NO_CIA,
                                                                   'FRM-GUIA'||Lc_GuiaRemision.CENTRO,
                                                                   TO_CHAR(SYSDATE,'MM')),9,0);
      IF NVL(Lc_GuiaRemision.NUMERO_ENVIO_SRI,0)=0 THEN
        Lv_ClaveAcceso:=ARCPK_WEBSERVICE.Ws_CpGeneratorClave(TO_CHAR(Lc_GuiaRemision.FECHA_REGISTRO,'DDMMYYYY'), --FECHAEMISION
                                                             Lv_TipoComprobanteSRI, --TIPOCOMPROBANTE SRI
                                          Lc_GuiaRemision.rucEmpresa, --RUC EMPRESA
                                          Ln_AmbienteId, --AMBIENTE
                                          Lc_GuiaRemision.SERIE, --NUMEROSERIE
                                          lpad(Lv_NoFisicoGuia, 9, '0'), --secuencial
                                          Lv_TipoEmision );

      END IF;

       Lv_NombreArchivo := 'GRE_'||Lc_GuiaRemision.establecimiento ||'-'||
                                          Lc_GuiaRemision.Punto_Emision   ||'-'||
                                          Lv_NoFisicoGuia;


      DBMS_OUTPUT.PUT_LINE(Lv_NombreArchivo);
      DBMS_OUTPUT.PUT_LINE(Lc_GuiaRemision.rucEmpresa);


      UPDATE NAF47_TNET.ARINENCREMISION
       SET CLAVE_ACCESO=NVL(Lv_ClaveAcceso,CLAVE_ACCESO),
        ESTADO_SRI='G',
        ESTADO='D',
        NUMERO_ENVIO_SRI=0,
        NOMBRE_ARCHIVO=Lv_NombreArchivo,
        NO_FISICO_GUIA=Lv_NoFisicoGuia,
        DETALLE_RECHAZO=NULL
      WHERE NO_TRANSA=Pn_NoTransa
       AND NO_CIA=Pn_NoCia;



   EXCEPTION
   WHEN Le_Error THEN
     Pv_Error := 'Error en P_GENERA_CLAVE_ACCESO: '||Pv_Error;
     UPDATE NAF47_TNET.ARINENCREMISION
        SET ESTADO_SRI='0',
        DETALLE_RECHAZO=Pv_Error
      WHERE NO_TRANSA=Pn_NoTransa
       AND NO_CIA=Pn_NoCia;


   WHEN OTHERS THEN
     Pv_Error:='Error en P_GENERA_CLAVE_ACCESO: '||SQLERRM;  
     UPDATE NAF47_TNET.ARINENCREMISION
        SET ESTADO_SRI='0',
        DETALLE_RECHAZO=Pv_Error
      WHERE NO_TRANSA=Pn_NoTransa
       AND NO_CIA=Pn_NoCia;

   END  P_GENERA_CLAVE_ACCESO;

 /**
  * Documentacion para P_ENVIA_GUIA_ELECTRONICA
  * Se agrega en la patametrizacion de los motivos filtrar por compa?ia para habilitar a Mega
  * 
  * @author Andres Astudillo <aastudillo@telconet.ec>
  * @version 1.1 17/06/2020
  * 
  */

   PROCEDURE P_ENVIA_GUIA_ELECTRONICA  AS

    CURSOR C_GUIA_REMISION IS
    SELECT XMLRoot(XMLElement("guiaRemision",
                        XMLAttributes('comprobante' AS "id",'1.0.0' AS "version"),
                        XMLElement("infoTributaria",( Select XMLElement("ambiente",  AE.AMBIENTE_ID)
                                                        From  DB_COMPROBANTES.ADMI_EMPRESA AE,
                                                              DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
                                                        Where EG.COD_EMPRESA =  C.no_cia
                                                        and      EG.PREFIJO = AE.CODIGO ),
                                                     XMLElement("tipoEmision",Lv_TipoEmision),
                                                     XMLElement("razonSocial",gek_consulta.gef_elimina_caracter_esp(A.razon_social)),
                                                     XMLElement("nombreComercial",gek_consulta.gef_elimina_caracter_esp(A.razon_social)),
                                                     XMLElement("ruc",A.id_tributario),
                                                     XMLElement("claveAcceso",C.CLAVE_ACCESO),
                                                     XMLElement("codDoc",(SELECT CODIGO FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO WHERE DESCRIPCION='guiaRemision')),--Tipo de comprobante Guia de Remision
                                                     XMLElement("estab",Substr(F.SERIE,1,3)),
                                                     XMLElement("ptoEmi",Substr(F.SERIE,4,3)),
                                                     XMLElement("secuencial",lpad(C.NO_FISICO_GUIA , 9, '0')),
                                                     XMLElement("dirMatriz",gek_consulta.gef_elimina_caracter_esp(A.direccion))),

                        XMLElement("infoGuiaRemision", XMLElement("dirEstablecimiento",gek_consulta.gef_elimina_caracter_esp(A.direccion)),
                                                        XMLElement("dirPartida",(SELECT SUBSTR(B.DIRECCION,1,300) FROM NAF47_TNET.ARINBO B
                                                                                WHERE   B.NO_CIA=C.NO_CIA
                                                                                AND B.CODIGO=C.BODEGA_ORIGEN)),
                                                         XMLElement("razonSocialTransportista",C.RAZON_SOCIAL_TRANSP),
                                                         XMLElement("tipoIdentificacionTransportista",(SELECT TIPO_IDENTIFICACION_SRI FROM NAF47_TNET.ARGETID WHERE CODIGO=C.ID_TIPO_TRANSPORTISTA)),
                                                         XMLElement("rucTransportista",C.CED_TRANSPORTISTA),
                                                         XMLElement("obligadoContabilidad",'SI'),
                                                        (select XMLElement("contribuyenteEspecial", X.parametro) 
                                                          from ge_parametros x, ge_grupos_parametros y
                                                          where x.id_grupo_parametro = y.id_grupo_parametro
                                                            and x.id_aplicacion = y.id_aplicacion
                                                            and x.id_empresa = y.id_empresa
                                                            and x.id_grupo_parametro = 'ES_CONTRIB_ESPECIAL'
                                                            and x.id_aplicacion = 'IN'
                                                            and x.id_empresa = a.no_cia
                                                            and x.estado = 'A'
                                                            and y.estado = 'A'),
                                                        XMLElement("fechaIniTransporte",to_char(C.FECHA_REGISTRO,'dd/mm/yyyy')),
                                                        XMLElement("fechaFinTransporte",to_char(C.FECHA_LLEGADA,'dd/mm/yyyy')),
                                                        XMLElement("placa",c.PLACA)),
                        XMLElement("destinatarios", XMLElement("destinatario",
                                   XMLElement("identificacionDestinatario",gek_consulta.gef_elimina_caracter_esp(c.ced_destinatario)),
                                                     XMLElement("razonSocialDestinatario",gek_consulta.gef_elimina_caracter_esp(c.nombre_destinatario)),
                                                     XMLElement("dirDestinatario",gek_consulta.gef_elimina_caracter_esp(c.direccion_destinatario)),
                                                     (select XMLElement("motivoTraslado", X.descripcion) 
                                                          from ge_parametros x, ge_grupos_parametros y
                                                          where x.id_grupo_parametro = y.id_grupo_parametro
                                                            and x.id_aplicacion = y.id_aplicacion
                                                            and x.id_empresa = y.id_empresa
                                                            and x.id_grupo_parametro = 'MOTIVOS_TRASLADOS'
                                                            and x.id_aplicacion = 'IN'
                                                            and x.parametro = c.motivo_traslado
                                                            and x.id_empresa = a.no_cia
                                                            and x.estado = 'A'
                                                            and y.estado = 'A'),
                                                     XMLElement("ruta",SUBSTR(C.OBSERVACION,1,200)),
                                                     XMLElement("detalles",CASE C.TIPO_GUIA WHEN 'M' THEN(SELECT XMLAgg(
                                                              XMLElement("detalle",
                                                                  XMLForest 
                                                           ( D.NO_ARTI AS "codigoInterno",
                                                             M.DESCRIPCION AS "descripcion",
                                                             D.CANTIDAD AS "cantidad"
                                                            )
                                                            ))                                                           

                                                FROM NAF47_TNET.ARINDETREMISION D, NAF47_TNET.ARIN_ARTICULOS_GUIA M
                                               WHERE D.NO_CIA=C.NO_CIA 
                                                  AND C.NO_TRANSA=D.NO_TRANSA
                                                  AND D.NO_CIA=M.NO_CIA
                                                  AND D.NO_ARTI=M.NO_ARTI)ELSE (SELECT XMLAgg(
                                                              XMLElement("detalle",
                                                                  XMLForest 
                                                           ( D.NO_ARTI AS "codigoInterno",
                                                             M.DESCRIPCION AS "descripcion",
                                                             D.CANTIDAD AS "cantidad"
                                                            )
                                                            ))                                                           

                                                FROM NAF47_TNET.ARINDETREMISION D, NAF47_TNET.ARINDA M
                                               WHERE D.NO_CIA=C.NO_CIA 
                                                  AND C.NO_TRANSA=D.NO_TRANSA
                                                  AND D.NO_CIA=M.NO_CIA
                                                  AND D.NO_ARTI=M.NO_ARTI)
                                                  END))),
                                                  XMLElement("infoAdicional",XMLElement("campoAdicional", XMLAttributes('emailCliente' AS "nombre"),C.CORREO_TRANSPORTISTA)
                                                    )
                        ), VERSION '1.0" encoding="UTF-8')RESULT_XML,
           D.ID_TRIBUTARIO rucEmpresa,
           U.USUARIO_WS USUARIO,
           U.CLAVE_WS CLAVE,
           SUBSTR(F.SERIE,1,3) ESTABLECIMIENTO,
           SUBSTR(F.SERIE,4,6) PUNTO_EMISION,
           LPAD(C.NO_FISICO_GUIA , 9, '0') SECUENCIAL_GUIA,
           C.NUMERO_ENVIO_SRI,
           C.CLAVE_ACCESO,
           ( SELECT ID_TIPO_DOC FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO Where DESCRIPCION='guiaRemision' ) tipoAdmiDocumento,
           C.NOMBRE_ARCHIVO,
           C.FECHA_REGISTRO,
           C.CED_TRANSPORTISTA IDENTIFICACION,
           C.CED_TRANSP_EXTERNO,
           A.RAZON_SOCIAL,
           A.E_MAIL,
           C.NO_TRANSA,
           C.NO_CIA,
           C.NO_CIA_TRANSP,
           C.ID_TIPO_TRANSPORTISTA,
           (SELECT ID_TIPO_IDENTIFICACION FROM DB_COMPROBANTES.INFO_TIPO_IDENTIFICACION 
            WHERE CODIGO=(SELECT TIPO_IDENTIFICACION_SRI FROM NAF47_TNET.ARGETID WHERE CODIGO=C.ID_TIPO_TRANSPORTISTA))ID_TIPO_IDENTIFICACION
    FROM NAF47_TNET.ARINENCREMISION C,NAF47_TNET.ARCGMC A ,NAF47_TNET.ARCGMC D,NAF47_TNET.ARCPCT U,NAF47_TNET.CONTROL_FORMU F
    WHERE C.NO_CIA=A.NO_CIA
    AND C.NO_CIA=D.NO_CIA
    AND C.NO_CIA=U.NO_CIA
    AND C.NO_CIA=F.NO_CIA
    AND F.ACTIVO = 'S'
    AND F.FORMULARIO='FRM-GUIA'||C.CENTRO
    AND C.ESTADO_SRI='G'
    AND U.GENERA_DOC_ELECTRONICO = 'S'
    AND U.TIPO_GENERACION = 'WS';

    CURSOR c_ParametroEmpresa (Cn_NoCia DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) is
      SELECT AE.ID_EMPRESA, AE.AMBIENTE_ID
      FROM   DB_COMPROBANTES.ADMI_EMPRESA AE, 
             DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
      WHERE EG.COD_EMPRESA = Cn_NoCia 
      AND   EG.PREFIJO     = AE.CODIGO;   

    CURSOR c_ParametroTipoComprobante is        
      SELECT CODIGO 
      FROM  DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO 
      WHERE DESCRIPCION='guiaRemision';

    CURSOR C_UsuarioExiste(Cv_Identificacion DB_COMPROBANTES.ADMI_USUARIO.LOGIN%TYPE)    IS
          SELECT ID_USUARIO
          FROM DB_COMPROBANTES.ADMI_USUARIO
          WHERE LOGIN = Cv_Identificacion
          AND ROWNUM  = 1;

      -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR EMPRESA
    CURSOR C_UsuarioEmpExiste(Cn_IdUsuario    DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE,
                                                     Cn_IdEmpresa  DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE)  IS
        SELECT USUE.ID_USR_EMP
        FROM  DB_COMPROBANTES.ADMI_USUARIO USU,
              DB_COMPROBANTES.ADMI_USUARIO_EMPRESA USUE
        WHERE  USUE.USUARIO_ID = USU.ID_USUARIO
        AND USUE.EMPRESA_ID = Cn_IdEmpresa
        AND USU.ID_USUARIO = Cn_IdUsuario
        AND ROWNUM = 1;

    CURSOR C_TRANS_INTERNO (Cv_Identificacion VARCHAR2,
                            Cv_NoCia          VARCHAR2) IS
    SELECT E.NOMBRE,
       E.MAIL_CIA CORREO,
       E.DIRECCION,
       E.ID_PROVINCIA PROVINCIA,
       E.TELEFONO,
       E.PAIS_NACIMIENTO PAIS,
       E.CANTON_NACIMIENTO CANTON,
       'C' ID_TIPO_IDENTIFICACION
    FROM NAF47_TNET.ARPLME E 
    WHERE E.CEDULA=Cv_Identificacion
    AND E.NO_CIA=Cv_NoCia;

    CURSOR C_TRANS_PROVEEDOR (Cv_Identificacion VARCHAR2,
                            Cv_NoCia          VARCHAR2) IS
    SELECT P.NOMBRE,
       CASE WHEN P.EMAIL1 IS NOT NULL AND P.EMAIL2 IS NOT NULL THEN
       P.EMAIL1||';'||P.EMAIL2
       WHEN P.EMAIL1 IS NOT NULL THEN
       P.EMAIL1
       WHEN P.EMAIL2 IS NOT NULL THEN
       P.EMAIL2
       END CORREO,
       P.DIRECCION DIRECCION,
       P.PROVINCIA,
       P.TELEFONO,
       P.PAIS,
       P.CANTON,
       P.TIPO_ID_TRIBUTARIO ID_TIPO_IDENTIFICACION
    FROM NAF47_TNET.ARCPMP P WHERE P.NO_CIA=Cv_NoCia
    AND  P.CEDULA=Cv_Identificacion ; 

    CURSOR c_wsParametroCiudad (Cv_Pais Varchar2,  Cv_Provincia Varchar2,  Cv_Canton Varchar2 ) is
      SELECT DESCRIPCION 
        FROM  NAF47_TNET.ARGECAN C
    WHERE C.PAIS = CV_PAIS
          AND C.PROVINCIA = CV_PROVINCIA
          AND C.CANTON = CV_CANTON;

    Lc_GuiaRemision       C_GUIA_REMISION%ROWTYPE;
    Lc_DatosTrans         C_TRANS_PROVEEDOR%ROWTYPE;
    Ln_AmbienteId         DB_COMPROBANTES.ADMI_EMPRESA.AMBIENTE_ID%TYPE; 
    Lv_TipoComprobanteSRI DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO.CODIGO%TYPE;
    Lr_CompAdmiUsuario    DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuario               := NULL;
    Lr_CompAdmiUsuarioEmp DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa  := NULL;
    Lr_CompInfoDocumento  DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento            := NULL;
    Ln_IdDocumento        DB_COMPROBANTES.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE:=NULL;
    Ln_IdEmpresa          DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE;
    Ln_IdUsuario          DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE;
    Ln_IdTipoIdent        DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_IDENTIFICACION_ID%TYPE;
    Lv_Password           DB_COMPROBANTES.ADMI_USUARIO.PASSWORD%TYPE:=NULL;
    Ln_IdUsuarioEmpresa   DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USUARIO_ID%TYPE;
    Lv_Ciudad             NAF47_TNET.ARGECAN.DESCRIPCION%TYPE;
    Lv_serie              NAF47_TNET.CONTROL_FORMU.NO_CIA%TYPE;
    Lv_noDocuError        NAF47_TNET.ARCPMD.NO_DOCU%TYPE := NULL;
    Lv_noCiaError         NAF47_TNET.ARCPMD.NO_CIA%TYPE := null;
    Lv_noRetError         VARCHAR2(1000) := NULL;
    Lv_NombreArchivo      VARCHAR2(250);
    Lv_ClaveAcceso        VARCHAR2(100):=NULL;
    Lv_MessageError       VARCHAR2(2000);
    Lv_CedulaTrans        VARCHAR2(50);
    Lv_NoCia_trans        NAF47_TNET.ARCPMD.NO_CIA%TYPE := null;
    Le_Error              EXCEPTION;

   BEGIN



      OPEN C_PARAMETROTIPOCOMPROBANTE;
      FETCH C_PARAMETROTIPOCOMPROBANTE INTO Lv_TipoComprobanteSRI;
      CLOSE C_PARAMETROTIPOCOMPROBANTE;


      FOR Lc_GuiaRemision IN  C_GUIA_REMISION LOOP
      
      Lv_CedulaTrans:=NULL;
      BEGIN
        OPEN C_PARAMETROEMPRESA(Lc_GuiaRemision.NO_CIA);
        FETCH C_PARAMETROEMPRESA INTO Ln_IdEmpresa, Ln_AmbienteId;
        CLOSE c_parametroempresa;

       

      IF C_UsuarioExiste%ISOPEN         THEN  CLOSE C_UsuarioExiste;      END IF;
      IF C_UsuarioEmpExiste%ISOPEN  THEN  CLOSE C_UsuarioEmpExiste; END IF;
      
      --Se verifica si se ingreso transportista externo
      IF Lc_GuiaRemision.CED_TRANSP_EXTERNO IS NOT NULL THEN
        Lv_CedulaTrans:=Lc_GuiaRemision.CED_TRANSP_EXTERNO;
      ELSE
        Lv_CedulaTrans:=Lc_GuiaRemision.IDENTIFICACION;
      END IF;
      

      OPEN C_Usuarioexiste(Lv_CedulaTrans);
      FETCH C_USUARIOEXISTE INTO Ln_IdUsuario;

      IF C_UsuarioExiste%notfound THEN

          IF Lc_GuiaRemision.CED_TRANSP_EXTERNO IS NOT NULL THEN
            OPEN C_TRANS_PROVEEDOR(Lc_GuiaRemision.CED_TRANSP_EXTERNO,Lc_GuiaRemision.NO_CIA);
            FETCH C_TRANS_PROVEEDOR INTO Lc_DatosTrans;
            CLOSE C_TRANS_PROVEEDOR;
          ELSE
              IF Lc_GuiaRemision.NO_CIA_TRANSP IS NOT NULL THEN
               Lv_NoCia_trans:= Lc_GuiaRemision.NO_CIA_TRANSP;
             ELSE
               Lv_NoCia_trans:= Lc_GuiaRemision.NO_CIA;
             END IF;
             OPEN C_TRANS_INTERNO(Lc_GuiaRemision.identificacion,Lv_NoCia_trans);
             FETCH C_TRANS_INTERNO INTO Lc_DatosTrans;
             CLOSE C_TRANS_INTERNO;
          END IF;
          
         
                  -- Obtencion de clave para el Usuario  
                 Lv_Password  := DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GENERA_PASSWD_SHA256 (Lv_CedulaTrans);
                  --
                  Ln_IdUsuario                      :=DB_COMPROBANTES.MIG_SECUENCIA.SEQ_ADMI_USUARIO;
                  Lr_CompAdmiUsuario.ID_USUARIO     :=Ln_IdUsuario;
                  Lr_CompAdmiUsuario.LOGIN          :=Lv_CedulaTrans;
                  Lr_CompAdmiUsuario.NOMBRES        :=Lc_DatosTrans.NOMBRE;
                  Lr_CompAdmiUsuario.APELLIDOS      :=NULL;
                  Lr_CompAdmiUsuario.EMAIL          :=Lc_DatosTrans.CORREO;
                  Lr_CompAdmiUsuario.ADMIN          :='N';
                  Lr_CompAdmiUsuario.ESTADO         :='Activo';
                  Lr_CompAdmiUsuario.FE_CREACION    :=SYSDATE;
                  Lr_CompAdmiUsuario.USR_CREACION   :=TRIM(User);
                  Lr_CompAdmiUsuario.FE_ULT_MOD     :=NULL;
                  Lr_CompAdmiUsuario.USR_ULT_MOD    :=NULL;
                  Lr_CompAdmiUsuario.IP_CREACION    :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuario.PASSWORD       := Lv_Password;
                  Lr_CompAdmiUsuario.EMPRESA        :='N';
                  Lr_CompAdmiUsuario.LOCALE         :='es_EC';
                  Lr_CompAdmiUsuario.EMPRESA_CONSULTA  :='N';
                  --
                  DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIO_COMP_ELECT(Lr_CompAdmiUsuario, Lv_MessageError);
      ELSE
        Ln_IdUsuario := Ln_IdUsuario;
      END IF;

      IF Lv_MessageError IS NOT NULL THEN 
        RAISE Le_Error;
      END IF;
      CLOSE C_UsuarioExiste;


       OPEN C_UsuarioEmpExiste(Ln_IdUsuario,  Ln_IdEmpresa);
       FETCH C_UsuarioEmpExiste INTO Ln_IdUsuarioEmpresa;

       IF C_UsuarioEmpExiste%NOTFOUND THEN
         OPEN c_wsParametroCiudad(Lc_DatosTrans.pais,  Lc_DatosTrans.provincia, Lc_DatosTrans.canton );
                FETCH c_wsParametroCiudad INTO Lv_Ciudad;
                CLOSE c_wsParametroCiudad;

                  Ln_IdUsuarioEmpresa                         :=DB_COMPROBANTES.MIG_SECUENCIA.SEQ_ADMI_USUARIO_EMPRESA;
                  Lr_CompAdmiUsuarioEmp.ID_USR_EMP            :=Ln_IdUsuarioEmpresa;
                  Lr_CompAdmiUsuarioEmp.USUARIO_ID            :=Ln_IdUsuario;
                  Lr_CompAdmiUsuarioEmp.EMPRESA_ID            :=Ln_IdEmpresa;
                  Lr_CompAdmiUsuarioEmp.FE_CREACION           :=SYSDATE;
                  Lr_CompAdmiUsuarioEmp.USR_CREACION          :=TRIM(User);
                  Lr_CompAdmiUsuarioEmp.FE_ULT_MOD            :=NULL;
                  Lr_CompAdmiUsuarioEmp.USR_ULT_MOD           :=NULL;
                  Lr_CompAdmiUsuarioEmp.IP_CREACION           :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                  Lr_CompAdmiUsuarioEmp.EMAIL                 :=Lc_DatosTrans.CORREO;
                  Lr_CompAdmiUsuarioEmp.DIRECCION             :=Lc_DatosTrans.DIRECCION;
                  Lr_CompAdmiUsuarioEmp.TELEFONO              :=Lc_DatosTrans.TELEFONO;
                  Lr_CompAdmiUsuarioEmp.CIUDAD                :=Lv_Ciudad;
                  Lr_CompAdmiUsuarioEmp.NUMERO                :=NULL;
                  Lr_CompAdmiUsuarioEmp.FORMAPAGO             :=NULL;
                  Lr_CompAdmiUsuarioEmp.LOGIN                 :=NULL;
                  Lr_CompAdmiUsuarioEmp.CONTRATO              :=NULL;
                  Lr_CompAdmiUsuarioEmp.PASSWORD              := Lv_Password;
                  Lr_CompAdmiUsuarioEmp.N_CONEXION            :=0;
                  Lr_CompAdmiUsuarioEmp.FE_ULT_CONEXION       :=NULL;
                  Lr_CompAdmiUsuarioEmp.CAMBIO_CLAVE          :='N';
                  --
                 DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIOEMP_COMP_ELECT(Lr_CompAdmiUsuarioEmp, Lv_MessageError);
                  --
       ELSE
                Ln_IdUsuarioEmpresa  :=  Ln_IdUsuarioEmpresa;

       END IF;
       CLOSE C_UsuarioEmpExiste;         

        IF Lv_MessageError IS NOT NULL THEN 
          RAISE Le_Error;
        END IF;

      --SETEO CAMPOS PARA INSERTAR EN DB_COMPROBANTES -> INFO_DOCUMENTO
      Ln_IdDocumento                              :=  DB_COMPROBANTES.MIG_SECUENCIA.SEQ_INFO_DOCUMENTO;
      Lr_CompInfoDocumento.ID_DOCUMENTO           := Ln_IdDocumento;
      Lr_CompInfoDocumento.TIPO_DOC_ID            := Lc_GuiaRemision.tipoAdmiDocumento;
      Lr_CompInfoDocumento.FORMATO_ID             := 1;
      Lr_CompInfoDocumento.EMPRESA_ID             := Ln_IdEmpresa;
      Lr_CompInfoDocumento.NOMBRE                 := Lc_GuiaRemision.nombre_Archivo;
      Lr_CompInfoDocumento.FE_CREACION            := SYSDATE;
      Lr_CompInfoDocumento.USR_CREACION           := TRIM(User);
      Lr_CompInfoDocumento.FE_ULT_MOD             := NULL;
      Lr_CompInfoDocumento.USR_ULT_MOD            := NULL;
      Lr_CompInfoDocumento.IP_CREACION            := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
      Lr_CompInfoDocumento.ESTABLECIMIENTO        := Lc_GuiaRemision.establecimiento;
      Lr_CompInfoDocumento.PUNTO_EMISION          := Lc_GuiaRemision.PUNTO_EMISION;
      Lr_CompInfoDocumento.VALOR                  := 0;
      Lr_CompInfoDocumento.ESTADO_DOC_ID          := 10;
      Lr_CompInfoDocumento.VERSION                := 1;
      Lr_CompInfoDocumento.SECUENCIAL             := Lc_GuiaRemision.SECUENCIAL_GUIA;
      Lr_CompInfoDocumento.FE_RECIBIDO            := SYSDATE;
      Lr_CompInfoDocumento.TIPO_IDENTIFICACION_ID := NULL;
      Lr_CompInfoDocumento.IDENTIFICACION         := Lc_GuiaRemision.IDENTIFICACION;
      Lr_CompInfoDocumento.TIPO_EMISION_ID        := 1;
      Lr_CompInfoDocumento.USUARIO_ID             := Ln_IdUsuario;
      Lr_CompInfoDocumento.LOTEMASIVO_ID          := 0;
      Lr_CompInfoDocumento.XML_ORIGINAL           := DB_FINANCIERO.MIG_LEE_CAMPOS_LOB.F_XMLBLOG(Lc_GuiaRemision.result_xml);
      Lr_CompInfoDocumento.AMBIENTE_ID            := Ln_AmbienteId;
      Lr_CompInfoDocumento.FE_EMISION             := Lc_GuiaRemision.FECHA_REGISTRO;
      Lr_CompInfoDocumento.INTENTO_RECEPCION      := 0;
      Lr_CompInfoDocumento.INTENTO_CONSULTA       := 0;
      Lr_CompInfoDocumento.ORIGEN_DOCUMENTO       := 'Offline';
      Lr_CompInfoDocumento.CLAVE_ACCESO           := Lc_GuiaRemision.clave_acceso;
      Lr_CompInfoDocumento.DOCUMENTO_ID_FINAN     := 0;

      --Si no se ha creado el documento
      IF  nvl(Lc_GuiaRemision.numero_envio_sri,0) = 0 THEN  

              NAF47_TNET.Mig_Lee_Campos_Lob.P_INSERT_INFO_DOCUMENTO(Lr_CompInfoDocumento, Lv_MessageError );

               IF Lv_MessageError IS NOT NULL  THEN  

                  BEGIN
                     Lv_MessageError := Lv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ';
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.P_INSERT_INFO_DOCUMENTO', 'INGRESO DE INFO_DOCUMENTO', Lv_MessageError);
                     RAISE Le_Error;
                  END;
                END IF;


        --caso contrario se actualiza el documento 
        ELSIF  Lc_GuiaRemision.numero_envio_sri  >  0  THEN 

              Lr_CompInfoDocumento.FE_ULT_MOD        := SYSDATE;
              Lr_CompInfoDocumento.USR_ULT_MOD       := TRIM(User);
              NAF47_TNET.MIG_LEE_CAMPOS_LOB.P_Update_Info_Documento_NAF(Lr_CompInfoDocumento, Lv_MessageError);

        END IF;

        IF  Lv_MessageError  IS NOT  NULL THEN
          RAISE Le_Error;
        ELSE

          UPDATE NAF47_TNET.ARINENCREMISION
          SET ESTADO_SRI='10',
          ESTADO='D',
          NUMERO_ENVIO_SRI = NUMERO_ENVIO_SRI + 1,
          DOCUMENTO_ID     = Ln_IdDocumento,
          TIPO_DOC_ID      = Lc_GuiaRemision.tipoAdmiDocumento,
          EMPRESA_ID = Ln_IdEmpresa
          WHERE NO_TRANSA=Lc_GuiaRemision.NO_TRANSA
          AND NO_CIA=Lc_GuiaRemision.NO_CIA; 
          COMMIT;  
        END IF;

      EXCEPTION
      WHEN Le_Error THEN
         UPDATE NAF47_TNET.ARINENCREMISION
          SET ESTADO_SRI='0',
          DETALLE_RECHAZO=Lv_MessageError
          WHERE NO_TRANSA=Lc_GuiaRemision.NO_TRANSA
          AND NO_CIA=Lc_GuiaRemision.NO_CIA;

      WHEN OTHERS THEN
         Lv_MessageError:='Error en registro de documento: '||SQLERRM; 
        UPDATE NAF47_TNET.ARINENCREMISION
          SET ESTADO_SRI='0',
          DETALLE_RECHAZO=Lv_MessageError
          WHERE NO_TRANSA=Lc_GuiaRemision.NO_TRANSA
          AND NO_CIA=Lc_GuiaRemision.NO_CIA;           


      END; --FIN BEGIN
      Lv_MessageError:=null;
      COMMIT;
      END LOOP;

   EXCEPTION

   WHEN OTHERS THEN

    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('GUIA_REMISION',
                                                         'NAF47_TNET.INKG_GUIAS_REMISION.P_ENVIA_GUIA_ELECTRONICA',
                                                         SQLERRM);
    ROLLBACK;
   END  P_ENVIA_GUIA_ELECTRONICA;


  PROCEDURE P_CONSULTA_COMP_GUIA IS


       CURSOR C_GUIA_REMISION  IS
    SELECT  C.NO_CIA,
            C.NO_TRANSA,
            C.CLAVE_ACCESO,
            C.NOMBRE_ARCHIVO nombrearchivo,
            C.ESTADO_SRI,
            C.DOCUMENTO_ID,
            C.TIPO_DOC_ID,
            C.EMPRESA_ID
    FROM NAF47_TNET.ARINENCREMISION C
    WHERE C.ESTADO_SRI IN (SELECT TO_CHAR(ID_EST_DOC)
                               FROM  DB_COMPROBANTES.ADMI_ESTADO_DOCUMENTO
                               WHERE NOMBRE IN ('Iniciado','Recibido','Creado')); --1:Iniciado;  3:Recibido, 10:EnviadoCompElect



    CURSOR C_ESTADO_GUIAS  ( CN_DOCUMENTO NUMBER, CN_TIPO NUMBER,  CN_EMPRESA NUMBER) IS
        SELECT CLAVE_ACCESO, ESTADO_DOC_ID, FE_AUTORIZACION
        FROM DB_COMPROBANTES.INFO_DOCUMENTO
        WHERE TIPO_DOC_ID     =  CN_TIPO
             AND ID_DOCUMENTO  = CN_DOCUMENTO
             AND EMPRESA_ID      = CN_EMPRESA;

    CURSOR C_MENSAJE  ( CN_DOCUMENTO NUMBER ) IS
        SELECT  SUBSTR(TIPO||' - '||MENSAJE||' - '||INFOADICIONAL,1,2000)  INFORMATIVO
        FROM DB_COMPROBANTES.INFO_MENSAJE
        WHERE  DOCUMENTO_ID = CN_DOCUMENTO
        AND ID_MENSAJE IN ( SELECT MAX(ID_MENSAJE) MENSAJE
                                      FROM DB_COMPROBANTES.INFO_MENSAJE
                                      WHERE DOCUMENTO_ID = CN_DOCUMENTO );

  Lv_ClaveAcceso    DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%type;      
  Ln_EstadoDocId    DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_SRI_ID%type;  
  Ld_FeAutorizacion DB_COMPROBANTES.INFO_DOCUMENTO.FE_AUTORIZACION%type;
  Lv_Mensaje        NAF47_TNET.ARCPMD.DETALLE_RECHAZO%TYPE;
    --
  Begin
    FOR est in C_GUIA_REMISION LOOP  
        --
        OPEN C_ESTADO_GUIAS(est.documento_id, est.tipo_doc_id, est.empresa_id); 
        FETCH C_ESTADO_GUIAS INTO Lv_ClaveAcceso, Ln_EstadoDocId, Ld_FeAutorizacion;
        CLOSE C_ESTADO_GUIAS;
        --
        IF  Ln_EstadoDocId = 1 THEN
            UPDATE NAF47_TNET.ARINENCREMISION A
               SET A.ESTADO_SRI = LN_ESTADODOCID,
                   A.DETALLE_RECHAZO = NULL,
                   A.NUMERO_ENVIO_SRI = 0
             WHERE A.NO_TRANSA = EST.NO_TRANSA
                 AND A.NO_CIA = EST.NO_CIA;

        ELSIF  Ln_EstadoDocId = 2  THEN  -- (Rechazado,  obtener motivo de rechazo en INFO_MENSAJE)
             OPEN  C_MENSAJE (est.documento_id);
             FETCH C_MENSAJE into Lv_Mensaje;
             CLOSE C_MENSAJE;

             UPDATE NAF47_TNET.ARINENCREMISION a
                SET a.ESTADO_SRI = Ln_EstadoDocId,
                   A.DETALLE_RECHAZO = Lv_Mensaje,
                   A.NUMERO_ENVIO_SRI = A.NUMERO_ENVIO_SRI + 1
             WHERE A.NO_TRANSA = est.NO_TRANSA
                 AND A.NO_CIA = est.NO_CIA;

        ELSIF  Ln_EstadoDocId = 0 THEN  -- (Error por validacion WSTelconet,  obtener motivo de rechazo en INFO_MENSAJE)
             OPEN  C_MENSAJE (est.documento_id);
             FETCH C_MENSAJE INTO Lv_Mensaje;
             CLOSE C_MENSAJE;

             UPDATE NAF47_TNET.ARINENCREMISION a
                SET A.ESTADO_SRI = Ln_EstadoDocId,
                   A.DETALLE_RECHAZO = Lv_mensaje,
                   a.NUMERO_ENVIO_SRI = a.NUMERO_ENVIO_SRI + 1
             WHERE a.NO_TRANSA = est.NO_TRANSA
                 AND a.NO_CIA = est.NO_CIA;

        ELSIF  Ln_EstadoDocId = 5 THEN  -- (Autorizado por validacion WSTelconet,  obtener mensaje en INFO_MENSAJE)
             OPEN  C_MENSAJE (est.documento_id);
             FETCH C_MENSAJE INTO Lv_Mensaje;
             CLOSE C_MENSAJE;

            UPDATE NAF47_TNET.ARINENCREMISION a
               SET A.ESTADO_SRI = Ln_EstadoDocId,
                   A.ESTADO='D',
                   A.DETALLE_RECHAZO = NULL,
                   A.NUMERO_ENVIO_SRI = a.NUMERO_ENVIO_SRI + 1,
                   A.MENSAJE_AUTORIZACION_SRI  = Lv_mensaje,
                   A.FECHA_REMISION=Ld_FeAutorizacion
             WHERE A.NO_TRANSA = est.NO_TRANSA
                 AND A.NO_CIA = est.NO_CIA;
        END IF;
      COMMIT;
    END LOOP;

  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('GUIA_REMISION',
                                                         'NAF47_TNET.INKG_GUIAS_REMISION.P_CONSULTA_COMP_GUIA',
                                                          SQLERRM);
    ROLLBACK;
  END P_CONSULTA_COMP_GUIA;

  PROCEDURE P_ANULA_GUIA_REMISION  AS


  CURSOR C_GUIA_ANULAR IS 
  SELECT C.*
  FROM NAF47_TNET.ARINENCREMISION C, DB_COMPROBANTES.INFO_DOCUMENTO D
    WHERE ESTADO='X'
    AND C.DOCUMENTO_ID=D.ID_DOCUMENTO
    AND ESTADO_DOC_ID='8';    


  BEGIN

  FOR Lr_GuiaAnular IN C_GUIA_ANULAR LOOP 
      UPDATE NAF47_TNET.ARINENCREMISION
        SET ESTADO='A',
        ESTADO_SRI='8'
      WHERE NO_TRANSA=Lr_GuiaAnular.NO_TRANSA
      AND NO_CIA=Lr_GuiaAnular.NO_CIA;


      IF Lr_GuiaAnular.TIPO_GUIA='T' THEN --Transferencia

          UPDATE NAF47_TNET.ARINTE
            SET GUIA_REMISION='N'
          WHERE NO_CIA=Lr_GuiaAnular.NO_CIA 
            AND NO_DOCU IN (SELECT NO_DOCU 
                              FROM ARINDETREMISION
                            WHERE NO_CIA=Lr_GuiaAnular.NO_CIA
                            AND NO_TRANSA=Lr_GuiaAnular.NO_TRANSA);

      END IF; 

      IF Lr_GuiaAnular.TIPO_GUIA='O' THEN --Otros Documentos
        UPDATE NAF47_TNET.ARINME
            SET APLICA_GUIA_REM='N'
          WHERE NO_CIA=Lr_GuiaAnular.NO_CIA 
            AND NO_DOCU IN (SELECT NO_DOCU 
                              FROM ARINDETREMISION
                            WHERE NO_CIA=Lr_GuiaAnular.NO_CIA
                            AND NO_TRANSA=Lr_GuiaAnular.NO_TRANSA);
      END IF;
    COMMIT;    
  END LOOP;
  EXCEPTION

  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('GUIA_REMISION',
                                                         'NAF47_TNET.INKG_GUIAS_REMISION.P_ANULA_GUIA_REMISION',
                                                          SQLERRM);
    ROLLBACK;

  END P_ANULA_GUIA_REMISION;    


 PROCEDURE P_ENVIA_CORREO (Pv_Remitente    VARCHAR2,
                            Pv_Destinatario VARCHAR2,
                            Pv_Copia        VARCHAR2,
                            pv_Asunto       VARCHAR2,
                            pv_Mensaje      VARCHAR2,
                            Pv_Error        OUT VARCHAR2)AS

  BEGIN

    SYS.UTL_MAIL.SEND(SENDER     => Pv_Remitente,
                      RECIPIENTS => Pv_Destinatario,
                      CC         => Pv_Copia,
                      SUBJECT    => pv_Asunto,
                      MIME_TYPE  => 'text/html; charset=us-ascii',
                      MESSAGE    => pv_Mensaje);

  EXCEPTION
  WHEN OTHERS THEN

  Pv_Error:='Error en P_ENVIA_CORREO: '|| SQLERRM;

  END P_ENVIA_CORREO;                            



END INKG_GUIAS_REMISION;
/