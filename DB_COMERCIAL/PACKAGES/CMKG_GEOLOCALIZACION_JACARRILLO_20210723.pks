 CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_GEOLOCALIZACION AS 
    /**
    * Documentación para F_ESTANDARIZAR
    * Funcion para eliminar tildes y cambiar texto a mayuscula
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 28/06/2021
    */
    FUNCTION  F_ESTANDARIZAR(Fn_Nombre IN VARCHAR2 ) RETURN  VARCHAR2;
    /**
    * Documentación para P_VERIFICAR_CATALOGO
    * Procedimiento que verificar y registrar pais, provincias, cantones, parroquias, sectores
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 28/06/2021
    */
	PROCEDURE P_VERIFICAR_CATALOGO(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);
END CMKG_GEOLOCALIZACION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_GEOLOCALIZACION AS

    FUNCTION  F_ESTANDARIZAR(Fn_Nombre IN VARCHAR2 ) 
        RETURN  VARCHAR2 AS
        Ln_NuevoNombre VARCHAR2(1000);
        BEGIN 
	        Ln_NuevoNombre := RTRIM(LTRIM(UPPER(Translate(Fn_Nombre,'ÁáÉéÍíÓóÚú','AaEeIiOoUu'))));
	        Ln_NuevoNombre :=  REPLACE(Ln_NuevoNombre,'PROVINCIA','');
	        Ln_NuevoNombre :=  REPLACE(Ln_NuevoNombre,'CANTON','');
	        Ln_NuevoNombre :=  REPLACE(Ln_NuevoNombre,'PARROQUIA','');
	        Ln_NuevoNombre :=  REPLACE(Ln_NuevoNombre,'SECTOR','');
	        Ln_NuevoNombre :=  REPLACE(Ln_NuevoNombre,'DE LOS TSACHILAS','');
	    RETURN  Ln_NuevoNombre; 
    END F_ESTANDARIZAR;         

	PROCEDURE P_VERIFICAR_CATALOGO(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR) AS 
	    Ln_ContDataPuntoCobertura NUMBER ;
	    Ln_IdEmpresa NUMBER ;
	    Lv_UsrCreacion VARCHAR2(1000); 
	    Ln_IdPuntoCobertura NUMBER ;
	    Lv_NombrePuntoCobertura VARCHAR2(1000); 
	    Ln_IdPais NUMBER ;
	    Lv_NombrePais VARCHAR2(1000); 
	    Ln_IdProvincia NUMBER ;
	    Lv_NombreProvincia VARCHAR2(1000);    
	    Ln_IdCanton NUMBER ;
	    Lv_NombreCanton VARCHAR2(1000); 
	   	Ln_IdParroquia NUMBER ;
	    Lv_NombreParroquia VARCHAR2(1000); 
	   	Ln_IdSector NUMBER ;
	    Lv_NombreSector VARCHAR2(1000); 
	    Lv_CodigoPostal VARCHAR2(1000); 
	    Lv_CallePrincipal VARCHAR2(1000); 
	    Lv_PuntoInteres VARCHAR2(1000); 
	   
 	    CURSOR C_Canton (Cv_NombreCanton VARCHAR2 , Cv_IdProvincia NUMBER ) IS 
        SELECT id_canton , nombre_canton FROM DB_GENERAL.ADMI_CANTON 
        WHERE F_ESTANDARIZAR(ESTADO) IN ('ACTIVO','MODIFICADO') AND F_ESTANDARIZAR(nombre_canton)  LIKE '%'||F_ESTANDARIZAR(Cv_NombreCanton)||'%'  
        OR F_ESTANDARIZAR(nombre_canton)   IN 
		 (
		select regexp_substr(F_ESTANDARIZAR(Cv_NombreCanton),'[^ ]+', 1, level)
		from dual 
		connect BY regexp_substr(F_ESTANDARIZAR(Cv_NombreCanton), '[^ ]+', 1, level)
		is not null
		 ) 
		AND PROVINCIA_ID  = Cv_IdProvincia 
        ORDER BY id_canton ASC; 
       
        CURSOR C_Pais (Cv_NombrePais VARCHAR2) IS 
        SELECT id_pais , nombre_pais FROM DB_GENERAL.ADMI_PAIS WHERE F_ESTANDARIZAR(ESTADO) IN ('ACTIVO','MODIFICADO') AND F_ESTANDARIZAR(nombre_pais)  LIKE '%'||F_ESTANDARIZAR(Cv_NombrePais)||'%'  ORDER BY id_pais ASC; 
	   
        CURSOR C_Provincia (Cv_NombreProvincia VARCHAR2) IS 
        SELECT id_provincia , nombre_provincia FROM DB_GENERAL.ADMI_PROVINCIA WHERE F_ESTANDARIZAR(ESTADO) IN ('ACTIVO','MODIFICADO') AND F_ESTANDARIZAR(nombre_provincia)  LIKE '%'||F_ESTANDARIZAR(Cv_NombreProvincia)||'%'  ORDER BY id_provincia ASC; 
	   
        CURSOR C_Parroquia (Cv_NombreParroquia VARCHAR2, Cv_IdCanton NUMBER) IS 
        SELECT id_parroquia , nombre_parroquia FROM DB_GENERAL.ADMI_PARROQUIA WHERE F_ESTANDARIZAR(ESTADO) IN ('ACTIVO','MODIFICADO')  AND F_ESTANDARIZAR(nombre_parroquia)  LIKE '%'||F_ESTANDARIZAR(Cv_NombreParroquia)||'%'  AND CANTON_ID = Cv_IdCanton ORDER BY id_parroquia ASC; 
       
        CURSOR C_Sector (Cv_NombreSector VARCHAR2, Cv_IdParroquia NUMBER ) IS 
        SELECT id_sector , nombre_sector FROM DB_GENERAL.ADMI_SECTOR WHERE  F_ESTANDARIZAR(ESTADO) IN ('ACTIVO','MODIFICADO') 
        AND F_ESTANDARIZAR(nombre_sector) IN (       
        select F_ESTANDARIZAR( regexp_substr( Cv_NombreSector,'[^,]+', 1, level)) from dual
        connect by regexp_substr( Cv_NombreSector, '[^,]+', 1, level) is not null
        ) AND PARROQUIA_ID = Cv_IdParroquia  AND  EMPRESA_COD = Ln_IdEmpresa  ORDER BY id_sector ASC;        
        
       CURSOR C_PuntoCobertura (Cn_IdEmpresa NUMBER, Cn_IdCanton NUMBER) IS 
        SELECT  J.ID_JURISDICCION, J.NOMBRE_JURISDICCION  FROM DB_GENERAL.ADMI_JURISDICCION J
		INNER JOIN DB_GENERAL.INFO_OFICINA_GRUPO O
		ON  J.OFICINA_ID  = O.ID_OFICINA
		INNER JOIN DB_GENERAL.ADMI_CANTON_JURISDICCION JC
		ON J.ID_JURISDICCION =JC.JURISDICCION_ID	  
		WHERE  F_ESTANDARIZAR(J.ESTADO ) IN ('ACTIVO','MODIFICADO')  AND F_ESTANDARIZAR(O.ESTADO ) IN ('ACTIVO','MODIFICADO')    AND  F_ESTANDARIZAR(JC.ESTADO ) IN ('ACTIVO','MODIFICADO') 
		AND O.EMPRESA_ID = Cn_IdEmpresa	
		AND JC.CANTON_ID = Cn_IdCanton
		GROUP  BY J.ID_JURISDICCION , J.NOMBRE_JURISDICCION
		ORDER BY NOMBRE_JURISDICCION ASC; 
	
	   CURSOR C_CountPuntoCobertura (Cn_IdEmpresa NUMBER, Cn_IdCanton NUMBER) IS 
        SELECT  COUNT(*) FROM DB_GENERAL.ADMI_JURISDICCION J
		INNER JOIN DB_GENERAL.INFO_OFICINA_GRUPO O
		ON  J.OFICINA_ID  = O.ID_OFICINA
		INNER JOIN DB_GENERAL.ADMI_CANTON_JURISDICCION JC
		ON J.ID_JURISDICCION =JC.JURISDICCION_ID	  
			WHERE  F_ESTANDARIZAR(J.ESTADO ) IN ('ACTIVO','MODIFICADO')  AND F_ESTANDARIZAR(O.ESTADO ) IN ('ACTIVO','MODIFICADO')    AND  F_ESTANDARIZAR(JC.ESTADO ) IN ('ACTIVO','MODIFICADO') 
		AND O.EMPRESA_ID = Cn_IdEmpresa	
		AND JC.CANTON_ID = Cn_IdCanton 
		ORDER BY NOMBRE_JURISDICCION ASC; 

     
      
       BEGIN  
		APEX_JSON.PARSE(Pcl_Request);		
	    Ln_IdEmpresa := APEX_JSON.GET_VARCHAR2(p_path => 'idEmpresa');
	    Lv_UsrCreacion := APEX_JSON.GET_VARCHAR2(p_path => 'usrCreacion');
	    Lv_NombrePais := APEX_JSON.GET_VARCHAR2(p_path => 'nombrePais');
        Lv_NombreProvincia := F_ESTANDARIZAR( APEX_JSON.GET_VARCHAR2(p_path => 'nombreProvincia'));
        Lv_NombreCanton := F_ESTANDARIZAR(  APEX_JSON.GET_VARCHAR2(p_path => 'nombreCanton'));
		Lv_NombreParroquia := APEX_JSON.GET_VARCHAR2(p_path => 'nombreParroquia');
	    Lv_NombreSector := APEX_JSON.GET_VARCHAR2(p_path => 'nombreSector');
	    Lv_CodigoPostal := APEX_JSON.GET_VARCHAR2(p_path => 'codigoPostal');
	    Lv_CallePrincipal := APEX_JSON.GET_VARCHAR2(p_path => 'callePrincipal');
	    Lv_PuntoInteres := APEX_JSON.GET_VARCHAR2(p_path => 'puntoInteres');
        Ln_ContDataPuntoCobertura:= 0;
 
  		OPEN C_Pais(Lv_NombrePais); 
	    FETCH C_Pais INTO Ln_IdPais , Lv_NombrePais; 
	    dbms_output.put_line('Pais '||Lv_NombrePais||'->'||Ln_IdPais);    
	    CLOSE C_Pais;
	   
	   
        IF  Lv_NombreProvincia IS NOT NULL AND Ln_IdPais IS NOT NULL THEN
	   	OPEN C_Provincia(Lv_NombreProvincia); 
	    FETCH C_Provincia INTO Ln_IdProvincia , Lv_NombreProvincia; 
	    dbms_output.put_line('Provincia '||Lv_NombreProvincia||'->'||Ln_IdProvincia);    
	    CLOSE C_Provincia;
	    END IF; 
	   
	    IF Lv_NombreCanton IS NOT NULL AND  (Ln_IdPais IS NOT NULL ) AND (Ln_IdProvincia IS NOT NULL) THEN
	    OPEN C_Canton(Lv_NombreCanton, Ln_IdProvincia ); 
	    FETCH C_Canton INTO Ln_IdCanton , Lv_NombreCanton; 
	    dbms_output.put_line('Canton '||Lv_NombreCanton||'->'||Ln_IdCanton);    
	    CLOSE C_Canton;
	    END IF; 

	    IF  (Ln_IdPais IS NOT NULL ) AND (Ln_IdProvincia IS NOT NULL) AND (Ln_IdCanton IS NOT NULL) THEN       
	    OPEN C_PuntoCobertura (Ln_IdEmpresa , Ln_IdCanton); 
	    FETCH C_PuntoCobertura  INTO Ln_IdPuntoCobertura , Lv_NombrePuntoCobertura;        
        dbms_output.put_line('Punto Cobertura '||Lv_NombrePuntoCobertura||'->'||Ln_IdPuntoCobertura);    
        CLOSE C_PuntoCobertura ; 
       
        OPEN C_CountPuntoCobertura (Ln_IdEmpresa , Ln_IdCanton); 
	    FETCH C_CountPuntoCobertura  INTO  Ln_ContDataPuntoCobertura;     
        CLOSE C_CountPuntoCobertura ; 
       
		END IF;  
	
     	   
	    IF Lv_NombreParroquia IS NOT NULL AND  (Ln_IdPais IS NOT NULL ) AND (Ln_IdProvincia IS NOT NULL) AND (Ln_IdCanton IS NOT NULL) THEN
       	OPEN C_Parroquia(Lv_NombreParroquia, Ln_IdCanton); 
	    FETCH C_Parroquia INTO Ln_IdParroquia , Lv_NombreParroquia; 
	    dbms_output.put_line('Parroquia '||Lv_NombreParroquia||'->'||Ln_IdParroquia);    
	    CLOSE C_Parroquia;
	    END IF; 
	   
	    IF Lv_NombreSector IS NOT NULL AND  (Ln_IdPais IS NOT NULL ) AND (Ln_IdProvincia IS NOT NULL) AND (Ln_IdCanton IS NOT NULL) AND (Ln_IdParroquia IS NOT NULL) THEN
    	OPEN C_Sector(Lv_NombreSector, Ln_IdParroquia ); 
	    FETCH C_Sector INTO Ln_IdSector , Lv_NombreSector; 
	    dbms_output.put_line('Sector '||Lv_NombreSector||'->'||Ln_IdSector);    
	    CLOSE C_Sector;   
	    END IF; 
	   
	    --NUEVA VALIDACION SI NO HAY PUNTO DE COBERTURA QUITAR ID EN DATA DE GEO
	    IF ( Ln_ContDataPuntoCobertura <> 1 ) THEN
	    Ln_IdPuntoCobertura:= NULL; 
	    Ln_IdCanton:= NULL; 
	    Ln_IdParroquia:= NULL; 	   
	    Ln_IdSector:= NULL; 
	    dbms_output.put_line('***Se encontraron mas de '|| Ln_ContDataPuntoCObertura||' puntos de cobertura***'); 
	    END IF; 
	    --END VALIDACION
	   
	    dbms_output.put_line('Codigo Postal '|| Lv_CodigoPostal);
	    dbms_output.put_line('Calle Principal '|| Lv_CallePrincipal);
	    dbms_output.put_line('Punto Interes '|| Lv_PuntoInteres);
	     
	  	Pv_Status := 'OK';	
		Pv_Mensaje := 'Transacción exitosa';  
	
	    OPEN Pcl_Response FOR  
	    SELECT  
	    Ln_IdPuntoCobertura AS idPuntoCobertura, 
		Lv_NombrePuntoCobertura AS nombrePuntoCobertura,  
	    Ln_IdPais AS idPais, 
		Lv_NombrePais AS nombrePais,    
		Ln_IdProvincia AS idProvincia, 
		Lv_NombreProvincia AS nombreProvincia, 
		Ln_IdCanton AS idCanton, 
		Lv_NombreCanton AS nombreCanton, 
		Ln_IdParroquia AS idParroquia,   
		Lv_NombreParroquia AS nombreParroquia,  
		Ln_IdSector AS idSector,      
		Lv_NombreSector AS nombreSector,
		Lv_CodigoPostal AS codigoPostal,
		Lv_CallePrincipal AS callePrincipal, 
		Lv_PuntoInteres AS puntoInteres
	    FROM DUAL; 
	   
	   EXCEPTION
       WHEN OTHERS THEN
       Pv_Status := 'ERROR';	
	   Pv_Mensaje := 'Transacción fallida'; 
	   DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('ERROR GEOLOCALIZACION',
                                              'DB_COMERCIAL.CMKG_GEOLOCALIZACION.P_VERIFICAR_CATALOGO',
                                              'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                              'telcos',
                                              SYSDATE,
                                              '127.0.0.1');
	 
	END P_VERIFICAR_CATALOGO;   
END  CMKG_GEOLOCALIZACION;  
/