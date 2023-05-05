CREATE OR REPLACE PACKAGE            MIN_INVENTARIOS IS
	/**
	* Documentacion para el paquete 'MIN_INVENTARIOS'
	* Paquete que contiene procedimientos y funciones relacionadas a pre y post algoritmo.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	
	/**
	* Documentacion para la función 'F_ARTICULOS_C'.
	* Función que retorna cursor de la carga inicial por prefijo de empresa y estado para el pre-algoritmo.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_ARTICULOS_C(prefijoEmpresa IN VARCHAR2, estado IN VARCHAR2) RETURN SYS_REFCURSOR;
	
	/**
	* Documentacion para la función 'F_GET_WEEK_INTERVAL'.
	* Retorna la semana a la que pertenece la fecha proporcionada en formato 
	* fecha_lunes:fecha_domingo donde ambas fechas están en formato DD-MM-YYYY
	* @param VARCHAR2 fecha en formato DD-MM-YYYY
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_GET_WEEK_INTERVAL(fecha IN VARCHAR2) RETURN VARCHAR2;
	
	/**
	* Documentacion para la función 'F_VALIDAR_MISMA_SEMANA'.
	* Valida que la semana de la fecha proporcionada sea igual a la de la última inserción en la tabla del post-algoritmo.
	* @param VARCHAR2 fecha_actual fecha de data a ingresar en formato 'DD-MM-YYYY'
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_VALIDAR_MISMA_SEMANA(fecha_actual IN VARCHAR2) RETURN BOOLEAN;
	
	/**
	* Documentacion para la función 'F_GET_SEMANA_INSERCION'.
	* Obtiene la semana de inserción correspondiente.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_GET_SEMANA_INSERCION RETURN NUMBER ;

	/**
	* Documentacion para la función 'F_VALIDAR_EMPRESA'.
	* Valida que el prefijo proporcionado exista en la base de datos.
	* @param VARCHAR2 prefijo_empresa 
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	FUNCTION F_VALIDAR_EMPRESA(prefijo_empresa IN VARCHAR2) RETURN VARCHAR2;
	
	/**
	* Documentacion para el tipo 'ARRTYPE'.
	* Arreglo de tipo VARCHAR2 con índices enteros.
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	TYPE ARRTYPE IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
	
	/**
	* Documentacion para el procedimiento 'P_POSTALGORITMO'.
	* Procedimiento encargado de insertar los artículos del post-algoritmo.
	* Todos los artículos que el usuario envíe termina en la carga de la semana actual, 
	* aunque eso implique sobreescribir lo que se envió un día anterior de la misma semana.
	* @param arr_articulos recibe un array de artículos en formato de objetos JSON en VARCHAR2
	* @param int_insertados OUT NUMBER número de registros insertados. 
	* @param int_actualizados OUT NUMBER número de registros sobreescritos. 
	* @param int_semana OUT NUMBER semana a la que corresponde la inserción. 
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 11-10-2022
	*/
	PROCEDURE P_POSTALGORITMO(arr_articulos IN OUT ARRTYPE, int_semana IN NUMBER, int_insertados OUT NUMBER, int_actualizados OUT NUMBER, Lv_tiene_error OUT VARCHAR2);
END MIN_INVENTARIOS;
/


