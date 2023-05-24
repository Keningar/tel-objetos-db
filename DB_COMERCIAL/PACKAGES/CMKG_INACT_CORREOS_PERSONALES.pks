CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INACT_CORREOS_PERSONALES AS

	/**
	* Inactiva correos personales de empleados de TN en INFO_PERSONA_FORMA_CONTACTO
	*
	* @author Bryan Fonseca <bfonseca@telconet.ec>
	* @version 1.0 01-07-2022
	**/
	PROCEDURE P_INACTIVAR_CORREOS_PERSONALES;
	
END CMKG_INACT_CORREOS_PERSONALES;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INACT_CORREOS_PERSONALES AS

	PROCEDURE P_INACTIVAR_CORREOS_PERSONALES IS
		CURSOR C_CORREOS IS 
		SELECT ipfc.ID_PERSONA_FORMA_CONTACTO, sq.ID_PERSONA, ipfc.VALOR AS CORREO 
		FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc 
		INNER JOIN (
			SELECT DISTINCT ip.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA ip 
				INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON iper.PERSONA_ID = ip.ID_PERSONA
				INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL
				INNER JOIN DB_GENERAL.ADMI_ROL ar ON ar.ID_ROL = ier.ROL_ID
				WHERE iper.ESTADO = 'Activo' AND ar.TIPO_ROL_ID = '1' AND ier.EMPRESA_COD IN ('10', '18')
			) sq ON sq.ID_PERSONA = ipfc.PERSONA_ID
		WHERE ipfc.FORMA_CONTACTO_ID = 5 AND ipfc.ESTADO IN ('Activo', 'Modificado')
		ORDER BY ipfc.PERSONA_ID;
	
		Lv_id_persona NUMBER;
		Lv_id_persona_forma_contacto NUMBER;
		Lv_correo VARCHAR2(100);
		Lv_nombre_persona VARCHAR2(200);
		
		Lv_contador_correos_corp NUMBER := 0;
		Lv_contador_desactivados NUMBER := 0;
		Lv_contador_commits NUMBER := 0;
		
		-- Se crea una tabla con el tipo de fila del cursor
		TYPE tabla_bulk IS TABLE OF C_CORREOS%rowtype INDEX BY BINARY_INTEGER;
		tabla_persona_contacto tabla_bulk;
		
		idx NUMBER;
		
		FUNCTION F_esCorporativo(P_CORREO VARCHAR2) RETURN BOOLEAN IS
		CURSOR c_regexp_patterns IS 
			SELECT '.*' || DOMINIO as pattern FROM NAF47_TNET.ARCGMC WHERE DOMINIO IS NOT NULL;
		BEGIN
			FOR regexpPattern_row IN c_regexp_patterns LOOP
				IF (REGEXP_LIKE(P_CORREO, regexpPattern_row.pattern)) THEN
					RETURN TRUE;				
				END IF;							
			END LOOP;
			RETURN FALSE;
		END F_esCorporativo;
		
		FUNCTION F_tieneCorreosCorporativos(P_PERSONA_ID VARCHAR2) RETURN BOOLEAN IS
			CURSOR C_CORREOS_EMPLEADO IS
				SELECT VALOR FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc 
					WHERE ipfc.PERSONA_ID = P_PERSONA_ID
					AND ipfc.ESTADO = 'Activo'
					AND ipfc.FORMA_CONTACTO_ID = 5;
		BEGIN
			FOR correo_empleado_row IN C_CORREOS_EMPLEADO LOOP			
				IF (F_esCorporativo(correo_empleado_row.VALOR)) THEN
					RETURN TRUE;				
				END IF;							
			END LOOP;
			RETURN FALSE;
		END F_tieneCorreosCorporativos;
	BEGIN
		OPEN C_CORREOS;
			LOOP
				-- Collecta de 1000 en 1000
				FETCH C_CORREOS BULK COLLECT INTO tabla_persona_contacto LIMIT 1000;	
				
				idx := tabla_persona_contacto.FIRST();
				
				WHILE (idx IS NOT NULL) LOOP				
					Lv_id_persona := tabla_persona_contacto(idx).ID_PERSONA;
					Lv_id_persona_forma_contacto := tabla_persona_contacto(idx).ID_PERSONA_FORMA_CONTACTO;
					Lv_correo := tabla_persona_contacto(idx).CORREO;
					
					idx := tabla_persona_contacto.NEXT(idx);
					
					SELECT (ip.NOMBRES || ' ' || ip.APELLIDOS) INTO Lv_nombre_persona
					FROM DB_COMERCIAL.INFO_PERSONA ip WHERE ip.ID_PERSONA = Lv_id_persona;
		
					-- Si el correo no es de TN o MD
					IF (NOT F_esCorporativo(Lv_correo)) THEN
										
						-- Si es un empleado sin correo corporativo, no se inactivar� su correo personal
						IF NOT F_tieneCorreosCorporativos(Lv_id_persona) THEN
							CONTINUE;
						END IF;				
						
						-- Se inactiva el correo actual
						UPDATE DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc SET ipfc.ESTADO = 'Inactivo'
							WHERE ipfc.ID_PERSONA_FORMA_CONTACTO = Lv_id_persona_forma_contacto;
							
						Lv_contador_commits := Lv_contador_commits + 1;
						Lv_contador_desactivados := Lv_contador_desactivados + 1;
					END IF;		
					
					IF Lv_contador_commits >= 100 THEN 
						COMMIT;
						Lv_contador_commits := 0;
					END IF;
	
				END LOOP;	
				
				EXIT WHEN C_CORREOS%NOTFOUND;
			END LOOP;
		CLOSE C_CORREOS;
		COMMIT;
		dbms_output.put_line('Se desactivaron ' || Lv_contador_desactivados || ' correos personales.'); 
	EXCEPTION
	   WHEN others THEN 
		  dbms_output.put_line('Error inactivando correos personales de empleados.'|| SQLCODE || SQLERRM); 
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_INACT_CORREOS_PERSONALES', 
                                               'P_INACTIVAR_CORREOS_PERSONALES',  
                                               'Error inactivando correos personales de empleados.'|| SQLCODE || SQLERRM,  
                                               NVL(SYS_CONTEXT('USERENV', 'HOST'), 'DB_COMERCIAL'),  
                                               SYSDATE, 
                                               NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

	END;
	
END CMKG_INACT_CORREOS_PERSONALES;
/