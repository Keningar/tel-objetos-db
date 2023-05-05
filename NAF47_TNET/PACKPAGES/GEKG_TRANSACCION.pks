CREATE OR REPLACE PACKAGE            GEKG_TRANSACCION IS

  -- Author  : SFERNANDEZ
  -- Created : 21/11/2017 12:40:32
  -- Purpose : 

  /**
   * Documentacion para P_GENERAR_TOKEN
   * Procedimiento que realiza el consumo de ws de generacion de Token.
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.0 16/11/2017 
   *
   * @param Pv_UserName IN  VARCHAR2,
   * @param Pv_Password IN  VARCHAR2,
   * @param Pv_Name     IN  VARCHAR2,
   * @param Pv_Token    OUT VARCHAR2,
   * @param Pv_Status   OUT VARCHAR2,
   * @param Pv_Message  OUT VARCHAR2
   * @param Pv_MensajeError  OUT VARCHAR2
   */
     PROCEDURE P_GENERAR_TOKEN (Pv_UserName      IN VARCHAR2,
                                Pv_Password      IN VARCHAR2,
                                Pv_URL           IN VARCHAR2,
                                Pv_Name          IN VARCHAR2,
                                Pv_Token        OUT VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Message      OUT VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2);

  /**
   * Documentacion para P_CONSUMO_TECNICOWS
   * Procedimiento que realiza el consumo de ws de generacion de Token.
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.0 21/11/2017 
   *
   * @param Pc_Json      IN CLOB,
   * @param Pv_URL       IN VARCHAR2,
   * @param Pv_Status   OUT VARCHAR2,
   * @param Pv_Mensaje  OUT VARCHAR2,
   * @param Pv_MensajeError  OUT VARCHAR2
   */
     PROCEDURE P_CONSUMO_TECNICOWS (Pv_Json          IN VARCHAR2,
                                    Pv_URL           IN VARCHAR2,
                                    Pv_Status       OUT VARCHAR2,
                                    Pv_Mensaje      OUT VARCHAR2,
                                    Pv_MensajeError OUT VARCHAR2);

  /**
   * Documentacion para P_CREA_TAREA
   * Procedimiento que crea tareas para gestion de retiro de equipos a OPU
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.0 28/11/2017 
   *
   * @param Pv_IdAplicacion       IN VARCHAR2,
   * @param Pv_NoCia              IN VARCHAR2,
   * @param Pv_IdGrupoParametro   IN VARCHAR2,
   * @param Pv_ObsInfoDetalle     IN VARCHAR2,
   * @param Pv_DetalleSolicitudId IN VARCHAR2,
   * @param Pv_Login              IN VARCHAR2,
   * @param Pv_MensajeError      OUT VARCHAR
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.1 22/02/2018 Se actualiza la creacion de la tarea por la oficina asociada al punto del servicio.
    *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.1 26/04/2018 Se quita la valizacion por estado de la tarea.
   */

     PROCEDURE P_CREA_TAREA (Pv_IdAplicacion       IN VARCHAR2,
                             Pv_NoCia              IN VARCHAR2,
                             Pv_IdGrupoParametro   IN VARCHAR2,
                             Pv_ObsInfoDetalle     IN VARCHAR2,
                             Pv_DetalleSolicitudId IN VARCHAR2,
                             Pv_Login              IN VARCHAR2,
                             Pv_MensajeError      OUT VARCHAR2);

    /**
   * Documentacion para P_ENVIA_MAIL_TAREA
   * Procedimiento que gestiona el envio de correo al general las tareas
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.0 03/12/2017 
   *
   * @param Pn_NumeroTarea     IN NUMBER,
   * @param Pv_NombreTarea     IN VARCHAR2,
   * @param Pv_FechaAsignacion IN VARCHAR2 ,
   * @param Pv_UsuarioAsigna   IN VARCHAR2,
   * @param Pv_UsuarioAsignado IN VARCHAR2,
   * @param Pv_Observacino     IN VARCHAR2,
   * @param Pv_NombreEmpresa   IN VARCHAR2,
   * @param Pv_MailDestinatario IN VARCHAR2,
   * @param Pv_Asunto IN VARCHAR2,
   * @param Pv_MensajeError    OUT VARCHAR2  
   */

    PROCEDURE P_ENVIA_MAIL_TAREA(Pn_NumeroTarea     IN NUMBER,
                               Pv_NombreTarea       IN VARCHAR2,
                               Pv_FechaAsignacion   IN VARCHAR2 ,
                               Pv_UsuarioAsigna     IN VARCHAR2,
                               Pv_UsuarioAsignado   IN VARCHAR2,
                               Pv_Observacino       IN VARCHAR2,
                               Pv_NombreEmpresa     IN VARCHAR2,
                                Pv_MailDestinatario IN VARCHAR2,
                               Pv_Asunto            IN VARCHAR2,
                               Pv_MensajeError    OUT VARCHAR2);   

   /**
   * Documentacion para P_INSERTA_INFO_ERROR
   * Procedimiento inserta errores en el log INFO_ERROR del TELCOS
   *
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.0 05/06/20179
   *
   * @param Pv_Aplicacion     IN VARCHAR2,
   * @param Pv_Proceso        IN VARCHAR2 ,
   * @param Pv_Detalle        IN VARCHAR2
   */

   PROCEDURE P_INSERTA_INFO_ERROR(Pv_Aplicacion IN VARCHAR2,
                                  Pv_Proceso    IN VARCHAR2,
                                  Pv_Detalle    IN VARCHAR2);		

