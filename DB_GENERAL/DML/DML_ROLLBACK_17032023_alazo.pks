 /**
  * Documentación para hacer rollback de los detalle parametro  para 
  * la empresa ECUANET.
  *  
  * @author Andre Lazo <alazo@telconet.ec>
  * @version 1.0 17-03-2023
  */

--elimina los detalles del parametro 859 para empresa 33
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID=859 AND EMPRESA_COD=33;

--elimana el detalle de CICLO FACTURACION para la empresa 33
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID=1847 AND EMPRESA_COD=33 AND USR_CREACION='alazo';



COMMIT;
/