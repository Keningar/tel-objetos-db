CREATE OR REPLACE PACKAGE RHKG_CONSULTA IS
/**
* Documentacion para NAF47_TNET.RHKG_CONSULTA
* Packages que contiene procesos y funciones que pueden ser de uso general para todo el sistema
* @author David Leon <mdleon@telconet.ec>
* @version 1.0 12/11/2020
*/

  /**
  * Documentacion para F_GET_JSON_EMPLEADOS
  * Funcion genera JSON con datos de empleados recibiendo como parametros el login del empleado
  * @author David Leon <mdleon@telconet.ec>
  * @version 1.0 12/11/2020
  *
  * @param  Pv_Login        IN  varchar2  Recibe login del empleado
  * @param  Pv_Status         OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje        OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB                            retorna JSON con datos de proveedor
  */
  FUNCTION F_GET_JSON_EMPLEADOS ( Pv_Login VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 ) RETURN CLOB;
   /**
  * Documentacion para F_GET_JSON_CEL_EMPLEADO_LOGIN
  * Funcion genera JSON con telefonos del empleado recibiendo como parametros el login del empleado
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 25/11/2020
  *
  * @param  Pv_Login        IN  varchar2  Recibe login del empleado
  * @param  Pv_Status       OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje      OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB            retorna JSON con numeros de telefono del empleado
  */                                    
                                    
  FUNCTION F_GET_JSON_TEL_EMPLEADO_LOGIN ( Pv_Login   VARCHAR2,
                                           Pv_Status  OUT VARCHAR2,
                                           Pv_Mensaje OUT VARCHAR2 ) RETURN CLOB;
                                    
  /**
  * Documentacion para F_GET_JSON_LOGIN_EMPLEADO_TEL
  * Funcion genera JSON con login del empleado recibiendo como parametros el telefono del empleado
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 26/11/2020
  *
  * @param  Pv_Login        IN  varchar2  Recibe login del empleado
  * @param  Pv_Status       OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje      OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB            retorna JSON con numeros de telefono del empleado
  */
  
  FUNCTION F_GET_JSON_LOGIN_EMPLEADO_TEL ( Pv_Telefono   VARCHAR2,
                                           Pv_Status  OUT VARCHAR2,
                                           Pv_Mensaje OUT VARCHAR2 ) RETURN CLOB;
  
  /**
  * Documentacion para F_GET_JSON_CONS_TIPO_PEDIDO
  * Funcion genera JSON con observacion y tipo pedido mediante un pedido
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 26/11/2020
  *
  * @param  PN_ID_PEDIDO    IN  NUMBER  Recibe login del empleado
  * @param  Pv_Status       OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje      OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB            retorna JSON con numeros de telefono del empleado
  */
                                           
  FUNCTION F_GET_JSON_CONS_TIPO_PEDIDO ( PN_ID_PEDIDO   NUMBER,
                                         Pv_Status  OUT VARCHAR2,
                                         Pv_Mensaje OUT VARCHAR2 )  RETURN CLOB;                                          

END RHKG_CONSULTA;

/


