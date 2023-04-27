create or replace PACKAGE              DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS AS
    /**
    * Documentación para el procedimiento P_GUARDAR_FOTO_EMPLEADO
    *
    * Proceso encargado de detectar guardar foto de empleados en servidor nfs
    *
    * @param Pv_CedulaEmpleado IN  VARCHAR2 cedula del emleado.
    * @param Pv_CodEmpresa     IN  VARCHAR2 Codigo de empresa del empleado.
    * @param Pv_Usuario        IN  VARCHAR2 usuario de ejecucion.
    * @param Pn_CodRespuesta   OUT NUMBER Retorna en codigo = 0 Exito, -1 = Error.
    * @param Pv_MsjRespuesta   OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.0 14-09-2022
    *
    * @author Liseth Chunga <lchunga@telconet.ec>
    * @version 2.0 26-04-2023
    */
    PROCEDURE P_GUARDAR_FOTO_EMPLEADO(Pv_CedulaEmpleado IN  VARCHAR2, 
                                      Pv_CodEmpresa     IN  VARCHAR2,
                                      Pv_Usuario       IN VARCHAR2,
                                      Pn_CodRespuesta   OUT NUMBER,
                                      Pv_MsjRespuesta   OUT VARCHAR2);
        /**
    * Documentación para el procedimiento P_GUARDAR_ARCHIVO_NFS
    *
    * Proceso encargado de detectar guardar foto de empleados en servidor nfs
    *
    * @param Pcl_Archivo      IN  CLOB archivo en base 64.
    * @param Pn_CodigoApp     IN  NUMBER codigo de aplicacion.
    * @param Pn_CodigoPath    IN  NUMBER codigo de path.
    * @param Pv_NombreArchivo IN  VARCHAR2 nombre de archivo con su extension.
    * @param Pv_PathAdicional IN  VARCHAR2 path adicional en forma de arreglo.
    * @param Pv_Usuario       IN  VARCHAR2 usuario de creacion.
    * @param Pcl_Response     OUT  CLOB respuesta del servicio de nfs que guarda archivos .
    * @param Pn_CodRespuesta  OUT NUMBER Retorna en codigo = 0 Exito, -1 = Error.
    * @param Pv_MsjRespuesta  OUT VARCHAR2 Retorna un mensaje de error en caso de existir.
    *
    * @author Pedro Velez <psvelez@telconet.ec>
    * @version 1.0 14-09-2022
    *
    * @author Liseth Chunga <lchunga@telconet.ec>
    * @version 2.0 26-04-2023
    */
    PROCEDURE P_GUARDAR_ARCHIVO_NFS(  Pcl_Archivo      IN CLOB,
                                      Pn_CodigoApp     IN NUMBER,
                                      Pn_CodigoPath    IN NUMBER,
                                      Pv_NombreArchivo IN VARCHAR2,
                                      Pv_PathAdicional IN VARCHAR2,
                                      Pv_Usuario       IN VARCHAR2,
                                      Pcl_Response     OUT CLOB,
                                      Pn_CodRespuesta  OUT NUMBER,
                                      Pv_MsjRespuesta  OUT VARCHAR2);
end CMKG_ARCHIVOS_EMPLEADOS;

/

