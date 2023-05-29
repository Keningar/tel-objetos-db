CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_MIGRACION_TOKEN_ID_CSV IS

   /**
    * Documentación para el procedimiento valida_cadena
    *
    * Método encargado para validar la cadena del archivo
    *
    * @param pv_cadena_parametros    IN  VARCHAR2 cadena a validar
    * @param pv_separador            IN  VARCHAR2 separador de campos
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.0 24-04-2022
    */  
  FUNCTION valida_cadena(pv_cadena_parametros IN VARCHAR2,
                         pv_separador         IN VARCHAR2) RETURN VARCHAR2 ;
                            /**
    * Documentación para el procedimiento P_MIGRAR_TOKEN_ID_CSV
    *
    * Método encargado para validar la cadena del archivo
    *
    * @param pv_cadena_parametros    IN  VARCHAR2 cadena de parametros
    * @param pv_separador            IN  VARCHAR2 deparador de campos
    * @param pn_pos_campo          IN  VARCHAR2 posicion del campo a obtener
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.0 24-04-2022
    */  
  FUNCTION OBTENER_CAMPO_TRAMA(pv_cadena_parametros IN VARCHAR2,
                               pv_separador         IN VARCHAR2 DEFAULT '|',
                               pn_pos_campo         IN NUMBER) RETURN VARCHAR2 ;

   /**
    * Documentación para el procedimiento P_MIGRAR_TOKEN_ID_CSV
    *
    * Método encargado de leer un archivo .CSV y extraer el campo TOKEN e insertarlos
    * en la tabla INFO_PERSONA_EMPRESA_ROL_CARAC
    *
    * @param Pv_FileName    IN  VARCHAR2 ruta y nombre del archivo cvs
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.0 24-04-2022
    */  
    PROCEDURE P_MIGRAR_TOKEN_ID_CSV(
	    Pv_FileName    IN VARCHAR2,
	    Pv_Mensaje   OUT VARCHAR2);

END CMKG_MIGRACION_TOKEN_ID_CSV;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_MIGRACION_TOKEN_ID_CSV IS

