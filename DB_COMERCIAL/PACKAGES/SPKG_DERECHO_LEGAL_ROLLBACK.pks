/**
 * DEBE EJECUTARSE EN DB_COMERCIAL.
 * Rollback derecho_legal
 * @author William Sanchez Fernández <wdsanchez@telconet.ec>
 * @version 1.0 14-02-2022 - Versión Inicial.
 */

SET DEFINE OFF;
create or replace package DB_COMERCIAL.SPKG_DERECHO_LEGAL is

  
  
  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * VALIDAR_CARACT_USUARIO_CIFRADO
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_USU_CLIENTE(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);
                                            

 /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * VALIDAR_CARACT_USUARIO_CIFRADO
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_CARACT_CIFRADO(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);
                                            
                                            
                                            
  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * P_VALIDAR_DEUDAS
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_DEUDAS(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB); 
                                            
                                            
                                            
   /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * VALIDAR_CARACT_USUARIO_CIFRADO
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_SERVICIOS_CNL(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);   
                                            
                                            
  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * P_VALIDAR_EQUIPOS
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_EQUIPOS(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);     
                                            
                                            

  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * VALIDAR_CARACT_USUARIO_CIFRADO
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_VALIDAR_GENERAL_ENCRYPT(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);                                                 

  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * VALIDAR_CARACT_USUARIO_CIFRADO
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_GET_DATA_CIFRAR (Pv_IdentificacionCliente IN DB_COMERCIAL.INFO_PERSONA.identificacion_cliente%TYPE, 
                             Pcl_Resultado OUT CLOB);    
                             
                             
                             

  /**
 * Documentación para TYPE 'SPKG_DERECHO_LEGAL'.
 *
 * P_GET_DATA_CIFRAR
 * Procedimiento para validacion de estado cifrado para clientes.
 * @since 1.0
 * @author William Sanchez <wdsanchez@telconet.ec>
*/
PROCEDURE P_CLI_DATA_CIFRAR (Pcl_Request IN CLOB,
                             Pcl_Resultado OUT CLOB);    