CREATE OR REPLACE PACKAGE BODY            MIN_INVENTARIOS IS	
	FUNCTION F_ARTICULOS_C(prefijoEmpresa IN VARCHAR2, estado IN VARCHAR2) 
	RETURN SYS_REFCURSOR 
	IS
		C_ARTICULOS SYS_REFCURSOR;			
	BEGIN
		-- se crea un cursor para la consulta
		OPEN C_ARTICULOS FOR 
		(
			q'[SELECT iarm.NO_CIA, iarm.NO_ARTI, iarm.ID_REGION, iarm.BODEGA, 
						iarm.REGLA, iarm.STOCK_MINIMO, iarm.STOCK_MAXIMO
				FROM NAF47_TNET.INV_ARTI_RECU_MASTER iarm 
				INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg ON ieg.COD_EMPRESA = iarm.NO_CIA
				WHERE ieg.PREFIJO = ']'  || prefijoEmpresa ||
				q'[' AND iarm.ESTADO = ']' || estado || q'[']'
		);			
		RETURN C_ARTICULOS;
	END F_ARTICULOS_C;	
	
	FUNCTION F_VALIDAR_EMPRESA(prefijo_empresa IN VARCHAR2) 
	RETURN VARCHAR2
	IS
		contador_registros NUMBER := 0;
	BEGIN
		SELECT COUNT(*) INTO contador_registros FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
			WHERE ieg.PREFIJO = UPPER(prefijo_empresa);
		
		IF contador_registros > 0 THEN
			RETURN 'true';
		END IF;
		
		RETURN 'false';
	END;
	
	FUNCTION F_GET_WEEK_INTERVAL(fecha IN VARCHAR2)
	RETURN VARCHAR2 
	IS	
		Lv_date date := TO_DATE(fecha, 'dd-mm-yyyy');
		Lv_date_monday date := Lv_date;
		Lv_date_sunday date := Lv_date;
	BEGIN	
		WHILE(TO_CHAR(Lv_date_monday, 'D') <> 2)
		LOOP
			Lv_date_monday := Lv_date_monday - 1;
		END LOOP;
		Lv_date_sunday := Lv_date_monday + 6;
		RETURN (TO_CHAR(Lv_date_monday, 'dd-mm-yyyy') || ':' || TO_CHAR(Lv_date_sunday, 'dd-mm-yyyy'));
	END F_GET_WEEK_INTERVAL;	
	
	-- La fecha debe estar en formato 'dd-mm-yyyy'
	FUNCTION F_VALIDAR_MISMA_SEMANA(fecha_actual IN VARCHAR2)
	RETURN BOOLEAN 
	IS	
		fecha_ultima_insercion date;
		semana_ultima_insercion VARCHAR2(100);
		semana_actual VARCHAR2(100);
		
		Lv_contador_articulos_post NUMBER; 
	BEGIN	
		SELECT COUNT(sq.SEMANA) INTO Lv_contador_articulos_post FROM 
			(SELECT SEMANA FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP ORDER BY SEMANA DESC) sq 
			WHERE ROWNUM <= 1;
		
		-- Si hay artículos en la tabla de post-algoritmo
		IF Lv_contador_articulos_post > 0 THEN
			-- Se consigue la última fecha
			SELECT sq.FECHA_CREACION INTO fecha_ultima_insercion FROM 
				(SELECT FECHA_CREACION FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP ORDER BY SEMANA DESC) sq 
				WHERE ROWNUM <= 1;
		ELSE
			-- Si no hay artículos
			RETURN FALSE; 
		END IF;
		
		-- Se consigue la semana de esa fecha
		semana_ultima_insercion := F_GET_WEEK_INTERVAL(TO_CHAR(fecha_ultima_insercion, 'dd-mm-yyyy'));
		-- Se consigue la semana de la fecha que se trata de insertar
		semana_actual := F_GET_WEEK_INTERVAL(fecha_actual);
		RETURN semana_ultima_insercion = semana_actual;
	END F_VALIDAR_MISMA_SEMANA;
	
	FUNCTION F_GET_SEMANA_INSERCION
	RETURN NUMBER 
	IS	
		Lv_numero_semana NUMBER;		
		Lv_contador_articulos_post NUMBER; 
		Lv_es_misma_semana BOOLEAN;
	BEGIN	
		SELECT COUNT(sq.SEMANA) INTO Lv_contador_articulos_post FROM 
			(SELECT SEMANA FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP ORDER BY SEMANA DESC) sq 
			WHERE ROWNUM <= 1;
		
		-- Si no hay data en la tabla del post-algoritmo
		IF Lv_contador_articulos_post = 0 THEN
			-- Será la primera semana
			RETURN 1;
		END IF;
		
		-- Si hay data	
		IF Lv_contador_articulos_post > 0 THEN
			-- Se consigue la semana del último
			SELECT sq.SEMANA INTO Lv_numero_semana FROM 
				(SELECT SEMANA FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP ORDER BY SEMANA DESC) sq 
				WHERE ROWNUM <= 1;
		END IF;
		
		-- Se compara la semana actual con la del último artículo
		Lv_es_misma_semana := F_VALIDAR_MISMA_SEMANA(to_char(sysdate, 'DD-MM-YYYY'));		
		
		IF NOT Lv_es_misma_semana THEN
			-- Si la semana actual es diferente a la del último artículo
			-- Se conseguirá la siguiente
			Lv_numero_semana := Lv_numero_semana + 1;
		END IF;		
		
		-- Si la semana actual es la misma que la del último artículo, se conservará esa semana
		RETURN Lv_numero_semana;
	END F_GET_SEMANA_INSERCION;
	
	
	
	PROCEDURE P_POSTALGORITMO(arr_articulos IN OUT ARRTYPE, int_semana IN NUMBER, int_insertados OUT NUMBER, int_actualizados OUT NUMBER, Lv_tiene_error OUT VARCHAR2) IS
		Lv_no_cia_i NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE;
		Lv_no_articulo_i NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE;
		Lv_id_region_i NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE;
		Lv_stock_minimo_i NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE;
		Lv_stock_maximo_i NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE;				
		Lv_index NUMBER;	
		Lv_contador_duplicados NUMBER; -- para comprobar si se está tratando de ingresar un artículo que ya existe
		
		CURSOR c_carga_inicial is 
			SELECT sq.NO_CIA, sq.NO_ARTI, sq.ID_REGION, sq.STOCK_MINIMO, sq.STOCK_MAXIMO FROM (
				SELECT NO_CIA, NO_ARTI, ID_REGION, STOCK_MINIMO, STOCK_MAXIMO FROM NAF47_TNET.INV_ARTI_RECU_MASTER iarm
			) sq;
	BEGIN	
		Lv_tiene_error := 'false';
		int_insertados   := 0;
		int_actualizados := 0;
		
		-- Se itera el array de artículos a insertar
		Lv_index := arr_articulos.FIRST; -- primer índice (1)
		WHILE (Lv_index is not null)  LOOP    
			-- Se parsea el JSON y se recuperan las propiedades de interés
			APEX_JSON.PARSE(arr_articulos(Lv_index));
			Lv_no_cia_i := APEX_JSON.get_varchar2(p_path => 'ID_EMPRESA');
			Lv_no_articulo_i := APEX_JSON.get_varchar2(p_path => 'NO_ARTICULO');
			Lv_id_region_i := APEX_JSON.get_varchar2(p_path => 'ID_REGION');
			Lv_stock_minimo_i := APEX_JSON.get_varchar2(p_path => 'STOCK_MINIMO');
			Lv_stock_maximo_i := APEX_JSON.get_varchar2(p_path => 'STOCK_MAXIMO');
			
			SELECT COUNT(*) INTO Lv_contador_duplicados FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP aart
				WHERE aart.ID_EMPRESA = Lv_no_cia_i AND aart.ID_ARTICULO = Lv_no_articulo_i AND aart.ID_REGION = Lv_id_region_i
				AND aart.MES = to_char(SYSDATE, 'MM') AND aart.ANIO = to_char(SYSDATE, 'YYYY') AND aart.SEMANA = int_semana;
				
			IF Lv_contador_duplicados > 0 THEN
				-- Se está tratando de ingresar un duplicado
				-- Se actualiza ese duplicado
				UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP aart
					SET CANTIDAD_MINIMA = NVL2(Lv_stock_minimo_i, Lv_stock_minimo_i, 0), CANTIDAD_MAXIMA = NVL2(Lv_stock_maximo_i, Lv_stock_maximo_i, 0)
					WHERE aart.ID_EMPRESA = Lv_no_cia_i AND aart.ID_ARTICULO = Lv_no_articulo_i AND aart.ID_REGION = Lv_id_region_i
					AND aart.MES = to_char(SYSDATE, 'MM') AND aart.ANIO = to_char(SYSDATE, 'YYYY') AND aart.SEMANA = int_semana;
				int_actualizados := int_actualizados + 1;
			ELSE
				INSERT INTO NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
					(ID_EMPRESA, ID_ARTICULO, ID_REGION, CANTIDAD_MINIMA, CANTIDAD_MAXIMA, 
					MES, ANIO, ESTADO, OBSERVACION, USR_CREACION, FECHA_CREACION, 
					USR_ULT_MOD, FECHA_ULT_MOD, SEMANA) 
				VALUES
					(Lv_no_cia_i, Lv_no_articulo_i, Lv_id_region_i, NVL2(Lv_stock_minimo_i, Lv_stock_minimo_i, 0), NVL2(Lv_stock_maximo_i, Lv_stock_maximo_i, 0), 
					to_char(SYSDATE, 'MM'), to_char(SYSDATE, 'YYYY'),
					'I', 'Articulo ingresado', 'NAF_ARIN', SYSDATE, 
					'SYS', SYSDATE, int_semana);	
				int_insertados := int_insertados + 1;
			END IF;		
			Lv_index := arr_articulos.NEXT(Lv_index);
		END LOOP;		
		COMMIT;		
	EXCEPTION
		WHEN others THEN
			Lv_tiene_error := 'true'; -- Para notificar a PHP
			DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF', 
												 'NAF47_TNET.P_POSTALGORITMO',  
												 'Error ingresando o actualizando carga de post-algoritmo',  
												 NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'),  
												 SYSDATE, 
												 NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
	END P_POSTALGORITMO;
	
END MIN_INVENTARIOS;
/
