/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Se elimina parametro creado
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'CRC_FECHA_REENVIO_CORREO_RESUMEN';
delete from DB_GENERAL.admi_parametro_cab  WHERE nombre_parametro = 'CRC_FECHA_REENVIO_CORREO';

/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Se elimina parametro creado
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */

delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'TERMINOS_Y_CONDICIONES';
delete from DB_GENERAL.admi_parametro_cab  WHERE nombre_parametro = 'CORREO_RESUMEN_COMPRA_PROM';

/**
* DEBE EJECUTARSE EN DB_GENERAL.
 * Se elimina parametro creado
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'CRC_ESTADOS_PRODUCTOS_INTERVENCION_HUMANA';
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'CRC_ESTADOS_PRODUCTOS_ACTIVOS';
delete from DB_GENERAL.admi_parametro_cab  WHERE nombre_parametro = 'CRC_ESTADOS_PRODUCTOS_ADICIONALES';

/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Se elimina directorio creado
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 28-06-2022 - Versión Inicial.
 */
DELETE from db_general.ADMI_GESTION_DIRECTORIOS GD where GD.APLICACION='ResumenCompra' and GD.empresa='MD'
AND GD.MODULO='Comercial' AND GD.submodulo='DocResumenCompra'; 
/