/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para eliminar directorio en NFS donde se almacenarían archivos de Portal Cautivo
 * @author Ivan Mata <imata@telconet.ec>
 * @version 1.0
 * @since 02-03-2023
 */

begin

  delete from DB_GENERAL.ADMI_GESTION_DIRECTORIOS 
  where aplicacion = 'PortalCautivo'
  and pais = '593'
  and empresa = 'TN'
  and modulo = 'Tecnico'
  and submodulo = 'Archivos'
  and estado = 'Activo'
  and usr_creacion = 'imata';

  commit;

end;

/
