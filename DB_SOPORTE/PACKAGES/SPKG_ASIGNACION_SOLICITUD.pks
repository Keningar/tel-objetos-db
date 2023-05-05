CREATE EDITIONABLE PACKAGE              "SPKG_ASIGNACION_SOLICITUD"
AS
  /**
  * Actualizaci�n: Se agrega validaci�n para nuevos campos en la gestos de Tareas de Agente
  * @author Fernando L�pez <filopez@telconet.ec>
  * @version 1.7 17-01-2022
  * 
  * Actualizaci�n: Se agrega validaci�n para no considerar asignaciones con dependencia.
  * @author Miguel Angulo S�nchez <jmangulos@telconet.ec>
  * @version 1.6 26-06-2019
  *
  * Actualizaci�n: Se corrige el conteo de asignaciones por agente en el d�a, se valida que no 
  *                se repitan por los cambios de turno.
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.5 01-03-2019
  *
  * Actualizaci�n: La fecha de conexi�n se obtiene desde la funci�n: F_GET_FECHA_ESTADO_CONEXION
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.4 22-01-2019
  *
  * Actualizaci�n: Se agrega campo para validar si el orden es por CANTIDAD o por ESTADO_CONEXION
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.3 08-01-2019
  *
  * Actualizaci�n: Se agrega en el SELECT del query principal el campo per.ID_PERSONA_ROL
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.2 23-10-2018
  *
  * Actualizaci�n: Se valida que si no envia parametro de canton entonces que
  * consulte todos los empleados del departamento de todos los cantones
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 03-10-2018
  *
  * Documentacion para procedimiento 'P_GET_INFO_EMPLE_ASIGNACION'
  *
  * Procedimiento que obtiene empleados con asignaciones
  *
  * @param Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Codigo de la empresa
  * @param Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE  Id del departamento
  * @param Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE              Id del canton
  * @param Pv_feCreacion       IN VARCHAR2                                           Fecha de creaci�n de InfoAsignacionSolicitudHist
  * @param Pv_orden            IN VARCHAR2                                           indica como se ordena registros del query
  * @param Pv_MensajeError    OUT VARCHAR2                                           Retorna el mensaje de error en caso de existir
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_INFO_EMPLE_ASIGNACION(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_feCreacion       IN VARCHAR2,
      Pv_orden            IN VARCHAR2,
      Pr_Informacion      OUT SYS_REFCURSOR );

  /** Funci�n que retorna 1 si es asiganaci�n Padre 0 si no lo es
  *
  * @param Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Codigo de la empresa
  * @author Miguel Angulo S�nchez <jmangulos@telconet.ec>
  * @version 1.0 28-06-2019
  */
  FUNCTION F_GET_ES_PADRE(Pn_IdAsignacionPadre IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ASIGNACION_PADRE_ID%TYPE)
     RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se agrega en el Select del query el campo DATO_ADICIONAL
  * @author Andr�s Montero <amontero@telconet.ec>
  * @version 1.1 28-11-2018
  *
  * Documentacion para procedimiento 'P_GET_INFO_ASIGNACION_POR_ID'
  *
  * Procedimiento que obtiene informacion de asignaci�n por id
  *
  * @param Pv_idAsignacion IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE  Id de la asignaci�n
  * @param Pr_Informacion  OUT SYS_REFCURSOR  Retorna el resultado de la consulta
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_INFO_ASIGNACION_POR_ID(
    Pv_idAsignacion       IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE,
    Pr_Informacion OUT SYS_REFCURSOR );



  /**
  *
  * Actualizaci�n: Se agrega validaci�n para que excluya los seguimientos de asignaciones Eliminadas.
  * @author Andr�s Montero <amontero@telconet.ec>
  * @version 1.2 03-04-2019
  *
  * Actualizaci�n: Se agrega par�metro de id de tarea que se usar� para consultar 
  *                directamente la tarea con este id si el tipo de atenci�n es caso
  * @author Andr�s Montero <amontero@telconet.ec>
  * @version 1.1 18-02-2019
  *
  * Documentacion para procedimiento 'P_GET_SEGUIMIENTOS'
  *
  * Procedimiento que obtiene seguimientos de asignaciones
  *
  * @param Pv_idAsignacion     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE   Id de asignaci�n
  * @param Pv_idTarea          IN  DB_SOPORTE.INFO_COMUNICACION.ID_COMUNICACION%TYPE                   Id de la tarea
  * @param Pv_usrCreacion      IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_CREACION%TYPE              Usuario de creaci�n
  * @param Pv_tipo             IN  VARCHAR2                                                            Id del canton
  * @param Pv_feCreacion       IN  VARCHAR2                                                            Fecha de creaci�n
  * @param Pr_Informacion      OUT SYS_REFCURSOR                                                       Retorna el resultado de la consulta
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_SEGUIMIENTOS(
    Pv_idAsignacion IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE,
    Pv_idTarea      IN DB_SOPORTE.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pv_usrCreacion  IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_CREACION%TYPE,
    Pv_feCreacion   IN VARCHAR2,
    Pv_tipo         IN VARCHAR2,
    Pr_Informacion  OUT SYS_REFCURSOR );


  /**
  * Documentacion para procedimiento 'P_GET_ESTADOS_POR_TAREA'
  *
  * Procedimiento que obtiene los estados de la tarea y del caso seg�n el numero de tarea
  *
  * @param Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE   Id de asignaci�n
  * @param Pr_estadoTarea       OUT  VARCHAR2                                      Estado de la tarea
  * @param Pr_estadoCaso        OUT  VARCHAR2                                      Estado del caso
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_ESTADOS_POR_TAREA(
    Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pr_estadoTarea       OUT  VARCHAR2,
    Pr_estadoCaso        OUT  VARCHAR2);

  /**
  * Documentacion para procedimiento 'P_GET_ESTADOS_POR_CASO'
  *
  * Procedimiento que obtiene los estados de la tarea y del caso seg�n el id de caso
  *
  * @param Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE   Id de asignaci�n
  * @param Pr_estadoTarea       OUT  VARCHAR2            Estado de la tarea
  * @param Pr_estadoCaso        OUT  VARCHAR2            Estado del caso
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_ESTADOS_POR_CASO(
    Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
    Pr_estadoTarea       OUT  VARCHAR2,
    Pr_estadoCaso        OUT  VARCHAR2);

  /**
  * Documentacion para procedimiento 'P_GET_SEGUIMIENTOS_PEND_USR'
  *
  * Procedimiento que obtiene seguimientos de asignaciones por usuario
  *
  * @param Pv_usrAsignadoSeg   IN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION.USR_GESTION%TYPE   Usuario de creaci�n del seguimiento
  * @param Pr_Informacion      OUT SYS_REFCURSOR                                            Retorna el resultado de la consulta
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  PROCEDURE P_GET_SEGUIMIENTOS_PEND_USR(
    Pv_usrAsignadoSeg       IN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION.USR_GESTION%TYPE,
    Pr_Informacion OUT SYS_REFCURSOR );

  /**
  *
  * Actualizaci�n: Se agrega excepcion NO_DATA_FOUND para que no se inserte error al no encontrar datos
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 24-10-2018
  *
  * Documentacion para 'F_ESTADO_TAREA_POR_TAREA'
  *
  * Funci�n que obtiene estado de tarea por n�mero de tarea
  *
  * @param Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE n�mero de la tarea a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_ESTADO_TAREA_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se agrega excepcion NO_DATA_FOUND para que no se inserte error al no encontrar datos
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 24-10-2018
  *
  * Documentacion para 'F_ESTADO_CASO_POR_TAREA'
  *
  * Funci�n que obtiene estado del caso por n�mero de tarea
  *
  * @param Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE n�mero de la tarea a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_ESTADO_CASO_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se agrega excepcion NO_DATA_FOUND para que no se inserte error al no encontrar datos
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 24-10-2018
  *
  * Documentacion para 'F_ESTADO_TAREA_POR_CASO'
  *
  * Funci�n que obtiene estado de tarea por id de caso
  *
  * @param Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_ESTADO_TAREA_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se agrega excepcion NO_DATA_FOUND para que no se inserte error al no encontrar datos
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 24-10-2018
  *
  * Documentacion para 'F_ESTADO_CASO_POR_CASO'
  *
  * Funci�n que obtiene estado del caso por id de caso
  *
  * @param Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_ESTADO_CASO_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se elimina las comillas del detalle de seguimiento.
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 15-02-2019
  *
  * Documentacion para 'F_SEGUIMIENTOSJSON_POR_IDASIG'
  *
  * Funci�n que obtiene los seguimientos por id de asignaci�n
  *
  * @param Pv_idAsignacion DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE id de la asignaci�n
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_SEGUIMIENTOSJSON_POR_IDASIG(Pv_idAsignacion DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE)
      RETURN VARCHAR2;

  /**
  *
  * Actualizaci�n: Se agrega excepcion NO_DATA_FOUND para que no se inserte error al no encontrar datos
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 24-10-2018
  *
  * Documentacion para 'F_NUMERO_TAREA_POR_CASO'
  *
  * Funci�n que obtiene numero de tarea por id de caso
  *
  * @param Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_NUMERO_TAREA_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN NUMBER;

  /**
  * Documentacion para 'F_NUMERO_CASO_POR_TAREA'
  *
  * Funci�n que obtiene numero de caso por id de tarea
  *
  * @param Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE id de tarea a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 22-08-2018
  */
  FUNCTION F_NUMERO_CASO_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2;

  /**
  * Documentacion para 'F_GET_DATOS_TAREA'
  *
  * Funci�n que obtiene datos de la tarea
  *
  * @param Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE id de tarea a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 28-11-2018
  */
  FUNCTION F_GET_DATOS_TAREA(
    Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pv_tipo        VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentacion para 'F_GET_AFECTADOS_POR_CASO'
  *
  * Funci�n que obtiene los afectados por caso
  *
  * @param Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE id del caso a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 28-11-2018
  */
  FUNCTION F_GET_AFECTADOS_POR_CASO(
    Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
    RETURN VARCHAR2;

  /**
  * Actualizaci�n: Se mejora query por la obtenci�n de m�ltiples Login.
  * @author Miguel Angulo S <jmangulos@telconet.ec>
  * @version 1.3 26-07-2019
  *
  * Actualizaci�n: Se mejora el query para obtener el afectado para las tareas
  * @author Miguel Angulo S <amontero@telconet.ec>
  * @version 1.2 09-05-2019
  *
  * Actualizaci�n: Se mejora el query para obtener el afectado para las tareas
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 02-01-2019
  *
  *
  * Documentacion para 'F_GET_AFECTADOS_POR_TAREA'
  *
  * Funci�n que obtiene datos de la tarea
  *
  * @param Pv_idTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE id de tarea a consultar
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 28-11-2018
  */
  FUNCTION F_GET_AFECTADOS_POR_TAREA(
    Pv_idTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
    RETURN VARCHAR2;

  /**
  * Actualizaci�n: Se agrega parametro Pv_TipoConsulta para validar que campo se desea obtener VALOR o FE_ULT_MOD
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 08-01-2019
  *
  * Documentacion para 'F_GET_CARACTERISTICA_EMPLEADO'
  *
  * Funci�n que obtiene caracteristica del empleado
  *
  * @param Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_EMPRESA_ROL%TYPE id persona empresa rol a consultar
  * @param Pv_descCaracteristica  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE  descripci�n de la caracter�stica
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 03-12-2018
  */
  FUNCTION F_GET_CARACTERISTICA_EMPLEADO(
    Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Pv_descCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_TipoConsulta VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentacion para 'F_GET_FECHA_ESTADO_CONEXION'
  *
  * Funci�n que obtiene �ltima fecha de conexi�n del agente
  *
  * @param Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_EMPRESA_ROL%TYPE id persona empresa rol a consultar
  * @return TIMESTAMP
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 21-01-2019
  */
  FUNCTION F_GET_FECHA_ESTADO_CONEXION(
    Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN TIMESTAMP;


/**
  * Actualizaci�n: Se agrega validaci�n para no considerar asignaciones con dependencia.
  * @author Miguel Angulo S�nchez <jmangulos@telconet.ec>
  * @version 1.3 26-06-2019
  *
  * Actualizaci�n: Se reduce el tama�o de la cadena que obtiene por medio de LISTAGG las asignaciones por agente
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.2 02-01-2019
  *
  * Actualizaci�n: Se elimina caracteres especiales en el login de las asignaciones
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 28-12-2018
  * Documentacion para 'F_GET_REGISTROS_ASIGNACIONES'
  *
  * Funci�n que obtiene las asignaciones por login de empleado
  *
  * @param Pv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE - Id de la empresa
  * @param Pv_UsrAsignado DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE - Usuario asignado
  * @param Pv_FeCreacion  VARCHAR2 - Fecha de creaci�n de las asignaciones
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 04-12-2018
  */
  FUNCTION F_GET_REGISTROS_ASIGNACIONES(
    Pv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_UsrAsignado DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE,
    Pv_FeCreacion  VARCHAR2)
    RETURN VARCHAR2;
/**
  *
  * Actualizaci�n: Se agrega nuevo par�metro Pv_Estado para consultar las asignaciones por estado
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.3 22-05-2020
  *
  * Actualizaci�n: Se valida que si par�metro Pv_cantonId es NULL entonces excluye consultar por Cant�n
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.2 05-02-2019
  *
  * Actualizaci�n: Se agrega nuevo parametro de Pv_cantonId para consultar las asignaciones por canton
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 15-01-2019
  *
  * Documentacion para 'P_GET_ASIGNACIONES_TOTALIZADAS'
  *
  * Procedimiento que obtiene totalizado principal de asignaciones
  *
  * @param Pv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  - Id de la empresa
  * @param Pv_DepartamentoId DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE - id del departamento
  * @param Pv_CantonId       DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE - id del canton
  * @param Pv_FeCreacionIni  VARCHAR2 - fecha Inicio
  * @param Pv_FeCreacionFin  VARCHAR2 - fecha Fin
  * @param Pv_TotalizadoPor  VARCHAR2 - campo de group by
  * @param Pr_Informacion    SYS_REFCURSOR - que retorna el resultado
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 05-12-2018
  */
PROCEDURE P_GET_ASIGNACIONES_TOTALIZADAS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pv_TotalizadoPor    IN VARCHAR2,
      Pr_Informacion OUT SYS_REFCURSOR );

/**
  *
  * Actualizaci�n: Se valida que si par�metro Pv_cantonId es NULL entonces excluye consultar por Cant�n
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 05-02-2019
  *
  * Documentacion para 'F_GET_LISTAGG_ASIGTOTALIZADAS'
  *
  * Funci�n que obtiene totalizado de asignaciones
  *
  * @param Pv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  - Id de la empresa
  * @param Pv_DepartamentoId DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE - id del departamento
  * @param Pv_FeCreacionIni  VARCHAR2 - fecha Inicio
  * @param Pv_FeCreacionFin  VARCHAR2 - fecha Fin
  * @param Pv_TotalizadoPor  VARCHAR2 - campo de group by
  * @param Pv_FiltroQuery    VARCHAR2 - campo para filtrar el query o subquery
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 05-12-2018
  */
  FUNCTION F_GET_LISTAGG_ASIGTOTALIZADAS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pv_TotalizadoPor    IN VARCHAR2,
      Pv_FiltroQuery      IN VARCHAR2)
    RETURN VARCHAR2;

/**
  *
  * Actualizaci�n: Se corrige query para que no se muestre error de columna ambigua 
  *                cuando se envia idCanton por par�metro
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 13-03-2019
  *
  * Actualizaci�n: Se agrega en el query principal las asignaciones abiertas del d�a
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.1 06-03-2019
  *
  * Documentacion para 'P_GET_ASIGNACIONES_TOT_ESTADO'
  *
  * Procedimiento que obtiene totalizado por estado de la asignaci�n
  *
  * @param Pv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  - Id de la empresa
  * @param Pv_DepartamentoId DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE - id del departamento
  * @param Pv_CantonId       DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE - id del canton
  * @param Pr_Informacion    SYS_REFCURSOR - que retorna el resultado
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 07-02-2019
  */
  PROCEDURE P_GET_ASIGNACIONES_TOT_ESTADO(
        Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
        Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
        Pr_Informacion OUT SYS_REFCURSOR );

/**
  * Documentacion para 'P_REPORTE_ASIGNACIONES_PEND'
  *
  * Funci�n que genera reporte de asignaciones pendientes y envia por correo a los remitentes
  * que esten configurados en admi_parametro_det
  *
  * @param pv_cod_empresa     NUMBER   - Id de la empresa
  * @param pn_departamento_id NUMBER   - id del departamento
  * @param pn_canton_id       VARCHAR2 - fecha Inicio
  * @return VARCHAR2
  *
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 25-01-2019
  */
  PROCEDURE P_REPORTE_ASIGNACIONES_PEND(pv_cod_empresa     IN  VARCHAR2,
                                        pn_departamento_id IN  NUMBER,
                                        pn_canton_id       IN  NUMBER,
                                        pv_mensaje_error   OUT VARCHAR2);

  /**
    * Documentacion para 'P_ASIGNACIONES_PENDIENTES'
    *
    * Procedimiento que obtiene las asignaciones pendientes por departamento
    *
    * @param pv_cod_empresa     NUMBER   - Id de la empresa
    * @param pn_departamento_id NUMBER   - id del departamento
    * @param pn_canton_id       VARCHAR2 - fecha Inicio
    * @param Pr_Informacion     SYS_REFCURSOR - refcursor con los registros de las asignaciones
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 29-01-2019
    */
  PROCEDURE P_ASIGNACIONES_PENDIENTES (
                        pv_cod_empresa IN  VARCHAR2,
                        pn_departamento_id IN  NUMBER,
                        pn_canton_id IN  NUMBER,
                        Pr_Informacion OUT SYS_REFCURSOR);

  /**
    * Documentacion para 'F_INFO_TAREAS_POR_CASO'
    *
    * Funci�n que obtiene las asignaciones pendientes por departamento
    *
    * @param pv_idCaso     NUMBER   - Id del caso
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 14-02-2019
    */
  FUNCTION F_INFO_TAREAS_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
    RETURN VARCHAR2;

  /**
    * Documentacion para 'P_GET_ULTIMO_AGENTE_ASIGNADO'
    *
    * Procedimiento que obtiene el �ltimo agente asignado seg�n parametros recibidos
    *
    * @param Pv_cod_empresa     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD          - Id de la empresa
    * @param Pn_departamento_id IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE - Id del departamento
    * @param Pn_canton_id       IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.CANTON_ID%TYPE            - Id de la oficina
    * @param Pv_ultimoAsignado  OUT VARCHAR2
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 20-02-2019
    */
  PROCEDURE P_GET_ULTIMO_AGENTE_ASIGNADO(
    Pv_codEmpresa     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
    Pn_departamentoId IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
    Pn_cantonId       IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.CANTON_ID%TYPE,
    Pv_ultimoAsignado OUT VARCHAR2);

  /**
    * Actualizaci�n: Se a�adieron parametros y campos nuevos para la gesti�n de las tareas.
    *
    * @author Fernando L�pez <filopez@telconet.ec>
    * @version 1.2 17-01-2022
    * 
    * Actualizaci�n: Se a�adieron campos adicionales en consulta para departamento de sistemas.
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.1 09-07-2021
    *
    * Documentacion para 'P_GET_TAREAS_DEPARTAMENTO'
    *
    * Procedimiento que obtiene del departamento que se recibe por parametro
    *
    * @param Pn_departamento_id IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE - Id del departamento
    * @param Pv_cod_empresa     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD          - Id de la empresa
    * @param Pv_Informacion     OUT SYS_REFCURSOR
    * @param Pv_PermiteVerCamposTareas     IN VARCHAR2          - bandera para nuevos campos
    * @param Pv_FechaIni        IN VARCHAR2                     - fecha inicial de consulta
    * @param Pv_FechaFin        IN VARCHAR2                     - fecha final de consulta
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 21-02-2019
    */
  PROCEDURE P_GET_TAREAS_DEPARTAMENTO(
    Pv_departamentoId IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
    Pv_empresaCod     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
    Pr_Informacion    OUT SYS_REFCURSOR,
    Pv_PermiteVerCamposTareas  IN VARCHAR2 DEFAULT 'N',
    Pv_FechaIni  IN VARCHAR2 DEFAULT '',
    Pv_FechaFin  IN VARCHAR2 DEFAULT '');

  /**
    * Documentacion para 'P_GET_TOP_LOGINS'
    *
    * Procedimiento que obtiene el top de los logins con mas tareas y casos
    *
    * @param Pv_EmpresaCod     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD          - Id de la empresa
    * @param Pn_DepartamentoId IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE - Id del departamento
    * @param Pn_CantonId       IN  DB_COMERCIAL.CANTON_ID%TYPE                               - Id del canton
    * @param Pv_FeCreacionIni  IN  VARCHAR2                                                  - Fecha de incio de la consulta
    * @param Pn_DepartamentoId IN  VARCHAR2                                                  - Fecha de fin de la consulta
    * @param Pv_Informacion    OUT SYS_REFCURSOR
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 21-02-2019
    */
  PROCEDURE P_GET_TOP_LOGINS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pn_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pr_Informacion OUT SYS_REFCURSOR );

  /**
    * Documentacion para 'P_GET_REGISTROS_CONEXION'
    *
    * Procedimiento que obtiene listado de conexiones de un usuario seg�n idPersonaEmpresaRol enviado por parametro
    *
    * @param Pn_PersonaEmpresaRolId IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE - Id persona empresa rol del usuario
    * @param Pn_Mes                 IN  NUMBER                                                    - mes de consulta
    * @param Pn_Anio                IN  NUMBER                                                    - anio de consulta
    * @param Pr_Informacion         OUT SYS_REFCURSOR
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 17-03-2020
    */
    PROCEDURE P_GET_REGISTROS_CONEXION(
          Pn_PersonaEmpresaRolId     IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
          Pn_Mes                     IN  NUMBER,
          Pn_Anio                    IN  NUMBER,
          Pr_Informacion             OUT SYS_REFCURSOR );
  /**
    * Documentacion para 'P_GET_TOT_ASIGNACIONES_SIN_NUM'
    *
    * Procedimiento que obtiene el total de asignaciones que no contienen n�mero de caso o tarea
    *
    * @param Pv_idDepartamento IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE - Id del departamento
    * @param Pv_codEmpresa     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD          - Id de la empresa
    * @param Pn_idCanton       IN  DB_COMERCIAL.CANTON_ID%TYPE                               - Id del canton
    * @param Pv_usrAsignado    IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE    - Usuario asignado
    * @param Pn_total          OUT NUMBER
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 13-03-2020
    */
    PROCEDURE P_GET_TOT_ASIGNACIONES_SIN_NUM(
        Pv_idDepartamento DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
        Pv_codEmpresa     DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
        Pv_idCanton       DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
        Pv_usrAsignado    DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE,
        Pn_total          OUT  NUMBER);

  /**
    * Documentacion para 'P_ENVIAR_STANDBY_A_CAMB_TURNO'
    *
    * Procedimiento que envia asignaciones de standby a cambio de turno
    *
    * @param pv_mensaje_respuesta OUT VARCHAR2
    *
    * @author Andr�s Montero H <amontero@telconet.ec>
    * @version 1.0 15-05-2020
    */
    PROCEDURE P_ENVIAR_STANDBY_A_CAMB_TURNO(pv_mensaje_respuesta OUT VARCHAR2);

    /**
    * Documentacion para 'GET_TRAZABILIDAD_TAREAS_USR'
    *
    * Funci�n que obtiene trazabilidad(usuario y departamento) de tareas
    *
    * @param Pn_IdDetalle     NUMBER   - Id del detalle
    *
    * @author Pedro Velez Q <psvelez@telconet.ec>
    * @version 1.0 12-07-2021
    */
  FUNCTION GET_TRAZABILIDAD_TAREAS_USR (Pn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
    RETURN VARCHAR2;
   
    /**
    * Documentacion para 'F_GET_FECHA_CREACION_TAREA'
    *
    * Funci�n que obtiene la fecha de creaci�n de tarea
    *
    * @param Pn_IdDetalle     NUMBER   - Id del detalle
    * @param Pn_VecesIniciada NUMBER   - numerp de veces que ha sido iniciada una tarea
    *
    * @author Fernando L�pez <filopez@telconet.ec>
    * @version 1.0 14-01-2022
    */
   
  FUNCTION F_GET_FECHA_CREACION_TAREA (Pn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE, Pn_VecesIniciada NUMBER)
  	RETURN VARCHAR2;

END SPKG_ASIGNACION_SOLICITUD;
/

CREATE EDITIONABLE PACKAGE BODY              "SPKG_ASIGNACION_SOLICITUD"
AS
  --
  PROCEDURE P_GET_INFO_EMPLE_ASIGNACION(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_feCreacion       IN VARCHAR2,
      Pv_orden            IN VARCHAR2,
      Pr_Informacion      OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Lv_criterioFecha        VARCHAR2(300);
    Ln_Resultado            NUMBER;
    Lv_FechaConsulta        VARCHAR2(10);
    Lv_orderBy              VARCHAR2(100);
    --
    --
    Lv_anio     NUMBER;
    Lv_mes      NUMBER;
    --
  BEGIN
    --
      Lv_anio          := EXTRACT(YEAR FROM SYSDATE);
      Lv_mes           := EXTRACT(MONTH FROM SYSDATE);
      Lv_criterioFecha := '';
      Lv_FechaConsulta := TO_CHAR(SYSDATE,'YYYY/MM/DD');
      --
      IF Pv_feCreacion IS NOT NULL THEN
          Lv_criterioFecha := ' '||q'[  AND TO_CHAR(asignacionh.FE_CREACION,'YYYY/MM/DD')= :Pv_feCreacion ]'||' ';
          Lv_FechaConsulta := Pv_feCreacion;
      END IF;
      --
      --Valida orden de resultados del query
      IF Pv_orden = 'CANTIDAD' THEN
          Lv_orderBy := ' ORDER BY CANTIDAD DESC';
      ELSIF Pv_orden = 'ESTADO_CONEXION' OR Pv_orden IS NULL THEN
          Lv_orderBy := ' ORDER BY ORDEN ASC, FECHA ASC ';
      ELSE
          Lv_orderBy := ' ORDER BY CANTIDAD DESC';
      END IF;
      --
      Lv_Query   := 'SELECT ' ||
                      'iper.ID_PERSONA_ROL,'||
                      'persona.LOGIN,'||
                      'persona.NOMBRES NOMBRES,'||
                      'persona.APELLIDOS APELLIDOS,'||
                      'persona.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,'||
                      'canton.NOMBRE_CANTON,'||
                      'NVL(asig.CANTIDAD,0) CANTIDAD, '||
                      q'[ SPKG_ASIGNACION_SOLICITUD.F_GET_CARACTERISTICA_EMPLEADO(iper.ID_PERSONA_ROL,]'||
                      q'[ 'ESTADO CONEXION MODULO ASIGNACIONES','VALOR')]'||
                      ' ESTADO_CONEXION, '||
                      ' SPKG_ASIGNACION_SOLICITUD.F_GET_FECHA_ESTADO_CONEXION(iper.ID_PERSONA_ROL) FECHA, '||
                      q'[ SPKG_ASIGNACION_SOLICITUD.F_GET_CARACTERISTICA_EMPLEADO(iper.ID_PERSONA_ROL,'EXTENSION USUARIO','VALOR') EXTENSION, ]'||
                      q'[ SPKG_ASIGNACION_SOLICITUD.F_GET_REGISTROS_ASIGNACIONES(ier.EMPRESA_COD,persona.LOGIN,']'||
                         Lv_FechaConsulta||q'[') ASIGNACIONES ]'||
                    'FROM '||
                      'DB_COMERCIAL.info_persona persona '||
                      'JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON persona.ID_PERSONA = iper.PERSONA_ID '||
                      'JOIN DB_GENERAL.ADMI_DEPARTAMENTO dep ON iper.DEPARTAMENTO_ID = dep.ID_DEPARTAMENTO '||
                      'JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL '||
                      'JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO oficina ON iper.OFICINA_ID = oficina.ID_OFICINA '||
                      'JOIN DB_GENERAL.ADMI_CANTON canton ON oficina.CANTON_ID = canton.ID_CANTON '||
                      'LEFT JOIN (SELECT ASIGN.USR_ASIGNADO, COUNT(*) CANTIDAD FROM '||
                      '  ( '||
                      '    SELECT asignacionh.* '||
                      '    FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD_HIST asignacionh '||
                      '    JOIN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asignacion '||
                      '        ON asignacion.ID_ASIGNACION_SOLICITUD = asignacionh.ASIGNACION_SOLICITUD_ID '||
                      '    WHERE '||
                      q'[    asignacionh.ESTADO <> 'Eliminado'  ]'||
                      q'[ AND  asignacion.ESTADO <> 'Eliminado'  ]'||
                      '   AND asignacion.ASIGNACION_PADRE_ID IS NULL '||
                      '   AND  asignacion.EMPRESA_COD = :Pv_empresaCod '|| 
                          Lv_criterioFecha ||
                      '  ) ASIGN '||
                      '  WHERE ASIGN.FE_CREACION = ' ||
                      '                          ( ' ||
                      '                            SELECT MAX(FE_CREACION) FROM INFO_ASIGNACION_SOLICITUD_HIST asignacionh1'||
                      '                            WHERE asignacionh1.ASIGNACION_SOLICITUD_ID = ASIGN.ASIGNACION_SOLICITUD_ID '||
                      q'[                            AND asignacionh1.ESTADO <> 'Eliminado' ]'||
                      '                          ) '||
                      '  GROUP BY ASIGN.USR_ASIGNADO '||
                      '  ORDER BY CANTIDAD DESC '||
                      '  ) asig ON asig.USR_ASIGNADO = persona.LOGIN '||
                    'WHERE '||
                      'ier.EMPRESA_COD = :Pv_empresaCod '||
                      'and dep.ID_DEPARTAMENTO = :Pv_departamentoId '||
                      'and iper.estado = :Pv_estado '
                   ;
      IF (Pv_CantonId IS NOT NULL) THEN
          Lv_Query := Lv_Query || ' and canton.ID_CANTON = :Pv_cantonId ';
      END IF;
      Lv_Query := 'SELECT D.ID_PERSONA_ROL, '||
                  '       D.LOGIN, '||
                  '       D.NOMBRES, '||
                  '       D.APELLIDOS, ' ||
                  '       D.IDENTIFICACION_CLIENTE, ' ||
                  '       D.NOMBRE_CANTON, ' ||
                  '       D.CANTIDAD, ' ||
                  '       D.ESTADO_CONEXION, ' ||
                  '       D.EXTENSION, ' ||
                  '       D.ASIGNACIONES, '||
                  q'[     D.FECHA FE_ESTADO_CONEXION, ]'||
                  q'[     CASE WHEN D.ESTADO_CONEXION = 'Disponible' THEN 'A' ]'||
                  q'[          WHEN D.ESTADO_CONEXION = 'Almuerzo'   THEN 'A' ]'||
                  q'[          WHEN D.ESTADO_CONEXION = 'Ocupado'    THEN 'B' ]'||
                  q'[          WHEN D.ESTADO_CONEXION = 'Ausente'    THEN 'C' ]'||
                  q'[          ELSE 'D' END ORDEN ]'||
                  ' FROM '||
                  '('||
                  Lv_Query ||
                  ') D '
                  ;
      Lv_Query := Lv_Query || Lv_orderBy;

      --
      -- COSTO QUERY: 78
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_empresaCod',   Pv_EmpresaCod);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_departamentoId', Pv_DepartamentoId);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado', 'Activo');
      --
      IF (Pv_CantonId IS NOT NULL) THEN
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_cantonId', Pv_CantonId);
      END IF;

      IF Pv_feCreacion IS NOT NULL THEN
                DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacion', Pv_feCreacion);
      END IF;
      --
      --
      Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_INFO_EMPLE_ASIGNACION',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_INFO_EMPLE_ASIGNACION;

  FUNCTION F_GET_ES_PADRE(Pn_IdAsignacionPadre IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ASIGNACION_PADRE_ID%TYPE)
     RETURN VARCHAR2
 IS
      Ln_consulta     NUMBER := 0;
     Le_Exception     EXCEPTION;
     Lv_camp_retorna  VARCHAR2(1) := 'N';
     Lv_MensajeError  VARCHAR2(4000);
  BEGIN
  
         SELECT count(*) INTO Ln_consulta
           FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD
          WHERE ASIGNACION_PADRE_ID = Pn_IdAsignacionPadre;
      
        IF (Ln_consulta > 0 ) THEN
            Lv_camp_retorna := 'S';
        ELSE
            Lv_camp_retorna := 'N';
        END IF;
      
  RETURN Lv_camp_retorna;
  
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.F_GET_ES_PADRE',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END F_GET_ES_PADRE;


  PROCEDURE P_GET_INFO_ASIGNACION_POR_ID(
    Pv_idAsignacion       IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE,
    Pr_Informacion OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    --
    --
    --Lv_anio     NUMBER;
    --Lv_mes      NUMBER;
    --
  BEGIN
    --
      Lv_Query   := 'SELECT ' ||
                      'asig.ID_ASIGNACION_SOLICITUD,'||
                      q'[TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
                      'asig.REFERENCIA_CLIENTE,'||
                      'asig.USR_ASIGNADO,'||
                      'asig.TIPO_ATENCION,'||
                      'asig.TIPO_PROBLEMA,'||
                      'asig.REFERENCIA_ID,'||
                      'asig.CRITICIDAD,'||
                      'asig.DETALLE,'||
                      'asig.NOMBRE_REPORTA,'||
                      'asig.NOMBRE_SITIO,'||
                      'asig.ORIGEN,'||
                      'asig.ESTADO, '||
                      'asig.DATO_ADICIONAL, '||
                      q'[ CASE WHEN (asig.TIPO_ATENCION = 'TAREA' AND asig.REFERENCIA_ID IS NOT NULL) THEN asig.REFERENCIA_ID ]'||
                      q'[     WHEN (asig.TIPO_ATENCION = 'CASO' AND asig.REFERENCIA_ID IS NOT NULL) ]'||
                      '   THEN (SELECT DISTINCT caso.NUMERO_CASO FROM DB_COMUNICACION.INFO_CASO caso '||
                      '          WHERE caso.ID_CASO = asig.REFERENCIA_ID) ELSE NULL END NUMERO,'||
                      q'[CASE WHEN asig.TIPO_ATENCION = 'TAREA' THEN ]'||
                      ' asig.REFERENCIA_ID '||
                      q'[ WHEN asig.TIPO_ATENCION = 'CASO' THEN ]'||
                      ' TO_CHAR(SPKG_ASIGNACION_SOLICITUD.F_NUMERO_TAREA_POR_CASO(asig.REFERENCIA_ID)) '||
                      ' END NUMERO_TAREA,'||
                      q'[CASE WHEN asig.TIPO_ATENCION = 'TAREA' THEN ]'||
                      ' SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(asig.REFERENCIA_ID) '||
                      q'[ WHEN asig.TIPO_ATENCION = 'CASO' THEN ]'||
                      ' SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_CASO(asig.REFERENCIA_ID) '||
                      ' END ESTADO_TAREA,'||
                      q'[ CASE WHEN asig.TIPO_ATENCION = 'TAREA' THEN ]'||
                      ' NULL '||
                      q'[ WHEN asig.TIPO_ATENCION = 'CASO' THEN ]'||
                      ' SPKG_ASIGNACION_SOLICITUD.F_INFO_TAREAS_POR_CASO(asig.REFERENCIA_ID) '||
                      ' END INFO_TAREAS,'||
                      q'[ CASE WHEN asig.TIPO_ATENCION = 'TAREA' THEN ]'||
                      ' SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_TAREA(asig.REFERENCIA_ID) '||
                      q'[ WHEN asig.TIPO_ATENCION = 'CASO' THEN ]'||
                      ' SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO(asig.REFERENCIA_ID) '||
                         ' END ESTADO_CASO '||
                    'FROM '||
                      'DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig '||
                    'WHERE '||
                      'asig.ID_ASIGNACION_SOLICITUD = :Pv_idAsignacion '||
                      'and asig.estado <> :Pv_estadoAsig '
                   ;
      -- COSTO QUERY: 78
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_idAsignacion',   Pv_idAsignacion);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estadoAsig', 'Eliminado');
      --
      --
      Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_INFO_ASIGNACION_POR_ID',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_INFO_ASIGNACION_POR_ID;


  PROCEDURE P_GET_ESTADOS_POR_TAREA(
    Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pr_estadoTarea       OUT  VARCHAR2,
    Pr_estadoCaso        OUT  VARCHAR2)
  IS
    --
    Ln_IdCursor          NUMBER;
    Pv_Informacion       SYS_REFCURSOR;
    Ln_NumeroRegistros   NUMBER;
    Lv_Query             CLOB;
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    Ln_Resultado         NUMBER;
    Lc_Informacion       SPKG_TYPES.Lr_EstadosCasoTarea;
    --
  BEGIN
    --
    Pr_estadoTarea:= SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(Pv_numeroTarea);
    Pr_estadoCaso := SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_TAREA(Pv_numeroTarea);
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_ESTADOS_POR_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_ESTADOS_POR_TAREA;


  PROCEDURE P_GET_ESTADOS_POR_CASO(
    Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
    Pr_estadoTarea       OUT  VARCHAR2,
    Pr_estadoCaso        OUT  VARCHAR2)
  IS
    --
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    --
  BEGIN
    --
    Pr_estadoTarea:= SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_CASO(Pv_idCaso);
    Pr_estadoCaso := SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO(Pv_idCaso);
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_ESTADOS_POR_CASO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_ESTADOS_POR_CASO;

  FUNCTION F_ESTADO_TAREA_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(16);
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
        --COSTO QUERY: 3
        SELECT idh1.ESTADO INTO Lv_campo_retorna
        FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1
        WHERE
        ID_DETALLE_HISTORIAL =
        (
            SELECT MAX(id_detalle_historial)
            FROM DB_COMUNICACION.INFO_COMUNICACION com
            JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL idh ON idh.DETALLE_ID = com.DETALLE_ID
            WHERE com.ID_COMUNICACION = Pv_numeroTarea
        );
        --
    RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
        Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || 'ID_TAREA:'|| Pv_numeroTarea;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA',
                                              Lv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                              '127.0.0.1')
                                            );
        RETURN Lv_campo_retorna;
    --
  END F_ESTADO_TAREA_POR_TAREA;

  FUNCTION F_ESTADO_CASO_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
        RETURN VARCHAR2
    IS
        Lv_campo_retorna VARCHAR2(16);
        Lv_MensajeError  VARCHAR2(4000);
    BEGIN
        Lv_campo_retorna := '';
        --COSTO QUERY: 3
        SELECT casoh1.ESTADO INTO Lv_campo_retorna
        FROM
            DB_SOPORTE.INFO_CASO_HISTORIAL casoh1
        WHERE
            casoh1.ID_CASO_HISTORIAL =
            (
                SELECT MAX(casoh.ID_CASO_HISTORIAL)
                FROM DB_COMUNICACION.INFO_COMUNICACION com
                JOIN DB_SOPORTE.INFO_DETALLE idet ON idet.ID_DETALLE = com.DETALLE_ID
                JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS ideth ON ideth.ID_DETALLE_HIPOTESIS = idet.DETALLE_HIPOTESIS_ID
                JOIN DB_SOPORTE.INFO_CASO_HISTORIAL casoh ON casoh.CASO_ID = ideth.CASO_ID
                WHERE com.ID_COMUNICACION= Pv_numeroTarea
            );
      --
    --
    RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
        Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || ' idTarea:' || Pv_numeroTarea;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_TAREA',
                                              Lv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                              '127.0.0.1')
                                            );
        RETURN Lv_campo_retorna;
    --
  END F_ESTADO_CASO_POR_TAREA;


  FUNCTION F_ESTADO_TAREA_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(16);
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
        --COSTO QUERY: 3
        SELECT idhis1.ESTADO INTO Lv_campo_retorna
        FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idhis1
        WHERE
        idhis1.ID_DETALLE_HISTORIAL =
        (
            SELECT max(idhis.ID_DETALLE_HISTORIAL)
            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idhis
            WHERE idhis.DETALLE_ID =
            (
                SELECT
                min(idet.ID_DETALLE)
                FROM DB_SOPORTE.INFO_CASO caso
                JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS ideth ON ideth.CASO_ID = caso.ID_CASO
                JOIN DB_SOPORTE.INFO_DETALLE idet ON idet.DETALLE_HIPOTESIS_ID = ideth.ID_DETALLE_HIPOTESIS
                WHERE caso.ID_CASO = Pv_idCaso
                AND idet.TAREA_ID IS NOT NULL
            )
        );
        --
        --
        RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
        Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_CASO',
                                              Lv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                              '127.0.0.1')
                                            );

        RETURN Lv_campo_retorna;
    --
  END F_ESTADO_TAREA_POR_CASO;



  FUNCTION F_ESTADO_CASO_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(16);
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
      --COSTO QUERY: 3
    SELECT casoh1.ESTADO INTO Lv_campo_retorna
    FROM DB_SOPORTE.INFO_CASO_HISTORIAL casoh1
    WHERE
    casoh1.ID_CASO_HISTORIAL =
    (
        SELECT MAX(casoh.ID_CASO_HISTORIAL)
        FROM DB_SOPORTE.INFO_CASO caso
        JOIN DB_SOPORTE.INFO_CASO_HISTORIAL casoh ON casoh.CASO_ID = caso.ID_CASO
        WHERE ID_CASO = Pv_idCaso
    );
    --
    --
    RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );

      RETURN Lv_campo_retorna;
    --
  END F_ESTADO_CASO_POR_CASO;


  FUNCTION F_SEGUIMIENTOSJSON_POR_IDASIG(Pv_idAsignacion DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(4000);
      Le_Exception     EXCEPTION;
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
      SELECT '['||SEGUIMIENTOS||']'INTO Lv_campo_retorna FROM (
      SELECT LISTAGG('{"ID_SEGUIMIENTO_ASIGNACION":"'||SEG.ID_SEGUIMIENTO_ASIGNACION||'",'
                    ||'"DETALLE":"'||REPLACE(SEG.DETALLE,'"','')||'",'
                    ||'"USR_CREACION":"'||SEG.USR_CREACION||'",'
                    ||'"FE_CREACION":"'||SEG.FE_CREACION||'",'
                    ||'"USR_GESTION":"'||SEG.USR_GESTION||'",'
                    ||'"GESTIONADO":"'||SEG.GESTIONADO||'",'
                    ||'"HIJOS":['||(
                      SELECT LISTAGG('{"ID_SEGUIMIENTO_ASIGNACION":"'||SEG1.ID_SEGUIMIENTO_ASIGNACION||'",'
                                    ||'"DETALLE":"'||REPLACE(SEG1.DETALLE,'"','')||'",'
                                    ||'"USR_CREACION":"'||SEG1.USR_CREACION||'",'
                                    ||'"FE_CREACION":"'||SEG1.FE_CREACION||'",'
                                    ||'"USR_GESTION":"'||SEG1.USR_GESTION||'",'
                                    ||'"GESTIONADO":"'||SEG1.GESTIONADO
                      ||'"}',' ,')WITHIN GROUP (ORDER BY SEG1.FE_CREACION DESC)
                      FROM DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION SEG1 WHERE SEG1.SEGUIMIENTO_ASIGNACION_ID = SEG.ID_SEGUIMIENTO_ASIGNACION
                    )
                    ||']}', ' ,') WITHIN GROUP (ORDER BY SEG.FE_CREACION DESC) AS SEGUIMIENTOS
      FROM
      (
        SELECT SEGI.* FROM DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION SEGI
        WHERE SEGI.ASIGNACION_SOLICITUD_ID = Pv_idAsignacion
        AND SEGI.ESTADO = 'Activo'
        AND SEGI.SEGUIMIENTO_ASIGNACION_ID IS NULL
        ORDER BY SEGI.FE_CREACION DESC
      ) SEG
      WHERE
      rownum <= 3
      )
      ;
    --
    RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
    Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.F_SEGUIMIENTOSJSON_POR_IDASIG',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );

    RETURN Lv_campo_retorna;
    --

  END F_SEGUIMIENTOSJSON_POR_IDASIG;


  FUNCTION F_NUMERO_TAREA_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN NUMBER
    IS
      Lv_campo_retorna NUMBER;
      Le_Exception     EXCEPTION;
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
      --COSTO QUERY: 3

          SELECT com.ID_COMUNICACION INTO Lv_campo_retorna
          FROM DB_COMUNICACION.INFO_COMUNICACION com
          WHERE com.DETALLE_ID =
          (
              SELECT
              min(idet.ID_DETALLE)
              FROM DB_SOPORTE.INFO_CASO caso
              JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS ideth ON ideth.CASO_ID = caso.ID_CASO
              JOIN DB_SOPORTE.INFO_DETALLE idet ON idet.DETALLE_HIPOTESIS_ID = ideth.ID_DETALLE_HIPOTESIS
              WHERE caso.ID_CASO = Pv_idCaso
              AND idet.TAREA_ID IS NOT NULL
          );
      --
  RETURN Lv_campo_retorna;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.F_NUMERO_TAREA_POR_CASO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
    RETURN Lv_campo_retorna;
    --
  END F_NUMERO_TAREA_POR_CASO;


  FUNCTION F_NUMERO_CASO_POR_TAREA(Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(16);
      Le_Exception     EXCEPTION;
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
      Lv_campo_retorna := '';
      --COSTO QUERY: 3
      SELECT caso.NUMERO_CASO INTO Lv_campo_retorna
        FROM DB_SOPORTE.INFO_CASO_HISTORIAL casoh1
        JOIN  DB_SOPORTE.INFO_CASO caso ON caso.ID_CASO = casoh1.CASO_ID
      WHERE
        casoh1.ID_CASO_HISTORIAL =
        (
          SELECT MAX(casoh.ID_CASO_HISTORIAL)
          FROM DB_COMUNICACION.INFO_COMUNICACION com
          JOIN DB_SOPORTE.INFO_DETALLE idet ON idet.ID_DETALLE = com.DETALLE_ID
          JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS ideth ON ideth.ID_DETALLE_HIPOTESIS = idet.DETALLE_HIPOTESIS_ID
          JOIN DB_SOPORTE.INFO_CASO_HISTORIAL casoh ON casoh.CASO_ID = ideth.CASO_ID
          WHERE com.ID_COMUNICACION= Pv_numeroTarea
        );
      --
    --
    RETURN Lv_campo_retorna;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
    Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.F_NUMERO_CASO_POR_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );

    RETURN Lv_campo_retorna;
    --
  END F_NUMERO_CASO_POR_TAREA;


  PROCEDURE P_GET_SEGUIMIENTOS(
    Pv_idAsignacion IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ID_ASIGNACION_SOLICITUD%TYPE,
    Pv_idTarea      IN DB_SOPORTE.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pv_usrCreacion  IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_CREACION%TYPE,
    Pv_feCreacion   IN VARCHAR2,
    Pv_tipo         IN VARCHAR2,
    Pr_Informacion  OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    Ln_idTareaCaso          NUMBER;
    Lv_tipoAtencion         DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.TIPO_ATENCION%TYPE;
    Ln_idTarea              NUMBER;
    Ln_referenciaId         NUMBER;
    --
  BEGIN

  IF Pv_tipo = 'POR_ASIGNACION' THEN


    SELECT asig.REFERENCIA_ID, asig.TIPO_ATENCION  INTO Ln_idTareaCaso, Lv_tipoAtencion
    FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig WHERE ID_ASIGNACION_SOLICITUD = Pv_idAsignacion;
    --
    IF Lv_tipoAtencion = 'TAREA' AND Ln_idTareaCaso IS NOT NULL THEN
      Ln_idTarea      := Ln_idTareaCaso;
      Ln_referenciaId := Ln_idTareaCaso;
    ELSIF Lv_tipoAtencion = 'CASO' AND Ln_idTareaCaso IS NOT NULL THEN
      IF Pv_idTarea IS NOT NULL AND Pv_idTarea > 0 THEN
        Ln_idTarea := Pv_idTarea;
      ELSE
        --Busca tarea segun caso
        Ln_idTarea := F_NUMERO_TAREA_POR_CASO(Ln_idTareaCaso);
      END IF;
      Ln_referenciaId := Ln_idTareaCaso;
    END IF;

    IF Ln_idTarea IS NOT NULL THEN
      -- COSTO QUERY: 21
      Lv_Query   :=
      'SELECT '||
      'DETALLE, '||
      'ID_SEGUIMIENTO_ASIGNACION, '||
      'USR_CREACION, '||
      q'[ TO_CHAR(FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
      'PREFIJO, '||
      'NOMBRE_DEPARTAMENTO, '||
      'TIPO '||
      'FROM '||
      '((SELECT seg.ID_SEGUIMIENTO ID_SEGUIMIENTO_ASIGNACION, '||
             'CAST(seg.OBSERVACION AS VARCHAR2(3999)) DETALLE, '||
             'seg.USR_CREACION, '||
             'seg.FE_CREACION, '||
             'emp.PREFIJO,'||
             'dep.NOMBRE_DEPARTAMENTO,'||
            q'[ 'Externo' TIPO,]'||
             '('||
             '  SELECT COUNT(*) ' ||
             '  FROM DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION seg1 '||
             '  JOIN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig1 ON asig1.ID_ASIGNACION_SOLICITUD = seg1.ASIGNACION_SOLICITUD_ID '||
             '   WHERE CAST(seg.OBSERVACION AS VARCHAR2(3999)) = seg1.DETALLE AND seg.USR_CREACION = seg1.USR_CREACION '||
             q'[ AND seg1.estado ='Activo' AND asig1.REFERENCIA_ID = :Pv_referenciaId ]'||
             ' ) REPETIDO '||
             ' FROM DB_COMUNICACION.INFO_COMUNICACION com '||
             ' JOIN DB_SOPORTE.INFO_DETALLE det ON det.ID_DETALLE = com.DETALLE_ID '||
             ' JOIN DB_SOPORTE.INFO_TAREA_SEGUIMIENTO seg ON seg.DETALLE_ID = det.ID_DETALLE '||
             ' JOIN DB_GENERAL.ADMI_DEPARTAMENTO dep ON dep.ID_DEPARTAMENTO = seg.DEPARTAMENTO_ID '||
             ' JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO emp ON emp.COD_EMPRESA = seg.EMPRESA_COD '||
             ' WHERE '||
             ' com.ID_COMUNICACION = :Pv_idTarea '||
      ') '||
      ' UNION '||
      '( '||
            'SELECT '||
            'sega.ID_SEGUIMIENTO_ASIGNACION, '||
            'sega.DETALLE, '||
            'sega.USR_CREACION, '||
            'sega.FE_CREACION, '||
            'empa.PREFIJO, '||
            'depa.NOMBRE_DEPARTAMENTO,'||
            'sega.PROCEDENCIA TIPO,'||
            '0 REPETIDO '||
            'FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig '||
            'JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sega ON sega.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD '||
            'JOIN DB_GENERAL.ADMI_DEPARTAMENTO depa ON depa.ID_DEPARTAMENTO = asig.DEPARTAMENTO_ID '||
            'JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO empa ON empa.COD_EMPRESA = asig.EMPRESA_COD '||
            'WHERE asig.REFERENCIA_ID = :Pv_referenciaId '||
            q'[AND asig.ESTADO <> 'Eliminado' ]' ||
            q'[AND sega.ESTADO = 'Activo' ]' ||
      ') '||
      ') SEGUIMIENTOS '||
      'WHERE '||
      'SEGUIMIENTOS.REPETIDO = 0 '||
      'ORDER BY FE_CREACION DESC'
      ;
    ELSE
      -- COSTO QUERY: 8
      Lv_Query   :=
            'SELECT '||
            'sega.ID_SEGUIMIENTO_ASIGNACION, '||
            'sega.DETALLE, '||
            'sega.USR_CREACION, '||
            q'[ TO_CHAR(sega.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
            'empa.PREFIJO, '||
            'depa.NOMBRE_DEPARTAMENTO,'||
            'sega.PROCEDENCIA TIPO '||
            'FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig '||
            'JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sega ON sega.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD '||
            'JOIN DB_GENERAL.ADMI_DEPARTAMENTO depa ON depa.ID_DEPARTAMENTO = asig.DEPARTAMENTO_ID '||
            'JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO empa ON empa.COD_EMPRESA = asig.EMPRESA_COD '||
            'WHERE asig.ID_ASIGNACION_SOLICITUD = :Pv_Asignacion '||
            q'[AND sega.ESTADO = 'Activo' ]' ||
            'ORDER BY FE_CREACION DESC'
            ;

    END IF;

  ELSIF Pv_tipo = 'POR_USUARIO' THEN
    -- COSTO QUERY: 9
    Lv_Query   :=
            'SELECT '||
            'sega.ID_SEGUIMIENTO_ASIGNACION, '||
            'sega.DETALLE, '||
            'sega.USR_CREACION, '||
            q'[ TO_CHAR(sega.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
            'empa.PREFIJO, '||
            'depa.NOMBRE_DEPARTAMENTO,'||
            'sega.PROCEDENCIA TIPO, '||
            'asig.TIPO_ATENCION, '||
            q'[ CASE WHEN (asig.TIPO_ATENCION = 'TAREA' AND asig.REFERENCIA_ID IS NOT NULL) THEN asig.REFERENCIA_ID ]'||
            q'[     WHEN (asig.TIPO_ATENCION = 'CASO' AND asig.REFERENCIA_ID IS NOT NULL) ]'||
            '   THEN (SELECT DISTINCT caso.NUMERO_CASO FROM DB_COMUNICACION.INFO_CASO caso '||
            '          WHERE caso.ID_CASO = asig.REFERENCIA_ID) ELSE NULL END NUMERO, '||
            'asig.REFERENCIA_CLIENTE '||
            'FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig '||
            'JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sega ON sega.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD '||
            'JOIN DB_GENERAL.ADMI_DEPARTAMENTO depa ON depa.ID_DEPARTAMENTO = asig.DEPARTAMENTO_ID '||
            'JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO empa ON empa.COD_EMPRESA = asig.EMPRESA_COD '||
            'WHERE sega.USR_CREACION = :Pv_usrCreacion '||
            q'[AND TO_CHAR(sega.FE_CREACION,'YYYY/MM/DD') = :Pv_feCreacion ]'||
            q'[AND sega.ESTADO = 'Activo' ]' ||
            'ORDER BY sega.FE_CREACION DESC'
            ;

  END IF;

  --
  Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
  --
  DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);

  IF Pv_tipo = 'POR_ASIGNACION' THEN
    IF Ln_idTarea IS NOT NULL THEN
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_idTarea', Ln_idTarea);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_referenciaId', Ln_referenciaId);
    ELSE
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Asignacion',  Pv_idAsignacion );
    END IF;
  ELSIF Pv_tipo = 'POR_USUARIO' THEN
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_usrCreacion',  Pv_usrCreacion );
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacion',  Pv_feCreacion );
  END IF;
  --
  --
  Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
  Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
  --
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_SEGUIMIENTOS',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_SEGUIMIENTOS;


  PROCEDURE P_GET_SEGUIMIENTOS_PEND_USR(
    Pv_usrAsignadoSeg       IN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION.USR_GESTION%TYPE,
    Pr_Informacion OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    --
  BEGIN

      -- COSTO QUERY: 8
      Lv_Query   :=
            'SELECT '||
            'sega.ID_SEGUIMIENTO_ASIGNACION, '||
            'asig.REFERENCIA_CLIENTE, '||
            'asig.TIPO_ATENCION, '||
            q'[ CASE WHEN (asig.TIPO_ATENCION = 'TAREA' AND asig.REFERENCIA_ID IS NOT NULL) THEN asig.REFERENCIA_ID ]'||
            q'[     WHEN (asig.TIPO_ATENCION = 'CASO' AND asig.REFERENCIA_ID IS NOT NULL) ]'||
            '   THEN (SELECT DISTINCT caso.NUMERO_CASO FROM DB_COMUNICACION.INFO_CASO caso '||
            '          WHERE caso.ID_CASO = asig.REFERENCIA_ID) ELSE NULL END NUMERO,'||
            'sega.DETALLE, '||
            'sega.USR_GESTION, '||
            q'[ TO_CHAR(sega.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
            'sega.PROCEDENCIA TIPO '||
            'FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig '||
            'JOIN DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION sega ON sega.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD '||
            'WHERE sega.USR_GESTION = :Pv_usrAsignadoSeg '||
            q'[AND sega.GESTIONADO = 'N' ]' ||
            q'[AND sega.ESTADO = 'Activo' ]' ||
            'ORDER BY sega.FE_CREACION DESC'
            ;

    --
    Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
    DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_usrAsignadoSeg',  Pv_usrAsignadoSeg );

    --
    --
    Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
    Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_SEGUIMIENTOS_PEND_USR',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_SEGUIMIENTOS_PEND_USR;

  FUNCTION F_GET_DATOS_TAREA(
    Pv_numeroTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pv_tipo        VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    Ln_AsignadoId        DB_SOPORTE.Info_Detalle_Asignacion.ASIGNADO_ID%TYPE;
    Lv_AsignadoNombre    DB_SOPORTE.Info_Detalle_Asignacion.ASIGNADO_NOMBRE%TYPE;
    Ln_RefAsignadoId     DB_SOPORTE.Info_Detalle_Asignacion.REF_ASIGNADO_ID%TYPE;
    Lv_RefAsignadoNombre DB_SOPORTE.Info_Detalle_Asignacion.REF_ASIGNADO_NOMBRE%TYPE;
    Ln_Resultado         VARCHAR2(200);

    --
  BEGIN
    --
    Ln_Resultado := '';
    --
    IF Pv_numeroTarea IS NOT NULL THEN
      --
      --COSTO QUERY:16
      SELECT
      da.asignado_Id,
      da.asignado_Nombre,
      da.ref_Asignado_Id,
      da.ref_Asignado_Nombre
      INTO
        Ln_AsignadoId,
        Lv_AsignadoNombre,
        Ln_RefAsignadoId,
        Lv_RefAsignadoNombre

      FROM Info_Detalle d,
        Info_Detalle_Asignacion da,
        Info_Detalle_Historial dh,
        Admi_Tarea t ,
        Info_Comunicacion icom
      WHERE d.id_detalle   = da.detalle_Id
        AND d.id_detalle     = dh.detalle_Id
        AND t.id_tarea     = d.tarea_Id
        AND da.ID_DETALLE_ASIGNACION =
        (SELECT MAX(daMax.ID_DETALLE_ASIGNACION)
           FROM Info_Detalle_Asignacion daMax
           WHERE daMax.detalle_Id = da.detalle_Id
        )
        AND dh.ID_DETALLE_HISTORIAL =
        (SELECT MAX(dhMax.ID_DETALLE_HISTORIAL)
          FROM Info_Detalle_Historial dhMax
          WHERE dhMax.detalle_Id = dh.detalle_Id
        )
        AND icom.detalle_Id = d.id_DETALLE
        AND icom.id_COMUNICACION  = Pv_numeroTarea;
    --

      IF Pv_tipo = 'asignado' AND Lv_AsignadoNombre IS NOT NULL THEN
        Ln_Resultado := Lv_AsignadoNombre;
      ELSIF Pv_tipo = 'refasignado' AND Lv_RefAsignadoNombre IS NOT NULL THEN
        Ln_Resultado := Lv_RefAsignadoNombre;
      ELSIF Pv_tipo = 'telefonorefasignado' AND Ln_RefAsignadoId IS NOT NULL THEN
        SELECT VALOR INTO Ln_Resultado
        FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PF1 WHERE PF1.ID_PERSONA_FORMA_CONTACTO = 
        (
          SELECT MAX(ID_PERSONA_FORMA_CONTACTO)
          FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PF
          JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO F ON F.ID_FORMA_CONTACTO = PF.FORMA_CONTACTO_ID
          WHERE PF.PERSONA_ID = Ln_RefAsignadoId 
          AND PF.ESTADO = 'Activo' 
          AND F.DESCRIPCION_FORMA_CONTACTO LIKE 'Telefono%'
        );
      END IF;
    END IF;
  RETURN Ln_Resultado;
  --
  --
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN '';
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  --
  END F_GET_DATOS_TAREA;


  FUNCTION F_GET_AFECTADOS_POR_CASO(
    Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_Afectado     DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE;
    Lv_Resultado    VARCHAR2(200);

    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_idCaso IS NOT NULL THEN
      --
      --COSTO QUERY: 19
      SELECT
        pa.afectado_Nombre
        INTO
        Lv_Afectado
      FROM
			    Info_Parte_Afectada pa,
			    Info_Criterio_Afectado ca,
			    Info_Detalle de,
			    Info_Detalle_Hipotesis dh,
			    Info_Caso c
      WHERE
        pa.criterio_Afectado_Id = ca.ID_CRITERIO_AFECTADO
        AND ca.detalle_Id = de.id_detalle
        AND pa.detalle_Id = ca.detalle_Id
        AND pa.detalle_Id = de.id_detalle
        AND de.detalle_Hipotesis_Id = dh.id_detalle_hipotesis
        AND dh.caso_Id = c.id_caso
        AND pa.TIPO_AFECTADO = 'Cliente'
        AND c.id_caso = Pv_idCaso
        AND (dh.sintoma_Id is not null or (dh.hipotesis_Id is not null and dh.sintoma_Id is null))
        AND ROWNUM = 1;
    --
        Lv_Resultado := Lv_Afectado;
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
                                        'SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_CASO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  --
  END F_GET_AFECTADOS_POR_CASO;


  FUNCTION F_GET_AFECTADOS_POR_TAREA(
    Pv_idTarea DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_Afectado     VARCHAR2(150);
    Lv_Resultado    VARCHAR2(200);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_idTarea IS NOT NULL THEN
      --
      --COSTO QUERY: 3
      --
        SELECT CASE 
              WHEN EXISTS ( SELECT IPA.AFECTADO_ID
                              FROM DB_COMUNICACION.INFO_COMUNICACION IC,
                                   DB_SOPORTE.INFO_PARTE_AFECTADA IPA
                             WHERE IC.ID_COMUNICACION = COM.ID_COMUNICACION
                               AND IC.DETALLE_ID = IPA.DETALLE_ID)
                              THEN ( SELECT MAX(IP.LOGIN)
                                       FROM DB_COMUNICACION.INFO_COMUNICACION IC
                                       JOIN DB_SOPORTE.INFO_PARTE_AFECTADA IPA ON IC.DETALLE_ID = IPA.DETALLE_ID
                                       JOIN DB_SOPORTE.INFO_PUNTO IP ON IPA.AFECTADO_ID = IP.ID_PUNTO
                                      WHERE IC.ID_COMUNICACION = COM.ID_COMUNICACION)
              WHEN EXISTS (SELECT LOGIN FROM DB_SOPORTE.INFO_PUNTO WHERE ID_PUNTO = COM.PUNTO_ID) 
              THEN (SELECT LOGIN FROM DB_SOPORTE.INFO_PUNTO WHERE ID_PUNTO = COM.PUNTO_ID)  
              ELSE 
                DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_CASO(COM.CASO_ID)
              END AS PUNTO_AFECTADO INTO Lv_Afectado
          FROM DB_COMUNICACION.INFO_COMUNICACION COM 
         WHERE COM.ID_COMUNICACION = Pv_idTarea;
      --
      Lv_Resultado := Lv_Afectado;
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
                                        'SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  --
  END F_GET_AFECTADOS_POR_TAREA;

  FUNCTION F_GET_CARACTERISTICA_EMPLEADO(
    Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Pv_descCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_TipoConsulta VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_valor        VARCHAR2(150);
    Lv_Resultado    VARCHAR2(200);
    Lv_detalleId    NUMBER;
    Lv_Query        VARCHAR2(1000);
    Lv_Campo        VARCHAR2(200) := 'PERC.VALOR';
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_idPersonaEmpresaRol IS NOT NULL THEN

      IF Pv_TipoConsulta = 'FECHA' THEN
        Lv_Campo := ' CASE WHEN PERC.FE_ULT_MOD IS NOT NULL THEN PERC.FE_ULT_MOD ELSE PERC.FE_CREACION END ';
      END IF;
      --
      --COSTO QUERY: 6
      Lv_Query :=
      'SELECT '||
      Lv_Campo ||
      ' FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER '||
      '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PERC ON PER.ID_PERSONA_ROL = PERC.PERSONA_EMPRESA_ROL_ID '||
      '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON CARAC.ID_CARACTERISTICA = PERC.CARACTERISTICA_ID '||
      ' WHERE PER.ID_PERSONA_ROL = '||Pv_idPersonaEmpresaRol ||
      q'[  AND PERC.ESTADO = 'Activo' ]'||
      q'[ AND CARAC.DESCRIPCION_CARACTERISTICA = ']'||Pv_descCaracteristica||q'[']';
    --
    EXECUTE IMMEDIATE Lv_Query INTO Lv_valor;
        Lv_Resultado := Lv_valor;
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
                                            'F_GET_CARACTERISTICA_EMPLEADO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_CARACTERISTICA_EMPLEADO;


FUNCTION F_GET_FECHA_ESTADO_CONEXION(
    Pv_idPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN TIMESTAMP
  IS
    --
    Le_Exception    EXCEPTION;
    Lv_MensajeError VARCHAR2(4000);
    Lv_valor        TIMESTAMP;
    Lv_Resultado    TIMESTAMP;
    Lv_Query        VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_idPersonaEmpresaRol IS NOT NULL THEN
      --
      --COSTO QUERY: 6
      Lv_Query :=
      'SELECT '||
      ' CASE WHEN PERC.FE_ULT_MOD IS NOT NULL THEN PERC.FE_ULT_MOD ELSE PERC.FE_CREACION END '||
      ' FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER '||
      '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PERC ON PER.ID_PERSONA_ROL = PERC.PERSONA_EMPRESA_ROL_ID '||
      '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON CARAC.ID_CARACTERISTICA = PERC.CARACTERISTICA_ID '||
      ' WHERE PER.ID_PERSONA_ROL = '||Pv_idPersonaEmpresaRol ||
      q'[  AND PERC.ESTADO = 'Activo' ]'||
      q'[ AND CARAC.DESCRIPCION_CARACTERISTICA = 'ESTADO CONEXION MODULO ASIGNACIONES']';
    --
    EXECUTE IMMEDIATE Lv_Query INTO Lv_valor;
        Lv_Resultado := Lv_valor;
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
                                            'F_GET_FECHA_ESTADO_CONEXION',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_FECHA_ESTADO_CONEXION;


  FUNCTION F_GET_REGISTROS_ASIGNACIONES(
    Pv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_UsrAsignado DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE,
    Pv_FeCreacion  VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    Le_Exception       EXCEPTION;
    Lv_EstadoEliminado VARCHAR2(100);
    Lv_MensajeError    VARCHAR2(4000);
    Lv_valor           VARCHAR2(4000);
    Lv_Resultado       VARCHAR2(4000);


    --
  BEGIN
    --
    Lv_Resultado       := '';
    Lv_EstadoEliminado := 'Eliminado';
    --
    IF Pv_EmpresaCod IS NOT NULL AND Pv_UsrAsignado IS NOT NULL AND Pv_FeCreacion IS NOT NULL THEN
        --
        --COSTO QUERY: 5
        SELECT '['||ASIGNACIONES||']' INTO Lv_valor
        FROM
        (
          SELECT LISTAGG(
            '{"USR":"'||ASIGUSR.USR_ASIGNADO||'",'||
            '"TIPO":"'||ASIGUSR.TIPO||'",'||
            '"PIN":"'||ASIGUSR.PIN||'",'||
            '"TATENC":"'||ASIGUSR.TIPO_ATENCION||'",'||
            '"ESTADO":"'||ASIGUSR.ESTADO||'",'||
            '"FECHA":"'||ASIGUSR.FE_CREACION||'",'||
            '"NUM":"'||ASIGUSR.NUMERO||'",'||
            '"ORD":"'||ASIGUSR.ORDEN||'",'||
            '"REFCLI":"'||SPKG_UTILIDADES.GET_VARCHAR_CLEAN(ASIGUSR.REFERENCIA_CLIENTE)||'",'||
            '"ETAREA":"'||ASIGUSR.ESTADO_TAREA||'",'||
            '"ECASO":"'||ASIGUSR.ESTADO_CASO||'",'||
            '"LOGINA":"'||ASIGUSR.AFECTADO||'"'||
                          '}', ' ,'
          )
          WITHIN GROUP(ORDER BY ASIGUSR.ORDEN ASC) AS ASIGNACIONES
          FROM
          (
            SELECT
                USR_ASIGNADO,
                TIPO,
                PIN,
                TIPO_ATENCION,
                ESTADO,
                FE_CREACION,
                NUMERO,
                ORDEN,
                REFERENCIA_ID,
                REFERENCIA_CLIENTE,
                ESTADO_TAREA,
                ESTADO_CASO,
                AFECTADO
            FROM
              (SELECT USR_ASIGNADO,
                TIPO,
                PIN,
                TIPO_ATENCION,
                ESTADO,
                FE_CREACION,
                NUMERO,
                CASE
                  WHEN ESTADO = 'Pendiente'
                    THEN 'A'
                  WHEN ESTADO = 'EnGestion' AND TIPO_ATENCION = 'TAREA' AND ESTADO_TAREA <> 'Finalizada' AND TIPO = 'REASIGNACION'
                    THEN 'B'
                  WHEN ESTADO = 'EnGestion' AND TIPO_ATENCION = 'CASO' AND ESTADO_CASO  <> 'Cerrado' AND TIPO = 'REASIGNACION'
                    THEN 'B'
                  WHEN ESTADO = 'EnGestion' AND TIPO_ATENCION = 'TAREA' AND ESTADO_TAREA <> 'Finalizada' AND TIPO = 'ASIGNACION'
                    THEN 'C'
                  WHEN ESTADO = 'EnGestion' AND TIPO_ATENCION = 'CASO' AND ESTADO_CASO  <> 'Cerrado' AND TIPO = 'ASIGNACION'
                    THEN 'C'
                  ELSE 'D'
                END AS ORDEN,
                REFERENCIA_ID,
                REFERENCIA_CLIENTE,
                ESTADO_TAREA,
                ESTADO_CASO,
                AFECTADO
              FROM
              (
                SELECT asigh.USR_ASIGNADO,
                  asigh.TIPO,
                  CASE
                    WHEN asigh.TIPO = 'ASIGNACION'
                    AND (SELECT COUNT(*)
                        FROM INFO_ASIGNACION_SOLICITUD_HIST asigh1 WHERE asigh1.asignacion_solicitud_id = asig.ID_ASIGNACION_SOLICITUD) > 1
                      THEN'PIN1'
                    WHEN asigh.TIPO = 'REASIGNACION'
                    AND (SELECT MIN(asigh1.ID_ASIGNACION_SOLICITUD_HIST)
                          FROM INFO_ASIGNACION_SOLICITUD_HIST asigh1
                          WHERE asigh1.asignacion_solicitud_id = asig.ID_ASIGNACION_SOLICITUD
                          AND asigh1.TIPO = 'REASIGNACION' ) = asigh.ID_ASIGNACION_SOLICITUD_HIST
                    AND (SELECT COUNT(*)
                          FROM INFO_ASIGNACION_SOLICITUD_HIST asigh1
                          WHERE asigh1.asignacion_solicitud_id = asig.ID_ASIGNACION_SOLICITUD
                          AND asigh1.TIPO                      = 'REASIGNACION' ) > 1
                      THEN 'PIN2'
                    ELSE 'NO_PIN'
                  END AS PIN,
                  asig.TIPO_ATENCION,
                  asig.ESTADO,
                  asig.REFERENCIA_ID,
                  asig.REFERENCIA_CLIENTE,
                  TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') AS FE_CREACION,
                  CASE
                    WHEN (asig.TIPO_ATENCION = 'TAREA' AND asig.REFERENCIA_ID  IS NOT NULL)
                    THEN asig.REFERENCIA_ID
                    WHEN (asig.TIPO_ATENCION = 'CASO' AND asig.REFERENCIA_ID  IS NOT NULL)
                    THEN
                      (SELECT DISTINCT caso.NUMERO_CASO FROM DB_COMUNICACION.INFO_CASO caso WHERE caso.ID_CASO = asig.REFERENCIA_ID)
                    ELSE NULL
                  END AS NUMERO,
                  CASE
                    WHEN asig.TIPO_ATENCION = 'TAREA'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(asig.REFERENCIA_ID)
                    WHEN asig.TIPO_ATENCION = 'CASO'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_CASO(asig.REFERENCIA_ID)
                  END AS ESTADO_TAREA,
                  CASE
                    WHEN asig.TIPO_ATENCION = 'TAREA'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_TAREA(asig.REFERENCIA_ID)
                    WHEN asig.TIPO_ATENCION = 'CASO'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO(asig.REFERENCIA_ID)
                  END AS ESTADO_CASO,
                  CASE
                    WHEN asig.TIPO_ATENCION = 'TAREA'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_TAREA(asig.REFERENCIA_ID)
                    WHEN asig.TIPO_ATENCION = 'CASO'
                    THEN SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_CASO(asig.REFERENCIA_ID)
                  END AS AFECTADO
                FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig
                JOIN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD_HIST asigh
                ON asigh.ASIGNACION_SOLICITUD_ID            = asig.ID_ASIGNACION_SOLICITUD
                WHERE asig.EMPRESA_COD                      = Pv_EmpresaCod
                AND asig.ESTADO                            <> Lv_EstadoEliminado
                AND asigh.ESTADO                           <> Lv_EstadoEliminado
                AND asigh.USR_ASIGNADO                      = Pv_UsrAsignado
                AND TO_CHAR(asigh.FE_CREACION,'YYYY/MM/DD') = Pv_FeCreacion
                AND asig.ASIGNACION_PADRE_ID IS NULL
              )
            )
          ) ASIGUSR
          WHERE ROWNUM <= 15
        );
        --
        Lv_Resultado := Lv_valor;
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
                                            'F_GET_REGISTROS_ASIGNACIONES',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_REGISTROS_ASIGNACIONES;


PROCEDURE P_GET_ASIGNACIONES_TOTALIZADAS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pv_TotalizadoPor    IN VARCHAR2,
      Pr_Informacion OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Lv_SubQuerySelect       VARCHAR2(500);
    Lv_SubQueryFrom         VARCHAR2(500);
    Lv_SubQueryWhere        VARCHAR2(2000);
    Lv_SubQueryWhereFe      VARCHAR2(2000);
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    --
    --
  BEGIN

      --
      IF Pv_feCreacionIni IS NOT NULL AND Pv_feCreacionFin IS NOT NULL AND Pv_EmpresaCod IS NOT NULL THEN
        Lv_SubQuerySelect := 'SELECT asigh.USR_ASIGNADO, asig.TIPO_PROBLEMA, asig.TIPO_ATENCION, asig.ORIGEN ';
        Lv_SubQueryFrom   := ' FROM '||
                             '  INFO_ASIGNACION_SOLICITUD_HIST asigh '||
                             '  JOIN INFO_ASIGNACION_SOLICITUD asig ON asig.ID_ASIGNACION_SOLICITUD = asigh.ASIGNACION_SOLICITUD_ID ';
        Lv_SubQueryWhere  := ' WHERE '||
                             '  asig.EMPRESA_COD = :Pv_empresaCod ' ||
                             '  AND asig.DEPARTAMENTO_ID = :Pv_departamentoId ';

        Lv_SubQueryWhereFe:= q'[AND (TO_CHAR(asigh.FE_CREACION,'YYYY/MM/DD') >= :Pv_feCreacionIni ]' ||
                             q'[AND TO_CHAR(asigh.FE_CREACION,'YYYY/MM/DD') <= :Pv_feCreacionFin ) ]';
        --
        IF Pv_Estado IS NOT NULL AND UPPER(Pv_ESTADO) <> 'TODOS'  THEN

          IF Pv_Estado = 'Abierto' THEN
            Lv_SubQueryWhere := Lv_SubQueryWhere || q'[  AND asigh.ESTADO <> 'Eliminado' AND asig.ESTADO IN ('Pendiente','EnGestion','Standby') ]';
          ELSIF Pv_Estado = 'Cerrado' THEN
            Lv_SubQuerySelect  := 'SELECT asig.USR_ULT_MOD AS USR_ASIGNADO, asig.TIPO_PROBLEMA, asig.TIPO_ATENCION, asig.ORIGEN ';
            Lv_SubQueryFrom    := ' FROM '||
                                  ' INFO_ASIGNACION_SOLICITUD asig  ';
            Lv_SubQueryWhere   := Lv_SubQueryWhere || q'[ AND asig.ESTADO = ']'||Pv_Estado||q'[' ]';
            Lv_SubQueryWhereFe := q'[ AND (TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') >= :Pv_feCreacionIni ]' ||
                                  q'[ AND TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') <= :Pv_feCreacionFin ) ]';
          ELSE
            Lv_SubQueryWhere   := Lv_SubQueryWhere || q'[   AND asigh.ESTADO <> 'Eliminado' AND asig.ESTADO = ']'||Pv_Estado||q'[' ]';
          END IF;

        ELSE

          Lv_SubQueryWhere := Lv_SubQueryWhere ||q'[  AND asigh.ESTADO <> 'Eliminado' AND asig.ESTADO <> 'Eliminado' ]';


        END IF;
        --
        --
        IF Pv_CantonId IS NOT NULL THEN
          Lv_SubQueryFrom  := Lv_SubQueryFrom  || ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA ';
          Lv_SubQueryWhere := Lv_SubQueryWhere || '  AND ofi.CANTON_ID = :Pv_cantonId ';
        END IF;
        --
        IF (Pv_TotalizadoPor = 'TODAS') THEN

          Lv_Query        := q'[SELECT 'ASIGNACIONES' AS ITEM, COUNT(*) CANTIDAD FROM (]' ||
                             'SELECT * FROM ('|| Lv_SubQuerySelect || Lv_SubQueryFrom || Lv_SubQueryWhere || Lv_SubQueryWhereFe ||') )';
        ELSE

          Lv_Query        := 'SELECT CASE WHEN '||Pv_TotalizadoPor||' IS NOT NULL THEN '||Pv_TotalizadoPor||
                             q'[ ELSE 'No asignado'  END ITEM, COUNT(*) CANTIDAD FROM (]' ||
                             'SELECT * FROM ('|| Lv_SubQuerySelect || Lv_SubQueryFrom || Lv_SubQueryWhere || Lv_SubQueryWhereFe ||') asigsq '||
                             ') GROUP BY '||Pv_TotalizadoPor||' ORDER BY '||Pv_TotalizadoPor||' ASC';
        END IF;

        Lv_Query        := 'SELECT ITEM, CANTIDAD, SPKG_ASIGNACION_SOLICITUD.F_GET_LISTAGG_ASIGTOTALIZADAS('||
                            Pv_EmpresaCod||','||
                            Pv_DepartamentoId||','||
                            q'[']'||Pv_CantonId||q'[']'||','||
                            q'[']'||Pv_Estado||q'[']'||','||
                            q'[']'||Pv_FeCreacionIni||q'[',]'||
                            q'[']'||Pv_FeCreacionFin||q'[',]'||
                            q'[']'||Pv_TotalizadoPor||q'[',]'||
                            'ITEM'||
                           ') SUBCONSULTA'||
                           ' FROM ('||Lv_Query||')';

        --
        -- COSTO QUERY: 7
        Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
        --
        DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_empresaCod',   Pv_EmpresaCod);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_departamentoId', Pv_DepartamentoId);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacionIni', Pv_feCreacionIni);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacionFin', Pv_feCreacionFin);
        --
        IF Pv_CantonId IS NOT NULL THEN
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_cantonId', Pv_CantonId);
        END IF;

        --
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
        Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_ASIGNACIONES_TOTALIZADAS',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_ASIGNACIONES_TOTALIZADAS;

  FUNCTION F_GET_LISTAGG_ASIGTOTALIZADAS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pv_TotalizadoPor    IN VARCHAR2,
      Pv_FiltroQuery      IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    Le_Exception     EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Lv_valor                VARCHAR2(4000);
    Lv_Resultado            VARCHAR2(4000);
    Lv_SubQuery             VARCHAR2(4000);
    Lv_SubQuerySelect       VARCHAR2(2000);
    Lv_SubQueryFrom         VARCHAR2(4000);
    Lv_SubQueryWhere        VARCHAR2(4000);
    Lv_SubQueryWhereFe      VARCHAR2(4000);
    Lv_Query                VARCHAR2(4000);
    Pv_CampoFiltroQuery     VARCHAR2(100);
    Pv_ListaggTotalizadoPor VARCHAR2(100);
    --
  BEGIN
    --
    Lv_Resultado := '';

    IF Pv_TotalizadoPor = 'USR_ASIGNADO' THEN
      Pv_CampoFiltroQuery     := 'USR_ASIGNADO';
      Pv_ListaggTotalizadoPor := 'TIPO_PROBLEMA';
    ELSIF Pv_TotalizadoPor = 'TIPO_PROBLEMA' THEN
      Pv_CampoFiltroQuery     := 'TIPO_PROBLEMA';
      Pv_ListaggTotalizadoPor := 'USR_ASIGNADO';
    ELSIF Pv_TotalizadoPor = 'TIPO_ATENCION' THEN
      Pv_CampoFiltroQuery     := 'TIPO_ATENCION';
      Pv_ListaggTotalizadoPor := 'TIPO_PROBLEMA';
    ELSIF Pv_TotalizadoPor = 'ORIGEN' THEN
      Pv_CampoFiltroQuery     := 'ORIGEN';
      Pv_ListaggTotalizadoPor := 'USR_ASIGNADO';
    ELSIF Pv_TotalizadoPor = 'TODAS' THEN
      Pv_ListaggTotalizadoPor := 'NOMBRE_CANTON';
    END IF;
    --
    IF Pv_feCreacionIni IS NOT NULL AND Pv_feCreacionFin IS NOT NULL AND Pv_EmpresaCod IS NOT NULL THEN
    --
        Lv_SubQuery       := 'SELECT * FROM '||
                             '(';
        Lv_SubQuerySelect := 'SELECT asigh.USR_ASIGNADO, asig.TIPO_PROBLEMA, asig.TIPO_ATENCION, asig.ORIGEN ';
        Lv_SubQueryFrom   := 'FROM '||
                              '  INFO_ASIGNACION_SOLICITUD_HIST asigh '||
                              '  JOIN INFO_ASIGNACION_SOLICITUD asig ON asig.ID_ASIGNACION_SOLICITUD = asigh.ASIGNACION_SOLICITUD_ID ';
        Lv_SubQueryWhere := ' WHERE '||
                              '  asig.EMPRESA_COD = ' ||Pv_EmpresaCod ||' '||
                              '  AND asig.DEPARTAMENTO_ID = '||Pv_DepartamentoId|| ' ';
        Lv_SubQueryWhereFe:=  q'[AND (TO_CHAR(asigh.FE_CREACION,'YYYY/MM/DD') >=']'|| Pv_FeCreacionIni||q'[' ]' ||
                              q'[AND TO_CHAR(asigh.FE_CREACION,'YYYY/MM/DD') <= ']'|| Pv_FeCreacionFin||q'[' ) ]';

        --
        IF Pv_TotalizadoPor = 'TODAS' THEN
        Lv_SubQuerySelect  := Lv_SubQuerySelect || ', can.NOMBRE_CANTON ';
          Lv_SubQueryFrom  := Lv_SubQueryFrom  || ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA '||
                                                  ' JOIN DB_GENERAL.ADMI_CANTON can ON ofi.CANTON_ID = can.ID_CANTON ';
          IF Pv_CantonId IS NOT NULL THEN
            Lv_SubQueryWhere := Lv_SubQueryWhere || '  AND can.ID_CANTON =  ' || Pv_CantonId;
          END IF;
        
        ELSE
        
          IF Pv_CantonId IS NOT NULL THEN
            Lv_SubQueryFrom  := Lv_SubQueryFrom  || ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA ';
            Lv_SubQueryWhere := Lv_SubQueryWhere || '  AND ofi.CANTON_ID =  ' || Pv_CantonId;
          END IF;

        END IF;
        --
        IF Pv_Estado IS NOT NULL AND UPPER(Pv_ESTADO) <> 'TODOS'  THEN

          IF Pv_Estado = 'Abierto' THEN
            Lv_SubQueryWhere := Lv_SubQueryWhere || q'[  AND asigh.ESTADO <> 'Eliminado' AND asig.ESTADO IN ('Pendiente','EnGestion','Standby') ]';
          ELSIF Pv_Estado = 'Cerrado' THEN
              Lv_SubQuerySelect := 'SELECT asig.USR_ULT_MOD AS USR_ASIGNADO, asig.TIPO_PROBLEMA, asig.TIPO_ATENCION, asig.ORIGEN ';
              Lv_SubQueryFrom   := 'FROM INFO_ASIGNACION_SOLICITUD asig ';

            IF Pv_TotalizadoPor = 'TODAS' THEN
              Lv_SubQuerySelect := 'SELECT asig.USR_ULT_MOD AS USR_ASIGNADO, asig.TIPO_PROBLEMA, asig.TIPO_ATENCION, asig.ORIGEN, can.NOMBRE_CANTON ';
              Lv_SubQueryFrom   :=  'FROM INFO_ASIGNACION_SOLICITUD asig '||
                                    ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA '||
                                    ' JOIN DB_GENERAL.ADMI_CANTON can ON ofi.CANTON_ID = can.ID_CANTON ';
            END IF;

            Lv_SubQueryWhereFe:=  q'[AND (TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') >=']'|| Pv_FeCreacionIni||q'[' ]' ||
                                  q'[AND TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') <= ']'|| Pv_FeCreacionFin||q'[' ) ]';
            Lv_SubQueryWhere  := Lv_SubQueryWhere || q'[ AND asig.ESTADO = ']'||Pv_Estado||q'[' ]';
          ELSE
            Lv_SubQueryWhere := Lv_SubQueryWhere || q'[ AND asigh.ESTADO <> 'Eliminado' AND asig.ESTADO = ']'||Pv_Estado||q'[' ]';    
          END IF;
        
        ELSE

          Lv_SubQueryWhere := Lv_SubQueryWhere ||q'[  AND asigh.ESTADO <> 'Eliminado' ]'||
                                                 q'[  AND asig.ESTADO <> 'Eliminado' ]';
        END IF;
        --
        IF Pv_TotalizadoPor = 'TODAS' THEN
          Lv_SubQuery      := Lv_SubQuery || Lv_SubQuerySelect || Lv_SubQueryFrom || Lv_SubQueryWhere || Lv_SubQueryWhereFe ||
                              ') asigla ';
        ELSE
          Lv_SubQuery      := Lv_SubQuery || Lv_SubQuerySelect || Lv_SubQueryFrom || Lv_SubQueryWhere || Lv_SubQueryWhereFe ||
                              ') asigla '||
                              ' WHERE '||
                              'asigla.'||Pv_CampoFiltroQuery||q'[ = ']'||Pv_FiltroQuery||q'[']';
        END IF;
        --
        Lv_SubQuery := 'SELECT '||Pv_ListaggTotalizadoPor||', COUNT(*) CANTIDAD FROM ('||
                       Lv_subQuery ||
                       ') GROUP BY '||Pv_ListaggTotalizadoPor||' ORDER BY '||Pv_ListaggTotalizadoPor||' ASC';

        Lv_SubQuery := 'SELECT LISTAGG '||
        ' ('||
        q'['{]'||
        '"'||'ITEM'||q'[":"'||asiggen.]'||Pv_ListaggTotalizadoPor||q'[||'",]'||
        q'["CANTIDAD":"'||asiggen.CANTIDAD||'"}',',']'||
        ') WITHIN GROUP(ORDER BY asiggen.'||Pv_ListaggTotalizadoPor||' ASC) '||' FROM ('||Lv_SubQuery||') asiggen';
        --
        --COSTO QUERY: 6
        EXECUTE IMMEDIATE Lv_SubQuery INTO Lv_valor;
        --
        Lv_Resultado := '['||Lv_valor||']';
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
                                            'F_GET_LISTAGG_ASIGTOTALIZADAS',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_LISTAGG_ASIGTOTALIZADAS;

  PROCEDURE P_GET_ASIGNACIONES_TOT_ESTADO(
        Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pv_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
        Pv_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
        Pr_Informacion OUT SYS_REFCURSOR )
    IS
      --
      Ln_IdCursor             NUMBER;
      Ln_NumeroRegistros      NUMBER;
      Lv_Query                VARCHAR2(4000);
      Lv_SubQuery             VARCHAR2(4000);
      Lv_SubQueryFrom         VARCHAR2(1000);
      Lv_SubQueryWhere        VARCHAR2(1000);
      Le_Exception            EXCEPTION;
      Lv_MensajeError         VARCHAR2(4000);
      Ln_Resultado            NUMBER;
      --
      --
    BEGIN
        --
        IF Pv_EmpresaCod IS NOT NULL AND Pv_DepartamentoId IS NOT NULL THEN
          --
          IF Pv_CantonId IS NOT NULL THEN
            Lv_SubQueryFrom  := Lv_SubQueryFrom  || ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA ';
            Lv_SubQueryWhere := Lv_SubQueryWhere || '  AND ofi.CANTON_ID = :Pv_cantonId ';
          END IF;
          --
          Lv_SubQuery := 'SELECT ESTADO FROM ( ( SELECT asig.ESTADO '||
                         ' FROM '||
                         '  INFO_ASIGNACION_SOLICITUD asig '||Lv_SubQueryFrom ||
                         ' WHERE '||
                         '  asig.ESTADO <> :Pv_estado_eliminado  '||
                         '  AND asig.EMPRESA_COD = :Pv_empresaCod ' ||
                         '  AND asig.DEPARTAMENTO_ID = :Pv_departamentoId ' ||
                         Lv_SubQueryWhere ||
                         ')';
          Lv_SubQuery := Lv_SubQuery ||
                         ' UNION ALL'||
                         q'[( SELECT asig.ESTADO||'Hoy' ESTADO ]'||
                         ' FROM '||
                         '  INFO_ASIGNACION_SOLICITUD asig '|| Lv_SubQueryFrom ||
                         ' WHERE '||
                         q'[  (asig.ESTADO = :Pv_estado_pendiente OR asig.ESTADO = :Pv_estado_en_gestion) ]'||
                         '  AND asig.EMPRESA_COD = :Pv_empresaCod ' ||
                         '  AND asig.DEPARTAMENTO_ID = :Pv_departamentoId ' ||
                         q'[AND TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD') = TO_CHAR(SYSDATE,'YYYY/MM/DD') ]' ||
                         Lv_SubQueryWhere ||
                         ' ) ';
          Lv_SubQuery := Lv_SubQuery ||
                         ' UNION ALL'||
                         q'[( SELECT 'CerradoHoy' ESTADO ]'||
                         ' FROM '||
                         '  INFO_ASIGNACION_SOLICITUD asig '|| Lv_SubQueryFrom ||
                         ' WHERE '||
                         '  asig.ESTADO = :Pv_estado_cerrado '||
                         '  AND asig.EMPRESA_COD = :Pv_empresaCod ' ||
                         '  AND asig.DEPARTAMENTO_ID = :Pv_departamentoId ' ||
                         q'[AND TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') = TO_CHAR(SYSDATE,'YYYY/MM/DD') ]' ||
                         Lv_SubQueryWhere ||
                         ' ) ';
          Lv_SubQuery := Lv_SubQuery ||
                         ' UNION ALL'||
                         q'[( SELECT 'CerradoMes' ESTADO ]'||
                         ' FROM '||
                         '  INFO_ASIGNACION_SOLICITUD asig '|| Lv_SubQueryFrom ||
                         ' WHERE '||
                         '  asig.ESTADO = :Pv_estado_cerrado '||
                         '  AND asig.EMPRESA_COD = :Pv_empresaCod ' ||
                         '  AND asig.DEPARTAMENTO_ID = :Pv_departamentoId ' ||
                         q'[AND EXTRACT(MONTH FROM asig.FE_ULT_MOD) = EXTRACT(MONTH FROM SYSDATE) ]' ||
                         Lv_SubQueryWhere ||
                         ' ) )';
          --
          --
          Lv_Query        := 'SELECT ESTADO ITEM, COUNT(*) CANTIDAD FROM (' ||
                              'SELECT * FROM ('|| Lv_SubQuery ||') asigsq '||
                              ') GROUP BY ESTADO ORDER BY ESTADO ASC';
          --
          Lv_Query        := 'SELECT ITEM, CANTIDAD FROM ('||Lv_Query||')';
          --
          -- COSTO QUERY: 48
          Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
          --
          DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_empresaCod',   Pv_EmpresaCod);
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_departamentoId', Pv_DepartamentoId);
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado_eliminado', 'Eliminado');
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado_cerrado', 'Cerrado');
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado_pendiente','Pendiente');
          DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado_en_gestion','EnGestion');
          --
          IF Pv_CantonId IS NOT NULL THEN
            DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_cantonId', Pv_CantonId);
          END IF;
          --
          --
          Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
          Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
        END IF;
      --
      --
    EXCEPTION
    WHEN OTHERS THEN
    --
    Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'SPKG_ASIGNACION_SOLICITUD.P_GET_ASIGNACIONES_TOT_ESTADO',
                                          Lv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                          '127.0.0.1')
                                        );
  END P_GET_ASIGNACIONES_TOT_ESTADO;

  PROCEDURE P_REPORTE_ASIGNACIONES_PEND(pv_cod_empresa IN  VARCHAR2,
                                    pn_departamento_id IN  NUMBER,
                                    pn_canton_id IN  NUMBER,
                                    pv_mensaje_error   OUT VARCHAR2)
  IS
  --Se obtiene valor de parametro
  CURSOR c_getparametro(cv_nombre_parametro VARCHAR2,cv_descripcion VARCHAR2)
  IS
    SELECT admipatametrodet.valor1
    FROM db_general.admi_parametro_det admipatametrodet
    WHERE admipatametrodet.parametro_id =
      (SELECT admipatametrocab.id_parametro
      FROM db_general.admi_parametro_cab admipatametrocab
      WHERE admipatametrocab.nombre_parametro = cv_nombre_parametro
      )
  AND admipatametrodet.descripcion = cv_descripcion;

  Ln_IdCursor                     NUMBER;
  Ln_NumeroRegistros              NUMBER;
  Pr_Informacion                  SYS_REFCURSOR;
  lv_fecha_archivo                VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
  lv_asunto_notificacion          VARCHAR2(100)  := 'Reporte de Asignaciones Pendientes en M�dulo Agente';
  lv_directorio                   VARCHAR2(50)   := 'DIR_REPORTES_MODULO_AGENTE';
  lv_nombre_archivo               VARCHAR2(100)  := 'ReporteAsignacionesPendModAgente_'|| lv_fecha_archivo||'.csv';
  lv_nombre_archivo_comprimir     VARCHAR2(100)  := '';
  lv_Gzip                         VARCHAR2(500)  := '';
  Lv_parametro_proyecto_arcotel   VARCHAR2(100)  := 'PARAMETROS REPORTES MODULO AGENTE';
  Lv_parametro_remitente          VARCHAR2(100)  := 'CORREO_REMITENTE';
  Lv_parametro_destinatario       VARCHAR2(100)  := 'CORREO_DESTINATARIO';
  Lv_parametro_direcc_reporte     VARCHAR2(100)  := 'DIRECCION_REPORTES_AGENTE';
  Lv_parametro_comando_reporte    VARCHAR2(100)  := 'COMANDO_REPORTE';
  Lv_parametro_extension_repor    VARCHAR2(100)  := 'EXTENSION_REPORTE';
  lv_parametro_codigo_plantilla   VARCHAR2(1000) := 'CODIGO_PLANTILLA_NOTIFICACION';
  Lv_tipo_afectado                VARCHAR2(20)   := 'Servicio';
  Lv_IpCreacion                   VARCHAR2(30)   := '127.0.0.1';
  lv_codigo_plantilla             VARCHAR2(4000) := '';
  lv_remitente                    VARCHAR2(100)  := '';
  lv_destinatario                 VARCHAR2(100)  := '';
  lv_direccion_completa           VARCHAR2(200)  := '';
  lv_comando_ejecutar             VARCHAR2(200)  := '';
  lf_archivo                      utl_file.file_type;
  lv_delimitador                  VARCHAR2(1) := ';';
  lc_GetAliasPlantilla            DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  lv_Cuerpo                       VARCHAR2(9999) :='';
  lv_departamento                 DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE;
  lv_canton                       DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE;
  lv_empresa                      DB_COMERCIAL.INFO_EMPRESA_GRUPO.NOMBRE_EMPRESA%TYPE;
  --
  lv_feCreacion                   VARCHAR2(100);
  lv_tipoProblema                 VARCHAR2(500);
  lv_tipoAtencion                 VARCHAR2(500);
  lv_referenciaCliente            VARCHAR2(500);
  lv_estadCaso                    VARCHAR2(500);
  lv_estadoTarea                  VARCHAR2(500);
  lv_criticidad                   VARCHAR2(500);
  lv_afectado                     VARCHAR2(500);
  lv_asignado                     VARCHAR2(500);
  lv_usrAsignado                  VARCHAR2(500);
  lv_detalle                      VARCHAR2(2000);
  lv_numero                       VARCHAR2(500);
  lv_estado                       VARCHAR2(500);
  ln_departamentoId               NUMBER;
  ln_cantonId                     NUMBER;
  BEGIN

  --Se crea el archivo
  lf_archivo := utl_file.fopen(lv_directorio,lv_nombre_archivo,'w',3000);

  --Se obtiene el nombre del DEPARTAMENTO
  IF pn_departamento_id IS NOT NULL THEN
    SELECT NOMBRE_DEPARTAMENTO INTO lv_departamento FROM DB_GENERAL.ADMI_DEPARTAMENTO WHERE ID_DEPARTAMENTO = pn_departamento_id;
    Lv_parametro_destinatario := Lv_parametro_destinatario || '_'||pn_departamento_id;
  END IF;

  --Se obtiene el nombre del CANTON
  IF pn_canton_id IS NOT NULL THEN
    SELECT NOMBRE_CANTON INTO lv_canton FROM DB_GENERAL.ADMI_CANTON WHERE ID_CANTON = pn_canton_id;
    Lv_parametro_destinatario := Lv_parametro_destinatario || '_'||pn_canton_id;
  END IF;

  --Se obtiene el nombre de la EMPRESA
  IF pv_cod_empresa IS NOT NULL THEN
    SELECT NOMBRE_EMPRESA INTO lv_empresa FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO WHERE COD_EMPRESA = pv_cod_empresa;
  END IF;

  IF (C_GetParametro%isopen) THEN
    CLOSE C_GetParametro;
  END IF;

  --Se obtiene el remitente
  OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_remitente);
  FETCH c_getparametro INTO lv_remitente;
  CLOSE c_getparametro;



  --Se obtiene el destinatario
  OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_destinatario);
  FETCH c_getparametro INTO lv_destinatario;
  CLOSE c_getparametro;

  --Se obtiene la url del directorio para los reportes de casos para la arcotel
  OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_direcc_reporte);
  FETCH c_getparametro INTO lv_direccion_completa;
  CLOSE c_getparametro;

  --Se obtiene el comando a ejecutar
  OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_comando_reporte);
  FETCH C_GetParametro INTO lv_comando_ejecutar;
  CLOSE C_GetParametro;
  --Se obtiene el comando a ejecutar
  OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_extension_repor);
  FETCH C_GetParametro INTO Lv_parametro_extension_repor;
  CLOSE C_GetParametro;

  --Se obtiene la plantilla para la notificacion
  OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,lv_parametro_codigo_plantilla);
  FETCH C_GetParametro INTO lv_codigo_plantilla;
  CLOSE C_GetParametro;


  --Se insertan las CABECERAS
  utl_file.put_line(lf_archivo,
                      'FECHA CREACION'||lv_delimitador
                    ||'TIPO PROBLEMA'||lv_delimitador
                    ||'TIPO ATENCION'||lv_delimitador
                    ||'CRITICIDAD'||lv_delimitador
                    ||'NUMERO'||lv_delimitador
                    ||'USUARIO ASIGNADO'||lv_delimitador
                    ||'DETALLE'||lv_delimitador
                    ||'ESTADO TAREA'||lv_delimitador
                    ||'ESTADO CASO'||lv_delimitador
                    ||'ASIGNADO'||lv_delimitador
                    ||'AFECTADO'||lv_delimitador );

  --Consulta las asignaciones pendientes
  P_ASIGNACIONES_PENDIENTES (
                             pv_cod_empresa,
                             pn_departamento_id,
                             pn_canton_id,
                             Pr_Informacion
                            );
  LOOP
    FETCH Pr_Informacion INTO
          lv_feCreacion,
          lv_referenciaCliente,
          lv_tipoAtencion,
          lv_tipoProblema,
          lv_criticidad,
          lv_numero,
          lv_usrAsignado,
          lv_detalle,
          lv_estadoTarea,
          lv_estadCaso,
          lv_asignado,
          lv_afectado,
          lv_estado,
          ln_departamentoId,
          ln_cantonId
          ;
    EXIT WHEN Pr_Informacion%NOTFOUND;

    utl_file.put_line(lf_archivo,lv_feCreacion||lv_delimitador                            -- 1)Fecha de creacion
    ||lv_tipoProblema||lv_delimitador                                                     -- 2)Tipo de problema
    ||lv_tipoAtencion||lv_delimitador                                                     -- 3)Tipo de atenci�n
    ||lv_criticidad||lv_delimitador                                                       -- 4)Criticidad
    ||lv_numero||lv_delimitador                                                           -- 5)N�mero de caso o tarea
    ||lv_usrAsignado||lv_delimitador                                                      -- 6)Usuario Asignado
    ||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lv_detalle,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),'|',''),';','')
    ||lv_delimitador                                                                      -- 7)Detalle de la asignaci�n
    ||lv_estadoTarea||lv_delimitador                                                      -- 8)Estado de tarea
    ||lv_estadCaso||lv_delimitador                                                        -- 9)Estado de caso
    ||lv_asignado||lv_delimitador                                                         -- 10)departamento asignado
    ||lv_afectado||lv_delimitador                                                         -- 11)login afectado
    );

  END LOOP;
  CLOSE Pr_Informacion;


  utl_file.fclose(lf_archivo);

  --Armo nombre completo del archivo que se genera
  lv_nombre_archivo_comprimir := Lv_nombre_archivo || Lv_parametro_extension_repor;

  --Se arma el comando a ejecutar
  lv_Gzip := lv_comando_ejecutar || ' '  || lv_direccion_completa || Lv_nombre_archivo;
  dbms_output.put_line(naf47_tnet.javaruncommand (lv_Gzip));

  lc_GetAliasPlantilla      := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(lv_codigo_plantilla);
  lv_Cuerpo                 := lc_GetAliasPlantilla.PLANTILLA;

  /* Se envia notificacion de la generacion del reporte */
  lv_Cuerpo := REPLACE(lv_Cuerpo,'<<lv_departamento>>',lv_departamento);
  lv_Cuerpo := REPLACE(lv_Cuerpo,'<<lv_canton>>',lv_canton);
  lv_cuerpo := REPLACE(lv_cuerpo,'<<lv_fecha_hoy>>',TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'));
  lv_cuerpo := REPLACE(lv_cuerpo,'<<lv_empresa>>',lv_empresa);

  IF lv_destinatario IS NULL THEN
    lv_destinatario := lv_remitente;
  END IF;

  db_general.gnrlpck_util.send_email_attach(lv_remitente,lv_destinatario, lv_asunto_notificacion,
                                            lv_Cuerpo, lv_directorio, lv_nombre_archivo_comprimir);

  utl_file.fremove(lv_directorio,lv_nombre_archivo_comprimir);

  pv_mensaje_error := 'OK';

  EXCEPTION
  WHEN OTHERS THEN
    pv_mensaje_error := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

    db_general.gnrlpck_util.insert_error('Telcos +',
                                          'SPKG_ASIGNACION_SOLICITUD.P_REPORTE_ASIGNACIONES_PEND',
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );

  END P_REPORTE_ASIGNACIONES_PEND;



  PROCEDURE P_ASIGNACIONES_PENDIENTES (
                        pv_cod_empresa     IN  VARCHAR2,
                        pn_departamento_id IN  NUMBER,
                        pn_canton_id       IN  NUMBER,
                        Pr_Informacion     OUT SYS_REFCURSOR)
  AS
  Ln_IdCursor        NUMBER;
  Ln_NumeroRegistros NUMBER;
  Lv_Query           VARCHAR2(4000);
  BEGIN
  Lv_Query :=
  'SELECT * FROM '||
  '('||
    'SELECT * '||
    'FROM '||
      '(SELECT  '||
        q'[TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') FE_CREACION, ]'||
        'SPKG_UTILIDADES.GET_VARCHAR_CLEAN(asig.REFERENCIA_CLIENTE) AS REFERENCIA_CLIENTE, '||
        'asig.TIPO_ATENCION, '||
        'asig.TIPO_PROBLEMA, '||
        ' '||
        'asig.CRITICIDAD, '||
        'CASE '||
          q'[WHEN (asig.TIPO_ATENCION = 'TAREA' ]'||
          'AND asig.REFERENCIA_ID  IS NOT NULL) '||
          'THEN asig.REFERENCIA_ID '||
          q'[WHEN (asig.TIPO_ATENCION = 'CASO' ]'||
          'AND asig.REFERENCIA_ID  IS NOT NULL) '||
          'THEN '||
          '  (SELECT DISTINCT caso.NUMERO_CASO '||
          '  FROM DB_COMUNICACION.INFO_CASO caso '||
          '  WHERE caso.ID_CASO = asig.REFERENCIA_ID '||
          '  ) '||
          'ELSE NULL '||
        'END NUMERO, '||
        'asig.USR_ASIGNADO, '||
        'SPKG_UTILIDADES.GET_VARCHAR_CLEAN(asig.DETALLE) AS DETALLE, '||
        'CASE '||
        q'[  WHEN asig.TIPO_ATENCION = 'TAREA' ]'||
        '  THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(asig.REFERENCIA_ID) '||
        q'[WHEN asig.TIPO_ATENCION = 'CASO' ]'||
        ' THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_CASO(asig.REFERENCIA_ID) '||
        ' END ESTADO_TAREA, '||
        'CASE '||
        q'[  WHEN asig.TIPO_ATENCION = 'TAREA' ]'||
        '    THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_TAREA(asig.REFERENCIA_ID) '||
        q'[  WHEN asig.TIPO_ATENCION = 'CASO' ]'||
        '  THEN SPKG_ASIGNACION_SOLICITUD.F_ESTADO_CASO_POR_CASO(asig.REFERENCIA_ID) '||
        ' END ESTADO_CASO, '||
        'CASE '||
        q'[  WHEN asig.TIPO_ATENCION = 'TAREA' ]'||
        q'[  THEN SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(asig.REFERENCIA_ID,'asignado') ]'||
        q'[  WHEN asig.TIPO_ATENCION = 'CASO' ]'||
        q'[  THEN SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA( TO_CHAR(SPKG_ASIGNACION_SOLICITUD.F_NUMERO_TAREA_POR_CASO(asig.REFERENCIA_ID)), 'asignado') ]'||
        'END ASIGNADO, '||
        'CASE '||
        q'[  WHEN asig.TIPO_ATENCION = 'TAREA' ]'||
        '  THEN SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_TAREA(asig.REFERENCIA_ID) '||
        q'[  WHEN asig.TIPO_ATENCION = 'CASO' ]'||
        '  THEN SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_CASO(asig.REFERENCIA_ID) '||
        ' END AFECTADO, '||
        ' asig.ESTADO, '||
        ' asig.DEPARTAMENTO_ID, '||
        ' ofi.CANTON_ID '||
      'FROM INFO_ASIGNACION_SOLICITUD asig '||
      'JOIN INFO_OFICINA_GRUPO ofi '||
      'ON ofi.ID_OFICINA      = asig.OFICINA_ID '||
      'WHERE asig.EMPRESA_COD = :Pv_codEmpresa '||
      ') ASIGNACION '||
    q'[WHERE ASIGNACION.ESTADO       = 'Pendiente' ]'||
    q'[OR (ASIGNACION.ESTADO         = 'EnGestion' ]'||
    q'[AND (ASIGNACION.ESTADO_TAREA <> 'Finalizada' ]'||
    q'[OR (ASIGNACION.ESTADO_CASO   <> 'Cerrado' ]'||
    'AND ASIGNACION.ESTADO_CASO   IS NOT NULL)) ) '||
  ') '||
  'WHERE             1 = 1 '||
  'AND DEPARTAMENTO_ID = :Pv_departamentoId ';

  IF pn_canton_id IS NOT NULL THEN
    Lv_Query := Lv_Query || ' AND CANTON_ID = :Pv_cantonId ';
  END IF;

  Lv_Query := Lv_Query || ' ORDER BY FE_CREACION ASC ';

  Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
  DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_codEmpresa'    ,  pv_cod_empresa );
  DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_departamentoId',  pn_departamento_id );
  IF pn_canton_id IS NOT NULL THEN
    DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_cantonId',  pn_canton_id );
  END IF;

  --
  --
  Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
  Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);

  END P_ASIGNACIONES_PENDIENTES;


  FUNCTION F_INFO_TAREAS_POR_CASO(Pv_idCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE)
      RETURN VARCHAR2
    IS
      Lv_campo_retorna VARCHAR2(4000);
      Lv_MensajeError  VARCHAR2(4000);
    BEGIN
      --COSTO QUERY: 11
      SELECT
        '['||ESTADOS||']' AS TAREAS_POR_CASO INTO Lv_campo_retorna
      FROM
      (
        SELECT
        LISTAGG('{'||'"IDDET":"'||TAREAS.ID_DETALLE||'","FE":"'||TO_CHAR(TAREAS.FE_CREACION,'YYYY-MM-DD HH24:MI:SS')||
                '","NUM":"'||TAREAS.NUMERO_TAREA||'","EST":"'||TAREAS.MAX_HISTORIAL||'","ASIG":"'||TAREAS.ASIGNADO||'"}',',')
        WITHIN GROUP (ORDER BY TAREAS.NUMERO_TAREA ASC) AS ESTADOS
        FROM
        (
        SELECT ID_DETALLE,FE_CREACION,MAX_HISTORIAL,NUMERO_TAREA,SPKG_ASIGNACION_SOLICITUD.F_GET_DATOS_TAREA(NUMERO_TAREA,'asignado') AS ASIGNADO
        FROM
        (SELECT
          idet.ID_DETALLE,
          idet.FE_CREACION,
          ( SELECT MIN(com.ID_COMUNICACION)
            FROM DB_COMUNICACION.INFO_COMUNICACION com
            WHERE com.DETALLE_ID = idet.ID_DETALLE ) AS NUMERO_TAREA,
          ( SELECT
              histo.ESTADO
            FROM
              DB_SOPORTE.INFO_DETALLE_HISTORIAL histo
            WHERE
              histo.ID_DETALLE_HISTORIAL =
              (
                SELECT
                   max(idhis.ID_DETALLE_HISTORIAL)
                FROM
                   DB_SOPORTE.INFO_DETALLE_HISTORIAL idhis
                WHERE
                   idhis.DETALLE_ID = idet.ID_DETALLE
              )
          ) AS MAX_HISTORIAL

        FROM DB_SOPORTE.INFO_CASO caso
          JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS ideth ON ideth.CASO_ID = caso.ID_CASO
          JOIN DB_SOPORTE.INFO_DETALLE idet ON idet.DETALLE_HIPOTESIS_ID = ideth.ID_DETALLE_HIPOTESIS
        WHERE
          caso.ID_CASO = Pv_idCaso
          AND idet.TAREA_ID IS NOT NULL
        )
        )TAREAS
      );
      --
      RETURN Lv_campo_retorna;
    --
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN Lv_campo_retorna;
    WHEN OTHERS THEN
    --
        Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'SPKG_ASIGNACION_SOLICITUD.F_INFO_TAREAS_POR_CASO',
                                              Lv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                              '127.0.0.1')
                                            );

        RETURN Lv_campo_retorna;
    --
  END F_INFO_TAREAS_POR_CASO;


  PROCEDURE P_GET_ULTIMO_AGENTE_ASIGNADO(
    Pv_codEmpresa     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
    Pn_departamentoId IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
    Pn_cantonId       IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.CANTON_ID%TYPE,
    Pv_ultimoAsignado OUT VARCHAR2)
  IS
    --
    Le_Exception     EXCEPTION;
    Lv_MensajeError  VARCHAR2(4000) := '';
    Lv_resultado     VARCHAR2(4000) := '';
    Lv_query         VARCHAR2(2000) := '';
    --
  BEGIN
    --
    --COSTO QUERY 2
    --
    IF Pv_codEmpresa IS NOT NULL AND Pn_departamentoId IS NOT NULL THEN 
     
      Lv_Query := 'SELECT asigh.USR_ASIGNADO '|| 
                  'FROM '|| 
                  'INFO_ASIGNACION_SOLICITUD_HIST asigh '|| 
                  'WHERE asigh.ID_ASIGNACION_SOLICITUD_HIST = '|| 
                  '('|| 
                  '  SELECT MAX(asighMax.ID_ASIGNACION_SOLICITUD_HIST)  '||
                  '  FROM INFO_ASIGNACION_SOLICITUD_HIST asighMax '|| 
                  '  JOIN INFO_ASIGNACION_SOLICITUD asigMax ON asigMax.ID_ASIGNACION_SOLICITUD = asighMax.ASIGNACION_SOLICITUD_ID ';
      IF Pn_cantonId IS NOT NULL THEN
        Lv_Query := Lv_Query || '  JOIN INFO_OFICINA_GRUPO ofiMax ON asigMax.OFICINA_ID = ofiMax.ID_OFICINA ';
      END IF;
      --
      Lv_Query := Lv_Query || q'[  WHERE asigMax.ESTADO  <> 'Eliminado'  ]'||
                              ' AND  asigMax.EMPRESA_COD     = ' || Pv_codEmpresa  ||
                              ' AND  asigMax.DEPARTAMENTO_ID = ' || Pn_departamentoId ;
      --
      IF Pn_cantonId IS NOT NULL THEN
        Lv_Query := Lv_Query || ' AND  ofiMax.CANTON_ID = ' || Pn_cantonId ;
      END IF;
      --
      Lv_Query := Lv_Query || ')';
        --
      EXECUTE IMMEDIATE Lv_Query INTO Lv_resultado;
    END IF;
    --
  Pv_ultimoAsignado := Lv_resultado;
  --
  EXCEPTION
    WHEN OTHERS THEN
    --
    Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'SPKG_ASIGNACION_SOLICITUD.P_GET_ULTIMO_AGENTE_ASIGNADO',
                                          Lv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                          '127.0.0.1')
                                        );
  END P_GET_ULTIMO_AGENTE_ASIGNADO;



  PROCEDURE P_GET_TAREAS_DEPARTAMENTO(
    Pv_departamentoId IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
    Pv_empresaCod     IN  DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
    Pr_Informacion    OUT SYS_REFCURSOR,
    Pv_PermiteVerCamposTareas  IN VARCHAR2 DEFAULT 'N',
    Pv_FechaIni  IN VARCHAR2 DEFAULT '',
    Pv_FechaFin  IN VARCHAR2 DEFAULT '')
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    Lv_QueryTarea1          CLOB := '';
    Lv_QueryTarea2          CLOB := '';
    Lv_WhereTarea           CLOB := '';
    --
  BEGIN

      -- COSTO QUERY: 101
	  
	  IF Pv_PermiteVerCamposTareas IS NOT NULL  AND Pv_PermiteVerCamposTareas = 'S' THEN
	  
	    Lv_QueryTarea1 := ', CASE WHEN TAREAS.idCaso <> 0 THEN (SELECT ic.EMPRESA_COD FROM DB_SOPORTE.INFO_CASO ic '||
					q'[ WHERE ic.ID_CASO = TAREAS.idCaso) ELSE '' END caso_empresa_cod, ]' ||
					'(SELECT IPER.DEPARTAMENTO_ID FROM DB_SOPORTE.INFO_PERSONA  INFPER, DB_SOPORTE.INFO_PERSONA_EMPRESA_ROL IPER, '||
				       'DB_SOPORTE.ADMI_DEPARTAMENTO ADMDP,DB_SOPORTE.INFO_OFICINA_GRUPO IPG '||
				       'WHERE INFPER.ID_PERSONA = TAREAS.ref_Asignado_Id  AND IPER.PERSONA_ID = INFPER.ID_PERSONA '||
				       q'[AND IPER.ESTADO = 'Activo' AND IPER.DEPARTAMENTO_ID IS NOT NULL AND IPER.DEPARTAMENTO_ID = ADMDP.ID_DEPARTAMENTO ]'||
				       'AND IPER.OFICINA_ID  = IPG.ID_OFICINA AND IPG.EMPRESA_ID = 10 AND ADMDP.EMPRESA_COD = 10) AS departamento_id,'||
				    ' (SELECT PD.valor1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,DB_GENERAL.ADMI_PARAMETRO_CAB PC '||
				    q'[    WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID AND PC.NOMBRE_PARAMETRO = 'TAREAS_MOSTRAR_BTN_INFO_ADICIONAL' ]'||
				    q'[    AND PC.estado = 'Activo' AND PD.estado = 'Activo' AND PD.VALOR1 = TAREAS.nombre_Tarea AND rownum = 1) AS tarea_info_adicional, ]'||
				    ' SPKG_ASIGNACION_SOLICITUD.F_GET_FECHA_CREACION_TAREA(TAREAS.idDetalle,TAREAS.veces_tarea_iniciada) as fecha_tarea_creacion ';
				   
		Lv_QueryTarea2 := ', (SELECT idh.ID_DETALLE_HISTORIAL FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh WHERE idh.ID_DETALLE_HISTORIAL = ' ||
					'  (SELECT max(idh1.ID_DETALLE_HISTORIAL) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1 WHERE idh1.DETALLE_ID = d.ID_DETALLE)) AS idDetalleHist, '||
                    '  (SELECT idh.ESTADO FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh WHERE idh.ID_DETALLE_HISTORIAL = ' ||
					'  (SELECT max(idh1.ID_DETALLE_HISTORIAL) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1 WHERE idh1.DETALLE_ID = d.ID_DETALLE)) AS estadoHist, '||
                    '  (SELECT'|| q'[ TO_CHAR(idh.FE_CREACION,'yyyy/mm/dd hh24:mi:ss')]'||' FECHA FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh WHERE idh.ID_DETALLE_HISTORIAL = ' ||
					'  (SELECT max(idh1.ID_DETALLE_HISTORIAL) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1 WHERE idh1.DETALLE_ID = d.ID_DETALLE)) AS fechaCreaHist, '||
                    '  DB_SOPORTE.SPKG_INFO_TAREA.F_GET_TAREA_PADRE( d.detalle_Id_Relacionado ) AS numero_tarea_padre, '||
                    '  DB_SOPORTE.SPKG_INFO_TAREA.F_GET_PERMITE_FINALIZAR_INFORM( '||
                    '  d.id_detalle, t.nombre_Tarea, :Pv_departamentoId) AS permite_finalizar_informe, '||
                    '  NVL(d.DETALLE_HIPOTESIS_ID,0) AS id_det_hipotesis, '||
                    '  (SELECT idh.TAREA_ID FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh,DB_SOPORTE.ADMI_TAREA ata WHERE idh.ID_DETALLE_HISTORIAL = ' ||
					'  (SELECT min(idh1.ID_DETALLE_HISTORIAL) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1 WHERE idh1.DETALLE_ID = d.ID_DETALLE and idh1.ACCION = '|| q'['Reasignada' AND idh1.TAREA_ID IS NOT NULL) ]'||
					'  and ata.ID_TAREA = idh.TAREA_ID) AS id_tarea_anterior, '||
					'  (SELECT ata.NOMBRE_TAREA FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh,DB_SOPORTE.ADMI_TAREA ata WHERE idh.ID_DETALLE_HISTORIAL = ' ||
					'  (SELECT min(idh1.ID_DETALLE_HISTORIAL) FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL idh1 WHERE idh1.DETALLE_ID = d.ID_DETALLE and idh1.ACCION = '|| q'['Reasignada' AND idh1.TAREA_ID IS NOT NULL ) ]'||
					'  and ata.ID_TAREA = idh.TAREA_ID) AS nombre_tarea_anterior, '||
					'  (SELECT NVL(MAX(dh.CASO_ID),0) as ID_CASO FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS dh WHERE dh.ID_DETALLE_HIPOTESIS = d.DETALLE_HIPOTESIS_ID) AS idCaso, '||
					'  (SELECT COUNT(its.ID_SEGUIMIENTO) n_tarea_ini FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its WHERE its.DETALLE_ID = d.ID_DETALLE '||
                    q'[      AND its.OBSERVACION like '%Iniciada%' ) AS veces_tarea_iniciada, ]'||
                    '(SELECT tp.VALOR_TIEMPO FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp WHERE tp.ID_TIEMPO_PARCIAL = (SELECT max(tp1.ID_TIEMPO_PARCIAL) '||
					q'[	FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp1 WHERE tp1.DETALLE_ID = d.ID_DETALLE AND tp1.ESTADO = 'Pausada')) as valor_tiempo_pausa, ]'|| 
				    q'[ (SELECT TO_CHAR(tp.FE_CREACION,'dd-mm-yyyy hh24:mi') AS fe_creacion FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp ]'||
					'	  WHERE tp.ID_TIEMPO_PARCIAL = (SELECT  max(tp1.ID_TIEMPO_PARCIAL)  FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL tp1 '||
					q'[	WHERE tp1.DETALLE_ID = d.ID_DETALLE AND tp1.ESTADO = 'Reanudada')) as fecha_creacion_reanuda, ]'||
                    q'[  TO_CHAR(d.fe_Solicitada,'YYYY-MM-DD HH24:MI:SS') AS fecha_ejecucion ]';
          
         IF Pv_FechaIni IS NOT NULL  AND LENGTH(Pv_FechaIni) > 0 AND Pv_FechaFin IS NOT NULL  AND LENGTH(Pv_FechaFin) > 0  THEN
             Lv_WhereTarea := q'[ AND TRUNC(TAREAS.FE_CREACION) >= to_date(:Pv_FechaIni,'yyyy-mm-dd') ]'||
                    		  q'[ AND TRUNC(TAREAS.FE_CREACION) <= to_date(:Pv_FechaFin,'yyyy-mm-dd') ]';
         
         END IF; 
      
		
      END IF;
     

      Lv_Query   := 'SELECT SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_TAREA(TAREAS.ID_COMUNICACION) as AFECTADOS '|| 
      				Lv_QueryTarea1 ||
      				', TAREAS.* FROM ('||
                    'SELECT d.ID_DETALLE AS idDetalle,'||
                    '  (SELECT MIN(icom.ID_COMUNICACION) FROM INFO_COMUNICACION icom WHERE icom.DETALLE_ID = d.ID_DETALLE) AS ID_COMUNICACION, '||                    
                    '  d.latitud,'||
                    '  d.longitud,' ||
                    '  d.usr_Creacion AS usrCreacionDetalle,' ||
                    '  d.detalle_Id_Relacionado,' ||
                    q'[  TO_CHAR(d.FE_CREACION,'YYYY/MM/DD HH24:MI:SS') AS FE_TAREA_CREADA, ]' ||
                    '  d.fe_Solicitada,'||
                    '  t.id_tarea AS idTarea,'||
                    '  t.nombre_Tarea,'||
                    '  t.descripcion_Tarea,'||
                    '  da.asignado_Id,'||
                    '  da.asignado_Nombre,'||
                    '  da.ref_Asignado_Id,'||
                    '  da.ref_Asignado_Nombre,'||
                    '  da.persona_Empresa_Rol_Id,'||
                    '  (SELECT p.LOGIN FROM INFO_PERSONA_EMPRESA_ROL per ' ||
                    '   JOIN INFO_PERSONA p ON p.ID_PERSONA = per.PERSONA_ID '||
                    '   WHERE per.ID_PERSONA_ROL = da.persona_empresa_rol_id) AS usr_asignado, ' ||
                    '  da.fe_Creacion     AS feTareaAsignada,'||
                    '  da.departamento_Id AS idDepartamentoCreador,'||
                    '  dh.estado,'||
                    '  dh.fe_Creacion  AS feTareaHistorial,'||
                    '  dh.usr_Creacion AS usrTareaHistorial,'||
                    '  dh.observacion AS observacionHistorial,'||
                    '  da.tipo_Asignado,'||
                    '  SPKG_UTILIDADES.GET_VARCHAR_CLEAN(CAST(d.OBSERVACION AS VARCHAR2(3999))) as observacion, ' ||
                    '  d.fe_creacion, ' ||
                    '  dto.NOMBRE_DEPARTAMENTO,' || 
                    '  Pr.Nombre_Proceso, '||
                    '  (SELECT p.LOGIN FROM DB_COMERCIAL.INFO_PERSONA P WHERE P.Id_Persona = da.ref_Asignado_Id) ultimo_usr_asig, '||
                    '  (select S.Nombre_Departamento from DB_GENERAL.ADMI_DEPARTAMENTO s where s.ID_DEPARTAMENTO = da.asignado_Id) ultimo_dto_asig, '||
                    '   Eg.Nombre_Empresa, '||
                    '  SPKG_ASIGNACION_SOLICITUD.GET_TRAZABILIDAD_TAREAS_USR(d.id_detalle) trazabilidad '||
                    Lv_QueryTarea2 ||
                    'FROM '|| 
                    '  Info_Detalle d,'||
                    '  Info_Detalle_Asignacion da,'||
                    '  Info_Detalle_Historial dh,' ||
                    '  Admi_Tarea t ,'||
                    '  Info_Detalle_Tareas ta,' ||
                    '  DB_GENERAL.Admi_Departamento dto,' || 
                    '  Admi_Proceso pr, ' ||
                    '  DB_COMERCIAL.Info_Empresa_Grupo eg ' ||
                    'WHERE ' || 
                    'd.ID_DETALLE   = da.detalle_Id '||
                    'AND d.ID_DETALLE     = dh.detalle_Id '||
                    'AND t.ID_TAREA     = d.tarea_Id '||
                    'AND ta.DETALLE_ID = d.id_detalle '||
                    'AND da.ID_DETALLE_ASIGNACION = ta.detalle_Asignacion_Id '||
                    'AND dh.ID_DETALLE_HISTORIAL = ta.detalle_Historial_Id '||
                    'AND d.id_DETALLE IN '||
                    '  (SELECT a.DETALLE_ID '||
                    '  FROM Info_Detalle_Tareas a '||
                    '       JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi ON ofi.ID_OFICINA = a.OFICINA_ID'||
                    '  WHERE a.departamento_Id = :Pv_departamentoId '||
                    '  AND ofi.EMPRESA_ID        = :Pv_empresaCod '||
                    q'[  AND a.estado NOT      IN ('Anulada','Finalizada') ]'||
                    '  ) '||
                    q'[ AND dh.estado NOT IN ('Eliminada','Finalizada','Anulada') ]'||
                    'AND da.DEPARTAMENTO_ID = dto.ID_DEPARTAMENTO '||
                    'and Pr.Id_Proceso = T.Proceso_Id '|| 
                    'and Eg.Cod_Empresa = (SELECT MIN(Icom.Empresa_Cod) FROM DB_COMUNICACION.INFO_COMUNICACION icom WHERE icom.DETALLE_ID = d.ID_DETALLE) '||
                    ') TAREAS '||
                    q'[ LEFT JOIN INFO_ASIGNACION_SOLICITUD asig ON (TAREAS.ID_COMUNICACION = asig.REFERENCIA_ID AND asig.ESTADO<>'Eliminado')]' ||
                    q'[ WHERE asig.REFERENCIA_ID IS NULL ]' ||
                    Lv_WhereTarea ||
                    ' ORDER BY TAREAS.FE_CREACION DESC '
            ;
    --
    IF Pv_PermiteVerCamposTareas IS NOT NULL  AND Pv_PermiteVerCamposTareas = 'S' THEN 
    	IF  Pv_FechaIni IS NOT NULL  AND LENGTH(Pv_FechaIni) > 0 AND Pv_FechaFin IS NOT NULL  AND LENGTH(Pv_FechaFin) > 0  THEN
	    	OPEN Pr_Informacion FOR Lv_Query USING Pv_departamentoId,Pv_departamentoId,Pv_empresaCod,Pv_FechaIni,Pv_FechaFin;
		ELSE
			OPEN Pr_Informacion FOR Lv_Query USING Pv_departamentoId,Pv_departamentoId,Pv_empresaCod;
		END IF;
    ELSE 
    	OPEN Pr_Informacion FOR Lv_Query USING Pv_departamentoId,Pv_empresaCod;
    END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  IF Pr_Informacion%ISOPEN THEN
  	CLOSE Pr_Informacion;
  END IF;
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_TAREAS_DEPARTAMENTO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_TAREAS_DEPARTAMENTO;


