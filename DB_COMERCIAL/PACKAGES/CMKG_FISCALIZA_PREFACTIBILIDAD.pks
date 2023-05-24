CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD AS 
  
  /**
   * Documentaci�n para P_PROCESA_ACT_COORDENADA_MOVIL
   * Procedimiento que se encarga de la actualizaci�n de estados del servicio, solicitudes e historiales
   * seg�n el estado del servicio que hayan ca�do en PreFactibilidad por la funcionalidad de actualizaci�n de coordenadas desde el m�vil
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.0 19/03/2021
   * 
   *
   *
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.1 08/04/2021
   * Se Validan estados parametrizados para realizar acciones cuando pasa el primer umbral en estado Factible y
   * se registra en la INFO_LOG en caso de error al ejecutar el procedure.
   *
   */
  PROCEDURE P_PROCESA_ACT_COORDENADA_MOVIL;


  /**
   * Documentaci�n para P_RECHAZAR_SOL_CANCELA_TAR
   * Procedimiento que se encarga rechazar la solicitud y cancelar la tarea e historiales.
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.0 19/03/2021
   *
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.1 05/04/2021
   * Se registra en la tabla info_log en caso de error
   *
   * @param Pn_DetalleSolicitudId                   IN INTEGER   Id del detalle de la solicitu de planificaci�n.
   * @param Pn_DetalleId                            IN INTEGER   Id del detalle
   * @param Pv_ModificaSolicitudPla                 IN VARCHAR2  Opcion para modificar : SI O NO
   * @param Pv_EstadoSolPlanif                      IN VARCHAR2  Estado de la solicitud de Planificaci�n
   * @param Pv_ObservaSolPlanif                     IN VARCHAR2  Observaci�n de la solicitud de Planificaci�n
   *
   */
  PROCEDURE P_RECHAZAR_SOL_CANCELA_TAR(
										Pn_DetalleSolicitudId       IN INTEGER,
										Pn_DetalleId                IN INTEGER,
										Pv_ModificaSolicitudPla     IN VARCHAR2,
                                                                                Pv_EstadoSolPlanif          IN VARCHAR2,
                                                                                Pv_ObservaSolPlanif         IN VARCHAR2
									   );


  /**
   * Documentaci�n para P_SERVICIO_FACTIBILIDAD
   * Procedimiento que se encarga de modificar estado del servicio y de la solicitud de factibilidad.
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.0 19/03/2021
   * 
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.1 05/04/2021
   * Se registra en la tabla info_log en caso de error
   *
   * @param cn_idServicio  					IN INTEGER    Id del servicio.
   * @param Pv_ModificaSolicitudFac 		IN VARCHAR2   Opcion para modificar : SI O NO
   * @param Pv_ObservacionSolicitudFac 		IN VARCHAR2   Observaci�n para la solicitu de factibilidad
   * @param Pv_estadoSolicitudFac 			IN VARCHAR2   Estado para la solicitu de factibilidad
   * @param Pv_estadoServicio 				IN VARCHAR2   Estado para servicio
   * @param Pv_ObservacionServicio 			IN VARCHAR2   Observaci�n para servicio
   *
   */
  PROCEDURE P_SERVICIO_FACTIBILIDAD(
									cn_idServicio  			IN INTEGER,
									Pv_ModificaSolicitudFac 	IN VARCHAR2,
									Pv_ObservacionSolicitudFac	IN VARCHAR2,
									Pv_estadoSolicitudFac 		IN VARCHAR2,
									Pv_estadoServicio		IN VARCHAR2,
									Pv_ObservacionServicio		IN VARCHAR2
									);

 /**
   * Documentaci�n para P_FINALIZA_EVENTO_ACTIVO
   * Procedimiento que se encarga de finalizar el evento asociado a una tarea.
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.0 19/03/2021
   *
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.1 05/04/2021
   * Se registra en la tabla info_log en caso de error
   * 
   * @param cn_idComunicacion  					IN INTEGER    N�mero de la tarea
   * @param Pn_DetalleId  					IN INTEGER    Id Del Detalle 
   *
   */
  PROCEDURE P_FINALIZA_EVENTO_ACTIVO(   				cn_idComunicacion           IN INTEGER,
                                                                        Pn_DetalleId                IN INTEGER
                                    );


