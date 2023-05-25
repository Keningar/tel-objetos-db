/**
 * DEBE EJECUTARSE EN DB_INFRAESTRUCTURA
 * @author Pedro Velez <psvelez@telconet.ec>
 * @version 1.0
 * @since 25-05-2023
 * Script para crear actualizar los procesos de envio de 
 * notificaicones de mantenimiento programado
 */

 update DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB S 
 set S.ESTADO='Finalizado', 
     S.FE_ULT_MOD=sysdate,
     S.USR_ULT_MOD='psvelez'
WHERE S.TIPO_PROCESO= 'CierreCasoMantProgra' 
AND S.ESTADO= 'Pendiente';

commit;

/