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


                                          
    /**
    * Documentación para la función P_DOCUMENTOS_FIRMAR
    * Procedimiento para regularizar documentos que no tienen firma
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta 
    *
    * @author Jefferson Carrillo<jacarrillo@telconet.ec>
    * @version 1.0 04-05-2023
    */
    PROCEDURE P_DOCUMENTOS_FIRMAR(      Pcl_Request       CLOB,
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

-----

PROCEDURE P_DOCUMENTOS_FIRMAR(     Pcl_Request       CLOB,
                                   Pv_Mensaje        OUT VARCHAR2,
                                   Pv_Status         OUT VARCHAR2,
                                   Pcl_Response      OUT SYS_REFCURSOR) IS

    Lcl_Query                   CLOB;
    Lcl_Select                  CLOB;
    Lcl_From                    CLOB;
    Lcl_WhereAndJoin            CLOB; 
    Lcl_OrderAnGroup            CLOB;  
    Lcl_FiltroDocumentos        CLOB;
    
    Lv_Request                    VARCHAR2(5000);  
    Lv_usrCreacion                VARCHAR2(100); 
    Lv_Estado                     VARCHAR2(100); 

    Lv_ParametroCab             VARCHAR2(100);
    Lv_ParamDetFirma            VARCHAR2(100);
    Lv_ParamDetCambio           VARCHAR2(100);
    
    Pcl_ParamDetFirma        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
    Pcl_ParamDetCambio       DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;  
    
   CURSOR C_LISTA_TIPO_DOC IS
    SELECT pdet.DESCRIPCION FROM DB_GENERAL.ADMI_PARAMETRO_DET pdet
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB pcab
    ON pcab.id_parametro = pdet.parametro_id
    WHERE pcab.NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    AND pdet.ESTADO = 'Activo'; 

   
BEGIN
        APEX_JSON.PARSE(Pcl_Request);  

   
    
      Lv_ParametroCab	      :=  'PARAM_REGULARIZACION_DOCUMENTO_FIRMA' ;   
      Lv_ParamDetFirma	      :=  'FILTROS_DOCUMENTO_FIRMA';     
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro    => Lv_ParametroCab	,
                                                                  Pv_Descripcion       => Lv_ParamDetFirma	,
                                                                  Pv_Empresa_Cod       => '0',
                                                                  Pr_AdmiParametroDet  => Pcl_ParamDetFirma,
                                                                  Pv_Status            => Pv_Status ,
                                                                  Pv_Mensaje           => Pv_Mensaje );
        IF Pv_Status <> 'OK' THEN
            Pv_Mensaje := Pv_Mensaje  || ' ' || Lv_ParamDetFirma;  
            RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
        END IF;

      Lv_ParamDetCambio  	 :=  'CAMBIOS_DOCUMENTO_FIRMA';     
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro    => Lv_ParametroCab	,
                                                                  Pv_Descripcion       =>  Lv_ParamDetCambio	,
                                                                  Pv_Empresa_Cod       => '0',
                                                                  Pr_AdmiParametroDet  => Pcl_ParamDetCambio,
                                                                  Pv_Status            => Pv_Status ,
                                                                  Pv_Mensaje           => Pv_Mensaje );
        IF Pv_Status <> 'OK' THEN
            Pv_Mensaje := Pv_Mensaje  || ' ' || Lv_ParamDetCambio;  
            RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
        END IF;
    Lv_Estado         := Pcl_ParamDetCambio.VALOR1;
    Lv_usrCreacion    := Pcl_ParamDetCambio.VALOR2;
      
    IF Pcl_ParamDetFirma.VALOR1 = 'S' THEN
 
           Lcl_Select       :=  '
                                SELECT  
                                ipe.identificacion_cliente       cedula,                                  
                                indo.UBICACION_FISICA_DOCUMENTO  urlPdf,   
                                indo.ubicacion_logica_documento  namePdf,                                 
                                atdg.id_tipo_documento idTipoDocumentoGeneral, 
                                REGEXP_REPLACE(REGEXP_SUBSTR(indo.UBICACION_LOGICA_DOCUMENTO , ''[^/]+$'', 1, 1) , ''-[^/]+$'', '''' )  AS tipoDoc, 
                                indo.mensaje tipo,
                                indo.id_documento idDocumento,
                                ico.id_contrato idContrato,
                                iper.id_persona_rol idPersonaRol,
                                indr.numero_adendum numeroAdendum, 
                                indo.empresa_cod empresaCod
                                ';
            Lcl_From         := '
                                FROM db_comercial.info_contrato ico 
                                INNER JOIN db_comercial.info_persona_empresa_rol iper 
                                ON iper.id_persona_rol = ico.persona_empresa_rol_id
                                INNER JOIN db_comercial.info_persona ipe
                                ON ipe.id_persona = iper.persona_id
                                INNER JOIN db_comunicacion.info_documento indo
                                ON  indo.contrato_id = ico.id_contrato                          
                                INNER JOIN db_comunicacion.info_documento_relacion indr
                                ON indr.contrato_id = ico.id_contrato AND indr.documento_id = indo.id_documento  
                                INNER JOIN db_general.admi_tipo_documento_general atdg 
                                ON  atdg.id_tipo_documento  = indo.tipo_documento_general_id 
                                
                                ';
 

            Lcl_WhereAndJoin := '
                                WHERE  indo.empresa_cod in  ('''|| REPLACE(Pcl_ParamDetFirma.VALOR5, ',', ''',''') ||''') 
                                AND indo.estado = ''Activo''
                                AND (TRUNC(indo.fe_creacion)   BETWEEN to_date( '''|| Pcl_ParamDetFirma.VALOR3||''',''dd/mm/rrrr'') AND to_date('''|| Pcl_ParamDetFirma.VALOR4||''',''dd/mm/rrrr''))
                                AND ico.estado in ('''|| REPLACE(Pcl_ParamDetFirma.VALOR2, ',', ''',''') ||''') 
                                AND ((indo.USR_ULT_MOD  <> '''||Lv_usrCreacion||''' AND indo.ESTADO <> '''||  Lv_Estado ||''') OR indo.USR_CREACION  <>  '''||Lv_usrCreacion||''' )
                              

                                ';



        --FILTRAR POR TIPOS DE DOCUMENTOS
        FOR i IN C_LISTA_TIPO_DOC LOOP   
            Lcl_FiltroDocumentos  :=  Lcl_FiltroDocumentos || ' (INSTR(indo.UBICACION_LOGICA_DOCUMENTO ,''' ||i.DESCRIPCION||''' ) > 0) OR';              
        END LOOP;

    
        IF Lcl_FiltroDocumentos IS NOT NULL THEN 
        Lcl_FiltroDocumentos :=  SUBSTR(Lcl_FiltroDocumentos , 0, length(Lcl_FiltroDocumentos)-2); 
        Lcl_WhereAndJoin     :=  Lcl_WhereAndJoin||' AND ( '|| Lcl_FiltroDocumentos ||' ) '; 
        END IF; 

                            
        Lcl_OrderAnGroup := '';

        Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;
        dbms_output.put_line( Lcl_Query);  
        OPEN Pcl_Response FOR Lcl_Query;
    Pv_Mensaje    := 'Transacción exitosa';    
    ELSE       
    Pv_Mensaje    := 'Obtención de datos para documentos a firmar esta inhabilitado.';
    dbms_output.put_line(Pv_Mensaje);
    END IF; 
    Pv_Status     := 'OK';


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
                                                'DB_COMERCIAL.CMKG_REGULARIZACIONES.P_DOCUMENTOS_FIRMAR',
                                                'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                Lv_usrCreacion,
                                                SYSDATE,
                                                '127.0.0.1');
END P_DOCUMENTOS_FIRMAR;



END CMKG_REGULARIZACIONES;
/