END CMKG_FISCALIZA_PREFACTIBILIDAD;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD
AS

  /**
   * Documentaci�n para P_PROCESA_ACT_COORDENADA_MOVIL
   * Procedimiento que se encarga de la actualizaci�n de estados del servicio, solicitudes e historiales
   * seg�n el estado del servicio que hayan ca�do en PreFactibilidad por la funcionalidad de actualizaci�n de coordenadas desde el m�vil
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.0 19/03/2021
   *
   *
   *
   * @author Ronny Mor�n <rmoranc@telconet.ec>
   * @version 1.1 08/04/2021
   * Se Validan estados parametrizados para realizar acciones cuando pasa el primer umbral en estado Factible y 
   * se registra en la INFO_LOG en caso de error al ejecutar el procedure.
   *
   */
  PROCEDURE P_PROCESA_ACT_COORDENADA_MOVIL
  IS

  lv_correos            	VARCHAR2(1000);		
  Lv_MensajeErrorCorreo         VARCHAR2(4000);
  Lv_AsuntoVendedor     	VARCHAR2(300) := 'Notificaci�n Autom�tica por factibilidad no gestionada.';
  Lcl_Plantilla         	CLOB;
  Lv_estadosMayorUmbralUno    	VARCHAR2(600);
  type arrayTabla               is TABLE OF VARCHAR2(600);
  estadosValidar arrayTabla     := arrayTabla();
  Ln_indice                     integer;


  CURSOR cur_prefactibilidad_movil(cn_horasBusqueda INTEGER) IS
	SELECT servicio_id, max(id_servicio_historial), FE_CREACION FROM  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL WHERE 
	FE_CREACION > (SYSDATE-(cn_horasBusqueda/24)) 
	AND ESTADO = 'PreFactibilidad' 
	AND DBMS_LOB.instr(OBSERVACION,'Motivo: Actualizaci�n de coordenadas, Origen: MOVIL') > 0
    GROUP BY servicio_id, FE_CREACION;

  CURSOR c_infoServicio_tarea(cn_idServicio NUMBER) IS 
	SELECT 
	INFSER.ESTADO AS ESTADO_SERVICIO, IDS.ID_DETALLE_SOLICITUD,INFDET.ID_DETALLE, 
	INFCOM.ID_COMUNICACION, INFCOM.REMITENTE_NOMBRE, INFTAR.ESTADO AS ESTAD0_TAREA 
	FROM 
	DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS,
    DB_SOPORTE.INFO_DETALLE INFDET, DB_SOPORTE.INFO_COMUNICACION INFCOM,
    DB_SOPORTE.INFO_TAREA INFTAR, DB_COMERCIAL.INFO_SERVICIO INFSER
	WHERE 
    IDS.SERVICIO_ID = INFSER.ID_SERVICIO
    AND INFSER.ID_SERVICIO = cn_idServicio
	AND IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
    AND INFDET.DETALLE_SOLICITUD_ID = IDS.ID_DETALLE_SOLICITUD
    AND INFCOM.DETALLE_ID = INFDET.ID_DETALLE
    AND INFTAR.NUMERO_TAREA = INFCOM.ID_COMUNICACION
	AND ATS.DESCRIPCION_SOLICITUD = 'SOLICITUD PLANIFICACION';

	--example: to_date('2021-03-22 03:30', 'YYYY-MM-DD hh24:mi')
  CURSOR c_diff_minutos_servicio(cn_idServicio NUMBER,
				 Pv_tipoEstado VARCHAR2,
                                 dt_fechaRestar DATE) IS
	SELECT 1440 * (to_date((TO_CHAR(dt_fechaRestar,'YYYY-MM-DD hh24:mi')), 'YYYY-MM-DD hh24:mi') - to_date((TO_CHAR(FE_CREACION,'YYYY-MM-DD hh24:mi')), 'YYYY-MM-DD hh24:mi')) AS diff_minutos
	FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL WHERE ID_SERVICIO_HISTORIAL = (
	SELECT MAX(ID_SERVICIO_HISTORIAL)
	from DB_COMERCIAL.INFO_SERVICIO_HISTORIAL WHERE  SERVICIO_ID = cn_idServicio 
	AND ESTADO = Pv_tipoEstado);

  r_servicio_tarea			c_infoServicio_tarea%ROWTYPE;
  r_minutos_diff_servicio 		c_diff_minutos_servicio%ROWTYPE;

  CURSOR C_GET_MAP_PARAMETRO_DET(Cv_parametro VARCHAR2, Cv_valor1 VARCHAR2)
    IS
      SELECT 
        VALOR1,
        VALOR2
      FROM 
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE
        APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.ESTADO = 'Activo'
        AND APD.ESTADO = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_parametro
        AND APD.VALOR1 = Cv_valor1;

	Lc_map_umbral_uno       C_GET_MAP_PARAMETRO_DET%ROWTYPE;
	Lc_map_umbral_dos       C_GET_MAP_PARAMETRO_DET%ROWTYPE;
	Lc_map_correo_gis       C_GET_MAP_PARAMETRO_DET%ROWTYPE;  
	Lc_map_correo_md        C_GET_MAP_PARAMETRO_DET%ROWTYPE;  
	Lc_map_horas_pref  	C_GET_MAP_PARAMETRO_DET%ROWTYPE; 
        Lc_map_remitente  	C_GET_MAP_PARAMETRO_DET%ROWTYPE;  
	Lc_map_estados_umbral  	C_GET_MAP_PARAMETRO_DET%ROWTYPE;


    CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
      IS
      SELECT AP.PLANTILLA
      FROM DB_COMUNICACION.ADMI_PLANTILLA AP 
      WHERE AP.CODIGO = Cv_CodigoPlantilla
      AND AP.ESTADO <> 'Eliminado';

	BEGIN

		-- Se validan procesos
		IF C_GET_MAP_PARAMETRO_DET%ISOPEN THEN
		  CLOSE C_GET_MAP_PARAMETRO_DET;
		END IF;

		OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'PRIMER_UMBRAL_ACTUALIZA_COORDENADAS');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_umbral_uno;
		CLOSE C_GET_MAP_PARAMETRO_DET;

		OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'SEGUNDO_UMBRAL_ACTUALIZA_COORDENADAS');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_umbral_dos;
		CLOSE C_GET_MAP_PARAMETRO_DET;

		OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'ALIAS_NACIONAL_GIS');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_correo_gis;
		CLOSE C_GET_MAP_PARAMETRO_DET;

		OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'ALIAS_NACIONAL_MD');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_correo_md;
		CLOSE C_GET_MAP_PARAMETRO_DET;

		OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'HORAS_BUSQUEDA_JOB_PREFACTIB_MOVIL');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_horas_pref;
		CLOSE C_GET_MAP_PARAMETRO_DET;

                OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_GENERALES_MOVIL', 'REMITENTE_CORREO_NOTIFICACION_TELCOS');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_remitente;
		CLOSE C_GET_MAP_PARAMETRO_DET;

                OPEN C_GET_MAP_PARAMETRO_DET('PARAMETROS_ACTUALIZACION_COORDENADAS_MOVIL', 'ESTADOS_TAREA_MAYOR_UMBRAL_UNO');
		FETCH C_GET_MAP_PARAMETRO_DET INTO Lc_map_estados_umbral;
		CLOSE C_GET_MAP_PARAMETRO_DET;


                Lv_estadosMayorUmbralUno := Lc_map_estados_umbral.valor2;


                FOR servicio IN cur_prefactibilidad_movil(Lc_map_horas_pref.VALOR2)
		LOOP    
			OPEN c_infoServicio_tarea(servicio.servicio_id);
			LOOP
				FETCH c_infoServicio_tarea INTO r_servicio_tarea;
				EXIT WHEN c_infoServicio_tarea%notfound;

				--Factible
				IF r_servicio_tarea.ESTADO_SERVICIO = 'Factible' AND r_servicio_tarea.ESTAD0_TAREA != 'Cancelada' THEN

					OPEN c_diff_minutos_servicio(servicio.servicio_id,'Factible',servicio.fe_creacion);
					LOOP
						FETCH c_diff_minutos_servicio INTO r_minutos_diff_servicio;
						EXIT WHEN c_diff_minutos_servicio%notfound;


						IF (ABS(r_minutos_diff_servicio.diff_minutos) <= Lc_map_umbral_uno.VALOR2) THEN


							P_SERVICIO_FACTIBILIDAD(
								  servicio.servicio_id,
								  'NO',
								  '',
								  '',
								  'AsignadoTarea',
								  'Asignaci�n autom�tica. motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL'
								 );

						ELSE

                                                    Ln_indice    := 1;
                                                    FOR ESTADO IN
                                                    (SELECT trim(regexp_substr(Lv_estadosMayorUmbralUno, '[^,]+', 1, LEVEL)) ITERADO
                                                     FROM dual
                                                     CONNECT BY LEVEL <= regexp_count(Lv_estadosMayorUmbralUno, ',')+1)
                                                    LOOP
                                                        estadosValidar.extend;
                                                        estadosValidar(Ln_indice):= ESTADO.ITERADO;
                                                        Ln_indice := Ln_indice + 1;
                                                    END LOOP; 

                                                    IF (NOT r_servicio_tarea.ESTAD0_TAREA member of estadosValidar) THEN

                                                        P_SERVICIO_FACTIBILIDAD(
								  servicio.servicio_id,
								  'NO',
								  '',
								  '',
								  'PrePlanificada',
								  'Asignaci�n autom�tica. motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL'
								 );

							P_RECHAZAR_SOL_CANCELA_TAR(r_servicio_tarea.ID_DETALLE_SOLICITUD,
										   r_servicio_tarea.ID_DETALLE,
										   'SI',
                                                                                   'PrePlanificada',
                                                                                   'Solicitud PrePlanificada por motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL');

                                                        P_FINALIZA_EVENTO_ACTIVO(r_servicio_tarea.ID_COMUNICACION,
                                                                                 r_servicio_tarea.ID_DETALLE);

                                                    END IF;

						END IF;
					END LOOP;
					CLOSE c_diff_minutos_servicio;
				--Rechazada	
				ELSIF r_servicio_tarea.ESTADO_SERVICIO = 'Rechazada' AND r_servicio_tarea.ESTAD0_TAREA != 'Cancelada'  THEN


					P_RECHAZAR_SOL_CANCELA_TAR(r_servicio_tarea.ID_DETALLE_SOLICITUD,
                                                                   r_servicio_tarea.ID_DETALLE,
								   'SI',
                                                                   'Rechazada',
                                                                   'Solicitud rechazada por motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL');

				--PreFactibilidad						   
				ELSIF (r_servicio_tarea.ESTADO_SERVICIO = 'PreFactibilidad'  AND r_servicio_tarea.ESTAD0_TAREA != 'Cancelada')  THEN


					OPEN c_diff_minutos_servicio(servicio.servicio_id, 'PreFactibilidad', SYSDATE);
					LOOP
						FETCH c_diff_minutos_servicio INTO r_minutos_diff_servicio;
						EXIT WHEN c_diff_minutos_servicio%notfound;

						IF (ABS(r_minutos_diff_servicio.diff_minutos) > Lc_map_umbral_dos.VALOR2) THEN

							P_SERVICIO_FACTIBILIDAD(
								  servicio.servicio_id,
								  'SI',
								  'Solicitud rechazada por motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL',
								  'Rechazada',
								  'Rechazada',
								  'Rechazo autom�tico. motivo: : Job - Actualizaci�n de coordenadas, Origen: MOVIL'
								 );

							P_RECHAZAR_SOL_CANCELA_TAR(r_servicio_tarea.ID_DETALLE_SOLICITUD,
										   r_servicio_tarea.ID_DETALLE,
										   'SI',
                                                                                   'Rechazada',
                                                                                   'Solicitud rechazada por motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL');

                                                        P_FINALIZA_EVENTO_ACTIVO(r_servicio_tarea.ID_COMUNICACION,
                                                                                 r_servicio_tarea.ID_DETALLE);

							lv_correos:= Lc_map_correo_gis.VALOR2 ||';'|| Lc_map_correo_md.VALOR2;

							OPEN C_GetPlantilla('MAIL_FACT_JOBTM');
							FETCH C_GetPlantilla INTO Lcl_Plantilla;
							CLOSE C_GetPlantilla;

							If (Lcl_Plantilla is not null) Then

								Lcl_Plantilla                   := REPLACE(Lcl_Plantilla,'{{login}}',   r_servicio_tarea.remitente_nombre);
								Lcl_Plantilla                   := REPLACE(Lcl_Plantilla,'{{minutos}}', Lc_map_umbral_dos.VALOR2);
								--Env�os de correo
								DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(Lc_map_remitente.VALOR2, lv_correos, 
                                                                                                              Lv_AsuntoVendedor, 
                                                                                                              SUBSTR(Lcl_Plantilla, 1, 32767), 'text/html; charset=UTF-8', 
                                                                                                              Lv_MensajeErrorCorreo);  

							END IF;							
						END IF;
					END LOOP;
					CLOSE c_diff_minutos_servicio;

                                ELSIF r_servicio_tarea.ESTADO_SERVICIO = 'FactibilidadEnProceso' AND r_servicio_tarea.ESTAD0_TAREA != 'Cancelada'  THEN

                                        OPEN c_diff_minutos_servicio(servicio.servicio_id, 'FactibilidadEnProceso', SYSDATE);
					LOOP
						FETCH c_diff_minutos_servicio INTO r_minutos_diff_servicio;
						EXIT WHEN c_diff_minutos_servicio%notfound;

						IF (ABS(r_minutos_diff_servicio.diff_minutos) > Lc_map_umbral_dos.VALOR2) THEN

							P_RECHAZAR_SOL_CANCELA_TAR(r_servicio_tarea.ID_DETALLE_SOLICITUD,
										   r_servicio_tarea.ID_DETALLE,
										   'SI',
                                                                                   'Rechazada',
                                                                                   'Solicitud rechazada por motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL');

                                                        P_FINALIZA_EVENTO_ACTIVO(r_servicio_tarea.ID_COMUNICACION,
                                                                                 r_servicio_tarea.ID_DETALLE);

						END IF;
					END LOOP;
					CLOSE c_diff_minutos_servicio;

				END IF;

			END LOOP;
			CLOSE c_infoServicio_tarea;

		END LOOP;


    EXCEPTION 
	WHEN OTHERS THEN 

            DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG('18',
                         '1',
                         'P_PROCESA_ACT_COORDENADA_MOVIL',
                         'DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD',
                         'P_PROCESA_ACT_COORDENADA_MOVIL',
                         'Ejecutando procedure principal P_PROCESA_ACT_COORDENADA_MOVIL',
                         'Fallido',
                         SQLERRM,
                         'Sin par�metros',
                         'reg_prefact'
                        );  

    END P_PROCESA_ACT_COORDENADA_MOVIL;