CREATE OR REPLACE PACKAGE BODY RHKG_CONSULTA is
FUNCTION F_GET_JSON_EMPLEADOS ( Pv_Login VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2
                                   )
                                    RETURN CLOB IS
    --
    CURSOR C_LIST_EMPLEADOS IS
    SELECT 
            VE.NO_CIA COD_EMPRESA,
            VE.NO_EMPLE COD_EMPLEADO
    FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
    WHERE VE.LOGIN_EMPLE= Pv_Login;
	
    CURSOR C_EMPLEADOS(cv_empleado VARCHAR2, cn_empresa NUMBER) IS
      SELECT 
					VEE.NO_CIA COD_EMPRESA,
					VEE.NO_EMPLE COD,
					VEE.NOMBRE NOMBRE_COMPLETO,
					VEE.NOMBRE_PILA || ' ' || VEE.NOMBRE_SEGUNDO NOSMBRES,
					VEE.APE_PAT || ' ' || VEE.APE_MAT APELLIDOS,
					VEE.LOGIN_EMPLE LOGIN,
					VEE.MAIL_CIA CORREO_CORPORATIVO,
					VEE.DESCRIPCION_CARGO CARGO,
					DECODE(VEE.SEXO,'M','MASCULINO','FEMENINO') SEXO,
					VEE.F_NACIMI FECH_NACIMIENTO,
					VEE.F_INGRESO FECH_INGRESO,
          VEE.F_EGRESO FECH_EGRESO,
					VEE.NOMBRE_PROVINCIA PROVINCIA,
					VEE.NOMBRE_CANTON CANTON,
					VEE.OFICINA ID_OFICINA,
					VEE.ID_JEFE ID_JEFE,
					VEE.NO_CIA_JEFE ID_EMPRESA_JEFE
	 FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE
   WHERE 
				VEE.NO_EMPLE=cv_empleado AND
				VEE.NO_CIA=cn_empresa
		;     
	Lr_ObtenerEmpleados      C_EMPLEADOS%ROWTYPE;
	Lr_ObtenerJefes          C_EMPLEADOS%ROWTYPE;
  
    CURSOR C_TELEFONO(cv_empleado VARCHAR2, cn_empresa NUMBER) IS
    SELECT 
            ARP.TELEFONO TELEFONO
    FROM NAF47_TNET.ARPLME ARP
    WHERE ARP.NO_EMPLE=cv_empleado AND
          ARP.NO_CIA=cn_empresa;
          
    CURSOR C_OFICINA(cv_oficina VARCHAR2, cn_empresa NUMBER) IS
    SELECT 
            ARPO.NOMBRE_OFICINA OFICINA
    FROM NAF47_TNET.ARPLOFICINA ARPO
    WHERE ARPO.OFICINA=cv_oficina AND
          ARPO.NO_CIA=cn_empresa;      
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(9000) := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    Lv_Email          VARCHAR2(1000) := NULL;
    Lv_Telefono_Emp   C_TELEFONO%ROWTYPE;
    Lv_Telefono_Jef   C_TELEFONO%ROWTYPE;
    Lv_Oficina        C_OFICINA%ROWTYPE;
    Lv_Oficina_Jef    C_OFICINA%ROWTYPE;
    --
  BEGIN
  
     
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.RHKG_CONSULTA.F_GET_JSON_EMPLEADOS ENTRA A LA BASE',
                                           'Error en F_GET_JSON_EMPLEADOS: BEGIN',
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);

    --
    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"empleado":[';
    --
    FOR Lr_Datos in C_LIST_EMPLEADOS LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      
	  OPEN C_EMPLEADOS(Lr_Datos.COD_EMPLEADO,Lr_Datos.COD_EMPRESA);
	          FETCH C_EMPLEADOS INTO Lr_ObtenerEmpleados;
	  CLOSE C_EMPLEADOS;	

    OPEN C_TELEFONO(Lr_Datos.COD_EMPLEADO,Lr_Datos.COD_EMPRESA);
	  FETCH C_TELEFONO INTO Lv_Telefono_Emp;
	  CLOSE C_TELEFONO;
    
    OPEN C_TELEFONO(Lr_ObtenerEmpleados.ID_JEFE,Lr_ObtenerEmpleados.ID_EMPRESA_JEFE);
    FETCH C_TELEFONO INTO Lv_Telefono_Jef;
    CLOSE C_TELEFONO;
           
    OPEN C_OFICINA(Lr_ObtenerEmpleados.ID_OFICINA,Lr_ObtenerEmpleados.COD_EMPRESA);
	  FETCH C_OFICINA INTO Lv_Oficina;
	  CLOSE C_OFICINA;
    
		IF(Lr_ObtenerEmpleados.ID_JEFE IS NOT NULL AND Lr_ObtenerEmpleados.ID_EMPRESA_JEFE IS NOT NULL)	THEN
					OPEN C_EMPLEADOS(Lr_ObtenerEmpleados.ID_JEFE , Lr_ObtenerEmpleados.ID_EMPRESA_JEFE);
					  FETCH C_EMPLEADOS INTO Lr_ObtenerJefes;
            
            OPEN C_OFICINA(Lr_ObtenerJefes.ID_OFICINA,Lr_ObtenerJefes.COD_EMPRESA);
            FETCH C_OFICINA INTO Lv_Oficina_Jef;
            CLOSE C_OFICINA;
            
          CLOSE C_EMPLEADOS;
      END IF;
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_nombre_completo":"'||Lr_ObtenerEmpleados.NOMBRE_COMPLETO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_nombres":"'||Lr_ObtenerEmpleados.NOSMBRES||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_apellidos":"'||Lr_ObtenerEmpleados.APELLIDOS||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_username":"'||Lr_ObtenerEmpleados.LOGIN||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_email_corporativo":"'||Lr_ObtenerEmpleados.CORREO_CORPORATIVO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_cargo":"'||Lr_ObtenerEmpleados.CARGO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_sexo":"'||Lr_ObtenerEmpleados.SEXO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_fecha_nacimiento":"'||Lr_ObtenerEmpleados.FECH_NACIMIENTO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_fecha_ingreso":"'||Lr_ObtenerEmpleados.FECH_INGRESO||'",'||
              chr(10)||LPAD(' ',9, ' ')||'"usuario_fecha_salida":"'||Lr_ObtenerEmpleados.FECH_EGRESO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_teléfono":"'||Lv_Telefono_Emp.TELEFONO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_provincia":"'||Lr_ObtenerEmpleados.PROVINCIA||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_cantón":"'||Lr_ObtenerEmpleados.CANTON||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_oficina":"'||Lv_Oficina.OFICINA||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_empresa":"'||Lr_ObtenerEmpleados.COD_EMPRESA||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_nombre_completo":"'||Lr_ObtenerJefes.NOMBRE_COMPLETO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_nombres":"'||Lr_ObtenerJefes.NOSMBRES||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_apellidos":"'||Lr_ObtenerJefes.APELLIDOS||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_username":"'||Lr_ObtenerJefes.LOGIN||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_email_corporativo":"'||Lr_ObtenerJefes.CORREO_CORPORATIVO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_cargo":"'||Lr_ObtenerJefes.CARGO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_teléfono":"'||Lv_Telefono_Jef.TELEFONO||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_provincia":"'||Lr_ObtenerJefes.PROVINCIA||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_cantón":"'||Lr_ObtenerJefes.CANTON||'",'||
							chr(10)||LPAD(' ',9, ' ')||'"usuario_jefe_oficina":"'||Lv_Oficina_Jef.OFICINA||'"'||
							chr(10)||LPAD(' ',6, ' ')||'}';					  
      --
					  IF LENGTH(Lv_JasonAux) + LENGTH(Lv_RegJSon)  > 32767 THEN
						Lv_Jason := Lv_Jason || Lv_JasonAux;
						Lv_JasonAux := Lv_RegJSon;
					  ELSE
						Lv_JasonAux := Lv_JasonAux||Lv_RegJSon;
					  END IF;
					  --
					  Ln_Linea := Ln_Linea + 1;
      --
    END LOOP;
    --
    Lv_Jason := Lv_Jason || Lv_JasonAux;
    Lv_Jason := Lv_Jason||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Jason := Lv_Jason||chr(10)||'}';
    --

    IF NVL(Ln_Linea,0) = 0 THEN
      Pv_Mensaje := 'No existen datos del empleado';
      Pv_Status  := '404';
    END IF;
    --
    RETURN Lv_Jason;
    --
    EXCEPTION
    WHEN OTHERS THEN
    
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.RHKG_CONSULTA.F_GET_JSON_EMPLEADOS',
                                           'Error en F_GET_JSON_EMPLEADOS: ' ||
                                           SQLERRM,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);

  END F_GET_JSON_EMPLEADOS;

  FUNCTION F_GET_JSON_TEL_EMPLEADO_LOGIN ( Pv_Login   VARCHAR2,
                                            Pv_Status  OUT VARCHAR2,
                                            Pv_Mensaje OUT VARCHAR2 ) RETURN CLOB IS

    CURSOR C_LIST_EMPLEADOS IS
    SELECT 
            VE.NO_CIA COD_EMPRESA,
            VE.NO_EMPLE COD_EMPLEADO
    FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
    WHERE VE.LOGIN_EMPLE= Pv_Login;

    CURSOR C_EMPLEADOS IS
      SELECT 
                NO_CIA,
                NO_EMPLE
	 FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VEE
   WHERE LOGIN_EMPLE=Pv_Login;     


    CURSOR C_TELEFONO(cv_empleado VARCHAR2, cn_empresa NUMBER) IS
    SELECT 
            CEDULA, TELEFONO, CELULAR,CELULAR2,CELULAR3
    FROM NAF47_TNET.ARPLME ARP
    WHERE ARP.NO_EMPLE=cv_empleado AND
          ARP.NO_CIA=cn_empresa;

    CURSOR C_OFICINA(cv_oficina VARCHAR2, cn_empresa NUMBER) IS
    SELECT 
            ARPO.NOMBRE_OFICINA OFICINA
    FROM NAF47_TNET.ARPLOFICINA ARPO
    WHERE ARPO.OFICINA=cv_oficina AND
          ARPO.NO_CIA=cn_empresa;  

    CURSOR C_TELEFONO_EMPRESA (CV_CEDULA VARCHAR2)IS  
    SELECT  NOMBRE_ELEMENTO TEL_EMPRESA
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DE, DB_INFRAESTRUCTURA.INFO_ELEMENTO E
             WHERE DE.ELEMENTO_ID=E.ID_ELEMENTO
             AND DE.DETALLE_DESCRIPCION = 'PROPIETARIO CHIP'
             AND DE.DETALLE_VALOR IN (SELECT ID_PERSONA_ROL FROM DB_COMERCIAL.INFO_PERSONA P, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                        WHERE P.ID_PERSONA=PER.PERSONA_ID
                                        AND P.IDENTIFICACION_CLIENTE=CV_CEDULA
                                        AND PER.ESTADO='Activo')
               AND DE.ESTADO <> 'Eliminado';

    Lr_ObtenerEmpleados  C_EMPLEADOS%ROWTYPE;
	Lv_JsonAux          VARCHAR2(32767) := NULL;
    Lv_RegJSon           VARCHAR2(9000) := NULL;
    Lv_Json             CLOB := NULL;
    Ln_Linea             NUMBER := 0;
    Lv_Email             VARCHAR2(1000) := NULL;
    Lv_Telefono_Emp      C_TELEFONO%ROWTYPE;
    Lv_Telefono_Jef      C_TELEFONO%ROWTYPE;
    Lv_Oficina           C_OFICINA%ROWTYPE;
    Lv_Oficina_Jef       C_OFICINA%ROWTYPE;
    Lc_PersonaRol        C_TELEFONO_EMPRESA%ROWTYPE;

  BEGIN
    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    Lv_Json := '{'||chr(10);
    Lv_Json := Lv_Json||LPAD(' ',3, ' ')||'"empleado":[';

     

	  OPEN C_EMPLEADOS;
      FETCH C_EMPLEADOS INTO Lr_ObtenerEmpleados;
	  CLOSE C_EMPLEADOS;	

      OPEN C_TELEFONO(Lr_ObtenerEmpleados.NO_EMPLE,Lr_ObtenerEmpleados.NO_CIA);
	  FETCH C_TELEFONO INTO Lv_Telefono_Emp;
        IF C_TELEFONO%FOUND THEN
           Ln_Linea := Ln_Linea + 1;
        END IF; 
	  CLOSE C_TELEFONO;

      OPEN C_TELEFONO_EMPRESA (Lv_Telefono_Emp.CEDULA);--('0926700642');
      FETCH C_TELEFONO_EMPRESA INTO Lc_PersonaRol;
        IF C_TELEFONO_EMPRESA%FOUND THEN
           Ln_Linea := Ln_Linea + 1;
        END IF; 
      CLOSE C_TELEFONO_EMPRESA;
      
      IF NVL(Ln_Linea,0) > 0 THEN
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
	  chr(10)||LPAD(' ',9, ' ')||'"telefono":"'||NVL(Lv_Telefono_Emp.TELEFONO,'NA')||'",'||
	  chr(10)||LPAD(' ',9, ' ')||'"celular1":"'||NVL(Lv_Telefono_Emp.CELULAR,'NA')||'",'||
	  chr(10)||LPAD(' ',9, ' ')||'"celular2":"'||NVL(Lv_Telefono_Emp.CELULAR2,'NA')||'",'||
      chr(10)||LPAD(' ',9, ' ')||'"celular3":"'||NVL(Lv_Telefono_Emp.CELULAR3,'NA')||'",'||
	  chr(10)||LPAD(' ',9, ' ')||'"telempresa":"'||NVL(Lc_PersonaRol.TEL_EMPRESA,'NA')||'"'||
	  chr(10)||LPAD(' ',6, ' ')||'}';					  

	  IF LENGTH(Lv_JsonAux) + LENGTH(Lv_RegJSon)  > 32767 THEN
	    Lv_Json := Lv_Json || Lv_JsonAux;
		Lv_JsonAux := Lv_RegJSon;
	  ELSE
		Lv_JsonAux := Lv_JsonAux||Lv_RegJSon;
	  END IF;

     
    Lv_Json := Lv_Json || Lv_JsonAux;
    Lv_Json := Lv_Json||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Json := Lv_Json||chr(10)||'}';

    ELSE
      Pv_Mensaje := 'No existen datos del empleado';
      Pv_Status  := '404';
    END IF;

    RETURN Lv_Json;
   END F_GET_JSON_TEL_EMPLEADO_LOGIN;


  FUNCTION F_GET_JSON_LOGIN_EMPLEADO_TEL ( Pv_Telefono VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 ) RETURN CLOB IS




    CURSOR C_EMPLEADOS IS
      SELECT NO_CIA,NO_EMPLE
            FROM NAF47_TNET.ARPLME 
            WHERE CELULAR IS NOT NULL
            AND CELULAR = Pv_Telefono
      UNION
      SELECT NO_CIA,NO_EMPLE
            FROM NAF47_TNET.ARPLME 
            WHERE CELULAR2 IS NOT NULL
            AND CELULAR2 = Pv_Telefono
      UNION
      SELECT NO_CIA,NO_EMPLE
            FROM NAF47_TNET.ARPLME 
            WHERE CELULAR3 IS NOT NULL
            AND CELULAR3 =Pv_Telefono
      UNION
      SELECT NO_CIA,NO_EMPLE
            FROM NAF47_TNET.ARPLME 
            WHERE TELEFONO IS NOT NULL
            AND TELEFONO = Pv_Telefono;    

	
	
    CURSOR C_LOGIN_EMPLE(CV_NO_CIA VARCHAR2, CV_NO_EMPLE NUMBER) IS
      SELECT LOGIN_EMPLE 
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS 
      WHERE NO_CIA=CV_NO_CIA
      AND NO_EMPLE =CV_NO_EMPLE;


   CURSOR C_ID_PERSONA_ROL IS  
    SELECT  DE.DETALLE_VALOR
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DE, DB_INFRAESTRUCTURA.INFO_ELEMENTO E
    WHERE de.elemento_id=E.ID_ELEMENTO
    AND DE.DETALLE_DESCRIPCION = 'PROPIETARIO CHIP'
    AND E.NOMBRE_ELEMENTO = Pv_Telefono
    AND DE.ESTADO <> 'Eliminado';

    CURSOR C_LOGIN_EMPLE2(CV_ID_PERSONA_ROL DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
    SELECT P.LOGIN FROM DB_COMERCIAL.INFO_PERSONA P, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
    WHERE P.ID_PERSONA=PER.PERSONA_ID
    AND PER.ID_PERSONA_ROL=CV_ID_PERSONA_ROL
    AND PER.ESTADO='Activo';

    Lr_ObtenerEmpleados      C_EMPLEADOS%ROWTYPE;
    Lv_JsonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(9000) := NULL;
    Lv_Json          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    Lv_Email          VARCHAR2(1000) := NULL;
    Lv_LoginEmp       C_LOGIN_EMPLE%ROWTYPE;
    Lc_PersonaRol     C_ID_PERSONA_ROL%ROWTYPE;
    Lv_LoginEmp2      C_LOGIN_EMPLE2%ROWTYPE;
    Lv_Login          VARCHAR2(100);
    Lb_Login          BOOLEAN :=FALSE;

  BEGIN

    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    Lv_Json := '{'||chr(10);
    Lv_Json := Lv_Json||LPAD(' ',3, ' ')||'"empleado":[';

    
	  OPEN C_EMPLEADOS;
      FETCH C_EMPLEADOS INTO Lr_ObtenerEmpleados;
	  CLOSE C_EMPLEADOS;	

      OPEN C_LOGIN_EMPLE(Lr_ObtenerEmpleados.NO_CIA,Lr_ObtenerEmpleados.NO_EMPLE);
	  FETCH C_LOGIN_EMPLE INTO Lv_LoginEmp;
      IF C_LOGIN_EMPLE%FOUND THEN
       Lb_Login:= TRUE;
       Lv_Login:=Lv_LoginEmp.LOGIN_EMPLE;
      END IF;
	  CLOSE C_LOGIN_EMPLE;

      IF NOT Lb_Login THEN
        OPEN C_ID_PERSONA_ROL;
        FETCH C_ID_PERSONA_ROL INTO Lc_PersonaRol;
        CLOSE C_ID_PERSONA_ROL;

        OPEN C_LOGIN_EMPLE2(Lc_PersonaRol.DETALLE_VALOR);
        FETCH C_LOGIN_EMPLE2 INTO Lv_Login;
        
        CLOSE C_LOGIN_EMPLE2;
      END IF;

      IF NVL(Lv_Login,'X') != 'X' THEN

      	Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
		chr(10)||LPAD(' ',9, ' ')||'"login":"'||NVL(Lv_Login,'NA')||'"'||
		chr(10)||LPAD(' ',6, ' ')||'}';					  

		IF LENGTH(Lv_JsonAux) + LENGTH(Lv_RegJSon)  > 32767 THEN
          Lv_Json := Lv_Json || Lv_JsonAux;
		  Lv_JsonAux := Lv_RegJSon;
		ELSE
		  Lv_JsonAux := Lv_JsonAux||Lv_RegJSon;
		END IF;
	
     Lv_Json := Lv_Json || Lv_JsonAux;
     Lv_Json := Lv_Json||chr(10)||LPAD(' ',3, ' ')||']';
     Lv_Json := Lv_Json||chr(10)||'}';
    
      ELSE
        Pv_Mensaje := 'No existen datos del empleado';
        Pv_Status  := '404';
      END IF;

    RETURN Lv_Json;
  END F_GET_JSON_LOGIN_EMPLEADO_TEL;


  FUNCTION F_GET_JSON_CONS_TIPO_PEDIDO ( PN_ID_PEDIDO   NUMBER,
                                         Pv_Status  OUT VARCHAR2,
                                         Pv_Mensaje OUT VARCHAR2 ) RETURN CLOB IS

    CURSOR C_PEDIDO IS
    SELECT  OBSERVACION, PEDIDO_TIPO 
    FROM DB_COMPRAS.INFO_PEDIDO 
    WHERE ID_PEDIDO = PN_ID_PEDIDO;


    Lv_JsonAux          VARCHAR2(32767) := NULL;
    Lv_RegJSon           VARCHAR2(9000) := NULL;
    Lv_Json             CLOB := NULL;
    Ln_Linea             NUMBER := 0;
    Lv_Email             VARCHAR2(1000) := NULL;
    Lc_Pedido           C_PEDIDO%ROWTYPE;

  BEGIN
    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    Lv_Json := '{'||chr(10);
    Lv_Json := Lv_Json||LPAD(' ',3, ' ')||'"pedido":[';

      OPEN C_PEDIDO;
      FETCH C_PEDIDO INTO Lc_Pedido;
        IF C_PEDIDO%FOUND THEN
           Ln_Linea := Ln_Linea + 1;
        END IF;
	  CLOSE C_PEDIDO;	

      IF NVL(Ln_Linea,0) > 0 THEN
          Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
          chr(10)||LPAD(' ',9, ' ')||'"informacion":"'||NVL(Lc_Pedido.OBSERVACION,'NA')||'",'||
          chr(10)||LPAD(' ',9, ' ')||'"tipopedido":"'||NVL(Lc_Pedido.PEDIDO_TIPO,'NA')||'"'||
          chr(10)||LPAD(' ',6, ' ')||'}';					  
    
          IF LENGTH(Lv_JsonAux) + LENGTH(Lv_RegJSon)  > 32767 THEN
            Lv_Json := Lv_Json || Lv_JsonAux;
            Lv_JsonAux := Lv_RegJSon;
          ELSE
            Lv_JsonAux := Lv_JsonAux||Lv_RegJSon;
          END IF;


    Lv_Json := Lv_Json || Lv_JsonAux;
    Lv_Json := Lv_Json||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Json := Lv_Json||chr(10)||'}';

    ELSE
      Pv_Mensaje := 'No existen datos del empleado';
      Pv_Status  := '404';
    END IF;

    RETURN Lv_Json;
  END F_GET_JSON_CONS_TIPO_PEDIDO;

END RHKG_CONSULTA;

/
