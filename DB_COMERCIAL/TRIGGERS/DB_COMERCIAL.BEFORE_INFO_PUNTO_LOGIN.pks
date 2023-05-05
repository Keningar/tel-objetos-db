CREATE OR REPLACE TRIGGER DB_COMERCIAL.BEFORE_INFO_PUNTO_LOGIN BEFORE 
  INSERT ON DB_COMERCIAL.INFO_PUNTO
  REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE
 /**
  * Documentacion para trigger BEFORE_INFO_PUNTO_LOGIN
  * Especificacion: Triggers que permite quitar los caracteres especiales del login formado por punto cliente
  * caracteres permitidos [^A-Za-z0-9_-]
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-08-2015
  *
  * @author Alejandro Domínguez <adominguez@telconet.ec>
  * @version 1.1 04-12-2015
  * Se agrega el control de duplicidad de logins y preparación de una respuesta personalizada.
  */
  v_cadena_limpia  VARCHAR2(60);
  LN_ROW_COUNT NUMBER;
  LN_ID_PUNTO NUMBER;
  LV_USR_CREACION VARCHAR2(20);
  LD_FE_CREACION DATE;
  RAISE_EXCEPTION EXCEPTION;
  BEGIN
    DB_COMERCIAL.EscapaCaracteresEspeciales(:NEW.LOGIN, v_cadena_limpia => v_cadena_limpia);
    SELECT COUNT(*) INTO LN_ROW_COUNT FROM INFO_PUNTO WHERE LOGIN = v_cadena_limpia ;
    IF LN_ROW_COUNT > 0 THEN
      SELECT ID_PUNTO, USR_CREACION, FE_CREACION INTO LN_ID_PUNTO, LV_USR_CREACION, LD_FE_CREACION
      FROM (SELECT * FROM INFO_PUNTO WHERE LOGIN = v_cadena_limpia ORDER BY FE_CREACION DESC) WHERE ROWNUM = 1;
      RAISE RAISE_EXCEPTION;
    ELSE
      :NEW.LOGIN := v_cadena_limpia;
    END IF;
EXCEPTION
WHEN RAISE_EXCEPTION THEN
  RAISE_APPLICATION_ERROR(-20999, '#ERR-20999$Login ' ||v_cadena_limpia|| ' duplicado, el usuario ' || LV_USR_CREACION || 
                                  ' lo registró el ' || LD_FE_CREACION ||  '$'|| LN_ID_PUNTO ||'#');
WHEN OTHERS THEN
  UTL_MAIL.SEND (sender     => 'notificaciones@telconet.ec', 
                 recipients => 'telcos@telconet.ec', 
                 subject    => 'Error generado en el trigger DB_COMERCIAL.BEFORE_INFO_PUNTO_LOGIN', 
                 MESSAGE    => '<p>Ocurrio el siguiente error: '  || SQLERRM || ' - ' || SQLCODE ||' </p>', 
                 mime_type  => 'text/html; charset=UTF-8' );
END;
/
