SET DEFINE OFF;
create or replace package                                      DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_CONSULTA is

        /**
  * Documentación para el procedimiento P_CONSULTA_HORASEXTRA
  *
  * Método encargado de consultar la solicitud de horas extras
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   empresaCod     := número de empresa,
  *   nombreDpto     := nombre departamento,
  *   nombrePantalla := nombre de pantalla,
  *   estado         := estado de la solicitud
  *   esSuperUsuario := variable parametrizada para usuarios admin
  *   fechaInicio    := fecha inicio de la hora de la solicitud
  *   fechaFin       := fecha fin de la hora de la solicitud
  *
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                              
   PROCEDURE P_CONSULTA_HORASEXTRA(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);
                                   
                                
   /**
  * Documentación para el procedimiento P_CONSULTA_DETALLE_HEXTRA
  *
  * Método encargado de consultar el detalle de la solicitud de horas extras.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */                           
   PROCEDURE P_CONSULTA_DETALLE_HEXTRA(Pcl_Request  IN   CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);
                                   
    
    
    /**
  * Documentación para el procedimiento P_CONSULTAR_DOCUMENTO_HEXTRAS
  *
  * Método encargado de consultar los documento que contiene la solicitud de horas extras.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 22-06-2020
  */
   PROCEDURE P_CONSULTAR_DOCUMENTO_HEXTRAS(Pcl_Request  IN  CLOB,
                                           Pv_Status    OUT VARCHAR2,
                                           Pv_Mensaje   OUT VARCHAR2,
                                           Pcl_Response OUT SYS_REFCURSOR);


   /**
  * Documentación para el procedimiento P_CONSULTA_TAREAS_HEXTRAS
  *
  * Método encargado de consultar las tareas que contiene una solicitud de horas extras por ID.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 24-06-2020
  */
   PROCEDURE P_CONSULTA_TAREAS_HEXTRAS(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);
                                       
                                       
  
  /**
  * Documentación para el procedimiento P_CARGAR_SOLICITUDHE_PORID
  *
  * Método encargado de consultar información general de una solicitud de horas extras por Id.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := numero de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 24-06-2020
  */
   PROCEDURE P_CARGAR_SOLICITUDHE_PORID(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);
                                        
                                        
  
   /**
  * Documentación para el procedimiento P_CONSULTAR_HISTORIAL
  *
  * Método encargado de consultar información detallada del historial de una solicitud de horas extras por Id.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idHorasSolicitud    := número de solicitud de horas extra
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Ivan Mata <imata@telconet.ec>
  * @version 1.0 24-06-2020
  */
   PROCEDURE P_HISTORIAL_SOLICITUD(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);
                                   
                                   
  
                                     
    
    /**
    * Documentación para el procedimiento P_TOTAL_SOLICITUDES
    *
    * Método encargado de consultar el total de solicitudes preautorizadas de manera general y con filtros.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod    := número de compañía.
    *   nombreDpto    := nombre de departamento. 
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 26-07-2020
    */                  
    PROCEDURE P_TOTAL_SOLICITUDES(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);
                                  
    /**
    * Documentación para el procedimiento P_TOTAL_SOLI_DEPARTAMENTO
    *
    * Método encargado de consultar el total de solicitudes preautorizadas de todos los departamentos
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod    := número de compañía.
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 09-09-2020
    */                              
    PROCEDURE P_TOTAL_SOLI_DEPARTAMENTO(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);
           
                                        
           
    /**
    * Documentación para el procedimiento P_CONSULTA_CUADRI
    *
    * Método encargado de consultar el nombre de una cuadrilla por el idHorasSolicitud
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod         := número de compañía.
    *   nombreDpto         := nombre de departamento
    *   idHorasSolicitud   := número de solicitud de horas extra
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 09-09-2020
    */                         
    PROCEDURE P_CONSULTA_CUADRI(Pcl_Request IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);
                                
    
    /**
    * Documentación para el procedimiento P_TIPOS_HORAS_EXTRAS
    *
    * Método encargado de consultar el listado de tipos de horas extras.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   empresaCod         := número de compañía.
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
    *
    * @author Ivan Mata <imata@telconet.ec>
    * @version 1.0 10-11-2020
    */                              
    PROCEDURE P_TIPOS_HORAS_EXTRAS(Pcl_Request   IN CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR);

