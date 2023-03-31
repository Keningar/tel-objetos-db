 /**
  * Documentación para Registro  de producto para retiro de equipos y parametro Cambio de moden inmediato
  *para solicitud de facturacion por retiro de equipos
  *  
  * @author Andre Lazo <alazo@telconet.ec>
  * @version 1.0 30-03-2023
  */




--PRODUCTO PARA SOLCITUD DE RETIRO DE EQUIPOS
Insert  into db_comercial.admi_producto (ID_PRODUCTO,EMPRESA_COD,CODIGO_PRODUCTO,DESCRIPCION_PRODUCTO,FUNCION_COSTO,INSTALACION,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION,CTA_CONTABLE_PROD,CTA_CONTABLE_PROD_NC,ES_PREFERENCIA,ES_ENLACE,REQUIERE_PLANIFICACION,REQUIERE_INFO_TECNICA,NOMBRE_TECNICO,CTA_CONTABLE_DESC,TIPO,ES_CONCENTRADOR,FUNCION_PRECIO,SOPORTE_MASIVO,ESTADO_INICIAL,GRUPO,COMISION_VENTA,COMISION_MANTENIMIENTO,USR_GERENTE,CLASIFICACION,REQUIERE_COMISIONAR,SUBGRUPO,LINEA_NEGOCIO,FRECUENCIA,TERMINO_CONDICION) 
values (db_comercial.seq_admi_producto.nextval,'33','SOLCMI','RETIRO DE EQUIPOS',null,'0','Inactivo',sysdate,'alazo','127.0.0.1',null,null,'NO','NO','NO','NO','OTROS',null,'S','NO', EMPTY_CLOB(),null,'Pendiente',null,null,null,null,null,'NO','OTROS','OTROS',null, EMPTY_CLOB());



--PARAMETRO PARA SOLICITUD DE RETIRO DE EQUIPOS
Insert into db_general.admi_parametro_det (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,VALOR3,VALOR4,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,VALOR5,EMPRESA_COD,VALOR6,VALOR7,OBSERVACION,VALOR8,VALOR9) 
values (db_general.seq_admi_parametro_det.nextval,'846','Cambio de módem inmediato','SOLICITUD FACTURACION RETIRO EQUIPO',null,(select id_producto from db_comercial.admi_producto where descripcion_producto ='RETIRO DE EQUIPOS' and empresa_cod = '33'),'Equipos','Activo','alazo',sysdate,'127.0.0.1',null,null,null,'telcos_equipos','33','S',null,null,null,null);


COMMIT;
/
