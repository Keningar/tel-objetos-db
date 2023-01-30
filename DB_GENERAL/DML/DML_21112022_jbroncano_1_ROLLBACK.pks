/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * ROLLBACK VARIABLE DE VELOCIDAD COMERCIAL EN CREACIÓN DE PLANES
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 21-11-2022 - Versión Inicial.
 */
 
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'VELOCIDAD_MAXIMA';
delete from DB_GENERAL.admi_parametro_det  WHERE DESCRIPCION = 'VELOCIDAD_MINIMA';
delete from DB_GENERAL.admi_parametro_cab  WHERE nombre_parametro = 'VARIABLES_VELOCIDAD_PLANES';
COMMIT;

/