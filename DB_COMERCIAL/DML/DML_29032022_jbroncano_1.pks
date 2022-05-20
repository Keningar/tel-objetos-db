/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de Rango de visualizacion de saldo para   EL TAMAÑO DE LA LETRA DE LOS DOCUMENTOS DIGITALES
 * VALOR1 = 10(Puntos a visualizar)
 * VALOR2 = 1.33333( valor en pixeles de 1 punto computadora)
 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 29-03-2022 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CONTRATO_DIGITAL_FONT_SIZE','SE PARAMETRIZA EL TAMAÑO DE LA LETRA DE LOS DOCUMENTOS DIGITALES COMO CONTRATO, DOCUMENTO DE TÉRMINOS Y CONDICIONES, ADENDUM DE SERVICIOS DIGITALES, PAGARÉ A LA ORDEN, AUTORIZACIÓN PARA DÉBITO POR CONCEPTO DE PAGO
DEL SERVICIO;   VALOR1: AQUI SE ASINGA EL VALOR EN PUNTO COMPUTADORA PARA EL TAMAÑO DE LETRA ;  VALOR2: VALOR DE 1 PUNTO COMPUTADORA EN PIXEL 1.33333','COMERCIAL'
,'CONTRATO_DIGITAL_TAMANIO_LETRA','Activo','jbroncano',sysdate,'0.0.0.0',null,null,null);
INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CONTRATO_DIGITAL_FONT_SIZE'),
'CONTRATO_DIGITAL','10','1.33333',NULL,NULL,'Activo','jbroncano',sysdate,'0.0.0.0',null,null,null,null,'18',null,null,null);

update DB_GENERAL.admi_parametro_det
set valor1 = null,
valor2 ='ver-08 | Dic-2021'
where parametro_id= 1645 and ID_PARAMETRO_DET=21111; 


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DOC_VERSION_CONTRATO_DIGITAL'),
'terminosCondicionesMegadatos',NULL,'ver-07 | Ene-2021',NULL,NULL,'Activo','jbroncano',sysdate,'0.0.0.0',null,null,null,null,'18',null,null,null);


COMMIT;

/  
