CREATE OR REPLACE package                                                 DB_SOPORTE.SPKG_SOPORTE_TAREA IS

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

END SPKG_SOPORTE_TAREA;
/

CREATE OR REPLACE package body                                           DB_SOPORTE.SPKG_SOPORTE_TAREA IS

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
   
END SPKG_SOPORTE_TAREA;
/