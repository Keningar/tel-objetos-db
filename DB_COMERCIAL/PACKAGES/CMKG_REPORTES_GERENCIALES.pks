CREATE OR REPLACE PACKAGE  DB_COMERCIAL.CMKG_REPORTES_GERENCIALES
AS
/**
* Documentación para el procedimiento P_SUBIR_REPORTES_PENDIENTES
* Utiliza el paquete DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE para subir los reportes que estén en estado
* GENERADO o ERROR_SUBIDA. Puede ejecutarse varias veces, pues su único propósito es subir archivos
* pendientes. Cuando uno de estos archivos se sube, NO se emite notificación por correo a gerencia e
* informe. 
* Se usa como redundancia en caso de que se haya presentado un problema de conectividad a Telcodrive.
*/
PROCEDURE P_SUBIR_REPORTES_PENDIENTES;

/**
* Documentación para el procedimiento P_SUBIR_REPORTES_PENDIENTES
* Envía notificación por correo electrónico de la subida de los reportes que estaban en estado
* ERROR_NOTIFICA y SUBIDO. Se usa como redundancia en caso de que se haya presentado un problema
* al notificar por correos.
*/
PROCEDURE P_NOTIFICAR_REP_PENDIENTES;
 /**
  * p_reportComercial, genera archivo CSV con reporte de Gerencia utilizado para el calculo de Comisiones.
  * se encarga de generar el ZIP y enviarlo por correo.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 18-07-2016
  * @since 1.0
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 08-09-2016  
  * Se agrega Campos nuevos al reporte, comision venta, comision mantenimiento, gerente de producto, fecha finalizacion
  * del contrato y tiempo de validez del servicio
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.2 21-09-2016  
  * Se agrega Campos nuevos al reporte:
  * Nombres, telefonos y correos de contactos comerciales.
  * Nombres, telefonos, correos y celulares de todos los demas tipos de contactos registrados
  *
  * @author Alejandro Domínguez Vargas <adominguez@telconet.ec>
  * @version 1.3 26-09-2016
  * Se implementa la generación del Reporte Gerencia Financiero: Facturas y Pago, y se envía por correo de forma independiente al reporte comercial.
  * El rango de fechas del reporte será un mes atrás del día de la generación del mismo, siendo el 21 de cada més el rango será del 21 del mes 
  * anterior al 20 del mes actual.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.4 18-10-2016  
  * Se aumenta tamano del campo p_destinatario que contiene los correos de los destinatarios.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.5 24-10-2016  
  * Se aumenta delimitador (,) para el reporte Financiero Facturas y Pagos
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.6 19-12-2016  
  * Se solicita anadir a los reportes Comercial y Financiero la fecha de ejecucion y se requiere validar desde que ambiente se esta ejecutando 
  * en el servidor, se agregan registros a nivel de Tabla Parameter para definir las IPs de produccion y poder determinar el ambiente del cual 
  * se obtuvo el reporte.(Produccion/Desarrollo)
  * Se requiere que en los correos que se envian se especifique de que ambiente se ejecuto.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.7 20-12-2016  
  * Se corrige la manera de obtener la IP del Servidor de Produccion.
  * Se solicita que se Valide el envio de los correos con los CSV (Comercial y Financiero) solo si la ejecucion es de un ambiente de Produccion.
  * Se solicita que se agregue el envio de un nuevo correo con un resumen o informe Tecnicio de la ejecucion del Reporte de Gerencia en este correo
  * debe constar la notificacion de la ejecucion del Reporte de Gerencia, la IP del servidor de ejecucion, descripcion del ambiente de ejecucion,
  * (Desarrollo y Produccion) y debe ser enviado al correo notificaciones_telcos@telconet.ec y correo internos de sistemas para su revision.
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.8 12-01-2017
  * Segun la reunion de Directorio se solicita agregar la columna ES_CONCENTRADOR al reporte Comercial.   
  * Se solicita correccion en cuanto a la presentacion de la CAPACIDAD 
  * ya que actualmente se esta guardando esta informacion duplicada en Telcos y se requiere mostrar el mayor registro.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.9 17-01-2017
  * Se solicita aumentar en el reporte Comercial los siguientes campos:
  * Tipo Enlace: Campo que identifica si es enlace Principal o Backup
  * Descripcion Producto: Campo que define el nombre o descripcion del producto, se pide condicionar para los concentrados de la siguiente manera:
  * Si TIPO_ENLACE = PRINCIPAL
  *    ES_CONCENTRADOR = 'SI' y ES_VENTA = 'SI' --> DESCRIPCION = DESCRIPCION_PRODUCTO + TIPO_ENLACE + 'Pagado'
  *    ES_CONCENTRADOR = 'SI' y ES_VENTA = 'NO' --> DESCRIPCION = DESCRIPCION_PRODUCTO + TIPO_ENLACE
  * Si TIPO_ENLACE = BACKUP
  *    ES_CONCENTRADOR = 'SI' y ES_VENTA = 'SI' --> DESCRIPCION = DESCRIPCION_PRODUCTO + TIPO_ENLACE + 'Pagado'
  *    ES_CONCENTRADOR = 'SI' y ES_VENTA = 'NO' --> DESCRIPCION = DESCRIPCION_PRODUCTO + TIPO_ENLACE
  *
  * Campo Nombre de Usuario que Autorizo Solicitud de Descuento sea en Telcos o en SIT
  * Campo Fecha de Autorizacion de Solicitud de Descuento sea en telcos o en SIT
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 2.0 05-05-2017
  * Se agregan en el reporte de Gerencia Comercial las columnas que contendran la Plantilla de Comisionistas existente para el servicio,
  * esta informacion se debe cotejar con el grupo de roles de la siguiente manera "ROL | NOMBRE PERSONA | %COMISIÓN"
  * El Valor de Comision que se presenta sera la COMISION_MANTENIMIENTO,  de no existir sera la COMISION_VENTA.
  * Se agregan correcciones en sql, se agrega casteo a numero, dado que el campo valor es string, caso contrario se genera un error
  * ORA-01722: invalid number. Error fue solventado en el paquete pero no fue versionado, se agrega correccion.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 2.1 17-11-2017     -  Se agrega el campo IDENTIFICACION_CLIENTE al query del Reporte Comercial y se escribe en el reporte.
  *                                Se escribe en la tabla de error.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 2.2 23-09-2020
  * Se agrega columna al reporte LOGIN del Punto.
  *
  * @author Kevin Baque Puya <kbaque@telconet.ec>
  * @version 2.3 19-11-2020 - Se agrega la columna línea de negocio.
  *
  * @author Bryan Fonseca <bfonseca@telconet.ec>
  * @version 2.4 28-11-2022 - Se agrega interacción con Telcodrive para subir los reportes en vez de enviarlos por correo.
  *
  * @param cod_ret in out number,
  * @param msg_ret in out varchar2,  
  *
  */
procedure p_reportComercial(cod_ret  out number, msg_ret  out varchar2) ;

Lv_FechaReporte VARCHAR2(20):=TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');    
Lv_IpCreacion VARCHAR2(16) :=UTL_INADDR.get_host_address;
Lv_DestinatarioInforme VARCHAR2(150);
l_prefijo_empresa varchar2(2) :='TN';
p_archivo utl_file.file_type;
p_directorio varchar2(50):='DIR_REPGERENCIA';
p_delimitador varchar2(1):=';';
p_delimitador_fact varchar2(1):=',';
p_remitente varchar2(28):='dba@telconet.ec';
p_destinatario varchar2(150);

--Bloque Definición de variables para generación del reporte gerencia finaciero de Facturas y Pagos.
p_archivoFinanciero          utl_file.file_type;
--Fin del bloque

END CMKG_REPORTES_GERENCIALES;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REPORTES_GERENCIALES AS

FUNCTION F_GET_PARAMETRO(p_cabecera VARCHAR2, p_descripcion VARCHAR2) RETURN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE
AS
	detalleParametroRow DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
BEGIN
	SELECT apd.* INTO detalleParametroRow
	FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc 
		INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET apd ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
	WHERE apc.NOMBRE_PARAMETRO = p_cabecera
	AND apd.DESCRIPCION = p_descripcion;
	RETURN detalleParametroRow;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR(-20007, 'No se encontró el parámetro ' || p_descripcion || '.');
END;

-- Tipos: EMAIL_NOTIFICACION, EMAIL_GERENCIA
FUNCTION F_GET_CORREOS(p_tipo_correo VARCHAR2) RETURN VARCHAR2 AS
	Lv_correos VARCHAR2(256);
BEGIN
	SELECT LISTAGG(apd.VALOR1, ',') WITHIN GROUP (ORDER BY apd.VALOR1) INTO Lv_correos
	FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc 
		INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET apd ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
	WHERE apc.NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
	AND apd.DESCRIPCION = p_tipo_correo;
	
	IF Lv_correos IS NULL THEN
		RAISE NO_DATA_FOUND;
	END IF;
	
	RETURN Lv_correos;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
								 'DB_COMERCIAL.JOB_REPGER_REPORTCOMERCIAL',  
								 'No existen correos ' || p_tipo_correo || ' en tabla de parámetros: ' || SQLCODE || ' -ERROR_STACK: '
								 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
								 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
								 SYSDATE, 
								 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
END;

PROCEDURE F_NOTIFICAR_SUBIDA(p_token VARCHAR2, p_nombre_repo VARCHAR2, p_nombre_archivo VARCHAR2, p_path_telcodrive VARCHAR2) AS
	Lv_destinatarios VARCHAR2(256) := F_GET_CORREOS('EMAIL_GERENCIA');
BEGIN
	DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE.P_NOTIFICAR_SUBIDA(p_token => p_token, 
														 p_nombre_repo => p_nombre_repo, 
														 p_path_archivo => p_path_telcodrive || p_nombre_archivo,
														 p_destinatarios => Lv_destinatarios);
	-- Se registra que se notificó										  
	UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET ESTADO = 'NOTIFICADO' WHERE DESCRIPCION = p_nombre_archivo;
	COMMIT;	
EXCEPTION
	WHEN OTHERS THEN
	UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET ESTADO = 'ERROR_NOTIFICA' WHERE DESCRIPCION = p_nombre_archivo;
	COMMIT;	
	DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
										 'DB_COMERCIAL.JOB_REPGER_REPORTCOMERCIAL',  
										 'Error al notificar reportes: ' || SQLCODE || ' - ERROR_STACK: ' 
										 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
										 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
										 SYSDATE, 
										 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
END;

PROCEDURE P_SUBIR_REPORTE(p_token VARCHAR2, p_nombre_archivo VARCHAR2, p_nombre_repo VARCHAR2, p_path_telcodrive VARCHAR2) AS
	res CLOB;
BEGIN
	res := DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE.F_UPLOAD_FILE(p_token, 
														   p_directorio, 
														   p_nombre_archivo,
														   p_nombre_repo,
														   p_path_telcodrive);
	-- Se registra que se subió										  
	UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET ESTADO = 'SUBIDO' WHERE DESCRIPCION = p_nombre_archivo;
	COMMIT;	
	
EXCEPTION
	WHEN OTHERS THEN
		UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET ESTADO = 'ERROR_SUBIDA' WHERE DESCRIPCION = p_nombre_archivo;
		COMMIT;	
		DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
								 'DB_COMERCIAL.JOB_REPGER_REPORTCOMERCIAL',  
								 'Error al subir reporte: ' || SQLCODE || ' -ERROR_STACK: '
								 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
								 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
								 SYSDATE, 
								 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
END;

PROCEDURE P_NOTIFICAR_REP_PENDIENTES IS
	Lv_user VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'USER').VALOR1;
	Lv_password VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'PASSWORD').VALOR1;
	Lv_nombre_repo VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'NOMBRE_REPO').VALOR1;
	TOKEN_TELCODRIVE VARCHAR2(128);
	Lv_path_telcodrive VARCHAR2(128);
	
	CURSOR C_NO_NOTIFICADOS IS 
		SELECT apd.DESCRIPCION NOMBRE_REPORTE, apd.VALOR1 DIA, apd.VALOR2 MES, apd.VALOR3 ANIO 
		FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
		INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc ON apc.ID_PARAMETRO = apd.PARAMETRO_ID
		WHERE apc.NOMBRE_PARAMETRO = 'REPORTES_GENERADOS' AND apd.ESTADO IN ('ERROR_NOTIFICA', 'SUBIDO')
		ORDER BY apd.FE_CREACION DESC;	
BEGIN
	TOKEN_TELCODRIVE := DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE.F_AUTHENTICATION(Lv_user, Lv_password);
	FOR NO_NOTIFICADO IN C_NO_NOTIFICADOS LOOP
		-- Se construye el nombre del directorio en Telcodrive donde se subirá el reporte
		-- El path luce /2022/diciembre
		Lv_path_telcodrive := '/' || NO_NOTIFICADO.ANIO || '/' ||  TRIM(LOWER(TO_CHAR(TO_DATE(NO_NOTIFICADO.MES, 'MM'), 'MONTH',  'NLS_DATE_LANGUAGE = spanish'))) || '/';																	   
		F_NOTIFICAR_SUBIDA(p_token 			  	=> TOKEN_TELCODRIVE,
						   p_nombre_archivo     => NO_NOTIFICADO.NOMBRE_REPORTE, 
						   p_nombre_repo 		=> Lv_nombre_repo, 
						   p_path_telcodrive    => Lv_path_telcodrive);
	END LOOP; 	