/**
 * Documentaci�n para P_RECHAZAR_SOL_CANCELA_TAR
 * Procedimiento que se encarga rechazar la solicitud y cancelar la tarea e historiales.
 *
 * @author Ronny Mor�n <rmoranc@telconet.ec>
 * @version 1.0 19/03/2021
 *
 *
 * @author Ronny Mor�n <rmoranc@telconet.ec>
 * @version 1.1 05/04/2021
 * Se registra en la tabla info_log en caso de error
 *
 * @param Pn_DetalleSolicitudId                 IN INTEGER   Id del detalle de la solicitu de planificaci�n.
 * @param Pn_DetalleId 				IN INTEGER   Id del detalle
 * @param Pv_ModificaSolicitudPla               IN VARCHAR2  Opcion para modificar : SI O NO
 * @param Pv_EstadoSolPlanif                    IN VARCHAR2  Estado de la solicitud de Planificaci�n
 * @param Pv_ObservaSolPlanif                   IN VARCHAR2  Observaci�n de la solicitud de Planificaci�n
 *
*/
PROCEDURE P_RECHAZAR_SOL_CANCELA_TAR(
									 Pn_DetalleSolicitudId          IN INTEGER,
									 Pn_DetalleId  			IN INTEGER,
									 Pv_ModificaSolicitudPla  	IN VARCHAR2,
                                                                         Pv_EstadoSolPlanif             IN VARCHAR2,
                                                                         Pv_ObservaSolPlanif            IN VARCHAR2
									)
