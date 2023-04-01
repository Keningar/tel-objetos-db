
/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametros para el movil Comercial
 * @author Carlos Caguana<ccaguana@telconet.ec>
 */

UPDATE
            DB_GENERAL.admi_parametro_det 
           SET EMPRESA_COD=NULL,
           VALOR1='Ud. no posee perfil valido para el acceso a TM Comercial'
           WHERE DESCRIPCION='RESTRICCION_ACCESO';
     
 UPDATE
            DB_GENERAL.admi_parametro_det 
           SET EMPRESA_COD=NULL,
           VALOR1='Ud. no posee rol de las empresas permitidas en el sistema.'
           WHERE DESCRIPCION='RESTRICCION_NO_EMPLEADO';

COMMIT;
/           