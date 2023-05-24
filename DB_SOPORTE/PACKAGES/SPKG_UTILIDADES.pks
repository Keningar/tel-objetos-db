CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_UTILIDADES AS

 /**
  * Documentaci�n para FUNCTION 'F_GET_CLOB_TO_VARCHAR'
  * Funcion que permite convertir un clob a un varchar2
  *
  * PARAMETROS:
  * @Param ROWID       prw_infoTareaSeguimiento   rowid de la info_tarea_seguimiento
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 23-10-2017
  */
 FUNCTION F_GET_CLOB_TO_VARCHAR(Prw_InfoTareaSeguimiento IN ROWID)  RETURN VARCHAR2;


 /**
  * Actualizaci�n: Se realiza validaci�n de permitir eliminar registro solo si el par�metro
  *                recibido con el id del caso es diferente a null
  * @author Andr�s Montero <amontero@telconet.ec>
  * @version 1.1 04-01-2021
  *
  * Documentaci�n para funci�n 'F_ELIMINAR_REGISTROS_TEMPORAL'
  * Funci�n que permite eliminar registros temporales que sirven para el envi� de notificaciones a afectados backbone
  *
  * PARAMETROS:
  * @Param NUMBER       Pn_idCaso   id del caso
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 17-10-2018
  */
 FUNCTION F_ELIMINAR_REGISTROS_TEMPORAL(Pn_idCaso IN NUMBER)  RETURN VARCHAR2;

 /**
  * Documentaci�n para funci�n 'GET_VARCHAR_CLEAN'
  * Funci�n que permite eliminar caracteres especiales de una cadena
  *
  * PARAMETROS:
  * @Param VARCHAR2  Fv_Cadena Cadena para limpiar caracteres especiales
  * @author Andr�s Montero <amontero@telconet.ec>
  * @version 1.0 28-12-2018
  */
