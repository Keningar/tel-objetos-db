 /**
 * se debe ejecutar en DB_COMUNICACION 
 * Eliminar Plantilla Correo Resumen Compra
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
 delete from DB_COMUNICACION.ADMI_PLANTILLA WHERE CODIGO='CRESUCOMPRA' AND NOMBRE_PLANTILLA='Correo Resumen Compra';
  COMMIT;
 /