END GEKG_TRANSACCION;

/


CREATE OR REPLACE PACKAGE BODY                                                                              GEKG_TRANSACCION IS

  PROCEDURE P_GENERAR_TOKEN (Pv_UserName      IN VARCHAR2,
                             Pv_Password      IN VARCHAR2,
                             Pv_URL           IN VARCHAR2,
                             Pv_Name          IN VARCHAR2,
                             Pv_Token        OUT VARCHAR2,
                             Pv_Status       OUT VARCHAR2,
                             Pv_Message      OUT VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2)IS

    Lv_Metodo        VARCHAR2(10);
    Lv_Version       VARCHAR2(10);
    Lv_Aplicacion    VARCHAR2(50);
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    Lc_Json          CLOB;
    Lhttp_Request    UTL_HTTP.req;
    Lhttp_Response   UTL_HTTP.resp;
    data             VARCHAR2(4000); 

    BEGIN

      Lv_Metodo       := 'POST';
      Lv_Version      := ' HTTP/1.1';
      Lv_Aplicacion   := 'application/json';

      Lc_Json         := '{"username":"'||Pv_UserName||'","password":"'||Pv_Password||'","source":{"name":"'||Pv_Name||'"'||'}}';
      DBMS_OUTPUT.PUT_LINE(Lc_Json);
      Lhttp_Request := UTL_HTTP.begin_request (Pv_URL,
                                               Lv_Metodo,
                                               Lv_Version);
      DBMS_OUTPUT.PUT_LINE(Pv_URL);
      UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
      UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);

      Ln_LongitudReq  := DBMS_LOB.getlength(Lc_Json);

      IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
        UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lc_Json));
        UTL_HTTP.write_text(Lhttp_Request, Lc_Json);
      ELSE
        UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
        WHILE (Ln_Offset < Ln_LongitudReq) LOOP
          DBMS_LOB.READ(Lc_Json, 
                        Ln_Amount,
                        Ln_Offset,
                        Ln_Buffer);
          UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
          Ln_Offset := Ln_Offset + Ln_Amount;
        END LOOP;
      END IF;

      Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
      utl_http.read_text(Lhttp_Response, data);                         
      DBMS_OUTPUT.PUT_LINE(data);
      apex_json.parse (data);

      Pv_Token  :=apex_json.get_varchar2('token');
      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('message');

      UTL_HTTP.end_response(Lhttp_Response);

    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        Pv_MensajeError := 'Error UTL_HTTP.end_of_body';
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                             'GEKG_TRANSACCION.P_GENERAR_TOKEN',
                                             Pv_MensajeError,
                                             GEK_CONSULTA.F_RECUPERA_LOGIN,
                                             SYSDATE,
                                             GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;
        UTL_HTTP.end_response(Lhttp_Response); 
      WHEN OTHERS THEN
        Pv_MensajeError := 'Error en NAF47_TNET.P_GENERAR_TOKEN: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEKG_TRANSACCION.P_GENERAR_TOKEN',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
  END P_GENERAR_TOKEN;

  PROCEDURE P_CONSUMO_TECNICOWS (Pv_Json         IN VARCHAR2,
                                 Pv_URL           IN VARCHAR2,
                                 Pv_Status       OUT VARCHAR2,
                                 Pv_Mensaje      OUT VARCHAR2,
                                 Pv_MensajeError OUT VARCHAR2)IS

    Lv_Metodo        VARCHAR2(10);
    Lv_Version       VARCHAR2(10);
    Lv_Aplicacion    VARCHAR2(50);
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    Lv_Json          VARCHAR2(32767);
    Lhttp_Request    UTL_HTTP.req;
    Lhttp_Response   UTL_HTTP.resp;
    data             VARCHAR2(32767); 

    BEGIN

      Lv_Metodo       := 'POST';
      Lv_Version      := ' HTTP/1.1';
      Lv_Aplicacion   := 'application/json';

      Lv_Json         := Pv_Json;

      Lhttp_Request := UTL_HTTP.begin_request (Pv_URL,
                                               Lv_Metodo,
                                               Lv_Version);
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'Pv_URL',
                                            Pv_URL,
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP);

      UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
      UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);

      Ln_LongitudReq  := DBMS_LOB.getlength(Lv_Json);

      IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
        UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lv_Json));
        UTL_HTTP.write_text(Lhttp_Request, Lv_Json);
      ELSE
        UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
        WHILE (Ln_Offset < Ln_LongitudReq) LOOP
          DBMS_LOB.READ(Lv_Json, 
                        Ln_Amount,
                        Ln_Offset,
                        Ln_Buffer);
          UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
          Ln_Offset := Ln_Offset + Ln_Amount;
        END LOOP;
      END IF;

      Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
      utl_http.read_text(Lhttp_Response, data);                         
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                             'data',
                                             data,
                                             GEK_CONSULTA.F_RECUPERA_LOGIN,
                                             SYSDATE,
                                             GEK_CONSULTA.F_RECUPERA_IP);
      apex_json.parse (data);

      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Mensaje:=apex_json.get_varchar2('mensaje');

      UTL_HTTP.end_response(Lhttp_Response);

    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        Pv_MensajeError := 'Error UTL_HTTP.end_of_body'||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                             'NAF47_TNET.P_CONSUMO_TECNICOWS',
                                             Pv_MensajeError,
                                             GEK_CONSULTA.F_RECUPERA_LOGIN,
                                             SYSDATE,
                                             GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;
        UTL_HTTP.end_response(Lhttp_Response); 
    WHEN OTHERS THEN
        Pv_MensajeError := 'Error en NAF47_TNET.P_CONSUMO_TECNICOWS: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'NAF47_TNET.P_CONSUMO_TECNICOWS',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        IF INSTR(Pv_MensajeError,'transfer timeout',1)>0 THEN                                     
          Pv_Status:='OK';
          Pv_MensajeError:=NULL;
        ELSE
          Pv_Status:='X';
          ROLLBACK;
        END IF;    
  END P_CONSUMO_TECNICOWS;

  PROCEDURE P_CREA_TAREA (Pv_IdAplicacion       IN VARCHAR2,
                          Pv_NoCia              IN VARCHAR2,
                          Pv_IdGrupoParametro   IN VARCHAR2,
                          Pv_ObsInfoDetalle     IN VARCHAR2,
                          Pv_DetalleSolicitudId IN VARCHAR2,
                          Pv_Login              IN VARCHAR2,
                          Pv_MensajeError      OUT VARCHAR2)IS

    CURSOR C_GRUPOS_PARAMETROS (Cv_parametro Varchar2) IS
      SELECT DESCRIPCION
        FROM NAF47_TNET.GE_PARAMETROS
       WHERE ID_EMPRESA         = Pv_NoCia
         AND ID_APLICACION      = Pv_IdAplicacion
         AND ID_GRUPO_PARAMETRO = Pv_IdGrupoParametro
         AND PARAMETRO          = Cv_parametro
         AND ESTADO             = 'A';

     CURSOR C_PROCESO (Cv_NombreProceso Varchar2,
                       Cv_Activo        Varchar2)IS
      SELECT ID_PROCESO
        FROM DB_SOPORTE.ADMI_PROCESO
       WHERE NOMBRE_PROCESO = Cv_NombreProceso
         AND ESTADO         = Cv_Activo;

     CURSOR C_TAREA(Cv_NombreTarea Varchar2,
                    Cn_ProcesoId   Number,
                    Cv_Activo      Varchar2)IS
      SELECT ID_TAREA
        FROM DB_SOPORTE.ADMI_TAREA
       WHERE NOMBRE_TAREA = Cv_NombreTarea
         AND PROCESO_ID   = Cn_ProcesoId;

     CURSOR C_DEPARTAMENTO (Cv_NombreDepartamento Varchar2)IS
     SELECT ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO
       FROM DB_GENERAL.ADMI_DEPARTAMENTO 
       WHERE NOMBRE_DEPARTAMENTO = Cv_NombreDepartamento
         AND EMPRESA_COD = Pv_NoCia;

    CURSOR C_JEFE_OPERACIONES(Cv_NombreDepto   Varchar2,
                              Cv_Oficina       Varchar2,
                              Cv_IndJDepto     Varchar2)IS
      SELECT CEDULA,MAIL_CIA 
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS 
        WHERE NOMBRE_DEPTO = UPPER(Cv_NombreDepto)
        AND ESTADO = 'A' 
        AND JEFE_DEPARTAMENTAL = Cv_IndJDepto
        AND OFICINA            = Cv_Oficina;

    CURSOR C_ASIGNADO(Cv_IdentificacionCliente Varchar2) IS
     SELECT ID_PERSONA,NOMBRES|| ' '|| APELLIDOS AS NOMBRE
       FROM DB_COMERCIAL.INFO_PERSONA 
       WHERE IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente;

    CURSOR C_ASIGNA(Cv_Login Varchar2) IS
     SELECT NOMBRES|| ' '|| APELLIDOS AS NOMBRE
       FROM DB_COMERCIAL.INFO_PERSONA 
       WHERE LOGIN = Cv_Login;

    CURSOR C_PERSONA_ROL (Cn_PersonaId    Number,
                          Cn_Departamento Number,
                          Cv_Activo      Varchar2 )IS
    SELECT ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL 
     WHERE PERSONA_ID      = Cn_PersonaId 
       AND DEPARTAMENTO_ID = Cn_Departamento
       AND ESTADO          = Cv_Activo;

    CURSOR C_CLASE_DOC(Cv_Activo Varchar2) IS
     SELECT ID_CLASE_DOCUMENTO
        FROM DB_COMUNICACION.ADMI_CLASE_DOCUMENTO
       WHERE NOMBRE_CLASE_DOCUMENTO = 'REQUERIMIENTO INTERNO'
         AND ESTADO = Cv_Activo;

    CURSOR C_FORMA_CONTACTO(Cv_Activo Varchar2) IS
    SELECT ID_FORMA_CONTACTO
      FROM DB_COMUNICACION.ADMI_FORMA_CONTACTO
     WHERE DESCRIPCION_FORMA_CONTACTO = 'Correo Electronico'
       AND ESTADO = Cv_Activo; 

    CURSOR C_EMPRESA IS   
    SELECT NOMBRE_EMPRESA 
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO 
    WHERE COD_EMPRESA = Pv_NoCia;

    CURSOR C_OFICINA_PUNTO IS
     SELECT ID_OFICINA, IOG.EMPRESA_ID,APR.CODIGO_INEC_PROVINCIA,APR.NOMBRE_PROVINCIA
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
             DB_COMERCIAL.INFO_SERVICIO          ISE,
             DB_COMERCIAL.INFO_PUNTO             IPU,
             DB_COMERCIAL.ADMI_JURISDICCION      AJU,
             DB_COMERCIAL.INFO_OFICINA_GRUPO     IOG,
             DB_GENERAL.ADMI_CANTON              ACA,
             DB_GENERAL.ADMI_PROVINCIA           APR
       WHERE IDS.SERVICIO_ID = ISE.ID_SERVICIO
         AND ISE.PUNTO_ID    = IPU.ID_PUNTO
         AND IPU.PUNTO_COBERTURA_ID = AJU.ID_JURISDICCION
         AND AJU.OFICINA_ID  = IOG.ID_OFICINA
         AND IOG.CANTON_ID  = ACA.ID_CANTON
         AND ACA.PROVINCIA_ID = APR.ID_PROVINCIA
         AND IDS.ID_DETALLE_SOLICITUD = Pv_DetalleSolicitudId;

    Lv_NombreEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.NOMBRE_EMPRESA%TYPE;
    Ln_IdComunicacion     DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE:=0;
    Ln_IdDocumento        DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE:=0;
    Lv_IdFormaContacto    DB_COMUNICACION.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE:=0;
    Lv_IdClaseDoc         DB_COMUNICACION.ADMI_CLASE_DOCUMENTO.ID_CLASE_DOCUMENTO%TYPE:=0;
    Lv_Descripcion        NAF47_TNET.GE_PARAMETROS.DESCRIPCION%TYPE;
    Lv_DescripcionTarea   NAF47_TNET.GE_PARAMETROS.DESCRIPCION%TYPE;
    Lv_Proceso            Varchar2(10):= 'PROCESO';
    Lv_Tarea              Varchar2(10):= 'TAREA';
    Lv_DeptoAsigna        Varchar2(10):= 'DEPTOASIGN';
    Lv_OfiCosta           Varchar2(10):= 'OFIR1';
    Lv_OfiSierra          Varchar2(10):= 'OFIR2';
    Ln_IdProceso          DB_SOPORTE.ADMI_PROCESO.ID_PROCESO%TYPE:=0;
    Ln_IdTarea            DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE:=0;
    Ln_IdDetalle          DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE:=0;
    Lv_Opcion             DB_SOPORTE.INFO_CRITERIO_AFECTADO.OPCION%TYPE;
    Ln_IdCriterioAfectado DB_SOPORTE.INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE:=0;
    Ln_IdParteAfectada    DB_SOPORTE.INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE:=0;
    Ln_IdPunto            DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE:=0;
    Lv_NombreCliente      DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE;
    Lv_Departamento       DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE;
    Lr_Departamento       C_DEPARTAMENTO%ROWTYPE;
    Lr_DepartamentoAsigna C_DEPARTAMENTO%ROWTYPE;
    Lr_Persona            C_ASIGNADO%ROWTYPE;
    Ln_PersonaRol         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE:=0; 
    Ld_Fecha              Date:= SYSDATE;
    Lr_JefeOperaciones    C_JEFE_OPERACIONES%ROWTYPE;
    Lv_UsuarioAsigna      Varchar2(150);
    Lv_MensajeError       Varchar2(500);
    Lv_Asunto             Varchar2(150):= 'Nueva Tarea, Equipo No Entregado - Actividad #';
    Lr_OficinaPunto       C_OFICINA_PUNTO%ROWTYPE;
    Lv_DeptoPrincipal     Varchar2(10):= 'DEPTOPRINC';
    Lv_DeptoProvincia     Varchar2(10):= 'DEPTOPROV';
    Lv_Oficina            DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE:=0;
    Le_Error              Exception;
    Lv_IndJefeDepto       Varchar2(1):='S';
    Lv_EstadoTarea             Varchar2(10):='Activo';
    Lv_Asignada           Varchar2(10):='Asignada';

  BEGIN 


    IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
    OPEN C_GRUPOS_PARAMETROS (Lv_Proceso );
    FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
    CLOSE C_GRUPOS_PARAMETROS;

    IF C_PROCESO%ISOPEN THEN CLOSE C_PROCESO; END IF;
    OPEN C_PROCESO (Lv_Descripcion,Lv_EstadoTarea );
    FETCH C_PROCESO INTO Ln_IdProceso;
    CLOSE C_PROCESO;

    Lv_Descripcion:= NULL;

    IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
    OPEN C_GRUPOS_PARAMETROS (Lv_Tarea);
    FETCH C_GRUPOS_PARAMETROS INTO Lv_DescripcionTarea;
    CLOSE C_GRUPOS_PARAMETROS;

    IF C_TAREA%ISOPEN THEN CLOSE C_TAREA; END IF;
    OPEN C_TAREA (Lv_DescripcionTarea,Ln_IdProceso,Lv_EstadoTarea );
    FETCH C_TAREA INTO Ln_IdTarea;
    CLOSE C_TAREA;

    Ln_IdDetalle:= DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL;

    INSERT INTO DB_SOPORTE.INFO_DETALLE (ID_DETALLE,TAREA_ID,OBSERVACION,
                                         PESO_PRESUPUESTADO,
                                     VALOR_PRESUPUESTADO,FE_SOLICITADA,FE_CREACION,
                                     USR_CREACION,IP_CREACION,DETALLE_SOLICITUD_ID)
        VALUES (Ln_IdDetalle,Ln_IdTarea,Pv_ObsInfoDetalle,
                0,0, Ld_Fecha, 
                Ld_Fecha,GEK_CONSULTA.F_RECUPERA_LOGIN, GEK_CONSULTA.F_RECUPERA_IP,
                Pv_DetalleSolicitudId);

     Lv_Opcion := 'Cliente: '|| Pv_Login  || ' | OPCION: Punto Cliente';

     Ln_IdCriterioAfectado:= DB_SOPORTE.SEQ_INFO_CRITERIO_AFECTADO.NEXTVAL;

     INSERT INTO DB_SOPORTE.INFO_CRITERIO_AFECTADO (ID_CRITERIO_AFECTADO, DETALLE_ID, CRITERIO,
                                                OPCION,USR_CREACION, FE_CREACION, 
                                                IP_CREACION)
        VALUES (Ln_IdCriterioAfectado,Ln_IdDetalle,'Clientes',
                Lv_Opcion, GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha, GEK_CONSULTA.F_RECUPERA_IP);

      Ln_IdParteAfectada:= DB_SOPORTE.SEQ_INFO_PARTE_AFECTADA.NEXTVAL;

      INSERT INTO DB_SOPORTE.INFO_PARTE_AFECTADA (ID_PARTE_AFECTADA,CRITERIO_AFECTADO_ID,DETALLE_ID,
                                            AFECTADO_ID, AFECTADO_NOMBRE, AFECTADO_DESCRIPCION, 
                                            FE_INI_INCIDENCIA,USR_CREACION,FE_CREACION,
                                            IP_CREACION,TIPO_AFECTADO)
      VALUES (Ln_IdParteAfectada,Ln_IdCriterioAfectado, Ln_IdDetalle, 
              Ln_IdPunto, Pv_Login, Lv_NombreCliente,
              Ld_Fecha,GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha,
              GEK_CONSULTA.F_RECUPERA_IP,'CLIENTE');

      --
      IF C_OFICINA_PUNTO%ISOPEN THEN CLOSE C_OFICINA_PUNTO; END IF;
      OPEN C_OFICINA_PUNTO;
      FETCH C_OFICINA_PUNTO INTO Lr_OficinaPunto;
      CLOSE C_OFICINA_PUNTO;

      IF Lr_OficinaPunto.CODIGO_INEC_PROVINCIA = '17' OR Lr_OficinaPunto.CODIGO_INEC_PROVINCIA = '09' THEN

         IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
         OPEN C_GRUPOS_PARAMETROS (Lv_DeptoPrincipal );
         FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
         CLOSE C_GRUPOS_PARAMETROS;

         IF Lr_OficinaPunto.CODIGO_INEC_PROVINCIA = '17' THEN
           IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
           OPEN C_GRUPOS_PARAMETROS (Lv_OfiSierra);
           FETCH C_GRUPOS_PARAMETROS INTO Lv_Oficina;
           CLOSE C_GRUPOS_PARAMETROS;
         ELSIF Lr_OficinaPunto.CODIGO_INEC_PROVINCIA = '09' THEN
           IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
           OPEN C_GRUPOS_PARAMETROS (Lv_OfiCosta);
           FETCH C_GRUPOS_PARAMETROS INTO Lv_Oficina;
           CLOSE C_GRUPOS_PARAMETROS;
         END IF;
      ELSE

         IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
         OPEN C_GRUPOS_PARAMETROS (Lv_DeptoProvincia );
         FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
         CLOSE C_GRUPOS_PARAMETROS;
         Lv_Oficina:= Lr_OficinaPunto.Id_Oficina;
         IF Lr_OficinaPunto.CODIGO_INEC_PROVINCIA = '20' THEN
           Lv_IndJefeDepto:= 'N';
         END IF;

      END IF;

    Lv_Departamento:= INITCAP(Lv_Descripcion);

    IF C_DEPARTAMENTO%ISOPEN THEN CLOSE C_DEPARTAMENTO; END IF;
    OPEN C_DEPARTAMENTO (Lv_Departamento);
    FETCH C_DEPARTAMENTO INTO Lr_Departamento;
    CLOSE C_DEPARTAMENTO;

    IF C_JEFE_OPERACIONES%ISOPEN THEN CLOSE C_JEFE_OPERACIONES; END IF;
   -- OPEN C_JEFE_OPERACIONES (Lr_Departamento.Nombre_Departamento,Lv_oficina, Lv_IndJefeDepto);
    OPEN C_JEFE_OPERACIONES ('OPERACIONES URBANAS','69', 'S');
    FETCH C_JEFE_OPERACIONES INTO Lr_JefeOperaciones;
    IF C_JEFE_OPERACIONES%NOTFOUND THEN
      Pv_MensajeError:= 'No existe Jefe del Departamento: '||Lr_Departamento.Nombre_Departamento||' y Oficina: '||Lv_oficina ;
      RAISE Le_Error;
    END IF;      
    CLOSE C_JEFE_OPERACIONES;

    IF C_ASIGNADO%ISOPEN THEN CLOSE C_ASIGNADO; END IF;
    OPEN C_ASIGNADO (Lr_JefeOperaciones.Cedula);
    FETCH C_ASIGNADO INTO Lr_Persona;
    CLOSE C_ASIGNADO;

    IF C_PERSONA_ROL%ISOPEN THEN CLOSE C_PERSONA_ROL; END IF;
    OPEN C_PERSONA_ROL (Lr_Persona.Id_Persona, Lr_Departamento.Id_Departamento,Lv_EstadoTarea);
    FETCH C_PERSONA_ROL INTO Ln_PersonaRol;
    CLOSE C_PERSONA_ROL;

    Lv_Descripcion:= NULL;

    IF C_GRUPOS_PARAMETROS%ISOPEN THEN CLOSE C_GRUPOS_PARAMETROS; END IF;
    OPEN C_GRUPOS_PARAMETROS (Lv_DeptoAsigna);
    FETCH C_GRUPOS_PARAMETROS INTO Lv_Descripcion;
    CLOSE C_GRUPOS_PARAMETROS;

    Lv_Departamento:= INITCAP(Lv_Descripcion);

    IF C_DEPARTAMENTO%ISOPEN THEN CLOSE C_DEPARTAMENTO; END IF;
    OPEN C_DEPARTAMENTO (Lv_Departamento);
    FETCH C_DEPARTAMENTO INTO Lr_DepartamentoAsigna;
    CLOSE C_DEPARTAMENTO;


    INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION (ID_DETALLE_ASIGNACION,DETALLE_ID,ASIGNADO_ID,
                                                    ASIGNADO_NOMBRE,REF_ASIGNADO_ID,REF_ASIGNADO_NOMBRE,
                                                    MOTIVO,USR_CREACION,FE_CREACION,
                                                    IP_CREACION,PERSONA_EMPRESA_ROL_ID,TIPO_ASIGNADO,
                                                    DEPARTAMENTO_ID,CANTON_ID)
      VALUES(DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL,Ln_IdDetalle,Lr_Departamento.ID_DEPARTAMENTO ,
             Lr_Departamento.NOMBRE_DEPARTAMENTO, Lr_Persona.ID_PERSONA,Lr_Persona.NOMBRE,
             Pv_ObsInfoDetalle, GEK_CONSULTA.F_RECUPERA_LOGIN, Ld_Fecha,
             GEK_CONSULTA.F_RECUPERA_IP,Ln_PersonaRol,'Empleado',
             Lr_DepartamentoAsigna.ID_DEPARTAMENTO,'');

    INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO (ID_SEGUIMIENTO,DETALLE_ID,OBSERVACION,
                                                   USR_CREACION,FE_CREACION,EMPRESA_COD,
                                                   ESTADO_TAREA,DEPARTAMENTO_ID,PERSONA_EMPRESA_ROL_ID)

      VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_IdDetalle,'Tarea fue Asignada a '||Lr_Departamento.Nombre_Departamento,
              GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha, Pv_NoCia,Lv_Asignada,Lr_Departamento.ID_DEPARTAMENTO ,Ln_PersonaRol);


    INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL (ID_DETALLE_HISTORIAL, DETALLE_ID, OBSERVACION, 
                                               ESTADO,USR_CREACION,FE_CREACION,
                                               IP_CREACION,ASIGNADO_ID,PERSONA_EMPRESA_ROL_ID,
                                               DEPARTAMENTO_ORIGEN_ID,DEPARTAMENTO_DESTINO_ID,ACCION)
         VALUES(DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,Ln_IdDetalle,'Tarea fue Asignada a '||Lr_Departamento.Nombre_Departamento,
                Lv_Asignada,GEK_CONSULTA.F_RECUPERA_LOGIN, Ld_Fecha,
                GEK_CONSULTA.F_RECUPERA_IP,Lr_Departamento.ID_DEPARTAMENTO,Ln_PersonaRol,
                Lr_DepartamentoAsigna.ID_DEPARTAMENTO, Lr_Departamento.ID_DEPARTAMENTO,Lv_Asignada);


    IF C_CLASE_DOC%ISOPEN THEN CLOSE C_CLASE_DOC; END IF;
    OPEN C_CLASE_DOC(Lv_EstadoTarea);
    FETCH C_CLASE_DOC INTO Lv_IdClaseDoc;
    CLOSE C_CLASE_DOC;

    Ln_IdDocumento:= DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO(ID_DOCUMENTO,CLASE_DOCUMENTO_ID,NOMBRE_DOCUMENTO,
                                           USR_CREACION,FE_CREACION,IP_CREACION,
                                           ESTADO,MENSAJE,EMPRESA_COD)
   VALUES (Ln_IdDocumento,Lv_IdClaseDoc,'Registro de tarea',
           GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha,GEK_CONSULTA.F_RECUPERA_IP,
           Lv_EstadoTarea,Pv_ObsInfoDetalle,Pv_NoCia);

    IF C_FORMA_CONTACTO%ISOPEN THEN CLOSE C_FORMA_CONTACTO; END IF;
    OPEN C_FORMA_CONTACTO(Lv_EstadoTarea);
    FETCH C_FORMA_CONTACTO INTO Lv_IdFormaContacto;
    CLOSE C_FORMA_CONTACTO;

    Ln_IdComunicacion:= DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL;
    INSERT INTO DB_COMUNICACION.INFO_COMUNICACION (ID_COMUNICACION,FORMA_CONTACTO_ID,DETALLE_ID,
                                               CLASE_COMUNICACION,FECHA_COMUNICACION,ESTADO,
                                               USR_CREACION,FE_CREACION,IP_CREACION,
                                               EMPRESA_COD)
           VALUES(Ln_IdComunicacion,Lv_IdFormaContacto, Ln_IdDetalle,
                  'Recibido',Ld_Fecha,Lv_EstadoTarea,
                  GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha,GEK_CONSULTA.F_RECUPERA_IP,
                  Pv_NoCia);


    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION
        VALUES (DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL,Ln_IdDocumento,Ln_IdComunicacion,
               Lv_EstadoTarea,GEK_CONSULTA.F_RECUPERA_LOGIN,Ld_Fecha,GEK_CONSULTA.F_RECUPERA_IP);

   IF C_ASIGNA%ISOPEN THEN CLOSE C_ASIGNA; END IF;
   OPEN C_ASIGNA(GEK_CONSULTA.F_RECUPERA_LOGIN);
   FETCH C_ASIGNA INTO Lv_UsuarioAsigna;
   CLOSE C_ASIGNA;            
   Lv_Asunto:= Lv_Asunto|| Ln_IdComunicacion;

   IF C_EMPRESA%ISOPEN THEN CLOSE C_EMPRESA; END IF;
   OPEN C_EMPRESA;
   FETCH C_EMPRESA INTO Lv_NombreEmpresa;
   CLOSE C_EMPRESA;  

   NAF47_TNET.GEKG_TRANSACCION.P_ENVIA_MAIL_TAREA(Ln_IdComunicacion,
                                                  Lv_DescripcionTarea,
                                                  Ld_Fecha,
                                                  Lr_DepartamentoAsigna.Nombre_Departamento||' - '||Lv_UsuarioAsigna ,
                                                  Lr_Persona.NOMBRE ,                                                  
                                                  Pv_ObsInfoDetalle ,
                                                  Lv_NombreEmpresa ,
                                                  Lr_JefeOperaciones.Mail_Cia,
                                                  Lv_Asunto,
                                                  Lv_MensajeError);

   IF Lv_MensajeError IS NOT NULL THEN
     Pv_MensajeError:=Lv_MensajeError;
   END IF;

 EXCEPTION 
   WHEN Le_Error THEN     
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEKG_TRANSACCION.P_CREA_TAREA',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
   WHEN OTHERS THEN
        Pv_MensajeError := 'Error en NAF47_TNET.P_CREA_TAREA: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
         DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
         DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
         DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEKG_TRANSACCION.P_CREA_TAREA',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
        ROLLBACK;    
  END P_CREA_TAREA;

  PROCEDURE P_ENVIA_MAIL_TAREA(Pn_NumeroTarea IN NUMBER,
                               Pv_NombreTarea IN VARCHAR2,
                               Pv_FechaAsignacion IN VARCHAR2 ,
                               Pv_UsuarioAsigna IN VARCHAR2,
                               Pv_UsuarioAsignado IN VARCHAR2,
                               Pv_Observacino IN VARCHAR2,
                               Pv_NombreEmpresa        IN VARCHAR2,
                               Pv_MailDestinatario     IN VARCHAR2,
                               Pv_Asunto               IN VARCHAR2,
                               Pv_MensajeError        OUT VARCHAR2)IS                               


  CURSOR C_GetPlantilla(Cv_CodPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE) IS
      SELECT PLANTILLA
       FROM DB_COMUNICACION.ADMI_PLANTILLA 
      WHERE ESTADO <> 'Eliminado'
        AND CODIGO = Cv_CodPlantilla;