IS

   Lv_Status_info_tarea VARCHAR2(200);
   Lv_Mensaje_info_tarea VARCHAR2(200);

   BEGIN

	IF Pv_ModificaSolicitudPla = 'SI' THEN

		UPDATE 
		DB_COMERCIAL.INFO_DETALLE_SOLICITUD
		SET 
			ESTADO = Pv_EstadoSolPlanif, 
			OBSERVACION = Pv_ObservaSolPlanif,
			MOTIVO_ID = NULL,
			USR_RECHAZO = 'reg_prefact',
			FE_RECHAZO = sysdate
		WHERE 
			ID_DETALLE_SOLICITUD = Pn_DetalleSolicitudId;

		INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                (
                  ID_SOLICITUD_HISTORIAL,
                  DETALLE_SOLICITUD_ID,
                  ESTADO,
                  FE_INI_PLAN,
                  FE_FIN_PLAN,
                  OBSERVACION,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION,
                  MOTIVO_ID
                )
                VALUES
                (
                  DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                  Pn_DetalleSolicitudId,
                  Pv_EstadoSolPlanif,
                  NULL,
                  NULL,
                  Pv_ObservaSolPlanif,
                  'reg_prefact',
                  sysdate,
                  '127.0.0.1',
                  NULL
                );

	END IF;

	INSERT INTO 
	DB_SOPORTE.INFO_DETALLE_HISTORIAL (
	ID_DETALLE_HISTORIAL,
        DETALLE_ID,
        OBSERVACION,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        MOTIVO,
        ASIGNADO_ID,
        PERSONA_EMPRESA_ROL_ID,
        DEPARTAMENTO_ORIGEN_ID,
        DEPARTAMENTO_DESTINO_ID,
        ACCION,
	TAREA_ID,
	ES_SOLUCION,
	MOTIVO_FIN_TAREA,
	MOTIVO_ID
	) VALUES (
        DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,
        Pn_DetalleId,
        'Rechazo de Orden de Trabajo, motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL',
        'Rechazada',
        'reg_prefact',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '128',
        'Rechazada',
	NULL,
	NULL,
	NULL,
	NULL
    );	


	INSERT INTO 
	DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(
	ID_SEGUIMIENTO,
        DETALLE_ID,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        EMPRESA_COD,
        ESTADO_TAREA,
	INTERNO,
        DEPARTAMENTO_ID,
        PERSONA_EMPRESA_ROL_ID
	) 
    VALUES 
	(
	DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
        Pn_DetalleId,
        'Tarea fue Rechazada por el motivo: Rechazo de Orden de Trabajo, motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL',
        'reg_prefact',
        sysdate,
        '18',
        'Rechazada',
        'N',
        NULL,
        NULL
	);


	INSERT INTO 
	DB_SOPORTE.INFO_DETALLE_HISTORIAL (
	ID_DETALLE_HISTORIAL,
        DETALLE_ID,
        OBSERVACION,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        MOTIVO,
        ASIGNADO_ID,
        PERSONA_EMPRESA_ROL_ID,
        DEPARTAMENTO_ORIGEN_ID,
        DEPARTAMENTO_DESTINO_ID,
        ACCION,
	TAREA_ID,
	ES_SOLUCION,
	MOTIVO_FIN_TAREA,
	MOTIVO_ID
	) VALUES (
        DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL,
        Pn_DetalleId,
        'Cancelaci�n autom�tica por rechazo de Orden de Trabajo, motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL',
        'Cancelada',
        'reg_prefact',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '128',
        'Cancelada',
	NULL,
	NULL,
	NULL,
	NULL
    );	

	INSERT INTO 
	DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(
	ID_SEGUIMIENTO,
        DETALLE_ID,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        EMPRESA_COD,
        ESTADO_TAREA,
	INTERNO,
        DEPARTAMENTO_ID,
        PERSONA_EMPRESA_ROL_ID
	) 
    VALUES 
	(
	DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
        Pn_DetalleId,
        'Tarea fue Cancelada por el motivo: Cancelaci�n autom�tica por rechazo de Orden de Trabajo, motivo: Job - Actualizaci�n de coordenadas, Origen: MOVIL',
        'reg_prefact',
        sysdate,
        '18',
        'Cancelada',
	'N',
        NULL,
        NULL
	);

	COMMIT;

	DB_SOPORTE.SPKG_INFO_TAREA.P_UPDATE_TAREA(Pn_DetalleId,
                                                  'reg_prefact',
						  Lv_Status_info_tarea,
						  Lv_Mensaje_info_tarea);

	COMMIT;


