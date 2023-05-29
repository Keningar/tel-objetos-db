CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_EN AS 

 /*
  * Documentación para TYPE 'TypeClientesFacturar'.
  *
  * Tipo de datos para el retorno de la información correspondiente a los documentos a notificar a los usuarios
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE TypeClientesFacturar IS RECORD (
    empresa_id             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
    id_oficina             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    id_persona_rol         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    persona_id             DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    login                  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    empresa_rol_id         DB_COMERCIAL.INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE,
    rol_id                 DB_GENERAL.ADMI_ROL.ID_ROL%TYPE,
    descripcion_rol        DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE,
    descripcion_tipo_rol   DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
    id_punto               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    CLIENTE                DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    IDENTIFICACION_CLIENTE DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    estado                 DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    es_padre_facturacion   DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.ES_PADRE_FACTURACION%TYPE,
    gasto_administrativo   DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.GASTO_ADMINISTRATIVO%TYPE
  );

 /*
  * Documentación para TYPE 'T_ClientesFacturar'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE T_ClientesFacturar IS TABLE OF TypeClientesFacturar INDEX BY PLS_INTEGER;
  --
  --
 /*
  * Documentación para TYPE 'TypeServiciosAsociados'.
  * Record que me permite almancernar la informacion devuelta de los servicios asociados al punto de facturación.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE TypeServiciosAsociados IS RECORD (
    id_servicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
    producto_id           ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    plan_id               INFO_PLAN_CAB.ID_PLAN%TYPE,
    punto_id              INFO_PUNTO.ID_PUNTO%TYPE,
    cantidad              DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
    precio_venta          DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    porcentaje_descuento  DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE,
    valor_descuento       DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE,
    punto_facturacion_id  INFO_PUNTO.ID_PUNTO%TYPE,
    estado                DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
  );

 /*
  * Documentación para TYPE 'T_ServiciosAsociados'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE T_ServiciosAsociados IS TABLE OF TypeServiciosAsociados INDEX BY PLS_INTEGER;
  --
  --
 /*
  * Documentación para TYPE 'TypeSolicitudes'.
  * Record que me permite almancernar la informacion devuelta de las solicitudes asociados al punto de facturación.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  Type TypeSolicitudes IS RECORD (
    id_detalle_solicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    descripcion_solicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    estado_solicitud      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE
  );

 /*
  * Documentación para TYPE 'T_Solicitudes'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE T_Solicitudes IS TABLE OF TypeSolicitudes INDEX BY PLS_INTEGER;
 --
 --
 /*
  * Documentación para TYPE 'TypeSolicitudesReproceso'.
  *
  * Tipo de datos para el retorno de la información correspondiente a las solicitudes
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE TypeSolicitudesReproceso IS RECORD (
    ID_DETALLE_SOLICITUD          DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,         
    SERVICIO_ID                   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,         
    TIPO_SOLICITUD_ID             DB_COMERCIAL.INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE,          
    MOTIVO_ID                     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,         
    USR_CREACION                  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,   
    FE_CREACION                   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.FE_CREACION%TYPE,  
    PRECIO_DESCUENTO              DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PRECIO_DESCUENTO%TYPE,         
    PORCENTAJE_DESCUENTO          DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,         
    TIPO_DOCUMENTO                DB_COMERCIAL.INFO_DETALLE_SOLICITUD.TIPO_DOCUMENTO%TYPE,    
    OBSERVACION                   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE, 
    ESTADO                        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,   
    USR_RECHAZO                   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_RECHAZO%TYPE,   
    FE_RECHAZO                    DB_COMERCIAL.INFO_DETALLE_SOLICITUD.FE_RECHAZO%TYPE,   
    DETALLE_PROCESO_ID            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.DETALLE_PROCESO_ID%TYPE,         
    FE_EJECUCION                  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.FE_EJECUCION%TYPE,   
    ELEMENTO_ID                   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ELEMENTO_ID%TYPE       

  );

 /*
  * Documentación para TYPE 'T_SolicitudesReproceso'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  TYPE T_SolicitudesReproceso IS TABLE OF TypeSolicitudesReproceso INDEX BY PLS_INTEGER;
  --
  --
 /*
  * Documentación para el PROCEDURE 'P_PROCESAR_INFORMACION'.
  *
  * Procedimiento para procesar la información de los clientes a facturar
  *
  * @param Prf_ClientesFacturar        IN T_ClientesFacturar  (Cursor que contiene los clientes a facturar)
  * @param Pv_MesEmisionNumeros        IN VARCHAR2  (Mes de emision de la factura en numero)
  * @param Pv_MesEmisionLetras         IN VARCHAR2  (Mes de emision de la factura en letras)
  * @param Pv_AnioEmision              IN VARCHAR2  (Año de emision de la factura)
  * @param Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de la empresa a facturar)
  * @param Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE (Id de la oficina del cliente)
  * @param Pv_FeEmision                IN VARCHAR2  (Fecha de emision de la factura)
  * @param Pn_Porcentaje               IN NUMBER  (Porcentaje del IVA que se va a facturar)
  * @param Pn_RecordCount              IN OUT NUMBER  (Cantidad de clientes que se les procesó la información de facturación)
  * @param Pn_ClientesFacturados       IN OUT NUMBER  (Cantidad de clientes facturados)
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
  PROCEDURE P_PROCESAR_INFORMACION(
      Prf_ClientesFacturar        IN T_ClientesFacturar,
      Pv_MesEmisionNumeros        IN VARCHAR2,
      Pv_MesEmisionLetras         IN VARCHAR2,
      Pv_AnioEmision              IN VARCHAR2,
      Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pv_FeEmision                IN VARCHAR2,
      Pn_Porcentaje               IN NUMBER,
      Pn_RecordCount              IN OUT NUMBER,
      Pn_ClientesFacturados       IN OUT NUMBER);

 /*
  * Documentación para el PROCEDURE 'P_FACTURACION_MENSUAL'.
  *
  * Procedimiento para realizar la facturación mensual de todos los puntos
  *
  * @param Pv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (Código de la empresa que va a ejecutar el proceso de facturación)
  * @param Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE  (Descripción del impuesto a facturar)
  * @param Pv_TipoFacturacion     IN VARCHAR2  (Tipo de ciclo de facturación a ejecutar)
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 05-04-2023 - Se modifica el código de plantilla para envío de notificaciones de la empresa Ecuanet (FAC_MASIVA_EN).
  *
  */
  PROCEDURE P_FACTURACION_MENSUAL( Pn_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE,
                                   Pv_TipoFacturacion     IN VARCHAR2);

