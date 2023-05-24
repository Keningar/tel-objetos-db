CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS AS

 /**
  * Documentacion para el procedimiento P_MAIN
  *
  * M�todo encargado de ejecutar los procesos para la creacion de la planificacion de las cuadrillas.
  *
  * @param Pn_CuadrillaId     IN  NUMBER Recibe el id de la cuadrilla
  * @param Pn_IntervaloId     IN  NUMBER Recibe el id del intervalo
  * @param Pt_FechaDesde      IN  TIMESTAMP Recibe la fecha desde
  * @param Pt_FechaHasta      IN  TIMESTAMP Recibe la fecha hasta
  * @param Pv_EmpresaCod      IN  VARCHAR2 Recibe el id de la empresa
  * @param Pv_AsignadoMobile  IN  VARCHAR2 Recibe S o N para identificar si es movil
  * @param Pv_UsrCreacion     IN  VARCHAR2 Recibi el usuario de creacion
  * @param Pv_IpCreacion      IN  VARCHAR2 Recibi la ip de creacion
  * @param Pn_PersonaRolId    IN  NUMBER Recibi el id de la persona empresa rol, de la persona que esta realizando la planificacion
  * @param Pv_Automatico      IN  VARCHAR2 Recibi el identificador si es automatico o no
  * @param Pn_ZonaId          IN  NUMBER Recibi el id de la zona
  * @param Pv_Actividad       IN  VARCHAR2 Recibe la actividad que se realiza en la planificaci�n,
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  *
  * @version 1.1 28-10-2020 - Se agrega nuevo parametro Actividad para que pueda ser registrado en la cabecera de la planificaci�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  */
  PROCEDURE P_MAIN(Pn_CuadrillaId    IN  NUMBER,
                   Pn_IntervaloId    IN  NUMBER, 
                   Pt_FechaDesde     IN  TIMESTAMP, 
                   Pt_FechaHasta     IN  TIMESTAMP,
                   Pv_EmpresaCod     IN  VARCHAR2,
                   Pv_AsignadoMobile IN  VARCHAR2,
                   Pv_UsrCreacion    IN  VARCHAR2,
                   Pv_IpCreacion     IN  VARCHAR2,
                   Pn_PersonaRolId   IN  NUMBER,
                   Pv_Automatico     IN  VARCHAR2,
                   Pn_ZonaId         IN  NUMBER,
                   Pv_Actividad      IN  VARCHAR2,
                   Pv_Error          OUT VARCHAR2);

 /**
  * Documentacion para el procedimiento P_SET_PLANIF_CUADRILLA_MANUAL
  *
  * M�todo encargado de realizar la planificacion
  *
  * @param Pn_CuadrillaId     IN  NUMBER Recibe el id de la cuadrilla
  * @param Pn_IntervaloId     IN  NUMBER Recibe el id del intervalo
  * @param Pt_FechaDesde      IN  TIMESTAMP Recibe la fecha desde
  * @param Pt_FechaHasta      IN  TIMESTAMP Recibe la fecha hasta
  * @param Pv_EmpresaCod      IN  VARCHAR2 Recibe el id de la empresa
  * @param Pv_AsignadoMobile  IN  VARCHAR2 Recibe S o N para identificar si es movil
  * @param Pv_UsrCreacion     IN  VARCHAR2 Recibi el usuario de creacion
  * @param Pv_IpCreacion      IN  VARCHAR2 Recibi la ip de creacion
  * @param Pn_PersonaRolId    IN  NUMBER Recibi el id de la persona empresa rol, de la persona que esta realizando la planificacion
  * @param Pn_ZonaId          IN  NUMBER Recibi el id de la zona
  * @param Pv_Actividad       IN VARCHAR2 Recibe la actividad que se realiza en la planificaci�n
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 24-08-2018 - Se realiza ajustes en el m�todo para detectar si existe una planificaci�n creada en estado 'Liberado'
  *                           y en caso de existir se actualiza el estado a 'Activo'
  *
  * @version 1.2 28-10-2020 - Se agrega nuevo parametro Actividad para que pueda ser registrado en la cabecera de la planificaci�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  */
  PROCEDURE P_SET_PLANIF_CUADRILLA_MANUAL(Pn_CuadrillaId    IN  NUMBER,
                                          Pn_IntervaloId    IN  NUMBER, 
                                          Pt_FechaDesde     IN  TIMESTAMP, 
                                          Pt_FechaHasta     IN  TIMESTAMP,
                                          Pv_EmpresaCod     IN  VARCHAR2,
                                          Pv_AsignadoMobile IN  VARCHAR2,
                                          Pv_UsrCreacion    IN  VARCHAR2,
                                          Pv_IpCreacion     IN  VARCHAR2,
                                          Pn_PersonaRolId   IN  NUMBER,
                                          Pn_ZonaId         IN  NUMBER,
                                          Pv_Actividad      IN VARCHAR2,
                                          Pv_Error          OUT VARCHAR2);

 /**
  * Documentacion para el procedimiento P_GENERA_INTERVALO
  *
  * M�todo encargado de realizar la granularidad de los intervalos de tiempo de trabajo de una cuadrilla
  *
  * @param Pn_PlanifCuadrillaId IN  NUMBER Recibe el id de la cuadrilla
  * @param Pn_IntervaloId       IN  NUMBER Recibe el id del intervalo
  * @param Pt_FechaRegistro     IN  TIMESTAMP Recibe la fecha de planificacion
  * @param Pn_PersonaRolId      IN  NUMBER Recibe la persona empresa rol, encargada de crear la planificacion
  * @param Pv_UsrCreacion       IN  VARCHAR2 Recibe el usuario de creacion
  * @param Pv_IpCreacion        IN  VARCHAR2 Recibe la ipd de creacion
  * @param Pv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  */
  PROCEDURE P_GENERA_INTERVALO(Pn_PlanifCuadrillaId IN  NUMBER, 
                               Pn_IntervaloId       IN  NUMBER,
                               Pt_FechaRegistro     IN  TIMESTAMP,
                               Pn_PersonaRolId      IN  NUMBER,
                               Pv_UsrCreacion       IN  VARCHAR2,
                               Pv_IpCreacion        IN  VARCHAR2,
                               Pv_Error             OUT VARCHAR2);

 /**
  * Documentacion para el procedimiento F_VALIDA_PLANIF_CUADRILLA
  *
  * Funci�n encargada de identificar si ya existe una planificacion creada para la fecha sugerida por parametro.
  *
  * @param Pn_CuadrillaId   IN  NUMBER Recibe el id de la cuadrilla
  * @param Pn_IntervaloId   IN  NUMBER Recibe el id del intervalo
  * @param Pv_EmpresaCod    IN  TIMESTAMP Recibe el id de la empresa
  * @param Pt_FechaRegistro IN  NUMBER Recibe la fecha de planificacion
  * @param Pv_Estado        IN  VARCHAR2 Recibe el estado de planificacion
  *
  * @RETURN NUMBER - Retorna 0 si no existe planificacion creada y 1 cuando existe una planificacion.
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  */
  FUNCTION F_VALIDA_PLANIF_CUADRILLA(Pn_CuadrillaId     IN NUMBER,
                                     Pn_IntervaloId     IN NUMBER,
                                     Pv_EmpresaCod      IN VARCHAR2,
                                     Pt_FechaRegistro   IN TIMESTAMP,
                                     Pv_Estado          IN VARCHAR2) RETURN NUMBER;

 /**
  * Documentacion para el procedimiento F_INSERTA_PLANIF_CUADRILLA_CAB
  *
  * Funci�n encargada de identificar si ya existe una planificacion creada para la fecha sugerida por parametro.
  *
  * @param Fn_CuadrillaId     IN  NUMBER Recibe el id de la cuadrilla
  * @param Fn_IntervaloId     IN  NUMBER Recibe el id del intervalo
  * @param Fv_EmpresaCod      IN  VARCHAR2 Recibe el id de la empresa
  * @param Ft_FechaTrabajo    IN  TIMESTAMP Recibe la fecha de planificacion
  * @param Fv_AsignadoMobile  IN  VARCHAR2 Recibe si S si mobil y N cuando no lo es
  * @param Fv_UsrCreacion     IN  VARCHAR2 Recibe el usuario de creacion
  * @param Fv_IpCreacion      IN  VARCHAR2 Recibe la ip de creacion
  * @param Fn_ZonaId          IN  NUMBER Recibe el id de la Zona
  * @param Fv_Actividad       IN VARCHAR2 Recibe la actividad que se va a insertar en la planificaci�n
  * @param Fv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @RETURN NUMBER - Retorna el id de la generado de la tabla INFO_CUADRILLA_PLANIF_CAB
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  *
  * @version 1.1 28-10-2020 - Se agrega nuevo parametro Actividad para que pueda ser registrado en la cabecera de la planificaci�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  */
  FUNCTION F_INSERTA_PLANIF_CUADRILLA_CAB(Fn_CuadrillaId    IN  NUMBER,
                                          Fn_IntervaloId    IN  NUMBER,
                                          Fv_EmpresaCod     IN  VARCHAR2,
                                          Ft_FechaTrabajo   IN  TIMESTAMP,
                                          Fv_AsignadoMobile IN  VARCHAR2,
                                          Fv_UsrCreacion    IN  VARCHAR2,
                                          Fv_IpCreacion     IN  VARCHAR2,
                                          Fn_ZonaId         IN  NUMBER,
                                          Fv_Actividad      IN VARCHAR2,
                                          Fv_Error          OUT VARCHAR2) RETURN NUMBER;


 /**
  * Documentacion para el procedimiento F_INSERTA_PLANIF_CUADRILLA_CAB
  *
  * Funci�n encargada de identificar si ya existe una planificacion creada para la fecha sugerida por parametro.
  *
  * @param Pn_PlanifCuadrillaId IN  NUMBER Recibe el id de la tabla INFO_CUADRILLA_PLANIF_CAB
  * @param Pt_FechaInicio       IN  TIMESTAMP Recibe la fecha y hora de inicio
  * @param Pt_FechaFin          IN  TIMESTAMP Recibe la fecha y hora fin
  * @param Pn_personaRolId      IN  NUMBER Recibe la persona empresa rol, encargada de crear la planificacion
  * @param Pn_Orden             IN  NUMBER Recibe el orden para el calendario
  * @param Pn_Locacion          IN  NUMBER Recibe la locacion para el calendario
  * @param Pv_UsrCreacion       IN  VARCHAR2 Recibe el usuario de creacion
  * @param Pv_IpCreacion        IN  VARCHAR2 Recibe la ip de creacion
  * @param Fv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 23-04-2018
  *
  * Modificado: Se agrega el nuevo parametro Pv_TipoProceso, para identificar si el detalle de planificacion es creada por Manual o Automatico
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.2 28-06-2018
  *
  * Modificado: Se agrega en el insert la columna VISUALIZAR_MOVIL, para que se inserte el valor S o N de acuerdo al parametro configurado.
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.3 19-07-2018
  */
  PROCEDURE P_INSERTA_PLANIF_CUADRILLA_DET(Pn_PlanifCuadrillaId IN NUMBER,
                                           Pt_FechaInicio       IN TIMESTAMP,
                                           Pt_FechaFin          IN TIMESTAMP,
                                           Pn_personaRolId      IN NUMBER,
                                           Pn_Orden             IN NUMBER,
                                           Pn_Locacion          IN NUMBER,
                                           Pv_UsrCreacion       IN VARCHAR2,
                                           Pv_IpCreacion        IN VARCHAR2,
                                           Pv_TipoProceso       IN VARCHAR2,
                                           Pv_Error             OUT VARCHAR2);

 /**
  * Documentacion para el procedimiento P_ASIGNAR_SOLICITUD_TAREA
  *
  * M�todo encargado validar los parametros que llegue y obtener el intervalo de trabajo de una cuadrilla para
    asignar la solicitud de planificacion o la tarea de soporte.
  *
  * @param Pt_FeInicio    IN  TIMESTAMP Recibe la fecha de inicio del intervalo de trabajo
  * @param Pt_FeFin       IN  TIMESTAMP Recibe la fecha fin del intervalo de trabajo
  * @param Pt_FeIniOrigen IN  TIMESTAMP Recibe la fecha de inicio del intervalo de trabajo a liberar u/o limpiar
  * @param Pt_FeFinOrigen IN  TIMESTAMP Recibe la fecha fin del intervalo de trabajo a liberar u/o limpiar
  * @param Pn_IdCuadrilla IN  NUMBER Recibe el id de la cuadrilla
  * @param Pn_IdSolicitud IN  NUMBER Recibe el id de la solicitud de planificacion
  * @param Pn_IdTarea     IN  NUMBER Recibe el id de la tarea de soporte
  * @param Pv_User        IN  NUMBER Recibi el usuario que ejecuta el procedimineto
  * @param Fv_Error       OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 16-03-2018
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 12-07-2018 - Se realiza un nuevo filtro por estado Activo en el cursor que devuelve la jornada laboral de una cuadrilla.
  */
  PROCEDURE P_ASIGNAR_SOLICITUD_TAREA(Pt_FeInicio    IN  TIMESTAMP,
                                      Pt_FeFin       IN  TIMESTAMP,
                                      Pt_FeIniOrigen IN  TIMESTAMP,
                                      Pt_FeFinOrigen IN  TIMESTAMP,
                                      Pn_IdCuadrilla IN  NUMBER,
                                      Pn_IdSolicitud IN  NUMBER,
                                      Pn_IdTarea     IN  NUMBER,
                                      Pv_Opcion      IN  VARCHAR2,
                                      Pv_User        IN  VARCHAR2,
                                      Pv_Error       OUT VARCHAR2);

 /**
  * Documentacion para el procedimiento P_SET_PLINIF_CUAD_DET
  *
  * M�todo encargado de actualizar la informacion en la tabla INFO_CUADRILLA_PLANIF_DET
  *
  * @param Pn_IdPlanifDet     IN  NUMBER Recibe el id de la tabla
  * @param Pn_IdPlanifCab     IN  NUMBER Recibe el id de la tabla INFO_CUADRILLA_PLANIF_CAB
  * @param Pt_Feinicio        IN  TIMESTAMP Recibe la fecha de inicio del intervalo de trabajo
  * @param Pt_FeFin           IN  TIMESTAMP Recibe la fecha fin del intervalo de trabajo
  * @param Pn_IdPersonEmpRol  IN  NUMBER Recibe el id de la persona empresa rol id
  * @param Pn_Orden           IN  NUMBER Recibi el numero de orden
  * @param Pn_Locacion        IN  NUMBER Recibi el numero de locacion
  * @param Pn_IdSolicitudDet  IN  NUMBER Recibi el id de la solicitud de planificacion
  * @param Pn_IdTarea         IN  NUMBER Recibi el id de la tarea de soporte
  * @param Pv_UsrModificacion IN  VARCHAR2 Recibi el usuario que ejecuta el procedimineto
  * @param Fv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 16-03-2018
  */
  PROCEDURE P_SET_PLINIF_CUAD_DET(Pn_IdPlanifDet      IN NUMBER,
                                  Pn_IdPlanifCab      IN NUMBER,
                                  Pt_Feinicio         IN TIMESTAMP,
                                  Pt_FeFin            IN TIMESTAMP,
                                  Pn_IdPersonEmpRol   IN NUMBER,
                                  Pn_Orden            IN NUMBER,
                                  Pn_Locacion         IN NUMBER,
                                  Pn_IdSolicitudDet   IN NUMBER,
                                  Pn_IdTarea          IN NUMBER,
                                  Pv_UsrModificacion  IN VARCHAR2,
                                  Pv_Error           OUT VARCHAR2);
                                  
 /**
  * Documentacion para el procedimiento P_GENERA_INTERVALO_POR_ACT
  *
  * M�todo encargado de actualizar las horas de trabajo en la tabla INFO_CUADRILLA_PLANIF_DET
  *
  * @param Pn_PlanifCuadrillaId     IN  NUMBER Recibe el id de la tabla
  * @param Pn_HoraInicio            IN  TIMESTAMP Recibe la hora inicial de trabajo
  * @param Pn_HoraFin               IN  TIMESTAMP Recibe la hora final de trabajo
  * @param Pn_FechaRegistro         IN  TIMESTAMP Recibe la fecha de trabajo
  * @param Pn_PersonaRolId          IN  NUMBER Recibe el id de la persona empresa rol id
  * @param Pv_IpCreacion            IN  VARCHAR2 Recibe la ip creacion
  * @param Pv_UsrCreacion           IN  VARCHAR2 Recibe el usuario
  * @param Fv_Error                 OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Allan Suarez <arsuarez@telconet.ec>
  * @version 1.0 14-04-2018
  *
  * Modificado: Se realiza ajustes en el procedimiento para validar si la planificacion a ingresar ya se encuentra registrada, es caso de existir se actualiza el estado..
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 14-06-2018
  *
  * Modificado: Se agrega el nuevo parametro Pv_TipoProceso, para identificar si el detalle de planificacion es creada por Manual o Automatico
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.2 28-06-2018
  *
  */
  PROCEDURE P_GENERA_INTERVALO_POR_ACT(Pn_PlanifCuadrillaId IN  NUMBER, 
                                       Pn_HoraInicio        IN  TIMESTAMP,
                                       Pn_HoraFin           IN  TIMESTAMP,
                                       Pt_FechaRegistro     IN  TIMESTAMP,
                                       Pn_PersonaRolId      IN  NUMBER,
                                       Pv_UsrCreacion       IN  VARCHAR2,
                                       Pv_IpCreacion        IN  VARCHAR2,
                                       Pv_TipoProceso       IN  VARCHAR2,
                                       Pv_Error             OUT VARCHAR2);

  /**
   * Documentacion para el procedimiento P_SET_LIMPIAR_PLANIFICACION
   *
   * M�todo encargado de limpiar la planficacion de horas de trabajo en un rango de fecha determinado para una cuadrilla
   *
   * @param Pn_IdCuadrilla  IN  NUMBER Recibe el id de la cuadrilla
   * @param Pt_Feinicio     IN  TIMESTAMP Recibe la fecha de inicio
   * @param Pt_FeFin        IN  TIMESTAMP Recibe la fecha fin
   * @param Pv_Usuario      IN  VARCHAR2  Recibe el usuario quien realiza la modificacion
   * @param Fv_Error        OUT VARCHAR2  Retorna un mensaje de error en caso de existir
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-03-2018
   */
   PROCEDURE P_SET_LIMPIAR_PLANIFICACION(Pn_IdCuadrilla IN  NUMBER,
                                         Pt_Feinicio    IN  TIMESTAMP,
                                         Pt_FeFin       IN  TIMESTAMP,
                                         Pv_Usuario     IN  VARCHAR2,
                                         Pv_Error       OUT VARCHAR2);

  /**
   * Documentaci�n para el procedimiento P_UPDATE_VISUALIZAR_MOVIL
   *
   * M�todo encargado de actualizar el campo VISUALIZAR_MOVIL, para la visualizaci�n de las tareas en el telcos m�vil
   *
   * @param Pn_IdComunicacion  IN  NUMBER   Recibe el id de comunicaci�n u/o n�mero de tarea
   * @param Pv_VisualizarMovil IN  VARCHAR2 Recibe S o N para la visualizaci�n en el telcos m�vil
   * @param Pv_Usuario         IN  VARCHAR2 Recibe el usuario quien realiza la modificaci�n
   * @param Pv_Ip              IN  VARCHAR2 Recibe la ip quien realiza la modificaci�n
   * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-07-2018
   */
   PROCEDURE P_UPDATE_VISUALIZAR_MOVIL(Pn_IdComunicacion  IN  NUMBER,
                                       Pv_VisualizarMovil IN  VARCHAR2,
                                       Pv_Usuario         IN  VARCHAR2,
                                       Pv_Ip              IN  VARCHAR2,
                                       Pv_Error           OUT VARCHAR2);

