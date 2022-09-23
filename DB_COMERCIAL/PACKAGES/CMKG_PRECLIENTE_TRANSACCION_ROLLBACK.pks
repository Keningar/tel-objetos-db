  
 CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PRECLIENTE_TRANSACCION AS
 
   /**
    * Documentación para P_SET_CARACTERISTICAS
    * Procedimiento para INSERTAR Y ACTUALIZAR CARACTERISTICAS
    *
    * @param   Pv_Caracteristica      - Descripcion de la caracteristica, 
    *          Pv_Valor               - valor de caracteristica
    *          Pn_IdPersonaRol        - ID_PERSONA_ROL
    *          Pv_UsrCreacion         - USUARIO
    *          Pv_ClientIp            - IP
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 28/06/2021
    */
   PROCEDURE  P_SET_CARACTERISTICAS(Pv_Caracteristica IN VARCHAR2  ,  Pv_Valor IN CLOB  , Pn_IdPersonaRol  IN NUMBER  , Pv_UsrCreacion IN VARCHAR2   , Pv_ClientIp IN VARCHAR2  );
     /**
    * Documentación para P_CREAR PRECLIENTE
    * Procedimiento para crear pre cliente
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.0 20/08/2021
    */
    PROCEDURE P_CREAR_PRECLIENTE(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response  OUT SYS_REFCURSOR);

END CMKG_PRECLIENTE_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PRECLIENTE_TRANSACCION AS

PROCEDURE  P_SET_CARACTERISTICAS(Pv_Caracteristica IN VARCHAR2  ,  Pv_Valor IN CLOB  , Pn_IdPersonaRol  IN NUMBER  , Pv_UsrCreacion IN VARCHAR2   , Pv_ClientIp IN VARCHAR2  ) AS
      Pv_Mensaje CLOB;
      Pcl_AdmiCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA%ROWTYPE;
      Pcl_InfoPersonaEmpresaRolCarac DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC%ROWTYPE; 
  
      CURSOR C_GetCaracteristica(Cv_Descripcion VARCHAR2) IS 
           SELECT  ac.* FROM  DB_COMERCIAL.ADMI_CARACTERISTICA ac WHERE ac.DESCRIPCION_CARACTERISTICA = Cv_Descripcion AND ac.ESTADO ='Activo';
      
      CURSOR C_GetListPersEmpRolCarac(Cn_IdCaracteristica NUMBER , Cn_IdPersonaEmpresRol NUMBER) IS                      
           SELECT  iperc.* FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc WHERE iperc.CARACTERISTICA_ID = Cn_IdCaracteristica  AND iperc.PERSONA_EMPRESA_ROL_ID =Cn_IdPersonaEmpresRol  AND iperc.ESTADO ='Activo'; 

   BEGIN 
       
       OPEN  C_GetCaracteristica(Pv_Caracteristica); 
       FETCH C_GetCaracteristica INTO  Pcl_AdmiCaracteristica ;  
       CLOSE C_GetCaracteristica ;  
       
       IF  Pcl_AdmiCaracteristica.ID_CARACTERISTICA IS NULL THEN
           Pv_Mensaje := 'No se ha definido la característica '|| Pv_Caracteristica;
           dbms_output.put_line( Pv_Mensaje );  
           RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);     
       END IF ; 

       Pcl_InfoPersonaEmpresaRolCarac:= NULL;      
       OPEN C_GetListPersEmpRolCarac(Pcl_AdmiCaracteristica.ID_CARACTERISTICA , Pn_IdPersonaRol); 
       FETCH C_GetListPersEmpRolCarac INTO  Pcl_InfoPersonaEmpresaRolCarac  ;  
       CLOSE C_GetListPersEmpRolCarac;  
      
       Pcl_InfoPersonaEmpresaRolCarac.VALOR := Pv_Valor ; 
       Pcl_InfoPersonaEmpresaRolCarac.ESTADO := 'Activo';                     
  
       IF  Pcl_InfoPersonaEmpresaRolCarac.ID_PERSONA_EMPRESA_ROL_CARACT  IS  NULL THEN
           Pcl_InfoPersonaEmpresaRolCarac.ID_PERSONA_EMPRESA_ROL_CARACT:=  DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL;
           Pcl_InfoPersonaEmpresaRolCarac.PERSONA_EMPRESA_ROL_ID:=         Pn_IdPersonaRol;  
           Pcl_InfoPersonaEmpresaRolCarac.CARACTERISTICA_ID:=              Pcl_AdmiCaracteristica.ID_CARACTERISTICA; 
           Pcl_InfoPersonaEmpresaRolCarac.FE_CREACION:=                    SYSDATE;     
           Pcl_InfoPersonaEmpresaRolCarac.USR_CREACION:=                   Pv_UsrCreacion; 
           Pcl_InfoPersonaEmpresaRolCarac.IP_CREACION:=                    Pv_ClientIp ;
           INSERT  INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC VALUES Pcl_InfoPersonaEmpresaRolCarac; 
           Pv_Mensaje :='CARCATERISTICA '||Pv_Caracteristica||' INSERTADA '||Pcl_InfoPersonaEmpresaRolCarac.VALOR||' ID_PERSONA_EMPRESA_ROL_CARAC=>'||Pcl_InfoPersonaEmpresaRolCarac.ID_PERSONA_EMPRESA_ROL_CARACT;                    
      ELSE 
          UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc   SET
                   iperc.ESTADO      = Pcl_InfoPersonaEmpresaRolCarac.ESTADO, 
                   iperc.VALOR       = Pcl_InfoPersonaEmpresaRolCarac.VALOR,
                   iperc.FE_ULT_MOD  = SYSDATE,
                   iperc.USR_ULT_MOD = Pv_UsrCreacion
           WHERE  iperc.ID_PERSONA_EMPRESA_ROL_CARACT =   Pcl_InfoPersonaEmpresaRolCarac.ID_PERSONA_EMPRESA_ROL_CARACT; 
          Pv_Mensaje := 'CARCATERISTICA '||Pv_Caracteristica||' ACTUALIZADA '||Pcl_InfoPersonaEmpresaRolCarac.VALOR||' ID_PERSONA_EMPRESA_ROL_CARAC=>'||Pcl_InfoPersonaEmpresaRolCarac.ID_PERSONA_EMPRESA_ROL_CARACT;                    
       END IF ;
   dbms_output.put_line( Pv_Mensaje ); 
   COMMIT;
END P_SET_CARACTERISTICAS;   