EXCEPTION 
	WHEN OTHERS THEN 
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG('18',
                         '1',
                         'P_PROCESA_ACT_COORDENADA_MOVIL',
                         'DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD',
                         'P_RECHAZAR_SOL_CANCELA_TAR',
                         'Rechazando solicitud y cancelando tarea',
                         'Fallido',
                         SQLERRM,
                         'Pn_DetalleSolicitudId: '||Pn_DetalleSolicitudId ||
                         'Pn_DetalleId: '||Pn_DetalleId ||
                         'Pv_ModificaSolicitudPla: '||Pv_ModificaSolicitudPla ||
                         'Pv_EstadoSolPlanif: '||Pv_EstadoSolPlanif ||
                         'Pv_ObservaSolPlanif: '||Pv_ObservaSolPlanif,
                         'reg_prefact'
                        ); 

END P_RECHAZAR_SOL_CANCELA_TAR;


/**
 * Documentaci�n para P_SERVICIO_FACTIBILIDAD
 * Procedimiento que se encarga de modificar estado del servicio y de la solicitud de factibilidad.
 *
 * @author Ronny Mor�n <rmoranc@telconet.ec>
 * @version 1.0 19/03/2021
 *
 *
 * @author Ronny Mor�n <rmoranc@telconet.ec>
 * @version 1.1 05/04/2021
 * Se registra en la tabla info_log en caso de error
 * 
 * @param cn_idServicio  			IN INTEGER    Id del servicio.
 * @param Pv_ModificaSolicitudFac 		IN VARCHAR2   Opcion para modificar : SI O NO
 * @param Pv_ObservacionSolicitudFac            IN VARCHAR2   Observaci�n para la solicitu de factibilidad
 * @param Pv_estadoSolicitudFac 		IN VARCHAR2   Estado para la solicitu de factibilidad
 * @param Pv_estadoServicio 			IN VARCHAR2   Estado para servicio
 * @param Pv_ObservacionServicio 		IN VARCHAR2   Observaci�n para servicio
 *
*/
PROCEDURE P_SERVICIO_FACTIBILIDAD(
                                    cn_idServicio  			IN INTEGER,
				    Pv_ModificaSolicitudFac 		IN VARCHAR2,
				    Pv_ObservacionSolicitudFac          IN VARCHAR2,
				    Pv_estadoSolicitudFac 		IN VARCHAR2,
				    Pv_estadoServicio		 	IN VARCHAR2,
				    Pv_ObservacionServicio		IN VARCHAR2
				  )
