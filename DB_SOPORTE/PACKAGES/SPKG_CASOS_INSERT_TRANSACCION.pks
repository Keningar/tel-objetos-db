CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION AS 

   /**
   * Documentaci�n para proceso 'P_REINICIAR_SECUENCIAS_CASOS'
   *
   * Procedimiento encargado de reiniciar las secuencias que permiten obtener el n�mero respectivo seg�n el tipo de caso
   *
   * @author   Jorge G�mez <jigomez@telconet.ec>
   * @version  1.0
   * @since    20-01-2023
   */
   PROCEDURE P_REINICIAR_SECUENCIAS_CASOS;
  
  /**
   * Documentaci�n para proceso 'P_OBTENER_NUMERO_CASO'
   *
   * Procedimiento encargado de obtener el n�mero de caso correspondiente
   *
   * @param Pv_TipoCaso   IN ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE Recibe el nombre del tipo de caso
   * @param Pv_NumeroCaso OUT VARCHAR2 Retorna el n�mero del caso generado
   *
   * @author   Jorge G�mez <jigomez@telconet.ec>
   * @version  1.0
   * @since    22-01-2023
   */
  PROCEDURE P_OBTENER_NUMERO_CASO(Pv_TipoCaso   IN ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                                  Pv_NumeroCaso OUT INFO_CASO.NUMERO_CASO%TYPE,
                                  Pv_Status     OUT VARCHAR2,
                                  Pv_Mensaje    OUT VARCHAR2);
  /**
   * Documentaci�n para proceso 'P_GENERAR_CASO'
   *
   * Procedimiento encargado de generar el caso
   *
   * @param Pr_InfoCaso   IN INFO_CASO%ROWTYPE Recibe el registro para crear el caso
   * @param Pv_TipoCaso   IN ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE Recibe el nombre del tipo de caso
   * @param Pn_Contador   IN OUT INTEGER Recibe y Retorna el contador del intento de generacion de caso
   * @param Pv_NumeroCaso IN OUT VARCHAR2 Recibe y Retorna el n�mero del caso generado
   * @param Pn_IdCaso     OUT INFO_CASO.ID_CASO%TYPE Retorna el id del caso generado
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    04-10-2021
   */
  PROCEDURE P_GENERAR_CASO(Pr_InfoCaso   IN INFO_CASO%ROWTYPE,
                           Pv_TipoCaso   IN ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                           Pn_Contador   IN OUT INTEGER,
                           Pv_NumeroCaso IN OUT VARCHAR2,
                           Pn_IdCaso     OUT INFO_CASO.ID_CASO%TYPE);                          

  /**
   * Documentaci�n para proceso 'P_INSERT_CASO_HISTORIAL'
   *
   * Procedimiento encargado de generar un historial de caso
   *
   * @param Pcl_Request         IN  CLOB Recibe json request
   * [
   *  idCaso        Id del caso,
   *  observacion   Observaci�n para el historial conforme al caso,
   *  estado        Estado con el que se crea el historial del caso,
   *  usuario       Usuario quien general el historial del caso,
   *  ip            Ip desde donde se genera el historial del caso
   * ]
   * @param Pn_IdCasoHistorial  OUT INFO_CASO_HISTORIAL.ID_CASO_HISTORIAL%TYPE Retorna id del historal del caso
   * @param Pv_Status           OUT VARCHAR2 Retorna estatus de la transacci�n
   * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    06-10-2021
   */
  PROCEDURE P_INSERT_CASO_HISTORIAL(Pcl_Request         IN CLOB,
                                    Pn_IdCasoHistorial  OUT INFO_CASO_HISTORIAL.ID_CASO_HISTORIAL%TYPE,
                                    Pv_Status           OUT VARCHAR2,
                                    Pv_Mensaje          OUT VARCHAR2);

  /**
   * Documentaci�n para proceso 'P_INSERT_DETALLE_HIPOTESIS'
   *
   * Procedimiento encargado de generar un detalle de hipotesis
   *
   * @param Pcl_Request           IN  CLOB Recibe json request
   * [
   *  idCaso        Id del caso,
   *  idSintoma     Id del sintoma con que se apertura el caso,
   *  observacion   Observaci�n para el detalle de hipotesis conforme al caso,
   *  estado        Estado con el que se crea el detalle de hipotesis del caso,
   *  usuario       Usuario quien genera el detalle de hipotesis del caso,
   *  ip            Ip desde donde se genera el detalle de hipotesis del caso
   * ]
   * @param Pn_IdDetalleHipotesis OUT INFO_DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS%TYPE Retorna id del detalle de hipotesis
   * @param Pv_Status             OUT VARCHAR2 Retorna estatus de la transacci�n
   * @param Pv_Mensaje            OUT VARCHAR2 Retorna mensaje de la transacci�n
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    06-10-2021
   */                                  
  PROCEDURE P_INSERT_DETALLE_HIPOTESIS(Pcl_Request           IN CLOB,
                                       Pn_IdDetalleHipotesis OUT INFO_DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS%TYPE,
                                       Pv_Status             OUT VARCHAR2,
                                       Pv_Mensaje            OUT VARCHAR2);
  
  /**
   * Documentaci�n para proceso 'P_INSERT_CASO_ASIGNACION'
   *
   * Procedimiento encargado de generar un caso asignacion
   *
   * @param Pcl_Request           IN  CLOB Recibe json request
   * [
   *  idDetalleHipotesis  Id de detalle de la Hipotesis,
   *  idAsignado          Id del asignado al caso (id del departamento),
   *  nombreAsignado      Nombre del asignado al caso (nombre del departamento),
   *  refIdAsignado       Referencia del id del asignado al caso (id persona),
   *  refNombreAsignado   Referencia del nombre del asignado al caso (nombre de persona),
   *  motivo              Motivo de la asignaci�n del caso,
   *  idPersonaEmpresaRol Id persona empresa rol del asignado al caso,
   *  usuario             Usuario quien genera la asignaci�n del caso,
   *  ip                  Ip desde donde se genera la asignaci�n del caso
   * ]
   * @param Pn_IdCasoAsignacion OUT INFO_CASO_ASIGNACION.ID_CASO_ASIGNACION%TYPE Retorna id del caso asignacion
   * @param Pv_Status           OUT VARCHAR2 Retorna estatus de la transacci�n
   * @param Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la transacci�n
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    12-11-2021
   */                                       
  PROCEDURE P_INSERT_CASO_ASIGNACION(Pcl_Request          IN CLOB,
                                     Pn_IdCasoAsignacion  OUT INFO_CASO_ASIGNACION.ID_CASO_ASIGNACION%TYPE,
                                     Pv_Status            OUT VARCHAR2,
                                     Pv_Mensaje           OUT VARCHAR2);                                  

