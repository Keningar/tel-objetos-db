CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_RECAUDACIONES AS 

  /*
  * Documentación para TYPE 'Lr_FormatosRecaudacion'.
  *
  * Tipo de datos para el retorno de la informacion de los formatos de recaudación.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  TYPE Lr_FormatosRecaudacion
  IS
    RECORD
    (
      TIPO_CAMPO                        DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_CAMPO%TYPE,
      CONTENIDO                         DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE, 
      LONGITUD                          DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD%TYPE,
      CARACTER_RELLENO                  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CARACTER_RELLENO%TYPE,
      POSICION                          DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.POSICION%TYPE,
      TIPO_DATO                         DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_DATO%TYPE,
      ORIENTACION_CARACTER_RELLENO      DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ORIENTACION_CARACTER_RELLENO%TYPE,
      LONGITUD_TOTAL                    DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD_TOTAL%TYPE);
  --
  TYPE C_FormatosRecaudacion
  IS
    REF
    CURSOR
      RETURN Lr_FormatosRecaudacion;


  /*
  * Documentación para PROCEDURE 'P_GEN_FORMATO_ENV_REC'.
  * Procedure que permite generar el formato de envío de  recaudación según el canal de recaudación enviado como parámetro.
  *
  * PARAMETROS:
  * @Param varchar2 Pn_EmpresaCod     Empresa a generar el reporte
  * @Param varchar2 Pv_UsrSesion      Canal de recaudación
  * @Param varchar2 Pv_EmailUsrSesion Email del usuario a ser notificado.
  * @Param varchar2 Pv_UsuarioSession Usuario que genera formato de envío de recaudación.
  * @Param varchar2 Pv_NombreArchivo  Nombre del archivo de formato de envío de recaudación a generar.
  * @Param varchar2 Pv_PathNFS        Ruta donde se encuentra alojado el archivo.
  * @Param varchar2 Pv_Error          Usa para validar errores.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 16-09-2016
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 16-01-2018 Se realiza cierre de cursores utilizados en la generación de formatos de recaudación.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 16-02-2018 Se agrega envío de reporte de clientes que no cumplen con el formato necesario para generar recaudación, 
                            se agregan validaciones con respecto a la longitud de identificación y nombres del cliente.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 10-05-2021 Se realizan cambios por el consumo al nuevo NFS.
  */
  PROCEDURE P_GEN_FORMATO_ENV_REC(
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_CanalRecaudacion             IN  VARCHAR2,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_UsuarioSession               IN  VARCHAR2,
    Pv_NombreArchivo                IN  VARCHAR2,
    Pv_PathNFS                      OUT VARCHAR2,
    Pv_Error                        OUT VARCHAR2
  );

  /*
  * Documentación para la función 'F_GET_SALDO_CLIENTE'.
  * Funcuión que permite consultar el saldo total del cliente enviado como parámetro.
  *
  * PARAMETROS:
  * @Param varchar2 Fv_EmpresaCod             Código de la empresa
  * @Param varchar2 Fv_IdentificacionCliente  Identificación del cliente
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  FUNCTION F_GET_SALDO_CLIENTE(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_IdentificacionCliente  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE)
  RETURN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE;

  /*
  * Documentación para la función 'F_GET_FORMATOS_REC'.
  * Función que permite consultar los formatos de recaudación según los filtros enviados como parámetro.
  *
  * PARAMETROS:
  * @Param varchar2 Fv_EmpresaCod             Código de la empresa
  * @Param varchar2 Fv_CanalRecaudacion       Canal de recaudación
  * @Param varchar2 Fv_EsCabecera             Filtro que indica si es cabecera o detalle del formato de recaudación
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  FUNCTION F_GET_FORMATOS_REC(
    Fv_CodEmpresa         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.EMPRESA_COD%TYPE,
    Fv_CanalRecaudacion   IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CANAL_RECAUDACION_ID%TYPE,
    Fv_EsCabecera         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ES_CABECERA%TYPE)
  RETURN C_FormatosRecaudacion;


  /*
  * Documentación para la función 'F_GET_VALOR_FORMAT'.
  * Función que retorna una cadena de texto con el formato respectivo.
  *
  * PARAMETROS:
  * @Param DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE                     Fv_Contenido                   Cadena de texto a ser formatreada
  * @Param DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_CAMPO%TYPE                    Fv_TipoCampo                   Tipo de campo Fijo o Variable  
  * @Param DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD%TYPE                      Fv_Longitud                    Longitud de la cadena a formatear 
  * @Param DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CARACTER_RELLENO%TYPE              Fv_CaracterRelleno             Caracter de relleno  
  * @Param DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ORIENTACION_CARACTER_RELLENO%TYPE  Fv_OrientacionCaracterRelleno  Orientación de rellede DER o IZQ   
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  FUNCTION F_GET_VALOR_FORMAT(
    Fv_Contenido                        IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE,
    Fv_TipoCampo                        IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_CAMPO%TYPE,
    Fv_Longitud                         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD%TYPE,
    Fv_CaracterRelleno                  IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CARACTER_RELLENO%TYPE,
    Fv_OrientacionCaracterRelleno       IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ORIENTACION_CARACTER_RELLENO%TYPE,
    Fv_ContenidoAdicional               IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE)
  RETURN VARCHAR2;

  /*
  * Documentación para la función 'F_GET_SALDO_RECAUDADO'.
  * Función que permite consultar el saldo total recaudado de la empresa enviada como parámetro.
  *
  * PARAMETROS:
  * @Param varchar2 Fv_EmpresaCod             Código de la empresa
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  FUNCTION F_GET_SALDO_RECAUDADO(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE;


  /*
  * Documentación para la función 'F_GET_TOTAL_CLIENTES_REC'.
  * Función que permite consultar la cantidad total de cliente recaudados de la empresa enviada como parámetro.
  *
  * PARAMETROS:
  * @Param varchar2 Fv_EmpresaCod             Código de la empresa
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 22-11-2017
  */
  FUNCTION F_GET_TOTAL_CLIENTES_REC(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2;

/*
* Documentación para FUNCION 'P_PROCESAR'.
* Procedimiento que genra los registros contables en los Repositorios de Migración de NAF.
* @author Luis Lindao llindao@telconet.ec
* @version 1.0
*
* @Param Pv_NoCia        IN     VARCHAR2 recibe Código de Compañia
* @Param Pv_Fecha        IN     VARCHAR2 recibe fecha a procesar
* @Param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje de error
*
*/ 
  PROCEDURE P_CONTABILIZAR ( Pv_NoCia         IN VARCHAR2,
                             Pv_Fecha         IN VARCHAR2,
                             Pv_MensajeError  IN OUT VARCHAR2);

END FNKG_RECAUDACIONES;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_RECAUDACIONES AS     
  --
  Gv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACIONES_PROCESOS_CONTABLES';
  Gv_NombreProceso   DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE := 'FNKG_RECAUDACIONES';
  Gv_EstadoAtivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE := 'Activo';
  Gv_ParamEstadoPago DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'ESTADO_PAGO';
  Gv_ParamTipoDoc    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CODIGO_TIPO_DOCUMENTO';
  --

  PROCEDURE P_GEN_FORMATO_ENV_REC(
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_CanalRecaudacion             IN  VARCHAR2,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_UsuarioSession               IN  VARCHAR2,
    Pv_NombreArchivo                IN  VARCHAR2,
    Pv_PathNFS                      OUT VARCHAR2,
    Pv_Error                        OUT VARCHAR2
  )
  IS

    CURSOR C_Directory(Pv_Directorio VARCHAR2) IS
      SELECT DIRECTORY_PATH
      FROM ALL_DIRECTORIES
      WHERE UPPER(DIRECTORY_NAME) = Pv_Directorio;

    --Costo 5
    CURSOR C_PARAMETROS(Cv_NombreParametro      VARCHAR2,
                        Cv_DescripcionParametro VARCHAR2)
    IS 
      SELECT APD.VALOR1,
        APD.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APD.PARAMETRO_ID IN (SELECT APC.ID_PARAMETRO
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                 WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro) 
      AND APD.DESCRIPCION = Cv_DescripcionParametro;   
    
    --Costo 5
    CURSOR C_PARAMETROS_POR_EMPRESA(Cv_NombreParametro      VARCHAR2,
                                  Cv_DescripcionParametro VARCHAR2,
                                  Cv_Cod_Empresa VARCHAR2)
    IS 
      SELECT APD.VALOR1,
        APD.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APD.PARAMETRO_ID IN (SELECT APC.ID_PARAMETRO
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                 WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro) 
      AND APD.DESCRIPCION = Cv_DescripcionParametro
      AND APD.EMPRESA_COD = Cv_Cod_Empresa;
    
    --Costo 4
    CURSOR C_RUTA_ARCHIVO_NFS (Cv_EmpresaCod VARCHAR2)
    IS
      SELECT AGD.CODIGO_APP,
        AGD.CODIGO_PATH 
      FROM DB_FINANCIERO.ADMI_GESTION_DIRECTORIOS AGD,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE AGD.APLICACION = 'TelcosWeb' 
      AND AGD.SUBMODULO    = 'Recaudacion' 
      AND AGD.EMPRESA      = IEG.PREFIJO
      AND IEG.COD_EMPRESA  = Cv_EmpresaCod;

    Lv_QueryClientes                  VARCHAR2(10000) ;
    Lv_Directorio                     VARCHAR2(50)   := 'DIR_LOCAL_RECPAG';
    Lv_DirectorioF                    VARCHAR2(50)   := 'DIR_REMOTE_RECPAG';
    Lv_NombreArchivo                  VARCHAR2(50)   := Pv_NombreArchivo;
    Lv_Gzip                           VARCHAR2(100)  := '';
    Lv_Remitente                      VARCHAR2(20)   := 'telcos@telconet.ec';
    Lv_Destinatario                   VARCHAR2(100)  := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
    Lv_NombreArchivoGz                VARCHAR2(50)   := Lv_NombreArchivo||'.gz';
    Lv_NombreArchivoZip               VARCHAR2(50)   := Lv_NombreArchivo||'.zip';
    Lv_FechaActual                    VARCHAR2(100)  := TO_CHAR(SYSDATE, 'DD-MM-YYYY');
    Lv_Asunto                         VARCHAR2(300)  := 'Telcos+ : Generacion Formato Envio Recaudacion: '||Lv_FechaActual;
    Lv_AsuntoClientesSinFormato       VARCHAR2(300)  := 'Telcos+ : Reporte Clientes Sin Formato Envio Recaudacion: '||Lv_FechaActual;
    Lv_NombreArchivoRech              VARCHAR2(50)   := 'RptClientesSinFormato_'||Lv_FechaActual||'.csv';
    Lv_Cuerpo                         VARCHAR2(9999) := '';
    Lfile_Archivo                     utl_file.file_type;
    Lfile_ArchivoRechazados           utl_file.file_type;
    Lc_ClientesRecaudacion            SYS_REFCURSOR;
    Lc_Directory                      C_Directory%ROWTYPE;
    Lr_ClienteRecaudacion             DB_FINANCIERO.FNKG_TYPES.Lr_ClienteRecaudacion;
    Lr_GetAliasPlantilla              DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lrf_CursorFormatosRecaudacion     DB_FINANCIERO.FNKG_RECAUDACIONES.C_FormatosRecaudacion;
    Lr_GetFormatosRecaudacion         DB_FINANCIERO.FNKG_RECAUDACIONES.Lr_FormatosRecaudacion;
    Lrf_FormatosRecaudacionDet        DB_FINANCIERO.FNKG_RECAUDACIONES.C_FormatosRecaudacion;
    Lr_GetFormatosRecaudacionDet      DB_FINANCIERO.FNKG_RECAUDACIONES.Lr_FormatosRecaudacion;
    Lrf_GetAdmiParamtrosDet           SYS_REFCURSOR;
    Lr_GetAdmiParamtrosDet            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_CabeceraFormatoRec             VARCHAR2(200)  := '';
    Lv_ContenidoFormateado            VARCHAR2(100)  := '';
    Lv_ContenidoAdicionalCab          VARCHAR2(200)  := '';
    Lv_ContenidoAdicionalDet          VARCHAR2(200)  := '';
    Lv_DetalleFormatoRec              VARCHAR2(200)  := '';
    Lv_ContenFormatDet                VARCHAR2(100)  := '';
    Lv_IdentificacionCliente          VARCHAR2(100)  := '';
    Lv_TipoIdentificacionCliente      VARCHAR2(100)  := '';
    Lv_TotalRegistros                 VARCHAR2(100)  := '';
    Lv_SaldoTotal                     VARCHAR2(100)  := '';
    Lv_SaldoCliente                   VARCHAR2(100)  := '';
    Lv_NombresCliente                 VARCHAR2(1000) := '';
    Ln_ContadorLineas                 NUMBER         := 1;
    Ln_LongitudIdentificacion         NUMBER         := 0;
    Lv_Delimitador                    VARCHAR2(1)    :='|';
    Lv_reponse                        VARCHAR2(800)  := '';
    Lv_Comparacion                    VARCHAR2(10)   := '';
    Lv_UrlNfs                         VARCHAR2(3200) := '';
    Lv_CodigoApp                      VARCHAR2(150)  := '';
    Lv_CodigoPath                     VARCHAR2(150)  := '';
    Lc_Parametros                     C_PARAMETROS%ROWTYPE;
    LnCantidadUrl1                    NUMBER;
    LnCantidadUrl2                    NUMBER;
    LvPathAdicional                   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    
  BEGIN
    OPEN C_PARAMETROS_POR_EMPRESA ('PARAMETROS_RECAUDACION','PATH ADICIONAL', Pv_EmpresaCod);
    FETCH C_PARAMETROS_POR_EMPRESA INTO Lc_Parametros;
    CLOSE C_PARAMETROS_POR_EMPRESA;
    LvPathAdicional := Lc_Parametros.VALOR1;
    
    OPEN C_PARAMETROS ('PARAMETROS_RECAUDACION','RUTA_NFS');
    FETCH C_PARAMETROS INTO Lc_Parametros;
    CLOSE C_PARAMETROS;

    OPEN C_PARAMETROS ('REPORTE_CARTERA','RUTA_NFS');
    FETCH C_PARAMETROS INTO Lc_Parametros;
    CLOSE C_PARAMETROS;

    OPEN C_RUTA_ARCHIVO_NFS (Pv_EmpresaCod);
    FETCH C_RUTA_ARCHIVO_NFS INTO Lv_CodigoApp,Lv_CodigoPath;
    CLOSE C_RUTA_ARCHIVO_NFS;

    --SE REGISTRAN LOS SIGUIENTES PARAMETROS EN LA TABLA INFO_ERROR dnatha 29/10/2019
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
            'LOG DE EJECUCION DE PAGOS',
            'Ejecucion del proceso FNKG_RECAUDACIONES.P_GEN_FORMATO_ENV_REC con los sgtes parametros... Codigo de empresa: ' || Pv_EmpresaCod || ', Pv_CanalRecaudacion: ' || Pv_CanalRecaudacion || ', Pv_EmailUsrSesion: ' || Pv_EmailUsrSesion || ', Pv_UsuarioSession: ' || Pv_UsuarioSession || ', Pv_NombreArchivo: ' || Pv_NombreArchivo,
            'telcos',
            SYSDATE, 
            '172.0.0.1');

    OPEN  C_Directory(Lv_Directorio);
    FETCH C_Directory INTO Lc_Directory;
    CLOSE C_Directory;

    Lv_Gzip        :='gzip '||Lc_Directory.DIRECTORY_PATH||Lv_NombreArchivo;

    Lfile_Archivo  := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivo,'w',3000);

    Lv_QueryClientes :=
    '   SELECT IPE.TIPO_IDENTIFICACION, 
               IPE.IDENTIFICACION_CLIENTE,
               IPE.NOMBRES,
               IPE.APELLIDOS,
               IPE.RAZON_SOCIAL,
               DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_SALDO_CLIENTE('''|| Pv_EmpresaCod ||''',IPE.IDENTIFICACION_CLIENTE) AS SALDO
        FROM DB_COMERCIAL.INFO_PERSONA                   IPE  
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPE.ID_PERSONA              = IPER.PERSONA_ID
        LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO        IOG  ON IOG.ID_OFICINA              = IPER.OFICINA_ID
        LEFT JOIN DB_COMERCIAL.INFO_CONTRATO             IC   ON IC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
        LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO             AFP  ON AFP.ID_FORMA_PAGO           = IC.FORMA_PAGO_ID
        WHERE IOG.EMPRESA_ID           = '''|| Pv_EmpresaCod ||''' 
        AND AFP.DESCRIPCION_FORMA_PAGO = ''RECAUDACION''
        AND IC.FORMA_PAGO_ID IS NOT NULL';

        --
        -- CREACION DE ARCHIVO DE CLIENTES QUE NO CUMPLEN FORMATO
        --
        Lfile_ArchivoRechazados := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivoRech,'w',3000);

        utl_file.put_line(Lfile_ArchivoRechazados, 'LONGITUD'||Lv_Delimitador 
                                         ||'TIPO_IDENTIFICACION'||Lv_Delimitador 
                                         ||'IDENTIFICACION'||Lv_Delimitador 
                                         ||'NOMBRES - RAZON SOCIAL'||Lv_Delimitador );

        --
        -- CREACION DE CABECERA DEL DOCUMENTO DE FORMATO DE ENVIO DE RECAUDACION
        --

        Lrf_CursorFormatosRecaudacion    := NULL;

        Lrf_FormatosRecaudacionDet       := NULL;
        
        Lrf_CursorFormatosRecaudacion    := DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_FORMATOS_REC(Pv_EmpresaCod,
                                                                                                Pv_CanalRecaudacion,
                                                                                                'S');

        Lv_TotalRegistros := DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_TOTAL_CLIENTES_REC(Pv_EmpresaCod);

        Lv_SaldoTotal     := TO_CHAR(DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_SALDO_RECAUDADO(Pv_EmpresaCod),'99999999990D99');

        LOOP
          --
          FETCH Lrf_CursorFormatosRecaudacion INTO Lr_GetFormatosRecaudacion;

          EXIT WHEN Lrf_CursorFormatosRecaudacion%NOTFOUND;

          IF Lr_GetFormatosRecaudacion.TIPO_CAMPO = 'V' THEN  -- Si contenido tiene formato variable

            IF Lr_GetFormatosRecaudacion.CONTENIDO = 'TR' THEN

              Lv_ContenidoAdicionalCab := Lv_TotalRegistros;

            ELSIF Lr_GetFormatosRecaudacion.CONTENIDO = 'VT|13|2' THEN

              Lv_ContenidoAdicionalCab := Lv_SaldoTotal;

            ELSE

              Lv_ContenidoAdicionalCab := '';

            END IF;
          
          ELSE -- Si el contenido tiene formato fijo

            Lv_ContenidoAdicionalCab := '';

          END IF;

         Lv_ContenidoFormateado := DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_VALOR_FORMAT( Lr_GetFormatosRecaudacion.CONTENIDO,
                                                                                        Lr_GetFormatosRecaudacion.TIPO_CAMPO,
                                                                                        Lr_GetFormatosRecaudacion.LONGITUD,
                                                                                        Lr_GetFormatosRecaudacion.CARACTER_RELLENO,
                                                                                        Lr_GetFormatosRecaudacion.ORIENTACION_CARACTER_RELLENO,
                                                                                        Lv_ContenidoAdicionalCab);

          Lv_CabeceraFormatoRec  := Lv_CabeceraFormatoRec||Lv_ContenidoFormateado ;
          --
        END LOOP;

        IF Lv_CabeceraFormatoRec  IS NOT NULL THEN
            utl_file.put_line(Lfile_Archivo,Lv_CabeceraFormatoRec);
        END IF;

        --
        -- CREACION DE DETALLES DEL DOCUMENTO DE FORMATO DE ENVIO DE RECAUDACION
        --
        IF Lc_ClientesRecaudacion%ISOPEN THEN
          CLOSE Lc_ClientesRecaudacion;
        END IF;

        OPEN Lc_ClientesRecaudacion FOR Lv_QueryClientes;

        LOOP
          FETCH Lc_ClientesRecaudacion INTO Lr_ClienteRecaudacion;     
            EXIT
            WHEN Lc_ClientesRecaudacion%NOTFOUND;
          

          Lv_IdentificacionCliente         := TRIM(Lr_ClienteRecaudacion.IDENTIFICACION_CLIENTE);

          Lv_SaldoCliente                  := TO_CHAR(Lr_ClienteRecaudacion.SALDO,'99999999990D99');

          Lv_TipoIdentificacionCliente     := TRIM(Lr_ClienteRecaudacion.TIPO_IDENTIFICACION);

          Lrf_GetAdmiParamtrosDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_ADMI_PARAMETROS_DET('MAX_IDENTIFICACION', 'Activo','Activo', 
                                                                                       Lv_TipoIdentificacionCliente,'ECUADOR');
          --
          FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
          --
          CLOSE Lrf_GetAdmiParamtrosDet;

          IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
             Lr_GetAdmiParamtrosDet.VALOR3           IS NOT NULL THEN
              --
              Ln_LongitudIdentificacion := TO_NUMBER(Lr_GetAdmiParamtrosDet.VALOR3);
              --
          END IF;

          IF Lv_TipoIdentificacionCliente = 'CED' THEN
            
            Lv_TipoIdentificacionCliente := 'C';

          ELSIF Lv_TipoIdentificacionCliente = 'RUC' THEN
            
            Lv_TipoIdentificacionCliente := 'R';

          ELSE
            
            Lv_TipoIdentificacionCliente := 'P';

          END IF; 


          IF Lr_ClienteRecaudacion.RAZON_SOCIAL IS NOT NULL THEN
 
            Lv_NombresCliente  := Lr_ClienteRecaudacion.RAZON_SOCIAL;

          ELSE

            Lv_NombresCliente  := Lr_ClienteRecaudacion.NOMBRES || ' ' ||Lr_ClienteRecaudacion.APELLIDOS;

          END IF; 
          
          Lrf_FormatosRecaudacionDet       := DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_FORMATOS_REC(Pv_EmpresaCod,
                                                                                                  Pv_CanalRecaudacion,
                                                                                                  'N');
          LOOP
              --
            FETCH Lrf_FormatosRecaudacionDet INTO Lr_GetFormatosRecaudacionDet;

            EXIT WHEN Lrf_FormatosRecaudacionDet%NOTFOUND;

            IF Lr_GetFormatosRecaudacionDet.TIPO_CAMPO = 'V' THEN  -- Si contenido tiene formato variable

              IF Lr_GetFormatosRecaudacionDet.CONTENIDO = 'IDT' THEN

                Lv_ContenidoAdicionalDet := Lv_IdentificacionCliente;

              ELSIF Lr_GetFormatosRecaudacionDet.CONTENIDO = 'NOM' THEN

                Lv_ContenidoAdicionalDet := Lv_NombresCliente;

              ELSIF Lr_GetFormatosRecaudacionDet.CONTENIDO = 'TI' THEN

                Lv_ContenidoAdicionalDet := Lv_TipoIdentificacionCliente;

              ELSE

                Lv_ContenidoAdicionalDet := Lv_SaldoCliente;

              END IF;

            ELSE -- Si el contenido tiene formato fijo

              Lv_ContenidoAdicionalDet := '';

            END IF;

            Lv_ContenFormatDet := DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_VALOR_FORMAT( Lr_GetFormatosRecaudacionDet.CONTENIDO,
                                                                                       Lr_GetFormatosRecaudacionDet.TIPO_CAMPO,
                                                                                       Lr_GetFormatosRecaudacionDet.LONGITUD,
                                                                                       Lr_GetFormatosRecaudacionDet.CARACTER_RELLENO,
                                                                                       Lr_GetFormatosRecaudacionDet.ORIENTACION_CARACTER_RELLENO,
                                                                                       Lv_ContenidoAdicionalDet);
            Lv_DetalleFormatoRec  := Lv_DetalleFormatoRec || Lv_ContenFormatDet ;
              --
          END LOOP;

          CLOSE Lrf_FormatosRecaudacionDet;

          IF Lv_TipoIdentificacionCliente IS NOT NULL AND Lv_NombresCliente != ' ' 
             AND ((Lv_TipoIdentificacionCliente   != 'P'AND LENGTH(Lv_IdentificacionCliente) = Ln_LongitudIdentificacion)
                    OR Lv_TipoIdentificacionCliente = 'P')THEN

            IF Ln_ContadorLineas  < Lv_TotalRegistros THEN
                utl_file.put_line(Lfile_Archivo,Lv_DetalleFormatoRec);
            ELSE
                utl_file.put(Lfile_Archivo,Lv_DetalleFormatoRec);
            END IF;

          ELSE

            utl_file.put_line(Lfile_ArchivoRechazados,NVL(LENGTH(Lv_IdentificacionCliente),0)||Lv_Delimitador 
                 ||NVL(Lv_TipoIdentificacionCliente,'')||Lv_Delimitador 
                 ||NVL(Lv_IdentificacionCliente, '')||Lv_Delimitador 
                 ||NVL(Lv_NombresCliente, '')||Lv_Delimitador 
                 );   

          END IF;

          Lv_DetalleFormatoRec := '';
         
          Ln_ContadorLineas  := Ln_ContadorLineas + 1;

        END LOOP;

    UTL_FILE.fclose(Lfile_Archivo);
  
    UTL_FILE.fclose(Lfile_ArchivoRechazados);

    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  

    Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');

    Lv_Cuerpo            := Lr_GetAliasPlantilla.PLANTILLA;

   -- Se mueve el reporte zipeado desde el directorio del dbserver al fileserver
    Lv_reponse:= DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_HTTPPOSTMULTIPART(Lc_Parametros.VALOR2,
                                                                         Lc_Directory.DIRECTORY_PATH||Lv_NombreArchivoGz,
                                                                         Lv_NombreArchivoZip,
                                                                         LvPathAdicional,
                                                                         Lv_CodigoApp,
                                                                         Lv_CodigoPath);
                                                
    Lv_Comparacion := DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_CONTAINS(Lv_reponse,'200');

    IF Lv_Comparacion = 'OK' THEN
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos+', 
                                                  'FNKG_RECAUDACIONES.P_GEN_FORMATO_ENV_REC', 
                                                  'RESPUESTA DEL WS NFS: '||Lv_reponse);

      
      apex_json.parse (Lv_reponse);
      for i in 1 .. apex_json.get_count('data') loop
        Pv_PathNFS := apex_json.get_varchar2('data[%d].pathFile', p0=>i);
      end loop;
      Pv_Error := apex_json.get_varchar2('status');
     
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio, 
                                              Lv_NombreArchivoGz);

    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_AsuntoClientesSinFormato, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio, 
                                              Lv_NombreArchivoRech);
      

    ELSE
      Pv_Error       := 'ERROR';
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos+', 
                                                  'FNKG_RECAUDACIONES.P_GEN_FORMATO_ENV_REC', 
                                                  'ERROR EN RESPUESTA DEL WS NFS: '||Lv_reponse);
    END IF;
    
   UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoGz);

   UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoRech);

   EXCEPTION
     WHEN OTHERS THEN
       --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_RECAUDACIONES.P_GEN_FORMATO_ENV_REC', 
                                                    'FNKG_RECAUDACIONES.P_GEN_FORMATO_ENV_REC', 
                                                    ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                                    ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);     

  END P_GEN_FORMATO_ENV_REC;

  FUNCTION F_GET_SALDO_CLIENTE(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_IdentificacionCliente  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE)
  RETURN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE
  IS
    CURSOR Lrf_GetSaldoCliente(Cv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_IdentificacionCliente  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE) IS
      SELECT ROUND(SUM(NVL(VECR.SALDO,0)), 2)
      FROM DB_COMERCIAL.INFO_PERSONA                   IPE  
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPE.ID_PERSONA              = IPER.PERSONA_ID
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO                IPT  ON IPT.PERSONA_EMPRESA_ROL_ID  = IPER.ID_PERSONA_ROL
      LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO        IOG  ON IOG.ID_OFICINA              = IPER.OFICINA_ID
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO             IC   ON IC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO             AFP  ON AFP.ID_FORMA_PAGO           = IC.FORMA_PAGO_ID
      LEFT JOIN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VECR ON VECR.PUNTO_ID=IPT.ID_PUNTO
      WHERE IOG.EMPRESA_ID           = Cv_EmpresaCod
      AND AFP.DESCRIPCION_FORMA_PAGO = 'RECAUDACION'
      AND IC.FORMA_PAGO_ID IS NOT NULL
      AND VECR.SALDO>0
      AND IPE.IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente
      group by IPE.IDENTIFICACION_CLIENTE;
    
    
      Lf_GetSaldoCliente DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE := 0.00;
  BEGIN
    
    IF Lrf_GetSaldoCliente%ISOPEN THEN
      CLOSE Lrf_GetSaldoCliente;
    END IF;
    --
    OPEN Lrf_GetSaldoCliente(Fv_EmpresaCod,Fv_IdentificacionCliente);
    --
    FETCH Lrf_GetSaldoCliente INTO Lf_GetSaldoCliente;
    --
    CLOSE Lrf_GetSaldoCliente;
    --
    IF Lf_GetSaldoCliente IS NULL THEN
      Lf_GetSaldoCliente  := 0;
    END IF;
    --
    RETURN Lf_GetSaldoCliente;
  
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_SALDO_CLIENTE', 
                                          'No se pudo obtener saldo cliente' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      Lf_GetSaldoCliente := 0;
      RETURN Lf_GetSaldoCliente;
      
  END F_GET_SALDO_CLIENTE;


  FUNCTION F_GET_FORMATOS_REC(
    Fv_CodEmpresa         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.EMPRESA_COD%TYPE,
    Fv_CanalRecaudacion   IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CANAL_RECAUDACION_ID%TYPE,
    Fv_EsCabecera         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ES_CABECERA%TYPE)
  RETURN C_FormatosRecaudacion
  IS
    --
    Lrf_FormatosRecaudacion C_FormatosRecaudacion;
    --
  BEGIN

    OPEN Lrf_FormatosRecaudacion FOR 
      SELECT AFR.TIPO_CAMPO, 
             AFR.CONTENIDO, 
             AFR.LONGITUD, 
             AFR.CARACTER_RELLENO, 
             AFR.POSICION, 
             AFR.TIPO_DATO, 
             AFR.ORIENTACION_CARACTER_RELLENO, 
             AFR.LONGITUD_TOTAL 
      FROM   DB_FINANCIERO.ADMI_FORMATO_RECAUDACION AFR
      WHERE AFR.EMPRESA_COD          = Fv_CodEmpresa
      AND   AFR.ES_CABECERA          = Fv_EsCabecera
      AND   AFR.CANAL_RECAUDACION_ID = Fv_CanalRecaudacion;
    --
  RETURN Lrf_FormatosRecaudacion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lrf_FormatosRecaudacion := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_FORMATOS_REC', 
                                          'No se pudo obtener los formatos de recaudacion' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lrf_FormatosRecaudacion;
    --
  END F_GET_FORMATOS_REC;


  FUNCTION F_GET_VALOR_FORMAT(
    Fv_Contenido                        IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE,
    Fv_TipoCampo                        IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_CAMPO%TYPE,
    Fv_Longitud                         IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD%TYPE,
    Fv_CaracterRelleno                  IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CARACTER_RELLENO%TYPE,
    Fv_OrientacionCaracterRelleno       IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ORIENTACION_CARACTER_RELLENO%TYPE,
    Fv_ContenidoAdicional               IN  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE)
  RETURN VARCHAR2
  IS
    --
    Lv_ContenidoFormateado  VARCHAR2(100) := '';
    Lv_MsnError             VARCHAR2(2000):= '';
    Lv_ValorEnteroDecimal   VARCHAR2(200) ;
    Lrf_SplitEnteroDecimal  SYS_REFCURSOR ;
    --
  BEGIN

          IF Fv_TipoCampo = 'F' THEN

            IF Fv_OrientacionCaracterRelleno = 'I' THEN

              Lv_ContenidoFormateado := LPAD(Fv_Contenido, Fv_Longitud, Fv_CaracterRelleno);
            ELSE
              Lv_ContenidoFormateado := RPAD(Fv_Contenido, Fv_Longitud, Fv_CaracterRelleno);
            END IF;

          ELSE
            CASE 
              --
              WHEN Fv_Contenido = 'AAAAMMDD' THEN
                --
                Lv_ContenidoFormateado   := TO_CHAR(SYSDATE, 'YYYYMMDD');
                --
              WHEN Fv_Contenido = 'AAAAMM' THEN 
                --
                Lv_ContenidoFormateado   := TO_CHAR(SYSDATE, 'YYYYMM');
                --
              WHEN Fv_Contenido = 'DD' THEN 
                --
                Lv_ContenidoFormateado   := TO_CHAR(SYSDATE, 'DD');
                --
              WHEN Fv_Contenido IN ('TR','IDT','NOM','TI') THEN
                --
                IF Fv_OrientacionCaracterRelleno = 'I' THEN

                  Lv_ContenidoFormateado := LPAD(Fv_ContenidoAdicional, Fv_Longitud, Fv_CaracterRelleno);

                ELSE

                  Lv_ContenidoFormateado := RPAD(Fv_ContenidoAdicional, Fv_Longitud, Fv_CaracterRelleno);

                END IF;
                --
              ELSE
                --
                IF INSTR(Fv_ContenidoAdicional,',') > 0 THEN
                  FNCK_CONSULTS.P_SPLIT_CLOB(Fv_ContenidoAdicional, ',' , Lrf_SplitEnteroDecimal, Lv_MsnError);
                ELSE
                  FNCK_CONSULTS.P_SPLIT_CLOB(Fv_ContenidoAdicional, '.' , Lrf_SplitEnteroDecimal, Lv_MsnError);
                END IF;
                --Itera el ref_cursor para obtener parte entera y decimal
                LOOP
                  --
                  FETCH
                    Lrf_SplitEnteroDecimal
                  INTO
                    Lv_ValorEnteroDecimal;
                  EXIT
                    WHEN Lrf_SplitEnteroDecimal%NOTFOUND;
                
                  Lv_ContenidoFormateado := Lv_ContenidoFormateado || Lv_ValorEnteroDecimal;
                  Lv_ContenidoFormateado := TRIM(Lv_ContenidoFormateado);
                END LOOP;

                IF Fv_OrientacionCaracterRelleno = 'I' THEN

                  Lv_ContenidoFormateado := LPAD(Lv_ContenidoFormateado, Fv_Longitud, Fv_CaracterRelleno);

                ELSE

                  Lv_ContenidoFormateado := RPAD(Lv_ContenidoFormateado, Fv_Longitud, Fv_CaracterRelleno);

                END IF;
                --
            END CASE; 

          END IF;
    --
  RETURN Lv_ContenidoFormateado;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_VALOR_FORMAT', 
                                          'No se pudo obtener el valor con formato' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_ContenidoFormateado;
    --
  END F_GET_VALOR_FORMAT;


  FUNCTION F_GET_SALDO_RECAUDADO(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE
  IS
    CURSOR Lrf_GetSaldoCliente(Cv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT ROUND(SUM(FNKG_RECAUDACIONES.F_GET_SALDO_CLIENTE(Cv_EmpresaCod,IPE.IDENTIFICACION_CLIENTE)),2)
      FROM DB_COMERCIAL.INFO_PERSONA                   IPE  
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPE.ID_PERSONA              = IPER.PERSONA_ID
      LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO        IOG  ON IOG.ID_OFICINA              = IPER.OFICINA_ID
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO             IC   ON IC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO             AFP  ON AFP.ID_FORMA_PAGO           = IC.FORMA_PAGO_ID
      WHERE IOG.EMPRESA_ID           = Cv_EmpresaCod
      AND AFP.DESCRIPCION_FORMA_PAGO = 'RECAUDACION'
      AND IC.FORMA_PAGO_ID IS NOT NULL;
    
    
      Lf_GetSaldoCliente DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE := 0.00;

  BEGIN
    
    IF Lrf_GetSaldoCliente%ISOPEN THEN
      CLOSE Lrf_GetSaldoCliente;
    END IF;
    --
    OPEN Lrf_GetSaldoCliente(Fv_EmpresaCod);
    --
    FETCH Lrf_GetSaldoCliente INTO Lf_GetSaldoCliente;
    --
    CLOSE Lrf_GetSaldoCliente;
    --
    IF Lf_GetSaldoCliente IS NULL THEN
      Lf_GetSaldoCliente  := 0;
    END IF;
    --
    RETURN Lf_GetSaldoCliente;
  
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_SALDO_RECAUDADO', 
                                          'No se pudo obtener saldo recaudado' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      Lf_GetSaldoCliente := 0;
      RETURN Lf_GetSaldoCliente;
      
  END F_GET_SALDO_RECAUDADO;



  FUNCTION F_GET_TOTAL_CLIENTES_REC(
    Fv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2
  IS
    CURSOR Lrf_GetTotalClientes(Cv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT TO_CHAR(COUNT(IPE.ID_PERSONA))
      FROM DB_COMERCIAL.INFO_PERSONA                   IPE  
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPE.ID_PERSONA              = IPER.PERSONA_ID
      LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO        IOG  ON IOG.ID_OFICINA              = IPER.OFICINA_ID
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO             IC   ON IC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO             AFP  ON AFP.ID_FORMA_PAGO           = IC.FORMA_PAGO_ID
      WHERE IOG.EMPRESA_ID           = Cv_EmpresaCod
      AND AFP.DESCRIPCION_FORMA_PAGO = 'RECAUDACION'
      AND IC.FORMA_PAGO_ID IS NOT NULL;
    
    
      Lv_GetTotalClientes VARCHAR2(100) := '0';
  BEGIN
    
    IF Lrf_GetTotalClientes%ISOPEN THEN
      CLOSE Lrf_GetTotalClientes;
    END IF;
    --
    OPEN Lrf_GetTotalClientes(Fv_EmpresaCod);
    --
    FETCH Lrf_GetTotalClientes INTO Lv_GetTotalClientes;
    --
    CLOSE Lrf_GetTotalClientes;
    --
    IF Lv_GetTotalClientes IS NULL THEN
      Lv_GetTotalClientes  := '0';
    END IF;
    --
    RETURN Lv_GetTotalClientes;
  
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'DB_FINANCIERO.FNKG_RECAUDACIONES.F_GET_TOTAL_CLIENTES_REC', 
                                          'No se pudo obtener total clientes' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      Lv_GetTotalClientes := '0';
      RETURN Lv_GetTotalClientes;
      
  END F_GET_TOTAL_CLIENTES_REC;

PROCEDURE P_CONTABILIZAR ( Pv_NoCia         IN VARCHAR2,
                           Pv_Fecha         IN VARCHAR2,
                           Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    CURSOR C_TIPO_PAGO_RECAUDACION IS
      --
      SELECT APD.ID_PARAMETRO_DET, 
        APD.PARAMETRO_ID, 
        APD.VALOR1 PARAMETRO_TIPO_DOC, 
        APD.VALOR2 PREFIJO_TIPO_DOCUMENTO, 
        APD.VALOR3 PREFIO_FORMA_PAGO, 
        APD.VALOR4 TIPO_PROCESO, 
        APD.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO    = APD.PARAMETRO_ID 
      AND APC.ESTADO            = NVL(Gv_EstadoAtivo, APC.ESTADO ) 
      AND APD.ESTADO            = NVL(Gv_EstadoAtivo, APD.ESTADO ) 
      AND APC.NOMBRE_PARAMETRO  = NVL(Gv_NombreParametro, APC.NOMBRE_PARAMETRO ) 
      AND APD.DESCRIPCION       = NVL(Gv_NombreProceso, APD.DESCRIPCION ) 
      AND APD.VALOR1            = NVL(Gv_ParamTipoDoc, APD.VALOR1 ) 
      AND APD.EMPRESA_COD       = NVL(Pv_NoCia, APD.EMPRESA_COD );

    --
    CURSOR C_RECAUDACIONES ( Cv_CodTipoDocFin VARCHAR2,
                             Cv_CodFormaPago  VARCHAR2) IS
      SELECT PD.ID_PAGO_DET, 
        FP.DESCRIPCION_FORMA_PAGO,
        FP.CODIGO_FORMA_PAGO,
        PD.VALOR_PAGO,
        RD.FE_CREACION,
        P.NUMERO_PAGO,
        PD.NUMERO_CUENTA_BANCO,
        (SELECT LOGIN
         FROM DB_COMERCIAL.INFO_PUNTO PTO
         WHERE PTO.ID_PUNTO = P.PUNTO_ID ) LOGIN,
        P.USR_CREACION,
        OFI.NOMBRE_OFICINA,
        PD.CUENTA_CONTABLE_ID,
        PD.NUMERO_REFERENCIA,
        P.OFICINA_ID,
        EMP.PREFIJO,
        TDF.CODIGO_TIPO_DOCUMENTO,
        PD.PAGO_ID, 
        PD.FORMA_PAGO_ID,
        P.TIPO_DOCUMENTO_ID, 
        EMP.COD_EMPRESA,
        PD.FE_DEPOSITO,
        P.PUNTO_ID,
        P.ESTADO_PAGO,
        0
      FROM DB_FINANCIERO.INFO_PAGO_DET PD,
        DB_FINANCIERO.INFO_PAGO_CAB P,
        DB_FINANCIERO.INFO_RECAUDACION_DET RD,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF,
        DB_COMERCIAL.ADMI_FORMA_PAGO FP,
        DB_COMERCIAL.INFO_OFICINA_GRUPO OFI,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP
      WHERE PD.PAGO_ID = P.ID_PAGO
      AND P.RECAUDACION_DET_ID = RD.ID_RECAUDACION_DET 
      AND P.TIPO_DOCUMENTO_ID = TDF.ID_TIPO_DOCUMENTO
      AND PD.FORMA_PAGO_ID = FP.ID_FORMA_PAGO
      AND P.OFICINA_ID = OFI.ID_OFICINA
      AND OFI.EMPRESA_ID = EMP.COD_EMPRESA
      AND P.EMPRESA_ID = Pv_NoCia
      AND TDF.CODIGO_TIPO_DOCUMENTO = Cv_CodTipoDocFin
      AND FP.CODIGO_FORMA_PAGO = Cv_CodFormaPago
      --
      AND RD.FE_CREACION >= TO_TIMESTAMP(Pv_Fecha||' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
      AND RD.FE_CREACION <= TO_TIMESTAMP(Pv_Fecha||' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
      --
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                      WHERE MDA.DOCUMENTO_ORIGEN_ID = PD.ID_PAGO_DET
                      AND MDA.ESTADO = 'M')
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
                  AND APC.NOMBRE_PARAMETRO = Gv_NombreParametro
                  AND APC.ESTADO             = Gv_EstadoAtivo
                  AND APD.ESTADO             = Gv_EstadoAtivo
                  AND APD.DESCRIPCION        = Gv_NombreProceso
                  AND APD.VALOR1             = Gv_ParamEstadoPago
                  );
    Le_Error         EXCEPTION;
    --
    Lr_CabPlantillaCon DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    Lr_CuentaContable  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    Lr_DetallePago     DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;
    --
    Lr_MigraArckmm      NAF47_TNET.MIGRA_ARCKMM%ROWTYPE;
    Lr_MigraArcgae      NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraDocAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --

  BEGIN
    FOR Lr_TipoRecaudacion IN C_TIPO_PAGO_RECAUDACION LOOP
      
      IF Lr_TipoRecaudacion.Prefijo_Tipo_Documento IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Tipo Documento (Valor2) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_TipoRecaudacion.Prefio_Forma_Pago IS NULL THEN
        Pv_MensajeError := 'No se ha definido prefijo Forma de Pago (Valor3) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      ELSIF Lr_TipoRecaudacion.Tipo_Proceso IS NULL THEN
        Pv_MensajeError := 'No se ha definido Tipo de Proceso (Valor4) en Parametro: '||Gv_NombreParametro||', proceso: '||Gv_NombreProceso;
        RAISE Le_Error;
      END IF;
      -- se inicializa variable registro migra arckmm
      Lr_MigraArckmm := null;

      -- se recuperan datos de la cabecera de plantilla con la que se va a trabajr.
      Lr_CabPlantillaCon := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB_COD( Pv_NoCia, 
                                                                                                        Lr_TipoRecaudacion.Prefio_Forma_Pago,
                                                                                                        Lr_TipoRecaudacion.Prefijo_Tipo_Documento,
                                                                                                        Lr_TipoRecaudacion.Tipo_Proceso);
      --
      IF Lr_CabPlantillaCon.ID_PLANTILLA_CONTABLE_CAB IS NULL THEN
        Pv_MensajeError := 'No se ha definido Plantilla contable para documento '||Lr_TipoRecaudacion.Prefijo_Tipo_Documento||', forma pago: '||Lr_TipoRecaudacion.Prefio_Forma_Pago||' y tipo proceso: '||Lr_TipoRecaudacion.Tipo_Proceso;
        RAISE Le_Error;
      END IF;
      --
      FOR Lr_DetallePago IN C_RECAUDACIONES ( Lr_TipoRecaudacion.Prefijo_Tipo_Documento,
                                              Lr_TipoRecaudacion.Prefio_Forma_Pago) LOOP
        -- se inicializa variable registro documento asociado.
        Lr_MigraDocAsociado := NULL;

        -- si no se ha generado cabecera para esta forma de pago, se genera.
        IF Lr_MigraArckmm.Id_Migracion IS NULL THEN

          -- se recupera información de cuenta bancaria
          Lr_CuentaContable := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE( Lr_DetallePago.CUENTA_CONTABLE_ID );

          -- se inicializan los campos a insertar
          Lr_MigraArckmm.No_Cia          := Pv_NoCia;
          Lr_MigraArckmm.No_Cta          := Lr_CuentaContable.NO_CTA;
          Lr_MigraArckmm.Tipo_Doc        := Lr_CabPlantillaCon.TIPO_DOC;
          Lr_MigraArckmm.Fecha           := TRUNC(Lr_DetallePago.Fe_Creacion);
          Lr_MigraArckmm.Ano             := TO_NUMBER(TO_CHAR(Lr_MigraArckmm.Fecha,'YYYY'));
          Lr_MigraArckmm.Mes             := TO_NUMBER(TO_CHAR(Lr_MigraArckmm.Fecha,'MM'));
          Lr_MigraArckmm.no_fisico       := Lr_DetallePago.Numero_Referencia ;   
          Lr_MigraArckmm.origen          := Lr_DetallePago.Prefijo;
          Lr_MigraArckmm.usuario_creacion:= Lr_DetallePago.Usr_Creacion;
          Lr_MigraArckmm.fecha_doc       := TRUNC(Lr_DetallePago.Fe_Creacion);
          Lr_MigraArckmm.Cod_Diario      := Lr_CabPlantillaCon.Cod_Diario;
          Lr_MigraArckmm.Id_Forma_Pago   := Lr_DetallePago.Forma_Pago_Id;
          Lr_MigraArckmm.Id_Oficina_Facturacion := Lr_DetallePago.Oficina_Id;
          Lr_MigraArckmm.Comentario      := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_COMENTARIO(Lr_DetallePago, '', Lr_CabPlantillaCon.FORMATO_GLOSA,null,null);
          Lr_MigraArckmm.Monto           := 0;
          Lr_MigraArckmm.Estado          := 'P';
          Lr_MigraArckmm.Conciliado      := 'N';
          Lr_MigraArckmm.Procedencia     := 'C';
          Lr_MigraArckmm.Ind_otromov     := 'S';
          Lr_MigraArckmm.Moneda_cta      := 'P';
          Lr_MigraArckmm.Tipo_cambio     := '1';
          Lr_MigraArckmm.T_camb_c_v      := 'C';
          Lr_MigraArckmm.Ind_otros_meses := 'N';
          Lr_MigraArckmm.Ind_Division    := 'N';
          Lr_MigraArckmm.No_Docu         := Lr_DetallePago.Id_Pago_Det;
          --
          Lr_MigraArckmm.Id_Migracion := NAF47_TNET.TRANSA_ID.MIGRA_CK (Pv_NoCia);
          --
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
            --
        END IF;
        --
        -- generación detalle de Contabilización.
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO( Lr_CabPlantillaCon,
                                                                         Lr_DetallePago,
                                                                         Lr_MigraArckmm, 
                                                                         Lr_MigraArcgae, 
                                                                         Pv_MensajeError);
        --
        IF Pv_MensajeError != 'OK' THEN
          RAISE Le_Error;
        ELSE
          Pv_MensajeError := NULL;
          -- se acumulan los detalles de documentos que se estan contabilizando
          Lr_MigraArckmm.Monto := NVL(Lr_MigraArckmm.Monto,0) + NVL(Lr_DetallePago.Valor_Pago,0); 
        END IF;
        --
        Lr_MigraDocAsociado.DOCUMENTO_ORIGEN_ID := Lr_DetallePago.ID_PAGO_DET;
        Lr_MigraDocAsociado.MIGRACION_ID        := Lr_MigraArckmm.ID_MIGRACION;
        Lr_MigraDocAsociado.TIPO_DOC_MIGRACION  := Lr_CabPlantillaCon.COD_DIARIO;
        Lr_MigraDocAsociado.NO_CIA              := Pv_NoCia;
        Lr_MigraDocAsociado.FORMA_PAGO_ID       := Lr_CabPlantillaCon.ID_FORMA_PAGO;
        Lr_MigraDocAsociado.TIPO_DOCUMENTO_ID   := Lr_DetallePago.TIPO_DOCUMENTO_ID;
        Lr_MigraDocAsociado.ESTADO              := 'M';
        Lr_MigraDocAsociado.TIPO_MIGRACION      := 'CK';
        Lr_MigraDocAsociado.USR_CREACION        := Lr_DetallePago.USR_CREACION;
        Lr_MigraDocAsociado.FE_CREACION         := SYSDATE;
        --
        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO( Lr_MigraDocAsociado,
                                                               'I', 
                                                               Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        -- se marca el pago como contabilizado
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.MARCA_CONTABILIZADO_PAGO(Lr_DetallePago.ID_PAGO_DET,
                                                                             Lr_DetallePago.PAGO_ID, 
                                                                             Lr_DetallePago.ESTADO_PAGO);
        --

      END LOOP;
      --
      -- se actualiza el total del documento generado
      UPDATE MIGRA_ARCKMM
      SET MONTO = Lr_MigraArckmm.Monto
      WHERE ID_MIGRACION = Lr_MigraArckmm.Id_Migracion
      AND NO_CIA = Lr_MigraArckmm.No_Cia;
      --
    END LOOP; -- fin detalle parametros
    --
    COMMIT;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en FNKG_RECAUDACIONES.P_CONTABILIZAR. '||Pv_MensajeError;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNKG_RECAUDACIONES.P_CONTABILIZAR', 
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en FNKG_RECAUDACIONES.P_CONTABILIZAR. '||SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR( 'Telcos+', 
                                            'FNKG_RECAUDACIONES.P_CONTABILIZAR', 
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

  END P_CONTABILIZAR;

END FNKG_RECAUDACIONES;
/