END SPKG_PLANIFICACION_CUADRILLAS;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS AS

  /* VARIABLES GLOBALES */
  Lt_HoraBarrido    TIMESTAMP;
  Lt_HoraBarridoFin TIMESTAMP;
  Lt_HoraIni        TIMESTAMP;
  Lt_HoraFin        TIMESTAMP;

  /* PROCEDURE P_MAIN */
  PROCEDURE P_MAIN(Pn_CuadrillaId    IN  NUMBER,
                   Pn_IntervaloId    IN  NUMBER, 
                   Pt_FechaDesde     IN  TIMESTAMP, 
                   Pt_FechaHasta     IN  TIMESTAMP,
                   Pv_EmpresaCod     IN  VARCHAR2,
                   Pv_AsignadoMobile IN  VARCHAR2,
                   Pv_UsrCreacion    IN  VARCHAR2,
                   Pv_IpCreacion     IN  VARCHAR2,
                   Pn_PersonaRolId   IN  NUMBER,
                   Pv_Automatico     IN  VARCHAR2,
                   Pn_ZonaId         IN  NUMBER,
                   Pv_Actividad      IN  VARCHAR2,
                   Pv_Error          OUT VARCHAR2) AS

  BEGIN

    IF (UPPER(Pv_Automatico) != 'S') THEN
      DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_SET_PLANIF_CUADRILLA_MANUAL(Pn_CuadrillaId,
                                                                             Pn_IntervaloId, 
                                                                             Pt_FechaDesde, 
                                                                             Pt_FechaHasta,
                                                                             Pv_EmpresaCod,
                                                                             Pv_AsignadoMobile,
                                                                             Pv_UsrCreacion,
                                                                             Pv_IpCreacion,
                                                                             Pn_PersonaRolId,
                                                                             Pn_ZonaId,
                                                                             Pv_Actividad,
                                                                             Pv_Error);
    END IF;

  EXCEPTION

      WHEN OTHERS THEN
        Pv_Error := '{"estado":"fail"}';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                             'P_MAIN',
                                             'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_MAIN;

  /*  PROCEDURE P_SET_PLANIF_CUADRILLA_MANUAL */
  PROCEDURE P_SET_PLANIF_CUADRILLA_MANUAL(Pn_CuadrillaId    IN  NUMBER,
                                          Pn_IntervaloId    IN  NUMBER, 
                                          Pt_FechaDesde     IN  TIMESTAMP, 
                                          Pt_FechaHasta     IN  TIMESTAMP,
                                          Pv_EmpresaCod     IN  VARCHAR2,
                                          Pv_AsignadoMobile IN  VARCHAR2,
                                          Pv_UsrCreacion    IN  VARCHAR2,
                                          Pv_IpCreacion     IN  VARCHAR2,
                                          Pn_PersonaRolId   IN  NUMBER,
                                          Pn_ZonaId         IN  NUMBER,
                                          Pv_Actividad      IN VARCHAR2,
                                          Pv_Error          OUT VARCHAR2) AS

      --Cursor que obtiene una planificacion existe diferente del estado Activo
      CURSOR C_ExistePlanificacion(Cn_CuadrillaId NUMBER,
                                   Cn_IntervaloId NUMBER,
                                   Cn_ZonaId      NUMBER,
                                   Ct_FeTrabajo   TIMESTAMP,
                                   Cv_Estado      VARCHAR2) IS
        SELECT *
            FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB
        WHERE CUADRILLA_ID = Cn_CuadrillaId
          AND INTERVALO_ID = Cn_IntervaloId
          AND ZONA_ID      = Cn_ZonaId
          AND FE_TRABAJO   = Ct_FeTrabajo
          AND ESTADO       = Cv_Estado;

      Lt_FechaBarrido      TIMESTAMP;
      Lv_Error             VARCHAR2(4000);
      Ln_PlanifCuadrillaId NUMBER;
      Ln_ExisteRegistro    NUMBER;
      Le_MyException       EXCEPTION;
      Lb_ExistePlanif      BOOLEAN;
      Ln_Contador          NUMBER;

  BEGIN

    IF (Pn_CuadrillaId IS NULL OR Pn_IntervaloId IS NULL OR Pt_FechaDesde IS NULL OR Pt_FechaHasta IS NULL OR Pv_EmpresaCod IS NULL
        OR Pv_AsignadoMobile IS NULL OR Pv_UsrCreacion IS NULL OR Pv_IpCreacion IS NULL OR Pn_PersonaRolId IS NULL) THEN
          Pv_Error := 'No se puede enviar parametros nulos';
          RETURN;
    END IF;

    Lt_FechaBarrido := Pt_FechaDesde;

    WHILE (Lt_FechaBarrido <= Pt_FechaHasta) LOOP

      Ln_Contador     := 0;
      Lb_ExistePlanif := FALSE;

      -- Se verifica si existe un registro Activo en la cabecera con los mismos parametros a insertar.
      Ln_ExisteRegistro := DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.F_VALIDA_PLANIF_CUADRILLA(Pn_CuadrillaId,
                                                                                              Pn_IntervaloId,
                                                                                              Pv_EmpresaCod,
                                                                                              Lt_FechaBarrido,
                                                                                              'Activo'); 
      IF (Ln_ExisteRegistro IS NOT NULL AND Ln_ExisteRegistro < 1) THEN

        FOR Planificacion IN C_ExistePlanificacion(Pn_CuadrillaId,Pn_IntervaloId,Pn_ZonaId,Lt_FechaBarrido,'Liberado') LOOP

            Lb_ExistePlanif := TRUE;

            IF Ln_Contador = 0 THEN

                UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB
                    SET ESTADO = 'Activo'
                WHERE ID_CUADRILLA_PLANIF_CAB = Planificacion.ID_CUADRILLA_PLANIF_CAB;

                UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
                    SET ESTADO = 'Activo'
                WHERE CUADRILLA_PLANIF_CAB_ID = Planificacion.ID_CUADRILLA_PLANIF_CAB;

                Ln_PlanifCuadrillaId := Planificacion.ID_CUADRILLA_PLANIF_CAB;

            ELSE

                UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB
                    SET ESTADO = 'Eliminado'
                WHERE ID_CUADRILLA_PLANIF_CAB = Planificacion.ID_CUADRILLA_PLANIF_CAB;

                UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
                    SET ESTADO = 'Eliminado'
                WHERE CUADRILLA_PLANIF_CAB_ID = Planificacion.ID_CUADRILLA_PLANIF_CAB;

            END IF;

            Ln_Contador := 1;

        END LOOP;

        IF NOT Lb_ExistePlanif THEN

            -- Insertamos la cabecera de la planificacion de la cuadrilla
            Ln_PlanifCuadrillaId := DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.F_INSERTA_PLANIF_CUADRILLA_CAB(Pn_CuadrillaId,
                                                                                                            Pn_IntervaloId,
                                                                                                            Pv_EmpresaCod,
                                                                                                            Lt_FechaBarrido,
                                                                                                            Pv_AsignadoMobile,
                                                                                                            Pv_UsrCreacion,
                                                                                                            Pv_IpCreacion,
                                                                                                            Pn_ZonaId,
                                                                                                            Pv_Actividad,
                                                                                                            Lv_Error);
            -- Si el insert de la cabecera da error, terminamos el flujo
            IF (Lv_Error IS NOT NULL OR Ln_PlanifCuadrillaId IS NULL) THEN
              RAISE Le_MyException;
            END IF;

            DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_GENERA_INTERVALO(Ln_PlanifCuadrillaId,
                                                                        Pn_IntervaloId,
                                                                        Lt_FechaBarrido,
                                                                        Pn_PersonaRolId,
                                                                        Pv_UsrCreacion,
                                                                        Pv_IpCreacion,
                                                                        Lv_Error);

            -- Si existe un error, terminamos el flujo
            IF (Lv_Error IS NOT NULL) THEN
              RAISE Le_MyException;
            END IF;

        END IF;

        IF Pv_Error IS NULL THEN
          Pv_Error := '{"estado":"ok","idLista":['||Ln_PlanifCuadrillaId;
        ELSE
          Pv_Error := Pv_Error||','||Ln_PlanifCuadrillaId;
        END IF;

      END IF;

      Lt_FechaBarrido := Lt_FechaBarrido + 1;

    END LOOP;

 -- Confirmamos la transaccion completa
    Pv_Error := Pv_Error || ']}';
    COMMIT;

  EXCEPTION

    WHEN Le_MyException THEN
      ROLLBACK;
      Pv_Error := '{"estado":"fail","mensaje":"'||Lv_Error||'"}';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_SET_PLANIF_CUADRILLA_MANUAL',
                                            Lv_Error,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Error := '{"estado":"fail"}';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_SET_PLANIF_CUADRILLA_MANUAL',
                                           'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_SET_PLANIF_CUADRILLA_MANUAL;

  /* PROCEDURE P_GENERA_INTERVALO */
  PROCEDURE P_GENERA_INTERVALO(Pn_PlanifCuadrillaId IN  NUMBER,
                               Pn_IntervaloId       IN  NUMBER,
                               Pt_FechaRegistro     IN  TIMESTAMP,
                               Pn_PersonaRolId      IN  NUMBER,
                               Pv_UsrCreacion       IN  VARCHAR2,
                               Pv_IpCreacion        IN  VARCHAR2,
                               Pv_Error             OUT VARCHAR2) AS

    /* DECLARACION DE CURSORES */
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion     VARCHAR2) IS
      SELECT DET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
        AND CAB.ESTADO           = 'Activo'
        AND DET.ESTADO           = 'Activo'
        AND CAB.MODULO           = 'SOPORTE'
        AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro
        AND DET.DESCRIPCION      =  Cv_Descripcion;

    CURSOR C_Intervalos (Cn_IntervaloId NUMBER) IS
      SELECT hora_ini, hora_fin
        FROM DB_SOPORTE.ADMI_INTERVALO
      WHERE ID_INTERVALO = Cn_IntervaloId;

    /* VARIABLES LOCALES */
    Lt_FechaBarrido     TIMESTAMP;
    Lv_FechaConvertida  VARCHAR2(20);
    Lv_Intervalo        VARCHAR2(20);
    Le_MyException      EXCEPTION;
    Lv_Error            VARCHAR2(4000);

  BEGIN

    IF C_Parametros%ISOPEN THEN
        CLOSE C_Parametros;
    END IF;

    IF C_Intervalos%ISOPEN THEN
        CLOSE C_Intervalos;
    END IF;

    OPEN C_Parametros('PLANIFICACION_SOPORTE_HAL','GRANULARIDAD_INTERVALO');
      FETCH C_Parametros 
        INTO Lv_Intervalo;
    CLOSE C_Parametros;

    OPEN C_Intervalos(Pn_IntervaloId);
      FETCH C_Intervalos 
        INTO Lt_HoraIni, Lt_HoraFin;
    CLOSE C_Intervalos;        

    Lv_FechaConvertida  := TO_CHAR(Pt_FechaRegistro, 'DD/MM/RRRR') || ' ' || TO_CHAR(Lt_HoraIni, 'HH24:MI:SS');
    Lt_HoraBarrido      := TO_TIMESTAMP(Lv_FechaConvertida, 'DD/MM/RRRR HH24:MI:SS');
    Lv_FechaConvertida  := TO_CHAR(Pt_FechaRegistro, 'DD/MM/RRRR') || ' ' || TO_CHAR(Lt_HoraFin, 'HH24:MI:SS');
    Lt_HoraFin          := TO_TIMESTAMP(Lv_FechaConvertida, 'DD/MM/RRRR HH24:MI:SS');

    -- Si la fecha de inicio es mayor a la fecha fin, Entonces la planificacion es hasta el dia siguiente
    IF Lt_HoraBarrido > Lt_HoraFin THEN
      Lt_HoraFin := Lt_HoraFin + 1;
    END IF;

    WHILE (Lt_HoraBarrido < Lt_HoraFin) LOOP

        Lt_HoraBarridoFin := Lt_HoraBarrido + TO_NUMBER(Lv_Intervalo)/24/60;

        DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_INSERTA_PLANIF_CUADRILLA_DET(Pn_PlanifCuadrillaId,
                                                                                Lt_HoraBarrido,
                                                                                Lt_HoraBarridoFin,
                                                                                Pn_personaRolId,
                                                                                0,
                                                                                0,
                                                                                Pv_UsrCreacion,
                                                                                Pv_IpCreacion,
                                                                                'Manual',
                                                                                Lv_Error);
        
        -- Si el insert del detalle devuelve error, se termina el proceso
        IF (Lv_Error IS NOT NULL) THEN
          RAISE Le_MyException;
        END IF;

        Lt_HoraBarrido:= Lt_HoraBarridoFin;

    END LOOP;
    
  EXCEPTION

    WHEN Le_MyException THEN
      Pv_Error := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_GENERA_INTERVALO',
                                            Lv_Error,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    WHEN OTHERS THEN
     Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_GENERA_INTERVALO - Error: ' || SQLERRM;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                          'P_GENERA_INTERVALO',
                                          'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_GENERA_INTERVALO;

  /* FUNCTION F_VALIDA_PLANIF_CUADRILLA */
  FUNCTION F_VALIDA_PLANIF_CUADRILLA(Pn_CuadrillaId   IN NUMBER,
                                     Pn_IntervaloId   IN NUMBER,
                                     Pv_EmpresaCod    IN VARCHAR2,
                                     Pt_FechaRegistro IN TIMESTAMP,
                                     Pv_Estado        IN VARCHAR2) RETURN NUMBER IS

    /* DECLARACION DE CURSORES*/
    CURSOR C_ExisteCuadrillaInter(Cn_CuadrillaId   NUMBER,
                                  Cn_IntervaloId   NUMBER,
                                  Cv_EmpresaCod    VARCHAR2,
                                  Ct_FechaRegistro TIMESTAMP,
                                  Cv_Estado        VARCHAR2) IS
      SELECT COUNT(*)
      FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB CAB
        WHERE CAB.CUADRILLA_ID = Cn_CuadrillaId
        AND CAB.INTERVALO_ID   = Cn_IntervaloId
        AND CAB.EMPRESA_COD    = Cv_EmpresaCod
        AND CAB.FE_TRABAJO     = Ct_FechaRegistro
        AND CAB.ESTADO         = Cv_Estado;

    /* DECLARACION DE VARIABLES LOCALES */
    Ln_respuesta  NUMBER;

  BEGIN

    IF C_ExisteCuadrillaInter%ISOPEN THEN
      CLOSE C_ExisteCuadrillaInter;
    END IF;

    OPEN C_ExisteCuadrillaInter(Pn_CuadrillaId,
                                Pn_IntervaloId,
                                Pv_EmpresaCod,
                                Pt_FechaRegistro,
                                Pv_Estado);
      FETCH C_ExisteCuadrillaInter 
        INTO Ln_respuesta;
    CLOSE C_ExisteCuadrillaInter;

    RETURN Ln_respuesta;

  EXCEPTION

    WHEN OTHERS THEN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                             'F_VALIDA_PLANIF_CUADRILLA',
                                             'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        RETURN NULL;

  END F_VALIDA_PLANIF_CUADRILLA;

  /* FUNCTION FUNCTION F_INSERTA_PLANIF_CUADRILLA_CAB */
  FUNCTION F_INSERTA_PLANIF_CUADRILLA_CAB(Fn_CuadrillaId    IN  NUMBER,
                                          Fn_IntervaloId    IN  NUMBER,
                                          Fv_EmpresaCod     IN  VARCHAR2,
                                          Ft_FechaTrabajo   IN  TIMESTAMP,
                                          Fv_AsignadoMobile IN  VARCHAR2,
                                          Fv_UsrCreacion    IN  VARCHAR2,
                                          Fv_IpCreacion     IN  VARCHAR2,
                                          Fn_ZonaId         IN  NUMBER,
                                          Fv_Actividad      IN VARCHAR2,
                                          Fv_Error          OUT VARCHAR2) RETURN NUMBER IS

    Ln_CabeceraId NUMBER;

  BEGIN

    Ln_CabeceraId := DB_SOPORTE.SEQ_INFO_CUADRILLA_PLANIF_CAB.NEXTVAL;

    INSERT INTO DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB(
        ID_CUADRILLA_PLANIF_CAB,
        CUADRILLA_ID,
        INTERVALO_ID,
        ZONA_ID,
        EMPRESA_COD,
        FE_TRABAJO,
        ASIGNADO_MOBILE,
        ACTIVIDAD,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION,
        ESTADO
    ) VALUES (
        Ln_CabeceraId,
        Fn_CuadrillaId,
        Fn_IntervaloId,
        Fn_ZonaId,
        Fv_EmpresaCod,
        Ft_FechaTrabajo,
        Fv_AsignadoMobile,
        Fv_Actividad,
        SYSDATE,
        Fv_UsrCreacion,
        Fv_IpCreacion,
       'Activo'
    );
  
    RETURN Ln_CabeceraId;

  EXCEPTION
        WHEN OTHERS THEN
            Fv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.F_INSERTA_PLANIF_CUADRILLA_CAB - Error: ' || SQLERRM;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                                 'F_INSERTA_PLANIF_CUADRILLA_CAB',
                                                 'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
            RETURN NULL;

  END F_INSERTA_PLANIF_CUADRILLA_CAB;

  /* PROCEDURE P_INSERTA_PLANIF_CUADRILLA_DET */
  PROCEDURE P_INSERTA_PLANIF_CUADRILLA_DET(Pn_PlanifCuadrillaId IN NUMBER,
                                           Pt_FechaInicio       IN TIMESTAMP,
                                           Pt_FechaFin          IN TIMESTAMP,
                                           Pn_personaRolId      IN NUMBER,
                                           Pn_Orden             IN NUMBER,
                                           Pn_Locacion          IN NUMBER,
                                           Pv_UsrCreacion       IN VARCHAR2,
                                           Pv_IpCreacion        IN VARCHAR2,
                                           Pv_TipoProceso       IN VARCHAR2,
                                           Pv_Error             OUT VARCHAR2) AS

    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion     VARCHAR2) IS
      SELECT UPPER(DET.VALOR1)
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
        AND CAB.ESTADO           = 'Activo'
        AND DET.ESTADO           = 'Activo'
        AND CAB.MODULO           = 'SOPORTE'
        AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro
        AND DET.DESCRIPCION      =  Cv_Descripcion;

    Ln_IdDetallePlanifCuadrilla NUMBER;
    Lv_MostrarMovil             VARCHAR2(1);

  BEGIN

    IF C_Parametros%ISOPEN THEN
        CLOSE C_Parametros;
    END IF;

    OPEN C_Parametros('PLANIFICACION_SOPORTE_HAL','MOSTRAR_MOVIL');
        FETCH C_Parametros INTO Lv_MostrarMovil;
    CLOSE C_Parametros;

    IF Lv_MostrarMovil NOT IN ('S','N') THEN
        Lv_MostrarMovil := 'S';
    END IF;

    Ln_IdDetallePlanifCuadrilla := DB_SOPORTE.SEQ_INFO_CUADRILLA_PLANIF_DET.NEXTVAL; 

    INSERT INTO DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET (
        ID_CUADRILLA_PLANIF_DET,
        CUADRILLA_PLANIF_CAB_ID,
        FE_INICIO,
        FE_FIN,
        PERSONA_EMPRESA_ROL_ID,
        ORDEN,
        LOCACION,
        DETALLE_SOLICITUD_ID,
        COMUNICACION_ID,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION,
        TIPO_PROCESO,
        VISUALIZAR_MOVIL,
        ESTADO
    ) VALUES (
        Ln_IdDetallePlanifCuadrilla,
        Pn_PlanifCuadrillaId,
        Pt_FechaInicio,
        Pt_FechaFin,
        Pn_personaRolId,
        Pn_Orden,
        Pn_Locacion,
        NULL,
        NULL,
        SYSDATE,
        Pv_UsrCreacion,
        Pv_IpCreacion,
        Pv_TipoProceso,
        Lv_MostrarMovil,
       'Activo'
    );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_INSERTA_PLANIF_CUADRILLA_DET - Error: ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_INSERTA_PLANIF_CUADRILLA_DET',
                                           'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_INSERTA_PLANIF_CUADRILLA_DET;

  -- PROCEDURE P_ASIGNAR_SOLICITUD_TAREA
  PROCEDURE P_ASIGNAR_SOLICITUD_TAREA(Pt_FeInicio    IN  TIMESTAMP,
                                      Pt_FeFin       IN  TIMESTAMP,
                                      Pt_FeIniOrigen IN  TIMESTAMP,
                                      Pt_FeFinOrigen IN  TIMESTAMP,
                                      Pn_IdCuadrilla IN  NUMBER,
                                      Pn_IdSolicitud IN  NUMBER,
                                      Pn_IdTarea     IN  NUMBER,
                                      Pv_Opcion      IN  VARCHAR2,
                                      Pv_User        IN  VARCHAR2,
                                      Pv_Error       OUT VARCHAR2) AS

    /* Cursor que devuelve la planificacion de una cudrilla */
    CURSOR C_PlaniCuadrilla (Cn_IdCuadrilla NUMBER,
                             Ct_FeInicio    TIMESTAMP,
                             Ct_FeFin       TIMESTAMP) IS
      SELECT DET.*
      FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB CAB,
           DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET DET
      WHERE CAB.ID_CUADRILLA_PLANIF_CAB = DET.CUADRILLA_PLANIF_CAB_ID
      AND DET.FE_INICIO                >= Ct_FeInicio
      AND DET.FE_FIN                   <= Ct_FeFin
      AND CAB.CUADRILLA_ID             = Cn_IdCuadrilla
      AND UPPER(CAB.ESTADO)            = 'ACTIVO'
      AND UPPER(DET.ESTADO)            = 'ACTIVO';

    /*Variables a utilizar*/
    Lb_NoExiste                BOOLEAN := TRUE;
    Lc_PlanificacionCuadrilla  C_PlaniCuadrilla%ROWTYPE;
    Le_MyException             EXCEPTION;
    Lv_Error                   VARCHAR2(3000);

  BEGIN

    IF C_PlaniCuadrilla%ISOPEN THEN
      CLOSE C_PlaniCuadrilla;
    END IF;

    IF Pt_FeInicio IS NULL OR Pt_FeFin IS NULL OR Pn_IdCuadrilla IS NULL OR Pv_User IS NULL THEN
      Pv_Error := 'Alguno de estos valores se encuentra nulo: fecha inicio, fecha fin, id de cuadrilla, Usuario).';
      RETURN;
    END IF;

    IF Pn_IdSolicitud IS NULL AND Pn_IdTarea IS NULL THEN
      Pv_Error := 'Valores nulos no permitidos en: id de solicitud y id de tarea.';
      RETURN;
    END IF;

    IF upper(Pv_Opcion) = 'LIMPIAR' THEN

        DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_SET_LIMPIAR_PLANIFICACION(Pn_IdCuadrilla,
                                                                             Pt_FeInicio,
                                                                             Pt_FeFin,
                                                                             Pv_User,
                                                                             Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          RAISE Le_MyException;
        END IF;

    ELSE

      IF Pn_IdSolicitud IS NOT NULL AND Pn_IdTarea IS NOT NULL THEN
        Pv_Error := 'Solo un valor debe ser nulo sea id de solicitud o id de tarea';
        RETURN;
      END IF;

      IF Pt_FeInicio >= Pt_FeFin THEN
        Pv_Error := 'La fecha de inicio no puede ser mayor o igual a la fecha fin.';
        RETURN;
      END IF;

      OPEN C_PlaniCuadrilla(Pn_IdCuadrilla,Pt_FeInicio,Pt_FeFin);
        FETCH C_PlaniCuadrilla
          INTO Lc_PlanificacionCuadrilla;
            Lb_NoExiste := C_PlaniCuadrilla%NOTFOUND;
      CLOSE C_PlaniCuadrilla;

      IF Lb_NoExiste THEN
        Pv_Error := 'No se encontro informacion con los valores enviados.';
        RETURN;
      END IF;

      IF upper(Pv_Opcion) = 'LIMPIARACTUALIZAR' THEN

        UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
          SET COMUNICACION_ID = NULL
        WHERE COMUNICACION_ID = Pn_IdTarea
          AND FE_INICIO >= NVL(Pt_FeIniOrigen,FE_INICIO)
          AND FE_FIN    <= NVL(Pt_FeFinOrigen,FE_FIN);

      END IF;

      FOR I IN C_PlaniCuadrilla(Pn_IdCuadrilla,Pt_FeInicio,Pt_FeFin) LOOP

        DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_SET_PLINIF_CUAD_DET(I.ID_CUADRILLA_PLANIF_DET,
                                                                       NULL,
                                                                       NULL,
                                                                       NULL,
                                                                       NULL,
                                                                       NULL,
                                                                       NULL,
                                                                       Pn_IdSolicitud,
                                                                       Pn_IdTarea,
                                                                       Pv_User,
                                                                       Lv_Error);

        IF Lv_Error IS NOT NULL THEN
          RAISE Le_MyException;
        END IF;

      END LOOP;

    END IF;

    COMMIT;

    Pv_Error := 'ok';

  EXCEPTION

    WHEN Le_MyException THEN

      Pv_Error := Lv_Error;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_ASIGNAR_SOLICITUD_TAREA',
                                           'Error al asginar la solicitud: ' || SQLCODE || ' - ERROR_STACK: '||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    WHEN OTHERS THEN

      ROLLBACK;
      Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_ASIGNAR_SOLICITUD_TAREA - Error: ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_ASIGNAR_SOLICITUD_TAREA',
                                           'Error al asginar la solicitud: ' || SQLCODE || ' - ERROR_STACK: '||
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_ASIGNAR_SOLICITUD_TAREA;

  /* PROCEDURE P_SET_PLINIF_CUAD_DET */
  PROCEDURE P_SET_PLINIF_CUAD_DET(Pn_IdPlanifDet      IN  NUMBER,
                                  Pn_IdPlanifCab      IN  NUMBER,
                                  Pt_Feinicio         IN  TIMESTAMP,
                                  Pt_FeFin            IN  TIMESTAMP,
                                  Pn_IdPersonEmpRol   IN  NUMBER,
                                  Pn_Orden            IN  NUMBER,
                                  Pn_Locacion         IN  NUMBER,
                                  Pn_IdSolicitudDet   IN  NUMBER,
                                  Pn_IdTarea          IN  NUMBER,
                                  Pv_UsrModificacion  IN  VARCHAR2,
                                  Pv_Error            OUT VARCHAR2) AS

  BEGIN

    UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
      SET FE_INICIO             = NVL(Pt_Feinicio,FE_INICIO),
        FE_FIN                  = NVL(Pt_FeFin,FE_FIN),
        PERSONA_EMPRESA_ROL_ID  = NVL(Pn_IdPersonEmpRol,PERSONA_EMPRESA_ROL_ID),
        ORDEN                   = NVL(Pn_Orden,ORDEN),
        LOCACION                = NVL(Pn_Locacion,LOCACION),
        DETALLE_SOLICITUD_ID    = NVL(Pn_IdSolicitudDet,DETALLE_SOLICITUD_ID),
        COMUNICACION_ID         = NVL(Pn_IdTarea,COMUNICACION_ID),
        FE_MODIFICACION         = SYSDATE,
        USR_MODIFICACION        = NVL(Pv_UsrModificacion,USR_MODIFICACION)
    WHERE ID_CUADRILLA_PLANIF_DET = Pn_IdPlanifDet;

  EXCEPTION

    WHEN OTHERS THEN

      Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_SET_PLINIF_CUAD_DET - Error: ' || SQLERRM;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_SET_PLINIF_CUAD_DET',
                                           'Error al actualizar los datos: ' || SQLCODE || ' - ERROR_STACK: '|| 
                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_SET_PLINIF_CUAD_DET;

  --EDICION DE INTERVALOS DE TRABAJO EN PLANIFICACIONES YA EXISTENTES
  PROCEDURE P_GENERA_INTERVALO_POR_ACT(Pn_PlanifCuadrillaId IN  NUMBER,
                                       Pn_HoraInicio        IN  TIMESTAMP,
                                       Pn_HoraFin           IN  TIMESTAMP,
                                       Pt_FechaRegistro     IN  TIMESTAMP,
                                       Pn_PersonaRolId      IN  NUMBER,
                                       Pv_UsrCreacion       IN  VARCHAR2,
                                       Pv_IpCreacion        IN  VARCHAR2,
                                       Pv_TipoProceso       IN  VARCHAR2,
                                       Pv_Error             OUT VARCHAR2) AS

    /* DECLARACION DE CURSORES */
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion     VARCHAR2) IS
      SELECT DET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
        AND CAB.ESTADO           = 'Activo'
        AND DET.ESTADO           = 'Activo'
        AND CAB.MODULO           = 'SOPORTE'
        AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro
        AND DET.DESCRIPCION      =  Cv_Descripcion;

    CURSOR C_CuadrillaPlanif(Cn_CuadrillaPLanifId NUMBER,
                             Ct_HoraIni           TIMESTAMP,
                             Ct_HoraFin           TIMESTAMP) IS
        SELECT det.ID_CUADRILLA_PLANIF_DET,
               det.ESTADO
         FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET det
        WHERE det.CUADRILLA_PLANIF_CAB_ID = Cn_CuadrillaPLanifId
          AND det.FE_INICIO = Ct_HoraIni
          AND det.FE_FIN    = Ct_HoraFin;

    /* VARIABLES LOCALES */
    Lt_FechaBarrido     TIMESTAMP;
    Lt_HoraFin          TIMESTAMP;
    Lv_FechaConvertida  VARCHAR2(20);
    Lv_Intervalo        VARCHAR2(20);
    Le_MyException      EXCEPTION;
    Lv_Error            VARCHAR2(4000);
    Lb_ExistePlanif     BOOLEAN;
    Lc_CuadrillaPlanif  C_CuadrillaPlanif%ROWTYPE;

  BEGIN

    IF C_Parametros%ISOPEN THEN
        CLOSE C_Parametros;
    END IF;

    IF C_CuadrillaPlanif%ISOPEN THEN
        CLOSE C_CuadrillaPlanif;
    END IF;

    OPEN C_Parametros('PLANIFICACION_SOPORTE_HAL','GRANULARIDAD_INTERVALO');
      FETCH C_Parametros 
        INTO Lv_Intervalo;
    CLOSE C_Parametros;      

    Lv_FechaConvertida  := TO_CHAR(Pt_FechaRegistro, 'DD/MM/RRRR') || ' ' || TO_CHAR(Pn_HoraInicio, 'HH24:MI:SS');
    Lt_HoraBarrido      := TO_TIMESTAMP(Lv_FechaConvertida, 'DD/MM/RRRR HH24:MI:SS');
    Lv_FechaConvertida  := TO_CHAR(Pt_FechaRegistro, 'DD/MM/RRRR') || ' ' || TO_CHAR(Pn_HoraFin, 'HH24:MI:SS');
    Lt_HoraFin          := TO_TIMESTAMP(Lv_FechaConvertida, 'DD/MM/RRRR HH24:MI:SS');

    -- Si la fecha de inicio es mayor a la fecha fin, Entonces la planificacion es hasta el dia siguiente
    IF Lt_HoraBarrido > Lt_HoraFin THEN
      Lt_HoraFin := Lt_HoraFin + 1;
    END IF;

    WHILE (Lt_HoraBarrido < Lt_HoraFin) LOOP

        Lt_HoraBarridoFin := Lt_HoraBarrido + TO_NUMBER(Lv_Intervalo)/24/60;

        --Verificamos si el detalle de planificacion ya existe en la base para activarlo
        OPEN C_CuadrillaPlanif(Pn_PlanifCuadrillaId,Lt_HoraBarrido,Lt_HoraBarridoFin);
          FETCH C_CuadrillaPlanif
            INTO Lc_CuadrillaPlanif;
          Lb_ExistePlanif := C_CuadrillaPlanif%FOUND;
        CLOSE C_CuadrillaPlanif;

        IF Lb_ExistePlanif THEN
            IF NOT UPPER(Lc_CuadrillaPlanif.ESTADO) = 'ACTIVO' THEN
                UPDATE INFO_CUADRILLA_PLANIF_DET
                    SET ESTADO           = 'Activo',
                        FE_MODIFICACION  =  SYSDATE,
                        USR_MODIFICACION =  Pv_UsrCreacion,
                        TIPO_PROCESO     =  Pv_TipoProceso
                 WHERE ID_CUADRILLA_PLANIF_DET = Lc_CuadrillaPlanif.ID_CUADRILLA_PLANIF_DET;
            END IF;
        ELSE
            DB_SOPORTE.SPKG_PLANIFICACION_CUADRILLAS.P_INSERTA_PLANIF_CUADRILLA_DET(Pn_PlanifCuadrillaId,
                                                                                    Lt_HoraBarrido,
                                                                                    Lt_HoraBarridoFin,
                                                                                    Pn_personaRolId,
                                                                                    0,
                                                                                    0,
                                                                                    Pv_UsrCreacion,
                                                                                    Pv_IpCreacion,
                                                                                    Pv_TipoProceso,
                                                                                    Lv_Error);

            -- Si el insert del detalle devuelve error, se termina el proceso
            IF (Lv_Error IS NOT NULL) THEN
              RAISE Le_MyException;
            END IF;

        END IF;

        Lt_HoraBarrido:= Lt_HoraBarridoFin;

    END LOOP;

  EXCEPTION

    WHEN Le_MyException THEN
      Pv_Error := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                           'P_GENERA_INTERVALO_POR_ACT',
                                            Lv_Error,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    WHEN OTHERS THEN
     Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_GENERA_INTERVALO_POR_ACT - Error: ' || SQLERRM;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                          'P_GENERA_INTERVALO',
                                          'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_GENERA_INTERVALO_POR_ACT;

  -- PROCEDURE P_SET_LIMPIAR_PLANIFICACION
  PROCEDURE P_SET_LIMPIAR_PLANIFICACION(Pn_IdCuadrilla IN  NUMBER,
                                        Pt_Feinicio    IN  TIMESTAMP,
                                        Pt_FeFin       IN  TIMESTAMP,
                                        Pv_Usuario     IN  VARCHAR2,
                                        Pv_Error       OUT VARCHAR2) IS

  BEGIN

      UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
      SET COMUNICACION_ID  = NULL,
          USR_MODIFICACION = Pv_Usuario,
          FE_MODIFICACION  = SYSDATE
      WHERE FE_INICIO    >= Pt_Feinicio
        AND FE_FIN       <= Pt_FeFin
        AND CUADRILLA_PLANIF_CAB_ID IN
        (SELECT ID_CUADRILLA_PLANIF_CAB
           FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB
          WHERE CUADRILLA_ID = Pn_IdCuadrilla
        );

  EXCEPTION

    WHEN OTHERS THEN

     Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_SET_LIMPIAR_PLANIFICACION - Error: ' || SQLERRM;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                          'P_SET_LIMPIAR_PLANIFICACION',
                                          'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_SET_LIMPIAR_PLANIFICACION;
  --
  --
  PROCEDURE P_UPDATE_VISUALIZAR_MOVIL(Pn_IdComunicacion  IN  NUMBER,
                                      Pv_VisualizarMovil IN  VARCHAR2,
                                      Pv_Usuario         IN  VARCHAR2,
                                      Pv_Ip              IN  VARCHAR2,
                                      Pv_Error           OUT VARCHAR2) IS

    CURSOR C_Planificacion(Cn_IdComunicacion NUMBER) IS
        SELECT COUNT(*)
          FROM DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
         WHERE COMUNICACION_ID = Cn_IdComunicacion
           AND UPPER(ESTADO)   = 'ACTIVO';

    Ln_Cantidad NUMBER;

  BEGIN

    IF C_Planificacion%ISOPEN THEN
        CLOSE C_Planificacion;
    END IF;

    OPEN C_Planificacion(Pn_IdComunicacion);
     FETCH C_Planificacion
        INTO Ln_Cantidad;
    CLOSE C_Planificacion;

    IF Ln_Cantidad < 1 THEN
        Pv_Error := 'No existen valores a actualizar con los parametros ingresados';
        RETURN;
    END IF;

    UPDATE DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET
      SET VISUALIZAR_MOVIL = NVL(UPPER(Pv_VisualizarMovil),VISUALIZAR_MOVIL),
          FE_MODIFICACION  = SYSDATE,
          USR_MODIFICACION = NVL(Pv_Usuario,USR_MODIFICACION),
          IP_MODIFICACION  = NVL(Pv_Ip,IP_MODIFICACION)
    WHERE COMUNICACION_ID  = Pn_IdComunicacion
      AND UPPER(ESTADO)    = 'ACTIVO';

    COMMIT;

    Pv_Error := 'OK';

  EXCEPTION

    WHEN OTHERS THEN

     ROLLBACK;

     Pv_Error := 'Error: SPKG_PLANIFICACION_CUADRILLAS.P_UPDATE_VISUALIZAR_MOVIL - Error: ' || SQLERRM;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_PLANIFICACION_CUADRILLAS',
                                          'P_UPDATE_VISUALIZAR_MOVIL',
                                          'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_UPDATE_VISUALIZAR_MOVIL;

END SPKG_PLANIFICACION_CUADRILLAS;
/