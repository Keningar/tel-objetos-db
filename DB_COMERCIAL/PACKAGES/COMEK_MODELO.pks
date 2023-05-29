CREATE OR REPLACE PACKAGE DB_COMERCIAL.COMEK_MODELO AS 

    
    PROCEDURE COMP_INSERTA_PUNTO_HISTORIAL(
        Pr_puntoHistorial IN INFO_PUNTO_HISTORIAL%ROWTYPE,
        Lv_CodError OUT VARCHAR2,
        Lv_MensaError OUT VARCHAR2);


  /**
  * COMPP_INSERT_DETALLE_SOLICITUD
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_SOLICITUD
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 03/10/2014
  * @param string Pr_detalleSolicitud
  *
  * @return string Lv_MensaError
  */       

    PROCEDURE COMPP_INSERT_DETALLE_SOLICITUD(
        Pr_detalleSolicitud IN INFO_DETALLE_SOLICITUD%ROWTYPE,        
        Lv_MensaError OUT VARCHAR2);        
   /**
  * COMEP_INSERT_SERVICIO_HISTORIAL
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_SOLICITUD
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 10/10/2014
  * @param string Pr_detalleSolicitud
  *
  * @return string Pr_servicioHistorial
  */       

    PROCEDURE COMEP_INSERT_SERVICIO_HISTORIA(
        Pr_servicioHistorial IN INFO_SERVICIO_HISTORIAL%ROWTYPE,        
        Lv_MensaError OUT VARCHAR2);  

 /**
  * COMEP_INSERT_DETALLE_SOL_CARAC
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_SOL_CARACT
  *
  * @author John Vera            <javera@telconet.ec>
  * @version 1.0 19/03/2015
  * @param string Pr_detaleSol
  *
  * 
  */       

    PROCEDURE COMEP_INSERT_DETALLE_SOL_CARAC( 
        Pr_detaleSol IN INFO_DETALLE_SOL_CARACT%ROWTYPE,        
        Lv_MensaError OUT VARCHAR2);                

/*
 * Procedimiento que sirbe para insertar el seguimiento de los servicios
 *
 * @author David León <mdleon@telconet.ec>
 * @version 1.0 09-03-2020
 * @param  INFO_SEGUIMIENTO_SERVICIO%ROWTYPE   Pr_seguimientoServicio   Registro a ingresar
 * @return VARCHAR2   Lv_MensaError   Mensaje de Error
 */
  PROCEDURE COMP_INSERTA_SEGUIMIENTO_SERV(
        Pr_seguimientoServicio IN INFO_SEGUIMIENTO_SERVICIO%ROWTYPE,
        Lv_estadoAnterior IN VARCHAR2,
        Lv_fechaAnterior INFO_SERVICIO_HISTORIAL.FE_CREACION%type,
        Lv_CodError OUT VARCHAR2,
        Lv_MensaError OUT VARCHAR2);

  /**
   * P_INSERT_INFO_DETALLE_SOL_HIST
   * Procedimiento que obtiene el detalle del Wifi y Extender dual band de un plan
   *
   * @param  Pr_InfoDetalleSolHist  IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE
   * @param  Pv_MsjError            OUT VARCHAR2 Mensaje de error del procedimiento
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 15-06-2020
   *
   */
    PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(
      Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,        
      Pv_MsjError             OUT VARCHAR2);

END COMEK_MODELO;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.COMEK_MODELO AS
  
  --PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_PUNTO_HISTORIAL
  --JOHN VERA
  --03/10/2014
  PROCEDURE COMP_INSERTA_PUNTO_HISTORIAL(
        Pr_puntoHistorial IN INFO_PUNTO_HISTORIAL%ROWTYPE,
        Lv_CodError OUT VARCHAR2,
        Lv_MensaError OUT VARCHAR2) AS

  BEGIN

    INSERT
    INTO INFO_PUNTO_HISTORIAL
      (
        ID_PUNTO_HISTORIAL,
        PUNTO_ID,
        ACCION,
        VALOR,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        SEQ_INFO_PUNTO_HISTORIAL.NEXTVAL,
        Pr_puntoHistorial.PUNTO_ID,
        Pr_puntoHistorial.ACCION,
        Pr_puntoHistorial.VALOR,
        Pr_puntoHistorial.USR_CREACION,
        SYSDATE,
        Pr_puntoHistorial.IP_CREACION
      );


  EXCEPTION
    WHEN OTHERS THEN
      Lv_CodError   := SQLCODE;   
      Lv_MensaError := SQLERRM;

  END COMP_INSERTA_PUNTO_HISTORIAL;


