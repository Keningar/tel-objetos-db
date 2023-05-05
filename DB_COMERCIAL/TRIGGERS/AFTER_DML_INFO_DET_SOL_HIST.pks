create or replace TRIGGER DB_COMERCIAL.AFTER_DML_INFO_DET_SOL_HIST AFTER 
INSERT ON DB_COMERCIAL.INFO_DETALLE_SOL_HIST REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
DECLARE 
    --
/**
  * Documentacion para trigger AFTER_DML_INFO_DET_SOL_HIST
  * Inserta un registro en INFO_SERVICIO_HISTORIAL cuando la solicitud cambia a un estado diferente de Pendiente y ésta sea de tipo 'SOLICITUD MIGRACION'
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 11-03.2015
  */
    Ln_IdTipoSolicitud  ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
    Lv_EstadoServicio   INFO_SERVICIO.ESTADO%TYPE;
    Ln_TipoSolicitudId  INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE ;
    Ln_IdServicio       INFO_SERVICIO.ID_SERVICIO%TYPE;
    --
  BEGIN
    --
    --Inserta si la solictud cambia a un estado diferente de Pendiente
    IF :NEW.ESTADO <> 'Pendiente' THEN
      --Se obtiene el ID_TIPO_SOLICITUD
      SELECT
        ID_TIPO_SOLICITUD
      INTO
        Ln_IdTipoSolicitud
      FROM
        ADMI_TIPO_SOLICITUD
      WHERE
        DESCRIPCION_SOLICITUD = 'SOLICITUD MIGRACION';
      --
      --Se obtiene el TIPO_SOLICITUD_ID y SERVICIO_ID
      SELECT
        TIPO_SOLICITUD_ID,
        SERVICIO_ID
      INTO
        Ln_TipoSolicitudId,
        Ln_IdServicio
      FROM
        INFO_DETALLE_SOLICITUD
      WHERE
        ID_DETALLE_SOLICITUD = :NEW.DETALLE_SOLICITUD_ID;
      --
      --Se compara si la solictud es de Migracion
      IF Ln_IdTipoSolicitud = Ln_TipoSolicitudId THEN
        --Obtiene el estado del servicio
        SELECT
          ESTADO
        INTO
          Lv_EstadoServicio
        FROM
          INFO_SERVICIO
        WHERE
          ID_SERVICIO= Ln_IdServicio;
        --
        --Inserta el cambio de estado en la INFO_SERVICIO_HISTORIAL, con el nuevo estado de la solicitud
        INSERT
        INTO
          INFO_SERVICIO_HISTORIAL
          (
            ID_SERVICIO_HISTORIAL,
            SERVICIO_ID,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            ESTADO,
            OBSERVACION
          )
          VALUES
          (
            SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
            Ln_IdServicio,
            :NEW.USR_CREACION,
            sysdate,
            SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),
            Lv_EstadoServicio,
            'Solicitud de Migracion: Cambio a estado ['
            ||:NEW.ESTADO
            ||']'
          );
      END IF;
      --
    END IF;
  END AFTER_DML_INFO_DET_SOL_HIST;