FUNCTION GET_VARCHAR_CLEAN(
        Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;

/**
  * Documentaci�n para funci�n 'P_INSERT_TAREA_SEGUIMIENTO'
  * Funci�n insertar un historial en la INFO_TAREA_SEGUIMIENTO
  *
  * PARAMETROS:
  * @Param Pr_infoTareaSeguimiento INFO_TAREA_SEGUIMIENTO%ROWTYPE
  * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
  * @version 1.0 03-10-2019
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 30-09-2021 Se agregan al INSERT todos los campos de la tabla DB_SOPORTE.INFO_TAREA_SEGUIMIENTO
  */
PROCEDURE P_INSERT_TAREA_SEGUIMIENTO(Pr_infoTareaSeguimiento IN INFO_TAREA_SEGUIMIENTO%ROWTYPE,
                                      Lv_MensaError OUT VARCHAR2);
           
 /**
  * Documentaci�n para funci�n 'P_INSERT_DETALLE_HISTORIAL'
  * Funci�n insertar un historial en la INFO_DETALLE_HISTORIAL
  *
  * PARAMETROS:
  * @Param Pr_infoDetalleHistorial INFO_DETALLE_HISTORIAL%ROWTYPE
  * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
  * @version 1.0 03-10-2019
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 30-09-2021 Se agregan al INSERT todos los campos de la tabla DB_SOPORTE.INFO_DETALLE_HISTORIAL
  */                           
PROCEDURE P_INSERT_DETALLE_HISTORIAL(Pr_infoDetalleHistorial IN INFO_DETALLE_HISTORIAL%ROWTYPE,
                                      Lv_MensaError OUT VARCHAR2);

 /**
  * Documentaci�n para procedimiento 'P_INSERT_DETALLE'
  * Procedimiento para insertar un registro en la DB_SOPORTE.INFO_DETALLE
  *
  * @param  Pr_InfoDetalle IN DB_SOPORTE.INFO_DETALLE%ROWTYPE Registro con la informaci�n a crear
  * @param  Pv_MsjError    OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_DETALLE(Pr_InfoDetalle IN DB_SOPORTE.INFO_DETALLE%ROWTYPE,
                             Pv_MsjError    OUT VARCHAR2);

 /**
  * Documentaci�n para procedimiento 'P_INSERT_DETALLE_ASIGNACION'
  * Procedimiento para insertar un registro en la DB_SOPORTE.INFO_DETALLE_ASIGNACION
  *
  * @param  Pr_InfoDetalleAsignacion    IN DB_SOPORTE.INFO_DETALLE_ASIGNACION%ROWTYPE Registro con la informaci�n a crear
  * @param  Pv_MsjError                 OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_DETALLE_ASIGNACION(Pr_InfoDetalleAsignacion    IN DB_SOPORTE.INFO_DETALLE_ASIGNACION%ROWTYPE,
                                        Pv_MsjError                 OUT VARCHAR2);


 /**
  * Documentaci�n para procedimiento 'P_INSERT_INFO_TAREA'
  * Procedimiento para insertar un registro en la DB_SOPORTE.INFO_TAREA
  *
  * @param  Pr_InfoTarea    IN DB_SOPORTE.INFO_TAREA%ROWTYPE Registro con la informaci�n a crear
  * @param  Pv_MsjError     OUT VARCHAR2 Mensaje de error
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 30-09-2021
  */  
  PROCEDURE P_INSERT_INFO_TAREA(Pr_InfoTarea    IN DB_SOPORTE.INFO_TAREA%ROWTYPE,
                                Pv_MsjError     OUT VARCHAR2);
                               
 /*
  * Documentaci�n para FUNCI�N 'F_MATCH_VALOR_PARAMETER'.
  * Funci�n para buscar si existe valor parametrizado
  *
  * PARAMETROS:
  * @Param VARCHAR2  Pv_valor_param  ->  valor de parmetros
  * @Param VARCHAR2  Pv_valor_match  ->  valor a buscar
  * @Param VARCHAR2  Pv_delimiter  ->  delimitador
  * @author Fernando L�pez. <filopez@telconet.ec>
  * @version 1.0 30-03-2022
  */
  FUNCTION F_MATCH_VALOR_PARAMETER(Pv_valor_param VARCHAR2, Pv_valor_match VARCHAR2, Pv_delimiter VARCHAR2)
      RETURN VARCHAR2;

END SPKG_UTILIDADES;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_UTILIDADES
AS
FUNCTION F_GET_CLOB_TO_VARCHAR(
    Prw_InfoTareaSeguimiento IN ROWID)
  RETURN VARCHAR2
IS
  --
  Lv_Observacion VARCHAR2(4000) := '';
  --
BEGIN
  SELECT dbms_lob.substr(observacion,4000,1)
  INTO Lv_Observacion
  FROM DB_SOPORTE.INFO_TAREA_SEGUIMIENTO
  WHERE ROWID = Prw_InfoTareaSeguimiento;
  RETURN Lv_Observacion;

EXCEPTION
WHEN OTHERS THEN
RETURN Lv_Observacion;

END F_GET_CLOB_TO_VARCHAR;


FUNCTION F_ELIMINAR_REGISTROS_TEMPORAL(
    Pn_idCaso IN NUMBER)
  RETURN VARCHAR2
IS
  --
  Lv_Respuesta  VARCHAR2(1)  := 'N';
  Lv_IpCreacion VARCHAR2(30) := '127.0.0.1';
  --
BEGIN

IF Pn_idCaso IS NOT NULL THEN
  DELETE FROM TEMP_NOTIF_BACKBONE WHERE CASO_ID = Pn_idCaso;
  COMMIT;
  Lv_Respuesta := 'S';
END IF;

RETURN Lv_Respuesta;

EXCEPTION
WHEN OTHERS THEN
Lv_Respuesta := 'N';
db_general.gnrlpck_util.insert_error('Telcos +', 
                                      'SPKG_UTILIDADES.F_ELIMINAR_REGISTROS_TEMPORAL', 
                                      SQLERRM,
                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                      SYSDATE,
                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                    );  

RETURN Lv_Respuesta;

END F_ELIMINAR_REGISTROS_TEMPORAL;


FUNCTION GET_VARCHAR_CLEAN(
        Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2
IS
BEGIN
    RETURN TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            TRANSLATE(
            REGEXP_REPLACE(
            REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|<|>|/|%|"]|[)]+$', ' ')
            ,'[^A-Za-z0-9������������&()-_ ]' ,' ')
            ,'������,������', 'AEIOUN aeioun')
            , Chr(9), ' ')
            , Chr(10), ' ')
            , Chr(13), ' '));

