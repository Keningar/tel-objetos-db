CREATE OR REPLACE TRIGGER DB_COMERCIAL.T1_INFO_PUNTO_HISTORIAL AFTER
  UPDATE ON DB_COMERCIAL.INFO_PUNTO REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
  
  DECLARE 
/**
  * Documentacion para TRIGGER DB_COMERCIAL.T1_INFO_PUNTO_HISTORIAL
  * Crea un registro en el historial INFO_PUNTO_HISTORIAL usando el m�todo COMEK_MODELO.COMP_INSERTA_PUNTO_HISTORIAL
  *
  * @author Unknow
  * @version 1.0
  *
  * @author Alejandro Dom�nguez Vargas <adominguez@telconet.ec>
  * @version 1.1 04-12-2015
  * Se valida la asignaci�n inicial del ejecutivo de cobranzas al punto del cliente VIP
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 05-11-2020 - Se agregan caracter�sticas PUNTO_COBERTURA_ID y SECTOR_ID para guardar a nivel de INFO_PUNTO_CARACTERISTICA
  *                           los valores que tenia un Punto Cliente en la INFO_PUNTO antes del cambio, dichos registros ser�n actualizables. 
  * 
  */
  --RECUPERAMOS EL TIPO DE NEGOCIO
  CURSOR C_TipoNegocio(Cv_tipoNegocio ADMI_TIPO_NEGOCIO.ID_TIPO_NEGOCIO%type) IS
    SELECT NOMBRE_TIPO_NEGOCIO 
    FROM ADMI_TIPO_NEGOCIO
    WHERE ID_TIPO_NEGOCIO = Cv_tipoNegocio;
  
  --RECUPERAMOS EL TIPO DE UBICACION
  CURSOR C_TipoUbicacion (Cv_TipoUbicacion ADMI_TIPO_UBICACION.ID_TIPO_UBICACION%type) IS
    SELECT DESCRIPCION_TIPO_UBICACION 
    FROM ADMI_TIPO_UBICACION 
    WHERE ID_TIPO_UBICACION= Cv_TipoUbicacion;
    
  --RECUPERAMOS EL NOMBRE DE LA PERSONA
  CURSOR C_Persona (Cv_PersonaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
    SELECT P.NOMBRES||' '||P.APELLIDOS NOMBRE
    FROM  INFO_PERSONA_EMPRESA_ROL PE, 
          INFO_PERSONA P 
    WHERE PE.PERSONA_ID=P.ID_PERSONA
    AND PE.ID_PERSONA_ROL = Cv_PersonaRol;
    
  --RECUPERAMOS EL SECTOR
  CURSOR C_Sector (Cv_idSector ADMI_SECTOR.ID_SECTOR%type) IS
    SELECT NOMBRE_SECTOR
    FROM ADMI_SECTOR
    WHERE ID_SECTOR = Cv_idSector;
    
  --RECUPERAMOS LA JURISDICCION
  CURSOR C_Jurisdiccion(Cv_puntoCobertura ADMI_JURISDICCION.ID_JURISDICCION%TYPE) IS
    SELECT NOMBRE_JURISDICCION
    FROM ADMI_JURISDICCION 
    WHERE ID_JURISDICCION = Cv_puntoCobertura;

   --Costo: 2
   CURSOR C_GetCaract (Cv_DescripcionCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
   IS 
   SELECT ID_CARACTERISTICA 
   FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
   WHERE DESCRIPCION_CARACTERISTICA=Cv_DescripcionCarac
   AND ESTADO = 'Activo'
   AND ROWNUM = 1;
  
   --Costo: 5
   CURSOR C_PuntoCaract(Cn_PuntoId      DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA.PUNTO_ID%TYPE,
                       Cv_DescripCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS
    SELECT IPC.ID_PUNTO_CARACTERISTICA
    FROM  DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC
    JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA       AC  ON AC.ID_CARACTERISTICA = IPC.CARACTERISTICA_ID    
    WHERE 
    AC.DESCRIPCION_CARACTERISTICA = Cv_DescripCarac AND
    IPC.PUNTO_ID                  = Cn_PuntoId;    
  
  Lv_CaracSector           DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE:='SECTOR_ID';
  Lv_CaracPtoCobertura     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE:='PUNTO_COBERTURA_ID';
  Ln_IdPuntoCaracteristica DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA.ID_PUNTO_CARACTERISTICA%TYPE;
  Ln_CaracteristicaId      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;  
  
  Lv_jurisdiccionAnt ADMI_JURISDICCION.NOMBRE_JURISDICCION%type;
  Lv_jurisdiccionAct ADMI_JURISDICCION.NOMBRE_JURISDICCION%type;
    
  Lv_sectorAnt  ADMI_SECTOR.NOMBRE_SECTOR%type;
  Lv_sectorAct  ADMI_SECTOR.NOMBRE_SECTOR%type;
  
  Lv_nombreAnt VARCHAR2(200);
  Lv_nombreAct VARCHAR2(200);
    
  Lv_tipoUbicacionAnt ADMI_TIPO_UBICACION.DESCRIPCION_TIPO_UBICACION%type;
  Lv_tipoUbicacionAct ADMI_TIPO_UBICACION.DESCRIPCION_TIPO_UBICACION%type;
  
  Lv_tipoNegocioAnt ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%type;
  Lv_tipoNegocioAct ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%type;
  
  Lr_InfoHistorial INFO_PUNTO_HISTORIAL%ROWTYPE:=NULL;
  Lv_CodigoError  VARCHAR2(4000)  := NULL;
  Lv_MensajeError VARCHAR2(4000)  := NULL;
  e               EXCEPTION;
  Lv_Mensaje      VARCHAR2(500);  
  Lv_Valor INFO_PUNTO_HISTORIAL.VALOR%TYPE := NULL;
  
  BEGIN
    IF C_PuntoCaract%ISOPEN THEN
      CLOSE C_PuntoCaract;
    END IF;

    IF C_GetCaract%ISOPEN THEN
      CLOSE C_GetCaract;
    END IF;

    IF :NEW.USR_ULT_MOD IS NOT NULL THEN
      Lr_InfoHistorial.USR_CREACION := :NEW.USR_ULT_MOD;
    ELSE
      Lr_InfoHistorial.USR_CREACION := USER;
    END IF;
    
    Lr_InfoHistorial.PUNTO_ID    := :OLD.ID_PUNTO;
    Lr_InfoHistorial.IP_CREACION  := :NEW.IP_ULT_MOD;
    Lr_InfoHistorial.ACCION      := :NEW.ACCION;
    --
    IF (:NEW.ARCHIVO_DIGITAL     <> :OLD.ARCHIVO_DIGITAL) THEN
      Lv_Valor                   := Lv_Valor||' (ARCHIVO_DIGITAL) ANTERIOR:'||:OLD.ARCHIVO_DIGITAL||' - ACTUAL:'||:NEW.ARCHIVO_DIGITAL;
    END IF;
    --
    IF (:NEW.DESCRIPCION_PUNTO <> :OLD.DESCRIPCION_PUNTO) THEN
      IF Lv_Valor              IS NOT NULL THEN
        Lv_Valor               :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(DESCRIPCION_PUNTO) ANTERIOR:'||:OLD.DESCRIPCION_PUNTO||' - ACTUAL:'||:NEW.DESCRIPCION_PUNTO;
    END IF;
    --
    IF (:NEW.DIRECCION <> :OLD.DIRECCION) THEN
      IF Lv_Valor      IS NOT NULL THEN
        Lv_Valor       :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(DIRECCION) ANTERIOR:'||:OLD.DIRECCION||' - ACTUAL:'||:NEW.DIRECCION;
    END IF;
    --
    IF (:NEW.ESTADO <> :OLD.ESTADO) THEN
      IF Lv_Valor   IS NOT NULL THEN
        Lv_Valor    :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(ESTADO) ANTERIOR:'||:OLD.ESTADO||' - ACTUAL:'||:NEW.ESTADO;
    END IF;
    --
    IF (:NEW.LATITUD <> :OLD.LATITUD) THEN
      IF Lv_Valor    IS NOT NULL THEN
        Lv_Valor     :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(LATITUD) ANTERIOR:'||:OLD.LATITUD||' - ACTUAL:'||:NEW.LATITUD;
    END IF;
    --
    IF (:NEW.LOGIN <> :OLD.LOGIN) THEN
      IF Lv_Valor  IS NOT NULL THEN
        Lv_Valor   :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(LOGIN) ANTERIOR:'||:OLD.LOGIN||' - ACTUAL:'||:NEW.LOGIN;
    END IF;
    --
    IF (:NEW.LONGITUD <> :OLD.LONGITUD) THEN
      IF Lv_Valor     IS NOT NULL THEN
        Lv_Valor      :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(LONGITUD) ANTERIOR:'||:OLD.LONGITUD||' - ACTUAL:'||:NEW.LONGITUD;
    END IF;
    --
    IF (:NEW.NOMBRE_PUNTO <> :OLD.NOMBRE_PUNTO) THEN
      IF Lv_Valor         IS NOT NULL THEN
        Lv_Valor          :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(NOMBRE_PUNTO) ANTERIOR:'||:OLD.NOMBRE_PUNTO||' - ACTUAL:'||:NEW.NOMBRE_PUNTO;
    END IF;
    --
    IF (:NEW.OBSERVACION <> :OLD.OBSERVACION) THEN
      IF Lv_Valor        IS NOT NULL THEN
        Lv_Valor         :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(OBSERVACION) ANTERIOR:'||:OLD.OBSERVACION||' - ACTUAL:'||:NEW.OBSERVACION;
    END IF;
    --
    IF (:NEW.PERSONA_EMPRESA_ROL_ID <> :OLD.PERSONA_EMPRESA_ROL_ID) THEN
      IF Lv_Valor                   IS NOT NULL THEN
        Lv_Valor                    :=Lv_Valor||'|';
      END IF;
      
      OPEN C_Persona(:OLD.PERSONA_EMPRESA_ROL_ID);
      FETCH C_Persona INTO Lv_nombreAnt;
      CLOSE C_Persona;
      
      OPEN C_Persona(:NEW.PERSONA_EMPRESA_ROL_ID);
      FETCH C_Persona INTO Lv_nombreAct;
      CLOSE C_Persona;
      
      Lv_Valor := Lv_Valor||'(PERSONA_EMPRESA_ROL_ID) ANTERIOR:'||Lv_nombreAnt||' - ACTUAL:'||Lv_nombreAct;
    END IF;
    --
    IF (:NEW.RUTA_CROQUIS <> :OLD.RUTA_CROQUIS) THEN
      IF Lv_Valor         IS NOT NULL THEN
        Lv_Valor          :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(RUTA_CROQUIS) ANTERIOR:'||:OLD.RUTA_CROQUIS||' - ACTUAL:'||:NEW.RUTA_CROQUIS;
    END IF;
    --
    IF (:NEW.SECTOR_ID <> :OLD.SECTOR_ID) THEN
      IF Lv_Valor      IS NOT NULL THEN
        Lv_Valor       :=Lv_Valor||'|';
      END IF;
      
      OPEN C_Sector(:OLD.SECTOR_ID);
      FETCH C_Sector INTO Lv_sectorAnt ;
      CLOSE C_Sector ;
      
      OPEN C_Sector(:NEW.SECTOR_ID);
      FETCH C_Sector INTO Lv_sectorAct;
      CLOSE C_Sector;
      
      Lv_Valor := Lv_Valor||'(SECTOR_ID) ANTERIOR:'||Lv_sectorAnt||' - ACTUAL:'||Lv_sectorAct;
           
      OPEN C_GetCaract(Lv_CaracSector);
      FETCH C_GetCaract INTO Ln_CaracteristicaId;
      CLOSE C_GetCaract ;
      
      IF Ln_CaracteristicaId IS NOT NULL THEN      
        OPEN C_PuntoCaract(:OLD.ID_PUNTO, Lv_CaracSector);
        FETCH C_PuntoCaract INTO Ln_IdPuntoCaracteristica;
        CLOSE C_PuntoCaract ;

        IF Ln_IdPuntoCaracteristica IS NULL THEN
           INSERT INTO DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA 
           (ID_PUNTO_CARACTERISTICA,
            PUNTO_ID,
            CARACTERISTICA_ID,
            FE_CREACION,
            FE_ULT_MOD,
            USR_CREACION,
            USR_ULT_MOD,
            IP_CREACION,
            ESTADO,
            VALOR)
            VALUES 
           (DB_COMERCIAL.SEQ_INFO_PUNTO_CARACTERISTICA.NEXTVAL,
            :OLD.ID_PUNTO,
            Ln_CaracteristicaId,
            SYSDATE,
            NULL,
            'telconet',
            NULL,
            '127.0.0.1',
            'Activo',
            :OLD.SECTOR_ID);  
        ELSE
           UPDATE DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA  
           SET 
             VALOR = :OLD.SECTOR_ID,
             FE_ULT_MOD = SYSDATE,
             USR_ULT_MOD = 'telcos'
            WHERE ID_PUNTO_CARACTERISTICA = Ln_IdPuntoCaracteristica;
        END IF;
      END IF;
    END IF;
    --
    IF (:NEW.TIPO_CUENTA <> :OLD.TIPO_CUENTA) THEN
      IF Lv_Valor        IS NOT NULL THEN
        Lv_Valor         :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(TIPO_CUENTA) ANTERIOR:'||:OLD.TIPO_CUENTA||' - ACTUAL:'||:NEW.TIPO_CUENTA;
    END IF;
    --
    IF (:NEW.TIPO_NEGOCIO_ID <> :OLD.TIPO_NEGOCIO_ID) THEN
      IF Lv_Valor            IS NOT NULL THEN
        Lv_Valor             :=Lv_Valor||'|';
      END IF;
      
      OPEN C_TipoNegocio(:OLD.TIPO_NEGOCIO_ID);
      FETCH C_TipoNegocio INTO Lv_tipoNegocioAnt;
      CLOSE C_TipoNegocio;
      
      OPEN C_TipoNegocio(:NEW.TIPO_NEGOCIO_ID);
      FETCH C_TipoNegocio INTO Lv_tipoNegocioAct;
      CLOSE C_TipoNegocio;
      
      Lv_Valor := Lv_Valor||'(TIPO_NEGOCIO_ID) ANTERIOR:'||Lv_tipoNegocioAnt||' - ACTUAL:'||Lv_tipoNegocioAct;
    END IF;
    --
    IF (:NEW.TIPO_UBICACION_ID <> :OLD.TIPO_UBICACION_ID) THEN
      IF Lv_Valor              IS NOT NULL THEN
        Lv_Valor               :=Lv_Valor||'|';
      END IF;
      
      OPEN C_TipoUbicacion(:OLD.TIPO_UBICACION_ID);
      FETCH C_TipoUbicacion INTO Lv_tipoUbicacionAnt;
      CLOSE C_TipoUbicacion;
      
      OPEN C_TipoUbicacion(:NEW.TIPO_UBICACION_ID);
      FETCH C_TipoUbicacion INTO Lv_tipoUbicacionAct;
      CLOSE C_TipoUbicacion;
      
      Lv_Valor := Lv_Valor||'(TIPO_UBICACION_ID) ANTERIOR:'||Lv_tipoUbicacionAnt||' - ACTUAL:'||Lv_tipoUbicacionAct;
    END IF;
    
    --
    /* Validaci�n del ejecutivo de cobranzas*/
    IF :OLD.USR_COBRANZAS IS NULL THEN
      IF Lv_Valor IS NOT NULL THEN
        Lv_Valor :=Lv_Valor||'|';
      END IF; 
      Lv_Valor := Lv_Valor||'(USR_COBRANZAS) SE ASIGNA:'|| :NEW.USR_COBRANZAS;
    ELSE
      IF (:NEW.USR_COBRANZAS <> :OLD.USR_COBRANZAS) THEN
      IF Lv_Valor          IS NOT NULL THEN
        Lv_Valor           :=Lv_Valor||'|';
      END IF; 
        Lv_Valor := Lv_Valor||'(USR_COBRANZAS) ANTERIOR:'||:OLD.USR_COBRANZAS||' - ACTUAL:'||:NEW.USR_COBRANZAS;
      END IF;  
    END IF;   
    --
    IF (:NEW.USR_VENDEDOR <> :OLD.USR_VENDEDOR) THEN
      IF Lv_Valor         IS NOT NULL THEN
        Lv_Valor          :=Lv_Valor||'|';
      END IF;
      Lv_Valor := Lv_Valor||'(USR_VENDEDOR) ANTERIOR:'||:OLD.USR_VENDEDOR||' - ACTUAL:'||:NEW.USR_VENDEDOR;
    END IF;
    --
    IF (:NEW.PUNTO_COBERTURA_ID <> :OLD.PUNTO_COBERTURA_ID) THEN
      IF Lv_Valor         IS NOT NULL THEN
        Lv_Valor          :=Lv_Valor||'|';
      END IF;
      
      OPEN C_Jurisdiccion(:OLD.PUNTO_COBERTURA_ID);
      FETCH C_Jurisdiccion INTO Lv_jurisdiccionAnt ;
      CLOSE C_Jurisdiccion;
      
      OPEN C_Jurisdiccion(:NEW.PUNTO_COBERTURA_ID);
      FETCH C_Jurisdiccion INTO Lv_jurisdiccionAct ;
      CLOSE C_Jurisdiccion;
      
      Lv_Valor := Lv_Valor||'(PUNTO_COBERTURA_ID) ANTERIOR:'||Lv_jurisdiccionAnt||' - ACTUAL:'||Lv_jurisdiccionAct;
      
      Ln_CaracteristicaId:= NULL; 
      Ln_IdPuntoCaracteristica:= NULL;

      OPEN C_GetCaract(Lv_CaracPtoCobertura);
      FETCH C_GetCaract INTO Ln_CaracteristicaId;
      CLOSE C_GetCaract ;
      
      IF Ln_CaracteristicaId IS NOT NULL THEN      
        OPEN C_PuntoCaract(:OLD.ID_PUNTO, Lv_CaracPtoCobertura);
        FETCH C_PuntoCaract INTO Ln_IdPuntoCaracteristica;
        CLOSE C_PuntoCaract ;

        IF Ln_IdPuntoCaracteristica IS NULL THEN
           INSERT INTO DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA 
           (ID_PUNTO_CARACTERISTICA,
            PUNTO_ID,
            CARACTERISTICA_ID,
            FE_CREACION,
            FE_ULT_MOD,
            USR_CREACION,
            USR_ULT_MOD,
            IP_CREACION,
            ESTADO,
            VALOR)
            VALUES 
           (DB_COMERCIAL.SEQ_INFO_PUNTO_CARACTERISTICA.NEXTVAL,
            :OLD.ID_PUNTO,
            Ln_CaracteristicaId,
            SYSDATE,
            NULL,
            'telconet',
            NULL,
            '127.0.0.1',
            'Activo',
            :OLD.PUNTO_COBERTURA_ID);  
        END IF;
       ELSE
           UPDATE DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA  
           SET 
             VALOR = :OLD.PUNTO_COBERTURA_ID,
             FE_ULT_MOD = SYSDATE,
             USR_ULT_MOD = 'telcos'
            WHERE ID_PUNTO_CARACTERISTICA = Ln_IdPuntoCaracteristica;
      END IF;
    END IF;
    --

    IF Lv_Valor IS NOT NULL THEN
      Lr_InfoHistorial.VALOR := Lv_Valor;
      --INSERTO EL HISTORIAL
      COMEK_MODELO.COMP_INSERTA_PUNTO_HISTORIAL(Lr_InfoHistorial, Lv_CodigoError, Lv_MensajeError);
      IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
        Lv_Mensaje      := Lv_CodigoError||' '||Lv_MensajeError;
        RAISE e;
      END IF;
    END IF;
    --
  EXCEPTION
  WHEN e THEN
    UTL_MAIL.SEND (sender     => 'notificaciones@telconet.ec', 
                   recipients => 'telcos@telconet.ec;', 
                   subject    => 'Error generado en el trigger T1_INFO_PUNTO_HISTORIAL', 
                   MESSAGE    => '<p>Ocurrio el siguiente error: ' || SQLERRM || ' - ' || SQLCODE ||Lv_Mensaje||' </p>',
                   mime_type => 'text/html; charset=UTF-8' );
  WHEN OTHERS THEN
    UTL_MAIL.SEND (sender     => 'notificaciones@telconet.ec', 
                   recipients => 'telcos@telconet.ec;', 
                   subject    => 'Error generado en el trigger T1_INFO_PUNTO_HISTORIAL', 
                   MESSAGE    => '<p>Ocurrio el siguiente error: '  || SQLERRM || ' - ' || SQLCODE ||Lv_Mensaje||' </p>', 
                   mime_type  => 'text/html; charset=UTF-8' );
  END;
/