END SPKG_CASOS_INSERT_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION AS


  PROCEDURE P_REINICIAR_SECUENCIAS_CASOS AS
  
    Ln_ValorSecuencia NUMBER;
  
    BEGIN
      
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_A.nextval FROM DUAL' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_A INCREMENT BY -' || Ln_ValorSecuencia || ' MINVALUE 0';
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_A.nextval from dual' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_A INCREMENT BY 1 MINVALUE 0';
      
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_B.nextval FROM DUAL' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_B INCREMENT BY -' || Ln_ValorSecuencia || ' MINVALUE 0';
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_B.nextval from dual' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_B INCREMENT BY 1 MINVALUE 0';
      
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_M.nextval FROM DUAL' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_M INCREMENT BY -' || Ln_ValorSecuencia || ' MINVALUE 0';
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_M.nextval from dual' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_M INCREMENT BY 1 MINVALUE 0';
      
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_T.nextval FROM DUAL' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_T INCREMENT BY -' || Ln_ValorSecuencia || ' MINVALUE 0';
      EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUM_CASO_T.nextval from dual' INTO Ln_ValorSecuencia;
      EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUM_CASO_T INCREMENT BY 1 MINVALUE 0';
      
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'SPKG_CASOS_INSERT_TRANSACCION', 
                                              'P_REINICIAR_SECUENCIAS_CASOS', 
                                              'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                              || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));   
  END P_REINICIAR_SECUENCIAS_CASOS;

  PROCEDURE P_OBTENER_NUMERO_CASO   (Pv_TipoCaso   IN Admi_Tipo_Caso.Nombre_Tipo_Caso%TYPE,
                                     Pv_NumeroCaso OUT Info_Caso.Numero_Caso%TYPE,
                                     Pv_Status     OUT VARCHAR2,
                                     Pv_Mensaje    OUT VARCHAR2) AS
      Lv_NumeroCaso   Info_Caso.Numero_Caso%TYPE;
      Lv_MensajeError VARCHAR2(200);
      Le_Error        Exception;
    BEGIN
    
      IF Pv_TipoCaso NOT IN ('Arcotel','Backbone','Movilizacion','Tecnico') THEN
        Lv_MensajeError := 'Tipo de Caso no permitido';
        RAISE Le_Error;
      END IF;
    
      CASE Pv_TipoCaso
         WHEN 'Arcotel' THEN
              EXECUTE IMMEDIATE 'select LPAD(DB_SOPORTE.SEQ_NUM_CASO_A.nextval,4,0)  || ''A'' from dual' into Lv_NumeroCaso;
          WHEN 'Backbone' THEN
              EXECUTE IMMEDIATE 'select LPAD(DB_SOPORTE.SEQ_NUM_CASO_B.nextval,4,0)  || ''B'' from dual' into Lv_NumeroCaso;
          WHEN 'Movilizacion' THEN
              EXECUTE IMMEDIATE 'select LPAD(DB_SOPORTE.SEQ_NUM_CASO_M.nextval,4,0)  || ''M'' from dual' into Lv_NumeroCaso;
          ELSE
              EXECUTE IMMEDIATE 'select LPAD(DB_SOPORTE.SEQ_NUM_CASO_T.nextval,4,0) from dual' into Lv_NumeroCaso;
      END CASE;
      
      Pv_NumeroCaso := TO_CHAR(SYSDATE,'RRRRMMDD') || '-' || Lv_NumeroCaso;
      Pv_Status :=  'EXITO';
    EXCEPTION
      WHEN Le_Error THEN
        Pv_NumeroCaso := '';
        Pv_Status :=  'ERROR';
        Pv_Mensaje := Lv_MensajeError;
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'SPKG_CASOS_INSERT_TRANSACCION', 
                                              'P_OBTENER_NUMERO_CASO', 
                                              'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                              || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        Pv_NumeroCaso := '';
        Pv_Status :=  'ERROR';
        Pv_Mensaje := 'Error general al obtener el n�mero de caso';
  END P_OBTENER_NUMERO_CASO;


  PROCEDURE P_GENERAR_CASO(Pr_InfoCaso   IN INFO_CASO%ROWTYPE,
                           Pv_TipoCaso   IN ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                           Pn_Contador   IN OUT INTEGER,
                           Pv_NumeroCaso IN OUT VARCHAR2,
                           Pn_IdCaso     OUT INFO_CASO.ID_CASO%TYPE) AS
     
                                         
                           
    Lv_TipoCaso   Admi_Tipo_Caso.Nombre_Tipo_Caso%TYPE; 
    Lv_NumeroCaso  Info_Caso.Numero_Caso%TYPE;
    Lv_Status    VARCHAR2(200);
    Lv_Mensaje   VARCHAR2(200);
    Ln_NumeroCasoBase   VARCHAR2(400) := 'N'; 
  BEGIN
  
    Lv_TipoCaso := Pv_TipoCaso;

    WHILE Pv_NumeroCaso = Ln_NumeroCasoBase LOOP
      
      SPKG_CASOS_INSERT_TRANSACCION.P_OBTENER_NUMERO_CASO(Lv_TipoCaso, Lv_NumeroCaso, Lv_Status, Lv_Mensaje);
      Pv_NumeroCaso := Lv_NumeroCaso;
      
    END LOOP;

    IF Pv_NumeroCaso <> 'N' THEN   
      INSERT INTO DB_SOPORTE.INFO_CASO 
        (ID_CASO,EMPRESA_COD,TIPO_CASO_ID,FORMA_CONTACTO_ID,NIVEL_CRITICIDAD_ID,NUMERO_CASO,TITULO_INI,VERSION_INI,
        FE_APERTURA,USR_CREACION,IP_CREACION,TIPO_AFECTACION,TIPO_BACKBONE,ORIGEN) 
      VALUES
        (DB_SOPORTE.SEQ_INFO_CASO.NEXTVAL,Pr_InfoCaso.Empresa_Cod,Pr_InfoCaso.Tipo_Caso_Id,Pr_InfoCaso.Forma_Contacto_Id,
        Pr_InfoCaso.Nivel_Criticidad_Id,Pv_NumeroCaso,Pr_InfoCaso.Titulo_Ini,Pr_InfoCaso.Version_Ini,Pr_InfoCaso.Fe_Apertura,
        Pr_InfoCaso.Usr_Creacion,Pr_InfoCaso.Ip_Creacion,Pr_InfoCaso.Tipo_Afectacion,Pr_InfoCaso.Tipo_Backbone,Pr_InfoCaso.Origen)
      RETURNING ID_CASO INTO Pn_IdCaso;
    END IF;

  EXCEPTION 
    WHEN OTHERS THEN  
      Pn_IdCaso   := NULL;
  END P_GENERAR_CASO;
  
  PROCEDURE P_INSERT_CASO_HISTORIAL(Pcl_Request         IN CLOB,
                                    Pn_IdCasoHistorial  OUT INFO_CASO_HISTORIAL.ID_CASO_HISTORIAL%TYPE,
                                    Pv_Status           OUT VARCHAR2,
                                    Pv_Mensaje          OUT VARCHAR2) AS                                    
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdCasoHistorial := SEQ_INFO_CASO_HISTORIAL.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_CASO_HISTORIAL 
      (ID_CASO_HISTORIAL,
      CASO_ID,OBSERVACION,
      ESTADO,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdCasoHistorial,
      APEX_JSON.get_number('idCaso'),
      APEX_JSON.get_clob('observacion'),
      APEX_JSON.get_varchar2('estado'),
      APEX_JSON.get_date('fechaCreacion'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Historial creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_CASO_HISTORIAL;
  
  PROCEDURE P_INSERT_DETALLE_HIPOTESIS(Pcl_Request           IN CLOB,
                                       Pn_IdDetalleHipotesis OUT INFO_DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS%TYPE,
                                       Pv_Status             OUT VARCHAR2,
                                       Pv_Mensaje            OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDetalleHipotesis := SEQ_INFO_DETALLE_HIPOTESIS.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_DETALLE_HIPOTESIS 
      (ID_DETALLE_HIPOTESIS,
      CASO_ID,
      SINTOMA_ID,
      HIPOTESIS_ID,
      OBSERVACION,
      ESTADO,
      USR_CREACION,
      IP_CREACION,
      FE_CREACION) 
    VALUES
      (Pn_IdDetalleHipotesis,
      APEX_JSON.get_number('idCaso'),
      APEX_JSON.get_number('idSintoma'),
      APEX_JSON.get_number('idHipotesis'),
      APEX_JSON.get_clob('observacion'),
      APEX_JSON.get_varchar2('estado'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'),
      SYSDATE);
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Detalle de hipotesis creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DETALLE_HIPOTESIS;
  
  PROCEDURE P_INSERT_CASO_ASIGNACION(Pcl_Request          IN CLOB,
                                     Pn_IdCasoAsignacion  OUT INFO_CASO_ASIGNACION.ID_CASO_ASIGNACION%TYPE,
                                     Pv_Status            OUT VARCHAR2,
                                     Pv_Mensaje           OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdCasoAsignacion := SEQ_INFO_CASO_ASIGNACION.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_CASO_ASIGNACION 
      (ID_CASO_ASIGNACION,
      DETALLE_HIPOTESIS_ID,
      ASIGNADO_ID,
      ASIGNADO_NOMBRE,
      REF_ASIGNADO_ID,
      REF_ASIGNADO_NOMBRE,
      MOTIVO,
      PERSONA_EMPRESA_ROL_ID,
      USR_CREACION,
      IP_CREACION,
      FE_CREACION) 
    VALUES
      (Pn_IdCasoAsignacion,
      APEX_JSON.get_number('idDetalleHipotesis'),
      APEX_JSON.get_number('idAsignado'),
      APEX_JSON.get_varchar2('nombreAsignado'),
      APEX_JSON.get_number('refIdAsignado'),
      APEX_JSON.get_varchar2('refNombreAsignado'),
      APEX_JSON.get_clob('motivo'),
      APEX_JSON.get_number('idPersonaEmpresaRol'),
      SUBSTR(APEX_JSON.get_varchar2('usuario'),1,15),
      APEX_JSON.get_varchar2('ip'),
      SYSDATE);
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Caso asignacion creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_CASO_ASIGNACION;
  
END SPKG_CASOS_INSERT_TRANSACCION;
/