END GET_VARCHAR_CLEAN;

  PROCEDURE P_INSERT_TAREA_SEGUIMIENTO(Pr_infoTareaSeguimiento IN INFO_TAREA_SEGUIMIENTO%ROWTYPE,
                                        Lv_MensaError OUT VARCHAR2)
      AS
      BEGIN
        INSERT
        INTO INFO_TAREA_SEGUIMIENTO
          (
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
            SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL,
            Pr_infoTareaSeguimiento.DETALLE_ID,
            Pr_infoTareaSeguimiento.OBSERVACION,
            Pr_infoTareaSeguimiento.USR_CREACION,
            SYSDATE,
            Pr_infoTareaSeguimiento.EMPRESA_COD,
            Pr_infoTareaSeguimiento.ESTADO_TAREA,
            Pr_infoTareaSeguimiento.INTERNO,
            Pr_infoTareaSeguimiento.DEPARTAMENTO_ID,
            Pr_infoTareaSeguimiento.PERSONA_EMPRESA_ROL_ID
          );
          
      EXCEPTION
      WHEN OTHERS THEN
        Lv_MensaError := 'SPKG_UTILIDADES.P_INSERT_TAREA_SEGUIMIENTO '||SQLERRM;
  END P_INSERT_TAREA_SEGUIMIENTO;

  PROCEDURE P_INSERT_DETALLE_HISTORIAL(Pr_infoDetalleHistorial IN INFO_DETALLE_HISTORIAL%ROWTYPE,
                                        Lv_MensaError OUT VARCHAR2)
  AS
    Ln_IdDetalleHistorial NUMBER;
  BEGIN
    IF Pr_infoDetalleHistorial.ID_DETALLE_HISTORIAL IS NULL THEN
      Ln_IdDetalleHistorial := DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL;
    ELSE
      Ln_IdDetalleHistorial := Pr_infoDetalleHistorial.ID_DETALLE_HISTORIAL;
    END IF;
    INSERT
    INTO INFO_DETALLE_HISTORIAL
      (
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
        MOTIVO_ID,
        MOTIVO_FIN_TAREA
      )
      VALUES
      (
        Ln_IdDetalleHistorial,
        Pr_infoDetalleHistorial.DETALLE_ID,
        Pr_infoDetalleHistorial.OBSERVACION,
        Pr_infoDetalleHistorial.ESTADO,
        Pr_infoDetalleHistorial.USR_CREACION,
        NVL(Pr_infoDetalleHistorial.FE_CREACION, SYSDATE),
        Pr_infoDetalleHistorial.IP_CREACION,
        Pr_infoDetalleHistorial.MOTIVO,
        Pr_infoDetalleHistorial.ASIGNADO_ID,
        Pr_infoDetalleHistorial.PERSONA_EMPRESA_ROL_ID,
        Pr_infoDetalleHistorial.DEPARTAMENTO_ORIGEN_ID,
        Pr_infoDetalleHistorial.DEPARTAMENTO_DESTINO_ID,
        Pr_infoDetalleHistorial.ACCION,
        Pr_infoDetalleHistorial.TAREA_ID,
        Pr_infoDetalleHistorial.ES_SOLUCION,
        Pr_infoDetalleHistorial.MOTIVO_ID,
        Pr_infoDetalleHistorial.MOTIVO_FIN_TAREA
      );
          
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensaError := 'SPKG_UTILIDADES.P_INSERT_DETALLE_HISTORIAL '||SQLERRM;
  END P_INSERT_DETALLE_HISTORIAL;

  PROCEDURE P_INSERT_DETALLE(Pr_InfoDetalle IN DB_SOPORTE.INFO_DETALLE%ROWTYPE,
                             Pv_MsjError    OUT VARCHAR2)
  AS
    Ln_IdDetalle NUMBER;
  BEGIN
    IF Pr_InfoDetalle.ID_DETALLE IS NULL THEN
      Ln_IdDetalle := DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL;
    ELSE
      Ln_IdDetalle := Pr_InfoDetalle.ID_DETALLE;
    END IF;

    INSERT
    INTO DB_SOPORTE.INFO_DETALLE
      (
        ID_DETALLE,
        TAREA_ID,
        TIPO_ZONA,
        LONGITUD,
        LATITUD,
        PESO_PRESUPUESTADO,
        PESO_REAL,
        VALOR_PRESUPUESTADO,
        VALOR_FACTURADO,
        VALOR_NO_FACTURADO,
        FE_SOLICITADA,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ES_SOLUCION,
        DETALLE_SOLICITUD_ID,
        DETALLE_HIPOTESIS_ID,
        DETALLE_ID_RELACIONADO,
        PROGRESO_TAREA_ID
      )
      VALUES
      (
        Ln_IdDetalle,
        Pr_InfoDetalle.TAREA_ID,
        Pr_InfoDetalle.TIPO_ZONA,
        Pr_InfoDetalle.LONGITUD,
        Pr_InfoDetalle.LATITUD,
        Pr_InfoDetalle.PESO_PRESUPUESTADO,
        Pr_InfoDetalle.PESO_REAL,
        Pr_InfoDetalle.VALOR_PRESUPUESTADO,
        Pr_InfoDetalle.VALOR_FACTURADO,
        Pr_InfoDetalle.VALOR_NO_FACTURADO,
        Pr_InfoDetalle.FE_SOLICITADA,
        Pr_InfoDetalle.OBSERVACION,
        Pr_InfoDetalle.USR_CREACION,
        NVL(Pr_InfoDetalle.FE_CREACION, SYSDATE),
        Pr_InfoDetalle.IP_CREACION,
        Pr_InfoDetalle.ES_SOLUCION,
        Pr_InfoDetalle.DETALLE_SOLICITUD_ID,
        Pr_InfoDetalle.DETALLE_HIPOTESIS_ID,
        Pr_InfoDetalle.DETALLE_ID_RELACIONADO,
        Pr_InfoDetalle.PROGRESO_TAREA_ID
      );
          
    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'SPKG_UTILIDADES.P_INSERT_DETALLE '|| SQLERRM;
  END P_INSERT_DETALLE;

  PROCEDURE P_INSERT_DETALLE_ASIGNACION(Pr_InfoDetalleAsignacion    IN DB_SOPORTE.INFO_DETALLE_ASIGNACION%ROWTYPE,
                                        Pv_MsjError                 OUT VARCHAR2)
  AS
    Ln_IdDetalleAsignacion NUMBER;
  BEGIN
    IF Pr_InfoDetalleAsignacion.ID_DETALLE_ASIGNACION IS NULL THEN
      Ln_IdDetalleAsignacion := DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL;
    ELSE
      Ln_IdDetalleAsignacion := Pr_InfoDetalleAsignacion.ID_DETALLE_ASIGNACION;
    END IF;

    INSERT
    INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION
      (
        ID_DETALLE_ASIGNACION,
        DETALLE_ID,
        ASIGNADO_ID,
        ASIGNADO_NOMBRE,
        REF_ASIGNADO_ID,
        REF_ASIGNADO_NOMBRE,
        MOTIVO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        PERSONA_EMPRESA_ROL_ID,
        TIPO_ASIGNADO,
        DEPARTAMENTO_ID,
        CANTON_ID
      )
      VALUES
      (
        Ln_IdDetalleAsignacion,
        Pr_InfoDetalleAsignacion.DETALLE_ID,
        Pr_InfoDetalleAsignacion.ASIGNADO_ID,
        Pr_InfoDetalleAsignacion.ASIGNADO_NOMBRE,
        Pr_InfoDetalleAsignacion.REF_ASIGNADO_ID,
        Pr_InfoDetalleAsignacion.REF_ASIGNADO_NOMBRE,
        Pr_InfoDetalleAsignacion.MOTIVO,
        Pr_InfoDetalleAsignacion.USR_CREACION,
        NVL(Pr_InfoDetalleAsignacion.FE_CREACION, SYSDATE),
        Pr_InfoDetalleAsignacion.IP_CREACION,
        Pr_InfoDetalleAsignacion.PERSONA_EMPRESA_ROL_ID,
        Pr_InfoDetalleAsignacion.TIPO_ASIGNADO,
        Pr_InfoDetalleAsignacion.DEPARTAMENTO_ID,
        Pr_InfoDetalleAsignacion.CANTON_ID
      );
          
    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'SPKG_UTILIDADES.P_INSERT_DETALLE_ASIGNACION '|| SQLERRM;
  END P_INSERT_DETALLE_ASIGNACION;

  PROCEDURE P_INSERT_INFO_TAREA(Pr_InfoTarea    IN DB_SOPORTE.INFO_TAREA%ROWTYPE,
                                Pv_MsjError     OUT VARCHAR2)
  AS
    Ln_IdInfoTarea NUMBER;
  BEGIN
    IF Pr_InfoTarea.ID_INFO_TAREA IS NULL THEN
      Ln_IdInfoTarea := DB_SOPORTE.SEQ_INFO_TAREA.NEXTVAL;
    ELSE
      Ln_IdInfoTarea := Pr_InfoTarea.ID_INFO_TAREA;
    END IF;

    INSERT
    INTO DB_SOPORTE.INFO_TAREA
      (
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
      VALUES
      (
        Ln_IdInfoTarea,
        Pr_InfoTarea.OBSERVACION_HISTORIAL,
        Pr_InfoTarea.OBSERVACION,
        Pr_InfoTarea.PERSONA_EMPRESA_ROL_ID_HIS,
        Pr_InfoTarea.ASIGNADO_ID_HIS,
        Pr_InfoTarea.DEPARTAMENTO_ORIGEN_ID,
        Pr_InfoTarea.DETALLE_ID,
        Pr_InfoTarea.LATITUD,
        Pr_InfoTarea.LONGITUD,
        Pr_InfoTarea.USR_CREACION_DETALLE,
        Pr_InfoTarea.DETALLE_ID_RELACIONADO,
        Pr_InfoTarea.TAREA_ID,
        Pr_InfoTarea.NOMBRE_TAREA,
        Pr_InfoTarea.DESCRIPCION_TAREA,
        Pr_InfoTarea.ASIGNADO_ID,
        Pr_InfoTarea.ASIGNADO_NOMBRE,
        Pr_InfoTarea.REF_ASIGNADO_ID,
        Pr_InfoTarea.REF_ASIGNADO_NOMBRE,
        Pr_InfoTarea.PERSONA_EMPRESA_ROL_ID,
        Pr_InfoTarea.DEPARTAMENTO_ID,
        Pr_InfoTarea.CANTON_ID,
        Pr_InfoTarea.ESTADO,
        Pr_InfoTarea.USR_CREACION_HIS,
        Pr_InfoTarea.TIPO_ASIGNADO,
        Pr_InfoTarea.FE_CREACION_DETALLE,
        Pr_InfoTarea.FE_SOLICITADA,
        Pr_InfoTarea.FE_CREACION_ASIGNACION,
        Pr_InfoTarea.FE_CREACION_HIS,
        Pr_InfoTarea.NUMERO_TAREA,
        Pr_InfoTarea.NOMBRE_PROCESO,
        Pr_InfoTarea.PROCESO_ID,
        Pr_InfoTarea.DETALLE_HISTORIAL_ID,
        Pr_InfoTarea.DETALLE_ASIGNACION_ID,
        Pr_InfoTarea.DETALLE_HIPOTESIS_ID,
        Pr_InfoTarea.USR_CREACION,
        SYSTIMESTAMP,
        Pr_InfoTarea.IP_CREACION,
        Pr_InfoTarea.NUMERO
      );
    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjError := 'SPKG_UTILIDADES.P_INSERT_INFO_TAREA '|| SQLERRM;
  END P_INSERT_INFO_TAREA;
 
  FUNCTION F_MATCH_VALOR_PARAMETER(Pv_valor_param VARCHAR2, Pv_valor_match VARCHAR2, Pv_delimiter VARCHAR2)
     RETURN VARCHAR2
  IS
    Le_Exception                   EXCEPTION;
    Lv_valor_parametro			   VARCHAR2(4000);
    Lv_valor			   		   VARCHAR2(4000);
    Lv_existe_valor 			   VARCHAR2(2) := 'N';
    Lv_MensajeError                VARCHAR2(4000);

  BEGIN

    IF Pv_valor_param IS NOT NULL AND Pv_valor_match IS NOT NULL AND Pv_delimiter IS NOT NULL  THEN 
		BEGIN
			Lv_valor_parametro := Pv_valor_param;
		   LOOP
			    Lv_valor := SUBSTR(Lv_valor_parametro,1, INSTR(Lv_valor_parametro, Pv_delimiter, 1)-1);
			    IF INSTR(Lv_valor_parametro, Pv_delimiter, 1) = 0 THEN
			      Lv_valor := Lv_valor_parametro;
			    END IF;
			    
			    IF Lv_valor = Pv_valor_match THEN 
			    	Lv_existe_valor := 'S';
			    END IF;
			
			    EXIT WHEN INSTR(Lv_valor_parametro, Pv_delimiter, 1) = 0 OR Lv_valor = Pv_valor_match;
			
			    Lv_valor_parametro := SUBSTR(Lv_valor_parametro,INSTR(Lv_valor_parametro, Pv_delimiter, 1)+1);
			
			END LOOP;
	     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            Lv_existe_valor := 'N';
        END;
    END IF;   
    RETURN Lv_existe_valor;

  EXCEPTION
  WHEN OTHERS THEN
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                        'SPKG_UTILIDADES.F_MATCH_VALOR_PARAMETER',
                                        Lv_MensajeError,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                        '127.0.0.1')
                                      );
  RETURN Lv_existe_valor;
  END F_MATCH_VALOR_PARAMETER;

END SPKG_UTILIDADES;
/