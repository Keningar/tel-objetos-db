CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_SOPORTE AS

    /**
    * Documentaci�n para el procedimiento P_DETECTAR_CLIENTES_CASOS
    *
    * Proceso encargado de detectar y reportar los clientes que ya cuentan con un caso creado,
    * previo al caso masivo que se esta creando.
    *
    * @param Pn_IdCaso     IN  NUMBER Recibe el id del caso masivo.
    * @param Pb_Notificar  IN  BOOLEAN Recibe un valor booleano para validar el envio de notificaci�n.
    * @param Pc_ResultJson OUT CLOB Retorna en formato Json el error o los clientes con casos aperturados.
    * @param Pv_Error      OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
    *
    * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
    * @version 1.0 26-04-2019
    */
    PROCEDURE P_DETECTAR_CLIENTES_CASOS(Pn_IdCaso     IN  NUMBER,
                                        Pb_Notificar  IN  BOOLEAN,
                                        Pc_ResultJson OUT CLOB,
                                        Pv_Error      OUT VARCHAR2);
                                        
  /**
   * P_CAMBIAR_ESTADO_TAREA_RECHAZA_SERVICIOS
   *
   * Procedimiento que cambia el estado de la tarea por ejecuci�n del job_rechaza_servicios
   *
   * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
   * @version 1.0 03/10/2019
   * 
   * @param Pn_idDetalleSolicitud IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD
   * @param Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO
   * @param Pv_Observacion IN VARCHAR2
   * @param Pv_EstadoActualServicio OUT Pv_Error
   */                                  
  PROCEDURE P_CAMBIAR_ESTADO_TAREA_RECHAZO(Pn_idDetalleSolicitud IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Pv_EstadoActual IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                    Pv_Observacion IN VARCHAR2,
                                    Pv_Error      OUT VARCHAR2);

/**
   * P_CREA_NC_POR_INDISPONIBILIDAD
   *
   * Procedimiento que genera notas de credito por indisponibilidad
   *
   * @author Katherine Portugal Navarro <kportugal@telconet.ec>
   * @version 1.0 04/14/2021
   * 
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.1 19/10/2022 Se cambia cursor para obtener documentos financieros del caso.
   *                          En el query se modifica el rango de fecha para tomar el documento debido a los Ciclos 2 y 3.
   *
   * OUT Pv_Error
   */                                  
  PROCEDURE P_CREA_NC_POR_INDISPONIBILIDAD(Pv_Error      OUT VARCHAR2);
  
  /**
   * P_REPORTE_NC_INDISPONIBILIDAD
   *
   * Procedimiento que genera reporte con las notas de credito generadas por indisponibilidad el dia actual(SYSDATE), generadas por el proceso de Indisponibilidad
   *
   * @author Katherine Portugal Navarro <kportugal@telconet.ec>
   * @version 1.0 04/14/2021
   * 
   * OUT Pv_Error
   */                
   PROCEDURE P_REPORTE_NC_INDISPONIBILIDAD(pv_mensaje_error   OUT VARCHAR2);

  /** 
   * P_OBTIENE_DATOS_TRACKING
   *
   * Procedimiento que obtiene informacion necesaria para enviar los cambios de estados de tareas con casos megadatos NL
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 06/09/2021
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.2 12/09/2022
   * Se agrega obtencion de foto del tecnico, cedula y codigo de trabajo
   * 
   * @param Pn_IdDetalle IN NUMBER
   * @param Pv_UsrCreacion IN VARCHAR2
   * @param Pc_ResultClob  OUT CLOB
   * @param Pv_Error OUT VARCHAR2
   */                                   
  PROCEDURE P_OBTIENE_DATOS_TRACKING(Pn_IdDetalle   IN NUMBER,
                                    Pv_UsrCreacion IN VARCHAR2,
                                    Pc_ResultClob  OUT CLOB,                                    
                                    Pn_Error       OUT NUMBER);
    /** 
   * P_INSERTA_ERROR_TRACKING
   *
   * Procedimiento que inserta los errores en los evento enviados a web service middleware
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 06/09/2021
   * 
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.1 07/01/2022
   * Se agrega insert de campo dispositivo Id(serie logica de dispositivo)
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.2 12/09/2022
   * Se agrega insert de campo cedula de tecnico y codigo de trabajo
   *
   * @param Pv_Datos          IN VARCHAR2
   * @param Pv_Direccion      IN VARCHAR2
   * @param Pv_Observacion    IN VARCHAR2
   * @param Pv_LiderCuadrilla IN VARCHAR2
   * @param Pv_NombreTecnico  IN VARCHAR2
   * @param Pv_cedulaTecnico  IN VARCHAR2
   * @param Pv_codigoTrabajo  IN VARCHAR2
   * @param Pn_Error          OUT NUMBER
   */                                   
    PROCEDURE P_INSERTA_ERROR_TRACKING(Pv_Datos          IN VARCHAR2, 
                                       Pv_Direccion      IN VARCHAR2,
                                       Pv_Observacion    IN VARCHAR2,
                                       Pv_LiderCuadrilla IN VARCHAR2,
                                       Pv_NombreTecnico  IN VARCHAR2,
                                       Pv_cedulaTecnico  IN VARCHAR2,
                                       Pv_codigoTrabajo  IN VARCHAR2,
                                       Pn_Error          OUT NUMBER);
    /** 
   * P_OBTIENE_ERROR_TRACKING
   *
   * Procedimiento que obtiene los eventos marcados como error en el web service middleware
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 06/09/2021
   * 
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.1 07/01/2022
   * Se agrega nuevo tg dispositivoId en parametro de salida PcResultadoClob 
   * 
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.2 12/09/2022
   * Se agrega nuevos campos en el ResultClob de respuesta
   *   
   * @param Pn_idDetalle IN NUMBER
   * @param Pv_Estado    IN VARCHAR2
   * @param Pc_ResultClob  OUT CLOB
   * @param Pn_NumeroReg  OUT CLOB
   * @param Pn_Error OUT NUMBER
   */                                   
  PROCEDURE P_OBTIENE_ERROR_TRACKING(Pn_IdDetalle   IN NUMBER,
                                    Pv_Estado      IN VARCHAR2,
                                    Pc_ResultClob  OUT CLOB, 
                                    Pn_NumeroReg   OUT NUMBER,
                                    Pn_Error       OUT NUMBER);

    /** 
   * P_ACTUALIZA_ERROR_TRACKING
   *
   * Procedimiento actualiza registros marcados como error en el web service middleware
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 06/09/2021
   * 
   * @param Pn_idDetalle IN NUMBER 
   * @param Pv_Estado    IN VARCHAR2
   * @param Pn_Error OUT NUMBER
   */                                   
  PROCEDURE P_ACTUALIZA_ERROR_TRACKING(Pn_IdDetalle   IN NUMBER,
                                      Pv_Estado      IN VARCHAR2,                                    
                                      Pn_Error       OUT NUMBER); 
  /** 
   * P_OBTENER_INFO_CASOS_NOT_MASIVA
   *
   * Procedimiento que obtiene la informacion del caso para notificaciones push masivas 
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 25/04/2022
   * 
   * @param Pcl_Request  IN  CLOB
   * @param Pv_Status          OUT VARCHAR2
   * @param Pv_Mensaje         OUT VARCHAR2
   * @param Pcl_Response       OUT CLOB 
   */                                   
  PROCEDURE P_OBTENER_CASOS_NOT_MASIVA(Pcl_Request  IN  CLOB,
                                       Pv_Status          OUT VARCHAR2,
                           			   Pv_Mensaje   	   OUT VARCHAR2,
                                       Pcl_Response       OUT CLOB);                       
    /** 
   * AVANCE_NOT_MASIVA
   *
   * Procedimiento que obtiene la informacion del caso para notificaciones push masivas de avances 
   *
   * @author Pedro Velez <psvelez@telconet.ec>
   * @version 1.0 25/04/2022
   * 
   * @param Pcl_Request        IN  CLOB
   * @param Pv_Status          OUT VARCHAR2
   * @param Pv_Mensaje         OUT VARCHAR2
   * @param Pcl_Response       OUT CLOB 
   */                                   
  PROCEDURE P_OBTENER_AVANCE_NOT_MASIVA(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                           			    Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT CLOB);                                      
   
