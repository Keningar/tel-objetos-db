CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_C AS 
    /**
     * Contiene consultas al objeto P_GET_INFO_PER_FORMA_CONTACTO
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @since 1.0 28-10-2018
     **/
    PROCEDURE P_GET_INFO_PER_FORMA_CONTACTO (
        Pn_IdPersona              IN                        INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE,
        Pn_IdFormaContacto        IN                        INFO_PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID%TYPE,
        Pv_Valor                  IN                        INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPerFormaContacto   OUT                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    );

    /**
    * Documentaci�n para el procedimiento P_CONSULTA_CONTACTOS_EMPRESA
    *
    * M�todo encargado de consultar mediante id_persona_empresa_rol, codigo de empresa 
    * y estado los contactos VIP, Asesor de Cobranza y Asesor Comercial asociados a un Cliente.
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *  estado                Estado del proceso,
    *  personaEmpresaRolId   Id del rol de la persona en la empresa,
    *  codEmpresa             Id de la empresa
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci�n
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci�n
    * @param Lrf_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci�n
    *
    * @author Brenyx Giraldo <agiraldo@telconet.ec>
    * @version 1.0 23-03-2022
    */  
    PROCEDURE P_CONSULTA_CONTACTOS_EMPRESA(
        Pcl_Request  IN  CLOB,
	    Pv_Status    OUT VARCHAR2,
	    Pv_Mensaje   OUT VARCHAR2,
	    Lrf_Response OUT SYS_REFCURSOR);