PROCEDURE P_GET_TOP_LOGINS(
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_DepartamentoId   IN DB_GENERAL.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE,
      Pn_CantonId         IN DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
      Pv_Estado           IN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.ESTADO%TYPE,
      Pv_FeCreacionIni    IN VARCHAR2,
      Pv_FeCreacionFin    IN VARCHAR2,
      Pr_Informacion OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Lv_SubQuerySelect       VARCHAR2(500);
    Lv_SubQueryFrom         VARCHAR2(500);
    Lv_SubQueryWhere        VARCHAR2(2000);
    Lv_SubQueryWhereTa      VARCHAR2(2000);
    Lv_SubQueryWhereOtros   VARCHAR2(2000);
    Lv_SubQueryWhereFecha   VARCHAR2(2000);
    Lv_SubQueryWhereCanton  VARCHAR2(2000);
    Lv_SubQueryWhereEstado  VARCHAR2(2000);
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    --
    --
  BEGIN

      --
      IF Pv_feCreacionIni IS NOT NULL AND Pv_feCreacionFin IS NOT NULL AND Pv_EmpresaCod IS NOT NULL THEN
        --
        Lv_SubQuerySelect     := 'SELECT SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_CASO(asig.REFERENCIA_ID) AFECTADO, asig.TIPO_ATENCION ';
        Lv_SubQueryFrom       := ' FROM INFO_ASIGNACION_SOLICITUD asig ';
        Lv_SubQueryWhere      := ' WHERE ';
        Lv_SubQueryWhereTa    := ' asig.TIPO_ATENCION = :Pv_tipoAtencionCaso ';
        --
        Lv_SubQueryWhereOtros := '  AND asig.EMPRESA_COD = :Pv_empresaCod ' ||
                                 '  AND asig.DEPARTAMENTO_ID = :Pn_departamentoId ';
        Lv_SubQueryWhereFecha :=
                                 q'[AND (TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD') >= :Pv_feCreacionIni ]' ||
                                 q'[AND TO_CHAR(asig.FE_CREACION,'YYYY/MM/DD') <= :Pv_feCreacionFin ) ]';
        --
        IF Pn_CantonId IS NOT NULL THEN
          Lv_SubQueryFrom        := Lv_SubQueryFrom  || ' JOIN INFO_OFICINA_GRUPO ofi ON asig.OFICINA_ID = ofi.ID_OFICINA ';
          Lv_SubQueryWhereCanton := '  AND ofi.CANTON_ID = :Pn_cantonId ';
        END IF;
        --
        IF Pv_Estado IS NOT NULL AND UPPER(Pv_ESTADO) <> 'TODOS'  THEN

          IF Pv_Estado = 'Abierto' THEN
            Lv_SubQueryWhereEstado := Lv_SubQueryWhereEstado || q'[  AND asig.ESTADO IN ('EnGestion','Standby') ]';
          ELSE
            Lv_SubQueryWhereEstado := Lv_SubQueryWhereEstado || q'[  AND asig.ESTADO = ']'||Pv_Estado||q'[']';
            Lv_SubQueryWhereFecha  := q'[AND (TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') >= :Pv_feCreacionIni ]' ||
                                      q'[AND TO_CHAR(asig.FE_ULT_MOD,'YYYY/MM/DD') <= :Pv_feCreacionFin ) ]';
          END IF;

        ELSE

          Lv_SubQueryWhereEstado := Lv_SubQueryWhereEstado ||q'[ AND asig.ESTADO NOT IN ('Eliminado','Pendiente') ]';

        END IF;
        --
        Lv_Query        := '(SELECT * FROM '||
                           q'[( SELECT LOGINS.AFECTADO ,'CASO' TIPO_ATENCION,  COUNT(*) CANTIDAD FROM ]' ||
                            '('|| 
                                  Lv_SubQuerySelect || 
                                  Lv_SubQueryFrom   || 
                                  Lv_SubQueryWhere  || 
                                  Lv_SubQueryWhereTa  || 
                                  Lv_SubQueryWhereOtros  ||
                                  Lv_SubQueryWhereFecha  ||
                                  Lv_SubQueryWhereEstado ||
                                  Lv_SubQueryWhereCanton ||
                            ') LOGINS '||
                            'WHERE AFECTADO IS NOT NULL '||
                            ' GROUP BY AFECTADO,TIPO_ATENCION ORDER BY COUNT(*) DESC )'||
                            'WHERE ROWNUM <=10 )';
        --
        Lv_Query        := Lv_Query || ' UNION ALL ';
        --
        Lv_SubQuerySelect     := 'SELECT SPKG_ASIGNACION_SOLICITUD.F_GET_AFECTADOS_POR_TAREA(asig.REFERENCIA_ID) AFECTADO, asig.TIPO_ATENCION ';
        Lv_SubQueryWhereTa    := ' asig.TIPO_ATENCION = :Pv_tipoAtencionTarea ';
        --
        Lv_Query        := Lv_Query || '(SELECT * FROM '||
                                       q'[( SELECT LOGINS.AFECTADO ,'TAREA' TIPO_ATENCION,  COUNT(*) CANTIDAD FROM ]' ||
                                       '('|| 
                                            Lv_SubQuerySelect || 
                                            Lv_SubQueryFrom   || 
                                            Lv_SubQueryWhere  || 
                                            Lv_SubQueryWhereTa  || 
                                            Lv_SubQueryWhereOtros  || 
                                            Lv_SubQueryWhereFecha  ||
                                            Lv_SubQueryWhereEstado ||
                                            Lv_SubQueryWhereCanton ||
                                       ') LOGINS '||
                                       'WHERE AFECTADO IS NOT NULL '||
                                       ' GROUP BY AFECTADO,TIPO_ATENCION ORDER BY COUNT(*) DESC )'||
                                       'WHERE ROWNUM <=10 )';
        --
        -- COSTO QUERY: 146
        Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
        --
        DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_empresaCod',   Pv_EmpresaCod);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_departamentoId', Pn_DepartamentoId);
        --DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_estado', 'Eliminado');
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacionIni', Pv_FeCreacionIni);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_feCreacionFin', Pv_FeCreacionFin);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_tipoAtencionTarea', 'TAREA');
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_tipoAtencionCaso', 'CASO');
        IF Pn_CantonId IS NOT NULL THEN
                DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_cantonId', Pn_CantonId);
        END IF;
        --
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);

        Pr_Informacion     := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_TOP_LOGINS',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_TOP_LOGINS;



