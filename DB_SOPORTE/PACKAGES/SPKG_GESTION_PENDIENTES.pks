CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_GESTION_PENDIENTES
AS

  /*
  * Documentación para TYPE 'Gr_IdDetalle'.
  * Type para detalles de tareas
  * @author Andrés Montero H. <amontero@telconet.ec>
  * @version 1.0 15-09-2021
  */
  TYPE Gr_IdDetalle IS RECORD (
      ID_DETALLE DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE
  );

  /**
  * Documentacion para procedimiento 'P_GET_PENDIENTES'
  *
  * Procedimiento que obtiene informacion de tareas o casos pendientes asignados a un departamento
  * y que se encuentren registrados en DB_SOPORTE.INFO_ASIGNACION_SOLICITUD
  *
  * @param pv_cod_empresa IN VARCHAR2 id de la empresa
  * @param pn_departamento_id IN NUMBER id del departamento
  * @param pn_oficina_id IN NUMBER id de la oficina
  * @param pv_estado IN VARCHAR2 estado ABIERTO O CERRADO
  * @param pv_tipo IN VARCHAR2 tipo TAREA o CASO
  * @param pv_tab_visible IN VARCHAR2 tab visible del pendiente
  * @param pv_fecha_ini IN VARCHAR2 fecha de inicio del pendiente (tarea o caso)
  * @param pv_fecha_fin IN VARCHAR2 fecha de fin del pendiente (tarea o caso)
  * @param Pr_Informacion  OUT SYS_REFCURSOR  Retorna el resultado de la consulta
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 10-02-2021
  */
  PROCEDURE P_GET_PENDIENTES (
                        pv_cod_empresa     IN  VARCHAR2,
                        pn_departamento_id IN  NUMBER,
                        pn_canton_id       IN  NUMBER,
                        pv_estado          IN VARCHAR2,
                        pv_tipo            IN VARCHAR2,
                        pv_tab_visible     IN VARCHAR2,
                        pv_fecha_ini       IN VARCHAR2,
                        pv_fecha_fin       IN VARCHAR2,
                        Pr_Informacion     OUT SYS_REFCURSOR);

  /**
  * Documentacion para función 'F_GET_TAREAS_POR_CASO'
  *
  * Función que obtiene tareas asociadas a un caso
  *
  * @param Pv_id_caso IN DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso
  * @param Pv_id_departamento DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE id del departamento
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 10-02-2021
  */
FUNCTION F_GET_TAREAS_POR_CASO(
    Pv_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
    Pv_id_departamento DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE)
    RETURN VARCHAR2;

  /**
  * Documentacion para función 'F_GET_OBSERVACION_TAREA_CASO'
  *
  * Función que obtiene la observación de la primera tarea de un caso
  *
  * @param Pv_id_caso IN DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 10-02-2021
  */
