 /**
  * Documentación para hacer rollback DEL PARAMETRO PARA SOLICITUD DE RETIRO DE EQUIPOS
  *  
  * @author Andre Lazo <alazo@telconet.ec>
  * @version 1.0 30-03-2023
  */




--DELETE DE INSERCIONES PARA SOLICITUD CAMBIO DE EQUIPOS

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE USR_CREACION='alazo' AND DESCRIPCION='Cambio de módem inmediato' AND PARAMETRO_ID=846 AND EMPRESA_COD=33;



--DELETE RELACION  ADMI_CARACTERISTICA

--DELETE ADMI_PRODUCTO_CARACTERISTICA
DELETE DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
WHERE PRODUCTO_ID = (SELECT ID_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO WHERE DESCRIPCION_PRODUCTO='RETIRO DE EQUIPOS' AND EMPRESA_COD=33 AND ESTADO='Inactivo' AND USR_CREACION='alazo');

--DELETE DEL PRODUCTO

DELETE FROM DB_COMERCIAL.ADMI_PRODUCTO
WHERE DESCRIPCION_PRODUCTO='RETIRO DE EQUIPOS' AND EMPRESA_COD=33 AND ESTADO='Inactivo' AND USR_CREACION='alazo';


COMMIT;
/