PROCEDURE P_GET_TOT_ASIGNACIONES_SIN_NUM(
    Pv_idDepartamento DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.DEPARTAMENTO_ID%TYPE,
    Pv_codEmpresa     DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.EMPRESA_COD%TYPE,
    Pv_idCanton       DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
    Pv_usrAsignado    DB_SOPORTE.INFO_ASIGNACION_SOLICITUD.USR_ASIGNADO%TYPE,
    Pn_total        OUT  NUMBER)
  IS
    --
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    Lv_sql               VARCHAR2(1000);
    Lv_where             VARCHAR2(1000);
    --
  BEGIN
    --
    Lv_sql   := 'SELECT COUNT(*) FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD ASIG ';
    Lv_where := ' WHERE'||
      ' ASIG.REFERENCIA_ID IS NULL'||
      q'[ AND ASIG.ESTADO <> 'Eliminado']';
      
      IF Pv_idDepartamento IS NOT NULL THEN
          Lv_where := Lv_where || ' AND ASIG.DEPARTAMENTO_ID ='|| Pv_idDepartamento;
      END IF;

      IF Pv_codEmpresa IS NOT NULL THEN
          Lv_where := Lv_where || ' AND ASIG.EMPRESA_COD ='|| Pv_codEmpresa;
      END IF;

      IF Pv_idCanton IS NOT NULL THEN
          Lv_sql := Lv_sql || ' JOIN INFO_OFICINA_GRUPO OFI ON ASIG.OFICINA_ID = OFI.ID_OFICINA ';
          Lv_where := Lv_where || '  AND ofi.CANTON_ID = '|| Pv_idCanton;
      END IF;

      IF Pv_usrAsignado IS NOT NULL THEN
          Lv_where := Lv_where || q'[ AND ASIG.USR_ASIGNADO =']'|| Pv_usrAsignado||q'[']';
      END IF;
      --
      Lv_sql := Lv_sql || Lv_where;
      dbms_output.put_line(Lv_sql);
      --
      EXECUTE IMMEDIATE Lv_sql into Pn_total;
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_TOT_ASIGNACIONES_SIN_NUM',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_TOT_ASIGNACIONES_SIN_NUM;


PROCEDURE P_GET_REGISTROS_CONEXION(
      Pn_PersonaEmpresaRolId     IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pn_Mes                     IN  NUMBER,
      Pn_Anio                    IN  NUMBER,
      Pr_Informacion             OUT SYS_REFCURSOR )
  IS
    --
    Ln_IdCursor             NUMBER;
    Ln_NumeroRegistros      NUMBER;
    Lv_Query                CLOB;
    Le_Exception            EXCEPTION;
    Lv_MensajeError         VARCHAR2(4000);
    Ln_Resultado            NUMBER;
    --
    --
  BEGIN
      --
      IF Pn_PersonaEmpresaRolId IS NOT NULL AND Pn_Mes IS NOT NULL AND Pn_Anio IS NOT NULL  THEN
        --
        -- COSTO QUERY: 4
        OPEN Pr_Informacion FOR 
        SELECT FE_CONEXION, ESTADO_CONEXION, EXTENSION, FE_CREACION, USR_CREACION 
        FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD_REG 
        WHERE 
        PERSONA_EMPRESA_ROL_ID = Pn_PersonaEmpresaRolId 
        AND EXTRACT(MONTH FROM FE_CONEXION) = Pn_Mes
        AND EXTRACT(YEAR FROM FE_CONEXION)  = Pn_Anio
        ORDER BY FE_CONEXION DESC;
        --
        --
      END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_ASIGNACION_SOLICITUD.P_GET_REGISTROS_CONEXION',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  END P_GET_REGISTROS_CONEXION;


  PROCEDURE P_ENVIAR_STANDBY_A_CAMB_TURNO(pv_mensaje_respuesta OUT VARCHAR2)
  IS
  CURSOR C_GetAsignacionesStandby
  IS
    SELECT asig.*
      FROM DB_SOPORTE.INFO_ASIGNACION_SOLICITUD asig 
      JOIN DB_SOPORTE.INFO_ASIGNACION_SOLICITUD_HIST asigh ON asig.ID_ASIGNACION_SOLICITUD = asigh.ASIGNACION_SOLICITUD_ID
    WHERE asig.ESTADO = 'Standby'
      AND asig.CAMBIO_TURNO = 'N'
      AND asigh.FE_CAMBIO_TURNO <= LOCALTIMESTAMP
      AND asigh.ID_ASIGNACION_SOLICITUD_HIST =
        (SELECT MAX(asigh1.ID_ASIGNACION_SOLICITUD_HIST) FROM 
          DB_SOPORTE.INFO_ASIGNACION_SOLICITUD_HIST asigh1 
          WHERE asigh1.TIPO='STANDBY' 
          AND asigh1.ASIGNACION_SOLICITUD_ID = asig.ID_ASIGNACION_SOLICITUD)
    ORDER BY
    asigh.FE_CAMBIO_TURNO ASC;

  TYPE T_Array_asignaciones IS TABLE OF DB_SOPORTE.INFO_ASIGNACION_SOLICITUD%ROWTYPE INDEX BY BINARY_INTEGER;
  Lt_asignaciones T_Array_asignaciones;

  ln_idAsignacionSolicitud NUMBER;
  Ln_Indice_Asig           NUMBER := 1;

  BEGIN

    IF (C_GetAsignacionesStandby%isopen) THEN
      CLOSE C_GetAsignacionesStandby;
    END IF;

    OPEN C_GetAsignacionesStandby;
      FETCH C_GetAsignacionesStandby BULK COLLECT INTO Lt_asignaciones LIMIT 100000;
    CLOSE C_GetAsignacionesStandby;

    WHILE Ln_Indice_Asig <= Lt_asignaciones.COUNT LOOP

      ln_idAsignacionSolicitud := Lt_asignaciones(Ln_Indice_Asig).ID_ASIGNACION_SOLICITUD;

    --SE SETEA A CAMBIO DE TURNO LA ASIGNACION
      UPDATE DB_SOPORTE.INFO_ASIGNACION_SOLICITUD SET CAMBIO_TURNO = 'S', USR_ULT_MOD='telcos', FE_ULT_MOD = SYSTIMESTAMP 
      WHERE ID_ASIGNACION_SOLICITUD = ln_idAsignacionSolicitud;

    --SE INGRESA UN SEGUIMIENTO PARA LA ASIGNACION
      INSERT INTO DB_SOPORTE.INFO_SEGUIMIENTO_ASIGNACION(
        ID_SEGUIMIENTO_ASIGNACION,
        ASIGNACION_SOLICITUD_ID,
        DETALLE,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        PROCEDENCIA,
        GESTIONADO,
        ESTADO
      )
      VALUES
      (
        DB_SOPORTE.SEQ_INFO_SEGUIMIENTO_ASIGN_SOL.NEXTVAL,
        ln_idAsignacionSolicitud,
        'cambio de turno autom�tico por standby',
        'telcos',
        sysdate,
        '127.0.0.1',
        'Interno',
        'S',
        'Activo'
      );

      Ln_Indice_Asig := Ln_Indice_Asig + 1;
    END LOOP;

  pv_mensaje_respuesta := 'OK';

  EXCEPTION
  WHEN OTHERS THEN
    pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

    db_general.gnrlpck_util.insert_error('Telcos +',
                                          'SPKG_ASIGNACION_SOLICITUD.P_ENVIAR_STANDBY_A_CAMB_TURNO',
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                        );

  END P_ENVIAR_STANDBY_A_CAMB_TURNO;

  FUNCTION GET_TRAZABILIDAD_TAREAS_USR (
       Pn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
   RETURN VARCHAR2
  IS
       CURSOR C_GetTrazabilidad (
          Cn_IdDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
       IS
          SELECT UPPER(D.NOMBRE_DEPARTAMENTO) AS DEPARTAMENTO,S.REF_ASIGNADO_NOMBRE
           FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION S, 
                DB_GENERAL.ADMI_DEPARTAMENTO d
          where S.ASIGNADO_ID = D.ID_DEPARTAMENTO
            AND S.DETALLE_ID = Cn_IdDetalle 
           ORDER BY S.FE_CREACION;

       Lv_StrSalida   VARCHAR2 (3000) := NULL;

    BEGIN

       FOR TRA IN C_GetTrazabilidad(Pn_IdDetalle)
       LOOP
         IF Lv_StrSalida IS NULL THEN
          Lv_StrSalida := TRA.DEPARTAMENTO || ':' ||TRA.REF_ASIGNADO_NOMBRE;
         END IF;
           Lv_StrSalida := Lv_StrSalida || ' | ' || TRA.DEPARTAMENTO || ':' || TRA.REF_ASIGNADO_NOMBRE;
       END LOOP;

       RETURN Lv_StrSalida;
   
  END GET_TRAZABILIDAD_TAREAS_USR;
 
  FUNCTION F_GET_FECHA_CREACION_TAREA (
       Pn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE, Pn_VecesIniciada NUMBER)
       RETURN VARCHAR2
    IS
       Lv_StrSalida   VARCHAR2 (3000) := NULL;
       lv_FechaInicioTarea    VARCHAR2(200);

    BEGIN
		
	    lv_FechaInicioTarea := '';
	    IF Pn_VecesIniciada IS NOT NULL AND Pn_VecesIniciada < 2 THEN
	    	SELECT fecha_ini INTO lv_FechaInicioTarea FROM (SELECT  TO_CHAR(its.FE_CREACION,'dd-mm-yyyy hh24:mi' ) as fecha_ini
		     FROM
		       DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its 
		     WHERE its.detalle_ID = Pn_IdDetalle
		       AND (LOWER(its.observacion) LIKE ('%tarea fue aceptada%')
		       OR LOWER(its.observacion) LIKE ('%tarea fue asignada%')
		       OR LOWER(its.observacion) LIKE ('%tarea fue iniciada%')
		       OR LOWER(its.observacion) LIKE ('%tarea asignada%'))
		     ORDER BY its.FE_CREACION DESC)
		     WHERE  rownum = 1;
	    END IF;
	    IF Pn_VecesIniciada IS NOT NULL AND Pn_VecesIniciada > 1 THEN
		    SELECT TO_CHAR(MIN( ittp1.FE_CREACION),'dd-mm-yyyy hh24:mi') INTO lv_FechaInicioTarea
	          FROM DB_SOPORTE.INFO_TAREA_TIEMPO_PARCIAL ittp1
	            WHERE ittp1.DETALLE_ID = Pn_IdDetalle
	            AND ittp1.estado = 'Iniciada'; 
	    END IF; 
	    Lv_StrSalida := lv_FechaInicioTarea;
	   
       RETURN Lv_StrSalida;
   
  END F_GET_FECHA_CREACION_TAREA; 

END SPKG_ASIGNACION_SOLICITUD;
/