END SPKG_SOPORTE;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_SOPORTE AS
 PROCEDURE P_DETECTAR_CLIENTES_CASOS(Pn_IdCaso     IN  NUMBER,
                                        Pb_Notificar  IN  BOOLEAN,
                                        Pc_ResultJson OUT CLOB,
                                        Pv_Error      OUT VARCHAR2) IS

        --Cursor que obtiene todo los clientes afectados del elemento.
        CURSOR C_GetObtenerClientesAfectado(Cn_IdCaso NUMBER) IS
            SELECT IPU.LOGIN,
                   IEL.NOMBRE_ELEMENTO,
                   ICA.EMPRESA_COD,
                   NVL(IPE.RAZON_SOCIAL,IPE.NOMBRES||' '||IPE.APELLIDOS) AS CLIENTE
                FROM DB_SOPORTE.INFO_CASO                       ICA,
                     DB_SOPORTE.INFO_DETALLE_HIPOTESIS          IDHI,
                     DB_SOPORTE.INFO_DETALLE                    IDE,
                     DB_SOPORTE.INFO_PARTE_AFECTADA             IPAF,
                     DB_INFRAESTRUCTURA.INFO_ELEMENTO           IEL,
                     DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIEL,
                     DB_COMERCIAL.INFO_SERVICIO_TECNICO         ISTE,
                     DB_COMERCIAL.INFO_SERVICIO                 ISE,
                     DB_COMERCIAL.INFO_PUNTO                    IPU,
                     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL      IPERO,
                     DB_COMERCIAL.INFO_PERSONA                  IPE
            WHERE ICA.ID_CASO                  = IDHI.CASO_ID
              AND IDHI.ID_DETALLE_HIPOTESIS    = IDE.DETALLE_HIPOTESIS_ID
              AND IDE.ID_DETALLE               = IPAF.DETALLE_ID
              AND ICA.ID_CASO                  = Cn_IdCaso
              AND IPAF.TIPO_AFECTADO           = 'Elemento'
              AND IEL.ID_ELEMENTO              = IIEL.ELEMENTO_ID
              AND IEL.ID_ELEMENTO              = ISTE.ELEMENTO_ID
              AND IIEL.ID_INTERFACE_ELEMENTO   = ISTE.INTERFACE_ELEMENTO_ID
              AND ISTE.SERVICIO_ID             = ISE.ID_SERVICIO
              AND ISE.PUNTO_ID                 = IPU.ID_PUNTO
              AND IPAF.AFECTADO_ID             = IEL.ID_ELEMENTO
              AND IPAF.AFECTADO_DESCRIPCION_ID = IIEL.ID_INTERFACE_ELEMENTO
              AND IPU.PERSONA_EMPRESA_ROL_ID   = IPERO.ID_PERSONA_ROL
              AND IPERO.PERSONA_ID             = IPE.ID_PERSONA;

        --Cursor que obtiene los casos creados y que esten abiertos de un cliente.
        CURSOR C_GetObtenerCasosClientes(Cn_IdCaso        NUMBER,
                                         Cv_LoginAfectado VARCHAR2,
                                         Cn_idEmpresa     NUMBER) IS
            SELECT DISTINCT IPAF.AFECTADO_NOMBRE AS LOGIN_AFECTADO,
                            ICA.NUMERO_CASO,
                            TO_CHAR(ICA.FE_APERTURA,'DD/MM/RRRR HH24:MI:SS') AS FE_APERTURA,
                            ICHI.ESTADO,
                            ICA.TIPO_AFECTACION,
                            ATCA.NOMBRE_TIPO_CASO        AS TIPO_CASO,
                            ANCR.NOMBRE_NIVEL_CRITICIDAD AS NIVEL_CRITICIDAD
                FROM DB_SOPORTE.INFO_CASO              ICA,
                     DB_SOPORTE.INFO_CASO_HISTORIAL    ICHI,
                     DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI,
                     DB_SOPORTE.ADMI_NIVEL_CRITICIDAD  ANCR,
                     DB_SOPORTE.ADMI_TIPO_CASO         ATCA,
                     DB_SOPORTE.INFO_DETALLE           IDE,
                     DB_SOPORTE.INFO_PARTE_AFECTADA    IPAF
            WHERE ICA.ID_CASO               = ICHI.CASO_ID
              AND ICA.ID_CASO              != Cn_IdCaso
              AND ICA.ID_CASO               = IDHI.CASO_ID
              AND ANCR.ID_NIVEL_CRITICIDAD  = ICA.NIVEL_CRITICIDAD_ID
              AND ATCA.ID_TIPO_CASO         = ICA.TIPO_CASO_ID
              AND IDHI.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID
              AND IDE.ID_DETALLE            = IPAF.DETALLE_ID
              AND ICHI.ID_CASO_HISTORIAL    = (
                    SELECT MAX(ICHIMAX.ID_CASO_HISTORIAL)
                        FROM DB_SOPORTE.INFO_CASO_HISTORIAL ICHIMAX
                    WHERE ICHIMAX.CASO_ID = ICHI.CASO_ID
              )
              AND ICHI.ESTADO                 <> 'Cerrado'
              AND ICA.EMPRESA_COD             = Cn_idEmpresa
              AND LOWER(IPAF.TIPO_AFECTADO)   = LOWER('Cliente')
              AND LOWER(IPAF.AFECTADO_NOMBRE) = LOWER(Cv_LoginAfectado)
            ORDER BY FE_APERTURA ASC;

        --Cursor para obtener el n�mero de caso
        CURSOR C_GetNumeroCaso(Cn_IdCaso NUMBER) IS
            SELECT ICA.*
                FROM DB_SOPORTE.INFO_CASO ICA
            WHERE ICA.ID_CASO = Cn_IdCaso;

        -- Variables Locales
        Lv_HtmlCab     CLOB;
        Lv_HtmlDet     CLOB;
        Lc_Caso        C_GetNumeroCaso%ROWTYPE;
        Lv_Error       VARCHAR2(1000);
        Le_MyException EXCEPTION;
        Ln_Contador    NUMBER := 0;

    BEGIN

        IF C_GetObtenerClientesAfectado%ISOPEN THEN
            CLOSE C_GetObtenerClientesAfectado;
        END IF;

        IF C_GetObtenerCasosClientes%ISOPEN THEN
            CLOSE C_GetObtenerCasosClientes;
        END IF;

        IF C_GetNumeroCaso%ISOPEN THEN
            CLOSE C_GetNumeroCaso;
        END IF;

        OPEN C_GetNumeroCaso(Pn_IdCaso);
            FETCH C_GetNumeroCaso INTO Lc_Caso;
        CLOSE C_GetNumeroCaso;

        IF Pb_Notificar OR Pb_Notificar IS NULL THEN

            Lv_HtmlCab := '</tr><td colspan="2"><table class="cssTable" align="center" width="30%" cellspacing="0" cellpadding="5">';
            Lv_HtmlCab := Lv_HtmlCab || '<tr><th colspan="2">Caso Masivo</th><tr><tr><th>N&uacute;mero de Caso</th>';
            Lv_HtmlCab := Lv_HtmlCab || '<th>Fecha de Apertura</th><tr><tr><td align="center">'||Lc_Caso.NUMERO_CASO||'</td>';
            Lv_HtmlCab := Lv_HtmlCab || '<td align="center">'||TO_CHAR(Lc_Caso.FE_APERTURA,'DD/MM/RRRR HH24:MI:SS')||'</td>';
            Lv_HtmlCab := Lv_HtmlCab || '</tr></table></td>';
            Lv_HtmlCab := Lv_HtmlCab || '<tr><td colspan="2"><table class="cssTable" align="center" width="75%" cellspacing="0" cellpadding="5">';
            Lv_HtmlCab := Lv_HtmlCab || '<tr><th colspan="8">Casos Aperturados</th><tr><tr><th>N&uacute;mero de Caso</th><th>Cliente</th>';
            Lv_HtmlCab := Lv_HtmlCab || '<th>Login Cliente</th><th>Fecha de Apertura</th><th>Estado</th><th>Nivel de Criticidad</th>';
            Lv_HtmlCab := Lv_HtmlCab || '<th>Tipo de Caso</th><th>Elemento</th></tr>';

            FOR I IN C_GetObtenerClientesAfectado(Pn_IdCaso) LOOP

                FOR J IN C_GetObtenerCasosClientes(Lc_Caso.ID_CASO,I.LOGIN,I.EMPRESA_COD) LOOP

                    Lv_HtmlDet := Lv_HtmlDet || '<tr><td>'||J.NUMERO_CASO||'</td><td>'||I.CLIENTE||'</td><td>'||J.LOGIN_AFECTADO||'</td>';
                    Lv_HtmlDet := Lv_HtmlDet || '<td>'||J.FE_APERTURA||'</td><td>'||J.ESTADO||'</td><td>'||J.NIVEL_CRITICIDAD||'</td>';
                    Lv_HtmlDet := Lv_HtmlDet || '<td>'||J.TIPO_CASO||'</td><td>'||I.NOMBRE_ELEMENTO||'</td></tr>';

                END LOOP;

            END LOOP;

            IF Lv_HtmlDet IS NOT NULL THEN

                Lv_HtmlCab := Lv_HtmlCab || Lv_HtmlDet || '</table></td></tr>';
                DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIF_PROCESO_MASIVO_DEBITOS(Lv_HtmlCab,
                                                                                 'CCCLIENTE',
                                                                                 'notificaciones_telcos@telconet.ec',
                                                                                 'DETECCI�N DE CASOS ABIERTOS - #CASO: '||Lc_Caso.NUMERO_CASO,
                                                                                 '{{ informacionCasosCreados }}',
                                                                                 'text/html; charset=UTF-8',
                                                                                  Lv_Error);

                IF Lv_Error IS NOT NULL THEN
                    RAISE Le_MyException;
                END IF;

            END IF;

        ELSE

            FOR I IN C_GetObtenerClientesAfectado(Pn_IdCaso) LOOP

                FOR J IN C_GetObtenerCasosClientes(Lc_Caso.ID_CASO,I.LOGIN,I.EMPRESA_COD) LOOP

                    Lv_HtmlDet := Lv_HtmlDet || '{"numeroCaso":"'||J.NUMERO_CASO||'","clienteAfectado":"'||I.CLIENTE||'","loginAfectado":"'||J.LOGIN_AFECTADO||'",';
                    Lv_HtmlDet := Lv_HtmlDet || '"fechaApertura":"'||J.FE_APERTURA||'","estado":"'||J.ESTADO||'","nivelCriticidad":"'||J.NIVEL_CRITICIDAD||'",';
                    Lv_HtmlDet := Lv_HtmlDet || '"tipoCaso":"'||J.TIPO_CASO||'","nombreElemento":"'||I.NOMBRE_ELEMENTO||'"},';

                END LOOP;

            END LOOP;

            IF Lv_HtmlDet IS NULL THEN
                Lv_Error := 'Sin casos Aperturados';
                RAISE Le_MyException;
            END IF;

            Lv_HtmlCab    := '{"status":"ok","result":[%resultDetalle%]}';
            Lv_HtmlCab    :=  REPLACE(Lv_HtmlCab, '%resultDetalle%', Lv_HtmlDet);
            Lv_HtmlCab    :=  REPLACE(Lv_HtmlCab, '"},]}', '"}]}');
            Pc_ResultJson := Lv_HtmlCab;

        END IF;

        Pv_Error := 'ok';

    EXCEPTION

        WHEN Le_MyException THEN

            Pv_Error      := Lv_Error;
            Pc_ResultJson := '{"status":"fail","message":"'||Lv_Error||'"}';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE',
                                                 'P_DETECTAR_CLIENTES_CASOS',
                                                  Lv_Error,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

        WHEN OTHERS THEN

            Pc_ResultJson := '{"status":"fail", "message" : "Error en el proceso"}';
            Pv_Error      := 'fail';

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_SOPORTE',
                                                 'P_DETECTAR_CLIENTES_CASOS',
                                                 'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' ||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    END P_DETECTAR_CLIENTES_CASOS;

    PROCEDURE P_CAMBIAR_ESTADO_TAREA_RECHAZO(Pn_idDetalleSolicitud IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                     Pv_EstadoActual IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                     Pv_Observacion IN VARCHAR2,
                                     Pv_Error      OUT VARCHAR2)
        AS
        --
        Lv_UsrCreacion        VARCHAR2(15) := 'Telcos+';
        Lv_MensajeError       VARCHAR2(4000);
        Ln_TotalRegistros     NUMBER := 0;
        Lo_TareaSeguimiento DB_SOPORTE.INFO_TAREA_SEGUIMIENTO%ROWTYPE;
        Lo_DetalleHistorial DB_SOPORTE.INFO_DETALLE_HISTORIAL%ROWTYPE;
        Le_Exception EXCEPTION;
        
        Lv_Status_info_tarea VARCHAR2(200);
        Lv_Mensaje_info_tarea VARCHAR2(200);

        CURSOR C_GetDetalles(Cn_idDetalleSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
        IS
          SELECT IFD.ID_DETALLE
          FROM DB_SOPORTE.INFO_DETALLE IFD
          WHERE IFD.DETALLE_SOLICITUD_ID = Cn_idDetalleSolicitud;
          
    BEGIN

        FOR I_GetDetalles IN C_GetDetalles(Pn_idDetalleSolicitud)
        LOOP

          Ln_TotalRegistros := DB_COMUNICACION.CUKG_CONSULTS.F_GET_COUNT_TAREAS(I_GetDetalles.ID_DETALLE);

          IF (Ln_TotalRegistros > 0) 
          THEN

            --Se agrega registro en la INFO_TAREA_SEGUIMIENTO
            Lo_TareaSeguimiento   := NULL;
            Lv_MensajeError       := '';

            Lo_TareaSeguimiento.DETALLE_ID    := I_GetDetalles.ID_DETALLE;
            Lo_TareaSeguimiento.OBSERVACION   := 'Tarea fue Rechazada por el motivo: ' || Pv_Observacion;
            Lo_TareaSeguimiento.USR_CREACION  := Lv_UsrCreacion;
            Lo_TareaSeguimiento.ESTADO_TAREA  := Pv_EstadoActual;

            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO(Lo_TareaSeguimiento, Lv_MensajeError);
            
            Lo_TareaSeguimiento.OBSERVACION   := 'Tarea fue Anulada por el motivo: ' || Pv_Observacion;
            Lo_TareaSeguimiento.ESTADO_TAREA  := 'Anulada';

            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO(Lo_TareaSeguimiento, Lv_MensajeError);
            
            Lo_TareaSeguimiento.OBSERVACION   := 'Tarea fue Cancelada por el motivo: ' || Pv_Observacion;
            Lo_TareaSeguimiento.ESTADO_TAREA  := 'Cancelada';
            
            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO(Lo_TareaSeguimiento, Lv_MensajeError);

            --Se agrega registro en la INFO_DETALLE_HISTORIAL
            Lo_DetalleHistorial   := NULL;
            Lv_MensajeError       := '';

            Lo_DetalleHistorial.DETALLE_ID    := I_GetDetalles.ID_DETALLE;
            Lo_DetalleHistorial.OBSERVACION   := 'Tarea fue Rechazada por el motivo: ' || Pv_Observacion;
            Lo_DetalleHistorial.USR_CREACION  := Lv_UsrCreacion;
            Lo_DetalleHistorial.ESTADO        := Pv_EstadoActual;
            Lo_DetalleHistorial.IP_CREACION   := '127.0.0.1';

            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL(Lo_DetalleHistorial, Lv_MensajeError);
            
            Lo_DetalleHistorial.OBSERVACION   := 'Tarea fue Anulada por el motivo: ' || Pv_Observacion;
            Lo_DetalleHistorial.ESTADO        := 'Anulada';

            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL(Lo_DetalleHistorial, Lv_MensajeError);
            
            Lo_DetalleHistorial.OBSERVACION   := 'Tarea fue Cancelada por el motivo: ' || Pv_Observacion;
            Lo_DetalleHistorial.ESTADO        := 'Cancelada';
            
            DB_SOPORTE.SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL(Lo_DetalleHistorial, Lv_MensajeError);

          END IF;
  
          IF TRIM(Lv_MensajeError) IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;
          
          --
          COMMIT;
          --
          --ACTUALIZAR DETALLE EN INFO_TAREA
          DB_SOPORTE.SPKG_INFO_TAREA.P_UPDATE_TAREA( I_GetDetalles.ID_DETALLE,
                                                     Lv_UsrCreacion,
                                                     Lv_Status_info_tarea,
                                                     Lv_Mensaje_info_tarea);
          --
          COMMIT;
          --
        END LOOP;
    
    EXCEPTION
    WHEN Le_Exception THEN
        --
        ROLLBACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'SPKG_SOPORTE.P_CAMBIAR_ESTADO_TAREA', 
                                                Lv_MensajeError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'SPKG_SOPORTE.P_CAMBIAR_ESTADO_TAREA', Lv_MensajeError, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
    END P_CAMBIAR_ESTADO_TAREA_RECHAZO;
    
  PROCEDURE P_CREA_NC_POR_INDISPONIBILIDAD(Pv_Error      OUT VARCHAR2) IS
    
    --Permite obtener los casos por indisponibilidad que se encuentran cerrados
    CURSOR C_GetObtenerCasosClientes IS
     SELECT     IPAF.AFECTADO_ID ID_PUNTO,
           ICA.ID_CASO,
           ICA.EMPRESA_COD,
           ICA.FE_APERTURA AS FE_INICIO,
           ICA.FE_CIERRE AS FE_FIN,
           ICTA.TIEMPO_TOTAL_CASO
      FROM DB_SOPORTE.INFO_CASO                       ICA,
           DB_SOPORTE.INFO_CASO_HISTORIAL             ICHI,
           DB_SOPORTE.INFO_DETALLE_HIPOTESIS          IDHI,
           DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION     ICTA,
           DB_COMERCIAL.INFO_SERVICIO                 ISER,
           DB_SOPORTE.INFO_PARTE_AFECTADA             IPAF,
           DB_SOPORTE.INFO_DETALLE                    IDE
     WHERE ICA.ID_CASO               = ICHI.CASO_ID
       AND ICA.ID_CASO               = IDHI.CASO_ID
       AND ICHI.ID_CASO_HISTORIAL    = (SELECT MAX(ICHIMAX.ID_CASO_HISTORIAL)
                        FROM DB_SOPORTE.INFO_CASO_HISTORIAL ICHIMAX
                    WHERE ICHIMAX.CASO_ID = ICA.ID_CASO AND ICHIMAX.ESTADO = 'Cerrado'
              )
       AND ISER.PUNTO_ID=IPAF.AFECTADO_ID
       AND ISER.PLAN_ID IS NOT NULL 
       AND ISER.ESTADO='Activo'
       AND IDHI.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID
       AND IDE.ID_DETALLE            = IPAF.DETALLE_ID  
       AND ICTA.CASO_ID              = ICA.ID_CASO       
       AND LOWER(IPAF.TIPO_AFECTADO) = LOWER('Cliente')
       AND ICA.EMPRESA_COD           = 18
       AND IDE.ID_DETALLE = (SELECT MIN(DET.ID_DETALLE)
                              FROM DB_SOPORTE.INFO_DETALLE DET
                             WHERE DET.DETALLE_HIPOTESIS_ID = IDHI.ID_DETALLE_HIPOTESIS)
       AND NOT EXISTS (SELECT 1 FROM DB_COMUNICACION.INFO_DOCUMENTO_RELACION rel
                           WHERE PUNTO_ID=IPAF.AFECTADO_ID
                             AND CASO_ID=ICA.ID_CASO
                             AND USR_CREACION = 'telcos_indispo'
                             AND ESTADO = 'Activo')
       AND ICA.TIPO_CASO_ID          IN (SELECT PARDET.VALOR2 
                                         FROM DB_GENERAL.admi_parametro_cab PARCAB,
                                              DB_GENERAL.admi_parametro_det PARDET
                                        WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
                                          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
                                          AND PARDET.ESTADO = 'Activo' 
                                          AND PARCAB.ESTADO = 'Activo'
                                          AND PARDET.DESCRIPCION = 'TIPO CASO')
       AND ICA.TIPO_AFECTACION        IN (SELECT PARDET.VALOR1 
                                         FROM DB_GENERAL.admi_parametro_cab PARCAB,
                                              DB_GENERAL.admi_parametro_det PARDET
                                        WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
                                          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
                                          AND PARDET.ESTADO = 'Activo' 
                                          AND PARCAB.ESTADO = 'Activo'
                                          AND PARDET.DESCRIPCION = 'TIPO AFECTACION')
       AND ica.titulo_fin_hip        IN (SELECT PARDET.VALOR2
                                         FROM DB_GENERAL.admi_parametro_cab PARCAB,
                                              DB_GENERAL.admi_parametro_det PARDET
                                        WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
                                          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
                                          AND PARDET.ESTADO = 'Activo' 
                                          AND PARCAB.ESTADO = 'Activo'
                                          AND PARDET.DESCRIPCION = 'MOTIVO DE INDISPONIBILIDAD PARA NC')
                                          
       AND ICTA.TIEMPO_TOTAL_CASO/60 >= (SELECT (
                                                (SELECT PARDET.VALOR1/100
                                             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                                                  DB_GENERAL.admi_parametro_det PARDET
                                            WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
                                              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
                                              AND PARDET.ESTADO = 'Activo' 
                                              AND PARCAB.ESTADO = 'Activo'
                                              AND PARDET.DESCRIPCION = 'PORCENTAJE INDISPONIBILIDAD' ) 
                                                 * 
(CASE PARDET.VALOR1 WHEN
                                                'MENSUAL' THEN (to_number(to_char(LAST_DAY(ICA.FE_APERTURA), 'DD')))*24
                                                ELSE TO_NUMBER(PARDET.VALOR2)*24
                                                END)
                                                ) HORAS_PERMITIDAS
                                             FROM DB_GENERAL.admi_parametro_cab PARCAB,
                                                  DB_GENERAL.admi_parametro_det PARDET
                                            WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
                                              AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
                                              AND PARDET.DESCRIPCION = 'TIPO DE PERIODO'
                                              AND PARDET.ESTADO = 'Activo' 
                                              AND PARCAB.ESTADO = 'Activo')                                              
       AND TO_CHAR(ICA.FE_CIERRE,'MM/YYYY')  = TO_CHAR(SYSDATE,'MM/YYYY');
      
      -- Cursor para obtener los parametros configurados con los siguentes valores
      --VALOR1 TIPO FRECUENCIA
      --VALOR2 PORCENTAJE
      --VALOR3 NUMERO DIAS
      CURSOR C_GetObtenerParametros IS
       SELECT PARDET.VALOR1 AS TIPO_FRE,
              PARDET.VALOR2 AS PORC,
              PARDET.VALOR3 AS NUM_DIAS
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'TIPO DE PERIODO'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo';  
        
      --Cursor para obtener documentos financieros que pose el punto del caso 
      CURSOR C_GetObtDocFinanciero(Cn_IdPunto NUMBER,Cn_TipoDocFAC NUMBER, Cd_FeInicio  DATE) IS
       SELECT MAX(ID_DOCUMENTO) FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB 
        WHERE PUNTO_ID = Cn_IdPunto
          AND TIPO_DOCUMENTO_ID=CN_TipoDocFAC
          AND ES_AUTOMATICA='S'
          AND RECURRENTE='S'
          AND USR_CREACION='telcos'          
          AND ESTADO_IMPRESION_FACT IN ('Activo','Cerrado')
          AND FE_EMISION BETWEEN TRUNC(ADD_MONTHS(Cd_FeInicio, -1), 'MM') AND TRUNC(Cd_FeInicio);
          
       --Cursor para obtener motivo creacion nota credito 
      CURSOR C_GetObtenerMotivo IS
      SELECT PARDET.VALOR2
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'PARAMETROS GENERALES PARA NC INDISPONIBILIDAD'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'MOTIVO DE INDISPONIBILIDAD'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo';
       
      --Cursor para obtener tipo de documento nota credito 
      CURSOR C_GetObtTipDocNC IS
      SELECT ID_TIPO_DOCUMENTO 
        FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO 
       WHERE NOMBRE_TIPO_DOCUMENTO ='Nota de credito';
       
      --Cursor para obtener tipo de documento factura
      CURSOR C_GetObtTipoDocFac IS
      SELECT ID_TIPO_DOCUMENTO 
        FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO 
       WHERE NOMBRE_TIPO_DOCUMENTO ='Factura';
      
       --Cursor para obtener tipo de documento nota credito 
      CURSOR C_GetObtPrefijoEmpre (Cn_CodEmpresa NUMBER) is      
      SELECT PREFIJO 
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO 
       WHERE COD_EMPRESA=Cn_CodEmpresa;
       
        --Cursor para obtener le numero de dias permitidos por indisponibilidad
      CURSOR C_GetDiasIndisponibilidad is      
      SELECT PARDET.VALOR1
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'PARAMETROS DE INDISPONIBILIDAD PARA NC'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'DIAS INDISPONIBILIDAD NC'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo';
        
           --Cursor para obtener la observacion de la Nc
      CURSOR C_GetObservacionNc is      
      SELECT PARDET.VALOR1
         FROM DB_GENERAL.admi_parametro_cab PARCAB,
              DB_GENERAL.admi_parametro_det PARDET
        WHERE PARCAB.Nombre_parametro = 'PARAMETROS GENERALES PARA NC INDISPONIBILIDAD'
          AND PARDET.PARAMETRO_ID=PARCAB.ID_PARAMETRO
          AND PARDET.DESCRIPCION = 'OBSERVACION NOTA CREDITO POR INDISPONIBILIDAD'
          AND PARDET.ESTADO = 'Activo' 
          AND PARCAB.ESTADO = 'Activo';
    
    Lr_Parametros           C_GetObtenerParametros%ROWTYPE;
    Ln_diasIndisPermitido   NUMBER;
    Lv_PrefijoEmpre         DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
    Lv_UsrCreacion          VARCHAR2(15) := 'telcos_indispo';
    Lv_Estado               VARCHAR2(15) := 'Pendiente';
    Lv_Observacion          VARCHAR2(100) ;
    Lv_ValorOriginal        VARCHAR2(1):= 'N';
    Lv_ObservacionCreacion  VARCHAR2(4000);
    Lv_PorcentajeServicio   VARCHAR2(1):= 'N';
    Lv_ProporcionalPorDias  VARCHAR2(1):= 'Y';
    Lv_MsnError             VARCHAR2(4000);
    Ln_IdAdmMotivo          NUMBER(38,0);
    Ln_IdDocumentoNC        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_TipoDocNC            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Ln_TipoDocFAC           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Ln_ValorTotal           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Ln_DocFact              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_InfoDoc              DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_NumDiasInd           NUMBER;
    Lbool_Done              BOOLEAN;
    Le_Exception            EXCEPTION;
    
    BEGIN
    
    IF C_GetObtenerParametros%ISOPEN  THEN
          CLOSE C_GetObtenerParametros;
    END IF;
    
    OPEN C_GetObtenerParametros;
   FETCH C_GetObtenerParametros
    INTO Lr_Parametros;
   CLOSE C_GetObtenerParametros;
   
   IF C_GetObservacionNc%ISOPEN  THEN
          CLOSE C_GetObservacionNc;
    END IF;
    
    OPEN C_GetObservacionNc;
   FETCH C_GetObservacionNc
    INTO Lv_Observacion;
   CLOSE C_GetObservacionNc;
   
    
      IF C_GetObtenerMotivo%ISOPEN  THEN
   CLOSE C_GetObtenerMotivo;
  END IF;
    
    OPEN C_GetObtenerMotivo;
   FETCH C_GetObtenerMotivo
    INTO Ln_IdAdmMotivo;
   CLOSE C_GetObtenerMotivo;
    
    IF C_GetObtTipoDocFac%ISOPEN  THEN
       CLOSE C_GetObtTipoDocFac;
    END IF;
        
    OPEN C_GetObtTipoDocFac;
   FETCH C_GetObtTipoDocFac
    INTO Ln_TipoDocFac;
   CLOSE C_GetObtTipoDocFac;
    
      IF C_GetObtTipDocNC%ISOPEN  THEN
         CLOSE C_GetObtTipDocNC;
      END IF;
    
    OPEN C_GetObtTipDocNC;
   FETCH C_GetObtTipDocNC
    INTO Ln_TipoDocNc;
   CLOSE C_GetObtTipDocNC;
     
      IF C_GetObtenerCasosClientes%ISOPEN  THEN
         CLOSE C_GetObtenerCasosClientes;
      END IF;
      
      --
      
       IF C_GetDiasIndisponibilidad%ISOPEN  THEN
         CLOSE C_GetDiasIndisponibilidad;
      END IF;
    
    OPEN C_GetDiasIndisponibilidad;
   FETCH C_GetDiasIndisponibilidad
    INTO Ln_diasIndisPermitido;
   CLOSE C_GetDiasIndisponibilidad;
      
    FOR I_GetCasos IN C_GetObtenerCasosClientes
    
    LOOP
    
         IF C_GetObtPrefijoEmpre%ISOPEN  THEN
               CLOSE C_GetObtPrefijoEmpre;
         END IF;
              
          OPEN C_GetObtPrefijoEmpre(I_GetCasos.EMPRESA_COD);
         FETCH C_GetObtPrefijoEmpre
          INTO Lv_PrefijoEmpre;
         CLOSE C_GetObtPrefijoEmpre;
          
        IF C_GetObtDocFinanciero%ISOPEN  THEN
              CLOSE C_GetObtDocFinanciero;
        END IF;
             
        OPEN C_GetObtDocFinanciero(I_GetCasos.ID_PUNTO,Ln_TipoDocFac, I_GetCasos.FE_INICIO);
              FETCH C_GetObtDocFinanciero
              INTO Ln_DocFact;
        CLOSE C_GetObtDocFinanciero;        
        
        --El numero de dias que estuvo el cliente con indisponibilidad
        Ln_NumDiasInd := I_GetCasos.TIEMPO_TOTAL_CASO/1440;
        
        IF Ln_NumDiasInd <= Ln_diasIndisPermitido THEN
           Lv_Estado := 'Aprobada';
        END IF;
        
        IF Ln_DocFact IS NOT NULL THEN
        
        DB_FINANCIERO.FNCK_CONSULTS.P_CREA_NOTA_CREDITO (Ln_DocFact ,
                                                         Ln_TipoDocNc,
                                                         Lv_Observacion,
                                                         Ln_IdAdmMotivo,
                                                         Lv_UsrCreacion,
                                                         Lv_Estado,
                                                         Lv_ValorOriginal,
                                                         Lv_PorcentajeServicio,
                                                         to_number(Lr_Parametros.PORC),
                                                         Lv_ProporcionalPorDias,
                                                         TO_CHAR( I_GetCasos.FE_INICIO,'DD/MM/YYYY'),
                                                         TO_CHAR( I_GetCasos.FE_FIN,'DD/MM/YYYY'),
                                                         null,
                                                         I_GetCasos.EMPRESA_COD,
                                                         Ln_ValorTotal,
                                                         Ln_IdDocumentoNC,
                                                         Lv_ObservacionCreacion,
                                                         Lbool_Done,
                                                         Lv_MsnError);                                                         
           
           IF Ln_IdDocumentoNC IS NOT NULL THEN
              IF Lv_Estado='Aprobada' THEN
                  DB_FINANCIERO.FNCK_TRANSACTION.P_NUMERA_NOTA_CREDITO(Pn_DocumentoId    => Ln_IdDocumentoNC,
                                                                       Pv_PrefijoEmpresa => Lv_PrefijoEmpre,
                                                                       Pv_ObsHistorial   => Lv_Observacion,
                                                                       Pv_UsrCreacion    => Lv_UsrCreacion,
                                                                       Pv_Mensaje        => Lv_MsnError);
              
              END IF;
              
              BEGIN
              
              Ln_infoDoc := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
              INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO(ID_DOCUMENTO,
                                                         TIPO_DOCUMENTO_ID,
                                                         CLASE_DOCUMENTO_ID,
                                                         NOMBRE_DOCUMENTO,
                                                         UBICACION_LOGICA_DOCUMENTO,
                                                         UBICACION_FISICA_DOCUMENTO,
                                                         DOCUMENTO,
                                                         FECHA_DOCUMENTO,
                                                         MODELO_ELEMENTO_ID,
                                                         ELEMENTO_ID,
                                                         CONTRATO_ID,
                                                         DOCUMENTO_FINANCIERO_ID,
                                                         TAREA_INTERFACE_MODELO_TRA_ID,
                                                         USR_CREACION,
                                                         FE_CREACION,
                                                         IP_CREACION,
                                                         ESTADO,
                                                         MENSAJE,
                                                         EMPRESA_COD,
                                                         TIPO_DOCUMENTO_GENERAL_ID,
                                                         FECHA_DESDE,
                                                         FECHA_HASTA,
                                                         FE_ULT_MOD,
                                                         USR_ULT_MOD,
                                                         LATITUD,
                                                         LONGITUD,
                                                         ETIQUETA_DOCUMENTO,
                                                         CUADRILLA_HISTORIAL_ID) 
                                                         VALUES(Ln_InfoDoc,
                                                         Ln_TipoDocNc,
                                                         NULL,
                                                         Lv_Observacion,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         SYSDATE,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         Ln_DocFact,
                                                         NULL,
                                                         Lv_UsrCreacion,
                                                         SYSDATE,
                                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'),
                                                         'Activo',
                                                         null,
                                                         I_GetCasos.EMPRESA_COD,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null,
                                                         null);
             
              INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_RELACION(ID_DOCUMENTO_RELACION,
                                                                  DOCUMENTO_ID,
                                                                  MODULO,
                                                                  ENCUESTA_ID,
                                                                  SERVICIO_ID,
                                                                  PUNTO_ID,
                                                                  PERSONA_EMPRESA_ROL_ID,
                                                                  CONTRATO_ID,
                                                                  DOCUMENTO_FINANCIERO_ID,
                                                                  CASO_ID,
                                                                  ACTIVIDAD_ID,
                                                                  TIPO_ELEMENTO_ID,
                                                                  MODELO_ELEMENTO_ID,
                                                                  ELEMENTO_ID,
                                                                  ESTADO,
                                                                  FE_CREACION,
                                                                  USR_CREACION,
                                                                  DETALLE_ID,
                                                                  ORDEN_TRABAJO_ID,
                                                                  MANTENIMIENTO_ELEMENTO_ID,
                                                                  ESTADO_EVALUACION,
                                                                  EVALUACION_TRABAJO,
                                                                  FE_INICIO_EVALUACION,
                                                                  USR_EVALUACION,
                                                                  PORCENTAJE_EVALUACION_BASE,
                                                                  PORCENTAJE_EVALUADO,
                                                                  NUMERO_ADENDUM,
                                                                  PAGO_DATOS_ID )
                                                                  VALUES(
                                                                  DB_COMUNICACION.SEQ_INFO_DOCUMENTO_RELACION.NEXTVAL,
                                                                  Ln_infoDoc,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  I_GetCasos.ID_PUNTO,
                                                                  null,
                                                                  null,
                                                                  Ln_IdDocumentoNC,
                                                                  I_GetCasos.ID_CASO,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  'Activo',
                                                                  SYSDATE,
                                                                  Lv_UsrCreacion,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null);
              
        EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        Lv_MsnError := SQLCODE || ' -ERROR-CREA-INFO_DOCUMENTO ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('telcos_indispo', 'SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD', Lv_MsnError, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        END;
    
        ELSE
                 Pv_Error:=Lv_ObservacionCreacion;
                 DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('telcos_indispo', 'SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD', 
                                                Lv_MsnError || ' - ' || Pv_Error || ' - ' || SQLCODE || ' -ERROR-GENERAR_NC ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        END IF;
            
    ELSE
        Pv_Error:='No se puede generar nota de credito por insdiponibilidad, no existe factura para el mes afectado';
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('telcos_indispo', 'SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD', 
                                                Lv_MsnError || ' - ' || Pv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END IF;
          
    COMMIT;
            
  END LOOP;
        
        EXCEPTION
    WHEN Le_Exception THEN
        --
        ROLLBACK;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('telcos_indispo', 'SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD', 
                                                Lv_MsnError || ' - ' || Pv_Error || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    WHEN OTHERS THEN
        --
        ROLLBACK;
         Pv_Error:= SQLERRM;
        Lv_MsnError := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('telcos_indispo', 'SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD', Lv_MsnError, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
    END P_CREA_NC_POR_INDISPONIBILIDAD;
    
   PROCEDURE P_REPORTE_NC_INDISPONIBILIDAD(pv_mensaje_error   OUT VARCHAR2) IS
    
    --Cursor para obtener tipo de documento nota credito 
      CURSOR C_GetObtTipDocNC IS
      SELECT ID_TIPO_DOCUMENTO 
        FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO 
       WHERE NOMBRE_TIPO_DOCUMENTO ='Nota de credito';
      
        --Cursor para obtener tipo de documento nota credito 
      CURSOR C_GetObtenerNC  IS
            SELECT
            ipu.login                   AS login,
            adju.nombre_jurisdiccion    AS jurisdiccion,
            nvl(per.razon_social, per.nombres
                                  || ' '
                                  || per.apellidos)            nombre_cliente,
            idfc.numero_factura_sri     AS numero_nc,
            idfc.valor_total            AS valor_nc,
            ica.numero_caso             AS num_caso,
            icta.tiempo_total_caso      AS tiempo_sin_servicio,
            idfc.estado_impresion_fact
        FROM
            db_financiero.info_documento_financiero_cab    idfc,
            db_comunicacion.info_documento_relacion        idr,
            db_soporte.info_caso                           ica,
            db_soporte.info_caso_tiempo_asignacion         icta,
            db_comercial.info_punto                        ipu,
            db_infraestructura.admi_jurisdiccion           adju,
            db_comercial.info_persona_empresa_rol          iper,
            db_comercial.info_persona                      per
        WHERE
                trunc(idfc.fe_creacion) = trunc(sysdate)
            AND idfc.usr_creacion = 'telcos_indispo'
            AND ipu.id_punto = idr.punto_id
            AND idr.caso_id = ica.id_caso
            AND idr.documento_financiero_id = idfc.id_documento
            AND icta.caso_id = ica.id_caso
            AND ipu.persona_empresa_rol_id = iper.id_persona_rol
            AND iper.persona_id = per.id_persona
            AND ipu.punto_cobertura_id = adju.id_jurisdiccion;
            
            
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
    
    Ln_TipoDocNC            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lr_Parametros           C_GetObtenerNC%ROWTYPE;
    
    --Variables de configuraci�n
    Lv_NombreArchivoComprimir    VARCHAR2(100)  := '';
    Lv_Gzip                      VARCHAR2(500)  := '';
    Lv_NombreArchivo             VARCHAR2(100) := 'ReporteNC_Indisp_'||to_char(SYSDATE,'YYYYMMDD')||'.csv';
    Lv_nombre_archivo_comprimir  VARCHAR2(100)  := '';
    Lv_NombreParametro           VARCHAR2(100)  := 'PARAMETROS_REPORTE_NC_INDISPONIBILIDAD';
    Lv_directorio                VARCHAR2(50)   := 'DIR_REPORTES_NC_INDISP';
    Lv_Modulo                    VARCHAR2(7)   := 'SOPORTE';
    Lv_asunto                    VARCHAR2(100)   := 'Generacion de Reporte de Notas credito por Indisponibilidad';
    Lv_ParametroRemitente        VARCHAR2(16)  := 'CORREO_REMITENTE';
    Lv_ParametroDestinatario      VARCHAR2(25)  := 'CORREO_DESTINATARIO';
    Lv_ParametroNombreDirectorio VARCHAR2(25)  := 'DIRECTORIO_REPORTES';
    Lv_ParametroComandoReporte   VARCHAR2(15)  := 'COMANDO_REPORTE';
    Lv_ParametroExtensionReporte VARCHAR2(17)  := 'EXTENSION_REPORTE';
    Lv_ParametroPlantilla        VARCHAR2(50)  := 'PLANTILLA_NOTIFICACION_REPORTE_NC';
    Lv_IpCreacion                VARCHAR2(30)   := '127.0.0.1';
    Lf_archivo                   utl_file.file_type;
    Lv_plantilla_notificacion    VARCHAR2(4000) := '';
    Lv_delimitador               VARCHAR2(1) := '|';
    Lv_comando_ejecutar          VARCHAR2(200)  := '';
    Lv_ParametroExtension        VARCHAR2(200)  := '';
    Lv_remitente                 VARCHAR2(100)  := '';
    Lv_destinatario              VARCHAR2(100)  := '';
    Lv_direccion_completa        VARCHAR2(200)  := '';
 

    BEGIN
        
    IF C_GetObtTipDocNC%ISOPEN  THEN
     CLOSE C_GetObtTipDocNC;
    END IF;
    
    IF C_ParametrosConfiguracion%ISOPEN THEN
        CLOSE C_ParametrosConfiguracion;
    END IF;
    
    
    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRemitente);
            FETCH C_ParametrosConfiguracion INTO Lv_remitente;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroDestinatario);
            FETCH C_ParametrosConfiguracion INTO Lv_destinatario;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroNombreDirectorio);
            FETCH C_ParametrosConfiguracion INTO Lv_direccion_completa;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroComandoReporte);
            FETCH C_ParametrosConfiguracion INTO Lv_comando_ejecutar;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroExtensionReporte);
            FETCH C_ParametrosConfiguracion INTO Lv_ParametroExtension;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantilla);
            FETCH C_ParametrosConfiguracion INTO Lv_plantilla_notificacion;
        CLOSE C_ParametrosConfiguracion;

    
    
    OPEN C_GetObtTipDocNC;
   FETCH C_GetObtTipDocNC
    INTO Ln_TipoDocNc;
   CLOSE C_GetObtTipDocNC;
    
   --Se crea el archivo
    Lf_Archivo := UTL_FILE.FOPEN(Lv_directorio,Lv_NombreArchivo,'w',32767);
    
    -- CABECERAS DEL REPORTE
    utl_file.put_line(Lf_archivo, 
                    'LOGIN'||Lv_delimitador 
                  ||'JURISDICCION'||Lv_delimitador 
                  ||'NOMBRE CLIENTE'||Lv_delimitador
                  ||'VALOR NC'||Lv_delimitador
                  ||'NUMERO DE NC'||Lv_delimitador
                  ||'TIEMPO SIN SERVICIO'||Lv_delimitador
                  ||'NUMERO DE CASO'||Lv_delimitador
                  ||'ESTADO'||Lv_delimitador);
                  
    IF C_GetObtenerNC%ISOPEN THEN 
      CLOSE C_GetObtenerNC;
    END IF;
    
    FOR i IN C_GetObtenerNC LOOP
    BEGIN
    
    
    utl_file.put_line(Lf_archivo, i.LOGIN ||Lv_delimitador                                     -- 1)LOGIN
                      ||i.JURISDICCION||Lv_delimitador                                  -- 2)JURISDICCION
                      ||i.NOMBRE_CLIENTE||Lv_delimitador                              -- 3)NOMBRE_CLIENTE
                      ||i.VALOR_NC||Lv_delimitador                               -- 4)VALOR_NC
                      ||i.NUMERO_NC||Lv_delimitador                                   -- 5)NUMERO_NC
                      ||i.TIEMPO_SIN_SERVICIO||Lv_delimitador                                -- 6)TIEMPO_SIN_SERVICIO
                      ||i.NUM_CASO||Lv_delimitador                                  -- 7)NUM_CASO
                      ||i.estado_impresion_fact||Lv_delimitador 
                      );  
   

      exception
      when others then
      pv_mensaje_error := '';
      
      end;
    
    END LOOP;
    
    utl_file.fclose(lf_archivo);

    --Se arma el comando a ejecutar
    Lv_gzip := Lv_comando_ejecutar|| ' ' || Lv_direccion_completa || '/' || Lv_NombreArchivo;
    
    --Armo nombre completo del archivo que se genera
    Lv_nombre_archivo_comprimir := Lv_NombreArchivo || Lv_ParametroExtension;
    
    
    dbms_output.put_line(naf47_tnet.javaruncommand (lv_Gzip));
    
    /* Se envia notificacion de la generacion del reporte */
    Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<lv_nombre_archivo_comprimir>>',Lv_NombreArchivo);
    Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<pv_fecha_inicio>>',to_char(SYSDATE,'YYYYMMDD'));
    
    db_general.gnrlpck_util.send_email_attach(Lv_remitente,Lv_destinatario,Lv_asunto, Lv_Plantilla_Notificacion,
                                              Lv_directorio,lv_nombre_archivo_comprimir);                                        
    
    utl_file.fremove(lv_directorio,lv_nombre_archivo_comprimir);    
    pv_mensaje_error := 'Proceso realizado con exito';
    
    EXCEPTION
    WHEN OTHERS THEN
      pv_mensaje_error := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;  
    
      db_general.gnrlpck_util.insert_error('Telcos +', 
                                            'SPKG_SOPORTE.P_REPORTE_NC_INDISPONIBILIDAD', 
                                            SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos_indispo'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );  

  END P_REPORTE_NC_INDISPONIBILIDAD;

  PROCEDURE P_OBTIENE_DATOS_TRACKING(Pn_IdDetalle   IN NUMBER,
                                      Pv_UsrCreacion IN VARCHAR2,
                                      Pc_ResultClob  OUT CLOB,                                    
                                      Pn_Error       OUT NUMBER) AS
      Lv_Numero_Caso     VARCHAR2(100);
      Ln_Numero_Tarea    NUMBER;
      Lv_Titulo_Inicial  VARCHAR2(500); 
      Lv_Titulo_Fin      VARCHAR2(500); 
      Ln_Id_Detalle_Hip  NUMBER;
      Lv_Login_Cliente   VARCHAR2(100);
      Lv_Latitud         VARCHAR2(50);
      Lv_Longitud        VARCHAR2(60);
      Lv_Nombre_Cliente  VARCHAR2(500);
      Lv_Direccion       VARCHAR2(1000);
      Lv_Identificacion  VARCHAR2(20);
      Lv_Prefijo_Empresa VARCHAR2(2);
      Lv_Nombre_Tecnico  VARCHAR2(500);
      Lv_Nombre_Jefe     VARCHAR2(500);
      Ln_id_Jefe         NUMBER;
      Ln_Id_Per_Rol_jefe NUMBER;
      Lv_Id_dispositivo  VARCHAR2(500);
      Lc_Resultado       CLOB;
      Le_Exception       EXCEPTION;
      Lv_Error           VARCHAR2(250);
      Lv_Fecha_Agen      VARCHAR2(10);
      Lv_Hora_Agen       VARCHAR2(10);
      Ln_Tecnico_Rol     number;
      Lv_Identificacion_Tec Varchar2(20);
      Lv_urlFotoTecnico  Varchar2(1000);
      Lv_pathUrlPublica  Varchar2(1000);
      Lv_Codigo_Trabajo  Varchar2(15);
      Lv_Cod_Empresa     Varchar2(3);
      Lv_ParticionNfs    varchar2(2000);
      Lv_ParticionAux    varchar2(2000);
      Ln_PersonaIdCliente number:=null;
      Lv_NumeroContacto varchar2(50):='';
      
    BEGIN

         begin
              SELECT IC.NUMERO_CASO, 
                     ICO.ID_COMUNICACION AS NUMERO_TAREA, 
                     IC.TITULO_INI, 
                     IC.TITULO_FIN, 
                     DH.ID_DETALLE_HIPOTESIS
                INTO Lv_Numero_Caso,
                     Ln_Numero_Tarea,
                     Lv_Titulo_Inicial,
                     Lv_Titulo_Fin,
                     Ln_Id_Detalle_Hip
                FROM DB_SOPORTE.INFO_DETALLE DET,
                     DB_SOPORTE.INFO_DETALLE_HIPOTESIS DH,
                     DB_SOPORTE.INFO_CASO IC,
                     DB_COMUNICACION.INFO_COMUNICACION ICO
               WHERE DET.DETALLE_HIPOTESIS_ID = DH.ID_DETALLE_HIPOTESIS 
                 AND DH.CASO_ID = IC.ID_CASO
                 AND DET.ID_DETALLE = ICO.DETALLE_ID
                 AND DET.ID_DETALLE = Pn_IdDetalle
                 and rownum = 1;
         exception
           when others then
              Lv_Numero_Caso :='';
              Ln_Numero_Tarea   := 0;
              Lv_Titulo_Inicial := '';
              Lv_Titulo_Fin     := '';
              Ln_Id_Detalle_Hip := 0;
         end;

         begin
              select PA.AFECTADO_NOMBRE,
                     IP.LATITUD,
                     IP.LONGITUD,
                     PE.NOMBRES ||' '||PE.APELLIDOS AS NOMBRE_CLIENTE,
                     IP.DIRECCION,
                     PE.IDENTIFICACION_CLIENTE,
                     EG.PREFIJO,
                     PE.ID_PERSONA
                INTO Lv_Login_Cliente,
                     Lv_Latitud,
                     Lv_Longitud,
                     Lv_Nombre_Cliente,
                     Lv_Direccion,
                     Lv_Identificacion,
                     Lv_Prefijo_Empresa,
                     Ln_PersonaIdCliente
                from DB_SOPORTE.INFO_DETALLE s, 
                     DB_SOPORTE.INFO_PARTE_AFECTADA PA,
                     DB_COMERCIAL.INFO_PUNTO IP,
                     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                     DB_COMERCIAL.INFO_PERSONA PE,
                     DB_COMERCIAL.INFO_EMPRESA_ROL ER,
                     DB_COMERCIAL.INFO_EMPRESA_GRUPO EG
               where S.ID_DETALLE = PA.DETALLE_ID
                 AND PA.AFECTADO_NOMBRE = IP.LOGIN
                 AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                 AND IPER.PERSONA_ID = PE.ID_PERSONA
                 AND IPER.EMPRESA_ROL_ID = ER.ID_EMPRESA_ROL
                 AND ER.EMPRESA_COD = EG.COD_EMPRESA
                 AND S.DETALLE_HIPOTESIS_ID = Ln_Id_Detalle_Hip
                 AND PA.TIPO_AFECTADO = 'Cliente';
                 --AND EG.PREFIJO = 'MD';
         exception
           when others then
             Lv_Login_Cliente  :='';
             Lv_Latitud        :='';
             Lv_Longitud       :='';
             Lv_Nombre_Cliente :='';
             Lv_Direccion      :='';
             Lv_Identificacion :='';
             Lv_Prefijo_Empresa:='';
             Ln_PersonaIdCliente := null;
         end;  
         
         
         IF upper(Lv_Prefijo_Empresa) = 'TN' THEN 
         
             Lv_Login_Cliente  :='';
             Lv_Latitud        :='';
             Lv_Longitud       :='';
             Lv_Nombre_Cliente :='';
             Lv_Direccion      :='';
             Lv_Identificacion :='';
             Lv_Prefijo_Empresa:='';
             Ln_PersonaIdCliente := null;
         
         END IF; 
         
         if Ln_PersonaIdCliente is not null then 
             begin
                 select P.VALOR into Lv_NumeroContacto
                    from DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO p 
                    where P.PERSONA_ID= Ln_PersonaIdCliente 
                    and P.FORMA_CONTACTO_ID in (25,26,27)
                    and P.ESTADO = 'Activo'
                    and rownum =1;
             exception
               when others then
                 Lv_NumeroContacto  :='';
             end; 
         end if;
 
         begin
           select S.PERSONA_EMPRESA_ROL_ID 
             into Ln_Tecnico_Rol
             from DB_SOPORTE.INFO_DETALLE_HISTORIAL s 
            where S.DETALLE_ID = Pn_IdDetalle
              and rownum = 1;
         exception
           when others then
              Ln_Tecnico_Rol := 0;
         end;
 
         begin
          select P.NOMBRES ||' '|| P.APELLIDOS
            into Lv_Nombre_Tecnico
            from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL s,
                 DB_COMERCIAL.INFO_PERSONA p
           where P.ID_PERSONA = S.PERSONA_ID 
             and S.ID_PERSONA_ROL = Ln_Tecnico_Rol
             and S.ESTADO = 'Activo'
             and P.ESTADO = 'Activo';
         exception
           when others then
           Lv_Nombre_Tecnico := '';
         end;     
         
         begin         
           select P.ID_PERSONA,                   
                  substr(P.NOMBRES,1,instr(P.NOMBRES,' '))||substr(P.APELLIDOS,1,instr(P.APELLIDOS,' ')-1)
                  as NOMBRE_JEFE,
                  ER.ID_PERSONA_ROL,
                  P.Identificacion_Cliente,
                  Rol.Empresa_Cod
             INTO Ln_Id_Jefe, 
                  Lv_Nombre_Jefe,
                  Ln_Id_Per_Rol_jefe,
                  Lv_Identificacion_Tec,
                  Lv_Cod_Empresa
             from DB_SOPORTE.INFO_CUADRILLA_TAREA ct,
                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL er,
                  DB_COMERCIAL.INFO_PERSONA p,
                  INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
                  DB_COMERCIAL.Info_Empresa_Rol rol
            where ct.cuadrilla_id = er.cuadrilla_id 
              and ER.PERSONA_ID = P.ID_PERSONA
              and IPERC.PERSONA_EMPRESA_ROL_ID = er.ID_PERSONA_ROL
              and Rol.Id_Empresa_Rol= Er.Empresa_Rol_Id
              AND IPERC.VALOR  = 'Lider' 
              AND IPERC.ESTADO = 'Activo'
              and er.ESTADO = 'Activo'
              and p.ESTADO = 'Activo'
              and Rol.Estado not in('Inactivo','Eliminado')
              and ct.detalle_id = Pn_IdDetalle
              and ROWNUM = 1;

         exception
           when others then
               Ln_Id_Jefe := 0; 
               Lv_Nombre_Jefe := '';
               Ln_Id_Per_Rol_jefe := 0; 
               Lv_Identificacion_Tec := '';
               Lv_Cod_Empresa := '';
         end;
         
         begin
             select T.Valor 
               into Lv_urlFotoTecnico
               from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC t 
              where T.PERSONA_EMPRESA_ROL_ID = Ln_Id_Per_Rol_jefe 
                and T.Caracteristica_Id = (select S.Id_Caracteristica 
                                             from DB_COMERCIAL.admi_caracteristica s 
                                            where S.Descripcion_Caracteristica='URL_FOTO_EMPLEADO')
                and T.Estado = 'Activo';
         exception
           when others then
            Lv_urlFotoTecnico:= null;
         end;  

         IF Lv_urlFotoTecnico IS NOT NULL THEN
         
           Lv_ParticionAux := substr(Lv_urlFotoTecnico,instr(Lv_urlFotoTecnico,'/',1,3)+1,length(Lv_urlFotoTecnico));
           Lv_ParticionNfs := substr(Lv_ParticionAux,0,instr(Lv_ParticionAux,'/')-1);
           
            begin
              select APD.VALOR2
                into Lv_pathUrlPublica
                from DB_GENERAL.ADMI_PARAMETRO_DET apd
               where APD.PARAMETRO_ID = (Select APC.ID_PARAMETRO 
                                        from DB_GENERAL.ADMI_PARAMETRO_CAB apc 
                                       where apc.NOMBRE_PARAMETRO   ='URL_MICROSERVICIO'
                                       and APC.ESTADO = 'Activo')
                 and APD.DESCRIPCION =  'PATH_URL_PUBLICA'
                 and APD.VALOR1 = Lv_ParticionNfs
                 and APD.ESTADO ='Activo';
              exception
                when others then
                   Lv_pathUrlPublica:=null;
            end;
            
            IF Lv_pathUrlPublica IS NOT NULL THEN
                 Lv_urlFotoTecnico:=  Lv_pathUrlPublica || substr(Lv_urlFotoTecnico,instr(Lv_urlFotoTecnico,'/',1,9)+1,length(Lv_urlFotoTecnico));
            else
                 Lv_urlFotoTecnico := '';
            end if;
            
         END IF;
         
         
         begin
             select T.Valor 
               into Lv_Codigo_Trabajo
               from DB_SOPORTE.Info_Tarea_Caracteristica t 
              where T.Detalle_Id = Pn_IdDetalle 
                and T.Caracteristica_Id = (select S.Id_Caracteristica 
                                             from DB_COMERCIAL.admi_caracteristica s 
                                            where S.Descripcion_Caracteristica='CODIGO_TRABAJO')
                and T.Estado = 'Activo';
         exception
           when others then
            Lv_Codigo_Trabajo:= '';
         end;
         
         begin
             select S.SERIE_LOGICA 
               into Lv_Id_dispositivo
               from DB_INFRAESTRUCTURA.INFO_ELEMENTO s 
              where S.ID_ELEMENTO in (select max(S.ELEMENTO_ID) 
                                        from db_infraestructura.info_detalle_elemento s 
                                       where S.DETALLE_NOMBRE = 'RESPONSABLE_TABLET'
                                         and S.DETALLE_VALOR = Ln_Id_Per_Rol_jefe
                                     )  
                and S.ESTADO = 'Activo';
         exception
           when others then
             Lv_Id_dispositivo := '';
         end;
         
         Begin
          select to_char(icp.FE_INICIO,'dd-mm-yyyy') fecha,
                 to_char(icp.FE_INICIO,'hh24:mi:ss') hora
            into Lv_Fecha_Agen,Lv_Hora_Agen
            from DB_SOPORTE.INFO_CUADRILLA_PLANIF_DET icp, 
                 DB_COMUNICACION.INFO_COMUNICACION ico 
           where ico.ID_COMUNICACION = icp.COMUNICACION_ID
             and ico.DETALLE_ID = Pn_IdDetalle
             and ROWNUM = 1;
        Exception
          when others then
             Lv_Fecha_Agen := '';
             Lv_Hora_Agen := '';               
         End;

         DBMS_LOB.CREATETEMPORARY(Lc_Resultado, TRUE); 
         DBMS_LOB.APPEND(Lc_Resultado,'{"caso":"'||Lv_Numero_Caso||'","tarea":"'||Ln_Numero_Tarea||'","tituloInicial":"'||Lv_Titulo_Inicial||'","tituloFinal":"'||Lv_Titulo_Fin);
         DBMS_LOB.APPEND(Lc_Resultado,'","login":"'||Lv_Login_Cliente||'","latitud":"'||Lv_Latitud||'","longitud":"'||Lv_Longitud||'","direccion":"'||Lv_Direccion); 
         DBMS_LOB.APPEND(Lc_Resultado,'","identificacion":"'||Lv_Identificacion||'","empresa":"'||Lv_Prefijo_Empresa||'","nombreTecnico":"'||Lv_Nombre_Tecnico);
         DBMS_LOB.APPEND(Lc_Resultado,'","liderCuadrilla":"'||Lv_Nombre_Jefe||'","dispositivoId":"'||Lv_Id_dispositivo);
         DBMS_LOB.APPEND(Lc_Resultado,'","cedulaTecnico":"'||Lv_Identificacion_Tec||'","codigoTrabajo":"'||Lv_Codigo_Trabajo);
         DBMS_LOB.APPEND(Lc_Resultado,'","urlFotoTecnico":"'||Lv_urlFotoTecnico);
         DBMS_LOB.APPEND(Lc_Resultado,'","numeroCelular":"'||Lv_NumeroContacto);
         DBMS_LOB.APPEND(Lc_Resultado,'","fechaAgendamiento":"'||Lv_Fecha_Agen||'","horarioAgendamiento":"'||Lv_Hora_Agen||'"}');     
     
         Pc_ResultClob := Lc_Resultado;
         Pn_Error := 0;

  EXCEPTION 
    WHEN Le_Exception THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_OBTIENE_DATOS_TRACKING', 
                                                Lv_Error || ' - ' || SQLCODE ,NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                                SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
         Pn_Error := 1;
         
    WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_OBTIENE_DATOS_TRACKING', 
                                                'Error general 123: ' || SQLERRM || ' - ' || SQLCODE ,NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                                SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );                                               
         Pn_Error := 1;
  END P_OBTIENE_DATOS_TRACKING;
    
  PROCEDURE P_INSERTA_ERROR_TRACKING(Pv_Datos          IN VARCHAR2, 
                                       Pv_Direccion      IN VARCHAR2,
                                       Pv_Observacion    IN VARCHAR2,
                                       Pv_LiderCuadrilla IN VARCHAR2,
                                       Pv_NombreTecnico  IN VARCHAR2,
                                       Pv_cedulaTecnico  IN VARCHAR2,
                                       Pv_codigoTrabajo  IN VARCHAR2,
                                       Pn_Error          OUT NUMBER) AS
       Ln_IdDetalle      NUMBER;
       Lv_NumeroCaso     VARCHAR2(50);
       Ln_NumeroTarea    NUMBER;
       Lv_TipoEvento     VARCHAR2(50);
       Lv_Identificacion VARCHAR2(20);
       Lv_TituloInicial  VARCHAR2(100);
       Lv_TituloFinal    VARCHAR2(100); 
       Lv_Login          VARCHAR2(60);
       Lf_Latitud        FLOAT(126);
       Lf_Longitud       FLOAT(126);
       Lf_LatitudTec     FLOAT(126);
       Lf_LongitudTec    FLOAT(126);
       Lv_FechaAgenda    VARCHAR2(10);
       Lv_HoraAgenda     VARCHAR2(10);
       Lv_FechaEvento    VARCHAR2(20);
       Ln_Distancia      NUMBER;
       Lv_Empresa        VARCHAR2(2);
       Lv_Opcion         VARCHAR2(50);
       Lv_UsrCreacion    VARCHAR2(50);
       Lv_IpCreacion     VARCHAR2(20);
       Lv_Datos          VARCHAR2(4000);
       Lv_DispositivoId  VARCHAR2(225);

  BEGIN
      
      Lv_Datos := Pv_Datos;
      Ln_IdDetalle   := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_NumeroCaso  := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Ln_NumeroTarea := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_TipoEvento  := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_Identificacion := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_TituloInicial := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_TituloFinal := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));     
      Lv_Login       := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lf_Latitud     := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lf_Longitud    := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_FechaEvento := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Ln_Distancia   := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_Empresa     := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_Opcion      := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_UsrCreacion := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_IpCreacion  := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lf_LatitudTec  := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lf_LongitudTec := to_Number(SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1)));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_FechaAgenda := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_HoraAgenda  := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      Lv_Datos       := SUBSTR(Lv_Datos, (INSTR(Lv_Datos,'|')+1), LENGTH(Lv_Datos));
      Lv_DispositivoId := SUBSTR(Lv_Datos,0,(INSTR(Lv_Datos,'|')-1));
      
        INSERT INTO DB_Soporte.INFO_TRACKING_MAP_HIST(ID_TRACKING,
                    DETALLE_ID,
                    NUMERO_CASO,
                    NUMERO_TAREA,
                    TIPO_EVENTO,
                    IDENTIFICACION,
                    TITULO_INICIAL,
                    TITULO_FINAL,
                    LOGIN,
                    DIRECCION,
                    LATITUD,
                    LONGITUD,
                    FECHA_EVENTO,
                    LIDER_CUADRILLA,
                    NOMBRE_TECNICO,
                    DISTANCIA,
                    EMPRESA,
                    OPCION,
                    FE_CREACION,
                    ESTADO,
                    OBSERVACION,
                    USR_CREACION,
                    IP_CREACION,
                    LATITUD_TECNICO,
                    LONGITUD_TECNICO,
                    FE_AGENDAMIENTO,
                    HORA_AGENDAMIENTO,
                    DISPOSITIVO_ID,
                    CODIGO_TRABAJO,
                    CEDULA_TECNICO)
        VALUES(DB_Soporte.SEQ_INFO_TRACKING_MAP_HIST.NEXTVAL,
               Ln_IdDetalle,
               Lv_NumeroCaso,
               Ln_NumeroTarea,
               Lv_TipoEvento,
               Lv_Identificacion,
               Lv_TituloInicial,
               Lv_TituloFinal,
               Lv_Login,
               Pv_Direccion,
               Lf_Latitud,
               Lf_Longitud,
               to_date(Lv_FechaEvento,'yyyy-mm-dd HH24:MI:SS'),
               Pv_LiderCuadrilla,
               Pv_NombreTecnico,
               Ln_Distancia,
               Lv_Empresa,
               Lv_Opcion,
               SYSDATE,
               'Error',
               Pv_Observacion,
               Lv_UsrCreacion,
               Lv_IpCreacion,
               Lf_LatitudTec,
               Lf_LongitudTec,
               Lv_FechaAgenda,
               Lv_HoraAgenda,
               Lv_DispositivoId,
               Pv_codigoTrabajo,
               Pv_Cedulatecnico);             
        
        COMMIT; 
 
      Pn_Error := 0;
  EXCEPTION
     WHEN OTHERS THEN 
       rollback;
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_INSERTA_ERROR_TRACKING', 
                                             'Error en creacion de registro: ' || SQLERRM || ' - ' || SQLCODE ,NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                             SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

       Pn_Error := 1;
  END P_INSERTA_ERROR_TRACKING;
    
  PROCEDURE P_OBTIENE_ERROR_TRACKING(Pn_IdDetalle   IN NUMBER,
                                      Pv_Estado      IN VARCHAR2,
                                      Pc_ResultClob  OUT CLOB, 
                                      Pn_NumeroReg   OUT NUMBER,                                   
                                      Pn_Error       OUT NUMBER) as
     
     CURSOR C_GetObtenerErrorTRACKING IS
        Select MT.DETALLE_ID,MT.NUMERO_CASO,MT.NUMERO_TAREA,MT.TIPO_EVENTO,MT.IDENTIFICACION, 
               MT.LOGIN, MT.DIRECCION,MT.LATITUD,MT.LONGITUD,MT.FECHA_EVENTO,
               MT.LIDER_CUADRILLA,MT.NOMBRE_TECNICO,MT.DISTANCIA,MT.TITULO_INICIAL, MT.TITULO_FINAL,
               MT.LATITUD_TECNICO,MT.LONGITUD_TECNICO,MT.FE_AGENDAMIENTO,mt.HORA_AGENDAMIENTO,mt.DISPOSITIVO_ID,
               Mt.Codigo_Trabajo,Mt.Cedula_Tecnico
          From DB_Soporte.INFO_TRACKING_MAP_HIST mt
         where MT.DETALLE_ID = Pn_IdDetalle
           and MT.ESTADO = Pv_Estado
         order by MT.ID_TRACKING;
         
      Lc_Resultado  CLOB;
      Ln_Registros  NUMBER:=0;
  BEGIN 
        DBMS_LOB.CREATETEMPORARY(Lc_Resultado, TRUE);  
        FOR J IN C_GetObtenerErrorTRACKING LOOP
        
          DBMS_LOB.APPEND(Lc_Resultado,'{"accion":"'||J.TIPO_EVENTO||'","identificacion":"'||J.IDENTIFICACION||'","tituloInicial":"'||J.TITULO_INICIAL);
          DBMS_LOB.APPEND(Lc_Resultado,'","tituloFinal":"'||J.TITULO_FINAL ||'","login":"'||J.LOGIN||'","caso":"'||J.NUMERO_CASO);
          DBMS_LOB.APPEND(Lc_Resultado,'","tarea":"'||J.NUMERO_TAREA||'","direccion":"'||J.DIRECCION||'","fecha":"'||J.FECHA_EVENTO);
          DBMS_LOB.APPEND(Lc_Resultado,'","coordenadas":{"latitud":"'||J.LATITUD||'","longitud":"'||J.LONGITUD||'"}');
          DBMS_LOB.APPEND(Lc_Resultado,',"coordenadasTecnico":{"latitud":"'||J.LATITUD_TECNICO||'","longitud":"'||J.LONGITUD_TECNICO||'"}');
          DBMS_LOB.APPEND(Lc_Resultado,',"liderCuadrilla":"'||J.LIDER_CUADRILLA||'","nombreTecnico":"'||J.NOMBRE_TECNICO);
          DBMS_LOB.APPEND(Lc_Resultado,'","fechaAgendamiento":"'||J.FE_AGENDAMIENTO||'","horarioAgendamiento":"'||J.HORA_AGENDAMIENTO||'","datosTecnico":{"cedula":"');
          DBMS_LOB.APPEND(Lc_Resultado,J.Cedula_Tecnico||'","codigoTrabajo":"'||J.Codigo_Trabajo||'","foto":""}');
          DBMS_LOB.APPEND(Lc_Resultado,',"dispositivoId":"'||J.DISPOSITIVO_ID||'","distancia":"'||J.DISTANCIA||'"}|');
          
          Ln_Registros:= Ln_Registros+1;

        END LOOP;
        
        Pc_ResultClob := Lc_Resultado;
        Pn_NumeroReg := Ln_Registros;
                           
        Pn_Error := 0; 
      
  EXCEPTION 
     WHEN OTHERS THEN 
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_OBTIENE_ERROR_TRACKING', 
                                             'Error obteniendo registros: ' || SQLERRM || ' - ' || SQLCODE ,NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                             SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
       Pn_Error := 1;
       Pn_NumeroReg := 0;
  END P_OBTIENE_ERROR_TRACKING;
    
  PROCEDURE P_ACTUALIZA_ERROR_TRACKING(Pn_IdDetalle   IN NUMBER,
                                        Pv_Estado      IN VARCHAR2,                                    
                                        Pn_Error       OUT NUMBER)  AS
  BEGIN
    
      UPDATE DB_Soporte.INFO_TRACKING_MAP_HIST mt
         SET MT.ESTADO = Pv_Estado
       WHERE MT.DETALLE_ID = Pn_IdDetalle;
      
      COMMIT;
      
      Pn_Error := 0; 
      
      
  EXCEPTION
     WHEN OTHERS THEN
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_ACTUALIZA_ERROR_TRACKING', 
                                             'Error actualizando registros: ' || SQLERRM || ' - ' || SQLCODE ,NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                             SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      Pn_Error := 1;
  END P_ACTUALIZA_ERROR_TRACKING;

                                 
  PROCEDURE P_OBTENER_CASOS_NOT_MASIVA(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                               				 Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT CLOB) IS
 
       CURSOR C_GetInfoCasoMantProgramado(Cv_TipoProceso varchar2,Cv_Estado Varchar2) IS
		 SELECT pmc.ID_PROCESO_MASIVO_CAB,
		        pmc.TIPO_PROCESO, 
		        imp.TIPO_AFECTACION,
		        imp.TIPO_NOTIFICACION,
		        (select ichi.estado from  DB_SOPORTE.INFO_CASO_HISTORIAL ichi
                                where ichi.ID_CASO_HISTORIAL = (select max(ich.ID_CASO_HISTORIAL) 
                                    from  DB_SOPORTE.INFO_CASO_HISTORIAL ich 
                                    where ich.CASO_ID = ic.ID_CASO)) ESTADO_CASO,
		        ic.NUMERO_CASO,
		        imp.FECHA_INICIO,
		        imp.FECHA_FIN,
		        imp.TIEMPO_AFECTACION,
		        pmc.FE_CREACION,
		        pmc.FE_ULT_MOD,
		        pmc.ESTADO ESTADO_REGISTRO,
		        ic.ID_CASO
		   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB pmc,
		        DB_SOPORTE.INFO_CASO ic,
		        DB_SOPORTE.INFO_MANTENIMIENTO_PROGRAMADO imp,
		        DB_SOPORTE.INFO_DETALLE_HIPOTESIS idh
		  WHERE pmc.CASO_ID = ic.ID_CASO 
		    AND ic.ID_CASO = imp.CASO_ID 
		    AND idh.CASO_ID = ic.ID_CASO
		    AND pmc.TIPO_PROCESO = Cv_TipoProceso
		    AND pmc.ESTADO = Cv_Estado;

	   CURSOR C_GetInfoCaso(Cv_TipoProceso varchar2,Cv_Estado Varchar2) IS
		 SELECT pmc.ID_PROCESO_MASIVO_CAB,
		        pmc.TIPO_PROCESO, 
		        (select ichi.estado from  DB_SOPORTE.INFO_CASO_HISTORIAL ichi
                                where ichi.ID_CASO_HISTORIAL = (select max(ich.ID_CASO_HISTORIAL) 
                                    from  DB_SOPORTE.INFO_CASO_HISTORIAL ich 
                                    where ich.CASO_ID = ic.ID_CASO)) ESTADO_CASO,
		        ic.NUMERO_CASO,
		        pmc.FE_CREACION,
		        pmc.FE_ULT_MOD,
		        pmc.ESTADO ESTADO_REGISTRO,
		        ic.ID_CASO
		   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB pmc,
		        DB_SOPORTE.INFO_CASO ic
		  WHERE pmc.CASO_ID = ic.ID_CASO 		   
		    AND pmc.TIPO_PROCESO = Cv_TipoProceso
		    AND pmc.ESTADO = Cv_Estado;
       
    Lv_Estado_Registro  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE;
    Lv_Tipo_Proceso     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE;
    Lcl_Response        CLOB;
 
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado_Registro := APEX_JSON.get_varchar2('estadoRegistro');
    Lv_Tipo_Proceso    := APEX_JSON.get_varchar2('tipoProceso');
       
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    
    APEX_JSON.OPEN_ARRAY();

   IF Lv_Tipo_Proceso = 'CierreCasoMantProgra' THEN
   
    FOR i in C_GetInfoCasoMantProgramado(Lv_Tipo_Proceso, Lv_Estado_Registro) LOOP
         APEX_JSON.OPEN_OBJECT;
         APEX_JSON.WRITE('idProcesoCab',     i.ID_PROCESO_MASIVO_CAB);
         APEX_JSON.WRITE('idCaso',           i.ID_CASO);
         APEX_JSON.WRITE('tipoProceso',      i.TIPO_PROCESO);
    	   APEX_JSON.WRITE('tipoAfectacion',   i.TIPO_AFECTACION);
         APEX_JSON.WRITE('tipoNotificacion', i.TIPO_NOTIFICACION);
         APEX_JSON.WRITE('estadoCaso',       i.ESTADO_CASO);
         APEX_JSON.WRITE('numeroCaso',       i.NUMERO_CASO);
         APEX_JSON.WRITE('fechaInicio',      to_char(i.FECHA_INICIO,'dd-mm-yyyy'));
         APEX_JSON.WRITE('fechaFin',         to_char(i.FECHA_FIN,'dd-mm-yyyy'));
         APEX_JSON.WRITE('horaInicio',       to_char(i.FECHA_INICIO,'hh24:mi:ss'));
         APEX_JSON.WRITE('horaFin',          to_char(i.FECHA_FIN,'hh24:mi:ss'));
         APEX_JSON.WRITE('tiempoAfectacion', i.TIEMPO_AFECTACION);
         APEX_JSON.WRITE('feCreacionProceso',to_char(i.FE_CREACION,'dd-mm-yyyy hh24:mi:ss'));
         APEX_JSON.WRITE('feUltModProceso',  to_char(i.FE_ULT_MOD,'dd-mm-yyyy hh24:mi:ss'));
         APEX_JSON.WRITE('estadoProceso',    i.ESTADO_REGISTRO);
         APEX_JSON.CLOSE_OBJECT;
     END LOOP;   
   ELSE
    FOR i in C_GetInfoCaso(Lv_Tipo_Proceso, Lv_Estado_Registro) LOOP
         APEX_JSON.OPEN_OBJECT;
         APEX_JSON.WRITE('idProcesoCab',     i.ID_PROCESO_MASIVO_CAB);
         APEX_JSON.WRITE('idCaso',           i.ID_CASO);
         APEX_JSON.WRITE('tipoProceso',      i.TIPO_PROCESO);
         APEX_JSON.WRITE('estadoCaso',       i.ESTADO_CASO);
         APEX_JSON.WRITE('numeroCaso',       i.NUMERO_CASO);
         APEX_JSON.WRITE('feCreacionProceso',to_char(i.FE_CREACION,'dd-mm-yyyy hh24:mi:ss'));
         APEX_JSON.WRITE('feUltModProceso',  to_char(i.FE_ULT_MOD,'dd-mm-yyyy hh24:mi:ss'));
         APEX_JSON.WRITE('estadoProceso',    i.ESTADO_REGISTRO);
         APEX_JSON.CLOSE_OBJECT;
     END LOOP; 
    END IF;
     APEX_JSON.CLOSE_ARRAY;
     Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
     APEX_JSON.FREE_OUTPUT;

     Pv_Status := 'OK';
     Pv_Mensaje := 'Consulta exitosa';
     Pcl_Response := Lcl_Response;
  EXCEPTION
     WHEN OTHERS THEN
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_OBTENER_CASOS_NOT_MASIVA', 
                                             'Error obteniendo datos del caso: ' || SQLERRM || ' - ' || SQLCODE ,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                             SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
 
       Pv_Status := 'Error';
       Pv_Mensaje := 'Error obteniendo datos del caso: ' || SQLERRM || ' - ' || SQLCODE;
  END P_OBTENER_CASOS_NOT_MASIVA; 
 
  PROCEDURE P_OBTENER_AVANCE_NOT_MASIVA(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                           			        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT CLOB) IS
                                        
    CURSOR C_GetInfoCaso(Cv_TipoProceso number) IS
	   SELECT pmc.ID_PROCESO_MASIVO_CAB,
	        pmc.TIPO_PROCESO, 
	        ic.NUMERO_CASO,
	        pmc.FE_CREACION,
	        pmc.FE_ULT_MOD,
	        pmc.ESTADO ESTADO_REGISTRO,
	        ic.ID_CASO        
	   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB pmc,
	        DB_SOPORTE.INFO_CASO ic
	  WHERE pmc.CASO_ID = ic.ID_CASO 
	    AND pmc.ESTADO = 'Finalizado'
	    AND 'Asignado' = (select ichi.estado from DB_SOPORTE.INFO_CASO_HISTORIAL ichi
	            where ichi.ID_CASO_HISTORIAL = (select max(ich.ID_CASO_HISTORIAL) 
	                from  DB_SOPORTE.INFO_CASO_HISTORIAL ich 
	                where ich.CASO_ID = ic.ID_CASO))
	    AND pmc.FE_ULT_MOD IS NOT NULL
	    AND to_number(extract(day from 24 * 60 * (sysdate-pmc.FE_ULT_MOD))) >Cv_TipoProceso;
	   
	   Lcl_Response    CLOB;
	   Ln_tiempoEspera NUMBER:=0;
    BEGIN
	    APEX_JSON.PARSE(Pcl_Request);
	    Ln_tiempoEspera := APEX_JSON.get_Number('tiempoEsperaAvance');	       
	    APEX_JSON.INITIALIZE_CLOB_OUTPUT;	    
	    APEX_JSON.OPEN_ARRAY();
	
	    FOR i in C_GetInfoCaso(Ln_tiempoEspera) LOOP
		         APEX_JSON.OPEN_OBJECT;
		         APEX_JSON.WRITE('idProcesoCab',     i.ID_PROCESO_MASIVO_CAB);
		         APEX_JSON.WRITE('idCaso',           i.ID_CASO);
		         APEX_JSON.WRITE('tipoProceso',      i.TIPO_PROCESO);
		         APEX_JSON.WRITE('numeroCaso',       i.NUMERO_CASO);
		         APEX_JSON.WRITE('feCreacionProceso',to_char(i.FE_CREACION,'dd-mm-yyyy hh24:mi:ss'));
		         APEX_JSON.WRITE('feUltModProceso',  to_char(i.FE_ULT_MOD,'dd-mm-yyyy hh24:mi:ss'));
		         APEX_JSON.WRITE('estadoProceso',    i.ESTADO_REGISTRO);
		         APEX_JSON.CLOSE_OBJECT;
		 END LOOP;  
		
		 APEX_JSON.CLOSE_ARRAY;
     	 Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
     	 APEX_JSON.FREE_OUTPUT;

	     Pv_Status    := 'OK';
	     Pv_Mensaje   := 'Consulta exitosa';
	     Pcl_Response := Lcl_Response;
		
  EXCEPTION
     WHEN OTHERS THEN
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'SPKG_SOPORTE.P_OBTENER_AVANCE_NOT_MASIVA', 
                                             'Error obteniendo datos del caso: ' || SQLERRM || ' - ' || SQLCODE ,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'), 
                                             SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
 
       Pv_Status := 'Error';
       Pv_Mensaje := 'Error obteniendo datos del caso: ' || SQLERRM || ' - ' || SQLCODE;
  END P_OBTENER_AVANCE_NOT_MASIVA; 	

END SPKG_SOPORTE;
/