/*
 * Funcion que sirve para Ingresar detalle solicitud e Historial
 *
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 16-11-2015
 * @param  INFO_DETALLE_SOLICITUD%ROWTYPE   Pr_detalleSolicitud   Registro a ingresar
 * @return VARCHAR2   Lv_MensaError   Mensaje de Error
 */
PROCEDURE COMPP_INSERT_DETALLE_SOLICITUD(
    Pr_detalleSolicitud IN INFO_DETALLE_SOLICITUD%ROWTYPE,
    Lv_MensaError OUT VARCHAR2) AS

Ln_idDetalleSolicitud  number;

BEGIN
  --Se agrega validación de ingreso de ID
  IF Pr_detalleSolicitud.ID_DETALLE_SOLICITUD is null THEN
    Ln_idDetalleSolicitud := SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;
  ELSE
    Ln_idDetalleSolicitud := Pr_detalleSolicitud.ID_DETALLE_SOLICITUD;
  END IF;

  INSERT
  INTO "DB_COMERCIAL"."INFO_DETALLE_SOLICITUD"
    (
      ID_DETALLE_SOLICITUD,
      SERVICIO_ID,
      TIPO_SOLICITUD_ID,
      MOTIVO_ID,
      USR_CREACION,
      FE_CREACION,
      PRECIO_DESCUENTO,
      PORCENTAJE_DESCUENTO,
      TIPO_DOCUMENTO,
      OBSERVACION,
      ESTADO,
      USR_RECHAZO,
      FE_RECHAZO,
      DETALLE_PROCESO_ID,
      FE_EJECUCION,
      ELEMENTO_ID
    )
    VALUES
    (
      Ln_idDetalleSolicitud,
      Pr_detalleSolicitud.SERVICIO_ID,
      Pr_detalleSolicitud.TIPO_SOLICITUD_ID,
      Pr_detalleSolicitud.MOTIVO_ID,
      Pr_detalleSolicitud.USR_CREACION,
      SYSDATE,
      Pr_detalleSolicitud.PRECIO_DESCUENTO,
      Pr_detalleSolicitud.PORCENTAJE_DESCUENTO,
      Pr_detalleSolicitud.TIPO_DOCUMENTO,
      Pr_detalleSolicitud.OBSERVACION,
      Pr_detalleSolicitud.ESTADO,
      Pr_detalleSolicitud.USR_RECHAZO,
      Pr_detalleSolicitud.FE_RECHAZO,
      Pr_detalleSolicitud.DETALLE_PROCESO_ID,
      Pr_detalleSolicitud.FE_EJECUCION,
      Pr_detalleSolicitud.ELEMENTO_ID
    );
    --inserto el historial
  INSERT
  INTO "DB_COMERCIAL"."INFO_DETALLE_SOL_HIST"
    (
      ID_SOLICITUD_HISTORIAL,
      DETALLE_SOLICITUD_ID,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION,
      MOTIVO_ID
    )
    VALUES
    (
      SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
      SEQ_INFO_DETALLE_SOLICITUD.CURRVAL,
      Pr_detalleSolicitud.ESTADO,
      Pr_detalleSolicitud.OBSERVACION,
      Pr_detalleSolicitud.USR_CREACION,
      SYSDATE,
      Pr_detalleSolicitud.MOTIVO_ID     
    );
    --
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'COMK_MODELO.COMPP_INSERT_DETALLE_SOLICITUD '||SQLERRM;
END COMPP_INSERT_DETALLE_SOLICITUD;