PROCEDURE  P_CREAR_PRECLIENTE(Pcl_Request IN CLOB,Pv_Mensaje OUT VARCHAR2,Pv_Status OUT VARCHAR2,Pcl_Response OUT SYS_REFCURSOR)AS 
   Lv_CodEmpresa VARCHAR2(100);
   Ln_OficinaId  NUMBER;
   Lv_UsrCreacion VARCHAR2(100);
   Lv_ClientIp VARCHAR2(100);
   Lv_PrefijoEmpresa VARCHAR2(100);
   Ln_CountFormasContacto NUMBER;
   Lv_Recomendacion CLOB;
   Lv_DataTemp VARCHAR2(100);
   Lv_Revertir VARCHAR2(100);

   TYPE Lcl_Date IS RECORD(
       month VARCHAR2(100),
       day VARCHAR2(100),
       year VARCHAR2(100)
    ); 
   
   TYPE Lcl_DatosForm IS RECORD(
       Lv_Identificacion VARCHAR2(100),  
       Lv_TipoTributario VARCHAR2(100), 
       Lv_OrigenIngresos VARCHAR2(100), 
       Lv_Nacionalidad VARCHAR2(100), 
       Lv_Nombres CLOB, 
       Lv_Apellidos CLOB, 
       Lv_RazonSocial CLOB, 
       Lv_RepresentanteLegal CLOB, 
       Lv_EstadoCivil VARCHAR2(100), 
       Lv_FechaNacimiento Lcl_Date, 
       Lv_Referido VARCHAR2(100), 
       Ln_IdReferido NUMBER, 
       Ln_IdPerReferido NUMBER, 
       Lv_YaExiste VARCHAR2(100), 
       Ln_Id NUMBER, 
       Ln_IdFormaPago NUMBER, 
       Ln_IdTipoCuenta NUMBER, 
       Ln_IdBancoTipoCuenta VARCHAR2(100), 
       Lv_OrigenWeb VARCHAR2(100),  
       Ln_IdPais NUMBER,
       Lv_TipoEmpresa VARCHAR2(100), 
       Lv_DireccionTributaria  CLOB,
       Lv_ContribuyenteEspecial  VARCHAR2(100),
       Lv_PagaIva  VARCHAR2(100),
       Lv_NumeroConadis  VARCHAR2(100) , 
       Ln_IdTitulo  NUMBER, 
       Lv_Genero VARCHAR2(100), 
       Lv_TipoIdentificacion  VARCHAR2(100), 
       Lv_IdOficinaFacturacion  VARCHAR2(100),
       Lv_EsPrepago  VARCHAR2(100),
       Lv_Holding VARCHAR2(100),
       Lv_EsDistribuidor VARCHAR2(100)
   );

  Pcl_DatosForm Lcl_DatosForm;

  TYPE Lcl_GetClienteIdent IS RECORD(
       Ln_IdPersona NUMBER,
       Ln_IdPersonaRol NUMBER,
       Ln_IdEmpresaRol NUMBER,
       Ln_IdRol NUMBER,
       Ln_IdTipoRol NUMBER
   );
  Pcl_ClienteGlobal Lcl_GetClienteIdent;
  Pcl_ClienteCancelado  Lcl_GetClienteIdent;
  --GLOBALES     
  Lv_ExistePreCliente VARCHAR2(100);
  Lv_DescRoles VARCHAR2(100);
  Lv_Estados  VARCHAR2(100);

  Pcl_InfoPersona  DB_COMERCIAL.INFO_PERSONA%ROWTYPE;
  Pcl_InfoPersonaEmpresaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE;
  Pcl_AdmiCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA%ROWTYPE;
  Pcl_AdmiCiclo DB_COMERCIAL.ADMI_CICLO%ROWTYPE; 
  Pcl_InfoPersonaEmpFormaPago  DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO%ROWTYPE;
  Pcl_InfoPersonaReferido DB_COMERCIAL.INFO_PERSONA_REFERIDO%ROWTYPE; 
  Pcl_InfoPersonaEmpresaRolHisto DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE; 
  Pcl_InfoPersonaFormaContacto  INFO_PERSONA_FORMA_CONTACTO%ROWTYPE; 
  Pcl_InfoPersonaEmpresaRolCarac DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC%ROWTYPE; 

  CURSOR C_GetPersona(Cn_Id NUMBER) IS
       SELECT  ip.* FROM DB_COMERCIAL.INFO_PERSONA ip WHERE ip.ID_PERSONA  = Cn_Id;
   
  CURSOR C_GetTipoRolPorEmpresa(Cv_NombreTipoRol VARCHAR2 , Cv_CodigoEmpresa VARCHAR2 ) IS
       SELECT ier.ID_EMPRESA_ROL
       FROM DB_COMERCIAL.INFO_EMPRESA_ROL ier,
               DB_GENERAL.ADMI_ROL ar, 
               DB_GENERAL.ADMI_TIPO_ROL atr
       WHERE ier.ROL_ID             = ar.ID_ROL
       AND ar.TIPO_ROL_ID           = atr.ID_TIPO_ROL
       AND ier.EMPRESA_COD          = Cv_CodigoEmpresa
       AND atr.DESCRIPCION_TIPO_ROL = Cv_NombreTipoRol
       AND ar.DESCRIPCION_ROL       = Cv_NombreTipoRol;
  
  CURSOR C_GetClienteIdent(Cv_Identificacion VARCHAR2 , Cv_DescRol VARCHAR2,  Cv_CodEmpresa VARCHAR2, Cv_Estado VARCHAR2 ) IS
       SELECT   ip.ID_PERSONA ,  per.ID_PERSONA_ROL ,  er.ID_EMPRESA_ROL , rol.ID_ROL ,  trol.ID_TIPO_ROL
       FROM
       DB_COMERCIAL.INFO_PERSONA ip,
       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per,
       DB_COMERCIAL.INFO_EMPRESA_ROL  er,
       DB_GENERAL.ADMI_ROL rol,
       DB_GENERAL.ADMI_TIPO_ROL trol
       WHERE 
       per.EMPRESA_ROL_ID = er.ID_EMPRESA_ROL AND
       er.ROL_ID = rol.ID_ROL AND
       rol.TIPO_ROL_ID = trol.ID_TIPO_ROL AND
       per.PERSONA_ID = ip.ID_PERSONA AND
       ip.IDENTIFICACION_CLIENTE = Cv_Identificacion AND
       trol.DESCRIPCION_TIPO_ROL in (
       select  regexp_substr(Cv_DescRol ,'[^,]+', 1, level) from dual
       connect by regexp_substr(Cv_DescRol , '[^,]+', 1, level) is not null
       ) AND
       er.EMPRESA_COD = Cv_CodEmpresa 
       AND per.ESTADO in (
       select  regexp_substr(Cv_Estado,'[^,]+', 1, level) from dual
       connect by regexp_substr(Cv_Estado, '[^,]+', 1, level) is not null
       ) ORDER BY per.ESTADO DESC;
   
   CURSOR C_GetPersEmpRolHisto(Cv_Identificacion VARCHAR2 , Cv_DescRol VARCHAR2,  Cv_CodEmpresa VARCHAR2, Cv_Estado VARCHAR2 ) IS 
       SELECT * FROM (SELECT 
       perh.ID_PERSONA_EMPRESA_ROL_HISTO , 
       perh.USR_CREACION ,
       perh.FE_CREACION ,
       perh.IP_CREACION, 
       perh.ESTADO,
       perh.PERSONA_EMPRESA_ROL_ID, 
       perh.OBSERVACION ,
       perh.MOTIVO_ID,
       perh.EMPRESA_ROL_ID ,
       perh.OFICINA_ID ,
       perh.DEPARTAMENTO_ID ,
       perh.CUADRILLA_ID , 
       perh.REPORTA_PERSONA_EMPRESA_ROL_ID, 
       perh.ES_PREPAGO
       FROM 
       DB_COMERCIAL.INFO_PERSONA  ip,
       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per,
       DB_COMERCIAL.INFO_EMPRESA_ROL er,
       DB_GENERAL.ADMI_ROL rol,
       DB_GENERAL.ADMI_TIPO_ROL trol,
       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO perh
       WHERE 
       per.EMPRESA_ROL_ID = er.ID_EMPRESA_ROL AND
       er.ROL_ID = rol.ID_ROL AND
       rol.TIPO_ROL_ID = trol.ID_TIPO_ROL AND
       per.PERSONA_ID = ip.ID_PERSONA AND
       ip.IDENTIFICACION_CLIENTE =Cv_Identificacion  AND
       trol.DESCRIPCION_TIPO_ROL in (
       select  regexp_substr(Cv_DescRol ,'[^,]+', 1, level) from dual
       connect by regexp_substr(Cv_DescRol , '[^,]+', 1, level) is not null
       ) AND
       er.EMPRESA_COD =  Cv_CodEmpresa 
       AND per.ESTADO in (
       select  regexp_substr(Cv_Estado,'[^,]+', 1, level) from dual
       connect by regexp_substr(Cv_Estado, '[^,]+', 1, level) is not null
       ) 
       AND perh.ESTADO in (
       select  regexp_substr(Cv_Estado,'[^,]+', 1, level) from dual
       connect by regexp_substr(Cv_Estado, '[^,]+', 1, level) is not null
       ) 
       AND per.ID_PERSONA_ROL = perh.PERSONA_EMPRESA_ROL_ID  
       ORDER BY perh.FE_CREACION DESC ) WHERE ROWNUM =1;      

  CURSOR C_GetPersonaEmpresaRol(Cn_Id NUMBER) IS 
       SELECT  iper.* FROM  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper WHERE iper.ID_PERSONA_ROL  = Cn_Id ; 
 
  CURSOR C_GetCaracteristica(Cv_Descripcion VARCHAR2) IS 
       SELECT  ac.* FROM  DB_COMERCIAL.ADMI_CARACTERISTICA ac WHERE ac.DESCRIPCION_CARACTERISTICA = Cv_Descripcion AND ac.ESTADO ='Activo';
  
  CURSOR C_GetListPersEmpRolCarac(Cn_IdCaracteristica NUMBER , Cn_IdPersonaEmpresRol NUMBER) IS                      
       SELECT  iperc.* FROM  INFO_PERSONA_EMPRESA_ROL_CARAC iperc WHERE iperc.CARACTERISTICA_ID = Cn_IdCaracteristica  AND iperc.PERSONA_EMPRESA_ROL_ID =Cn_IdPersonaEmpresRol  AND iperc.ESTADO ='Activo'; 

  CURSOR C_GetCiclo(Cv_CodigoEmpresa VARCHAR2) IS 
       SELECT  c.* FROM  DB_COMERCIAL.ADMI_CICLO c  WHERE c.EMPRESA_COD  = Cv_CodigoEmpresa AND c.ESTADO ='Activo';
                       
  CURSOR C_GetListFormaPago(Cn_Id NUMBER) IS   
      SELECT   afp.* FROM DB_GENERAL.ADMI_FORMA_PAGO afp WHERE afp.ID_FORMA_PAGO = Cn_Id; 
 
  CURSOR C_GetFormaPago(Cn_Id VARCHAR2 , Cv_Descripcion VARCHAR2) IS   
      SELECT afc.ID_FORMA_CONTACTO FROM  DB_COMERCIAL.ADMI_FORMA_CONTACTO afc 
      WHERE afc.ID_FORMA_CONTACTO = Cn_Id   OR afc.DESCRIPCION_FORMA_CONTACTO = Cv_Descripcion ;


  BEGIN  
   APEX_JSON.PARSE(Pcl_Request); 

   Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'strCodEmpresa'); 
   Ln_OficinaId  := APEX_JSON.get_varchar2(p_path => 'intOficinaId'); 
   Lv_UsrCreacion := APEX_JSON.get_varchar2(p_path => 'strUsrCreacion'); 
   Lv_ClientIp := APEX_JSON.get_varchar2(p_path => 'strClientIp'); 
   Lv_PrefijoEmpresa := APEX_JSON.get_varchar2(p_path => 'strPrefijoEmpresa');  
   Ln_CountFormasContacto := APEX_JSON.get_count(p_path => 'arrayFormasContacto');
   Lv_Recomendacion := APEX_JSON.get_varchar2(p_path => 'arrayRecomendacionTarjeta');  
   Pcl_DatosForm.Lv_Identificacion := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.identificacionCliente');
   Pcl_DatosForm.Lv_TipoTributario := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.tipoTributario');
   Pcl_DatosForm.Lv_OrigenIngresos := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.origenIngresos');
   Pcl_DatosForm.Lv_Nacionalidad := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.nacionalidad');
   Pcl_DatosForm.Lv_Nombres := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.nombres');
   Pcl_DatosForm.Lv_Apellidos := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.apellidos');
   Pcl_DatosForm.Lv_RazonSocial := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.razonSocial');
   Pcl_DatosForm.Lv_RepresentanteLegal := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.representanteLegal');
   Pcl_DatosForm.Lv_EstadoCivil := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.estadoCivil'); 
   Pcl_DatosForm.Lv_FechaNacimiento.month := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.fechaNacimiento.month');
   Pcl_DatosForm.Lv_FechaNacimiento.day := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.fechaNacimiento.day');
   Pcl_DatosForm.Lv_FechaNacimiento.year := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.fechaNacimiento.year');    
   Pcl_DatosForm.Lv_Referido := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.referido');
   Pcl_DatosForm.Ln_IdReferido := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.idreferido');
   Pcl_DatosForm.Ln_IdPerReferido := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.idperreferido');
   Pcl_DatosForm.Lv_YaExiste := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.yaexiste');
   Pcl_DatosForm.Ln_Id := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.id'); 
   Pcl_DatosForm.Ln_IdFormaPago := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.formaPagoId');
   Pcl_DatosForm.Ln_IdTipoCuenta := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.tipoCuentaId');
   Pcl_DatosForm.Ln_IdBancoTipoCuenta := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.bancoTipoCuentaId');
   Pcl_DatosForm.Lv_OrigenWeb := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.origen_web');
   Pcl_DatosForm.Ln_IdPais := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.intIdPais');
   Pcl_DatosForm.Lv_TipoEmpresa := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.tipoEmpresa');
   Pcl_DatosForm.Lv_DireccionTributaria := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.direccionTributaria');
   Pcl_DatosForm.Lv_ContribuyenteEspecial  := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.contribuyenteEspecial');
   Pcl_DatosForm.Lv_PagaIva := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.pagaIva ');
   Pcl_DatosForm.Lv_NumeroConadis := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.numeroConadis');
   Pcl_DatosForm.Ln_IdTitulo := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.tituloId');
   Pcl_DatosForm.Lv_Genero := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.genero');
   Pcl_DatosForm.Lv_TipoIdentificacion := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.tipoIdentificacion');
   Pcl_DatosForm.Lv_IdOficinaFacturacion := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.idOficinaFacturacion');
   Pcl_DatosForm.Lv_EsPrepago := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.esPrepago'); 
   Pcl_DatosForm.Lv_Holding := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.holding'); 
   Pcl_DatosForm.Lv_EsDistribuidor := APEX_JSON.get_varchar2(p_path => 'arrayDatosForm.es_distribuidor'); 
   Lv_Revertir := 'S'; 
   Lv_ExistePreCliente := 'N'; 
   
   
    --VALIDACIONES GENERALES   
    IF  Pcl_DatosForm.Lv_TipoIdentificacion IS  NULL THEN 
        Lv_Revertir := 'N'; 
        Pv_Mensaje := 'Parametro tipoIdentificacion es requerido.';
        dbms_output.put_line( Pv_Mensaje );  
        RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
    END IF;   
   
    IF  Pcl_DatosForm.Lv_OrigenWeb IS  NULL THEN 
        Lv_Revertir := 'N';
        Pv_Mensaje := 'Parametro origen_web es requerido.';
        dbms_output.put_line( Pv_Mensaje );  
        RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
    END IF;  
  
   IF LENGTH( Pcl_DatosForm.Lv_DireccionTributaria ) >200 THEN 
        Lv_Revertir := 'N';
        Pv_Mensaje := 'La dirección ingresada es muy larga, tamaño permitido 200 caracteres.';
        dbms_output.put_line( Pv_Mensaje );  
        RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
    END IF; 

     IF Lv_PrefijoEmpresa <> 'TN' THEN    
           --OBTENGO CARACTERISTICAS DE CICLO_FACTURACION
           OPEN  C_GetCaracteristica('CICLO_FACTURACION'); 
           FETCH C_GetCaracteristica INTO  Pcl_AdmiCaracteristica ;  
           CLOSE C_GetCaracteristica ;  
           
           IF  Pcl_AdmiCaracteristica.ID_CARACTERISTICA IS NULL THEN
               Lv_Revertir := 'N';
               Pv_Mensaje := 'No existe Caracteristica CICLO_FACTURACION - No se pudo Ingresar el Prospecto.';
               dbms_output.put_line( Pv_Mensaje );  
               RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);     
           END IF ; 
   
           --OBTENGO EL CICLO DE FACTURACION ACTIVO POR EMPRESA EN SESION  
           OPEN  C_GetCiclo(Lv_CodEmpresa); 
           FETCH C_GetCiclo INTO  Pcl_AdmiCiclo ;  
           CLOSE C_GetCiclo ;
           
           IF  Pcl_AdmiCiclo.ID_CICLO IS NULL THEN
               Lv_Revertir := 'N';
               Pv_Mensaje := 'No existe Ciclo de Facturación Activo - No se pudo Ingresar el Prospecto.';
               dbms_output.put_line( Pv_Mensaje );  
               RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);     
           END IF ; 
    END IF;

   --VALIDO QUE NO REGISTRE CLIENTE SI ESTE YA EXISTE CON ROL DE CLIENTE 
   Lv_DescRoles := 'Cliente';
   Lv_Estados   := 'Activo';    
   OPEN C_GetClienteIdent(Pcl_DatosForm.Lv_Identificacion, Lv_DescRoles ,Lv_CodEmpresa ,Lv_Estados ); 
     FETCH C_GetClienteIdent  INTO  Pcl_ClienteGlobal;  
     dbms_output.put_line('Cliente Activo IdPersona =>'||Pcl_ClienteGlobal.Ln_IdPersona);    
   CLOSE C_GetClienteIdent;        
      
   IF  Pcl_ClienteGlobal.Ln_IdPersona IS NOT NULL THEN 
        Lv_Revertir := 'N';
        Pv_Mensaje := 'Identificacion ya existente como un Cliente, Por favor ingrese otra Identificacion.';
        dbms_output.put_line( Pv_Mensaje );  
        RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
   ELSE         
        --VALIDO QUE NO REGISTRE PROSPECTO SI ESTE YA EXISTE CON ROL DE PRECLIENTE  
        Lv_DescRoles := 'Pre-cliente';
        Lv_Estados   := 'Activo,Pendiente';    
        OPEN C_GetClienteIdent(Pcl_DatosForm.Lv_Identificacion, Lv_DescRoles ,Lv_CodEmpresa ,Lv_Estados ); 
        FETCH C_GetClienteIdent INTO  Pcl_ClienteGlobal;  
        dbms_output.put_line('Pre-Cliente (Activo,Pendiente) IdPersona =>'||Pcl_ClienteGlobal.Ln_IdPersona);    
        CLOSE C_GetClienteIdent; 
        IF Pcl_ClienteGlobal.Ln_IdPersona IS NOT NULL THEN
           Lv_Revertir := 'N';
           Pv_Mensaje := 'Identificacion ya existente como un Pre-cliente, Por favor ingrese otra Identificacion.';
           dbms_output.put_line( Pv_Mensaje );  
           RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
        ELSE   
           --BUSCAR PRE-CLIENTE INACTIVO
           Lv_DescRoles := 'Pre-cliente';
           Lv_Estados   := 'Inactivo';    
           OPEN C_GetClienteIdent(Pcl_DatosForm.Lv_Identificacion , Lv_DescRoles ,Lv_CodEmpresa ,Lv_Estados ); 
           FETCH C_GetClienteIdent INTO  Pcl_ClienteGlobal;  
           dbms_output.put_line('Per-Cliente Inactivo IdPersona =>'||Pcl_ClienteGlobal.Ln_IdPersona);    
           CLOSE C_GetClienteIdent;   
          
           --BUSCAR CLIENTE CANCELADO
           Lv_DescRoles := 'Cliente';
           Lv_Estados   := 'Cancelado';    
           OPEN C_GetClienteIdent(Pcl_DatosForm.Lv_Identificacion , Lv_DescRoles ,Lv_CodEmpresa ,Lv_Estados ); 
           FETCH C_GetClienteIdent INTO Pcl_ClienteCancelado; 
           dbms_output.put_line('Cliente Cancelado IdPersona =>'||  Pcl_ClienteCancelado.Ln_IdPersona );    
           CLOSE C_GetClienteIdent;   
          
           IF (Pcl_ClienteGlobal.Ln_IdPersona IS NOT NULL ) THEN 
            Pcl_DatosForm.Ln_Id := Pcl_ClienteGlobal.Ln_IdPersona; 
          dbms_output.put_line('Data INACTIVO : IdPersona->'||Pcl_ClienteGlobal.Ln_IdPersona||', IdPersonaRol->'|| Pcl_ClienteGlobal.Ln_IdPersonaRol||', IdEmpresaRol-> '|| Pcl_ClienteGlobal.Ln_IdEmpresaRol||', IdRol-> '|| Pcl_ClienteGlobal.Ln_IdRol||', IdTipoRol-> '|| Pcl_ClienteGlobal.Ln_IdTipoRol); 
       
           END IF;    
        
           IF (Pcl_ClienteCancelado.Ln_IdPersona  IS NOT NULL )  THEN 
             Pcl_ClienteGlobal := Pcl_ClienteCancelado; 
             Pcl_DatosForm.Ln_Id := Pcl_ClienteGlobal.Ln_IdPersona; 
            dbms_output.put_line('Data CANCELADO : IdPersona->'||Pcl_ClienteGlobal.Ln_IdPersona||', IdPersonaRol->'|| Pcl_ClienteGlobal.Ln_IdPersonaRol||', IdEmpresaRol-> '|| Pcl_ClienteGlobal.Ln_IdEmpresaRol||', IdRol-> '|| Pcl_ClienteGlobal.Ln_IdRol||', IdTipoRol-> '|| Pcl_ClienteGlobal.Ln_IdTipoRol); 
            
           END IF;    
        
           IF (Pcl_DatosForm.Ln_Id IS NOT NULL ) THEN 
              Lv_ExistePreCliente := 'S';  
               --GENERO REGISTRO EN EL HISTORIAL DEL PRE-CLIENTE EN ESTADO CANCELADO                        
              FOR i IN C_GetPersEmpRolHisto(Pcl_DatosForm.Lv_Identificacion,Lv_DescRoles,Lv_CodEmpresa, Lv_Estados)
              LOOP
                   --SI EXISTE HISTORIAL DEL CLIENTE CANCELADO, CLONO Y CREO REGISTRO DE HISTORIAL PARA PRE-CLIENTE CANCELADO EN BASE AL ULTIMO HISTORIAL DEL CLIENTE
                       Pcl_InfoPersonaEmpresaRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO  :=  SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
                       Pcl_InfoPersonaEmpresaRolHisto.USR_CREACION :=  i.USR_CREACION ;
                       Pcl_InfoPersonaEmpresaRolHisto.FE_CREACION  :=  i.FE_CREACION ;
                       Pcl_InfoPersonaEmpresaRolHisto.IP_CREACION  :=  i.IP_CREACION; 
                       Pcl_InfoPersonaEmpresaRolHisto.ESTADO       :=  i.ESTADO;
                       Pcl_InfoPersonaEmpresaRolHisto.PERSONA_EMPRESA_ROL_ID :=   Pcl_ClienteGlobal.Ln_IdPersonaRol; 
                       Pcl_InfoPersonaEmpresaRolHisto.OBSERVACION     := i.OBSERVACION;
                       Pcl_InfoPersonaEmpresaRolHisto.MOTIVO_ID       := i.MOTIVO_ID;
                       Pcl_InfoPersonaEmpresaRolHisto.EMPRESA_ROL_ID  := i.EMPRESA_ROL_ID ;
                       Pcl_InfoPersonaEmpresaRolHisto.OFICINA_ID      := i.OFICINA_ID ;
                       Pcl_InfoPersonaEmpresaRolHisto.DEPARTAMENTO_ID := i.DEPARTAMENTO_ID ;
                       Pcl_InfoPersonaEmpresaRolHisto.CUADRILLA_ID    := i.CUADRILLA_ID ; 
                       Pcl_InfoPersonaEmpresaRolHisto.REPORTA_PERSONA_EMPRESA_ROL_ID := i.REPORTA_PERSONA_EMPRESA_ROL_ID; 
                       Pcl_InfoPersonaEmpresaRolHisto.ES_PREPAGO      := i.ES_PREPAGO;
                       INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES  Pcl_InfoPersonaEmpresaRolHisto;
                       dbms_output.put_line('Ultimo Historial clonado he insertado PERSONA_EMPRESA_ROL_ID =>'||Pcl_ClienteGlobal.Ln_IdPersonaRol); 
                       COMMIT;
              END LOOP;    
               --CANCELO LA FORMA DE PAGO DEL PRE-CLIENTE 
              UPDATE  DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO  perfPago
              SET perfPago.ESTADO = 'Cancelado'     
              where perfPago.PERSONA_EMPRESA_ROL_ID  = Pcl_ClienteGlobal.Ln_IdPersonaRol; 
              dbms_output.put_line('Formas de pago de Pre-cliente canceladas'); 
              COMMIT;
           END IF;               
      
           OPEN C_GetPersona(Pcl_DatosForm.Ln_Id); 
           FETCH C_GetPersona INTO  Pcl_InfoPersona;  
           CLOSE C_GetPersona;   
          
           IF (Pcl_InfoPersona.ID_PERSONA IS NULL)  THEN 
               Pcl_DatosForm.Lv_YaExiste := 'N';
               Pcl_InfoPersona.ID_PERSONA:= DB_COMERCIAL.SEQ_INFO_PERSONA.NEXTVAL ;       
               dbms_output.put_line('SE INSERTARA DATA DE ID_PERSONA =>'||Pcl_InfoPersona.ID_PERSONA);
           ELSE
               Pcl_DatosForm.Lv_YaExiste := 'S';
               dbms_output.put_line('SE ACTUALIZARA DATA DE ID_PERSONA =>'||Pcl_InfoPersona.ID_PERSONA);  
           END IF; 
      
           Pcl_InfoPersona.IDENTIFICACION_CLIENTE  := Pcl_DatosForm.Lv_Identificacion;
           Pcl_InfoPersona.TIPO_EMPRESA            := Pcl_DatosForm.Lv_TipoEmpresa;
           Pcl_InfoPersona.TIPO_TRIBUTARIO         := Pcl_DatosForm.Lv_TipoTributario;
           Pcl_InfoPersona.RAZON_SOCIAL            :=  Pcl_DatosForm.Lv_RazonSocial;
           Pcl_InfoPersona.REPRESENTANTE_LEGAL     :=  Pcl_DatosForm.Lv_RepresentanteLegal;
           Pcl_InfoPersona.NACIONALIDAD            := Pcl_DatosForm.Lv_Nacionalidad; 
           Pcl_InfoPersona.DIRECCION_TRIBUTARIA    := Pcl_DatosForm.Lv_DireccionTributaria ; 
           Pcl_InfoPersona.DIRECCION               := Pcl_DatosForm.Lv_DireccionTributaria ;
                 
           IF Lv_PrefijoEmpresa = 'TN' THEN
               Pcl_InfoPersona.CONTRIBUYENTE_ESPECIAL:=  Pcl_DatosForm.Lv_ContribuyenteEspecial ;
               Pcl_InfoPersona.PAGA_IVA:= Pcl_DatosForm.Lv_PagaIva ;
               Pcl_InfoPersona.NUMERO_CONADIS:= Pcl_DatosForm.Lv_NumeroConadis ;
           ELSE
               Pcl_InfoPersona.PAGA_IVA:= 'S' ; 
           END IF;
       
           IF (Pcl_DatosForm.Lv_FechaNacimiento.year IS NOT NULL)
           AND (Pcl_DatosForm.Lv_FechaNacimiento.month IS NOT NULL)
           AND (Pcl_DatosForm.Lv_FechaNacimiento.day IS NOT NULL)      
           THEN 
               --LA VALIDACION DE EDAD DE NACIMIENTO ESTA EN MS
               Pcl_InfoPersona.FECHA_NACIMIENTO:=  TO_DATE( Pcl_DatosForm.Lv_FechaNacimiento.year||'-' ||Pcl_DatosForm.Lv_FechaNacimiento.month||'-'|| Pcl_DatosForm.Lv_FechaNacimiento.day,'YYYY-MM-DD');
           END IF;
   
           Pcl_InfoPersona.NOMBRES:= Pcl_DatosForm.Lv_Nombres;
           Pcl_InfoPersona.APELLIDOS:= Pcl_DatosForm.Lv_Apellidos; 
           
           IF Pcl_DatosForm.Ln_IdTitulo IS NOT NULL THEN 
              Pcl_InfoPersona.TITULO_ID :=  Pcl_DatosForm.Ln_IdTitulo;
           END IF;    
  
          Pcl_InfoPersona.GENERO:= Pcl_DatosForm.Lv_Genero; 
          Pcl_InfoPersona.ESTADO_CIVIL:= SUBSTR(Pcl_DatosForm.Lv_EstadoCivil,1,1) ; 
          Pcl_InfoPersona.ORIGEN_INGRESOS:= Pcl_DatosForm.Lv_OrigenIngresos; 
          Pcl_InfoPersona.ORIGEN_PROSPECTO:= 'N'; 
       
          IF ((Pcl_DatosForm.Lv_OrigenWeb= 'S') OR (Pcl_DatosForm.Lv_OrigenWeb= 'N')OR (Pcl_DatosForm.Lv_OrigenWeb= 'M'))  THEN
              Pcl_InfoPersona.ORIGEN_WEB := Pcl_DatosForm.Lv_OrigenWeb;
          END IF;     

          Pcl_InfoPersona.ESTADO:= 'Pendiente';    
          Pcl_InfoPersona.PAIS_ID:= Pcl_DatosForm.Ln_IdPais;  

 
          IF (Pcl_DatosForm.Lv_YaExiste = 'N')  THEN
               --LA VALIDACION DE TIPO IDENTIFICACION ESTA EN MS         
               Pcl_InfoPersona.FE_CREACION:= SYSDATE;
               Pcl_InfoPersona.USR_CREACION := Lv_UsrCreacion; 
               Pcl_InfoPersona.IP_CREACION:= Lv_ClientIp ;
               Pcl_InfoPersona.TIPO_IDENTIFICACION:= Pcl_DatosForm.Lv_TipoIdentificacion; 
               INSERT  INTO DB_COMERCIAL.INFO_PERSONA VALUES Pcl_InfoPersona;  
               dbms_output.put_line('PERSONA INSERTADA ID_PERSONA=>'||Pcl_InfoPersona.ID_PERSONA);
          ELSE  
               UPDATE DB_COMERCIAL.INFO_PERSONA ip SET 
               ip.TITULO_ID               = Pcl_InfoPersona.TITULO_ID,
               ip.ORIGEN_PROSPECTO        = Pcl_InfoPersona.ORIGEN_PROSPECTO, 
               ip.TIPO_EMPRESA            = Pcl_InfoPersona.TIPO_EMPRESA,
               ip.TIPO_TRIBUTARIO         = Pcl_InfoPersona.TIPO_TRIBUTARIO,
               ip.NOMBRES                 = Pcl_InfoPersona.NOMBRES,      
               ip.APELLIDOS               = Pcl_InfoPersona.APELLIDOS ,  
               ip.RAZON_SOCIAL            = Pcl_InfoPersona.RAZON_SOCIAL,
               ip.REPRESENTANTE_LEGAL     = Pcl_InfoPersona.REPRESENTANTE_LEGAL,
               ip.NACIONALIDAD            = Pcl_InfoPersona.NACIONALIDAD,
               ip.DIRECCION               = Pcl_InfoPersona.DIRECCION,
               ip.LOGIN                   = Pcl_InfoPersona.LOGIN,
               ip.CARGO                   = Pcl_InfoPersona.CARGO,
               ip.DIRECCION_TRIBUTARIA    = Pcl_InfoPersona.DIRECCION_TRIBUTARIA,
               ip.GENERO                  = Pcl_InfoPersona.GENERO,
               ip.ESTADO                  = Pcl_InfoPersona.ESTADO,   
               ip.FE_CREACION             = Pcl_InfoPersona.FE_CREACION,        
               ip.USR_CREACION            = Pcl_InfoPersona.USR_CREACION,
               ip.IP_CREACION             = Pcl_InfoPersona.IP_CREACION,
               ip.ESTADO_CIVIL            = Pcl_InfoPersona.ESTADO_CIVIL,
               ip.FECHA_NACIMIENTO        = Pcl_InfoPersona.FECHA_NACIMIENTO,   
               ip.CALIFICACION_CREDITICIA = Pcl_InfoPersona.CALIFICACION_CREDITICIA,
               ip.ORIGEN_INGRESOS         = Pcl_InfoPersona.ORIGEN_INGRESOS,
               ip.ORIGEN_WEB              = Pcl_InfoPersona.ORIGEN_WEB,
               ip.CONTRIBUYENTE_ESPECIAL  = Pcl_InfoPersona.CONTRIBUYENTE_ESPECIAL,
               ip.PAGA_IVA                = Pcl_InfoPersona.PAGA_IVA,
               ip.NUMERO_CONADIS          = Pcl_InfoPersona.NUMERO_CONADIS,
               ip.PAIS_ID                 = Pcl_InfoPersona.PAIS_ID       
               WHERE ip.ID_PERSONA = Pcl_InfoPersona.ID_PERSONA ;  
               dbms_output.put_line('PERSONA ACTUALIZADA ID_PERSONA=>'||Pcl_InfoPersona.ID_PERSONA);
          END IF;
        
       
         COMMIT;
         --ASIGNA ROL DE PRE-CLIENTE A LA PERSONA
           IF  Lv_ExistePreCliente  ='S' THEN     
               OPEN C_GetPersonaEmpresaRol(Pcl_ClienteGlobal.Ln_IdPersonaRol); 
               FETCH C_GetPersonaEmpresaRol INTO  Pcl_InfoPersonaEmpresaRol;  
               CLOSE C_GetPersonaEmpresaRol;   
           END IF;   
  
          Pcl_InfoPersonaEmpresaRol.PERSONA_ID := Pcl_InfoPersona.ID_PERSONA;   
          
           OPEN  C_GetTipoRolPorEmpresa('Pre-cliente', Lv_CodEmpresa ); 
           FETCH C_GetTipoRolPorEmpresa INTO  Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID;  
           CLOSE C_GetTipoRolPorEmpresa ; 
           dbms_output.put_line('EMPRESA_ROL_ID =>'||Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID);
   
           IF Lv_PrefijoEmpresa = 'TN' THEN    
                IF Pcl_DatosForm.Lv_IdOficinaFacturacion IS NOT NULL THEN 
                    Pcl_InfoPersonaEmpresaRol.OFICINA_ID := Pcl_DatosForm.Lv_IdOficinaFacturacion; 
                END IF;
                Pcl_InfoPersonaEmpresaRol.ES_PREPAGO := Pcl_DatosForm.Lv_EsPrepago; 
           ELSE  
                IF Ln_OficinaId IS NOT NULL THEN 
                    Pcl_InfoPersonaEmpresaRol.OFICINA_ID := Ln_OficinaId ; 
                END IF;
                Pcl_InfoPersonaEmpresaRol.ES_PREPAGO := 'S';
                      
            END IF;
  

           Pcl_InfoPersonaEmpresaRol.FE_CREACION  := SYSDATE;
           Pcl_InfoPersonaEmpresaRol.USR_CREACION := Lv_UsrCreacion; 
           Pcl_InfoPersonaEmpresaRol.FE_ULT_MOD   := SYSDATE;
           Pcl_InfoPersonaEmpresaRol.USR_ULT_MOD  := Lv_UsrCreacion;
           Pcl_InfoPersonaEmpresaRol.ESTADO       :='Pendiente' ; 
      
           IF Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL IS NULL THEN 
               Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL ;
               INSERT  INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL VALUES   Pcl_InfoPersonaEmpresaRol;  
               dbms_output.put_line('PERSONA_EMPRESA_ROL ACTUALIZADO ID_PERSONA_ROL=>'||Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL);
           ELSE 
               UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper SET 
               iper.ID_PERSONA_ROL       = Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL, 
               iper.PERSONA_ID           = Pcl_InfoPersonaEmpresaRol.PERSONA_ID,
               iper.EMPRESA_ROL_ID       = Pcl_InfoPersonaEmpresaRol.EMPRESA_ROL_ID,
               iper.OFICINA_ID           = Pcl_InfoPersonaEmpresaRol.OFICINA_ID,
               iper.DEPARTAMENTO_ID      = Pcl_InfoPersonaEmpresaRol.DEPARTAMENTO_ID, 
               iper.ESTADO               = Pcl_InfoPersonaEmpresaRol.ESTADO , 
               iper.ES_PREPAGO           = Pcl_InfoPersonaEmpresaRol.ES_PREPAGO, 
               iper.USR_ULT_MOD          = Pcl_InfoPersonaEmpresaRol.USR_ULT_MOD,
               iper.FE_ULT_MOD           = Pcl_InfoPersonaEmpresaRol.FE_ULT_MOD ,
               iper.IP_CREACION          = Pcl_InfoPersonaEmpresaRol.IP_CREACION,
               
               iper.CUADRILLA_ID                   = Pcl_InfoPersonaEmpresaRol.CUADRILLA_ID,
               iper.PERSONA_EMPRESA_ROL_ID         = Pcl_InfoPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID,
               iper.PERSONA_EMPRESA_ROL_ID_TTCO    = Pcl_InfoPersonaEmpresaRol.PERSONA_EMPRESA_ROL_ID_TTCO,
               iper.REPORTA_PERSONA_EMPRESA_ROL_ID = Pcl_InfoPersonaEmpresaRol.REPORTA_PERSONA_EMPRESA_ROL_ID
                     
               WHERE iper.ID_PERSONA_ROL = Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL;
               dbms_output.put_line('PERSONA_EMPRESA_ROL ACTUALIZADO ID_PERSONA_ROL=>'||Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL);                    
           END IF; 
       
           COMMIT;
       
            IF Lv_PrefijoEmpresa <>'TN' THEN  

              --SE BUSCA SI EL PRECLIENTE TIENE UN CICLO ASIGNADO ANTERIORMENTE YA SEA POR RECONTRATACIÓN O INCONSISTENCIA DE MIGRACIÓN.
               FOR i IN C_GetListPersEmpRolCarac(Pcl_AdmiCaracteristica.ID_CARACTERISTICA , Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL)
                   LOOP
                   --SE ACTUALIZA EL ESTADO DEL REGISTRO  
                       UPDATE  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc SET 
                       iperc.ESTADO ='Inactivo',
                       iperc.FE_ULT_MOD=SYSDATE,
                       iperc.USR_ULT_MOD =Lv_UsrCreacion
                       WHERE iperc.ID_PERSONA_EMPRESA_ROL_CARACT = i.ID_PERSONA_EMPRESA_ROL_CARACT; 
                       dbms_output.put_line( 'Caracteristica Inactivada ID_PERSONA_EMPRESA_ROL_CARACT=>'|| i.ID_PERSONA_EMPRESA_ROL_CARACT);  
                      --SE CREA EL HISTORIAL POR CAMBIO DE ESTADO EN CARACTERISTICA DEL CICLO.
                       INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO (
                       ID_PERSONA_EMPRESA_ROL_HISTO,
                       USR_CREACION ,
                       FE_CREACION ,
                       IP_CREACION ,
                       ESTADO ,
                       PERSONA_EMPRESA_ROL_ID,
                       OBSERVACION   
                       ) VALUES(                   
                       DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL ,
                       Lv_UsrCreacion ,
                       SYSDATE,
                       Lv_ClientIp ,
                       'Inactivo',
                       Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                       'Se inactiva el ciclo anteriormente asignado'
                       ); 
                       dbms_output.put_line( 'Historial registrado');                
                       COMMIT;
                END LOOP;     
                   
                   --INSERTO CARACTERISTICA DE CICLO_FACTURACION EN EL PRE_CLIENTE           
                       INSERT INTO  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC(
                       ID_PERSONA_EMPRESA_ROL_CARACT,
                       PERSONA_EMPRESA_ROL_ID,
                       CARACTERISTICA_ID,
                       VALOR,
                       FE_CREACION, 
                       USR_CREACION, 
                       IP_CREACION,
                       ESTADO)
                       VALUES (
                       DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL , 
                       Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                       Pcl_AdmiCaracteristica.ID_CARACTERISTICA ,
                       Pcl_AdmiCiclo.ID_CICLO,
                       SYSDATE, 
                       Lv_UsrCreacion,
                       Lv_ClientIp,                    
                       'Activo');  
                       dbms_output.put_line( 'Caracteristica de ciclo registrada');  
                       COMMIT;
                   --INSERTO HISTORIAL DE CREACION DE CARACTERISTICA DE CICLO_FACTURACION EN EL PRE_CLIENTE 
                       INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO (
                       ID_PERSONA_EMPRESA_ROL_HISTO,
                       USR_CREACION ,
                       FE_CREACION ,
                       IP_CREACION ,
                       ESTADO ,
                       PERSONA_EMPRESA_ROL_ID,
                       OBSERVACION   
                       ) VALUES(                   
                       DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
                       Lv_UsrCreacion ,
                       SYSDATE,
                       Lv_ClientIp ,
                       Pcl_InfoPersona.ESTADO,
                       Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                       'Se creo Pre-cliente con Ciclo de Facturación:'||Pcl_AdmiCiclo.NOMBRE_CICLO
                       ); 
                       dbms_output.put_line( 'Historial registrado');  
                       COMMIT;  
         
            END IF;   

       
            IF Lv_PrefijoEmpresa = 'MD' THEN  
                --INSERTAR FORMA DE PAGO
                Pcl_InfoPersonaEmpFormaPago.ID_DATOS_PAGO:=            DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_FORMA_PAG.NEXTVAL; 
                Pcl_InfoPersonaEmpFormaPago.PERSONA_EMPRESA_ROL_ID:=   Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL;         
                Pcl_InfoPersonaEmpFormaPago.FORMA_PAGO_ID:=            Pcl_DatosForm.Ln_IdFormaPago;                        
                Pcl_InfoPersonaEmpFormaPago.TIPO_CUENTA_ID:=           Pcl_DatosForm.Ln_IdTipoCuenta;
                Pcl_InfoPersonaEmpFormaPago.BANCO_TIPO_CUENTA_ID:=     Pcl_DatosForm.Ln_IdBancoTipoCuenta ; 
                Pcl_InfoPersonaEmpFormaPago.ESTADO:=                   'Activo';
                Pcl_InfoPersonaEmpFormaPago.FE_CREACION:=               SYSDATE; 
                Pcl_InfoPersonaEmpFormaPago.USR_CREACION:=              Lv_UsrCreacion; 
                Pcl_InfoPersonaEmpFormaPago.IP_CREACION:=               Lv_ClientIp ;   
                INSERT  INTO DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO VALUES Pcl_InfoPersonaEmpFormaPago; 
                dbms_output.put_line( 'FORMA DE PAGO INSERTADA ID_DATOS_PAGO =>'||  Pcl_InfoPersonaEmpFormaPago.ID_DATOS_PAGO );                    
                COMMIT;
            END IF;


            IF Pcl_DatosForm.Ln_IdPerReferido IS NOT NULL THEN 
                --GRABA RELACION ENTRE REFERIDO Y PRE-CLIENTE
                Pcl_InfoPersonaReferido.ID_PERSONA_REFERIDO:=           DB_COMERCIAL.SEQ_INFO_PERSONA_REFERIDO.NEXTVAL; 
                Pcl_InfoPersonaReferido.REFERIDO_ID:=                   Pcl_DatosForm.Ln_IdReferido;             
                Pcl_InfoPersonaReferido.REF_PERSONA_EMPRESA_ROL_ID:=    Pcl_DatosForm.Ln_IdPerReferido ; 
                Pcl_InfoPersonaReferido.PERSONA_EMPRESA_ROL_ID:=        Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL;
                Pcl_InfoPersonaReferido.ESTADO:=                       'Activo';
                Pcl_InfoPersonaReferido.FE_CREACION:=                   SYSDATE; 
                Pcl_InfoPersonaReferido.USR_CREACION:=                  Lv_UsrCreacion; 
                Pcl_InfoPersonaReferido.IP_CREACION:=                   Lv_ClientIp ;   
                INSERT  INTO DB_COMERCIAL.INFO_PERSONA_REFERIDO VALUES  Pcl_InfoPersonaReferido; 
                dbms_output.put_line( 'PERSONA REFERIDO INSERTADA ID_PERSONA_REFERIDO =>'||  Pcl_InfoPersonaReferido.ID_PERSONA_REFERIDO);                    
                COMMIT;
            END IF;

                --REGISTRA EN LA TABLA DE PERSONA_EMPRESA_ROL_HISTO
                Pcl_InfoPersonaEmpresaRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO:=     DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;  
                Pcl_InfoPersonaEmpresaRolHisto.PERSONA_EMPRESA_ROL_ID:=           Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL;
                Pcl_InfoPersonaEmpresaRolHisto.OBSERVACION:=                      '' ;  
                Pcl_InfoPersonaEmpresaRolHisto.ESTADO:=                           Pcl_InfoPersona.ESTADO;   
                Pcl_InfoPersonaEmpresaRolHisto.USR_CREACION:=                     Lv_UsrCreacion;
                Pcl_InfoPersonaEmpresaRolHisto.FE_CREACION:=                      SYSDATE;         
                Pcl_InfoPersonaEmpresaRolHisto.IP_CREACION:=                      Lv_ClientIp ;
                INSERT  INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES  Pcl_InfoPersonaEmpresaRolHisto; 
                dbms_output.put_line( 'PERSONA EMPRES ROL HISTORIAL  INSERTADA ID_PERSONA_EMPRESA_ROL_HISTO =>'|| Pcl_InfoPersonaEmpresaRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO);                    
                COMMIT;
                --SE ENVIA ARRAY DE PARAMETROS Y SE AGREGA STROPCIONPERMITIDA Y STRPREFIJOEMPRESA, PREFIJO DE EMPRESA EN SESION PARA VALIDAR
                --QUE PARA EMPRESA MD NO SE OBLIGUE EL INGRESO DE AL MENOS 1 CORREO 
                dbms_output.put_line( '******VALIDAR  LAS FORMAS DE PAGO AQUI SE DEJA VALIDACION EN BACKEND ANTES DEL CONSUMO DEL PKS**************');


            IF (Pcl_DatosForm.Lv_YaExiste = 'S')  THEN
                --PONE ESTADO INACTIVO A TODOS LAS FORMAS DE CONTACTO DE LA PERSONA QUE tengan estado ACTIVO          
                UPDATE DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc  SET
                        ipfc.ESTADO      = 'Inactivo', 
                        ipfc.FE_ULT_MOD  = SYSDATE ,
                        ipfc.USR_ULT_MOD = Lv_UsrCreacion
                WHERE ipfc.ESTADO =  'Activo'
                AND ipfc.VALOR IS  NOT NULL  
                AND ipfc.PERSONA_ID  = Pcl_InfoPersona.ID_PERSONA; 
                dbms_output.put_line( 'LAS FORMAS DE CONTACTOS Activas  SE HAN Inactivados');    
                COMMIT;
            END IF;

            --REGISTRA LAS FORMAS DE CONTACTO DEL PRE-CLIENTE


            FOR i IN 1 .. Ln_CountFormasContacto
                LOOP        
                Pcl_InfoPersonaFormaContacto := NULL; 
                OPEN  C_GetFormaPago(apex_json.get_varchar2 ('arrayFormasContacto[%d].idFormaContacto', i), apex_json.get_varchar2 ('arrayFormasContacto[%d].formaContacto', i) );
                FETCH C_GetFormaPago INTO  Pcl_InfoPersonaFormaContacto.FORMA_CONTACTO_ID;  
                CLOSE C_GetFormaPago ;  

                IF  Pcl_InfoPersonaFormaContacto.FORMA_CONTACTO_ID IS NULL THEN
                    Pv_Mensaje := 'No se ha encontro forma de contacto.';
                    dbms_output.put_line( Pv_Mensaje );  
                    RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);     
                END IF ; 

                Lv_DataTemp :=  apex_json.get_varchar2 ('arrayFormasContacto[%d].valor', i);   
                Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO:= DB_COMERCIAL.SEQ_INFO_PERSONA_FORMA_CONT.NEXTVAL;  
                Pcl_InfoPersonaFormaContacto.PERSONA_ID:= Pcl_InfoPersona.ID_PERSONA;   
                Pcl_InfoPersonaFormaContacto.VALOR:= Lv_DataTemp ;                 
                Pcl_InfoPersonaFormaContacto.ESTADO:= 'Activo' ;   
                Pcl_InfoPersonaFormaContacto.FE_CREACION:= SYSDATE;     
                Pcl_InfoPersonaFormaContacto.USR_CREACION:=  Lv_UsrCreacion; 
                Pcl_InfoPersonaFormaContacto.IP_CREACION:=  Lv_ClientIp ;
                INSERT  INTO DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO VALUES Pcl_InfoPersonaFormaContacto; 
                dbms_output.put_line( 'PERSONA FORMA CONTACTO INSERTADA ID_PERSONA_FORMA_CONTACTO  =>'||Pcl_InfoPersonaFormaContacto.ID_PERSONA_FORMA_CONTACTO);                    
                COMMIT;
                END LOOP;

            --SE GENERA LA IPERCARACTERISTICA LOGIN PARA LA AUTENTICACION DEL USUARIO EN EXTRANET Y MOBILE NETLIFE
            --NUEVO CAMBIO POR JUAN LAFUENTE 


                P_SET_CARACTERISTICAS(
                'USUARIO',
                Pcl_DatosForm.Lv_Identificacion ,
                Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,    
                Lv_UsrCreacion,
                Lv_ClientIp 
                ); 

            --AGREGAMOS CARACTERISTICAHOLDING PARA CLIENTES TN 
            IF Pcl_DatosForm.Lv_Holding IS NOT NULL AND Lv_PrefijoEmpresa = 'TN'  THEN    
                P_SET_CARACTERISTICAS(
                'HOLDING EMPRESARIAL',
                Pcl_DatosForm.Lv_Holding,
                Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                Lv_UsrCreacion,
                Lv_ClientIp 
                ); 
            END IF ;

            --AGREGAMOS CARACTERISTICA DISTRIBUIDOR PARA CLIENTES TN 
            IF Pcl_DatosForm.Lv_EsDistribuidor IS NOT NULL AND Lv_PrefijoEmpresa = 'TN'  THEN    
                P_SET_CARACTERISTICAS(
                'ES_DISTRIBUIDOR',
                Pcl_DatosForm.Lv_EsDistribuidor,
                Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                Lv_UsrCreacion,
                Lv_ClientIp 
                );   
            END IF ;

            --RECOMENDACION DE TARJETA MD
            IF Lv_Recomendacion  IS NOT NULL AND Lv_PrefijoEmpresa = 'MD'  THEN    
                P_SET_CARACTERISTICAS(
                'EQUIFAX_RECOMENDACION', 
                Lv_Recomendacion ,
                Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL,
                Lv_UsrCreacion,
                Lv_ClientIp 
                );   
            END IF ;  

          
      END IF;
      
   END IF;


   
   OPEN Pcl_Response FOR  
   SELECT  
   Pcl_InfoPersona.ID_PERSONA AS idPersona,
   Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL AS  idPersonaEmpresaRol
   FROM DUAL; 

   Pv_Mensaje   := 'Proceso realizado con exito';
   Pv_Status    := 'OK';
   dbms_output.put_line(Pv_Mensaje );  
   EXCEPTION
       WHEN OTHERS THEN
       ROLLBACK;
       Pv_Status     := 'ERROR'; 
       Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
       'PRE CLIENTE',
       'DB_COMERCIAL.CMKG_PRECLIENTE_TRANSACCION.P_CREAR_PRECLIENTE',
       'Error: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
       'telcos',
       SYSDATE,
       '127.0.0.1');
               
     IF  Lv_Revertir = 'S'  THEN 
     
          IF  Pcl_InfoPersona.ID_PERSONA  IS NOT NULL  THEN  
               UPDATE DB_COMERCIAL.INFO_PERSONA  
               SET  IDENTIFICACION_CLIENTE = NULL , ESTADO = 'Eliminado'
               WHERE IDENTIFICACION_CLIENTE  =  Pcl_DatosForm.Lv_Identificacion AND ESTADO = 'Pendiente'; 
               COMMIT; 
           END IF; 

           IF  Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL IS NOT NULL  THEN    
                    --REGISTRA EN LA TABLA DE PERSONA_EMPRESA_ROL_HISTO
                    Pcl_InfoPersonaEmpresaRolHisto.ID_PERSONA_EMPRESA_ROL_HISTO:=     DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;  
                    Pcl_InfoPersonaEmpresaRolHisto.PERSONA_EMPRESA_ROL_ID:=           Pcl_InfoPersonaEmpresaRol.ID_PERSONA_ROL ;
                    Pcl_InfoPersonaEmpresaRolHisto.OBSERVACION:=                      'registro eliminado por fallo en transaccion' ;  
                    Pcl_InfoPersonaEmpresaRolHisto.ESTADO:=                           'Eliminado';   
                    Pcl_InfoPersonaEmpresaRolHisto.USR_CREACION:=                     Lv_UsrCreacion;
                    Pcl_InfoPersonaEmpresaRolHisto.FE_CREACION:=                      SYSDATE;         
                    Pcl_InfoPersonaEmpresaRolHisto.IP_CREACION:=                      Lv_ClientIp ;
                    INSERT  INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO VALUES  Pcl_InfoPersonaEmpresaRolHisto; 
                    COMMIT; 
            END IF;  
         
     dbms_output.put_line( 'SE REALIZO EL REVERSO');       
     END IF;

END P_CREAR_PRECLIENTE;   
END CMKG_PRECLIENTE_TRANSACCION; 
 
/
 