END HEKG_HORASEXTRAS_CONSULTA;
/
create or replace package body                                DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_CONSULTA is

   PROCEDURE P_CONSULTA_HORASEXTRA(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)
  
     AS
      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_Where              CLOB;
      Lcl_Join               CLOB;
      Lcl_JoinA              CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_EmpresaCod          VARCHAR2(2);
      Lv_NombreDepartamento  VARCHAR2(35);
      Lv_NombrePantalla      VARCHAR2(20);
      Lv_Estado              VARCHAR2(15);
      Lv_EsSuperUsuario      VARCHAR2(20);
      Lv_FechaInicio         VARCHAR2(15);
      Lv_FechaFin            VARCHAR2(15);
      Lv_Nombres             VARCHAR2(50);
      Lv_Canton              VARCHAR2(35);
      Lv_Provincia           VARCHAR2(35);
      Lv_TipoHoraExtra       VARCHAR2(35);
      Ln_IdCuadrilla         NUMBER;
      Ld_FechaCorte          DATE;
      Ld_FechaActual         DATE;
      Le_Errors              EXCEPTION;

      CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
       SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
         WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
       WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_CONSULTA';

      Lr_Valor1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;

  BEGIN
       -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_NombreDepartamento  :=  APEX_JSON.get_varchar2(p_path => 'nombreDpto');
      Lv_NombrePantalla      :=  APEX_JSON.get_varchar2(p_path => 'nombrePantalla');
      Lv_Estado              :=  APEX_JSON.get_varchar2(p_path => 'estado');
      Lv_EsSuperUsuario      :=  APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');
      Lv_FechaInicio         :=  APEX_JSON.get_varchar2(p_path => 'fechaInicio');
      Lv_FechaFin            :=  APEX_JSON.get_varchar2(p_path => 'fechaFin');
      Lv_Nombres             :=  APEX_JSON.get_varchar2(p_path => 'nombres');
      Lv_Provincia           :=  APEX_JSON.get_varchar2(p_path => 'provincia');
      Lv_Canton              :=  APEX_JSON.get_varchar2(p_path => 'canton');
      Ln_IdCuadrilla         :=  APEX_JSON.get_number(p_path => 'idCuadrilla');
      Lv_TipoHoraExtra       :=  APEX_JSON.get_varchar2(p_path => 'tipoHorasExtra');

      -- VALIDACIONES

        IF Lv_EmpresaCod IS NULL THEN
            Pv_Mensaje := 'El parámetro empresaCod está vacío';
            RAISE Le_Errors;
        END IF;


        IF Lv_NombrePantalla IS NULL THEN
            Pv_Mensaje := 'El parámetro nombrePantalla está vacío';
            RAISE Le_Errors;
        END IF;

        IF Lv_Estado IS NULL THEN
            Lv_Estado:='Pendiente';
        END IF;

        IF C_DIA_CORTE%ISOPEN THEN
            CLOSE C_DIA_CORTE;
        END IF;

        OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
        FETCH C_DIA_CORTE INTO Lr_valor1;

        IF C_DIA_CORTE%FOUND THEN  

           SELECT TO_DATE(Lr_valor1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
             INTO Ld_FechaCorte
           FROM DUAL;           

        END IF;

        CLOSE C_DIA_CORTE;

      Ld_FechaActual:= SYSDATE;


      Lcl_Select       := '
                 SELECT DISTINCT IHS.ID_HORAS_SOLICITUD,VEE.CEDULA,VEE.NOMBRE,TO_CHAR(TO_DATE(IHS.FECHA,''DD-MM-YY''),''DD-MM-YYYY'') FECHA_SOLICITUD,
                 IHS.ESTADO ESTADO_SOLICITUD,A.HORAS, VEE.NOMBRE_DEPTO, IHS.DESCRIPCION,A_ITH.CANTIDAD_TAREA,IHS.HORA_INICIO,IHS.HORA_FIN, IHS.OBSERVACION,
                 TIPO_HE.TIPO_HORAS_EXTRA ';

      Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS ';


      Lcl_Join        := '
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
                 LEFT JOIN DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH ON ITH.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 LEFT JOIN(SELECT IHS.ID_HORAS_SOLICITUD, COUNT(ITH.TAREA_ID)CANTIDAD_TAREA
                              FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                              LEFT JOIN DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ITH ON IHS.ID_HORAS_SOLICITUD = ITH.HORAS_SOLICITUD_ID
                              GROUP BY IHS.ID_HORAS_SOLICITUD
                              ORDER BY IHS.ID_HORAS_SOLICITUD DESC)A_ITH ON A_ITH.ID_HORAS_SOLICITUD = IHS.ID_HORAS_SOLICITUD
                 LEFT JOIN(SELECT DISTINCT IHSO.ID_HORAS_SOLICITUD,ATHE.TIPO_HORAS_EXTRA,IHSD.HORAS
                           FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHSO
                           JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSO.ID_HORAS_SOLICITUD   = IHSD.HORAS_SOLICITUD_ID
                           JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHSO.ID_HORAS_SOLICITUD
                           JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID 
                           JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEEM ON VEEM.NO_EMPLE = IHSE.NO_EMPLE AND VEEM.NO_CIA = IHSO.EMPRESA_COD
                           WHERE ATHE.TIPO_HORAS_EXTRA=''SIMPLE'' 
                           AND TO_DATE(SYSDATE||'' ''||IHSD.HORAS,''DD-MM-YY HH24:mi'')>TO_DATE(SYSDATE||'' 04:00'',''DD-MM-YY HH24:mi'')
                           AND IHSO.EMPRESA_COD ='''||Lv_EmpresaCod||''' AND VEEM.NOMBRE_DEPTO='''||Lv_NombreDepartamento||'''
                           AND IHSD.ESTADO IN (''Pendiente'',''Autorizada'',''Pre-Autorizada'',''Anulada'')
                           ORDER BY IHSO.ID_HORAS_SOLICITUD DESC)A ON A.ID_HORAS_SOLICITUD = IHS.ID_HORAS_SOLICITUD

                 JOIN(SELECT ID_HORAS_SOLICITUD,
                             LISTAGG (TIPO_HORAS_EXTRA, '' , '') WITHIN GROUP (
                             ORDER BY TIPO_HORAS_EXTRA DESC) TIPO_HORAS_EXTRA 
                             FROM (
                                    SELECT DISTINCT IHSOL.ID_HORAS_SOLICITUD,ATHE.TIPO_HORAS_EXTRA
                                           FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHSOL
                                           JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSDET ON IHSOL.ID_HORAS_SOLICITUD = IHSDET.HORAS_SOLICITUD_ID
                                           JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSDET.TIPO_HORAS_EXTRA_ID
                                           WHERE IHSOL.ESTADO ='''||Lv_Estado||''' AND IHSDET.ESTADO = '''||Lv_Estado||'''
                                           GROUP BY IHSOL.ID_HORAS_SOLICITUD,ATHE.TIPO_HORAS_EXTRA
                                           ORDER BY IHSOL.ID_HORAS_SOLICITUD DESC)TABLA
                            GROUP BY ID_HORAS_SOLICITUD
                            ORDER BY ID_HORAS_SOLICITUD DESC)TIPO_HE ON TIPO_HE.ID_HORAS_SOLICITUD = IHS.ID_HORAS_SOLICITUD ';

      Lcl_Where      := ' WHERE VEE.ESTADO=''A'' AND VEE.NO_CIA='''||Lv_EmpresaCod||''' ';

      IF Lv_NombreDepartamento IS NOT NULL THEN

          Lcl_Where  :=  Lcl_Where|| ' AND VEE.NOMBRE_DEPTO= '''||Lv_NombreDepartamento||''' ';

      END IF;


      IF Lv_NombrePantalla = 'Registro' THEN

              IF Lv_Estado IS NULL THEN

                 Lcl_Where := Lcl_Where || ' AND IHS.ESTADO = ''Pendiente'' AND IHSE.ESTADO=''Pendiente'' AND IHSD.ESTADO=''Pendiente'' ';

              ELSE

                Lcl_Where := Lcl_Where || ' AND IHS.ESTADO ='''||Lv_Estado||''' AND IHSE.ESTADO='''||Lv_Estado||''' AND IHSD.ESTADO='''||Lv_Estado||'''  ';

              END IF;

      ELSIF Lv_NombrePantalla = 'Autorizacion' OR Lv_NombrePantalla='DetalleAutorizacion' THEN


             IF Lv_Estado IS NULL AND Lv_EsSuperUsuario = 'Gerencia' THEN

                Lcl_Where := Lcl_Where || ' AND IHS.ESTADO = ''Pre-Autorizada'' AND IHSE.ESTADO=''Pre-Autorizada'' AND IHSD.ESTADO=''Pre-Autorizada''  ';


             ELSIF Lv_Estado IS NULL AND Lv_EsSuperUsuario = 'Jefatura' THEN

                 Lcl_Where := Lcl_Where || ' AND IHS.ESTADO = ''Pendiente'' AND IHSE.ESTADO=''Pendiente'' AND IHSD.ESTADO=''Pendiente'' ';

             ELSIF Lv_Estado IS NOT NULL THEN

                Lcl_Where := Lcl_Where || ' AND IHS.ESTADO ='''||Lv_Estado||''' AND IHSE.ESTADO='''||Lv_Estado||''' AND IHSD.ESTADO='''||Lv_Estado||'''  ';

             END IF;

             IF Lv_NombrePantalla='DetalleAutorizacion' THEN

                Lcl_Where := Lcl_Where || ' AND VEE.TIPO_EMP NOT IN(''03'') ';

             END IF;

             IF(Lv_FechaInicio IS NULL AND Lv_FechaFin IS NULL) THEN

                IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY') )THEN 

                    Lcl_Where := Lcl_Where || ' AND TO_CHAR(TO_DATE(IHS.FECHA,''DD-MM-YY''),''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

                ELSE 

                    Lcl_Where := Lcl_Where || ' AND TO_CHAR(TO_DATE(IHS.FECHA,''DD-MM-YY''),''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

                END IF;

             END IF;




      END IF;

      IF (Lv_FechaInicio IS NOT NULL AND Lv_FechaFin IS NOT NULL) THEN

          Lcl_Where := Lcl_Where || ' AND TO_DATE(IHS.FECHA) >= TO_DATE('''||Lv_FechaInicio||''',''DD-MM-YYYY'')
                                      AND TO_DATE(IHS.FECHA)<= TO_DATE('''||Lv_FechaFin||''',''DD-MM-YYYY'') ';


      END IF;

      IF Lv_Nombres IS NOT NULL THEN

          Lcl_Where := Lcl_Where || ' AND VEE.NOMBRE LIKE UPPER('''||'%'||Lv_Nombres||'%'||''') ';

      END IF;

      IF Lv_Provincia IS NOT NULL THEN

          Lcl_Where := Lcl_Where || ' AND VEE.NOMBRE_PROVINCIA ='''||Lv_Provincia||''' ';

      END IF;

      IF Lv_Canton IS NOT NULL THEN

          Lcl_Where := Lcl_Where || ' AND VEE.NOMBRE_CANTON ='''||Lv_Canton||''' ';

      END IF;

      IF Ln_IdCuadrilla IS NOT NULL THEN

          Lcl_Where := Lcl_Where || ' AND ITH.CUADRILLA_ID ='||Ln_IdCuadrilla||' ';

      END IF;

      IF Lv_TipoHoraExtra IS NOT NULL THEN

          IF Lv_TipoHoraExtra = 'DOBLES' THEN

              Lcl_Where := Lcl_Where || ' AND ATHE.TIPO_HORAS_EXTRA IN('''||Lv_TipoHoraExtra||''',''DIALIBRE_DOBLE'') ';

          ELSE

              Lcl_Where := Lcl_Where || ' AND ATHE.TIPO_HORAS_EXTRA ='''||Lv_TipoHoraExtra||''' ';

          END IF;

      END IF;

      Lcl_OrderAnGroup := '
                         GROUP BY IHS.ID_HORAS_SOLICITUD,VEE.CEDULA,VEE.NOMBRE,IHS.FECHA,IHS.ESTADO,A.HORAS,
                                  VEE.NOMBRE_DEPTO,IHS.DESCRIPCION,A_ITH.CANTIDAD_TAREA,IHS.HORA_INICIO,
                                  IHS.HORA_FIN,IHS.OBSERVACION,TIPO_HE.TIPO_HORAS_EXTRA
                         ORDER BY IHS.ID_HORAS_SOLICITUD DESC ';

      Lcl_Query := Lcl_Select || Lcl_From || Lcl_Join|| Lcl_Where || Lcl_OrderAnGroup; 

      OPEN Pcl_Response FOR Lcl_Query;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_CONSULTA_HORASEXTRA;

  PROCEDURE P_CONSULTA_DETALLE_HEXTRA(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR)

  AS
      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Ln_IdHorasSolicitud    NUMBER;
      Lv_Nombres             VARCHAR2(50);
      Le_Errors              EXCEPTION;

  BEGIN

       -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdHorasSolicitud          :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
    Lv_Nombres                    := APEX_JSON.get_varchar2(p_path => 'nombres');

    -- VALIDACIONES
         IF Ln_IdHorasSolicitud IS NULL THEN
            Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
            RAISE Le_Errors;
        END IF;


    Lcl_Select       := '
                 SELECT ATHE.TIPO_HORAS_EXTRA,IHSD.HORA_INICIO_DET HORA_INICIO,IHSD.HORA_FIN_DET HORA_FIN,IHSD.HORAS,TO_CHAR(IHSD.FECHA_SOLICITUD_DET,''DD-MM-YYYY'') FECHA_SOLICITUD,IHS.ESTADO ESTADO_SOLICITUD,
                        IHS.OBSERVACION,
                        (CASE WHEN IHS.USR_MODIFICACION IS NULL THEN IHS.USR_CREACION
                              WHEN IHS.USR_MODIFICACION IS NOT NULL THEN IHS.USR_MODIFICACION END)USR_CREACION,
                        (CASE WHEN IHS.FE_MODIFICACION IS NULL THEN IHS.FE_CREACION
                              WHEN IHS.FE_MODIFICACION IS NOT NULL THEN IHS.FE_MODIFICACION END)FE_CREACION,
                              VEE.NOMBRE_DEPTO DEPARTAMENTO ';

    Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE AND VEE.NO_CIA = IHS.EMPRESA_COD ';

    Lcl_WhereAndJoin := '
                 WHERE IHS.ID_HORAS_SOLICITUD='||Ln_IdHorasSolicitud||' AND IHSD.ESTADO IN (''Pendiente'',''Anulada'',''Autorizada'',''Pre-Autorizada'')
                 AND IHSE.ESTADO IN (''Pendiente'',''Anulada'',''Autorizada'',''Pre-Autorizada'')
                 AND VEE.NOMBRE = '''||Lv_Nombres||''' ';

    Lcl_OrderAnGroup := ' ORDER BY IHSD.ID_HORAS_SOLICITUD_DETALLE ';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin|| Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;                                          


  END P_CONSULTA_DETALLE_HEXTRA;

  PROCEDURE P_CONSULTAR_DOCUMENTO_HEXTRAS(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT SYS_REFCURSOR)
  AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_IdHorasSolicitud    NUMBER;
      Le_Errors              EXCEPTION;


  BEGIN
     -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdHorasSolicitud          :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud'); 

    -- VALIDACIONES
    IF Lv_IdHorasSolicitud IS NULL THEN
         Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
         RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
                 SELECT IDHE.NOMBRE_DOCUMENTO NOMBRE_DOCUMENTO,IDHE.UBICACION_DOCUMENTO';

    Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_DOCUMENTO_HORAS_EXTRAS IDHE';

    Lcl_WhereAndJoin := '
                 WHERE IDHE.HORAS_SOLICITUD_ID='||Lv_IdHorasSolicitud||' 
                 AND ESTADO IN (''Pendiente'',''Anulada'') ';

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

  END P_CONSULTAR_DOCUMENTO_HEXTRAS;

  PROCEDURE P_CONSULTA_TAREAS_HEXTRAS(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR)

  AS    

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Ln_IdHorasSolicitud    NUMBER;
      Le_Errors              EXCEPTION;

  BEGIN
      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdHorasSolicitud          :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud'); 

      -- VALIDACIONES
      IF Ln_IdHorasSolicitud IS NULL THEN
         Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
         RAISE Le_Errors;
      END IF;

      Lcl_Select       := '
                 SELECT ITH.TAREA_ID, TO_CHAR(IDE.OBSERVACION)OBSERVACION,
                 (SELECT IDHI.ESTADO FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHI WHERE IDHI.DETALLE_ID=ICO.DETALLE_ID
                 AND IDHI.FE_CREACION = (SELECT MAX(FE_CREACION) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL WHERE DETALLE_ID=ICO.DETALLE_ID))ESTADO ';

      Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS ';

      Lcl_WhereAndJoin := '
                 JOIN INFO_TAREAS_HORAS ITH ON ITH.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN DB_COMUNICACION.INFO_COMUNICACION ICO ON ICO.ID_COMUNICACION = ITH.TAREA_ID
                 JOIN DB_SOPORTE.INFO_DETALLE IDE ON IDE.ID_DETALLE = ICO.DETALLE_ID
                 WHERE IHS.ID_HORAS_SOLICITUD ='||Ln_IdHorasSolicitud||' AND ITH.ESTADO IN (''Pendiente'',''Anulada'',''Pre-Autorizada'',''Autorizada'') ';

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


  END P_CONSULTA_TAREAS_HEXTRAS;

  PROCEDURE P_CARGAR_SOLICITUDHE_PORID(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)          


  AS
      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_SelectA            CLOB;
      Lcl_SelectB            CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Ln_IdHorasSolicitud    NUMBER;
      Lv_Descripcion         VARCHAR2(20);
      Le_Errors              EXCEPTION;

  BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdHorasSolicitud          :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
      Lv_Descripcion               :=  APEX_JSON.get_varchar2(p_path => 'descripcion');

      -- VALIDACIONES
      IF Ln_IdHorasSolicitud IS NULL THEN
         Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
         RAISE Le_Errors;
      END IF;

      Lcl_Select       := '
                 SELECT DISTINCT IHSE.NO_EMPLE,VEE.CEDULA,VEE.NOMBRE,TO_DATE(IHS.FECHA,''DD-MM-YY'')FECHA,IHS.HORA_INICIO,IHS.HORA_FIN,IHS.OBSERVACION,VEE.MAIL_CIA CORREO, ';

      Lcl_SelectA      := '
                 SELECT DISTINCT IHS.FECHA,IHS.HORA_INICIO,IHS.HORA_FIN,IHS.OBSERVACION, ';

      Lcl_SelectB      := '
                (CASE WHEN ATHE.TIPO_HORAS_EXTRA = ''NOCTURNO'' THEN ATHE.TIPO_HORAS_EXTRA 
                      WHEN ATHE.TIPO_HORAS_EXTRA = ''DIALIBRE_DOBLE'' THEN ATHE.TIPO_HORAS_EXTRA END)TIPO_HORAS_EXTRA ';

      Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS';

      Lcl_WhereAndJoin := '
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID= IHS.ID_HORAS_SOLICITUD
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                 JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON IHSE.NO_EMPLE = VEE.NO_EMPLE 
                 AND IHS.EMPRESA_COD =VEE.NO_CIA
                 WHERE IHS.ID_HORAS_SOLICITUD='||Ln_IdHorasSolicitud||'
                 AND IHSD.ESTADO IN (''Pendiente'',''Anulada'') ';

      Lcl_OrderAnGroup :=  ' ORDER BY TIPO_HORAS_EXTRA  ';

      IF Lv_Descripcion = 'Unitaria' OR Lv_Descripcion = 'Unitaria_HN' THEN
           Lcl_Query := Lcl_Select || Lcl_SelectB|| Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;
      ELSE
           Lcl_Query := Lcl_SelectA || Lcl_SelectB|| Lcl_From || Lcl_WhereAndJoin ;
      END IF;

      OPEN Pcl_Response FOR Lcl_Query;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;


  END P_CARGAR_SOLICITUDHE_PORID;

  PROCEDURE P_HISTORIAL_SOLICITUD(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR)


   AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Ln_IdHorasSolicitud    NUMBER;
      Lv_EmpresaCod          VARCHAR2(2);
      Le_Errors              EXCEPTION;


   BEGIN

    -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdHorasSolicitud    :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');

      -- VALIDACIONES
      IF Ln_IdHorasSolicitud IS NULL THEN
         Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
         RAISE Le_Errors;
      END IF;

      Lcl_Select       := '
                 SELECT DISTINCT IHSH.HORAS_SOLICITUD_ID, ATHE.TIPO_HORAS_EXTRA, 
                        IHSH.HORA_INICIO_DET HORA_INICIO, IHSH.HORA_FIN_DET HORA_FIN, IHSH.HORAS,
                        TO_CHAR(IHSH.FECHA_SOLICITUD_DET,''DD-MM-YYYY'') FECHA_SOLICITUD, IHSH.ESTADO ESTADO_SOLICITUD, 
                        IHSH.OBSERVACION,IHSH.USR_CREACION,IHSH.FE_CREACION,IHSH.ID_HORAS_SOLICITUD_HISTORIAL,
                        VEE.NOMBRE_DEPTO DEPARTAMENTO ';

      Lcl_From         := '
                 FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL IHSH  ';

      Lcl_WhereAndJoin := '
                JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSH.TIPO_HORAS_EXTRA_ID
                 JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS ON IHS.ID_HORAS_SOLICITUD = IHSH.HORAS_SOLICITUD_ID
                JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                 JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
                WHERE IHSH.HORAS_SOLICITUD_ID='||Ln_IdHorasSolicitud||' AND IHSH.FE_CREACION !=(SELECT MAX(IHSHI.FE_CREACION) FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_HISTORIAL IHSHI 
                 WHERE IHSHI.HORAS_SOLICITUD_ID='||Ln_IdHorasSolicitud||') AND IHSE.ESTADO IN(''Inactivo'',''Anulada'',''Autorizada'',''Pre-Autorizada'')
                 AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND IHS.EMPRESA_COD='''||Lv_EmpresaCod||''' ';

      Lcl_OrderAnGroup := '
                 ORDER BY IHSH.FE_CREACION DESC,IHSH.ID_HORAS_SOLICITUD_HISTORIAL ';

      Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin|| Lcl_OrderAnGroup;

      OPEN Pcl_Response FOR Lcl_Query;

      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';


   EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;


   END P_HISTORIAL_SOLICITUD;

   PROCEDURE P_TOTAL_SOLICITUDES(Pcl_Request   IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR)

   AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_EmpresaCod          VARCHAR2(2);
      Lv_Estado              VARCHAR2(25);
      Lv_EsSuperUsuario      VARCHAR2(25);
      Lv_NombreDepartamento  VARCHAR2(60);
      Lv_FechaInicio         VARCHAR2(15);
      Lv_FechaFin            VARCHAR2(15);
      Lv_Nombres             VARCHAR2(50);
      Lv_Canton              VARCHAR2(35);
      Lv_Provincia           VARCHAR2(35);
      Lv_NombrePantalla      VARCHAR2(20);
      Lv_Area                VARCHAR2(2);
      Lv_NombreArea          VARCHAR2(35);
      Ln_IdCuadrilla         NUMBER;
      Lv_TipoHoraExtra       VARCHAR2(35);
      Ld_FechaCorte          DATE;
      Ld_FechaActual         DATE;
      Le_Errors              EXCEPTION;

      CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
       SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
         WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
       WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_CONSULTA';

      Lr_Valor1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;

   BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_EsSuperUsuario      :=  APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');
      Lv_NombreDepartamento  :=  APEX_JSON.get_varchar2(p_path => 'nombreDpto');
      Lv_Estado              :=  APEX_JSON.get_varchar2(p_path => 'estado');
      Lv_FechaInicio         :=  APEX_JSON.get_varchar2(p_path => 'fechaInicio');
      Lv_FechaFin            :=  APEX_JSON.get_varchar2(p_path => 'fechaFin');
      Lv_Nombres             :=  APEX_JSON.get_varchar2(p_path => 'nombres');
      Lv_Provincia           :=  APEX_JSON.get_varchar2(p_path => 'provincia');
      Lv_Canton              :=  APEX_JSON.get_varchar2(p_path => 'canton');
      Ln_IdCuadrilla         :=  APEX_JSON.get_number(p_path => 'idCuadrilla');
      Lv_NombrePantalla      :=  APEX_JSON.get_varchar2(p_path => 'nombrePantalla');
      Lv_Area                :=  APEX_JSON.get_varchar2(p_path => 'area');
      Lv_NombreArea          :=  APEX_JSON.get_varchar2(p_path => 'nombreArea');
      Lv_TipoHoraExtra       :=  APEX_JSON.get_varchar2(p_path => 'tipoHorasExtra');


      IF C_DIA_CORTE%ISOPEN THEN
            CLOSE C_DIA_CORTE;
      END IF;

      OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
      FETCH C_DIA_CORTE INTO Lr_valor1;

      IF C_DIA_CORTE%FOUND THEN  

         SELECT TO_DATE(Lr_valor1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
           INTO Ld_FechaCorte
         FROM DUAL;           

      END IF;

      CLOSE C_DIA_CORTE;


      Ld_FechaActual:= SYSDATE;



      Lcl_Select :=   '
                    SELECT COUNT(*) TOTAL_SOLICITUDES ';

      Lcl_From := ' 
                    FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS ';

      Lcl_WhereAndJoin := '
                    JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                    JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE AND IHS.EMPRESA_COD = VEE.NO_CIA ';


      IF Lv_TipoHoraExtra IS NOT NULL THEN        
         Lcl_WhereAndJoin := Lcl_WhereAndJoin ||' 
                        JOIN (SELECT DISTINCT HORAS_SOLICITUD_ID,TIPO_HORAS_EXTRA_ID,ESTADO FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE)IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                        JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID  ';

      END IF;


      IF Ln_IdCuadrilla IS NOT NULL THEN        
         Lcl_WhereAndJoin := Lcl_WhereAndJoin ||' 
                        LEFT JOIN (SELECT DISTINCT HORAS_SOLICITUD_ID,CUADRILLA_ID,ESTADO FROM DB_HORAS_EXTRAS.INFO_TAREAS_HORAS WHERE CUADRILLA_ID IS NOT NULL
                        AND ESTADO NOT IN(''Inactivo''))ITH ON ITH.HORAS_SOLICITUD_ID= IHS.ID_HORAS_SOLICITUD ';

      END IF;

      Lcl_WhereAndJoin := Lcl_WhereAndJoin ||' 
                        WHERE IHS.ESTADO='''||Lv_Estado||''' AND IHSE.ESTADO='''||Lv_Estado||''' AND IHS.EMPRESA_COD='''||Lv_EmpresaCod||'''
                        AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND VEE.ESTADO=''A'' ';

      IF Lv_NombrePantalla = 'DetalleAutorizacion' OR Lv_NombrePantalla='Autorizacion'  THEN

        Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.TIPO_EMP NOT IN(''03'')  ';

      END IF;


      IF(Lv_NombrePantalla!='Registro' AND Lv_FechaInicio IS NULL AND Lv_FechaFin IS NULL) THEN


           IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN 

                Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(TO_DATE(IHS.FECHA,''DD-MM-YY''),''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

           ELSE

                Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(TO_DATE(IHS.FECHA,''DD-MM-YY''),''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

           END IF;


      END IF;


         IF Lv_NombreDepartamento IS NOT NULL THEN

            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.NOMBRE_DEPTO='''||Lv_NombreDepartamento||'''  ';

         END IF;

         IF (Lv_Nombres IS NOT NULL) THEN

            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.NOMBRE LIKE UPPER('''||'%'||Lv_Nombres||'%'||''') ';

         END IF;

         IF (Lv_FechaInicio IS NOT NULL AND Lv_FechaFin IS NOT NULL) THEN

              Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_DATE(IHS.FECHA) >= TO_DATE('''||Lv_FechaInicio||''',''DD-MM-YYYY'')
                                      AND TO_DATE(IHS.FECHA)<= TO_DATE('''||Lv_FechaFin||''',''DD-MM-YYYY'') ';

         END IF;

         IF Lv_Provincia IS NOT NULL THEN

             Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.NOMBRE_PROVINCIA ='''||Lv_Provincia||''' ';

         END IF;

         IF Lv_Canton IS NOT NULL THEN

             Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.NOMBRE_CANTON ='''||Lv_Canton||''' ';

         END IF;

         IF Ln_IdCuadrilla IS NOT NULL THEN

            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ITH.ESTADO='''||Lv_Estado||''' AND ITH.CUADRILLA_ID ='||Ln_IdCuadrilla||'  ';

         END IF;

         IF Lv_Area IS NOT NULL THEN

            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.AREA ='''||Lv_Area||''' ';

         END IF;

         IF Lv_NombreArea IS NOT NULL THEN

            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND VEE.NOMBRE_AREA ='''||Lv_NombreArea||''' ';

         END IF;

         IF Lv_TipoHoraExtra IS NOT NULL THEN

            IF Lv_TipoHoraExtra = 'DOBLES' THEN

              Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATHE.TIPO_HORAS_EXTRA IN('''||Lv_TipoHoraExtra||''',''DIALIBRE_DOBLE'') AND IHSD.ESTADO='''||Lv_Estado||''' ';

            ELSE

              Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATHE.TIPO_HORAS_EXTRA ='''||Lv_TipoHoraExtra||''' AND IHSD.ESTADO='''||Lv_Estado||''' ';

            END IF;

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


   END P_TOTAL_SOLICITUDES;

   PROCEDURE P_TOTAL_SOLI_DEPARTAMENTO(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)

   AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_EmpresaCod          VARCHAR2(2);
      Lv_nombreArea          VARCHAR2(35);
      Lv_Area                VARCHAR2(2);
      Lv_nombreDepartamento  VARCHAR2(35);
      Lv_Estado              VARCHAR2(25):='Pre-Autorizada';
      Ld_FechaCorte          DATE;
      Ld_FechaActual         DATE;
      Lv_EsSuperUsuario      VARCHAR2(25);
      Le_Errors              EXCEPTION;


      CURSOR C_DIA_CORTE(Cv_RolUsuario VARCHAR2) IS
       SELECT APD.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
         WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
       WHERE APC.NOMBRE_PARAMETRO='DIA_DE_CORTE_HE') AND APD.VALOR2=Cv_RolUsuario AND APD.DESCRIPCION='DIA_CORTE_CONSULTA';

      Lr_Valor1              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;


   BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_EsSuperUsuario      :=  APEX_JSON.get_varchar2(p_path => 'esSuperUsuario');
      Lv_nombreArea          :=  APEX_JSON.get_varchar2(p_path => 'nombreArea');
      Lv_Area                :=  APEX_JSON.get_varchar2(p_path => 'area');
      Lv_nombreDepartamento  :=  APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');


      IF C_DIA_CORTE%ISOPEN THEN
            CLOSE C_DIA_CORTE;
      END IF;

      OPEN C_DIA_CORTE(Lv_EsSuperUsuario);
      FETCH C_DIA_CORTE INTO Lr_valor1;


      IF C_DIA_CORTE%FOUND THEN  

         SELECT TO_DATE(Lr_valor1||'-'||TO_CHAR(SYSDATE,'MM-YYYY'),'DD-MM-YY')FECHA_CORTE
           INTO Ld_FechaCorte
         FROM DUAL;           

      END IF;

      CLOSE C_DIA_CORTE;


      Ld_FechaActual:= SYSDATE;



      Lcl_Select :=   '
                    SELECT ARP.DESCRI NOMBRE_DEPTO,
                           (CASE WHEN A.TOTAL_SOLICITUD IS NULL THEN 0
                           WHEN A.TOTAL_SOLICITUD IS NOT NULL THEN A.TOTAL_SOLICITUD END)SOLICITUDES_DEPARTAMENTO,
                           (CASE WHEN A.TOTAL_NOCTURNA IS NULL THEN 0
                           WHEN A.TOTAL_NOCTURNA IS NOT NULL THEN A.TOTAL_NOCTURNA END)TOTAL_NOCTURNA,
                           (CASE WHEN A.TOTAL_SIMPLE IS NULL THEN 0
                           WHEN A.TOTAL_SIMPLE IS NOT NULL THEN A.TOTAL_SIMPLE END)TOTAL_SIMPLE,
                           (CASE WHEN A.TOTAL_DOBLES IS NULL THEN 0
                           WHEN A.TOTAL_DOBLES IS NOT NULL THEN A.TOTAL_DOBLES END)TOTAL_DOBLES ';

      Lcl_From   :=   ' 
                    FROM NAF47_TNET.ARPLDP ARP ';

      Lcl_WhereAndJoin := '
                    JOIN ARPLAR ARA ON ARP.AREA = ARA.AREA 
                    LEFT JOIN(SELECT COUNT(*) TOTAL_SOLICITUD ,VEE.NOMBRE_DEPTO, VEE.DEPTO,
                                          (CASE WHEN NOCTURNAHE.NOCTURNA IS NULL THEN 0
                                           WHEN NOCTURNAHE.NOCTURNA IS NOT NULL THEN NOCTURNAHE.NOCTURNA END)TOTAL_NOCTURNA,
                                          (CASE WHEN SIMPLEHE.TSIMPLE IS NULL THEN 0
                                           WHEN SIMPLEHE.TSIMPLE IS NOT NULL THEN SIMPLEHE.TSIMPLE END)TOTAL_SIMPLE,
                                          (CASE WHEN DOBLESHE.TDOBLES IS NULL THEN 0
                                           WHEN DOBLESHE.TDOBLES IS NOT NULL THEN DOBLESHE.TDOBLES END)TOTAL_DOBLES
                                           FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS
                                            JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                            JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE= IHSE.NO_EMPLE ' ;

                                     Lcl_WhereAndJoin := Lcl_WhereAndJoin||' 
                                           LEFT JOIN(SELECT COUNT(*)NOCTURNA,VEE.NOMBRE_DEPTO 
                                                      FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE AND VEE.NO_CIA = IHS.EMPRESA_COD
                                                      JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                                                      WHERE IHS.EMPRESA_COD='''||Lv_EmpresaCod||''' AND VEE.NO_CIA='''||Lv_EmpresaCod||'''
                                                      AND IHS.ESTADO=''Pre-Autorizada'' AND IHSD.ESTADO=''Pre-Autorizada'' AND IHSE.ESTADO=''Pre-Autorizada'' AND VEE.TIPO_EMP NOT IN(''03'')
                                                      AND ATHE.TIPO_HORAS_EXTRA=''NOCTURNO'' ';

                                                      IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN 

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

                                                      ELSE

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

                                                      END IF;                                              
                                     Lcl_WhereAndJoin := Lcl_WhereAndJoin||'                  
                                                      GROUP BY VEE.NOMBRE_DEPTO)NOCTURNAHE ON NOCTURNAHE.NOMBRE_DEPTO = VEE.NOMBRE_DEPTO ';

                                     Lcl_WhereAndJoin := Lcl_WhereAndJoin||'
                                           LEFT JOIN(SELECT COUNT(*)TSIMPLE,VEE.NOMBRE_DEPTO 
                                                      FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE AND VEE.NO_CIA = IHS.EMPRESA_COD
                                                      JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                                                      WHERE IHS.EMPRESA_COD='''||Lv_EmpresaCod||''' AND VEE.NO_CIA='''||Lv_EmpresaCod||'''
                                                      AND IHS.ESTADO=''Pre-Autorizada'' AND IHSD.ESTADO=''Pre-Autorizada'' AND IHSE.ESTADO=''Pre-Autorizada'' AND VEE.TIPO_EMP NOT IN(''03'')
                                                      AND ATHE.TIPO_HORAS_EXTRA=''SIMPLE'' ';

                                                      IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN 

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

                                                      ELSE

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

                                                      END IF; 

                                     Lcl_WhereAndJoin := Lcl_WhereAndJoin||'
                                                      GROUP BY VEE.NOMBRE_DEPTO)SIMPLEHE ON SIMPLEHE.NOMBRE_DEPTO = VEE.NOMBRE_DEPTO';

                                    Lcl_WhereAndJoin := Lcl_WhereAndJoin||'
                                             LEFT JOIN(SELECT COUNT(*)TDOBLES,VEE.NOMBRE_DEPTO 
                                                      FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS 
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_DETALLE IHSD ON IHSD.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                                                      JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE AND VEE.NO_CIA = IHS.EMPRESA_COD
                                                      JOIN DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ON ATHE.ID_TIPO_HORAS_EXTRA = IHSD.TIPO_HORAS_EXTRA_ID
                                                      WHERE IHS.EMPRESA_COD='''||Lv_EmpresaCod||''' AND VEE.NO_CIA='''||Lv_EmpresaCod||'''
                                                      AND IHS.ESTADO=''Pre-Autorizada'' AND IHSD.ESTADO=''Pre-Autorizada'' AND IHSE.ESTADO=''Pre-Autorizada'' AND VEE.TIPO_EMP NOT IN(''03'')
                                                      AND ATHE.TIPO_HORAS_EXTRA IN(''DOBLES'',''DIALIBRE_DOBLE'') ';

                                                      IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN 

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

                                                      ELSE

                                                          Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

                                                      END IF; 

                                    Lcl_WhereAndJoin := Lcl_WhereAndJoin||' 
                                                      GROUP BY VEE.NOMBRE_DEPTO)DOBLESHE ON DOBLESHE.NOMBRE_DEPTO = VEE.NOMBRE_DEPTO ';

                                    Lcl_WhereAndJoin := Lcl_WhereAndJoin||'
                                             WHERE IHS.ESTADO=''Pre-Autorizada'' AND IHSE.ESTADO=''Pre-Autorizada'' AND IHS.EMPRESA_COD='''||Lv_EmpresaCod||'''
                                             AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND VEE.TIPO_EMP NOT IN(''03'') ';

                                             IF(TO_CHAR(Ld_FechaActual,'DD-MM-YYYY') > TO_CHAR(Ld_FechaCorte,'DD-MM-YYYY'))THEN 

                                                    Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,0),''MM-YYYY'') ';

                                             ELSE

                                                    Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND TO_CHAR(IHS.FECHA,''MM-YYYY'')=TO_CHAR(ADD_MONTHS(SYSDATE,-1),''MM-YYYY'') ';

                                             END IF;                          

                                             Lcl_WhereAndJoin := Lcl_WhereAndJoin||' GROUP BY VEE.NOMBRE_DEPTO,VEE.DEPTO,NOCTURNAHE.NOCTURNA,SIMPLEHE.TSIMPLE,DOBLESHE.TDOBLES)A ON A.DEPTO = ARP.DEPA ';   


      Lcl_WhereAndJoin := Lcl_WhereAndJoin||' 
                    WHERE ARP.NO_CIA='''||Lv_EmpresaCod||''' AND ARA.NO_CIA='''||Lv_EmpresaCod||''' ';

      IF Lv_nombreArea IS NOT NULL THEN

         Lcl_WhereAndJoin := Lcl_WhereAndJoin||'AND ARA.DESCRI='''||Lv_nombreArea||'''';

      END IF;

      IF Lv_Area IS NOT NULL THEN

         Lcl_WhereAndJoin := Lcl_WhereAndJoin||'AND ARA.AREA='''||Lv_Area||'''';

      END IF;

      IF Lv_nombreDepartamento IS NOT NULL THEN

         Lcl_WhereAndJoin := Lcl_WhereAndJoin||'AND ARP.DESCRI='''||Lv_nombreDepartamento||'''';

      END IF;


      Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin|| Lcl_OrderAnGroup;


      OPEN Pcl_Response FOR Lcl_Query;



      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';

   EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

   END P_TOTAL_SOLI_DEPARTAMENTO;


   PROCEDURE P_CONSULTA_CUADRI(Pcl_Request   IN CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)

   AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_EmpresaCod          VARCHAR2(2);
      Ln_IdHorasSolicitud    NUMBER;
      Lv_nombreDpto          VARCHAR2(50);
      Le_Errors              EXCEPTION;

   BEGIN

      -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdHorasSolicitud    :=  APEX_JSON.get_number(p_path => 'idHorasSolicitud');
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');
      Lv_nombreDpto          :=  APEX_JSON.get_varchar2(p_path => 'nombreDpto');

      -- VALIDACIONES
      IF Ln_IdHorasSolicitud IS NULL THEN
         Pv_Mensaje := 'El parámetro idHorasSolicitud está vacío';
         RAISE Le_Errors;
      END IF;

      IF Lv_EmpresaCod IS NULL THEN
         Pv_Mensaje := 'El parámetro estado está vacío';
         RAISE Le_Errors;
      END IF;

      IF Lv_nombreDpto IS NULL THEN
         Pv_Mensaje := 'El parámetro nombreDpto está vacío';
         RAISE Le_Errors;
      END IF;

      Lcl_Select :=   '
                    SELECT DISTINCT AC.NOMBRE_CUADRILLA ';

      Lcl_From   :=   ' 
                    FROM DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD IHS ';

      Lcl_WhereAndJoin := '
                    JOIN DB_HORAS_EXTRAS.INFO_HORAS_SOLICITUD_EMPLEADO IHSE ON IHSE.HORAS_SOLICITUD_ID = IHS.ID_HORAS_SOLICITUD
                    JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE ON VEE.NO_EMPLE = IHSE.NO_EMPLE
                    JOIN DB_COMERCIAL.INFO_PERSONA IP ON IP.LOGIN= VEE.LOGIN_EMPLE
                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.PERSONA_ID = IP.ID_PERSONA
                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                    JOIN DB_COMERCIAL.ADMI_CUADRILLA AC ON AC.ID_CUADRILLA = IPER.CUADRILLA_ID
                    WHERE IHS.EMPRESA_COD='''||Lv_EmpresaCod||''' AND VEE.NO_CIA='''||Lv_EmpresaCod||''' AND IHS.ID_HORAS_SOLICITUD='''||Ln_IdHorasSolicitud||'''
                    AND IER.EMPRESA_COD='''||Lv_EmpresaCod||''' AND IHS.ESTADO IN(''Pendiente'',''Anulada'')
                    AND VEE.NOMBRE_DEPTO='''||Lv_nombreDpto||''' ';

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

   END P_CONSULTA_CUADRI;

   PROCEDURE P_TIPOS_HORAS_EXTRAS(Pcl_Request   IN CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Pcl_Response OUT SYS_REFCURSOR)

   AS

      Lcl_Query              CLOB;
      Lcl_Select             CLOB;
      Lcl_From               CLOB;
      Lcl_WhereAndJoin       CLOB;
      Lcl_OrderAnGroup       CLOB;
      Lv_EmpresaCod          VARCHAR2(2);
      Le_Errors              EXCEPTION;


   BEGIN

   -- RETORNO LAS VARIABLES DEL REQUEST
      APEX_JSON.PARSE(Pcl_Request);
      Lv_EmpresaCod          :=  APEX_JSON.get_varchar2(p_path => 'empresaCod');

      Lcl_Select :=   '
                    SELECT ATHE.ID_TIPO_HORAS_EXTRA,ATHE.TIPO_HORAS_EXTRA  ';

      Lcl_From   :=   ' 
                    FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATHE ';

      Lcl_WhereAndJoin := '
                    WHERE ATHE.EMPRESA_COD='''||Lv_EmpresaCod||''' AND ATHE.ESTADO=''Activo'' 
                    AND ATHE.TIPO_HORAS_EXTRA NOT IN(''HORAS_NO_ESTIMADAS_MATUTINA'',''HORAS_NO_ESTIMADAS_NOCTURNA'',''HORA_FIN_DIA'',''DIALIBRE_DOBLE'') ';

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


   END P_TIPOS_HORAS_EXTRAS;

END HEKG_HORASEXTRAS_CONSULTA;
/