/* Valida si existe el separado al inicio y fin de la trama */
  FUNCTION valida_cadena(pv_cadena_parametros IN VARCHAR2,
                         pv_separador         IN VARCHAR2) RETURN VARCHAR2 IS
    
    lv_cadena_parametro VARCHAR2(4000);
  BEGIN
    
    -- Si existen espacios en blanco al inicio y al final los quita.
    lv_cadena_parametro := TRIM(pv_cadena_parametros);
    
    -- Verifica si al inicio de la cadena existe el separador, por verdadero lo quita.
    IF SUBSTR(lv_cadena_parametro,0,1) = pv_separador THEN
      lv_cadena_parametro := SUBSTR(lv_cadena_parametro,2);
    END IF;
    
    -- Verifica si al final de la cadena existe el separador.
    IF SUBSTR(lv_cadena_parametro,-1) <> pv_separador THEN
      lv_cadena_parametro := lv_cadena_parametro || pv_separador;
    END IF;
    
    RETURN lv_cadena_parametro;
  EXCEPTION
    WHEN OTHERS THEN
      lv_cadena_parametro:= pv_cadena_parametros;
      RETURN lv_cadena_parametro;
  END valida_cadena;
  
  FUNCTION OBTENER_CAMPO_TRAMA(pv_cadena_parametros IN VARCHAR2,
                               pv_separador         IN VARCHAR2 DEFAULT '|',
                               pn_pos_campo         IN NUMBER) RETURN VARCHAR2 IS
    
    lv_cadena_parametros VARCHAR2(4000);
    lv_campo_cadena   VARCHAR2(4000);
    ln_pos_pipe_desde NUMBER := 0;
    ln_pos_pipe_hasta NUMBER;
  BEGIN
    lv_cadena_parametros := valida_cadena(pv_cadena_parametros, pv_separador);
    IF pn_pos_campo > 1 THEN
      ln_pos_pipe_desde := instr(lv_cadena_parametros,
                                 pv_separador,
                                 1,
                                 pn_pos_campo - 1);
    END IF;
    ln_pos_pipe_hasta := instr(lv_cadena_parametros,
                               pv_separador,
                               1,
                               pn_pos_campo);
    lv_campo_cadena   := substr(lv_cadena_parametros,
                                ln_pos_pipe_desde + 1,
                                ln_pos_pipe_hasta - ln_pos_pipe_desde - 1);
    RETURN lv_campo_cadena;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END OBTENER_CAMPO_TRAMA;


        
        PROCEDURE P_MIGRAR_TOKEN_ID_CSV (
        Pv_FileName                IN                       VARCHAR2,
        Pv_Mensaje                  OUT                      VARCHAR2
    ) AS

            Infile                         UTL_FILE.FILE_TYPE;
            Linebuf                        VARCHAR2 (4000);
            V_Getstring                    VARCHAR2 (100);
            Lv_Directorio                  VARCHAR2(50) := 'RESPSOLARIS';
            ln_Id_Caract_Push_Cliente      NUMBER;
            ln_Id_Persona_Rol              NUMBER;
            lv_Token                       VARCHAR2 (4000);
            lv_Identificacion              VARCHAR2 (14);
            ln_Id_Per_Emp_Rol_carac        NUMBER;

            -- Field Values Array tokenClientesPipe.csv tokenClientesPipe.csv
            TYPE Fieldvalue IS TABLE OF VARCHAR2 (100)
                                    INDEX BY BINARY_INTEGER;

            Field_Position        Fieldvalue;

            Total_Rec_Count       NUMBER := 0;
            Total_Rec_Processed   NUMBER := 0;
            
            CURSOR C_GetIdCaracteristica IS
            SELECT 
                AC.ID_CARACTERISTICA
            FROM
                DB_COMERCIAL.ADMI_CARACTERISTICA AC
            WHERE
                AC.DESCRIPCION_CARACTERISTICA = 'PUSH_ID_CLIENTE' AND AC.ESTADO = 'Activo';
            
            CURSOR C_GetIdPersonaRol (Cv_IdentificacionCliente IN VARCHAR2) IS
            SELECT 
                IPER.ID_PERSONA_ROL  
            FROM 
                DB_COMERCIAL.INFO_PERSONA IP, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
            WHERE 
                IP.ID_PERSONA = IPER.PERSONA_ID  
            AND 
                IP.IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente
            AND 
                IPER.EMPRESA_ROL_ID = 813
            AND 
                IP.ESTADO = 'Activo'
            AND 
                IPER.ESTADO = 'Activo';
                
            CURSOR C_Get_IdPerEmpRolCaracExist (Cv_IdPersonaEmpresaRolId IN NUMBER, Cn_IdCaracterisitca IN NUMBER) IS
            SELECT IPRC.ID_PERSONA_EMPRESA_ROL_CARACT 
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPRC
            WHERE IPRC.PERSONA_EMPRESA_ROL_ID = Cv_IdPersonaEmpresaRolId 
            AND IPRC.CARACTERISTICA_ID = Cn_IdCaracterisitca 
            AND IPRC.ESTADO = 'Activo';
            
            
            BEGIN
            
              OPEN C_GetIdCaracteristica;   
              FETCH C_GetIdCaracteristica INTO ln_Id_Caract_Push_Cliente;   
              CLOSE C_GetIdCaracteristica;                      

            Infile := UTL_FILE.FOPEN(Lv_Directorio, Pv_FileName , 'R');
            
            LOOP
               lv_Token:=null;
               lv_Identificacion :=null;
               
                UTL_FILE.Get_Line (Infile, Linebuf);
                
               lv_Token := OBTENER_CAMPO_TRAMA(Linebuf,'|',2); 
               lv_Identificacion := OBTENER_CAMPO_TRAMA(Linebuf,'|',1); 
              
               IF lv_Token is not null or lv_Identificacion is not null
            THEN
            ln_Id_Persona_Rol:=null;
               OPEN C_GetIdPersonaRol(lv_Identificacion);   
              FETCH C_GetIdPersonaRol INTO ln_Id_Persona_Rol;   
              CLOSE C_GetIdPersonaRol;           
          
            END IF;
              
                BEGIN
                
                    IF ln_Id_Persona_Rol is not null and lv_Token is not null
                    THEN
                    ln_Id_Per_Emp_Rol_carac := null;
                    
                    OPEN C_Get_IdPerEmpRolCaracExist(ln_Id_Persona_Rol,ln_Id_Caract_Push_Cliente);   
                    FETCH C_Get_IdPerEmpRolCaracExist INTO ln_Id_Per_Emp_Rol_carac;   
                    CLOSE C_Get_IdPerEmpRolCaracExist;
                    
                      IF ln_Id_Per_Emp_Rol_carac is not null
                       THEN
                        update DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC set ESTADO='Inactivo', FE_ULT_MOD = SYSDATE , USR_ULT_MOD = 'agiraldo'
                         where ID_PERSONA_EMPRESA_ROL_CARACT = ln_Id_Per_Emp_Rol_carac;
                      END IF;
                      
                    INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC (ID_PERSONA_EMPRESA_ROL_CARACT, 
                                                                                     PERSONA_EMPRESA_ROL_ID,
                                                                                     CARACTERISTICA_ID, 
                                                                                     VALOR, 
                                                                                     FE_CREACION, 
                                                                                     USR_CREACION, 
                                                                                     IP_CREACION, 
                                                                                     ESTADO)
                    VALUES (db_comercial.SEQ_INFO_PERSONA_EMP_ROL_CARAC.nextval, 
                                    ln_Id_Persona_Rol,
                                     ln_Id_Caract_Push_Cliente, 
                                     lv_Token, 
                                     SYSDATE,
                                     'agiraldo',
                                     '127.0.0.1', 
                                     'Activo');
                    
                    IF total_rec_processed = 500
                    THEN
      
                    COMMIT;
                    
                    total_rec_processed := 0;
                    ELSE
                     Total_Rec_Processed := Total_Rec_Processed + 1; 
                    
                    END IF;
 
                     END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                        'CMKG_MIGRACION_TOKEN_ID_CSV.P_MIGRAR_TOKEN_ID_CSV', 
                                                        substr(SQLERRM,1,200),
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                        SYSDATE, 
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') 
                                                      );
                END;
            END LOOP;

            IF UTL_FILE.is_open (infile)
            THEN
                UTL_FILE.Fclose (Infile);
            END IF;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                IF UTL_FILE.is_open (infile)
                THEN
                    UTL_FILE.Fclose (Infile);
                END IF;
            IF total_rec_processed > 0
            THEN
               COMMIT;
            END IF;
            WHEN OTHERS
            THEN
                IF UTL_FILE.is_open (infile)
                THEN
                    UTL_FILE.Fclose (Infile);
                END IF;

                Pv_Mensaje := SQLERRM;
            
         
        
    END P_MIGRAR_TOKEN_ID_CSV;

END CMKG_MIGRACION_TOKEN_ID_CSV;
/