END;

PROCEDURE P_SUBIR_REPORTES_PENDIENTES IS
	Lv_user VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'USER').VALOR1;
	Lv_password VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'PASSWORD').VALOR1;
	Lv_nombre_repo VARCHAR2(128) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'NOMBRE_REPO').VALOR1;
	Lv_destinatarios VARCHAR2(256) := F_GET_CORREOS('EMAIL_GERENCIA');
	TOKEN_TELCODRIVE VARCHAR2(128);
	Lv_path_telcodrive VARCHAR2(128);
	res CLOB;
	
	CURSOR C_NO_SUBIDOS IS 
		SELECT apd.DESCRIPCION NOMBRE_REPORTE, apd.VALOR1 DIA, apd.VALOR2 MES, apd.VALOR3 ANIO 
		FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
		INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc ON apc.ID_PARAMETRO = apd.PARAMETRO_ID
		WHERE apc.NOMBRE_PARAMETRO = 'REPORTES_GENERADOS' AND apd.ESTADO IN ('ERROR_SUBIDA', 'GENERADO')
		ORDER BY apd.FE_CREACION DESC;	
BEGIN
	TOKEN_TELCODRIVE := DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE.F_AUTHENTICATION(Lv_user, Lv_password);
	
	FOR i IN (SELECT trim(regexp_substr(Lv_destinatarios, '[^,]+', 1, LEVEL)) correo
		FROM dual CONNECT BY LEVEL <= regexp_count(Lv_destinatarios, ',') + 1)
	LOOP
		BEGIN
			res := DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE.F_SHARE_TO_USER(TOKEN_TELCODRIVE, Lv_nombre_repo, i.correo);
		EXCEPTION
			WHEN OTHERS THEN
				DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
							 'DB_COMERCIAL.CMKG_REPORTES_GERENCIALES.P_SUBIR_REPORTES_PENDIENTES',  
							 'Error al compartir repositorio: ' || SQLCODE || ' -ERROR_STACK: '
							 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
							 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
							 SYSDATE, 
							 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
		END;		
	END LOOP;
	
	FOR NO_SUBIDO IN C_NO_SUBIDOS LOOP
		-- Se construye el nombre del directorio en Telcodrive donde se subirá el reporte
		-- El path luce /2022/diciembre
		Lv_path_telcodrive := '/' || NO_SUBIDO.ANIO || '/' ||  TRIM(LOWER(TO_CHAR(TO_DATE(NO_SUBIDO.MES, 'MM'), 'MONTH',  'NLS_DATE_LANGUAGE = spanish'))) || '/';																	   
		P_SUBIR_REPORTE(p_token 			=> TOKEN_TELCODRIVE,
						p_nombre_archivo    => NO_SUBIDO.NOMBRE_REPORTE, 
						p_nombre_repo 		=> Lv_nombre_repo, 
						p_path_telcodrive   => Lv_path_telcodrive);
	END LOOP; 
END;

