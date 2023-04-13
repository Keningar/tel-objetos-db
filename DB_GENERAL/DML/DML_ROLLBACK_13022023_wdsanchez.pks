/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para realizar rollback en parametros  microservicios derecho legal proceso descifra datos
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 13-02-2023 - Versión Inicial.
 */


delete from DB_GENERAL.ADMI_PARAMETRO_DET where descripcion = 'DATOS_CORREO_DESCIFRAR';
delete from DB_GENERAL.ADMI_PARAMETRO_DET where descripcion = 'DATOS_LINK';
delete from DB_GENERAL.ADMI_PARAMETRO_DET where descripcion = 'CORREO_DESCIFRA';


COMMIT;


/
     
