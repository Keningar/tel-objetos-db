/*
* Documentación para registraAdmiEmpleadoDat
  * Funcion que inserta o actualiza empleado
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 20/01/2022
*/

DELIMITER //
DROP FUNCTION IF exists telconet.registraAdmiEmpleadoDat//
CREATE FUNCTION telconet.registraAdmiEmpleadoDat(TIPO_IDENT VARCHAR(2),
                                                 IDENTIFICACION VARCHAR(15),
                                                 CARGO VARCHAR(100),
                                                 NOMBRES VARCHAR(100),
                                                 APELLIDOS VARCHAR(100),
                                                 LOGIN VARCHAR(20),
                                                 CLAVE VARCHAR(100),
                                                 FECHA_NACIMIENTO DATE,
                                                 EMAIL VARCHAR(50),
                                                 EMAIL_ALTERNO VARCHAR(50),
                                                 ESTADO_CIVIL VARCHAR(1),
                                                 FECHA_INGRESO DATE,
                                                 GENERO VARCHAR(1),
                                                 ESTADO VARCHAR(1),
                                                 AREA VARCHAR(50)) RETURNS VARCHAR(10)
BEGIN
    DECLARE EXISTE INT;
    select count(*) into EXISTE
    from admi_empleado_dat
    WHERE identificacion_empleado = IDENTIFICACION;
    IF EXISTE = 0 THEN
    
    Insert into admi_empleado_dat
    (id_tipo_identificacion,
     id_cargo_empleado,
     identificacion_empleado,
     nombres_empleado,
     apellidos_empleado,
     login_empleado,
     password_empleado,
     fecha_nacimiento_empleado,
     email_empleado,
     email_alterno_empleado,
     estado_empleado,
     fecha_creacion_empleado,
     aporta_iess,
     numero_seguro_social,
     estado_civil,
     sueldo,
     fecha_ingreso_empl,
     genero,
     es_vendedor,
     es_vip,
     id_oficina_extra)
     values
     ((select id_tipo_identificacion FROM telconet.admi_tipo_identificacion_dat 
       where abrevia_tipo_identificacion=TIPO_IDENT limit 1),
     (select id_cargo_empleado from telconet.admi_cargos_empleado_dat  
      where descripcion_cargo=CARGO limit 1),
      IDENTIFICACION,
      NOMBRES,
      APELLIDOS,
      LOGIN,
      CLAVE,
      FECHA_NACIMIENTO,
      EMAIL,
      EMAIL_ALTERNO,
      ESTADO,
     NOW(),
     'S',
     0,
     ESTADO_CIVIL,
     0,
     FECHA_INGRESO,
     GENERO,
     'N',
     'N',
     0
     );
     
     Insert Into telconet.admi_empleado_area_dat
     (id_empleado,
      id_area)
     values
     ((select id_empleado from telconet.admi_empleado_dat where identificacion_empleado=IDENTIFICACION),
     (select id_area from telconet.admi_area_dat where descripcion_area=AREA limit 1)
     );
     ELSE
     UPDATE admi_empleado_dat
     SET id_tipo_identificacion = (select id_tipo_identificacion FROM telconet.admi_tipo_identificacion_dat 
                                   where abrevia_tipo_identificacion=TIPO_IDENT limit 1),
         id_cargo_empleado =(select id_cargo_empleado from telconet.admi_cargos_empleado_dat  
                         where descripcion_cargo=CARGO limit 1),
         nombres_empleado = NOMBRES,
         apellidos_empleado = APELLIDOS,
         login_empleado = LOGIN,
         password_empleado = LOGIN,
         fecha_nacimiento_empleado = FECHA_NACIMIENTO,
         email_empleado = EMAIL,
         email_alterno_empleado = EMAIL_ALTERNO,
         estado_empleado = ESTADO,
         estado_civil = ESTADO_CIVIL,
         fecha_ingreso_empl = FECHA_INGRESO,
         genero = GENERO
     WHERE identificacion_empleado = IDENTIFICACION;
     
    UPDATE telconet.admi_empleado_area_dat
    SET id_area=(select id_area from telconet.admi_area_dat where descripcion_area=AREA limit 1)
    WHERE id_empleado=(select id_empleado from telconet.admi_empleado_dat where identificacion_empleado=IDENTIFICACION);
     END IF;
     RETURN 'OK';
END;//
