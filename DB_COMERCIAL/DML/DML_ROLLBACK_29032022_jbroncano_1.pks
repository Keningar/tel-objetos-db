/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para proceso de visualizacion de saldo
 * @author Luis Ardila Macias <lardila@telconet.ec>
 * @version 1.0 10-01-2022 - Versión Inicial.
 */
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID IN (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONTRATO_DIGITAL_FONT_SIZE');
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONTRATO_DIGITAL_FONT_SIZE'
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID IN (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_VERSION_CONTRATO_DIGITAL');
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID IN (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_VERSION_CONTRATO_DIGITAL') AND B.DESCRIPCION='terminosCondicionesMegadatos';
update DB_GENERAL.admi_parametro_det
set valor1 = 'ver-08 | Dic-2021',
valor2 = null
where parametro_id= 1645 and ID_PARAMETRO_DET=21111; 

COMMIT;
/

