
/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * @author Carlos Caguana<ccaguana@telconet.ec>
 */

UPDATE
            DB_GENERAL.admi_parametro_det 
           SET EMPRESA_COD=18,
           VALOR1='Ud. no cuenta con el perfil de acceso a TM Comercial'
           WHERE DESCRIPCION='RESTRICCION_ACCESO';
     
 UPDATE
            DB_GENERAL.admi_parametro_det 
           SET EMPRESA_COD=18,
           VALOR1='Ud. no posee rol de las empresa Megadatos.'
           WHERE DESCRIPCION='RESTRICCION_NO_EMPLEADO';

COMMIT;
/           