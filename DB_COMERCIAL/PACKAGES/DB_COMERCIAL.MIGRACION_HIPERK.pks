CREATE OR REPLACE PACKAGE DB_COMERCIAL.MIGRACION_HIPERK AS 

procedure migraComercialHiperk(cod_ret out number, msg_ret  out varchar2) ;
procedure migraClientesPersonales(cod_ret  out number, msg_ret  out varchar2) ;
function devuelveNumeracion(p_id_oficina number,p_codigo VARCHAR2) return VARCHAR2;
function devuelveLogin(p_cod_empresa VARCHAR2,p_id_canton NUMBER, p_id_tipo_negocio NUMBER, p_login_ini VARCHAR2) return VARCHAR2;   

l_cod_empresa varchar2(2) := '18';--MD
l_id_tipo_negocio NUMBER := 22;--HOME
l_tipo_ubicacion NUMBER := 5;--Barrio
l_vendedor VARCHAR2(20) := 'vendedor_hk';-- se migra con usr vendedor-hk para luego hacer la asignacion del vendedor correspondiente
END MIGRACION_HIPERK;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.MIGRACION_HIPERK AS

procedure migraComercialHiperk(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'MIGRACION_HIPERK.migraComercialHiperk';
    --
  begin
    
   /****************************************************************
   * Migracion Clientes personales del Hiperk al telcos de Megadatos
   *****************************************************************/
    -- 
   migraClientesPersonales(cod_ret, msg_ret);
    if(cod_ret!=0)then
       raise errorProcedure;
    end if;
    --
    cod_ret := 0;
    commit;
  exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
      rollback;
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
      rollback;
  end;
  
  
/****************************************************************
 * Migracion de persona Empresa Rol Clientes, Pre-Clientes
 *****************************************************************/      
procedure migraClientesPersonales(cod_ret out number, msg_ret out varchar2) is
 errorProcedure exception;
 nameProcedure varchar2(60) := 'MIGRACION_HIPERK.migraClientesPersonales';    
    /*********************************************************************************************************************************
    * Cursor que lee vista del HK para migrar clientes Personales en Telcos empresa MD en base al campo Tipo de Contrato del HK 
    * se considera solo los tipos "PE" como Personales
    */
    cursor lc_ClientesPersonalesHK is 
    select * from HIPERK.kfpsivmigrar where TIPCONT IN ('BA','PE')
    and ESTADO_CLIENTE in ('Activo','Suspendido');
  
    --Cursor para obtener Puntos Login a migrarse del Hiperk considerando solo los clientes con tipo de contrato "PE" como Personales
     cursor lc_ObtenerPuntosHK(c_id_cliente VARCHAR2) is 
      select suc.* from HIPERK.kfpsivmigrar_suc suc
      join HIPERK.kfpsivmigrar cli on suc.ID_CLIENTE=cli.ID_CLIENTE
      where TIPCONT IN ('BA','PE')
      and suc.ID_CLIENTE=c_id_cliente
      and cli.ESTADO_CLIENTE in ('Activo','Suspendido');
    
    lr_ObtenerPuntosHK lc_ObtenerPuntosHK%ROWTYPE;
    
    --Cursor para obtener el contrato del cliente del Hiperk considerando solo los clientes con tipo de contrato "PE" como Personales
     cursor lc_ObtenerContratoHiperk(c_id_cliente VARCHAR2) is      
     select cont.* from HIPERK.kfpsivmigrar_fp cont
      join HIPERK.kfpsivmigrar cli on cont.ID_CLIENTE=cli.ID_CLIENTE
      where TIPCONT IN ('BA','PE')
      and cli.ID_CLIENTE=c_id_cliente
      and cli.ESTADO_CLIENTE in ('Activo','Suspendido');
      
     lr_ObtenerContratoHiperk lc_ObtenerContratoHiperk%ROWTYPE;
   
   --Cursor para obtener contactos del Hiperk considerando solo los clientes con tipo de contrato "PE" como Personales
     cursor lc_ObtenerContactosHiperk(c_id_cliente VARCHAR2) is
      select contact.* from HIPERK.kfpsivmigrar_contac contact
      join HIPERK.kfpsivmigrar cli on contact.ID_CLIENTE=cli.ID_CLIENTE
      where TIPCONT IN ('BA','PE')
      and cli.ID_CLIENTE=c_id_cliente
      and cli.ESTADO_CLIENTE in ('Activo','Suspendido');
      
   --Cursor para obtener los servicios del Hiperk a migrar considerando solo los clientes con tipo de contrato "PE" como Personales
   cursor lc_ObtenerServiciosHiperk(c_id_cliente VARCHAR2) is
   /* SELECT serv.* FROM HIPERK.kfpsivmigrar_tarper serv
      join HIPERK.kfpsivmigrar cli on serv.ID_CLIENTE=cli.ID_CLIENTE
    where TIPCONT IN ('BA','PE')
    and cli.ID_CLIENTE=c_id_cliente
    and cli.ESTADO_CLIENTE in ('Activo','Suspendido');*/
      SELECT serv.*,
       prod.CODTIPPLA,P.DESTIPPLA,prod.CODPLATAR, prod.DESPLATAR
       FROM
       Hiperk.kfpsittarpla prod, Hiperk.kfpsittiptarpla p, HIPERK.kfpsivmigrar_tarper serv
       join HIPERK.kfpsivmigrar cli on serv.ID_CLIENTE=cli.ID_CLIENTE
    where cli.TIPCONT IN ('BA','PE') and cli.ESTADO_CLIENTE in ('Activo','Suspendido')
          and  prod.codplatar=serv.ID_PRODUCTO
          and prod.codemp in (70)
          and prod.codemp = p.codemp
          and prod.codtippla = p.codtippla 
          and cli.ID_CLIENTE=c_id_cliente
    ORDER BY CLI.ID_CLIENTE ASC;     
          
  /* **********************************************************************************************************************
   * CURSOR SOLO CLIENTES QUE TIENEN CONTRATO EN HIPERK PERO QUE YA EXISTE EL REGISTRO DE LA PERSONA EN EMPRESA MD
   * CONSIDERACIONES : SOLO SE CONSIDERARA EL ESTADO 'Activo','Modificado' DE LA INFO_PERSONA_EMPRESA_ROL 
   * INCLUYE SOLO A CLIENTES O PRE-CLIENTES ES DECIR QUE POSEEN CONTRATO Y AL MENOS 1 SERVICIO EN LOS ESTADOS 'Activo','In-Corte','In-Temp'
   * SE VERIFICA SI YA EXISTE REGISTRO DE LA PERSONA_EMPRESA_ROL PARA LA PERSONA VERIFICANDO POR NUMERO DE CEDULA, SE INCLUYEN
   * LOS ESTADOS 'Activo','Modificado',Pendiente'
   * MIGRACION: SI LA PERSONA YA POSEE REGISTRO EN EMPRESA MD NO SE CREARA REGISTRO EN INFO_PERSONA_EMPRESA_ROL
   * NI CONTRATO, SOLO SE CREA DESDE INFO_PUNTO Y ESTE HERERARA EL CONTRATO YA EXISTENTE EN MD, ASI COMO LA INFORMACION
   * DE LA TABLA INFO_PERSONA_EMPRESA_ROL
   */
    cursor lc_PersonaHKExisteEnMd(c_identificacion varchar2) is
    select per.ID_PERSONA,per.NOMBRES,per.APELLIDOS,per.IDENTIFICACION_CLIENTE,per.RAZON_SOCIAL,
    pemprol.ID_PERSONA_ROL,pemprol.DEPARTAMENTO_ID,pemprol.OFICINA_ID,
    cod_empresa,descripcion_rol   
    from info_persona per
    join HIPERK.kfpsivmigrar hk on per.IDENTIFICACION_CLIENTE=hk.ID_CLIENTE1  
    --
    join info_persona_empresa_rol pemprol on per.id_persona=pemprol.persona_id 
    and pemprol.estado in ('Activo','Modificado')
    join info_empresa_rol emprol on pemprol.empresa_rol_id=emprol.id_empresa_rol     
    join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa and prefijo='MD' 
    join admi_rol rol on emprol.ROL_ID=rol.ID_ROL 
    join ADMI_TIPO_ROL trol on rol.TIPO_ROL_ID=trol.ID_TIPO_ROL and trol.descripcion_tipo_rol in ('Pre-cliente','Cliente')
    left join admi_departamento dpto on pemprol.DEPARTAMENTO_ID=dpto.ID_DEPARTAMENTO
    left join info_oficina_grupo ofi on pemprol.OFICINA_ID=ofi.ID_OFICINA
    --Verifica que tenga Contrato y Login
    join info_punto pto on pemprol.ID_PERSONA_ROL=pto.PERSONA_EMPRESA_ROL_ID    
    join info_contrato cont on pemprol.ID_PERSONA_ROL=cont.PERSONA_EMPRESA_ROL_ID
    join admi_forma_pago fpago on cont.FORMA_PAGO_ID=fpago.ID_FORMA_PAGO
    --    
    where
    per.IDENTIFICACION_CLIENTE = c_identificacion and
    --Verifica que cliente de MD tenga al menos 1 servicio en estado Activo, In-corte, In-Temp
    exists
    (  SELECT pemprol.id_persona_rol
       FROM info_servicio serv, info_punto pto
       WHERE serv.punto_id = pto.id_punto and serv.estado in ('Activo','In-Corte','In-Temp')
       AND pto.persona_empresa_rol_id = pemprol.id_persona_rol
       GROUP BY pemprol.id_persona_rol
    )
    GROUP BY (per.ID_PERSONA,per.NOMBRES,per.APELLIDOS,per.ESTADO,per.IDENTIFICACION_CLIENTE,per.RAZON_SOCIAL,
    pemprol.ID_PERSONA_ROL,pemprol.DEPARTAMENTO_ID,pemprol.OFICINA_ID,
    cod_empresa,descripcion_rol    
    );

    lr_PersonaHKExisteEnMd lc_PersonaHKExisteEnMd%ROWTYPE;
       
    --Cursor para obtener la Oficina a la que pertenece el cliente en base al Canton del HK
     cursor lc_ObtenerOficinaHK(c_nombre_canton varchar2) is 
      select ofi.ID_OFICINA,ofi.EMPRESA_ID,ofi.CANTON_ID,canton.NOMBRE_CANTON, ofi.nombre_oficina
      from INFO_OFICINA_GRUPO ofi
      JOIN ADMI_CANTON canton on ofi.canton_id=canton.id_canton
      WHERE ofi.EMPRESA_ID=l_cod_empresa and canton.NOMBRE_CANTON=c_nombre_canton;
        
     cursor lc_ObtenerEmpRolMd(c_descripcion_rol varchar2) is
       select emprol.ID_EMPRESA_ROL ,empgrup.COD_EMPRESA,rol.DESCRIPCION_ROL,trol.DESCRIPCION_TIPO_ROL 
    from info_empresa_rol emprol
    join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa and prefijo='MD' 
    join admi_rol rol on emprol.ROL_ID=rol.ID_ROL and rol.DESCRIPCION_ROL=c_descripcion_rol
    join ADMI_TIPO_ROL trol on rol.TIPO_ROL_ID=trol.ID_TIPO_ROL and trol.descripcion_tipo_rol in ('Pre-cliente','Cliente');
      
     lr_ObtenerEmpRolMd lc_ObtenerEmpRolMd%ROWTYPE;
     
     --Cursor para obtener el numero de caracteres de la cadena identificacion para definir si es cedula , Ruc o pasaporte
     cursor lc_ObtenerTipoIdenti(c_identificacion VARCHAR2) is
        select LENGTH(c_identificacion) as cantidad from dual;
        
     lr_ObtenerTipoIdenti lc_ObtenerTipoIdenti%ROWTYPE;
      
      --Cursor para verificar si rol ya existe
      cursor lc_ExisteRolMD(c_descripcion_rol VARCHAR2) is
        select emprol.ID_EMPRESA_ROL ,empgrup.COD_EMPRESA,rol.DESCRIPCION_ROL,trol.DESCRIPCION_TIPO_ROL 
    from info_empresa_rol emprol
    join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa and prefijo='MD' 
    join admi_rol rol on emprol.ROL_ID=rol.ID_ROL and rol.DESCRIPCION_ROL=c_descripcion_rol
    join ADMI_TIPO_ROL trol on rol.TIPO_ROL_ID=trol.ID_TIPO_ROL and trol.descripcion_tipo_rol in ('Contacto');
      lr_ExisteRolMD lc_ExisteRolMD%ROWTYPE;
      
      
      cursor lc_LoginHKExisteMD(c_login VARCHAR2) is
        select per.ID_PERSONA ,per.IDENTIFICACION_CLIENTE ,
          per.NOMBRES ,per.APELLIDOS ,per.RAZON_SOCIAL ,
          pto.ID_PUNTO , pto.LOGIN          
          from INFO_PUNTO pto
          join INFO_PERSONA_EMPRESA_ROL pemprol on pto.PERSONA_EMPRESA_ROL_ID=pemprol.ID_PERSONA_ROL
          join INFO_PERSONA per on per.ID_PERSONA=pemprol.PERSONA_ID
          join info_empresa_rol emprol on pemprol.empresa_rol_id=emprol.id_empresa_rol
          join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa and prefijo='MD'
        
        where PTO.LOGIN=c_login
        AND  exists
            (  SELECT pemprol.id_persona_rol
               FROM info_servicio serv, info_punto pto
               WHERE serv.punto_id = pto.id_punto and serv.estado not in ('Cancel','Eliminado','Anulado','Eliminado-Migra')
               AND pto.persona_empresa_rol_id = pemprol.id_persona_rol
               GROUP BY pemprol.id_persona_rol
            );
        
        lr_LoginHKExisteMD lc_LoginHKExisteMD%ROWTYPE;

    cursor lc_ObtenerJurisdMD(c_id_oficina NUMBER) is
       SELECT ju.ID_JURISDICCION,ju.NOMBRE_JURISDICCION,cant.ID_CANTON,cant.NOMBRE_CANTON
         FROM  DB_INFRAESTRUCTURA.ADMI_JURISDICCION ju
              join INFO_OFICINA_GRUPO ofi on ofi.ID_OFICINA=ju.OFICINA_ID
              join INFO_EMPRESA_GRUPO emp on emp.COD_EMPRESA=ofi.EMPRESA_ID and emp.PREFIJO='MD'
              join DB_GENERAL.ADMI_CANTON cant on cant.ID_CANTON=ofi.CANTON_ID 
              WHERE ofi.ID_OFICINA=c_id_oficina;
              
     lr_ObtenerJurisdMD lc_ObtenerJurisdMD%ROWTYPE;
     
     cursor lc_ObtenerPlanHkEnMD(c_codigo_plan VARCHAR2) is
      SELECT ID_PLAN,CODIGO_PLAN,NOMBRE_PLAN,
    DESCRIPCION_PLAN,EMPRESA_COD,DESCUENTO_PLAN,
    ESTADO,IP_CREACION,FE_CREACION,
    USR_CREACION,IVA,ID_SIT,TIPO,
    PLAN_ID,CODIGO_INTERNO,FE_ULT_MOD, USR_ULT_MOD
      FROM INFO_PLAN_CAB 
      where CODIGO_PLAN=c_codigo_plan
      and EMPRESA_COD=l_cod_empresa; 
      
      lr_ObtenerPlanHkEnMD lc_ObtenerPlanHkEnMD%ROWTYPE;
     
     cursor lc_ObtenerProductoHkEnMD(c_codigo_producto VARCHAR2) is
      SELECT ID_PRODUCTO,
    EMPRESA_COD,CODIGO_PRODUCTO,DESCRIPCION_PRODUCTO,FUNCION_PRECIO,FUNCION_COSTO,
    INSTALACION,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION,
    CTA_CONTABLE_PROD,CTA_CONTABLE_PROD_NC,ES_PREFERENCIA,ES_ENLACE,
    REQUIERE_PLANIFICACION,REQUIERE_INFO_TECNICA,NOMBRE_TECNICO,CTA_CONTABLE_DESC
      FROM ADMI_PRODUCTO 
      WHERE CODIGO_PRODUCTO=c_codigo_producto
      and EMPRESA_COD=l_cod_empresa; 
      
     lr_ObtenerProductoHkEnMD lc_ObtenerProductoHkEnMD%ROWTYPE;
     
     cursor lc_ObtenerProdImpHkEnMD(c_id_producto NUMBER) is
      SELECT ID_PRODUCTO_IMPUESTO,
    PRODUCTO_ID,
    IMPUESTO_ID,PORCENTAJE_IMPUESTO,FE_CREACION,
    USR_CREACION,FE_ULT_MOD,USR_ULT_MOD,ESTADO
      FROM INFO_PRODUCTO_IMPUESTO 
      where PRODUCTO_ID=c_id_producto
      and IMPUESTO_ID=1;

     lr_ObtenerProdImpHkEnMD lc_ObtenerProdImpHkEnMD%ROWTYPE;
     
    N number := 0; 
    TYPE T_ARRAY_OF_VARCHAR IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
     -- arreglo usado para dividir el campo nombre_cliente del HK y separarlo en nombres y apellido o razon social    
    MY_ARRAY T_ARRAY_OF_VARCHAR;
     -- arreglo usado para dividir el campo nombre_contacto del HK y separarlo en nombres y apellido o razon social    
    MY_ARRAY_CONT T_ARRAY_OF_VARCHAR;
     --arreglo usado para encerar o vaciar los otros arreglos
    MY_ARRAY_EMPTY T_ARRAY_OF_VARCHAR;
    
    MY_STRING VARCHAR2(2000);-- cadena que tiene el valor a separar por espacio en blanco
    
    l_id_departamento NUMBER;
    l_id_canton NUMBER;
    l_nombre_canton VARCHAR2(100);           
    l_id_oficina NUMBER;
    l_id_empresa_rol NUMBER;    
    l_cantidad_identificacion NUMBER;   --cantidad de digitos que tiene la identificacion del cliente usado para validar
    l_tipo_identificacion VARCHAR2(3);
    l_tipo_empresa VARCHAR2(7);
    l_tipo_tributario VARCHAR2(3);
    l_nacionalidad VARCHAR2(3);
    l_razon_social VARCHAR2(150) := null;
    l_nombres  VARCHAR2(100) := null;
    l_apellidos  VARCHAR2(100) := null;
    l_id_persona NUMBER;       
    l_id_persona_empresa_rol NUMBER; -- id de la persona empresa rol que es cliente        
    l_estado VARCHAR2(15);
    l_id_persona_empresa_rol_h NUMBER;
    l_numeracion VARCHAR2(30);
    l_id_tipo_contrato NUMBER;
    l_id_contrato NUMBER;
    l_fe_fin_contrato TIMESTAMP(6);
    l_id_forma_pago NUMBER;
    l_id_dato_adicional NUMBER;
    l_id_datos_pago NUMBER;
    l_numero_cta_tarjeta VARCHAR2(200);
    KEY_ENCRIP  VARCHAR(255):='c69555ab183de6672b1ebf6100bbed59186a5d72';--LLAVE DE ENCRIPCION para numero de cuenta y tarjeta
    l_id_banco_tipo_cuenta NUMBER;
    l_id_tipo_cuenta NUMBER;    
    l_id_persona_contacto NUMBER;
    l_id_persona_c NUMBER; --id de la persona que es contacto de un cliente de HK
    l_razon_social_c VARCHAR2(150) := null; --razon social del contacto
    l_nombres_c  VARCHAR2(100) := null;   --nombre del contacto
    l_apellidos_c  VARCHAR2(100) := null; --apellido del contacto
    l_id_persona_empresa_rol_c NUMBER; --id de la persona empresa rol que es contacto
    l_id_empresa_rol_c NUMBER; --id empresa rol de creado para los contactos de HK
    l_id_rol_c NUMBER; --id del rol creado para los roles de Contactos
    l_descripcion_rol_c VARCHAR2(80);    
    l_ini_primer_nombre VARCHAR2(20) :='';
    l_ini_segundo_nombre VARCHAR2(20) :='';
    l_ini_primer_apellido VARCHAR2(20) :='';
    l_ini_segundo_apellido VARCHAR2(20) :='';
    l_ini_razon_social VARCHAR2(20) :='';
    l_login_ini VARCHAR2(60) :='';
    l_login VARCHAR2(60) :='';    
    l_id_jurisdiccion NUMBER;
    l_id_punto NUMBER;
    l_id_punto_dato_adic NUMBER;
    l_id_punto_forma_contac NUMBER;
    l_gasto_admin VARCHAR2(1) :='N';
    l_id_servicio NUMBER;
    l_id_produto NUMBER;
    l_id_plan NUMBER;
    l_id_plan_det NUMBER;
    l_id_producto NUMBER;
    l_id_producto_impuesto NUMBER;
    l_id_sector NUMBER;
    l_id_orden_trabajo NUMBER;
    l_numero_orden_trabajo VARCHAR2(30);    
    l_id_servicio_histo NUMBER;
    l_id_detalle_solicitud NUMBER;
    l_titular_cuenta VARCHAR2(200);
    
 begin
   cod_ret := 1000;
   MSG_RET := 'Migracion de Clientes personales del Hiperk al Telcos MD';
   
    /******************************************************
    * Migracion de Clientes Personales del Hiperk
    ******************************************************/
    FOR datosClientes in lc_ClientesPersonalesHK LOOP
    
        cod_ret := 1100;
        MSG_RET := 'Obteniendo Punto Cliente del HK a Migrar';
        
        --Si TIPO_IDENTI  en HK es : 1: Registro Unico de Contribuyente      2: Cedula de Identidad        3: Pasaporte
    --Tipo de identificacion en Telcos: CED: cedula o RUC: ruc PAS: pasaporte
    cod_ret := 1500;
    MSG_RET := 'Obteniendo tipo de Identificacion CEDULA, RUC, PASAPORTE';
              
    /*OPEN lc_ObtenerTipoIdenti(datosClientes.ID_CLIENTE1);
    FETCH lc_ObtenerTipoIdenti INTO lr_ObtenerTipoIdenti;
    IF(lc_ObtenerTipoIdenti%notfound) THEN
         l_cantidad_identificacion := lr_ObtenerTipoIdenti.cantidad;
        END IF;
    close lc_ObtenerTipoIdenti;*/
    
    l_cantidad_identificacion := LENGTH(datosClientes.ID_CLIENTE1);         
    
    if(l_cantidad_identificacion = 13) then 
        l_tipo_identificacion := 'RUC';
    ELSIF(l_cantidad_identificacion = 10) then
        l_tipo_identificacion := 'CED';
    ELSE
        l_tipo_identificacion := 'PAS';
    end if;
              
    IF(datosClientes.TIPO_IDENTI = 1 and l_cantidad_identificacion = 13) THEN
        l_tipo_identificacion := 'RUC';
    ELSIF(datosClientes.TIPO_IDENTI = 2 and l_cantidad_identificacion = 10) THEN
        l_tipo_identificacion := 'CED';
    ELSIF(datosClientes.TIPO_IDENTI = 3) then    
        l_tipo_identificacion := 'PAS';
    END IF;
          
    cod_ret := 1600;
        MSG_RET := 'Obteniendo tipo de Tributario NATURAL O JURIDICO';
    --Tipo de tributario  NAT: Natural, JUR: Juridica              
    IF(datosClientes.TIPO_CLIENTE = 'J') then
        l_tipo_tributario := 'JUR';
    ELSE 
        l_tipo_tributario := 'NAT';
    end if;
          
    cod_ret := 1700;
    MSG_RET := 'Obteniendo tipo de Empresa PRIVADA O PUBLICA';
    --Tipo de Empresa:  Publica o Privada. Este campo solo aplica si la persona es juridica.
    IF(l_tipo_tributario = 'NAT') then
         l_tipo_empresa := null;
    ELSIF(datosClientes.TIPO_EMPRESA = 1) then
         l_tipo_empresa := 'Privada';
    ELSIF(datosClientes.TIPO_EMPRESA = 2) then
         l_tipo_empresa := 'Publica';          
    end if;
    
    --Obteniendo Nombres, apellidos y razon social
    cod_ret := 1900;
    MSG_RET := 'Obteniendo Nombres, apellidos y razon social';          
    MY_STRING := datosClientes.RAZON_SOCIAL;-- separo la cadena por espacios en blanco
    N := 0;
    MY_ARRAY := MY_ARRAY_EMPTY;
    l_razon_social := null;
        l_nombres := null;
        l_apellidos := null;
        l_ini_primer_nombre :='';
        l_ini_segundo_nombre :='';
        l_ini_primer_apellido :='';
        l_ini_segundo_apellido :='';
        l_ini_razon_social :='';
    FOR CURRENT_ROW IN (
         with test as    
         (select MY_STRING from dual)
             select regexp_substr(MY_STRING, '[^ ]+', 1, rownum) SPLIT
              from test
              connect by level <= length (regexp_replace(MY_STRING, '[^ ]+'))  + 1)
        LOOP
            N := N + 1;
            --DBMS_OUTPUT.PUT_LINE(CURRENT_ROW.SPLIT);            
            -- arreglo usado para dividir el campo nombre_cliente del HK y separarlo en nombres y apellido o razon social                
            MY_ARRAY(MY_ARRAY.COUNT) := CURRENT_ROW.SPLIT;                      
        END LOOP;
        cod_ret := 1910;
    MSG_RET := 'Validando para sacar Nombres Apellidos';          
              
        if(l_tipo_identificacion = 'CED' and l_tipo_tributario = 'NAT') then
            if(N = 1) then
                l_razon_social := trim(MY_ARRAY(0));
                l_ini_razon_social := substr(l_razon_social,0,(INSTR(l_razon_social,' ',1,1)-1));
            elsif(N = 2) then
                l_apellidos := trim(MY_ARRAY(0));
                l_nombres := trim(MY_ARRAY(1));   
                l_ini_primer_nombre := substr(l_nombres,0,1);      
                l_ini_primer_apellido := l_apellidos;
            elsif(N = 3) then
                l_apellidos := trim(MY_ARRAY(0)) || ' ' ||  trim(MY_ARRAY(1));
                l_nombres := trim(MY_ARRAY(2)); 
                l_ini_primer_nombre := substr(l_nombres,0,1);    
                l_ini_primer_apellido :=  trim(MY_ARRAY(0));
                l_ini_segundo_apellido := substr(trim(MY_ARRAY(1)),0,1);
            elsif(N = 4) then
                l_apellidos := trim(MY_ARRAY(0)) || ' ' ||  trim(MY_ARRAY(1));
                l_nombres := trim(MY_ARRAY(2)) || ' ' ||  trim(MY_ARRAY(3));
                l_ini_primer_nombre := substr(trim(MY_ARRAY(2)),0,1);    
                l_ini_segundo_nombre := substr(trim(MY_ARRAY(3)),0,1);   
                l_ini_primer_apellido :=  trim(MY_ARRAY(0));
                l_ini_segundo_apellido := substr(trim(MY_ARRAY(1)),0,1);
            elsif(N = 5) then
                l_apellidos := trim(MY_ARRAY(0)) || ' ' ||  trim(MY_ARRAY(1)); 
                l_nombres := trim(MY_ARRAY(2)) || ' ' ||  trim(MY_ARRAY(3)) || ' ' || trim(MY_ARRAY(4));
                l_ini_primer_nombre := substr(trim(MY_ARRAY(2)),0,1);    
                l_ini_segundo_nombre := substr(trim(MY_ARRAY(3)),0,1);   
                l_ini_primer_apellido :=  trim(MY_ARRAY(0));
                l_ini_segundo_apellido := substr(trim(MY_ARRAY(1)),0,1);
            end if;
            
            if (N > 1) then
                 l_login_ini := l_ini_primer_nombre || l_ini_segundo_nombre || l_ini_primer_apellido || l_ini_segundo_apellido;
            else
                 l_login_ini := l_ini_razon_social;
            end if;
        else
              l_razon_social := trim(datosClientes.RAZON_SOCIAL);  
              l_ini_razon_social := substr(l_razon_social,0,(INSTR(l_razon_social,' ',1,1)-1));
              l_login_ini := l_ini_razon_social;
        end if;        
                                  
    --Obteniendo Puntos (Login) del Hiperk
        OPEN lc_ObtenerPuntosHK(datosClientes.ID_CLIENTE);
    FETCH lc_ObtenerPuntosHK INTO lr_ObtenerPuntosHK;
    IF(lc_ObtenerPuntosHK%found) THEN    
        --Obteniendo Estado del Punto
            cod_ret := 1150;
        MSG_RET := 'Obteniendo Estado';    
            if(lr_ObtenerPuntosHK.ESTADO_CLIENTE = 'Activo') then
               l_estado := 'Activo';
            elsif(lr_ObtenerPuntosHK.ESTADO_CLIENTE = 'Suspendido') then
               l_estado := 'In-Corte';
            end if; 
            
            --Obtengo Oficina en MD en base al campo ciudad del HK
            cod_ret := 1200;
        MSG_RET := 'Obteniendo Oficina en MD';
        --Verifico si oficina de HK no existe en MD para insertar registro de oficina en el canton correspondiente           
            -- 1: Guayaquil
        -- 2: Quito
        if( lr_ObtenerPuntosHK.ID_CIUDAD is not null) then
            if(lr_ObtenerPuntosHK.ID_CIUDAD = 1) then
               l_nombre_canton := 'GUAYAQUIL';
            l_id_canton := 75;
            l_id_sector := 1826; --COOP. JUAN PABLO II
            l_id_oficina := 58;
            else
            l_nombre_canton := 'QUITO'; 
            l_id_canton := 178;
            l_id_sector := 728; --LA ECUATORIANA
            l_id_oficina := 59;
            end if;
            
        /* for lr_ObtenerOficinaHK in lc_ObtenerOficinaHK(l_nombre_canton) loop
              --Obtengo oficina de empresa MD
              l_id_oficina := lr_ObtenerOficinaHK.ID_OFICINA;                  
              exit;
           end loop;*/
              
        end if;
            IF(l_id_oficina is null) THEN
        cod_ret := 1300;
        MSG_RET := 'No encontro Oficina en MD- ID_CIUDAD Hiperk : ' || lr_ObtenerPuntosHK.ID_CIUDAD;
        raise errorProcedure;
        END IF;
          
        --Verifico si la persona ya existe con rol en empresa MD, si ya existe no se crea registro
        --en info_persona_empresa_rol y solo se crearan los Logins de Hiperk en el registro ya existente
        OPEN lc_PersonaHKExisteEnMd(datosClientes.ID_CLIENTE1);
        FETCH lc_PersonaHKExisteEnMd INTO lr_PersonaHKExisteEnMd;
        IF(lc_PersonaHKExisteEnMd%notfound) THEN
             --SI NO EXISTE PERSONA DE HK EN MD SE CREA REGISTRO DE PERSONA, PERSONA_EMPRESA_ROL, CONTRATO ETC
         --No existe campo departamente se envia NULL por default
          l_id_departamento := NULL;
          
          --Obtengo empresa_rol en MD
                  cod_ret := 1400;
                  MSG_RET := 'Obteniendo Empresa Rol en MD';
          OPEN lc_ObtenerEmpRolMd('Cliente');
              FETCH lc_ObtenerEmpRolMd INTO lr_ObtenerEmpRolMd;
              IF(lc_ObtenerEmpRolMd%found) THEN    
                   l_id_empresa_rol :=lr_ObtenerEmpRolMd.ID_EMPRESA_ROL;
              end if;
              close lc_ObtenerEmpRolMd;                            
          
          --Tipo de Nacionalidad NAC: Nacional, EXT: Extranjera
          cod_ret := 1800;
          MSG_RET := 'Obteniendo Nacionalidad NAC: Nacional, EXT: Extranjera.';
           IF(datosClientes.PROCEDENCIA = 'N') then
              l_nacionalidad := 'NAC';
          ELSIF(datosClientes.PROCEDENCIA = 'I') then
              l_nacionalidad := 'EXT';
          ELSE 
              l_nacionalidad := 'NAC';
          end if;
          
              cod_ret := 2000;
          MSG_RET := 'Insertando Persona HK en MD';
          
          l_id_persona := SEQ_INFO_PERSONA.NEXTVAL;
          Insert into INFO_PERSONA
          (ID_PERSONA,TITULO_ID,ORIGEN_PROSPECTO,TIPO_IDENTIFICACION,IDENTIFICACION_CLIENTE,
          TIPO_EMPRESA,TIPO_TRIBUTARIO,NOMBRES,APELLIDOS,RAZON_SOCIAL,REPRESENTANTE_LEGAL,
          NACIONALIDAD,DIRECCION,LOGIN,CARGO,DIRECCION_TRIBUTARIA,GENERO,ESTADO,
          FE_CREACION,USR_CREACION,IP_CREACION,ESTADO_CIVIL,FECHA_NACIMIENTO,CALIFICACION_CREDITICIA,ORIGEN_INGRESOS)
          values (l_id_persona,null,'N',l_tipo_identificacion,datosClientes.ID_CLIENTE1,
          l_tipo_empresa,l_tipo_tributario,l_nombres,l_apellidos,l_razon_social,null,
          l_nacionalidad,datosClientes.DIRECCION,null,null,datosClientes.DIRECCION,null,'Activo',
          sysdate,'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'),null,null,null,null);
          
          cod_ret := 2100;
          MSG_RET := 'Insertando Persona Empresa Rol HK en MD';
          l_id_persona_empresa_rol := SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;
          Insert into INFO_PERSONA_EMPRESA_ROL
            (ID_PERSONA_ROL,PERSONA_ID,
            EMPRESA_ROL_ID,OFICINA_ID,DEPARTAMENTO_ID,
            ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,
            CUADRILLA_ID,PERSONA_EMPRESA_ROL_ID,PERSONA_EMPRESA_ROL_ID_TTCO)
            values (l_id_persona_empresa_rol,l_id_persona,
            l_id_empresa_rol,l_id_oficina,l_id_departamento,
            'Activo','migracion_hk',sysdate,sys_context('USERENV', 'IP_ADDRESS'),
             null,null,null);
           
          --Inserto Historial
          cod_ret := 2200;
          MSG_RET := 'Insertando Historial de Persona Empresa Rol en MD';
          l_id_persona_empresa_rol_h := SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
          Insert into INFO_PERSONA_EMPRESA_ROL_HISTO
          (ID_PERSONA_EMPRESA_ROL_HISTO,USR_CREACION,FE_CREACION,
          IP_CREACION,ESTADO,PERSONA_EMPRESA_ROL_ID)
          values (l_id_persona_empresa_rol_h,'migracion_hk',sysdate,
          sys_context('USERENV', 'IP_ADDRESS'),'Activo',l_id_persona_empresa_rol);

          cod_ret := 2300;
                  MSG_RET := 'Saco Numeracion para el Contrato a insertarse en MD';
                  l_numeracion := devuelveNumeracion(l_id_oficina,'CON');
                  IF(l_numeracion is null) THEN
                       cod_ret := 2310;
                       MSG_RET := 'No encontro Numeracion para el Contrato a insertarse en MD para la oficina: ' || l_id_oficina;
                       raise errorProcedure;
                  END IF;
            
                  cod_ret := 2400;
                  MSG_RET := 'Saco contrato en HIPERK a migrarse';
                  --Saco informacion del contrato de Hiperk para insertarlo en MD
                  OPEN lc_ObtenerContratoHiperk(datosClientes.ID_CLIENTE);
                  FETCH lc_ObtenerContratoHiperk INTO lr_ObtenerContratoHiperk;
                  IF(lc_ObtenerContratoHiperk%found) THEN
                       --Inserto contrato del Hiperk en telcos de MD
                       l_id_tipo_contrato := 4; -- Por default se migran con tipo de contrato  4: Home                
                       
            --obteniendo forma de Pago.
            if(lr_ObtenerContratoHiperk.FORPAG2 = 'EFE' or
               lr_ObtenerContratoHiperk.FORPAG2 = 'CORT' or
               lr_ObtenerContratoHiperk.FORPAG2 = 'PP')then
                 l_id_forma_pago := 1;
            elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CHQ') then
                 l_id_forma_pago := 2;
            elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CA' or
                  lr_ObtenerContratoHiperk.FORPAG2 = 'CC' or 
                  lr_ObtenerContratoHiperk.FORPAG2 = 'TC') then
                 l_id_forma_pago := 3;        
            end if;
            
            l_fe_fin_contrato := ADD_MONTHS(sysdate, 24);
            
             --Inserto Contrato en MD
            cod_ret := 2410;
            MSG_RET := 'Insertando contrato en MD ' || 'oficina:' || l_id_oficina || ' Numero:'|| l_numeracion;
            l_id_contrato := SEQ_INFO_CONTRATO.NEXTVAL;
            
            Insert into INFO_CONTRATO
            (ID_CONTRATO,NUMERO_CONTRATO,NUMERO_CONTRATO_EMP_PUB,FORMA_PAGO_ID,ESTADO,
            FE_CREACION,USR_CREACION,IP_CREACION,TIPO_CONTRATO_ID,FE_FIN_CONTRATO,
            VALOR_CONTRATO,VALOR_ANTICIPO,VALOR_GARANTIA,PERSONA_EMPRESA_ROL_ID,FE_APROBACION,
            USR_APROBACION,ARCHIVO_DIGITAL,NUM_CONTRATO_ANT,FE_RECHAZO,USR_RECHAZO,MOTIVO_RECHAZO_ID)
            
            values (l_id_contrato,l_numeracion,null,l_id_forma_pago,'Activo',
            sysdate,'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'),l_id_tipo_contrato,l_fe_fin_contrato,
            null,null,null,l_id_persona_empresa_rol,sysdate,
            'migracion_hk',null,null,null,null,null); 
            
            cod_ret := 2420;
            MSG_RET := 'Insertando Datos Adicionales al Contrato de TTCO a MD';
            l_id_dato_adicional := SEQ_INFO_CONTRA_DATO_ADI.nextval;
            Insert into INFO_CONTRATO_DATO_ADICIONAL
             (CONTRATO_ID,ES_VIP,ES_TRAMITE_LEGAL,PERMITE_CORTE_AUTOMATICO,FIDEICOMISO,CONVENIO_PAGO,
              TIEMPO_ESPERA_MESES_CORTE,FE_CREACION,FE_ULT_MOD,USR_CREACION,USR_ULT_MOD,IP_CREACION,ID_DATO_ADICIONAL)
              
            values (l_id_contrato,'N','N','N','N','N',1,
              sysdate,null,'migracion_hk',null,sys_context('USERENV', 'IP_ADDRESS'),l_id_dato_adicional);
            
            cod_ret := 2430;
            MSG_RET := 'Encriptando numero de cuenta o tarjeta de credito';
            
            if(lr_ObtenerContratoHiperk.NUMCUE is not null) then            
                DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(lr_ObtenerContratoHiperk.NUMCUE,KEY_ENCRIP,l_numero_cta_tarjeta);   
            else                
                --se manda un valor por defaul de numero de cuentay/o tarjeta porque existen valores vacion en HK y es campo
                --obligatorio en Telcos
                DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR('111111',KEY_ENCRIP,l_numero_cta_tarjeta);   
            end if;
            
            cod_ret := 2440;
            MSG_RET := 'Insertando Datos de la Forma de Pago del Contrato';
                                          
            if(lr_ObtenerContratoHiperk.NOMBAN = 8) then
                 --PRODUBANCO
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 42;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 103;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 15) then
                 --PACIFICARD y  Visa Cash 
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                       l_id_banco_tipo_cuenta := 85;
                       l_id_tipo_cuenta := 21;--TARJETA MASTERCARD
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 11) then
                 --BANCO BOLIVARIANO
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 61;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 102;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 6) then
                 --DINERS CLUB
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                       l_id_banco_tipo_cuenta := 83;
                       l_id_tipo_cuenta := 23;
                 end if;            
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 9) then
                 --BANCO INTERNACIONAL
                     if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 204;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 6;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 2) then
                 --PICHINCHA
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 43;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 101;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 3) then
                 --Magna (mastercard)
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                       l_id_banco_tipo_cuenta := 85;
                       l_id_tipo_cuenta := 21;--TARJETA MASTERCARD
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 1) then
                 --GUAYAQUIL
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 3;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 21;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 10) then
                --BANCO RUMIÑAHUI
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 107;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 108;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 5) then
                 --VISA
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                       l_id_banco_tipo_cuenta := 82;
                       l_id_tipo_cuenta := 3;
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 7) then
                 --PACIFICO
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 41;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 104;
                       l_id_tipo_cuenta := 2;             
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 4) then
                 --American Express 
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                       l_id_banco_tipo_cuenta := 84;
                       l_id_tipo_cuenta := 22;
                 end if;
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 13) then
                 --BANCO DEL AUSTRO
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 4;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 5;
                       l_id_tipo_cuenta := 2;             
                 end if;            
            elsif(lr_ObtenerContratoHiperk.NOMBAN = 12) then
                 --BANCO DE MACHALA
                 if(lr_ObtenerContratoHiperk.FORPAG2 = 'CA') THEN
                       l_id_banco_tipo_cuenta := 81;
                       l_id_tipo_cuenta := 1;
                 elsif(lr_ObtenerContratoHiperk.FORPAG2 = 'CC') THEN
                        l_id_banco_tipo_cuenta := 105;
                       l_id_tipo_cuenta := 2;             
                 end if;            
            end if;            
            
            if(lr_ObtenerContratoHiperk.TITULAR is null) then
                 l_titular_cuenta := datosClientes.RAZON_SOCIAL;
            else
                 l_titular_cuenta := lr_ObtenerContratoHiperk.TITULAR;
            end if;
            
            --Inserto datos de forma de pago solo para CC CA TC
            if(lr_ObtenerContratoHiperk.FORPAG2 = 'CC' or
               lr_ObtenerContratoHiperk.FORPAG2 = 'CA' or
               lr_ObtenerContratoHiperk.FORPAG2 = 'TC') THEN
                  l_id_datos_pago := SEQ_INFO_CONTRATO_FORMA_PAGO.nextval;
                  Insert into INFO_CONTRATO_FORMA_PAGO
                (ID_DATOS_PAGO,CONTRATO_ID,BANCO_TIPO_CUENTA_ID,NUMERO_CTA_TARJETA,
                NUMERO_DEBITO_BANCO,CODIGO_VERIFICACION,TITULAR_CUENTA,FE_CREACION,FE_ULT_MOD,
                USR_CREACION,USR_ULT_MOD,ESTADO,TIPO_CUENTA_ID,IP_CREACION,
                ANIO_VENCIMIENTO,MES_VENCIMIENTO,CEDULA_TITULAR)
                
                  values (l_id_datos_pago,l_id_contrato,l_id_banco_tipo_cuenta,l_numero_cta_tarjeta,
                null,null,l_titular_cuenta,sysdate,null,
                'migracion_hk',null,'Activo',l_id_tipo_cuenta,sys_context('USERENV', 'IP_ADDRESS'),
                lr_ObtenerContratoHiperk.ANIO_EXP,lr_ObtenerContratoHiperk.MES_EXP,null);                
                    end if;            
                  END IF;
                  close lc_ObtenerContratoHiperk;                             
            ELSE
                  -- SI YA EXISTE LA PERSONA DEL HK COMO REGISTRO EN LA INFO_PERSONA EN MD , NO SE INSERTA PERSONA, 
                  -- SE TOMA EL ID DE PERSONA_EMPRESA_ROL EXISTENTE EN MD (SE VERIFICA POR NUMERO DE IDENTIFICACION)
                  --Asigno el id persona empresa rol ya existente en MD en caso que ya exista
                  l_id_persona_empresa_rol := lr_PersonaHKExisteEnMd.ID_PERSONA_ROL;        
        END IF;
            CLOSE lc_PersonaHKExisteEnMd; 
            
            --INSERTANDO INFORMACION DE LOS CONTACTOS POR PERSONA_EMPRESA_ROL
            cod_ret := 2500;
            MSG_RET := 'Insertando contactos por Persona Empresa Rol en MD';
            --
            FOR lr_ObtenerContactosHiperk in lc_ObtenerContactosHiperk(datosClientes.ID_CLIENTE) LOOP
                  l_razon_social_c := null;
                  l_nombres_c := null;
                  l_apellidos_c := null;
                  cod_ret := 2510;
          MSG_RET := 'Obteniendo Nombres, apellidos del Contacto';    
                  N := 0;
                  MY_ARRAY_CONT := MY_ARRAY_EMPTY;
                  MY_STRING := lr_ObtenerContactosHiperk.NOMBRES;-- separo la cadena por espacios en blanco
          FOR CURRENT_ROW IN (
                     with test as    
                      (select MY_STRING from dual)
                     select regexp_substr(MY_STRING, '[^ ]+', 1, rownum) SPLIT
                     from test
                     connect by level <= length (regexp_replace(MY_STRING, '[^ ]+'))  + 1)
                  LOOP
                      N := N + 1;
                      --DBMS_OUTPUT.PUT_LINE(CURRENT_ROW.SPLIT);                                            
                      MY_ARRAY_CONT(MY_ARRAY_CONT.COUNT) := CURRENT_ROW.SPLIT;                      
                  END LOOP;                  
                  if(N = 1) then
                         l_razon_social_c := trim(MY_ARRAY_CONT(0));
                  elsif(N = 2) then
                         l_nombres_c := trim(MY_ARRAY_CONT(0));                         
                         l_apellidos_c := trim(MY_ARRAY_CONT(1));                         
                  elsif(N = 3) then
                         l_nombres_c := trim(MY_ARRAY_CONT(0));
                         l_apellidos_c := trim(MY_ARRAY_CONT(1)) || ' ' ||  trim(MY_ARRAY_CONT(2));   
                  elsif(N = 4) then
                         l_nombres_c := trim(MY_ARRAY_CONT(0)) || ' ' ||  trim(MY_ARRAY_CONT(1));
                         l_apellidos_c := trim(MY_ARRAY_CONT(2)) || ' ' ||  trim(MY_ARRAY_CONT(3));
                  elsif(N = 5) then
                         l_nombres_c := trim(MY_ARRAY_CONT(0)) || ' ' ||  trim(MY_ARRAY_CONT(1)) || ' ' ||  trim(MY_ARRAY_CONT(2));  
                         l_apellidos_c := trim(MY_ARRAY_CONT(3)) || ' ' || trim(MY_ARRAY_CONT(4));
                  end if;                                   
                
                  cod_ret := 2520;
                  MSG_RET := 'Insertando a la Persona que es un Contacto en MD';
                 
                  l_id_persona_c := SEQ_INFO_PERSONA.NEXTVAL;
          Insert into INFO_PERSONA
          (ID_PERSONA,TITULO_ID,ORIGEN_PROSPECTO,TIPO_IDENTIFICACION,IDENTIFICACION_CLIENTE,
          TIPO_EMPRESA,TIPO_TRIBUTARIO,NOMBRES,APELLIDOS,RAZON_SOCIAL,REPRESENTANTE_LEGAL,
          NACIONALIDAD,DIRECCION,LOGIN,CARGO,DIRECCION_TRIBUTARIA,GENERO,ESTADO,
          FE_CREACION,USR_CREACION,IP_CREACION,ESTADO_CIVIL,FECHA_NACIMIENTO,CALIFICACION_CREDITICIA,ORIGEN_INGRESOS)
          
          values (l_id_persona_c,null,'N',null,null,
          null,null,l_nombres_c,l_apellidos_c,l_razon_social_c,null,
          null,null,null,null,null,null,'Activo',
          sysdate,'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'),null,null,null,null);
          
          cod_ret := 2525;
                  MSG_RET := 'Insertando registro de rol para cada contacto del HK';                    
                  /*****************************
                  Tipos de Contactos del HK:
                  TEC : Tecnico
          COM : Comercial
          ADM : Administrador de edificio
          COB : Facturacion/Cobranza
          REF : Comercial
          CON : Comercial
          ******************************/
          if(lr_ObtenerContactosHiperk.TIPCON = 'COM' or
             lr_ObtenerContactosHiperk.TIPCON = 'REF' or
             lr_ObtenerContactosHiperk.TIPCON = 'CON') then
               l_descripcion_rol_c := 'Contacto Comercial';
          elsif(lr_ObtenerContactosHiperk.TIPCON = 'TEC') then
               l_descripcion_rol_c := 'Contacto Tecnico';
          elsif(lr_ObtenerContactosHiperk.TIPCON = 'ADM') then
               l_descripcion_rol_c := 'Contacto Administrador de edificio';
          elsif(lr_ObtenerContactosHiperk.TIPCON = 'COB') then
               l_descripcion_rol_c := 'Contacto Facturacion/Cobranza';
          end if;
          
          OPEN lc_ExisteRolMD(l_descripcion_rol_c);
              FETCH lc_ExisteRolMD INTO lr_ExisteRolMD;
              --Si no existe el rol para la empresa MD lo inserto
              IF(lc_ExisteRolMD%notfound) THEN              
              l_id_rol_c := DB_GENERAL.SEQ_ADMI_ROL.NEXTVAL;
              Insert into DB_GENERAL.ADMI_ROL
              (ID_ROL,TIPO_ROL_ID,DESCRIPCION_ROL,ESTADO,USR_CREACION,FE_CREACION,
              USR_ULT_MOD,FE_ULT_MOD,ES_JEFE,PERMITE_ASIGNACION)           
              values (l_id_rol_c,5,l_descripcion_rol_c,'Activo','migracion_hk',sysdate,
              'migracion_hk',sysdate,'N','N');
              
              cod_ret := 2530;
              MSG_RET := 'Insertando el rol del Contacto para la empresa MD';                  
              
              l_id_empresa_rol_c := SEQ_INFO_EMPRESA_ROL.NEXTVAL;
              Insert into INFO_EMPRESA_ROL
              (ID_EMPRESA_ROL,EMPRESA_COD,ROL_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION)
              values (l_id_empresa_rol_c,l_cod_empresa,l_id_rol_c,'Activo',
            'migracion_hk',sysdate,sys_context('USERENV', 'IP_ADDRESS'));            
          else
              l_id_empresa_rol_c := lr_ExisteRolMD.ID_EMPRESA_ROL;
          end if;
          close lc_ExisteRolMD;
          
          cod_ret := 2530;
                  MSG_RET := 'Insertando a la persona _empresa_rol del HK con Rol de Contacto en MD';
                  
          l_id_persona_empresa_rol_c := SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL;
          Insert into INFO_PERSONA_EMPRESA_ROL
            (ID_PERSONA_ROL,PERSONA_ID,
            EMPRESA_ROL_ID,OFICINA_ID,DEPARTAMENTO_ID,
            ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,
            CUADRILLA_ID,PERSONA_EMPRESA_ROL_ID,PERSONA_EMPRESA_ROL_ID_TTCO)
          values (l_id_persona_empresa_rol_c,l_id_persona_c,
            l_id_empresa_rol_c,l_id_oficina,l_id_departamento,
            'Activo','migracion_hk',sysdate,sys_context('USERENV', 'IP_ADDRESS'),
             null,null,null);
                   
          --Inserto Historial
          cod_ret := 2540;
          MSG_RET := 'Insertando Historial de Persona Empresa Rol en MD';
          l_id_persona_empresa_rol_h := SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
          Insert into INFO_PERSONA_EMPRESA_ROL_HISTO
          (ID_PERSONA_EMPRESA_ROL_HISTO,USR_CREACION,FE_CREACION,
          IP_CREACION,ESTADO,PERSONA_EMPRESA_ROL_ID)
          values (l_id_persona_empresa_rol_h,'migracion_hk',sysdate,
          sys_context('USERENV', 'IP_ADDRESS'),'Activo',l_id_persona_empresa_rol_c);
          
          cod_ret := 2550;
          MSG_RET := 'Insertando registro de la Persona que es contacto del Cliente del HK migrado a MD';
          
          l_id_persona_contacto := SEQ_INFO_PERSONA_CONTACTO.NEXTVAL;
          Insert into INFO_PERSONA_CONTACTO
          (ID_PERSONA_CONTACTO,CONTACTO_ID,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION,PERSONA_EMPRESA_ROL_ID)
          values (l_id_persona_contacto,l_id_persona_c,'Activo',sysdate,'migracion_hk',
          sys_context('USERENV', 'IP_ADDRESS'),l_id_persona_empresa_rol);                                      
                
            END LOOP;-- FIN DE CONTACTOS
            
            --INSERTANDO PUNTOS (LOGINS)
            cod_ret := 2600;
        MSG_RET := 'Obteniendo Login generado para empresa MD';
        l_login := devuelveLogin(l_cod_empresa, l_id_canton, l_id_tipo_negocio, l_login_ini);
            
            --Se verifica si login de hk a migrarse ya se encuentra en MD        
            cod_ret := 2610;
        MSG_RET := 'Verificando si login a migrarse ya se encuentra en MD';
            OPEN lc_LoginHKExisteMD(l_login);
        FETCH lc_LoginHKExisteMD INTO lr_LoginHKExisteMD;
        IF(lc_LoginHKExisteMD%found) THEN
            --Si existe Login se debe agregar siglas hk al final del Login
        l_login := l_login || '-hk';
        END IF;
        CLOSE lc_LoginHKExisteMD;
            
            cod_ret := 2620;
        MSG_RET := 'Obteniendo Jurisdiccion en MD - Oficina: '|| l_id_oficina ;
            OPEN lc_ObtenerJurisdMD(l_id_oficina);
        FETCH lc_ObtenerJurisdMD INTO lr_ObtenerJurisdMD;
        IF(lc_ObtenerJurisdMD%found) THEN            
        l_id_jurisdiccion := lr_ObtenerJurisdMD.ID_JURISDICCION;
            ELSE
                raise errorProcedure;
        END IF;
        CLOSE lc_ObtenerJurisdMD;
            
           cod_ret := 2630;
           MSG_RET := 'Insertando Puntos Clientes en MD';
           l_id_punto := SEQ_INFO_PUNTO.nextval;
           Insert into INFO_PUNTO
           (ID_PUNTO,PUNTO_COBERTURA_ID,TIPO_NEGOCIO_ID,TIPO_UBICACION_ID,SECTOR_ID,
           DIRECCION,DESCRIPCION_PUNTO,LONGITUD,RUTA_CROQUIS,USR_VENDEDOR,ESTADO,
           FE_CREACION,FE_ULT_MOD,USR_CREACION,USR_ULT_MOD,IP_CREACION,LATITUD,
           LOGIN,PASSWORD,OBSERVACION,PERSONA_EMPRESA_ROL_ID,
           TIPO_CUENTA,ARCHIVO_DIGITAL,NOMBRE_PUNTO,USR_COBRANZAS,IP_ULT_MOD,ACCION)
           values 
           (l_id_punto,l_id_jurisdiccion,l_id_tipo_negocio,l_tipo_ubicacion,l_id_sector,
           lr_ObtenerPuntosHK.DIRECCION_CLIENTE_SUCURSAL,null,null,null,l_vendedor,l_estado,
           sysdate,null,'migracion_hk',null,sys_context('USERENV', 'IP_ADDRESS'),null,
           l_login,null,'Punto Cliente por migracion del Hiperk ID_CLIENTE origen: ' || lr_ObtenerPuntosHK.ID_CLIENTE,
           l_id_persona_empresa_rol,null,null,null,null,null,null);

           cod_ret := 2640;
           MSG_RET := 'Saco Numeracion para orden de servicio a insertarse en MD';
           l_numero_orden_trabajo := devuelveNumeracion(l_id_oficina,'ORD');
           IF(l_numero_orden_trabajo is null) THEN
                cod_ret := 2650;
                MSG_RET := 'No encontro Numeracion para la Orden de Trabajo a insertarse en MD para la oficina: ' || l_id_oficina;
                raise errorProcedure;
           END IF;
                  
           cod_ret := 2660;
           MSG_RET := 'Insertando Orden de Trabajo';
           l_id_orden_trabajo := SEQ_INFO_ORDEN_TRABAJO.nextval;
           
           Insert into INFO_ORDEN_TRABAJO 
           (ID_ORDEN_TRABAJO,NUMERO_ORDEN_TRABAJO,PUNTO_ID,FE_CREACION,
           FE_ULT_MOD,USR_CREACION,USR_ULT_MOD,IP_CREACION,TIPO_ORDEN,
           OFICINA_ID,ESTADO,ULTIMA_MILLA_ID) 
           values (l_id_orden_trabajo,l_numero_orden_trabajo,l_id_punto,sysdate,
           null,'migracion_hk',null,sys_context('USERENV', 'IP_ADDRESS'),'N',
           l_id_oficina,'Activa','1');
           
           cod_ret := 2665;
           MSG_RET := 'Insertando Servicios x Punto Cliente';
           
           l_gasto_admin := 'N';
           FOR lr_ObtenerServiciosHiperk in lc_ObtenerServiciosHiperk(datosClientes.ID_CLIENTE) LOOP  
                --El campo l_gasto_admin -> marcara 'S' si en el HK el cliente posee un producto  OC106 y/o OC111  Emisión y Archivo o Envío   0,99
            --Caso contrario quedara con N
        if(lr_ObtenerServiciosHiperk.ID_PRODUCTO = 'OC111' or  
            lr_ObtenerServiciosHiperk.ID_PRODUCTO = 'OC106') then
            l_gasto_admin := 'S';
        end if;
        --No se migran servicios OC106 y OC111  Emisión y Archivo o Envío   0,99
        if(lr_ObtenerServiciosHiperk.ID_PRODUCTO != 'OC111' and  
            lr_ObtenerServiciosHiperk.ID_PRODUCTO != 'OC106') then
              --Los tarifarios del HK se migran como planes en estado Inactivo              
              cod_ret := 2670;
              MSG_RET := 'Buscando si plan hk ya existe en MD';
              OPEN lc_ObtenerPlanHkEnMD(lr_ObtenerServiciosHiperk.CODPLATAR);
              FETCH lc_ObtenerPlanHkEnMD INTO lr_ObtenerPlanHkEnMD;
              IF(lc_ObtenerPlanHkEnMD%found) THEN            
                      l_id_plan := lr_ObtenerPlanHkEnMD.ID_PLAN;
                  else
                     --Si no existe se inserta plan en estado Inactivo
                     cod_ret := 2671;
                 MSG_RET := 'Insertando Plan HK en MD';
                 l_id_plan := SEQ_INFO_PLAN_CAB.nextval;
                 Insert into INFO_PLAN_CAB 
                 (ID_PLAN,CODIGO_PLAN,NOMBRE_PLAN,
                 DESCRIPCION_PLAN,EMPRESA_COD,DESCUENTO_PLAN,ESTADO,
                 IP_CREACION,FE_CREACION,USR_CREACION,IVA,
                 ID_SIT,TIPO,PLAN_ID,CODIGO_INTERNO,FE_ULT_MOD,USR_ULT_MOD) 
                 values (l_id_plan,lr_ObtenerServiciosHiperk.CODPLATAR,lr_ObtenerServiciosHiperk.DESPLATAR,
                 lr_ObtenerServiciosHiperk.DESPLATAR,l_cod_empresa,0,'Inactivo',
                 sys_context('USERENV', 'IP_ADDRESS'),sysdate,'migracion_hk','S',
                 null,'HOME',null,'201502',sysdate,'migracion_hk');
                 
                 cod_ret := 2672;
                 MSG_RET := 'Buscando si Producto hk ya existe en MD';
                 OPEN lc_ObtenerProductoHkEnMD(lr_ObtenerServiciosHiperk.CODTIPPLA);
                 FETCH lc_ObtenerProductoHkEnMD INTO lr_ObtenerProductoHkEnMD;
                 IF(lc_ObtenerProductoHkEnMD%found) THEN            
                         l_id_producto := lr_ObtenerProductoHkEnMD.ID_PRODUCTO;
                         --Si ya existe Producto lo inactivo
                         update ADMI_PRODUCTO set estado='Inactivo' where ID_PRODUCTO=l_id_producto;
                     else                     
                  --Si no existe se inserta producto en estado Inactivo
                  cod_ret := 2673;
                  MSG_RET := 'Insertando Producto HK en MD';
                  l_id_producto := SEQ_ADMI_PRODUCTO.nextval;
                  
                  Insert into ADMI_PRODUCTO
                  (ID_PRODUCTO,EMPRESA_COD,CODIGO_PRODUCTO,DESCRIPCION_PRODUCTO,
                  FUNCION_PRECIO,FUNCION_COSTO,INSTALACION,ESTADO,FE_CREACION,USR_CREACION,
                  IP_CREACION,CTA_CONTABLE_PROD,CTA_CONTABLE_PROD_NC,ES_PREFERENCIA,ES_ENLACE,
                  REQUIERE_PLANIFICACION,REQUIERE_INFO_TECNICA,NOMBRE_TECNICO,CTA_CONTABLE_DESC)
                  values 
                  (l_id_producto,l_cod_empresa,lr_ObtenerServiciosHiperk.CODTIPPLA,lr_ObtenerServiciosHiperk.DESTIPPLA,
                  'PRECIO=0.00','COSTO=0.00',null,'Inactivo',sysdate,'migracion_hk',
                  sys_context('USERENV', 'IP_ADDRESS'),null,null,'NO','NO','NO','NO',null,null);
             END IF;
             close lc_ObtenerProductoHkEnMD;
             
             cod_ret := 2674;
                 MSG_RET := 'Buscando si Producto hk en MD ya tiene registrado impuestos';
                 OPEN lc_ObtenerProdImpHkEnMD(l_id_producto);
                 FETCH lc_ObtenerProdImpHkEnMD INTO lr_ObtenerProdImpHkEnMD;
                 --Si no tiene registrado impuestos se insertan en estado Inactivo.
                 IF(lc_ObtenerProdImpHkEnMD%notfound) THEN
                    l_id_producto_impuesto :=  SEQ_INFO_PRODUCTO_IMPUESTO.nextval;
                        Insert into INFO_PRODUCTO_IMPUESTO 
                        (ID_PRODUCTO_IMPUESTO,PRODUCTO_ID,IMPUESTO_ID,PORCENTAJE_IMPUESTO,
                        FE_CREACION,USR_CREACION,FE_ULT_MOD,USR_ULT_MOD,ESTADO)
                        values (l_id_producto_impuesto,l_id_producto,1,12,
                        sysdate,'migracion_hk',null,null,'Inactivo');   
             END IF;
             CLOSE lc_ObtenerProdImpHkEnMD;
             
                 cod_ret := 2675;
                 MSG_RET := 'Insertando Detalle del Plan HK en MD';
                 
                 l_id_plan_det := SEQ_INFO_PLAN_DET.nextval;                 
                 Insert into INFO_PLAN_DET
                 (ID_ITEM,PRODUCTO_ID,PLAN_ID,CANTIDAD_DETALLE,COSTO_ITEM,PRECIO_ITEM,
                 DESCUENTO_ITEM,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION,PRECIO_UNITARIO) 
                 values (l_id_plan_det,l_id_producto,l_id_plan,1,
                 lr_ObtenerServiciosHiperk.PRECIO_VENTA_ORDEN,lr_ObtenerServiciosHiperk.PRECIO_VENTA_ORDEN,
                 0,'Inactivo',sysdate,'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'),null);
                  END IF;
                  close lc_ObtenerPlanHkEnMD;
                  
                  cod_ret := 2677;
              MSG_RET := 'Guardando los servicios del HK en MD';
              l_id_servicio := SEQ_INFO_SERVICIO.nextval;
              Insert into INFO_SERVICIO
            (ID_SERVICIO,PUNTO_ID,PRODUCTO_ID,PLAN_ID,
            ORDEN_TRABAJO_ID,CICLO_ID,INTERFACE_ELEMENTO_ID,ES_VENTA,CANTIDAD,
            PRECIO_VENTA,COSTO,PORCENTAJE_DESCUENTO,
            VALOR_DESCUENTO,DIAS_GRACIA,FRECUENCIA_PRODUCTO,
            MESES_RESTANTES,DESCRIPCION_PRESENTA_FACTURA,
            FE_VIGENCIA,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION,
            PUNTO_FACTURACION_ID,ELEMENTO_ID,ULTIMA_MILLA_ID,TIPO_ORDEN,
            OBSERVACION,ELEMENTO_CLIENTE_ID,INTERFACE_ELEMENTO_CLIENTE_ID,REF_SERVICIO_ID)
              values (l_id_servicio,l_id_punto,null,l_id_plan,
            l_id_orden_trabajo,1,NULL,'S',lr_ObtenerServiciosHiperk.CANTIDAD_ORDEN_DETALLE,
            lr_ObtenerServiciosHiperk.PRECIO_VENTA_ORDEN,null,lr_ObtenerServiciosHiperk.PORENTAJE_DESCUENTO_ORDEN,
            null,null,1,
            null,NULL,
            null,l_estado,sysdate,'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'),
            l_id_punto,null,1,'N',
            lr_ObtenerServiciosHiperk.OBSERVACION_ORDEN_DET,null,null,null);
            
            --INSERTO HISTORIAL POR SERVICIO MIGRADO EN MD
            cod_ret := 2680;
                        MSG_RET := 'Insertando Historial del servicio por Migracion HK';             
            l_id_servicio_histo := SEQ_INFO_SERVICIO_HISTORIAL.nextval;
            Insert into INFO_SERVICIO_HISTORIAL
            (ID_SERVICIO_HISTORIAL,SERVICIO_ID,USR_CREACION,FE_CREACION,IP_CREACION,ESTADO,MOTIVO_ID,OBSERVACION)
            values (l_id_servicio_histo,l_id_servicio,'migracion_hk',sysdate, sys_context('USERENV', 'IP_ADDRESS'),
            'Activo',null,'Se crea Servicio del Cliente : Migracion del Hiperk');

            --SE INSERTA HISTORIAL QUE SE REQUIERE PARA LA FACTURACION
            cod_ret := 2690;
                        MSG_RET := 'Insertando Historial del servicio requerido para la Facturacion';
            l_id_servicio_histo := SEQ_INFO_SERVICIO_HISTORIAL.nextval;
            Insert into INFO_SERVICIO_HISTORIAL
            (ID_SERVICIO_HISTORIAL,SERVICIO_ID,USR_CREACION,FE_CREACION,IP_CREACION,ESTADO,MOTIVO_ID,OBSERVACION)
            values (l_id_servicio_histo,l_id_servicio,'migracion_hk',sysdate, sys_context('USERENV', 'IP_ADDRESS'),
            'Activo',null,'Se confirmo el servicio');
            
            --SE INSERTA SOLICITUDES DE DESCUENTO SI CLIENTE DEL HK POSEE PORCENTAJE DE DESCUENTO
            IF(lr_ObtenerServiciosHiperk.PORENTAJE_DESCUENTO_ORDEN IS NOT NULL AND 
            lr_ObtenerServiciosHiperk.PORENTAJE_DESCUENTO_ORDEN != 0) THEN
                  cod_ret := 2695;
                  MSG_RET := 'Insertando Solicitudes de descuento para el cliente del HK en base a su % de descuento';
                  -- Las solicitudes se migraran con tipo_solicitud: 2: SOLICITUD DESCUENTO
                  -- motivo de la solicitud 486 : Margen de Negociación
                  l_id_detalle_solicitud := SEQ_INFO_DETALLE_SOLICITUD.nextval;
                  Insert into INFO_DETALLE_SOLICITUD
                  (ID_DETALLE_SOLICITUD,SERVICIO_ID,TIPO_SOLICITUD_ID,MOTIVO_ID,USR_CREACION,FE_CREACION,
                  PRECIO_DESCUENTO,PORCENTAJE_DESCUENTO,TIPO_DOCUMENTO,
                  OBSERVACION,ESTADO,USR_RECHAZO,FE_RECHAZO,DETALLE_PROCESO_ID,FE_EJECUCION)
                  values 
                  (l_id_detalle_solicitud,l_id_servicio,2,486,'migracion_hk',sysdate,
                  null,lr_ObtenerServiciosHiperk.PORENTAJE_DESCUENTO_ORDEN,null,
                  'Descuento generado por migracion del Hiperk','Aprobado',null,null,null,null
                  );
                END IF;
        end if;    
           END LOOP;
           
           cod_ret := 2700;
           MSG_RET := 'Insertando Datos Adicionales por Punto';
           --El campo l_gasto_admin -> marcara 'S' si en el HK el cliente posee un producto  OC106 y OC111  Emisión y Archivo o Envío   0,99
           --caso contrario marcara 'N'
           l_id_punto_dato_adic := SEQ_INFO_PUNTO_DATO_ADICIONAL.nextval;
           Insert into INFO_PUNTO_DATO_ADICIONAL
             (ID_PUNTO_DATO_ADICIONAL,PUNTO_ID,ES_EDIFICIO,DEPENDE_DE_EDIFICIO,PUNTO_EDIFICIO_ID,
              FE_CREACION,FE_ULT_MOD,USR_CREACION,USR_ULT_MOD,IP_CREACION,ES_PADRE_FACTURACION,
              DATOS_ENVIO,NOMBRE_ENVIO,SECTOR_ID,DIRECCION_ENVIO,EMAIL_ENVIO,TELEFONO_ENVIO,
              NOMBRE_EDIFICIO,ES_ELECTRONICA,GASTO_ADMINISTRATIVO)
           values (l_id_punto_dato_adic,l_id_punto,'N','N',null,
             sysdate,null,'migracion_hk',null,sys_context('USERENV', 'IP_ADDRESS'),'S',
             'N',null,null,null,null,null,null,
             'S',l_gasto_admin);
         
           cod_ret := 2710;
           MSG_RET := 'Insertando Formas de Contacto por Punto';
          
          --Se va requerir de una actualizacion o depuracion de esta data por estar sin formato
          --ingresan lo telefonos y correos sin estandar o ingresan cualquier cosa
           FOR lr_ObtenerContactosHiperk in lc_ObtenerContactosHiperk(datosClientes.ID_CLIENTE) LOOP
                if(lr_ObtenerContactosHiperk.TELCON is not null) then
              l_id_punto_forma_contac := SEQ_INFO_PUNTO_FORMA_CONTACTO.nextval;
              --Los telefonos se migran como 4: Telefono Fijo
              Insert into INFO_PUNTO_FORMA_CONTACTO 
            (ID_PUNTO_FORMA_CONTACTO,PUNTO_ID,FORMA_CONTACTO_ID,
            VALOR,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION)
              values (l_id_punto_forma_contac,l_id_punto,4,
            lr_ObtenerContactosHiperk.TELCON,'Activo',sysdate,
            'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'));
        end if;  
        if(lr_ObtenerContactosHiperk.EMAIL1 is not null) then
              l_id_punto_forma_contac := SEQ_INFO_PUNTO_FORMA_CONTACTO.nextval;
              --Los telefonos se migran como 5: Correo Electronico
              Insert into INFO_PUNTO_FORMA_CONTACTO 
            (ID_PUNTO_FORMA_CONTACTO,PUNTO_ID,FORMA_CONTACTO_ID,
            VALOR,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION)
              values (l_id_punto_forma_contac,l_id_punto,5,
            lr_ObtenerContactosHiperk.EMAIL1,'Activo',sysdate,
            'migracion_hk',sys_context('USERENV', 'IP_ADDRESS'));                  
                end if;            
           END LOOP;             
    END IF;   
    CLOSE lc_ObtenerPuntosHK;     
    END LOOP;   
    cod_ret := 0;
    MSG_RET := 'OK';
    commit;

  exception
    when errorProcedure then          
      if (lc_PersonaHKExisteEnMd%isopen) then close lc_PersonaHKExisteEnMd; end if;
      if (lc_ObtenerPuntosHK%isopen) then close lc_ObtenerPuntosHK; end if;      
      if (lc_ObtenerEmpRolMd%isopen) then close lc_ObtenerEmpRolMd; end if;
      if (lc_ObtenerTipoIdenti%isopen) then close lc_ObtenerTipoIdenti; end if;
      if (lc_ObtenerContratoHiperk%isopen) then close lc_ObtenerContratoHiperk; end if;   
      if (lc_ExisteRolMD%isopen) then close lc_ExisteRolMD; end if;
      if (lc_LoginHKExisteMD%isopen) then close lc_LoginHKExisteMD; end if;
      if (lc_ObtenerJurisdMD%isopen) then close lc_ObtenerJurisdMD; end if;
      if (lc_ObtenerPlanHkEnMD%isopen) then close lc_ObtenerPlanHkEnMD; end if;
      if (lc_ObtenerProductoHkEnMD%isopen) then close lc_ObtenerProductoHkEnMD; end if; 
      if (lc_ObtenerProdImpHkEnMD%isopen) then close lc_ObtenerProdImpHkEnMD; end if;      
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
       rollback;
    WHEN OTHERS THEN
      if (lc_PersonaHKExisteEnMd%isopen) then close lc_PersonaHKExisteEnMd; end if;
      if (lc_ObtenerPuntosHK%isopen) then close lc_ObtenerPuntosHK; end if;      
      if (lc_ObtenerEmpRolMd%isopen) then close lc_ObtenerEmpRolMd; end if;
      if (lc_ObtenerTipoIdenti%isopen) then close lc_ObtenerTipoIdenti; end if;  
      if (lc_ObtenerContratoHiperk%isopen) then close lc_ObtenerContratoHiperk; end if;  
      if (lc_ExisteRolMD%isopen) then close lc_ExisteRolMD; end if;
      if (lc_LoginHKExisteMD%isopen) then close lc_LoginHKExisteMD; end if;
      if (lc_ObtenerJurisdMD%isopen) then close lc_ObtenerJurisdMD; end if;  
      if (lc_ObtenerPlanHkEnMD%isopen) then close lc_ObtenerPlanHkEnMD; end if; 
      if (lc_ObtenerProductoHkEnMD%isopen) then close lc_ObtenerProductoHkEnMD; end if;
      if (lc_ObtenerProdImpHkEnMD%isopen) then close lc_ObtenerProdImpHkEnMD; end if;      
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
       rollback;
  end;

  --Funcion para generar los logins de los clientes migrados del Hiperk en base al formato actual de generacion
  --de logins de MD
  function devuelveLogin(p_cod_empresa VARCHAR2,p_id_canton NUMBER, p_id_tipo_negocio NUMBER, p_login_ini VARCHAR2) return VARCHAR2 is     

   cursor lc_ObtenerEmpresaGrupo(c_cod_empresa VARCHAR2) is
    SELECT COD_EMPRESA,NOMBRE_EMPRESA,
      RAZON_SOCIAL,RUC,ESTADO,
      USR_CREACION,FE_CREACION,IP_CREACION,
      LDAP_DN,lower(PREFIJO) as prefijo_emp ,FACTURA_ELECTRONICO
    FROM INFO_EMPRESA_GRUPO where COD_EMPRESA=c_cod_empresa;      
   
   lr_ObtenerEmpresaGrupo lc_ObtenerEmpresaGrupo%ROWTYPE;
   
   cursor lc_ObtenerCanton(c_id_canton NUMBER) is
   SELECT ID_CANTON,
      PROVINCIA_ID,NOMBRE_CANTON,ES_CABECERA,
      ES_CAPITAL,ESTADO,USR_CREACION,
      FE_CREACION,USR_ULT_MOD,FE_ULT_MOD,
      lower(SIGLA) AS SIGLA_C,OFICINA_ID
    FROM ADMI_CANTON where ID_CANTON=c_id_canton;
    
   lr_ObtenerCanton lc_ObtenerCanton%ROWTYPE;
      
   cursor lc_ObtenerTipoNegocio(c_id_tipo_negocio NUMBER) is
   SELECT ID_TIPO_NEGOCIO,CODIGO_TIPO_NEGOCIO,NOMBRE_TIPO_NEGOCIO,
      FE_CREACION,USR_CREACION,FE_ULT_MOD,
      USR_ULT_MOD,ESTADO,EMPRESA_COD
    FROM ADMI_TIPO_NEGOCIO where ID_TIPO_NEGOCIO=c_id_tipo_negocio;
   
   lr_ObtenerTipoNegocio lc_ObtenerTipoNegocio%ROWTYPE;
   
   cursor lc_PtosPorEmpresaPorCanton(c_cod_empresa VARCHAR2, c_id_canton NUMBER, c_login_sin_secuencia VARCHAR2) is
       SELECT count(*) CANTIDAD_LOGIN         
         FROM
         INFO_PUNTO a, INFO_PERSONA b, 
         INFO_PERSONA_EMPRESA_ROL c, INFO_EMPRESA_ROL d, INFO_PUNTO_DATO_ADICIONAL e,
         DB_GENERAL.ADMI_SECTOR g, DB_GENERAL.ADMI_PARROQUIA h, DB_GENERAL.ADMI_CANTON i
         WHERE
          a.SECTOR_ID = g.ID_SECTOR AND
          g.PARROQUIA_ID = h.ID_PARROQUIA AND
          h.CANTON_ID=i.ID_CANTON AND    
          a.PERSONA_EMPRESA_ROL_ID = c.ID_PERSONA_ROL AND
          i.ID_CANTON = c_id_canton AND
          b.ID_PERSONA = c.PERSONA_ID AND
          c.EMPRESA_ROL_ID = d.ID_EMPRESA_ROL AND
          a.ID_PUNTO = e.PUNTO_ID AND
          a.LOGIN like '%'|| c_login_sin_secuencia ||'%' AND
          d.EMPRESA_COD = c_cod_empresa;
   lr_PtosPorEmpresaPorCanton lc_PtosPorEmpresaPorCanton%ROWTYPE;              
     
   l_login_sin_secuencia VARCHAR2(60);
   l_login_generado VARCHAR2(60);
   l_tipo_negocio VARCHAR2(4);
   l_prefijo_empresa VARCHAR2(5);
   l_sigla VARCHAR2(10);
   l_cantidad NUMBER;
   errorProcedure exception;
   l_caracteres_orig varchar2(50);
   l_caracteres_reemp varchar2(50);
   
   begin     
       --Saco Tipo de negocio
       OPEN lc_ObtenerTipoNegocio(p_id_tipo_negocio);
       FETCH lc_ObtenerTipoNegocio INTO lr_ObtenerTipoNegocio;
       IF(lc_ObtenerTipoNegocio%found) THEN
           if(lr_ObtenerTipoNegocio.NOMBRE_TIPO_NEGOCIO = 'ISP') then 
                l_tipo_negocio := 'isp-';
           else
                l_tipo_negocio := '';
           end if;
       else
       raise errorProcedure;    
       END IF;
       CLOSE lc_ObtenerTipoNegocio;
       
       --Saco prefijo de empresa
       OPEN lc_ObtenerEmpresaGrupo(p_cod_empresa);
       FETCH lc_ObtenerEmpresaGrupo INTO lr_ObtenerEmpresaGrupo;
       IF(lc_ObtenerEmpresaGrupo%found) THEN
           l_prefijo_empresa := lr_ObtenerEmpresaGrupo.prefijo_emp || '-';
       else
       raise errorProcedure;    
       END IF;
       CLOSE lc_ObtenerEmpresaGrupo;              
              
      --Saco informacion del canton para obtener las siglas
       OPEN lc_ObtenerCanton(p_id_canton);
       FETCH lc_ObtenerCanton INTO lr_ObtenerCanton;
       IF(lc_ObtenerCanton%found) THEN    
           if(lr_ObtenerCanton.SIGLA_C is not null) then
               l_sigla := lr_ObtenerCanton.SIGLA_C;
           else
               l_sigla := '';
           end if;    
       else
       raise errorProcedure;    
       END IF;
       CLOSE lc_ObtenerCanton;               
       
      l_login_sin_secuencia := l_sigla || p_login_ini;         
      l_caracteres_orig  := 'áéíóúñÁÉÍÓÚÑ./-_&,\*$';
      l_caracteres_reemp := 'aeiounaeioun         ';
      l_login_sin_secuencia := lower(TRANSLATE(l_login_sin_secuencia,l_caracteres_orig,l_caracteres_reemp));
     
      l_login_sin_secuencia := l_prefijo_empresa || l_tipo_negocio || l_login_sin_secuencia;
     
       OPEN lc_PtosPorEmpresaPorCanton(p_cod_empresa, p_id_canton, l_login_sin_secuencia);
       FETCH lc_PtosPorEmpresaPorCanton INTO lr_PtosPorEmpresaPorCanton;
       IF(lc_PtosPorEmpresaPorCanton%found) THEN    
              l_cantidad := lr_PtosPorEmpresaPorCanton.CANTIDAD_LOGIN+1;
       else
              l_cantidad := 1;
       END IF;
       CLOSE lc_PtosPorEmpresaPorCanton;
       
       l_login_generado := l_login_sin_secuencia || l_cantidad;
       return l_login_generado;

     exception
      when errorProcedure then
       if (lc_ObtenerTipoNegocio%isopen) then close lc_ObtenerTipoNegocio; end if;
       if (lc_ObtenerEmpresaGrupo%isopen) then close lc_ObtenerEmpresaGrupo; end if;
       if (lc_ObtenerCanton%isopen) then close lc_ObtenerCanton; end if;
       if (lc_PtosPorEmpresaPorCanton%isopen) then close lc_PtosPorEmpresaPorCanton; end if;
       rollback;
       return null;
       when others then
       if (lc_ObtenerTipoNegocio%isopen) then close lc_ObtenerTipoNegocio; end if;
       if (lc_ObtenerEmpresaGrupo%isopen) then close lc_ObtenerEmpresaGrupo; end if;
       if (lc_ObtenerCanton%isopen) then close lc_ObtenerCanton; end if;
       if (lc_PtosPorEmpresaPorCanton%isopen) then close lc_PtosPorEmpresaPorCanton; end if;
       rollback;
       return null;
  end;
  --Funcion que devuelve la numeracion de los documentos e incrementa la secuencia en uno
  function devuelveNumeracion(p_id_oficina number,p_codigo VARCHAR2) return VARCHAR2 is     

    /************************************************************************
     * CURSOR PARA SACAR NUMERACION DE DOCUMENTOS
     ****************************************************/
    cursor lc_numeracion(c_id_oficina NUMBER, c_codigo VARCHAR2) is
      SELECT ID_NUMERACION,(NUMERACION_UNO || '-' || NUMERACION_DOS || '-' || LPAD(SECUENCIA,7,'0')) Numeracion,SECUENCIA
      FROM ADMI_NUMERACION
      where OFICINA_ID=c_id_oficina
      and CODIGO =c_codigo
      ;
      lr_numeracion lc_numeracion%ROWTYPE;

      l_numeracion VARCHAR2(30);
      errorProcedure exception;
     begin     
      --Saco Numeracion
       OPEN lc_numeracion(p_id_oficina,p_codigo);
       FETCH lc_numeracion INTO lr_numeracion;
       IF(lc_numeracion%found) THEN
           l_numeracion := lr_numeracion.Numeracion;
           update ADMI_NUMERACION set SECUENCIA=SECUENCIA+1 where ID_NUMERACION=lr_numeracion.ID_NUMERACION;
       else
       raise errorProcedure;    
       END IF;
       CLOSE lc_numeracion;
       return l_numeracion;

     exception
      when errorProcedure then
       if (lc_numeracion%isopen) then close lc_numeracion; end if;
       rollback;
       return null;
       when others then
       if (lc_numeracion%isopen) then close lc_numeracion; end if;
       rollback;
       return null;
  end;
 
END MIGRACION_HIPERK;
/
