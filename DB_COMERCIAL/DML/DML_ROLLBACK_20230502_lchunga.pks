/**
 * Rollback de la inserción del parámetro departamento OPU 
 *
 * @author Liseth Chunga <lchunga@telconet.ec>
 *
 * @version 1.0
 * @since 02-05-2023
 */
Delete from db_general.admi_parametro_det
where descripcion = 'dpto_guardar_foto_nfs';
commit;
