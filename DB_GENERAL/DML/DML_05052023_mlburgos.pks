/** 
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para insertar detalle que permite la version y la fecha del contrato Megadatos Digital Cambio razon Social.
 * @author Leonela Burgos Castro <mlburgos@telconet.ec>
 * @version 1.0 
 * @since 10-04-2023 - Versión Inicial.
 */ 

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR6='FO-VEN-01' , VALOR7 ='ver-10 | Feb-2023' where 
PARAMETRO_ID= (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE TRIM(NOMBRE_PARAMETRO)= TRIM('DOCUMENTOS_CONTRATO_EMPRESA')) 
and descripcion='DOCS_CRS_MS_CONTRATO' AND EMPRESA_COD=18 AND ESTADO='Activo' AND TRIM(VALOR1)='contratoMegadatos' AND VALOR3='POR PUNTO';
COMMIT;