END FNCK_FACTURACION_MENSUAL_EN;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_EN
AS

--
  PROCEDURE P_FACTURACION_MENSUAL( Pn_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE,
                                   Pv_TipoFacturacion     IN VARCHAR2)
  IS
  
  --Consulta del ciclo de facturación
  CURSOR C_ConsultaCiclos (Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT AC.ID_CICLO,
             UPPER(TRIM(AC.NOMBRE_CICLO)) as NOMBRE_CICLO, 
             1 as BANDERA
      FROM DB_FINANCIERO.ADMI_CICLO AC
      WHERE TO_CHAR(AC.FE_INICIO,'DD') = TO_CHAR(SYSDATE,'DD')
      AND   AC.ESTADO                  IN ('Activo','Inactivo')
      AND   AC.EMPRESA_COD             = Cn_EmpresaCod;

  --Variable cursor de los ciclos
  Lc_ConsultaCiclos C_ConsultaCiclos%ROWTYPE;

  --Listados
  C_PuntosFacturar            SYS_REFCURSOR;

  --Tipos de equivalentes a las tablas
  Lv_PrefijoEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_IdOficina                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
  Lr_InfoCicloFacturacion     DB_FINANCIERO.INFO_CICLO_FACTURADO%ROWTYPE;

  --Variables
  Ln_Porcentaje               NUMBER;
  Lv_UsrCreacion              VARCHAR2(10):='telcos';

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);

  --Tipo para el BULK
  Cn_Puntos_Facturar          T_ClientesFacturar;
  Ln_RecordCount              NUMBER(04):=0;

  --Generacion de fecha emision
  Lv_FeEmision                VARCHAR2(20);
  Ln_MesEmision               VARCHAR2(20);
  Lv_MesEmision               DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE;
  Lv_AnioEmision              DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE;

  --Informacion del ciclo
  Lv_NombreCiclo              DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE;
  Ln_CantidadCiclo            NUMBER;

  --Query de consulta del script
  Lv_Consulta                 VARCHAR2(30000);
  --
  --
  Ln_ClientesFacturados       NUMBER := 0;
  Lv_CuerpoMensaje            CLOB;
  --