IS

   CURSOR cur_info_detalle_sol(cn_servicioId NUMBER) IS
		SELECT
        IDS.ID_DETALLE_SOLICITUD  
        FROM 
		DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, 
		DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
		WHERE IDS.SERVICIO_ID = cn_servicioId
		AND IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
		AND ATS.DESCRIPCION_SOLICITUD = 'SOLICITUD FACTIBILIDAD';

	r_info_detalle_sol 		cur_info_detalle_sol%ROWTYPE;

   BEGIN

        UPDATE 
            DB_COMERCIAL.INFO_SERVICIO
		SET 
            ESTADO = Pv_estadoServicio
		WHERE 
            ID_SERVICIO = cn_idServicio; 

		INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
		(
		  ID_SERVICIO_HISTORIAL,
		  SERVICIO_ID,
		  USR_CREACION,
		  FE_CREACION,
		  IP_CREACION,
		  ESTADO,
		  MOTIVO_ID,
		  OBSERVACION,
		  ACCION
		)
		VALUES
		(
		  DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
		  cn_idServicio,
		  'reg_prefact',
		  SYSDATE,
		  '127.0.0.1',
		  Pv_estadoServicio,
		  NULL,
		  Pv_ObservacionServicio,
		  NULL
		);

		OPEN cur_info_detalle_sol(cn_idServicio);
                FETCH cur_info_detalle_sol INTO r_info_detalle_sol;

			IF Pv_ModificaSolicitudFac = 'SI' THEN

				UPDATE 
				DB_COMERCIAL.INFO_DETALLE_SOLICITUD
				SET 
					ESTADO = Pv_estadoSolicitudFac, 
					OBSERVACION = Pv_ObservacionSolicitudFac,
					MOTIVO_ID = NULL,
					USR_RECHAZO = 'reg_prefact',
					FE_RECHAZO = sysdate
				WHERE 
					ID_DETALLE_SOLICITUD = r_info_detalle_sol.ID_DETALLE_SOLICITUD;

				INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
				(
				  ID_SOLICITUD_HISTORIAL,
				  DETALLE_SOLICITUD_ID,
				  ESTADO,
				  FE_INI_PLAN,
				  FE_FIN_PLAN,
				  OBSERVACION,
				  USR_CREACION,
				  FE_CREACION,
				  IP_CREACION,
				  MOTIVO_ID
				)
			  VALUES
				(
				  DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
				  r_info_detalle_sol.ID_DETALLE_SOLICITUD,
				  Pv_estadoSolicitudFac,
				  NULL,
				  NULL,
				  Pv_ObservacionSolicitudFac,
				  'reg_prefact',
				  sysdate,
				  '127.0.0.1',
				  NULL
				);

			END IF;

		CLOSE cur_info_detalle_sol;


	COMMIT;


