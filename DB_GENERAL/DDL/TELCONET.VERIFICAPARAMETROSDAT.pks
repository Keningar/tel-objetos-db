/*
* Documentación para verificaParametrosDat
  * Funcion que verifica e inserta informacion requerida
  * para insertar un empleado
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 19/01/2022
*/
DELIMITER //
DROP FUNCTION IF exists telconet.verificaParametrosDat//
CREATE FUNCTION telconet.verificaParametrosDat(CARGO VARCHAR(100),
                         AREA VARCHAR(100),
                                               DEPARTAMENTO VARCHAR(100),
                                               CIUDAD VARCHAR(100)) RETURNS VARCHAR(10)
BEGIN
    DECLARE RESUL varchar(2) ;
    DECLARE TOTAL_CARGO INT;
    DECLARE TOTAL_AREA INT;
    DECLARE DEPT INT;
    DECLARE ID_OFI INT;
    
    /*Se verifica el cargo*/
    SELECT count(*) 
           INTO TOTAL_CARGO 
           FROM telconet.admi_cargos_empleado_dat
           WHERE descripcion_cargo = CARGO;
           
  IF TOTAL_CARGO = 0  THEN
      INSERT INTO telconet.admi_cargos_empleado_dat
       (DESCRIPCION_CARGO,
        RANGO_SUELDO_MIN,
        RANGO_SUELDO_MAX,
        ESTADO_CARGO)
      VALUES
       (CARGO,
       0,
       0,
       'A');
    END IF;
    
    /*Se verifica el area*/
    
    SELECT COUNT(*) 
           INTO TOTAL_AREA
    FROM telconet.admi_area_dat
    WHERE DESCRIPCION_AREA=AREA;
    
    IF TOTAL_AREA = 0 THEN
      /* Si no existe area se obtiene el departamento*/
      SELECT id_departamento INTO DEPT
      FROM telconet.admi_departamento_dat
      where descripcion_departamento=DEPARTAMENTO
      AND ESTADO_DEPARTAMENTO='A'
      limit 1;
      
      IF DEPT is null THEN
        /*Si departamento no existe se inerta*/
        SELECT ID_OFICINA 
               INTO ID_OFI
        FROM telconet.admi_oficina_dat o,
              telconet.admi_ciudad_dat c
        where o.id_ciudad = c.id_ciudad
        and upper(c.nombre_ciudad) =UPPER(CIUDAD)
        LIMIT 1; 
        
        INSERT INTO telconet.admi_departamento_dat
        (ID_OFICINA,
         CODIGO_DEPARTAMENTO,
         DESCRIPCION_DEPARTAMENTO,
         FECHA_CREACION_DEPART,
         ESTADO_DEPARTAMENTO)
         VALUES
         (
           ID_OFI,
           SUBSTR(DEPARTAMENTO,1,4),
           DEPARTAMENTO,
           NOW(),
           'A'
         );
         /*Se obtiene Id_departamento*/
         SELECT LAST_INSERT_ID() INTO DEPT;
      
      END IF;
      INSERT INTO telconet.admi_area_dat
      (ID_DEPARTAMENTO,
       CODIGO_AREA,
       DESCRIPCION_AREA,
       FECHA_CREACION_AREA,
       ESTADO_AREA,
       ID_AREA_GENERAL
      )
      VALUES
      (DEPT,
       SUBSTR(AREA,1,4),
       AREA,
       NOW(),
       'A',
       0 
    );
    END IF;
    
    RETURN 'OK';
END;//