FUNCTION F_GET_OBSERVACION_TAREA_CASO(
    Pv_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
    RETURN VARCHAR2;


  /**
  * Documentacion para función 'F_GET_FECHA_FIN_TAREA'
  *
  * Función que obtiene fecha finalización de una tarea
  *
  * @param Pv_id_caso IN DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION id de la tarea
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 10-02-2021
  */
FUNCTION F_GET_FECHA_FIN_TAREA(
    Pv_id_comunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
    RETURN VARCHAR2;

  /**
  * Documentacion para procedimiento 'P_GET_SEGUIMIENTOS'
  *
  * Procedimiento que obtiene los seguimientos de una tarea que se encuentren registrados en telcos y
  * registrados en DB_SOPORTE.INFO_ASIGNACION_SOLICITUD
  *
  * @param pn_tarea_id IN NUMBER id de la tarea
  * @param pn_departamento_id IN NUMBER id del departamento
  * @param pv_empresa_cod IN NUMBER id de la empresa
  * @param pn_referencia_id IN NUMBER id del caso o la tarea
  * @param pv_procedencia IN VARCHAR2 procedencia del seguimiento
  * @param Pr_Informacion  OUT SYS_REFCURSOR  Retorna el resultado de la consulta
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 10-02-2021
  */
  PROCEDURE P_GET_SEGUIMIENTOS (
                        pn_tarea_id        IN  NUMBER,
                        pn_departamento_id IN  NUMBER,
                        pv_empresa_cod     IN  NUMBER,
                        pn_referencia_id   IN  NUMBER,
                        pv_procedencia     IN  VARCHAR2,
                        Pr_Informacion     OUT SYS_REFCURSOR);

  /**
  * Documentacion para procedimiento 'P_GET_DATOS_TAREA'
  *
  * Procedimiento que obtiene los datos de la tarea
  *
  * @param pn_comunicacion_id IN NUMBER id de la tarea
  * @param Pr_Informacion  OUT SYS_REFCURSOR  Retorna el resultado de la consulta
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 18-03-2021
  */
  PROCEDURE P_GET_DATOS_TAREA
 (
    pn_comunicacion_id IN  NUMBER,
    Pr_Informacion     OUT SYS_REFCURSOR);

  /**
  * Documentacion para función 'F_GET_FECHA_FIN_ACT_PENDIENTE'
  *
  * Función que obtiene fecha fin del pendiente basada en última actualización en la tarea de recorrido o de informe
  *
  * @param Pv_id_asignacion_solicitud IN NUMBER id de la asignacion solicitud
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 11-05-2021
  */
  FUNCTION F_GET_FECHA_FIN_ACT_PENDIENTE(
      Pv_id_asignacion_solicitud DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE)
      RETURN VARCHAR2;

  /**
  * Documentacion para función 'F_GET_FECHA_INI_TAREA'
  *
  * Función que obtiene los de la tarea
  *
  * @param Pv_id_comunicacion IN NUMBER id comunicación
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 11-05-2021
  */
  FUNCTION F_GET_FECHA_INI_TAREA(
      Pv_id_comunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2;

  /**
  * Documentacion para función 'F_GET_DEPARTAMENTO_USUARIO'
  *
  * Función que obtiene los de la tarea
  *
  * @param Pv_usr_creacion IN VARCHAR2 - usuario al que pertenece el departamento
  * @param Pv_empresa_cod IN VARCHAR2 - id de la empresa
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 11-05-2021
  */
  FUNCTION F_GET_DEPARTAMENTO_USUARIO(
    Pv_usr_creacion DB_SOPORTE.INFO_TAREA_SEGUIMIENTO.USR_CREACION%TYPE,
    Pv_empresa_cod DB_SOPORTE.INFO_TAREA_SEGUIMIENTO.EMPRESA_COD%TYPE)
    RETURN VARCHAR2;


  /**
  * Documentacion para función 'F_GET_OBS_ULTIMO_SEGUIMIENTO'
  *
  * Función que obtiene el último seguimiento de una tarea
  *
  * @param Pn_id_comunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE - id de la tarea para buscar seguimiento
  * @param Pv_empresa_cod DB_SOPORTE.INFO_TAREA_SEGUIMIENTO.EMPRESA_COD%TYPE - id de la empresa
  *
  * @author Andrés Montero H <amontero@telconet.ec>
  * @version 1.0 08-07-2021
  */
FUNCTION F_GET_OBS_ULTIMO_SEGUIMIENTO(
        Pn_id_referencia NUMBER,
        Pv_tipo VARCHAR2
    )
    RETURN VARCHAR2;



END SPKG_GESTION_PENDIENTES;

/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_GESTION_PENDIENTES
AS


  PROCEDURE P_GET_PENDIENTES (
                        pv_cod_empresa     IN  VARCHAR2,
                        pn_departamento_id IN  NUMBER,
                        pn_canton_id       IN  NUMBER,
                        pv_estado          IN VARCHAR2,
                        pv_tipo            IN VARCHAR2,
                        pv_tab_visible     IN VARCHAR2,
                        pv_fecha_ini       IN VARCHAR2,
                        pv_fecha_fin       IN VARCHAR2,
                        Pr_Informacion     OUT SYS_REFCURSOR)
  AS
  Ln_IdCursor        NUMBER;
  Ln_NumeroRegistros NUMBER;
  Lv_Query           CLOB;
  BEGIN
  Lv_Query :=
  'SELECT ID_ASIGNACION,TIPO,NUMERO,ID,VERSION_INICIAL,OBSERVACION,TIPO_PROBLEMA,REFERENCIA_ID,ESTADO,ESTADO_PENDIENTE, '||
  q'[TO_CHAR(FECHA,'YYYY/MM/DD HH24:MI:SS') AS FECHA,FECHA_FIN,DETALLE_ID, ]'||
  'TAREAS,TRAMO,HILO_TELEFONICA,FECHA_INI_TAREA,FECHA_FIN_TAREA,TAREA_INFORME_ID,'||
  ' ASIGNADO_TAREA,TELEFONO_ASIGNADO_TAREA,ESTADO_TAREA_INFORME,CIRCUITO,NOTIFICACION,ULTIMO_SEGUIMIENTO,LOGIN '||
    ' FROM (SELECT DB_SOPORTE.ASIG.ID_ASIGNACION_SOLICITUD AS ID_ASIGNACION, ASIG.REFERENCIA_CLIENTE AS LOGIN, ASIG.TIPO_ATENCION AS TIPO, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  'ASIG.REFERENCIA_ID '||
  q'[WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  '(SELECT NUMERO_CASO FROM DB_SOPORTE.INFO_CASO WHERE ID_CASO = ASIG.REFERENCIA_ID) '||
  'ELSE '||
  q'[ '' ]'||
  ' END NUMERO, '||
  ' ASIG.REFERENCIA_ID AS ID, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  q'[ '' ]'||
  q'[WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  ' ASIG.DETALLE '||
  'ELSE '||
  q'[ '' ]'||
  ' END VERSION_INICIAL, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  '   ASIG.DETALLE '||
  q'[WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  q'[DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_OBSERVACION_TAREA_CASO(ASIG.REFERENCIA_ID) ]'||
  'ELSE '||
  q'[ '' ]'||
  ' END OBSERVACION, '||
  'ASIG.TIPO_PROBLEMA, '||
  'ASIG.TRAMO, '||
  'ASIG.HILO_TELEFONICA, '||
  'ASIG.DATO_ADICIONAL TAREA_INFORME_ID, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  q'[DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(ASIG.REFERENCIA_ID,'refasignado') ]'||
  q'[ELSE ]'||
  q'[ '' ]'||
  'END ASIGNADO_TAREA, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  q'[DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(ASIG.REFERENCIA_ID,'telefonorefasignado') ]'||
  q'[ELSE ]'||
  q'[ '' ]'||
  'END TELEFONO_ASIGNADO_TAREA, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  'DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_FECHA_INI_TAREA(ASIG.REFERENCIA_ID) '||
  q'[ELSE ]'||
  q'[ '' ]'||
  'END FECHA_INI_TAREA, '||
  q'[CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  'DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_FECHA_FIN_ACT_PENDIENTE(ASIG.ID_ASIGNACION_SOLICITUD) '||
  q'[ELSE ]'||
  q'[ '' ]'||
  'END FECHA_FIN_TAREA, '||
  'ASIG.REFERENCIA_ID, '||
  q'[ CASE WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  ' DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO(TO_NUMBER(ASIG.REFERENCIA_ID)) '||
  q'[ WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  ' DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(TO_NUMBER(ASIG.REFERENCIA_ID)) '||
  ' ELSE '||
  q'[ '' ]'||
  ' END ESTADO, '||
  q'[ CASE WHEN ASIG.TIPO_ATENCION='TAREA' AND ASIG.DATO_ADICIONAL IS NOT NULL AND ASIG.TAB_VISIBLE = 'GestionPendientesRecorridos' THEN ]' ||
  ' DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(TO_NUMBER(ASIG.DATO_ADICIONAL)) '||
  ' ELSE '||
  q'[ '' ]'||
  ' END ESTADO_TAREA_INFORME, '||
  ' ASIG.ESTADO AS ESTADO_PENDIENTE, '||
  ' ASIG.FE_CREACION AS FECHA, '||
  ' ASIG.NOTIFICACION AS NOTIFICACION, '||
  ' ASIG.CIRCUITO AS CIRCUITO, '||
  q'[ CASE WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  q'[ (SELECT TO_CHAR(ICASO.FE_CIERRE,'YYYY/MM/DD HH24:MI:SS') FROM DB_SOPORTE.INFO_CASO ICASO WHERE ICASO.ID_CASO = ASIG.REFERENCIA_ID )  ]'||
  q'[ WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  ' DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_FECHA_FIN_TAREA(ASIG.REFERENCIA_ID)  '||
  ' ELSE '||
  q'[ '' ]'||
  ' END FECHA_FIN, '||
  q'[ CASE WHEN ASIG.TIPO_ATENCION='TAREA' THEN ]' ||
  '(SELECT DETALLE_ID FROM DB_COMUNICACION.INFO_COMUNICACION WHERE ID_COMUNICACION = TO_NUMBER(ASIG.REFERENCIA_ID) ) '||
  ' ELSE '||
  q'[ NULL ]'||
  ' END DETALLE_ID, '||
   q'[ CASE WHEN ASIG.TIPO_ATENCION='CASO' THEN ]'||
  ' DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_TAREAS_POR_CASO(ASIG.REFERENCIA_ID, ASIG.DEPARTAMENTO_ID) ' ||
  ' ELSE '||
  q'[ '' ]'||
  'END TAREAS, ' ||
  q'[ CASE WHEN ASIG.TIPO_ATENCION='TAREA' AND ASIG.TAB_VISIBLE = 'GestionPendientesRecorridos' THEN ]' ||
  q'[CONCAT('Tarea:',CONCAT(TO_CHAR(ASIG.REFERENCIA_ID),CONCAT('**UltSeg:', CONCAT( ]'||
  q'[DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_OBS_ULTIMO_SEGUIMIENTO(ASIG.REFERENCIA_ID,ASIG.TIPO_ATENCION),CONCAT('|',  ]' ||
  q'[CONCAT('Tarea:',CONCAT(ASIG.DATO_ADICIONAL,CONCAT('**UltSeg:', ]'||
  'DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_OBS_ULTIMO_SEGUIMIENTO(TO_NUMBER(ASIG.DATO_ADICIONAL),ASIG.TIPO_ATENCION) ))))))))'||
  ' ELSE '||
  'DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_OBS_ULTIMO_SEGUIMIENTO(ASIG.REFERENCIA_ID,ASIG.TIPO_ATENCION)  END ' ||
  ' ULTIMO_SEGUIMIENTO '||
  ' FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD ASIG '||
  ' JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFI ON OFI.ID_OFICINA = ASIG.OFICINA_ID '||
  ' WHERE ASIG.EMPRESA_COD = :Pv_codEmpresa '
  ;

  IF pn_canton_id IS NOT NULL THEN
    Lv_Query := Lv_Query || ' AND OFI.CANTON_ID = :Pv_cantonId ';
  END IF;

  IF pv_tipo IS NOT NULL THEN
    Lv_Query := Lv_Query || ' AND ASIG.TIPO_ATENCION = :Pv_tipo ';
  END IF;

  IF pv_tab_visible IS NOT NULL THEN
    Lv_Query := Lv_Query || q'[ AND ASIG.TAB_VISIBLE = ']'||pv_tab_visible||q'[']';
  END IF;

  IF pn_departamento_id IS NOT NULL THEN
    Lv_Query := Lv_Query || ' AND ASIG.DEPARTAMENTO_ID = '||pn_departamento_id;
  END IF;

  IF pv_estado IS NOT NULL THEN 
    IF UPPER(pv_estado) = 'CERRADO' THEN
      Lv_Query := Lv_Query || ' AND ASIG.ESTADO  = :Pv_estadoCerr  ';
    ELSIF UPPER(pv_estado) = 'ABIERTO' THEN
      Lv_Query := Lv_Query || q'[ AND ( ASIG.ESTADO  = :Pv_estadoEnGest OR ASIG.ESTADO  = :Pv_estadoPend OR ASIG.ESTADO = 'ProblemaDeAcceso') ]';
    ELSIF UPPER(pv_estado) = 'PROBLEMAS_DE_ACCESO' THEN
      Lv_Query := Lv_Query || q'[ AND ASIG.ESTADO  = 'ProblemaDeAcceso' ]';
    END IF;
  ELSE
    Lv_Query := Lv_Query || q'[ AND ASIG.ESTADO  <> :Pv_estadoStandby AND ASIG.ESTADO  <> :Pv_estadoEliminado AND ASIG.ESTADO <> 'Inactivo' ]';
  END IF;

  Lv_Query := Lv_Query || ') PS ';

  Lv_Query := Lv_Query || ' WHERE 1=1 ';


  IF pv_fecha_ini IS NOT NULL AND pv_fecha_fin IS NOT NULL THEN
      Lv_Query := Lv_Query || 
                  q'[ AND TRUNC(PS.FECHA) >= TO_DATE(:Pv_fecha_ini ,'DD/MM/YYYY') ]'
                  ||
                  q'[ AND TRUNC(PS.FECHA) <= TO_DATE(:Pv_fecha_fin ,'DD/MM/YYYY') ]'

                  ;
  END IF;

  Lv_Query := Lv_Query || ' ORDER BY PS.FECHA DESC';

  Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
  DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_codEmpresa'    ,  pv_cod_empresa );

  IF pn_canton_id IS NOT NULL THEN
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_cantonId',  pn_canton_id );
  END IF;

  IF pv_tipo IS NOT NULL THEN
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_tipo',  pv_tipo );
  END IF;

  IF pv_estado IS NOT NULL THEN 
    IF UPPER(pv_estado) = 'CERRADO' THEN
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoCerr',  'Cerrado' );
    ELSIF UPPER(pv_estado) = 'ABIERTO' THEN
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoEnGest','EnGestion' );
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoPend','Pendiente' );
    END IF;
  ELSE
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoStandby',  'Standby' );
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoEliminado',  'Eliminado' );
  END IF;

  IF pv_fecha_ini IS NOT NULL AND pv_fecha_fin IS NOT NULL THEN
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_fecha_ini',  pv_fecha_ini );
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_fecha_fin',  pv_fecha_fin );
  END IF;
  --
  --
  Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
  Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);

  EXCEPTION
  WHEN OTHERS THEN

    db_general.gnrlpck_util.insert_error('Telcos +',
                                          'SPKG_GESTION_PENDIENTES.P_GET_PENDIENTES',
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                        );



  END P_GET_PENDIENTES;

FUNCTION F_GET_TAREAS_POR_CASO(
    Pv_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
    Pv_id_departamento DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_Resultado    VARCHAR2(4000);
    Lv_Query        VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_id_caso IS NOT NULL THEN
      --
      --COSTO QUERY: 39

      SELECT '['||TAREAS||']' INTO Lv_Resultado
      FROM
      (
          SELECT LISTAGG(
          '{"ID":"'||DET.ID_COMUNICACION||'",'||
          '"IDDET":"'||DET.ID_DETALLE||'",'||
          '"ESTADO":"'||DET.ESTADO||'"'||
                        '}', ' ,'
          )
          WITHIN GROUP(ORDER BY DET.ID_COMUNICACION ASC) AS TAREAS
          FROM 
          (SELECT * FROM (
            SELECT (SELECT MIN(com.ID_COMUNICACION) FROM DB_COMUNICACION.INFO_COMUNICACION com 
            WHERE com.DETALLE_ID= d.id_detalle) AS ID_COMUNICACION,
           --(SELECT MAX(da.ASIGNADO_ID) FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION da 
           -- WHERE da.DETALLE_ID = d.id_detalle) AS ID_ASIGNADO,
               d.ID_DETALLE , dh.ESTADO
                  FROM 
                  DB_SOPORTE.Info_Detalle d,
                  DB_SOPORTE.Info_Detalle_Hipotesis dhi,  
                  DB_SOPORTE.Info_Detalle_Historial dh,  
                  DB_SOPORTE.Admi_Tarea t
                  WHERE d.tarea_Id = t.id_tarea 
                  AND dhi.caso_Id = Pv_id_caso
                  AND d.detalle_Hipotesis_Id = dhi.id_detalle_hipotesis 
                  AND dh.detalle_Id = d.id_detalle 
                  AND dh.id_detalle_historial = (SELECT MAX(dhmax.id_detalle_historial) 
                                FROM DB_SOPORTE.Info_Detalle_Historial dhMax
                                WHERE dhMax.detalle_Id = dh.detalle_Id)
                ) TA 
                --WHERE TA.ID_ASIGNADO = Pv_id_departamento
          )DET 
      );
    --

    END IF;
    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_TAREAS_POR_CASO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_TAREAS_POR_CASO;



  PROCEDURE P_GET_SEGUIMIENTOS (
                        pn_tarea_id        IN  NUMBER,
                        pn_departamento_id IN  NUMBER,
                        pv_empresa_cod     IN  NUMBER,
                        pn_referencia_id   IN  NUMBER,
                        pv_procedencia     IN  VARCHAR2,
                        Pr_Informacion     OUT SYS_REFCURSOR)
  AS
  Ln_IdCursor        NUMBER;
  Ln_NumeroRegistros NUMBER;
  Lv_Query           VARCHAR2(4000);
  Lv_Query_where     VARCHAR2(1000);
  BEGIN
  IF pv_procedencia IS NOT NULL THEN
    Lv_Query_where := Lv_Query_where || ' AND asigs.PROCEDENCIA = :Pv_procedencia ';
  END IF;

  Lv_Query_where := Lv_Query_where || ' AND asigs.COMUNICACION_ID = :Pn_comunicacionId ';

  Lv_Query :=
            'SELECT * FROM ( ( SELECT '||
            q'[ TO_CHAR(seg.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') AS FE_CREACION, ]'||
            'seg.USR_CREACION,seg.EMPRESA_COD,'||
            ' SPKG_UTILIDADES.F_GET_CLOB_TO_VARCHAR(seg.ROWID) AS OBSERVACION, '||
            q'[ SPKG_GESTION_PENDIENTES.F_GET_DEPARTAMENTO_USUARIO(seg.USR_CREACION,seg.EMPRESA_COD) AS DEPARTAMENTO, 'EXTERNO' AS TIPO ]'||
            'FROM DB_COMUNICACION.INFO_COMUNICACION com '||
            'JOIN DB_SOPORTE.INFO_DETALLE det ON det.ID_DETALLE = com.DETALLE_ID '||
            'JOIN DB_SOPORTE.INFO_TAREA_SEGUIMIENTO seg ON seg.DETALLE_ID = det.ID_DETALLE '||
            'JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO emp ON emp.COD_EMPRESA = seg.EMPRESA_COD '||
            'WHERE '|| 
            'com.ID_COMUNICACION = :Pv_idTarea '||
            'AND seg.EMPRESA_COD = :Pv_empresaCod '||
            ' ) '
            ||
            ' UNION ' ||
            '( SELECT '||
            q'[ TO_CHAR(asigs.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') AS FE_CREACION, ]'||
            q'[ asigs.USR_CREACION, asig.EMPRESA_COD, asigs.DETALLE AS OBSERVACION, depa.NOMBRE_DEPARTAMENTO AS DEPARTAMENTO, 'INTERNO' AS TIPO ]'||
            ' FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig ' ||
            ' JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION asigs ON asigs.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD '||
            ' JOIN DB_COMERCIAL.ADMI_DEPARTAMENTO depa ON depa.ID_DEPARTAMENTO = asig.DEPARTAMENTO_ID  '||
            ' WHERE '||
            ' asig.REFERENCIA_ID = :Pv_referenciaId ' ||
            Lv_Query_where ||
            ' ) ) SEGUIMIENTOS ORDER BY SEGUIMIENTOS.FE_CREACION DESC '
              ;


  Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
  DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
  --DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_idDepartamento',  pn_departamento_id );
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_empresaCod',  pv_empresa_cod );
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_idTarea',  pn_tarea_id );
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_referenciaId',  pn_referencia_id );

  IF pv_procedencia IS NOT NULL THEN
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_procedencia',  pv_procedencia );
  END IF;

  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_comunicacionId',  pn_tarea_id );
  --
  --
  Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
  Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);

  EXCEPTION
  WHEN OTHERS THEN

    db_general.gnrlpck_util.insert_error('Telcos +',
                                          'SPKG_GESTION_PENDIENTES.P_GET_SEGUIMIENTOS',
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                        );



  END P_GET_SEGUIMIENTOS;

