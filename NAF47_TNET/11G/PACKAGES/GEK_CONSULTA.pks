CREATE OR REPLACE PACKAGE NAF47_TNET.GEK_CONSULTA IS
/**
* Documentacion para NAF47_TNET.GEK_CONSULTA
* Packages que contiene procesos y funciones que pueden ser de uso general para todo el sistema
* @author llindao <llindao@telconet.ec>
* @version 1.0 26/04/2015
*/

  /**
  * Documentacion para GEF_ELIMINA_CARACTER_ESP
  * Function que permite eliminar caracteres especiales de un texto
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/04/2015
  *
  * Documentación para GEF_ELIMINA_CARACTER_ESP
  * Se hace el llamado a la tabla DB_GENERAL.ADMI_PARAMETRO_DET la cuál contiene en la columna
  * valor1 con los caracteres especiales que se desean reemplazar por espacios en blanco y se	
  * recorre cada uno de ellos por medio de un ciclo for loop.	
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.1 20/02/2020
  *
  * @param Pv_Texto IN VARCHAR2 Recibe texto a validar
  * @return            VARCHAR2 retorna texto sin caracteres especiales
  */
  FUNCTION GEF_ELIMINA_CARACTER_ESP(Pv_Texto IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para GEP_REG_PARAMETROS
  * Procedimiento que permite recuperar registro de un parametro general
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/04/2015
  *
  * @param Pv_IdEmpresa        IN VARCHAR2 Recibe codigo de empresa
  * @param Pv_IdAplicacion     IN VARCHAR2  recibe codigo de aplicacion
  * @param Pv_IdGrupoParametro IN VARCHAR2 recibe codigo de parametro general
  * @param Pv_IdParametro      IN VARCHAR2  recibe codigo de parametro
  * @param Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE retorna registro parametro general
  * @param Pv_CodigoError      OUT VARCHAR2 retorna codigo de error de base de datos
  * @param Pv_MensajeError     OUT VARCHAR2 retorna mensaje error
  */
  PROCEDURE GEP_REG_PARAMETROS(Pv_IdEmpresa        IN VARCHAR2,
                               Pv_IdAplicacion     IN VARCHAR2,
                               Pv_IdGrupoParametro IN VARCHAR2,
                               Pv_IdParametro      IN VARCHAR2,
                               Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE,
                               Pv_CodigoError      OUT VARCHAR2,
                               Pv_MensajeError     OUT VARCHAR2);  

  /**
  * Documentacion para F_RECUPERA_IP
  * Funcion que recupera la IP para asignar en la forma
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/02/2017
  *
  * @return VARCHAR2 retorna dirección IP del equipo que invoca a la funcion
  */
  FUNCTION F_RECUPERA_IP RETURN VARCHAR2;

  /**
  * Documentacion para F_RECUPERA_LOGIN
  * Funcion que recupera login de empleado
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/02/2017
  *
  * @return VARCHAR2 retorna login del usuario que invoca a la funcion
  */
  FUNCTION F_RECUPERA_LOGIN RETURN VARCHAR2;

  /**
  * Documentacion para F_RECUPERA_OSUSER
  * Funcion que recupera usuario de sistema operativo
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/09/2017
  *
  * @return VARCHAR2 retorna usuario de sistema operativo del equipo que invoca a la funcion
  */
  FUNCTION F_RECUPERA_OSUSER RETURN VARCHAR2;

  /**
  * Documentacion para F_DESC_ADMI_CUENTA_CONTABLE
  * Funcion que recupera descripcion de parametros segun el detalle plantilla por tipo cuenta contable
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/06/2019
  *
  * @param Pv_NombreTabla IN VARCHAR2 recibe nombre de estructura a realizar la busqueda
  * @param Pv_NombreCampo IN VARCHAR2 recibe nombre de campo que identifica el parametro de busqueda
  * @param Pv_ValorBuscar IN VARCHAR2 recibe codigo de parametro a buscar
  * @param Pv_NoCia       IN VARCHAR2 recibe codigo de empresa
  * @return VARCHAR2 retorna descripcion de acuerdo al parametro configurado
  */
  FUNCTION F_DESC_ADMI_CUENTA_CONTABLE (Pv_NombreTabla  IN VARCHAR2,
                                        Pv_NombreCampo  IN VARCHAR2,
                                        Pv_ValorBuscar  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para F_VALIDA_NUMEROS
  * Funcion que valida si el dato es numérico
  * @author afayala <afayala@telconet.ec>
  * @version 1.0 23/04/2019
  *
  * @param  Pv_Texto          IN  varchar2  Recibe la cantidad a generar
  * @param  Pv_Error          OUT varchar2  Mensajes de error si se generan
  */
  PROCEDURE F_VALIDA_NUMEROS (Pv_Texto IN VARCHAR2,Pv_Error OUT VARCHAR2);

  /**
  * Documentacion para F_GET_JSON_PROVEEDORES
  * Funcion genera JSON con datos de proveedores recibiendo como parametro de busqueda la cedula o RUC
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/05/2020
  *
  * @param  Pv_Identificacion IN  varchar2  Recibe identificación de proveedor
  * @param  Pv_NoCia          IN  varchar2  Recibe código de compañía
  * @param  Pv_Status         OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje        OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB                            retorna JSON con datos de proveedor
  */
  FUNCTION F_GET_JSON_PROVEEDORES ( Pv_Identificacion VARCHAR2,
                                    Pv_NoCia          VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 ) RETURN CLOB;

END GEK_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.GEK_CONSULTA IS

  FUNCTION GEF_ELIMINA_CARACTER_ESP(Pv_Texto IN VARCHAR2) RETURN VARCHAR2 IS
    lv_result VARCHAR2(32767):=NULL;
  BEGIN
    lv_result := GEK_CONSULTA.GEF_ELIMINA_CARACTER_ESP@GPOETNET(Pv_Texto);
    return lv_result;
  END GEF_ELIMINA_CARACTER_ESP;

  PROCEDURE GEP_REG_PARAMETROS(Pv_IdEmpresa        IN VARCHAR2,
                               Pv_IdAplicacion     IN VARCHAR2,
                               Pv_IdGrupoParametro IN VARCHAR2,
                               Pv_IdParametro      IN VARCHAR2,
                               Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE,
                               Pv_CodigoError      OUT VARCHAR2,
                               Pv_MensajeError     OUT VARCHAR2) IS
  BEGIN
       GEK_CONSULTA.GEP_REG_PARAMETROS@GPOETNET(pv_idempresa,
                          pv_idaplicacion,
                          pv_idgrupoparametro,
                          pv_idparametro,
                          pr_regparametro,
                          pv_codigoerror,
                          pv_mensajeerror
                          );
  EXCEPTION
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en GEK_CONSULTA.GEP_REG_PARAMETROS ' || Pv_CodigoError || '-' || SQLERRM;
  END GEP_REG_PARAMETROS;

  FUNCTION F_RECUPERA_IP RETURN VARCHAR2 IS
  BEGIN
    RETURN NVL(sys_context('userenv','ip_address'),'127.0.0.1');
  END F_RECUPERA_IP;

  FUNCTION F_RECUPERA_LOGIN RETURN VARCHAR2 IS
    Lv_user     varchar2(35):=GEK_CONSULTA.F_RECUPERA_LOGIN@GPOETNET;
  BEGIN
    RETURN Lv_user;
  END F_RECUPERA_LOGIN;


  FUNCTION F_RECUPERA_OSUSER RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV','OS_USER') ;
  END F_RECUPERA_OSUSER;

  --
  FUNCTION F_DESC_ADMI_CUENTA_CONTABLE (Pv_NombreTabla  IN VARCHAR2,
                                        Pv_NombreCampo  IN VARCHAR2,
                                        Pv_ValorBuscar  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN GEK_CONSULTA.F_DESC_ADMI_CUENTA_CONTABLE@GPOETNET(
                                        pv_nombretabla,
                                        pv_nombrecampo,
                                        pv_valorbuscar,
                                        pv_nocia
                                        );
  END;

  PROCEDURE F_VALIDA_NUMEROS(Pv_Texto IN VARCHAR2, Pv_Error OUT VARCHAR2) IS
    Lv_Texto VARCHAR2(50) :=  NULL;
  BEGIN
      IF LENGTH(TRIM(TRANSLATE(Pv_Texto , '0123456789',' '))) >= 1 THEN
        Lv_Texto:= 'Se deben ingresar sólo números enteros';
      END IF;
      Pv_Error:= Lv_Texto;
  END F_VALIDA_NUMEROS;



  FUNCTION F_GET_JSON_PROVEEDORES ( Pv_Identificacion VARCHAR2,
                                    Pv_NoCia          VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2
                                   )
                                    RETURN CLOB IS
  BEGIN
    /*
    RETURN GEK_CONSULTA.F_GET_JSON_PROVEEDORES@GPOETNET(pv_identificacion,
                                  pv_nocia,
                                  pv_status,
                                  pv_mensaje
                                  ); */
                                  
                                  NULL;
  END F_GET_JSON_PROVEEDORES;
END GEK_CONSULTA;
/