--
  Lc_Plantilla C_GetPlantilla%ROWTYPE;
  Lv_MessageMail VARCHAR2(4000);

  Lex_Exception                     EXCEPTION;
--
BEGIN
--
    IF C_GetPlantilla%ISOPEN THEN CLOSE C_GetPlantilla; END IF;
    OPEN C_GetPlantilla('EQ_NO_ENTREGADO');
    FETCH C_GetPlantilla INTO Lc_Plantilla;
    IF C_GetPlantilla%NOTFOUND THEN
     RAISE Lex_Exception;
    END IF;
    --
    Lv_MessageMail := REPLACE(Lc_Plantilla.PLANTILLA, '{{ intNumeroTarea }}', Pn_NumeroTarea);

    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strNombreTarea }}', Pv_NombreTarea);
    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strFechaAsignacion }}', Pv_FechaAsignacion);
    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strUsuarioAsigna }}', Pv_UsuarioAsigna);
    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strUsuarioAsignado }}', Pv_UsuarioAsignado);
    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strObservacion }}', Pv_Observacino);
    Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strNombreEmpresa }}', Pv_NombreEmpresa);

    DBMS_OUTPUT.PUT_LINE(Lv_MessageMail);
    --
    UTL_MAIL.SEND (SENDER => 'notificaciones_telcos@telconet.ec', 
                   RECIPIENTS =>Pv_MailDestinatario, 
                   SUBJECT => Pv_Asunto,
                   MESSAGE => Lv_MessageMail,
                   MIME_TYPE => 'text/html; charset=UTF-8' );

    --
    EXCEPTION
    WHEN Lex_Exception THEN
         Pv_MensajeError:= 'Error P_ENVIA_MAIL_TAREA Lex_Exception';
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEKG_TRANSACCION.F_ENVIA_CORREO_TAREA',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);

                                              --
    WHEN OTHERS THEN
         Pv_MensajeError:= 'Error P_ENVIA_MAIL_TAREA: '||SQLCODE ||' - '||SQLERRM;
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                              'GEKG_TRANSACCION.F_ENVIA_CORREO_TAREA',
                                              Pv_MensajeError,
                                              GEK_CONSULTA.F_RECUPERA_LOGIN,
                                              SYSDATE,
                                              GEK_CONSULTA.F_RECUPERA_IP);
-- 
 END P_ENVIA_MAIL_TAREA;

  PROCEDURE P_INSERTA_INFO_ERROR(Pv_Aplicacion IN VARCHAR2,
                                 Pv_Proceso    IN VARCHAR2,
                                 Pv_Detalle    IN VARCHAR2) IS

  BEGIN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Pv_Aplicacion,
                                         Pv_Proceso,
                                         Pv_Detalle,
                                         GEK_CONSULTA.F_RECUPERA_LOGIN,
                                         SYSDATE,
                                         GEK_CONSULTA.F_RECUPERA_IP);
    -- 
  END P_INSERTA_INFO_ERROR;

END GEKG_TRANSACCION;
/
