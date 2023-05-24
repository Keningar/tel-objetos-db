CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_INFO_TAREA AS

  /*
  * Documentaci�n para TYPE 'Gr_Tareas_numera'.
  * Type para tareas
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  TYPE Gr_Tareas IS RECORD (
      OBSERVACION DB_SOPORTE.INFO_TAREA.OBSERVACION%TYPE,
      OBSERVACION_HISTORIAL DB_SOPORTE.INFO_TAREA.OBSERVACION_HISTORIAL%TYPE,
      DETALLE_ID  DB_SOPORTE.INFO_TAREA.DETALLE_ID%TYPE,
      LATITUD DB_SOPORTE.INFO_TAREA.LATITUD%TYPE,
      LONGITUD DB_SOPORTE.INFO_TAREA.LONGITUD%TYPE,
      USR_CREACION_DETALLE DB_SOPORTE.INFO_TAREA.USR_CREACION%TYPE,
      DETALLE_ID_RELACIONADO  DB_SOPORTE.INFO_TAREA.DETALLE_ID_RELACIONADO%TYPE,
      FE_CREACION_DETALLE VARCHAR2(20),
      FE_SOLICITADA VARCHAR2(20),
      TAREA_ID  DB_SOPORTE.INFO_TAREA.TAREA_ID%TYPE,
      NOMBRE_TAREA      DB_SOPORTE.INFO_TAREA.NOMBRE_TAREA%TYPE,
      DESCRIPCION_TAREA DB_SOPORTE.INFO_TAREA.DESCRIPCION_TAREA%TYPE,
      NOMBRE_PROCESO DB_SOPORTE.INFO_TAREA.NOMBRE_PROCESO%TYPE,
      ASIGNADO_ID  DB_SOPORTE.INFO_TAREA.ASIGNADO_ID%TYPE,
      ASIGNADO_NOMBRE DB_SOPORTE.INFO_TAREA.ASIGNADO_NOMBRE%TYPE,
      REF_ASIGNADO_ID DB_SOPORTE.INFO_TAREA.REF_ASIGNADO_ID%TYPE,
      REF_ASIGNADO_NOMBRE DB_SOPORTE.INFO_TAREA.REF_ASIGNADO_NOMBRE%TYPE,
      PERSONA_EMPRESA_ROL_ID  DB_SOPORTE.INFO_TAREA.PERSONA_EMPRESA_ROL_ID%TYPE,
      FE_CREACION_ASIGNACION VARCHAR2(20),
      DEPARTAMENTO_ID  DB_SOPORTE.INFO_TAREA.DEPARTAMENTO_ID%TYPE,
      TIPO_ASIGNADO DB_SOPORTE.INFO_TAREA.TIPO_ASIGNADO%TYPE,
      ESTADO DB_SOPORTE.INFO_TAREA.ESTADO%TYPE,
      DETALLE_HISTORIAL_ID DB_SOPORTE.INFO_TAREA.DETALLE_HISTORIAL_ID%TYPE,
      FE_CREACION VARCHAR2(20),
      USR_CREACION DB_SOPORTE.INFO_TAREA.USR_CREACION%TYPE,
      ASIGNADO_ID_HIS DB_SOPORTE.INFO_TAREA.ASIGNADO_ID_HIS%TYPE,
      DEPARTAMENTO_ORIGEN_ID  DB_SOPORTE.INFO_TAREA.DEPARTAMENTO_ORIGEN_ID%TYPE,
      NUMERO_TAREA DB_SOPORTE.INFO_TAREA.NUMERO_TAREA%TYPE,
      NUMERO DB_SOPORTE.INFO_TAREA.NUMERO%TYPE,
      REENVIAR_SYSCLOUD VARCHAR2(100),
      NOMBRE_ACTUALIZADO_POR VARCHAR2(2000),
      SE_MUESTRA_COORD_MANGA VARCHAR2(100),
      EMPRESA_TAREA VARCHAR2(100),
      CERRAR_TAREA VARCHAR2(1),
      NUMERO_TAREA_PADRE NUMBER,
      PERMITE_SEGUIMIENTO VARCHAR2(1),
      PERMITE_ANULAR VARCHAR2(1),
      ES_HAL VARCHAR2(1),
      MUESTRA_PESTANA_HAL VARCHAR2(1),
      ATENDER_ANTES VARCHAR2(1),
      MUESTRA_REPROGRAMAR VARCHAR2(100),
      PERMITE_FINALIZAR_INFORME VARCHAR2(1), 
      ES_DEPARTAMENTO VARCHAR2(100),
      PUNTO_ATENCION VARCHAR2(100),
      IDCASO DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
      ULT_FECHA_ASIGNACION VARCHAR2(20),
      DETALLE_SOL_CARACT NUMBER,
      ULT_TIPO_ASIGNADO DB_SOPORTE.INFO_DETALLE_ASIGNACION.TIPO_ASIGNADO%TYPE,
      FECHA_TIEMPO_PARCIAL VARCHAR2(4000),
      ID_DEP_COORDINADOR NUMBER,
      HAS_CARACTERISTICA_DETALLE VARCHAR2(2),
      TAREA_ANTERIOR VARCHAR2(4000),
      FECHA_CREACION_TAREA VARCHAR2(20),
      INFO_TAREA_ADIC VARCHAR2(4000),
      TRUNC_OBS VARCHAR2(1000),
      ID_SERVICIO_AFECT DB_COMERCIAL.INFO_PARTE_AFECTADA.AFECTADO_ID%TYPE,
      FECHA_TIEMPO_PARCIAL_CASO VARCHAR2(4000),
      DATA_CASO VARCHAR2(4000),
      ULT_ESTADO_CASO DB_SOPORTE.INFO_CASO_HISTORIAL.ESTADO%TYPE,
      CLIENTE_AFECTADO VARCHAR2(4000),
      ULTIMA_MILLA_SOPORTE VARCHAR2(4000),
      TAREA_INICIADA_MOVIL VARCHAR2(2),
      ES_INTERDEPARTAMENTAL VARCHAR2(2),
      INFO_SERV_AFECT_TAREA  VARCHAR2(4000),
      PROGRESO_TAREA   VARCHAR2(4000),
      NUMERO_ROW NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Gr_Tareas_numera'.
  * Type para migrar tareas
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  TYPE Gr_Tareas_migra IS RECORD (

      DETALLE_ID  DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
      LATITUD DB_SOPORTE.INFO_DETALLE.LATITUD%TYPE,
      LONGITUD DB_SOPORTE.INFO_DETALLE.LONGITUD%TYPE,
      USR_CREACION_DETALLE DB_SOPORTE.INFO_DETALLE.USR_CREACION%TYPE,
      DETALLE_ID_RELACIONADO  DB_SOPORTE.INFO_DETALLE.DETALLE_ID_RELACIONADO%TYPE,
      FE_CREACION_DETALLE DB_SOPORTE.INFO_DETALLE.FE_CREACION%TYPE, 
      FE_SOLICITADA DB_SOPORTE.INFO_DETALLE.FE_SOLICITADA%TYPE, 
      OBSERVACION DB_SOPORTE.INFO_DETALLE.OBSERVACION%TYPE,
      DETALLE_HIPOTESIS_ID DB_SOPORTE.INFO_DETALLE.DETALLE_HIPOTESIS_ID%TYPE,
      ID_TAREA  DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE,
      NOMBRE_TAREA      DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
      DESCRIPCION_TAREA DB_SOPORTE.ADMI_TAREA.DESCRIPCION_TAREA%TYPE,
      NOMBRE_PROCESO DB_SOPORTE.ADMI_PROCESO.NOMBRE_PROCESO%TYPE,
      PROCESO_ID DB_SOPORTE.ADMI_TAREA.PROCESO_ID%TYPE,
      ASIGNADO_ID  DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE,
      ASIGNADO_NOMBRE DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_NOMBRE%TYPE,
      REF_ASIGNADO_ID DB_SOPORTE.INFO_DETALLE_ASIGNACION.REF_ASIGNADO_ID%TYPE,
      REF_ASIGNADO_NOMBRE DB_SOPORTE.INFO_DETALLE_ASIGNACION.REF_ASIGNADO_NOMBRE%TYPE,
      PERSONA_EMPRESA_ROL_ID  DB_SOPORTE.INFO_DETALLE_ASIGNACION.PERSONA_EMPRESA_ROL_ID%TYPE,
      ID_DETALLE_ASIGNACION DB_SOPORTE.INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE,
      FE_CREACION_ASIGNACION DB_SOPORTE.INFO_DETALLE_ASIGNACION.FE_CREACION%TYPE, 
      DEPARTAMENTO_ID  DB_SOPORTE.INFO_DETALLE_ASIGNACION.DEPARTAMENTO_ID%TYPE,
      TIPO_ASIGNADO DB_SOPORTE.INFO_DETALLE_ASIGNACION.TIPO_ASIGNADO%TYPE,
      CANTON_ID  DB_SOPORTE.INFO_DETALLE_ASIGNACION.CANTON_ID%TYPE,
      ESTADO DB_SOPORTE.INFO_DETALLE_HISTORIAL.ESTADO%TYPE,
      ID_DETALLE_HISTORIAL DB_SOPORTE.INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE,
      FE_CREACION_HIS DB_SOPORTE.INFO_DETALLE_HISTORIAL.FE_CREACION%TYPE, 
      USR_CREACION_HIS DB_SOPORTE.INFO_DETALLE_HISTORIAL.USR_CREACION%TYPE,
      OBSERVACION_HISTORIAL DB_SOPORTE.INFO_DETALLE_HISTORIAL.OBSERVACION%TYPE,
      DEPARTAMENTO_ORIGEN_ID  DB_SOPORTE.INFO_DETALLE_HISTORIAL.DEPARTAMENTO_ORIGEN_ID%TYPE,
      PERSONA_EMPRESA_ROL_ID_HIS  DB_SOPORTE.INFO_DETALLE_HISTORIAL.PERSONA_EMPRESA_ROL_ID%TYPE,
      ASIGNADO_ID_HIS DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE,
      NUMERO_TAREA DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
      USR_CREACION DB_SOPORTE.INFO_TAREA.USR_CREACION%TYPE,
      FE_CREACION DB_SOPORTE.INFO_TAREA.FE_CREACION%TYPE,
      IP_CREACION DB_SOPORTE.INFO_TAREA.IP_CREACION%TYPE,
      USR_ULT_MOD DB_SOPORTE.INFO_TAREA.USR_ULT_MOD%TYPE,
      FE_ULT_MOD DB_SOPORTE.INFO_TAREA.FE_ULT_MOD%TYPE,
      NUMERO DB_SOPORTE.INFO_TAREA.NUMERO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Gr_Tareas_numera'.
  * Type para numerar tareas
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  TYPE Gr_Tareas_numera IS RECORD (

      ID_INFO_TAREA  DB_SOPORTE.INFO_TAREA.ID_INFO_TAREA%TYPE,
      FE_CREACION_DETALLE DB_SOPORTE.INFO_TAREA.FE_CREACION_DETALLE%TYPE
  );

  /*
  * Documentaci�n para PROCEDURE 'P_CREA_INFO_TAREA'.
  * Procedimiento que ingresa una tarea en INFO_TAREA seg�n id detalle
  * PARAMETROS:
  * @Param NUMBER           Pn_id_detalle   ->   id detalle de la tarea
  * @Param VARCHAR2         Pv_usr_ult_mod  ->   usuario �ltima modificaci�n
  * @Param VARCHAR2 OUT     Pv_Status       ->  estado de ejecuci�n
  * @Param VARCHAR2 OUT     Pv_Message      ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_CREA_INFO_TAREA(
                             Pn_id_detalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
                             Pv_usr_creacion IN DB_SOPORTE.INFO_TAREA.USR_CREACION%TYPE, 
                             Pv_Status   OUT VARCHAR2,
                             Pv_Message  OUT VARCHAR2);

  /*
  * Documentaci�n para PROCEDURE 'P_UPDATE_TAREA'.
  * Procedimiento que actualiza una tarea en INFO_TAREA seg�n id detalle
  * PARAMETROS:
  * @Param NUMBER           Pn_id_detalle   ->   id detalle de la tarea
  * @Param VARCHAR2         Pv_usr_ult_mod  ->   usuario �ltima modificaci�n
  * @Param VARCHAR2 OUT     Pv_Status       ->  estado de ejecuci�n
  * @Param VARCHAR2 OUT     Pv_Message      ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_UPDATE_TAREA( Pn_id_detalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
                            Pv_usr_ult_mod IN DB_SOPORTE.INFO_TAREA.USR_ULT_MOD%TYPE,
                            Pv_Status   OUT VARCHAR2,
                            Pv_Message  OUT VARCHAR2);

  /*
  * Actualizaci�n: Se realiza correcci�n para incluir comillas dobles en la observaci�n:
  *                En el string de observaci�n las comillas dobles '"' se reemplazan por '*fff'
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.1 27-07-2020
  *
  * Documentaci�n para PROCEDURE 'P_REPORTE_TAREAS'.
  * Procedimiento que obtiene las tareas seg�n los par�metros recibidos
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pcl_Json          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pcl_JsonRespuesta -> respuesta de registros en formato json
  * @Param VARCHAR2 OUT Pn_Total          -> total de registros
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se modifica el filtro por cliente, para evitar la consulta a la info_comunicacion.
  */
  PROCEDURE P_REPORTE_TAREAS(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2);

  /*
  * Actualizaci�n: Se realiza optimizaci�n para generar numeraci�n con la secuencia DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA 
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.1 25-01-2021
  *
  * Documentaci�n para PROCEDURE 'P_SYNC_TAREAS_NUEVAS_DIA'.
  * Procedimiento que registra tareas del d�a
  *
  * PARAMETROS:
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta   ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_SYNC_TAREAS_NUEVAS_DIA(pv_mensaje_respuesta OUT VARCHAR2);

  /*
  * Documentaci�n para PROCEDURE 'P_SYNC_TAREAS_EXISTENTES'.
  * Procedimiento que registra tareas del d�a
  *
  * PARAMETROS:
  * @Param NUMBER IN        pn_dias_actualiza      ->  cantidad de d�as hacia atras que se desea actualizar
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta   ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_SYNC_TAREAS_EXISTENTES(pn_dias_actualiza IN NUMBER, 
                                         pv_mensaje_respuesta OUT VARCHAR2);



  /*
  * Documentaci�n para PROCEDURE 'P_MIGRAR_TAREAS'.
  * Procedimiento que registra tareas seg�n el a�o desde enviado por par�metro
  *
  * PARAMETROS:
  * @Param NUMBER           pn_anio_desde          ->   anio desde para numerar tareas
  * @Param VARCHAR2         pv_por_estado          ->   estado de tareas a migrar
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta   ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_MIGRAR_TAREAS(pn_anio_desde NUMBER, 
                            pv_por_estado VARCHAR2, 
                            pv_mensaje_respuesta OUT VARCHAR2);

  /*
  * Actualizaci�n: Se realiza optimizaci�n para generar numeraci�n con la secuencia DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA 
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.1 25-01-2021
  *
  * Documentaci�n para PROCEDURE 'P_NUMERAR_INFO_TAREA'.
  * Procedimiento que registra una tarea si no existe o actualiza registro en INFO_TAREA
  *
  * PARAMETROS:
  * @Param NUMBER           pn_anio                ->   a�o desde para numerar tareas
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta   ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_NUMERAR_INFO_TAREA(pn_anio NUMBER, 
                                 pv_mensaje_respuesta OUT VARCHAR2);

  /*
  * Documentaci�n para PROCEDURE 'P_REGISTRA_EN_INFO_TAREA'.
  * Procedimiento que registra una tarea si no existe o actualiza registro en INFO_TAREA
  *
  * PARAMETROS:
  * @Param Gr_Tareas_migra  pg_tareas               ->  type de tareas
  * @Param VARCHAR2         pv_valida_existe        ->  bandera que indica si valida que existe registro
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta    ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_REGISTRA_EN_INFO_TAREA(pg_tareas Gr_Tareas_migra, 
                                     pv_valida_existe VARCHAR2, 
                                     pv_mensaje_respuesta OUT VARCHAR2);
  /*
  * Documentaci�n para PROCEDURE 'P_ACTUALIZA_EN_INFO_TAREA'.
  * Procedimiento que actualiza en INFO_TAREA la tarea enviada por parametro
  *
  * PARAMETROS:
  * @Param Gr_Tareas_migra  pg_tareas               ->  type de tareas
  * @Param VARCHAR2 OUT     pv_mensaje_respuesta    ->  mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  */
  PROCEDURE P_ACTUALIZA_EN_INFO_TAREA(pg_tareas Gr_Tareas_migra, 
                                      pv_mensaje_respuesta OUT VARCHAR2);

  /*
  * Documentaci�n para FUNCI�N 'F_GET_REENVIAR_SYSCLOUD'.
  * Funci�n que verifca si se reenvia a syscloud
  *
  * PARAMETROS:
  * @Param VARCHAR2  Pv_numero_tarea            ->  n�mero de la tarea
  * @Param VARCHAR2  Pv_Usr_creacion_detalle    ->  usuario creaci�n detalle
  * @Param NUMBER  Pn_Departamento_asignado     ->  departamento asignado
  * @Param VARCHAR2  Pv_Id_departamento_sesion  ->  departamento en sesi�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_REENVIAR_SYSCLOUD(
                                      Pv_numero_tarea VARCHAR2,
                                      Pv_Usr_creacion_detalle  VARCHAR2,  
                                      Pn_Departamento_asignado NUMBER, 
                                      Pv_Id_departamento_sesion VARCHAR2)
  RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_NOMB_ACTUALIZADO_POR'.
  * Funci�n que obtiene el nombre de usuario que actualiza
  *
  * PARAMETROS:
  * @Param CLOB  Pv_obs_historial              ->  observaci�n de historial
  * @Param VARCHAR2  Pv_Usr_creacion_historial ->  usuario creaci�n historial
  * @Param CLOB  Pv_msg_reasigna_aut_camb_dep  ->  mensaje reasignar cambio departamento
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_NOMB_ACTUALIZADO_POR(
                                       Pv_obs_historial CLOB,
                                       Pv_Usr_creacion_historial  VARCHAR2,  
                                       Pv_msg_reasigna_aut_camb_dep CLOB)
  RETURN VARCHAR2;

   /*
  * Documentaci�n para FUNCI�N 'F_GET_SI_MUESTRA_COORD_MANGA'.
  * Funci�n que verifica si muestra la coordenada manga
  * PARAMETROS:
  * @Param NUMBER  Pn_Id_tarea ->  id de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_SI_MUESTRA_COORD_MANGA(Pn_Id_tarea NUMBER)
    RETURN VARCHAR2;

   /*
  * Documentaci�n para FUNCI�N 'F_GET_EMPRESA_DE_TAREA'.
  * Funci�n que obtiene la empresa de la tarea
  * PARAMETROS:
  * @Param NUMBER  Pn_numero_tarea ->  n�mero de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_EMPRESA_DE_TAREA(Pn_numero_tarea NUMBER)
    RETURN VARCHAR2;

   /*
  * Documentaci�n para FUNCI�N 'F_GET_CERRAR_TAREA'.
  * Funci�n que verifica si se permite cerrar tarea
  * PARAMETROS:
  * @Param NUMBER  Pn_Id_detalle ->  detalle id relacionado de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_CERRAR_TAREA(Pn_Id_detalle NUMBER)
    RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_TAREA_PADRE'.
  * Funci�n que obtiene la tarea padre de la tarea
  * PARAMETROS:
  * @Param NUMBER  Pn_Detalle_id_relacionado ->  detalle id relacionado de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_TAREA_PADRE(Pn_Detalle_id_relacionado NUMBER)
    RETURN NUMBER;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_PERMITE_SEGUIMIENTO'.
  * Funci�n que verifica si se permite ingresar seguimientos
  * PARAMETROS:
  * @Param VARCHAR2  Pv_Id_departamento_sesion ->  id departamento sesi�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_PERMITE_SEGUIMIENTO(Pv_Id_departamento_sesion VARCHAR2) 
    RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_PERMITE_ANULAR'.
  * Funci�n que verifica si permite anular tarea
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_Id_detalle              ->  detalle id de la tarea
  * @Param VARCHAR2  Pv_Estado             ->  estado de la tarea
  * @Param VARCHAR2  Pv_Id_usuario  ->  id de usuario sesi�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_PERMITE_ANULAR(
                                Pn_Id_detalle NUMBER,
                                Pv_Estado VARCHAR2,
                                Pv_Id_usuario VARCHAR2)
    RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_ES_HAL'.
  * Funci�n que verifica si la tarea pertenece a HAL
  * PARAMETROS:
  * @Param NUMBER  Pn_numero_tarea  ->  n�mero de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_ES_HAL(Pn_numero_tarea NUMBER)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_ATENDER_ANTES'.
  * Funci�n que verifica si se debe atender antes la tarea
  * PARAMETROS:
  * @Param NUMBER  Pn_id_tarea  ->  id de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_MUESTRA_PESTANA_HAL(Pn_id_tarea NUMBER)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_ATENDER_ANTES'.
  * Funci�n que verifica si se debe atender antes la tarea
  * PARAMETROS:
  * @Param  NUMBER Pn_numero_tarea  ->  n�mero de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_ATENDER_ANTES(Pn_numero_tarea NUMBER)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_MUESTRA_REPROGRAMAR'.
  * Funci�n que verifica si se muestra bot�n de reprogramar tarea
  * PARAMETROS:
  * @Param VARCHAR2  Pv_estado                 ->  estado de la tarea
  * @Param VARCHAR2  Pv_Id_departamento_sesion ->  id departamento sesi�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_MUESTRA_REPROGRAMAR(
                                     Pv_estado VARCHAR2, 
                                     Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_PERMITE_FINALIZAR_INFORM'.
  * Funci�n que verifica si permite finalizar informe
  *
  * PARAMETROS:
  * @Param NUMBER  Pn_detalle_id              ->  detalle id de la tarea
  * @Param VARCHAR2  Pv_nombreTarea             ->  nombre de la tarea
  * @Param VARCHAR2  Pv_Id_departamento_sesion  ->  id departamento sesi�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_PERMITE_FINALIZAR_INFORM(
                                          Pn_detalle_id NUMBER,
                                          Pv_nombreTarea VARCHAR2,
                                          Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_ES_DEPARTAMENTO'.
  * Funci�n que verifica si la tarea es asignada a departamento en sesi�n
  *
  * PARAMETROS:
  * @Param varchar2  Pv_Tipo_asignado           ->  tipo de asignado en la tarea
  * @Param number  Pn_Asignado_id             ->  id del departamento asignado
  * @Param number  Pn_Persona_empresa_rol_id  ->  persona empresa rol id de la tarea
  * @Param varchar2  Pv_VerTodasLasTareas       -> bandera ver todas las tareas
  * @Param varchar2  Pv_Dptos_empleado          ->  departamentos del empleado en sesi�n
  * @Param varchar2  Pv_Id_departamento_sesion  ->  Fecha de creaci�n del detalle de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_ES_DEPARTAMENTO(Pv_Tipo_asignado VARCHAR2,
                                 Pn_Asignado_id NUMBER,
                                 Pn_Persona_empresa_rol_id NUMBER,
                                 Pv_VerTodasLasTareas VARCHAR2,
                                 Pv_Dptos_empleado VARCHAR2, 
                                 Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2;

  /*
  * Documentaci�n para FUNCI�N 'F_GET_NUMERACION_INFO_TAREA'.
  * Funci�n que permite generar numeraci�n para nuevos registros en la tabla INFO_TAREA
  *
  * PARAMETROS:
  * @Param timestamp  pd_fe_creacion_detalle  ->  Fecha de creaci�n del detalle de la tarea
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 08-07-2020
  *
  * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.1 02-02-2021 - Se retorna el valor por defecto en la excepci�n.
  */
  FUNCTION F_GET_NUMERACION_INFO_TAREA(pd_fe_creacion_detalle  DB_SOPORTE.INFO_TAREA.FE_CREACION_DETALLE%TYPE)
      RETURN VARCHAR2;
  /*
  * Documentaci�n para Procedimiento 'P_GET_FIBRA_TAREA'.
  * Funci�n que permite obtener informacion de fibra de una tarea por su idComunicacion o idDetalle
  *
  * PARAMETROS:
  * @Param Number Pn_IdComunicacion -->Id de comunicaci�n
  * @Param Number Pn_IdDetalle -->Id de detalle
  * @Param Clob Pv_Retorno -->Variable que lleva el json con la informaci�n obtenida
  * @author Edgar Pin Villavicencio <epin@telconet.ec>
  * @version 1.0 28-11-2020
  */      
  PROCEDURE P_GET_FIBRA_TAREA(Pn_IdComunicacion NUMBER,
                             Pn_IdDetalle      NUMBER,
                             Pv_Retorno        OUT CLOB,
                             Pv_Error          OUT VARCHAR2 ) ;     

  /*
  * Documentaci�n para Procedimiento 'P_REINICIAR_NUMERACION'.
  * Funci�n que permite reiniciar la numeraci�n de la tabla info_tarea
  *
  * PARAMETROS:
  * @Param VARCHAR2 pv_mensaje_respuesta --> Retorna respuesta si proceso fue exitoso o no
  * @author Andr�s Montero H <amontero@telconet.ec>
  * @version 1.0 25-01-2021
  */      
  PROCEDURE P_REINICIAR_NUMERACION(pv_mensaje_respuesta OUT VARCHAR2);

  /**
   * Documentaci�n para Procedimiento 'P_CREA_ACTIVIDAD_AUTOMATICA'.
   * Procedimiento que permite crear una actividad de manera autom�tica
   *
   * @param Pr_RegInfoCreaActividad IN DB_SOPORTE.SPKG_TYPES.Lr_InfoCreaActividad Tipo de dato que almacena la informaci�n para crear una actividad
   * @param Pv_Status               OUT VARCHAR2 Status de procedimiento
   * @param Pv_MsjError             OUT VARCHAR2 Mensaje de error
   * @param Pn_IdComunicacionTarea  OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE Id comunicaci�n de la tarea creada
   * @param Pn_IdDetalleTarea       OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE Id detalle de la tarea creada
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 30-09-2021
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 01-12-2021 Se modifica el valor del c�digo empresa asociado al departamento para que �ste sea de acuerdo a la empresa del 
   *                         empleado asignado
   */   
  PROCEDURE P_CREA_ACTIVIDAD_AUTOMATICA(
    Pr_RegInfoCreaActividad IN DB_SOPORTE.SPKG_TYPES.Lr_InfoCreaActividad,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdComunicacionTarea  OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalleTarea       OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE);

  /**
   * Documentaci�n para Procedimiento 'P_CREA_ACTIVIDAD_PARAMETRIZADA'.
   * Procedimiento que permite crear una actividad de manera autom�tica de acuerdo a los par�metros enviados
   *
   * @param Pv_ParamCabNombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE Nombre de par�metro con la informaci�n de la tarea
   * @param Pv_ParamDetValor1Proceso    IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE Valor del proceso a ejecutar
   * @param Pv_ParamCreacionTarea       IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE Nombre de par�metro para la creaci�n de la tarea
   * @param Pv_ParamAsignacionTarea     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE Nombre de par�metro para la asignaci�n de la tarea
   * @param Pv_ObservAdicionalTarea     IN VARCHAR2 Observaci�n adicional
   * @param Pv_Status                   OUT VARCHAR2 Status de procedimiento
   * @param Pv_MsjError                 OUT VARCHAR2 Mensaje de error
   * @param Pn_IdComunicacionTarea      OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE Id comunicaci�n de la tarea creada
   * @param Pn_IdDetalleTarea           OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE Id detalle de la tarea creada
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 30-11-2021
   */ 
  PROCEDURE P_CREA_ACTIVIDAD_PARAMETRIZADA(
    Pv_ParamCabNombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
    Pv_ParamDetValor1Proceso    IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    Pv_ParamCreacionTarea       IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Pv_ParamAsignacionTarea     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    Pv_ObservAdicionalTarea     IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Pn_IdComunicacionTarea      OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalleTarea           OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE);