EXCEPTION 
	WHEN OTHERS THEN 
            ROLLBACK;

            DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG('18',
                         '1',
                         'P_PROCESA_ACT_COORDENADA_MOVIL',
                         'DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD',
                         'P_SERVICIO_FACTIBILIDAD',
                         'Modificando estado de servicio y factibilidad',
                         'Fallido',
                         SQLERRM,
                         'cn_idServicio: '||cn_idServicio ||
                         'Pv_ModificaSolicitudFac: '||Pv_ModificaSolicitudFac ||
                         'Pv_ObservacionSolicitudFac: '||Pv_ObservacionSolicitudFac ||
                         'Pv_estadoSolicitudFac: '||Pv_estadoSolicitudFac ||
                         'Pv_estadoServicio: '||Pv_estadoServicio ||
                         'Pv_ObservacionServicio: '||Pv_ObservacionServicio,
                         'reg_prefact'
                        ); 

END P_SERVICIO_FACTIBILIDAD;

/**
  * Documentaci�n para P_FINALIZA_EVENTO_ACTIVO
  * Procedimiento que se encarga de finalizar el evento asociado a una tarea.
  *
  * @author Ronny Mor�n <rmoranc@telconet.ec>
  * @version 1.0 19/03/2021
  * 
  *
  * @author Ronny Mor�n <rmoranc@telconet.ec>
  * @version 1.1 05/04/2021
  * Se registra en la tabla info_log en caso de error
  *
  * @param cn_idComunicacion  					IN INTEGER    N�mero de la tarea 
  * @param Pn_DetalleId  					IN INTEGER    Id Del Detalle 
  *
  */