procedure p_reportComercial(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    Lv_nameProcedure varchar2(60) := 'CMKG_REPORTES_GERENCIALES.p_reportComercial';
    Lv_IdentMunicipio VARCHAR2(15) := F_GET_PARAMETRO('REPORTES_GERENCIALES', 'IDENT_MUNICIPIO').VALOR1;
   /********************************************************
   * Query para obtener informacion para reporte Comercial
   *********************************************************/    
  cursor lc_reporteComercial is
  select  pto.id_punto,per.id_persona,pemprol.id_persona_rol,
    (CASE 
    WHEN serv.LOGIN_AUX='' or serv.LOGIN_AUX is null
          THEN pto.login  
    ELSE
               serv.LOGIN_AUX
          END) AS login_cliente ,       
        um.NOMBRE_TIPO_MEDIO as ultima_milla,
         elem.NOMBRE_ELEMENTO as switches,
        intelem.NOMBRE_INTERFACE_ELEMENTO as puerto,        
     (CASE 
      WHEN ptofact.login!=pto.login  
          THEN  ptofact.login
      ELSE
              ''
          END) AS login_padreFact,       
        tnego.NOMBRE_TIPO_NEGOCIO as tipo_negocio,
        serv.precio_venta as precio_venta_servicio,
       serv.usr_vendedor,                  
       per.NOMBRES as nombre_cliente,per.APELLIDOS as apellidos_cliente,
       per.RAZON_SOCIAL as razon_social_cliente,
       TRANSLATE(pto.DIRECCION,',',' ') as direccion_punto,
       cant.NOMBRE_CANTON AS sitio_entrega,
       prod.grupo,
       prod.subgrupo,
       prod.linea_negocio,
       serv.estado,
       ofi.nombre_oficina,        
     (CASE 
      WHEN serv.ES_VENTA='S'  
          THEN  'Venta'
      ELSE
              'Cortesia'
          END) AS es_venta,
          serv.FRECUENCIA_PRODUCTO,
          serv.cantidad,
          per.PAGA_IVA, 
          serv.VALOR_DESCUENTO,               
          moelem.nombre_modelo_elemento as modelo_elemento,
          marcelem.nombre_marca_elemento as marca_elemento,
      (CASE 
      WHEN serv.TIPO_ORDEN='N'  
          THEN  'Nueva'
      WHEN serv.TIPO_ORDEN='T' 
          THEN 'Traslado' 
      WHEN serv.TIPO_ORDEN='R' 
          THEN 'Reubicacion'     
      ELSE
          'Nueva'
      END) AS tipo_de_orden,
      serv.id_servicio,
      pemprol.ES_PREPAGO,
      prod.COMISION_VENTA,
      prod.COMISION_MANTENIMIENTO,
      prod.USR_GERENTE,
      (CASE 
       WHEN prod.ES_CONCENTRADOR='SI'
       THEN 'SI'
       ELSE 'NO'
       END) AS LV_CONCENTRADOR,
       servt.TIPO_ENLACE,
       prod.DESCRIPCION_PRODUCTO,
       serv.REF_SERVICIO_ID,
       PER.IDENTIFICACION_CLIENTE,
       PTO.LOGIN AS LOGIN_PUNTO
        --Saco Informacion de la persona Cliente de TN y su Rol de Cliente o Pre-Cliente
        from db_comercial.info_persona per 
        join db_comercial.info_persona_empresa_rol pemprol on per.id_persona=pemprol.persona_id  
        join info_oficina_grupo ofi on pemprol.OFICINA_ID=ofi.id_oficina
        join db_comercial.info_empresa_rol emprol on pemprol.empresa_rol_id=emprol.id_empresa_rol 
        join db_comercial.info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa and empgrup.PREFIJO=l_prefijo_empresa 
        join db_general.admi_rol rol on emprol.ROL_ID=rol.ID_ROL 
        join db_general.ADMI_TIPO_ROL trol on rol.TIPO_ROL_ID=trol.ID_TIPO_ROL and trol.DESCRIPCION_TIPO_ROL in ('Cliente','Pre-cliente')
        --Saco Punto Login 
        join db_comercial.info_punto pto on pemprol.ID_PERSONA_ROL=pto.PERSONA_EMPRESA_ROL_ID   
        --Saco Tipo negocio
        join db_comercial.admi_tipo_negocio tnego on pto.TIPO_NEGOCIO_ID=tnego.ID_TIPO_NEGOCIO        
        --Saco informacion Adicional como si es Punto de Facturacion
        left join db_comercial.info_punto_dato_adicional ptoad on pto.ID_PUNTO=ptoad.PUNTO_ID     
        --Saco Servicio del Login 
        join db_comercial.info_servicio serv on  pto.id_punto=serv.PUNTO_ID 
        and serv.estado not in ('migracion_ttco','Anulado','AnuladoMigra','Eliminado','MigradoOnnet','Rechazada','Eliminado-Migra') 
        --Saco Nombre tecnico del producto
        join ADMI_PRODUCTO prod on serv.producto_id=prod.id_producto
        --Saco Padre de Facturacion por servicio
        left join db_comercial.info_punto ptofact on serv.PUNTO_FACTURACION_ID=ptofact.id_punto
        --Se hace left join porque los VSAT no tienen UM y hay servicio que no poseen registro en INFO_SERVICIO_TECNICO
        left join db_comercial.INFO_SERVICIO_TECNICO servt on serv.id_servicio=servt.SERVICIO_ID
        --Saco UM
        left join DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO um on servt.ULTIMA_MILLA_ID=um.ID_TIPO_MEDIO
        --Saco elemento o SW
        left join DB_INFRAESTRUCTURA.INFO_ELEMENTO elem on servt.elemento_id=elem.ID_ELEMENTO
        --Saco modelo y marca de Elemento
        left join DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO moelem on elem.MODELO_ELEMENTO_ID=moelem.ID_MODELO_ELEMENTO
        left join DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO marcelem on moelem.MARCA_ELEMENTO_ID=marcelem.ID_MARCA_ELEMENTO
        --Saco puerto
        left join DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO intelem on servt.INTERFACE_ELEMENTO_ID=intelem.ID_INTERFACE_ELEMENTO

        --Saco Sitio Entrega Equivalente Ciudad del cliente
        join DB_GENERAL.ADMI_SECTOR sec on pto.sector_id=sec.id_sector
        join DB_GENERAL.ADMI_PARROQUIA parr on sec.parroquia_id=parr.id_parroquia
        join DB_GENERAL.ADMI_CANTON cant on parr.canton_id=cant.id_canton
       ;                    
       --Cursor Obtiene BW del servicio
       CURSOR C_GetAnchoBanda(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, Cv_Estado VARCHAR2) IS
          SELECT SERVPC.ID_SERVICIO_PROD_CARACT,
            SERVPC.SERVICIO_ID,
            CARAC.DESCRIPCION_CARACTERISTICA,
            SERVPC.VALOR,
            SERVPC.ESTADO,
            SERVPC.FE_CREACION,
            SERVPC.FE_ULT_MOD 
          FROM 
          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SERVPC 
          JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PRODC ON SERVPC.PRODUCTO_CARACTERISITICA_ID = PRODC.ID_PRODUCTO_CARACTERISITICA
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON PRODC.CARACTERISTICA_ID = CARAC.ID_CARACTERISTICA
          WHERE  CARAC.DESCRIPCION_CARACTERISTICA ='CAPACIDAD1' 
          AND SERVPC.ESTADO                       = Cv_Estado
          AND SERVPC.SERVICIO_ID                  = Cn_IdServicio 
          AND SERVPC.ID_SERVICIO_PROD_CARACT IN 
          (SELECT MAX(SERVPC.ID_SERVICIO_PROD_CARACT)
            FROM   
            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SERVPC 
            JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PRODC ON SERVPC.PRODUCTO_CARACTERISITICA_ID = PRODC.ID_PRODUCTO_CARACTERISITICA
            JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON PRODC.CARACTERISTICA_ID = CARAC.ID_CARACTERISTICA
            WHERE  CARAC.DESCRIPCION_CARACTERISTICA = 'CAPACIDAD1'
            AND SERVPC.ESTADO                       = Cv_Estado
            AND SERVPC.SERVICIO_ID                  = Cn_IdServicio 
          );
       Lr_GetAnchoBanda C_GetAnchoBanda%ROWTYPE;

       --Saco fecha Fin de Contrato.
       Cursor lc_obtieneFeFinContrato(c_id_persona_rol number) is
       SELECT cont.FE_FIN_CONTRATO FROM DB_COMERCIAL.INFO_CONTRATO cont
         JOIN INFO_PERSONA_EMPRESA_ROL pemprol on cont.PERSONA_EMPRESA_ROL_ID=pemprol.ID_PERSONA_ROL
         JOIN INFO_PERSONA per on pemprol.PERSONA_ID=per.id_persona
       where per.IDENTIFICACION_CLIENTE=Lv_IdentMunicipio and pemprol.ID_PERSONA_ROL=c_id_persona_rol
        and cont.estado not in ('Anulado','Rechazado') and ROWNUM=1;
        lr_obtieneFeFinContrato lc_obtieneFeFinContrato%ROWTYPE;

       --Saco Tiempo de Validez del servicio en dias
        Cursor lc_obtieneTiempoValidezServ(c_fecha_fin_contrato TIMESTAMP,c_fecha_activacion TIMESTAMP) is
              select EXTRACT (DAY FROM (c_fecha_fin_contrato-c_fecha_activacion)) as tiempo
              from dual;
        lr_obtieneTiempoValidezServ lc_obtieneTiempoValidezServ%ROWTYPE;      

      --Cursor saca Ingenieros VIP (Verificar si se manda solo 1 Ing VIP, Existen clientes con mas de 1 Ing VIP ejemplo id_persona_rol=662548)
      cursor lc_obtieneIngVip(c_id_persona_rol number) is
         select  pemprolc.valor,pervip.NOMBRES || ' ' || pervip.APELLIDOS as nombre_ingvip , perfc.VALOR as correo
            from INFO_PERSONA_EMPRESA_ROL_CARAC pemprolc
               join ADMI_CARACTERISTICA carac on pemprolc.CARACTERISTICA_ID=carac.ID_CARACTERISTICA
               JOIN INFO_PERSONA_EMPRESA_ROL peremprolvip on COALESCE(TO_NUMBER(REGEXP_SUBSTR(pemprolc.valor,'^\d+')),0)=peremprolvip.ID_PERSONA_ROL
               join info_persona pervip on (peremprolvip.PERSONA_ID)=(pervip.ID_PERSONA)
               join INFO_PERSONA_FORMA_CONTACTO perfc on pervip.ID_PERSONA=perfc.PERSONA_ID 
               join ADMI_FORMA_CONTACTO fc on perfc.FORMA_CONTACTO_ID=fc.ID_FORMA_CONTACTO 
             where              
               carac.DESCRIPCION_CARACTERISTICA='ID_VIP' and fc.DESCRIPCION_FORMA_CONTACTO='Correo Electronico'
               and pemprolc.PERSONA_EMPRESA_ROL_ID =c_id_persona_rol and ROWNUM=1;

       lr_obtieneIngVip lc_obtieneIngVip%ROWTYPE;

       --Vendedor
       cursor lc_obtieneVendedor(c_usr_vendedor varchar2) is
         select perv.NOMBRES || ' ' || perv.APELLIDOS as nombre_vendedor 
             from db_comercial.INFO_PERSONA perv 
              where perv.login=c_usr_vendedor and ROWNUM=1;

       lr_obtieneVendedor lc_obtieneVendedor%ROWTYPE;

       --Obtiene Forma de Pago del Contrato que son Canjes.       
       cursor lc_obtieneContratoCanje(c_id_persona_rol number) is
         select fp.DESCRIPCION_FORMA_PAGO as canje
             from db_comercial.INFO_CONTRATO cont,admi_forma_pago fp 
              where  cont.persona_empresa_rol_id=c_id_persona_rol AND fp.DESCRIPCION_FORMA_PAGO='CANJE' and
              cont.forma_pago_id=fp.id_forma_pago AND cont.estado not in ('Anulado','Rechazado') and 
              ROWNUM=1;

       lr_obtieneContratoCanje lc_obtieneContratoCanje%ROWTYPE;

       --Obtiene si Login tiene caracteristica es Canje
       cursor lc_obtienePuntoCanje(c_id_punto number)
       is
         SELECT pto.ID_PUNTO, 
           pto.LOGIN, 
           ptoc.valor AS es_canje
         FROM INFO_PUNTO pto
           JOIN INFO_PUNTO_CARACTERISTICA ptoc ON pto.ID_PUNTO = ptoc.PUNTO_ID             
           JOIN ADMI_CARACTERISTICA carac ON ptoc.CARACTERISTICA_ID = carac.ID_CARACTERISTICA           
         WHERE ptoc.punto_id = c_id_punto 
         AND ptoc.estado                      = 'Activo' 
         AND carac.DESCRIPCION_CARACTERISTICA = 'CANJE'
         AND ROWNUM                           = 1;

       lr_obtienePuntoCanje lc_obtienePuntoCanje%ROWTYPE;

       --Cursor saca Formas de Contacto Telefono Fijo por Persona 
       cursor lc_obtenerFormaContactoPersona(c_formacontacto varchar2, c_id_persona number) is
      select perfc.valor as forma_contacto from INFO_PERSONA_FORMA_CONTACTO perfc
        join ADMI_FORMA_CONTACTO fc on perfc.FORMA_CONTACTO_ID=fc.ID_FORMA_CONTACTO 
      where              
        fc.DESCRIPCION_FORMA_CONTACTO=c_formacontacto --Telefono Fijo
        and perfc.estado='Activo'
        and perfc.PERSONA_ID=c_id_persona;

     --Cursor que obtiene 1 registro de Forma de Contacto especifica por tipo de Contacto para un Punto o Login especifico
     cursor lc_obtieneContacto(c_id_punto number, c_descripcion_contacto varchar2, c_formacontacto varchar2) is
     SELECT punto.LOGIN, 
      contacto.ID_PERSONA,contacto.NOMBRES,contacto.APELLIDOS,contacto.IDENTIFICACION_CLIENTE,contacto.RAZON_SOCIAL,
      prolContacto.ID_PERSONA_ROL,emprolContacto.EMPRESA_COD,descripcion_rol,perfc.VALOR as forma_contacto
      from
      DB_COMERCIAL.INFO_PUNTO_CONTACTO ptoContacto,
      DB_COMERCIAL.info_punto punto,
      DB_COMERCIAL.INFO_PERSONA contacto,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL prolContacto,
      DB_COMERCIAL.INFO_EMPRESA_ROL emprolContacto,
      DB_GENERAL.ADMI_ROL rolContacto,
      DB_GENERAL.ADMI_TIPO_ROL trolContacto,
      DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO perfc,
      DB_COMERCIAL.ADMI_FORMA_CONTACTO fc
      where ptoContacto.PUNTO_ID=punto.ID_PUNTO
      and ptoContacto.CONTACTO_ID=contacto.ID_PERSONA
      and ptoContacto.PERSONA_EMPRESA_ROL_ID=prolContacto.ID_PERSONA_ROL
      and prolContacto.EMPRESA_ROL_ID=emprolContacto.ID_EMPRESA_ROL
      and emprolContacto.ROL_ID=rolContacto.ID_ROL
      and rolContacto.TIPO_ROL_ID=trolContacto.ID_TIPO_ROL
      and trolContacto.DESCRIPCION_TIPO_ROL ='Contacto'
      and rolContacto.DESCRIPCION_ROL=c_descripcion_contacto --'Contacto Comercial'
      and prolContacto.estado IN ('Activo','Inactivo') and ptoContacto.estado ='Activo'
      and  ptoContacto.CONTACTO_ID=perfc.PERSONA_ID
      and perfc.FORMA_CONTACTO_ID=fc.ID_FORMA_CONTACTO 
      and fc.DESCRIPCION_FORMA_CONTACTO=c_formacontacto --'Correo Electronico'
      and punto.id_punto=c_id_punto
      and ROWNUM=1;

      lr_obtieneContacto lc_obtieneContacto%ROWTYPE;

     --Obtiene los Contactos Existentes por tipo de Contacto y por punto
     --Contacto Notificacion, Contacto Facturacion, Contacto Cobranzas, Contacto Gerente general, 
     --Contacto Encargado del punto, Contacto Gerente financiero, Contacto Administrador de edificio,
     --Contacto Escalamiento, Contacto Compras, Contacto Importaciones, Contacto Seguridad logica
     cursor lc_contactosPorTipoTodos(c_id_punto number) is
     SELECT punto.LOGIN, 
        contacto.ID_PERSONA,contacto.NOMBRES,contacto.APELLIDOS,contacto.IDENTIFICACION_CLIENTE,contacto.RAZON_SOCIAL              
        from
        DB_COMERCIAL.INFO_PUNTO_CONTACTO ptoContacto,
        DB_COMERCIAL.info_punto punto,
        DB_COMERCIAL.INFO_PERSONA contacto,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL prolContacto,
        DB_COMERCIAL.INFO_EMPRESA_ROL emprolContacto,
        DB_GENERAL.ADMI_ROL rolContacto,
        DB_GENERAL.ADMI_TIPO_ROL trolContacto
        where ptoContacto.PUNTO_ID=punto.ID_PUNTO
        and ptoContacto.CONTACTO_ID=contacto.ID_PERSONA
        and ptoContacto.PERSONA_EMPRESA_ROL_ID=prolContacto.ID_PERSONA_ROL
        and prolContacto.EMPRESA_ROL_ID=emprolContacto.ID_EMPRESA_ROL
        and emprolContacto.ROL_ID=rolContacto.ID_ROL
        and rolContacto.TIPO_ROL_ID=trolContacto.ID_TIPO_ROL
        and trolContacto.DESCRIPCION_TIPO_ROL ='Contacto'
        and rolContacto.DESCRIPCION_ROL in ('Contacto Notificacion', 'Contacto Facturacion', 'Contacto Cobranzas', 
        'Contacto Gerente general', 'Contacto Encargado del punto', 'Contacto Gerente financiero', 
        'Contacto Administrador de edificio','Contacto Escalamiento', 'Contacto Compras', 'Contacto Importaciones', 
        'Contacto Seguridad logica')
        and prolContacto.estado IN ('Activo','Inactivo') and ptoContacto.estado ='Activo'        
        and punto.id_punto=c_id_punto
        group by punto.LOGIN, 
        contacto.ID_PERSONA,contacto.NOMBRES,contacto.APELLIDOS,contacto.IDENTIFICACION_CLIENTE,contacto.RAZON_SOCIAL  
        ;
        --Obtiene 1 Forma de Contacto por Persona Contacto y por Tipo de Forma de Contacto Telefono Movil
        cursor lc_FormaContactPorPersTodos(c_id_persona number) is    
         SELECT 
            perfc.VALOR as forma_contacto
          from     
          DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO perfc,
          DB_COMERCIAL.ADMI_FORMA_CONTACTO fc
          where 
          perfc.PERSONA_ID=c_id_persona
          and perfc.FORMA_CONTACTO_ID=fc.ID_FORMA_CONTACTO 
          and fc.DESCRIPCION_FORMA_CONTACTO like 'Telefono Movil%'
          AND ROWNUM=1
       ;      
       lr_FormaContactPorPersTodos lc_FormaContactPorPersTodos%ROWTYPE;

     --Obtiene los Contactos Existentes por tipo de Contacto y por punto
     cursor lc_contactosPorTipo(c_id_punto number, c_descripcion_contacto varchar2) is
     SELECT punto.LOGIN, 
        contacto.ID_PERSONA,contacto.NOMBRES,contacto.APELLIDOS,contacto.IDENTIFICACION_CLIENTE,contacto.RAZON_SOCIAL,
        prolContacto.ID_PERSONA_ROL,emprolContacto.EMPRESA_COD,descripcion_rol
        from
        DB_COMERCIAL.INFO_PUNTO_CONTACTO ptoContacto,
        DB_COMERCIAL.info_punto punto,
        DB_COMERCIAL.INFO_PERSONA contacto,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL prolContacto,
        DB_COMERCIAL.INFO_EMPRESA_ROL emprolContacto,
        DB_GENERAL.ADMI_ROL rolContacto,
        DB_GENERAL.ADMI_TIPO_ROL trolContacto
        where ptoContacto.PUNTO_ID=punto.ID_PUNTO
        and ptoContacto.CONTACTO_ID=contacto.ID_PERSONA
        and ptoContacto.PERSONA_EMPRESA_ROL_ID=prolContacto.ID_PERSONA_ROL
        and prolContacto.EMPRESA_ROL_ID=emprolContacto.ID_EMPRESA_ROL
        and emprolContacto.ROL_ID=rolContacto.ID_ROL
        and rolContacto.TIPO_ROL_ID=trolContacto.ID_TIPO_ROL
        and trolContacto.DESCRIPCION_TIPO_ROL ='Contacto'
        and rolContacto.DESCRIPCION_ROL=c_descripcion_contacto--'Contacto Tecnico' 
        and prolContacto.estado IN ('Activo','Inactivo') and ptoContacto.estado ='Activo'        
        and punto.id_punto=c_id_punto
        ;    
        --Obtiene 1 Forma de Contacto por Persona Contacto y por Tipo de Forma de Contacto
        cursor lc_FormaContactPorPersYTipo(c_id_persona number, c_formacontacto varchar2) is    
         SELECT 
            perfc.VALOR as forma_contacto
          from     
          DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO perfc,
          DB_COMERCIAL.ADMI_FORMA_CONTACTO fc
          where 
          perfc.PERSONA_ID=c_id_persona
          and perfc.FORMA_CONTACTO_ID=fc.ID_FORMA_CONTACTO 
          and fc.DESCRIPCION_FORMA_CONTACTO=c_formacontacto --'Correo Electronico'
          AND ROWNUM=1
       ;      
       lr_FormaContactPorPersYTipo lc_FormaContactPorPersYTipo%ROWTYPE;

     --Obtiene Fecha de Activacion, Fecha de Cancelacion del Servicio recibe servicio y estado a consultar
     cursor lc_obtenerFechaHistorico(c_id_servicio number, c_estado varchar2) is
     select  serv.ID_SERVICIO,MIN(hist.FE_CREACION) as fecha_historico
        from info_servicio_historial hist 
        join info_servicio serv on serv.id_servicio = hist.servicio_id
        where 
        hist.estado = c_estado      
        and serv.id_servicio=c_id_servicio 
        group by serv.ID_SERVICIO;

     lr_obtenerFechaHistorico lc_obtenerFechaHistorico%ROWTYPE;

    --Obtiene motivo de la Solicitud de Cortesia , en caso de que el servicio del Cliente tenga Cortesias
    cursor lc_obtieneMotivoSolCortesia(c_id_servicio number, c_tipo_solicitud varchar2) is 
      select ts.DESCRIPCION_SOLICITUD,mo.NOMBRE_MOTIVO,ds.* 
      from info_detalle_solicitud ds, ADMI_TIPO_SOLICITUD ts, DB_GENERAL.ADMI_MOTIVO mo
      where ds.estado='Aprobado'
      and ds.TIPO_SOLICITUD_ID=ts.ID_TIPO_SOLICITUD and ts.DESCRIPCION_SOLICITUD=c_tipo_solicitud-- 'SOLICITUD CAMBIO DOCUMENTO'
      and ds.MOTIVO_ID=mo.ID_MOTIVO
      and ds.SERVICIO_ID=c_id_servicio and ROWNUM=1
      order by ID_DETALLE_SOLICITUD desc;

       lr_obtieneMotivoSolCortesia lc_obtieneMotivoSolCortesia%ROWTYPE;      

    --Obtiene Login, Login_aux y Ciudad del Concentrador del enlace en base al ID del servicio Extremo del Tunel
    cursor lc_obtenerLoginConcentrador(c_id_servicio number) is
      select servpc.servicio_id, servpc.valor,servpc.estado, serconcent.PUNTO_ID,
        ptoconcent.login as login_concentrador,cant.NOMBRE_CANTON AS ciudad_concentrador,
        serconcent.LOGIN_AUX as login_aux_concentrador
        from 
        db_comercial.info_servicio_prod_caract servpc,db_comercial.admi_producto_caracteristica prodc,
        db_comercial.admi_caracteristica carac, db_comercial.info_servicio serconcent,db_comercial.info_punto ptoconcent,
        DB_GENERAL.ADMI_SECTOR sec, DB_GENERAL.ADMI_PARROQUIA parr, DB_GENERAL.ADMI_CANTON cant

        where  carac.DESCRIPCION_CARACTERISTICA='ENLACE_DATOS' 
        and servpc.PRODUCTO_CARACTERISITICA_ID=prodc.ID_PRODUCTO_CARACTERISITICA
        and prodc.CARACTERISTICA_ID=carac.ID_CARACTERISTICA 
        and servpc.valor=serconcent.ID_SERVICIO
        and COALESCE(TO_NUMBER(REGEXP_SUBSTR(servpc.valor,'^\d+')),0) = serconcent.ID_SERVICIO
        and serconcent.punto_id=ptoconcent.ID_PUNTO
        and ptoconcent.sector_id=sec.id_sector
        and sec.parroquia_id=parr.id_parroquia
        and parr.canton_id=cant.id_canton
        and servpc.SERVICIO_ID=c_id_servicio 
        and servpc.estado='Activo' and ROWNUM=1;

      lr_obtenerLoginConcentrador lc_obtenerLoginConcentrador%ROWTYPE;      

     --Obtiene el motivo de Cancelacion del Servicio
     cursor lc_obtenerMotivoHistorial(c_id_servicio number) is
     select hist.MOTIVO_ID,mo.NOMBRE_MOTIVO
        from info_servicio_historial hist 
        join info_servicio serv on serv.id_servicio = hist.servicio_id
        join DB_GENERAL.ADMI_MOTIVO mo on hist.MOTIVO_ID=mo.ID_MOTIVO
        where 
        hist.estado = 'Cancel' and ROWNUM=1     
        and serv.id_servicio=c_id_servicio;

      lr_obtenerMotivoHistorial lc_obtenerMotivoHistorial%ROWTYPE;        
    -- 
     cursor lc_escapa_caracter(l_cadena varchar2) is
      SELECT
        REGEXP_REPLACE(l_cadena, '[[:cntrl:];"]', '')  as cadena_limpia
      FROM dual WHERE ROWNUM=1;
     lr_escapa_caracter lc_escapa_caracter%ROWTYPE;        

     --
    CURSOR C_GetSolicitudDescTelcos(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS  
      SELECT DS.SERVICIO_ID,
        DS.OBSERVACION,
        DS.FE_CREACION AS FE_CREACION_SOLICITUD,
        DS.PORCENTAJE_DESCUENTO,
        DS.PRECIO_DESCUENTO,
        DS.ESTADO AS ESTADO_SOLICITUD,
        DSH.USR_CREACION AS USR_APROBACION,
        AUT.NOMBRES || '' ||AUT.APELLIDOS AS NOMBRE_APROBACION,
        DSH.FE_CREACION AS FECHA_APROBACION,
        DSH.ESTADO AS ESTADO_APROBACION
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
      JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS ON DS.TIPO_SOLICITUD_ID=TS.ID_TIPO_SOLICITUD
      JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH ON DS.ID_DETALLE_SOLICITUD=DSH.DETALLE_SOLICITUD_ID  
      JOIN DB_COMERCIAL.INFO_PERSONA AUT ON DSH.USR_CREACION=AUT.LOGIN                  
      WHERE ts.DESCRIPCION_SOLICITUD = 'SOLICITUD DESCUENTO'
      AND DS.ESTADO                  = 'Aprobado'
      AND DSH.ESTADO                 = 'Aprobado'
      AND DS.SERVICIO_ID             = Cn_IdServicio
      AND ROWNUM                     = 1; 

     Lr_GetSolicitudDescTelcos C_GetSolicitudDescTelcos%ROWTYPE;
    --
    CURSOR C_GetSolicitudDescSit(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS  
    SELECT PRO.EMPLEADO_APROB_PRECIO,
      EMPL.NOMBRES_EMPLEADO || ' ' || EMPL.APELLIDOS_EMPLEADO AS USR_APROBACION_SIT,
      PER.NOMBRES || ' ' || PER.APELLIDOS AS USR_APROBACION,
      PRO.FECHA_APROB_PRECIO AS FE_APROBACION_SIT,
      PRO.ESTADO_APROB_PRECIO AS ESTADO_APROBACION_SIT,
      PRO.OBSERVACION_APROB_PRECIO AS OBSERVACION_SOL_SIT 
    FROM DBSIT.VENT_ORDEN_SERVICIO_DET OSD    
    JOIN DBSIT.VENT_PROFORMA_DET PRO ON OSD.PROFORMA_DETALLE_ID=PRO.ID_PROFORMA_DETALLE 
    JOIN DBSIT.ADMI_EMPLEADO_DAT EMPL ON PRO.EMPLEADO_APROB_PRECIO=EMPL.ID_EMPLEADO
    JOIN DB_COMERCIAL.INFO_PERSONA PER ON EMPL.LOGIN_EMPLEADO=PER.LOGIN
    WHERE
    OSD.ID_ORDEN_SERVICIO_DET    = Cn_IdServicio
    AND PRO.ESTADO_APROB_PRECIO  ='A'
    AND ROWNUM                   = 1;

    Lr_GetSolicitudDescSit C_GetSolicitudDescSit%ROWTYPE;

    --
    CURSOR C_GetRolesPlantillas
    IS
    SELECT DET.ID_PARAMETRO_DET,
      DET.DESCRIPCION, 
      DET.VALOR1,
      DET.VALOR2, 
      DET.VALOR3, 
      DET.VALOR4,
      DET.VALOR5
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
    DB_GENERAL.ADMI_PARAMETRO_DET DET,
    DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGRUP
    WHERE 
    CAB.NOMBRE_PARAMETRO   = 'GRUPO_ROLES_PERSONAL'
    AND DET.EMPRESA_COD    = EMPGRUP.COD_EMPRESA
    AND EMPGRUP.PREFIJO    = l_prefijo_empresa 
    AND CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
    ORDER BY VALOR5 ASC;

    --
    CURSOR C_GetComisionistasPorRol(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Cn_IdParametroDet DB_GENERAL.ADMI_PARAMETRO_DET.ID_PARAMETRO_DET%TYPE)
    IS
    SELECT PARD.DESCRIPCION || '|' ||
    UPPER(PER.NOMBRES) || ' ' || UPPER(PER.APELLIDOS)|| '|' || 
    CASE
    WHEN SCOM.COMISION_MANTENIMIENTO IS NOT NULL AND SCOM.COMISION_MANTENIMIENTO>0
    THEN
    SCOM.COMISION_MANTENIMIENTO
    ELSE
    SCOM.COMISION_VENTA 
    END AS PLANTILLA
    FROM DB_COMERCIAL.INFO_SERVICIO_COMISION SCOM,     
    DB_COMERCIAL.ADMI_COMISION_DET COMD,     
    DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
    DB_GENERAL.ADMI_PARAMETRO_DET PARD,
    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL,
    DB_COMERCIAL.INFO_PERSONA PER,
    DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGRUP
    WHERE
    SCOM.SERVICIO_ID                = Cn_IdServicio
    AND PARD.ID_PARAMETRO_DET       = Cn_IdParametroDet
    AND SCOM.COMISION_DET_ID        = COMD.ID_COMISION_DET
    AND COMD.PARAMETRO_DET_ID       = PARD.ID_PARAMETRO_DET
    AND PARD.PARAMETRO_ID           = PARC.ID_PARAMETRO 
    AND SCOM.PERSONA_EMPRESA_ROL_ID = PEMPROL.ID_PERSONA_ROL
    AND PEMPROL.PERSONA_ID          = PER.ID_PERSONA
    AND PARC.NOMBRE_PARAMETRO       = 'GRUPO_ROLES_PERSONAL'
    AND PARD.EMPRESA_COD            = EMPGRUP.COD_EMPRESA    
    AND EMPGRUP.PREFIJO             = l_prefijo_empresa 
    AND SCOM.ESTADO                 = 'Activo'  
    AND ROWNUM                      = 1  
    ;

    Lr_GetComisionistasPorRol C_GetComisionistasPorRol%ROWTYPE;

    /****************************************************************************
     * Reporte Financiero: Facturas y Pagos.
     ****************************************************************************/
     CURSOR lc_reporteFinanciero is
     SELECT  IDFC.ID_DOCUMENTO AS ID_FACTURA,
             IP.LOGIN          AS LOGIN_CLIENTE_SUCURSAL,
             CASE
               WHEN IPER.ESTADO ='Activo'
               THEN 'A'
               WHEN IPER.ESTADO ='Cancelado'
               THEN 'I'
             END                                                                       AS ESTADO_CLIENTE_SUCURSAL,
             TO_CHAR(IDFC.FE_CREACION,'yyyy-mm-dd')                                    AS FECHA_CREACION,
             IDFC.NUMERO_FACTURA_SRI                                                   AS NUMERO_DOCUMENTO,
             TRIM(TO_CHAR(IDFC.VALOR_TOTAL, '999999999999999999999999999999999999.99'))AS VALOR,
             CASE
               WHEN IDFC.ESTADO_IMPRESION_FACT='Activo'  THEN 'A'
               WHEN IDFC.ESTADO_IMPRESION_FACT='Cerrado' THEN 'C'
               WHEN IDFC.ESTADO_IMPRESION_FACT='Anulada' THEN 'N'
               WHEN IDFC.ESTADO_IMPRESION_FACT='Anulado' THEN 'N' END AS ESTADO_DOCUMENTO,
             CASE
               WHEN ATDF.CODIGO_TIPO_DOCUMENTO='FAC'  THEN 'FACT'
               WHEN ATDF.CODIGO_TIPO_DOCUMENTO='FACP' THEN 'FACT'
               WHEN ATDF.CODIGO_TIPO_DOCUMENTO='NDI'  THEN 'NDB'
               WHEN ATDF.CODIGO_TIPO_DOCUMENTO='NC'   THEN 'NCR'
               ELSE ATDF.CODIGO_TIPO_DOCUMENTO                    END AS DOCUMENTO,
             IOG.NOMBRE_OFICINA,
             'Factura' AS FORMA_PAGO
     FROM      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
     LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
     LEFT JOIN DB_COMERCIAL.INFO_PUNTO                      IP   ON IP.ID_PUNTO            = IDFC.PUNTO_ID
     LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL        IPER ON IPER.ID_PERSONA_ROL    = IP.PERSONA_EMPRESA_ROL_ID
     LEFT JOIN DB_FINANCIERO.INFO_OFICINA_GRUPO             IOG  ON IOG.ID_OFICINA         = IDFC.OFICINA_ID
     LEFT JOIN DB_FINANCIERO.INFO_EMPRESA_GRUPO             IEG  ON IEG.COD_EMPRESA        = IOG.EMPRESA_ID
     WHERE TRUNC(IDFC.FE_CREACION) BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -1)) AND TRUNC(SYSDATE - 1)
       AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado','Anulada','Anulado')
       AND IEG.PREFIJO                = l_prefijo_empresa

     UNION ALL

     SELECT  IPC.ID_PAGO AS ID_FACTURA,
             IP.LOGIN    AS LOGIN_CLIENTE_SUCURSAL,
             CASE
               WHEN IPER.ESTADO ='Activo'
               THEN 'A'
               WHEN IPER.ESTADO ='Cancelado'
               THEN 'I'
             END                                                                             AS ESTADO_CLIENTE_SUCURSAL,
             TO_CHAR(IPC.FE_CREACION,'yyyy-mm-dd')                                           AS FE_CREACION,
             IPC.NUMERO_PAGO                                                                 AS NUMERO_DOCUMENTO,
             TRIM(TO_CHAR(NVL(IPD.VALOR_PAGO,0), '999999999999999999999999999999999999.99')) AS VALOR,
             CASE
               WHEN IPC.ESTADO_PAGO = 'Cerrado'
               THEN 'C'
               WHEN IPC.ESTADO_PAGO = 'Pendiente'
               THEN 'P'
               WHEN IPC.ESTADO_PAGO = 'Anulado'
               THEN 'N'
             END   AS ESTADO_DOCUMENTO,
             'PAG' AS DOCUMENTO,
             IOG.NOMBRE_OFICINA,
             AFP.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO
     FROM      DB_FINANCIERO.INFO_PAGO_CAB                  IPC
     LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET                  IPD  ON IPD.PAGO_ID            = IPC.ID_PAGO
     LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO                   AFP  ON AFP.ID_FORMA_PAGO      = IPD.FORMA_PAGO_ID
     LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
     LEFT JOIN DB_COMERCIAL.INFO_PUNTO                      IP   ON IP.ID_PUNTO            = IPC.PUNTO_ID
     LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL        IPER ON IPER.ID_PERSONA_ROL    = IP.PERSONA_EMPRESA_ROL_ID
     LEFT JOIN DB_FINANCIERO.INFO_OFICINA_GRUPO             IOG  ON IOG.ID_OFICINA         = IPC.OFICINA_ID
     LEFT JOIN DB_FINANCIERO.INFO_EMPRESA_GRUPO             IEG  ON IEG.COD_EMPRESA        = IOG.EMPRESA_ID
     WHERE TRUNC(IPC.FE_CREACION) BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -1)) AND TRUNC(SYSDATE - 1)
       AND IPC.ESTADO_PAGO  NOT IN ('Anulado','Asignado')
       AND IPC.PUNTO_ID     IS NOT NULL
       AND IEG.PREFIJO      = l_prefijo_empresa
     ;
    /****************************************************************************
     * FIN - Reporte Financiero: Facturas y Pagos.
     ****************************************************************************/

    --Cursor para obtener las IPs del Servidor de Produccion
    CURSOR C_GetParametroIp(Cv_NombreParametro VARCHAR2, Cv_Ip VARCHAR2)
    IS
      SELECT PC.NOMBRE_PARAMETRO,
        PD.ID_PARAMETRO_DET,
        PD.DESCRIPCION, 
        PD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC
      JOIN DB_GENERAL.ADMI_PARAMETRO_DET PD ON PC.ID_PARAMETRO=PD.PARAMETRO_ID
      WHERE PC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND PD.VALOR1=Cv_Ip;

    Lc_GetParametroIp C_GetParametroIp%ROWTYPE;  
    --
    Lv_Descripcion VARCHAR2(100);
    --
    Lv_UsuarioAutoriza VARCHAR2(200);
    Lt_FechaAutoriza TIMESTAMP;
    Lv_FechaAutForm VARCHAR2(10);
    --
    Lv_Ambiente VARCHAR2(25);
    Lv_Cuerpo VARCHAR2(80);
    Lv_TextoInforme VARCHAR2(3000);
    Lv_AsuntoInforme VARCHAR2(100);
    --
    Lv_NombreArchivo VARCHAR2(100);
    Lv_Gzip VARCHAR2(100);
    Lv_NombreArchivoZip VARCHAR2(100);
    Lv_Asunto VARCHAR2(80);
    --
    Lv_NombreArchivoFinanciero  VARCHAR2(100);
    Lv_GzipFinanciero           VARCHAR2(100);
    Lv_NombreArchivoFinancieroZip VARCHAR2(100);
    Lv_AsuntoFinanciero          VARCHAR2(80);
    --
    l_nombre_ingVip varchar2(200):='';
    l_correo_ingVip varchar2(200):='';    
    l_nombre_vendedor varchar2(200):='';
    l_telefono_fijo1 varchar2(50):='';
    l_telefono_fijo2 varchar2(50):='';
    l_correo_contacto varchar2(500):='';
    l_nombres_contacto_tec varchar2(900):='';
    l_correos_contactos_tec varchar2(900):='';    
    l_telefono_contactos_tec varchar2(900):='';  
    l_nombres_contacto_com varchar2(900):='';
    l_correos_contactos_com varchar2(900):='';    
    l_telefono_contactos_com varchar2(900):=''; 
    l_nombres_contacto_todos varchar2(2000):='';
    l_correos_contactos_todos varchar2(2000):='';    
    l_telefono_contactos_todos varchar2(2000):='';
    l_celular_contactos_todos varchar2(2000):='';
    l_fecha_activacion TIMESTAMP;
    l_fecha_act_form varchar2(10);
    l_fecha_cancelacion date;
    l_fecha_canc_form varchar2(10);
    l_motivo_cortesia varchar2(50):=''; 
    l_login_concentrador varchar2(50):=''; 
    l_loginaux_concentrador varchar2(50):=''; 
    l_ciudad_concentrador varchar2(50):=''; 
    l_motivo_cancelacion varchar2(250):='';     
    --
    l_login varchar2(200):=''; 
    l_login_punto varchar2(200):=''; 
    l_ultima_milla varchar2(200):=''; 
    l_switches varchar2(500):=''; 
    l_puerto varchar2(50):=''; 
    l_bwInternet varchar2(50):=''; 
    l_login_padreFact varchar2(200):=''; 
    l_tipo_negocio varchar2(60):=''; 
    l_nombre_cliente varchar2(250):=''; 
    l_apellidos_cliente varchar2(250):=''; 
    l_razon_social_cliente varchar2(250):=''; 
    l_direccion_punto varchar2(1000):=''; 
    l_sitio_entrega varchar2(250):=''; 
    l_estado varchar2(100):='';
    l_canje varchar2(20):='';
    l_fecha_fin_contrato TIMESTAMP;
    l_fecha_fin_contrato_form varchar2(10);
    l_tiempo_validez_serv number;
    i number;
    Lv_Plantilla VARCHAR2(250):='';
  begin
   p_destinatario := F_GET_CORREOS('EMAIL_GERENCIA');
   Lv_DestinatarioInforme := F_GET_CORREOS('EMAIL_NOTIFICACION');
  
   cod_ret := 1000;
   MSG_RET := 'Reporte Comercial de Gerencia';

   OPEN C_GetParametroIp('IP_BASE_DATOS_PRODUCCION',Lv_IpCreacion);
   FETCH C_GetParametroIp INTO Lc_GetParametroIp;   
   IF(C_GetParametroIp%found) THEN
      Lv_Ambiente:='Ambiente_Produccion';    
   ELSE
      Lv_Ambiente:='Ambiente_Desarrollo';
   END IF;
   CLOSE C_GetParametroIp;

   Lv_Cuerpo:='Generación automática y envío por correo ' || Lv_Ambiente;
   Lv_AsuntoInforme:='Notificación de Informe Técnico de Reporte Gerencial';
   --   
   Lv_NombreArchivo:='ReporteTtopic-'|| Lv_FechaReporte || '-' || Lv_Ambiente || '.csv';
   Lv_Gzip:='gzip /backup/repgerencia/'|| Lv_NombreArchivo;
   Lv_NombreArchivoZip:='ReporteTtopic-'|| Lv_FechaReporte || '-' || Lv_Ambiente || '.csv.gz'; 
   Lv_Asunto:='Notificacion Reporte Gerencial '|| Lv_Ambiente;
   --
   Lv_NombreArchivoFinanciero:= 'ReporteTtopicFinanciero-'|| Lv_FechaReporte || '-' || Lv_Ambiente || '.csv';
   Lv_GzipFinanciero:= 'gzip -f /backup/repgerencia/'|| Lv_NombreArchivoFinanciero;
   Lv_NombreArchivoFinancieroZip:= 'ReporteTtopicFinanciero-'|| Lv_FechaReporte || '-' || Lv_Ambiente || '.csv.gz';
   Lv_AsuntoFinanciero:= 'Notificación Reporte Gerencial Financiero: Facturas y Pagos '|| Lv_Ambiente;

   p_archivo :=UTL_FILE.fopen(p_directorio,Lv_NombreArchivo,'w',3000);--Opening a file                
   FOR datos in lc_reporteComercial LOOP         
       cod_ret := 1100;
       MSG_RET := 'Saco informacion de Ingeniero VIP asignado al cliente';

       l_nombre_ingVip:='';
       l_correo_ingVip:='';
       OPEN lc_obtieneIngVip(datos.id_persona_rol);
       FETCH lc_obtieneIngVip INTO lr_obtieneIngVip;
       IF(lc_obtieneIngVip%found) THEN
         l_nombre_ingVip:=lr_obtieneIngVip.nombre_ingvip;
         l_correo_ingVip:=lr_obtieneIngVip.correo;
       end if;
       CLOSE lc_obtieneIngVip;

       cod_ret := 1200;
       MSG_RET := 'Saco informacion del Vendedor asignado al Punto cliente';

       l_nombre_vendedor:='';       
       OPEN lc_obtieneVendedor(datos.usr_vendedor);
       FETCH lc_obtieneVendedor INTO lr_obtieneVendedor;
       IF(lc_obtieneVendedor%found) THEN
         l_nombre_vendedor:=lr_obtieneVendedor.nombre_vendedor;         
       end if;
       CLOSE lc_obtieneVendedor;       

       cod_ret := 1150;
       MSG_RET := 'Saco si cliente es Canje en la Forma de Pago de su contrato';

       l_canje:='';       
       OPEN lc_obtieneContratoCanje(datos.id_persona_rol);
       FETCH lc_obtieneContratoCanje INTO lr_obtieneContratoCanje;
       IF(lc_obtieneContratoCanje%found) THEN
         l_canje:=lr_obtieneContratoCanje.canje;         
       end if;
       CLOSE lc_obtieneContratoCanje;       

       cod_ret := 1160;
       MSG_RET := 'Saco si Punto cliente posee Caracteristica Canje';
       OPEN lc_obtienePuntoCanje(datos.id_punto);
       FETCH lc_obtienePuntoCanje INTO lr_obtienePuntoCanje;
       IF(lc_obtienePuntoCanje%found) THEN
          if(lr_obtienePuntoCanje.es_canje='S') then
              l_canje:='CANJE'; 
          end if;
       end if;
       CLOSE lc_obtienePuntoCanje;    

       cod_ret := 1300;
       MSG_RET := 'Saco informacion de Telefonos Fijos del cliente';
       i:=0;
       l_telefono_fijo1:='';
       l_telefono_fijo2:='';
       FOR datosFormasContacto in lc_obtenerFormaContactoPersona('Telefono Fijo',datos.id_persona) LOOP   
            i:=i+1;
            if(i=1) then
                  l_telefono_fijo1:=datosFormasContacto.forma_contacto;
            end if;
            if(i=2) then
                  l_telefono_fijo2:=datosFormasContacto.forma_contacto;
            end if;            
       END LOOP;

       cod_ret := 1400;
       MSG_RET := 'Saco informacion del correo del Contacto Comercial';
       l_correo_contacto:='';
       OPEN lc_obtieneContacto(datos.id_punto,'Contacto Comercial','Correo Electronico');
       FETCH lc_obtieneContacto INTO lr_obtieneContacto;
       IF(lc_obtieneContacto%found) THEN        
            l_correo_contacto:=lr_obtieneContacto.forma_contacto;
       end if;
       CLOSE lc_obtieneContacto;

       cod_ret := 1500;
       MSG_RET := 'Saco informacion de los Contactos Tecnicos';  
       l_nombres_contacto_tec:='';
       l_correos_contactos_tec:='';
       l_telefono_contactos_tec:='';
       FOR lr_contactosPorTipo in lc_contactosPorTipo(datos.id_punto,'Contacto Tecnico') LOOP                
             l_nombres_contacto_tec:=l_nombres_contacto_tec||lr_contactosPorTipo.NOMBRES || ' ' || lr_contactosPorTipo.APELLIDOS||'|';
             cod_ret := 1600;
             MSG_RET := 'Saco informacion de la forma de Contacto Correo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Correo Electronico');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_correos_contactos_tec:=l_correos_contactos_tec||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

             cod_ret := 1700;
             MSG_RET := 'Saco informacion de la forma de Contacto Telefono fijo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Telefono Fijo');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_telefono_contactos_tec:=l_telefono_contactos_tec||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

       END LOOP;

       cod_ret := 1750;
       MSG_RET := 'Saco informacion de los Contactos Comerciales';  
       l_nombres_contacto_com:='';
       l_correos_contactos_com:='';
       l_telefono_contactos_com:='';
       FOR lr_contactosPorTipo in lc_contactosPorTipo(datos.id_punto,'Contacto Comercial') LOOP                
             l_nombres_contacto_com:=l_nombres_contacto_com||lr_contactosPorTipo.NOMBRES || ' ' || lr_contactosPorTipo.APELLIDOS||'|';
             cod_ret := 1751;
             MSG_RET := 'Saco informacion de la forma de Contacto Correo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Correo Electronico');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_correos_contactos_com:=l_correos_contactos_com||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

             cod_ret := 1752;
             MSG_RET := 'Saco informacion de la forma de Contacto Telefono fijo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Telefono Fijo');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_telefono_contactos_com:=l_telefono_contactos_com||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

       END LOOP;

       cod_ret := 1760;
       MSG_RET := 'Saco informacion de todos los Contactos adicionales del cliente';  
       l_nombres_contacto_todos:='';
       l_correos_contactos_todos:='';
       l_telefono_contactos_todos:='';
       l_celular_contactos_todos:='';
       FOR lr_contactosPorTipo in lc_contactosPorTipoTodos(datos.id_punto) LOOP                
             l_nombres_contacto_todos:=l_nombres_contacto_todos||lr_contactosPorTipo.NOMBRES || ' ' || lr_contactosPorTipo.APELLIDOS||'|';
             cod_ret := 1761;
             MSG_RET := 'Saco informacion de la forma de Contacto Correo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Correo Electronico');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_correos_contactos_todos:=l_correos_contactos_todos||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

             cod_ret := 1762;
             MSG_RET := 'Saco informacion de la forma de Contacto Telefono fijo de la Persona Contacto';

             OPEN lc_FormaContactPorPersYTipo(lr_contactosPorTipo.ID_PERSONA,'Telefono Fijo');
             FETCH lc_FormaContactPorPersYTipo INTO lr_FormaContactPorPersYTipo;
             IF(lc_FormaContactPorPersYTipo%found) THEN
                 l_telefono_contactos_todos:=l_telefono_contactos_todos||lr_FormaContactPorPersYTipo.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersYTipo;

             cod_ret := 1763;
             MSG_RET := 'Saco informacion de la forma de Contacto Telefono Movil de la Persona Contacto';

             OPEN lc_FormaContactPorPersTodos(lr_contactosPorTipo.ID_PERSONA);
             FETCH lc_FormaContactPorPersTodos INTO lr_FormaContactPorPersTodos;
             IF(lc_FormaContactPorPersTodos%found) THEN
                 l_celular_contactos_todos:=l_celular_contactos_todos||lr_FormaContactPorPersTodos.forma_contacto||'|'; 
             end if;
             CLOSE lc_FormaContactPorPersTodos;

       END LOOP;

       cod_ret := 1800;
       MSG_RET := 'Saco Fecha de Activacion del servicio';
       l_fecha_activacion:='';
       l_fecha_act_form:='';
       OPEN lc_obtenerFechaHistorico(datos.id_servicio,'Activo');
       FETCH lc_obtenerFechaHistorico INTO lr_obtenerFechaHistorico;
       IF(lc_obtenerFechaHistorico%found) THEN
           l_fecha_activacion:=lr_obtenerFechaHistorico.fecha_historico;
           l_fecha_act_form:=to_char(l_fecha_activacion, 'MM/DD/YYYY');
       end if;
       CLOSE lc_obtenerFechaHistorico;

       cod_ret := 1900;
       MSG_RET := 'Saco Fecha de Cancelacion del servicio';
       l_fecha_cancelacion:='';
       l_fecha_canc_form:='';
       OPEN lc_obtenerFechaHistorico(datos.id_servicio,'Cancel');
       FETCH lc_obtenerFechaHistorico INTO lr_obtenerFechaHistorico;
       IF(lc_obtenerFechaHistorico%found) THEN
           l_fecha_cancelacion:=lr_obtenerFechaHistorico.fecha_historico;
           l_fecha_canc_form:=to_char(l_fecha_cancelacion, 'MM/DD/YYYY');
       end if;
       CLOSE lc_obtenerFechaHistorico;

       cod_ret := 2000;
       MSG_RET := 'Saco Motivo de Cortesia del servicio';
       l_motivo_cortesia:='';
       OPEN lc_obtieneMotivoSolCortesia(datos.id_servicio,'SOLICITUD CAMBIO DOCUMENTO');
       FETCH lc_obtieneMotivoSolCortesia INTO lr_obtieneMotivoSolCortesia;
       IF(lc_obtieneMotivoSolCortesia%found) THEN
           l_motivo_cortesia:=lr_obtieneMotivoSolCortesia.NOMBRE_MOTIVO;
       end if;
       CLOSE lc_obtieneMotivoSolCortesia;

       cod_ret := 2100;
       MSG_RET := 'Saco Login, Login Aux y Ciudad del Punto que es Concentrador';

       OPEN lc_obtenerLoginConcentrador(datos.id_servicio);
       FETCH lc_obtenerLoginConcentrador INTO lr_obtenerLoginConcentrador;
       IF(lc_obtenerLoginConcentrador%found) THEN
           l_login_concentrador:=lr_obtenerLoginConcentrador.login_concentrador;
           l_loginaux_concentrador:=lr_obtenerLoginConcentrador.login_aux_concentrador;
           l_ciudad_concentrador:=lr_obtenerLoginConcentrador.ciudad_concentrador;
       else
           l_login_concentrador:='NT';
           l_loginaux_concentrador:='NT';
           l_ciudad_concentrador:='NT';
       end if;
       CLOSE lc_obtenerLoginConcentrador;        

       cod_ret := 2200;
       MSG_RET := 'Saco Motivo de Cancelacion del Servicio';
       l_motivo_cancelacion:='';
       OPEN lc_obtenerMotivoHistorial(datos.id_servicio);
       FETCH lc_obtenerMotivoHistorial INTO lr_obtenerMotivoHistorial;
       IF(lc_obtenerMotivoHistorial%found) THEN
            l_motivo_cancelacion:=lr_obtenerMotivoHistorial.NOMBRE_MOTIVO;      
       end if;
       CLOSE lc_obtenerMotivoHistorial;        

       cod_ret := 2250;
       MSG_RET := 'Saco Ancho de Banda del Servicio'; 
       l_bwInternet:='';      
       OPEN C_GetAnchoBanda(datos.id_servicio,datos.estado);
       FETCH C_GetAnchoBanda INTO Lr_GetAnchoBanda;
       IF(C_GetAnchoBanda%found) THEN
         l_bwInternet:= Lr_GetAnchoBanda.VALOR; 
       END IF;
       CLOSE C_GetAnchoBanda;

       --Quitando caracteres no imprimibles de todos los campos
       cod_ret := 2300;
       MSG_RET := 'Quitando caracteres no imprimibles de todos los campos';
       OPEN lc_escapa_caracter(datos.login_cliente);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_login:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;       
       --       
       OPEN lc_escapa_caracter(datos.LOGIN_PUNTO);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_login_punto:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;   
       --
       OPEN lc_escapa_caracter(datos.ultima_milla);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_ultima_milla:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(datos.switches);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_switches:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(datos.puerto);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_puerto:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(l_bwInternet);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_bwInternet:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(datos.login_padreFact);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_login_padreFact:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;        
       --
       OPEN lc_escapa_caracter(datos.tipo_negocio);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_tipo_negocio:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;    
       --
       OPEN lc_escapa_caracter(l_nombre_vendedor);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_nombre_vendedor:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
       --
       OPEN lc_escapa_caracter(datos.nombre_cliente);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_nombre_cliente:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
        --
       OPEN lc_escapa_caracter(datos.apellidos_cliente);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_apellidos_cliente:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
       --
       OPEN lc_escapa_caracter(datos.razon_social_cliente);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_razon_social_cliente:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
        --
       OPEN lc_escapa_caracter(datos.direccion_punto);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_direccion_punto:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
        --
       OPEN lc_escapa_caracter(l_telefono_fijo1);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_telefono_fijo1:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
       --
       OPEN lc_escapa_caracter(l_telefono_fijo2);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_telefono_fijo2:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
       --
       OPEN lc_escapa_caracter(l_correo_contacto);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_correo_contacto:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
       --
       OPEN lc_escapa_caracter(datos.sitio_entrega);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_sitio_entrega:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
        --
       OPEN lc_escapa_caracter(l_telefono_contactos_tec);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_telefono_contactos_tec:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;       
       --
       OPEN lc_escapa_caracter(l_correos_contactos_tec);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_correos_contactos_tec:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(l_motivo_cortesia);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_motivo_cortesia:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;
         --
       OPEN lc_escapa_caracter(l_telefono_contactos_com);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_telefono_contactos_com:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;       
       --
       OPEN lc_escapa_caracter(l_correos_contactos_com);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_correos_contactos_com:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(l_telefono_contactos_todos);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_telefono_contactos_todos:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;       
       --
       OPEN lc_escapa_caracter(l_correos_contactos_todos);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_correos_contactos_todos:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       OPEN lc_escapa_caracter(l_celular_contactos_todos);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         l_celular_contactos_todos:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter; 
       --
       if(datos.estado='Activo') then
          l_estado:='Current';
       ELSIF(datos.estado='In-Corte' or datos.estado='In-Temp') then
          l_estado:='On Hold';
       ELSIF(datos.estado='Cancel' or datos.estado='Cancelado' or datos.estado='Trasladado') then
          l_estado:='Canceled';   
       ELSIF(datos.estado='EnPruebas') then
          l_estado:='En Pruebas';      
       ELSIF(datos.estado='Asignada') then
          l_estado:='Falta Activacion Servidores'; 
       ELSE
          l_estado:='Pending';
       end if;
       --
       --Obtengo la fecha de finalizacion del contrato solo si se trata del cliente Municipio de Guayaquil
       --para obtener: tiempo de validez del servicio= fecha_fin_contrato-fecha_activacion_servicio calculado en dias
       cod_ret := 2400;
       MSG_RET := 'Saco la fecha fin del contrato para calcular el tiempo de validez del servicio';
       l_fecha_fin_contrato:='';
       l_fecha_fin_contrato_form:='';
       l_tiempo_validez_serv:=null;
       OPEN lc_obtieneFeFinContrato(datos.id_persona_rol);
       FETCH lc_obtieneFeFinContrato INTO lr_obtieneFeFinContrato;
       IF(lc_obtieneFeFinContrato%found) THEN                  
            l_fecha_fin_contrato:=lr_obtieneFeFinContrato.FE_FIN_CONTRATO;
            l_fecha_fin_contrato_form:=to_char(l_fecha_fin_contrato, 'MM/DD/YYYY');
            if(l_fecha_fin_contrato is not null and l_fecha_activacion is not null) then                
                OPEN lc_obtieneTiempoValidezServ(l_fecha_fin_contrato,l_fecha_activacion);
                FETCH lc_obtieneTiempoValidezServ INTO lr_obtieneTiempoValidezServ;
                IF(lc_obtieneTiempoValidezServ%found) THEN
                   l_tiempo_validez_serv:=lr_obtieneTiempoValidezServ.tiempo;                    
                end if;
                CLOSE lc_obtieneTiempoValidezServ;            
             end if;

       end if;
       CLOSE lc_obtieneFeFinContrato;

       cod_ret := 2500;
       MSG_RET := 'Obtengo la Cadena con la descripcion del nombre del producto';
       Lv_Descripcion:='';
       IF(datos.LV_CONCENTRADOR='SI') THEN
          IF(datos.TIPO_ENLACE='PRINCIPAL' OR datos.TIPO_ENLACE='BACKUP') THEN
              IF(datos.es_venta='Venta') THEN
                  Lv_Descripcion:=datos.DESCRIPCION_PRODUCTO || ' ' || datos.TIPO_ENLACE || ' Pagado';
              ELSE
                  Lv_Descripcion:=datos.DESCRIPCION_PRODUCTO || ' ' || datos.TIPO_ENLACE;
              END IF;
          ELSE
              IF(datos.es_venta='Venta') THEN
                  Lv_Descripcion:=datos.DESCRIPCION_PRODUCTO || ' Pagado';
              ELSE
                  Lv_Descripcion:=datos.DESCRIPCION_PRODUCTO;
              END IF; 
          END IF;
       ELSE
            Lv_Descripcion:=datos.DESCRIPCION_PRODUCTO;
       END IF;

       OPEN lc_escapa_caracter(Lv_Descripcion);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         Lv_Descripcion:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;  

       Lv_UsuarioAutoriza:='';
       Lt_FechaAutoriza:='';
       Lv_FechaAutForm:='';

       IF C_GetSolicitudDescTelcos%ISOPEN THEN
         CLOSE C_GetSolicitudDescTelcos;
       END IF;

       IF C_GetSolicitudDescSit%ISOPEN THEN
         CLOSE C_GetSolicitudDescSit;
       END IF;

       cod_ret := 2600;
       MSG_RET := 'Saco si existe Solicitud de Descuento en Telcos';

       OPEN C_GetSolicitudDescTelcos(datos.id_servicio);
       FETCH C_GetSolicitudDescTelcos INTO Lr_GetSolicitudDescTelcos;
       IF(C_GetSolicitudDescTelcos%found) THEN
          Lv_UsuarioAutoriza:=Lr_GetSolicitudDescTelcos.NOMBRE_APROBACION;
          Lt_FechaAutoriza:=Lr_GetSolicitudDescTelcos.FECHA_APROBACION;   
          Lv_FechaAutForm:=to_char(Lt_FechaAutoriza, 'MM/DD/YYYY');                        
       ELSE
           cod_ret := 2700;
           MSG_RET := 'Saco si existe Solicitud de Descuento en SIT';

           OPEN C_GetSolicitudDescSit(datos.REF_SERVICIO_ID);
           FETCH C_GetSolicitudDescSit INTO Lr_GetSolicitudDescSit;
           IF(C_GetSolicitudDescSit%found) THEN
                Lv_UsuarioAutoriza:=Lr_GetSolicitudDescSit.USR_APROBACION;
                Lt_FechaAutoriza:=Lr_GetSolicitudDescSit.FE_APROBACION_SIT; 
                Lv_FechaAutForm:=to_char(Lt_FechaAutoriza, 'MM/DD/YYYY');         
           END IF;
           CLOSE C_GetSolicitudDescSit; 

       END IF;
       CLOSE C_GetSolicitudDescTelcos;                        

       OPEN lc_escapa_caracter(Lv_UsuarioAutoriza);
       FETCH lc_escapa_caracter INTO lr_escapa_caracter;
       IF(lc_escapa_caracter%found) THEN
         Lv_UsuarioAutoriza:=lr_escapa_caracter.cadena_limpia;         
       end if;
       CLOSE lc_escapa_caracter;  

       cod_ret := 2800;
       MSG_RET := 'Obteniendo Plantilla de Comisionistas por servicio';

       Lv_Plantilla:='';
       FOR DatosRolesPlantillas IN C_GetRolesPlantillas LOOP             
           IF C_GetComisionistasPorRol%ISOPEN THEN
              CLOSE C_GetComisionistasPorRol;
           END IF;           
           OPEN C_GetComisionistasPorRol(datos.id_servicio,DatosRolesPlantillas.ID_PARAMETRO_DET);
           FETCH C_GetComisionistasPorRol INTO Lr_GetComisionistasPorRol;
           IF(C_GetComisionistasPorRol%FOUND) THEN                
                Lv_Plantilla:=Lv_Plantilla || Lr_GetComisionistasPorRol.PLANTILLA ||p_delimitador ;                  
           ELSE
                Lv_Plantilla:=Lv_Plantilla ||p_delimitador;
           END IF;
           CLOSE C_GetComisionistasPorRol; 
       END LOOP;      

       cod_ret := 3000;
       MSG_RET := 'Construyo el contenido del CSV';

       utl_file.put_line(p_archivo,l_login||p_delimitador --1)Login del Punto Cliente o Login_Aux del cliente
                   ||l_ultima_milla||p_delimitador --2)Ultima Milla
                   ||l_switches||p_delimitador--3)Elemento SW
                   ||l_puerto||p_delimitador --4)Puerto
                   ||' '||p_delimitador--5)Bw Internet
                   ||' '||p_delimitador--6)Bw Datos
                   ||l_bwInternet||p_delimitador--7)Bw Total
                   ||' '||p_delimitador --8)Tipo Cliente (Principal/Secundaria)
                   || l_canje ||p_delimitador --9)Clase Cliente  en SIT(Estandar/Cortesia/Demo), 
                                              --en Telcos solo se tiene marcado los Canjes en la forma de PAGO
                   ||l_login_padreFact||p_delimitador --10)Login del Punto Cliente que es Punto Padre de Facturacion
                   ||l_tipo_negocio||p_delimitador --11)Tipo de Negocio del Punto Cliente
                   ||datos.precio_venta_servicio||p_delimitador --12)Precio de Venta del Servicio 
                   ||l_nombre_vendedor||p_delimitador --13)Nombre de Vendedor, si no encuentra registro asigna el usr_vendedor del asignado al Punto
                   ||l_nombre_ingVip||p_delimitador --14)Nombre del Ingeniero Vip asignado al cliente
                   ||l_correo_ingVip||p_delimitador -- 15)Correo del Ingeniero VIP Asignado al Cliente
                   ||l_nombre_cliente||p_delimitador -- 16)Nombre del Cliente
                   ||l_apellidos_cliente||p_delimitador -- 17)Apellidos del Cliente
                   ||l_razon_social_cliente||p_delimitador -- 18)Razon Social del Cliente
                   ||l_direccion_punto||p_delimitador --19)Direccion del Punto Cliente
                   ||' '||p_delimitador -- 20)Codigo de Area Telefono Fijo1
                   ||l_telefono_fijo1||p_delimitador -- 21)Telefono Fijo1 del cliente (Forma de Contacto del Cliente)
                     ||' '||p_delimitador --22)Codigo de Area Telefono Fijo2
                   ||l_telefono_fijo2||p_delimitador -- 23)Telefono Fijo2 del Cliente (Forma de Contacto del Cliente)
                   ||l_correo_contacto||p_delimitador -- 24)Correco del Contacto Comercial del Cliente
                   ||l_sitio_entrega||p_delimitador --25)Ciudad del Cliente (Canton en Telcos) (Ciudad Sitio Entrega en SIT)
                    ||' '||p_delimitador --26)Descripcion del Tipo de Servicio del Cliente (Tipo Producto Servicio en SIT)
                   ||datos.grupo||p_delimitador -- 27)Nombre o Clasificacion del Servicio del Cliente (Mecanismo en el SIT)
                   ||' '||p_delimitador --28)Horario de Atencion
                   ||' '||p_delimitador --29)Horario de Monitoreo
                   ||l_nombres_contacto_tec||p_delimitador -- 30)Nombre de los contactos Tecnicos separados por |
                   ||l_telefono_contactos_tec||p_delimitador -- 31)Telefono Fijo de los Contactos Tecnicos separados por | 
                   ||l_correos_contactos_tec||p_delimitador -- 32)Correos de los Contactos Tecnicos separados por |                   
                   ||l_estado||p_delimitador -- 33)Estado del Servicio del Cliente 
                   ||datos.nombre_oficina||p_delimitador -- 34)Nombre de Oficina del Cliente
                   ||l_fecha_act_form||p_delimitador -- 35)Fecha de Activacion del Servicio
                   ||l_fecha_canc_form||p_delimitador -- 36)Fecha de Cancelacion del Servicio
                   ||datos.es_venta||p_delimitador -- 37)Identificador si servicio es Es Venta o Cortesia S/N
                   ||l_motivo_cortesia||p_delimitador -- 38)Motivo de Cortesia del Servicio
                   ||datos.FRECUENCIA_PRODUCTO||p_delimitador --39)Frecuencia o ciclo de Facturacion del Servicio
                   ||datos.cantidad||p_delimitador --40)Cantidad de items por servicio
                   ||datos.PAGA_IVA||p_delimitador --41)Paga Iva S/N
                   ||datos.VALOR_DESCUENTO||p_delimitador --42)Descuento del Servicio
                   ||l_login_concentrador||p_delimitador --43)Login del Concentrador
                   ||l_loginaux_concentrador||p_delimitador --44)Login Aux del Concentrador
                   ||l_ciudad_concentrador||p_delimitador --45)Ciudad del Concentrador
                   ||datos.marca_elemento||p_delimitador --46)Tipo o marca del elemento (CPE)
                   ||datos.modelo_elemento||p_delimitador --47)Modelo del elemento
                   ||l_motivo_cancelacion||p_delimitador --48)Motivo de Cancelacion
                   ||datos.tipo_de_orden||p_delimitador --49)Tipo de orden Nueva,Traslado,Reubicacion
                   ||datos.id_servicio||p_delimitador --50)Id del Servicio                   
                   ||datos.ES_PREPAGO||p_delimitador --51)Es Prepago S/N  
                   ||l_fecha_fin_contrato_form||p_delimitador--52)Fecha Fin del Contrato Municipio formato mm/dd/yyyy
                   ||l_tiempo_validez_serv||p_delimitador --53)Tiempo de Vaidez del servicio en dias
                   ||datos.COMISION_VENTA||p_delimitador --54)Campo Comision venta 
                   ||datos.COMISION_MANTENIMIENTO||p_delimitador --55)Campo Comision mantenimiento 
                   ||datos.USR_GERENTE||p_delimitador --56)usr del gerente de producto
                   ||l_nombres_contacto_com||p_delimitador -- 57)Nombre de los contactos Comerciales separados por |
                   ||l_telefono_contactos_com||p_delimitador --58)Telefono Fijo de los Contactos Comer. separados por | 
                   ||l_correos_contactos_com||p_delimitador -- 59)Correos de los Contactos Comerciales separados por |  
                   ||l_nombres_contacto_todos||p_delimitador -- 60)Nombre de los contactos adicionales separados por |
                       --Contacto Notificacion, Contacto Facturacion, Contacto Cobranzas, Contacto Gerente general, 
                       --Contacto Encargado del punto, Contacto Gerente financiero, Contacto Administrador de edificio,
                       --Contacto Escalamiento, Contacto Compras, Contacto Importaciones, Contacto Seguridad logica
                   ||l_telefono_contactos_todos||p_delimitador --61)Telefono Fijo de los Contactos adicionales separados por | 
                   ||l_correos_contactos_todos||p_delimitador -- 62)Correos de los Contactos adicionales separados por |  
                   ||l_celular_contactos_todos||p_delimitador -- 63)Celular de los Contactos adicionales separados por |  
                   ||datos.LV_CONCENTRADOR||p_delimitador -- 64)Campo que identifica si el servicio es un Concentrador SI/NO   
                   ||datos.TIPO_ENLACE||p_delimitador -- 65)Campo que identifica el tipo de enlace del servicio, si es PRINCIPAL o BACKUP
                   ||Lv_Descripcion||p_delimitador -- 66)Campo que identifica la descripcion o nombre del Producto
                   ||Lv_UsuarioAutoriza||p_delimitador -- 67)Campo que identifica Persona que Aprobo la Solicitud de descuento del servicio
                   ||Lv_FechaAutForm||p_delimitador -- 68)Campo que identifica Fecha de Aprobacion de la Solicitud de descuento del servicio
                   ||Lv_Plantilla||p_delimitador -- 69-73)Campo que almacena las plantillas de comisionistas por servicio, el numero de columnas 
                                                 -- dependera del numero de GRUPOS_ROLES que exista definido en la Parameter, Cada Columna contiene:
                                                 -- "ROL | NOMBRE PERSONA | %COMISIÓN" 
                   ||datos.subgrupo||p_delimitador  --74)Campo que identifica el subgrupo al que pertenece el producto.
                   ||datos.IDENTIFICACION_CLIENTE ||p_delimitador --75)Campo que muestra la IDENTIFICACIÓN DEL CLIENTE.
                   ||l_login_punto ||p_delimitador --76)Campo que muestra el Login del Punto en Info_Punto.
                   ||datos.linea_negocio||p_delimitador  --77)Campo que identifica la linea de negocio que pertenece el producto.
                   );                                     

   END LOOP;       
   UTL_FILE.fclose(p_archivo);
   dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  

   cod_ret := 3100;
   MSG_RET := 'Imprimiendo Cabecera del Reporte Financiero';

   p_archivoFinanciero := UTL_FILE.fopen(p_directorio, Lv_NombreArchivoFinanciero, 'w', 3000);
   utl_file.put_line(p_archivoFinanciero, 'ID_FACTURA'              || p_delimitador_fact || -- 1)  Cabecera: Id de la Factura
                                          'LOGIN_CLIENTE_SUCURSAL'  || p_delimitador_fact || -- 2)  Cabecera: Login del punto
                                          'ESTADO_CLIENTE_SUCURSAL' || p_delimitador_fact || -- 3)  Cabecera: Estado del Cliente en Oficina facturación
                                          'FECHA_CREACION'          || p_delimitador_fact || -- 4)  Cabecera: Fecha de emisión de la Factura
                                          'NUMERO_DOCUMENTO'        || p_delimitador_fact || -- 5)  Cabecera: Número SRI de la Factura
                                          'VALOR'                   || p_delimitador_fact || -- 6)  Cabecera: Monto total de la Factura
                                          'ESTADO_DOCUMENTO'        || p_delimitador_fact || -- 7)  Cabecera: Estado de la Factura
                                          'DOCUMENTO'               || p_delimitador_fact || -- 8)  Cabecera: Codigo del Tipo de Documentos
                                          'NOMBRE_OFICINA'          || p_delimitador_fact || -- 9)  Cabecera: Nombre de la Oficina de facturación
                                          'FORMA_PAGO');                                -- 10) Cabecera: Forma de Pago 


   cod_ret := 3200;
   MSG_RET := 'Imprimiendo Registros del Reporte Financiero';
   FOR datos in lc_reporteFinanciero LOOP

     utl_file.put_line(p_archivoFinanciero, datos.ID_FACTURA              || p_delimitador_fact || -- 1)  Id de la Factura
                                            datos.LOGIN_CLIENTE_SUCURSAL  || p_delimitador_fact || -- 2)  Login del punto
                                            datos.ESTADO_CLIENTE_SUCURSAL || p_delimitador_fact || -- 3)  Estado del Cliente en Oficina facturación
                                            datos.FECHA_CREACION          || p_delimitador_fact || -- 4)  Fecha de emisión de la Factura
                                            datos.NUMERO_DOCUMENTO        || p_delimitador_fact || -- 5)  Número SRI de la Factura
                                            datos.VALOR                   || p_delimitador_fact || -- 6)  Monto total de la Factura
                                            datos.ESTADO_DOCUMENTO        || p_delimitador_fact || -- 7)  Estado de la Factura
                                            datos.DOCUMENTO               || p_delimitador_fact || -- 8)  Codigo del Tipo de Documentos
                                            datos.NOMBRE_OFICINA          || p_delimitador_fact || -- 9)  Nombre de la Oficina de facturación
                                            datos.FORMA_PAGO);                                -- 10) Forma de Pago
   END LOOP;

   cod_ret := 3300;
   MSG_RET := 'Generando Correo y adjuntando reporte gerencial financiero';
   UTL_FILE.fclose(p_archivoFinanciero);
   dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_GzipFinanciero) ) ;  
   
   -- Se crearon ambos reportes, se ingresan en la tabla de parámetros con estado GENERADO		
	INSERT
	INTO DB_GENERAL.ADMI_PARAMETRO_DET
		(
			ID_PARAMETRO_DET,
			PARAMETRO_ID,
			DESCRIPCION,
			VALOR1,
			VALOR2,
			VALOR3,
			ESTADO,
			USR_CREACION,
			FE_CREACION,
			IP_CREACION,
			EMPRESA_COD,
			OBSERVACION
		)
		VALUES
		(
			DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
			(SELECT ID_PARAMETRO
				FROM DB_GENERAL.ADMI_PARAMETRO_CAB
				WHERE NOMBRE_PARAMETRO = 'REPORTES_GENERADOS'
				AND ESTADO             = 'Activo'
			),
			Lv_NombreArchivoZip, to_char(sysdate, 'DD'), to_char(sysdate, 'MM'), to_char(sysdate, 'YYYY'), 'GENERADO', 'bfonseca',
			SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Reporte gerencial creado.'
		);
	INSERT
	INTO DB_GENERAL.ADMI_PARAMETRO_DET
		(
			ID_PARAMETRO_DET,
			PARAMETRO_ID,
			DESCRIPCION,
			VALOR1,
			VALOR2,
			VALOR3,
			ESTADO,
			USR_CREACION,
			FE_CREACION,
			IP_CREACION,
			EMPRESA_COD,
			OBSERVACION
		)
		VALUES
		(
			DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
			(SELECT ID_PARAMETRO
				FROM DB_GENERAL.ADMI_PARAMETRO_CAB
				WHERE NOMBRE_PARAMETRO = 'REPORTES_GENERADOS'
				AND ESTADO             = 'Activo'
			),
			Lv_NombreArchivoFinancieroZip, to_char(sysdate, 'DD'), to_char(sysdate, 'MM'), to_char(sysdate, 'YYYY'), 'GENERADO', 'bfonseca',
			SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Reporte gerencial creado.'
		);
	COMMIT;	
	
	-- Se intentan subir los archivos pendientes (idealmente serían solo los que se acaban de generar arriba)
	BEGIN
		P_SUBIR_REPORTES_PENDIENTES();
	EXCEPTION
		WHEN OTHERS THEN
			DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
							 'DB_COMERCIAL.CMKG_REPORTES_GERENCIALES.P_SUBIR_REPORTES_PENDIENTES',  
							 'Error al subir reportes pendientes: ' || SQLCODE || ' -ERROR_STACK: '
							 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
							 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
							 SYSDATE, 
							 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
	END;
	
	-- Se intentan notificar los archivos pendientes (idealmente serían solo los que se acaban de subir arriba)
	BEGIN
		P_NOTIFICAR_REP_PENDIENTES();
	EXCEPTION
		WHEN OTHERS THEN
			DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('DB_COMERCIAL', 
							 'DB_COMERCIAL.CMKG_REPORTES_GERENCIALES.P_NOTIFICAR_REP_PENDIENTES',  
							 'Error al notificar reportes pendientes: ' || SQLCODE || ' -ERROR_STACK: '
							 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
							 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_COMERCIAL'),  
							 SYSDATE, 
							 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
	END;	

   cod_ret := 3400;
   MSG_RET := 'Envio de Correo de Informe Tecnico';

   Lv_TextoInforme := '<html><head><meta http-equiv=Content-Type content="text/html; charset=UTF-8"></head><body>
                       <table align="center" width="100%" cellspacing="0" cellpadding="5">
                       <tr><td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;"> 
                       <img alt=""  src="http://images.telconet.net/others/telcos/logo.png"/>        
                       </td></tr><tr>        
                       <td style="border:1px solid #6699CC;"> 
                       <table width="100%" cellspacing="0" cellpadding="5">        
                       <tr><td colspan="2"><table cellspacing="0" cellpadding="2">
                       <tr>
                       <td colspan="2">Estimado usuario:</td>
                       </tr>
                       <tr><td></td></tr>
                       <tr><td>Se ejecut&#243; con exito la generaci&#243;n de los Reportes Gerenciales</td></tr>
                       <tr><td>Ejecuci&#243;n: '|| Lv_Ambiente ||'</td></tr>      
                       <tr><td>IP Ejecuci&#243;n: '|| Lv_IpCreacion ||'</td></tr>
                       <tr><td>Fecha Ejecuci&#243;n: '|| SYSDATE ||'</td></tr>
                       <tr><td>Reporte Comercial Generado: '|| Lv_NombreArchivoZip ||'</td></tr>
                       <tr><td>Reporte Financiero Generado: '|| Lv_NombreArchivoFinancieroZip ||'</td></tr>
                       <tr><td></td></tr>
                       <tr><td></td></tr>
                       <tr>
                       <td colspan="2">Atentamente,</td>
                       </tr>
                       <tr><td></td></tr>
                       <tr>
                       <td colspan="2"><strong>Sistema TelcoS+</strong></td>
                       </tr>
                       </table></td></tr>
                       <tr><td colspan="2"><br></td></tr></table>
                       </td></tr><tr><td></td></tr>
                       <tr><td><strong><font size="2" face="Tahoma">Telconet S.A.</font></strong></p></td></tr></table></body></html>';
    UTL_MAIL.SEND (sender     => F_GET_PARAMETRO('INTEGRACION_TELCODRIVE', 'REMITENTE_NOTIFICACION').VALOR1,
                   recipients => Lv_DestinatarioInforme,                  
                   subject    => Lv_AsuntoInforme,
                   message    => Lv_TextoInforme,
                   mime_type  => 'text/html; charset=UTF-8'
                 );         
   ---------------
   cod_ret := 0;
   MSG_RET := 'OK';
   ---------------    

  exception
   when utl_file.invalid_operation then
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           Lv_NameProcedure,
                                           'Error al crear el archivo: ' || SQLCODE || ' - ERROR_STACK: '
                                                 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      if (lc_obtieneIngVip%isopen) then close lc_obtieneIngVip; end if;
      if (lc_obtieneContacto%isopen) then close lc_obtieneContacto; end if;
      if (lc_FormaContactPorPersYTipo%isopen) then close lc_FormaContactPorPersYTipo; end if;  
      if (lc_obtenerFechaHistorico%isopen) then close lc_obtenerFechaHistorico; end if;  
      if (lc_obtieneMotivoSolCortesia%isopen) then close lc_obtieneMotivoSolCortesia; end if;  
      if (lc_obtenerLoginConcentrador%isopen) then close lc_obtenerLoginConcentrador; end if;     
      if (lc_obtenerMotivoHistorial%isopen) then close lc_obtenerMotivoHistorial; end if;
      if (lc_obtieneVendedor%isopen) then close lc_obtieneVendedor; end if;
      if (lc_obtieneContratoCanje%isopen) then close lc_obtieneContratoCanje; end if;    
      if (lc_obtienePuntoCanje%isopen) then close lc_obtienePuntoCanje; end if;          
      if (lc_obtieneFeFinContrato%isopen) then close lc_obtieneFeFinContrato; end if;  
      if (lc_obtieneTiempoValidezServ%isopen) then close lc_obtieneTiempoValidezServ; end if;        
      if (lc_escapa_caracter%isopen) then close lc_escapa_caracter; end if; 
      if (lc_FormaContactPorPersTodos%isopen) then close lc_FormaContactPorPersTodos; end if;    
      if (C_GetParametroIp%isopen) then close C_GetParametroIp; end if;
      if (C_GetAnchoBanda%isopen) then close C_GetAnchoBanda; end if;     
      IF C_GetSolicitudDescTelcos%ISOPEN THEN
         CLOSE C_GetSolicitudDescTelcos;
      END IF;   
      IF C_GetSolicitudDescSit%ISOPEN THEN
         CLOSE C_GetSolicitudDescSit;
      END IF;  
      IF C_GetComisionistasPorRol%ISOPEN THEN
         CLOSE C_GetComisionistasPorRol;
      END IF;             
    when errorProcedure then      
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           Lv_NameProcedure,
                                           'Error: ' || SQLCODE || ' - ERROR_STACK: '
                                                 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      if (lc_obtieneIngVip%isopen) then close lc_obtieneIngVip; end if;
      if (lc_obtieneContacto%isopen) then close lc_obtieneContacto; end if;
      if (lc_FormaContactPorPersYTipo%isopen) then close lc_FormaContactPorPersYTipo; end if;    
      if (lc_obtenerFechaHistorico%isopen) then close lc_obtenerFechaHistorico; end if; 
      if (lc_obtieneMotivoSolCortesia%isopen) then close lc_obtieneMotivoSolCortesia; end if;
      if (lc_obtenerLoginConcentrador%isopen) then close lc_obtenerLoginConcentrador; end if;   
      if (lc_obtenerMotivoHistorial%isopen) then close lc_obtenerMotivoHistorial; end if;   
      if (lc_obtieneVendedor%isopen) then close lc_obtieneVendedor; end if;
      if (lc_obtieneContratoCanje%isopen) then close lc_obtieneContratoCanje; end if; 
      if (lc_obtienePuntoCanje%isopen) then close lc_obtienePuntoCanje; end if;          
      if (lc_obtieneFeFinContrato%isopen) then close lc_obtieneFeFinContrato; end if;
      if (lc_obtieneTiempoValidezServ%isopen) then close lc_obtieneTiempoValidezServ; end if;        
      if (lc_escapa_caracter%isopen) then close lc_escapa_caracter; end if;      
      if (lc_FormaContactPorPersTodos%isopen) then close lc_FormaContactPorPersTodos; end if;
      if (C_GetParametroIp%isopen) then close C_GetParametroIp; end if;  
      if (C_GetAnchoBanda%isopen) then close C_GetAnchoBanda; end if;   
      IF C_GetSolicitudDescTelcos%ISOPEN THEN
         CLOSE C_GetSolicitudDescTelcos;
      END IF;       
      IF C_GetSolicitudDescSit%ISOPEN THEN
         CLOSE C_GetSolicitudDescSit;
      END IF;             
      IF C_GetComisionistasPorRol%ISOPEN THEN
         CLOSE C_GetComisionistasPorRol;
      END IF; 
    WHEN OTHERS THEN    
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           Lv_NameProcedure,
                                           'Error al crear el archivo: ' || SQLCODE || ' - ERROR_STACK: '
                                                 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      if (lc_obtieneIngVip%isopen) then close lc_obtieneIngVip; end if;
      if (lc_obtieneContacto%isopen) then close lc_obtieneContacto; end if;
      if (lc_FormaContactPorPersYTipo%isopen) then close lc_FormaContactPorPersYTipo; end if;  
      if (lc_obtenerFechaHistorico%isopen) then close lc_obtenerFechaHistorico; end if;  
      if (lc_obtieneMotivoSolCortesia%isopen) then close lc_obtieneMotivoSolCortesia; end if;  
      if (lc_obtenerLoginConcentrador%isopen) then close lc_obtenerLoginConcentrador; end if;     
      if (lc_obtenerMotivoHistorial%isopen) then close lc_obtenerMotivoHistorial; end if;  
      if (lc_obtieneVendedor%isopen) then close lc_obtieneVendedor; end if;
      if (lc_obtieneContratoCanje%isopen) then close lc_obtieneContratoCanje; end if; 
      if (lc_obtienePuntoCanje%isopen) then close lc_obtienePuntoCanje; end if;          
      if (lc_obtieneFeFinContrato%isopen) then close lc_obtieneFeFinContrato; end if;     
      if (lc_obtieneTiempoValidezServ%isopen) then close lc_obtieneTiempoValidezServ; end if;        
      if (lc_escapa_caracter%isopen) then close lc_escapa_caracter; end if;
      if (lc_FormaContactPorPersTodos%isopen) then close lc_FormaContactPorPersTodos; end if;
      if (C_GetParametroIp%isopen) then close C_GetParametroIp; end if; 
      if (C_GetAnchoBanda%isopen) then close C_GetAnchoBanda; end if;  
      IF C_GetSolicitudDescTelcos%ISOPEN THEN
         CLOSE C_GetSolicitudDescTelcos;
      END IF; 
      IF C_GetSolicitudDescSit%ISOPEN THEN
         CLOSE C_GetSolicitudDescSit;
      END IF;  
      IF C_GetComisionistasPorRol%ISOPEN THEN
         CLOSE C_GetComisionistasPorRol;
      END IF;                        
end p_reportComercial;

end CMKG_REPORTES_GERENCIALES;
/