/*
  * Documentaci�n para Procedimiento 'P_INFO_TAREA_INDISPONIBILIDAD'.
  * Procedimiento que permite reiniciar la numeraci�n de la tabla info_tarea
  *
  * PARAMETROS:
  * @Param VARCHAR2 pv_mensaje_respuesta --> Retorna respuesta si proceso fue exitoso o no
  * @author Jose Daniel Giler <jdgiler@telconet.ec>
  * @version 1.0 24-11-2021
  */      
  PROCEDURE P_INFO_TAREA_INDISPONIBILIDAD(pn_detalle_id_pn_caso_id varchar2,
                                          pv_tipo_pv_INDISPONIBILIDAD varchar2,
                                          pn_TIEMPO_AFECTACION number,
                                          pv_masivo varchar2,
                                          pv_OLT_pv_PUERTO varchar2,
                                          pv_CAJA_pv_SPLITTER varchar2,
                                          pn_CLIENTES_pn_RESPONSABLE varchar2,
                                          pv_OBSERVACION varchar2,
                                          pv_USR_CREACION_pv_IP_CREACION varchar2,
                                          pv_mensaje_respuesta OUT VARCHAR2);

END SPKG_INFO_TAREA;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_INFO_TAREA AS
  --


  PROCEDURE P_CREA_INFO_TAREA(
                             Pn_id_detalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
                             Pv_usr_creacion IN DB_SOPORTE.INFO_TAREA.USR_CREACION%TYPE, 
                             Pv_Status   OUT VARCHAR2,
                             Pv_Message  OUT VARCHAR2)
    IS
    --VARIABLES

      Lg_tareas             Gr_Tareas_migra;
      ln_existeDetalle      NUMBER;
      lv_respuesta_registra VARCHAR2(500) := '';

    BEGIN

      Pv_Status  := 'ok';
      Pv_Message := 'Proceso ejecutado correctamente';

      --CONSULTA DATOS
      BEGIN
      SELECT
        IDE.ID_DETALLE AS DETALLE_ID,
        IDE.LATITUD AS LATITUD,
        IDE.LONGITUD AS LONGITUD,
        IDE.USR_CREACION AS USR_CREACION_DETALLE,
        IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO,
        IDE.FE_CREACION AS FE_CREACION_DETALLE, 
        IDE.FE_SOLICITADA AS FE_SOLICITADA,
        IDE.OBSERVACION AS OBSERVACION,
        IDE.DETALLE_HIPOTESIS_ID AS DETALLE_HIPOTESIS_ID,
        ATA.ID_TAREA AS ID_TAREA,
        ATA.NOMBRE_TAREA AS NOMBRE_TAREA,
        ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA,
        APR.NOMBRE_PROCESO AS NOMBRE_PROCESO,
        ATA.PROCESO_ID AS PROCESO_ID,
        IDA.ASIGNADO_ID AS ASIGNADO_ID,
        IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE,
        IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID,
        IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE,
        IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID,
        IDA.ID_DETALLE_ASIGNACION AS ID_DETALLE_ASIGNACION,
        IDA.FE_CREACION AS FE_CREACION_ASIGNACION,
        IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID,
        IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO,
        IDA.CANTON_ID AS CANTON_ID,
        IDH.ESTADO AS ESTADO,
        IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL,
        IDH.FE_CREACION AS FE_CREACION,
        IDH.USR_CREACION AS USR_CREACION,
        IDH.OBSERVACION AS OBSERVACION_HISTORIAL,
        IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID,
        IDH.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID_HIS,
        IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS,
        (SELECT MIN(infoComunicacion.ID_COMUNICACION) 
        FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion 
        WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA,
        Pv_usr_creacion AS USR_CREACION,
        SYSDATE AS FE_CREACION,
        '127.0.0.1' AS IP_CREACION,
        Pv_usr_creacion AS USR_ULT_MOD,
        SYSDATE AS FE_ULT_MOD,
        NULL AS NUMERO
      INTO 

      Lg_tareas

      FROM 
        DB_SOPORTE.INFO_DETALLE IDE
        JOIN DB_SOPORTE.ADMI_TAREA ATA ON IDE.TAREA_ID = ATA.ID_TAREA
        JOIN DB_SOPORTE.ADMI_PROCESO APR ON ATA.PROCESO_ID = APR.ID_PROCESO
        JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ON IDH.DETALLE_ID = IDE.ID_DETALLE

      WHERE 
        IDE.ID_DETALLE                =  Pn_id_detalle

        AND IDA.ID_DETALLE_ASIGNACION =  (SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) 
                                          FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX 
                                          WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) 

        AND IDH.ID_DETALLE_HISTORIAL  =  (SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) 
                                          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
                                          WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)
      ;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      Pv_Status  := 'error';
      Pv_Message := 'No se pudo insertar registro en INFO_TAREA porque no se encontro tarea con id_detalle:'||Pn_id_detalle;
      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_CREA_INFO_TAREA',
                                            Pv_Message,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
      END;
      IF Pv_Status = 'ok' THEN
        --INGRESA EL REGISTRO
        P_REGISTRA_EN_INFO_TAREA(Lg_tareas, 'S', lv_respuesta_registra);
      END IF;
      COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
      Pv_Message := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_CREA_INFO_TAREA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_CREA_INFO_TAREA;




  PROCEDURE P_REPORTE_TAREAS(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2) IS

      --Cursor para obtener el n�mero de caso
      CURSOR C_ObtenerCaso(Cn_IdDetalle NUMBER) IS
          SELECT  ICA.ID_CASO,
                  ICA.NUMERO_CASO
              FROM DB_SOPORTE.INFO_DETALLE           IDE,
                  DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI,
                  DB_SOPORTE.INFO_CASO              ICA
          WHERE IDE.DETALLE_HIPOTESIS_ID = IDHI.ID_DETALLE_HIPOTESIS
            AND IDHI.CASO_ID             = ICA.ID_CASO
            AND IDE.ID_DETALLE           = Cn_IdDetalle
            AND ROWNUM < 2;

      --Cursor para obtener los afectados
      CURSOR C_ObtenerAfectados(Cn_IdDetalle    NUMBER,
                                Cv_TipoAfectado VARCHAR2,
                                Cn_CasoId       NUMBER) IS

          (SELECT IPAFE.AFECTADO_ID,
                IPAFE.AFECTADO_NOMBRE,
                IPAFE.AFECTADO_DESCRIPCION,
                IPU.DIRECCION
              FROM DB_SOPORTE.INFO_PARTE_AFECTADA    IPAFE,
                  DB_SOPORTE.INFO_CRITERIO_AFECTADO ICAFE,
                  DB_SOPORTE.INFO_DETALLE           IDE,
                  DB_COMERCIAL.INFO_PUNTO           IPU
          WHERE IPAFE.CRITERIO_AFECTADO_ID = ICAFE.ID_CRITERIO_AFECTADO
            AND IPAFE.DETALLE_ID           = ICAFE.DETALLE_ID
            AND IPAFE.DETALLE_ID           = IDE.ID_DETALLE
            AND ICAFE.DETALLE_ID           = IDE.ID_DETALLE
            AND IPAFE.AFECTADO_ID          = IPU.ID_PUNTO
            AND LOWER(IPAFE.TIPO_AFECTADO) = LOWER(Cv_TipoAfectado)
            AND IDE.ID_DETALLE             = Cn_IdDetalle)
          UNION
          (SELECT IPU.ID_PUNTO AS AFECTADO_ID,
                  IPU.LOGIN    AS AFECTADO_NOMBRE,
                  NVL(IPER.RAZON_SOCIAL,IPER.APELLIDOS||' '||IPER.NOMBRES) AS AFECTADO_DESCRIPCION,
                  IPU.DIRECCION
              FROM DB_COMERCIAL.INFO_PUNTO               IPU,
                  DB_COMUNICACION.INFO_COMUNICACION     ICO,
                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERO,
                  DB_COMERCIAL.INFO_PERSONA             IPER
          WHERE IPU.ID_PUNTO         = ICO.PUNTO_ID
            AND IPERO.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
            AND IPERO.PERSONA_ID     = IPER.ID_PERSONA
            AND ICO.ID_COMUNICACION =
              (SELECT MIN(ICOMIN.ID_COMUNICACION)
                  FROM DB_COMUNICACION.INFO_COMUNICACION ICOMIN
                WHERE ICOMIN.DETALLE_ID = Cn_IdDetalle
                  AND ICOMIN.PUNTO_ID IS NOT NULL)
            AND IPU.ESTADO IN ('Activo','In-Corte'))
          UNION
          (SELECT IPAFE.AFECTADO_ID,
                  IPAFE.AFECTADO_NOMBRE,
                  IPAFE.AFECTADO_DESCRIPCION,
                  IPU.DIRECCION
              FROM DB_SOPORTE.INFO_PARTE_AFECTADA IPAFE,
                  DB_COMERCIAL.INFO_PUNTO        IPU
          WHERE IPAFE.AFECTADO_ID          = IPU.ID_PUNTO
            AND LOWER(IPAFE.TIPO_AFECTADO) = LOWER(Cv_TipoAfectado)
            AND DETALLE_ID =
              (SELECT MIN(IDE.ID_DETALLE)
                  FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI,
                      DB_SOPORTE.INFO_DETALLE           IDE
                WHERE IDHI.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID
                  AND IDHI.CASO_ID              = Cn_CasoId));

      --Cursor para obtener los nombres completo de un usuario
      CURSOR C_ObtenerDatosUsuario(Cv_Login VARCHAR2, Cv_Estado VARCHAR2) IS
          SELECT INITCAP(IPE.NOMBRES||' '||IPE.APELLIDOS) NOMBRES
              FROM DB_COMERCIAL.INFO_PERSONA             IPE,
                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERO
          WHERE IPE.ID_PERSONA      = IPERO.PERSONA_ID
            AND LOWER(IPERO.ESTADO) = LOWER(Cv_Estado)
            AND LOWER(IPE.LOGIN)    = LOWER(Cv_Login)
            AND ROWNUM < 2;

      --Cursor para obtener los contactos de los puntos afectados
      CURSOR C_ObtenerContactos(Cn_IdPunto         NUMBER,
                                Cv_Estado          VARCHAR2,
                                Cn_IdFormaContacto NUMBER) IS
          (SELECT d.VALOR
              FROM DB_COMERCIAL.info_persona                a,
                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL    b,
                  DB_COMERCIAL.info_punto                  c,
                  DB_COMERCIAL.info_persona_forma_contacto d
          WHERE c.PERSONA_EMPRESA_ROL_ID  = b.ID_PERSONA_ROL
            AND b.PERSONA_ID               = a.ID_PERSONA
            AND d.PERSONA_ID               = a.ID_PERSONA
            AND c.ID_PUNTO                 = Cn_IdPunto
            AND d.ESTADO                   = Cv_Estado
            AND d.FORMA_CONTACTO_ID NOT IN (Cn_IdFormaContacto))
          UNION
          (SELECT b.VALOR
              FROM DB_COMERCIAL.info_punto               c,
                  DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO b
          WHERE b.PUNTO_ID          = c.ID_PUNTO
            AND c.ID_PUNTO          = Cn_IdPunto
            AND b.estado            = Cv_Estado
            AND b.FORMA_CONTACTO_ID NOT IN (Cn_IdFormaContacto));

      --Cursor para obtener el correo del usuario quien genera el reporte
      CURSOR C_ObtenerCorreoUsuario(Cv_Estado     VARCHAR2,
                                    Cv_Login      VARCHAR2) IS
          SELECT (LISTAGG(NVEE.MAIL_CIA,',')
                  WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
              FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
          WHERE NVEE.LOGIN_EMPLE   = Cv_Login
            AND UPPER(NVEE.ESTADO) = UPPER(Cv_Estado);

      --Cursor para obtener el valor de configuraci�n
      CURSOR C_ParametrosConfiguracion(Cv_NombreParametro VARCHAR2,
                                      Cv_Modulo          VARCHAR2,
                                      Cv_Descripcion     VARCHAR2) IS
      SELECT APCDET.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
              DB_GENERAL.ADMI_PARAMETRO_DET APCDET
      WHERE APCAB.ID_PARAMETRO = APCDET.PARAMETRO_ID
        AND UPPER(APCAB.ESTADO)    = 'ACTIVO'
        AND UPPER(APCDET.ESTADO)   = 'ACTIVO'
        AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APCAB.MODULO           = Cv_Modulo
        AND APCDET.DESCRIPCION     = Cv_Descripcion;

      --Variables para el query din�mico
      Lrf_ReporteTareas       SYS_REFCURSOR;
      Lrf_JsonTareas          SYS_REFCURSOR;
      Lv_QuerySelect          CLOB;
      Lv_Queryfrom            VARCHAR2(1000) := '';
      Lv_From                 VARCHAR2(1000) := '';
      Lv_QueryWhere           VARCHAR2(4000) := '';
      Lv_Where                VARCHAR2(1000) := '';
      Lcl_QueryTareas         CLOB;
      Lr_Tareas               Gr_Tareas;
      Lr_JsonTareas           Gr_Tareas;
      Lf_Archivo              UTL_FILE.FILE_TYPE;
      Lv_QueryNewCampos1      VARCHAR2(4000) := '';
      Lv_QueryNewCampos2      VARCHAR2(4000) := '';

      --Variables de apoyo
      Lb_FiltroCuadrilla      BOOLEAN := FALSE;
      Lv_Estado               VARCHAR2(60) := '''Finalizada'','||'''Cancelada'','||'''Rechazada'','||'''Anulada''';
      Lt_NumeroCaso           DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE;
      Lt_IdCaso               DB_SOPORTE.INFO_CASO.ID_CASO%TYPE;
      Lv_Nombres              VARCHAR2(100);
      Lv_Para                 VARCHAR2(500);
      Lcl_AfectadoNombre      CLOB;
      Lcl_AfectadoDescripcion CLOB;
      Lcl_AfectadoDireccion   CLOB;
      Lcl_FormaContacto       CLOB;

      -- Variables de configuraci�n
      Lv_NombreArchivo             VARCHAR2(100) := 'ReporteTareas_'||to_char(SYSDATE,'RRRRMMDDHH24MISS')||'.csv';
      Lv_NombreParametro           VARCHAR2(25)  := 'PARAMETROS_REPORTE_TAREAS';
      Lv_Modulo                    VARCHAR2(7)   := 'SOPORTE';
      Lv_ParametroRemitente        VARCHAR2(16)  := 'CORREO_REMITENTE';
      Lv_ParametroNombreDirectorio VARCHAR2(25)  := 'NOMBRE_DIRECTORIO_REPORTE';
      Lv_ParametroRutaDirectorio   VARCHAR2(24)  := 'RUTA_DIRECTORIO_REPORTES';
      Lv_ParametroComandoReporte   VARCHAR2(15)  := 'COMANDO_REPORTE';
      Lv_ParametroExtensionReporte VARCHAR2(17)  := 'EXTENSION_REPORTE';
      Lv_ParametroPlantilla        VARCHAR2(22)  := 'PLANTILLA_NOTIFICACION';
      Lv_ParametroAsuntoCorreo     VARCHAR2(13)  := 'ASUNTO_CORREO';

      --Variables en caso que exista error en el reporte de tareas
      Lv_ParametroCorreoError      VARCHAR2(25)  := 'CORREO_DEFECTO_ERROR';
      Lv_ParametroPlantillaError   VARCHAR2(25)  := 'PLANTILLA_ERROR';

      Lv_Delimitador               VARCHAR2(2)   := ';';
      Lt_CorreoRemitente           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_NombreDirectorio          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_RutaDirectorio            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_ComandoReporte            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_ExtensionReporte          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_PlantillaNotificacion     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_AsuntoCorreo              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_CorreoError               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lt_PlantillaError            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lb_Fexists                   BOOLEAN;
      Ln_FileLength                NUMBER;
      Lbi_BlockSize                BINARY_INTEGER;

      --Filtros para el Query dinamico
      Lv_EstadoTarea            VARCHAR2(4000);
      Lv_IdCuadrilla            VARCHAR2(4000);
      Lv_NombreAsignado         VARCHAR2(4000);
      Lv_Cuadrilla              VARCHAR2(4000) := 'N/A';
      Lv_Departamento           VARCHAR2(100)  := 'N/A';
      Lv_FeSolicitadaDesde      VARCHAR2(20);
      Lv_FeSolicitadaHasta      VARCHAR2(20);
      Lv_FeFinalizadaDesde      VARCHAR2(20);
      Lv_FeFinalizadaHasta      VARCHAR2(20);
      Lv_IdTarea                VARCHAR2(20);
      Lv_DepartamentoOrigen     VARCHAR2(100);
      Lv_CiudadOrigen           VARCHAR2(100);
      Lv_EstadosTareaNotIn      VARCHAR2(200);
      Lv_TareaPadre             VARCHAR2(20);
      Lv_Tipo                   VARCHAR2(100);
      Lv_IdDepartamento         VARCHAR2(20);
      Lv_Origen                 VARCHAR2(100);
      Lv_TodaLasEmpresa         VARCHAR2(100);
      Lv_ExisteFiltro           VARCHAR2(100);
      Lv_ArrayDepartamentos     VARCHAR2(100);
      Lv_TieneCredencial        VARCHAR2(100);
      Lv_DepartamentoSession    VARCHAR2(100);
      Lv_OficinaSession         VARCHAR2(100);
      Lv_OpcionBusqueda         VARCHAR2(100);
      Lv_arrayPersonaEmpresaRol VARCHAR2(100);
      Lv_IdUsuario              VARCHAR2(100);
      Lv_FiltroUsuario          VARCHAR2(100);
      Lv_IntProceso             VARCHAR2(100);
      Lv_Asignado               VARCHAR2(100);
      Lv_Cliente                VARCHAR2(100);
      Lv_Actividad              VARCHAR2(100);
      Lv_Caso                   VARCHAR2(100);
      Lv_CiudadDestino          VARCHAR2(100);
      Lv_FechaDefecto           VARCHAR2(100);
      Lv_UsuarioSolicita        VARCHAR2(100);
      Lv_Empresa                VARCHAR2(100);
      Lv_CodEmpresa             VARCHAR2(50);

      Lv_Json                   VARCHAR2(4000);
      Lv_Codigo                 VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
      Lt_InsertaOk              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
      Lv_InsertarErrorOk        VARCHAR2(25) := 'INSERTAR_ERROR_OK';
      Lv_EsConsulta             VARCHAR2(3);
      Lv_Start                  VARCHAR2(10);
      Lv_Limit                  VARCHAR2(10);
      Lv_VerTareasEcucert       VARCHAR2(10);
      Lv_MsgReasigAutoCambDep   CLOB;
      Lv_CaracSolicitud         VARCHAR2(1000);
      Lv_VerTareasTodasEmpresas VARCHAR2(1000);
      Lv_DptosEmpleadoEmpresas  VARCHAR2(1000);

      Lv_Observacion            CLOB;
      Lv_ObservacionHistorial   CLOB;
     
      Lv_newCamposConsulta      VARCHAR2(2);
      Lv_DescCaractSolicitud    VARCHAR2(1000);
      Lv_newCampos 				CLOB :='';
      Lv_TareaInfoAdicional 	VARCHAR2(4000);
      Lv_ObsTareaIniMovil       VARCHAR2(4000);
      Lv_IdTareaInstalacion		VARCHAR2(20);
      Lv_QueryTruncObservacion  VARCHAR2(400) := 'ITA.OBSERVACION AS OBSERVACION, ITA.OBSERVACION_HISTORIAL AS OBSERVACION_HISTORIAL, ';
      Lv_IdTareasNoReqActivo	VARCHAR2(400);
      Lv_descripcionTareaRemplace   CLOB;
      Lv_ObservacionRemplace   CLOB;

    BEGIN

      IF C_ObtenerCaso%ISOPEN THEN
          CLOSE C_ObtenerCaso;
      END IF;

      IF C_ObtenerAfectados%ISOPEN THEN
          CLOSE C_ObtenerAfectados;
      END IF;

      IF C_ObtenerDatosUsuario%ISOPEN THEN
          CLOSE C_ObtenerDatosUsuario;
      END IF;

      IF C_ObtenerContactos%ISOPEN THEN
          CLOSE C_ObtenerContactos;
      END IF;

      IF C_ObtenerCorreoUsuario%ISOPEN THEN
          CLOSE C_ObtenerCorreoUsuario;
      END IF;

      IF C_ParametrosConfiguracion%ISOPEN THEN
          CLOSE C_ParametrosConfiguracion;
      END IF;

      apex_json.parse(Pcl_Json);
      Lv_UsuarioSolicita := apex_json.get_varchar2('strUsuarioSolicita');--Obtenemos el usuario quien realiza la petici�n
      Lv_EsConsulta      := apex_json.get_varchar2('esConsulta');
      Lv_Start           := apex_json.get_varchar2('start');
      Lv_Limit           := apex_json.get_varchar2('limit');

      IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

          --Se habren los cursores para obtener las informaciones necesarias para completar el flujo del reporte.
          OPEN C_ObtenerCorreoUsuario('A',Lv_UsuarioSolicita);
              FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
          CLOSE C_ObtenerCorreoUsuario;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRemitente);
              FETCH C_ParametrosConfiguracion INTO Lt_CorreoRemitente;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroNombreDirectorio);
              FETCH C_ParametrosConfiguracion INTO Lt_NombreDirectorio;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRutaDirectorio);
              FETCH C_ParametrosConfiguracion INTO Lt_RutaDirectorio;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroComandoReporte);
              FETCH C_ParametrosConfiguracion INTO Lt_ComandoReporte;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroExtensionReporte);
              FETCH C_ParametrosConfiguracion INTO Lt_ExtensionReporte;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantilla);
              FETCH C_ParametrosConfiguracion INTO Lt_PlantillaNotificacion;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroAsuntoCorreo);
              FETCH C_ParametrosConfiguracion INTO Lt_AsuntoCorreo;
          CLOSE C_ParametrosConfiguracion;

          --CURSORES PARA OBTENER LA INFORMAION POR SI DA ERROR EL PROCESO
          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroCorreoError);
              FETCH C_ParametrosConfiguracion INTO Lt_CorreoError;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantillaError);
              FETCH C_ParametrosConfiguracion INTO Lt_PlantillaError;
          CLOSE C_ParametrosConfiguracion;

          OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_InsertarErrorOk);
              FETCH C_ParametrosConfiguracion INTO Lt_InsertaOk;
          CLOSE C_ParametrosConfiguracion;

      END IF;

      --Parseo del Json de Tareas.
      Lv_IdTarea                := apex_json.get_varchar2('tarea');
      Lv_DepartamentoOrigen     := apex_json.get_varchar2('departamentoOrig');
      Lv_CiudadOrigen           := apex_json.get_varchar2('ciudadOrigen');
      Lv_EstadoTarea            := apex_json.get_varchar2('estado');
      Lv_EstadosTareaNotIn      := apex_json.get_varchar2('estadosTareaNotIn');
      Lv_TareaPadre             := apex_json.get_varchar2('tareaPadre');
      Lv_FeSolicitadaDesde      := apex_json.get_varchar2('feSolicitadaDesde');
      Lv_FeSolicitadaHasta      := apex_json.get_varchar2('feSolicitadaHasta');
      Lv_FeFinalizadaDesde      := apex_json.get_varchar2('feFinalizadaDesde');
      Lv_FeFinalizadaHasta      := apex_json.get_varchar2('feFinalizadaHasta');
      Lv_Tipo                   := apex_json.get_varchar2('tipo');
      Lv_IdDepartamento         := apex_json.get_varchar2('idDepartamento');
      Lv_NombreAsignado         := apex_json.get_varchar2('nombreAsignado');
      Lv_Origen                 := apex_json.get_varchar2('strOrigen');
      Lv_TodaLasEmpresa         := apex_json.get_varchar2('strTodaLasEmpresa');
      Lv_ExisteFiltro           := apex_json.get_varchar2('existeFiltro');
      Lv_ArrayDepartamentos     := apex_json.get_varchar2('arrayDepartamentosP');
      Lv_TieneCredencial        := apex_json.get_varchar2('strTieneCredencial');
      Lv_DepartamentoSession    := apex_json.get_varchar2('departamentoSession');
      Lv_OficinaSession         := apex_json.get_varchar2('oficinaSession');
      Lv_OpcionBusqueda         := apex_json.get_varchar2('strOpcionBusqueda');
      Lv_arrayPersonaEmpresaRol := apex_json.get_varchar2('arrayPersonaEmpresaRolP');
      Lv_IdUsuario              := apex_json.get_varchar2('idUsuario');
      Lv_FiltroUsuario          := apex_json.get_varchar2('filtroUsuario');
      Lv_IntProceso             := apex_json.get_varchar2('intProceso');
      Lv_Asignado               := apex_json.get_varchar2('asignado');
      Lv_IdCuadrilla            := apex_json.get_varchar2('idCuadrilla');
      Lv_Cliente                := apex_json.get_varchar2('cliente');
      Lv_Actividad              := apex_json.get_varchar2('actividad');
      Lv_Caso                   := apex_json.get_varchar2('caso');
      Lv_CiudadDestino          := apex_json.get_varchar2('ciudadDestino');
      Lv_FechaDefecto           := apex_json.get_varchar2('strFechaDefecto');
      Lv_Empresa                := apex_json.get_varchar2('strNombreEmpresa');
      Lv_CodEmpresa             := apex_json.get_varchar2('codEmpresa');
      Lv_VerTareasEcucert       := apex_json.get_varchar2('strVerTareasEcucert');
      Lv_MsgReasigAutoCambDep   := apex_json.get_varchar2('strMsgReasignacionAutomaticaCambioDep');
      Lv_CaracSolicitud         := apex_json.get_varchar2('caracteristicaSolicitud');
      Lv_VerTareasTodasEmpresas := apex_json.get_varchar2('booleanVerTareasTodasEmpresa');
      Lv_newCamposConsulta      := apex_json.get_varchar2('newCamposConsulta');
      Lv_DescCaractSolicitud	:= apex_json.get_varchar2('descCaractSolicitud');
      Lv_TareaInfoAdicional		:= apex_json.get_varchar2('tareaInfoAdicional');
      Lv_ObsTareaIniMovil		:= apex_json.get_varchar2('obsTareaIniMovil');
      Lv_IdTareaInstalacion		:= apex_json.get_varchar2('idTareaInstalacion');
      Lv_IdTareasNoReqActivo    := apex_json.get_varchar2('idTareasNoReqActivo');
      --Creaci�n del Query.
       
      Lv_QueryNewCampos1 := 'SELECT  T.*, SPKG_INFO_ADICIONAL_TAREA.F_GET_TAREA_TIEMPO_PARCIAL(T.ID_DETALLE,T.ESTADO,T.IDCASO) AS FECHA_TIEMPO_PARCIAL_CASO, ' ||
     						' SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_CASO(T.IDCASO) AS  DATA_CASO, ' ||
     						' CASE WHEN T.IDCASO != 0 THEN ' ||
					     	'	(SELECT ch.ESTADO FROM DB_SOPORTE.INFO_CASO_HISTORIAL ch  WHERE ch.ID_CASO_HISTORIAL = ' ||
					     	'  	(SELECT max(ich.ID_CASO_HISTORIAL) FROM DB_SOPORTE.INFO_CASO_HISTORIAL ich WHERE ich.CASO_ID = T.IDCASO)) ' ||
					     	q'[   ELSE '' END ULT_ESTADO_CASO, ]' ||
					        ' SPKG_INFO_ADICIONAL_TAREA.F_GET_CLIENTES_AFECTADOS(T.ID_DETALLE,T.IDCASO) AS ClIENTE_AFECTADO, ' ||	  
						    q'[ CASE WHEN T.IDCASO != 0 THEN SPKG_INFO_ADICIONAL_TAREA.F_GET_ULTIMA_MILLA_SOPORTE(T.IDCASO) ELSE '' END ULTIMA_MILLA_SOPORTE, ]' ||
							q'[ CASE WHEN T.ULT_TIPO_ASIGNADO = 'CUADRILLA' AND (T.IDCASO != 0 OR T.ID_TAREA = TO_NUMBER(']'||Lv_IdTareaInstalacion||q'[')) THEN ]'||
							q'[ ((SELECT CASE WHEN count(*) > 0 AND LENGTH(']'||Lv_ObsTareaIniMovil||q'[') > 0 THEN 'S' ELSE 'N' END TAREA_MOVIL  FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO its ]' ||
 							q'[	WHERE its.DETALLE_ID = T.ID_DETALLE AND its.OBSERVACION LIKE '%]'||Lv_ObsTareaIniMovil||q'[%')) ELSE 'S' END TAREA_INICIADA_MOVIL, ]' ||
						    q'[ CASE WHEN  (DB_SOPORTE.SPKG_UTILIDADES.F_MATCH_VALOR_PARAMETER(']'||Lv_IdTareasNoReqActivo||q'[',T.ID_TAREA,',')) = 'S' OR T.IDCASO != 0 THEN 'N' ELSE 'S' END ES_INTERDEPARTAMENTAL, ]'|| 
 							' SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_TAREA_DETALE_CASO(T.ID_DETALLE, T.IDCASO, '||
							'	(SELECT EMP.COD_EMPRESA FROM DB_COMUNICACION.INFO_COMUNICACION COM '||
							'		   JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP ON EMP.COD_EMPRESA = COM.EMPRESA_COD '||
							'		   WHERE COM.ID_COMUNICACION = T.NUMERO_TAREA), '||
							q'[	(CASE WHEN  (DB_SOPORTE.SPKG_UTILIDADES.F_MATCH_VALOR_PARAMETER(']'||Lv_IdTareasNoReqActivo||q'[',T.ID_TAREA,',')) = 'S' OR T.IDCASO != 0 THEN 'N' ELSE 'S' END) ]'||
							'	) INFO_SERV_AFECT_TAREA, '||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_VALIDA_PROGRESO_TAREA(T.ID_DETALLE, T.IDCASO, '||
							'	(SELECT EMP.COD_EMPRESA FROM DB_COMUNICACION.INFO_COMUNICACION COM '||
							'		   JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP ON EMP.COD_EMPRESA = COM.EMPRESA_COD '||
							'		   WHERE COM.ID_COMUNICACION = T.NUMERO_TAREA), '||
							q'[	(CASE WHEN  (DB_SOPORTE.SPKG_UTILIDADES.F_MATCH_VALOR_PARAMETER(']'||Lv_IdTareasNoReqActivo||q'[',T.ID_TAREA,',')) = 'S' OR T.IDCASO != 0 THEN 'N' ELSE 'S' END) ]'||
							'	) PROGRESO_TAREA '||	
						    ' FROM 	(';
	  Lv_QueryNewCampos2 := ', (SELECT NVL(MAX(dh.CASO_ID), 0) ' ||
							'	      FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS dh, DB_SOPORTE.INFO_DETALLE id '||
							'	      WHERE id.ID_DETALLE = ITA.DETALLE_ID ' ||
							'	      AND dh.ID_DETALLE_HIPOTESIS = id.DETALLE_HIPOTESIS_ID) AS IDCASO, '||
								      
							q'[ (SELECT TO_CHAR(max(a.FE_SOLICITADA),'RRRR-MM-DD HH24:MI') as fecha FROM DB_SOPORTE.INFO_DETALLE a, DB_SOPORTE.INFO_DETALLE_ASIGNACION b ]' ||   
							'                WHERE a.ID_DETALLE = ITA.DETALLE_ID AND a.ID_DETALLE = b.DETALLE_ID ' ||
							'                AND (b.REF_ASIGNADO_ID = ITA.REF_ASIGNADO_ID or b.ASIGNADO_ID = ITA.ASIGNADO_ID)) AS ULT_FECHA_ASIGNACION, ' ||
							' (SELECT count(*) FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac,DB_COMERCIAL.INFO_DETALLE_SOL_CARACT ids '||
							q'[	WHERE ac.DESCRIPCION_CARACTERISTICA = ']' || Lv_DescCaractSolicitud || q'[' ]' || 
							'	AND ids.CARACTERISTICA_ID = ac.ID_CARACTERISTICA '||
							'	AND ids.VALOR = TO_CHAR(ITA.DETALLE_ID)) AS DETALLE_SOL_CARACT,' ||
							' (SELECT da.TIPO_ASIGNADO FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION da WHERE da.ID_DETALLE_ASIGNACION = ' ||
 							' 	(SELECT max(ida.ID_DETALLE_ASIGNACION) FROM  DB_SOPORTE.INFO_DETALLE_ASIGNACION ida WHERE ida.DETALLE_ID = ITA.DETALLE_ID)) AS ULT_TIPO_ASIGNADO,' ||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_FECHA_TIEMPO_PARCIAL(ITA.DETALLE_ID,ITA.ESTADO) AS FECHA_TIEMPO_PARCIAL, ' ||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_DEP_COORDINADOR(ITA.REF_ASIGNADO_ID) AS ID_DEP_COORDINADOR, ' ||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_CARACTERISTICA_DETALLE(ITA.DETALLE_ID,ITA.NUMERO_TAREA) AS HAS_CARACTERISTICA_DETALLE, ' ||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_MOTIVO_POR_TAREA(ITA.DETALLE_ID) AS TAREA_ANTERIOR, ' ||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_FECHA_CREA_TAREA(ITA.DETALLE_ID) AS FECHA_CREACION_TAREA, '||
							q'[ SPKG_INFO_ADICIONAL_TAREA.F_GET_INFO_ADICIONAL_TAREA(ITA.DETALLE_ID,ITA.NOMBRE_TAREA,']'||Lv_TareaInfoAdicional||q'[') AS INFO_TAREA_ADIC, ]'||
							q'['{"length_obs":"'||LENGTH(ITA.OBSERVACION)||'","limit_trunc":"10000"}' AS TRUNC_OBS, ]'||
							' SPKG_INFO_ADICIONAL_TAREA.F_GET_ID_SERVICIO_VRF(ITA.DETALLE_ID) AS ID_SERVICIO_AFECT ';
     
      Lv_QuerySelect := 'SELECT  ' ||
                               Lv_QueryTruncObservacion||
                              'ITA.DETALLE_ID AS ID_DETALLE, '||
                              'ITA.LATITUD AS LATITUD, '||
                              'ITA.LONGITUD AS LONGITUD, '||
                              'DECODE(SIGN(INSTR(ITA.USR_CREACION_DETALLE,''@'')),1,ITA.USR_CREACION,ITA.USR_CREACION_DETALLE) AS USR_CREACION_DETALLE, '||
                              'ITA.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO, '||
                              'TO_CHAR(ITA.FE_CREACION_DETALLE,''RRRR-MM-DD HH24:MI'') AS FE_CREACION_DETALLE, '||
                              'TO_CHAR(ITA.FE_SOLICITADA,''RRRR-MM-DD HH24:MI'') AS FE_SOLICITADA, '||
                              'ITA.TAREA_ID AS ID_TAREA, '||
                              'ITA.NOMBRE_TAREA AS NOMBRE_TAREA, '||
                              'ITA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA, '||
                              'ITA.NOMBRE_PROCESO AS NOMBRE_PROCESO, '||
                              'ITA.ASIGNADO_ID AS ASIGNADO_ID, '||
                              'ITA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE, '||
                              'ITA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID, '||
                              'ITA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE, '||
                              'ITA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID, '||
                              'TO_CHAR(ITA.FE_CREACION_ASIGNACION,''RRRR-MM-DD HH24:MI'') AS FE_CREACION_ASIGNACION, '||
                              'ITA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID, '||
                              'ITA.TIPO_ASIGNADO AS TIPO_ASIGNADO, '||
                              'ITA.ESTADO AS ESTADO, '||
                              'ITA.DETALLE_HISTORIAL_ID AS ID_DETALLE_HISTORIAL, '||
                              'TO_CHAR(ITA.FE_CREACION_HIS,''RRRR-MM-DD HH24:MI'') AS FE_CREACION, '||
                              'DECODE(SIGN(INSTR(ITA.USR_CREACION_HIS,''@'')),1,ITA.USR_CREACION,ITA.USR_CREACION_HIS) AS USR_CREACION, '||
                              'ITA.ASIGNADO_ID_HIS AS ASIGNADO_ID_HIS, '||
                              'ITA.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID, '||
                              'ITA.NUMERO_TAREA AS NUMERO_TAREA, '||
                              'ITA.NUMERO AS NUMERO, '||
                              ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_REENVIAR_SYSCLOUD( '||
                              ' ITA.NUMERO_TAREA, '||
                              ' ITA.USR_CREACION_DETALLE, '|| 
                              q'[  ITA.ASIGNADO_ID, TRIM(']'||Lv_DepartamentoSession||q'[') ) AS REENVIAR_SYSCLOUD, ]' 
                              ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_NOMB_ACTUALIZADO_POR( '||
                                ' ITA.OBSERVACION_HISTORIAL, '||
                                q'[ ITA.USR_CREACION_HIS, ']'||
                                Lv_MsgReasigAutoCambDep||q'[' ) AS NOMBRE_ACTUALIZADO_POR, ]'
                              ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_SI_MUESTRA_COORD_MANGA( ITA.TAREA_ID ) AS SE_MUESTRA_COORD_MANGA, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_EMPRESA_DE_TAREA( ITA.NUMERO_TAREA ) AS EMPRESA_TAREA, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_CERRAR_TAREA( ITA.DETALLE_ID ) AS CERRAR_TAREA, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_TAREA_PADRE( ITA.DETALLE_ID_RELACIONADO ) AS NUMERO_TAREA_PADRE, ' 
                                ||
                                q'[ DB_SOPORTE.SPKG_INFO_TAREA.F_GET_PERMITE_SEGUIMIENTO( ']'||
                                    Lv_DepartamentoSession||q'[' ) AS PERMITE_SEGUIMIENTO, ]'
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_PERMITE_ANULAR( '||
                                ' ITA.DETALLE_ID, '||
                                q'[ ITA.ESTADO, ' ]'|| Lv_IdUsuario||q'[' ) AS PERMITE_ANULAR, ]'
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_ES_HAL( ITA.NUMERO_TAREA ) AS ES_HAL, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_MUESTRA_PESTANA_HAL( ITA.TAREA_ID ) AS MUESTRA_PESTANA_HAL, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_ATENDER_ANTES( ITA.NUMERO_TAREA ) AS ATENDER_ANTES, '
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_MUESTRA_REPROGRAMAR( '||
                                q'[ITA.DETALLE_ID, ']'||Lv_DepartamentoSession||q'[') AS MUESTRA_REPROGRAMAR, ]'
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_PERMITE_FINALIZAR_INFORM( '||
                                q'[ITA.DETALLE_ID, ITA.NOMBRE_TAREA, ']'||Lv_DepartamentoSession||q'[') AS PERMITE_FINALIZAR_INFORME, ]'
                                ||
                                ' DB_SOPORTE.SPKG_INFO_TAREA.F_GET_ES_DEPARTAMENTO( '||
                                ' ITA.TIPO_ASIGNADO, '||
                                ' ITA.ASIGNADO_ID, '||
                                q'[ ITA.PERSONA_EMPRESA_ROL_ID, ']'||
                                Lv_VerTareasTodasEmpresas||q'[',']'||
                                Lv_ArrayDepartamentos||q'[',']'||
                                Lv_DepartamentoSession||q'[' ) AS ES_DEPARTAMENTO ]'
                                ;

      Lv_QuerySelect:= Lv_QuerySelect||', (SELECT APA.NOMBRE_PUNTO_ATENCION FROM DB_SOPORTE.INFO_TAREA_CARACTERISTICA  ITC
                                           JOIN DB_COMERCIAL.ADMI_PUNTO_ATENCION APA ON TO_CHAR(APA.ID_PUNTO_ATENCION) = ITC.VALOR
                                           WHERE ITC.TAREA_ID =  ITA.NUMERO_TAREA  )PUNTO_ATENCION';

      Lv_Queryfrom := ' FROM DB_SOPORTE.INFO_TAREA ITA ';

      Lv_QueryWhere := ' WHERE 1 = 1 ';


      IF Lv_Actividad IS NOT NULL THEN
          Lv_Queryfrom  := Lv_Queryfrom || ', DB_COMUNICACION.INFO_COMUNICACION ICOM ';
          Lv_QueryWhere := Lv_QueryWhere ||' AND ICOM.DETALLE_ID = ITA.DETALLE_ID '||
                                            'AND ICOM.ID_COMUNICACION = :numeroActividad';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':numeroActividad',Lv_Actividad);
      END IF;

      IF Lv_IdTarea IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.TAREA_ID = :tarea';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tarea',Lv_IdTarea);
      END IF;

      IF Lv_DepartamentoOrigen IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.DEPARTAMENTO_ID = :departamentoId';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':departamentoId',Lv_DepartamentoOrigen);
      END IF;

      IF Lv_CiudadOrigen IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.CANTON_ID = :ciudadOrigen';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':ciudadOrigen',Lv_CiudadOrigen);
      END IF;

      IF Lv_EstadoTarea IS NOT NULL AND Lv_EstadoTarea != 'Todos' THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(ITA.ESTADO) IN (:estado)';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':estado',Lv_EstadoTarea);
      END IF;

      IF Lv_EstadosTareaNotIn IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.ESTADO NOT IN (:paramEstadosTareaNotIn)';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadosTareaNotIn',Lv_EstadosTareaNotIn);
      END IF;

      IF Lv_TareaPadre IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.DETALLE_ID_RELACIONADO = '||
                                              '(SELECT ICOP.DETALLE_ID '||
                                                  'FROM DB_COMUNICACION.INFO_COMUNICACION ICOP '||
                                              'WHERE ICOP.ID_COMUNICACION = :tareaPadre)';

          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tareaPadre',Lv_TareaPadre);
      END IF;

      IF Lv_FeSolicitadaDesde IS NOT NULL THEN
          Lv_FeSolicitadaDesde := TO_CHAR(TO_dATE(Lv_FeSolicitadaDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ITA.FE_SOLICITADA,''RRRR-MM-DD'') >= :feSolicitadaDesde';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feSolicitadaDesde',''''||Lv_FeSolicitadaDesde||'''');
      END IF;

      IF Lv_FeSolicitadaHasta IS NOT NULL THEN
          Lv_FeSolicitadaHasta := TO_CHAR(TO_dATE(Lv_FeSolicitadaHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ITA.FE_SOLICITADA,''RRRR-MM-DD'') <= :feSolicitadaHasta';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feSolicitadaHasta',''''||Lv_FeSolicitadaHasta||'''');
      END IF;

      IF Lv_FeFinalizadaDesde IS NOT NULL THEN
          Lv_FeFinalizadaDesde := TO_CHAR(TO_dATE(Lv_FeFinalizadaDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ITA.FE_CREACION_HIS,''RRRR-MM-DD'') >= :feFinalizadaDesde';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feFinalizadaDesde',''''||Lv_FeFinalizadaDesde||'''');
      END IF;

      IF Lv_FeFinalizadaHasta IS NOT NULL THEN
          Lv_FeFinalizadaHasta := TO_CHAR(TO_dATE(Lv_FeFinalizadaHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ITA.FE_CREACION_HIS,''RRRR-MM-DD'') <= :feFinalizadaDesde';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feFinalizadaDesde',''''||Lv_FeFinalizadaHasta||'''');
      END IF;

      IF Lv_Tipo IS NOT NULL THEN

          IF Lv_Tipo = 'ByDepartamento'THEN

              IF Lv_IdDepartamento IS NOT NULL AND
                Lv_NombreAsignado IS NOT NULL AND
                Lv_Tipo = 'ByDepartamento' THEN

                  IF Lv_Origen = 'tareasPorDepartamento' THEN

                      --Lv_From  := ', DB_SOPORTE.INFO_DETALLE_TAREAS IDT';
                      --Lv_Where := ' AND ITA.DETALLE_ID = IDT.DETALLE_ID '||
                      --            'AND ITA.DETALLE_ASIGNACION_ID = IDT.DETALLE_ASIGNACION_ID '||
                      --            'AND ITA.DETALLE_HISTORIAL_ID = IDT.DETALLE_HISTORIAL_ID';

                      IF UPPER(Lv_TodaLasEmpresa) = 'S' THEN
                          Lv_QueryWhere := Lv_QueryWhere || ' AND ITA.DETALLE_ID IN ( '||
                                                              'SELECT A.DETALLE_ID '||
                                                                'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                              'WHERE A.DEPARTAMENTO_ID IN (:paramDepartamentosEmpresas) '||
                                                                'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                            'AND ITA.ESTADO NOT IN (:paramEstadoHistorial)';

                          IF UPPER(Lv_ExisteFiltro) = 'S' THEN
                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentosEmpresas',Lv_IdDepartamento);
                          ELSE
                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentosEmpresas',Lv_ArrayDepartamentos);
                          END IF;
                      ELSE
                          IF UPPER(Lv_TieneCredencial) = 'S'THEN
                              Lv_QueryWhere := Lv_QueryWhere || ' AND ITA.DETALLE_ID IN ( '||
                                                                  'SELECT A.DETALLE_ID '||
                                                                    'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                                  'WHERE A.DEPARTAMENTO_ID = (:paramDepartamentoSession) '||
                                                                    'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                                'AND ITA.ESTADO NOT IN (:paramEstadoHistorial)';

                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentoSession',Lv_DepartamentoSession);
                          ELSE
                            Lv_QueryWhere := Lv_QueryWhere || ' AND ITA.DETALLE_ID IN ( '||
                                                                  'SELECT A.DETALLE_ID '||
                                                                    'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                                  'WHERE A.DEPARTAMENTO_ID = (:paramDepartamentoSession) '||
                                                                    'AND A.OFICINA_ID = :paramOficinaSession '||
                                                                    'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                                'AND ITA.ESTADO NOT IN (:paramEstadoHistorial)';

                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentoSession',Lv_DepartamentoSession);
                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramOficinaSession',Lv_OficinaSession);
                          END IF;
                      END IF;

                      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoHistorial',Lv_Estado);

                  ELSE

                      IF Lv_TareaPadre IS NULL THEN

                          IF UPPER(Lv_OpcionBusqueda) = 'N' AND Lv_arrayPersonaEmpresaRol IS NOT NULL THEN

                              --Lv_From  := ', DB_SOPORTE.INFO_DETALLE_TAREAS IDT';
                              --Lv_Where := ' AND ITA.DETALLE_ID = IDT.DETALLE_ID '||
                              --            'AND ITA.DETALLE_ASIGNACION_ID = IDT.DETALLE_ASIGNACION_ID '||
                              --            'AND ITA.DETALLE_HISTORIAL_ID = IDT.DETALLE_HISTORIAL_ID';

                              Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.PERSONA_EMPRESA_ROL_ID IN (:paramPersonaEmpresaRol) '||
                                                                'AND ITA.ESTADO NOT IN (:paramEstadoHistorial)';

                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramPersonaEmpresaRol',Lv_arrayPersonaEmpresaRol);
                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoHistorial',Lv_Estado);
                          ELSE
                              Lv_QueryWhere := Lv_QueryWhere || ' AND ITA.ASIGNADO_ID = :asignadoId '||
                                                                'AND UPPER(ITA.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdDepartamento);
                              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');

                          END IF;
                      END IF;
                  END IF;

              END IF;

              IF Lv_IdUsuario IS NOT NULL AND Lv_FiltroUsuario = 'ByUsuario' THEN
                  Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.REF_ASIGNADO_ID = :refAsignadoId';
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoId',Lv_IdUsuario);
              END IF;

              IF Lv_IntProceso IS NOT NULL THEN
                  Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.PROCESO_ID = :paramProcesoId';
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramProcesoId',Lv_IntProceso);
              END IF;

              IF Lv_Asignado IS NOT NULL THEN
                  Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(ITA.REF_ASIGNADO_NOMBRE) like UPPER(:refAsignadoNombre)';
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoNombre','''%'||Lv_Asignado||'%''');
              END IF;

          ELSIF Lv_Tipo = 'ByCuadrilla' AND Lv_IdCuadrilla IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN

              Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.TIPO_ASIGNADO = :tipoAsignado';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAsignado','''CUADRILLA''');

              IF Lv_IdCuadrilla != 'Todos' THEN
                  Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.ASIGNADO_ID IN (:asignadoId) '||
                                                    'AND UPPER(ITA.ASIGNADO_NOMBRE) IN (:asignadoNombre)';

                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdCuadrilla);
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',Lv_NombreAsignado);
              END IF;

          ELSE
              IF Lv_IdCuadrilla IS NOT NULL THEN
                  Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.TIPO_ASIGNADO = :tipoAsignado';
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAsignado','''CUADRILLA''');

                  IF Lv_IdCuadrilla != 'Todos' THEN
                      Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.ASIGNADO_ID = :asignadoId '||
                                                        'AND UPPER(ITA.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdCuadrilla);
                      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');
                  END IF;
                  Lb_FiltroCuadrilla := TRUE;
              END IF;

              IF Lv_Asignado IS NOT NULL AND NOT Lb_FiltroCuadrilla THEN

                  Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(ITA.REF_ASIGNADO_NOMBRE) LIKE UPPER(:refAsignadoNombre)';
                  Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoNombre','''%'||TRIM(Lv_Asignado)||'%''');

                  IF Lv_IdDepartamento IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
                      Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.ASIGNADO_ID_HIS = :asignadoId '||
                                                        'AND UPPER(ITA.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdDepartamento);
                      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');
                  END IF;
              END IF;

          END IF;

      END IF;

      IF Lv_Cliente IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND EXISTS ( '||
                                              'SELECT PA1.ID_PARTE_AFECTADA '             ||
                                                'FROM DB_SOPORTE.INFO_PARTE_AFECTADA PA1 '||
                                              'WHERE ITA.DETALLE_ID    = PA1.DETALLE_ID ' ||
                                                'AND PA1.TIPO_AFECTADO = :tipoAfectado '  ||
                                                'AND PA1.AFECTADO_ID   = :afectadoId) ';

          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':afectadoId',Lv_Cliente);
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAfectado','''Cliente''');
      END IF;

      IF Lv_Caso IS NOT NULL THEN
          Lv_Queryfrom  := Lv_Queryfrom || ', DB_SOPORTE.INFO_CASO ICASO'||
                                          ', DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI';

          Lv_QueryWhere := Lv_QueryWhere ||' AND ICASO.NUMERO_CASO = :numeroCaso '||
                                            'AND ICASO.ID_CASO = IDHI.CASO_ID '||
                                            'AND IDHI.ID_DETALLE_HIPOTESIS = ITA.DETALLE_HIPOTESIS_ID';

          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':numeroCaso',''''||Lv_Caso||'''');
      END IF;

      IF Lv_CiudadDestino IS NOT NULL THEN
          Lv_Queryfrom  := Lv_Queryfrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL infoPersonaEmpresaRol';

          Lv_QueryWhere := Lv_QueryWhere ||' AND ITA.PERSONA_EMPRESA_ROL_ID_HIS = infoPersonaEmpresaRol.ID_PERSONA_ROL  '||
                                            'AND infoPersonaEmpresaRol.OFICINA_ID IN '||
                                              '(SELECT infoOficinaGrupo.ID_OFICINA '||
                                                  'FROM DB_COMERCIAL.INFO_OFICINA_GRUPO infoOficinaGrupo '||
                                              'WHERE infoOficinaGrupo.CANTON_ID = :cantonIdD)';

          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':cantonIdD',Lv_CiudadDestino);
      END IF;

      IF Lv_FeSolicitadaDesde IS NULL AND Lv_FeSolicitadaHasta IS NULL AND
         Lv_FeFinalizadaDesde IS NULL AND Lv_FeFinalizadaHasta IS NULL AND
         Lv_FechaDefecto      IS NOT NULL THEN

          Lv_FechaDefecto := TO_CHAR(TO_dATE(Lv_FechaDefecto,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ITA.FE_CREACION_DETALLE,''RRRR-MM-DD'') >= :fechaDefault';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':fechaDefault',''''||Lv_FechaDefecto||'''');

      END IF;

      IF Lv_VerTareasEcucert IS NULL OR Lv_VerTareasEcucert = 'N' THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND NOT EXISTS
                                                              (SELECT IID.COMUNICACION_ID FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID 
                                                                  WHERE IID.COMUNICACION_ID = ITA.NUMERO_TAREA) ' ;

      ELSE
          Lv_QueryWhere := Lv_QueryWhere ||' AND EXISTS
                                                              (SELECT IID.COMUNICACION_ID FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID 
                                                                  WHERE IID.COMUNICACION_ID = ITA.NUMERO_TAREA) ' ;
      END IF;
      --Query completo
      Lcl_QueryTareas := Lv_QuerySelect || Lv_QueryNewCampos2 ||
                        Lv_Queryfrom   ||
                        Lv_From        ||
                        Lv_QueryWhere  ||
                        Lv_Where       || ' ORDER BY ITA.FE_SOLICITADA DESC';
      Lcl_QueryTareas := Lv_QueryNewCampos1 || Lcl_QueryTareas || ') T';
     

      IF UPPER(Lv_EsConsulta) = 'S' THEN

          EXECUTE IMMEDIATE 'SELECT COUNT(ITA.DETALLE_ID) '||
                            Lv_Queryfrom||
                            Lv_From||
                            Lv_QueryWhere||
                            Lv_Where INTO Pn_Total;

          IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL  AND Lv_newCamposConsulta IS NULL THEN

              Lv_Limit :=  Lv_Start + Lv_Limit;

              Lcl_QueryTareas := 'SELECT RESULTADO.* '||
                                      'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                              'FROM ('||Lcl_QueryTareas||') CONSULTA '||
                                            'WHERE ROWNUM <= :intFin) RESULTADO '||
                                'WHERE RESULTADO.NUMERO_ROWNUM > :intInicio ';

              Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intFin'   ,Lv_Limit);
              Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intInicio',Lv_Start);

          ELSE

              IF Lv_Limit IS NOT NULL AND Lv_newCamposConsulta IS NULL THEN

                  Lcl_QueryTareas := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                          'FROM ('||Lcl_QueryTareas||') CONSULTA '||
                                    'WHERE ROWNUM <= :intFin ';

                  Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intFin',Lv_Limit);

              END IF;
             
              IF Lv_newCamposConsulta ='S' THEN 
              	 Lcl_QueryTareas := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                          'FROM ('||Lcl_QueryTareas||') CONSULTA ';
              END IF; 

          END IF;

      ELSE
          Lcl_QueryTareas := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                  'FROM ('||Lcl_QueryTareas||') CONSULTA ';
          --Se crea el archivo
          Lf_Archivo := UTL_FILE.FOPEN(Lt_NombreDirectorio,Lv_NombreArchivo,'w',32767);

          --Criterios de consulta
          IF Lv_Caso IS NULL THEN
              Lv_Caso := 'Todos';
          END IF;

          IF Lv_Actividad IS NULL THEN
              Lv_Actividad := 'Todos';
          END IF;

          IF Lv_Asignado IS NULL THEN
              Lv_Asignado := 'Todos';
          END IF;

          IF Lv_EstadoTarea IS NULL THEN
              Lv_EstadoTarea := 'Todos';
          END IF;

          IF Lv_IdCuadrilla IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
              Lv_Cuadrilla := Lv_NombreAsignado;
          END IF;

          IF Lv_IdDepartamento IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
              Lv_Departamento := Lv_NombreAsignado || ' ('||Lv_Empresa||')';
          END IF;

          IF Lv_FeSolicitadaDesde IS NULL THEN
              Lv_FeSolicitadaDesde := 'Todos';
          END IF;

          IF Lv_FeSolicitadaHasta IS NULL THEN
              Lv_FeSolicitadaHasta := 'Todos';
          END IF;

          IF Lv_FeFinalizadaDesde IS NULL THEN
              Lv_FeFinalizadaDesde := 'Todos';
          END IF;

          IF Lv_FeFinalizadaHasta IS NULL THEN
              Lv_FeFinalizadaHasta := 'Todos';
          END IF;

          --Criterios del Reporte
          UTL_FILE.PUT_LINE(Lf_Archivo,
                    'USUARIO QUE GENERA: '||Lv_Delimitador
                  ||Lv_Delimitador||Lv_UsuarioSolicita||chr(13)
                  ||'FECHA DE GENERACION: '||Lv_Delimitador
                  ||Lv_Delimitador||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||chr(13)||chr(13)
                  ||'ASIGNADO: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_Asignado||chr(13)
                  ||'ESTADO: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_EstadoTarea||chr(13)
                  ||'NUMERO DE TAREA: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_Actividad||chr(13)
                  ||'NUMERO DE CASO: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_Caso||chr(13)
                  ||'FECHA SOLICITADA: ' ||Lv_Delimitador
                                  ||'DESDE: '||Lv_Delimitador||Lv_FeSolicitadaDesde||chr(13)
                  ||Lv_Delimitador||'HASTA: '||Lv_Delimitador||Lv_FeSolicitadaHasta||chr(13)
                  ||'FECHA ESTADO: ' ||Lv_Delimitador
                                  ||'DESDE: ' ||Lv_Delimitador||Lv_FeFinalizadaDesde||chr(13)
                  ||Lv_Delimitador||'HASTA: ' ||Lv_Delimitador||Lv_FeFinalizadaHasta||chr(13)
                  ||'DEPARTAMENTO: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_Departamento||chr(13)
                  ||'CUADRILLA: ' ||Lv_Delimitador
                  ||Lv_Delimitador||Lv_Cuadrilla||chr(13)
                  ||chr(13)||chr(13));

          -- Detalle del Reporte
          UTL_FILE.PUT_LINE(Lf_Archivo,
                      'NUMERO DE TAREA'||Lv_Delimitador
                    ||'NUMERO DE CASO'||Lv_Delimitador
                    ||'PTO. CLIENTE'||Lv_Delimitador
                    ||'NOMBRE CLIENTE'||Lv_Delimitador
                    ||'DIRECCION PT. CLIENTE'||Lv_Delimitador
                    ||'NOMBRE PROCESO'||Lv_Delimitador
                    ||'NOMBRE TAREA'||Lv_Delimitador
                    ||'OBSERVACION'||Lv_Delimitador
                    ||'RESPONSABLE ASIGNADO'||Lv_Delimitador
                    ||'FECHA CREACION' ||Lv_Delimitador
                    ||'FECHA EJECUCION'||Lv_Delimitador
                    ||'ACTUALIZADO POR'||Lv_Delimitador
                    ||'FECHA ESTADO'||Lv_Delimitador
                    ||'ESTADO'||Lv_Delimitador
                    ||'CONTACTOS'||Lv_Delimitador
                    ||'PUNTO_ATENCION'||Lv_Delimitador);

      END IF;

      DBMS_OUTPUT.PUT_LINE(Lcl_QueryTareas);

      IF (
            (Lv_Tipo IS NULL OR Lv_Tipo != 'ByDepartamento') OR
            (Lv_Tipo = 'ByDepartamento' AND Lv_IdDepartamento IS NULL) OR
            (Lv_Tipo = 'ByDepartamento' AND Lv_DepartamentoSession IS NULL)
         )
          AND
         (Lv_EstadosTareaNotIn IS NULL OR Lv_EstadoTarea IS NULL) AND
          Lv_FechaDefecto      IS NOT NULL AND
          Lv_FeSolicitadaDesde IS NULL AND
          Lv_FeSolicitadaHasta IS NULL AND
          Lv_FeFinalizadaDesde IS NULL AND
          Lv_FeFinalizadaHasta IS NULL AND
          Lv_Caso              IS NULL AND
          Lv_Cliente           IS NULL AND
          Lv_CiudadDestino     IS NULL AND
          Lv_Actividad         IS NULL THEN

          Lv_Json := SUBSTR(Pcl_Json,1,3000);
          IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('PROCESO_TAREAS',
                                                 'PROCESO_TAREAS',
                                                  Lv_Codigo||'|1- '||Lv_Json,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          Lv_Json := SUBSTR(Pcl_Json,3001,6000);
          IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('PROCESO_TAREAS',
                                                 'PROCESO_TAREAS',
                                                  Lv_Codigo||'|2- '||Lv_Json,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          Lv_Json := SUBSTR(Pcl_Json,6001,9000);
          IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('PROCESO_TAREAS',
                                                 'PROCESO_TAREAS',
                                                  Lv_Codigo||'|3- '||Lv_Json,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          RETURN;

      END IF;

      IF UPPER(Lv_EsConsulta) = 'S' THEN

          OPEN Lrf_JsonTareas FOR Lcl_QueryTareas;

          Pcl_JsonRespuesta:= '[';
          LOOP
            FETCH Lrf_JsonTareas INTO Lr_JsonTareas;

            EXIT WHEN Lrf_JsonTareas%NOTFOUND;

            Lv_Observacion := '';
            Lv_ObservacionHistorial := '';

            IF Lr_JsonTareas.OBSERVACION IS NOT NULL THEN
              Lv_Observacion          :=  TRIM(
                                            REPLACE(
                                              REPLACE(
                                                REPLACE(
                                                  REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(Lr_JsonTareas.OBSERVACION,'"','*fff'),
                                                    '^[^A-Z|^a-z|^0-9|^<]|[?|�|\|"]|[)]+$', ' '),'[^A-Za-z0-9������������&()-_ ]' ,' ')
                                                  , Chr(9), ' ')
                                                , Chr(10), ' ')
                                              , Chr(13), ' ')
                                          );
            END IF;

            IF Lr_JsonTareas.OBSERVACION_HISTORIAL IS NOT NULL THEN
            Lv_ObservacionHistorial :=  TRIM(
                                          REPLACE(
                                            REPLACE(
                                              REPLACE(
                                                REGEXP_REPLACE(REGEXP_REPLACE(Lr_JsonTareas.OBSERVACION_HISTORIAL,
                                                  '^[^A-Z|^a-z|^0-9]|[?|�|\|"]|[)]+$', ' '),'[^A-Za-z0-9������������&()-_ ]' ,' ')
                                                , Chr(9), ' ')
                                              , Chr(10), ' ')
                                            , Chr(13), ' ')
                                        );
            END IF;

            IF MOD((Lr_JsonTareas.NUMERO_ROW-1),Lv_Start) = 0 THEN
              dbms_lob.append(Pcl_JsonRespuesta,'{');
            ELSE
              dbms_lob.append(Pcl_JsonRespuesta,',{');
            END IF;
           
            IF UPPER(Lv_newCamposConsulta) = 'S' THEN 
               lv_newCampos := ',"idcaso":"'||Lr_JsonTareas.IDCASO||'",'||
                               '"ult_fecha_asignacion":"'||Lr_JsonTareas.ULT_FECHA_ASIGNACION||'",'||
                               '"detalle_sol_caract":"'||Lr_JsonTareas.DETALLE_SOL_CARACT||'",'||
                               '"ult_tipo_asignado":"'||Lr_JsonTareas.ULT_TIPO_ASIGNADO||'",'||
                               '"fecha_tiempo_parcial":'||Lr_JsonTareas.FECHA_TIEMPO_PARCIAL||','||
                               '"id_dep_coordinador":"'||Lr_JsonTareas.ID_DEP_COORDINADOR||'",'||
                               '"has_caracteristica_detalle":"'||Lr_JsonTareas.HAS_CARACTERISTICA_DETALLE||'",'||
                               '"tarea_anterior":'||Lr_JsonTareas.TAREA_ANTERIOR||','||
                               '"fecha_creacion_tarea":"'|| Lr_JsonTareas.FECHA_CREACION_TAREA ||'",'||
                               '"info_tarea_adic":'||Lr_JsonTareas.INFO_TAREA_ADIC||','||
                               '"trunc_obs":'||Lr_JsonTareas.TRUNC_OBS||','||
                               '"id_servicio_afect":"'||Lr_JsonTareas.ID_SERVICIO_AFECT||'",'||
                               '"fecha_tiempo_parcial_caso":'||Lr_JsonTareas.FECHA_TIEMPO_PARCIAL_CASO||','||
                               '"data_caso":'||Lr_JsonTareas.DATA_CASO||','||
                               '"ult_estado_caso":"'||Lr_JsonTareas.ULT_ESTADO_CASO||'",'||
                               '"cliente_afectado":"'||Lr_JsonTareas.CLIENTE_AFECTADO||'",'||
                               '"ultima_milla_soporte":"'||Lr_JsonTareas.ULTIMA_MILLA_SOPORTE||'",'||
                               '"tarea_iniciada_movil":"'||Lr_JsonTareas.TAREA_INICIADA_MOVIL||'",'||
                               '"es_interdepartamental":"'||Lr_JsonTareas.ES_INTERDEPARTAMENTAL||'",'||
                               '"info_serv_afect_tarea":'||Lr_JsonTareas.INFO_SERV_AFECT_TAREA||','||
                               '"progreso_tarea":'||Lr_JsonTareas.PROGRESO_TAREA;
		   
            END IF; 

            Lv_ObservacionRemplace := REPLACE(Lv_Observacion, '"', '');
          
            Lv_descripcionTareaRemplace := REPLACE(Lr_JsonTareas.DESCRIPCION_TAREA, '"', '');
           
            dbms_lob.append(Pcl_JsonRespuesta,
                '"numero":"'||Lr_JsonTareas.NUMERO||'",'||            
                '"detalle_id":"'||Lr_JsonTareas.DETALLE_ID||'",'||
                '"latitud":"'||Lr_JsonTareas.LATITUD||'",'||
                '"longitud":"'||Lr_JsonTareas.LONGITUD||'",'||
                '"usr_creacion_detalle":"'||Lr_JsonTareas.USR_CREACION_DETALLE||'",'||
                '"detalle_id_relacionado":"'||Lr_JsonTareas.DETALLE_ID_RELACIONADO||'",'||
                '"fe_creacion_detalle":"'||Lr_JsonTareas.FE_CREACION_DETALLE||'",'||
                '"fe_solicitada":"'||Lr_JsonTareas.FE_SOLICITADA||'",'||
                '"observacion":"'||Lv_ObservacionRemplace||'",'||
                '"tarea_id":"'||Lr_JsonTareas.TAREA_ID||'",'||
                '"nombre_tarea":"'||Lr_JsonTareas.NOMBRE_TAREA||'",'||
                '"descripcion_tarea":"'||Lv_descripcionTareaRemplace||'",'||
                '"nombre_proceso":"'||Lr_JsonTareas.NOMBRE_PROCESO||'",'||
                '"asignado_id":"'||Lr_JsonTareas.ASIGNADO_ID||'",'||
                '"asignado_nombre":"'||Lr_JsonTareas.ASIGNADO_NOMBRE||'",'||
                '"ref_asignado_id":"'||Lr_JsonTareas.REF_ASIGNADO_ID||'",'||
                '"ref_asignado_nombre":"'||Lr_JsonTareas.REF_ASIGNADO_NOMBRE||'",'||
                '"persona_empresa_rol_id":"'||Lr_JsonTareas.PERSONA_EMPRESA_ROL_ID||'",'||
                '"fe_creacion_asignacion":"'||Lr_JsonTareas.FE_CREACION_ASIGNACION||'",'||
                '"departamento_id":"'||Lr_JsonTareas.DEPARTAMENTO_ID||'",'||
                '"tipo_asignado":"'||Lr_JsonTareas.TIPO_ASIGNADO||'",'||
                '"estado":"'||Lr_JsonTareas.ESTADO||'",'||
                '"detalle_historial_id":"'||Lr_JsonTareas.DETALLE_HISTORIAL_ID||'",'||
                '"fe_creacion":"'||Lr_JsonTareas.FE_CREACION||'",'||
                '"usr_creacion":"'||Lr_JsonTareas.USR_CREACION||'",'||
                '"observacion_historial":"'||Lv_ObservacionHistorial||'",'||
                '"asignado_id_his":"'||Lr_JsonTareas.ASIGNADO_ID_HIS||'",'||
                '"departamento_origen_id":"'||Lr_JsonTareas.DEPARTAMENTO_ORIGEN_ID||'",'||
                '"numero_tarea":"'||Lr_JsonTareas.NUMERO_TAREA||'",'||
                '"reenviar_syscloud":'||Lr_JsonTareas.REENVIAR_SYSCLOUD||','||
                '"nombre_actualizado_por":"'||Lr_JsonTareas.NOMBRE_ACTUALIZADO_POR||'",'||
                '"se_muestra_coord_manga":'||Lr_JsonTareas.SE_MUESTRA_COORD_MANGA||','||
                '"empresa_tarea":'||Lr_JsonTareas.EMPRESA_TAREA||','||
                '"cerrar_tarea":"'||Lr_JsonTareas.CERRAR_TAREA||'",'||
                '"numero_tarea_padre":"'||Lr_JsonTareas.NUMERO_TAREA_PADRE||'",'||
                '"permite_seguimiento":"'||Lr_JsonTareas.PERMITE_SEGUIMIENTO||'",'||
                '"permite_anular":"'||Lr_JsonTareas.PERMITE_ANULAR||'",'||
                '"es_hal":"'||Lr_JsonTareas.ES_HAL||'",'||
                '"muestra_pestana_hal":"'||Lr_JsonTareas.MUESTRA_PESTANA_HAL||'",'||
                '"atender_antes":"'||Lr_JsonTareas.ATENDER_ANTES||'",'||
                '"muestra_reprogramar":'||Lr_JsonTareas.MUESTRA_REPROGRAMAR||','||
                '"permite_finalizar_informe":"'||Lr_JsonTareas.PERMITE_FINALIZAR_INFORME||'",'||
                '"es_departamento":'||Lr_JsonTareas.ES_DEPARTAMENTO||Lv_newCampos||
            '}');

          END LOOP;
          
          dbms_lob.append(Pcl_JsonRespuesta,']');

      ELSE

          OPEN Lrf_ReporteTareas FOR Lcl_QueryTareas;

              LOOP

                  FETCH Lrf_ReporteTareas INTO Lr_Tareas;

                  EXIT WHEN Lrf_ReporteTareas%NOTFOUND;

                  OPEN C_ObtenerCaso(Lr_Tareas.DETALLE_ID);
                      FETCH C_ObtenerCaso INTO Lt_IdCaso,Lt_NumeroCaso;
                  CLOSE C_ObtenerCaso;

                  FOR Afectados IN C_ObtenerAfectados(Lr_Tareas.DETALLE_ID,'cliente',Lt_IdCaso) LOOP

                      IF LENGTH(Lcl_AfectadoNombre) <= 2000 OR Lcl_AfectadoNombre IS NULL THEN
                          IF Lcl_AfectadoNombre IS NULL AND Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                              Lcl_AfectadoNombre := Afectados.AFECTADO_NOMBRE;
                          ELSE
                              IF Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                                  Lcl_AfectadoNombre := Lcl_AfectadoNombre||','||Afectados.AFECTADO_NOMBRE;
                              END IF;
                          END IF;
                      END IF;

                      IF LENGTH(Lcl_AfectadoDescripcion) <= 2000 OR Lcl_AfectadoDescripcion IS NULL THEN
                          IF Lcl_AfectadoDescripcion IS NULL AND Afectados.AFECTADO_DESCRIPCION IS NOT NULL THEN
                              Lcl_AfectadoDescripcion := Afectados.AFECTADO_DESCRIPCION;
                          ELSE
                              IF Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                                  Lcl_AfectadoDescripcion := Lcl_AfectadoDescripcion||','||Afectados.AFECTADO_DESCRIPCION;
                              END IF;
                          END IF;
                      END IF;

                      IF LENGTH(Lcl_AfectadoDireccion) <= 2000 OR Lcl_AfectadoDireccion IS NULL THEN
                          IF Lcl_AfectadoDireccion IS NULL AND Afectados.DIRECCION IS NOT NULL THEN
                              Lcl_AfectadoDireccion := Afectados.DIRECCION;
                          ELSE
                              IF Afectados.DIRECCION IS NOT NULL THEN
                                  Lcl_AfectadoDireccion := Lcl_AfectadoDireccion||','||Afectados.DIRECCION;
                              END IF;
                          END IF;
                      END IF;

                      FOR Contactos IN C_ObtenerContactos(Afectados.AFECTADO_ID,'Activo',5) LOOP

                          IF LENGTH(Lcl_FormaContacto) <= 2000 OR Lcl_FormaContacto IS NULL THEN

                            IF Lcl_FormaContacto IS NULL AND Contactos.VALOR IS NOT NULL THEN
                                  Lcl_FormaContacto := Contactos.VALOR;
                              ELSE
                                  IF Contactos.VALOR IS NOT NULL THEN
                                      Lcl_FormaContacto := Lcl_FormaContacto||','||Contactos.VALOR;
                                  END IF;
                              END IF;

                          END IF;

                      END LOOP;

                  END LOOP;

                  OPEN C_ObtenerDatosUsuario(Lr_Tareas.USR_CREACION,'Activo');
                      FETCH C_ObtenerDatosUsuario INTO Lv_nombres;
                  CLOSE C_ObtenerDatosUsuario;

                  UTL_FILE.PUT_LINE(Lf_Archivo,

                              Lr_Tareas.NUMERO_TAREA ||Lv_Delimitador||

                              Lt_NumeroCaso ||Lv_Delimitador||

                              NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lcl_AfectadoNombre,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  )),'')||Lv_Delimitador||

                              NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lcl_AfectadoDescripcion,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  )),'')||Lv_Delimitador||

                              NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lcl_AfectadoDireccion,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  )),'')||Lv_Delimitador||

                              NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lr_Tareas.NOMBRE_PROCESO,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  ),'')||Lv_Delimitador||

                              NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lr_Tareas.NOMBRE_TAREA,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  ),'')||Lv_Delimitador||

                              NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lr_Tareas.OBSERVACION,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  ),'')||Lv_Delimitador||

                              NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                  (TRIM(REPLACE(
                                        REPLACE(
                                        REPLACE(Lr_Tareas.REF_ASIGNADO_NOMBRE,Chr(9),' '),Chr(10),' '),
                                              Chr(13),' ')
                                        )
                                  )),'')||Lv_Delimitador||

                              Lr_Tareas.FE_CREACION_DETALLE||Lv_Delimitador||

                              Lr_Tareas.FE_SOLICITADA||Lv_Delimitador||

                              NVL(TRIM(REPLACE(REPLACE(REPLACE(
                                      lv_nombres,Chr(9),' '),
                                      Chr(10),' '),
                                      Chr(13),' ')),'')||Lv_Delimitador||

                              Lr_Tareas.FE_CREACION||Lv_Delimitador||

                              Lr_Tareas.ESTADO ||Lv_Delimitador||

                              NVL(TRIM(REPLACE(REPLACE(REPLACE(
                                      Lcl_FormaContacto,Chr(9),' '),
                                      Chr(10),' '),
                                      Chr(13),' ')),'')||Lv_Delimitador||

                              Lr_Tareas.PUNTO_ATENCION||Lv_Delimitador);

                  Lt_IdCaso               := NULL;
                  Lt_NumeroCaso           := NULL;
                  Lcl_AfectadoNombre      := NULL;
                  Lcl_AfectadoDescripcion := NULL;
                  Lcl_AfectadoDireccion   := NULL;
                  Lv_nombres              := NULL;
                  Lcl_FormaContacto       := NULL;

              END LOOP;

          CLOSE Lrf_ReporteTareas;

      END IF;

      IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

          --Cierre del Archivo
          UTL_FILE.FCLOSE(Lf_Archivo);

          --Ejecuci�n del comando para crear el archivo comprimido
          DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lt_ComandoReporte||' '||Lt_RutaDirectorio||Lv_NombreArchivo));

          --Envio del archivo por correo
          DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lt_CorreoRemitente,
                                                    Lv_Para||',',
                                                    Lt_AsuntoCorreo,
                                                    Lt_PlantillaNotificacion,
                                                    Lt_NombreDirectorio,
                                                    Lv_NombreArchivo||Lt_ExtensionReporte);

          --Eliminaci�n del archivo
          BEGIN
              UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
          EXCEPTION
              WHEN OTHERS THEN
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                                      'P_REPORTE_TAREAS',
                                                        Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                          DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                          DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                        NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END;

      END IF;

      --Mensaje de respuesta
      Pv_Status  := 'ok';
      Pv_Message := 'Proceso ejecutado correctamente';

      --Insertamos la ejecuci�n por ok del reporte.
      IF Lt_InsertaOk IS NULL OR UPPER(Lt_InsertaOk) = 'S' THEN

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                              'P_REPORTE_TAREAS',
                                                Pv_Message,
                                                NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      END IF;

    EXCEPTION

      WHEN OTHERS THEN

          Pv_Status  := 'fail';
          Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;
          Lv_Codigo  := Lv_Codigo || Lv_EsConsulta;

          IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

              --Eliminaci�n del archivo
              BEGIN

                  IF Lt_NombreDirectorio IS NOT NULL AND Lv_NombreArchivo IS NOT NULL THEN

                      UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                      IF Lb_Fexists THEN
                          UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo);
                      END IF;

                      IF Lt_ExtensionReporte IS NOT NULL THEN
                          UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo||Lt_ExtensionReporte, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                          IF Lb_Fexists THEN
                              UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
                          END IF;
                      END IF;

                  END IF;

              EXCEPTION
                  WHEN OTHERS THEN
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                                          'P_REPORTE_TAREAS',
                                                            Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                            NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                            SYSDATE,
                                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
              END;

              IF Lv_Para IS NULL THEN
                  Lv_Para := NVL(Lt_CorreoError,'sistemas@telconet.ec');
              END IF;

              IF Lt_CorreoRemitente IS NULL THEN
                  Lt_CorreoRemitente := 'notificaciones_telcos@telconet.ec';
              END IF;

              IF Lt_AsuntoCorreo IS NULL THEN
                  Lt_AsuntoCorreo := 'REPORTE DE TAREAS (ERROR)';
              ELSE
                  Lt_AsuntoCorreo := Lt_AsuntoCorreo || ' (ERROR)';
              END IF;

              IF Lt_PlantillaError IS NOT NULL THEN
                  Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[userLogin]]' , Lv_UsuarioSolicita);
                  Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[diaReporte]]', TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS'));
              ELSE
                  Lt_PlantillaError := 'Estimado usuario '||Lv_UsuarioSolicita
                      ||', el reporte generado el d�a '||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')
                      ||' no se pudo generar. Por favor comunicar a Sistemas';
              END IF;

          END IF;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                              'P_REPORTE_TAREAS',
                                                Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

          Lv_Json := SUBSTR(Pcl_Json,0,3000);
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                              'P_REPORTE_TAREAS',
                                                Lv_Codigo||'|1- '||Lv_Json,
                                                NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Pcl_Json,3001,6000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                          'P_REPORTE_TAREAS',
                                            Lv_Codigo||'|2- '||Lv_Json,
                                            NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Pcl_Json,6001,8000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_INFO_TAREA',
                                          'P_REPORTE_TAREAS',
                                            Lv_Codigo||'|3- '||Lv_Json,
                                            NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

              UTL_MAIL.SEND(SENDER     => Lt_CorreoRemitente,
                            RECIPIENTS => Lv_Para,
                            SUBJECT    => Lt_AsuntoCorreo,
                            MESSAGE    => Lt_PlantillaError,
                            MIME_TYPE  => 'text/html; charset=UTF-8');

          END IF;

  END P_REPORTE_TAREAS;


  PROCEDURE P_MIGRAR_TAREAS(pn_anio_desde NUMBER, pv_por_estado VARCHAR2, pv_mensaje_respuesta OUT VARCHAR2)
  IS
    CURSOR C_GetTareas(cn_anio_desde NUMBER)
    IS
      SELECT        
        IDE.ID_DETALLE AS DETALLE_ID,
        IDE.LATITUD AS LATITUD,
        IDE.LONGITUD AS LONGITUD,
        IDE.USR_CREACION AS USR_CREACION_DETALLE,
        IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO,
        IDE.FE_CREACION AS FE_CREACION_DETALLE, 
        IDE.FE_SOLICITADA AS FE_SOLICITADA,
        IDE.OBSERVACION AS OBSERVACION,
        IDE.DETALLE_HIPOTESIS_ID AS DETALLE_HIPOTESIS_ID,
        ATA.ID_TAREA AS ID_TAREA,
        ATA.NOMBRE_TAREA AS NOMBRE_TAREA,
        ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA,
        APR.NOMBRE_PROCESO AS NOMBRE_PROCESO,
        ATA.PROCESO_ID AS PROCESO_ID,
        IDA.ASIGNADO_ID AS ASIGNADO_ID,
        IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE,
        IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID,
        IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE,
        IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID,
        IDA.ID_DETALLE_ASIGNACION AS ID_DETALLE_ASIGNACION,
        IDA.FE_CREACION AS FE_CREACION_ASIGNACION,
        IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID,
        IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO,
        IDA.CANTON_ID AS CANTON_ID,
        IDH.ESTADO AS ESTADO,
        IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL,
        IDH.FE_CREACION AS FE_CREACION_HIS,
        IDH.USR_CREACION AS USR_CREACION_HIS,
        IDH.OBSERVACION AS OBSERVACION_HISTORIAL,
        IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID,
        IDH.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID_HIS,
        IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS,
        (SELECT MIN(infoComunicacion.ID_COMUNICACION) 
        FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion 
        WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA,
        'telcos' AS USR_CREACION,
        SYSDATE AS FE_CREACION,
        '127.0.0.1' AS IP_CREACION,
        NULL AS USR_ULT_MOD,
        NULL AS FE_ULT_MOD,
        '' AS NUMERO
      FROM 
        DB_SOPORTE.INFO_DETALLE IDE
        JOIN DB_SOPORTE.ADMI_TAREA ATA ON IDE.TAREA_ID = ATA.ID_TAREA
        JOIN DB_SOPORTE.ADMI_PROCESO APR ON ATA.PROCESO_ID = APR.ID_PROCESO
        JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ON IDH.DETALLE_ID = IDE.ID_DETALLE

      WHERE 1=1 
        AND IDA.ID_DETALLE_ASIGNACION =  (SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) 
                                          FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX 
                                          WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) 

        AND IDH.ID_DETALLE_HISTORIAL  =  (SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) 
                                          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
                                          WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)
        AND EXTRACT(YEAR FROM IDE.FE_CREACION ) >= cn_anio_desde
        AND NOT EXISTS
            (SELECT ITA.DETALLE_ID FROM DB_SOPORTE.INFO_TAREA ITA WHERE ITA.DETALLE_ID = IDE.ID_DETALLE) 
        ORDER BY IDE.FE_CREACION ASC;

    CURSOR C_GetTareas_abiertas(cn_anio_desde NUMBER)
    IS
      SELECT        
        IDE.ID_DETALLE AS DETALLE_ID,
        IDE.LATITUD AS LATITUD,
        IDE.LONGITUD AS LONGITUD,
        IDE.USR_CREACION AS USR_CREACION_DETALLE,
        IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO,
        IDE.FE_CREACION AS FE_CREACION_DETALLE, 
        IDE.FE_SOLICITADA AS FE_SOLICITADA,
        IDE.OBSERVACION AS OBSERVACION,
        IDE.DETALLE_HIPOTESIS_ID AS DETALLE_HIPOTESIS_ID,
        ATA.ID_TAREA AS ID_TAREA,
        ATA.NOMBRE_TAREA AS NOMBRE_TAREA,
        ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA,
        APR.NOMBRE_PROCESO AS NOMBRE_PROCESO,
        ATA.PROCESO_ID AS PROCESO_ID,
        IDA.ASIGNADO_ID AS ASIGNADO_ID,
        IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE,
        IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID,
        IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE,
        IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID,
        IDA.ID_DETALLE_ASIGNACION AS ID_DETALLE_ASIGNACION,
        IDA.FE_CREACION AS FE_CREACION_ASIGNACION,
        IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID,
        IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO,
        IDA.CANTON_ID AS CANTON_ID,
        IDH.ESTADO AS ESTADO,
        IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL,
        IDH.FE_CREACION AS FE_CREACION_HIS,
        IDH.USR_CREACION AS USR_CREACION_HIS,
        IDH.OBSERVACION AS OBSERVACION_HISTORIAL,
        IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID,
        IDH.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID_HIS,
        IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS,
        (SELECT MIN(infoComunicacion.ID_COMUNICACION) 
        FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion 
        WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA,
        'telcos' AS USR_CREACION,
        SYSDATE AS FE_CREACION,
        '127.0.0.1' AS IP_CREACION,
        NULL AS USR_ULT_MOD,
        NULL AS FE_ULT_MOD,
        '' AS NUMERO
      FROM 
        DB_SOPORTE.INFO_DETALLE IDE
        JOIN DB_SOPORTE.ADMI_TAREA ATA ON IDE.TAREA_ID = ATA.ID_TAREA
        JOIN DB_SOPORTE.ADMI_PROCESO APR ON ATA.PROCESO_ID = APR.ID_PROCESO
        JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ON IDH.DETALLE_ID = IDE.ID_DETALLE

      WHERE 1=1
        AND IDA.ID_DETALLE_ASIGNACION =  (SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) 
                                          FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX 
                                          WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) 

        AND IDH.ID_DETALLE_HISTORIAL  =  (SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) 
                                          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
                                          WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)
        AND EXTRACT(YEAR FROM IDE.FE_CREACION ) >= cn_anio_desde
        AND IDH.ESTADO NOT IN ('Finalizada','Cancelada','Rechazada','Anulada') 
        AND NOT EXISTS
            (SELECT ITA.DETALLE_ID FROM DB_SOPORTE.INFO_TAREA ITA WHERE ITA.DETALLE_ID = IDE.ID_DETALLE) ;

    TYPE T_Array_tareas IS TABLE OF Gr_Tareas_migra INDEX BY BINARY_INTEGER;
    Lt_tareas T_Array_tareas;

    ln_idDetalle          NUMBER;
    Lt_Indice_tarea       NUMBER := 1;
    Lt_Indice_tarea_reg   NUMBER := 1;
    Ln_Indice_Anio_numera NUMBER := 1;
    ln_existeDetalle      NUMBER;
    lv_respuesta_ingresa  VARCHAR2(500) := '';
    BEGIN
      DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

      Ln_Indice_Anio_numera := pn_anio_desde;

      IF (C_GetTareas%isopen) THEN
        CLOSE C_GetTareas;
      END IF;
      IF (C_GetTareas_abiertas%isopen) THEN
        CLOSE C_GetTareas_abiertas;
      END IF;
      IF (pn_anio_desde IS NOT NULL AND pv_por_estado IS NOT NULL) THEN

        IF (pv_por_estado = 'ABIERTAS') THEN
          OPEN C_GetTareas_abiertas(pn_anio_desde);
            FETCH C_GetTareas_abiertas BULK COLLECT INTO Lt_tareas LIMIT 100000000;
          CLOSE C_GetTareas_abiertas;
        ELSIF (pv_por_estado = 'TODAS') THEN
          OPEN C_GetTareas(pn_anio_desde);
            FETCH C_GetTareas BULK COLLECT INTO Lt_tareas LIMIT 100000000;
          CLOSE C_GetTareas;  
        END IF;

        WHILE Lt_Indice_tarea <= Lt_tareas.COUNT LOOP

          ln_idDetalle := Lt_tareas(Lt_Indice_tarea).DETALLE_ID;

            P_REGISTRA_EN_INFO_TAREA(Lt_tareas(Lt_Indice_tarea), 'N', lv_respuesta_ingresa);
            Lt_Indice_tarea_reg := Lt_Indice_tarea_reg + 1;

          IF MOD(Lt_Indice_tarea,5000) = 0 THEN
            COMMIT;
          END IF;

          Lt_Indice_tarea := Lt_Indice_tarea + 1;
        END LOOP;
        COMMIT;
      END IF;

      WHILE Ln_Indice_Anio_numera <= EXTRACT(YEAR FROM SYSDATE) LOOP
          P_NUMERAR_INFO_TAREA(Ln_Indice_Anio_numera, pv_mensaje_respuesta);
          Ln_Indice_Anio_numera := Ln_Indice_Anio_numera + 1;
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('TOTAL:'||(Lt_Indice_tarea-1));
      DBMS_OUTPUT.PUT_LINE('REGISTROS:'||(Lt_Indice_tarea_reg-1));
      DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

      pv_mensaje_respuesta := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_MIGRAR_TAREAS',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_MIGRAR_TAREAS;


  PROCEDURE P_SYNC_TAREAS_NUEVAS_DIA(pv_mensaje_respuesta OUT VARCHAR2)
  IS
    CURSOR C_GetTareas
    IS

      SELECT        
        IDE.ID_DETALLE AS DETALLE_ID,
        IDE.LATITUD AS LATITUD,
        IDE.LONGITUD AS LONGITUD,
        IDE.USR_CREACION AS USR_CREACION_DETALLE,
        IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO,
        IDE.FE_CREACION AS FE_CREACION_DETALLE, 
        IDE.FE_SOLICITADA AS FE_SOLICITADA,
        IDE.OBSERVACION AS OBSERVACION,
        IDE.DETALLE_HIPOTESIS_ID AS DETALLE_HIPOTESIS_ID,
        ATA.ID_TAREA AS ID_TAREA,
        ATA.NOMBRE_TAREA AS NOMBRE_TAREA,
        ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA,
        APR.NOMBRE_PROCESO AS NOMBRE_PROCESO,
        ATA.PROCESO_ID AS PROCESO_ID,
        IDA.ASIGNADO_ID AS ASIGNADO_ID,
        IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE,
        IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID,
        IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE,
        IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID,
        IDA.ID_DETALLE_ASIGNACION AS ID_DETALLE_ASIGNACION,
        IDA.FE_CREACION AS FE_CREACION_ASIGNACION,
        IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID,
        IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO,
        IDA.CANTON_ID AS CANTON_ID,
        IDH.ESTADO AS ESTADO,
        IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL,
        IDH.FE_CREACION AS FE_CREACION_HIS,
        IDH.USR_CREACION AS USR_CREACION_HIS,
        IDH.OBSERVACION AS OBSERVACION_HISTORIAL,
        IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID,
        IDH.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID_HIS,
        IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS,
        (SELECT MIN(infoComunicacion.ID_COMUNICACION) 
        FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion 
        WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA,
        'telcos' AS USR_CREACION,
        SYSTIMESTAMP AS FE_CREACION,
        '127.0.0.1' AS IP_CREACION,
        'telcos' AS USR_ULT_MOD,
        SYSTIMESTAMP AS FE_ULT_MOD,
        NULL AS NUMERO
      FROM 
        DB_SOPORTE.INFO_DETALLE IDE
        JOIN DB_SOPORTE.ADMI_TAREA ATA ON IDE.TAREA_ID = ATA.ID_TAREA
        JOIN DB_SOPORTE.ADMI_PROCESO APR ON ATA.PROCESO_ID = APR.ID_PROCESO
        JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
        JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ON IDH.DETALLE_ID = IDE.ID_DETALLE

      WHERE 
        1                =  1

        AND IDA.ID_DETALLE_ASIGNACION =  (SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) 
                                          FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX 
                                          WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) 

        AND IDH.ID_DETALLE_HISTORIAL  =  (SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) 
                                          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
                                          WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)
        AND IDE.FE_CREACION >= TO_TIMESTAMP(TO_CHAR(SYSDATE-1,'YYYY-MM-DD'),'YYYY-MM_DD')
        AND NOT EXISTS
            (SELECT ITA.DETALLE_ID FROM DB_SOPORTE.INFO_TAREA ITA WHERE ITA.DETALLE_ID = IDE.ID_DETALLE)
    ;

    TYPE T_Array_tareas IS TABLE OF Gr_Tareas_migra INDEX BY BINARY_INTEGER;
    Lt_tareas T_Array_tareas;

    ln_idDetalle          NUMBER;
    Lt_Indice_tarea       NUMBER := 1;
    Lt_Indice_tarea_reg   NUMBER := 1;
    ln_existeDetalle      NUMBER;
    lv_respuesta_ingresa  VARCHAR2(500) := '';
    BEGIN

      IF (C_GetTareas%isopen) THEN
        CLOSE C_GetTareas;
      END IF;

      OPEN C_GetTareas;
        FETCH C_GetTareas BULK COLLECT INTO Lt_tareas LIMIT 10000000;
      CLOSE C_GetTareas;

      WHILE Lt_Indice_tarea <= Lt_tareas.COUNT LOOP

        ln_idDetalle := Lt_tareas(Lt_Indice_tarea).DETALLE_ID;

        P_REGISTRA_EN_INFO_TAREA(Lt_tareas(Lt_Indice_tarea), 'S', lv_respuesta_ingresa);
        Lt_Indice_tarea_reg := Lt_Indice_tarea_reg + 1;

        COMMIT;

        Lt_Indice_tarea := Lt_Indice_tarea + 1;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[P_SYNC_TAREAS_NUEVAS_DIA]');
    DBMS_OUTPUT.PUT_LINE('TOTAL:'||(Lt_Indice_tarea-1));
    DBMS_OUTPUT.PUT_LINE('REGISTROS:'||(Lt_Indice_tarea_reg-1));
    pv_mensaje_respuesta := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_SYNC_TAREAS_NUEVAS_DIA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );

  END P_SYNC_TAREAS_NUEVAS_DIA;





  PROCEDURE P_NUMERAR_INFO_TAREA(pn_anio NUMBER, pv_mensaje_respuesta OUT VARCHAR2)
  IS
    CURSOR C_GetTareas(cn_anio NUMBER)
    IS
      SELECT ID_INFO_TAREA, FE_CREACION_DETALLE 
      FROM DB_SOPORTE.INFO_TAREA WHERE EXTRACT(YEAR FROM FE_CREACION_DETALLE) = cn_anio ORDER BY FE_CREACION_DETALLE ASC;

    TYPE T_Array_tareas IS TABLE OF Gr_Tareas_numera INDEX BY BINARY_INTEGER;
    Lt_tareas T_Array_tareas;

    ln_idDetalle          NUMBER;
    Lt_Indice_tarea       NUMBER := 1;
    ln_existeDetalle      NUMBER;
    lv_respuesta_ingresa  VARCHAR2(500) := '';
    lv_numero             VARCHAR2(20);
    ln_secuencia          NUMBER := 1;
    lv_bandera_fecha      VARCHAR2(20);
    BEGIN

      IF (C_GetTareas%isopen) THEN
        CLOSE C_GetTareas;
      END IF;

      OPEN C_GetTareas(pn_anio);
        FETCH C_GetTareas BULK COLLECT INTO Lt_tareas LIMIT 10000000;
      CLOSE C_GetTareas;

      WHILE Lt_Indice_tarea <= Lt_tareas.COUNT LOOP
        IF Lt_Indice_tarea > 1 THEN

            IF ln_secuencia  = 1 THEN
              lv_bandera_fecha := TO_CHAR(Lt_tareas(Lt_Indice_tarea).FE_CREACION_DETALLE,'YYYY-MM-DD');
            END IF;

            IF lv_bandera_fecha != TO_CHAR(Lt_tareas(Lt_Indice_tarea).FE_CREACION_DETALLE,'YYYY-MM-DD') THEN
              ln_secuencia  := 1;
            ELSE
              ln_secuencia  := ln_secuencia + 1;
            END IF;

        END IF;
        lv_numero := TO_CHAR(Lt_tareas(Lt_Indice_tarea).FE_CREACION_DETALLE,'YYYYMMDD')||'-T'||LPAD(ln_secuencia,5,'0');

        IF lv_numero IS NOT NULL THEN
          UPDATE DB_SOPORTE.INFO_TAREA 
          SET NUMERO = lv_numero
          WHERE ID_INFO_TAREA = Lt_tareas(Lt_Indice_tarea).ID_INFO_TAREA;
        END IF;
        IF MOD(Lt_Indice_tarea,5000) = 0 THEN
          COMMIT;
        END IF;

        Lt_Indice_tarea := Lt_Indice_tarea + 1;

      END LOOP;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[P_NUMERAR_INFO_TAREA]');
      DBMS_OUTPUT.PUT_LINE('TOTAL:'||(Lt_Indice_tarea-1));
      pv_mensaje_respuesta := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_NUMERAR_INFO_TAREA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_NUMERAR_INFO_TAREA;
  /*
  * Documentaci�n para TYPE 'P_SYNC_TAREAS_EXISTENTES'.
  * Mejora para disminuir el costo de query Antes: 271373 Ahora: 36718
  * @author Jose Guaman <jaguamanp@telconet.ec>
  * @version 1.0 18-10-2022
  */
  PROCEDURE P_SYNC_TAREAS_EXISTENTES(pn_dias_actualiza IN NUMBER, pv_mensaje_respuesta OUT VARCHAR2)
  IS
    CURSOR C_GetTareas(cn_Dias NUMBER)
    IS
      SELECT        
        DETALLE_ID
      FROM 
        DB_SOPORTE.INFO_TAREA ITA
      WHERE 
        1 = 1
        AND ITA.DETALLE_HISTORIAL_ID <> ( SELECT MAX (IDHMAX.ID_DETALLE_HISTORIAL) AS MAXIMO
         FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
         WHERE IDHMAX.DETALLE_ID = ITA.DETALLE_ID )
       AND ITA.FE_CREACION_DETALLE >= TO_TIMESTAMP(TO_CHAR(SYSDATE - cn_Dias, 'YYYY-MM-DD'),'YYYY-MM_DD') 
       AND ITA.FE_CREACION_DETALLE <= systimestamp;

    TYPE T_Array_tareas IS TABLE OF DB_SOPORTE.INFO_TAREA.DETALLE_ID%TYPE INDEX BY BINARY_INTEGER;
    Lt_tareas T_Array_tareas;

    Lt_Indice_tarea       NUMBER := 1;
    lv_respuesta_ingresa  VARCHAR2(500) := '';

    Pv_Status_update VARCHAR2(100);
    Pv_Message_update VARCHAR2(100);

    BEGIN

      IF (C_GetTareas%isopen) THEN
        CLOSE C_GetTareas;
      END IF;

      OPEN C_GetTareas(pn_dias_actualiza);
        FETCH C_GetTareas BULK COLLECT INTO Lt_tareas LIMIT 10000000;
      CLOSE C_GetTareas;

      WHILE Lt_Indice_tarea <= Lt_tareas.COUNT LOOP

        P_UPDATE_TAREA( Lt_tareas(Lt_Indice_tarea),
                        'telcos',
                        Pv_Status_update,
                        Pv_Message_update);


        Lt_Indice_tarea := Lt_Indice_tarea + 1;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[P_SYNC_TAREAS_EXISTENTES]');
   DBMS_OUTPUT.PUT_LINE('TOTAL:'||(Lt_Indice_tarea-1));
    pv_mensaje_respuesta := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_SYNC_TAREAS_EXISTENTES',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );

  END P_SYNC_TAREAS_EXISTENTES;

  PROCEDURE P_UPDATE_TAREA( Pn_id_detalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
                            Pv_usr_ult_mod IN DB_SOPORTE.INFO_TAREA.USR_ULT_MOD%TYPE,
                            Pv_Status   OUT VARCHAR2,
                            Pv_Message  OUT VARCHAR2)
  IS

    Lg_tareas              Gr_Tareas_migra;
    ln_existeDetalle       NUMBER;
    lv_respuesta_actualiza VARCHAR2(500) := '';
    BEGIN

      Pv_Status  := 'ok';
      Pv_Message := 'Proceso ejecutado correctamente';

      BEGIN
        SELECT        
          IDE.ID_DETALLE AS DETALLE_ID,
          IDE.LATITUD AS LATITUD,
          IDE.LONGITUD AS LONGITUD,
          IDE.USR_CREACION AS USR_CREACION_DETALLE,
          IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO,
          IDE.FE_CREACION AS FE_CREACION_DETALLE, 
          IDE.FE_SOLICITADA AS FE_SOLICITADA,
          IDE.OBSERVACION AS OBSERVACION,
          IDE.DETALLE_HIPOTESIS_ID AS DETALLE_HIPOTESIS_ID,
          ATA.ID_TAREA AS ID_TAREA,
          ATA.NOMBRE_TAREA AS NOMBRE_TAREA,
          ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA,
          APR.NOMBRE_PROCESO AS NOMBRE_PROCESO,
          ATA.PROCESO_ID AS PROCESO_ID,
          IDA.ASIGNADO_ID AS ASIGNADO_ID,
          IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE,
          IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID,
          IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE,
          IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID,
          IDA.ID_DETALLE_ASIGNACION AS ID_DETALLE_ASIGNACION,
          IDA.FE_CREACION AS FE_CREACION_ASIGNACION,
          IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID,
          IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO,
          IDA.CANTON_ID AS CANTON_ID,
          IDH.ESTADO AS ESTADO,
          IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL,
          IDH.FE_CREACION AS FE_CREACION_HIS,
          IDH.USR_CREACION AS USR_CREACION_HIS,
          IDH.OBSERVACION AS OBSERVACION_HISTORIAL,
          IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID,
          IDH.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID_HIS,
          IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS,
          (SELECT MIN(infoComunicacion.ID_COMUNICACION) 
          FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion 
          WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA,
          NULL AS USR_CREACION,
          NULL AS FE_CREACION,
          NULL AS IP_CREACION,
          Pv_usr_ult_mod AS USR_ULT_MOD,
          SYSTIMESTAMP AS FE_ULT_MOD,
          '' AS NUMERO

          INTO

          Lg_tareas

        FROM 
          DB_SOPORTE.INFO_DETALLE IDE
          JOIN DB_SOPORTE.ADMI_TAREA ATA ON IDE.TAREA_ID = ATA.ID_TAREA
          JOIN DB_SOPORTE.ADMI_PROCESO APR ON ATA.PROCESO_ID = APR.ID_PROCESO
          JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA ON IDA.DETALLE_ID = IDE.ID_DETALLE
          JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ON IDH.DETALLE_ID = IDE.ID_DETALLE

        WHERE 
                                      1 =  1

          AND IDA.ID_DETALLE_ASIGNACION =  (SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) 
                                            FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX 
                                            WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) 

          AND IDH.ID_DETALLE_HISTORIAL  =  (SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) 
                                            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
                                            WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)
          AND IDE.ID_DETALLE            =  Pn_id_detalle;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Pv_Status  := 'error';
        Pv_Message := 'No se pudo actualizar registro en INFO_TAREA porque no se encontr� tarea con id_detalle:' || Pn_id_detalle;
        db_general.gnrlpck_util.insert_error('Telcos +',
                                              'SPKG_INFO_TAREA.P_UPDATE_TAREA',
                                              Pv_Message,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                            );
      END;
      IF Pv_Status = 'ok' THEN
        P_ACTUALIZA_EN_INFO_TAREA(Lg_tareas, lv_respuesta_actualiza);
      END IF;
      COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
      Pv_Message := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_UPDATE_TAREA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_UPDATE_TAREA;


  PROCEDURE P_REGISTRA_EN_INFO_TAREA(pg_tareas Gr_Tareas_migra, pv_valida_existe VARCHAR2, pv_mensaje_respuesta OUT VARCHAR2)
  IS
  Ln_detalle_id NUMBER;
  Lv_numeracion VARCHAR2(20);
  BEGIN

    IF pv_valida_existe = 'S' THEN
      BEGIN
        SELECT DETALLE_ID INTO Ln_detalle_id FROM DB_SOPORTE.INFO_TAREA WHERE DETALLE_ID = pg_tareas.DETALLE_ID;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Ln_detalle_id := NULL;
      END;
    ELSE
        Ln_detalle_id := NULL;
    END IF;

    IF (Ln_detalle_id IS NULL) THEN

        IF pg_tareas.NUMERO IS NULL THEN
            Lv_numeracion := DB_SOPORTE.SPKG_INFO_TAREA.F_GET_NUMERACION_INFO_TAREA(pg_tareas.FE_CREACION_DETALLE);
        ELSE
            Lv_numeracion := pg_tareas.NUMERO;
        END IF;

        INSERT INTO DB_SOPORTE.INFO_TAREA (
          ID_INFO_TAREA, 
          OBSERVACION_HISTORIAL,
          OBSERVACION,
          PERSONA_EMPRESA_ROL_ID_HIS,
          ASIGNADO_ID_HIS,
          DEPARTAMENTO_ORIGEN_ID,
          DETALLE_ID,
          LATITUD,
          LONGITUD,
          USR_CREACION_DETALLE,
          DETALLE_ID_RELACIONADO,
          TAREA_ID,
          NOMBRE_TAREA,
          DESCRIPCION_TAREA,
          ASIGNADO_ID ,
          ASIGNADO_NOMBRE,
          REF_ASIGNADO_ID,
          REF_ASIGNADO_NOMBRE,
          PERSONA_EMPRESA_ROL_ID,
          DEPARTAMENTO_ID,
          CANTON_ID,
          ESTADO,
          USR_CREACION_HIS,
          TIPO_ASIGNADO,
          FE_CREACION_DETALLE,
          FE_SOLICITADA,
          FE_CREACION_ASIGNACION,
          FE_CREACION_HIS,
          NUMERO_TAREA,
          NOMBRE_PROCESO,
          PROCESO_ID,
          DETALLE_HISTORIAL_ID,
          DETALLE_ASIGNACION_ID,
          DETALLE_HIPOTESIS_ID,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          NUMERO
        )
        VALUES(
          DB_SOPORTE.SEQ_INFO_TAREA.NEXTVAL,
          pg_tareas.OBSERVACION_HISTORIAL,
          pg_tareas.OBSERVACION,
          pg_tareas.PERSONA_EMPRESA_ROL_ID_HIS,
          pg_tareas.ASIGNADO_ID_HIS,
          pg_tareas.DEPARTAMENTO_ORIGEN_ID,
          pg_tareas.DETALLE_ID,
          pg_tareas.LATITUD,
          pg_tareas.LONGITUD,
          pg_tareas.USR_CREACION_DETALLE,
          pg_tareas.DETALLE_ID_RELACIONADO,
          pg_tareas.ID_TAREA,
          pg_tareas.NOMBRE_TAREA,
          pg_tareas.DESCRIPCION_TAREA,
          pg_tareas.ASIGNADO_ID,
          pg_tareas.ASIGNADO_NOMBRE,
          pg_tareas.REF_ASIGNADO_ID,
          pg_tareas.REF_ASIGNADO_NOMBRE,
          pg_tareas.PERSONA_EMPRESA_ROL_ID,
          pg_tareas.DEPARTAMENTO_ID,
          pg_tareas.CANTON_ID,
          pg_tareas.ESTADO,
          pg_tareas.USR_CREACION_HIS,
          pg_tareas.TIPO_ASIGNADO,
          pg_tareas.FE_CREACION_DETALLE,
          pg_tareas.FE_SOLICITADA,
          pg_tareas.FE_CREACION_ASIGNACION,
          pg_tareas.FE_CREACION_HIS,
          pg_tareas.NUMERO_TAREA,
          pg_tareas.NOMBRE_PROCESO,
          pg_tareas.PROCESO_ID,
          pg_tareas.ID_DETALLE_HISTORIAL,
          pg_tareas.ID_DETALLE_ASIGNACION,
          pg_tareas.DETALLE_HIPOTESIS_ID,
          pg_tareas.USR_CREACION,
          SYSTIMESTAMP,
          pg_tareas.IP_CREACION,
          Lv_numeracion
        );
    ELSE
      P_ACTUALIZA_EN_INFO_TAREA(pg_tareas, pv_mensaje_respuesta);
    END IF;
    pv_mensaje_respuesta := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_REGISTRA_EN_INFO_TAREA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_REGISTRA_EN_INFO_TAREA;

  PROCEDURE P_ACTUALIZA_EN_INFO_TAREA(pg_tareas Gr_Tareas_migra, pv_mensaje_respuesta OUT VARCHAR2)
  IS

  BEGIN

    UPDATE DB_SOPORTE.INFO_TAREA SET 
      OBSERVACION_HISTORIAL      = pg_tareas.OBSERVACION_HISTORIAL,
      OBSERVACION                = pg_tareas.OBSERVACION,
      PERSONA_EMPRESA_ROL_ID_HIS = pg_tareas.PERSONA_EMPRESA_ROL_ID_HIS,
      ASIGNADO_ID_HIS            = pg_tareas.ASIGNADO_ID_HIS,
      DEPARTAMENTO_ORIGEN_ID     = pg_tareas.DEPARTAMENTO_ORIGEN_ID,
      LATITUD                    = pg_tareas.LATITUD,
      LONGITUD                   = pg_tareas.LONGITUD,
      USR_CREACION_DETALLE       = pg_tareas.USR_CREACION_DETALLE,
      DETALLE_ID_RELACIONADO     = pg_tareas.DETALLE_ID_RELACIONADO,
      TAREA_ID                   = pg_tareas.ID_TAREA,
      NOMBRE_TAREA               = pg_tareas.NOMBRE_TAREA,
      DESCRIPCION_TAREA          = pg_tareas.DESCRIPCION_TAREA,
      ASIGNADO_ID                = pg_tareas.ASIGNADO_ID,
      ASIGNADO_NOMBRE            = pg_tareas.ASIGNADO_NOMBRE,
      REF_ASIGNADO_ID            = pg_tareas.REF_ASIGNADO_ID,
      REF_ASIGNADO_NOMBRE        = pg_tareas.REF_ASIGNADO_NOMBRE,
      PERSONA_EMPRESA_ROL_ID     = pg_tareas.PERSONA_EMPRESA_ROL_ID,
      DEPARTAMENTO_ID            = pg_tareas.DEPARTAMENTO_ID,
      CANTON_ID                  = pg_tareas.CANTON_ID,
      ESTADO                     = pg_tareas.ESTADO,
      USR_CREACION_HIS           = pg_tareas.USR_CREACION_HIS,
      TIPO_ASIGNADO              = pg_tareas.TIPO_ASIGNADO,
      FE_CREACION_DETALLE        = pg_tareas.FE_CREACION_DETALLE,
      FE_SOLICITADA              = pg_tareas.FE_SOLICITADA,
      FE_CREACION_ASIGNACION     = pg_tareas.FE_CREACION_ASIGNACION,
      FE_CREACION_HIS            = pg_tareas.FE_CREACION_HIS,
      NUMERO_TAREA               = pg_tareas.NUMERO_TAREA,
      NOMBRE_PROCESO             = pg_tareas.NOMBRE_PROCESO,
      PROCESO_ID                 = pg_tareas.PROCESO_ID,
      DETALLE_HISTORIAL_ID       = pg_tareas.ID_DETALLE_HISTORIAL,
      DETALLE_ASIGNACION_ID      = pg_tareas.ID_DETALLE_ASIGNACION,
      DETALLE_HIPOTESIS_ID       = pg_tareas.DETALLE_HIPOTESIS_ID,
      USR_ULT_MOD                = pg_tareas.USR_ULT_MOD,
      FE_ULT_MOD                 = pg_tareas.FE_ULT_MOD
    WHERE
      DETALLE_ID                 = pg_tareas.DETALLE_ID;

    pv_mensaje_respuesta := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_ACTUALIZA_EN_INFO_TAREA',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_ACTUALIZA_EN_INFO_TAREA;




  FUNCTION F_GET_REENVIAR_SYSCLOUD(
                                       Pv_numero_tarea VARCHAR2,
                                       Pv_Usr_creacion_detalle  VARCHAR2,  
                                       Pn_Departamento_asignado NUMBER, 
                                       Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2
  IS

    Ln_Indice_param        NUMBER        := 1;
    Ln_Indice_carac        NUMBER        := 1;
    Lv_valor1              VARCHAR2(100);
    Ln_Id_caracteristica   NUMBER;
    Lv_valor_info_ta_carac VARCHAR2(100);

    Ln_consulta            NUMBER        := 0;
    Le_Exception           EXCEPTION;
    Lv_camp_retorna        VARCHAR2(100)   := '{"gestion_completa":"S","reenviar_syscloud":"N"}';
    Lv_gestion_completa    VARCHAR2(1)   := 'N';
    Lv_reenviar_syscloud   VARCHAR2(1)   := 'N';
    Lv_MensajeError        VARCHAR2(4000);

  BEGIN

    IF Pn_Departamento_asignado IS NOT NULL THEN
      BEGIN
      SELECT det.VALOR1 INTO Lv_valor1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab 
      JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO
      WHERE 
      det.ESTADO               = 'Activo'
      AND cab.ESTADO           = 'Activo'
      AND cab.NOMBRE_PARAMETRO = 'USUARIOS LIMITADORES DE GESTION DE TAREAS'
      AND cab.MODULO           = 'SOPORTE' 
      AND det.VALOR1           = Pn_Departamento_asignado;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_camp_retorna := '{"gestion_completa":"S","reenviar_syscloud":"N"}';
          Lv_valor1       := NULL;
      END;
      IF Lv_valor1 IS NOT NULL THEN
        Lv_camp_retorna := '{"gestion_completa":"N","reenviar_syscloud":"N"}';
        IF Pv_Usr_creacion_detalle <> 'telcoSys' THEN

          BEGIN

            SELECT ID_CARACTERISTICA INTO Ln_Id_caracteristica 
            FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
            WHERE 
            DESCRIPCION_CARACTERISTICA = 'TAREA_SYS_CLOUD_CENTER'
            AND ESTADO                 = 'Activo';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Lv_camp_retorna := '{"gestion_completa":"N","reenviar_syscloud":"N"}';
              Ln_Id_caracteristica := NULL;
          END;

          IF Ln_Id_caracteristica IS NOT NULL AND 
             Pv_numero_tarea IS NOT NULL AND
             Lv_valor1 = Pv_Id_departamento_sesion THEN

             BEGIN
                  SELECT VALOR INTO Lv_valor_info_ta_carac 
                  FROM DB_SOPORTE.INFO_TAREA_CARACTERISTICA 
                  WHERE 
                  CARACTERISTICA_ID   = Ln_Id_caracteristica
                    AND TAREA_ID      = Pv_numero_tarea
                    AND ESTADO        = 'Activo';
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    Lv_camp_retorna := '{"gestion_completa":"N","reenviar_syscloud":"N"}';
                    Lv_valor_info_ta_carac := NULL;
             END;
             IF Lv_valor_info_ta_carac IS NULL OR Lv_valor_info_ta_carac = 'N' THEN
                     Lv_camp_retorna := '{"gestion_completa":"N","reenviar_syscloud":"S"}';
             END IF;

          END IF;

        END IF;

      END IF;

    END IF;

  RETURN Lv_camp_retorna;
  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_REENVIAR_SYSCLOUD',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_REENVIAR_SYSCLOUD;



  FUNCTION F_GET_NOMB_ACTUALIZADO_POR(
                                       Pv_obs_historial CLOB,
                                       Pv_Usr_creacion_historial  VARCHAR2,  
                                       Pv_msg_reasigna_aut_camb_dep CLOB)
     RETURN VARCHAR2
  IS
    Lv_Nombre_persona VARCHAR2(2000) := '';
    Le_Exception      EXCEPTION;
    Lv_camp_retorna   VARCHAR2(2000) := '';
    Lv_MensajeError   VARCHAR2(4000);

  BEGIN

    IF Pv_Usr_creacion_historial IS NOT NULL THEN 

            SELECT MAX(CASE WHEN ip.RAZON_SOCIAL IS NOT NULL THEN ip.RAZON_SOCIAL 
                        WHEN ip.NOMBRES IS NOT NULL AND ip.APELLIDOS IS NOT NULL THEN ip.NOMBRES || ' ' || ip.APELLIDOS
                        WHEN ip.REPRESENTANTE_LEGAL IS NOT NULL THEN ip.REPRESENTANTE_LEGAL 
                        ELSE '' END) NOMBRE INTO Lv_Nombre_persona
            FROM INFO_PERSONA ip,
                INFO_PERSONA_EMPRESA_ROL iper 
            WHERE ip.LOGIN           = Pv_Usr_creacion_historial 
            AND   ip.ID_PERSONA              = iper.PERSONA_ID
            AND   LOWER(iper.ESTADO) = LOWER('Activo') ;

            IF Lv_Nombre_persona IS NOT NULL THEN

                Lv_Nombre_persona := INITCAP( LOWER(Lv_Nombre_persona) );
                Lv_camp_retorna := Lv_Nombre_persona;
                IF Pv_msg_reasigna_aut_camb_dep IS NOT NULL  AND 
                   Pv_obs_historial IS NOT NULL  AND
                   Pv_msg_reasigna_aut_camb_dep = Pv_obs_historial
                THEN
                  Lv_camp_retorna := Lv_Nombre_persona || ' (Proceso Autom�tico por cambio de departamento)';
                END IF;

            END IF;

    END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_NOMB_ACTUALIZADO_POR',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_NOMB_ACTUALIZADO_POR;

  FUNCTION F_GET_SI_MUESTRA_COORD_MANGA(
                                       Pn_Id_tarea NUMBER)
     RETURN VARCHAR2
  IS
    Lv_valor1                VARCHAR2(4000);
    Lv_valor3                VARCHAR2(4000);
    Lv_Mostrar_coordenada    VARCHAR2(1) := 'N';
    Lv_Tareas_manga          VARCHAR2(1) := 'N';

    Le_Exception         EXCEPTION;
    Lv_camp_retorna      VARCHAR2(100) := '{"mostrar_coordenada":"N","tareas_manga":"N"}';
    Lv_MensajeError      VARCHAR2(4000);

  BEGIN

    IF Pn_Id_tarea > 0 THEN 
      BEGIN
          SELECT det.VALOR1, det.VALOR3 INTO Lv_valor1, Lv_valor3
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab 
          JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO
          WHERE 
          det.ESTADO               = 'Activo'
          AND cab.ESTADO           = 'Activo'
          AND cab.NOMBRE_PARAMETRO = 'TAREAS_PERMITIDAS_INGRESAR_COORDENADAS'
          AND cab.MODULO           = 'SOPORTE' 
          AND cab.PROCESO          = 'CASO' 
          AND det.DESCRIPCION      = 'TAREA SELECCIONAR COORDENADA' 
          AND det.VALOR1           = Pn_Id_tarea;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Lv_camp_retorna        :=  '{"mostrar_coordenada":"N","tareas_manga":"N"}';
            Lv_valor1              := NULL;
            Lv_valor3              := NULL;
      END;
      IF TO_NUMBER(Lv_valor1) = Pn_Id_tarea THEN
        Lv_Mostrar_coordenada := 'S';
        IF Lv_valor3 = 'S' THEN
          Lv_Tareas_manga := 'S';
        END IF;
        Lv_camp_retorna := '{"mostrar_coordenada":"'||Lv_Mostrar_coordenada||'","tareas_manga":"'||Lv_Tareas_manga||'"}';
      END IF;

    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_SI_MUESTRA_COORD_MANGA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_SI_MUESTRA_COORD_MANGA;


  FUNCTION F_GET_EMPRESA_DE_TAREA(Pn_numero_tarea NUMBER)
     RETURN VARCHAR2
  IS
    Lv_Prefijo_empresa   VARCHAR2(16);
    Lv_Cod_empresa       VARCHAR2(2);
    Le_Exception         EXCEPTION;
    Lv_camp_retorna      VARCHAR2(100) := '{"prefijo_empresa":"","cod_empresa":""}';
    Lv_MensajeError      VARCHAR2(4000);

  BEGIN

    IF Pn_numero_tarea IS NOT NULL AND Pn_numero_tarea > 0 THEN 
      BEGIN
          SELECT EMP.PREFIJO, EMP.COD_EMPRESA INTO Lv_Prefijo_empresa, Lv_Cod_empresa
          FROM DB_COMUNICACION.INFO_COMUNICACION COM 
          JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP ON EMP.COD_EMPRESA = COM.EMPRESA_COD
          WHERE
          COM.ID_COMUNICACION = Pn_numero_tarea;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Lv_Prefijo_empresa := NULL;
            Lv_Cod_empresa     := NULL;
      END;
      IF Lv_Cod_empresa IS NOT NULL THEN
        Lv_camp_retorna := '{"prefijo_empresa":"'||Lv_Prefijo_empresa||'","cod_empresa":"'||Lv_Cod_empresa||'"}';
      END IF;

    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_EMPRESA_DE_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_EMPRESA_DE_TAREA;


  FUNCTION F_GET_CERRAR_TAREA(Pn_Id_detalle NUMBER)
  RETURN VARCHAR2
  IS
  CURSOR C_GetTareasRelacionadas(Cn_Id_detalle NUMBER)
  IS
    SELECT det.*
      FROM DB_SOPORTE.INFO_DETALLE det 
    WHERE det.DETALLE_ID_RELACIONADO = Cn_Id_detalle;

  TYPE T_Array_detalles IS TABLE OF DB_SOPORTE.INFO_DETALLE%ROWTYPE INDEX BY BINARY_INTEGER;
  Lt_detalles_relacionados T_Array_detalles;

  Ln_Indice           NUMBER := 1;
  Lv_UltimoEstado     VARCHAR2(16);
  Le_Exception        EXCEPTION;
  Lv_camp_retorna     VARCHAR2(1) := 'S';
  Lv_MensajeError     VARCHAR2(4000);

  BEGIN

    IF (C_GetTareasRelacionadas%isopen) THEN
      CLOSE C_GetTareasRelacionadas;
    END IF;

    OPEN C_GetTareasRelacionadas(Pn_Id_detalle);
      FETCH C_GetTareasRelacionadas BULK COLLECT INTO Lt_detalles_relacionados LIMIT 100000;
    CLOSE C_GetTareasRelacionadas;

    WHILE Ln_Indice <= Lt_detalles_relacionados.COUNT LOOP
      BEGIN
      SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) INTO Lv_UltimoEstado
        FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX 
        WHERE IDHMAX.DETALLE_ID = Lt_detalles_relacionados(Ln_Indice).ID_DETALLE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN

            Lv_UltimoEstado := NULL;
      END;

      IF Lv_UltimoEstado IS NOT NULL AND 
         Lv_UltimoEstado <> 'Finalizada' AND Lv_UltimoEstado <> 'Rechazada' AND 
         Lv_UltimoEstado <> 'Cancelada' AND Lv_UltimoEstado <> 'Anulada' THEN

          Lv_camp_retorna := 'N';

      END IF;
      Ln_Indice := Ln_Indice + 1;
    END LOOP;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_CERRAR_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_CERRAR_TAREA;

  FUNCTION F_GET_TAREA_PADRE(Pn_Detalle_id_relacionado NUMBER)
     RETURN NUMBER
  IS
    Le_Exception         EXCEPTION;
    Ln_camp_retorna      NUMBER := NULL;
    Lv_MensajeError      VARCHAR2(4000);

  BEGIN

    IF Pn_Detalle_id_relacionado IS NOT NULL THEN 
      BEGIN
        SELECT MIN( com.ID_COMUNICACION ) INTO Ln_camp_retorna
        FROM  DB_SOPORTE.INFO_COMUNICACION com
        WHERE com.DETALLE_ID = Pn_Detalle_id_relacionado ;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN

            Ln_camp_retorna := NULL;
      END;
    END IF;

    RETURN Ln_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_TAREA_PADRE',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Ln_camp_retorna;
  END F_GET_TAREA_PADRE;

  FUNCTION F_GET_PERMITE_SEGUIMIENTO(Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2
  IS

    Lv_valor2        VARCHAR2(100);
    Le_Exception     EXCEPTION;
    Lv_camp_retorna  VARCHAR2(1) := 'N';
    Lv_MensajeError  VARCHAR2(4000);

  BEGIN
      BEGIN
        SELECT det.VALOR2 INTO Lv_valor2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab 
        JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO
        WHERE 
        det.ESTADO               = 'Activo'
        AND cab.ESTADO           = 'Activo'
        AND cab.NOMBRE_PARAMETRO = 'SEGUIMIENTO INTERNO'
        AND cab.MODULO           = 'SOPORTE' 
        AND cab.PROCESO          = 'CASOS' 
        AND det.DESCRIPCION      = 'DEPARTAMENTOS TN' 
        AND det.VALOR2           = Pv_Id_departamento_sesion;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_camp_retorna := 'N';
      END;
      IF Lv_valor2 IS NOT NULL THEN

        Lv_camp_retorna := 'S';

      END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
   WHEN NO_DATA_FOUND THEN
            Lv_camp_retorna := 'N';
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_PERMITE_SEGUIMIENTO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_PERMITE_SEGUIMIENTO;

  FUNCTION F_GET_PERMITE_ANULAR(Pn_Id_detalle NUMBER,
                                Pv_Estado VARCHAR2,
                                Pv_Id_usuario VARCHAR2)
     RETURN VARCHAR2
  IS

    Ln_total         NUMBER;
    Le_Exception     EXCEPTION;
    Lv_camp_retorna  VARCHAR2(1) := 'N';
    Lv_MensajeError  VARCHAR2(4000);

  BEGIN

    SELECT COUNT(infoDetalleAsignacion.ID_DETALLE_ASIGNACION) INTO Ln_total
    FROM 
        DB_SOPORTE.INFO_DETALLE_ASIGNACION infoDetalleAsignacion,
        DB_SOPORTE.INFO_DETALLE infoDetalle,
        DB_COMERCIAL.INFO_PERSONA infoPersona
        WHERE infoDetalleAsignacion.DETALLE_ID = infoDetalle.ID_DETALLE
        AND infoPersona.ID_PERSONA  = infoDetalleAsignacion.REF_ASIGNADO_ID
        AND infoPersona.LOGIN = infoDetalle.USR_CREACION 
        AND infoDetalleAsignacion.REF_ASIGNADO_ID = TO_NUMBER(Pv_Id_usuario) 
        AND infoDetalleAsignacion.DETALLE_ID = Pn_Id_detalle;


      IF Ln_total = 1 AND Pv_Estado = 'Asignada' THEN

        Lv_camp_retorna := 'S';

      END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_PERMITE_ANULAR',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_PERMITE_ANULAR;


  FUNCTION F_GET_ES_HAL(Pn_numero_tarea NUMBER)
     RETURN VARCHAR2
  IS

    Ln_total         NUMBER;
    Le_Exception     EXCEPTION;
    Lv_camp_retorna  VARCHAR2(1) := 'N';
    Lv_MensajeError  VARCHAR2(4000);

  BEGIN

    SELECT COUNT(DET.COMUNICACION_ID) INTO Ln_total 
    FROM
        DB_SOPORTE.INFO_CUADRILLA_PLANIF_CAB CAB, 
        DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET DET 
    WHERE CAB.ID_CUADRILLA_PLANIF_CAB = DET.CUADRILLA_PLANIF_CAB_ID 
    AND DET.COMUNICACION_ID = Pn_numero_tarea 
    AND CAB.ESTADO = 'Activo'  
    AND DET.ESTADO = 'Activo' ;


    IF Ln_total > 0  THEN

      Lv_camp_retorna := 'S';

    END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_ES_HAL',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_ES_HAL;



  FUNCTION F_GET_MUESTRA_PESTANA_HAL(Pn_id_tarea NUMBER)
     RETURN VARCHAR2
  IS

    Ln_total         NUMBER;
    Le_Exception     EXCEPTION;
    Lv_camp_retorna  VARCHAR2(1) := 'N';
    Lv_MensajeError  VARCHAR2(4000);

  BEGIN

        SELECT COUNT(*) INTO Ln_total
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab 
        JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO
        WHERE 
        det.ESTADO               = 'Activo'
        AND cab.ESTADO           = 'Activo'
        AND cab.NOMBRE_PARAMETRO = 'PLANIFICACION_TAREAS_HAL'
        AND cab.MODULO           = 'SOPORTE' 
        AND det.VALOR1           = Pn_id_tarea;

    IF Ln_total > 0  THEN

      Lv_camp_retorna := 'S';

    END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_MUESTRA_PESTANA_HAL',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_MUESTRA_PESTANA_HAL;



  FUNCTION F_GET_ATENDER_ANTES(Pn_numero_tarea NUMBER)
     RETURN VARCHAR2
  IS

    Ln_total             NUMBER;
    Ln_Id_caracteristica NUMBER;
    Le_Exception         EXCEPTION;
    Lv_camp_retorna      VARCHAR2(1) := 'N';
    Lv_MensajeError      VARCHAR2(4000);

  BEGIN
      BEGIN

        SELECT ID_CARACTERISTICA INTO Ln_Id_caracteristica 
        FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
        WHERE 
        DESCRIPCION_CARACTERISTICA = 'ATENDER_ANTES'
        AND ESTADO                 = 'Activo';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_camp_retorna := 'N';
          Ln_Id_caracteristica := NULL;
      END;

    IF Ln_Id_caracteristica IS NOT NULL  THEN

      SELECT COUNT(*) INTO Ln_total FROM DB_SOPORTE.INFO_TAREA_CARACTERISTICA WHERE 
      TAREA_ID = Pn_numero_tarea 
      AND CARACTERISTICA_ID = Ln_Id_caracteristica
      AND VALOR = 'S'
      AND ESTADO = 'Activo';

      IF Ln_total > 0 THEN 
        Lv_camp_retorna := 'S';
      END IF;

    END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_ATENDER_ANTES',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_ATENDER_ANTES;


  FUNCTION F_GET_MUESTRA_REPROGRAMAR(Pv_estado VARCHAR2, Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2
  IS
    Ln_total                   NUMBER;
    Lv_Mostrar_reprogramar_dep VARCHAR2(1)   := 'N';
    Lv_Mostrar_reprogramar_hal VARCHAR2(1)   := 'N';
    Le_Exception               EXCEPTION;
    Lv_camp_retorna            VARCHAR2(100) := '{"reprogramar_dep":"N","reprogramar_hal":"N"}';
    Lv_MensajeError            VARCHAR2(4000);

  BEGIN

    IF Pv_Id_departamento_sesion IS NOT NULL AND Pv_estado IS NOT NULL THEN 

      SELECT COUNT(*) INTO Ln_total
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab 
      JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO
      WHERE 
      det.ESTADO               = 'Activo'
      AND cab.ESTADO           = 'Activo'
      AND cab.NOMBRE_PARAMETRO = 'REPROGRAMAR_DEPARTAMENTO_HAL'
      AND cab.MODULO           = 'SOPORTE' 
      AND det.VALOR1           = Pv_Id_departamento_sesion;

      IF (Ln_total > 0 AND (Pv_estado = 'Aceptada' OR Pv_estado = 'Reprogramada' OR Pv_estado = 'Pausada' OR Pv_estado = 'Asignada') ) THEN
        Lv_Mostrar_reprogramar_dep := 'S';
      ELSIF (Pv_estado = 'Aceptada' OR Pv_estado = 'Reprogramada' OR Pv_estado = 'Pausada' OR Pv_estado = 'Asignada') THEN
        Lv_Mostrar_reprogramar_hal := 'S';
      END IF;

      Lv_camp_retorna := '{"reprogramar_dep":"'||Lv_Mostrar_reprogramar_dep||'","reprogramar_hal":"'||Lv_Mostrar_reprogramar_hal||'"}';

    END IF;

    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_MUESTRA_REPROGRAMAR',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_MUESTRA_REPROGRAMAR;



  FUNCTION F_GET_PERMITE_FINALIZAR_INFORM(Pn_detalle_id NUMBER, Pv_nombreTarea VARCHAR2, Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2
  IS

    Ln_total             NUMBER;
    Ln_Id_depart_origen  NUMBER;
    Le_Exception         EXCEPTION;
    Lv_camp_retorna      VARCHAR2(1) := 'S';
    Lv_MensajeError      VARCHAR2(4000);

  BEGIN
    IF Pv_nombreTarea = 'Realizar Informe Ejecutivo de Incidente' THEN
      BEGIN

        SELECT IDEHI2.DEPARTAMENTO_ORIGEN_ID INTO Ln_Id_depart_origen FROM INFO_DETALLE_HISTORIAL IDEHI2
        WHERE IDEHI2.ID_DETALLE_HISTORIAL = (
                    SELECT MIN(IDEHI.ID_DETALLE_HISTORIAL) FROM INFO_DETALLE_HISTORIAL IDEHI
                    WHERE IDEHI.DETALLE_ID = Pn_detalle_id );
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_camp_retorna := 'S';
          Ln_Id_depart_origen := NULL;
      END;

      IF Ln_Id_depart_origen IS NOT NULL AND Ln_Id_depart_origen <>  TO_NUMBER(Pv_Id_departamento_sesion) THEN

        Lv_camp_retorna := 'N';

      END IF;
    END IF;

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_PERMITE_FINALIZAR_INFORM',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_PERMITE_FINALIZAR_INFORM;


  FUNCTION F_GET_ES_DEPARTAMENTO(Pv_Tipo_asignado VARCHAR2,
                                 Pn_Asignado_id NUMBER,
                                 Pn_Persona_empresa_rol_id NUMBER,
                                 Pv_VerTodasLasTareas VARCHAR2,
                                 Pv_Dptos_empleado VARCHAR2, 
                                 Pv_Id_departamento_sesion VARCHAR2)
     RETURN VARCHAR2
  IS

    Ln_Id_departamento_persona  NUMBER;
    Lv_EsDepartamento           VARCHAR2(1) := 'S';
    Lv_EsDepartamentoAutGestion VARCHAR2(1) := 'N';
    Le_Exception                EXCEPTION;
    Lv_camp_retorna             VARCHAR2(100) := '{"es_departamento":"S","es_departamento_aut_gestion":"N"}';
    Lv_MensajeError             VARCHAR2(4000);

  BEGIN

    IF Pv_Tipo_asignado = 'EMPLEADO' THEN

      IF Pn_Asignado_id <> TO_NUMBER(Pv_Id_departamento_sesion) THEN
        Lv_EsDepartamento := 'N';
      ELSE
        Lv_EsDepartamento := 'S';
      END IF;

      IF Pv_VerTodasLasTareas = 'true' AND INSTR(Pv_Dptos_empleado,Pv_Id_departamento_sesion, 1, 1) > 0 THEN
        Lv_EsDepartamentoAutGestion := 'S';
      END IF;

    ELSIF Pv_Tipo_asignado = 'CUADRILLA' THEN

      BEGIN

        SELECT MAX(DEPARTAMENTO_ID) INTO Ln_Id_departamento_persona 
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
        WHERE ID_PERSONA_ROL = Pn_Persona_empresa_rol_id
          AND CUADRILLA_ID   = Pn_Asignado_id
          AND ESTADO         = 'Activo';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_camp_retorna := '{"es_departamento":"S","es_departamento_aut_gestion":"N"}';
          Ln_Id_departamento_persona := NULL;
      END;

      IF Ln_Id_departamento_persona IS NOT NULL AND Ln_Id_departamento_persona <>  TO_NUMBER(Pv_Id_departamento_sesion) THEN

        Lv_EsDepartamento := 'N';

      ELSE

        Lv_EsDepartamento := 'S';

      END IF;

    END IF;

    Lv_camp_retorna := '{"es_departamento":"'||Lv_EsDepartamento||'","es_departamento_aut_gestion":"'||Lv_EsDepartamentoAutGestion||'"}';

  RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_ES_DEPARTAMENTO',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_ES_DEPARTAMENTO;



  FUNCTION F_GET_NUMERACION_INFO_TAREA(pd_fe_creacion_detalle  DB_SOPORTE.INFO_TAREA.FE_CREACION_DETALLE%TYPE)
     RETURN VARCHAR2
  IS

    Le_Exception                EXCEPTION;
    Lv_inicial_numero           VARCHAR2(20);
    Ln_numero                   NUMBER;
    Lv_camp_retorna             VARCHAR2(20) := '';
    Lv_MensajeError             VARCHAR2(4000);
    Ln_secuencia                NUMBER;
    ln_idparametrodet           NUMBER;
    lv_ult_numeracion_ayer      VARCHAR2(10);
  BEGIN
    IF pd_fe_creacion_detalle IS NOT NULL THEN

      Lv_inicial_numero := TO_CHAR(pd_fe_creacion_detalle,'YYYYMMDD')||'-T';
      BEGIN

        IF TRUNC(pd_fe_creacion_detalle) = TRUNC(SYSDATE) THEN

            Ln_numero := DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA.NEXTVAL;

        ELSE
            SELECT DET.VALOR1, DET.ID_PARAMETRO_DET INTO lv_ult_numeracion_ayer, ln_idparametrodet 
            FROM DB_GENERAL.ADMI_PARAMETRO_DET DET 
            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID  
            WHERE CAB.NOMBRE_PARAMETRO = 'NUMERACION_INFO_TAREA' 
            AND DET.DESCRIPCION = 'NUMERACION';

            Ln_numero := TO_NUMBER(lv_ult_numeracion_ayer,99999)+1;

            UPDATE DB_GENERAL.ADMI_PARAMETRO_DET 
            SET VALOR1=Ln_numero, VALOR2= TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS') 
            WHERE ID_PARAMETRO_DET = ln_idparametrodet;

            COMMIT;

        END IF;


      EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Lv_camp_retorna := Lv_inicial_numero||LPAD(1,5,'0');
      END;

      IF Ln_numero IS NULL THEN
        Lv_camp_retorna := Lv_inicial_numero||LPAD(1,5,'0');
      ELSE
        Lv_camp_retorna := Lv_inicial_numero||LPAD(Ln_numero,5,'0');
      END IF;

    ELSE
      Lv_camp_retorna := NULL;
    END IF;
    RETURN Lv_camp_retorna;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_INFO_TAREA.F_GET_NUMERACION_INFO_TAREA',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_camp_retorna;
  END F_GET_NUMERACION_INFO_TAREA;

    PROCEDURE P_GET_FIBRA_TAREA(Pn_IdComunicacion NUMBER,
                             Pn_IdDetalle      NUMBER,
                             Pv_Retorno        OUT CLOB,
                             Pv_Error          OUT VARCHAR2)

  AS

    Le_Exception                EXCEPTION;
    Lv_MensajeError             VARCHAR2(4000);
    Lv_ContieneIdCom            VARCHAR2(1) := 'N'; 
    Lv_Query                    VARCHAR2(4000); 
    Lv_InComunicacion           VARCHAR2(2000);
    Lb_DataFound               BOOLEAN := FALSE;
    Ln_count                 NUMBER := 0;
        Ln_Indice                   NUMBER := 0;
    CURSOR C_FIBRA(Cv_Custodio VARCHAR2, Cv_Login VARCHAR2, Cd_FechaInicio TIMESTAMP, Cd_FechaFin TIMESTAMP) IS 
      SELECT 
      CUSTODIO_ID, EMPRESA_CUSTODIO_ID empresa_cliente, FECHA_INICIO fecha, ARTICULO_ID bobina, cantidad, TIPO_ACTIVIDAD, TIPO_ARTICULO, TIPO_TRANSACCION_ID, login, USR_CREACION tecnico
      FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO
      WHERE CUSTODIO_ID=Cv_Custodio
      AND LOGIN=Cv_Login
      and FE_CREACION between Cd_FechaInicio
      and Cd_FechaFin
      AND TIPO_ARTICULO='Fibra'
      AND ROWNUM = 1;
    CURSOR C_Parametros(Cv_Parametro VARCHAR2, Cv_Tipo VARCHAR2) IS
        SELECT DET.*
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
          ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
        WHERE DET.ESTADO = 'Activo'
          and CAB.NOMBRE_PARAMETRO = Cv_Parametro
          and DET.VALOR2 = Cv_Tipo;

     TYPE Rt_tarea IS RECORD(
        ID_COMUNICACION   NUMBER,
        DETALLE_ID      NUMBER,
        PERSONA_EMPRESA_ROL_ID   NUMBER,
        LOGIN             VARCHAR2(60),
        FECHA_COMUNICACION             TIMESTAMP,
        REMITENTE_NOMBRE   VARCHAR2(100),
        FECHA_FINALIZACION TIMESTAMP,
        DESCRIPCION_TAREA  VARCHAR2(1500)
     );
     TYPE Aat_record IS TABLE OF Rt_tarea;
      l_registro Aat_record;
  BEGIN
  Pv_Retorno  := '{"data": [ ';
  IF (NOT Pn_IdDetalle IS NULL and Pn_IdDetalle > 0) THEN

    FOR Lr_Parametro in C_Parametros('QUERYS FIBRA SOPORTE', 'DETALLE') LOOP
       Ln_Count := Ln_Count + 1;
       Lv_Query := Lr_Parametro.VALOR1;
       Lv_Query := REPLACE(Lv_Query, '<<detalle_id>>', Pn_IdDetalle);
       Lv_Query := REPLACE(Lv_Query, ';', '');

       dbms_output.put_line(Ln_Count);
       dbms_output.put_line(Lv_Query);
       l_registro := null;
       EXECUTE IMMEDIATE Lv_Query BULK COLLECT INTO l_registro;
       Ln_Indice := 1;
       WHILE Ln_Indice <= l_registro.COUNT LOOP 
          DBMS_LOB.APPEND(Pv_Retorno, '{');
          DBMS_LOB.APPEND(Pv_Retorno, '"id_comunicacion": ' || l_registro(Ln_Indice).ID_COMUNICACION || ',');
          DBMS_LOB.APPEND(Pv_Retorno, '"id_detalle": ' || l_registro(Ln_Indice).DETALLE_ID || ',');
          DBMS_LOB.APPEND(Pv_Retorno, '"login": "' || l_registro(Ln_Indice).LOGIN || '",');
          DBMS_LOB.APPEND(Pv_Retorno, '"fecha": "' || l_registro(Ln_Indice).FECHA_FINALIZACION || '",');
          Lb_DataFound := false;
          FOR Lr_Fibra in C_Fibra(l_registro(Ln_Indice).PERSONA_EMPRESA_ROL_ID,l_registro(Ln_Indice).LOGIN, l_registro(Ln_Indice).FECHA_COMUNICACION, l_registro(Ln_Indice).FECHA_FINALIZACION) LOOP
             Lb_DataFound := true;
             DBMS_LOB.APPEND(Pv_Retorno, '"empresaCliente": ' || Lr_Fibra.empresa_cliente || ',');
             DBMS_LOB.APPEND(Pv_Retorno, '"bobina": "' || Lr_Fibra.bobina || '",');
             DBMS_LOB.APPEND(Pv_Retorno, '"cantidad": ' || Lr_Fibra.cantidad || ',');
             DBMS_LOB.APPEND(Pv_Retorno, '"tecnico": "' || Lr_Fibra.tecnico || '",');
             DBMS_LOB.APPEND(Pv_Retorno, '"observacion": "Consulta Exitosa"},');
          END LOOP;
          IF (NOT Lb_DataFound) THEN
             DBMS_LOB.APPEND(Pv_Retorno, '"empresaCliente": 0,');
             DBMS_LOB.APPEND(Pv_Retorno, '"bobina": "",');
             DBMS_LOB.APPEND(Pv_Retorno, '"cantidad": 0,');
             DBMS_LOB.APPEND(Pv_Retorno, '"tecnico": "",');
             DBMS_LOB.APPEND(Pv_Retorno, '"observacion": "No se obtuvo informaci�n en NAF"},');          
          END IF;
          IF (l_registro(Ln_Indice).ID_COMUNICACION = Pn_IdComunicacion) THEN
             Lv_ContieneIdCom := 'S';
          END IF;
          Ln_Indice := Ln_Indice + 1;
       END LOOP;
    END LOOP;
  END IF;
  IF (NOT Pn_IdComunicacion IS NULL and Lv_ContieneIdCom = 'N') THEN
     FOR Lr_Parametro in C_Parametros('QUERYS FIBRA SOPORTE', 'COMUNICACION') LOOP
       Ln_Count := Ln_Count + 1;
       Lv_Query := Lr_Parametro.VALOR1;
       Lv_Query := REPLACE(Lv_Query, '<<comunicacion_id>>', Pn_IdComunicacion);
       Lv_Query := REPLACE(Lv_Query, ';', '');

       dbms_output.put_line(Ln_Count);
       dbms_output.put_line(Lv_Query);
       l_registro := null;
       EXECUTE IMMEDIATE Lv_Query BULK COLLECT INTO l_registro;
       --FOR I IN 1 .. l_registro.COUNT LOOP
       Ln_Indice := 1;
       WHILE Ln_Indice <= l_registro.COUNT LOOP 
          DBMS_LOB.APPEND(Pv_Retorno, '{');
          DBMS_LOB.APPEND(Pv_Retorno, '"id_comunicacion": ' || l_registro(Ln_Indice).ID_COMUNICACION || ',');
          DBMS_LOB.APPEND(Pv_Retorno, '"id_detalle": ' || l_registro(Ln_Indice).DETALLE_ID || ',');
          DBMS_LOB.APPEND(Pv_Retorno, '"login": "' || l_registro(Ln_Indice).LOGIN || '",');
          DBMS_LOB.APPEND(Pv_Retorno, '"fecha": "' || l_registro(Ln_Indice).FECHA_FINALIZACION || '",');
          Lb_DataFound := false;
          FOR Lr_Fibra in C_Fibra(l_registro(Ln_Indice).PERSONA_EMPRESA_ROL_ID,l_registro(Ln_Indice).LOGIN, l_registro(Ln_Indice).FECHA_COMUNICACION, l_registro(Ln_Indice).FECHA_FINALIZACION) LOOP
             Lb_DataFound := true;
             DBMS_LOB.APPEND(Pv_Retorno, '"empresaCliente": ' || Lr_Fibra.empresa_cliente || ',');
             DBMS_LOB.APPEND(Pv_Retorno, '"bobina": "' || Lr_Fibra.bobina || '",');
             DBMS_LOB.APPEND(Pv_Retorno, '"cantidad": ' || Lr_Fibra.cantidad || ',');
             DBMS_LOB.APPEND(Pv_Retorno, '"tecnico": "' || Lr_Fibra.tecnico || '",');
             DBMS_LOB.APPEND(Pv_Retorno, '"observacion": "Consulta Exitosa"},');
          END LOOP;
          IF (NOT Lb_DataFound) THEN
             DBMS_LOB.APPEND(Pv_Retorno, '"empresaCliente": 0,');
             DBMS_LOB.APPEND(Pv_Retorno, '"bobina": "",');
             DBMS_LOB.APPEND(Pv_Retorno, '"cantidad": 0,');
             DBMS_LOB.APPEND(Pv_Retorno, '"tecnico": "",');
             DBMS_LOB.APPEND(Pv_Retorno, '"observacion": "No se obtuvo informaci�n en NAF"},');          
          END IF;
          Ln_Indice := Ln_Indice + 1;
       END LOOP;
    END LOOP;


  END IF;
  Pv_Retorno := SUBSTR(Pv_Retorno, 0, LENGTH(Pv_Retorno) - 1);
  DBMS_LOB.APPEND(Pv_Retorno, ']}');      

  exception 
  when others then
     Pv_Error := substr(SQLERRM,1,500);
    dbms_output.put_line(Pv_Error);

  END P_GET_FIBRA_TAREA;

  PROCEDURE P_REINICIAR_NUMERACION(pv_mensaje_respuesta OUT VARCHAR2)
  IS

  PN_CURRVAL NUMBER := 0;
  PN_NEXTVAL NUMBER := 0;

  BEGIN

    EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA.NEXTVAL FROM DUAL' INTO PN_NEXTVAL;
    EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA.CURRVAL * -1 FROM DUAL' INTO PN_CURRVAL;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA INCREMENT BY ' || PN_CURRVAL;
    EXECUTE IMMEDIATE 'SELECT DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA.NEXTVAL FROM DUAL' INTO PN_CURRVAL;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE DB_SOPORTE.SEQ_NUMERACION_INFO_TAREA INCREMENT BY 1';

    UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR1= (PN_NEXTVAL-1), VALOR2= TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS')
    WHERE  
    PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB WHERE CAB.NOMBRE_PARAMETRO = 'NUMERACION_INFO_TAREA' AND CAB.ESTADO='Activo');

    COMMIT;

    pv_mensaje_respuesta := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_REINICIAR_NUMERACION',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );

  END P_REINICIAR_NUMERACION;

  PROCEDURE P_INFO_TAREA_INDISPONIBILIDAD(pn_detalle_id_pn_caso_id varchar2,
                                            pv_tipo_pv_INDISPONIBILIDAD varchar2,
                                            pn_TIEMPO_AFECTACION number,
                                            pv_masivo varchar2,
                                            pv_OLT_pv_PUERTO varchar2,
                                            pv_CAJA_pv_SPLITTER varchar2,
                                            pn_CLIENTES_pn_RESPONSABLE varchar2,
                                            pv_OBSERVACION varchar2,
                                            pv_USR_CREACION_pv_IP_CREACION varchar2,
                                            pv_mensaje_respuesta OUT VARCHAR2)
  IS

  Lv_numeracion VARCHAR2(20);
  
  ln_detalle_id number;
  ln_caso_id number;
  lv_tipo varchar2(100);
  lv_indisponibilidad varchar2(100);
  lv_olt varchar2(500);
  lv_puerto varchar2(500);
  lv_caja varchar2(500);
  lv_splitter varchar2(500);
  ln_clientes_afectados number;
  ln_responsable_problema number;
  lv_usr varchar2(50);
  lv_ip varchar2(50);
  
  
  BEGIN

    ln_detalle_id := nvl(substr(pn_detalle_id_pn_caso_id, 1, INSTR(pn_detalle_id_pn_caso_id, ',', 1)-1),0);
    ln_caso_id := nvl(substr(pn_detalle_id_pn_caso_id, INSTR(pn_detalle_id_pn_caso_id, ',', 1)+1, length(pn_detalle_id_pn_caso_id)),0);

   lv_tipo := substr(pv_tipo_pv_INDISPONIBILIDAD, 1, INSTR(pv_tipo_pv_INDISPONIBILIDAD, ',', 1)-1);
    lv_indisponibilidad := substr(pv_tipo_pv_INDISPONIBILIDAD, INSTR(pv_tipo_pv_INDISPONIBILIDAD, ',', 1)+1, length(pv_tipo_pv_INDISPONIBILIDAD));
    
    lv_olt := substr(pv_OLT_pv_PUERTO, 1, INSTR(pv_OLT_pv_PUERTO, ';', 1)-1);
    lv_puerto := substr(pv_OLT_pv_PUERTO, INSTR(pv_OLT_pv_PUERTO, ';', 1)+1, length(pv_OLT_pv_PUERTO));
    
    lv_caja := substr(pv_CAJA_pv_SPLITTER, 1, INSTR(pv_CAJA_pv_SPLITTER, ';', 1)-1);
    lv_splitter := substr(pv_CAJA_pv_SPLITTER, INSTR(pv_CAJA_pv_SPLITTER, ';', 1)+1, length(pv_CAJA_pv_SPLITTER));
    
    ln_clientes_afectados := nvl(substr(pn_CLIENTES_pn_RESPONSABLE, 1, INSTR(pn_CLIENTES_pn_RESPONSABLE, ',', 1)-1),0);
    ln_responsable_problema := nvl(substr(pn_CLIENTES_pn_RESPONSABLE, INSTR(pn_CLIENTES_pn_RESPONSABLE, ',', 1)+1, length(pn_CLIENTES_pn_RESPONSABLE)),0);

    lv_usr := nvl(substr(pv_USR_CREACION_pv_IP_CREACION, 1, INSTR(pv_USR_CREACION_pv_IP_CREACION, ',', 1)-1),0);
    lv_ip := nvl(substr(pv_USR_CREACION_pv_IP_CREACION, INSTR(pv_USR_CREACION_pv_IP_CREACION, ',', 1)+1, length(pv_USR_CREACION_pv_IP_CREACION)),0);

        INSERT INTO DB_SOPORTE.info_tarea_indisponibilidad (
          ID_INDISPONIBILIDAD, 
          DETALLE_ID,
          CASO_ID,
          TIPO,
          INDISPONIBILIDAD,
          TIEMPO_AFECTACION,
          MASIVO,
          OLT,
          PUERTO,
          CAJA,
          SPLITTER,
          CLIENTES_AFECTADOS,
          RESPONSABLE_PROBLEMA,
          OBSERVACION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION
        )
        VALUES(
          DB_SOPORTE.SEQ_INFO_TAREA_INDISPON.NEXTVAL,
          ln_detalle_id,
          ln_caso_id,
          lv_tipo,
          decode(lv_indisponibilidad, 'SI', 'S', 'N'),
          pn_TIEMPO_AFECTACION,
          decode(pv_masivo, 'SI', 'S', 'N'),
          lv_olt,
          lv_PUERTO,
          lv_CAJA,
          lv_SPLITTER,
          ln_clientes_afectados,
          ln_responsable_problema,
          pv_OBSERVACION,
          lv_usr,
          SYSTIMESTAMP,
          lv_ip
        );


    pv_mensaje_respuesta := 'OK';
    
    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_respuesta := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;

      db_general.gnrlpck_util.insert_error('Telcos +',
                                            'SPKG_INFO_TAREA.P_REGISTRA_EN_INFO_TAREA_INDISPONIBILIDAD',
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                          );
  END P_INFO_TAREA_INDISPONIBILIDAD;


  PROCEDURE P_CREA_ACTIVIDAD_AUTOMATICA(
    Pr_RegInfoCreaActividad IN DB_SOPORTE.SPKG_TYPES.Lr_InfoCreaActividad,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pn_IdComunicacionTarea  OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalleTarea       OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
  AS
    Lv_MsjError                 VARCHAR2(4000);
    Le_Exception                EXCEPTION;
    Ln_Rownum                   NUMBER := 1;
    Lv_Si                       VARCHAR2(2) := 'SI';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoEliminado          VARCHAR2(9) := 'Eliminado';
    Lv_EstadoInactivo           VARCHAR2(8) := 'Inactivo';
    Lv_EstadoCancelado          VARCHAR2(9) := 'Cancelado';
    Lv_EstadoAnulado            VARCHAR2(7) := 'Anulado';
    Lv_EstadoAsignada           VARCHAR2(8) := 'Asignada';
    Lv_AccionAsignada           VARCHAR2(8) := 'Asignada';
    Ln_IdTarea                  DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE;
    Ln_IdDetalle                DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;
    Lr_InfoDetalle              DB_SOPORTE.INFO_DETALLE%ROWTYPE;
    Ln_IdDetalleAsignacion      DB_SOPORTE.INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE;
    Lr_InfoDetalleAsignacion    DB_SOPORTE.INFO_DETALLE_ASIGNACION%ROWTYPE;
    Ln_IdDetalleHistorial       DB_SOPORTE.INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE;
    Lr_InfoDetalleHistorial     DB_SOPORTE.INFO_DETALLE_HISTORIAL%ROWTYPE;
    Lr_InfoTareaSeguimiento     DB_SOPORTE.INFO_TAREA_SEGUIMIENTO%ROWTYPE;
    Lr_InfoTarea                DB_SOPORTE.INFO_TAREA%ROWTYPE;
    Lr_InfoDocRegistroLlamada   DB_COMUNICACION.INFO_DOCUMENTO%ROWTYPE;
    Ln_IdDocRegistroLlamada     DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Lr_InfoComunicacionTarea    DB_COMUNICACION.INFO_COMUNICACION%ROWTYPE;
    Ln_IdComunicacionTarea      DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Lr_InfoDocComunicacionTarea DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION%ROWTYPE;

    CURSOR Lc_GetInfoGeneralTarea(  Cv_NombreProceso    DB_SOPORTE.ADMI_PROCESO.NOMBRE_PROCESO%TYPE,
                                    Cv_NombreTarea      DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE)
    IS
      SELECT TAREA.ID_TAREA, TAREA.NOMBRE_TAREA, TAREA.DESCRIPCION_TAREA, PROCESO_TAREA.ID_PROCESO, PROCESO_TAREA.NOMBRE_PROCESO
      FROM DB_SOPORTE.ADMI_PROCESO_EMPRESA PROCESO_EMPRESA_TAREA
      INNER JOIN DB_SOPORTE.ADMI_PROCESO PROCESO_TAREA
      ON PROCESO_TAREA.ID_PROCESO = PROCESO_EMPRESA_TAREA.PROCESO_ID
      INNER JOIN DB_SOPORTE.ADMI_TAREA TAREA
      ON TAREA.PROCESO_ID = PROCESO_TAREA.ID_PROCESO
      WHERE PROCESO_TAREA.NOMBRE_PROCESO = Cv_NombreProceso
      AND TAREA.NOMBRE_TAREA= Cv_NombreTarea
      AND PROCESO_TAREA.ESTADO <> Lv_EstadoEliminado
      AND TAREA.ESTADO <> Lv_EstadoEliminado
      AND ROWNUM = Ln_Rownum;


    CURSOR Lc_GetInfoEmpleado(Cv_LoginEmpleado  DB_SOPORTE.ADMI_PROCESO.NOMBRE_PROCESO%TYPE,
                              Cv_CodEmpresa     VARCHAR2)
    IS
      SELECT *
      FROM (
        SELECT PER.ID_PERSONA_ROL, PERSONA.ID_PERSONA, CONCAT(CONCAT(PERSONA.NOMBRES, ' '), PERSONA.APELLIDOS) AS NOMBRE_EMPLEADO,
        DEPARTAMENTO.ID_DEPARTAMENTO, DEPARTAMENTO.NOMBRE_DEPARTAMENTO, OFICINA.CANTON_ID
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
        ON PERSONA.ID_PERSONA = PER.PERSONA_ID
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA
        ON OFICINA.ID_OFICINA = PER.OFICINA_ID
        INNER JOIN DB_GENERAL.ADMI_DEPARTAMENTO DEPARTAMENTO
        ON DEPARTAMENTO.ID_DEPARTAMENTO = PER.DEPARTAMENTO_ID
        WHERE PERSONA.LOGIN = Cv_LoginEmpleado
        AND OFICINA.EMPRESA_ID = Cv_CodEmpresa
        AND PER.DEPARTAMENTO_ID IS NOT NULL
        AND PER.DEPARTAMENTO_ID <> 0
        AND PER.ESTADO NOT IN (Lv_EstadoInactivo, Lv_EstadoCancelado, Lv_EstadoAnulado, Lv_EstadoEliminado)
        ORDER BY PER.ESTADO ASC
      )
      WHERE ROWNUM = Ln_Rownum;

    CURSOR Lc_GetInfoDepartamento(Cv_NombreDepartamento DB_GENERAL.ADMI_DEPARTAMENTO.NOMBRE_DEPARTAMENTO%TYPE,
                                  Cv_CodEmpresa VARCHAR2)
    IS
      SELECT DEP.ID_DEPARTAMENTO
      FROM DB_GENERAL.ADMI_DEPARTAMENTO DEP
      WHERE DEP.NOMBRE_DEPARTAMENTO = Cv_NombreDepartamento
      AND DEP.EMPRESA_COD = Cv_CodEmpresa
      AND DEP.ESTADO <> Lv_EstadoEliminado
      AND ROWNUM = Ln_Rownum;

    CURSOR Lc_GetInfoCanton(Cv_NombreCanton DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE)
    IS
      SELECT CANTON.ID_CANTON
      FROM DB_GENERAL.ADMI_CANTON CANTON
      WHERE CANTON.NOMBRE_CANTON= Cv_NombreCanton
      AND CANTON.ESTADO <> Lv_EstadoEliminado
      AND ROWNUM = Ln_Rownum;

    CURSOR Lc_GetInfoClaseDocumento(Cv_NombreClaseDocumento DB_COMUNICACION.ADMI_CLASE_DOCUMENTO.NOMBRE_CLASE_DOCUMENTO%TYPE)
    IS
      SELECT CLASE_DOCUMENTO.ID_CLASE_DOCUMENTO
      FROM DB_COMUNICACION.ADMI_CLASE_DOCUMENTO CLASE_DOCUMENTO
      WHERE CLASE_DOCUMENTO.NOMBRE_CLASE_DOCUMENTO = Cv_NombreClaseDocumento
      AND CLASE_DOCUMENTO.ESTADO <> Lv_EstadoEliminado
      AND CLASE_DOCUMENTO.VISIBLE = Lv_Si
      AND ROWNUM = Ln_Rownum;

    CURSOR Lc_GetInfoFormaContacto(Cv_DescripcionFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE)
    IS
      SELECT FORMA_CONTACTO.ID_FORMA_CONTACTO
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
      WHERE FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO = Cv_DescripcionFormaContacto
      AND FORMA_CONTACTO.ESTADO <> Lv_EstadoEliminado
      AND ROWNUM = Ln_Rownum;

    Lr_RegGetInfoGeneralTarea       Lc_GetInfoGeneralTarea%ROWTYPE;
    Lr_RegGetInfoEmpleadoAsignado   Lc_GetInfoEmpleado%ROWTYPE;
    Lr_RegGetDepartamentoCreaTarea  Lc_GetInfoDepartamento%ROWTYPE;
    Lr_RegGetCantonCreaTarea        Lc_GetInfoCanton%ROWTYPE;
    Lr_RegGetInfoClaseDocumento     Lc_GetInfoClaseDocumento%ROWTYPE;
    Lr_RegGetInfoFormaContacto      Lc_GetInfoFormaContacto%ROWTYPE;
  BEGIN
    OPEN Lc_GetInfoGeneralTarea(Pr_RegInfoCreaActividad.NOMBRE_PROCESO, Pr_RegInfoCreaActividad.NOMBRE_TAREA);
    FETCH Lc_GetInfoGeneralTarea INTO Lr_RegGetInfoGeneralTarea;
    CLOSE Lc_GetInfoGeneralTarea;
    Ln_IdTarea  := Lr_RegGetInfoGeneralTarea.ID_TAREA;
    IF Ln_IdTarea IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n de la tarea a crear';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetInfoDepartamento(Pr_RegInfoCreaActividad.NOMBRE_DEPARTAMENTO_CREA_TAREA, Pr_RegInfoCreaActividad.COD_EMPRESA_EMPLEADO_ASIGNADO);
    FETCH Lc_GetInfoDepartamento INTO Lr_RegGetDepartamentoCreaTarea;
    CLOSE Lc_GetInfoDepartamento;
    IF Lr_RegGetDepartamentoCreaTarea.ID_DEPARTAMENTO IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n del departamento origen que crear� la tarea';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetInfoCanton(Pr_RegInfoCreaActividad.NOMBRE_CANTON_CREA_TAREA);
    FETCH Lc_GetInfoCanton INTO Lr_RegGetCantonCreaTarea;
    CLOSE Lc_GetInfoCanton;
    IF Lr_RegGetCantonCreaTarea.ID_CANTON IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n del cant�n origen que crear� la tarea';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetInfoEmpleado(Pr_RegInfoCreaActividad.LOGIN_EMPLEADO_ASIGNADO, Pr_RegInfoCreaActividad.COD_EMPRESA_EMPLEADO_ASIGNADO);
    FETCH Lc_GetInfoEmpleado INTO Lr_RegGetInfoEmpleadoAsignado;
    CLOSE Lc_GetInfoEmpleado;
    IF Lr_RegGetInfoEmpleadoAsignado.ID_PERSONA_ROL IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n del empleado al que se le asignar� la tarea';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetInfoClaseDocumento(Pr_RegInfoCreaActividad.NOMBRE_CLASE);
    FETCH Lc_GetInfoClaseDocumento INTO Lr_RegGetInfoClaseDocumento;
    CLOSE Lc_GetInfoClaseDocumento;
    IF Lr_RegGetInfoClaseDocumento.ID_CLASE_DOCUMENTO IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n de la clase de documento asociada a la tarea';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetInfoFormaContacto(Pr_RegInfoCreaActividad.DESCRIPCION_ORIGEN);
    FETCH Lc_GetInfoFormaContacto INTO Lr_RegGetInfoFormaContacto;
    CLOSE Lc_GetInfoFormaContacto;
    IF Lr_RegGetInfoFormaContacto.ID_FORMA_CONTACTO IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n de la clase de documento asociada a la tarea';
      RAISE Le_Exception;
    END IF;

    Ln_IdDetalle                        := DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL;
    Lr_InfoDetalle.ID_DETALLE           := Ln_IdDetalle;
    Lr_InfoDetalle.TAREA_ID             := Ln_IdTarea;
    Lr_InfoDetalle.OBSERVACION          := Pr_RegInfoCreaActividad.OBSERVACION;
    Lr_InfoDetalle.PESO_PRESUPUESTADO   := 0;
    Lr_InfoDetalle.VALOR_PRESUPUESTADO  := 0;
    Lr_InfoDetalle.FE_SOLICITADA        := Pr_RegInfoCreaActividad.FE_SOLICITADA;
    Lr_InfoDetalle.FE_CREACION          := SYSDATE;
    Lr_InfoDetalle.USR_CREACION         := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoDetalle.IP_CREACION          := Pr_RegInfoCreaActividad.IP_CREACION;
    DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE(Lr_InfoDetalle, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Ln_IdDetalleAsignacion                          := DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL;
    Lr_InfoDetalleAsignacion.ID_DETALLE_ASIGNACION  := Ln_IdDetalleAsignacion;
    Lr_InfoDetalleAsignacion.DETALLE_ID             := Ln_IdDetalle;
    Lr_InfoDetalleAsignacion.ASIGNADO_ID            := Lr_RegGetInfoEmpleadoAsignado.ID_DEPARTAMENTO;
    Lr_InfoDetalleAsignacion.ASIGNADO_NOMBRE        := Lr_RegGetInfoEmpleadoAsignado.NOMBRE_DEPARTAMENTO;
    Lr_InfoDetalleAsignacion.REF_ASIGNADO_ID        := Lr_RegGetInfoEmpleadoAsignado.ID_PERSONA;
    Lr_InfoDetalleAsignacion.REF_ASIGNADO_NOMBRE    := Lr_RegGetInfoEmpleadoAsignado.NOMBRE_EMPLEADO;
    Lr_InfoDetalleAsignacion.PERSONA_EMPRESA_ROL_ID := Lr_RegGetInfoEmpleadoAsignado.ID_PERSONA_ROL;
    Lr_InfoDetalleAsignacion.IP_CREACION            := Pr_RegInfoCreaActividad.IP_CREACION;
    Lr_InfoDetalleAsignacion.USR_CREACION           := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoDetalleAsignacion.FE_CREACION            := SYSDATE;        
    Lr_InfoDetalleAsignacion.TIPO_ASIGNADO          := 'EMPLEADO';
    Lr_InfoDetalleAsignacion.DEPARTAMENTO_ID        := Lr_RegGetDepartamentoCreaTarea.ID_DEPARTAMENTO;
    Lr_InfoDetalleAsignacion.CANTON_ID              := Lr_RegGetCantonCreaTarea.ID_CANTON;
    Lr_InfoDetalleAsignacion.MOTIVO                 := Pr_RegInfoCreaActividad.OBSERVACION;
    DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_ASIGNACION(Lr_InfoDetalleAsignacion, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Ln_IdDetalleHistorial                           := DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL;
    Lr_InfoDetalleHistorial.ID_DETALLE_HISTORIAL    := Ln_IdDetalleHistorial;
    Lr_InfoDetalleHistorial.DETALLE_ID              := Ln_IdDetalle;
    Lr_InfoDetalleHistorial.OBSERVACION             := 'Tarea Asignada - Modulo de Actividades';
    Lr_InfoDetalleHistorial.USR_CREACION            := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoDetalleHistorial.ACCION                  := Lv_AccionAsignada;
    Lr_InfoDetalleHistorial.DEPARTAMENTO_ORIGEN_ID  := Lr_RegGetDepartamentoCreaTarea.ID_DEPARTAMENTO;
    Lr_InfoDetalleHistorial.ESTADO                  := Lv_EstadoAsignada;
    Lr_InfoDetalleHistorial.IP_CREACION             := Pr_RegInfoCreaActividad.IP_CREACION;
    Lr_InfoDetalleHistorial.PERSONA_EMPRESA_ROL_ID  := Lr_RegGetInfoEmpleadoAsignado.ID_PERSONA_ROL;
    Lr_InfoDetalleHistorial.DEPARTAMENTO_DESTINO_ID := Lr_RegGetInfoEmpleadoAsignado.ID_DEPARTAMENTO;
    Lr_InfoDetalleHistorial.FE_CREACION             := SYSDATE;
    DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL(Lr_InfoDetalleHistorial, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Lr_InfoTareaSeguimiento.DETALLE_ID              := Ln_IdDetalle;
    Lr_InfoTareaSeguimiento.OBSERVACION             := 'Tarea fue Asignada a ' || Lr_RegGetInfoEmpleadoAsignado.NOMBRE_EMPLEADO;
    Lr_InfoTareaSeguimiento.EMPRESA_COD             := Pr_RegInfoCreaActividad.COD_EMPRESA;
    Lr_InfoTareaSeguimiento.USR_CREACION            := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoTareaSeguimiento.ESTADO_TAREA            := Lv_EstadoAsignada;
    Lr_InfoTareaSeguimiento.INTERNO                 := 'N';
    Lr_InfoTareaSeguimiento.DEPARTAMENTO_ID         := Lr_RegGetDepartamentoCreaTarea.ID_DEPARTAMENTO;
    Lr_InfoTareaSeguimiento.PERSONA_EMPRESA_ROL_ID  := Lr_RegGetInfoEmpleadoAsignado.ID_PERSONA_ROL;
    DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO(Lr_InfoTareaSeguimiento, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Ln_IdDocRegistroLlamada                         := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
    Lr_InfoDocRegistroLlamada.ID_DOCUMENTO          := Ln_IdDocRegistroLlamada;
    Lr_InfoDocRegistroLlamada.MENSAJE               := Pr_RegInfoCreaActividad.OBSERVACION; 
    Lr_InfoDocRegistroLlamada.NOMBRE_DOCUMENTO      := 'Registro de llamada.';
    Lr_InfoDocRegistroLlamada.CLASE_DOCUMENTO_ID    := Lr_RegGetInfoClaseDocumento.ID_CLASE_DOCUMENTO;
    Lr_InfoDocRegistroLlamada.ESTADO                := Lv_EstadoActivo;
    Lr_InfoDocRegistroLlamada.USR_CREACION          := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoDocRegistroLlamada.IP_CREACION           := Pr_RegInfoCreaActividad.IP_CREACION;
    Lr_InfoDocRegistroLlamada.EMPRESA_COD           := Pr_RegInfoCreaActividad.COD_EMPRESA;
    DB_COMUNICACION.CUKG_UTILS.P_INSERT_INFO_DOCUMENTO(Lr_InfoDocRegistroLlamada, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Ln_IdComunicacionTarea                              := DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL;
    Lr_InfoComunicacionTarea.ID_COMUNICACION            := Ln_IdComunicacionTarea;
    Lr_InfoComunicacionTarea.FORMA_CONTACTO_ID          := Lr_RegGetInfoFormaContacto.ID_FORMA_CONTACTO;
    Lr_InfoComunicacionTarea.REMITENTE_ID               := Pr_RegInfoCreaActividad.REMITENTE_ID_TAREA;
    Lr_InfoComunicacionTarea.REMITENTE_NOMBRE           := Pr_RegInfoCreaActividad.REMITENTE_NOMBRE_TAREA;
    Lr_InfoComunicacionTarea.CLASE_COMUNICACION         := 'Recibido';
    Lr_InfoComunicacionTarea.DETALLE_ID                 := Ln_IdDetalle;
    Lr_InfoComunicacionTarea.FECHA_COMUNICACION         := Pr_RegInfoCreaActividad.FECHA_COMUNICACION;
    Lr_InfoComunicacionTarea.ESTADO                     := Lv_EstadoActivo;
    Lr_InfoComunicacionTarea.USR_CREACION               := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoComunicacionTarea.IP_CREACION                := Pr_RegInfoCreaActividad.IP_CREACION;
    Lr_InfoComunicacionTarea.EMPRESA_COD                := Pr_RegInfoCreaActividad.COD_EMPRESA;
    DB_COMUNICACION.CUKG_UTILS.P_INSERT_INFO_COMUNICACION(Lr_InfoComunicacionTarea, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Lr_InfoDocComunicacionTarea.COMUNICACION_ID             := Ln_IdComunicacionTarea;
    Lr_InfoDocComunicacionTarea.DOCUMENTO_ID                := Ln_IdDocRegistroLlamada;
    Lr_InfoDocComunicacionTarea.ESTADO                      := Lv_EstadoActivo;
    Lr_InfoDocComunicacionTarea.USR_CREACION                := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoDocComunicacionTarea.IP_CREACION                 := Pr_RegInfoCreaActividad.IP_CREACION;
    DB_COMUNICACION.CUKG_UTILS.P_INSERT_INFO_DOC_COMUNICACION(Lr_InfoDocComunicacionTarea, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Lr_InfoTarea.NUMERO                     := DB_SOPORTE.SPKG_INFO_TAREA.F_GET_NUMERACION_INFO_TAREA(Lr_InfoDetalle.FE_CREACION);
    Lr_InfoTarea.USR_CREACION_DETALLE       := Lr_InfoDetalle.USR_CREACION;
    Lr_InfoTarea.FE_CREACION_DETALLE        := Lr_InfoDetalle.FE_CREACION;
    Lr_InfoTarea.FE_SOLICITADA              := Lr_InfoDetalle.FE_SOLICITADA;
    Lr_InfoTarea.OBSERVACION                := Pr_RegInfoCreaActividad.OBSERVACION;
    Lr_InfoTarea.TAREA_ID                   := Lr_RegGetInfoGeneralTarea.ID_TAREA;
    Lr_InfoTarea.NOMBRE_TAREA               := Lr_RegGetInfoGeneralTarea.NOMBRE_TAREA;
    Lr_InfoTarea.DESCRIPCION_TAREA          := Lr_RegGetInfoGeneralTarea.DESCRIPCION_TAREA;
    Lr_InfoTarea.NOMBRE_PROCESO             := Lr_RegGetInfoGeneralTarea.NOMBRE_PROCESO;
    Lr_InfoTarea.PROCESO_ID                 := Lr_RegGetInfoGeneralTarea.ID_PROCESO;
    Lr_InfoTarea.ASIGNADO_ID                := Lr_InfoDetalleAsignacion.ASIGNADO_ID;
    Lr_InfoTarea.ASIGNADO_NOMBRE            := Lr_InfoDetalleAsignacion.ASIGNADO_NOMBRE;
    Lr_InfoTarea.REF_ASIGNADO_ID            := Lr_InfoDetalleAsignacion.REF_ASIGNADO_ID;
    Lr_InfoTarea.REF_ASIGNADO_NOMBRE        := Lr_InfoDetalleAsignacion.REF_ASIGNADO_NOMBRE;
    Lr_InfoTarea.PERSONA_EMPRESA_ROL_ID     := Lr_InfoDetalleAsignacion.PERSONA_EMPRESA_ROL_ID;
    Lr_InfoTarea.DETALLE_ASIGNACION_ID      := Lr_InfoDetalleAsignacion.ID_DETALLE_ASIGNACION;
    Lr_InfoTarea.FE_CREACION_ASIGNACION     := Lr_InfoDetalleAsignacion.FE_CREACION;
    Lr_InfoTarea.DEPARTAMENTO_ID            := Lr_InfoDetalleAsignacion.DEPARTAMENTO_ID ;
    Lr_InfoTarea.TIPO_ASIGNADO              := Lr_InfoDetalleAsignacion.TIPO_ASIGNADO;
    Lr_InfoTarea.CANTON_ID                  := Lr_InfoDetalleAsignacion.CANTON_ID;
    Lr_InfoTarea.ESTADO                     := Lr_InfoDetalleHistorial.ESTADO;
    Lr_InfoTarea.DETALLE_HISTORIAL_ID       := Lr_InfoDetalleHistorial.ID_DETALLE_HISTORIAL;
    Lr_InfoTarea.FE_CREACION_HIS            := Lr_InfoDetalleHistorial.FE_CREACION;
    Lr_InfoTarea.USR_CREACION_HIS           := Lr_InfoDetalleHistorial.USR_CREACION;
    Lr_InfoTarea.OBSERVACION_HISTORIAL      := Lr_InfoDetalleHistorial.OBSERVACION;
    Lr_InfoTarea.DEPARTAMENTO_ORIGEN_ID     := Lr_InfoDetalleHistorial.DEPARTAMENTO_ORIGEN_ID;
    Lr_InfoTarea.PERSONA_EMPRESA_ROL_ID_HIS := Lr_InfoDetalleHistorial.PERSONA_EMPRESA_ROL_ID;
    Lr_InfoTarea.NUMERO_TAREA               := Lr_InfoComunicacionTarea.ID_COMUNICACION;
    Lr_InfoTarea.DETALLE_ID                 := Lr_InfoDetalle.ID_DETALLE;
    Lr_InfoTarea.FE_CREACION                := SYSDATE;
    Lr_InfoTarea.USR_CREACION               := Pr_RegInfoCreaActividad.USR_CREACION;
    Lr_InfoTarea.IP_CREACION                := Pr_RegInfoCreaActividad.IP_CREACION;
    DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_INFO_TAREA(Lr_InfoTarea, Lv_MsjError);
    IF Lv_MsjError IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;

    Pv_Status               := 'OK';
    Pn_IdComunicacionTarea  := Ln_IdComunicacionTarea;
    Pn_IdDetalleTarea       := Ln_IdDetalle;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := Lv_MsjError || ' Por favor consulte al Dep. de Sistemas!';
    Pn_IdComunicacionTarea  := 0;
    Pn_IdDetalleTarea       := 0;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_AUTOMATICA',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := 'Ha ocurrido un error inesperado al crear la tarea. Por favor consulte al Dep. de Sistemas!';
    Pn_IdComunicacionTarea  := 0;
    Pn_IdDetalleTarea       := 0;
    ROLLBACK;
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_AUTOMATICA', 
                                            'Ocurri� un error inesperado en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_CREA_ACTIVIDAD_AUTOMATICA;

  PROCEDURE P_CREA_ACTIVIDAD_PARAMETRIZADA(
    Pv_ParamCabNombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
    Pv_ParamDetValor1Proceso    IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    Pv_ParamCreacionTarea       IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Pv_ParamAsignacionTarea     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    Pv_ObservAdicionalTarea     IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Pn_IdComunicacionTarea      OUT DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    Pn_IdDetalleTarea           OUT DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
  AS
    Lv_EstadoActivo VARCHAR2(15)  := 'Activo';
    CURSOR Lc_GetValorParamServicios( Cv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_Valor1             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                      Cv_Valor2             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT DET.ID_PARAMETRO_DET, DET.VALOR3, DET.VALOR4, DET.VALOR5, DET.VALOR6, DET.VALOR7, DET.OBSERVACION, DET.EMPRESA_COD
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO = Lv_EstadoActivo
      AND DET.VALOR1 = Cv_Valor1
      AND DET.VALOR2 = Cv_Valor2
      AND DET.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetInfoAsignacionTarea(Cn_IdDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
    IS
      SELECT DETALLE.ID_DETALLE, TAREA.NOMBRE_TAREA, PROCESO.NOMBRE_PROCESO,
        TO_CHAR(DET_ASIGNACION.FE_CREACION, 'DD-MON-YYYY HH24:MI') AS FECHA_ASIGNACION,
        CONCAT(DET_ASIGNACION.ASIGNADO_NOMBRE, CONCAT('-',DET_ASIGNACION.REF_ASIGNADO_NOMBRE)) AS ASIGNADO,
        DET_ASIGNACION.REF_ASIGNADO_ID AS ID_PERSONA,
        DET_ASIGNACION.MOTIVO AS OBSERVACION 
      FROM DB_SOPORTE.INFO_DETALLE DETALLE
      INNER JOIN DB_SOPORTE.INFO_DETALLE_ASIGNACION DET_ASIGNACION
      ON DET_ASIGNACION.DETALLE_ID = DETALLE.ID_DETALLE
      INNER JOIN DB_SOPORTE.ADMI_TAREA TAREA
      ON TAREA.ID_TAREA = DETALLE.TAREA_ID
      INNER JOIN DB_SOPORTE.ADMI_PROCESO PROCESO
      ON PROCESO.ID_PROCESO = TAREA.PROCESO_ID
      WHERE DETALLE.ID_DETALLE = Cn_IdDetalle;

    CURSOR Lc_GetCorreoAsignacionTarea( Cv_DescripcionFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
                                        Cn_IdPersona                DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE)
    IS
      SELECT DISTINCT IPFC.VALOR
      FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC
      INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
      ON AFC.ID_FORMA_CONTACTO = IPFC.FORMA_CONTACTO_ID 
      WHERE AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_DescripcionFormaContacto
      AND AFC.ESTADO = Lv_EstadoActivo
      AND IPFC.PERSONA_ID = Cn_IdPersona
      AND IPFC.ESTADO = Lv_EstadoActivo
      AND ROWNUM = 1;

    CURSOR Lc_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
    IS
      SELECT PLANTILLA.ID_PLANTILLA, PLANTILLA.PLANTILLA
      FROM DB_COMUNICACION.ADMI_PLANTILLA PLANTILLA 
      WHERE PLANTILLA.CODIGO = Cv_CodigoPlantilla
      AND PLANTILLA.ESTADO = Lv_EstadoActivo;

    Lr_RegGetParamsCreacionTarea    Lc_GetValorParamServicios%ROWTYPE;
    Lr_RegGetParamsAsignacionTarea  Lc_GetValorParamServicios%ROWTYPE;
    Lr_RegGetValorParamServicios    Lc_GetValorParamServicios%ROWTYPE;
    Lr_RegInfoCreaActividad         DB_SOPORTE.SPKG_TYPES.Lr_InfoCreaActividad;
    Ln_IdDetalleTarea               DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdComunicacionTarea          DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Lr_RegGetPlantillaTareaCorreo   Lc_GetPlantilla%ROWTYPE;
    Lr_RegGetCorreoAsignacionTarea  Lc_GetCorreoAsignacionTarea%ROWTYPE;
    Lr_RegGetInfoAsignacionTarea    Lc_GetInfoAsignacionTarea%ROWTYPE;
    Lr_GetAliasPlantillaCorreo      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_GetAliasPlantillaTarea       DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Remitente                    VARCHAR2(100);
    Lv_Asunto                       VARCHAR2(300);
    Lv_PlantillaCorreo              VARCHAR2(32767);
    Lv_PlantillaTareaCorreo         VARCHAR2(32767);
    Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
    Lv_ProcesoRemitenteYAsunto      VARCHAR2(33) := 'CREACION_ACTIVIDAD_PARAMETRIZADA';
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
  BEGIN

    OPEN Lc_GetValorParamServicios(Pv_ParamCabNombreParametro, Pv_ParamDetValor1Proceso, Pv_ParamCreacionTarea);
    FETCH Lc_GetValorParamServicios INTO Lr_RegGetParamsCreacionTarea;
    CLOSE Lc_GetValorParamServicios;
    IF Lr_RegGetParamsCreacionTarea.ID_PARAMETRO_DET IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener los par�metros configurados para la creaci�n de la tarea';
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetValorParamServicios(Pv_ParamCabNombreParametro, Pv_ParamDetValor1Proceso, Pv_ParamAsignacionTarea);
    FETCH Lc_GetValorParamServicios INTO Lr_RegGetParamsAsignacionTarea;
    CLOSE Lc_GetValorParamServicios;
    IF Lr_RegGetParamsAsignacionTarea.ID_PARAMETRO_DET IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener los par�metros configurados para la asignaci�n de la tarea';
      RAISE Le_Exception;
    END IF;
  
    Lr_RegInfoCreaActividad.DESCRIPCION_ORIGEN              := Lr_RegGetParamsCreacionTarea.VALOR3;
    Lr_RegInfoCreaActividad.NOMBRE_CLASE                    := Lr_RegGetParamsCreacionTarea.VALOR4;
    Lr_RegInfoCreaActividad.NOMBRE_PROCESO                  := Lr_RegGetParamsCreacionTarea.VALOR5;
    Lr_RegInfoCreaActividad.NOMBRE_TAREA                    := Lr_RegGetParamsCreacionTarea.VALOR6;
    Lr_RegInfoCreaActividad.USR_CREACION                    := Lr_RegGetParamsCreacionTarea.VALOR7;
    Lr_RegInfoCreaActividad.OBSERVACION                     := Lr_RegGetParamsCreacionTarea.OBSERVACION || Pv_ObservAdicionalTarea;
    Lr_RegInfoCreaActividad.FE_SOLICITADA                   := SYSDATE;
    Lr_RegInfoCreaActividad.COD_EMPRESA_EMPLEADO_ASIGNADO   := Lr_RegGetParamsAsignacionTarea.VALOR3;
    Lr_RegInfoCreaActividad.LOGIN_EMPLEADO_ASIGNADO         := Lr_RegGetParamsAsignacionTarea.VALOR4;
    Lr_RegInfoCreaActividad.NOMBRE_DEPARTAMENTO_CREA_TAREA  := Lr_RegGetParamsAsignacionTarea.VALOR5;
    Lr_RegInfoCreaActividad.NOMBRE_CANTON_CREA_TAREA        := Lr_RegGetParamsAsignacionTarea.VALOR6;
    Lr_RegInfoCreaActividad.REMITENTE_ID_TAREA              := NULL;
    Lr_RegInfoCreaActividad.REMITENTE_NOMBRE_TAREA          := NULL;
    Lr_RegInfoCreaActividad.FECHA_COMUNICACION              := SYSDATE;
    Lr_RegInfoCreaActividad.IP_CREACION                     := '127.0.0.1';
    Lr_RegInfoCreaActividad.COD_EMPRESA                     := Lr_RegGetParamsCreacionTarea.EMPRESA_COD;
  
    --Se crea la tarea
    DB_SOPORTE.SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_AUTOMATICA( Lr_RegInfoCreaActividad,
                                                            Lv_Status, 
                                                            Lv_MsjError, 
                                                            Ln_IdComunicacionTarea,
                                                            Ln_IdDetalleTarea);
    IF Lv_Status = 'ERROR' THEN
      RAISE Le_Exception;
    END IF;

    OPEN Lc_GetValorParamServicios(Pv_ParamCabNombreParametro, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServicios INTO Lr_RegGetValorParamServicios;
    CLOSE Lc_GetValorParamServicios;
    Lv_Remitente    := Lr_RegGetValorParamServicios.VALOR3;
    Lv_Asunto       := Lr_RegGetValorParamServicios.VALOR4;
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener el remitente y/o el asunto del correo';
      RAISE Le_Exception;
    END IF;

    Lr_RegGetPlantillaTareaCorreo := NULL;
    OPEN Lc_GetPlantilla('TAREAAUTOPARAM');
    FETCH Lc_GetPlantilla INTO Lr_RegGetPlantillaTareaCorreo;
    CLOSE Lc_GetPlantilla;
    Lv_PlantillaTareaCorreo := Lr_RegGetPlantillaTareaCorreo.PLANTILLA;
    IF Lv_PlantillaTareaCorreo IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la plantilla para la asignaci�n de la tarea';
      RAISE Le_Exception;
    END IF;

    Lr_RegGetInfoAsignacionTarea := NULL;
    OPEN Lc_GetInfoAsignacionTarea(Ln_IdDetalleTarea);
    FETCH Lc_GetInfoAsignacionTarea INTO Lr_RegGetInfoAsignacionTarea;
    CLOSE Lc_GetInfoAsignacionTarea;
    IF Lr_RegGetInfoAsignacionTarea.ID_DETALLE IS NULL THEN
      Lv_MsjError := 'No se ha podido obtener la informaci�n de la asignaci�n de la tarea';
      RAISE Le_Exception;
    END IF;

    Lr_GetAliasPlantillaTarea  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('TAREAAUTOPARAM');
    IF Lr_GetAliasPlantillaTarea.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaTarea.ALIAS_CORREOS, ';', ',') || ',';
    END IF;

    Lr_RegGetCorreoAsignacionTarea := NULL;
    OPEN Lc_GetCorreoAsignacionTarea('Correo Electronico', Lr_RegGetInfoAsignacionTarea.ID_PERSONA );
    FETCH Lc_GetCorreoAsignacionTarea INTO Lr_RegGetCorreoAsignacionTarea;
    CLOSE Lc_GetCorreoAsignacionTarea;
    IF Lr_RegGetCorreoAsignacionTarea.VALOR IS NOT NULL THEN
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := Lr_GetAliasPlantillaTarea.ALIAS_CORREOS || Lr_RegGetCorreoAsignacionTarea.VALOR || ',';
    END IF;

    IF Lr_GetAliasPlantillaTarea.ALIAS_CORREOS IS NULL THEN 
      Lr_GetAliasPlantillaTarea.ALIAS_CORREOS := Lv_Remitente || ',';
    END IF;

    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NUMERO_TAREA}}', Ln_IdComunicacionTarea);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NOMBRE_TAREA}}', Lr_RegGetInfoAsignacionTarea.NOMBRE_TAREA);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{NOMBRE_PROCESO}}', Lr_RegGetInfoAsignacionTarea.NOMBRE_PROCESO);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{FECHA_ASIGNACION}}', Lr_RegGetInfoAsignacionTarea.FECHA_ASIGNACION);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{USUARIO_ASIGNA}}', Lr_RegGetParamsCreacionTarea.VALOR7);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{ASIGNADO}}', Lr_RegGetInfoAsignacionTarea.ASIGNADO);
    Lv_PlantillaTareaCorreo := REPLACE(Lv_PlantillaTareaCorreo,'{{OBSERVACION}}', Lr_RegGetInfoAsignacionTarea.OBSERVACION);

    Lv_Asunto := REPLACE(Lv_Asunto,'{{NUMERO_TAREA}}', Ln_IdComunicacionTarea);
    Lv_Asunto := REPLACE(Lv_Asunto,'{{NOMBRE_PROCESO}}', Lr_RegGetInfoAsignacionTarea.NOMBRE_PROCESO);
    
    UTL_MAIL.SEND(SENDER      => Lv_Remitente, 
                  RECIPIENTS  => Lr_GetAliasPlantillaTarea.ALIAS_CORREOS, 
                  SUBJECT     => Lv_Asunto,
                  MESSAGE     => SUBSTR(Lv_PlantillaTareaCorreo, 1, 32767), 
                  MIME_TYPE   => 'text/html; charset=iso-8859-1' );
    Pv_Status := 'OK';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError || ' Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_PARAMETRIZADA',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error al crear la tarea parametrizada. Por favor consulte al Dep. de Sistemas!';
    ROLLBACK;
    Lv_MsjError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'SPKG_INFO_TAREA.P_CREA_ACTIVIDAD_PARAMETRIZADA', 
                                            'Ocurri� un error inesperado en el proceso, '|| SUBSTR(Lv_MsjError,0,3950),
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_CREA_ACTIVIDAD_PARAMETRIZADA;

END SPKG_INFO_TAREA;
/