PROCEDURE P_FINALIZA_EVENTO_ACTIVO(
                                                      cn_idComunicacion  			IN INTEGER,
                                                      Pn_DetalleId                              IN INTEGER
				  )
IS

    CURSOR c_fecha_inicio_evento_tarea(idComunicacion NUMBER, 
                                       idDetalle      NUMBER) 
    IS  
    SELECT ID_EVENTO, FECHA_INICIO FROM DB_SOPORTE.INFO_EVENTO 
    WHERE 
    ID_EVENTO = 
    (SELECT MAX(ID_EVENTO) 
    FROM DB_SOPORTE.INFO_EVENTO
    WHERE DBMS_LOB.instr(OBSERVACION,CONCAT('#',idComunicacion)) > 0  
    AND FECHA_FIN IS NULL 
    AND VALOR_TIEMPO IS NULL
    AND FECHA_INICIO IS NOT NULL
    AND DETALLE_ID IN (idDetalle,0));

r_info_evento_tarea 	c_fecha_inicio_evento_tarea%ROWTYPE;

BEGIN

	OPEN c_fecha_inicio_evento_tarea(cn_idComunicacion,Pn_DetalleId);
        FETCH c_fecha_inicio_evento_tarea INTO r_info_evento_tarea;
            IF(c_fecha_inicio_evento_tarea%found) THEN	

                UPDATE 
                DB_SOPORTE.INFO_EVENTO
                SET 
                FECHA_FIN = SYSDATE, 
                VALOR_TIEMPO = (ABS(60 * 1440 * (to_date((TO_CHAR(SYSDATE,'YYYY-MM-DD hh24:mi:ss')), 'YYYY-MM-DD hh24:mi:ss') - to_date((TO_CHAR(FECHA_INICIO,'YYYY-MM-DD hh24:mi:ss')), 'YYYY-MM-DD hh24:mi:ss')))), 
                FE_ULT_MOD = SYSDATE, USR_ULT_MOD = 'reg_prefact'
                WHERE
                ID_EVENTO = r_info_evento_tarea.ID_EVENTO;

                COMMIT;

            end if; 

	CLOSE c_fecha_inicio_evento_tarea;


EXCEPTION 
	WHEN OTHERS THEN 
            ROLLBACK;

            DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG('18',
                         '1',
                         'P_PROCESA_ACT_COORDENADA_MOVIL',
                         'DB_COMERCIAL.CMKG_FISCALIZA_PREFACTIBILIDAD',
                         'P_FINALIZA_EVENTO_ACTIVO',
                         'Finalizando evento',
                         'Fallido',
                         SQLERRM,
                         'cn_idComunicacion: '||cn_idComunicacion ||
                         'Pn_DetalleId: '||Pn_DetalleId,
                         'reg_prefact'
                        );    

END P_FINALIZA_EVENTO_ACTIVO;


END CMKG_FISCALIZA_PREFACTIBILIDAD;


/
