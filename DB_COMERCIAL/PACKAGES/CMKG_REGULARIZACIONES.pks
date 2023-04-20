CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REGULARIZACIONES AS

   
    /**
    * Documentación para la función P_ROLES_ENUNCIADOS
    * Procedimiento para regularizar clientes que tiene roles repetidos en enunciados
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta 
    *
    * @author Carlos Caguana <ccaguana@telconet.ec>
    * @version 1.0 18-04-2023
    */
    PROCEDURE P_ROLES_ENUNCIADOS(      Pcl_Request       CLOB,
                                       Pv_Mensaje        OUT VARCHAR2,
                                       Pv_Status         OUT VARCHAR2,
                                       Pcl_Response      OUT SYS_REFCURSOR);

END CMKG_REGULARIZACIONES;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REGULARIZACIONES AS

 
PROCEDURE P_ROLES_ENUNCIADOS(      Pcl_Request       CLOB,
                                   Pv_Mensaje        OUT VARCHAR2,
                                   Pv_Status         OUT VARCHAR2,
                                   Pcl_Response      OUT SYS_REFCURSOR) IS
    --
    CURSOR C_PERSONAS_REGULARIZAR(Cv_ESTADO VARCHAR2, CN_DIAS NUMBER) IS
        SELECT 
        DISTINCT IPE.ID_PERSONA 
        FROM
        (SELECT iper.PERSONA_ID,ipere.enunciado_id,COUNT(*) FROM DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO ipere
        inner join db_comercial.info_persona_empresa_rol iper on ipere.persona_empresa_rol_id=iper.id_persona_rol
        WHERE ipere.fecha_creacion > sysdate -CN_DIAS and ipere.estado='Activo'
        GROUP BY iper.PERSONA_ID,ipere.enunciado_id
        HAVING COUNT(*) > 1) T1
        INNER JOIN db_comercial.info_persona ipe on ipe.id_persona=T1.persona_id
        INNER JOIN DB_DOCUMENTO.admi_enunciado aen on aen.id_enunciado=T1.enunciado_id;
    --

    Lv_Request                    VARCHAR2(5000); 
    Ln_IdDocumentoEnunciado       NUMBER;
    Ln_dias                       NUMBER;
    Lv_Identificacion             VARCHAR2(100); 
    Lv_UsrModificacion            VARCHAR2(100) :='MovilRegula';

   
BEGIN
    APEX_JSON.PARSE(Pcl_Request); 
    
    Ln_dias       := APEX_JSON.get_number(p_path => 'dias');
   
     IF Ln_dias IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'El campo dias es obligatorio');
    END IF;


   ----Recorro las personas que tienen mas de un rol
   FOR persona IN C_PERSONAS_REGULARIZAR('Activo',Ln_dias) LOOP
   
	    Ln_IdDocumentoEnunciado:= NULL; 
	  
	  
	  
        BEGIN
            
            SELECT IDENTIFICACION_CLIENTE
            INTO  Lv_Identificacion
            FROM DB_COMERCIAL.INFO_PERSONA
            WHERE ID_PERSONA    = persona.ID_PERSONA;
                
                
          
            SELECT max(DOCUMENTO_RELACION_ID) 
            INTO  Ln_IdDocumentoEnunciado
            FROM DB_DOCUMENTO.INFO_DOCUMENTO_CARAC idc WHERE  DOC_REFERENCIA_ID =1 AND
            VALOR =Lv_Identificacion
            ORDER BY FECHA_CREACION DESC;
              
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
             Ln_IdDocumentoEnunciado := NULL;
        END;
      
      
      	

        IF Ln_IdDocumentoEnunciado IS NULL THEN
            CONTINUE;
        END IF;	   
       
       
     
	
		UPDATE    
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
        SET iper.ESTADO='Eliminado',
        FE_ULT_MOD =SYSDATE ,
        iper.USR_ULT_MOD=Lv_UsrModificacion 
        WHERE ID_PERSONA_ROL in(
            SELECT  iper.ID_PERSONA_ROL  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ,
            DB_COMERCIAL.INFO_EMPRESA_ROL IFR,
            DB_GENERAL.ADMI_ROL  AR
            WHERE
            PERSONA_ID =persona.ID_PERSONA and
            IFR.ROL_ID=AR.ID_ROL and
            EMPRESA_ROL_ID= IFR.ID_EMPRESA_ROL and
            AR.DESCRIPCION_ROL IN('blanca','negra') AND iper.ESTADO='Activo'  
        );
				
		
	    UPDATE 
	    DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO ipere
		SET ESTADO='Eliminado',
		FECHA_MODIFICACION =SYSDATE ,
		USUARIO_MODIFICACION =Lv_UsrModificacion
		WHERE PERSONA_EMPRESA_ROL_ID IN (
		SELECT  iper.ID_PERSONA_ROL  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ,
		    DB_COMERCIAL.INFO_EMPRESA_ROL IFR,
		    DB_GENERAL.ADMI_ROL  AR
		WHERE
		PERSONA_ID =persona.ID_PERSONA  and
		IFR.ROL_ID=AR.ID_ROL and
		EMPRESA_ROL_ID= IFR.ID_EMPRESA_ROL and
		AR.DESCRIPCION_ROL IN('blanca','negra'));	
	
	    COMMIT;
 
        Lv_Request  := '{"identificacion":"'||Lv_Identificacion||'","contactos":[ ],"idDocumentoRelacion":"'||Ln_IdDocumentoEnunciado||'","usrCreacion":"'||Lv_UsrModificacion||'","ipCreacion":"127.0.0.1" }';       
        DB_COMERCIAL.CMKG_LISTA_PERSONA.P_AGREGAR_PERSONA_LISTA(
                                  Lv_Request,
                                  Pv_Mensaje ,   
                                  Pv_Status ,
                                  Pcl_Response) ;          
                              
       dbms_output.put_line(Pv_Status);
       dbms_output.put_line(Pv_Mensaje);                     
       DBMS_OUTPUT.PUT_LINE (persona.ID_PERSONA||' - '||Ln_IdDocumentoEnunciado);
             
   END LOOP;



    --
    Pv_Mensaje   :=' Transacción realizada correctamente.';
    Pv_Status    := 'OK';
    --
EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        Pcl_Response  :=  NULL;
        Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        IF SQLCODE = -20101 THEN
            Pv_Status  := 'ERROR-CONTROL';
        END IF;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                'DB_COMERCIAL.CMKG_REGULARIZACIONES.P_ROLES_ENUNCIADOS',
                                                'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                Lv_UsrModificacion ,
                                                SYSDATE,
                                                '127.0.0.1');
END P_ROLES_ENUNCIADOS;

END CMKG_REGULARIZACIONES;