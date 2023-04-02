
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET EMPRESA_COD=NULL
WHERE ID_PARAMETRO_DET=28252;


--ESTADO_SERVICIO_MD_CONTRATO
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='ESTADO SERVICIO MD CONTRATO'
AND EMPRESA_COD =33;


---ESTADO_PLAN_CONTRATO
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='ESTADO_PLAN_CONTRATO'
AND EMPRESA_COD =33;




--PRODUCTOS ADICIONALES MANUALES'
        
                    
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='Productos adicionales manuales para activar'
AND EMPRESA_COD =33;


--PRODUCTOS QUE NO SE PLANIFICAN

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='PRODUCTOS QUE NO SE PLANIFICAN'
AND EMPRESA_COD =33;




-----OFICINA VIRTUAL
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='OFICINA ECUANET'
AND EMPRESA_COD =33;


--'VALIDA_PROD_ADICIONAL', 'PROD_ADIC_PLANIFICA'
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION ='Datos Planificacion Producto Adicional'
AND EMPRESA_COD =33;


commit;
/