BEGIN

  OPEN C_ConsultaCiclos(Pn_EmpresaCod);
    FETCH C_ConsultaCiclos INTO Lc_ConsultaCiclos;
  CLOSE C_ConsultaCiclos;

  --Validacion de Ciclo de Facturación
  IF Lc_ConsultaCiclos.BANDERA IS NULL THEN
    RETURN;
  END IF;

  --Seteamos el porcentaje de IVA
  --Se debe recibir como parametro el IVA a facturar
  Ln_Porcentaje:= DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO_POR_DESC(Pv_DescripcionImpuesto);

  --Generamos la consulta como string para segun el TipoFacturacion procesar

  Lv_Consulta := 'SELECT 
    iog.empresa_id, 
    iog.id_oficina, 
    iper.id_persona_rol, 
    iper.persona_id, 
    ipu.login, 
    iper.empresa_rol_id, 
    ier.rol_id, 
    ar.descripcion_rol, 
    atr.descripcion_tipo_rol, 
    ipu.id_punto,
    CASE
      WHEN per.RAZON_SOCIAL IS NOT NULL THEN
        per.RAZON_SOCIAL
      ELSE
        CONCAT(per.NOMBRES, CONCAT('' '', per.APELLIDOS))
    END AS CLIENTE,
    per.IDENTIFICACION_CLIENTE,
    ipu.estado,'||q'['S']'||' as es_padre_facturacion,' || q'['N']'||'as gasto_administrativo
    FROM DB_COMERCIAL.info_oficina_grupo iog 
    JOIN DB_COMERCIAL.info_persona_empresa_rol iper ON iper.oficina_id=iog.id_oficina 
    JOIN DB_COMERCIAL.info_persona per ON per.id_persona=iper.persona_id 
    JOIN DB_COMERCIAL.info_empresa_rol ier ON ier.id_empresa_rol=iper.empresa_rol_id 
    JOIN DB_GENERAL.admi_rol ar ON ar.id_rol=ier.rol_id 
    JOIN DB_GENERAL.admi_tipo_rol atr ON atr.id_tipo_rol=ar.tipo_rol_id 
    JOIN DB_COMERCIAL.info_punto ipu ON IPU.PERSONA_EMPRESA_ROL_ID=iper.id_persona_rol 
    JOIN DB_GENERAL.ADMI_SECTOR ASE ON ASE.ID_SECTOR=ipu.SECTOR_ID
    JOIN DB_GENERAL.ADMI_PARROQUIA AP ON AP.ID_PARROQUIA=ASE.PARROQUIA_ID
    JOIN DB_GENERAL.ADMI_CANTON AC ON AC.ID_CANTON=AP.CANTON_ID
    JOIN DB_COMERCIAL.info_servicio iser ON iser.PUNTO_FACTURACION_ID=ipu.id_punto 
    WHERE iog.empresa_id='||Pn_EmpresaCod||
    ' AND ier.empresa_cod='||Pn_EmpresaCod||
    ' AND (iper.estado='||q'['Activo']'||' OR iper.estado='||q'['Modificado']'||')
      AND EXISTS (
        SELECT null from DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda 
        WHERE ipda.punto_id=ipu.id_punto
        AND ipda.es_padre_facturacion='||q'['S']'||'
      )
      AND atr.descripcion_tipo_rol='||q'['Cliente']'||'
      AND ar.descripcion_rol='||q'['Cliente']'||'
      AND iser.ESTADO='||q'['Activo']'||'
      AND iser.cantidad>0 
      AND iser.ES_VENTA='||q'['S']'||'
      AND iser.precio_venta>0 
      AND iser.frecuencia_producto=1
      AND EXISTS (
        Select 1
        from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc,
             DB_COMERCIAL.ADMI_CARACTERISTICA ac
        where iperc.PERSONA_EMPRESA_ROL_ID=iper.id_persona_rol
          and AC.ID_CARACTERISTICA=IPERC.CARACTERISTICA_ID
          and iperc.ESTADO=''Activo''
          and IPERC.VALOR = '''||Lc_ConsultaCiclos.ID_CICLO||'''
          and AC.DESCRIPCION_CARACTERISTICA=''CICLO_FACTURACION''
      )';

     Lv_Consulta:= Lv_Consulta || ' group by iog.empresa_id, 
      iog.id_oficina, 
      iper.id_persona_rol, 
      iper.persona_id, 
      ipu.login, 
      iper.empresa_rol_id, 
      ier.rol_id, 
      ar.descripcion_rol, 
      atr.descripcion_tipo_rol, 
      ipu.id_punto, 
      ipu.estado,
      per.IDENTIFICACION_CLIENTE,
      per.NOMBRES,
      per.APELLIDOS,
      per.RAZON_SOCIAL';

  --Seteamos fe_emision
  DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_GENERAR_FECHA_EMISION_CICLOS(Lc_ConsultaCiclos.ID_CICLO,Lv_FeEmision,Lv_MesEmision,Ln_MesEmision,Lv_AnioEmision);

  --Previo a la ejecución del proceso de facturacion, se verifica , se valida o ingresa el log de la ejecución de la facturación
  Ln_CantidadCiclo:= 0;
  Lv_NombreCiclo  := Lc_ConsultaCiclos.NOMBRE_CICLO;
  Ln_CantidadCiclo:= DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_VERIFICAR_CICLO(Lv_NombreCiclo,UPPER(TRIM(Lv_MesEmision)),UPPER(TRIM(Lv_AnioEmision)),Pv_TipoFacturacion,Pn_EmpresaCod);

  --Inicializando variable de error
  Lv_InfoError:='';
  IF(Ln_CantidadCiclo>0)THEN
    --Escribir que el proceso ya se ejecutó
    Lv_InfoError:='F_VERIFICAR_CICLO, Ln_CantidadCiclo: '||Ln_CantidadCiclo ||
                    ', Ciclo ya procesado: Lv_NombreCiclo:'||Lv_NombreCiclo ||'-'||
                    'Lv_MesEmision:'||UPPER(TRIM(Lv_MesEmision))||'-'||
                    'Lv_AnioEmision'||UPPER(TRIM(Lv_AnioEmision));
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 'FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL', Lv_InfoError);
  ELSE

    --Si no hay un registro debemos crear la ejecucion del proceso
    Lr_InfoCicloFacturacion.ID_CICLO_FACTURADO  := DB_FINANCIERO.SEQ_INFO_CICLO_FACTURADO.NEXTVAL;
    Lr_InfoCicloFacturacion.CICLO_ID            := Lc_ConsultaCiclos.ID_CICLO;
    Lr_InfoCicloFacturacion.EMPRESA_COD         := Pn_EmpresaCod;
    Lr_InfoCicloFacturacion.MES_FACTURADO       := UPPER(TRIM(Lv_MesEmision));
    Lr_InfoCicloFacturacion.ANIO_FACTURADO      := Lv_AnioEmision;
    Lr_InfoCicloFacturacion.FE_EJE_INICIO       := SYSDATE;
    Lr_InfoCicloFacturacion.USR_CREACION        := Lv_UsrCreacion;
    --Se mete la información referente al proceso ejecutado
    Lr_InfoCicloFacturacion.PROCESO           := 'MENSUAL';
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_CICLO_FACTURACION(Lr_InfoCicloFacturacion,Lv_InfoError);

    --Guardamos la confirmación de la ejecución del paquete
    IF(Lv_InfoError IS NULL) THEN
      COMMIT;
    END IF;

    --Seteamos variables para obtener las numeraciones
    DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_PREFIJO_OFICINA(Pn_EmpresaCod,Lv_PrefijoEmpresa,Ln_IdOficina);

    --Se llama el cursor del BULK
    OPEN C_PuntosFacturar FOR Lv_Consulta;
    LOOP
      FETCH C_PuntosFacturar BULK COLLECT INTO Cn_Puntos_Facturar LIMIT 5000;
      --Llamada al proceso de escritura de la factura
      P_PROCESAR_INFORMACION (
      Cn_Puntos_Facturar,
      Ln_MesEmision,
      Lv_MesEmision,
      Lv_AnioEmision,
      Lv_PrefijoEmpresa,
      Ln_IdOficina,
      Lv_FeEmision,
      Ln_Porcentaje,
      Ln_RecordCount,
      Ln_ClientesFacturados
      );
      --Llamada al proceso de escritura de la factura
      EXIT WHEN C_PuntosFacturar%NOTFOUND;

    END LOOP;
    CLOSE C_PuntosFacturar;

    --Ha terminado el proceso
    Lr_InfoCicloFacturacion.FE_EJE_FIN:= SYSDATE;
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_CICLO_FACTURACION(Lr_InfoCicloFacturacion.ID_CICLO_FACTURADO,Lr_InfoCicloFacturacion,Lv_InfoError);

    IF Ln_RecordCount >=0 THEN
       COMMIT;
    END IF;
    --
    --
    --
    IF Ln_ClientesFacturados IS NOT NULL AND Ln_ClientesFacturados > 0 THEN
      --
      Lv_InfoError     := NULL;
      Lv_CuerpoMensaje := '<table class = ''cssTable'' align=''center'' >' ||
                            '<tr>' ||
                              '<th> Total de Clientes Facturados </th>' ||
                              '<td>' || Ln_ClientesFacturados || '</td>' ||
                            '</tr>' ||                            
                          '</table>';
      --
      --
      DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA(Lv_CuerpoMensaje, 'FAC_MASIVA_EN', Pn_EmpresaCod, Lv_InfoError);
      --
      --
      IF TRIM(Lv_InfoError) IS NOT NULL THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL', 
                                              Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
      --
      --
    END IF;
    --
  END IF;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 'FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL', 
                                                          DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));      
