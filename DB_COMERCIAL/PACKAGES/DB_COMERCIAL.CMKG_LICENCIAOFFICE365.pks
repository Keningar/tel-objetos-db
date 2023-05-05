CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_LICENCIAOFFICE365 AS

  /**
  * Documentacion para el procedimiento P_RENOVAR_LICOFFICE365
  *
  * Método encargado de la renovación de licencias Office365 para los clientes por medio de la llamada a un Web Service.
  *
  * @param Pv_PrefijoEmpresa  IN VARCHAR2 Prefijo de la empresa 
  * @param Pv_EmpresaCod      IN VARCHAR2 Código de empresa
  * @param Pv_UsrCreacion     IN VARCHAR2 Usuario de creación
  * @param Pv_Ip              IN VARCHAR2 Ip de creación
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 28-06-2018
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 28-02-2019 Se envia generacion de historial e inactivación de caracteristicas al proceso que ejecuta telcos.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 07-03-2019 Se agrega cursor para consultar detalle de parámetro por valor.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.3 09-03-2023 Se agrega cursor para consultar número de meses transcurridos desde la fecha de creación de la última caracteristica del servicio
  *                         creada en la renovación de licencia con respecto a la fecha actual. se agrega validación de dicha variable con respecto al
  *                         número de meses parametrizado para realizar la renovación.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.4 20-03-2023 Se agrega uso de llamada a función CEIL debido a problemas de decimales al calcular el tiempo en meses  con respecto 
  *                         a la ultima fecha creación de caracteristica de renovación.
  */      
  PROCEDURE P_RENOVAR_LICOFFICE365(Pv_PrefijoEmpresa  IN VARCHAR2,
		                   Pv_EmpresaCod      IN VARCHAR2,
		                   Pv_UsrCreacion     IN VARCHAR2,
		                   Pv_Ip              IN VARCHAR2);
    
