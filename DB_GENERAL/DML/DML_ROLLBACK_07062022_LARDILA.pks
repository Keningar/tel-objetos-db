
/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para eliminar directorio en NFS donde se almacenarían archivos de Calculadora
 * @author David De La Cruz <lardila@telconet.ec>
 * @version 1.0
 * @since 27-09-2021
 */

begin

  delete from DB_GENERAL.ADMI_GESTION_DIRECTORIOS 
  where aplicacion = 'Calculadora'
  and pais = '593'
  and empresa = 'TN'
  and modulo = 'Inspecciones'
  and submodulo = 'Archivos'
  and estado = 'Activo'
  and usr_creacion = 'lardila';

  commit;

end;

/
