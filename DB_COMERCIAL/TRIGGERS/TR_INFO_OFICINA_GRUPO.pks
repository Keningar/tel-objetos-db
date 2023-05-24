CREATE OR REPLACE TRIGGER DB_COMERCIAL.TR_INFO_OFICINA_GRUPO AFTER
  INSERT OR
  UPDATE ON DB_COMERCIAL.INFO_OFICINA_GRUPO REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE
    --
  CURSOR C_NOM_OFICINA IS
  SELECT NOMBRE_OFICINA
  FROM NAF47_TNET.ARPLOFICINA
  WHERE NOMBRE_OFICINA = :NEW.NOMBRE_OFICINA
  AND NO_CIA  = :NEW.EMPRESA_ID;
  --
  CURSOR C_NO_OFICINA IS
  SELECT NOMBRE_OFICINA
  FROM NAF47_TNET.ARPLOFICINA
  WHERE OFICINA   = :NEW.ID_OFICINA
  AND NO_CIA  = :NEW.EMPRESA_ID;

  --

  --
  Lv_NombreOficina  NAF47_TNET.ARPLOFICINA.NOMBRE_OFICINA%type:=NULL;
  Le_Error          EXCEPTION;
  Lv_Mensaje        VARCHAR2(500);
  BEGIN

    IF INSERTING THEN
      OPEN C_NOM_OFICINA;
      FETCH C_NOM_OFICINA INTO Lv_NombreOficina;
      CLOSE C_NOM_OFICINA;
      --VERIFICO SI YA EXISTE CREADA LA OFICINA
      IF Lv_NombreOficina IS NULL THEN
        INSERT
        INTO NAF47_TNET.ARPLOFICINA
          ( NO_CIA,
            OFICINA,
            NOMBRE_OFICINA,
            DIRECCION_OFICINA,
            USUARIO_CREA,
            FECHA_CREA,
            USUARIO_ACTUALIZA,
            FECHA_ACTUALIZA,
            ESTADO)
          VALUES
          ( :NEW.EMPRESA_ID,
            :NEW.ID_OFICINA,
            :NEW.NOMBRE_OFICINA,
            :NEW.DIRECCION_OFICINA,
            USER,
            SYSDATE,
            NULL,
            NULL,
            DECODE(:NEW.ESTADO,'Activo','A','Eliminado','I','Inactivo','I'));
      END IF;
    END IF;
    --
    IF UPDATING THEN
      OPEN C_NO_OFICINA;
      FETCH C_NO_OFICINA INTO Lv_NombreOficina;
      CLOSE C_NO_OFICINA;
      --VERIFICO SI YA EXISTE CREADA LA OFICINA
      IF Lv_NombreOficina IS NULL THEN
        INSERT
        INTO NAF47_TNET.ARPLOFICINA
          ( NO_CIA,
            OFICINA,
            NOMBRE_OFICINA,
            DIRECCION_OFICINA,
            USUARIO_CREA,
            FECHA_CREA,
            USUARIO_ACTUALIZA,
            FECHA_ACTUALIZA,
            ESTADO)
          VALUES
          ( :NEW.EMPRESA_ID,
            :NEW.ID_OFICINA,
            :NEW.NOMBRE_OFICINA,
            :NEW.DIRECCION_OFICINA,
            USER,
            SYSDATE,
            NULL,
            NULL,
            DECODE(:NEW.ESTADO,'Activo','A','Eliminado','I','Inactivo','I'));
      ELSE
           UPDATE NAF47_TNET.ARPLOFICINA
      SET NOMBRE_OFICINA     = :NEW.NOMBRE_OFICINA,
          DIRECCION_OFICINA  = :NEW.DIRECCION_OFICINA,
          USUARIO_ACTUALIZA  = USER,
          FECHA_ACTUALIZA    = SYSDATE,
          ESTADO             = DECODE(:NEW.ESTADO,'Activo','A','Eliminado','I','Inactivo','I')
      WHERE OFICINA   = :NEW.ID_OFICINA
        AND NO_CIA  = :NEW.EMPRESA_ID;


      END IF;
      --
    END IF;
    --
  EXCEPTION
  WHEN Le_Error THEN
    UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', recipients => 'telcos@telconet.ec;dba@telconet.ec;NAF@telconet.ec', subject => 'Error generado en el trigger TR_INFO_OFICINA_GRUPO', MESSAGE => '<p>Ocurrio el siguiente error: ' || SQLERRM || ' - ' || SQLCODE ||Lv_Mensaje||' </p>', mime_type => 'text/html; charset=UTF-8' );
  WHEN OTHERS THEN
    UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', recipients => 'telcos@telconet.ec;dba@telconet.ec;NAF@telconet.ec', subject => 'Error generado en el trigger TR_INFO_OFICINA_GRUPO', MESSAGE => '<p>Ocurrio el siguiente error: ' || SQLERRM || ' - ' || SQLCODE ||Lv_Mensaje||' </p>', mime_type => 'text/html; charset=UTF-8' );
  END;

/