END P_FACTURACION_MENSUAL;
--
--
  PROCEDURE P_PROCESAR_INFORMACION(
      Prf_ClientesFacturar        IN T_ClientesFacturar,
      Pv_MesEmisionNumeros        IN VARCHAR2,
      Pv_MesEmisionLetras         IN VARCHAR2,
      Pv_AnioEmision              IN VARCHAR2,
      Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pv_FeEmision                IN VARCHAR2,
      Pn_Porcentaje               IN NUMBER,
      Pn_RecordCount              IN OUT NUMBER,
      Pn_ClientesFacturados       IN OUT NUMBER)
  AS
    --
    --CURSOR QUE RETORNA EL SECTOR_ID DEL PUNTO DE FACTURACION
    --COSTO DEL QUERY: 3
    CURSOR C_GetSectorByPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      --
      SELECT
        SECTOR_ID
      FROM
        DB_COMERCIAL.INFO_PUNTO
      WHERE
        ID_PUNTO = Cn_IdPunto;
      --
    -- C_GetTipoSolicitudReproceso - Costo Query: 5
    CURSOR C_GetValorCargoReproceso (Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
      IS
        SELECT TO_NUMBER(APD.VALOR2)
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO
        WHERE  APC.NOMBRE_PARAMETRO = 'CARGO REPROCESO DEBITO'
        AND    APC.ESTADO           = 'Activo'
        AND    APD.EMPRESA_COD      = Cn_EmpresaCod;
    --
    Lr_Punto                      TypeClientesFacturar;
    Ln_SimularionPorPorcentaje    NUMBER;
    Ln_SimulacionPorValor         NUMBER;
    Ln_DescuentoFacProDetalle     NUMBER;
    Ln_PrecioVentaFacProDetalle   NUMBER;
    Ln_ValorImpuesto              NUMBER;
    Lv_FeActivacion               VARCHAR2(100);

    Ln_IdDetalleSolicitud         DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
    Ln_PorcentajeDescuento        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE;
    Ln_Subtotal                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    Ln_SubtotalConImpuesto        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
    Ln_SubtotalDescuento          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE;
    Ln_ValorTotal                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinancieroDet DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinancieroImp DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
    Lr_InfoDocumentoFinancieroHis DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;

    Pv_MsnError                   VARCHAR2(5000);
    LV_BanderaPoseeDetalle        VARCHAR2(2);
    Lv_BanderaSolicitud           VARCHAR2(2);

   --Variables de Servicios
    Lc_ServiciosFacturar          SYS_REFCURSOR;
    Lr_Servicios                  TypeServiciosAsociados;
    Lt_ServiciosFacturar          T_ServiciosAsociados;

    --Variables de Solicitudes
    Lc_Solicitud                  SYS_REFCURSOR;
    Lr_Solicitud                  TypeSolicitudes;
    Lt_Solicitud                  T_Solicitudes;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError                  VARCHAR2(2000);

    --Variables de la numeracion
    Lrf_Numeracion                DB_FINANCIERO.FNKG_TYPES.Lrf_AdmiNumeracion;
    Lr_AdmiNumeracion             DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
    Lt_Numeracion                 DB_FINANCIERO.FNKG_TYPES.T_Numeraciones;

    --Variables de Solicitudes de reproceso
    Lrf_GetSolicitudesReproceso   SYS_REFCURSOR;
    Lr_SolicitudReprocesoDebito   TypeSolicitudesReproceso;
    Lt_SolicitudReproceso         T_SolicitudesReproceso;

    Lv_EsMatriz                   DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE;
    Lv_EsOficinaFacturacion       DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE;
    Lv_CodigoNumeracion           DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE;

    Lv_Numeracion                 VARCHAR2(1000);
    Lv_Secuencia                  VARCHAR2(1000);

    Ln_IdImpuesto                 DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;
    --
    Ln_SectorId                   DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE;
    Ln_DescuentoCompensacion      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE;
    Ln_PtoSolicitudReprocesoId    NUMBER := 0;
    Ln_CantidadSolReproceso       NUMBER := 0;
    Ln_PrecioCargoReproceso       NUMBER := 0;
    Ln_ServicioIdCargoReproceso   NUMBER := 0;
    Lr_ProductoReproceso          DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE;
    Lv_TieneSolCargoReproceso     VARCHAR2(2);
    Lb_ValidaFechas               BOOLEAN := TRUE;
    Lv_RangoConsumo               VARCHAR2(2000);
    Ld_FechInicioRango            DATE;
    Ld_FechFinRango               DATE;
    Ln_CaracteristicaId           NUMBER := 0;
    Lv_EmpresaCod                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE; 
    Ln_Limit                      CONSTANT PLS_INTEGER DEFAULT 100;
    Ln_IndCliente                 NUMBER;
    Ln_IndServicio                NUMBER;
    Ln_IndSolicitud               NUMBER;
    Ln_IndNumeracion              NUMBER;
    Ln_IndSolicitudReproceso      NUMBER;
    --

    --Cursor que obtiene el id de una característica según su descripción, estado y tipo.
    CURSOR C_ObtieneCaracteristica (Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_Tipo              DB_COMERCIAL.ADMI_CARACTERISTICA.TIPO%TYPE,
                                    Cv_Estado            DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE) IS
        SELECT ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA
         WHERE DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
           AND ESTADO = Cv_Estado
           AND TIPO   = Cv_Tipo;
    Lr_ObtieneCaracteristica  C_ObtieneCaracteristica%ROWTYPE;

  BEGIN
    --Inicializando
    Lv_EsMatriz               := 'S';
    Lv_EsOficinaFacturacion   := 'S';
    Lv_CodigoNumeracion       := 'FACE';
    Lv_EmpresaCod             := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Pv_PrefijoEmpresa);
    --
    --
    IF C_GetValorCargoReproceso%ISOPEN THEN
      CLOSE C_GetValorCargoReproceso;
    END IF;
    --
    OPEN C_GetValorCargoReproceso(Lv_EmpresaCod);
      FETCH C_GetValorCargoReproceso INTO Ln_PrecioCargoReproceso;
    CLOSE C_GetValorCargoReproceso;
    --
    --Se obtiene la característica por CRS para excluir los servicios.
    OPEN C_ObtieneCaracteristica('FACTURACION_CRS_CICLO_FACT', 'COMERCIAL', 'Activo');
      FETCH C_ObtieneCaracteristica INTO Lr_ObtieneCaracteristica;
    CLOSE C_ObtieneCaracteristica;

    Ln_CaracteristicaId := Lr_ObtieneCaracteristica.ID_CARACTERISTICA;

    Ln_IndCliente := Prf_ClientesFacturar.FIRST; 
    WHILE (Ln_IndCliente IS NOT NULL)
    LOOP 
      --Contador para los commits, a los 5k se ejecuta
      Pn_RecordCount:= Pn_RecordCount + 1;     

      --Recorriendo la data
      Lr_Punto := Prf_ClientesFacturar(Ln_IndCliente);
      --
      --
      --SE CONSULTA EL SECTOR_ID DEL PUNTO DE FACTURACION
      IF C_GetSectorByPunto%ISOPEN THEN
        CLOSE C_GetSectorByPunto;
      END IF;
      --
      OPEN C_GetSectorByPunto( Lr_Punto.id_punto );
      FETCH C_GetSectorByPunto INTO Ln_SectorId;
      CLOSE C_GetSectorByPunto;
      --
      --
      --SE VALIDA SI SE ENCONTRO EL SECTOR DEL PUNTO A FACTURAR
      IF Ln_SectorId IS NULL OR Ln_SectorId = 0 THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL_EN.P_PROCESAR_INFORMACION', 
                                              'No se pudo obtener el sector del siguiente punto (' || Lr_Punto.id_punto || ') - ' || SQLCODE || 
                                              ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
      --
      --Simulacion de facturacion que se puede dar en el punto
      DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_SIMULAR_FACT_MENSUAL(Lr_Punto.id_punto,Ln_SimularionPorPorcentaje,Ln_SimulacionPorValor);

      DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_GET_CLIENT_FACT(Lr_Punto.id_punto,
                                                 Ld_FechInicioRango,
                                                 Ld_FechFinRango,
                                                 Lb_ValidaFechas,
                                                 Lv_RangoConsumo);

      IF (Ln_SimularionPorPorcentaje>0 AND Ln_SimulacionPorValor>0 AND Lb_ValidaFechas) THEN
        --Con el pto ya seleccionado procedemos a ingresar la cabcera, con la informacion existente
        Lr_InfoDocumentoFinancieroCab                       :=NULL;
        Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO          :=DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
        Lr_InfoDocumentoFinancieroCab.OFICINA_ID            :=Lr_Punto.id_oficina;
        Lr_InfoDocumentoFinancieroCab.PUNTO_ID              :=Lr_Punto.id_punto;
        --Modificar a funcion de tipo de documento
        Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID     :=1;
        Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA         :='S';
        Lr_InfoDocumentoFinancieroCab.PRORRATEO             :='N';
        Lr_InfoDocumentoFinancieroCab.REACTIVACION          :='N';
        Lr_InfoDocumentoFinancieroCab.RECURRENTE            :='S';
        Lr_InfoDocumentoFinancieroCab.COMISIONA             :='S';
        Lr_InfoDocumentoFinancieroCab.FE_CREACION           :=sysdate;
        Lr_InfoDocumentoFinancieroCab.USR_CREACION          :='telcos';
        Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA        :='S';
        Lr_InfoDocumentoFinancieroCab.RANGO_CONSUMO         :=Lv_RangoConsumo;
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT :='Pendiente';
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

        --Con la informacion de cabecera se inserta el historial
        Lr_InfoDocumentoFinancieroHis                       :=NULL;
        Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
        Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos';
        Lr_InfoDocumentoFinancieroHis.ESTADO                :='Pendiente';
        Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se crea la factura';
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);

        --Inicializo la bandera que se utilizara para los detalles
        LV_BanderaPoseeDetalle:='N';

        --Inicializo la bandera que se utilizara para agregar los detalles  por reproceso de débito.
        Lv_TieneSolCargoReproceso := 'N';

        --Con el pto de facturacion podemos obtener los servicios asociados al punto
        DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_SERVICIO_ASOCIADOS(Lr_Punto.id_punto, Ln_CaracteristicaId ,Lc_ServiciosFacturar);    
        LOOP
          --Inicializo la bandera por cada servicio, como por defecto que se facture todos los servicios
          Lv_BanderaSolicitud:='S';

          IF Lc_ServiciosFacturar%notfound THEN
            Lv_BanderaSolicitud:='N';
          END IF;

          EXIT WHEN Lc_ServiciosFacturar%notfound;

          FETCH Lc_ServiciosFacturar BULK COLLECT INTO Lt_ServiciosFacturar LIMIT Ln_Limit;

          Ln_IndServicio := Lt_ServiciosFacturar.FIRST;
          WHILE (Ln_IndServicio IS NOT NULL)
          LOOP
              Lr_Servicios:= Lt_ServiciosFacturar(Ln_IndServicio);

              -- Se verifica si existe solicitud de reproceso de débito.
              IF Lv_TieneSolCargoReproceso = 'N' THEN

                Ln_PtoSolicitudReprocesoId   := 0;
                Ln_ServicioIdCargoReproceso  := 0;
                Lr_ProductoReproceso         := NULL;
                Lrf_GetSolicitudesReproceso  := NULL;

                Lrf_GetSolicitudesReproceso  := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SOL_PEND_BY_SER_ID('SOLICITUD CARGO REPROCESO DEBITO', 
                                                                                                      Lr_Servicios.id_servicio);

                Ln_CantidadSolReproceso      := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SOL_BY_SERVICIO_ID(Lr_Servicios.id_servicio,
                                                                                                      'SOLICITUD CARGO REPROCESO DEBITO',
                                                                                                      'Pendiente');
                IF Ln_CantidadSolReproceso > 0 THEN
                  Lv_TieneSolCargoReproceso   := 'S';
                  Ln_ServicioIdCargoReproceso := Lr_Servicios.id_servicio;
                  Ln_PtoSolicitudReprocesoId  := Lr_Servicios.punto_id;
                  Lr_ProductoReproceso        := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_PRODUCTO_BY_COD('CGC');

                END IF;
              END IF;

              --Con los servicios verifico si posee solicitudes
              DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_SOLICITUDES_CANCEL_SUSP(Lr_Servicios.id_servicio,Lc_Solicitud);
              LOOP
                FETCH Lc_Solicitud BULK COLLECT INTO Lt_Solicitud LIMIT Ln_Limit;
                IF Lc_Solicitud%notfound THEN
                   Lv_BanderaSolicitud:='S';
                END IF;

                EXIT WHEN Lc_Solicitud%notfound;

                Ln_IndSolicitud := Lt_Solicitud.FIRST;

                WHILE (Ln_IndSolicitud IS NOT NULL)
                LOOP

                    Lr_Solicitud:= Lt_Solicitud(Ln_IndSolicitud);

                    --Segun el tipo de solicitud verifico si el servicio se facturara o no
                    IF Lr_Solicitud.descripcion_solicitud   ='SOLICITUD CANCELACION' THEN
                      Lv_BanderaSolicitud                  :='N';
                    ELSIF Lr_Solicitud.descripcion_solicitud='SOLICITUD SUSPENSION TEMPORAL' THEN
                      Lv_BanderaSolicitud                  :='N';
                    ELSE
                      Lv_BanderaSolicitud:='S';
                    END IF;

                    Ln_IndSolicitud := Lt_Solicitud.NEXT(Ln_IndSolicitud);  
                    --
                END LOOP;
                --
              END LOOP;

              --Cierro el cursor de las solicitudes
              CLOSE Lc_Solicitud;

              --Dependiendo de la bandera de solicitud hago los sigts pasos
              IF Lv_BanderaSolicitud='S' THEN
                --Inicializo

                Ln_DescuentoFacProDetalle:=0;
                --Con los servicios verifico si posee descuento unico

                DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_SOL_DESCT_UNICO(Lr_Servicios.id_servicio,Ln_IdDetalleSolicitud,Ln_PorcentajeDescuento);
                --Si posee porcentaje de descuento, realizo los calculos
                --Debo actualizar la solicitud
                IF Ln_PorcentajeDescuento IS NOT NULL AND Ln_PorcentajeDescuento>0 THEN
                  DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.UPD_SOL_DESCT_UNICO(Ln_IdDetalleSolicitud);
                  Ln_DescuentoFacProDetalle:=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Ln_PorcentajeDescuento)/100,2);
                --Verifico si posee descuento fijo por porcentaje o valor; ya que este es el mandatorio  
                ELSIF Lr_Servicios.porcentaje_descuento>0 THEN
                   Ln_DescuentoFacProDetalle        :=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Lr_Servicios.porcentaje_descuento)/100,2);
                ELSIF Lr_Servicios.valor_descuento  >0 THEN
                  Ln_DescuentoFacProDetalle        :=ROUND(Lr_Servicios.valor_descuento,2); 
                ELSE                
                  DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_SOL_DESCT_PROMOCIONAL(Lr_Servicios.id_servicio,Ln_IdDetalleSolicitud,Ln_PorcentajeDescuento); 
                  IF Ln_PorcentajeDescuento IS NOT NULL AND Ln_PorcentajeDescuento>0 THEN
                    DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.UPD_SOL_DESCT_UNICO(Ln_IdDetalleSolicitud);
                    Ln_DescuentoFacProDetalle:=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Ln_PorcentajeDescuento)/100,2);
                  END IF;  
                END IF;

                --Con los valores obtenidos procedo hacer los calculos para cada servicio
                Ln_PrecioVentaFacProDetalle:=0;
                Ln_PrecioVentaFacProDetalle:=ROUND((Lr_Servicios.cantidad*Lr_Servicios.precio_venta),2);
                --
                --Calcula el valor del impuesto correspondiente al detalle
                Ln_ValorImpuesto := 0;
                Ln_ValorImpuesto := ((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle)*Pn_Porcentaje/100);

                --Con el precio de venta nuevo procedemos a ingresar los valores del detalle
                Lr_InfoDocumentoFinancieroDet                            :=NULL;
                Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE             :=DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
                Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID               :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
                Lr_InfoDocumentoFinancieroDet.PUNTO_ID                   :=Lr_Servicios.punto_id;
                Lr_InfoDocumentoFinancieroDet.PLAN_ID                    :=Lr_Servicios.plan_id;
                Lr_InfoDocumentoFinancieroDet.CANTIDAD                   :=Lr_Servicios.cantidad;
                Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE:=ROUND(Lr_Servicios.precio_venta,2);
                Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO:=Ln_PorcentajeDescuento;
                Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE   :=Ln_DescuentoFacProDetalle;
                Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE       :=ROUND(Lr_Servicios.precio_venta,2);
                Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE       :=ROUND(Lr_Servicios.precio_venta,2);
                Lr_InfoDocumentoFinancieroDet.FE_CREACION                :=sysdate;
                Lr_InfoDocumentoFinancieroDet.USR_CREACION               :='telcos';
                Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                :=Lr_Servicios.producto_id;
                Lr_InfoDocumentoFinancieroDet.SERVICIO_ID                :=Lr_Servicios.id_servicio;
                --Obtengo la Fe_activacion del servicio
                Lv_FeActivacion                                              :=DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_FECHA_ACTIVACION(Lr_Servicios.id_servicio);
                Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE  :=TRIM('Consumo: '||Lv_RangoConsumo);  
                IF Lv_FeActivacion                                           IS NOT NULL THEN
                  Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE:=TRIM(Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE 
                                                                                    || ', Fecha de Activacion: '|| Lv_FeActivacion);
                END IF;
                DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet,Pv_MsnError);
                --Pregunto si se guardo el detalle
                IF Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE>0 THEN
                  LV_BanderaPoseeDetalle:='S';
                ELSE
                  LV_BanderaPoseeDetalle:='N';
                END IF;


                --Con los valores de detalle insertado, podemos ingresar el impuesto
                Lr_InfoDocumentoFinancieroImp               :=NULL;
                Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP    :=DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
                Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID:=Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;

                --Modificar funcion del impuesto
                --Debemos obtener el impuesto en base al porcentaje enviado en el arreglo
                Ln_IdImpuesto                               :=DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO_X_PORCEN(Pn_Porcentaje);
                --
                Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID   :=Ln_IdImpuesto;
                Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO:=Ln_ValorImpuesto;
                Lr_InfoDocumentoFinancieroImp.PORCENTAJE    :=Pn_Porcentaje;
                Lr_InfoDocumentoFinancieroImp.FE_CREACION   :=sysdate;
                Lr_InfoDocumentoFinancieroImp.USR_CREACION  :='telcos';
                DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);
              ELSE
                --
                Lv_InfoError := 'Punto de Facturacion:' || Lr_Punto.id_punto || ' No se factura el servicio: ' || Lr_Servicios.id_servicio 
                                || ' Bandera de solicitud:'||Lv_BanderaSolicitud;
                --
                --
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                      'FNCK_FACTURACION_MENSUAL_EN.P_PROCESAR_INFORMACION', 
                                                      Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                      SYSDATE, 
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                --
              END IF;
              --
              Ln_IndServicio := Lt_ServiciosFacturar.NEXT(Ln_IndServicio);  
              --
          END LOOP;
          --
        END LOOP;
        --Se termina de procesar los servicios
        --Cierro el cursor de los servicios
        CLOSE Lc_ServiciosFacturar;


        IF Lv_TieneSolCargoReproceso = 'S' THEN

          Ln_PrecioVentaFacProDetalle:=ROUND((Ln_CantidadSolReproceso*Ln_PrecioCargoReproceso),2);

          -- Finalizamos la solicitud de cargo por reproceso de débito
          LOOP
            --
            FETCH Lrf_GetSolicitudesReproceso BULK COLLECT INTO Lt_SolicitudReproceso LIMIT Ln_Limit;
            --
            Ln_IndSolicitudReproceso := Lt_SolicitudReproceso.FIRST;
            WHILE (Ln_IndSolicitudReproceso IS NOT NULL)
            LOOP
              Lr_SolicitudReprocesoDebito:=Lt_SolicitudReproceso(Ln_IndSolicitudReproceso);
              DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.UPD_SOL_DESCT_UNICO(Lr_SolicitudReprocesoDebito.ID_DETALLE_SOLICITUD);
              Ln_IndSolicitudReproceso := Lt_SolicitudReproceso.NEXT(Ln_IndSolicitudReproceso);  
            END LOOP;

            EXIT WHEN Lrf_GetSolicitudesReproceso%NOTFOUND;
            --
          END LOOP;

          CLOSE Lrf_GetSolicitudesReproceso;

          -- Se agrega detalle por cargo de reproceso de débito.
          Lr_InfoDocumentoFinancieroDet                                := NULL;
          Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                 := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
          Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                   := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroDet.PUNTO_ID                       := Ln_PtoSolicitudReprocesoId;
          Lr_InfoDocumentoFinancieroDet.PLAN_ID                        := 0;
          Lr_InfoDocumentoFinancieroDet.CANTIDAD                       := Ln_CantidadSolReproceso;
          Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE    := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO    := 0;
          Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE       := 0;
          Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE           := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE           := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.FE_CREACION                    := sysdate;
          Lr_InfoDocumentoFinancieroDet.USR_CREACION                   := 'telcos';
          Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                    := Lr_ProductoReproceso.ID_PRODUCTO;
          Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE  := '';
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet,Pv_MsnError);

          --Con los valores de detalle insertado, podemos ingresar el impuesto

          Ln_ValorImpuesto := (Ln_PrecioVentaFacProDetalle*Pn_Porcentaje/100);

          Lr_InfoDocumentoFinancieroImp                := NULL;
          Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP     := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
          Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID := Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;

          Ln_IdImpuesto                                := DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO_X_PORCEN(Pn_Porcentaje);
          --
          Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID    := Ln_IdImpuesto;
          Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO := Ln_ValorImpuesto;
          Lr_InfoDocumentoFinancieroImp.PORCENTAJE     := Pn_Porcentaje;
          Lr_InfoDocumentoFinancieroImp.FE_CREACION    := sysdate;
          Lr_InfoDocumentoFinancieroImp.USR_CREACION   := 'telcos';
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);

        END IF;
        --

        --Se debe obtener las sumatorias de los Subtotales y se actualiza las cabeceras
        Ln_Subtotal              := 0;
        Ln_SubtotalDescuento     := 0;
        Ln_SubtotalConImpuesto   := 0;
        Ln_ValorTotal            := 0;
        Ln_DescuentoCompensacion := 0;

        Ln_Subtotal            := ROUND( NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_SUBTOTAL(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);
        Ln_SubtotalDescuento   := ROUND( NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_DESCUENTO(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);
        Ln_SubtotalConImpuesto := ROUND( NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_SUMAR_IMPUESTOS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);


        Ln_ValorTotal := NVL( NVL(Ln_Subtotal, 0) - NVL(Ln_SubtotalDescuento, 2) - NVL(Ln_DescuentoCompensacion, 0) + NVL(Ln_SubtotalConImpuesto, 0)
                              , 0);

        --Actualizo los valores
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL               := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO  := Ln_SubtotalConImpuesto;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO     := Ln_SubtotalDescuento;
        Lr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION := Ln_DescuentoCompensacion;
        Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL            := Ln_ValorTotal;

        --Actualizo la numeracion y el estado
        IF Ln_ValorTotal >0 THEN

          Lrf_Numeracion:=DB_FINANCIERO.FNCK_CONSULTS.F_GET_NUMERACION(Pv_PrefijoEmpresa,Lv_EsMatriz,Lv_EsOficinaFacturacion,Pn_IdOficina,Lv_CodigoNumeracion);
          --Debo recorrer la numeracion obtenida
          LOOP
            --
            EXIT WHEN Lrf_Numeracion%notfound;
            FETCH Lrf_Numeracion BULK COLLECT INTO Lt_Numeracion LIMIT Ln_Limit;
            Ln_IndNumeracion := Lt_Numeracion.FIRST;
            WHILE (Ln_IndNumeracion IS NOT NULL)
            LOOP
              Lr_AdmiNumeracion:=Lt_Numeracion(Ln_IndNumeracion);

              Lv_Secuencia :=LPAD(Lr_AdmiNumeracion.SECUENCIA,9,'0');
              Lv_Numeracion:=Lr_AdmiNumeracion.NUMERACION_UNO || '-'||Lr_AdmiNumeracion.NUMERACION_DOS||'-'||Lv_Secuencia;

              Ln_IndNumeracion := Lt_Numeracion.NEXT(Ln_IndNumeracion);  
              --
            END LOOP;

          END LOOP;
          --Cierro la numeracion
          CLOSE Lrf_Numeracion;

          Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI   :=Lv_Numeracion;
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Pendiente';
          Lr_InfoDocumentoFinancieroCab.FE_EMISION           :=TO_DATE(Pv_FeEmision,'dd-mm-yyyy');

          --Actualizo los valores de la cabecera
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

          --Incremento la numeracion
          Lr_AdmiNumeracion.SECUENCIA:=Lr_AdmiNumeracion.SECUENCIA+1;
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION,Lr_AdmiNumeracion,Pv_MsnError);
          --
          --SE AUMENTA EN UNO A LA CANTIDAD DE CLIENTES FACTURADOS
          Pn_ClientesFacturados := Pn_ClientesFacturados + 1;
          --
        ELSE
          -- Se actualiza el estado de la cabecera de la factura a Eliminado, debido a que no posee detalles y su valorTotal es 0 o nulo.
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Eliminado';
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

          --Se inserta el historial de Eliminado.
          Lr_InfoDocumentoFinancieroHis                       :=NULL;
          Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
          Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
          Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos';
          Lr_InfoDocumentoFinancieroHis.ESTADO                :='Eliminado';
          Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se elimina el documento debido a que no posee detalles';
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
          --
        END IF;
        --
        -- Verifica Incremento el contador, para poder hacer el commit
        IF Pn_RecordCount>=5000 THEN
          COMMIT;
          Pn_RecordCount:=0;
        END IF;

      ELSE
        Lv_InfoError := 'Punto de Facturacion:' || Lr_Punto.id_punto || ' Ln_SimularionPorPorcentaje:' || Ln_SimularionPorPorcentaje || 
                        ' Ln_SimulacionPorValor:' || Ln_SimulacionPorValor;
        --
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL_EN.P_PROCESAR_INFORMACION', 
                                              Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
       --
       Ln_IndCliente := Prf_ClientesFacturar.NEXT(Ln_IndCliente);  
       --
    END LOOP;

    EXCEPTION
    WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('facturacion@telcos.ec','Error Facturacion Masiva',
                                                            DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13), 
                                                            'FACE');    
    --Salida del BULK
  END P_PROCESAR_INFORMACION;
  --


END FNCK_FACTURACION_MENSUAL_EN;
/ 