create or replace PACKAGE BODY  DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS AS

    PROCEDURE P_GUARDAR_FOTO_EMPLEADO(Pv_CedulaEmpleado IN  VARCHAR2, 
                                      Pv_CodEmpresa     IN  VARCHAR2,
                                      Pv_Usuario        IN VARCHAR2,
                                      Pn_CodRespuesta   OUT NUMBER,
                                      Pv_MsjRespuesta   OUT VARCHAR2) IS 
      Ln_CodigoApp    NUMBER;
      Ln_CodigoPath   NUMBER;
      Lcl_Foto        CLOB;
      Lcl_Response    CLOB; 
      Ln_CodRespuesta NUMBER;
      Ln_IdPersonaEmpresaRol NUMBER;
      Lv_PathAdicional VARCHAR2(500):='[]';
      Lv_StatusResult VARCHAR2(100);
      Lv_urlFotoTecnico VARCHAR2(500);
      Lb_FoundFoto  BOOLEAN:= true;
      Lv_RutaFoto  VARCHAR2(200);
      Lv_NombreArchivo VARCHAR2(100);
      Lv_Mensaje      VARCHAR2(200);
      Lv_MsjRespuesta VARCHAR2(300);
      Le_Error        EXCEPTION;
      
    BEGIN
       begin
            SELECT S.Id_Persona_Rol, Me.Foto
            INTO Ln_IdPersonaEmpresaRol, Lcl_Foto
            FROM Db_Comercial.Info_Persona_Empresa_Rol S,
            Db_Comercial.Info_Empresa_Rol Ipr,
            Db_Comercial.Info_Persona P,
            Naf47_Tnet.Arplme Me,
            DB_GENERAL.ADMI_PARAMETRO_DET pd
            WHERE P.Identificacion_Cliente = Pv_CedulaEmpleado
            AND S.Persona_Id               = P.Id_Persona
            AND P.Identificacion_Cliente   = Me.Cedula
            AND Ipr.Id_Empresa_Rol         = S.Empresa_Rol_Id
            AND Ipr.Empresa_Cod            = Me.No_Cia
            AND Ipr.Empresa_Cod            = Pv_CodEmpresa
            AND Me.Foto                    IS NOT NULL
            AND Me.Estado                  = 'A'
            AND S.Estado                   = 'Activo'
            AND PD.DESCRIPCION             = 'DPTO_GUARDAR_FOTO_NFS'
            AND PD.VALOR1                  = S.Departamento_Id
            AND Pd.empresa_Cod             = Ipr.Empresa_Cod
            AND PD.Estado                  = 'Activo';
       exception
        when others then
           Ln_CodRespuesta := -1;
           Lv_MsjRespuesta := 'No se pudo obtener la foto del empleado';
           RAISE Le_Error;
       end;
       
       begin
           select AGD.CODIGO_APP,AGD.CODIGO_PATH 
             into Ln_CodigoApp, Ln_CodigoPath
             from DB_GENERAL.ADMI_GESTION_DIRECTORIOS AGD 
            where AGD.empresa='TN' 
              and AGD.modulo='Empleados'
              and AGD.APLICACION = 'Naf'
              and AGD.SUBMODULO = 'Fotos'; 
       exception
        when others then
           Ln_CodRespuesta := -1;
           Lv_MsjRespuesta := 'No se pudo obtener configuracion de directorio donde guardar la foto';
           RAISE Le_Error;
       end;
       
       Lv_NombreArchivo:= Pv_CedulaEmpleado||'.jpg';
       
       P_GUARDAR_ARCHIVO_NFS(Lcl_Foto,
                             Ln_CodigoApp,
                             Ln_CodigoPath,
                             Lv_NombreArchivo,
                             Lv_PathAdicional,
                             Pv_Usuario,
                             Lcl_Response,
                             Ln_CodRespuesta,
                             Lv_Mensaje);
                     
        IF Ln_CodRespuesta = 0 AND INSTR(Lcl_Response, 'status') != 0 AND INSTR(Lcl_Response, 'message') != 0 THEN
           
           APEX_JSON.PARSE(Lcl_Response);
           Lv_StatusResult := APEX_JSON.GET_VARCHAR2(p_path => 'status');       
           Lv_Mensaje      := APEX_JSON.GET_VARCHAR2(p_path => 'message');      
                
        
            if upper(Lv_StatusResult)= 'OK' then
               
               Lv_RutaFoto     := APEX_JSON.GET_VARCHAR2(p_path => 'data[%d].pathFile',p0=> 1);
               
                              
               begin
                select T.Valor 
                  into Lv_urlFotoTecnico
                  from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC t 
                 where T.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRol 
                   and T.Caracteristica_Id = (select S.Id_Caracteristica 
                                             from DB_COMERCIAL.admi_caracteristica s 
                                            where S.Descripcion_Caracteristica='URL_FOTO_EMPLEADO')
                   and T.Estado = 'Activo';
               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Lb_FoundFoto:=false;
               END;
               
               if Lb_FoundFoto then
                     update DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC T
                     set  T.valor = Lv_RutaFoto,
                          T.USR_ULT_MOD = Pv_Usuario,
                          T.FE_ULT_MOD = sysdate
                     where T.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRol 
                       and T.Caracteristica_Id = (select S.Id_Caracteristica 
                                                 from DB_COMERCIAL.admi_caracteristica s 
                                                where S.Descripcion_Caracteristica='URL_FOTO_EMPLEADO')
                      and T.Estado = 'Activo';
                else
                   begin
                    insert into DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC(ID_PERSONA_EMPRESA_ROL_CARACT,
                                PERSONA_EMPRESA_ROL_ID,
                                CARACTERISTICA_ID,
                                VALOR,
                                FE_CREACION,
                                USR_CREACION,
                                IP_CREACION,
                                ESTADO)
                    VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
                           Ln_IdPersonaEmpresaRol,
                           (SELECT S.ID_CARACTERISTICA 
                            FROM DB_COMERCIAL.ADMI_CARACTERISTICA S 
                            WHERE S.DESCRIPCION_CARACTERISTICA='URL_FOTO_EMPLEADO' 
                            AND S.ESTADO='Activo'),
                           Lv_RutaFoto,
                           sysdate,
                           Pv_Usuario,
                           '127.0.0.1',
                           'Activo');
                   exception
                    when others then
                       Ln_CodRespuesta := -1;
                       Lv_MsjRespuesta := 'No se pudo guardar la caracteristica URL_FOTO_EMPLEADO del empleado'||substr(sqlerrm,1,200);
                       RAISE Le_Error;
                   end;
                end if;
                
                commit;
                
               Pn_CodRespuesta := 0;
               Pv_MsjRespuesta := 'Caracteristica URL_FOTO_EMPLEADO del empleado'||Pv_CedulaEmpleado||' creada de manera exitosa';
            else
              Pn_CodRespuesta := -1;
              Pv_MsjRespuesta := Lv_Mensaje;
            end if;

        ELSE
            Pn_CodRespuesta := Ln_CodRespuesta;
            Pv_MsjRespuesta := Lv_Mensaje;
        END IF;       

    EXCEPTION
     WHEN Le_Error THEN
       Pn_CodRespuesta := Ln_CodRespuesta;
       Pv_MsjRespuesta := Lv_MsjRespuesta;
     WHEN OTHERS THEN
       Pn_CodRespuesta := -1;
       Pv_MsjRespuesta := 'Error general: '||substr(SQLERRM,1,200);
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Error al guardar archivo en NFS',
                                          'DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS.P_GUARDAR_FOTO_EMPLEADO',
                                          'ERROR GENERAL COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                          ' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                          'telcos',
                                          SYSDATE,
                                          '127.0.0.1');
    END P_GUARDAR_FOTO_EMPLEADO;       

    PROCEDURE P_GUARDAR_ARCHIVO_NFS(  Pcl_Archivo      IN CLOB,
                                      Pn_CodigoApp     IN NUMBER,
                                      Pn_CodigoPath    IN NUMBER,
                                      Pv_NombreArchivo IN VARCHAR2,
                                      Pv_PathAdicional IN VARCHAR2,
                                      Pv_Usuario       IN VARCHAR2,
                                      Pcl_Response     OUT CLOB,
                                      Pn_CodRespuesta  OUT NUMBER,
                                      Pv_MsjRespuesta  OUT VARCHAR2) IS  
      Lcl_Request      CLOB;
      Lcl_Response     CLOB; 
      Lv_Aplicacion    VARCHAR2(50) := 'application/json';
      Lcl_Headers      CLOB;
      Ln_CodeRequest   NUMBER:=0;
      Lv_Url           VARCHAR2(200);
      Lv_StatusResult  VARCHAR2(100);
      Lv_MsgResult     VARCHAR2(100);
      Lv_respuestaData VARCHAR2(2000);
      Le_Error Exception;
                                        
    BEGIN      
        
        begin
          select APD.VALOR1
            into Lv_Url
            from DB_GENERAL.ADMI_PARAMETRO_DET apd
            where APD.PARAMETRO_ID = (Select APC.ID_PARAMETRO 
                                        from DB_GENERAL.ADMI_PARAMETRO_CAB apc 
                                       where apc.NOMBRE_PARAMETRO   ='URL_MICROSERVICIO'
                                       and APC.ESTADO = 'Activo')
            and APD.DESCRIPCION =  'URL_NFS_GUARDAR_ARCHIVO'
            and APD.ESTADO ='Activo';
         exception
          when others then
             Ln_CodeRequest := -1;
             Lv_MsgResult := 'Error al obtener Url del microservicio de guardar archivo';
             RAISE Le_Error;
         end;
        
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Content-Type', Lv_Aplicacion);
        APEX_JSON.WRITE('Accept', Lv_Aplicacion);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;     
        
        DBMS_LOB.CREATETEMPORARY(Lcl_Request, TRUE); 
        DBMS_LOB.APPEND(Lcl_Request,'{"data":[{"codigoApp": '||Pn_CodigoApp||',"codigoPath": '|| Pn_CodigoPath);
        DBMS_LOB.APPEND(Lcl_Request,',"nombreArchivo": "'|| Pv_NombreArchivo||'","fileBase64": "');
        DBMS_LOB.APPEND(Lcl_Request,Pcl_Archivo);
        DBMS_LOB.APPEND(Lcl_Request,'", "pathAdicional":'||Pv_PathAdicional||'}],"op": "guardarArchivo"');
        DBMS_LOB.APPEND(Lcl_Request,',"user": "'||Pv_Usuario ||'"}');        
        
        DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_Url,Lcl_Headers,Lcl_Request,Ln_CodeRequest,Lv_MsgResult,Lcl_Response);    
        
        Pcl_Response := Lcl_Response;
        Pn_CodRespuesta := Ln_CodeRequest;
        Pv_MsjRespuesta := Lv_MsgResult;        
      
    EXCEPTION
     WHEN Le_Error THEN
        Pn_CodRespuesta := Ln_CodeRequest;
        Pv_MsjRespuesta := Lv_MsgResult;
     WHEN OTHERS THEN
      Pn_CodRespuesta:= -1;
      Pv_MsjRespuesta:= 'Error general: '||substr(SQLERRM,1,200);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Error al guardar archivo en NFS',
                                          'DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS.P_GUARDAR_ARCHIVO_NFS',
                                          'ERROR GENERAL COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                          ' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                          'telcos',
                                          SYSDATE,
                                          '127.0.0.1');
    END P_GUARDAR_ARCHIVO_NFS;  
                                        
 END CMKG_ARCHIVOS_EMPLEADOS;

/
