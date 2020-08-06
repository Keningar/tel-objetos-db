/**
 * ROLLBACK de aumento de carácteres para la columna nombre en tabla ADMI_GRUPO
 * @author Leonardo Espinoza <eespinoza@telconet.ec>
 * @since 09-07-2020
 */
 ALTER TABLE DB_MONITOREO.ADMI_GRUPO MODIFY (NOMBRE VARCHAR2(20));

 /