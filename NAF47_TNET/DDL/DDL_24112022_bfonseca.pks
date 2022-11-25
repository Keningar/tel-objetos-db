CREATE OR REPLACE PACKAGE NAF47_TNET.GENERAR_IMG_EMPLEADOS_TN IS
	/**
	* Documentacion para el paquete 'GENERAR_IMG_EMPLEADOS_TN'
	* Paquete para generar fotos de empleados de TN en directorio del servidor usando tabla NAF47_TNET.ARPLME.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 24-11-2022
	*/
	
	-- Nombre de la cabacera que contiene los parámetros usados por este paquete.
	NOMBRE_PARAMETRO_CAB VARCHAR2(128) := 'FOTOS_EMPLEADOS_TN';

	/**
	* Documentacion del procedimiento P_GENERAR_IMG_EMPLEADOS_TN
	* Convierte las fotos de empleados activos de TN guardadas como CLOB en la tabla ARPLME a binarios JPEG y 
	* las guarda en el directorio /naf/inve/reportes/fotos_empleados_tn
	* Las fotos generadas tienen como nombre los números de cédula de los empleados seguidos del formato .jpeg
	*
	* Cada vez que se ejecute este procedimiento se SOBREESCRIBIRÁN las fotos del directorio 
	* /naf/inve/reportes/fotos_empleados_tn que pudieran haber sido generadas en una ejecución anterior. 
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 24-11-2022
	*/
	PROCEDURE P_GENERAR_IMG_EMPLEADOS_TN;
END GENERAR_IMG_EMPLEADOS_TN;
/
CREATE OR REPLACE PACKAGE BODY NAF47_TNET.GENERAR_IMG_EMPLEADOS_TN IS
	FUNCTION F_GET_PARAMETRO(p_descripcion VARCHAR2) RETURN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE
	AS
		detalleParametroRow DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
	BEGIN
		SELECT apd.* INTO detalleParametroRow
		FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc 
			INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET apd ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
		WHERE apc.NOMBRE_PARAMETRO = NOMBRE_PARAMETRO_CAB 
		AND apd.DESCRIPCION = p_descripcion;
		RETURN detalleParametroRow;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20007, 'No se encontró el parámetro ' || p_descripcion || '.');
	END;

	/**
		Guarda la foto en el directorio especificado y retorna el nombre del archivo.
	*/
	FUNCTION F_guardarFoto(p_nombre_dir_base VARCHAR2, p_cedula_empleado VARCHAR2, p_foto_clob CLOB) RETURN VARCHAR2 AS
		lengthFotoBlob NUMBER;
		lengthFotoBlobTmp NUMBER;
		fotoBlob BLOB;
		bufferLength NUMBER := 32000; -- buffer
		vstart NUMBER := 1;
		imageBuffer RAW(32000);
		imagenFile utl_file.file_type;
		nombreFoto VARCHAR2(128) := p_cedula_empleado || '.jpeg';
	BEGIN
	
		fotoBlob := APEX_WEB_SERVICE.CLOBBASE642BLOB(p_foto_clob);
		imagenFile := UTL_FILE.fopen(p_nombre_dir_base, nombreFoto, 'wb', 32760);
		lengthFotoBlob := dbms_lob.getlength(fotoBlob);
		lengthFotoBlobTmp := lengthFotoBlob; -- Se cambia en cada iteración
		
		-- Se puede escribir toda la imagen de una sola pieza	
		IF lengthFotoBlob < 32760 THEN
			utl_file.put_raw(imagenFile, fotoBlob);
			utl_file.fflush(imagenFile);
		ELSE 
			vstart := 1;
			WHILE vstart < lengthFotoBlob AND bufferLength > 0
			LOOP
				dbms_lob.read(fotoBlob, bufferLength, vstart, imageBuffer);
				utl_file.put_raw(imagenFile, imageBuffer);
				utl_file.fflush(imagenFile);
				-- Se establece la posición de inicio para el siguiente buffer
				vstart := vstart + bufferLength;				
				lengthFotoBlobTmp := lengthFotoBlobTmp - bufferLength;
				-- Si queda menos de 32000, se usa eso como tamaño de buffer
				IF lengthFotoBlobTmp < 32000 THEN
					bufferLength := lengthFotoBlobTmp;
				END IF;
			END LOOP;
		END IF;
		utl_file.fclose(imagenFile);
		RETURN nombreFoto;
	END F_guardarFoto;

	PROCEDURE P_GENERAR_IMG_EMPLEADOS_TN 
	AS	
		nombreDirBase VARCHAR2(128) := F_GET_PARAMETRO('DIR_FOTOS_EMPLEADOS_TN_BASE').VALOR1;
		nombreDirDestino VARCHAR2(128) := F_GET_PARAMETRO('DIR_FOTOS_EMPLEADOS_TN_DESTINO').VALOR1;
		nombreDirectorioSO VARCHAR2(128);
		nombreFotoGuardada VARCHAR2(128);
		contadorImagenes NUMBER := 0;
	
		CURSOR cursorEmpleados IS (
			SELECT nombre, CEDULA, FOTO FROM NAF47_TNET.ARPLME 
				WHERE 
				NO_CIA = 10 AND 
				ESTADO = 'A' AND 
				FOTO IS NOT NULL AND
				dbms_lob.substr(FOTO, 100, 1) <> 'AAAAAA==');				
	BEGIN
		SELECT DIRECTORY_PATH INTO nombreDirectorioSO FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = nombreDirBase;
		dbms_output.put_line(NAF47_TNET.JAVARUNCOMMAND('rm -rf ' || nombreDirectorioSO || nombreDirDestino)); 
		dbms_output.put_line(NAF47_TNET.JAVARUNCOMMAND('mkdir ' || nombreDirectorioSO || nombreDirDestino)); 
		FOR empleado IN cursorEmpleados
		LOOP
			nombreFotoGuardada := F_guardarFoto(nombreDirBase, empleado.cedula, empleado.foto);
			-- Se mueve la foto generada al directorio creado
			dbms_output.put_line(NAF47_TNET.JAVARUNCOMMAND('mv ' || nombreDirectorioSO || nombreFotoGuardada || ' ' || nombreDirectorioSO || nombreDirDestino)); 	
			contadorImagenes := contadorImagenes + 1;
		END LOOP;
		dbms_output.put_line('Se generaron ' || contadorImagenes || ' imagenes');
	EXCEPTION
		WHEN OTHERS THEN
			DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF47_TNET', 
						 'NAF47_TNET.P_GENERAR_IMG_EMPLEADOS_TN',  
						 SQLCODE || ' -ERROR_STACK: '
						 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
						 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'NAF47_TNET'),  
						 SYSDATE, 
						 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
	END P_GENERAR_IMG_EMPLEADOS_TN;
	
END GENERAR_IMG_EMPLEADOS_TN;
/