CREATE OR REPLACE TRIGGER DB_COMERCIAL.BEFORE_DML_INFO_PERSONA 
  BEFORE INSERT OR UPDATE OF NOMBRES,APELLIDOS,RAZON_SOCIAL,IDENTIFICACION_CLIENTE ON DB_COMERCIAL.INFO_PERSONA 
  FOR EACH ROW
  
    /**
    * Documentación para trigger BEFORE_DML_INFO_PERSONA
    * Al momento de guardar los datos de una persona, se depura los caracteres especiales en los campos NOMBRES, 
    * APELLIDOS y RAZON SOCIAL. Para la identicacion se realiza la conversión a mayúsculas.
    * @author Gernan Valenzuela <gvalenzuela@telconet.ec>
    * @version 1.0 28-08-2017
    *
    * @author Alex Arreaga <atarreaga@telconet.ec>
    * @version 1.1 14-05-2021 - Se agrega adicional la función F_GET_VARCHAR_CLEAN para depurar otros caracteres  
    *                           especiales a los campos NOMBRES, APELLIDOS, RAZON_SOCIAL.
    *
    * Se agrego el validacion que restringe la creacion de un cliente repetido.
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.1 14-05-2021 
    */
  DECLARE
  v_persona_id integer;
  BEGIN

    IF INSERTING THEN
      SELECT COUNT(*) INTO v_persona_id
        FROM DB_COMERCIAL.INFO_PERSONA
      where IDENTIFICACION_CLIENTE=:new.IDENTIFICACION_CLIENTE;
      IF(v_persona_id>=1) THEN
        RAISE_APPLICATION_ERROR(-20000, 'La identificación ya existe en el Sistema');
      END IF;
    END IF;

    :NEW.NOMBRES                := DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.F_DEBITOS_VARCHAR_REPLACED(:NEW.NOMBRES);
    :NEW.APELLIDOS              := DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.F_DEBITOS_VARCHAR_REPLACED(:NEW.APELLIDOS);
    :NEW.RAZON_SOCIAL           := DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.F_DEBITOS_VARCHAR_REPLACED(:NEW.RAZON_SOCIAL);
    :NEW.IDENTIFICACION_CLIENTE := UPPER(:NEW.IDENTIFICACION_CLIENTE);

    :NEW.NOMBRES                := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(:NEW.NOMBRES);
    :NEW.APELLIDOS              := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(:NEW.APELLIDOS);
    :NEW.RAZON_SOCIAL           := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(:NEW.RAZON_SOCIAL);
   
    EXCEPTION

    WHEN OTHERS THEN
    
    RAISE_APPLICATION_ERROR(-20001, SQLERRM || ' - DB_COMERCIAL.BEFORE_DML_INFO_PERSONA');
   
END;
/