END CMKG_LICENCIAOFFICE365;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_LICENCIAOFFICE365 AS

  PROCEDURE P_RENOVAR_LICOFFICE365(Pv_PrefijoEmpresa  IN VARCHAR2,
		                   Pv_EmpresaCod      IN VARCHAR2,
		                   Pv_UsrCreacion     IN VARCHAR2,
		                   Pv_Ip              IN VARCHAR2) IS
    

    CURSOR C_GET_PARAMETROS(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    CURSOR C_GET_PARAMETRO_DET(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Valor2 VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND DET.VALOR2           =  Cv_Valor2
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

      CURSOR C_GET_SERVICIOS_RENOVAR(Cv_PrefijoEmpresa      VARCHAR2,
                                     Cv_DescripcionProducto VARCHAR2, 
                                     Cv_EstadoServicio      VARCHAR2,
                                     Cv_AccionHistAct       VARCHAR2,
                                     Cv_AccionHistRen       VARCHAR2,  
                                     Cn_NumMesesActivo      NUMBER) IS
        SELECT ISE.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO            ISE
        JOIN DB_COMERCIAL.ADMI_PRODUCTO            PRO  ON PRO.ID_PRODUCTO     = ISE.PRODUCTO_ID
        JOIN DB_COMERCIAL.INFO_PUNTO               PTO  ON PTO.ID_PUNTO        = ISE.PUNTO_ID
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER  ON IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID 
        JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO       IEG  ON IEG.COD_EMPRESA     = IER.EMPRESA_COD
        JOIN DB_COMERCIAL.INFO_PERSONA             PERS ON PERS.ID_PERSONA     = IPER.PERSONA_ID 
        JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  ISH  ON ISE.ID_SERVICIO     = ISH.SERVICIO_ID
        WHERE PRO.DESCRIPCION_PRODUCTO = Cv_DescripcionProducto
        AND ISE.ESTADO                 = Cv_EstadoServicio
        AND ISH.ESTADO                 = Cv_EstadoServicio
        AND IEG.PREFIJO                = Cv_PrefijoEmpresa
        AND (ISH.ID_SERVICIO_HISTORIAL = (

                                           SELECT MAX(ISHS.ID_SERVICIO_HISTORIAL) 
                                           FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHS 
                                           WHERE  ISHS.ACCION      = Cv_AccionHistRen 
                                           AND    ISHS.SERVICIO_ID = ISE.ID_SERVICIO

                                         )
        OR ISH.ID_SERVICIO_HISTORIAL =   (
                                           SELECT MAX(ISHS.ID_SERVICIO_HISTORIAL) 
                                           FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHS 
                                           WHERE  ISHS.ACCION      = Cv_AccionHistAct 
                                           AND    ISHS.SERVICIO_ID = ISE.ID_SERVICIO
                                         )
         AND NOT EXISTS (SELECT IH.* FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL IH 
                         WHERE  IH.SERVICIO_ID = ISE.ID_SERVICIO 
                         AND    IH.ACCION      = Cv_AccionHistRen)                          
            )
        AND MONTHS_BETWEEN((SYSDATE - 1),ISH.FE_CREACION) >= Cn_NumMesesActivo;

    CURSOR C_GET_CARACTERISTICAS(Cv_Producto VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT AC.*
      FROM  DB_COMERCIAL.ADMI_PRODUCTO                 AP 
      JOIN  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA  APC ON AP.ID_PRODUCTO       = APC.PRODUCTO_ID
      JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA           AC  ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
      WHERE AP.DESCRIPCION_PRODUCTO  =  Cv_Producto      
      AND   AP.ESTADO                =  Cv_Estado
      AND   AC.ESTADO                =  Cv_Estado
      AND   APC.ESTADO               =  Cv_Estado;
    -- Cursor que obtiene el número de meses desde la fecha de creación de la característica con respecto a la fecha actual.
    CURSOR C_GET_NUM_MESES_ULT_REN(Cn_IdServicio NUMBER, Cv_Caracteristica VARCHAR2) IS

      SELECT CEIL(ROUND(MONTHS_BETWEEN((SYSDATE-1),ISC.FE_CREACION),2))
      FROM  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISC
      WHERE ISC.ID_SERVICIO_PROD_CARACT = (SELECT MAX(ISC.ID_SERVICIO_PROD_CARACT)
                                           FROM  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISC
                                           JOIN  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISC.PRODUCTO_CARACTERISITICA_ID
                                           JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA          AC  ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                                           WHERE ISC.SERVICIO_ID = Cn_IdServicio  
                                           AND   ISC.ESTADO      = 'Activo'
                                           AND   AC.ESTADO       = 'Activo'
                                           AND   AC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica); 
 

    
    /* Variables locales */
    Lr_ServicioHistorial            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE := NULL;
    Lc_ParametrosWs                 C_GET_PARAMETROS%ROWTYPE;
    Lc_ParametrosCd                 C_GET_PARAMETROS%ROWTYPE;
    Lc_ParametrosCm                 C_GET_PARAMETROS%ROWTYPE;
    Le_MyException                  EXCEPTION;
    Lv_EstadoActivo                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE                           := 'Activo';
    Lv_EstadoInactivo               DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE                           := 'Inactivo';
    Lv_DescripcionProducto          DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE             := 'NetlifeCloud';
    Lv_AccionHistActivacion         DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE                 := 'confirmarServicio';
    Lv_AccionHistRenovacion         DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE                 := 'renovarLicenciaOffice365';
    Lv_UsrRenovacion                DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE           := 'telcos_renova';
    Lv_ModuloComercial              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE                        := 'COMERCIAL';
    Lv_ModuloFinanciero             DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE                        := 'FINANCIERO';
    Lv_ParametroRenovarLicOffice    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'RENOVAR_LIC_OFFICE365';
    Lv_ParametroCertificadoDigital  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'CERTIFICADO_DIGITAL_TELCOS';
    Lv_ParametroPeriodoRenovacion   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'PERIODO_RENOVAR_LICOFFICE365';
    Lv_ParametroDetRenovacion       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                        := 'RenovarLicenciaOffice365';
    Lv_DescripcionCaracteristica    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := '';
    Lv_Error                        VARCHAR2(4000):=NULL;
    Ln_ControlError                 NUMBER        := 0;
    Ln_NumMesesActivo               NUMBER        := 0;
    Ln_NumMesesUltRenovacion        NUMBER        := 0;
    Ln_Contador                     NUMBER        := 0;
    Ln_ServicioIdRenovar            NUMBER        := 0;
    Lcl_Json                        CLOB;
    Lcl_Servicios                   CLOB;
    Lcl_Respuesta                   CLOB;
    Lb_ControlError                 BOOLEAN;    

  BEGIN
    
    IF C_GET_PARAMETROS%ISOPEN THEN
      CLOSE C_GET_PARAMETROS;
    END IF;

    IF C_GET_SERVICIOS_RENOVAR%ISOPEN THEN
      CLOSE C_GET_SERVICIOS_RENOVAR;
    END IF;

    IF C_GET_NUM_MESES_ULT_REN%ISOPEN THEN
      CLOSE C_GET_NUM_MESES_ULT_REN;
    END IF;
    
    OPEN C_GET_PARAMETRO_DET(Pv_EmpresaCod,Lv_ParametroRenovarLicOffice,Lv_ModuloComercial,Lv_ParametroDetRenovacion,Lv_EstadoActivo);
     FETCH C_GET_PARAMETRO_DET 
        INTO Lc_ParametrosWs;
    CLOSE C_GET_PARAMETRO_DET;

    OPEN C_GET_PARAMETROS(Pv_EmpresaCod,Lv_ParametroCertificadoDigital,Lv_ModuloFinanciero,Lv_EstadoActivo);
     FETCH C_GET_PARAMETROS
        INTO Lc_ParametrosCd;
    CLOSE C_GET_PARAMETROS;

    OPEN C_GET_PARAMETROS(Pv_EmpresaCod,Lv_ParametroPeriodoRenovacion,Lv_ModuloComercial,Lv_EstadoActivo);
     FETCH C_GET_PARAMETROS
        INTO Lc_ParametrosCm;
    CLOSE C_GET_PARAMETROS;


     Ln_NumMesesActivo := NVL(Lc_ParametrosCm.VALOR1,0);
            
     /* Inicio For servicios a renovar licencia */
     
     FOR ServiciosRenovar IN C_GET_SERVICIOS_RENOVAR (Pv_PrefijoEmpresa, Lv_DescripcionProducto, Lv_EstadoActivo, Lv_AccionHistActivacion, Lv_AccionHistRenovacion, Ln_NumMesesActivo) LOOP
       Ln_ServicioIdRenovar := ServiciosRenovar.ID_SERVICIO;
       IF Ln_ServicioIdRenovar IS NOT NULL THEN
         OPEN C_GET_NUM_MESES_ULT_REN(Ln_ServicioIdRenovar,'PRODUCTKEY');
          FETCH C_GET_NUM_MESES_ULT_REN
            INTO Ln_NumMesesUltRenovacion;
         CLOSE C_GET_NUM_MESES_ULT_REN;
         IF Ln_NumMesesUltRenovacion >= Ln_NumMesesActivo THEN
            /* Se arma el json que seré enviado al web service. */
            Lcl_Json := '{ "data":{"prefijoEmpresa":"prefijoWS","empresaId":"empresaWS",';
            Lcl_Json := Lcl_Json ||'"usuarioCreacion":"userWS","ip":"ipWS","servicioId":"servicioIdWS","accion":"accionWS"},';
            Lcl_Json := Lcl_Json ||'"op":"opWS"}';

            /* Se reemplaza los valores respectivos.*/
            Lcl_Json := REPLACE(Lcl_Json,'prefijoWS'    ,Pv_PrefijoEmpresa);
            Lcl_Json := REPLACE(Lcl_Json,'empresaWS'    ,Pv_EmpresaCod);
            Lcl_Json := REPLACE(Lcl_Json,'userWS'       ,Pv_UsrCreacion);
            Lcl_Json := REPLACE(Lcl_Json,'ipWS'         ,Pv_Ip);
            Lcl_Json := REPLACE(Lcl_Json,'servicioIdWS' ,Ln_ServicioIdRenovar);
            Lcl_Json := REPLACE(Lcl_Json,'accionWS'     ,Lv_AccionHistRenovacion);
            Lcl_Json := REPLACE(Lcl_Json,'opWS'         ,Lc_ParametrosWs.VALOR2);

            DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                      Pcl_Mensaje        => Lcl_Json,
                                                      Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                      Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                      Pv_UrlFileDigital  => Lc_ParametrosCd.VALOR1,
                                                      Pv_PassFileDigital => Lc_ParametrosCd.VALOR2,
                                                      Pcl_Respuesta      => Lcl_Respuesta,
                                                      Pv_Error           => Lv_Error);


            IF Lv_Error IS NOT NULL THEN
             RAISE Le_MyException;
            END IF;
       END IF;
      END IF;
     END LOOP;  /* Fin For servicios a renovar licencia */
     COMMIT;
  EXCEPTION
    
    WHEN Le_MyException THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_LICENCIAOFFICE365.P_RENOVAR_LICOFFICE365',
                                           'Error ' || Lv_Error,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    
    WHEN OTHERS THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_LICENCIAOFFICE365.P_RENOVAR_LICOFFICE365',
                                           'Error ' || SQLCODE || ' -ERROR- ' || SQLERRM || ' - ERROR_STACK: '
                                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      
  END P_RENOVAR_LICOFFICE365;

END CMKG_LICENCIAOFFICE365;
/