--
--
--
PROCEDURE COMEP_INSERT_SERVICIO_HISTORIA(
    Pr_servicioHistorial IN INFO_SERVICIO_HISTORIAL%ROWTYPE,
    Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_SERVICIO_HISTORIAL
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
      SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
      Pr_servicioHistorial.SERVICIO_ID,
      Pr_servicioHistorial.USR_CREACION,
      SYSDATE,
      Pr_servicioHistorial.IP_CREACION,
      Pr_servicioHistorial.ESTADO,
      Pr_servicioHistorial.MOTIVO_ID,
      Pr_servicioHistorial.OBSERVACION,
      Pr_servicioHistorial.ACCION
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'COMK_MODELO.COMEP_INSERT_SERVICIO_HISTORIA '||SQLERRM;
END COMEP_INSERT_SERVICIO_HISTORIA;   
--
--
--
PROCEDURE COMEP_INSERT_DETALLE_SOL_CARAC( 
        Pr_detaleSol IN INFO_DETALLE_SOL_CARACT%ROWTYPE,        
        Lv_MensaError OUT VARCHAR2)
AS
BEGIN
  INSERT
  INTO INFO_DETALLE_SOL_CARACT
    (
      ID_SOLICITUD_CARACTERISTICA,
      CARACTERISTICA_ID,
      VALOR,
      DETALLE_SOLICITUD_ID,
      ESTADO,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
      Pr_detaleSol.CARACTERISTICA_ID,
      Pr_detaleSol.VALOR,
      Pr_detaleSol.DETALLE_SOLICITUD_ID,
      Pr_detaleSol.ESTADO,
      Pr_detaleSol.USR_CREACION,
      SYSDATE
    );
EXCEPTION
WHEN OTHERS THEN
  Lv_MensaError := 'COMK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC '||SQLERRM;
END COMEP_INSERT_DETALLE_SOL_CARAC;    

/*
 * Procedimiento que sirbe para insertar el seguimiento de los servicios
 *
 * @author David León <mdleon@telconet.ec>
 * @version 1.0 09-03-2020
 * @param  INFO_SEGUIMIENTO_SERVICIO%ROWTYPE   Pr_seguimientoServicio   Registro a ingresar
 * @return VARCHAR2   Lv_MensaError   Mensaje de Error
 */
  PROCEDURE COMP_INSERTA_SEGUIMIENTO_SERV(
        Pr_seguimientoServicio IN INFO_SEGUIMIENTO_SERVICIO%ROWTYPE,
        Lv_estadoAnterior IN VARCHAR2,
        Lv_fechaAnterior INFO_SERVICIO_HISTORIAL.FE_CREACION%type,
        Lv_CodError OUT VARCHAR2,
        Lv_MensaError OUT VARCHAR2) AS

  CURSOR C_DatoHisto(Cv_idServicio INFO_SERVICIO_HISTORIAL.SERVICIO_ID%type,
														Cv_estado INFO_SERVICIO_HISTORIAL.ESTADO%type) IS
    SELECT OBSERVACION,FE_CREACION
    FROM INFO_SERVICIO_HISTORIAL
    WHERE SERVICIO_ID = Cv_idServicio
      AND ESTADO = Cv_estado
      AND ID_SERVICIO_HISTORIAL = (SELECT MAX(ID_SERVICIO_HISTORIAL) FROM INFO_SERVICIO_HISTORIAL
                                    WHERE SERVICIO_ID = Cv_idServicio AND ESTADO = Cv_estado);


    CURSOR C_Fechas(cv_fechaIni INFO_SERVICIO_HISTORIAL.FE_CREACION%type, 
                  cv_fechaFin INFO_SERVICIO_HISTORIAL.FE_CREACION%type)IS
    SELECT 
     CAST((CAST( cv_fechaFin AS DATE) -
     CAST( cv_fechaIni       AS DATE))*24*60 AS INTEGER) AS TIEMPOMINUTOS
    FROM DUAL;

  Lv_observacionOld     INFO_SERVICIO_HISTORIAL.OBSERVACION%type;  
  Lv_fechaNueva	        INFO_SERVICIO_HISTORIAL.FE_CREACION%type := NULL;  
  Lv_tiempoEstimado VARCHAR2(4000)  := NULL;
  Lv_tiempoTarea 	  INT;
  Lv_fecha_Actual  INFO_SERVICIO_HISTORIAL.FE_CREACION%type := sysdate;
  BEGIN
    IF (Lv_estadoAnterior IS NOT NULL) THEN 

    OPEN C_Fechas(Lv_fechaAnterior, Pr_seguimientoServicio.FE_CREACION);
    FETCH C_Fechas INTO Lv_tiempoTarea;
    CLOSE C_Fechas;

      UPDATE INFO_SEGUIMIENTO_SERVICIO
      SET --OBSERVACION=Lv_observacionOld,
      FE_MODIFICACION=Pr_seguimientoServicio.FE_CREACION,
      TIEMPO_TRANSCURRIDO=Lv_tiempoTarea,
      DIAS_TRANSCURRIDO=Lv_tiempoTarea/60/24
      WHERE SERVICIO_ID=Pr_seguimientoServicio.SERVICIO_ID
      AND ESTADO=Lv_estadoAnterior;
    END IF;

    INSERT
    INTO INFO_SEGUIMIENTO_SERVICIO
      (
        ID_SEGUIMIENTO_SERVICIO,
        SERVICIO_ID,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        --FE_MODIFICACION,
        IP_CREACION,
        DEPARTAMENTO,
        TIEMPO_ESTIMADO,
        OBSERVACION
      )
	VALUES (SEQ_INFO_SEGUIMIENTO_SERVICIO.NEXTVAL,
          Pr_seguimientoServicio.SERVICIO_ID,
          Pr_seguimientoServicio.ESTADO,
          Pr_seguimientoServicio.USR_CREACION,
          Pr_seguimientoServicio.FE_CREACION,
          --Pr_seguimientoServicio.FE_MODIFICACION,
          Pr_seguimientoServicio.IP_CREACION,
          Pr_seguimientoServicio.DEPARTAMENTO,
          Pr_seguimientoServicio.TIEMPO_ESTIMADO,
          Pr_seguimientoServicio.OBSERVACION
          );

IF (Pr_seguimientoServicio.ESTADO ='Activo') THEN
UPDATE INFO_SEGUIMIENTO_SERVICIO
      SET
      FE_MODIFICACION=Pr_seguimientoServicio.FE_CREACION,
      TIEMPO_TRANSCURRIDO=0,
      DIAS_TRANSCURRIDO=0
      WHERE SERVICIO_ID=Pr_seguimientoServicio.SERVICIO_ID
      AND ESTADO=Pr_seguimientoServicio.ESTADO;
END IF;

  EXCEPTION
    WHEN OTHERS THEN
      Lv_CodError   := SQLCODE;   
      Lv_MensaError := SQLERRM;

  END COMP_INSERTA_SEGUIMIENTO_SERV;

  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(
    Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,        
    Pv_MsjError             OUT VARCHAR2)
  AS
  BEGIN
    INSERT
    INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
      (
        ID_SOLICITUD_HISTORIAL,
        DETALLE_SOLICITUD_ID,
        ESTADO,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        Pr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL,
        Pr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID,
        Pr_InfoDetalleSolHist.ESTADO,
        Pr_InfoDetalleSolHist.OBSERVACION,
        Pr_InfoDetalleSolHist.USR_CREACION,
        SYSDATE,
        Pr_InfoDetalleSolHist.IP_CREACION
      );
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjError := 'COMK_MODELO.P_INSERT_INFO_DETALLE_SOL_HIST '||SQLERRM;
  END P_INSERT_INFO_DETALLE_SOL_HIST;  

END COMEK_MODELO;
/