FUNCTION F_GET_OBSERVACION_TAREA_CASO(
    Pv_id_caso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_Resultado    VARCHAR2(4000);
    Lv_Query        VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_id_caso IS NOT NULL THEN
      --
      --COSTO QUERY: 3

      SELECT  dbms_lob.substr(DET1.OBSERVACION,4000,1) AS OBSERVACION INTO Lv_Resultado
      FROM DB_SOPORTE.INFO_DETALLE DET1
      WHERE DET1.ID_DETALLE = 
          (SELECT MIN(ID_DETALLE) FROM 
              (SELECT 
                  d.ID_DETALLE 
                FROM 
                DB_SOPORTE.Info_Detalle d,
                DB_SOPORTE.Info_Detalle_Hipotesis dhi,  
                DB_SOPORTE.Info_Detalle_Historial dh,  
                DB_SOPORTE.Admi_Tarea t
                WHERE d.tarea_Id = t.id_tarea 
                AND dhi.caso_Id = Pv_id_caso
                AND d.detalle_Hipotesis_Id = dhi.id_detalle_hipotesis 
                AND dh.detalle_Id = d.id_detalle 
                AND dh.id_detalle_historial = (SELECT MAX(dhmax.id_detalle_historial) 
                              FROM DB_SOPORTE.Info_Detalle_Historial dhMax
                              WHERE dhMax.detalle_Id = dh.detalle_Id)
              )
          );
    --

    END IF;
    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_OBSERVACION_TAREA_CASO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_OBSERVACION_TAREA_CASO;



FUNCTION F_GET_FECHA_FIN_TAREA(
    Pv_id_comunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_Resultado    VARCHAR2(4000);
    Lv_Query        VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_id_comunicacion IS NOT NULL THEN
      --
      --COSTO QUERY: 3

      SELECT TO_CHAR(dhis1.FE_CREACION,'YYYY/MM/DD HH24:MI:SS')  INTO Lv_Resultado FROM 
      DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis1 WHERE dhis1.ID_DETALLE_HISTORIAL =
      (
        SELECT MAX(dhis.ID_DETALLE_HISTORIAL) FROM 
        DB_COMUNICACION.INFO_COMUNICACION com
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis ON dhis.DETALLE_ID = com.DETALLE_ID
        WHERE ID_COMUNICACION = Pv_id_comunicacion 
        AND dhis.ESTADO = 'Finalizada'
      );
    --

    END IF;
    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_FECHA_FIN_TAREA',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_FECHA_FIN_TAREA;

  PROCEDURE P_GET_DATOS_TAREA(
    pn_comunicacion_id IN  NUMBER,
    Pr_Informacion     OUT SYS_REFCURSOR)
  AS
  Ln_IdCursor        NUMBER;
  Ln_NumeroRegistros NUMBER;
  Lv_Query           VARCHAR2(4000);
  Lv_Query_where     VARCHAR2(1000);
  BEGIN

  Lv_Query :=
            'SELECT  '||
            q'[ TO_CHAR(det.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') AS FECHA, ]' ||
            '   DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_FECHA_INI_TAREA(com.ID_COMUNICACION) AS FECHA_INI_TAREA, '||
            '   DB_SOPORTE.SPKG_GESTION_PENDIENTES.F_GET_FECHA_FIN_TAREA(com.ID_COMUNICACION) AS FECHA_FIN_TAREA, '||
            '   DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(com.ID_COMUNICACION) AS ESTADO, '||
            'dbms_lob.substr(det.OBSERVACION,4000,1) AS OBSERVACION, '||
            'dbms_lob.substr(det.OBSERVACION,4000,1) AS observacion_up, '||
            'ATA.NOMBRE_TAREA AS TAREA, '||
            'com.DETALLE_ID AS DETALLE_ID, '||
            q'[  DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(com.ID_COMUNICACION,'refasignado')   NOMBRE_ASIGNADO, ]'||
            q'[  DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(com.ID_COMUNICACION,'telefonorefasignado')  TELEFONO_ASIGNADO ]'||
            'FROM DB_COMUNICACION.INFO_COMUNICACION com '||
            'JOIN DB_SOPORTE.INFO_DETALLE det ON det.ID_DETALLE = com.DETALLE_ID '||
            'JOIN DB_SOPORTE.ADMI_TAREA ATA ON det.TAREA_ID = ATA.ID_TAREA ' ||
            ' WHERE '||
            'com.ID_COMUNICACION = :Pn_comunicacionId '
            ;

  Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
  DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_comunicacionId',  pn_comunicacion_id );
  --
  --
  Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
  Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);

  EXCEPTION
  WHEN OTHERS THEN

    db_general.gnrlpck_util.insert_error('Telcos +',
                                          'SPKG_GESTION_PENDIENTES.P_GET_DATOS_TAREA',
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                        );

  END P_GET_DATOS_TAREA;


