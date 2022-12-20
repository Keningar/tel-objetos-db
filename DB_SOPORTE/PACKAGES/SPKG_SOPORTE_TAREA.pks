CREATE OR REPLACE package DB_SOPORTE.SPKG_SOPORTE_TAREA IS

 /**
  * Documentación para el procedimiento P_TAREA_EMPLEADO
  *
  * Método encargado de consultar mediante el numero de tarea la tarea y los empleados asociados a la  tarea.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   numeroTarea    := número de tarea
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                              
   PROCEDURE P_TAREA_EMPLEADO(Pcl_Request  IN  CLOB,
                              Pv_Status    OUT VARCHAR2,
                              Pv_Mensaje   OUT VARCHAR2,
                              Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_GENERA_HE_TAREA_FINALIZADA
  *
  * Método encargado de generar la solicitud de horas extras al finalizar una tarea, validando el horario linea base.
  *
  * @param Pn_EmpresaCod      IN  NUMBER Codigo de empresa
  * @param Pn_IdDetalle       IN  NUMBER Codigo de id detalle de la tarea que genera la solicitud
  * @param Pv_TAREA_ID        IN  VARCHAR2 Codigo de tarea que genera la solicitud
  * @param Pn_NumeroTarea     IN  NUMBER Usuario genera finaliza la tarea y genera la solicitud de horas extras
  * @param Pv_userCreacion    IN  VARCHAR2 Usuario genera finaliza la tarea y genera la solicitud de horas extras
  * @param Pv_Error           OUT VARCHAR2 Mensaje de la transacción
  *
  * @author Katherine Portugal <kportugal@telconet.ec>
  * @version 1.0 22-09-2021
  */                               
    PROCEDURE P_GENERA_HE_TAREA_FINALIZADA(Pn_EmpresaCod       IN NUMBER,
                                           Pn_IdDetalle        IN NUMBER,
                                           Pv_TAREA_ID         IN VARCHAR2,
                                           Pn_NumeroTarea      IN NUMBER,
                                           Pv_userCreacion     IN VARCHAR2,
                                           Pv_Error            OUT VARCHAR2);    

  /**
  * Documentación para el procedimiento PR_MIGRACION_TAREAS_DEPTO
  *
  * Método encargado de generar la solicitud de horas extras al finalizar una tarea, validando el horario linea base.
  *
  * @param PN_ID_DEPTO_ANTERIOR IN  NUMBER Codigo de departamento anterior
  * @param PN_ID_DEPTO_ACTUAL   IN  NUMBER Codigo de departamento actual
  * @param PN_COD_EMPRESA       IN  NUMBER Codigo de la empresa
  * @param PV_USR_EJECUTA       IN  VARCHAR2 Usuario que realiza la ejecucion de la mogracion de tareas
  * @param PV_MENSAJE           OUT VARCHAR2 Mensaje de respuesta del proceso
  *
  * @author Pedro Velez <psvelez@telconet.ec>
  * @version 1.0 15-08-2022
  */ 
  PROCEDURE PR_MIGRACION_TAREAS_DEPTO(PN_ID_DEPTO_ANTERIOR  NUMBER, 
                                      PN_ID_DEPTO_ACTUAL     NUMBER, 
                                      PN_COD_EMPRESA         NUMBER,
                                      PV_USR_EJECUTA         VARCHAR2,
                                      PV_MENSAJE             OUT VARCHAR2 );                        

     /**
   * Documentación para el procedimiento P_GET_FIN_MOVILIZACION
   *
   * Metodo encargado de consultar si el evento de movilizacion de una cuadrilla finalizó
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   *
   * [
   *  numeroTarea   Numero de tarea que gestiona la cuadrilla 
   * ]
   *
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response   OUT  CLOB Retorna json de la consulta
   *
   * @author  Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 
   * @since   03-01-2022
   */                           
  PROCEDURE P_GET_EVENTO_TAREA(Pcl_Request  IN CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT CLOB);

  /**
   * Documentación para el proceso 'P_GET_ADMI_PROCESO'
   *
   * Metodo encargado de consultar uno o varios procesos, según los datos ingresados
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * [
   *  idProceso           Id del proceso,
   *  nombreProceso       Nombre del proceso,
   *  estado              Estado del proceso,
   *  procesoPadreId      Id del proceso padre,
   *  aplicaEstado        Indica si aplica estado,
   *  visible             Indica si es visible,
   *  planMantenimiento   Indica si es parte del plan de mantenimiento
   * ]
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   22-10-2021
   */                              
  PROCEDURE P_GET_ADMI_PROCESO(Pcl_Request  IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Prf_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el proceso 'P_GET_ADMI_TAREA'
   *
   * Metodo encargado de consultar uno o varias tareas, según los datos ingresados
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * [
   *  idTarea       Id de la tarea,
   *  idProceso     Id del proceso,
   *  estado        Estado de la tarea,
   *  nombreTarea   Nombre de la tarea
   * ]
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   22-10-2021
   */                               
  PROCEDURE P_GET_ADMI_TAREA(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Prf_Response OUT SYS_REFCURSOR);  

  /**
   * Documentación para el procedimiento P_GET_TAREAS
   *
   * Metodo encargado de consultar uno o varias tareas (actividades), segun los datos ingresados
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   *
   * [
   *  codEmpresa              Código de la empresa,
   *  fechaCreacionDesde      Fecha de inicio para buscar tarea según la fecha de creación,
   *  fechaCreacionHasta      Fecha fin para buscar tarea según la fecha de creación,
   *  estados                 Estados de la(s) tarea(s) a consultar,
   *  nombreAfectado          Nombre del afectado en la tarea,
   *  identificacionCliente   Identificación del cliente
   * ]
   *
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Pcl_Response   OUT  CLOB Retorna json de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   26-10-2021
   */                           
  PROCEDURE P_GET_TAREAS(Pcl_Request  IN CLOB,
                         Pv_Status    OUT VARCHAR2,
                         Pv_Mensaje   OUT VARCHAR2,
                         Pcl_Response OUT CLOB);                                   

 /**
  * Documentación para el procedimiento P_CAMBIAR_ESTADO_TAREA
  *
  * Método encargado de actualizar el estado de una tarea
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT CLOB Retorna la información de la tarea actualizado el estado
  *
  * @author Andrés Montero H. <amontero@telconet.ec>
  * @version 1.0 10-05-2022
  */    
  PROCEDURE P_CAMBIAR_ESTADO_TAREA(Pcl_Request IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response      OUT CLOB) ;

 /**
  * Documentación para el procedimiento P_REVERSAR_ESTADO_TAREA
  *
  * Método encargado de reversar el cambio de estado de una tarea
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT CLOB Retorna la información de la tarea actualizado el estado
  *
  * @author Andrés Montero H. <amontero@telconet.ec>
  * @version 1.0 10-05-2022
  */    
  PROCEDURE P_REVERSAR_ESTADO_TAREA(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB);
END SPKG_SOPORTE_TAREA;

/


CREATE OR REPLACE package body DB_SOPORTE.SPKG_SOPORTE_TAREA IS

   PROCEDURE P_TAREA_EMPLEADO(Pcl_Request  IN  CLOB,
                              Pv_Status    OUT VARCHAR2,
                              Pv_Mensaje   OUT VARCHAR2,
                              Pcl_Response OUT SYS_REFCURSOR) 
                              
   AS
      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_NumeroTarea         VARCHAR2(30);
      Lv_EmpresaCod          VARCHAR2(2);
      Lv_NombreDepartamento  VARCHAR2(50);
      Lv_Nombres             VARCHAR2(50);
      Le_Errors              EXCEPTION;


   BEGIN 

      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_NumeroTarea         :=  APEX_JSON.get_varchar2(p_path => 'numeroTarea');
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_NombreDepartamento  :=  APEX_JSON.get_varchar2(p_path => 'nombreDpto');
      Lv_Nombres             :=  APEX_JSON.get_varchar2(p_path => 'nombres');

      Lcl_Select       :=  '
                     SELECT DISTINCT IP.IDENTIFICACION_CLIENTE IDENTIFICACION, VEE.NOMBRE NOMBRES,ATA.NOMBRE_TAREA,ATA.ESTADO ESTADO_TAREA,
                            VEE.NO_EMPLE,VEE.MAIL_CIA, VEE.NOMBRE_DEPTO DEPARTAMENTO,ICO.ID_COMUNICACION NUMERO_TAREA  ';


      Lcl_From         :=   ' 
                     FROM DB_COMUNICACION.INFO_COMUNICACION ICO ';

      Lcl_WhereAndJoin := '  
                     JOIN DB_SOPORTE.INFO_DETALLE IDE ON IDE.ID_DETALLE = ICO.DETALLE_ID
                     JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
                     JOIN DB_SOPORTE.ADMI_TAREA ATA ON ATA.ID_TAREA = IDE.TAREA_ID
                     JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL= IDA.PERSONA_EMPRESA_ROL_ID
                     JOIN DB_COMERCIAL.INFO_PERSONA IP ON IP.ID_PERSONA = IPER.PERSONA_ID
                     JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.LOGIN_EMPLE = IP.LOGIN 
                     WHERE ICO.ID_COMUNICACION='||Lv_NumeroTarea||' AND VEE.ESTADO=''A'' AND IPER.ESTADO=''Activo''
                     AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND VEE.NOMBRE_DEPTO = '''||Lv_NombreDepartamento||''' ';


      IF Lv_Nombres IS NOT NULL THEN

         Lcl_WhereAndJoin := Lcl_WhereAndJoin ||' AND VEE.NOMBRE='''||Lv_Nombres||''' ' ;

      END IF;

      Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin;

      OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';


   EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;


   END P_TAREA_EMPLEADO;

   ----

   
   PROCEDURE P_GENERA_HE_TAREA_FINALIZADA(Pn_EmpresaCod       IN NUMBER,
                                         Pn_IdDetalle        IN NUMBER,
                                         Pv_TAREA_ID         IN VARCHAR2,
                                         Pn_NumeroTarea      IN NUMBER,
                                         Pv_userCreacion     IN VARCHAR2,
                                         Pv_Error            OUT VARCHAR2)

    AS                          

       CURSOR C_GET_HISTORIAL_TAREA(Cn_EmpresaCod  NUMBER,CV_TAREA_ID VARCHAR2, Cn_IdDetalle NUMBER) IS
       SELECT Q1.NO_EMPLE,
          Q1.USR_CREACION,
          TO_CHAR(Q1.FE_CREACION,'DD-MM-YYYY') FECHA_INICIO,
          TO_CHAR(Q2.FECHA,'DD-MM-YYYY') FECHA_FIN ,
          TO_CHAR(Q1.FE_CREACION,'DD-MM-YYYY HH24:MI') FECHA_INICIO_HE,
          TO_CHAR(Q2.FECHA,'DD-MM-YYYY HH24:MI') FECHA_FIN_HE ,
          TO_CHAR(Q1.FE_CREACION,'HH24:MI') HORA_INICIO,
          TO_CHAR(Q2.FECHA, 'HH24:MI') HORA_FIN,
          TRUNC(24 * (to_date(TO_CHAR(Q2.FECHA, 'DD-MM-YYYY') || ' ' || TO_CHAR(Q2.FECHA, 'HH24:MI'), 'DD-MM-YYYY HH24:MI')- to_date(TO_CHAR(Q1.FE_CREACION, 'DD-MM-YYYY')|| ' ' || TO_CHAR(Q1.FE_CREACION, 'HH24:MI'), 'DD-MM-YYYY HH24:MI'))) TOTAL_HORAS
        FROM
          (SELECT VE.NO_EMPLE,
            IDH1.USR_CREACION,
            IDH1.FE_CREACION
          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH1
          JOIN DB_SOPORTE.INFO_DETALLE IDE1
          ON IDE1.ID_DETALLE = IDH1.DETALLE_ID
          JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
          ON VE.LOGIN_EMPLE   = IDH1.USR_CREACION
          AND VE.NO_CIA       = Cn_EmpresaCod
          WHERE IDE1.TAREA_ID = CV_TAREA_ID
          AND IDH1.DETALLE_ID = Cn_IdDetalle
          AND IDH1.ESTADO    IN ('Aceptada')
          AND IDH1.ACCION    IN ('Ejecutada')
          ) Q1,
          (SELECT IDH.USR_CREACION USER_CREACION,
            IDH.FE_CREACION fecha
          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
          JOIN DB_SOPORTE.INFO_DETALLE IDE
          ON IDE.ID_DETALLE  = IDH.DETALLE_ID
          WHERE IDE.TAREA_ID = CV_TAREA_ID
          AND IDH.DETALLE_ID = Cn_IdDetalle
          AND IDH.ESTADO    IN ( 'Asignada', 'Finalizada' )
          AND IDH.ACCION    IN ( 'Reasignada', 'Finalizada' )
          ) Q2
        WHERE Q1.USR_CREACION=Q2.USER_CREACION
        GROUP BY Q1.NO_EMPLE,
          Q1.USR_CREACION,
          Q1.FE_CREACION,
          Q2.FECHA
        ORDER BY Q1.FE_CREACION ASC;

      CURSOR C_ADMI_HORA_EMPLE_LINEA_BASE(Cn_EmpresaCod  NUMBER,
                                          Cv_Estado      VARCHAR2,
                                          Cv_NoEMple     NUMBER,                                       
                                          Cv_FechaDesde  VARCHAR2,
                                          Cv_FechaHasta  VARCHAR2)IS
        SELECT AHE.NO_EMPLE,
               MIN(AHE.FECHA_INICIO) FECHA_INICIO,
               MAX(AHE.FECHA_FIN) FECHA_FIN,
               MIN(AHE.HORA_INICIO) HORA_INICIO,
               MAX(AHE.HORA_FIN) HORA_FIN
          FROM DB_HORAS_EXTRAS.INFO_HORARIO_EMPLEADOS AHE
          JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS ATH
            ON ATH.ID_TIPO_HORARIO      = AHE.TIPO_HORARIO_ID
           AND ATH.NOMBRE_TIPO_HORARIO  = 'LINEA BASE'
         WHERE AHE.EMPRESA_COD          = Cn_EmpresaCod
           AND AHE.ESTADO               = Cv_Estado
           AND AHE.NO_EMPLE             = Cv_NoEMple
           AND ((TO_CHAR(AHE.FECHA_INICIO, 'MM') = TO_CHAR(TO_DATE(Cv_FechaDesde,'DD-MM-YYYY'), 'MM') 
           AND TO_CHAR(AHE.FECHA_INICIO, 'YYYY') = TO_CHAR(TO_DATE(Cv_FechaDesde,'DD-MM-YYYY'), 'YYYY'))
           OR  (TO_CHAR(AHE.FECHA_FIN, 'MM') = TO_CHAR(TO_DATE(Cv_FechaHasta,'DD-MM-YYYY'), 'MM') 
           AND TO_CHAR(AHE.FECHA_FIN, 'YYYY') = TO_CHAR(TO_DATE(Cv_FechaHasta,'DD-MM-YYYY'), 'YYYY')))
      GROUP BY AHE.NO_EMPLE;

         CURSOR C_DATOS_EMPLE(Cn_EmpresaCod  NUMBER,
                              Cv_NoEMple     NUMBER)IS   
            SELECT VEE.AREA,VEE.NOMBRE_AREA,VEE.DEPTO,VEE.NOMBRE_DEPTO
             FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE 
             WHERE VEE.NO_EMPLE=Cv_NoEMple 
             AND VEE.NO_CIA=Cn_EmpresaCod;

        --CURSOR QUE OBTIENE TAREAS FINALIZADAS EN EL MES Y AÑO ACTUAL, (TAREA_ID)
          CURSOR C_GET_TAREA (CV_ID_TAREA VARCHAR2, CV_ESTADO VARCHAR2 , CV_ID_DETALLE VARCHAR2 ) IS
          SELECT  IT.*
          FROM DB_SOPORTE.INFO_TAREA IT
          WHERE IT.ESTADO = CV_ESTADO
            AND IT.TAREA_ID=CV_ID_TAREA
            AND IT.DETALLE_ID=CV_ID_DETALLE
            AND PROCESO_ID = (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_PROCESO WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA' AND ESTADO='Activo')

       ORDER BY IT.NUMERO_TAREA DESC;

      Lc_Datostarea             C_GET_TAREA%ROWTYPE;   
      Lc_PlaniLineBase          C_ADMI_HORA_EMPLE_LINEA_BASE%ROWTYPE; 
      Lc_DatosEMple             C_DATOS_EMPLE%ROWTYPE;  

      Lv_EstadoTarea            VARCHAR2(20);
      Lv_estadoSolicitud        VARCHAR2(20);
      Lv_Observacion            VARCHAR2(200);
      Lv_Status                 VARCHAR2(30);
      Lv_regjson                CLOB;  
      Lv_MsnError               VARCHAR2(2400);  
      Le_Exception              EXCEPTION; 
      Ln_ContadorRegistros      NUMBER;
      Ln_ContadorReg            NUMBER;   
      Ln_NumeroHoras        NUMBER;


      Type C_GET_HISTORIAL_TAREA_TYPE IS VARRAY(2) OF C_GET_HISTORIAL_TAREA%ROWTYPE;

      Lc_horariosTareaEnviar    C_GET_HISTORIAL_TAREA_TYPE;   
      Lc_horariosTarea_tmp      C_GET_HISTORIAL_TAREA%ROWTYPE;



   BEGIN

      Lv_EstadoTarea:= 'Finalizada';
      Lv_estadoSolicitud:='Verificacion';
      Lv_Observacion:='Origen Tarea HE Finalizacion de tarea en telcos';
      Ln_ContadorRegistros:=0;
      Ln_ContadorReg:=1;

      IF Pn_EmpresaCod IS NULL THEN
         Pv_Error := 'El parámetro empresaCod está vacío';
         RAISE Le_Exception;
      END IF;

      IF Pv_userCreacion IS NULL THEN
          Pv_Error := 'El parámetro userCreacion está vacío';
          RAISE Le_Exception;
      END IF;

      IF C_GET_TAREA%ISOPEN THEN
         CLOSE C_GET_TAREA;
      END IF;

      OPEN C_GET_TAREA(Pv_TAREA_ID,Lv_EstadoTarea,Pn_IdDetalle);
        FETCH C_GET_TAREA 
          INTO Lc_Datostarea;
      CLOSE C_GET_TAREA;
         
      SELECT PARDET.VALOR1 AS TOTAL_HORAS
     INTO Ln_NumeroHoras
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'TOTAL DE HORAS EXTRAS'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo'; 

     FOR histoTarea IN C_GET_HISTORIAL_TAREA(Pn_EmpresaCod,Lc_Datostarea.TAREA_ID,Pn_IdDetalle) LOOP

            IF C_ADMI_HORA_EMPLE_LINEA_BASE%ISOPEN THEN
               CLOSE C_ADMI_HORA_EMPLE_LINEA_BASE;
            END IF;          

            OPEN C_ADMI_HORA_EMPLE_LINEA_BASE(Pn_EmpresaCod,'Activo',TO_NUMBER(histoTarea.no_emple),histoTarea.FECHA_INICIO,histoTarea.FECHA_FIN);
              FETCH C_ADMI_HORA_EMPLE_LINEA_BASE 
                INTO Lc_PlaniLineBase;
            CLOSE C_ADMI_HORA_EMPLE_LINEA_BASE;


            IF C_DATOS_EMPLE%ISOPEN THEN
                CLOSE C_DATOS_EMPLE;
            END IF;

            OPEN C_DATOS_EMPLE(Pn_EmpresaCod,TO_NUMBER(histoTarea.no_emple) );
              FETCH C_DATOS_EMPLE 
                INTO Lc_DatosEMple;
            CLOSE C_DATOS_EMPLE;

           IF Lc_PlaniLineBase.FECHA_INICIO  IS NOT NULL then 
           
              IF histoTarea.TOTAL_HORAS<Ln_NumeroHoras THEN             

              IF to_date(histoTarea.FECHA_FIN, 'DD-MM-YYYY') > to_date(histoTarea.FECHA_INICIO, 'DD-MM-YYYY') THEN
                Lc_horariosTarea_tmp := histoTarea;
                Lc_horariosTarea_tmp.HORA_FIN:='23:59';
                Lc_horariosTarea_tmp.FECHA_FIN:=histoTarea.FECHA_INICIO;
                Lc_horariosTareaEnviar := C_GET_HISTORIAL_TAREA_TYPE(Lc_horariosTarea_tmp);

                Lc_horariosTareaEnviar.extend;
                Lc_horariosTarea_tmp := histoTarea;
                Lc_horariosTarea_tmp.HORA_INICIO:='00:00';
                Lc_horariosTarea_tmp.FECHA_INICIO:=histoTarea.FECHA_FIN;
                Lc_horariosTareaEnviar(2):=Lc_horariosTarea_tmp;

               ELSE
                  Lc_horariosTareaEnviar := C_GET_HISTORIAL_TAREA_TYPE(histoTarea);
               END IF;


               Ln_ContadorRegistros:=Lc_horariosTareaEnviar.count;
               WHILE Ln_ContadorReg <=  Ln_ContadorRegistros LOOP

                          lv_regjson := chr(10)
                          || lpad(' ', 6, ' ')
                          || '{'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"noEmpleado":['
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).NO_EMPLE
                          || '],'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"fecha":"'
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_INICIO 
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"horaInicio":"'
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).HORA_INICIO 
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"horaFin":"'
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).HORA_FIN
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"observacion":"'
                          || Lv_Observacion
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"estado":"'
                          || Lv_estadoSolicitud
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"empresaCod":"'
                          || TO_CHAR(Pn_EmpresaCod)
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"usrCreacion":"'
                          || Pv_userCreacion
                          || '",'
                          || chr(10)                             
                          || lpad(' ', 9, ' ')                    
                          || '"tareaId":['
                          || Lc_Datostarea.numero_tarea 
                          || '],'                    
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"nombreDocumento":[],'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"ubicacionDocumento":[],'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"jornadaEmpleado":"'
                          || 'M'
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"esFinDeSemana":"'
                          || 'N'
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"esDiaLibre":"'
                          || 'N'
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"descripcion":"'
                          || 'Unitaria'
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"idCuadrilla":"'
                          || null
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"nombreArea":"'
                          || Lc_DatosEMple.NOMBRE_AREA
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"feInicioTarea":["'
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_INICIO_HE
                          || '"],'                                        
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"feFinTarea":["'
                          || Lc_horariosTareaEnviar(Ln_ContadorReg).FECHA_FIN_HE
                          || '"],'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"nombreDepartamento":"'
                          || Lc_DatosEMple.NOMBRE_DEPTO
                          || '",'
                          || chr(10)
                          || lpad(' ', 9, ' ')
                          || '"esSuperUsuario":"'
                          || 'N'
                          || '"'
                          || chr(10)
                          || lpad(' ', 6, ' ')
                          || '}';

                      DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_GUARDAR_HORASEXTRA(lv_regjson,
                                                                                   Lv_Status,
                                                                                   Pv_Error);
                      IF Lv_Status = 'ERROR' THEN
                         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS', 'SPKG_SOPORTE_TAREA.P_GENERA_HE_TAREA_FINALIZADA', 
                                                        Pv_Error || ' Linea:'|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE , NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                       END IF; 


                       Ln_ContadorReg := Ln_ContadorReg + 1;
                   END LOOP;

                   ELSE
                 DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS',
                                                   'SPKG_SOPORTE_TAREA.P_GENERA_HE_TAREA_FINALIZADA',
                                                   'No se puede generar solicitud de Horas Extras en estado VERIFICACION para la tarea: ' ||
                          Lc_Datostarea.numero_tarea || ', número total de horas excedido',
                                                   NVL(SYS_CONTEXT('USERENV',
                                                                   'HOST'),
                                                       'DB_SOPORTE'),
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV',
                                                                   'IP_ADDRESS'),
                                                       '127.0.0.1'));                                    
             END IF;

        ELSE
            PV_ERROR:= 'No se pudo generar solicitud de Horas Extras en estado VERIFICACION para la tarea: ' || Lc_Datostarea.numero_tarea || ',No posee linea base ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS', 'SPKG_SOPORTE_TAREA.P_GENERA_HE_TAREA_FINALIZADA', 
                                          Pv_Error || ' Linea:'|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        END IF;

        END LOOP; 
         COMMIT;
     EXCEPTION
    WHEN Le_Exception THEN

        ROLLBACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS', 'SPKG_SOPORTE_TAREA.P_GENERA_HE_TAREA_FINALIZADA', 
                                                Pv_Error || ' Linea:'|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_HORAS_EXTRAS'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    WHEN OTHERS THEN
      --
        ROLLBACK;

        Lv_MsnError := SQLCODE || ' -ERROR- ' || SQLERRM || ' Linea:'|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('HORAS_EXTRAS', 'SPKG_SOPORTE_TAREA.P_GENERA_HE_TAREA_FINALIZADA', Lv_MsnError , 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_HORAS_EXTRAS'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  END P_GENERA_HE_TAREA_FINALIZADA;

  PROCEDURE PR_MIGRACION_TAREAS_DEPTO(PN_ID_DEPTO_ANTERIOR  NUMBER, 
                                      PN_ID_DEPTO_ACTUAL     NUMBER, 
                                      PN_COD_EMPRESA         NUMBER,
                                      PV_USR_EJECUTA         VARCHAR2,
                                      PV_MENSAJE             OUT VARCHAR2 ) IS

    LV_NOMBRE_DEPTO_ACTUAL   Varchar2(100);
    LV_NOMBRE_DEPTO_ANTERIOR VARCHAR2(100);
    LN_NUMERO_TAREA1  NUMBER;
    LN_NUMERO_TAREA2  NUMBER;
    LN_NUMERO_TAREA3  NUMBER;
    LV_MENSAJE      VARCHAR2(250);
    LE_EXCEPTION    EXCEPTION;
    
  BEGIN

      DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Inicio',
                                        'Inicio de la migracion de tareas por nuevo departamento',
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                        PV_USR_EJECUTA);
                                        
  BEGIN 
    select S.Nombre_Departamento 
      INTO LV_NOMBRE_DEPTO_ANTERIOR
      from DB_GENERAL.Admi_Departamento s 
      where S.Id_Departamento = PN_ID_DEPTO_ANTERIOR 
        AND S.EMPRESA_COD = PN_COD_EMPRESA;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJE := 'No existe departamento con codigo: '||PN_ID_DEPTO_ANTERIOR;
      RAISE LE_EXCEPTION;
  END;
  
  BEGIN 
    select S.Nombre_Departamento 
      INTO LV_NOMBRE_DEPTO_ACTUAL
      from DB_GENERAL.Admi_Departamento s 
      where S.Id_Departamento = PN_ID_DEPTO_ACTUAL 
        AND S.EMPRESA_COD = PN_COD_EMPRESA;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJE := 'No existe departamento con codigo: '||PN_ID_DEPTO_ACTUAL;
      RAISE LE_EXCEPTION;
  END;
  
  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA1
  FROM DB_SOPORTE.Info_Detalle_Asignacion
  WHERE asignado_id     = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Detalle_Asignacion
      set asignado_id     = PN_ID_DEPTO_ACTUAL, 
          Asignado_Nombre = LV_NOMBRE_DEPTO_ACTUAL
    where asignado_id     = PN_ID_DEPTO_ANTERIOR;
    
  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA2
  FROM DB_SOPORTE.Info_Detalle_Asignacion
  WHERE asignado_id     = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Detalle_Asignacion
      set Departamento_Id = PN_ID_DEPTO_ACTUAL
    where Departamento_Id = PN_ID_DEPTO_ANTERIOR; 
    
    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Ejecucion 1',
                                        'Se actualiza registros de tabla Info_Detalle_Asignacion, Numero de Registros: '||LN_NUMERO_TAREA1||', segundo query:'||LN_NUMERO_TAREA2,
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||' nombre:'||LV_NOMBRE_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||' nombre:'||
                                        LV_NOMBRE_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,PV_USR_EJECUTA);
  ------------------------------------------------------------------------------------

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA1
  FROM DB_SOPORTE.Info_Detalle_Historial
  WHERE asignado_id     = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Detalle_Historial
      set asignado_id = PN_ID_DEPTO_ACTUAL
    where asignado_id = PN_ID_DEPTO_ANTERIOR;

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA2
  FROM DB_SOPORTE.Info_Detalle_Historial
  WHERE Departamento_Origen_Id = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Detalle_Historial
      set Departamento_Origen_Id = PN_ID_DEPTO_ACTUAL
    where Departamento_Origen_Id = PN_ID_DEPTO_ANTERIOR;

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA3
  FROM DB_SOPORTE.Info_Detalle_Historial
  WHERE Departamento_Destino_Id = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Detalle_Historial
      set Departamento_Destino_Id= PN_ID_DEPTO_ACTUAL
    where Departamento_Destino_Id = PN_ID_DEPTO_ANTERIOR;

    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Ejecucion 2',
                                        'Se actualiza registros de tabla Info_Detalle_Historial, Numero de Registros: '||LN_NUMERO_TAREA1||', segundo query:'||LN_NUMERO_TAREA2||', tercer query:'||LN_NUMERO_TAREA3,
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                        PV_USR_EJECUTA);
  -----------------------------------------------------------------
  
  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA1
  FROM DB_SOPORTE.Info_Tarea
  WHERE asignado_id     = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Tarea 
      set asignado_id = PN_ID_DEPTO_ACTUAL,
          asignado_nombre = LV_NOMBRE_DEPTO_ACTUAL
    where asignado_id = PN_ID_DEPTO_ANTERIOR;

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA2
  FROM DB_SOPORTE.Info_Tarea
  WHERE Departamento_Id = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Tarea 
      set Departamento_Id = PN_ID_DEPTO_ACTUAL
    where Departamento_Id = PN_ID_DEPTO_ANTERIOR; 

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA3
  FROM DB_SOPORTE.Info_Tarea
  WHERE Departamento_Origen_Id = PN_ID_DEPTO_ANTERIOR;
  
  update DB_SOPORTE.Info_Tarea 
      set Departamento_Origen_Id = PN_ID_DEPTO_ACTUAL
    where Departamento_Origen_Id = PN_ID_DEPTO_ANTERIOR;  

    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Ejecucion 3',
                                        'Se actualiza registros de tabla Info_Tarea, Numero de Registros: '||LN_NUMERO_TAREA1||', segundo query:'||LN_NUMERO_TAREA2||', tercer query:'||LN_NUMERO_TAREA3,
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                        PV_USR_EJECUTA);
  ----------------------------------------------------------------- 

  SELECT COUNT(*) 
  INTO LN_NUMERO_TAREA1
  FROM DB_SOPORTE.Info_Tarea_Seguimiento
  WHERE Departamento_Id = PN_ID_DEPTO_ANTERIOR;
  
    update DB_SOPORTE.Info_Tarea_Seguimiento
      set Departamento_Id = PN_ID_DEPTO_ACTUAL
    where Departamento_Id = PN_ID_DEPTO_ANTERIOR; 
  
    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Ejecucion 4',
                                        'Se actualiza registros de tabla Info_Tarea_Seguimiento, Numero de Registros: '||LN_NUMERO_TAREA1,
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                        PV_USR_EJECUTA); 
----------------------------------------------------------------------------

 SELECT COUNT(*) 
 INTO LN_NUMERO_TAREA1
 FROM DB_SOPORTE.INFO_DETALLE_COLABORADOR
 WHERE asignado_id = PN_ID_DEPTO_ANTERIOR;
 
  update DB_SOPORTE.INFO_DETALLE_COLABORADOR
     set asignado_id = PN_ID_DEPTO_ACTUAL,
         ASIGNADO_NOMBRE = LV_NOMBRE_DEPTO_ACTUAL
   where asignado_id = PN_ID_DEPTO_ANTERIOR; 
 
  DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                       '1',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'Migracion tareas depto',
                                       'Ejecucion 5',
                                       'Se actualiza registros de tabla INFO_DETALLE_COLABORADOR, Numero de Registros: '||LN_NUMERO_TAREA1,
                                       'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                       PV_USR_EJECUTA); 
------------------------------------------------------------------------- 
  SELECT COUNT(*) 
 INTO LN_NUMERO_TAREA1
 FROM DB_SOPORTE.Info_detalle_tareas
 WHERE Departamento_Id = PN_ID_DEPTO_ANTERIOR;
 
  update DB_SOPORTE.Info_detalle_tareas
     set Departamento_Id = PN_ID_DEPTO_ACTUAL
   where Departamento_Id = PN_ID_DEPTO_ANTERIOR; 
 
  DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                       '1',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'Migracion tareas depto',
                                       'Ejecucion 6',
                                       'Se actualiza registros de tabla Info_detalle_tareas, Numero de Registros: '||LN_NUMERO_TAREA1,
                                       'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                       PV_USR_EJECUTA); 
------------------------------------------------------------------------------------------------
 SELECT COUNT(*) 
 INTO LN_NUMERO_TAREA1
 FROM DB_SOPORTE.info_caso_asignacion
 WHERE asignado_id = PN_ID_DEPTO_ANTERIOR;
 
  update DB_SOPORTE.info_caso_asignacion
     set asignado_id = PN_ID_DEPTO_ACTUAL,
         ASIGNADO_NOMBRE = LV_NOMBRE_DEPTO_ACTUAL
   where asignado_id = PN_ID_DEPTO_ANTERIOR; 
 
  DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                       '1',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'Migracion tareas depto',
                                       'Ejecucion 7',
                                       'Se actualiza registros de tabla info_caso_asignacion, Numero de Registros: '||LN_NUMERO_TAREA1,
                                       'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                       PV_USR_EJECUTA); 
------------------------------------------------------------------------------------------------
 SELECT COUNT(*) 
 INTO LN_NUMERO_TAREA1
 FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD
 WHERE Departamento_Id = PN_ID_DEPTO_ANTERIOR;
 
  update DB_SOPORTE.INFO_ASIGNACION_SOLICITUD
     set Departamento_Id = PN_ID_DEPTO_ACTUAL
   where Departamento_Id = PN_ID_DEPTO_ANTERIOR; 
 
  DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                       '1',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'PR_MIGRACION_TAREAS_DEPTO',
                                       'Migracion tareas depto',
                                       'Ejecucion 8',
                                       'Se actualiza registros de tabla INFO_ASIGNACION_SOLICITUD, Numero de Registros: '||LN_NUMERO_TAREA1,
                                       'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                       PV_USR_EJECUTA); 
------------------------------------------------------------------------------------------------
  SELECT count(Distinct S.Detalle_Id) 
    into LN_NUMERO_TAREA1
    FROM DB_SOPORTE.Info_Detalle_Historial S 
    WHERE S.asignado_id = PN_ID_DEPTO_ANTERIOR 
      or s.Departamento_Origen_Id = PN_ID_DEPTO_ANTERIOR 
      or s.Departamento_destino_Id = PN_ID_DEPTO_ANTERIOR;

    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                        '1',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'PR_MIGRACION_TAREAS_DEPTO',
                                        'Migracion tareas depto',
                                        'Ejecucion 9',
                                        'Se realizó la migracion de '||LN_NUMERO_TAREA1||' tareas',
                                        'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                        PV_USR_EJECUTA); 
  
    COMMIT;

    PV_MENSAJE := 'Se realizó la migracion de '||LN_NUMERO_TAREA1||' tareas';

  EXCEPTION
  WHEN LE_EXCEPTION THEN
    
      DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                          '1',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'Migracion tareas depto',
                                          'Error',
                                          LV_MENSAJE,
                                          'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                          PV_USR_EJECUTA);
      PV_MENSAJE:= LV_MENSAJE;
      
  WHEN OTHERS THEN
      Lv_Mensaje := 'Error en proceso de migracion de tareas a nuevos departamento '||substr(sqlerrm,1,200);
      
      DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Pn_Cod_Empresa,
                                          '1',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'PR_MIGRACION_TAREAS_DEPTO',
                                          'Migracion tareas depto',
                                          'Error',
                                          LV_MENSAJE,
                                          'PN_ID_DEPTO_ANTERIOR='||PN_ID_DEPTO_ANTERIOR||'-PN_ID_DEPTO_ACTUAL='||PN_ID_DEPTO_ACTUAL||',-PN_COD_EMPRESA'||PN_COD_EMPRESA,
                                          PV_USR_EJECUTA);
    PV_MENSAJE := LV_MENSAJE;
    
  END PR_MIGRACION_TAREAS_DEPTO;

   PROCEDURE P_GET_EVENTO_TAREA(Pcl_Request  IN CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Pcl_Response OUT CLOB) AS
                                   
    Ln_IdComunicacion   DB_COMUNICACION.Info_Comunicacion.Id_Comunicacion%TYPE;
    Lcl_Response        CLOB;
    Lb_Fin_Movilizacion BOOLEAN:= false;
    Ld_Fecha            DATE;
    Lv_Error            varchar2(250);
    Le_Error            EXCEPTION;
   BEGIN
  
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdComunicacion := APEX_JSON.get_number('numeroTarea');
    
    BEGIN			
		SELECT FECHA_FIN INTO Ld_Fecha 
		 FROM (SELECT ie.FECHA_FIN
				 FROM INFO_EVENTO ie 
				WHERE TIPO_EVENTO_ID  = 1 
				  AND OBSERVACION LIKE '%CLIENTE|#'||Ln_IdComunicacion||'|%'
			    ORDER BY ie.id_evento DESC) 
	     WHERE  rownum = 1;
    EXCEPTION 
     WHEN no_data_found THEN
       Lv_Error:= 'No estiste evento de inicio de movilizacion';
       raise Le_Error;
     WHEN OTHERS THEN
       Lv_Error:= 'Error en la consulta de evento de movilizacion';
       raise Le_Error;  
  	 END;   
  
  	 IF Ld_Fecha IS NOT NULL THEN
	    Lb_Fin_Movilizacion:= TRUE;
	 END IF;   
   
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('finMovilizacion',Lb_Fin_Movilizacion); 
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;
   EXCEPTION
    WHEN Le_Error THEN
     Pv_Status := 'ERROR';
     Pv_Mensaje := Lv_Error;
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
   END P_GET_EVENTO_TAREA;

  PROCEDURE P_GET_ADMI_PROCESO(Pcl_Request IN  CLOB,
                               Pv_Status    OUT VARCHAR2,
                               Pv_Mensaje   OUT VARCHAR2,
                               Prf_Response OUT SYS_REFCURSOR)
  AS

    Lr_AdmiProceso  ADMI_PROCESO%ROWTYPE;  
    Lcl_SelectFrom  CLOB;
    Lcl_Where       CLOB;
    Lcl_Query       CLOB;

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lr_AdmiProceso.Id_Proceso := APEX_JSON.get_varchar2(p_path => 'idProceso');
    Lr_AdmiProceso.Nombre_Proceso := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lr_AdmiProceso.Estado         :=  APEX_JSON.get_varchar2(p_path => 'estado');
    Lr_AdmiProceso.Proceso_Padre_Id := APEX_JSON.get_varchar2(p_path => 'procesoPadreId');
    Lr_AdmiProceso.Aplica_Estado := APEX_JSON.get_varchar2(p_path => 'aplicaEstado');
    Lr_AdmiProceso.Visible := APEX_JSON.get_varchar2(p_path => 'visible');
    Lr_AdmiProceso.PlanMantenimiento := APEX_JSON.get_varchar2(p_path => 'planMantenimiento');

    DBMS_LOB.CREATETEMPORARY(Lcl_SelectFrom, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Where, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, true);

    DBMS_LOB.APPEND(Lcl_SelectFrom,'SELECT * FROM DB_SOPORTE.ADMI_PROCESO apr ');

    IF Lr_AdmiProceso.Estado IS NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'WHERE apr.estado = ''Activo'' ');
    ELSE
      DBMS_LOB.APPEND(Lcl_Where,'WHERE apr.estado = '''||Lr_AdmiProceso.Estado||''' ');
    END IF;

    IF Lr_AdmiProceso.Id_Proceso IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND apr.id_proceso = '||Lr_AdmiProceso.Id_Proceso||' ');
    END IF;

    IF Lr_AdmiProceso.Nombre_Proceso IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND apr.nombre_proceso = '''||Lr_AdmiProceso.Nombre_Proceso||''' ');
    END IF;

    IF Lr_AdmiProceso.Proceso_Padre_Id IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND apr.proceso_padre_id = '||Lr_AdmiProceso.Proceso_Padre_Id||' ');
    END IF;

    IF Lr_AdmiProceso.Visible IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND apr.visible = '''||Lr_AdmiProceso.Visible||''' ');
    END IF;

    IF Lr_AdmiProceso.PlanMantenimiento IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND apr.planmantenimiento = '''||Lr_AdmiProceso.PlanMantenimiento||''' ');
    END IF;

    DBMS_LOB.APPEND(Lcl_Query,Lcl_SelectFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_Where);

    OPEN Prf_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Consulta exitosa';

  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := SQLERRM;
  END P_GET_ADMI_PROCESO;

  PROCEDURE P_GET_ADMI_TAREA(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Prf_Response OUT SYS_REFCURSOR)
  AS

    Lr_AdmiTarea  ADMI_TAREA%ROWTYPE;  
    Lcl_SelectFrom  CLOB;
    Lcl_Where       CLOB;
    Lcl_Query       CLOB;

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lr_AdmiTarea.Id_Tarea := APEX_JSON.get_varchar2(p_path => 'idTarea');
    Lr_AdmiTarea.Proceso_Id := APEX_JSON.get_varchar2(p_path => 'idProceso');
    Lr_AdmiTarea.Estado         :=  APEX_JSON.get_varchar2(p_path => 'estado');
    Lr_AdmiTarea.Nombre_Tarea := APEX_JSON.get_varchar2(p_path => 'nombreTarea');

    DBMS_LOB.CREATETEMPORARY(Lcl_SelectFrom, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Where, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, true);

    DBMS_LOB.APPEND(Lcl_SelectFrom,'SELECT * FROM DB_SOPORTE.ADMI_TAREA ata ');

    IF Lr_AdmiTarea.Estado IS NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'WHERE ata.estado = ''Activo'' ');
    ELSE
      DBMS_LOB.APPEND(Lcl_Where,'WHERE ata.estado = '''||Lr_AdmiTarea.Estado||''' ');
    END IF;

    IF Lr_AdmiTarea.Id_Tarea IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND ata.id_tarea = '||Lr_AdmiTarea.Id_Tarea||' ');
    END IF;

    IF Lr_AdmiTarea.Nombre_Tarea IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND ata.nombre_tarea = '''||Lr_AdmiTarea.Nombre_Tarea||''' ');
    END IF;

    IF Lr_AdmiTarea.Proceso_Id IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND ata.proceso_id = '||Lr_AdmiTarea.Proceso_Id||' ');
    END IF;


    DBMS_LOB.APPEND(Lcl_Query,Lcl_SelectFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_Where);

    OPEN Prf_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Consulta exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_GET_ADMI_TAREA;

  PROCEDURE P_GET_TAREAS(Pcl_Request  IN CLOB,
                         Pv_Status    OUT VARCHAR2,
                         Pv_Mensaje   OUT VARCHAR2,
                         Pcl_Response OUT CLOB) AS

    /**
     * C_GetHistorialTarea, obtiene el historial de una tarea (actividad)
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 15-11-2021
     * @costo   7, cardinalidad 3
     */
    CURSOR C_GetHistorialTarea(Cn_IdDetalle Number) IS
      SELECT
        Idh.*
      FROM
        Db_Soporte.Info_Detalle_Historial Idh
      WHERE
        Idh.Detalle_Id = Cn_IdDetalle
      ORDER BY Idh.fe_creacion ASC;
      
    /**
     * C_GetAsignacionTarea, obtiene información de asignación de la tarea
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   4, cardinalidad 1
     */
    CURSOR C_GetAsignacionTarea(Cn_IdDetalle Number, Cn_IdPersonaEmpresaRol Number) IS
      SELECT
        Ida.*
      FROM
        Info_Detalle_Asignacion Ida
      WHERE
        Ida.Detalle_Id = Cn_IdDetalle
        AND Ida.Persona_Empresa_Rol_Id = Cn_IdPersonaEmpresaRol
        AND ROWNUM = 1;   
        
    /**
     * C_GetAfectadosTarea, obtiene información de afectados de la tarea (actividad)
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   5, cardinalidad 1
     */
    CURSOR C_GetAfectadosTarea(Cn_IdDetalle Number, Cv_TipoAfectado Varchar2) IS
      SELECT
        Ipa.*
      FROM
             Db_Soporte.Info_Criterio_Afectado Ica
        INNER JOIN Db_Soporte.Info_Parte_Afectada Ipa ON Ica.Detalle_Id = Ipa.Detalle_Id
                                                         AND Ica.Id_Criterio_Afectado = Ipa.Criterio_Afectado_Id
      WHERE
        Ica.Detalle_Id = Cn_IdDetalle
         AND Initcap(Ipa.Tipo_Afectado) = Cv_TipoAfectado;
         
    /**
     * C_GetInfoPunto, obtiene información del punto afectado
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetInfoPunto(Cn_IdPunto Number) IS
      SELECT
        Ipu.*
      FROM
        Db_Comercial.Info_Punto Ipu
      WHERE
        Ipu.Id_Punto = Cn_IdPunto;
        
    /**
     * C_GetInfoPersona, obtiene información de la persona
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 15-11-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetInfoPersona(Cn_IdPersona Number) IS
      SELECT
        Ipe.*
      FROM
        Db_Comercial.Info_Persona Ipe
      WHERE
        Ipe.Id_Persona = Cn_IdPersona; 

    Lr_AdmiParametroDet DB_GENERAL.Admi_Parametro_Det%ROWTYPE;
    Lr_DocRelacion      DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE;
    Lc_DetalleAsigna    C_GetAsignacionTarea%ROWTYPE;
    Lc_InfoPunto        C_GetInfoPunto%ROWTYPE;
    Lc_InfoPersona      C_GetInfoPersona%ROWTYPE;
    Lv_CodEmpresa       DB_COMERCIAL.Info_Empresa_Grupo.cod_Empresa%TYPE;
    Lv_IdentCliente     DB_COMERCIAL.Info_Persona.Identificacion_Cliente%TYPE;
    Ln_IdComunicacion   DB_COMUNICACION.Info_Comunicacion.Id_Comunicacion%TYPE;
    Lv_NombreAfectado   Info_Parte_Afectada.Afectado_Nombre%TYPE;
    Lr_Tarea            SPKG_TYPES.Ltr_Tarea;
    Lr_Documento        SPKG_TYPES.Ltr_Documento;
    Lv_FeCreacionDesde  VARCHAR2(25);
    Lv_FeCreacionHasta  VARCHAR2(25);
    Lv_WhereFeCreacionD VARCHAR2(500);
    Lv_WhereFeCreacionH VARCHAR2(500);
    Lv_Estados          VARCHAR2(1000);
    Lv_Status           VARCHAR2(200);
    Lv_Mensaje          VARCHAR2(3000);
    Lrf_Tareas          SYS_REFCURSOR;
    Lrf_Documentos      SYS_REFCURSOR;
    Lcl_QuerySelect     CLOB;
    Lcl_QuerySelectCar  CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryFromCar    CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_QueryWhereCar   CLOB;
    Lcl_Query           CLOB;
    Lcl_Response        CLOB;
    Ln_CantidadEstados  NUMBER;
    Li_Cont             PLS_INTEGER;
    Li_Cont_Doc         PLS_INTEGER;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Lv_FeCreacionDesde := APEX_JSON.get_varchar2('fechaCreacionDesde');
    Lv_FeCreacionHasta := APEX_JSON.get_varchar2('fechaCreacionHasta');
    Lv_NombreAfectado := APEX_JSON.get_varchar2('nombreAfectado');
    Lv_IdentCliente := APEX_JSON.get_varchar2('identificacionCliente');
    Ln_IdComunicacion := APEX_JSON.get_number('numeroTarea');
    
    Ln_CantidadEstados := APEX_JSON.get_count('estados');

    IF NVL(Ln_CantidadEstados,0) > 0 THEN
      FOR i IN 1..Ln_CantidadEstados LOOP
        lv_estados := lv_estados ||''''||APEX_JSON.get_varchar2('estados[%d]',i)||''',';
      END LOOP;      
      IF lv_estados IS NOT NULL THEN
        lv_estados := Substr(Initcap(lv_estados),1,length(lv_estados)-1);
      END IF;    
    END IF;

    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelectCar, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFromCar, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhereCar, TRUE); 

    IF Lv_FeCreacionDesde IS NULL AND Ln_IdComunicacion IS NULL THEN
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_SOPORTE', 
                                                                  Pv_Descripcion       => 'DIAS_DEFAULT_PARA_CONSULTAR_TAREAS',
                                                                  Pv_Empresa_Cod       => Nvl(Lv_CodEmpresa,10),
                                                                  Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                                  Pv_Status            => Lv_Status,
                                                                  Pv_Mensaje           => Lv_Mensaje); 

      Lv_FeCreacionDesde := to_char(Sysdate - Lr_AdmiParametroDet.Valor1,'rrrr-mm-dd');
    END IF;

    IF Lv_FeCreacionHasta IS NULL THEN
      Lv_FeCreacionHasta := to_char(Sysdate,'rrrr-mm-dd hh24:mi:ss');
    ELSE
      IF LENGTH(Lv_FeCreacionHasta) = 10 THEN
        Lv_FeCreacionHasta := Lv_FeCreacionHasta || ' 23:59:59';
      END IF;
    END IF;

    DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT
                                      Ico.Id_Comunicacion AS numeroTarea,
                                      Ico.forma_Contacto_Id AS idFormaContacto,
                                      Afc.descripcion_Forma_Contacto AS formaContacto,
                                      Ico.Caso_Id AS idCaso,
                                      Ico.Detalle_Id AS idDetalle,
                                      Ide.observacion,
                                      Ico.fecha_comunicacion AS fechaCreacion,
                                      (
                                        SELECT
                                          Idhi.Estado
                                        FROM
                                          Db_Soporte.Info_Detalle_Historial Idhi
                                        WHERE
                                          Idhi.Id_Detalle_Historial = (
                                            SELECT
                                              MAX(Idh.Id_Detalle_Historial)
                                            FROM
                                              Db_Soporte.Info_Detalle_Historial Idh
                                            WHERE
                                              Idh.Detalle_Id = Ico.Detalle_Id
                                          )
                                      ) AS Estado,
                                      Ico.usr_Creacion AS usuarioCreacion,
                                      Ico.ip_Creacion AS ipCreacion,
                                      Ipa.Tipo_Afectado,
                                      Ipa.Afectado_Id ');
    DBMS_LOB.APPEND(Lcl_QueryFrom,'FROM
                                         Db_Comunicacion.Info_Comunicacion Ico
                                    INNER JOIN Db_Soporte.Info_Tarea             Ita ON Ico.id_Comunicacion = Ita.Numero_Tarea
                                    INNER JOIN Db_Soporte.Info_Detalle           Ide ON Ico.Detalle_Id = Ide.Id_Detalle
                                    INNER JOIN Db_Soporte.Info_Criterio_Afectado Ica ON Ide.Id_Detalle = Ica.Detalle_Id
                                    INNER JOIN Db_Soporte.Info_Parte_Afectada    Ipa ON Ica.Detalle_Id = Ipa.Detalle_Id
                                                                                     AND Ica.Id_Criterio_Afectado = Ipa.Criterio_Afectado_Id
                                    INNER JOIN Db_Comercial.Info_Punto Ipu ON Ipa.Afectado_Id = Ipu.Id_Punto  
                                    INNER JOIN Db_Comercial.Info_Persona_Empresa_Rol Iper ON Ipu.Persona_Empresa_Rol_Id = Iper.id_Persona_Rol
                                    INNER JOIN Db_Comercial.Info_Persona Ipe ON Iper.Persona_Id = Ipe.Id_Persona
                                    INNER JOIN Db_Comercial.Admi_Forma_Contacto Afc ON Ico.Forma_Contacto_Id = Afc.id_Forma_Contacto ');
    
    DBMS_LOB.APPEND(Lcl_QuerySelectCar,'SELECT
                                      Ico.Id_Comunicacion AS numeroTarea,
                                      Ico.forma_Contacto_Id AS idFormaContacto,
                                      Afc.descripcion_Forma_Contacto AS formaContacto,
                                      Ico.Caso_Id AS idCaso,
                                      Ico.Detalle_Id AS idDetalle,
                                      Ide.observacion,
                                      Ico.fecha_comunicacion AS fechaCreacion,
                                      (
                                        SELECT
                                          Idhi.Estado
                                        FROM
                                          Db_Soporte.Info_Detalle_Historial Idhi
                                        WHERE
                                          Idhi.Id_Detalle_Historial = (
                                            SELECT
                                              MAX(Idh.Id_Detalle_Historial)
                                            FROM
                                              Db_Soporte.Info_Detalle_Historial Idh
                                            WHERE
                                              Idh.Detalle_Id = Ico.Detalle_Id
                                          )
                                      ) AS Estado,
                                      Ico.usr_Creacion AS usuarioCreacion,
                                      Ico.ip_Creacion AS ipCreacion,
                                      Aca.Descripcion_Caracteristica ,
                                      To_Number(Itc.Valor) ');
                                      
    DBMS_LOB.APPEND(Lcl_QueryFromCar,'FROM
                                         Db_Comunicacion.Info_Comunicacion Ico
                                    INNER JOIN Db_Soporte.Info_Detalle           Ide ON Ico.Detalle_Id = Ide.Id_Detalle
                                    INNER JOIN Db_Soporte.Info_Tarea_Caracteristica Itc ON Ide.Id_Detalle = Itc.Detalle_Id
                                    INNER JOIN Db_Comercial.Admi_Caracteristica Aca ON Itc.Caracteristica_Id = Aca.Id_Caracteristica
                                    INNER JOIN Db_Comercial.Info_Persona Ipe ON Itc.Valor = Ipe.Id_Persona
                                    INNER JOIN Db_Comercial.Admi_Forma_Contacto Afc ON Ico.Forma_Contacto_Id = Afc.id_Forma_Contacto ');                                    

    IF Ln_IdComunicacion IS NULL THEN
      Lv_WhereFeCreacionD := 'WHERE Ico.Fecha_Comunicacion >= To_Date('':feCreacionD'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeCreacionH:= 'AND Ico.Fecha_Comunicacion <= To_Date('':feCreacionH'',''rrrr-mm-dd hh24:mi:ss'') ';
  
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeCreacionD, ':feCreacionD', Lv_FeCreacionDesde));
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE(Lv_WhereFeCreacionH, ':feCreacionH', Lv_FeCreacionHasta));
      
      DBMS_LOB.APPEND(Lcl_QueryWhereCar,REPLACE(Lv_WhereFeCreacionD, ':feCreacionD', Lv_FeCreacionDesde));
      DBMS_LOB.APPEND(Lcl_QueryWhereCar,REPLACE(Lv_WhereFeCreacionH, ':feCreacionH', Lv_FeCreacionHasta));
    ELSE
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('WHERE Ico.Id_Comunicacion = :idComunicacion ', ':idComunicacion', Ln_IdComunicacion));
      DBMS_LOB.APPEND(Lcl_QueryWhereCar,REPLACE('WHERE Ico.Id_Comunicacion = :idComunicacion ', ':idComunicacion', Ln_IdComunicacion));
    END IF;
    
    DBMS_LOB.APPEND(Lcl_QueryWhereCar,'AND Aca.Descripcion_Caracteristica = ''REFERENCIA_PERSONA'' ');
        
    IF Lv_CodEmpresa IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ico.Empresa_Cod = '':codEmpresa'' ',':codEmpresa',Lv_CodEmpresa));  
      DBMS_LOB.APPEND(Lcl_QueryWhereCar,REPLACE('AND Ico.Empresa_Cod = '':codEmpresa'' ',':codEmpresa',Lv_CodEmpresa));  
    END IF;

    IF Lv_NombreAfectado IS NOT NULL THEN
       DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Ipa.Afectado_Nombre = '''||Lv_NombreAfectado||''' ');
    END IF;

    IF Lv_IdentCliente IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ipe.Identificacion_Cliente = '':idenCliente'' ',':idenCliente',Lv_IdentCliente));   
      DBMS_LOB.APPEND(Lcl_QueryWhereCar,REPLACE('AND Ipe.Identificacion_Cliente = '':idenCliente'' ',':idenCliente',Lv_IdentCliente)); 
    END IF;
    
    DBMS_LOB.APPEND(Lcl_QueryWhereCar,'AND not exists (SELECT ''X'' FROM Db_Soporte.Info_Criterio_Afectado Ica WHERE Ica.Detalle_Id = Ide.Id_Detalle) ');

    DBMS_LOB.APPEND(Lcl_Query,'SELECT tab.* FROM ( ');
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    
    IF Lv_NombreAfectado IS NULL AND Lv_IdentCliente IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Query,'Union All ');
      DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelectCar);
      DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFromCar);
      DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhereCar);
    END IF;
    
    DBMS_LOB.APPEND(Lcl_Query,') tab ');  

    IF Lv_Estados IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Query,'WHERE tab.estado IN ('||Lv_Estados||') ');
    END IF;

    DBMS_LOB.APPEND(Lcl_Query,'ORDER BY tab.fechaCreacion DESC');
    
    OPEN Lrf_Tareas FOR Lcl_Query;
    
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY();
    LOOP
      FETCH Lrf_Tareas BULK COLLECT INTO Lr_Tarea LIMIT 100;
        Li_Cont := Lr_Tarea.FIRST;
        WHILE (Li_Cont IS NOT NULL) LOOP
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('numeroTarea', Lr_Tarea(Li_Cont).Numero_Tarea);
          APEX_JSON.WRITE('idFormaContacto', Lr_Tarea(Li_Cont).Id_Forma_Contacto);
          APEX_JSON.WRITE('formaContacto', Lr_Tarea(Li_Cont).Forma_Contacto);
          APEX_JSON.WRITE('idCaso', Lr_Tarea(Li_Cont).Id_Caso);
          APEX_JSON.WRITE('idDetalle', Lr_Tarea(Li_Cont).Id_Detalle);
          APEX_JSON.WRITE('observacion', Lr_Tarea(Li_Cont).Observacion);
          APEX_JSON.WRITE('fechaCreacion', Lr_Tarea(Li_Cont).Fe_Creacion);
          APEX_JSON.WRITE('estado', Lr_Tarea(Li_Cont).Estado);
          APEX_JSON.WRITE('usuarioCreacion', Lr_Tarea(Li_Cont).Usr_Creacion);
          APEX_JSON.WRITE('ipCreacion', Lr_Tarea(Li_Cont).Ip_Creacion);
          
          APEX_JSON.OPEN_ARRAY('historial');
          FOR i in C_GetHistorialTarea(Lr_Tarea(Li_Cont).Id_Detalle) LOOP
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('fechaCambioEstado', i.Fe_Creacion);
            APEX_JSON.WRITE('estado', i.Estado);
            APEX_JSON.WRITE('accion', i.Accion);
            APEX_JSON.WRITE('observacion', i.Observacion);
            
            APEX_JSON.OPEN_OBJECT('detalleAsignacion');
            OPEN C_GetAsignacionTarea(Lr_Tarea(Li_Cont).Id_Detalle,i.Persona_Empresa_Rol_Id);
            FETCH C_GetAsignacionTarea INTO Lc_DetalleAsigna;
            CLOSE C_GetAsignacionTarea;
            APEX_JSON.WRITE('idAsignado', Lc_DetalleAsigna.Asignado_Id);
            APEX_JSON.WRITE('nombreAsignado', Lc_DetalleAsigna.Asignado_Nombre);
            APEX_JSON.WRITE('refIdAsignado', Lc_DetalleAsigna.Ref_Asignado_Id);
            APEX_JSON.WRITE('refNombreAsignado', Lc_DetalleAsigna.Ref_Asignado_Nombre);
            APEX_JSON.WRITE('idPersonaEmpresaRol', Lc_DetalleAsigna.Persona_Empresa_Rol_Id);
            APEX_JSON.WRITE('tipoAsignado', Lc_DetalleAsigna.Tipo_Asignado);              
            APEX_JSON.CLOSE_OBJECT;            
            
            APEX_JSON.CLOSE_OBJECT;
          END LOOP;
          APEX_JSON.CLOSE_ARRAY; 
          
          APEX_JSON.OPEN_ARRAY('afectados');          
          IF Lr_Tarea(Li_Cont).Tipo_Afectado = 'REFERENCIA_PERSONA' THEN
            
            OPEN C_GetInfoPersona(Lr_Tarea(Li_Cont).Afectado_Id);
            FETCH C_GetInfoPersona INTO Lc_InfoPersona;
            CLOSE C_GetInfoPersona;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('tipoAfectado', Lr_Tarea(Li_Cont).Tipo_Afectado);
            APEX_JSON.WRITE('idAfectado', Lr_Tarea(Li_Cont).Afectado_Id);
            IF Lc_InfoPersona.Razon_Social IS NOT NULL THEN
              APEX_JSON.WRITE('descripcionAfectado', Lc_InfoPersona.Razon_Social);
            ELSE
              APEX_JSON.WRITE('descripcionAfectado', Lc_InfoPersona.Nombres ||' '|| Lc_InfoPersona.Apellidos);
            END IF;
            APEX_JSON.CLOSE_OBJECT;
          ELSE
            FOR i in C_GetAfectadosTarea(Lr_Tarea(Li_Cont).Id_Detalle,'Cliente') LOOP
              APEX_JSON.OPEN_OBJECT;
              APEX_JSON.WRITE('tipoAfectado', i.Tipo_Afectado);
              APEX_JSON.WRITE('idAfectado', i.Afectado_Id);
              APEX_JSON.WRITE('nombreAfectado', i.Afectado_Nombre);
              APEX_JSON.WRITE('descripcionAfectado', i.Afectado_Descripcion);
              
              IF Initcap(i.Tipo_Afectado) = 'Cliente' THEN
                APEX_JSON.OPEN_OBJECT('detallePunto');
                OPEN C_GetInfoPunto(i.Afectado_Id);
                FETCH C_GetInfoPunto INTO Lc_InfoPunto;
                CLOSE C_GetInfoPunto;
                APEX_JSON.WRITE('direccion', Lc_InfoPunto.Direccion);
                APEX_JSON.WRITE('latitud', Lc_InfoPunto.Latitud);
                APEX_JSON.WRITE('longitud', Lc_InfoPunto.Longitud);
                APEX_JSON.WRITE('idPuntoCobertura', Lc_InfoPunto.Punto_Cobertura_Id);
                APEX_JSON.WRITE('idTipoUbicacion', Lc_InfoPunto.Tipo_Ubicacion_Id);
                APEX_JSON.WRITE('idSector', Lc_InfoPunto.Sector_Id);
                APEX_JSON.WRITE('idTipoNegocio', Lc_InfoPunto.Tipo_Negocio_Id);
                APEX_JSON.CLOSE_OBJECT;
              END IF;           
              
              APEX_JSON.CLOSE_OBJECT;
            END LOOP;
          END IF;          
          APEX_JSON.CLOSE_ARRAY;
          
          Lr_DocRelacion.Detalle_Id := Lr_Tarea(Li_Cont).Id_Detalle;
          Lr_DocRelacion.Estado := 'Activo';
          
          DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA.P_GET_DOCUMENTOS_RELACIONADOS(Pr_DocumentoRelacion => Lr_DocRelacion,
                                                                                     Pv_Status            => Lv_Status,
                                                                                     Pv_Mensaje           => Lv_Mensaje,
                                                                                     Prf_Response         => Lrf_Documentos);
          
          APEX_JSON.OPEN_ARRAY('documentos');
          LOOP
            FETCH Lrf_Documentos BULK COLLECT INTO Lr_Documento LIMIT 100;
              Li_Cont_Doc := Lr_Documento.FIRST;
              WHILE (Li_Cont_Doc IS NOT NULL) LOOP
                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.WRITE('idDocumento',Lr_Documento(Li_Cont_Doc).Id_Documento);
                APEX_JSON.WRITE('nombreDocumento', Lr_Documento(Li_Cont_Doc).Ubicacion_Logica_Documento);
                APEX_JSON.WRITE('rutaDocumento', Lr_Documento(Li_Cont_Doc).Ubicacion_Fisica_Documento);
                APEX_JSON.CLOSE_OBJECT;
                Li_Cont_Doc:= Lr_Documento.NEXT(Li_Cont_Doc);
              END LOOP;
            EXIT WHEN Lrf_Documentos%NOTFOUND;
          END LOOP;              
          APEX_JSON.CLOSE_ARRAY;
          
          APEX_JSON.CLOSE_OBJECT;
          Li_Cont:= Lr_Tarea.NEXT(Li_Cont);
        END LOOP;
      EXIT WHEN Lrf_Tareas%NOTFOUND;
    END LOOP;
    APEX_JSON.CLOSE_ARRAY;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_TAREAS;
   


  PROCEDURE P_CAMBIAR_ESTADO_TAREA(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB) IS

      --Variables para el query dinámico
      Lrf_Parametros        SYS_REFCURSOR;

      Lv_IdComunicacion     VARCHAR2(20);
      Lv_DetalleId          VARCHAR2(20);
      Lv_Estado             VARCHAR2(200);
      Lv_Observacion        VARCHAR2(2000);
      Lv_UsrCreacion        VARCHAR2(20);
      Lv_Adjuntos           VARCHAR2(20);
      Le_Errors             EXCEPTION;

      Ln_cantAdjuntos       NUMBER := 0;
      Ln_cantParametros     NUMBER := 0;
      Ln_cantParamEstPerm   NUMBER := 0;

      Lv_MensajeError       VARCHAR2(4000);
      Ln_TotalRegistros     NUMBER := 0;
      Lo_TareaSeguimiento   DB_SOPORTE.INFO_TAREA_SEGUIMIENTO%ROWTYPE;
      Lo_DetalleHistorial   DB_SOPORTE.INFO_DETALLE_HISTORIAL%ROWTYPE;

      Lv_RequestSolPlanif   CLOB;
      Lv_StatusSolPlanif    VARCHAR2(200);
      Lv_MensajeSolPlanif   VARCHAR2(200);
      Lv_RequestSolicitud   CLOB;
      Lv_StatusSolicitud    VARCHAR2(200);
      Lv_MensajeSolicitud   VARCHAR2(200);
        
      Lv_Status_info_tarea  VARCHAR2(200);
      Lv_Mensaje_info_tarea VARCHAR2(200);

      Ln_IdSolPlanif        NUMBER;
      Ln_IdDetalleSolicitud NUMBER;
      Lv_UltimoEstado       VARCHAR2(20);

      Lv_parametroEstados   VARCHAR2(2000);

      Ln_esEstadoPermitido  NUMBER := 0;

      Lr_InfoDocumento      DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE;
      Ln_IdDocumento        DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
      Lv_MsjErrorDocumento  VARCHAR2(4000);
      Lr_InfoDocumentoRel   DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE;
      Ln_IdDocumentoRel     DB_COMUNICACION.INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE;
      Lv_MsjErrorDocumentRe VARCHAR2(4000);

        CURSOR C_GetIdDetalleTarea(Cn_idComunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
        IS
          SELECT COM.DETALLE_ID
          FROM DB_COMUNICACION.INFO_COMUNICACION COM
          WHERE COM.ID_COMUNICACION = Cn_idComunicacion;

        CURSOR C_GetDetalleTarea(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
          SELECT DET.ID_DETALLE
          FROM DB_SOPORTE.INFO_DETALLE DET
          WHERE DET.ID_DETALLE = Cn_idDetalle;

        CURSOR C_GetUltimoEstadoTarea(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
         SELECT idh1.ESTADO
         FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1
         WHERE
         ID_DETALLE_HISTORIAL =
         (
               SELECT MAX(idh.id_detalle_historial)
               FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh WHERE idh.DETALLE_ID = Cn_idDetalle
         );

        CURSOR C_GetIdSolicitudPlanif(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
          SELECT SP.ID_DETALLE_SOL_PLANIF, SP.DETALLE_SOLICITUD_ID
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SP
          JOIN DB_COMUNICACION.INFO_COMUNICACION COM ON COM.ID_COMUNICACION = SP.TAREA_ID
          WHERE COM.DETALLE_ID = Cn_idDetalle;

        CURSOR C_GetParametros(Cv_nombreParametro VARCHAR2, Cv_descripcionParamDet VARCHAR2)
        IS
            SELECT APD.* 
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                   DB_GENERAL.ADMI_PARAMETRO_DET APD 
                   WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                   AND APC.ESTADO = 'Activo' 
                   AND APD.EMPRESA_COD = '10'
                   AND APD.ESTADO = 'Activo'
                   AND APC.NOMBRE_PARAMETRO = Cv_nombreParametro 
                   AND APD.DESCRIPCION = Cv_descripcionParamDet;

    BEGIN

      apex_json.parse(Pcl_Request);
      Lv_IdComunicacion         := apex_json.get_varchar2('idComunicacion');
      Lv_DetalleId              := apex_json.get_varchar2('detalleId');
      Lv_Estado                 := apex_json.get_varchar2('estado');
      Lv_Observacion            := apex_json.get_varchar2('observacion');
      Lv_UsrCreacion            := apex_json.get_varchar2('registerUser');

      IF Lv_IdComunicacion IS NULL AND Lv_DetalleId IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos uno de los siguientes parámetros idComunicacion o detalleId';
          RAISE Le_Errors;
      END IF;

      IF Lv_Estado IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos un estado';
          RAISE Le_Errors;
      END IF;

      IF Lv_UsrCreacion IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar un registerUser';
          RAISE Le_Errors;
      END IF;

      IF Lv_DetalleId IS NOT NULL THEN
            OPEN C_GetDetalleTarea(Lv_DetalleId);
            FETCH C_GetDetalleTarea INTO Lv_DetalleId;
            IF C_GetDetalleTarea%NOTFOUND THEN
               Lv_DetalleId := NULL;
            END IF;
            CLOSE C_GetDetalleTarea;
      END IF;

      IF Lv_IdComunicacion IS NOT NULL THEN
            Lv_DetalleId := NULL;
            OPEN C_GetIdDetalleTarea(Lv_IdComunicacion);
            FETCH C_GetIdDetalleTarea INTO Lv_DetalleId;
            IF C_GetIdDetalleTarea%NOTFOUND THEN
               Lv_DetalleId := NULL;
            END IF;
            CLOSE C_GetIdDetalleTarea;
      END IF;

      IF Lv_DetalleId IS NULL THEN
         Pv_Mensaje := 'ERROR: No se encontro el detalle de la tarea con el idComunicacion enviado';
         RAISE Le_Errors;
      END IF;

      --CONSULTAR EL ULTIMO ESTADO DE LA TAREA
      IF C_GetUltimoEstadoTarea%ISOPEN THEN
            CLOSE C_GetUltimoEstadoTarea;
      END IF;
      OPEN C_GetUltimoEstadoTarea(Lv_DetalleId);
      FETCH C_GetUltimoEstadoTarea INTO Lv_UltimoEstado;
      IF C_GetUltimoEstadoTarea%NOTFOUND THEN
         Lv_UltimoEstado := NULL;
      END IF;
      CLOSE C_GetUltimoEstadoTarea;

      --VALIDAR QUE LA TAREA TENGA PERMITIDO EL CAMBIO DE ESTADO
      IF (C_GetParametros%isopen) THEN 
         CLOSE C_GetParametros;
      END IF;
      FOR parametros IN C_GetParametros('INSP_CALC_PARAM_INSPECTION','ALLOWED_CHANGE_STATUS') LOOP
          Lv_parametroEstados := parametros.VALOR1;
      END LOOP;

      apex_json.parse('{"data":'||Lv_parametroEstados||'}');
      Ln_cantParametros := apex_json.get_count(p_path => 'data');

      IF Ln_cantParametros > 0 THEN

         FOR j IN 1 .. Ln_cantParametros LOOP
            IF Lv_UltimoEstado = apex_json.get_varchar2('data[%d].currentStatus',p0 => j) THEN
               Ln_cantParamEstPerm := apex_json.get_count(p_path => 'data[%d].allowedStatus',p0 => j);
               IF Ln_cantParamEstPerm > 0 THEN
                  FOR a IN 1 .. Ln_cantParamEstPerm LOOP
                     IF Lv_Estado = apex_json.get_varchar2(p_path => 'data[%d].allowedStatus[%d].status', p0 => j, p1 => a) THEN
                           Ln_esEstadoPermitido := Ln_esEstadoPermitido + 1;
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;

      END IF;

      IF Ln_esEstadoPermitido <= 0 THEN
         Pv_Mensaje:= 'No es permitido cambiar esta tarea de ('||Lv_UltimoEstado||') a ('||Lv_Estado||')';
         RAISE Le_Errors;
      END IF;

      --SE AGREGA REGISTRO EN LA INFO_TAREA_SEGUIMIENTO
      Lo_TareaSeguimiento   := NULL;
      Lv_MensajeError       := '';

      Lo_TareaSeguimiento.DETALLE_ID    := Lv_DetalleId;
      Lo_TareaSeguimiento.OBSERVACION   := 'Se cambia estado de la tarea a '||Lv_Estado||' por el motivo: ' || Lv_Observacion;
      Lo_TareaSeguimiento.USR_CREACION  := Lv_UsrCreacion;
      Lo_TareaSeguimiento.ESTADO_TAREA  := Lv_Estado;

      DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO(Lo_TareaSeguimiento, Lv_MensajeError);

      IF TRIM(Lv_MensajeError) IS NOT NULL THEN
         Pv_Mensaje := Lv_MensajeError;
         RAISE Le_Errors;
      END IF;

      --SE AGREGA REGISTRO EN LA INFO_DETALLE_HISTORIAL
      Lo_DetalleHistorial   := NULL;
      Lv_MensajeError       := '';

      Lo_DetalleHistorial.DETALLE_ID    := Lv_DetalleId;
      Lo_DetalleHistorial.OBSERVACION   := 'Se cambio estado de la tarea a '||Lv_Estado||' por el motivo: ' || Lv_Observacion;
      Lo_DetalleHistorial.USR_CREACION  := Lv_UsrCreacion;
      Lo_DetalleHistorial.ESTADO        := Lv_Estado;
      Lo_DetalleHistorial.IP_CREACION   := '127.0.0.1';

      DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL(Lo_DetalleHistorial, Lv_MensajeError);

      IF TRIM(Lv_MensajeError) IS NOT NULL THEN
         Pv_Mensaje := Lv_MensajeError;
         RAISE Le_Errors;
      END IF;

      --SE ADJUNTA DOCUMENTOS A LA TAREA SI ES REQUERIDO
      apex_json.parse(Pcl_Request);
      Ln_cantAdjuntos           := apex_json.get_count(p_path => 'adjuntos');
      Lv_Adjuntos := '';
      IF Ln_cantAdjuntos > 0 THEN

        FOR j IN 1 .. Ln_cantAdjuntos LOOP

            Ln_IdDocumento := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
            Lr_InfoDocumento.ID_DOCUMENTO := Ln_IdDocumento;
            Lr_InfoDocumento.TIPO_DOCUMENTO_ID := apex_json.get_varchar2(p_path => 'adjuntos[%d].tipoDocumentoId',p0 => j);
            Lr_InfoDocumento.NOMBRE_DOCUMENTO := apex_json.get_varchar2(p_path => 'adjuntos[%d].nombreDocumento',p0 => j);
            Lr_InfoDocumento.MENSAJE := apex_json.get_varchar2(p_path => 'adjuntos[%d].mensaje',p0 => j);
            Lr_InfoDocumento.UBICACION_FISICA_DOCUMENTO := apex_json.get_varchar2(p_path => 'adjuntos[%d].ubicacionFisica',p0 => j);
            Lr_InfoDocumento.UBICACION_LOGICA_DOCUMENTO := apex_json.get_varchar2(p_path => 'adjuntos[%d].ubicacionLogica',p0 => j);
            Lr_InfoDocumento.ESTADO := apex_json.get_varchar2(p_path => 'adjuntos[%d].estado',p0 => j);
            Lr_InfoDocumento.FE_CREACION := SYSDATE;
            Lr_InfoDocumento.FECHA_DOCUMENTO := SYSDATE;
            Lr_InfoDocumento.IP_CREACION := '127.0.0.1';
            Lr_InfoDocumento.USR_CREACION := apex_json.get_varchar2(p_path => 'adjuntos[%d].registerUser',p0 => j);
            Lr_InfoDocumento.EMPRESA_COD := apex_json.get_varchar2(p_path => 'adjuntos[%d].empresaCod',p0 => j);
            Lr_InfoDocumento.LATITUD := apex_json.get_varchar2(p_path => 'adjuntos[%d].latitud',p0 => j);
            Lr_InfoDocumento.LONGITUD := apex_json.get_varchar2(p_path => 'adjuntos[%d].longitud',p0 => j);

            Lv_MsjErrorDocumento := 'OK';
            DB_COMUNICACION.CUKG_UTILS.P_INSERT_INFO_DOCUMENTO(Lr_InfoDocumento, Lv_MsjErrorDocumento);
            
            IF Lv_MsjErrorDocumento <> 'OK' THEN
                  Pv_Mensaje := 'Ocurrio un Error: '|| Lv_MsjErrorDocumento;
                  RAISE Le_Errors;
            END IF;

            Ln_IdDocumentoRel := DB_COMUNICACION.SEQ_INFO_DOCUMENTO_RELACION.NEXTVAL;
            Lr_InfoDocumentoRel.ID_DOCUMENTO_RELACION := Ln_IdDocumentoRel;
            Lr_InfoDocumentoRel.MODULO := 'SOPORTE';
            Lr_InfoDocumentoRel.ESTADO := Lr_InfoDocumento.ESTADO;
            Lr_InfoDocumentoRel.FE_CREACION := SYSDATE;
            Lr_InfoDocumentoRel.USR_CREACION := Lr_InfoDocumento.USR_CREACION;
            Lr_InfoDocumentoRel.DETALLE_ID := Lv_DetalleId;
            Lr_InfoDocumentoRel.DOCUMENTO_ID := Lr_InfoDocumento.ID_DOCUMENTO;

            Lv_MsjErrorDocumentRe := 'OK';
            DB_COMUNICACION.CUKG_UTILS.P_INSERT_INFO_DOCUMENTO_RELAC(Lr_InfoDocumentoRel, Lv_MsjErrorDocumentRe);

            IF Lv_MsjErrorDocumentRe <> 'OK' THEN
                  Pv_Mensaje := 'Ocurrio un Error: '|| Lv_MsjErrorDocumentRe;
                  RAISE Le_Errors;
            END IF;

        END LOOP;
      END IF;

      --SI SE FINALIZA TAREA LLAMA A PROCEDIMIENTO DE FINALIZAR TAREA
      IF UPPER(Lv_Estado) = 'FINALIZADA' THEN

          --OBTIENE ID DE PLANIFICACION DE SOLICITUD
            IF C_GetIdSolicitudPlanif%ISOPEN THEN
                  CLOSE C_GetIdSolicitudPlanif;
            END IF;
            OPEN C_GetIdSolicitudPlanif(Lv_DetalleId);
            FETCH C_GetIdSolicitudPlanif INTO Ln_IdSolPlanif,Ln_IdDetalleSolicitud;
            IF C_GetIdSolicitudPlanif%NOTFOUND THEN
               Ln_IdSolPlanif := NULL;
            END IF;
            CLOSE C_GetIdSolicitudPlanif;

            IF Ln_IdSolPlanif IS NOT NULL THEN
               --CAMBIA ESTADO A SOLICITUD
               APEX_JSON.INITIALIZE_CLOB_OUTPUT;
               APEX_JSON.OPEN_OBJECT;
               APEX_JSON.WRITE('idDetalleSolPlanif'  , Ln_IdSolPlanif);
               APEX_JSON.WRITE('idDetalleSolicitud'  , Ln_IdDetalleSolicitud);
               APEX_JSON.WRITE('estado'      , 'Finalizada');
               APEX_JSON.WRITE('accion'      , 'CAMBIAR_ESTADO');
               APEX_JSON.WRITE('usrCreacion'  , Lv_UsrCreacion);
               APEX_JSON.WRITE('ipCreacion'  , '127.0.0.1');
               APEX_JSON.WRITE('observacion'  , Lv_Observacion);
               APEX_JSON.CLOSE_OBJECT;
               Lv_RequestSolPlanif := APEX_JSON.GET_CLOB_OUTPUT;
               APEX_JSON.FREE_OUTPUT;

               --EJECUTA FINALIZACION DE PLANIFICACION DE LA SOLICITUD ASOCIADA A LA TAREA
               DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_CAMBIAR_ESTADO_PLANIF_SOL(Lv_RequestSolPlanif, Lv_StatusSolPlanif, Lv_MensajeSolPlanif);

               IF Lv_StatusSolPlanif <> 'OK' THEN
                  Pv_Mensaje := 'Ocurrio error en procedimiento DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_CAMBIAR_ESTADO_PLANIF_SOL, Mensaje:' || 
                                Lv_MensajeSolPlanif;
                  RAISE Le_Errors;
               END IF; 
            END IF;

      END IF;

      COMMIT;

      --ACTUALIZAR DETALLE EN INFO_TAREA
      DB_SOPORTE.SPKG_INFO_TAREA.P_UPDATE_TAREA( Lv_DetalleId,
                                                Lv_UsrCreacion,
                                                Lv_Status_info_tarea,
                                                Lv_Mensaje_info_tarea);
          Pv_Status  := 'ok';
          Pv_Mensaje := 'Actualización de tarea ejecutada correctamente';
          Pcl_Response := Pv_Mensaje;

    EXCEPTION
      WHEN Le_Errors THEN

          ROLLBACK;

          Pv_Status  := 'ERROR';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE_TAREA',
                                              'P_CAMBIAR_ESTADO_TAREA',
                                                Pv_Mensaje,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      WHEN OTHERS THEN

          ROLLBACK;

          Pv_Status  := 'fail';
          Pv_Mensaje := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE_TAREA',
                                              'P_CAMBIAR_ESTADO_TAREA',
                                                'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_CAMBIAR_ESTADO_TAREA;

  PROCEDURE P_REVERSAR_ESTADO_TAREA(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB) IS

      --Variables para el query dinámico
      Lrf_Parametros        SYS_REFCURSOR;
      Lv_IdComunicacion     VARCHAR2(20);
      Lv_DetalleId          VARCHAR2(20);
      Lv_Estado             VARCHAR2(200);
      Lv_Observacion        VARCHAR2(2000);
      Lv_UsrCreacion        VARCHAR2(20);
      Le_Errors             EXCEPTION;
      Ln_cantAdjuntos       NUMBER := 0;
      Lv_RequestSolPlanif   CLOB;
      Lv_StatusSolPlanif    VARCHAR2(200);
      Lv_MensajeSolPlanif   VARCHAR2(200);
      Ln_IdSolPlanif        NUMBER;
      Lv_UltimoEstado       VARCHAR2(20);
      Lv_parametroEstados   VARCHAR2(2000);
      Ln_esEstadoPermitido  NUMBER := 0;
      Lv_Status_info_tarea  VARCHAR2(200);
      Lv_Mensaje_info_tarea VARCHAR2(200);

      Lr_InfoDocumento      DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE;
      Lr_InfoDetalleHistAnt DB_SOPORTE.INFO_DETALLE_HISTORIAL%ROWTYPE;
      Lr_InfoDetalleHistUlt DB_SOPORTE.INFO_DETALLE_HISTORIAL%ROWTYPE;
      Lr_InfoTareaSeguimUlt DB_SOPORTE.INFO_TAREA_SEGUIMIENTO%ROWTYPE;
      Lr_InfoDocumentRelac  DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE;

        CURSOR C_GetIdDetalleTarea(Cn_idComunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
        IS
          SELECT COM.DETALLE_ID
          FROM DB_COMUNICACION.INFO_COMUNICACION COM
          WHERE COM.ID_COMUNICACION = Cn_idComunicacion;

        CURSOR C_GetDetalleTarea(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
          SELECT DET.ID_DETALLE
          FROM DB_SOPORTE.INFO_DETALLE DET
          WHERE DET.ID_DETALLE = Cn_idDetalle;

        CURSOR C_GetIdSolicitudPlanif(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
          SELECT SP.ID_DETALLE_SOL_PLANIF
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SP
          JOIN DB_COMUNICACION.INFO_COMUNICACION COM ON COM.ID_COMUNICACION = SP.TAREA_ID
          WHERE COM.DETALLE_ID = Cn_idDetalle;

        CURSOR C_GetUltimoDetalleHist(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
         SELECT idh1.*
         FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1
         WHERE
         ID_DETALLE_HISTORIAL =
         (
               SELECT MAX(idh.id_detalle_historial)
               FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh WHERE idh.DETALLE_ID = Cn_idDetalle
         );

        CURSOR C_GetUltimoDetalleSeg(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
        IS
         SELECT its1.*
         FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its1
         WHERE
         ID_SEGUIMIENTO =
         (
               SELECT MAX(its.ID_SEGUIMIENTO)
               FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its WHERE its.DETALLE_ID = Cn_idDetalle
         );

        CURSOR C_GetDocumento(Cn_idDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
                              Cn_nombreDocumento DB_COMUNICACION.INFO_DOCUMENTO.NOMBRE_DOCUMENTO%TYPE,
                              Cn_ubicFisicaDoc DB_COMUNICACION.INFO_DOCUMENTO.UBICACION_FISICA_DOCUMENTO%TYPE)
        IS
          SELECT docr.*
          FROM DB_COMUNICACION.INFO_DOCUMENTO doc
          JOIN DB_COMUNICACION.INFO_DOCUMENTO_RELACION docr ON docr.DOCUMENTO_ID = doc.ID_DOCUMENTO
          WHERE docr.DETALLE_ID = Cn_idDetalle 
          AND doc.NOMBRE_DOCUMENTO = Cn_nombreDocumento 
          AND doc.UBICACION_FISICA_DOCUMENTO = Cn_ubicFisicaDoc;

   BEGIN
      apex_json.parse(Pcl_Request);
      Lv_IdComunicacion         := apex_json.get_varchar2('idComunicacion');
      Lv_DetalleId              := apex_json.get_varchar2('detalleId');
      Lv_Estado                 := apex_json.get_varchar2('estado');
      Lv_Observacion            := apex_json.get_varchar2('observacion');
      Lv_UsrCreacion            := apex_json.get_varchar2('registerUser');

      IF Lv_IdComunicacion IS NULL AND Lv_DetalleId IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos uno de los siguientes parámetros idComunicacion o detalleId';
          RAISE Le_Errors;
      END IF;

      IF Lv_DetalleId IS NOT NULL THEN
            OPEN C_GetDetalleTarea(Lv_DetalleId);
            FETCH C_GetDetalleTarea INTO Lv_DetalleId;
            IF C_GetDetalleTarea%NOTFOUND THEN
               Lv_DetalleId := NULL;
            END IF;
            CLOSE C_GetDetalleTarea;
      END IF;

      IF Lv_IdComunicacion IS NOT NULL THEN
            Lv_DetalleId := NULL;
            OPEN C_GetIdDetalleTarea(Lv_IdComunicacion);
            FETCH C_GetIdDetalleTarea INTO Lv_DetalleId;
            IF C_GetIdDetalleTarea%NOTFOUND THEN
               Lv_DetalleId := NULL;
            END IF;
            CLOSE C_GetIdDetalleTarea;
      END IF;

      IF Lv_DetalleId IS NULL THEN
         Pv_Mensaje := 'ERROR: No se encontro el detalle de la tarea con el idComunicacion enviado';
         RAISE Le_Errors;
      END IF;

      --OBTIENE ID DE PLANIFICACION DE SOLICITUD
      IF C_GetIdSolicitudPlanif%ISOPEN THEN
            CLOSE C_GetIdSolicitudPlanif;
      END IF;
      OPEN C_GetIdSolicitudPlanif(Lv_DetalleId);
      FETCH C_GetIdSolicitudPlanif INTO Ln_IdSolPlanif;
      IF C_GetIdSolicitudPlanif%NOTFOUND THEN
         Ln_IdSolPlanif := NULL;
      END IF;
      CLOSE C_GetIdSolicitudPlanif;

      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('accion'      , 'REVERSAR');
      APEX_JSON.WRITE('idDetalleSolPlanif'  , Ln_IdSolPlanif);
      APEX_JSON.WRITE('estado'      , '');
      APEX_JSON.WRITE('usrCreacion'  , '');
      APEX_JSON.WRITE('ipCreacion'  , '');
      APEX_JSON.WRITE('observacion'  , '');
      APEX_JSON.CLOSE_OBJECT;
      Lv_RequestSolPlanif := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      --EJECUTA FINALIZACION DE PLANIFICACION DE LA SOLICITUD ASOCIADA A LA TAREA
      DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_CAMBIAR_ESTADO_PLANIF_SOL(Lv_RequestSolPlanif, Lv_StatusSolPlanif, Lv_MensajeSolPlanif);

      --SE ADJUNTA DOCUMENTOS A LA TAREA SI ES REQUERIDO
      apex_json.parse(Pcl_Request);
      Ln_cantAdjuntos           := apex_json.get_count(p_path => 'adjuntos');

      IF Ln_cantAdjuntos > 0 THEN

        FOR j IN 1 .. Ln_cantAdjuntos LOOP

            Lr_InfoDocumento.NOMBRE_DOCUMENTO := apex_json.get_varchar2(p_path => 'adjuntos[%d].nombreDocumento',p0 => j);
            Lr_InfoDocumento.UBICACION_FISICA_DOCUMENTO := apex_json.get_varchar2(p_path => 'adjuntos[%d].ubicacionFisica',p0 => j);

            Lr_InfoDocumentRelac := NULL;
            --ELIMINAR DOCUMENTO RELACION
            OPEN C_GetDocumento(Lv_DetalleId,Lr_InfoDocumento.NOMBRE_DOCUMENTO,Lr_InfoDocumento.UBICACION_FISICA_DOCUMENTO);
            FETCH C_GetDocumento INTO Lr_InfoDocumentRelac;
            CLOSE C_GetDocumento;

            IF Lr_InfoDocumentRelac.ID_DOCUMENTO_RELACION IS NOT NULL THEN

               DELETE FROM DB_COMUNICACION.INFO_DOCUMENTO_RELACION WHERE ID_DOCUMENTO_RELACION = Lr_InfoDocumentRelac.ID_DOCUMENTO_RELACION;
               --ELIMINAR DOCUMENTO
               DELETE FROM DB_COMUNICACION.INFO_DOCUMENTO WHERE ID_DOCUMENTO = Lr_InfoDocumentRelac.DOCUMENTO_ID;
            END IF;

        END LOOP;
      END IF;

      --ELIMINAR DETALLE HISTORIAL
      OPEN C_GetUltimoDetalleHist(Lv_DetalleId);
      FETCH C_GetUltimoDetalleHist INTO Lr_InfoDetalleHistUlt;
      CLOSE C_GetUltimoDetalleHist;
      DELETE FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL WHERE ID_DETALLE_HISTORIAL = Lr_InfoDetalleHistUlt.ID_DETALLE_HISTORIAL;
      --ELIMINAR SEGUIMIENTO
      OPEN C_GetUltimoDetalleSeg(Lv_DetalleId);
      FETCH C_GetUltimoDetalleSeg INTO Lr_InfoTareaSeguimUlt;
      CLOSE C_GetUltimoDetalleSeg;
      DELETE FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO WHERE ID_SEGUIMIENTO = Lr_InfoTareaSeguimUlt.ID_SEGUIMIENTO;

      COMMIT;

      --ACTUALIZAR DETALLE EN INFO_TAREA
      DB_SOPORTE.SPKG_INFO_TAREA.P_UPDATE_TAREA( Lv_DetalleId,
                                                Lr_InfoDetalleHistUlt.USR_CREACION,
                                                Lv_Status_info_tarea,
                                                Lv_Mensaje_info_tarea);

      Pv_Status  := 'ok';
      Pv_Mensaje := 'Actualización de tarea ejecutada correctamente';
      Pcl_Response := Pv_Mensaje;

    EXCEPTION
      WHEN Le_Errors THEN
          ROLLBACK;
          Pv_Status  := 'ERROR';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE_TAREA',
                                              'P_REVERSAR_ESTADO_TAREA',
                                                Pv_Mensaje,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      WHEN OTHERS THEN
          ROLLBACK;
          Pv_Status  := 'fail';
          Pv_Mensaje := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE_TAREA',
                                              'P_REVERSAR_ESTADO_TAREA',
                                                'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_REVERSAR_ESTADO_TAREA;

END SPKG_SOPORTE_TAREA;

/

