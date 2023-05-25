/**
 * DEBE EJECUTARSE EN DB_INFRAESTRUCTURA
 * @author Pedro Velez <psvelez@telconet.ec>
 * @version 1.0
 * @since 25-05-2023
 * Script para reverso de script DML_02052023_psvelez.pks
 */

 update DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB S 
 set S.ESTADO='Pendiente', 
     S.FE_ULT_MOD=sysdate
WHERE S.TIPO_PROCESO= 'CierreCasoMantProgra' 
AND S.USR_ULT_MOD='psvelez'; 

COMMIT;

/