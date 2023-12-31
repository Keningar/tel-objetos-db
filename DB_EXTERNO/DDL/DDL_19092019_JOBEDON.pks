/**
 * Script para mejorar costos de consultas de información comercial y tecnica
 * @author José Bedón Sánchez <jobedon@telconet.ec>
 * @version 1.0 19-09-2019 - Versión Inicial.
 */
CREATE UNIQUE INDEX DB_COMERCIAL.IDX_CRM_TELCOS ON DB_COMERCIAL.INFO_PUNTO (ID_PUNTO ASC, LOGIN ASC, DIRECCION ASC, PERSONA_EMPRESA_ROL_ID ASC, PUNTO_COBERTURA_ID ASC, SECTOR_ID ASC, ESTADO DESC)

EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_SERVICIO_HISTORIAL').
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_PUNTO_SALDO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_PERSONA');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_PERSONA_EMPRESA_ROL');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_ROL');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_TIPO_ROL');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_PUNTO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_INFRAESTRUCTURA','ADMI_JURISDICCION');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_SECTOR');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_PARROQUIA');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_CANTON');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_PROVINCIA');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_REGION');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_GENERAL','ADMI_SECTOR');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_SERVICIO');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','INFO_PLAN_DET');
EXEC DBMS_STATS.GATHER_TABLE_STATS('DB_COMERCIAL','ADMI_PRODUCTO');


/