END CMKG_INFO_PER_FORMA_CONTACTO_C;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_C AS

    PROCEDURE P_GET_INFO_PER_FORMA_CONTACTO (
        Pn_IdPersona              IN                        INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE,
        Pn_IdFormaContacto        IN                        INFO_PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID%TYPE,
        Pv_Valor                  IN                        INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPerFormaContacto   OUT                       INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    ) AS

        /**
          * C_GetInfoPerFormaContacto, obtiene un registro por codigo
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 3, cardinalidad 1
          */

        CURSOR C_GetInfoPerFormaContacto (
            Cn_IdPersona         INFO_PERSONA_FORMA_CONTACTO.PERSONA_ID%TYPE,
            Cn_IdFormaContacto   INFO_PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID%TYPE,
            Cv_Valor             INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE
        ) IS
        SELECT
            IPFC.*
        FROM
            INFO_PERSONA_FORMA_CONTACTO IPFC
        WHERE
            IPFC.PERSONA_ID = Cn_IdPersona
            AND IPFC.FORMA_CONTACTO_ID = Cn_IdFormaContacto
            AND UPPER(TRIM(IPFC.VALOR)) = UPPER(TRIM(Cv_Valor));

        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetInfoPerFormaContacto%ISOPEN THEN
            CLOSE C_GetInfoPerFormaContacto;
        END IF;
        OPEN C_GetInfoPerFormaContacto(Pn_IdPersona, Pn_IdFormaContacto, Pv_Valor);
        FETCH C_GetInfoPerFormaContacto INTO Pr_InfoPerFormaContacto;
        IF C_GetInfoPerFormaContacto%NOTFOUND THEN
            CLOSE C_GetInfoPerFormaContacto;
            RAISE Le_NotFound;
        END IF;
        CLOSE C_GetInfoPerFormaContacto;
        Pv_Status := CMKG_RESULT.FOUND_STATUS;
        Pv_Code := CMKG_RESULT.FOUND_CODE;
        Pv_Msn := 'Se encontro forma contacto';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Status := CMKG_RESULT.NOT_FOUND_STATUS;
            Pv_Code := CMKG_RESULT.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro forma contacto';
        WHEN OTHERS THEN
            Pv_Status := CMKG_RESULT.FAILED_STATUS;
            Pv_Code := CMKG_RESULT.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_GET_INFO_PER_FORMA_CONTACTO;


   /* Procedure para optener los Contactos VIP, Asesor de Cobranza y Asesor Comercial asociados a un Cliente	*/
    PROCEDURE P_CONSULTA_CONTACTOS_EMPRESA(
            Pcl_Request          IN              CLOB,
            Pv_Status            OUT             VARCHAR2,
            Pv_Mensaje           OUT             VARCHAR2,
            Lrf_Response         OUT             SYS_REFCURSOR
            )AS

            Lv_Estado  	            	    INFO_PERSONA_EMPRESA_ROL_CARAC.ESTADO%TYPE;
            Ln_EmpresaRolId  	            INFO_PERSONA_EMPRESA_ROL_CARAC.PERSONA_EMPRESA_ROL_ID%TYPE;
            Lv_CodEmpresa 			    	INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
            Lcl_QuerySelectIngVip           CLOB;
            Lcl_QueryFrom                   CLOB;
            Lcl_QueryWhere                  CLOB;
           	Lcl_QueryAsesorCmal             CLOB;
          	Lcl_QueryAsesorCbza             CLOB;
            Lcl_Query                       CLOB;
            ln_Id_Vip_Ciudad                NUMBER;
            ln_Id_Vip_Extension             NUMBER;
            ln_Id_Persona_Vendedor          NUMBER;
            ln_Id_Persona_Cobranza          NUMBER;

        CURSOR C_GetIdCaracteristica (Cn_CaractDescripcion IN VARCHAR2) IS
            SELECT 
                AC.ID_CARACTERISTICA
            FROM
                DB_COMERCIAL.ADMI_CARACTERISTICA AC
            WHERE
                AC.DESCRIPCION_CARACTERISTICA = Cn_CaractDescripcion;

         CURSOR C_GetIdVendedor (Cn_PersonaEmpresaRolId IN NUMBER) IS
            SELECT DISTINCT 
                IP.ID_PERSONA 
            FROM 
                DB_COMERCIAL.INFO_PUNTO IPS 
            INNER JOIN DB_COMERCIAL.INFO_PERSONA IP on IP.LOGIN = IPS.USR_VENDEDOR
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  PER  ON PER.ID_PERSONA_ROL  = IP.ID_PERSONA
            WHERE  
                IPS.PERSONA_EMPRESA_ROL_ID  = Cn_PersonaEmpresaRolId
            AND IP.ESTADO = 'Activo';

         CURSOR C_GetIdCobranzas (Cn_PersonaEmpresaRolId IN NUMBER) IS
            SELECT DISTINCT 
                IP.ID_PERSONA 
            FROM 
                DB_COMERCIAL.INFO_PUNTO IPS 
            INNER JOIN DB_COMERCIAL.INFO_PERSONA IP on IP.LOGIN = IPS.USR_COBRANZAS
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  PER  ON PER.ID_PERSONA_ROL  = IP.ID_PERSONA
            WHERE  
                IPS.PERSONA_EMPRESA_ROL_ID  = Cn_PersonaEmpresaRolId
            AND IP.ESTADO = 'Activo';




    BEGIN
            APEX_JSON.PARSE(Pcl_Request);
            Ln_EmpresaRolId	                    := APEX_JSON.get_number(p_path => 'idPersonaEmpresaRol');
            Lv_Estado 					            := APEX_JSON.get_varchar2(p_path => 'estado');
            Lv_CodEmpresa                          := APEX_JSON.get_varchar2(p_path => 'codEmpresa');


            OPEN C_GetIdCaracteristica ('ID_VIP_CIUDAD');   
            FETCH C_GetIdCaracteristica INTO ln_Id_Vip_Ciudad;   
            CLOSE C_GetIdCaracteristica; 

            OPEN C_GetIdVendedor (Ln_EmpresaRolId);   
            FETCH C_GetIdVendedor INTO ln_Id_Persona_Vendedor;   
            CLOSE C_GetIdVendedor; 



            OPEN C_GetIdCobranzas (Ln_EmpresaRolId);   
            FETCH C_GetIdCobranzas INTO ln_Id_Persona_Cobranza;   
            CLOSE C_GetIdCobranzas; 



            DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelectIngVip, true); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, true); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, true); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryAsesorCmal, true);  
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryAsesorCbza, true);
            DBMS_LOB.CREATETEMPORARY(Lcl_Query, true);   


            DBMS_LOB.APPEND(Lcl_QuerySelectIngVip,'SELECT TO_NUMBER(PERC.VALOR) idPersona, 
       INITCAP(P.NOMBRES || '' '' || P.APELLIDOS) nombre, 
       EMP.MAIL_CIA email, ''09'' || SUBSTR(EL.NOMBRE_ELEMENTO,-8) contacto, 
       INITCAP( PER_CIU.CIUDAD) ciudad,
	   ''Ingeniero VIP'' tipoContacto
			');

            DBMS_LOB.APPEND(Lcl_QueryFrom,'FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PERC
       INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  PER
                    ON PER.ID_PERSONA_ROL  = TO_NUMBER(PERC.VALOR)
       INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL          ER   ON ER.ID_EMPRESA_ROL   = PER.EMPRESA_ROL_ID
       INNER JOIN DB_COMERCIAL.INFO_PERSONA              P    ON P.ID_PERSONA        = PER.PERSONA_ID
       INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA       C    ON C.ID_CARACTERISTICA = PERC.CARACTERISTICA_ID
       LEFT JOIN NAF47_TNET.V_Empleados_Empresas         EMP  ON EMP.LOGIN_EMPLE     = P.LOGIN
                                                              AND EMP.ESTADO=''A''
       LEFT JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DE  ON  DE.DETALLE_VALOR   = PER.ID_PERSONA_ROL
                                                              AND DE.ESTADO          = '''||Lv_Estado||'''
                                                              AND DE.DETALLE_NOMBRE  = ''COLABORADOR''
       LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO        EL   ON  EL.ID_ELEMENTO      = DE.ELEMENTO_ID
                                                              AND EL.DESCRIPCION_ELEMENTO = ''NUMERO CELULAR''
            '); 


        IF ln_Id_Vip_Ciudad IS NOT NULL THEN
            DBMS_LOB.APPEND(Lcl_QueryFrom,'LEFT JOIN ( SELECT PER_CIUDAD.PERSONA_EMPRESA_ROL_CARAC_ID, CANTON.NOMBRE_CANTON CIUDAD
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PER_CIUDAD
            INNER JOIN DB_GENERAL.ADMI_CANTON CANTON ON CANTON.ID_CANTON = PER_CIUDAD.VALOR
            WHERE PER_CIUDAD.CARACTERISTICA_ID = '||ln_Id_Vip_Ciudad||' AND PER_CIUDAD.ESTADO = '''||Lv_Estado||''' ) PER_CIU
            ON PER_CIU.PERSONA_EMPRESA_ROL_CARAC_ID = PERC.ID_PERSONA_EMPRESA_ROL_CARACT 
            ');
        END IF;

        DBMS_LOB.APPEND(Lcl_QueryWhere,'WHERE PERC.PERSONA_EMPRESA_ROL_ID  = '||Ln_EmpresaRolId||'
            AND   C.DESCRIPCION_CARACTERISTICA = ''ID_VIP''
            AND   PERC.ESTADO                  = '''||Lv_Estado||'''
            AND   ER.EMPRESA_COD               = '''||Lv_CodEmpresa||'''
			');

      	DBMS_LOB.APPEND(Lcl_QueryAsesorCmal,' 
			UNION
			SELECT DISTINCT IP.ID_PERSONA idPersona ,
			INITCAP(IP.NOMBRES || '' '' || IP.APELLIDOS) nombre,
			EMP.MAIL_CIA email,PTC.contacto contacto ,INITCAP(EMP.NOMBRE_CANTON) ciudad,
			''Asesor Comercial''
		    FROM DB_COMERCIAL.INFO_PUNTO ips 
		    INNER JOIN DB_COMERCIAL.INFO_PERSONA IP on IP.LOGIN = ips.USR_VENDEDOR
		    INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  PER    ON PER.ID_PERSONA_ROL  = IP.ID_PERSONA
		    INNER JOIN DB_COMERCIAL.INFO_PERSONA              P    	 ON P.ID_PERSONA        = PER.PERSONA_ID
		    LEFT JOIN NAF47_TNET.V_Empleados_Empresas         EMP    ON EMP.LOGIN_EMPLE     = IP.LOGIN
		                                                             AND EMP.ESTADO=''A''
	        LEFT JOIN ( SELECT pfc.persona_id personaId, 
	                    LISTAGG(''09'' || SUBSTR(pfc.valor,-8), '', '')  WITHIN GROUP (ORDER BY pfc.valor) contacto
		                FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO pfc,
		                DB_COMERCIAL.ADMI_FORMA_CONTACTO  fc 
		                WHERE pfc.FORMA_CONTACTO_ID = fc.ID_FORMA_CONTACTO 
		                AND pfc.PERSONA_ID = '||ln_Id_Persona_Vendedor||'
		                AND fc.DESCRIPCION_FORMA_CONTACTO = ''Telefono Movil''
		                AND pfc.ESTADO = '''||Lv_Estado||'''
		                GROUP BY pfc.persona_id
		                ) PTC  on PTC.personaId = IP.ID_PERSONA
		    WHERE ips.PERSONA_EMPRESA_ROL_ID  = '||Ln_EmpresaRolId||' 
			AND ips.ESTADO = '''||Lv_Estado||''' ');

		DBMS_LOB.APPEND(Lcl_QueryAsesorCbza,' 
		  UNION
	      SELECT DISTINCT IP.ID_PERSONA idPersona,
	      INITCAP(IP.NOMBRES || '' '' || IP.APELLIDOS) nombre,
	      EMP.MAIL_CIA email,PTC.contacto contacto,INITCAP(EMP.NOMBRE_CANTON) ciudad,
		  ''Asesor Cobranzas''
	      FROM DB_COMERCIAL.INFO_PUNTO ips 
	      INNER JOIN DB_COMERCIAL.INFO_PERSONA IP on IP.LOGIN = ips.USR_COBRANZAS
	      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  PER  ON PER.ID_PERSONA_ROL  = IP.ID_PERSONA
	      INNER JOIN DB_COMERCIAL.INFO_PERSONA              P    ON P.ID_PERSONA        = PER.PERSONA_ID
	      LEFT JOIN NAF47_TNET.V_Empleados_Empresas         EMP    ON EMP.LOGIN_EMPLE     = IP.LOGIN
	                                                              AND EMP.ESTADO=''A''
	      LEFT JOIN ( SELECT pfc.persona_id personaId, 
	                  LISTAGG(''09'' || SUBSTR(pfc.valor,-8), '', '')  WITHIN GROUP (ORDER BY pfc.valor) contacto
	                  FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO pfc,
	                  DB_COMERCIAL.ADMI_FORMA_CONTACTO  fc 
		              WHERE pfc.FORMA_CONTACTO_ID = fc.ID_FORMA_CONTACTO 
		              AND pfc.PERSONA_ID = '||ln_Id_Persona_Cobranza||'
		              AND fc.DESCRIPCION_FORMA_CONTACTO =  ''Telefono Movil''
		              AND pfc.ESTADO = '''||Lv_Estado||'''
		              GROUP BY pfc.persona_id
		              ) PTC  on PTC.personaId = IP.ID_PERSONA
		  WHERE ips.PERSONA_EMPRESA_ROL_ID  = '||Ln_EmpresaRolId||' 
		  AND ips.ESTADO ='''||Lv_Estado||''' ');


        DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelectIngVip);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryAsesorCmal);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryAsesorCbza);

    OPEN Lrf_Response FOR Lcl_Query;

        Pv_Status  := 'OK';
        Pv_Mensaje := 'Consulta exitosa';

        EXCEPTION
        WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;

    END P_CONSULTA_CONTACTOS_EMPRESA;                        



END CMKG_INFO_PER_FORMA_CONTACTO_C;
/