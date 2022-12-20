/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear directorio en NFS donde se almacenarán archivos de Calculadora
 * @author Luis Ardila <lardila@telconet.ec>
 * @version 1.0
 * @since 07-06-2022
 */

declare

ln_codigo_app number;

begin

	select max(codigo_app) max_codigo_app
	into ln_codigo_app
	from db_general.admi_gestion_directorios s;


	insert into DB_GENERAL.ADMI_GESTION_DIRECTORIOS (id_gestion_directorio,codigo_app,codigo_path,aplicacion,pais,empresa,modulo,submodulo,
	estado,fe_creacion,fe_ult_mod,usr_creacion,usr_ult_mod)
	values(db_general.seq_admi_gestion_directorios.nextval,ln_codigo_app+1,1,'Calculadora','593','TN','Inspecciones','Archivos',
	'Activo',sysdate,null,'lardila',null);

	commit;

end;

/