FUNCTION F_GET_FECHA_FIN_ACT_PENDIENTE(
    Pv_id_asignacion_solicitud DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    Ln_idTareaRecorrido NUMBER;
    Ln_idTareaInforme   NUMBER;
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_id_asignacion_solicitud IS NOT NULL THEN
      SELECT TO_NUMBER(REFERENCIA_ID,'9999999999'), TO_NUMBER(DATO_ADICIONAL,'9999999999') INTO Ln_idTareaRecorrido, Ln_idTareaInforme
      FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD WHERE 
      ID_ASIGNACION_SOLICITUD = Pv_id_asignacion_solicitud;
    END IF;

    IF Ln_idTareaRecorrido IS NOT NULL THEN
      --
      SELECT TO_CHAR(MAX(FECHA),'YYYY/MM/DD HH24:MI:SS') INTO Lv_Resultado FROM 
      (
            (
                SELECT dhis1.FE_CREACION FECHA FROM 
                DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis1 WHERE dhis1.ID_DETALLE_HISTORIAL =
                (
                  SELECT MAX(dhis.ID_DETALLE_HISTORIAL) FROM 
                  DB_COMUNICACION.INFO_COMUNICACION com
                  JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis ON dhis.DETALLE_ID = com.DETALLE_ID
                  WHERE ID_COMUNICACION = Ln_idTareaRecorrido 
                  AND dhis.ESTADO = 'Finalizada'
                )
            )
            UNION ALL
            (
                SELECT dhis1.FE_CREACION FECHA FROM 
                DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis1 WHERE dhis1.ID_DETALLE_HISTORIAL =
                (
                  SELECT MAX(dhis.ID_DETALLE_HISTORIAL) FROM 
                  DB_COMUNICACION.INFO_COMUNICACION com
                  JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis ON dhis.DETALLE_ID = com.DETALLE_ID
                  WHERE ID_COMUNICACION = Ln_idTareaInforme 
                  AND dhis.ESTADO = 'Finalizada'  
            )
          )
      );

    END IF;


    --SI NO ENCONTRO FECHA FIN DE LA TAREA RECORRIDO ENTONCES BUSCA
    --EL ULTIMO SEGUIMIENTO INGRESADO EN LA TAREA DE RECORRIDO
    IF Lv_Resultado IS NULL THEN

      SELECT TO_CHAR(MAX(FECHA),'YYYY/MM/DD HH24:MI:SS') INTO Lv_Resultado FROM  
      (
        (
          SELECT SEG1.FE_CREACION FECHA
          FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG1 WHERE SEG1.ID_SEGUIMIENTO =
          (SELECT MAX(ID_SEGUIMIENTO) FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG
          JOIN DB_SOPORTE.INFO_DETALLE DET ON DET.ID_DETALLE = SEG.DETALLE_ID
          JOIN DB_SOPORTE.INFO_COMUNICACION COM ON COM.DETALLE_ID = DET.ID_DETALLE
          WHERE
          COM.ID_COMUNICACION = Ln_idTareaRecorrido)
        )
        UNION ALL
        (
          SELECT SEG1.FE_CREACION FECHA
          FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG1 WHERE SEG1.ID_SEGUIMIENTO =
          (SELECT MAX(ID_SEGUIMIENTO) FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG
          JOIN DB_SOPORTE.INFO_DETALLE DET ON DET.ID_DETALLE = SEG.DETALLE_ID
          JOIN DB_SOPORTE.INFO_COMUNICACION COM ON COM.DETALLE_ID = DET.ID_DETALLE
          WHERE
          COM.ID_COMUNICACION = Ln_idTareaInforme)
        )
      )
      ;
    END IF;

    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_FECHA_FIN_ACT_PENDIENTE',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_FECHA_FIN_ACT_PENDIENTE;


FUNCTION F_GET_FECHA_INI_TAREA(
    Pv_id_comunicacion DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --

    IF Pv_id_comunicacion IS NOT NULL THEN
      --
                SELECT TO_CHAR(dhis1.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') INTO Lv_Resultado 
                FROM 
                DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis1 WHERE dhis1.ID_DETALLE_HISTORIAL =
                (
                  SELECT MIN(dhis.ID_DETALLE_HISTORIAL) FROM 
                  DB_COMUNICACION.INFO_COMUNICACION com
                  JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL dhis ON dhis.DETALLE_ID = com.DETALLE_ID
                  WHERE ID_COMUNICACION = Pv_id_comunicacion 
                );

    END IF;

    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_FECHA_INI_TAREA',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_FECHA_INI_TAREA;


FUNCTION F_GET_DEPARTAMENTO_USUARIO(
    Pv_usr_creacion DB_SOPORTE.INFO_TAREA_SEGUIMIENTO.USR_CREACION%TYPE,
    Pv_empresa_cod DB_SOPORTE.INFO_TAREA_SEGUIMIENTO.EMPRESA_COD%TYPE

    )
    RETURN VARCHAR2
  IS
    --
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --

    IF Pv_usr_creacion IS NOT NULL THEN
      --
        SELECT MAX(DEP.NOMBRE_DEPARTAMENTO) INTO Lv_Resultado
        FROM DB_COMERCIAL.INFO_PERSONA P
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER ON PER.PERSONA_ID = P.ID_PERSONA
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EROL ON EROL.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
        JOIN DB_GENERAL.ADMI_DEPARTAMENTO DEP ON DEP.ID_DEPARTAMENTO = PER.DEPARTAMENTO_ID
        WHERE 
        LOGIN = Pv_usr_creacion
        AND EROL.EMPRESA_COD = Pv_empresa_cod
        AND PER.ESTADO='Activo';

    END IF;

    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_DEPARTAMENTO_USUARIO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_DEPARTAMENTO_USUARIO;


FUNCTION F_GET_OBS_ULTIMO_SEGUIMIENTO(
        Pn_id_referencia NUMBER,
        Pv_tipo VARCHAR2
    )
    RETURN VARCHAR2
  IS
    --
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    --
    Lrf_Tareas       SYS_REFCURSOR;
    Lr_Tareas               Gr_IdDetalle;
    Ln_IdTarea NUMBER;
    Lv_Seguimiento VARCHAR2(4000);
    Lt_Indice_tarea       NUMBER := 1;

    --
    TYPE T_Array_tareas IS TABLE OF Gr_IdDetalle INDEX BY BINARY_INTEGER;
    Lt_tareas T_Array_tareas;
    --
    CURSOR C_GetDetallesTxCaso(cn_id_caso NUMBER)
    IS
    SELECT 
    d.ID_DETALLE 
    FROM 
    DB_SOPORTE.Info_Detalle d,
    DB_SOPORTE.Info_Detalle_Hipotesis dhi, 
    DB_SOPORTE.Info_Detalle_Historial dh,  
    DB_SOPORTE.Admi_Tarea t 
    WHERE d.tarea_Id = t.id_tarea 
    AND dhi.caso_Id =  cn_id_caso 
    AND d.detalle_Hipotesis_Id = dhi.id_detalle_hipotesis
    AND dh.detalle_Id = d.id_detalle
    AND dh.id_detalle_historial = (SELECT MAX(dhmax.id_detalle_historial)
    FROM 
    DB_SOPORTE.Info_Detalle_Historial dhMax 
    WHERE 
    dhMax.detalle_Id = dh.detalle_Id);

    --
  BEGIN
    --
    Lv_Resultado := '';
    --

    IF Pn_id_referencia IS NOT NULL THEN

      IF Pv_tipo = 'TAREA' THEN
        --
          SELECT TAREAS.DETALLE_SEGUIMIENTO INTO Lv_Resultado 
            FROM 
            (
              SELECT FE_CREACION,DETALLE_SEGUIMIENTO 
              FROM 
              (
                    (
                      SELECT SPKG_UTILIDADES.F_GET_CLOB_TO_VARCHAR(SEG2.ROWID) AS DETALLE_SEGUIMIENTO, seg2.FE_CREACION 
                              FROM  DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG2 WHERE SEG2.ID_SEGUIMIENTO = 
                                (SELECT 
                                MAX(seg.ID_SEGUIMIENTO)  
                                FROM DB_COMUNICACION.INFO_COMUNICACION com 
                                JOIN DB_SOPORTE.INFO_DETALLE det ON det.ID_DETALLE = com.DETALLE_ID 
                                JOIN DB_SOPORTE.INFO_TAREA_SEGUIMIENTO seg ON seg.DETALLE_ID = det.ID_DETALLE 
                                WHERE 
                                com.ID_COMUNICACION = Pn_id_referencia  
                                )                        
                    )
                    UNION ALL
                    (
                      SELECT 
                        segui.DETALLE AS DETALLE_SEGUIMIENTO, segui.FE_CREACION
                      FROM DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION segui 
                      WHERE segui.ID_SEGUIMIENTO_ASIGNACION = 
                      (
                        SELECT MAX(sasig.ID_SEGUIMIENTO_ASIGNACION) FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD sol
                        JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sasig ON sasig.ASIGNACION_SOLICITUD_ID = sol.ID_ASIGNACION_SOLICITUD
                        WHERE 
                        sasig.COMUNICACION_ID = Pn_id_referencia
                      )
                    )
              ) ORDER BY FE_CREACION DESC
            )TAREAS 
            WHERE  rownum = 1;

      ELSE
          OPEN C_GetDetallesTxCaso(Pn_id_referencia);
            FETCH C_GetDetallesTxCaso BULK COLLECT INTO Lt_tareas LIMIT 500;
          CLOSE C_GetDetallesTxCaso;

        WHILE Lt_Indice_tarea <= Lt_tareas.COUNT LOOP

              SELECT MIN(ID_COMUNICACION) INTO Ln_IdTarea FROM DB_COMUNICACION.INFO_COMUNICACION 
              WHERE DETALLE_ID = Lt_tareas(Lt_Indice_tarea).ID_DETALLE;

              SELECT TAREAS.DETALLE_SEGUIMIENTO INTO Lv_Seguimiento 
              FROM 
              (
                SELECT FE_CREACION,DETALLE_SEGUIMIENTO 
                FROM 
                (
                      (
                        SELECT SPKG_UTILIDADES.F_GET_CLOB_TO_VARCHAR(SEG2.ROWID) AS DETALLE_SEGUIMIENTO, seg2.FE_CREACION 
                                FROM  DB_SOPORTE.INFO_TAREA_SEGUIMIENTO SEG2 WHERE SEG2.ID_SEGUIMIENTO = 
                                  (SELECT 
                                  MAX(seg.ID_SEGUIMIENTO)  
                                  FROM DB_COMUNICACION.INFO_COMUNICACION com 
                                  JOIN DB_SOPORTE.INFO_DETALLE det ON det.ID_DETALLE = com.DETALLE_ID 
                                  JOIN DB_SOPORTE.INFO_TAREA_SEGUIMIENTO seg ON seg.DETALLE_ID = det.ID_DETALLE 
                                  WHERE 
                                  com.ID_COMUNICACION = Ln_IdTarea  
                                  )                        
                      )
                      UNION ALL
                      (
                        SELECT 
                          segui.DETALLE AS DETALLE_SEGUIMIENTO, segui.FE_CREACION
                        FROM DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION segui 
                        WHERE segui.ID_SEGUIMIENTO_ASIGNACION = 
                        (
                          SELECT MAX(sasig.ID_SEGUIMIENTO_ASIGNACION) FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD sol
                          JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sasig ON sasig.ASIGNACION_SOLICITUD_ID = sol.ID_ASIGNACION_SOLICITUD
                          WHERE 
                          sasig.COMUNICACION_ID = Ln_IdTarea
                        )
                      )
                ) ORDER BY FE_CREACION DESC
              )TAREAS 
              WHERE  rownum = 1;
              Lv_Resultado := Lv_Resultado ||'Tarea:'||Ln_IdTarea||'**UltSeg:'||Lv_Seguimiento||'|';
              Lt_Indice_tarea := Lt_Indice_tarea + 1;
        END LOOP;

      END IF;

    END IF;

    --
  RETURN Lv_Resultado;
  --
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'F_GET_OBS_ULTIMO_SEGUIMIENTO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_OBS_ULTIMO_SEGUIMIENTO;

END SPKG_GESTION_PENDIENTES;
/