END SPKG_DERECHO_LEGAL;
/
create or replace PACKAGE BODY DB_COMERCIAL.SPKG_DERECHO_LEGAL AS

  PROCEDURE P_VALIDAR_USU_CLIENTE(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB) AS
                                            
  Lv_Identificacion      VARCHAR2(50);   
  Lv_IdPersona           VARCHAR2(50); 
  Lv_PersonaEmpRol       VARCHAR2(50);  
  
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lcl_Response           SYS_REFCURSOR;
  Le_Errors              EXCEPTION; 
  
  
  
  --costo: 11
  CURSOR C_GET_CLIENTE_VALIDO(Cv_identificacion VARCHAR2) IS
        SELECT
        IPE.ID_PERSONA,IPER.ID_PERSONA_ROL
        FROM DB_COMERCIAL.INFO_PERSONA IPE
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPE.ID_PERSONA = IPER.PERSONA_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
        WHERE /*IPER.ESTADO    = 'Activo'
          AND*/ IPE.IDENTIFICACION_CLIENTE = Cv_identificacion
          AND IER.EMPRESA_COD = '18'
          AND AR.ID_ROL = '1'
          and rownum < 2;
                                            
  BEGIN
  
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Pv_Status := 'OK';
  
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_USU_CLIENTE',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
   
   
   IF C_GET_CLIENTE_VALIDO%ISOPEN THEN
                    CLOSE C_GET_CLIENTE_VALIDO;
                END IF;
                OPEN C_GET_CLIENTE_VALIDO(Lv_Identificacion);
                FETCH C_GET_CLIENTE_VALIDO INTO Lv_IdPersona, Lv_PersonaEmpRol;
                
     IF  Lv_IdPersona IS NOT NULL THEN
     
      Lv_Retorno := '000';
      Lv_Error := 'Exito.';
      Pv_Mensaje := 'Exito.';
     
     
     Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';
     
     
     ELSE 
     
      Lv_Retorno := '001';
      Lv_Error := 'La identificación no pertenece a un cliente.';
      Pv_Mensaje := 'La identificación no pertenece a un cliente.';
      Pv_Status := 'ERROR';
      
      
      Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';
      
      
     
     END IF;
     
     
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_VALIDAR_USU_CLIENTE',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    
    
    EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_USU_CLIENTE',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';
    
  END P_VALIDAR_USU_CLIENTE;
  
  
  PROCEDURE P_VALIDAR_CARACT_CIFRADO(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)  AS 
                                            
                                          
  Lv_Identificacion      VARCHAR2(50);   
  Lv_IdPersona           VARCHAR2(50); 
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lcl_Response           SYS_REFCURSOR;
  Le_Errors              EXCEPTION; 
  
  --costo: 10
  CURSOR C_GET_CLIENTE_CARACT(Cv_identificacion VARCHAR2) IS
   select IP.ID_PERSONA from 
      DB_COMERCIAL.INFO_PERSONA IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
   where 
        IP.IDENTIFICACION_CLIENTE = Cv_identificacion
    AND IP.ID_PERSONA = IPER.PERSONA_ID
    AND IPERC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPERC.ESTADO = 'Activo'
    /*AND IPER.ESTADO = 'Activo'*/
    AND IPERC.CARACTERISTICA_ID = CA.ID_CARACTERISTICA
    AND CA.estado = 'Activo'
    AND CA.DESCRIPCION_CARACTERISTICA = 'CLIENTE CIFRADO'
    AND IPERC.VALOR = 'Y'
    and rownum < 2; 
                                            
   BEGIN                                         
               
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Pv_Status := 'OK';
  
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_CARACT_CIFRADO',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );    
                                          
                                          
      IF C_GET_CLIENTE_CARACT%ISOPEN THEN
                    CLOSE C_GET_CLIENTE_CARACT;
                END IF;
                OPEN C_GET_CLIENTE_CARACT(Lv_Identificacion);
                FETCH C_GET_CLIENTE_CARACT INTO Lv_IdPersona;
                
                
       IF  Lv_IdPersona IS NOT NULL THEN
       
        Lv_Retorno := '004';
        Lv_Error := 'El cliente ya se encuentra eliminado/encriptado.';
        Pv_Mensaje := 'El cliente ya se encuentra eliminado/encriptado.';
       
       
         Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';
       
        ELSE
       
       
        Lv_Retorno := '005';
        Lv_Error := 'La identificación no pertenece a un cliente encriptado/eliminado.';
        Pv_Mensaje := 'La identificación no pertenece a un cliente encriptado/eliminado.';
       
       
         Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';
       
       
       END IF;
       
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_VALIDAR_CARACT_CIFRADO',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
       
       
       EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_CARACT_CIFRADO',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';
    
    END P_VALIDAR_CARACT_CIFRADO;       
    
    
  PROCEDURE P_VALIDAR_DEUDAS(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)  AS 
                                            
                                          
  Lv_Identificacion      VARCHAR2(50);   
  Lv_EmpresaCod          VARCHAR2(50);  
  
  Lv_IdPersona           VARCHAR2(50); 
  Lv_Identificacion2     VARCHAR2(50); 
  Lv_RazonSocial         VARCHAR2(4000); 
  Lv_Nombres             VARCHAR2(400);
  Lv_Apellidos           VARCHAR2(400);
  Ln_Saldo               NUMBER;
  Ln_SaldoTotal          NUMBER;
  
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lcl_Response           SYS_REFCURSOR;
  Le_Errors              EXCEPTION; 
  
  

                                            
   BEGIN                                         
               
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoEmpresa'); 
     Pv_Status := 'OK';
  
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_DEUDAS',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );    
                                          
                                          
      
       Lcl_Response := DB_FINANCIERO.FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_POR_IDENTIF(Lv_Identificacion, Lv_EmpresaCod);
       
       FETCH Lcl_Response INTO Lv_IdPersona, Lv_Identificacion2, Lv_RazonSocial, Lv_Nombres, Lv_Apellidos, Ln_Saldo;
       
       
       IF Ln_Saldo IS NULL THEN 
        Ln_SaldoTotal:=0;
       ELSE
        Ln_SaldoTotal := ROUND(Ln_Saldo, 4);
       END IF;
       
       IF Ln_SaldoTotal > 0 THEN
       
           Lv_Retorno := '007';
           Lv_Error := 'El cliente no cumple las condiciones de eliminación ya que tiene deudas pendientes.';
           
           
           Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';

                Pv_Status := 'ERROR';
                Pv_Mensaje := 'El cliente no cumple las condiciones de eliminación ya que tiene deudas pendientes.';
           
       
       ELSE 
       
           Lv_Retorno := '000';
           Lv_Error := 'Exito.';
           
            Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';

             Pv_Status     := 'OK';
             Pv_Mensaje    := 'Transacción exitosa';
        
       END IF;
       
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_VALIDAR_DEUDAS',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      
      
       EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_DEUDAS',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';
    
    END P_VALIDAR_DEUDAS;
    
    
    
     PROCEDURE P_VALIDAR_SERVICIOS_CNL(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)  AS 
                                            
                                          
  Lv_Identificacion      VARCHAR2(50);   
  Lv_EmpresaCod          VARCHAR2(50);  
  Lv_PersonaEmpRol       VARCHAR2(50);  
  
  Lv_IdServicio          VARCHAR2(50); 
  Lv_Estado            VARCHAR2(50); 
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lb_banderaSer          BOOLEAN :=true; 
  Lcl_Response           SYS_REFCURSOR;
  Le_Errors              EXCEPTION; 
  
   TYPE typ_rec   IS RECORD
        (
          ID_SERVICIO      VARCHAR2(50),
          ESTADO          VARCHAR2(50)
        );
        
  TYPE Te_Servicio IS TABLE OF typ_rec INDEX BY PLS_INTEGER;
   Le_Servicio Te_Servicio; 
   
   Li_Limit                    CONSTANT PLS_INTEGER DEFAULT 50;    
   Li_Cont_Servicio            PLS_INTEGER;
  
  --costo: 12
   CURSOR C_GET_CLIENTE_SERVI(Cv_identificacion VARCHAR2) IS
            select IFO.ID_SERVICIO,IFO.ESTADO
        from DB_COMERCIAL.INFO_PERSONA  IP,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
             DB_COMERCIAL.INFO_PUNTO IPU,
             DB_COMERCIAL.INFO_SERVICIO IFO,
             DB_COMERCIAL.INFO_PLAN_DET IPLAN,
             DB_COMERCIAL.ADMI_PRODUCTO ADMP
      where
           IP.IDENTIFICACION_CLIENTE = Cv_identificacion
       and IPER.PERSONA_ID = IP.ID_PERSONA
       and EMP.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
       and IPER.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
       and IPU.ID_PUNTO = IFO.PUNTO_ID 
       and IFO.PLAN_ID = IPLAN.PLAN_ID
       and IPLAN.PRODUCTO_ID = ADMP.ID_PRODUCTO
       and ADMP.NOMBRE_TECNICO = 'INTERNET'
       and EMP.EMPRESA_COD = '18'
       group by IFO.ID_SERVICIO,IFO.ESTADO; 
  
  

                                            
   BEGIN                                         
               
   
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Lv_PersonaEmpRol   := APEX_JSON.get_varchar2(p_path => 'personaEmpRol'); 
     Lv_EmpresaCod      := APEX_JSON.get_varchar2(p_path => 'codigoEmpresa'); 
     Pv_Status := 'OK';
  
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.C_GET_CLIENTE_SERVI',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );    
                                          
                                          
     
        IF C_GET_CLIENTE_SERVI%ISOPEN THEN
            CLOSE C_GET_CLIENTE_SERVI;
        END IF;
        OPEN C_GET_CLIENTE_SERVI(Lv_Identificacion);         
         
         FETCH C_GET_CLIENTE_SERVI BULK COLLECT INTO Le_Servicio LIMIT Li_Limit;
         Li_Cont_Servicio := Le_Servicio.FIRST;
      
       WHILE (Li_Cont_Servicio IS NOT NULL) LOOP  
            Lv_IdServicio:=  Le_Servicio(Li_Cont_Servicio).ID_SERVICIO; 
            Lv_Estado:=  Le_Servicio(Li_Cont_Servicio).ESTADO; 
            
            IF upper(Lv_Estado) not in ('CANCEL','CANCELADO') THEN
             Lb_banderaSer:=false; 
            END IF; 
            
            
           EXIT WHEN Lb_banderaSer=false;  
           Li_Cont_Servicio := Le_Servicio.NEXT(Li_Cont_Servicio);
      END LOOP;     
       
       
       IF Lb_banderaSer != true THEN 
       
           Lv_Retorno := '006';
           Lv_Error := 'El cliente no cumple las condiciones de eliminación ya que no tiene todos los servicios cancelados';
           
           
           Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';

                Pv_Status := 'ERROR';
                Pv_Mensaje := 'El cliente no cumple las condiciones de eliminación ya que no tiene todos los servicios cancelados';
           
       
       ELSE 
       
           Lv_Retorno := '000';
           Lv_Error := 'Exito.';
           
              
           Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';

             Pv_Status     := 'OK';
             Pv_Mensaje    := 'Transacción exitosa';
        
       END IF;
       
       
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.C_GET_CLIENTE_SERVI',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      
      
      EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.C_GET_CLIENTE_SERVI',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';  
    
    END P_VALIDAR_SERVICIOS_CNL;
    
    
      PROCEDURE P_VALIDAR_EQUIPOS(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)  AS  
                                            
  
   TYPE typ_rec   IS RECORD
        (
          ID_PUNTO      VARCHAR2(20)
        );
        
        
        TYPE typ_rec2   IS RECORD
        (
          TAREA_ID  VARCHAR2(20),
          ESTADO_TAREA  VARCHAR2(20),
          ESTADO VARCHAR2(20)
        );
  
  Lv_Identificacion      VARCHAR2(50);   
  Lv_EmpresaCod          VARCHAR2(50);  
  Lv_PersonaEmpRol       VARCHAR2(50);    
   
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lcl_Response           SYS_REFCURSOR;
  Lv_IdPunto             VARCHAR2(20); 
  
   Lv_IdTarea            VARCHAR2(20); 
   Lv_EstadoTarea        VARCHAR2(50); 
   Lv_Estado             VARCHAR2(20); 
  
  Lv_param_TareaEntrega VARCHAR2(50);
  Lv_param_TareaPago VARCHAR2(50);
  Lv_param_Bandera VARCHAR2(50);
  Lb_bandera_vali boolean := false;
  
  Le_Errors              EXCEPTION; 
  
  TYPE Te_IdPunto IS TABLE OF typ_rec INDEX BY PLS_INTEGER;
  Le_Punto Te_IdPunto;
  
  TYPE Te_IdTarea IS TABLE OF typ_rec2 INDEX BY PLS_INTEGER;
  Le_Tarea Te_IdTarea;
  
  Li_Limit              CONSTANT PLS_INTEGER DEFAULT 50;    
  Li_Cont_Punto         PLS_INTEGER;
  Li_Cont_Tarea         PLS_INTEGER;
  
     --costo: 12
    CURSOR C_GET_CLIENTE_PUNTO(Cv_identificacion VARCHAR2) IS
            select IPU.ID_PUNTO
        from DB_COMERCIAL.INFO_PERSONA  IP,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
             DB_COMERCIAL.INFO_PUNTO IPU,
             DB_COMERCIAL.INFO_SERVICIO IFO,
             DB_COMERCIAL.INFO_PLAN_DET IPLAN,
             DB_COMERCIAL.ADMI_PRODUCTO ADMP
      where
           IP.IDENTIFICACION_CLIENTE = Cv_identificacion
       and EMP.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID 
       and IPER.PERSONA_ID = IP.ID_PERSONA
       and IPER.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
       and IPU.ID_PUNTO = IFO.PUNTO_ID 
       and IFO.PLAN_ID = IPLAN.PLAN_ID
       and IPLAN.PRODUCTO_ID = ADMP.ID_PRODUCTO
       and ADMP.NOMBRE_TECNICO = 'INTERNET'
       and EMP.EMPRESA_COD = '18'
       group by IPU.ID_PUNTO; 
       
       --costo: 5
    CURSOR C_GET_PARAM_SOL_ENTREGA IS
    select det.valor2 from DB_GENERAL.ADMI_PARAMETRO_DET det
     where det.PARAMETRO_ID in (
    SELECT ID_PARAMETRO 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
     WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'
      )
      AND DESCRIPCION = 'TAREA_ENTREGA_EQUIPO';       
       
     --costo: 5   
    CURSOR C_GET_PARAM_SOL_PAGO IS
    select det.valor2 from DB_GENERAL.ADMI_PARAMETRO_DET det
     where det.PARAMETRO_ID in (
    SELECT ID_PARAMETRO 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
     WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'
      )
      AND DESCRIPCION = 'TAREA_PAGO_EQUIPO';  
       
       
      
      --BANDERA_FINALIZA_TAREA
       --costo: 5
      CURSOR C_GET_PARAM_BANDERA IS
    select det.valor2 from DB_GENERAL.ADMI_PARAMETRO_DET det
     where det.PARAMETRO_ID in (
    SELECT ID_PARAMETRO 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
     WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'
      )
      AND DESCRIPCION = 'BANDERA_FINALIZA_TAREA';   
 
  --costo: 12
   CURSOR C_GET_VALIDA_SOL_ENTREGA(Cv_idPunto VARCHAR2) IS 
       SELECT
        (
            SELECT
                idet.tarea_id
            FROM
                db_soporte.info_detalle idet
            WHERE
                idet.id_detalle = a.detalle_id
        ) AS tarea_id,
        (
            SELECT
                estado
            FROM
                db_soporte.info_detalle_historial idh
            WHERE
                    idh.detalle_id = a.detalle_id
                AND idh.id_detalle_historial = (
                    SELECT
                        MAX(idh2.id_detalle_historial)
                    FROM
                        db_soporte.info_detalle_historial idh2
                    WHERE
                        idh2.detalle_id = idh.detalle_id
                )
        ) AS estado_tarea,
        a.ESTADO
    FROM
        db_comunicacion.info_comunicacion a
    WHERE
        a.remitente_id = Cv_idPunto
    ORDER BY
        a.id_comunicacion DESC;
           
   BEGIN
   
      DBMS_OUTPUT.PUT_LINE('Inicio validacion');
   
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Lv_PersonaEmpRol   := APEX_JSON.get_varchar2(p_path => 'personaEmpRol'); 
     Lv_EmpresaCod      := APEX_JSON.get_varchar2(p_path => 'codigoEmpresa'); 
     Pv_Status := 'OK';
     
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_EQUIPOS',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );   
                                          
      IF C_GET_PARAM_SOL_ENTREGA%ISOPEN THEN
         CLOSE C_GET_PARAM_SOL_ENTREGA;
         END IF;
         OPEN C_GET_PARAM_SOL_ENTREGA;
        FETCH C_GET_PARAM_SOL_ENTREGA INTO Lv_param_TareaEntrega; 
        
        DBMS_OUTPUT.PUT_LINE('Param 1 '||Lv_param_TareaEntrega);
        
      IF C_GET_PARAM_SOL_PAGO%ISOPEN THEN
         CLOSE C_GET_PARAM_SOL_PAGO;
         END IF;
         OPEN C_GET_PARAM_SOL_PAGO;
        FETCH C_GET_PARAM_SOL_PAGO INTO Lv_param_TareaPago; 
        
         DBMS_OUTPUT.PUT_LINE('Param 2 '||Lv_param_TareaPago);
        
      IF C_GET_PARAM_BANDERA%ISOPEN THEN
         CLOSE C_GET_PARAM_BANDERA;
         END IF;
         OPEN C_GET_PARAM_BANDERA;
        FETCH C_GET_PARAM_BANDERA INTO Lv_param_Bandera;  
        
         DBMS_OUTPUT.PUT_LINE('Param 3 '||Lv_param_Bandera);
           
           
       
       
       IF C_GET_CLIENTE_PUNTO%ISOPEN THEN
            CLOSE C_GET_CLIENTE_PUNTO;
        END IF;
        OPEN C_GET_CLIENTE_PUNTO(Lv_Identificacion);
        
       FETCH C_GET_CLIENTE_PUNTO BULK COLLECT INTO Le_Punto LIMIT Li_Limit;
        Li_Cont_Punto := Le_Punto.FIRST;
      
       WHILE (Li_Cont_Punto IS NOT NULL) LOOP  
            Lv_IdPunto:=  Le_Punto(Li_Cont_Punto).ID_PUNTO;  
           
           DBMS_OUTPUT.PUT_LINE('Id Punto: '||Lv_IdPunto);
           Lb_bandera_vali := false;
           
           
           IF C_GET_VALIDA_SOL_ENTREGA%ISOPEN THEN
            CLOSE C_GET_VALIDA_SOL_ENTREGA;
        END IF;
        OPEN C_GET_VALIDA_SOL_ENTREGA(Lv_IdPunto);
           
           FETCH C_GET_VALIDA_SOL_ENTREGA BULK COLLECT INTO Le_Tarea LIMIT Li_Limit;
           Li_Cont_Tarea := Le_Tarea.FIRST;
      
       WHILE (Li_Cont_Tarea IS NOT NULL) LOOP  
            Lv_IdTarea:=  Le_Tarea(Li_Cont_Tarea).TAREA_ID; 
            Lv_EstadoTarea:=  Le_Tarea(Li_Cont_Tarea).ESTADO_TAREA; 
           
             
            IF Lv_IdTarea in (Lv_param_TareaEntrega,Lv_param_TareaPago) AND Lv_param_Bandera in ('S') AND Lv_EstadoTarea = 'Finalizada' THEN
              
              Lb_bandera_vali := true;
               DBMS_OUTPUT.PUT_LINE('Equipo entregado a punto: '||Lv_IdPunto);
              
            END IF;
             
            IF Lv_IdTarea in (Lv_param_TareaEntrega,Lv_param_TareaPago) AND NOT Lv_param_Bandera in ('S') THEN
              
               Lb_bandera_vali := true;
               DBMS_OUTPUT.PUT_LINE('Equipo entregado a punto: '||Lv_IdPunto);
              
            END IF;
            
            Li_Cont_Tarea := Le_Tarea.NEXT(Li_Cont_Tarea);
        END LOOP;
          
           
            EXIT WHEN Lb_bandera_vali=false; 
      
          Li_Cont_Punto := Le_Punto.NEXT(Li_Cont_Punto);
        END LOOP;
           
           
           IF Lb_bandera_vali THEN
              
            DBMS_OUTPUT.PUT_LINE('Todo entregado');
            
             Lv_Retorno := '000';
             Lv_Error := 'Exito.';
             
             Pv_Status     := 'OK';
             Pv_Mensaje    := 'Transacción exitosa'; 
              
            ELSE
            
            DBMS_OUTPUT.PUT_LINE('Falta entregar algo');
            
             Lv_Retorno := '008';
             Lv_Error := 'El cliente no cumple las condiciones de eliminacion ya que tiene pendiente la entrega de equipos';
             
             Pv_Status     := 'ERROR';
             Pv_Mensaje    := 'El cliente no cumple las condiciones de eliminacion ya que tiene pendiente la entrega de equipos';
           
           END IF;
           
           
              
           Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';

              
           
                                          
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_VALIDAR_EQUIPOS',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );                                  
   
    DBMS_OUTPUT.PUT_LINE('Fin validacion');
   
   EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_EQUIPOS',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';  
   
   END P_VALIDAR_EQUIPOS;
   
   
   
   
   PROCEDURE P_VALIDAR_GENERAL_ENCRYPT(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)  AS   
  
  Lv_Identificacion      VARCHAR2(50);   
  Lv_EmpresaCod          VARCHAR2(50);  
  Lv_PersonaEmpRol       VARCHAR2(50);  
  
  Lvl_Request_local      CLOB; 
  
  Lv_Retorno             VARCHAR2(3);
  Lv_Error               VARCHAR2(4000);
  Lcl_Response           SYS_REFCURSOR;
  Le_Errors              EXCEPTION; 
  lb_bandera             BOOLEAN;
  
  BEGIN     
  
      lb_bandera := TRUE;
              
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_GENERAL_ENCRYPT',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 
        --1er validar eliminado/encriptado
        
        P_VALIDAR_CARACT_CIFRADO(Pcl_Request,
                                          Pv_Status,
                                          Pv_Mensaje,
                                          Pcl_Response);
        
       APEX_JSON.PARSE(Pcl_Response);
       Lv_Retorno  := UPPER(APEX_JSON.get_varchar2(p_path => 'retorno'));
       Lv_Error  := UPPER(APEX_JSON.get_varchar2(p_path => 'error'));
       Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacion'));
       
       --005 cliente no encriptado
       IF Lv_Retorno = '004' THEN   
          lb_bandera := FALSE;
       END IF;
        
        --2do validar servicios cancelados
        
        IF lb_bandera = TRUE THEN
        
        P_VALIDAR_SERVICIOS_CNL(Pcl_Request,
                                          Pv_Status,
                                          Pv_Mensaje,
                                          Pcl_Response);
        
        
         APEX_JSON.PARSE(Pcl_Response);
         Lv_Retorno  := UPPER(APEX_JSON.get_varchar2(p_path => 'retorno'));
         Lv_Error  := UPPER(APEX_JSON.get_varchar2(p_path => 'error'));
         Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacion'));
         
           IF Lv_Retorno != '000' THEN   
            lb_bandera := FALSE;
          END IF;
        
        END IF;
        
        
        --3ro validar deudas
        
        IF lb_bandera = TRUE THEN
        
        P_VALIDAR_DEUDAS(Pcl_Request,
                                          Pv_Status,
                                          Pv_Mensaje,
                                          Pcl_Response);
        
        
         APEX_JSON.PARSE(Pcl_Response);
         Lv_Retorno  := UPPER(APEX_JSON.get_varchar2(p_path => 'retorno'));
         Lv_Error  := UPPER(APEX_JSON.get_varchar2(p_path => 'error'));
         Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacion'));
         
          IF Lv_Retorno != '000' THEN   
            lb_bandera := FALSE;
          END IF;
        
        END IF;
        
        --4to validar entrega pendiente
        
        
        IF lb_bandera = TRUE THEN
        
        P_VALIDAR_EQUIPOS(Pcl_Request,
                                          Pv_Status,
                                          Pv_Mensaje,
                                          Pcl_Response);
        
        
         APEX_JSON.PARSE(Pcl_Response);
         Lv_Retorno  := UPPER(APEX_JSON.get_varchar2(p_path => 'retorno'));
         Lv_Error  := UPPER(APEX_JSON.get_varchar2(p_path => 'error'));
         Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacion'));
         
           IF Lv_Retorno != '000' THEN   
            lb_bandera := FALSE;
            ELSE
          
            Lv_Retorno := '000';
            Lv_Error := 'Exito.';
            
            
            Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"identificacion":"' || Lv_Identificacion || '"' 
                                || '}';
 
          END IF;
        
        END IF;
                                          
                                          
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_VALIDAR_GENERAL_ENCRYPT',
                                          SUBSTR('RESPONSE:'||Pcl_Response,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );                                       
              
   EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_GENERAL_ENCRYPT',
                                          'Problemas al consultar el estado del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';  

   END P_VALIDAR_GENERAL_ENCRYPT;
   
   PROCEDURE P_GET_DATA_CIFRAR (Pv_IdentificacionCliente IN DB_COMERCIAL.INFO_PERSONA.identificacion_cliente%TYPE, 
                                Pcl_Resultado OUT CLOB)  AS          
    Lrf_Persona                 SYS_REFCURSOR;
    Lrf_Puntos                  SYS_REFCURSOR;
    Lrf_FormasContactoPuntos    SYS_REFCURSOR;
    Lrf_FormasContactoPersona   SYS_REFCURSOR;
    Lrf_DatosFormaPago          SYS_REFCURSOR;
    Lrf_RepresentanteLegal      SYS_REFCURSOR;
    Lrf_DatosContratoFormaPago  SYS_REFCURSOR;
    Lcl_Persona                 CLOB;
    Le_Errors                   EXCEPTION;
    Lv_Retorno                  VARCHAR2(3);
    Lv_Error                    VARCHAR2(4000);
    
  BEGIN     
    --costo: 5
    OPEN Lrf_Persona FOR
    SELECT ipe.id_persona,
       ipe.nombres,
       ipe.apellidos,
       ipe.nacionalidad,
       ipe.genero,
       ipe.numero_conadis,
       ipe.tipo_empresa,
       ipe.tipo_tributario,
       ipe.titulo_id,
       ipe.razon_social,
       ipe.estado_civil,
       ipe.origen_ingresos,
       ipe.fecha_nacimiento,
       ipe.direccion,
       ipe.direccion_tributaria,
       ipe.representante_legal
    FROM DB_COMERCIAL.INFO_PERSONA ipe
    WHERE 
        ipe.identificacion_cliente = Pv_IdentificacionCliente;
    
    --costo: 13
    OPEN Lrf_Puntos FOR SELECT ipu.id_punto, 
       ipu.direccion, 
       ipu.descripcion_punto,
       ipu.NOMBRE_PUNTO,
       ipu.TIPO_UBICACION_ID,
       ipu.SECTOR_ID,
       ipu.longitud,
       ipu.latitud
         FROM DB_COMERCIAL.info_punto ipu, 
              DB_COMERCIAL.info_persona iper,
              DB_COMERCIAL.info_persona_empresa_rol ipero,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE
         iper.identificacion_cliente = Pv_IdentificacionCliente
         AND iper.id_persona = ipero.persona_id
         AND ipu.persona_empresa_rol_id = ipero.id_persona_rol
         AND EMP.ID_EMPRESA_ROL = ipero.empresa_rol_id
         AND EMP.EMPRESA_COD = '18'
         ;
    --
    --costo: 13
    OPEN Lrf_FormasContactoPuntos FOR SELECT ipfc.id_punto_forma_contacto,
       ipfc.valor
         FROM DB_COMERCIAL.info_punto ipu, 
              DB_COMERCIAL.info_persona iper,
              DB_COMERCIAL.info_persona_empresa_rol ipero,
              DB_COMERCIAL.info_punto_forma_contacto ipfc,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE
         iper.identificacion_cliente = Pv_IdentificacionCliente
         AND iper.id_persona = ipero.persona_id
         AND ipu.persona_empresa_rol_id = ipero.id_persona_rol
         AND ipfc.punto_id = ipu.id_punto
         AND ipfc.forma_contacto_id IN (5,45,218,215,26,8,25,7,27,212,214,4)
         AND EMP.ID_EMPRESA_ROL = ipero.empresa_rol_id
         AND EMP.EMPRESA_COD = '18'
         ;
    --
    --costo: 9
    OPEN Lrf_FormasContactoPersona FOR SELECT ipfc.id_persona_forma_contacto,
                ipfc.valor
         FROM DB_COMERCIAL.info_persona ip,
              DB_COMERCIAL.info_persona_forma_contacto ipfc,
              DB_COMERCIAL.info_persona_empresa_rol iper,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE
         ip.identificacion_cliente = Pv_IdentificacionCliente
         AND ipfc.persona_id = ip.id_persona
         AND ipfc.forma_contacto_id IN (5,45,218,215,26,8,25,7,27,212,214,4)
         AND iper.persona_id = ip.id_persona
         AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
         AND EMP.EMPRESA_COD = '18';
    --
    --costo: 14
    OPEN Lrf_DatosFormaPago FOR SELECT ico.id_contrato,
       ico.forma_pago_id
     FROM DB_COMERCIAL.info_persona ipe,
          DB_COMERCIAL.info_persona_empresa_rol iper,
          DB_COMERCIAL.info_contrato ico,
          DB_COMERCIAL.INFO_EMPRESA_ROL EMP
     WHERE ipe.identificacion_cliente = Pv_IdentificacionCliente
     AND iper.persona_id = ipe.id_persona
     AND ico.persona_empresa_rol_id = iper.id_persona_rol
     AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
     AND EMP.EMPRESA_COD = '18'
     ;
    --
    
    --costo: 13
     OPEN Lrf_DatosContratoFormaPago FOR SELECT ifo.ID_DATOS_PAGO,
               ifo.BANCO_TIPO_CUENTA_ID,
               ifo.titular_cuenta,
               ifo.anio_vencimiento,
               ifo.mes_vencimiento,
               ifo.TIPO_CUENTA_ID
     FROM DB_COMERCIAL.info_persona ipe,
          DB_COMERCIAL.info_persona_empresa_rol iper,
          DB_COMERCIAL.info_contrato ico,
          DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ifo
     WHERE ipe.identificacion_cliente = Pv_IdentificacionCliente
     AND iper.persona_id = ipe.id_persona
     AND ico.persona_empresa_rol_id = iper.id_persona_rol
     AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
     AND EMP.EMPRESA_COD = '18'
     AND ifo.contrato_id = ico.id_contrato ;
    --
    
    --costo: 10
    OPEN Lrf_RepresentanteLegal FOR SELECT ipre.id_persona_representante,
       ipre.representante_empresa_rol_id
         FROM DB_COMERCIAL.info_persona ipe ,
              DB_COMERCIAL.info_persona_empresa_rol iper,
              DB_COMERCIAL.info_persona_representante ipre,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE ipe.identificacion_cliente = Pv_IdentificacionCliente
         AND iper.persona_id = ipe.id_persona
         AND ipre.persona_empresa_rol_id = iper.id_persona_rol
         AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
         AND EMP.EMPRESA_COD = '18'
         ;
    --    
    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object;
    APEX_JSON.write('IDENTIFICACION_CLIENTE', Pv_IdentificacionCliente);
    APEX_JSON.write('DB_COMERCIAL.INFO_PERSONA', Lrf_Persona);
    APEX_JSON.write('DB_COMERCIAL.INFO_PUNTO', Lrf_Puntos);
    APEX_JSON.write('DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO', Lrf_FormasContactoPersona);
    APEX_JSON.write('DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO', Lrf_FormasContactoPuntos);
    APEX_JSON.write('DB_COMERCIAL.INFO_CONTRATO', Lrf_DatosFormaPago);
    APEX_JSON.write('DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE', Lrf_RepresentanteLegal);
    APEX_JSON.write('DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO', Lrf_DatosContratoFormaPago);
    APEX_JSON.close_object;
    Pcl_Resultado := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.free_output;
   
   EXCEPTION
    WHEN Le_Errors THEN
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            APEX_JSON.write('error','Ocurrio un error al buscar' );
            APEX_JSON.close_object;
            Pcl_Resultado := APEX_JSON.GET_CLOB_OUTPUT;
            APEX_JSON.free_output;
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_VALIDAR_GENERAL_ENCRYPT',
                                          'Problemas al consultar la data a cifrar. Parametros ('||Pv_IdentificacionCliente||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pcl_Resultado  := '{' ||
                                '"RETORNO":"' || Lv_Retorno || '",' ||
                                '"ERROR":"' || Lv_Error || '",' ||
                                '"IDENTIFICACION_CLIENTE":"' || Pv_IdentificacionCliente || '"' 
                            || '}';  
   END P_GET_DATA_CIFRAR;
   
  PROCEDURE P_CLI_DATA_CIFRAR (Pcl_Request IN CLOB,
                                Pcl_Resultado OUT CLOB)  AS
                                
                                
     TYPE typ_rec   IS RECORD
        (
          ID_PERSONA_ROL      VARCHAR2(20)
        );
       
        TYPE typ_rec2   IS RECORD
        (
          ID_SERVICIO      VARCHAR2(20)
        );
      
                                
   Lcl_Persona                 CLOB;
   Le_Errors                   EXCEPTION;
   Lv_Retorno                  VARCHAR2(3);
   Lv_Error                    VARCHAR2(4000);     
   lv_cadena                   VARCHAR2(8);
   
   Lv_Identificacion           VARCHAR2(50);
   Lv_usr_mod                  VARCHAR2(50);
   Lv_ip_mod                   VARCHAR2(50);
   Lv_IdPersonaEmpresa         VARCHAR2(50);
   Lv_IdServicio                VARCHAR2(50);
   
     
   
   
    CURSOR C_GET_CLIENTE_ID(Cv_identificacion VARCHAR2) IS
    SELECT
        IPER.ID_PERSONA_ROL
        FROM DB_COMERCIAL.INFO_PERSONA IPE
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPE.ID_PERSONA = IPER.PERSONA_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
        WHERE /*IPER.ESTADO    = 'Activo'
          AND*/ IPE.IDENTIFICACION_CLIENTE = Cv_identificacion
          AND IER.EMPRESA_COD = '18'
          AND AR.ID_ROL = '1';
    
    
    
    
     CURSOR C_GET_SERVICIOS(Cv_identificacion VARCHAR2) IS
     select IFO.id_servicio
        from DB_COMERCIAL.INFO_PERSONA  IP,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_COMERCIAL.INFO_PUNTO IPU,
             DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
             DB_COMERCIAL.INFO_SERVICIO IFO,
             DB_COMERCIAL.INFO_PLAN_DET IPLAN,
             DB_COMERCIAL.ADMI_PRODUCTO ADMP
      where
           IP.IDENTIFICACION_CLIENTE = Cv_identificacion
       and IPER.PERSONA_ID = IP.ID_PERSONA
       and EMP.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
       and IPER.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
       and IPU.ID_PUNTO = IFO.PUNTO_ID 
       and IFO.PLAN_ID = IPLAN.PLAN_ID
       and IPLAN.PRODUCTO_ID = ADMP.ID_PRODUCTO
       and ADMP.NOMBRE_TECNICO = 'INTERNET'
       and EMP.EMPRESA_COD = '18'; 
   
    V_servicios_clientes C_GET_SERVICIOS%rowtype;
    
    
     TYPE Te_Persona IS TABLE OF typ_rec INDEX BY PLS_INTEGER;
     TYPE Te_Servicio IS TABLE OF typ_rec2 INDEX BY PLS_INTEGER;
     Le_Persona Te_Persona;  
     Le_Servicio Te_Servicio;  
     Li_Limit                    CONSTANT PLS_INTEGER DEFAULT 50;    
     Li_Cont_Persona_rol         PLS_INTEGER;
     Li_Cont_Servicio            PLS_INTEGER;
   
   BEGIN 
   
    DBMS_OUTPUT.PUT_LINE('inicio ofuscar'); 
   
     APEX_JSON.PARSE(Pcl_Request);
     Lv_Identificacion  := UPPER(APEX_JSON.get_varchar2(p_path => 'identificacionCliente'));
     Lv_usr_mod   := APEX_JSON.get_varchar2(p_path => 'usuarioMod'); 
     Lv_ip_mod      := APEX_JSON.get_varchar2(p_path => 'ipMod');
     
     DBMS_OUTPUT.PUT_LINE('INFO_PERSONA'); 
   
    update DB_COMERCIAL.INFO_PERSONA 
      set
         nombres = case when nombres is not null then DBMS_RANDOM.string('U', 8) end, 
         apellidos = case when apellidos is not null then DBMS_RANDOM.string('U', 8) end,
         nacionalidad = case when nacionalidad is not null then null end,
         genero = case when genero is not null then 'Y' end,
         numero_conadis = case when numero_conadis is not null then DBMS_RANDOM.string('U', 8) end,
         tipo_empresa = case when tipo_empresa is not null then DBMS_RANDOM.string('U', 5) end,
         tipo_tributario = case when tipo_tributario is not null then null end,
         titulo_id = case when titulo_id is not null then null end,
         razon_social = case when razon_social is not null then DBMS_RANDOM.string('U', 8) end,
         estado_civil = case when estado_civil is not null then 'Y' end,
         origen_ingresos = case when origen_ingresos is not null then 'Y' end,
         fecha_nacimiento = null,
         direccion = case when razon_social is not null then DBMS_RANDOM.string('U', 8) end,
         direccion_tributaria = case when direccion_tributaria is not null then DBMS_RANDOM.string('U', 8) end,
         representante_legal = case when representante_legal is not null then DBMS_RANDOM.string('U', 8) end
     where id_persona in (
    select ipe.id_persona 
       FROM DB_COMERCIAL.INFO_PERSONA ipe,
         DB_COMERCIAL.info_persona_empresa_rol ipero,
         DB_COMERCIAL.INFO_EMPRESA_ROL EMP
    WHERE 
        ipe.identificacion_cliente = Lv_Identificacion
    AND ipe.id_persona = ipero.persona_id
    AND EMP.ID_EMPRESA_ROL = ipero.empresa_rol_id
    AND EMP.EMPRESA_COD = '18');
    
    
      DBMS_OUTPUT.PUT_LINE('info_punto');
    
    update  info_punto 
       set  
            direccion = case when direccion is not null then DBMS_RANDOM.string('U', 10) end,  
            descripcion_punto = case when descripcion_punto is not null then DBMS_RANDOM.string('U', 10) end,
            nombre_punto = case when nombre_punto is not null then DBMS_RANDOM.string('U', 10) end,
            longitud =  0,
            latitud =  0,
            FE_ULT_MOD = sysdate,
            USR_ULT_MOD = Lv_usr_mod,
            IP_ULT_MOD = Lv_ip_mod
      where id_punto in (
     select ipu.id_punto
       FROM DB_COMERCIAL.info_punto ipu, 
              DB_COMERCIAL.info_persona iper,
              DB_COMERCIAL.info_persona_empresa_rol ipero,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE iper.identificacion_cliente = Lv_Identificacion
         AND iper.id_persona = ipero.persona_id
         AND ipu.persona_empresa_rol_id = ipero.id_persona_rol
         AND EMP.ID_EMPRESA_ROL = ipero.empresa_rol_id
         AND EMP.EMPRESA_COD = '18');
     
      DBMS_OUTPUT.PUT_LINE('info_punto_forma_contacto'); 
    
    update DB_COMERCIAL.info_punto_forma_contacto
       set  
           valor = case when valor is not null then DBMS_RANDOM.string('U', 8) end
     where id_punto_forma_contacto in (
    select ipfc.id_punto_forma_contacto
             FROM DB_COMERCIAL.info_punto ipu, 
              DB_COMERCIAL.info_persona iper,
              DB_COMERCIAL.info_persona_empresa_rol ipero,
              DB_COMERCIAL.info_punto_forma_contacto ipfc,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE
         iper.identificacion_cliente = Lv_Identificacion
         AND iper.id_persona = ipero.persona_id
         AND ipu.persona_empresa_rol_id = ipero.id_persona_rol
         AND ipfc.punto_id = ipu.id_punto
         AND ipfc.forma_contacto_id IN (5,45,218,215,26,8,25,7,27,212,214,4)
         AND EMP.ID_EMPRESA_ROL = ipero.empresa_rol_id
         AND EMP.EMPRESA_COD = '18');
    
    DBMS_OUTPUT.PUT_LINE('info_persona_forma_contacto'); 
             
    update DB_COMERCIAL.info_persona_forma_contacto 
       set  valor = case when valor is not null then DBMS_RANDOM.string('U', 8) end,
            FE_ULT_MOD = sysdate,
            USR_ULT_MOD = Lv_usr_mod
     where id_persona_forma_contacto in ( 
    select ipfc.id_persona_forma_contacto
      FROM DB_COMERCIAL.info_persona ip,
              DB_COMERCIAL.info_persona_forma_contacto ipfc,
              DB_COMERCIAL.info_persona_empresa_rol iper,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE
         ip.identificacion_cliente = Lv_Identificacion
         AND ipfc.persona_id = ip.id_persona
         AND ipfc.forma_contacto_id IN (5,45,218,215,26,8,25,7,27,212,214,4)
         AND iper.persona_id = ip.id_persona
         AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
         AND EMP.EMPRESA_COD = '18');
         
     DBMS_OUTPUT.PUT_LINE('info_contrato');     
         
     update DB_COMERCIAL.info_contrato
       set forma_pago_id = (select ID_FORMA_PAGO 
                              from DB_COMERCIAL.ADMI_FORMA_PAGO  
                             where descripcion_forma_pago = 'No disponible LOPDP')  
     where id_contrato in (
     SELECT ico.id_contrato
      FROM DB_COMERCIAL.info_persona ipe,
          DB_COMERCIAL.info_persona_empresa_rol iper,
          DB_COMERCIAL.info_contrato ico,
          DB_COMERCIAL.INFO_EMPRESA_ROL EMP
     WHERE ipe.identificacion_cliente = Lv_Identificacion
     AND iper.persona_id = ipe.id_persona
     AND ico.persona_empresa_rol_id = iper.id_persona_rol
     AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
     AND EMP.EMPRESA_COD = '18');
       
       DBMS_OUTPUT.PUT_LINE('info_persona_representante'); 
       
       update DB_COMERCIAL.info_persona_representante 
          set REPRESENTANTE_EMPRESA_ROL_ID =  (
                                                select x.ID_PERSONA_ROL
                                                  from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL x, 
                                                      DB_COMERCIAL.INFO_PERSONA y 
                                                 where y.id_persona = x.persona_id
                                                   and y.identificacion_cliente = 'ESTO NO ES UNA IDENTIFICACION'
                                                   ),
              FE_ULT_MOD = sysdate,
              USR_ULT_MOD = Lv_usr_mod,
              IP_ULT_MOD = Lv_ip_mod
        where id_persona_representante in (
       SELECT ipre.id_persona_representante
          FROM DB_COMERCIAL.info_persona ipe ,
              DB_COMERCIAL.info_persona_empresa_rol iper,
              DB_COMERCIAL.info_persona_representante ipre,
              DB_COMERCIAL.INFO_EMPRESA_ROL EMP
         WHERE ipe.identificacion_cliente = Lv_Identificacion
         AND iper.persona_id = ipe.id_persona
         AND ipre.persona_empresa_rol_id = iper.id_persona_rol
         AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
         AND EMP.EMPRESA_COD = '18'); 
         
         DBMS_OUTPUT.PUT_LINE('Insert INFO_CONTRATO_FORMA_PAGO '||Lv_IdPersonaEmpresa); 
         
         update DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  
            set  
              titular_cuenta  = case when titular_cuenta is not null then DBMS_RANDOM.string('U', 8) end,
              anio_vencimiento = case when anio_vencimiento is not null then DBMS_RANDOM.string('U', 4) end,
              mes_vencimiento = case when mes_vencimiento is not null then DBMS_RANDOM.string('U', 1) end
              where ID_DATOS_PAGO in(
               select  ifo.ID_DATOS_PAGO
                   FROM DB_COMERCIAL.info_persona ipe,
                        DB_COMERCIAL.info_persona_empresa_rol iper,
                        DB_COMERCIAL.info_contrato ico,
                        DB_COMERCIAL.INFO_EMPRESA_ROL EMP,
                        DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ifo
                   WHERE ipe.identificacion_cliente = Lv_Identificacion
                   AND iper.persona_id = ipe.id_persona
                   AND ico.persona_empresa_rol_id = iper.id_persona_rol
                   AND EMP.ID_EMPRESA_ROL = iper.empresa_rol_id
                   AND EMP.EMPRESA_COD = '18'
                   AND ifo.contrato_id = ico.id_contrato ) ;
         
         
     DBMS_OUTPUT.PUT_LINE('Insert INFO_SERVICIO_HISTORIAL '||Lv_IdPersonaEmpresa); 
     
     
      IF C_GET_SERVICIOS%ISOPEN THEN
            CLOSE C_GET_SERVICIOS;
        END IF;
        OPEN C_GET_SERVICIOS(Lv_Identificacion);
        
       FETCH C_GET_SERVICIOS BULK COLLECT INTO Le_Servicio LIMIT Li_Limit;
        Li_Cont_Servicio := Le_Servicio.FIRST;
      
       WHILE (Li_Cont_Servicio IS NOT NULL) LOOP  
            Lv_IdServicio:=  Le_Servicio(Li_Cont_Servicio).ID_Servicio; 
    
            DBMS_OUTPUT.PUT_LINE ('Insert INFO_SERVICIO_HISTORIAL: '|| Lv_IdServicio);
       
           INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
           values ( 
            DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
            Lv_IdServicio,
            Lv_usr_mod,
            sysdate,
            Lv_ip_mod,
            'Activo',
            null,
            'Proceso eliminación/encriptación del cliente',
            null
           );
         
         Li_Cont_Servicio := Le_Servicio.NEXT(Li_Cont_Servicio);
        END LOOP;
         
      IF C_GET_CLIENTE_ID%ISOPEN THEN
            CLOSE C_GET_CLIENTE_ID;
        END IF;
        OPEN C_GET_CLIENTE_ID(Lv_Identificacion);
    
       FETCH C_GET_CLIENTE_ID BULK COLLECT INTO Le_Persona LIMIT Li_Limit;
        Li_Cont_Persona_rol := Le_Persona.FIRST;
      
       WHILE (Li_Cont_Persona_rol IS NOT NULL) LOOP
   
            Lv_IdPersonaEmpresa:=  Le_Persona(Li_Cont_Persona_rol).ID_PERSONA_ROL; 
    
            DBMS_OUTPUT.PUT_LINE ('Insert INFO_PERSONA_EMPRESA_ROL_CARAC: '|| Lv_IdPersonaEmpresa);
            
            insert into DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
            values (
            DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL, 
            Lv_IdPersonaEmpresa,
           (select CA.ID_CARACTERISTICA from DB_COMERCIAL.ADMI_CARACTERISTICA CA where CA.DESCRIPCION_CARACTERISTICA = 'CLIENTE CIFRADO'),
            'Y',
            sysdate,
            null,
            Lv_usr_mod,
            null,
            Lv_ip_mod,
            'Activo',
            null
           ); 
            Li_Cont_Persona_rol := Le_Persona.NEXT(Li_Cont_Persona_rol);

        END LOOP;
         
     
  
    
    
         
         
   
   DBMS_OUTPUT.PUT_LINE('fin ofuscar'); 
        
         
  commit;
  
   Lv_Retorno := '000'; 
   Lv_Error := 'Exito.';
   Pcl_Resultado  := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';  
   
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'SPKG_DERECHO_LEGAL.P_CLI_DATA_CIFRAR',
                                          SUBSTR('RESPONSE:'||Pcl_Resultado,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
   
   EXCEPTION
    
    WHEN Le_Errors THEN
           rollback;
            APEX_JSON.initialize_clob_output;
            APEX_JSON.open_object;
            APEX_JSON.write('error','Ocurrio un error al ofuscar' );
            APEX_JSON.close_object;
            Pcl_Resultado := APEX_JSON.GET_CLOB_OUTPUT;
            APEX_JSON.free_output;
   
    WHEN OTHERS THEN
        rollback;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'DB_COMERCIAL',
                                          'PSKG_DERECHO_LEGAL.P_CLI_DATA_CIFRAR',
                                          'Problemas al cifrar la data. Parametros ('||Lv_Identificacion||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        
        
        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pcl_Resultado  := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"identificacion":"' || Lv_Identificacion || '"' 
                            || '}';  
   
   END P_CLI_DATA_CIFRAR;
   
END SPKG_DERECHO_LEGAL;
/
