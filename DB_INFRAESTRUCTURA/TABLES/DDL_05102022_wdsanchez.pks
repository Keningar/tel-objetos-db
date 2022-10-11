 --crear tabla control ejecucion cron

    /**
    * Documentación para tabla DB_INFRAESTRUCTURA.SHEDLOCK
    * tabla control de ejecucion en paralelo para configuracion cron en ambientes monitoreo 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 05-10-2022
    */
  CREATE TABLE DB_INFRAESTRUCTURA.SHEDLOCK (
      name VARCHAR2(64 CHAR) ,
      lock_until TIMESTAMP,
      locked_at TIMESTAMP,
      locked_by  VARCHAR2(255 CHAR),
      PRIMARY KEY (name)
    );
    
    
    COMMENT ON COLUMN DB_INFRAESTRUCTURA.SHEDLOCK.name IS 'INSTANCIA CONTROL SHEDLOCK';
    COMMENT ON COLUMN DB_INFRAESTRUCTURA.SHEDLOCK.lock_until IS 'INICIO DE CONTROL EJECUCION MULTIPLE';
    COMMENT ON COLUMN DB_INFRAESTRUCTURA.SHEDLOCK.locked_at IS 'FIN DE CONTROL EJECUCION MULTIPLE';
    COMMENT ON COLUMN DB_INFRAESTRUCTURA.SHEDLOCK.locked_by IS 'APLICACION QUE ENVIA PETICION DE CONTROL';


/

