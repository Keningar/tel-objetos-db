CREATE EDITIONABLE PACKAGE            SPKG_REPORTES AS

  /*
  * Documentaci�n para PROCEDURE 'P_REPORTE_ARCOTEL_CASOS'.
  * Procedure que permite generar un reporte de casos cerrados para la empresa Telconet
  *
  * PARAMETROS:
  * @Param varchar2       pv_prefijo_empresa   Prefijo de empresa en sesion
  * @Param varchar2       pv_fecha_inicio      fecha de inicio del reporte
  * @Param varchar2       pv_fecha_fin         fecha fin del reporte
  * @Param varchar2       pv_mensaje_error     Mensaje de error  
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 23-03-2017
  */
  PROCEDURE P_REPORTE_ARCOTEL_CASOS(pv_prefijo_empresa IN  VARCHAR2,
                                    pv_fecha_inicio    IN  VARCHAR2,
                                    pv_fecha_fin       IN  VARCHAR2,    
                                    pv_mensaje_error   OUT VARCHAR2);


  /*
  * Documentaci�n para PROCEDURE 'P_REPORTE_TAREAS_TT'.
  * Procedure que permite generar un reporte de tareas que es enviado al Ing. TT
  *
  * PARAMETROS:
  * @Param varchar2       pv_fecha_inicio      fecha de inicio del reporte
  * @Param varchar2       pv_fecha_fin         fecha fin del reporte
  * @Param varchar2       pv_mensaje_error     Mensaje de error  
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 24-10-2017
  *
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 09-07-2018 - Se agregan 3 campos al reporte de tareas: NUMERO_CASO,FECHA_APERTURA Y FECHA_CIERRE
  */
  PROCEDURE P_REPORTE_TAREAS_TT(pv_fecha_inicio    IN  VARCHAR2,
                                pv_fecha_fin       IN  VARCHAR2,    
                                pv_mensaje_error   OUT VARCHAR2); 

  /*
   * Documentaci�n para TYPE 'Gr_Tareas'.
   * Record que me permite devolver los valores para setear las columnas del reporte de tareas.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 29-05-2019
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.1 04-07-2019 - Se agrega las columnas 'ASIGNADO_ID_HIS', 'DEPARTAMENTO_ORIGEN_ID' y se cambias las fechas
   *                           por tipo de dato VARCHAR2.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.2 27-12-2019 - Se agrega la columna 'ID_DETALLE_HISTORIAL' para obtener el
   *                           id del detalle historial de la tarea.
   */
  TYPE Gr_Tareas IS RECORD (
          ID_DETALLE              DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE,
          LATITUD                 DB_SOPORTE.INFO_DETALLE.LATITUD%TYPE,
          LONGITUD                DB_SOPORTE.INFO_DETALLE.LONGITUD%TYPE,
          USR_CREACION_DETALLE    DB_SOPORTE.INFO_DETALLE.USR_CREACION%TYPE,
          DETALLE_ID_RELACIONADO  DB_SOPORTE.INFO_DETALLE.DETALLE_ID_RELACIONADO%TYPE,
          FE_CREACION_DETALLE     VARCHAR2(20),
          FE_SOLICITADA           VARCHAR2(20),
          OBSERVACION             DB_SOPORTE.INFO_DETALLE.OBSERVACION%TYPE,
          ID_TAREA                DB_SOPORTE.ADMI_TAREA.ID_TAREA%TYPE,
          NOMBRE_TAREA            DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
          DESCRIPCION_TAREA       DB_SOPORTE.ADMI_TAREA.DESCRIPCION_TAREA%TYPE,
          NOMBRE_PROCESO          DB_SOPORTE.ADMI_PROCESO.NOMBRE_PROCESO%TYPE,
          ASIGNADO_ID             DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_ID%TYPE,
          ASIGNADO_NOMBRE         DB_SOPORTE.INFO_DETALLE_ASIGNACION.ASIGNADO_NOMBRE%TYPE,
          REF_ASIGNADO_ID         DB_SOPORTE.INFO_DETALLE_ASIGNACION.REF_ASIGNADO_ID%TYPE,
          REF_ASIGNADO_NOMBRE     DB_SOPORTE.INFO_DETALLE_ASIGNACION.REF_ASIGNADO_NOMBRE%TYPE,
          PERSONA_EMPRESA_ROL_ID  DB_SOPORTE.INFO_DETALLE_ASIGNACION.PERSONA_EMPRESA_ROL_ID%TYPE,
          FE_CREACION_ASIGNACION  VARCHAR2(20),
          DEPARTAMENTO_ID         DB_SOPORTE.INFO_DETALLE_ASIGNACION.DEPARTAMENTO_ID%TYPE,
          TIPO_ASIGNADO           DB_SOPORTE.INFO_DETALLE_ASIGNACION.TIPO_ASIGNADO%TYPE,
          ESTADO                  DB_SOPORTE.INFO_DETALLE_HISTORIAL.ESTADO%TYPE,
          ID_DETALLE_HISTORIAL    DB_SOPORTE.INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE,
          FE_CREACION             VARCHAR2(20),
          USR_CREACION            DB_SOPORTE.INFO_DETALLE_HISTORIAL.USR_CREACION%TYPE,
          OBSERVACION_HISTORIAL   DB_SOPORTE.INFO_DETALLE_HISTORIAL.OBSERVACION%TYPE,
          ASIGNADO_ID_HIS         DB_SOPORTE.INFO_DETALLE_HISTORIAL.ASIGNADO_ID%TYPE,
          DEPARTAMENTO_ORIGEN_ID  DB_SOPORTE.INFO_DETALLE_HISTORIAL.DEPARTAMENTO_ORIGEN_ID%TYPE,
          NUMERO_TAREA            DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE
  );

  /*
   * Documentaci�n para el procedimiento 'P_REPORTE_TAREAS'.
   *
   * M�todo que permite generar el reporte de tareas solicitada por el Telcos+.
   *
   * @Param CLOB     Pcl_Json   Json de los criterios de consulta para el reporte de tarea
   * @Param varchar2 Pv_Status  Estado de la ejecuci�n del proceso ('ok','fail')
   * @Param varchar2 Pv_Message Mensaje de respuesta de la ejecuci�n del proceso
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 29-05-2019
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.1 15-06-2019 - Se modifica la manera de parsear el estado y las cuadrillas, obteniendo
   *                           un array y filtrandolo por un IN.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.2 27-06-2019 - En caso de que ocurra una excepci�n se valida si el archivo existe y se procede a eliminarlo.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.3 03-07-2019 - Se agrega el par�metro 'Prf_Tareas' encargado de retorna el record de tareas
   *                           solicitadas por el usuario.
   *                         - Se agrega el par�metro 'Pn_Total' encargado de retornar la cantidad de registros de las tareas
   *                           solicitadas por el usuario.
   *
   * @author Modificado: N�stor Naula <nnaulal@telconet.ec>
   * @version 1.4 04-09-2019 - Se agrega la variable strVerTareasEcucert que permite ver o no las tareas de ECUCERT.
   * @since 1.3
   *
   * @author Modificado: N�stor Naula <nnaulal@telconet.ec>
   * @version 1.5 13-09-2019 - Se cambia la forma de filtro de las tareas ECUCERT de NOT IN a EXISTS para optimizar la consulta.
   * @since 1.4
   *
   * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.6 27-12-2019 - Se agrega en el query principal el campo 'ID_DETALLE_HISTORIAL'
   *
   * @author Modificado: N�stor Naula <nnaulal@telconet.ec>
   * @version 1.7 15-06-2020 - Se cambia la forma de filtro de las tareas ECUCERT por temas de lentitud.
   * @since 1.6
   *
   * @author Modificado: Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.8 02-02-2021 - Se modifica el filtro por cliente, para evitar la consulta a la info_comunicacion.
   */
  PROCEDURE P_REPORTE_TAREAS(Pcl_Json    IN  CLOB,
                             Prf_Tareas  OUT SYS_REFCURSOR,
                             Pn_Total    OUT NUMBER,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Message  OUT VARCHAR2);

  /*
   * Documentaci�n para TYPE 'Gr_Casos'.
   *
   * Record que me permite devolver los valores para setear las columnas del reporte de casos.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 19-06-2019
   */
  TYPE Gr_Casos IS RECORD (
          ID_CASO        DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
          NUMERO_CASO    DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE,
          TITULO_INI     DB_SOPORTE.INFO_CASO.TITULO_INI%TYPE,
          TITULO_FIN     DB_SOPORTE.INFO_CASO.TITULO_FIN%TYPE,
          TITULO_FIN_HIP DB_SOPORTE.INFO_CASO.TITULO_FIN_HIP%TYPE,
          VERSION_INI    DB_SOPORTE.INFO_CASO.VERSION_INI%TYPE,
          VERSION_FIN    DB_SOPORTE.INFO_CASO.VERSION_FIN%TYPE,
          FE_APERTURA    DB_SOPORTE.INFO_CASO.FE_APERTURA%TYPE,
          FE_CIERRE      DB_SOPORTE.INFO_CASO.FE_CIERRE%TYPE,
          ESTADO         DB_SOPORTE.INFO_CASO_HISTORIAL.ESTADO%TYPE
  );

  /*
   * Documentaci�n para el procedimiento 'P_REPORTE_CASOS'.
   *
   * M�todo que permite generar el reporte de casos solicitado por el Telcos+.
   *
   * @Param CLOB     Pcl_Json   Json de los criterios de consulta para el reporte de casos.
   * @Param varchar2 Pv_Status  Estado de la ejecuci�n del proceso ('ok','fail').
   * @Param varchar2 Pv_Message Mensaje de respuesta de la ejecuci�n del proceso.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 19-06-2019
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.1 03-06-2020 - Se elimina la llamada al cursor *C_GetUltimosCasosLogin*
   *                           por motivos que ocasiona latencia en la base de datos.
   */
  PROCEDURE P_REPORTE_CASOS(Pcl_Json    IN  CLOB,
                            Pv_Status   OUT VARCHAR2,
                            Pv_Message  OUT VARCHAR2);

  /**
   * Documentaci�n para la funci�n 'F_GET_VARCHAR_CLEAN'
   *
   * Funci�n que limpia ciertos car�cteres especiales para los reportes.
   *
   * @Param CLOB Fv_Cadena Recibe la cadena a limpiar.
   *
   * @return CLOB Retorna la cadena sin car�cteres especiales.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 21-06-2019
   */
  FUNCTION F_GET_VARCHAR_CLEAN(Fv_Cadena IN CLOB) RETURN CLOB;

END SPKG_REPORTES;
/



/
CREATE EDITIONABLE PACKAGE BODY            SPKG_REPORTES AS

PROCEDURE P_REPORTE_ARCOTEL_CASOS(pv_prefijo_empresa IN  VARCHAR2,
                                  pv_fecha_inicio    IN  VARCHAR2,
                                  pv_fecha_fin       IN  VARCHAR2,    
                                  pv_mensaje_error   OUT VARCHAR2) IS
                                
  
--Costo del query: 13
CURSOR c_get_casos_por_mes(cn_id_caso NUMBER,cv_estado_caso VARCHAR2,cv_tipo_afectado VARCHAR2)
IS
SELECT infocaso.numero_caso numero_caso,
  admitipocaso.nombre_tipo_caso tipo_caso,  
  infoparteafectada.tipo_afectado,
  (SELECT nombre_provincia
  FROM db_general.admi_provincia
  WHERE id_provincia =
    (SELECT MAX(provincia_id)
    FROM db_general.admi_canton
    WHERE id_canton =
      (SELECT MAX(canton_id)
      FROM db_general.admi_parroquia
      WHERE id_parroquia =
        (SELECT MAX(parroquia_id)
        FROM db_general.admi_sector
        WHERE id_sector =
          (SELECT MAX(sector_id)
          FROM db_comercial.info_punto
          WHERE login = infoparteafectada.afectado_nombre
          )
        )
      )
    )
  ) provincia,
  (SELECT nombre_canton
  FROM db_general.admi_canton
  WHERE id_canton =
    (SELECT MAX(canton_id)
    FROM db_general.admi_parroquia
    WHERE id_parroquia =
      (SELECT MAX(parroquia_id)
      FROM db_general.admi_sector
      WHERE id_sector =
        (SELECT MAX(sector_id)
        FROM db_comercial.info_punto
        WHERE login = infoparteafectada.afectado_nombre
        )
      )
    )
  ) canton,
  infoparteafectada.afectado_nombre login_afectado,
  (SELECT admihipotesis.nombre_hipotesis
  FROM db_soporte.admi_hipotesis admihipotesis
  WHERE admihipotesis.id_hipotesis = infocaso.titulo_fin_hip
  ) titulo_final,
  infocaso.fe_creacion fecha_creacion,
  infocaso.fe_apertura fecha_apertura,
  infocaso.version_ini version_inicial,
  infocaso.version_fin version_final,
  infocaso.tipo_backbone,
  infocaso.fe_cierre,
  (SELECT listagg(infoparteafectada.afectado_nombre, ':') WITHIN GROUP (
  ORDER BY infoparteafectada.fe_creacion)
  FROM db_soporte.INFO_PARTE_AFECTADA infoparteafectada
  WHERE infoparteafectada.detalle_id = infodetalle.id_detalle
  AND infoparteafectada.tipo_afectado = cv_tipo_afectado
  ) servicios_afectado,  
  (SELECT MAX(infocasotiempoasignacion.tiempo_total_caso_solucion)
  FROM db_soporte.info_caso_tiempo_asignacion infocasotiempoasignacion
  WHERE infocasotiempoasignacion.caso_id = infocaso.id_caso
  ) tiempo_total_solucion,
  (SELECT MAX(infocasotiempoasignacion.tiempo_total_caso)
  FROM db_soporte.info_caso_tiempo_asignacion infocasotiempoasignacion
  WHERE infocasotiempoasignacion.caso_id = infocaso.id_caso
  ) tiempo_total_caso,
  (SELECT MAX(infocasotiempoasignacion.tiempo_cliente_asignado)
  FROM db_soporte.info_caso_tiempo_asignacion infocasotiempoasignacion
  WHERE infocasotiempoasignacion.caso_id = infocaso.id_caso
  ) tiempo_total_cliente,
  (SELECT MAX(infocasotiempoasignacion.tiempo_empresa_asignado)
  FROM db_soporte.info_caso_tiempo_asignacion infocasotiempoasignacion
  WHERE infocasotiempoasignacion.caso_id = infocaso.id_caso
  ) tiempo_total_empresa
FROM db_soporte.info_caso infocaso,
  db_soporte.info_caso_historial infocasohistorial,
  db_soporte.admi_tipo_caso admitipocaso,
  db_soporte.info_detalle_hipotesis infodetallehipotesis,
  db_soporte.info_detalle infodetalle,
  db_soporte.info_parte_afectada infoparteafectada
WHERE infocaso.id_caso               = infocasohistorial.caso_id
AND admitipocaso.id_tipo_caso        = infocaso.tipo_caso_id
AND infodetallehipotesis.caso_id     = infocaso.id_caso
AND infodetalle.detalle_hipotesis_id = infodetallehipotesis.id_detalle_hipotesis
AND infoparteafectada.detalle_id     = infodetalle.id_detalle
AND infoCaso.id_caso                 = cn_id_caso
AND infoparteafectada.id_parte_afectada =
  (SELECT MIN(c.id_parte_afectada)
  FROM db_soporte.info_parte_afectada c
  WHERE c.detalle_id = infodetalle.id_detalle
  )
AND infodetalle.id_detalle =
  (SELECT MIN(A.id_detalle)
  FROM db_soporte.info_detalle A
  WHERE A.detalle_hipotesis_id = infodetallehipotesis.id_detalle_hipotesis
  )
AND infocasohistorial.estado            = cv_estado_caso
AND infocasohistorial.id_caso_historial =
  (SELECT MAX(b.id_caso_historial)
  FROM db_soporte.info_caso_historial b
  WHERE b.caso_id = infocaso.id_caso
  );

--Se obtiene los casos por empresa
CURSOR c_get_casos(cv_cod_empresa VARCHAR2,cv_fecha_inicio VARCHAR2,cv_fecha_fin VARCHAR2) IS
SELECT infocaso.id_caso 
FROM db_soporte.info_caso infocaso
WHERE infocaso.empresa_cod = cv_cod_empresa
AND infocaso.fe_creacion >= to_date(cv_fecha_inicio,'dd/mm/yyyy')
AND infocaso.fe_creacion <= to_date(cv_fecha_fin,'dd/mm/yyyy');

--Se obtiene valor de parametro
CURSOR c_getparametro(cv_nombre_parametro VARCHAR2,cv_descripcion VARCHAR2)
IS
  SELECT admipatametrodet.valor1
  FROM db_general.admi_parametro_det admipatametrodet
  WHERE admipatametrodet.parametro_id =
    (SELECT admipatametrocab.id_parametro
    FROM db_general.admi_parametro_cab admipatametrocab
    WHERE admipatametrocab.nombre_parametro = cv_nombre_parametro
    )
AND admipatametrodet.descripcion = cv_descripcion;


--Se obtiene el codigo de la empresa
CURSOR c_getCodEmpresa(cv_prefijo VARCHAR2)
IS
  SELECT cod_empresa
  FROM db_comercial.info_empresa_grupo
  WHERE prefijo = cv_prefijo;


lv_fecha_archivo                VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
lv_asunto_notificacion          VARCHAR2(100)  := 'Notificaci�n de Generacion de Reporte de Casos';
lv_directorio                   VARCHAR2(50)   := 'DIR_REPORTES_ARCOTEL_CASOS';
lv_nombre_archivo               VARCHAR2(100)  := 'ReporteArcotelCasosTN_'|| lv_fecha_archivo||'.csv';
lv_nombre_archivo_comprimir     VARCHAR2(100)  := '';
lv_Gzip                         VARCHAR2(500)  := '';
lv_estado_caso                  VARCHAR2(20)   := 'Cerrado';
Lv_parametro_proyecto_arcotel   VARCHAR2(100)  := 'PARAMETROS PROYECTO ARCOTEL';
Lv_parametro_remitente          VARCHAR2(100)  := 'CORREO_REMITENTE';
Lv_parametro_destinatario       VARCHAR2(100)  := 'CORREO_DESTINATARIO_CASO';
Lv_parametro_direcc_reporte     VARCHAR2(100)  := 'DIRECCION_REPORTES_CASOS';
Lv_parametro_comando_reporte    VARCHAR2(100)  := 'COMANDO_REPORTE';    
Lv_parametro_extension_repor    VARCHAR2(100)  := 'EXTENSION_REPORTE';  
Lv_parametro_plantilla          VARCHAR2(1000) := 'PLANTILLA_NOTIFICACION_CASOS';  
Lv_tipo_afectado                VARCHAR2(20)   := 'Servicio';
Lv_IpCreacion                   VARCHAR2(30)   := '127.0.0.1';
lv_plantilla_notificacion       VARCHAR2(4000) := '';
lv_codigo_empresa               VARCHAR2(5)    ;
lv_remitente                    VARCHAR2(100)  := '';
lv_destinatario                 VARCHAR2(100)  := '';
lv_provincia                    VARCHAR2(50)   := '';
lv_canton                       VARCHAR2(50)   := '';
lv_direccion_completa           VARCHAR2(200)  := '';
lv_comando_ejecutar             VARCHAR2(200)  := '';
lf_archivo                      utl_file.file_type;
lr_caso                         c_get_casos_por_mes%ROWTYPE;
lv_delimitador                  VARCHAR2(1) := '|';

BEGIN

--Se crea el archivo
lf_archivo := utl_file.fopen(lv_directorio,lv_nombre_archivo,'w',3000);

IF (C_GetParametro%isopen) THEN 
  CLOSE C_GetParametro;
END IF;
--Se obtiene el remitente
OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_remitente);
FETCH c_getparametro INTO lv_remitente;
CLOSE c_getparametro;
--Se obtiene el destinatario
OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_destinatario);
FETCH c_getparametro INTO lv_destinatario;
CLOSE c_getparametro;

--Se obtiene la url del directorio para los reportes de casos para la arcotel
OPEN c_getparametro(Lv_parametro_proyecto_arcotel,Lv_parametro_direcc_reporte);
FETCH c_getparametro INTO lv_direccion_completa;
CLOSE c_getparametro;

--Se obtiene el comando a ejecutar
OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_comando_reporte);   
FETCH C_GetParametro INTO lv_comando_ejecutar;
CLOSE C_GetParametro;    
--Se obtiene el comando a ejecutar
OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_extension_repor);
FETCH C_GetParametro INTO Lv_parametro_extension_repor;
CLOSE C_GetParametro;
--Se obtiene la plantilla para la notificacion
OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_plantilla);
FETCH C_GetParametro INTO Lv_Plantilla_Notificacion;
CLOSE C_GetParametro;

IF (c_getCodEmpresa%isopen) THEN 
  CLOSE c_getCodEmpresa;
END IF;

--Se obtiene el codigo de la empresa
OPEN c_getCodEmpresa(pv_prefijo_empresa);
FETCH c_getCodEmpresa INTO lv_codigo_empresa;
CLOSE c_getCodEmpresa;

--Se insertan las CABECERAS
utl_file.put_line(lf_archivo, 
                    'NUMERO DE CASO'||lv_delimitador 
                  ||'TIPO DE CASO'||lv_delimitador 
                  ||'TIPO BACKBONE'||lv_delimitador
                  ||'TIPO DE AFECTADO'||lv_delimitador
                  ||'PRODUCTO AFECTADO'||lv_delimitador
                  ||'PROVINCIA'||lv_delimitador 
                  ||'CANTON'||lv_delimitador 
                  ||'LOGIN AFECTADO'||lv_delimitador 
                  ||'TITULO FINAL'||lv_delimitador 
                  ||'FECHA DE CREACION'||lv_delimitador 
                  ||'FECHA DE APERTURA'||lv_delimitador
                  ||'FECHA DE CIERRE'||lv_delimitador   
                  ||'VERSION INICIAL'||lv_delimitador 
                  ||'VERSION FINAL'||lv_delimitador 
                  ||'TIEMPO TOTAL SOLUCION'||lv_delimitador 
                  ||'TIEMPO TOTAL'||lv_delimitador 
                  ||'TIEMPO TOTAL CLIENTE'||lv_delimitador 
                  ||'TIEMPO TOTAL EMPRESA'||lv_delimitador );

IF (c_get_casos%isopen) THEN 
  CLOSE c_get_casos;
END IF;

FOR i IN c_get_casos(lv_codigo_empresa,pv_fecha_inicio,pv_fecha_fin) LOOP

IF (c_get_casos_por_mes%isopen) THEN 
  CLOSE c_get_casos_por_mes;
END IF;

OPEN c_get_casos_por_mes(i.id_caso,lv_estado_caso,Lv_tipo_afectado);
FETCH c_get_casos_por_mes INTO lr_caso;
CLOSE c_get_casos_por_mes;

lv_provincia := '';
lv_canton := '';

IF(lr_caso.tipo_afectado <> 'Elemento') THEN
  lv_provincia     := lr_caso.provincia;
  lv_canton        := lr_caso.canton;
ELSE
  lv_provincia := 'N/A';
  lv_canton    := 'N/A';
END IF;

  utl_file.put_line(lf_archivo, lr_caso.numero_caso||lv_delimitador                                    -- 1)Numero del Caso
  ||lr_caso.tipo_caso||lv_delimitador                                                                  -- 2)Tipo del Caso
  ||lr_caso.tipo_backbone||lv_delimitador                                                              -- 3)Tipo backbone
  ||lr_caso.tipo_afectado||lv_delimitador                                                              -- 4)Tipo de Afectado
  ||lr_caso.servicios_afectado||lv_delimitador                                                         -- 5)Servicios Afectados
  ||lv_provincia||lv_delimitador                                                                       -- 6)Provincia
  ||lv_canton||lv_delimitador                                                                          -- 7)Canton
  ||lr_caso.login_afectado||lv_delimitador                                                                  -- 8)Login Afectado
  ||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lr_caso.titulo_final,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),'|',''),';','')
  ||lv_delimitador                                                                                          -- 7)Titulo Final
  ||lr_caso.fecha_creacion||lv_delimitador                                                                  -- 10)Fecha de Creacion
  ||lr_caso.fecha_apertura||lv_delimitador                                                                  -- 11)Fecha de Apertura
  ||lr_caso.fe_cierre||lv_delimitador                                                                       -- 12)Fecha de Cierre
  ||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lr_caso.version_inicial,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),'|',''),';','')
  ||lv_delimitador                                                                                          -- 13)Version Inicial
  ||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lr_caso.version_final,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),'|',''),';','')
  ||lv_delimitador                                                                                          -- 14)Version Final
  ||lr_caso.tiempo_total_solucion||lv_delimitador                                                           -- 15)Tiempo Total Solucion
  ||lr_caso.tiempo_total_caso||lv_delimitador                                                               -- 16)Tiempo Total
  ||lr_caso.tiempo_total_cliente||lv_delimitador                                                            -- 17)Tiempo Total Cliente
  ||lr_caso.tiempo_total_empresa||lv_delimitador                                                            -- 18)Tiempo Total Empresa
  );

END LOOP;

utl_file.fclose(lf_archivo);

--Se arma el comando a ejecutar
Lv_gzip := lv_comando_ejecutar || ' ' || lv_direccion_completa || Lv_nombre_archivo;

--Armo nombre completo del archivo que se genera
lv_nombre_archivo_comprimir := Lv_nombre_archivo || Lv_parametro_extension_repor;

dbms_output.put_line(naf47_tnet.javaruncommand (lv_Gzip));

/* Se envia notificacion de la generacion del reporte */
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<lv_nombre_archivo_comprimir>>',lv_nombre_archivo_comprimir);
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<pv_fecha_inicio>>',pv_fecha_inicio);
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<pv_fecha_fin>>',pv_fecha_fin);

db_general.gnrlpck_util.send_email_attach(lv_remitente,lv_destinatario, lv_asunto_notificacion, lv_plantilla_notificacion,
                                          lv_directorio,lv_nombre_archivo_comprimir);

utl_file.fremove(lv_directorio,lv_nombre_archivo_comprimir);

pv_mensaje_error := 'Proceso realizado con exito';

EXCEPTION
WHEN OTHERS THEN
  pv_mensaje_error := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;  

  db_general.gnrlpck_util.insert_error('Telcos +', 
                                        'SPKG_REPORTES.P_REPORTE_ARCOTEL_CASOS', 
                                        SQLERRM,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                      );  

END P_REPORTE_ARCOTEL_CASOS;





PROCEDURE P_REPORTE_TAREAS_TT(pv_fecha_inicio    IN  VARCHAR2,
                              pv_fecha_fin       IN  VARCHAR2,    
                              pv_mensaje_error   OUT VARCHAR2) IS


Cursor c_get_tareas(cv_fecha_inicio VARCHAR2,cv_fecha_fin VARCHAR2) Is 
SELECT
  b.detalle_id,
  (SELECT MIN(IC.ID_COMUNICACION)
  FROM db_soporte.INFO_COMUNICACION IC
  WHERE IC.DETALLE_ID = b.detalle_id
  ) numero_tarea,
  (SELECT nombre_tarea
  FROM db_soporte.admi_tarea
  WHERE id_tarea =
    (SELECT tarea_id FROM db_soporte.info_detalle WHERE id_detalle = b.detalle_id
    )
  ) nombre_tarea,
  (SELECT MIN (fe_creacion)
  FROM db_soporte.info_detalle_historial
  WHERE detalle_id = b.detalle_id
  AND estado      IN ('Aceptada')
  ) fe_inicio_tarea,
  (SELECT MAX (fe_creacion)
  FROM db_soporte.info_detalle_historial
  WHERE detalle_id = b.detalle_id
  AND estado      IN ('Finalizada', 'Cancelada', 'Rechazada', 'Anulada', 'Asignada', 'Pausada')
  ) fe_cierre_tarea,
  (select infoC.NUMERO_CASO from db_soporte.info_caso infoC where infoC.id_caso = (
  select infoDetalleH.CASO_ID from db_soporte.INFO_DETALLE_HIPOTESIS infoDetalleH where infoDetalleH.ID_DETALLE_HIPOTESIS = (
  select infoD.DETALLE_HIPOTESIS_ID from db_soporte.info_detalle infoD where infoD.id_detalle = b.detalle_id))) numero_caso,
  (select to_char(infoC.FE_APERTURA,'dd/mm/yyyy hh24:mi:ss') from db_soporte.info_caso infoC where infoC.id_caso = (
  select infoDetalleH.CASO_ID from db_soporte.INFO_DETALLE_HIPOTESIS infoDetalleH where infoDetalleH.ID_DETALLE_HIPOTESIS = (
  select infoD.DETALLE_HIPOTESIS_ID from db_soporte.info_detalle infoD where infoD.id_detalle = b.detalle_id))) fecha_apertura,
    (select to_char(infoC.FE_CIERRE,'dd/mm/yyyy hh24:mi:ss') from db_soporte.info_caso infoC where infoC.id_caso = (
  select infoDetalleH.CASO_ID from db_soporte.INFO_DETALLE_HIPOTESIS infoDetalleH where infoDetalleH.ID_DETALLE_HIPOTESIS = (
  select infoD.DETALLE_HIPOTESIS_ID from db_soporte.info_detalle infoD where infoD.id_detalle = b.detalle_id))) fecha_cierre,
  (SELECT asignado_nombre
  FROM db_soporte.info_detalle_asignacion
  WHERE id_detalle_asignacion =
    (SELECT MAX (id_detalle_asignacion)
    FROM db_soporte.info_detalle_asignacion
    WHERE detalle_id  = b.detalle_id
    AND tipo_asignado = 'CUADRILLA'
    )
  ) cuadrilla_asignada,
  (SELECT nombre_departamento
  FROM db_soporte.ADMI_DEPARTAMENTO
  WHERE id_departamento =
    (SELECT departamento_id
    FROM db_soporte.INFO_PERSONA_EMPRESA_ROL
    WHERE id_persona_rol =
      (SELECT f.persona_empresa_rol_id
      FROM db_soporte.INFO_DETALLE_ASIGNACION f
      WHERE f.ID_DETALLE_ASIGNACION =
        (SELECT MAX(id_detalle_asignacion)
        FROM db_soporte.INFO_DETALLE_ASIGNACION
        WHERE tipo_asignado = 'CUADRILLA'
        AND detalle_id      = B.DETALLE_ID
        )
      )
    )
  ) departamento,
  (SELECT estado
  FROM db_soporte.info_detalle_historial
  WHERE id_detalle_historial =
    (SELECT MAX (id_detalle_historial)
    FROM db_soporte.info_detalle_historial
    WHERE detalle_id = b.detalle_id
    AND estado      IN ('Finalizada', 'Cancelada', 'Rechazada', 'Anulada')
    )
  ) estado_final_tarea,
  (SELECT J1.NOMBRE_JURISDICCION
  FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION J1,
    DB_COMERCIAL.INFO_PUNTO P1
  WHERE J1.ID_JURISDICCION = P1.PUNTO_COBERTURA_ID
  AND p1.id_punto          = (
    (SELECT afectado_id
    FROM db_soporte.info_parte_afectada
    WHERE id_parte_afectada = (
      (SELECT MIN (id_parte_afectada)
      FROM db_soporte.info_parte_afectada
      WHERE detalle_id =
        (SELECT MIN (id_detalle)
        FROM db_soporte.info_detalle
        WHERE detalle_hipotesis_id =
          (SELECT detalle_hipotesis_id
          FROM db_soporte.info_detalle
          WHERE id_detalle = b.detalle_id
          )
        )
      ))
    ))
  UNION
  SELECT J1.NOMBRE_JURISDICCION
  FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION J1,
    DB_COMERCIAL.INFO_PUNTO P1
  WHERE J1.ID_JURISDICCION = P1.PUNTO_COBERTURA_ID
  AND p1.id_punto          =
    (SELECT afectado_id
    FROM db_soporte.info_parte_afectada
    WHERE id_parte_afectada = (
      (SELECT MIN (id_parte_afectada)
      FROM db_soporte.info_parte_afectada
      WHERE detalle_id = b.detalle_id
      ))
    )
  ) region_afectado,
  (SELECT nombre_empresa
  FROM db_soporte.info_empresa_grupo
  WHERE cod_empresa =
    (SELECT empresa_id
    FROM db_soporte.info_oficina_grupo
    WHERE id_oficina =
      (SELECT J1.oficina_id
      FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION J1,
        DB_COMERCIAL.INFO_PUNTO P1
      WHERE J1.ID_JURISDICCION = P1.PUNTO_COBERTURA_ID
      AND p1.id_punto          = (
        (SELECT afectado_id
        FROM db_soporte.info_parte_afectada
        WHERE id_parte_afectada = (
          (SELECT MIN ( id_parte_afectada)
          FROM db_soporte.info_parte_afectada
          WHERE detalle_id =
            (SELECT MIN ( id_detalle)
            FROM db_soporte.info_detalle
            WHERE detalle_hipotesis_id =
              (SELECT detalle_hipotesis_id
              FROM db_soporte.info_detalle
              WHERE id_detalle = b.detalle_id
              )
            )
          ))
        ))
      )
    )
  UNION
  SELECT nombre_empresa
  FROM db_soporte.info_empresa_grupo
  WHERE cod_empresa =
    (SELECT empresa_id
    FROM db_soporte.info_oficina_grupo
    WHERE id_oficina =
      (SELECT J1.oficina_id
      FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION J1,
        DB_COMERCIAL.INFO_PUNTO P1
      WHERE J1.ID_JURISDICCION = P1.PUNTO_COBERTURA_ID
      AND p1.id_punto          =
        (SELECT afectado_id
        FROM db_soporte.info_parte_afectada
        WHERE id_parte_afectada = (
          (SELECT MIN ( id_parte_afectada)
          FROM db_soporte.info_parte_afectada
          WHERE detalle_id = b.detalle_id
          ))
        )
      )
    )
  ) empresa_afectado,
  (SELECT nombre_oficina
  FROM db_soporte.info_oficina_grupo
  WHERE id_oficina =
    (SELECT oficina_id
    FROM db_soporte.info_persona_empresa_rol
    WHERE id_persona_rol =
      (SELECT persona_empresa_rol_id
      FROM db_soporte.info_detalle_asignacion
      WHERE id_detalle_asignacion =
        (SELECT MAX(id_detalle_asignacion)
        FROM db_soporte.info_detalle_asignacion
        WHERE tipo_asignado = 'CUADRILLA'
        AND detalle_id      = b.detalle_id
        )
      )
    )
  ) oficina_responsable,
  (SELECT nombre_empresa
  FROM db_soporte.INFO_EMPRESA_GRUPO
  WHERE cod_empresa =
    (SELECT empresa_id
    FROM db_soporte.info_oficina_grupo
    WHERE id_oficina =
      (SELECT oficina_id
      FROM db_soporte.info_persona_empresa_rol
      WHERE id_persona_rol =
        (SELECT persona_empresa_rol_id
        FROM db_soporte.info_detalle_asignacion
        WHERE id_detalle_asignacion =
          (SELECT MAX(id_detalle_asignacion)
          FROM db_soporte.info_detalle_asignacion
          WHERE tipo_asignado = 'CUADRILLA'
          AND detalle_id      = b.detalle_id
          )
        )
      )
    )
  ) empresa_responsable
FROM
  (SELECT a.DETALLE_ID
  FROM db_soporte.info_detalle_asignacion a,
    db_soporte.INFO_DETALLE_HISTORIAL b,
    db_soporte.info_detalle c
  WHERE a.detalle_id  = b.detalle_id
  AND b.detalle_id    = c.id_detalle
  AND b.estado       IN ('Finalizada', 'Cancelada', 'Rechazada', 'Anulada')
  AND c.fe_creacion  >= TO_DATE (cv_fecha_inicio, 'dd/mm/yyyy')
  AND a.fe_creacion  <= TO_DATE (cv_fecha_fin||' 23:59:59', 'dd/mm/yyyy hh24:mi:ss')
  AND a.TIPO_ASIGNADO = 'CUADRILLA'
  GROUP BY a.DETALLE_ID
  ) b;     


--Se obtiene el trace de la tarea
CURSOR c_getTrace(cn_detalle_id NUMBER) is
SELECT LISTAGG(g.estado_tarea
    ||'\'
    ||
    (SELECT REPLACE(nn.nombres,'null','-')
      ||' '
      ||REPLACE(nn.apellidos,'null','-')
    FROM db_soporte.info_persona nn
    WHERE nn.id_persona =
      (SELECT MAX(bb.id_persona)
      FROM db_soporte.info_persona bb
      WHERE bb.login = g.usr_creacion
      )
    )
    ||'\'
    ||
    (SELECT NOMBRE_DEPARTAMENTO
    FROM db_soporte.ADMI_DEPARTAMENTO
    WHERE id_departamento = (
      (SELECT a.DEPARTAMENTO_ID
      FROM db_soporte.INFO_PERSONA_EMPRESA_ROL a
      WHERE a.persona_id =
        (SELECT id_persona
        FROM db_soporte.info_persona
        WHERE id_persona =
          ( SELECT MIN(id_persona) FROM db_soporte.info_persona WHERE login = g.usr_creacion
          )
        )
      AND a.DEPARTAMENTO_ID IN
        (SELECT id_departamento
        FROM db_soporte.admi_departamento
        WHERE empresa_cod IN ('10','18')
        )
      AND a.estado     IN ('Activo','Inactivo','Eliminado')
      AND a.oficina_id IS NOT NULL
      AND rownum        < 2
      ))
    )
    ||'\'
    ||SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(g.observacion,CHR(10),'') ,CHR(13),'') ,CHR(09),'') ,'null','-'),'@',''),'|',''),'\',''),0,55)
    ||'\'
    ||TO_CHAR(g.fe_creacion,'dd/mm/yyyy hh24:mi:ss'), ' @ ') WITHIN GROUP (
  ORDER BY g.fe_creacion ASC) trace
  FROM db_soporte.INFO_TAREA_SEGUIMIENTO g
  WHERE g.DETALLE_ID = cn_detalle_id
  AND (g.OBSERVACION LIKE '%Asignada y Aceptada%'
  OR g.OBSERVACION LIKE'%Tarea fue Reasignada%'
  OR g.OBSERVACION LIKE'%Tarea fue Iniciada%'
  OR g.OBSERVACION LIKE'%Tarea fue Pausada%'
  OR g.OBSERVACION LIKE'%Tarea fue Reanudada%'
  OR g.OBSERVACION LIKE'%Tarea fue Finalizada%'
  OR g.OBSERVACION LIKE'%Tarea fue Asignada%'
  OR g.OBSERVACION LIKE '%Obs: Desde el m�vil%'
  OR g.OBSERVACION LIKE '%Tarea fue Cancelada%'
  OR g.OBSERVACION LIKE '%Tarea fue Rechazada%'
  OR g.OBSERVACION LIKE '%Se inicia la ejecucion de la Tarea%');


--Se obtiene valor de parametro
CURSOR c_getparametro(cv_nombre_parametro VARCHAR2,cv_descripcion VARCHAR2)
IS
  SELECT admipatametrodet.valor1
  FROM db_general.admi_parametro_det admipatametrodet
  WHERE admipatametrodet.parametro_id =
    (SELECT admipatametrocab.id_parametro
    FROM db_general.admi_parametro_cab admipatametrocab
    WHERE admipatametrocab.nombre_parametro = cv_nombre_parametro
    )
AND admipatametrodet.descripcion = cv_descripcion;


--Se obtiene la fecha de asignacion de la tarea
CURSOR cu_getFechaAsignacion(cn_detalleId number) is
select fe_creacion from info_detalle_historial where id_detalle_historial = (select min(id_detalle_historial) 
from db_soporte.info_detalle_historial where detalle_id = cn_detalleId and estado = 'Asignada');


lv_fecha_archivo                VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
lv_asunto                       VARCHAR2(40)   := 'Generacion de Reporte de Tareas TT';
lv_directorio                   VARCHAR2(50)   := 'DIR_REPORTES_ARCOTEL_CASOS';
lv_nombre_archivo               VARCHAR2(100)  := 'ReporteTareas_'|| lv_fecha_archivo||'.csv';
lv_nombre_archivo_comprimir     VARCHAR2(100)  := '';
lv_Gzip                         VARCHAR2(500)  := '';
Lv_parametro_proyecto_tareas    VARCHAR2(100)  := 'PARAMETROS PROYECTO REPORTE TAREAS TRACE';
Lv_parametro_remitente          VARCHAR2(100)  := 'CORREO_REMITENTE';
Lv_parametro_destinatario       VARCHAR2(100)  := 'CORREO_DESTINATARIO';
Lv_parametro_direcc_reporte     VARCHAR2(100)  := 'DIRECTORIO_REPORTES_TAREAS_TRACE';
Lv_parametro_comando_reporte    VARCHAR2(100)  := 'COMANDO_REPORTE';    
Lv_parametro_extension_repor    VARCHAR2(100)  := 'EXTENSION_REPORTE';  
Lv_parametro_plantilla          VARCHAR2(1000) := 'PLANTILLA_NOTIFICACION_REPORTE_TRACE';  
Lv_tipo_afectado                VARCHAR2(20)   := 'Servicio';
Lv_IpCreacion                   VARCHAR2(30)   := '127.0.0.1';
lv_plantilla_notificacion       VARCHAR2(4000) := '';
lv_remitente                    VARCHAR2(100)  := '';
lv_destinatario                 VARCHAR2(100)  := '';
lv_direccion_completa           VARCHAR2(200)  := '';
lv_comando_ejecutar             VARCHAR2(200)  := '';
lv_trace                        VARCHAR2(4000) := '';
ld_fechaAsignacion              DATE;
lf_archivo                      utl_file.file_type;
lv_delimitador                  VARCHAR2(1) := '|';

BEGIN
null;

--Se crea el archivo
lf_archivo := utl_file.fopen(lv_directorio,lv_nombre_archivo,'w',32767);


IF (C_GetParametro%isopen) THEN 
  CLOSE C_GetParametro;
END IF;

--Se obtiene el remitente
OPEN c_getparametro(Lv_parametro_proyecto_tareas,Lv_parametro_remitente);
FETCH c_getparametro INTO lv_remitente;
CLOSE c_getparametro;

--Se obtiene el destinatario
OPEN c_getparametro(Lv_parametro_proyecto_tareas,Lv_parametro_destinatario);
FETCH c_getparametro INTO lv_destinatario;
CLOSE c_getparametro;

--Se obtiene la url del directorio para los reportes de casos para la arcotel
OPEN c_getparametro(Lv_parametro_proyecto_tareas,Lv_parametro_direcc_reporte);
FETCH c_getparametro INTO lv_direccion_completa;
CLOSE c_getparametro;

--Se obtiene el comando a ejecutar
OPEN C_GetParametro(Lv_parametro_proyecto_tareas,Lv_parametro_comando_reporte);   
FETCH C_GetParametro INTO lv_comando_ejecutar;
CLOSE C_GetParametro; 

--Se obtiene el comando a ejecutar
OPEN C_GetParametro(Lv_parametro_proyecto_tareas,Lv_parametro_extension_repor);
FETCH C_GetParametro INTO Lv_parametro_extension_repor;
CLOSE C_GetParametro;

--Se obtiene la plantilla para la notificacion
OPEN C_GetParametro(Lv_parametro_proyecto_tareas,Lv_parametro_plantilla);
FETCH C_GetParametro INTO Lv_Plantilla_Notificacion;
CLOSE C_GetParametro;


--Se insertan las CABECERAS
utl_file.put_line(lf_archivo, 
                    'NUMERO_TAREA'||lv_delimitador 
                  ||'NOMBRE_TAREA'||lv_delimitador 
                  ||'FE_INICIO_TAREA'||lv_delimitador
                  ||'FE_CIERRE_TAREA'||lv_delimitador
                  ||'NUMERO_CASO'||lv_delimitador
                  ||'FE_APERTURA'||lv_delimitador
                  ||'FE_CIERRE'||lv_delimitador
                  ||'CUADRILLA_ASIGNADA'||lv_delimitador
                  ||'DEPARTAMENTO'||lv_delimitador 
                  ||'ESTADO_FINAL_TAREA'||lv_delimitador 
                  ||'REGION_AFECTADO'||lv_delimitador 
                  ||'EMPRESA_AFECTADO'||lv_delimitador 
                  ||'OFICINA_RESPONSABLE'||lv_delimitador 
                  ||'EMPRESA_RESPONSABLE'||lv_delimitador   
                  ||'SEGUIMIENTOS'||lv_delimitador);


IF (c_get_tareas%isopen) THEN 
  CLOSE c_get_tareas;
END IF;

FOR i IN c_get_tareas(pv_fecha_inicio,pv_fecha_fin) LOOP

--Generar el Trace de la tarea
IF (c_getTrace%isopen) THEN 
  CLOSE c_getTrace;
END IF;

begin

  ld_fechaAsignacion := '';
  if(i.fe_inicio_tarea is null) then
    IF (cu_getFechaAsignacion%isopen) THEN 
      CLOSE cu_getFechaAsignacion;
    END IF;

    --Se obtiene la fecha de asignacion de tarea    
    OPEN cu_getFechaAsignacion(i.detalle_id);
    FETCH cu_getFechaAsignacion INTO ld_fechaAsignacion;
    CLOSE cu_getFechaAsignacion;    

  else

    ld_fechaAsignacion := i.fe_inicio_tarea;

  end if;

  --Se obtiene el trace
  lv_trace := '';
  OPEN c_getTrace(i.detalle_id);
  FETCH c_getTrace INTO lv_trace;
  CLOSE c_getTrace;


  utl_file.put_line(lf_archivo, i.numero_tarea||lv_delimitador      -- 1)numero_tarea
  ||i.nombre_tarea||lv_delimitador                                  -- 2)nombre_tarea
  ||ld_fechaAsignacion||lv_delimitador                              -- 3)fe_inicio_tarea
  ||i.fe_cierre_tarea||lv_delimitador                               -- 4)fe_cierre_tarea
  ||i.numero_caso||lv_delimitador                                   -- 5)numero_caso
  ||i.fecha_apertura||lv_delimitador                                -- 6)fe_apertura
  ||i.fecha_cierre||lv_delimitador                                  -- 7)fe_cierre
  ||i.cuadrilla_asignada||lv_delimitador                            -- 8)cuadrilla_asignada
  ||i.departamento||lv_delimitador                                  -- 9)departamento
  ||i.estado_final_tarea||lv_delimitador                            -- 10)estado_final_tarea
  ||i.region_afectado||lv_delimitador                               -- 11)region_afectado
  ||i.empresa_afectado||lv_delimitador                              -- 12)empresa_afectado
  ||i.oficina_responsable||lv_delimitador                           -- 13)oficina_responsable
  ||i.empresa_responsable||lv_delimitador                           -- 14)empresa_responsable
  ||lv_trace||lv_delimitador                                        -- 15)trace
  );


exception
when others then
lv_trace := '';

end;

END LOOP;

utl_file.fclose(lf_archivo);


--Se arma el comando a ejecutar
Lv_gzip := lv_comando_ejecutar|| ' ' || lv_direccion_completa || Lv_nombre_archivo;

--Armo nombre completo del archivo que se genera
lv_nombre_archivo_comprimir := Lv_nombre_archivo || Lv_parametro_extension_repor;

dbms_output.put_line(naf47_tnet.javaruncommand (lv_Gzip));

/* Se envia notificacion de la generacion del reporte */
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<lv_nombre_archivo_comprimir>>',lv_nombre_archivo_comprimir);
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<pv_fecha_inicio>>',pv_fecha_inicio);
Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<pv_fecha_fin>>',pv_fecha_fin);


db_general.gnrlpck_util.send_email_attach(lv_remitente,lv_destinatario,lv_asunto, Lv_Plantilla_Notificacion,
                                          lv_directorio,lv_nombre_archivo_comprimir);                                        


utl_file.fremove(lv_directorio,lv_nombre_archivo_comprimir);

pv_mensaje_error := 'Proceso realizado con exito';

EXCEPTION
WHEN OTHERS THEN
  pv_mensaje_error := 'COD_ERROR: '||SQLCODE||' - '||sqlerrm;  

  db_general.gnrlpck_util.insert_error('Telcos +', 
                                        'SPKG_REPORTES.P_REPORTE_TAREAS_TT', 
                                        SQLERRM,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                      );  

END P_REPORTE_TAREAS_TT;
--
--
  PROCEDURE P_REPORTE_TAREAS(Pcl_Json    IN  CLOB,
                             Prf_Tareas  OUT SYS_REFCURSOR,
                             Pn_Total    OUT NUMBER,
                             Pv_Status   OUT VARCHAR2,
                             Pv_Message  OUT VARCHAR2) IS

    --Cursor para obtener el n�mero de caso
    CURSOR C_ObtenerCaso(Cn_IdDetalle NUMBER) IS
        SELECT  ICA.ID_CASO,
                ICA.NUMERO_CASO
            FROM DB_SOPORTE.INFO_DETALLE           IDE,
                 DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI,
                 DB_SOPORTE.INFO_CASO              ICA
        WHERE IDE.DETALLE_HIPOTESIS_ID = IDHI.ID_DETALLE_HIPOTESIS
          AND IDHI.CASO_ID             = ICA.ID_CASO
          AND IDE.ID_DETALLE           = Cn_IdDetalle
          AND ROWNUM < 2;

    --Cursor para obtener los afectados
    CURSOR C_ObtenerAfectados(Cn_IdDetalle    NUMBER,
                              Cv_TipoAfectado VARCHAR2,
                              Cn_CasoId       NUMBER) IS

        (SELECT IPAFE.AFECTADO_ID,
               IPAFE.AFECTADO_NOMBRE,
               IPAFE.AFECTADO_DESCRIPCION,
               IPU.DIRECCION
            FROM DB_SOPORTE.INFO_PARTE_AFECTADA    IPAFE,
                 DB_SOPORTE.INFO_CRITERIO_AFECTADO ICAFE,
                 DB_SOPORTE.INFO_DETALLE           IDE,
                 DB_COMERCIAL.INFO_PUNTO           IPU
         WHERE IPAFE.CRITERIO_AFECTADO_ID = ICAFE.ID_CRITERIO_AFECTADO
           AND IPAFE.DETALLE_ID           = ICAFE.DETALLE_ID
           AND IPAFE.DETALLE_ID           = IDE.ID_DETALLE
           AND ICAFE.DETALLE_ID           = IDE.ID_DETALLE
           AND IPAFE.AFECTADO_ID          = IPU.ID_PUNTO
           AND LOWER(IPAFE.TIPO_AFECTADO) = LOWER(Cv_TipoAfectado)
           AND IDE.ID_DETALLE             = Cn_IdDetalle)
         UNION
        (SELECT IPU.ID_PUNTO AS AFECTADO_ID,
                IPU.LOGIN    AS AFECTADO_NOMBRE,
                NVL(IPER.RAZON_SOCIAL,IPER.APELLIDOS||' '||IPER.NOMBRES) AS AFECTADO_DESCRIPCION,
                IPU.DIRECCION
            FROM DB_COMERCIAL.INFO_PUNTO               IPU,
                 DB_COMUNICACION.INFO_COMUNICACION     ICO,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERO,
                 DB_COMERCIAL.INFO_PERSONA             IPER
         WHERE IPU.ID_PUNTO         = ICO.PUNTO_ID
           AND IPERO.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
           AND IPERO.PERSONA_ID     = IPER.ID_PERSONA
           AND ICO.ID_COMUNICACION =
             (SELECT MIN(ICOMIN.ID_COMUNICACION)
                FROM DB_COMUNICACION.INFO_COMUNICACION ICOMIN
              WHERE ICOMIN.DETALLE_ID = Cn_IdDetalle
                AND ICOMIN.PUNTO_ID IS NOT NULL)
           AND IPU.ESTADO IN ('Activo','In-Corte'))
         UNION
        (SELECT IPAFE.AFECTADO_ID,
                IPAFE.AFECTADO_NOMBRE,
                IPAFE.AFECTADO_DESCRIPCION,
                IPU.DIRECCION
            FROM DB_SOPORTE.INFO_PARTE_AFECTADA IPAFE,
                 DB_COMERCIAL.INFO_PUNTO        IPU
         WHERE IPAFE.AFECTADO_ID          = IPU.ID_PUNTO
           AND LOWER(IPAFE.TIPO_AFECTADO) = LOWER(Cv_TipoAfectado)
           AND DETALLE_ID =
             (SELECT MIN(IDE.ID_DETALLE)
                FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI,
                     DB_SOPORTE.INFO_DETALLE           IDE
              WHERE IDHI.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID
                AND IDHI.CASO_ID              = Cn_CasoId));

    --Cursor para obtener los nombres completo de un usuario
    CURSOR C_ObtenerDatosUsuario(Cv_Login VARCHAR2, Cv_Estado VARCHAR2) IS
        SELECT INITCAP(IPE.NOMBRES||' '||IPE.APELLIDOS) NOMBRES
            FROM DB_COMERCIAL.INFO_PERSONA             IPE,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERO
        WHERE IPE.ID_PERSONA      = IPERO.PERSONA_ID
          AND LOWER(IPERO.ESTADO) = LOWER(Cv_Estado)
          AND LOWER(IPE.LOGIN)    = LOWER(Cv_Login)
          AND ROWNUM < 2;

    --Cursor para obtener los contactos de los puntos afectados
    CURSOR C_ObtenerContactos(Cn_IdPunto         NUMBER,
                              Cv_Estado          VARCHAR2,
                              Cn_IdFormaContacto NUMBER) IS
        (SELECT d.VALOR
            FROM DB_COMERCIAL.info_persona                a,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL    b,
                 DB_COMERCIAL.info_punto                  c,
                 DB_COMERCIAL.info_persona_forma_contacto d
         WHERE c.PERSONA_EMPRESA_ROL_ID  = b.ID_PERSONA_ROL
          AND b.PERSONA_ID               = a.ID_PERSONA
          AND d.PERSONA_ID               = a.ID_PERSONA
          AND c.ID_PUNTO                 = Cn_IdPunto
          AND d.ESTADO                   = Cv_Estado
          AND d.FORMA_CONTACTO_ID NOT IN (Cn_IdFormaContacto))
        UNION
        (SELECT b.VALOR
            FROM DB_COMERCIAL.info_punto               c,
                DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO b
         WHERE b.PUNTO_ID          = c.ID_PUNTO
           AND c.ID_PUNTO          = Cn_IdPunto
           AND b.estado            = Cv_Estado
           AND b.FORMA_CONTACTO_ID NOT IN (Cn_IdFormaContacto));

    --Cursor para obtener el correo del usuario quien genera el reporte
    CURSOR C_ObtenerCorreoUsuario(Cv_Estado     VARCHAR2,
                                  Cv_Login      VARCHAR2) IS
        SELECT (LISTAGG(NVEE.MAIL_CIA,',')
                WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE NVEE.LOGIN_EMPLE   = Cv_Login
          AND UPPER(NVEE.ESTADO) = UPPER(Cv_Estado);

    --Cursor para obtener el valor de configuraci�n
    CURSOR C_ParametrosConfiguracion(Cv_NombreParametro VARCHAR2,
                                     Cv_Modulo          VARCHAR2,
                                     Cv_Descripcion     VARCHAR2) IS
    SELECT APCDET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
             DB_GENERAL.ADMI_PARAMETRO_DET APCDET
    WHERE APCAB.ID_PARAMETRO = APCDET.PARAMETRO_ID
      AND UPPER(APCAB.ESTADO)    = 'ACTIVO'
      AND UPPER(APCDET.ESTADO)   = 'ACTIVO'
      AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APCAB.MODULO           = Cv_Modulo
      AND APCDET.DESCRIPCION     = Cv_Descripcion;

    --Variables para el query din�mico
    Lrf_ReporteTareas       SYS_REFCURSOR;
    Lv_QuerySelect          VARCHAR2(2000);
    Lv_Queryfrom            VARCHAR2(1000) := '';
    Lv_From                 VARCHAR2(1000) := '';
    Lv_QueryWhere           VARCHAR2(3000) := '';
    Lv_Where                VARCHAR2(1000) := '';
    Lcl_QueryTareas         CLOB;
    Lr_Tareas               Gr_Tareas;
    Lf_Archivo              UTL_FILE.FILE_TYPE;
    Lv_WhereEcucert         VARCHAR2(3000) := '';

    --Variables de apoyo
    Lb_FiltroCuadrilla      BOOLEAN := FALSE;
    Lv_Estado               VARCHAR2(60) := '''Finalizada'','||'''Cancelada'','||'''Rechazada'','||'''Anulada''';
    Lt_NumeroCaso           DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE;
    Lt_IdCaso               DB_SOPORTE.INFO_CASO.ID_CASO%TYPE;
    Lv_Nombres              VARCHAR2(100);
    Lv_Para                 VARCHAR2(500);
    Lcl_AfectadoNombre      CLOB;
    Lcl_AfectadoDescripcion CLOB;
    Lcl_AfectadoDireccion   CLOB;
    Lcl_FormaContacto       CLOB;

    -- Variables de configuraci�n
    Lv_NombreArchivo             VARCHAR2(100) := 'ReporteTareas_'||to_char(SYSDATE,'RRRRMMDDHH24MISS')||'.csv';
    Lv_NombreParametro           VARCHAR2(25)  := 'PARAMETROS_REPORTE_TAREAS';
    Lv_Modulo                    VARCHAR2(7)   := 'SOPORTE';
    Lv_ParametroRemitente        VARCHAR2(16)  := 'CORREO_REMITENTE';
    Lv_ParametroNombreDirectorio VARCHAR2(25)  := 'NOMBRE_DIRECTORIO_REPORTE';
    Lv_ParametroRutaDirectorio   VARCHAR2(24)  := 'RUTA_DIRECTORIO_REPORTES';
    Lv_ParametroComandoReporte   VARCHAR2(15)  := 'COMANDO_REPORTE';
    Lv_ParametroExtensionReporte VARCHAR2(17)  := 'EXTENSION_REPORTE';
    Lv_ParametroPlantilla        VARCHAR2(22)  := 'PLANTILLA_NOTIFICACION';
    Lv_ParametroAsuntoCorreo     VARCHAR2(13)  := 'ASUNTO_CORREO';

    --Variables en caso que exista error en el reporte de tareas
    Lv_ParametroCorreoError      VARCHAR2(25)  := 'CORREO_DEFECTO_ERROR';
    Lv_ParametroPlantillaError   VARCHAR2(25)  := 'PLANTILLA_ERROR';

    Lv_Delimitador               VARCHAR2(2)   := ';';
    Lt_CorreoRemitente           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_NombreDirectorio          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_RutaDirectorio            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_ComandoReporte            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_ExtensionReporte          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_PlantillaNotificacion     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_AsuntoCorreo              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_CorreoError               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_PlantillaError            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lb_Fexists                   BOOLEAN;
    Ln_FileLength                NUMBER;
    Lbi_BlockSize                BINARY_INTEGER;

    --Filtros para el Query dinamico
    Lv_EstadoTarea            VARCHAR2(4000);
    Lv_IdCuadrilla            VARCHAR2(4000);
    Lv_NombreAsignado         VARCHAR2(4000);
    Lv_Cuadrilla              VARCHAR2(4000) := 'N/A';
    Lv_Departamento           VARCHAR2(100)  := 'N/A';
    Lv_FeSolicitadaDesde      VARCHAR2(20);
    Lv_FeSolicitadaHasta      VARCHAR2(20);
    Lv_FeFinalizadaDesde      VARCHAR2(20);
    Lv_FeFinalizadaHasta      VARCHAR2(20);
    Lv_IdTarea                VARCHAR2(20);
    Lv_DepartamentoOrigen     VARCHAR2(100);
    Lv_CiudadOrigen           VARCHAR2(100);
    Lv_EstadosTareaNotIn      VARCHAR2(200);
    Lv_TareaPadre             VARCHAR2(20);
    Lv_Tipo                   VARCHAR2(100);
    Lv_IdDepartamento         VARCHAR2(20);
    Lv_Origen                 VARCHAR2(100);
    Lv_TodaLasEmpresa         VARCHAR2(100);
    Lv_ExisteFiltro           VARCHAR2(100);
    Lv_ArrayDepartamentos     VARCHAR2(100);
    Lv_TieneCredencial        VARCHAR2(100);
    Lv_DepartamentoSession    VARCHAR2(100);
    Lv_OficinaSession         VARCHAR2(100);
    Lv_OpcionBusqueda         VARCHAR2(100);
    Lv_arrayPersonaEmpresaRol VARCHAR2(100);
    Lv_IdUsuario              VARCHAR2(100);
    Lv_FiltroUsuario          VARCHAR2(100);
    Lv_IntProceso             VARCHAR2(100);
    Lv_Asignado               VARCHAR2(100);
    Lv_Cliente                VARCHAR2(100);
    Lv_Actividad              VARCHAR2(100);
    Lv_Caso                   VARCHAR2(100);
    Lv_CiudadDestino          VARCHAR2(100);
    Lv_FechaDefecto           VARCHAR2(100);
    Lv_UsuarioSolicita        VARCHAR2(100);
    Lv_Empresa                VARCHAR2(100);
    Lv_CodEmpresa             VARCHAR2(50);

    Lv_Json                   VARCHAR2(4000);
    Lv_Codigo                 VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lt_InsertaOk              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lv_InsertarErrorOk        VARCHAR2(25) := 'INSERTAR_ERROR_OK';
    Lv_EsConsulta             VARCHAR2(3);
    Lv_Start                  VARCHAR2(10);
    Lv_Limit                  VARCHAR2(10);
    Lv_VerTareasEcucert       VARCHAR2(10);

  BEGIN

    IF C_ObtenerCaso%ISOPEN THEN
        CLOSE C_ObtenerCaso;
    END IF;

    IF C_ObtenerAfectados%ISOPEN THEN
        CLOSE C_ObtenerAfectados;
    END IF;

    IF C_ObtenerDatosUsuario%ISOPEN THEN
        CLOSE C_ObtenerDatosUsuario;
    END IF;

    IF C_ObtenerContactos%ISOPEN THEN
        CLOSE C_ObtenerContactos;
    END IF;

    IF C_ObtenerCorreoUsuario%ISOPEN THEN
        CLOSE C_ObtenerCorreoUsuario;
    END IF;

    IF C_ParametrosConfiguracion%ISOPEN THEN
        CLOSE C_ParametrosConfiguracion;
    END IF;

    apex_json.parse(Pcl_Json);
    Lv_UsuarioSolicita := apex_json.get_varchar2('strUsuarioSolicita');--Obtenemos el usuario quien realiza la petici�n
    Lv_EsConsulta      := apex_json.get_varchar2('esConsulta');
    Lv_Start           := apex_json.get_varchar2('start');
    Lv_Limit           := apex_json.get_varchar2('limit');

    IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

        --Se habren los cursores para obtener las informaciones necesarias para completar el flujo del reporte.
        OPEN C_ObtenerCorreoUsuario('A',Lv_UsuarioSolicita);
            FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
        CLOSE C_ObtenerCorreoUsuario;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRemitente);
            FETCH C_ParametrosConfiguracion INTO Lt_CorreoRemitente;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroNombreDirectorio);
            FETCH C_ParametrosConfiguracion INTO Lt_NombreDirectorio;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRutaDirectorio);
            FETCH C_ParametrosConfiguracion INTO Lt_RutaDirectorio;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroComandoReporte);
            FETCH C_ParametrosConfiguracion INTO Lt_ComandoReporte;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroExtensionReporte);
            FETCH C_ParametrosConfiguracion INTO Lt_ExtensionReporte;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantilla);
            FETCH C_ParametrosConfiguracion INTO Lt_PlantillaNotificacion;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroAsuntoCorreo);
            FETCH C_ParametrosConfiguracion INTO Lt_AsuntoCorreo;
        CLOSE C_ParametrosConfiguracion;

        --CURSORES PARA OBTENER LA INFORMAION POR SI DA ERROR EL PROCESO
        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroCorreoError);
            FETCH C_ParametrosConfiguracion INTO Lt_CorreoError;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantillaError);
            FETCH C_ParametrosConfiguracion INTO Lt_PlantillaError;
        CLOSE C_ParametrosConfiguracion;

        OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_InsertarErrorOk);
            FETCH C_ParametrosConfiguracion INTO Lt_InsertaOk;
        CLOSE C_ParametrosConfiguracion;

    END IF;

    --Parseo del Json de Tareas.
    Lv_IdTarea                := apex_json.get_varchar2('tarea');
    Lv_DepartamentoOrigen     := apex_json.get_varchar2('departamentoOrig');
    Lv_CiudadOrigen           := apex_json.get_varchar2('ciudadOrigen');
    Lv_EstadoTarea            := apex_json.get_varchar2('estado');
    Lv_EstadosTareaNotIn      := apex_json.get_varchar2('estadosTareaNotIn');
    Lv_TareaPadre             := apex_json.get_varchar2('tareaPadre');
    Lv_FeSolicitadaDesde      := apex_json.get_varchar2('feSolicitadaDesde');
    Lv_FeSolicitadaHasta      := apex_json.get_varchar2('feSolicitadaHasta');
    Lv_FeFinalizadaDesde      := apex_json.get_varchar2('feFinalizadaDesde');
    Lv_FeFinalizadaHasta      := apex_json.get_varchar2('feFinalizadaHasta');
    Lv_Tipo                   := apex_json.get_varchar2('tipo');
    Lv_IdDepartamento         := apex_json.get_varchar2('idDepartamento');
    Lv_NombreAsignado         := apex_json.get_varchar2('nombreAsignado');
    Lv_Origen                 := apex_json.get_varchar2('strOrigen');
    Lv_TodaLasEmpresa         := apex_json.get_varchar2('strTodaLasEmpresa');
    Lv_ExisteFiltro           := apex_json.get_varchar2('existeFiltro');
    Lv_ArrayDepartamentos     := apex_json.get_varchar2('arrayDepartamentosP');
    Lv_TieneCredencial        := apex_json.get_varchar2('strTieneCredencial');
    Lv_DepartamentoSession    := apex_json.get_varchar2('departamentoSession');
    Lv_OficinaSession         := apex_json.get_varchar2('oficinaSession');
    Lv_OpcionBusqueda         := apex_json.get_varchar2('strOpcionBusqueda');
    Lv_arrayPersonaEmpresaRol := apex_json.get_varchar2('arrayPersonaEmpresaRolP');
    Lv_IdUsuario              := apex_json.get_varchar2('idUsuario');
    Lv_FiltroUsuario          := apex_json.get_varchar2('filtroUsuario');
    Lv_IntProceso             := apex_json.get_varchar2('intProceso');
    Lv_Asignado               := apex_json.get_varchar2('asignado');
    Lv_IdCuadrilla            := apex_json.get_varchar2('idCuadrilla');
    Lv_Cliente                := apex_json.get_varchar2('cliente');
    Lv_Actividad              := apex_json.get_varchar2('actividad');
    Lv_Caso                   := apex_json.get_varchar2('caso');
    Lv_CiudadDestino          := apex_json.get_varchar2('ciudadDestino');
    Lv_FechaDefecto           := apex_json.get_varchar2('strFechaDefecto');
    Lv_Empresa                := apex_json.get_varchar2('strNombreEmpresa');
    Lv_CodEmpresa             := apex_json.get_varchar2('codEmpresa');
    Lv_VerTareasEcucert       := apex_json.get_varchar2('strVerTareasEcucert');

    --Creaci�n del Query.
    Lv_QuerySelect := 'SELECT /*+ RESULT_CACHE */ ' ||
                             'IDE.ID_DETALLE AS ID_DETALLE, '||
                             'IDE.LATITUD AS LATITUD, '||
                             'IDE.LONGITUD AS LONGITUD, '||
                             'IDE.USR_CREACION AS USR_CREACION_DETALLE, '||
                             'IDE.DETALLE_ID_RELACIONADO AS DETALLE_ID_RELACIONADO, '||
                             'TO_CHAR(IDE.FE_CREACION,''RRRR-MM-DD HH24:MI'') AS FE_CREACION_DETALLE, '||
                             'TO_CHAR(IDE.FE_SOLICITADA,''RRRR-MM-DD HH24:MI'') AS FE_SOLICITADA, '||
                             'IDE.OBSERVACION AS OBSERVACION, '||
                             'ATA.ID_TAREA AS ID_TAREA, '||
                             'ATA.NOMBRE_TAREA AS NOMBRE_TAREA, '||
                             'ATA.DESCRIPCION_TAREA AS DESCRIPCION_TAREA, '||
                             'APR.NOMBRE_PROCESO AS NOMBRE_PROCESO, '||
                             'IDA.ASIGNADO_ID AS ASIGNADO_ID, '||
                             'IDA.ASIGNADO_NOMBRE AS ASIGNADO_NOMBRE, '||
                             'IDA.REF_ASIGNADO_ID AS REF_ASIGNADO_ID, '||
                             'IDA.REF_ASIGNADO_NOMBRE AS REF_ASIGNADO_NOMBRE, '||
                             'IDA.PERSONA_EMPRESA_ROL_ID AS PERSONA_EMPRESA_ROL_ID, '||
                             'TO_CHAR(IDA.FE_CREACION,''RRRR-MM-DD HH24:MI'') AS FE_CREACION_ASIGNACION, '||
                             'IDA.DEPARTAMENTO_ID AS DEPARTAMENTO_ID, '||
                             'IDA.TIPO_ASIGNADO AS TIPO_ASIGNADO, '||
                             'IDH.ESTADO AS ESTADO, '||
                             'IDH.ID_DETALLE_HISTORIAL AS ID_DETALLE_HISTORIAL, '||
                             'TO_CHAR(IDH.FE_CREACION,''RRRR-MM-DD HH24:MI'') AS FE_CREACION, '||
                             'IDH.USR_CREACION AS USR_CREACION, '||
                             'IDH.OBSERVACION AS OBSERVACION_HISTORIAL, '||
                             'IDH.ASIGNADO_ID AS ASIGNADO_ID_HIS, '||
                             'IDH.DEPARTAMENTO_ORIGEN_ID AS DEPARTAMENTO_ORIGEN_ID ';

    Lv_QuerySelect := Lv_QuerySelect || ',(SELECT MIN(infoComunicacion.ID_COMUNICACION) '||
                                            'FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion '||
                                          'WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA';

    Lv_Queryfrom := ' FROM DB_SOPORTE.INFO_DETALLE IDE, '||
                          'DB_SOPORTE.INFO_DETALLE_ASIGNACION IDA, '||
                          'DB_SOPORTE.INFO_DETALLE_HISTORIAL  IDH, '||
                          'DB_SOPORTE.ADMI_TAREA ATA, '||
                          'DB_SOPORTE.ADMI_PROCESO APR';

    Lv_QueryWhere := ' WHERE IDE.ID_DETALLE = IDA.DETALLE_ID '||
                        'AND IDE.ID_DETALLE = IDH.DETALLE_ID '||
                        'AND IDE.TAREA_ID   = ATA.ID_TAREA '||
                        'AND APR.ID_PROCESO = ATA.PROCESO_ID';

    Lv_Where := ' AND IDA.ID_DETALLE_ASIGNACION = '||
                     '(SELECT MAX(IDAMAX.ID_DETALLE_ASIGNACION) '||
                         'FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDAMAX '||
                      'WHERE IDAMAX.DETALLE_ID = IDE.ID_DETALLE) '||
                 'AND IDH.ID_DETALLE_HISTORIAL = '||
                     '(SELECT MAX(IDHMAX.ID_DETALLE_HISTORIAL) '||
                         'FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHMAX '||
                      'WHERE IDHMAX.DETALLE_ID = IDE.ID_DETALLE)';

    IF Lv_Actividad IS NOT NULL THEN
        Lv_Queryfrom  := Lv_Queryfrom || ', DB_COMUNICACION.INFO_COMUNICACION ICOM ';
        Lv_QueryWhere := Lv_QueryWhere ||' AND ICOM.DETALLE_ID = IDE.ID_DETALLE '||
                                          'AND ICOM.ID_COMUNICACION = :numeroActividad';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':numeroActividad',Lv_Actividad);
    END IF;

    IF Lv_IdTarea IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND ATA.ID_TAREA = :tarea';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tarea',Lv_IdTarea);
    END IF;

    IF Lv_DepartamentoOrigen IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.DEPARTAMENTO_ID = :departamentoId';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':departamentoId',Lv_DepartamentoOrigen);
    END IF;

    IF Lv_CiudadOrigen IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.CANTON_ID = :ciudadOrigen';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':ciudadOrigen',Lv_CiudadOrigen);
    END IF;

    IF Lv_EstadoTarea IS NOT NULL AND Lv_EstadoTarea != 'Todos' THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(IDH.ESTADO) IN (:estado)';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':estado',Lv_EstadoTarea);
    END IF;

    IF Lv_EstadosTareaNotIn IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND IDH.ESTADO NOT IN (:paramEstadosTareaNotIn)';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadosTareaNotIn',Lv_EstadosTareaNotIn);
    END IF;

    IF Lv_TareaPadre IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND IDE.DETALLE_ID_RELACIONADO = '||
                                            '(SELECT ICOP.DETALLE_ID '||
                                                'FROM DB_COMUNICACION.INFO_COMUNICACION ICOP '||
                                             'WHERE ICOP.ID_COMUNICACION = :tareaPadre)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tareaPadre',Lv_TareaPadre);
    END IF;

    IF Lv_FeSolicitadaDesde IS NOT NULL THEN
        Lv_FeSolicitadaDesde := TO_CHAR(TO_dATE(Lv_FeSolicitadaDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(IDE.FE_SOLICITADA,''RRRR-MM-DD'') >= :feSolicitadaDesde';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feSolicitadaDesde',''''||Lv_FeSolicitadaDesde||'''');
    END IF;

    IF Lv_FeSolicitadaHasta IS NOT NULL THEN
        Lv_FeSolicitadaHasta := TO_CHAR(TO_dATE(Lv_FeSolicitadaHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(IDE.FE_SOLICITADA,''RRRR-MM-DD'') <= :feSolicitadaHasta';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feSolicitadaHasta',''''||Lv_FeSolicitadaHasta||'''');
    END IF;

    IF Lv_FeFinalizadaDesde IS NOT NULL THEN
        Lv_FeFinalizadaDesde := TO_CHAR(TO_dATE(Lv_FeFinalizadaDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(IDH.FE_CREACION,''RRRR-MM-DD'') >= :feFinalizadaDesde';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feFinalizadaDesde',''''||Lv_FeFinalizadaDesde||'''');
    END IF;

    IF Lv_FeFinalizadaHasta IS NOT NULL THEN
        Lv_FeFinalizadaHasta := TO_CHAR(TO_dATE(Lv_FeFinalizadaHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(IDH.FE_CREACION,''RRRR-MM-DD'') <= :feFinalizadaDesde';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feFinalizadaDesde',''''||Lv_FeFinalizadaHasta||'''');
    END IF;

    IF Lv_Tipo IS NOT NULL THEN

        IF Lv_Tipo = 'ByDepartamento'THEN

            IF Lv_IdDepartamento IS NOT NULL AND
               Lv_NombreAsignado IS NOT NULL AND
               Lv_Tipo = 'ByDepartamento' THEN

                IF Lv_Origen = 'tareasPorDepartamento' THEN

                    Lv_From  := ', DB_SOPORTE.INFO_DETALLE_TAREAS IDT';
                    Lv_Where := ' AND IDE.ID_DETALLE = IDT.DETALLE_ID '||
                                 'AND IDA.ID_DETALLE_ASIGNACION = IDT.DETALLE_ASIGNACION_ID '||
                                 'AND IDH.ID_DETALLE_HISTORIAL = IDT.DETALLE_HISTORIAL_ID';

                    IF UPPER(Lv_TodaLasEmpresa) = 'S' THEN
                        Lv_QueryWhere := Lv_QueryWhere || ' AND IDE.ID_DETALLE IN ( '||
                                                             'SELECT A.DETALLE_ID '||
                                                               'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                             'WHERE A.DEPARTAMENTO_ID IN (:paramDepartamentosEmpresas) '||
                                                               'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                           'AND IDH.ESTADO NOT IN (:paramEstadoHistorial)';

                        IF UPPER(Lv_ExisteFiltro) = 'S' THEN
                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentosEmpresas',Lv_IdDepartamento);
                        ELSE
                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentosEmpresas',Lv_ArrayDepartamentos);
                        END IF;
                    ELSE
                        IF UPPER(Lv_TieneCredencial) = 'S'THEN
                            Lv_QueryWhere := Lv_QueryWhere || ' AND IDE.ID_DETALLE IN ( '||
                                                                 'SELECT A.DETALLE_ID '||
                                                                   'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                                 'WHERE A.DEPARTAMENTO_ID = (:paramDepartamentoSession) '||
                                                                   'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                               'AND IDH.ESTADO NOT IN (:paramEstadoHistorial)';

                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentoSession',Lv_DepartamentoSession);
                         ELSE
                           Lv_QueryWhere := Lv_QueryWhere || ' AND IDE.ID_DETALLE IN ( '||
                                                                 'SELECT A.DETALLE_ID '||
                                                                   'FROM DB_SOPORTE.INFO_DETALLE_TAREAS A '||
                                                                 'WHERE A.DEPARTAMENTO_ID = (:paramDepartamentoSession) '||
                                                                   'AND A.OFICINA_ID = :paramOficinaSession '||
                                                                   'AND A.ESTADO NOT IN (:paramEstadoHistorial)) '||
                                                               'AND IDH.ESTADO NOT IN (:paramEstadoHistorial)';

                           Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDepartamentoSession',Lv_DepartamentoSession);
                           Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramOficinaSession',Lv_OficinaSession);
                        END IF;
                    END IF;

                    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoHistorial',Lv_Estado);

                ELSE

                    IF Lv_TareaPadre IS NULL THEN

                        IF UPPER(Lv_OpcionBusqueda) = 'N' AND Lv_arrayPersonaEmpresaRol IS NOT NULL THEN

                            Lv_From  := ', DB_SOPORTE.INFO_DETALLE_TAREAS IDT';
                            Lv_Where := ' AND IDE.ID_DETALLE = IDT.DETALLE_ID '||
                                         'AND IDA.ID_DETALLE_ASIGNACION = IDT.DETALLE_ASIGNACION_ID '||
                                         'AND IDH.ID_DETALLE_HISTORIAL = IDT.DETALLE_HISTORIAL_ID';

                            Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.PERSONA_EMPRESA_ROL_ID IN (:paramPersonaEmpresaRol) '||
                                                              'AND IDH.ESTADO NOT IN (:paramEstadoHistorial)';

                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramPersonaEmpresaRol',Lv_arrayPersonaEmpresaRol);
                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoHistorial',Lv_Estado);
                        ELSE
                            Lv_QueryWhere := Lv_QueryWhere || ' AND IDA.ASIGNADO_ID = :asignadoId '||
                                                               'AND UPPER(IDA.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdDepartamento);
                            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');

                        END IF;
                    END IF;
                END IF;

            END IF;

            IF Lv_IdUsuario IS NOT NULL AND Lv_FiltroUsuario = 'ByUsuario' THEN
                Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.REF_ASIGNADO_ID = :refAsignadoId';
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoId',Lv_IdUsuario);
            END IF;

            IF Lv_IntProceso IS NOT NULL THEN
                Lv_QueryWhere := Lv_QueryWhere ||' AND ATA.PROCESO_ID = :paramProcesoId';
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramProcesoId',Lv_IntProceso);
            END IF;

            IF Lv_Asignado IS NOT NULL THEN
                Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(IDA.REF_ASIGNADO_NOMBRE) like UPPER(:refAsignadoNombre)';
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoNombre','''%'||Lv_Asignado||'%''');
            END IF;

        ELSIF Lv_Tipo = 'ByCuadrilla' AND Lv_IdCuadrilla IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN

            Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.TIPO_ASIGNADO = :tipoAsignado';
            Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAsignado','''CUADRILLA''');

            IF Lv_IdCuadrilla != 'Todos' THEN
                Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.ASIGNADO_ID IN (:asignadoId) '||
                                                  'AND UPPER(IDA.ASIGNADO_NOMBRE) IN (:asignadoNombre)';

                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdCuadrilla);
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',Lv_NombreAsignado);
            END IF;

        ELSE
            IF Lv_IdCuadrilla IS NOT NULL THEN
                Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.TIPO_ASIGNADO = :tipoAsignado';
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAsignado','''CUADRILLA''');

                IF Lv_IdCuadrilla != 'Todos' THEN
                    Lv_QueryWhere := Lv_QueryWhere ||' AND IDA.ASIGNADO_ID = :asignadoId '||
                                                      'AND UPPER(IDA.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdCuadrilla);
                    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');
                END IF;
                Lb_FiltroCuadrilla := TRUE;
            END IF;

            IF Lv_Asignado IS NOT NULL AND NOT Lb_FiltroCuadrilla THEN

                Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(IDA.REF_ASIGNADO_NOMBRE) LIKE UPPER(:refAsignadoNombre)';
                Lv_QueryWhere := REPLACE(Lv_QueryWhere,':refAsignadoNombre','''%'||TRIM(Lv_Asignado)||'%''');

                IF Lv_IdDepartamento IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
                    Lv_QueryWhere := Lv_QueryWhere ||' AND IDH.ASIGNADO_ID = :asignadoId '||
                                                      'AND UPPER(IDH.ASIGNADO_NOMBRE) = UPPER(:asignadoNombre)';

                    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoId',Lv_IdDepartamento);
                    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':asignadoNombre',''''||Lv_NombreAsignado||'''');
                END IF;
            END IF;

        END IF;

    END IF;

    IF Lv_Cliente IS NOT NULL THEN
        Lv_QueryWhere := Lv_QueryWhere ||' AND EXISTS ( '||
                                            'SELECT PA1.ID_PARTE_AFECTADA '             ||
                                              'FROM DB_SOPORTE.INFO_PARTE_AFECTADA PA1 '||
                                            'WHERE IDE.ID_DETALLE    = PA1.DETALLE_ID ' ||
                                              'AND PA1.TIPO_AFECTADO = :tipoAfectado '  ||
                                              'AND PA1.AFECTADO_ID   = :afectadoId) ';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':afectadoId',Lv_Cliente);
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAfectado','''Cliente''');
    END IF;

    IF Lv_Caso IS NOT NULL THEN
        Lv_Queryfrom  := Lv_Queryfrom || ', DB_SOPORTE.INFO_CASO ICASO'||
                                         ', DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHI';

        Lv_QueryWhere := Lv_QueryWhere ||' AND ICASO.NUMERO_CASO = :numeroCaso '||
                                          'AND ICASO.ID_CASO = IDHI.CASO_ID '||
                                          'AND IDHI.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':numeroCaso',''''||Lv_Caso||'''');
    END IF;

    IF Lv_CiudadDestino IS NOT NULL THEN
        Lv_Queryfrom  := Lv_Queryfrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL infoPersonaEmpresaRol';

        Lv_QueryWhere := Lv_QueryWhere ||' AND IDH.PERSONA_EMPRESA_ROL_ID = infoPersonaEmpresaRol.ID_PERSONA_ROL  '||
                                          'AND infoPersonaEmpresaRol.OFICINA_ID IN '||
                                            '(SELECT infoOficinaGrupo.ID_OFICINA '||
                                                'FROM DB_COMERCIAL.INFO_OFICINA_GRUPO infoOficinaGrupo '||
                                             'WHERE infoOficinaGrupo.CANTON_ID = :cantonIdD)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':cantonIdD',Lv_CiudadDestino);
    END IF;

    IF Lv_FeSolicitadaDesde IS NULL AND Lv_FeSolicitadaHasta IS NULL AND
       Lv_FeFinalizadaDesde IS NULL AND Lv_FeFinalizadaHasta IS NULL AND
       Lv_FechaDefecto IS NOT NULL THEN

        Lv_FechaDefecto := TO_CHAR(TO_dATE(Lv_FechaDefecto,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(IDE.FE_CREACION,''RRRR-MM-DD'') >= :fechaDefault';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':fechaDefault',''''||Lv_FechaDefecto||'''');

    END IF;

    --Query completo
    Lcl_QueryTareas := Lv_QuerySelect ||
                       Lv_Queryfrom   ||
                       Lv_From        ||
                       Lv_QueryWhere  ||
                       Lv_Where       || ' ORDER BY IDE.FE_SOLICITADA DESC';

    IF UPPER(Lv_EsConsulta) = 'S' THEN

        IF Lv_VerTareasEcucert IS NULL OR Lv_VerTareasEcucert = 'N' THEN
            Lv_WhereEcucert := ' WHERE NOT EXISTS
                                                (SELECT IID.COMUNICACION_ID
                                                FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
                                                WHERE CONSULTA.NUMERO_TAREA=IID.COMUNICACION_ID) ' ;
        ELSE
            Lv_WhereEcucert := ' WHERE EXISTS
                                                (SELECT IID.COMUNICACION_ID
                                                FROM DB_SOPORTE.INFO_INCIDENCIA_DET IID
                                                WHERE CONSULTA.NUMERO_TAREA=IID.COMUNICACION_ID) ' ;
        END IF;

        EXECUTE IMMEDIATE 'SELECT COUNT(CONSULTA.ID_DETALLE)' ||
                          'FROM ( SELECT IDE.ID_DETALLE,(SELECT MIN(infoComunicacion.ID_COMUNICACION) '||
                                    'FROM DB_COMUNICACION.INFO_COMUNICACION infoComunicacion '||
                                    'WHERE infoComunicacion.DETALLE_ID = IDE.ID_DETALLE) AS NUMERO_TAREA '||
                           Lv_Queryfrom||
                           Lv_From||
                           Lv_QueryWhere||
                           Lv_Where || ' ) CONSULTA '||
                           Lv_WhereEcucert
                           INTO Pn_Total;

        Lv_WhereEcucert := Lv_WhereEcucert || ' ORDER BY CONSULTA.FE_SOLICITADA DESC ';

        IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL THEN

            Lv_Limit :=  Lv_Start + Lv_Limit;

            Lcl_QueryTareas := 'SELECT RESULTADO2.* '|| ' FROM ( SELECT RESULTADO.*, ROWNUM AS NUMERO_ROWNUM2 '||
                'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                        'FROM ('||Lcl_QueryTareas||') CONSULTA '||
                         Lv_WhereEcucert|| ' ) RESULTADO WHERE ROWNUM <= :intFin )  RESULTADO2 '||
            'WHERE RESULTADO2.NUMERO_ROWNUM2 > :intInicio '|| ' ORDER BY RESULTADO2.FE_SOLICITADA DESC ';

            Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intFin'   ,Lv_Limit);
            Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intInicio',Lv_Start);

        ELSE

            IF Lv_Limit IS NOT NULL THEN

                Lcl_QueryTareas := 'SELECT RESULTADO.* FROM ( SELECT CONSULTA.* '||
                                        'FROM ('||Lcl_QueryTareas||') CONSULTA '||
                                         Lv_WhereEcucert || ') RESULTADO WHERE ROWNUM <= :intFin ORDER BY RESULTADO.FE_SOLICITADA DESC ';

                Lcl_QueryTareas := REPLACE(Lcl_QueryTareas,':intFin',Lv_Limit);

            END IF;

        END IF;

    ELSE

        --Se crea el archivo
        Lf_Archivo := UTL_FILE.FOPEN(Lt_NombreDirectorio,Lv_NombreArchivo,'w',32767);

        --Criterios de consulta
        IF Lv_Caso IS NULL THEN
            Lv_Caso := 'Todos';
        END IF;

        IF Lv_Actividad IS NULL THEN
            Lv_Actividad := 'Todos';
        END IF;

        IF Lv_Asignado IS NULL THEN
            Lv_Asignado := 'Todos';
        END IF;

        IF Lv_EstadoTarea IS NULL THEN
            Lv_EstadoTarea := 'Todos';
        END IF;

        IF Lv_IdCuadrilla IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
            Lv_Cuadrilla := Lv_NombreAsignado;
        END IF;

        IF Lv_IdDepartamento IS NOT NULL AND Lv_NombreAsignado IS NOT NULL THEN
            Lv_Departamento := Lv_NombreAsignado || ' ('||Lv_Empresa||')';
        END IF;

        IF Lv_FeSolicitadaDesde IS NULL THEN
            Lv_FeSolicitadaDesde := 'Todos';
        END IF;

        IF Lv_FeSolicitadaHasta IS NULL THEN
            Lv_FeSolicitadaHasta := 'Todos';
        END IF;

        IF Lv_FeFinalizadaDesde IS NULL THEN
            Lv_FeFinalizadaDesde := 'Todos';
        END IF;

        IF Lv_FeFinalizadaHasta IS NULL THEN
            Lv_FeFinalizadaHasta := 'Todos';
        END IF;

        --Criterios del Reporte
        UTL_FILE.PUT_LINE(Lf_Archivo,
                  'USUARIO QUE GENERA: '||Lv_Delimitador
                ||Lv_Delimitador||Lv_UsuarioSolicita||chr(13)
                ||'FECHA DE GENERACION: '||Lv_Delimitador
                ||Lv_Delimitador||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||chr(13)||chr(13)
                ||'ASIGNADO: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_Asignado||chr(13)
                ||'ESTADO: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_EstadoTarea||chr(13)
                ||'NUMERO DE TAREA: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_Actividad||chr(13)
                ||'NUMERO DE CASO: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_Caso||chr(13)
                ||'FECHA SOLICITADA: ' ||Lv_Delimitador
                                ||'DESDE: '||Lv_Delimitador||Lv_FeSolicitadaDesde||chr(13)
                ||Lv_Delimitador||'HASTA: '||Lv_Delimitador||Lv_FeSolicitadaHasta||chr(13)
                ||'FECHA ESTADO: ' ||Lv_Delimitador
                                ||'DESDE: ' ||Lv_Delimitador||Lv_FeFinalizadaDesde||chr(13)
                ||Lv_Delimitador||'HASTA: ' ||Lv_Delimitador||Lv_FeFinalizadaHasta||chr(13)
                ||'DEPARTAMENTO: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_Departamento||chr(13)
                ||'CUADRILLA: ' ||Lv_Delimitador
                ||Lv_Delimitador||Lv_Cuadrilla||chr(13)
                ||chr(13)||chr(13));

        -- Detalle del Reporte
        UTL_FILE.PUT_LINE(Lf_Archivo,
                     'NUMERO DE TAREA'||Lv_Delimitador
                   ||'NUMERO DE CASO'||Lv_Delimitador
                   ||'PTO. CLIENTE'||Lv_Delimitador
                   ||'NOMBRE CLIENTE'||Lv_Delimitador
                   ||'DIRECCION PT. CLIENTE'||Lv_Delimitador
                   ||'NOMBRE PROCESO'||Lv_Delimitador
                   ||'NOMBRE TAREA'||Lv_Delimitador
                   ||'OBSERVACION'||Lv_Delimitador
                   ||'RESPONSABLE ASIGNADO'||Lv_Delimitador
                   ||'FECHA CREACION' ||Lv_Delimitador
                   ||'FECHA EJECUCION'||Lv_Delimitador
                   ||'ACTUALIZADO POR'||Lv_Delimitador
                   ||'FECHA ESTADO'||Lv_Delimitador
                   ||'ESTADO'||Lv_Delimitador
                   ||'CONTACTOS'||Lv_Delimitador);

    END IF;

    DBMS_OUTPUT.PUT_LINE(Lcl_QueryTareas);

    IF UPPER(Lv_EsConsulta) = 'S' THEN

        OPEN Prf_Tareas FOR Lcl_QueryTareas;

    ELSE

        OPEN Lrf_ReporteTareas FOR Lcl_QueryTareas;

            LOOP

                FETCH Lrf_ReporteTareas INTO Lr_Tareas;

                EXIT WHEN Lrf_ReporteTareas%NOTFOUND;

                OPEN C_ObtenerCaso(Lr_Tareas.ID_DETALLE);
                    FETCH C_ObtenerCaso INTO Lt_IdCaso,Lt_NumeroCaso;
                CLOSE C_ObtenerCaso;

                FOR Afectados IN C_ObtenerAfectados(Lr_Tareas.ID_DETALLE,'cliente',Lt_IdCaso) LOOP

                    IF LENGTH(Lcl_AfectadoNombre) <= 2000 OR Lcl_AfectadoNombre IS NULL THEN
                        IF Lcl_AfectadoNombre IS NULL AND Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                            Lcl_AfectadoNombre := Afectados.AFECTADO_NOMBRE;
                        ELSE
                            IF Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                                Lcl_AfectadoNombre := Lcl_AfectadoNombre||','||Afectados.AFECTADO_NOMBRE;
                            END IF;
                        END IF;
                    END IF;

                    IF LENGTH(Lcl_AfectadoDescripcion) <= 2000 OR Lcl_AfectadoDescripcion IS NULL THEN
                        IF Lcl_AfectadoDescripcion IS NULL AND Afectados.AFECTADO_DESCRIPCION IS NOT NULL THEN
                            Lcl_AfectadoDescripcion := Afectados.AFECTADO_DESCRIPCION;
                        ELSE
                            IF Afectados.AFECTADO_NOMBRE IS NOT NULL THEN
                                Lcl_AfectadoDescripcion := Lcl_AfectadoDescripcion||','||Afectados.AFECTADO_DESCRIPCION;
                            END IF;
                        END IF;
                    END IF;

                    IF LENGTH(Lcl_AfectadoDireccion) <= 2000 OR Lcl_AfectadoDireccion IS NULL THEN
                        IF Lcl_AfectadoDireccion IS NULL AND Afectados.DIRECCION IS NOT NULL THEN
                            Lcl_AfectadoDireccion := Afectados.DIRECCION;
                        ELSE
                            IF Afectados.DIRECCION IS NOT NULL THEN
                                Lcl_AfectadoDireccion := Lcl_AfectadoDireccion||','||Afectados.DIRECCION;
                            END IF;
                        END IF;
                    END IF;

                    FOR Contactos IN C_ObtenerContactos(Afectados.AFECTADO_ID,'Activo',5) LOOP

                        IF LENGTH(Lcl_FormaContacto) <= 2000 OR Lcl_FormaContacto IS NULL THEN

                           IF Lcl_FormaContacto IS NULL AND Contactos.VALOR IS NOT NULL THEN
                                Lcl_FormaContacto := Contactos.VALOR;
                            ELSE
                                IF Contactos.VALOR IS NOT NULL THEN
                                    Lcl_FormaContacto := Lcl_FormaContacto||','||Contactos.VALOR;
                                END IF;
                            END IF;

                        END IF;

                    END LOOP;

                END LOOP;

                OPEN C_ObtenerDatosUsuario(Lr_Tareas.USR_CREACION,'Activo');
                    FETCH C_ObtenerDatosUsuario INTO Lv_nombres;
                CLOSE C_ObtenerDatosUsuario;

                UTL_FILE.PUT_LINE(Lf_Archivo,

                            Lr_Tareas.NUMERO_TAREA ||Lv_Delimitador||

                            Lt_NumeroCaso ||Lv_Delimitador||

                            NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lcl_AfectadoNombre,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                )),'')||Lv_Delimitador||

                            NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lcl_AfectadoDescripcion,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                )),'')||Lv_Delimitador||

                            NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lcl_AfectadoDireccion,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                )),'')||Lv_Delimitador||

                            NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Tareas.NOMBRE_PROCESO,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                            NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Tareas.NOMBRE_TAREA,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                            NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Tareas.OBSERVACION,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                            NVL(INITCAP(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Tareas.REF_ASIGNADO_NOMBRE,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                )),'')||Lv_Delimitador||

                            Lr_Tareas.FE_CREACION_DETALLE||Lv_Delimitador||

                            Lr_Tareas.FE_SOLICITADA||Lv_Delimitador||

                            NVL(TRIM(REPLACE(REPLACE(REPLACE(
                                    lv_nombres,Chr(9),' '),
                                    Chr(10),' '),
                                    Chr(13),' ')),'')||Lv_Delimitador||

                            Lr_Tareas.FE_CREACION||Lv_Delimitador||

                            Lr_Tareas.ESTADO ||Lv_Delimitador||

                            NVL(TRIM(REPLACE(REPLACE(REPLACE(
                                    Lcl_FormaContacto,Chr(9),' '),
                                    Chr(10),' '),
                                    Chr(13),' ')),'')||Lv_Delimitador);

                Lt_IdCaso               := NULL;
                Lt_NumeroCaso           := NULL;
                Lcl_AfectadoNombre      := NULL;
                Lcl_AfectadoDescripcion := NULL;
                Lcl_AfectadoDireccion   := NULL;
                Lv_nombres              := NULL;
                Lcl_FormaContacto       := NULL;

            END LOOP;

        CLOSE Lrf_ReporteTareas;

    END IF;

    IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

        --Cierre del Archivo
        UTL_FILE.FCLOSE(Lf_Archivo);

        --Ejecuci�n del comando para crear el archivo comprimido
        DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lt_ComandoReporte||' '||Lt_RutaDirectorio||Lv_NombreArchivo));

        --Envio del archivo por correo
        DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lt_CorreoRemitente,
                                                  Lv_Para||',',
                                                  Lt_AsuntoCorreo,
                                                  Lt_PlantillaNotificacion,
                                                  Lt_NombreDirectorio,
                                                  Lv_NombreArchivo||Lt_ExtensionReporte);

        --Eliminaci�n del archivo
        BEGIN
            UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
        EXCEPTION
            WHEN OTHERS THEN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                     'P_REPORTE_TAREAS',
                                                      Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                        DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                      NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        END;

    END IF;

    --Mensaje de respuesta
    Pv_Status  := 'ok';
    Pv_Message := 'Proceso ejecutado correctamente';

    --Insertamos la ejecuci�n por ok del reporte.
    IF Lt_InsertaOk IS NULL OR UPPER(Lt_InsertaOk) = 'S' THEN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_TAREAS',
                                              Pv_Message,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    END IF;

  EXCEPTION

    WHEN OTHERS THEN

        Pv_Status  := 'fail';
        Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;
        Lv_Codigo  := Lv_Codigo || Lv_EsConsulta;

        IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

            --Eliminaci�n del archivo
            BEGIN

                IF Lt_NombreDirectorio IS NOT NULL AND Lv_NombreArchivo IS NOT NULL THEN

                    UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                    IF Lb_Fexists THEN
                        UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo);
                    END IF;

                    IF Lt_ExtensionReporte IS NOT NULL THEN
                        UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo||Lt_ExtensionReporte, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                        IF Lb_Fexists THEN
                            UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
                        END IF;
                    END IF;

                END IF;

            EXCEPTION
                WHEN OTHERS THEN
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                         'P_REPORTE_TAREAS',
                                                          Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                          NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                          SYSDATE,
                                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
            END;

            IF Lv_Para IS NULL THEN
                Lv_Para := NVL(Lt_CorreoError,'sistemas@telconet.ec');
            END IF;

            IF Lt_CorreoRemitente IS NULL THEN
                Lt_CorreoRemitente := 'notificaciones_telcos@telconet.ec';
            END IF;

            IF Lt_AsuntoCorreo IS NULL THEN
                Lt_AsuntoCorreo := 'REPORTE DE TAREAS (ERROR)';
            ELSE
                Lt_AsuntoCorreo := Lt_AsuntoCorreo || ' (ERROR)';
            END IF;

            IF Lt_PlantillaError IS NOT NULL THEN
                Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[userLogin]]' , Lv_UsuarioSolicita);
                Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[diaReporte]]', TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS'));
            ELSE
                Lt_PlantillaError := 'Estimado usuario '||Lv_UsuarioSolicita
                    ||', el reporte generado el d�a '||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')
                    ||' no se pudo generar. Por favor comunicar a Sistemas';
            END IF;

        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_TAREAS',
                                              Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

        Lv_Json := SUBSTR(Pcl_Json,0,3000);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_TAREAS',
                                              Lv_Codigo||'|1- '||Lv_Json,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

        Lv_Json := NULL;
        Lv_Json := SUBSTR(Pcl_Json,3001,6000);
        IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                         'P_REPORTE_TAREAS',
                                          Lv_Codigo||'|2- '||Lv_Json,
                                          NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        END IF;

        Lv_Json := NULL;
        Lv_Json := SUBSTR(Pcl_Json,6001,8000);
        IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                         'P_REPORTE_TAREAS',
                                          Lv_Codigo||'|3- '||Lv_Json,
                                          NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        END IF;

        IF Lv_EsConsulta IS NULL OR UPPER(Lv_EsConsulta) <> 'S' THEN

            UTL_MAIL.SEND(SENDER     => Lt_CorreoRemitente,
                          RECIPIENTS => Lv_Para,
                          SUBJECT    => Lt_AsuntoCorreo,
                          MESSAGE    => Lt_PlantillaError,
                          MIME_TYPE  => 'text/html; charset=UTF-8');

        END IF;

  END P_REPORTE_TAREAS;
--
--
  /*
  * Documentaci�n para PROCEDURE 'P_REPORTE_CASOS'.
  * Mejora para disminuir el costo de query aumentando usando WITH Antes: 3714434875 Ahora: 49668
  * @author Jose Guaman <jaguamanp@telconet.ec>
  * @version 1.0 18-10-2022
  */
  PROCEDURE P_REPORTE_CASOS(Pcl_Json    IN  CLOB,
                            Pv_Status   OUT VARCHAR2,
                            Pv_Message  OUT VARCHAR2) IS

    --======= INICIO DE CURSORES =======--

    CURSOR C_TipoCaso (Cv_IdTIpoCaso VARCHAR2) IS
        SELECT NOMBRE_TIPO_CASO
            FROM DB_SOPORTE.ADMI_TIPO_CASO
        WHERE ID_TIPO_CASO = Cv_IdTIpoCaso;

    CURSOR C_NivelCriticidad (Cv_IdNivelCriticidad VARCHAR2) IS
        SELECT NOMBRE_NIVEL_CRITICIDAD
            FROM DB_SOPORTE.ADMI_NIVEL_CRITICIDAD
        WHERE ID_NIVEL_CRITICIDAD = Cv_IdNivelCriticidad;

    CURSOR C_Hipotesis (Cv_IdHipotesis VARCHAR2) IS
        SELECT NOMBRE_HIPOTESIS
            FROM DB_SOPORTE.ADMI_HIPOTESIS
        WHERE ID_HIPOTESIS = Cv_IdHipotesis;

    CURSOR C_Departamento (Cv_IdDepartamento VARCHAR2) IS
        SELECT NOMBRE_DEPARTAMENTO
            FROM DB_GENERAL.ADMI_DEPARTAMENTO
        WHERE ID_DEPARTAMENTO = Cv_IdDepartamento;

    CURSOR C_Persona (Cv_IdPersona VARCHAR2) IS
        SELECT NVL(RAZON_SOCIAL, NOMBRES ||' '||APELLIDOS)
            FROM DB_COMERCIAL.INFO_PERSONA
        WHERE ID_PERSONA = Cv_IdPersona;

    CURSOR C_GetTiempoCaso (Ct_IdCaso DB_SOPORTE.INFO_CASO.ID_CASO%TYPE) IS
        SELECT TIEMPO_TOTAL_CASO_SOLUCION
            FROM DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION
        WHERE CASO_ID = Ct_IdCaso;

    CURSOR C_GetOneDetalleByIdCaso (Cv_IdCaso VARCHAR2) IS
        SELECT MAX(I0_.ID_DETALLE_HIPOTESIS) AS idDetalleHipotesis,
               I1_.ID_CASO        AS idCaso,
               A2_.ID_HIPOTESIS   AS hipotesisId
        FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS I0_,
             DB_SOPORTE.INFO_CASO              I1_,
             DB_SOPORTE.ADMI_HIPOTESIS         A2_
        WHERE I0_.CASO_ID      = Cv_IdCaso
          AND I0_.CASO_ID      = I1_.ID_CASO
          AND A2_.ID_HIPOTESIS = I0_.HIPOTESIS_ID
        GROUP BY I1_.ID_CASO,A2_.ID_HIPOTESIS;

    CURSOR C_GetUltimaAsignacion (Cv_IdCaso VARCHAR2) IS
        SELECT ICASI.ASIGNADO_NOMBRE
            FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHIP,
                 DB_SOPORTE.INFO_CASO_ASIGNACION   ICASI
        WHERE ICASI.DETALLE_HIPOTESIS_ID = IDHIP.ID_DETALLE_HIPOTESIS
          AND ICASI.ID_CASO_ASIGNACION   = (SELECT MAX(ICASIMAX.ID_CASO_ASIGNACION)
                                                FROM DB_SOPORTE.INFO_CASO_ASIGNACION ICASIMAX
                                            WHERE ICASIMAX.DETALLE_HIPOTESIS_ID = ICASI.DETALLE_HIPOTESIS_ID)
          AND IDHIP.CASO_ID = Cv_IdCaso;

    CURSOR C_getInfoDetalle (Cv_IdDetalleHipotesis VARCHAR2) IS
        SELECT IDET.*
            FROM DB_SOPORTE.INFO_DETALLE IDET
        WHERE IDET.DETALLE_HIPOTESIS_ID = Cv_IdDetalleHipotesis;

    CURSOR C_getTareaEstado (Cv_IdDetalle VARCHAR2) IS
        SELECT ATAR.NOMBRE_TAREA,IDHIS.ESTADO
            FROM DB_SOPORTE.ADMI_TAREA             ATAR,
                 DB_SOPORTE.INFO_DETALLE           IDET,
                 DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHIS
        WHERE IDET.ID_DETALLE = Cv_IdDetalle
          AND ATAR.ID_TAREA   = IDET.TAREA_ID
          AND IDET.ID_DETALLE = IDHIS.DETALLE_ID
          AND IDHIS.ID_DETALLE_HISTORIAL =
            (SELECT MAX(IDHISMAX.ID_DETALLE_HISTORIAL)
                FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHISMAX
             WHERE IDHISMAX.DETALLE_ID = IDHIS.DETALLE_ID);

    CURSOR C_GetAfectadosPorCaso (Cv_IdDetalle VARCHAR2) IS
        SELECT IPA.*
            FROM INFO_PARTE_AFECTADA IPA
        WHERE IPA.DETALLE_ID = Cv_IdDetalle
          AND UPPER(IPA.TIPO_AFECTADO) IN ('CLIENTE','ELEMENTO')
          AND IPA.AFECTADO_NOMBRE IS NOT NULL
          AND IPA.AFECTADO_DESCRIPCION IS NOT NULL;

    CURSOR C_GetPuntoCliente (Cv_IdPunto VARCHAR2) IS
        SELECT IPU.*
            FROM DB_COMERCIAL.INFO_PUNTO IPU
        WHERE IPU.ID_PUNTO = Cv_IdPunto;

    CURSOR C_GetContactosPunto (Cv_IdPunto VARCHAR2) IS
        (SELECT D.VALOR
             FROM DB_COMERCIAL.INFO_PERSONA A,
                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B,
                  DB_COMERCIAL.INFO_PUNTO C,
                  DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO D
             WHERE C.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL
               AND B.PERSONA_ID = A.ID_PERSONA
               AND D.PERSONA_ID = A.ID_PERSONA
               AND D.FORMA_CONTACTO_ID NOT IN (5)
               AND C.ID_PUNTO = Cv_IdPunto
               AND D.ESTADO = 'Activo'
            )
            UNION
        (SELECT B.VALOR
            FROM DB_COMERCIAL.INFO_PUNTO C,
                 DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO B
         WHERE B.PUNTO_ID = C.ID_PUNTO
           AND B.FORMA_CONTACTO_ID NOT IN (5)
           AND C.ID_PUNTO = Cv_IdPunto
           AND B.ESTADO = 'Activo');

    CURSOR C_GetServiciosPorPunto (Cv_IdPunto VARCHAR2) IS
        SELECT S.*
            FROM DB_COMERCIAL.INFO_SERVICIO S,
                 DB_COMERCIAL.INFO_PLAN_CAB PC,
                 DB_COMERCIAL.INFO_PLAN_DET PD,
                 DB_COMERCIAL.ADMI_PRODUCTO P
        WHERE PC.ID_PLAN = S.PLAN_ID
          AND PD.PLAN_ID = PC.ID_PLAN
          AND P.ID_PRODUCTO = PD.PRODUCTO_ID
          AND P.NOMBRE_TECNICO = 'INTERNET'
          AND S.PUNTO_ID = Cv_IdPunto
          AND S.ESTADO NOT IN ('Cancel','Anulado','Eliminado','Trasladado','Reubicado','Rechazada')
          AND ROWNUM < 2;

    CURSOR C_ServicioTecnico (Cv_ServicioId VARCHAR2) IS
        SELECT *
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO
        WHERE SERVICIO_ID = Cv_ServicioId
          AND ROWNUM < 2;

    CURSOR C_Elmento (Cv_IdElemento VARCHAR2) IS
        SELECT *
            FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
        WHERE ID_ELEMENTO = Cv_IdElemento
          AND ROWNUM < 2;

    CURSOR C_UltimaDepCierraTarea (Cv_IdCaso VARCHAR2) IS
        SELECT NVL((SELECT ADEP.NOMBRE_DEPARTAMENTO
                        FROM DB_GENERAL.ADMI_DEPARTAMENTO ADEP
                    WHERE ADEP.ID_DEPARTAMENTO = A.ASIGNADO_ID
                      AND ADEP.NOMBRE_DEPARTAMENTO = A.ASIGNADO_NOMBRE
                      AND ROWNUM < 2),
               NVL((SELECT ADEP2.NOMBRE_DEPARTAMENTO
                        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPEROL2,
                             DB_GENERAL.ADMI_DEPARTAMENTO          ADEP2
                    WHERE IPEROL2.DEPARTAMENTO_ID = ADEP2.ID_DEPARTAMENTO
                      AND IPEROL2.ID_PERSONA_ROL = A.PERSONA_EMPRESA_ROL_ID
                      AND ROWNUM < 2)
                   ,'Empresa')) AS DEPARTAMENTO,
               A.PERSONA_EMPRESA_ROL_ID
            FROM (SELECT IDASI.ASIGNADO_ID,
                         IDASI.ASIGNADO_NOMBRE,
                         IDASI.PERSONA_EMPRESA_ROL_ID,
                         IDHIS.FE_CREACION AS FE_FINALIZA
                    FROM DB_SOPORTE.INFO_CASO ICAS,
                         DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHIP,
                         DB_SOPORTE.INFO_DETALLE IDET,
                         DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHIS,
                         DB_SOPORTE.INFO_DETALLE_ASIGNACION IDASI
                  WHERE ICAS.ID_CASO = IDHIP.CASO_ID
                    AND IDHIP.ID_DETALLE_HIPOTESIS = IDET.DETALLE_HIPOTESIS_ID
                    AND IDET.ID_DETALLE = IDHIS.DETALLE_ID
                    AND IDET.ID_DETALLE = IDASI.DETALLE_ID
                    AND IDHIS.ID_DETALLE_HISTORIAL =
                      (SELECT MAX(IDHISMAX.ID_DETALLE_HISTORIAL)
                          FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL IDHISMAX
                       WHERE IDHISMAX.DETALLE_ID = IDHIS.DETALLE_ID)
                    AND IDASI.ID_DETALLE_ASIGNACION =
                      (SELECT MAX(IDASIMAX.ID_DETALLE_ASIGNACION)
                          FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION IDASIMAX
                       WHERE IDASIMAX.DETALLE_ID = IDHIS.DETALLE_ID)
                    AND ICAS.ID_CASO = Cv_IdCaso
                    AND IDHIS.ESTADO = 'Finalizada'
                  ORDER BY IDHIS.FE_CREACION DESC
                 ) A
        WHERE ROWNUM < 2;

    CURSOR C_Parametros (Cv_Valor1 VARCHAR2) IS
        SELECT COUNT(APDET.ID_PARAMETRO_DET) AS CANTIDAD
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
                 DB_GENERAL.ADMI_PARAMETRO_DET APDET
        WHERE APCAB.NOMBRE_PARAMETRO = 'DEPARTAMENTO CIUDAD REPORTE CASOS'
          AND APCAB.ID_PARAMETRO = APDET.PARAMETRO_ID
          AND APDET.DESCRIPCION = 'DEPARTAMENTO TECNICA SUCURSAL'
          AND APCAB.MODULO = 'SOPORTE'
          AND APCAB.PROCESO = 'CASOS'
          AND APDET.VALOR1 = Cv_Valor1
          AND APCAB.ESTADO = 'Activo'
          AND APDET.ESTADO = 'Activo';

    CURSOR C_NombreCanton (Cv_IdPersonaEmpresaRol VARCHAR2) IS
        SELECT ACAN.NOMBRE_CANTON
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPEROL,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO IOGRU,
                 DB_GENERAL.ADMI_CANTON ACAN
        WHERE IPEROL.OFICINA_ID = IOGRU.ID_OFICINA
          AND IOGRU.CANTON_ID = ACAN.ID_CANTON
          AND IPEROL.ID_PERSONA_ROL = Cv_IdPersonaEmpresaRol
          AND ROWNUM < 2;

    CURSOR C_GetUltimosCasosLogin (Cv_idCado VARCHAR2,Cv_idEmpresa VARCHAR2) IS
        SELECT A.* FROM (
            SELECT 'Numero Caso: '||INFOCASO.NUMERO_CASO||
                   ' , Version Final: '||INFOCASO.VERSION_FIN AS CASOS
                FROM DB_SOPORTE.INFO_CASO INFOCASO
            WHERE INFOCASO.EMPRESA_COD = Cv_idEmpresa
              AND INFOCASO.ID_CASO IN
                (SELECT DISTINCT(INFODETALLEHIPOTESIS.CASO_ID)
                    FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS INFODETALLEHIPOTESIS
                 WHERE INFODETALLEHIPOTESIS.ID_DETALLE_HIPOTESIS IN
                    (SELECT INFODETALLE.DETALLE_HIPOTESIS_ID
                        FROM DB_SOPORTE.INFO_DETALLE INFODETALLE
                     WHERE INFODETALLE.ID_DETALLE IN
                        (SELECT INFOPARTEAFECTADA.DETALLE_ID
                            FROM DB_SOPORTE.INFO_PARTE_AFECTADA INFOPARTEAFECTADA
                         WHERE INFOPARTEAFECTADA.AFECTADO_ID IN
                            (SELECT INFOPUNTO.ID_PUNTO
                                FROM DB_COMERCIAL.INFO_PUNTO INFOPUNTO
                             WHERE INFOPUNTO.LOGIN IN (
                                SELECT IPAFE.AFECTADO_NOMBRE
                                    FROM DB_SOPORTE.INFO_PARTE_AFECTADA IPAFE
                                 WHERE IPAFE.DETALLE_ID IN (
                                    SELECT MIN(IDET.ID_DETALLE)
                                        FROM DB_SOPORTE.INFO_DETALLE IDET,
                                             DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHIP
                                     WHERE IDET.DETALLE_HIPOTESIS_ID = IDHIP.ID_DETALLE_HIPOTESIS
                                       AND IDHIP.CASO_ID = Cv_idCado)
                                 AND ROWNUM < 2)
                               AND INFOPUNTO.ESTADO = 'Activo'))))
            ORDER BY INFOCASO.FE_CREACION DESC) A
         WHERE ROWNUM < 4;

    --Cursor para obtener el correo del usuario quien genera el reporte
    CURSOR C_ObtenerCorreoUsuario(Cv_Estado VARCHAR2,Cv_Login VARCHAR2) IS
        SELECT (LISTAGG(NVEE.MAIL_CIA,',')
                WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE NVEE.LOGIN_EMPLE   = Cv_Login
          AND UPPER(NVEE.ESTADO) = UPPER(Cv_Estado);

    --Cursor para obtener el valor de configuraci�n
    CURSOR C_ParametrosConfiguracion(Cv_NombreParametro VARCHAR2,
                                     Cv_Modulo          VARCHAR2,
                                     Cv_Descripcion     VARCHAR2) IS
    SELECT APCDET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
             DB_GENERAL.ADMI_PARAMETRO_DET APCDET
    WHERE APCAB.ID_PARAMETRO = APCDET.PARAMETRO_ID
      AND UPPER(APCAB.ESTADO)    = 'ACTIVO'
      AND UPPER(APCDET.ESTADO)   = 'ACTIVO'
      AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APCAB.MODULO           = Cv_Modulo
      AND APCDET.DESCRIPCION     = Cv_Descripcion;

    CURSOR C_ParametroArbolHip (Cv_codEmpresa VARCHAR2) IS
        SELECT APDET.VALOR2
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
                 DB_GENERAL.ADMI_PARAMETRO_DET APDET
        WHERE APCAB.NOMBRE_PARAMETRO = 'EMPRESA_APLICA_PROCESO'
          AND APCAB.ID_PARAMETRO = APDET.PARAMETRO_ID
          AND APCAB.MODULO = 'GENERAL'
          AND APCAB.PROCESO = 'TELCOS'
          AND APDET.VALOR1 = 'CONSULTA_ARBOL_HIPOTESIS'
          AND APDET.EMPRESA_COD = Cv_codEmpresa
          AND APCAB.ESTADO = 'Activo'
          AND APDET.ESTADO = 'Activo';

    CURSOR C_HipotesisArbol (Cv_IdHipotesis VARCHAR2) IS
        SELECT NOMBRE_HIPOTESIS, HIPOTESIS_ID
            FROM DB_SOPORTE.ADMI_HIPOTESIS
        WHERE ID_HIPOTESIS = Cv_IdHipotesis;

    --========= FIN DE CURSORES ========--

    --Variables para la formaci�n del query din�mico
    Lv_QuerySelect          VARCHAR2(2000)  := '';
    Lv_Queryfrom            VARCHAR2(1500) := '';
    Lv_QueryWhere           VARCHAR2(2000) := '';
    Lv_QueryAnd             VARCHAR2(2000) := '';
    Lv_Where1               VARCHAR2(1000);
    Lv_Where2               VARCHAR2(1000);
    Lcl_QueryCasos          CLOB;
    Lrf_ReporteCasos        SYS_REFCURSOR;
    Lr_Casos                Gr_Casos;

    --Criterios
    Lv_NumeroCaso           VARCHAR2(300);
    Lv_UsrCreacion          VARCHAR2(300);
    Lv_UsrCierra            VARCHAR2(300);
    Lv_EstadoCaso           VARCHAR2(400);
    Lv_TituloInicial        VARCHAR2(4000);
    Lv_VersionInicial       VARCHAR2(4000);
    Lv_TituloFinal          VARCHAR2(4000);
    Lv_TituloFinalHip       VARCHAR2(4000);
    Lv_VersionFinal         VARCHAR2(4000);
    Lv_NivelCriticidad      VARCHAR2(400);
    Lv_TipoCaso             VARCHAR2(400);
    Lv_Origen               VARCHAR2(20);
    Lv_FeAperturaDesde      VARCHAR2(20);
    Lv_FeAperturaHasta      VARCHAR2(20);
    Lv_FeCierreDesde        VARCHAR2(20);
    Lv_FeCierreHasta        VARCHAR2(20);
    Lv_LoginAfectado        VARCHAR2(4000);
    Lv_ClienteAfectado      VARCHAR2(4000);
    Lv_idDepartamento       VARCHAR2(400);
    Lv_idEmpleado           VARCHAR2(400);
    Lv_idCanton             VARCHAR2(400);
    Lv_idEmpresaSeleccion   VARCHAR2(400);

    --Variables de apoyo
    Lb_Continuar              BOOLEAN := FALSE;
    Lv_Codigo                 VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lv_UsuarioSolicita        VARCHAR2(100);
    Lv_IpSolicita             VARCHAR2(100);
    Lv_Error                  VARCHAR2(4000);
    Lv_Todos                  VARCHAR2(6) := 'Todos';
    Lv_TiempoCasoSolucion     VARCHAR2(200);
    Lb_tieneDatos             BOOLEAN;
    Lc_GetOneDetalleByIdCaso  C_GetOneDetalleByIdCaso%ROWTYPE;
    Lv_AsignadoNombre         VARCHAR2(4000);
    Lv_NombreTarea            VARCHAR2(4000) := '';
    Lv_EstadoTarea            VARCHAR2(4000) := '';
    Lc_GetTareaEstado         C_getTareaEstado%ROWTYPE;
    Lb_EnLimite               BOOLEAN;
    Lc_GetPuntoCliente        C_GetPuntoCliente%ROWTYPE;
    Lv_Olt                    VARCHAR2(4000) := '';
    Lv_Caja                   VARCHAR2(4000) := '';
    Lv_Direccion              VARCHAR2(4000) := '';
    Lv_Contactos              VARCHAR2(4000) := '';
    Lc_GetServiciosPorPunto   C_GetServiciosPorPunto%ROWTYPE;
    Lc_ServicioTecnico        C_ServicioTecnico%ROWTYPE;
    Lc_Elmento                C_Elmento%ROWTYPE;
    Lv_EstadoServicio         VARCHAR2(200);
    Lc_UltimaDepCierraTarea   C_UltimaDepCierraTarea%ROWTYPE;
    Lv_DepartamentoCierra     VARCHAR2(400);
    Ln_Cantidad               NUMBER;
    Lv_Canton                 VARCHAR2(100);
    Lv_PrefijoEmpresa         VARCHAR2(70);
    Lc_ultimosCasos           CLOB;
    Lv_Json                   VARCHAR2(4000);
    Lb_Fexists                BOOLEAN;
    Ln_FileLength             NUMBER;
    Lbi_BlockSize             BINARY_INTEGER;
    Ln_HipotesisIdArbolN1     DB_SOPORTE.ADMI_HIPOTESIS.ID_HIPOTESIS%TYPE;
    Lv_NombreHipotesisArbolN1 DB_SOPORTE.ADMI_HIPOTESIS.NOMBRE_HIPOTESIS%TYPE;
    Ln_HipotesisIdArbolN2     DB_SOPORTE.ADMI_HIPOTESIS.ID_HIPOTESIS%TYPE;
    Lv_NombreHipotesisArbolN2 DB_SOPORTE.ADMI_HIPOTESIS.NOMBRE_HIPOTESIS%TYPE;
    Ln_HipotesisIdArbolN3     DB_SOPORTE.ADMI_HIPOTESIS.ID_HIPOTESIS%TYPE;
    Lv_NombreHipotesisArbolN3 DB_SOPORTE.ADMI_HIPOTESIS.NOMBRE_HIPOTESIS%TYPE;
    Lv_CabeceraHipotesisFile  VARCHAR2(600);
    Lv_DetalleHipotesisFile   VARCHAR2(600);

    --Variables de configuraci�n
    Lf_Archivo                   UTL_FILE.FILE_TYPE;
    Lv_NombreArchivo             VARCHAR2(100) := 'ReporteCasos_'||to_char(SYSDATE,'RRRRMMDDHH24MISS')||'.csv';
    Lv_Delimitador               VARCHAR2(2)   := ';';
    Lv_NombreParametro           VARCHAR2(25)  := 'PARAMETROS_REPORTE_CASOS';
    Lv_Modulo                    VARCHAR2(7)   := 'SOPORTE';
    Lv_ParametroRemitente        VARCHAR2(16)  := 'CORREO_REMITENTE';
    Lv_ParametroCorreoError      VARCHAR2(25)  := 'CORREO_DEFECTO_ERROR';
    Lv_ParametroNombreDirectorio VARCHAR2(25)  := 'NOMBRE_DIRECTORIO_REPORTE';
    Lv_ParametroRutaDirectorio   VARCHAR2(24)  := 'RUTA_DIRECTORIO_REPORTES';
    Lv_ParametroComandoReporte   VARCHAR2(15)  := 'COMANDO_REPORTE';
    Lv_ParametroExtensionReporte VARCHAR2(17)  := 'EXTENSION_REPORTE';
    Lv_ParametroPlantilla        VARCHAR2(22)  := 'PLANTILLA_NOTIFICACION';
    Lv_ParametroPlantillaError   VARCHAR2(25)  := 'PLANTILLA_ERROR';
    Lv_ParametroAsuntoCorreo     VARCHAR2(13)  := 'ASUNTO_CORREO';
    Lv_InsertarErrorOk           VARCHAR2(25)  := 'INSERTAR_ERROR_OK';
    Lt_CorreoRemitente           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_CorreoError               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_AsuntoCorreo              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_NombreDirectorio          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_RutaDirectorio            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_ComandoReporte            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_ExtensionReporte          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_PlantillaNotificacion     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_PlantillaError            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_InsertaOk                 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lt_ConsultaArbolHipotesis    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
    Lv_Para                      VARCHAR2(500);

  BEGIN

    IF C_TipoCaso%ISOPEN THEN
        CLOSE C_TipoCaso;
    END IF;

    IF C_NivelCriticidad%ISOPEN THEN
        CLOSE C_NivelCriticidad;
    END IF;

    IF C_Hipotesis%ISOPEN THEN
        CLOSE C_Hipotesis;
    END IF;

    IF C_Departamento%ISOPEN THEN
        CLOSE C_Departamento;
    END IF;

    IF C_Persona%ISOPEN THEN
        CLOSE C_Persona;
    END IF;

    IF C_GetTiempoCaso%ISOPEN THEN
        CLOSE C_GetTiempoCaso;
    END IF;

    IF C_GetOneDetalleByIdCaso%ISOPEN THEN
        CLOSE C_GetOneDetalleByIdCaso;
    END IF;

    IF C_GetUltimaAsignacion%ISOPEN THEN
        CLOSE C_GetUltimaAsignacion;
    END IF;

    IF C_getInfoDetalle%ISOPEN THEN
        CLOSE C_getInfoDetalle;
    END IF;

    IF C_getTareaEstado%ISOPEN THEN
        CLOSE C_getTareaEstado;
    END IF;

    IF C_GetAfectadosPorCaso%ISOPEN THEN
        CLOSE C_GetAfectadosPorCaso;
    END IF;

    IF C_GetPuntoCliente%ISOPEN THEN
        CLOSE C_GetPuntoCliente;
    END IF;

    IF C_GetContactosPunto%ISOPEN THEN
        CLOSE C_GetContactosPunto;
    END IF;

    IF C_GetServiciosPorPunto%ISOPEN THEN
        CLOSE C_GetServiciosPorPunto;
    END IF;

    IF C_ServicioTecnico%ISOPEN THEN
        CLOSE C_ServicioTecnico;
    END IF;

    IF C_Elmento%ISOPEN THEN
        CLOSE C_Elmento;
    END IF;

    IF C_UltimaDepCierraTarea%ISOPEN THEN
        CLOSE C_UltimaDepCierraTarea;
    END IF;

    IF C_Parametros%ISOPEN THEN
        CLOSE C_Parametros;
    END IF;

    IF C_NombreCanton%ISOPEN THEN
        CLOSE C_NombreCanton;
    END IF;

    IF C_GetUltimosCasosLogin%ISOPEN THEN
        CLOSE C_GetUltimosCasosLogin;
    END IF;

    IF C_ObtenerCorreoUsuario%ISOPEN THEN
        CLOSE C_ObtenerCorreoUsuario;
    END IF;

    IF C_ParametrosConfiguracion%ISOPEN THEN
        CLOSE C_ParametrosConfiguracion;
    END IF;

    IF C_HipotesisArbol%ISOPEN THEN
        CLOSE C_HipotesisArbol;
    END IF;

    IF C_ParametroArbolHip%ISOPEN THEN
        CLOSE C_ParametroArbolHip;
    END IF;

    apex_json.parse(Pcl_Json);
    Lv_IpSolicita         := apex_json.get_varchar2('strIpSolicita');
    Lv_UsuarioSolicita    := apex_json.get_varchar2('strUsuarioSolicita');

    --Se habren los cursores para obtener las informaciones necesarias para completar el flujo del reporte.
    OPEN C_ObtenerCorreoUsuario('A',Lv_UsuarioSolicita);
        FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
    CLOSE C_ObtenerCorreoUsuario;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRemitente);
        FETCH C_ParametrosConfiguracion INTO Lt_CorreoRemitente;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroNombreDirectorio);
        FETCH C_ParametrosConfiguracion INTO Lt_NombreDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroRutaDirectorio);
        FETCH C_ParametrosConfiguracion INTO Lt_RutaDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroComandoReporte);
        FETCH C_ParametrosConfiguracion INTO Lt_ComandoReporte;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroExtensionReporte);
        FETCH C_ParametrosConfiguracion INTO Lt_ExtensionReporte;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantilla);
        FETCH C_ParametrosConfiguracion INTO Lt_PlantillaNotificacion;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroAsuntoCorreo);
        FETCH C_ParametrosConfiguracion INTO Lt_AsuntoCorreo;
    CLOSE C_ParametrosConfiguracion;

    --CURSORES PARA OBTENER LA INFORMAION POR SI DA ERROR EL PROCESO
    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroCorreoError);
        FETCH C_ParametrosConfiguracion INTO Lt_CorreoError;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_ParametroPlantillaError);
        FETCH C_ParametrosConfiguracion INTO Lt_PlantillaError;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,Lv_Modulo,Lv_InsertarErrorOk);
        FETCH C_ParametrosConfiguracion INTO Lt_InsertaOk;
    CLOSE C_ParametrosConfiguracion;

    Lv_NumeroCaso         := apex_json.get_varchar2('numero');
    Lv_UsrCreacion        := apex_json.get_varchar2('usrApertura');
    Lv_UsrCierra          := apex_json.get_varchar2('usrCierre');
    Lv_EstadoCaso         := apex_json.get_varchar2('estado');
    Lv_TituloInicial      := apex_json.get_varchar2('tituloInicial');
    Lv_VersionInicial     := apex_json.get_varchar2('versionInicial');
    Lv_TituloFinal        := apex_json.get_varchar2('tituloFinal');
    Lv_TituloFinalHip     := apex_json.get_varchar2('tituloFinalHip');
    Lv_VersionFinal       := apex_json.get_varchar2('versionFinal');
    Lv_NivelCriticidad    := apex_json.get_varchar2('nivelCriticidad');
    Lv_TipoCaso           := apex_json.get_varchar2('tipoCaso');
    Lv_Origen             := apex_json.get_varchar2('strOrigen');
    Lv_FeAperturaDesde    := apex_json.get_varchar2('feAperturaDesde');
    Lv_FeAperturaHasta    := apex_json.get_varchar2('feAperturaHasta');
    Lv_FeCierreDesde      := apex_json.get_varchar2('feCierreDesde');
    Lv_FeCierreHasta      := apex_json.get_varchar2('feCierreHasta');
    Lv_ClienteAfectado    := apex_json.get_varchar2('clienteAfectado');
    Lv_LoginAfectado      := apex_json.get_varchar2('loginAfectado');
    Lv_idDepartamento     := apex_json.get_varchar2('departamento_id');
    Lv_idEmpleado         := apex_json.get_varchar2('empleado_id');
    Lv_idCanton           := apex_json.get_varchar2('canton_id');
    Lv_idEmpresaSeleccion := apex_json.get_varchar2('idEmpresaSeleccion');
    Lv_PrefijoEmpresa     := apex_json.get_varchar2('prefijoEmpresa');

    Lv_QuerySelect := 'WITH MAXIMO_CASO AS '||
                    '(SELECT IDHMAX.CASO_ID, MAX (IDHMAX.ID_DETALLE_HIPOTESIS) MAXIMO '||
                    'FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDHMAX '||
                    'GROUP BY IDHMAX.CASO_ID), '||
                    'MAXIMO_HIPOTESIS AS '||
                    '(SELECT ICAMAX.DETALLE_HIPOTESIS_ID, MAX (ICAMAX.ID_CASO_ASIGNACION) MAXIMO '||
                    'FROM DB_SOPORTE.INFO_CASO_ASIGNACION ICAMAX '||
                    'GROUP BY ICAMAX.DETALLE_HIPOTESIS_ID)'||
                    ' SELECT /*+ RESULT_CACHE */ ' ||
                             'ICAS.ID_CASO, '||
                             'ICAS.NUMERO_CASO, '||
                             'ICAS.TITULO_INI, '||
                             'ICAS.TITULO_FIN, '||
                             'ICAS.TITULO_FIN_HIP, '||
                             'ICAS.VERSION_INI, '||
                             'ICAS.VERSION_FIN, '||
                             'ICAS.FE_APERTURA, '||
                             'ICAS.FE_CIERRE, '||
                             'ICHIS.ESTADO';

    Lv_Queryfrom := ' FROM DB_SOPORTE.INFO_CASO ICAS, '||
                          'DB_SOPORTE.INFO_CASO_HISTORIAL ICHIS';

    Lv_QueryWhere := ' WHERE ICAS.ID_CASO IS NOT NULL '||
                        'AND ICAS.ID_CASO = ICHIS.CASO_ID '||
                        'AND ICAS.EMPRESA_COD = :idEmpresaSeleccion '||
                        'AND ICHIS.ID_CASO_HISTORIAL = (SELECT MAX(CASOHISTMAX.ID_CASO_HISTORIAL) '||
                                                            'FROM DB_SOPORTE.INFO_CASO_HISTORIAL CASOHISTMAX '||
                                                       'WHERE CASOHISTMAX.CASO_ID = ICHIS.CASO_ID)';

    Lv_QueryWhere := REPLACE(Lv_QueryWhere,':idEmpresaSeleccion',''''||Lv_idEmpresaSeleccion||'''');

    OPEN C_ParametroArbolHip (Lv_idEmpresaSeleccion);
        FETCH C_ParametroArbolHip INTO Lt_ConsultaArbolHipotesis;
    CLOSE C_ParametroArbolHip;

    IF Lv_NumeroCaso IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND ICAS.NUMERO_CASO = :numeroCaso';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':numeroCaso',''''||Lv_NumeroCaso||'''');
    END IF;

    IF Lv_UsrCreacion IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICAS.USR_CREACION) LIKE LOWER(:usrCreacion)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':usrCreacion','''%'||Lv_UsrCreacion||'%''');
    END IF;

    IF Lv_UsrCierra IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICHIS.USR_CREACION) LIKE LOWER(:usrCierra) '||
                                          'AND LOWER(ICHIS.ESTADO) = :estadoCerrado';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':usrCierra','''%'||Lv_UsrCierra||'%''');
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':estadoCerrado','''cerrado''');
    END IF;

    IF Lv_EstadoCaso IS NOT NULL AND LOWER(Lv_EstadoCaso) != 'todos' THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICHIS.estado) LIKE LOWER(:estadoCaso)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':estadoCaso','''%'||Lv_EstadoCaso||'%''');
    END IF;

    IF Lv_TituloInicial IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICAS.TITULO_INI) LIKE LOWER(:tituloInicial)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tituloInicial','''%'||Lv_TituloInicial||'%''');
    END IF;

    IF Lv_VersionInicial IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICAS.VERSION_INI) LIKE LOWER(:versionInicial)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':versionInicial','''%'||Lv_VersionInicial||'%''');
    END IF;

    IF Lv_TituloFinal IS NOT NULL OR Lv_TituloFinalHip IS NOT NULL THEN

        IF Lv_TituloFinal IS NOT NULL THEN
            Lb_Continuar := TRUE;
            Lv_Where1 := 'LOWER(ICAS.TITULO_FIN) LIKE LOWER(:tituloFinal)';

            Lv_Where1 := REPLACE(Lv_Where1,':tituloFinal','''%'||Lv_TituloFinal||'%''');
        END IF;

        IF Lv_TituloFinalHip IS NOT NULL THEN
            Lb_Continuar := TRUE;
            Lv_Where2 := 'ICAS.TITULO_FIN_HIP = :tituloFinalHip';

            Lv_Where2 := REPLACE(Lv_Where2,':tituloFinalHip',Lv_TituloFinalHip);
        END IF;

        IF Lv_Where1 IS NOT NULL AND Lv_Where2 IS NOT NULL THEN
            Lv_QueryWhere := Lv_QueryWhere || ' AND ('||Lv_Where1||' OR '||Lv_Where2||')';
        ELSIF Lv_Where1 IS NOT NULL THEN
            Lv_QueryWhere := Lv_QueryWhere || ' AND '||Lv_Where1;
        ELSIF Lv_Where2 IS NOT NULL THEN
            Lv_QueryWhere := Lv_QueryWhere || ' AND '||Lv_Where2;
        END IF;

    END IF;

    IF Lv_VersionFinal IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICAS.VERSION_FIN) LIKE LOWER(:versionFinal)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':versionFinal','''%'||Lv_VersionFinal||'%''');
    END IF;

    IF Lv_NivelCriticidad IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND ICAS.NIVEL_CRITICIDAD_ID = :nivelCriticidad';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':nivelCriticidad',Lv_NivelCriticidad);
    END IF;

    IF Lv_TipoCaso IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND ICAS.TIPO_CASO_ID = :tipoCaso';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoCaso',Lv_TipoCaso);
    END IF;

    IF Lv_Origen IS NOT NULL THEN
        Lb_Continuar  := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND LOWER(ICAS.ORIGEN) LIKE LOWER(:strOrigen) '||
                                          'AND LOWER(ICHIS.ESTADO) NOT IN (:strEstado)';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':strOrigen','''M''');
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':strEstado','''Asignado'','||'''Cerrado''');
    END IF;

    IF Lv_FeAperturaDesde IS NOT NULL THEN
        Lb_Continuar := TRUE;
        Lv_FeAperturaDesde := TO_CHAR(TO_dATE(Lv_FeAperturaDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ICAS.FE_APERTURA,''RRRR-MM-DD'') >= :feAperturaDesde';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feAperturaDesde',''''||Lv_FeAperturaDesde||'''');
    END IF;

    IF Lv_FeAperturaHasta IS NOT NULL THEN
        Lb_Continuar := TRUE;
        Lv_FeAperturaHasta := TO_CHAR(TO_dATE(Lv_FeAperturaHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ICAS.FE_APERTURA,''RRRR-MM-DD'') <= :feAperturaHasta';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feAperturaHasta',''''||Lv_FeAperturaHasta||'''');
    END IF;

    IF Lv_FeCierreDesde IS NOT NULL THEN
        Lb_Continuar := TRUE;
        Lv_FeCierreDesde := TO_CHAR(TO_dATE(Lv_FeCierreDesde,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ICAS.FE_CIERRE,''RRRR-MM-DD'') >= :feCierreDesde';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feCierreDesde',''''||Lv_FeCierreDesde||'''');
    END IF;

    IF Lv_FeCierreHasta IS NOT NULL THEN
        Lb_Continuar := TRUE;
        Lv_FeCierreHasta := TO_CHAR(TO_dATE(Lv_FeCierreHasta,'RRRR-MM-DD'),'RRRR-MM-DD');
        Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ICAS.FE_CIERRE,''RRRR-MM-DD'') <= :feCierreHasta';
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feCierreHasta',''''||Lv_FeCierreHasta||'''');
    END IF;

    IF Lv_ClienteAfectado IS NOT NULL AND Lv_LoginAfectado IS NULL THEN
        Lb_Continuar := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND EXISTS (SELECT 1 '||
                                                        'FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS DH1, '||
                                                            'DB_SOPORTE.INFO_DETALLE D1, '||
                                                            'DB_SOPORTE.INFO_PARTE_AFECTADA PA1 '||
                                                      'WHERE DH1.CASO_ID = ICAS.ID_CASO '||
                                                        'AND DH1.ID_DETALLE_HIPOTESIS = D1.DETALLE_HIPOTESIS_ID '||
                                                        'AND D1.ID_DETALLE  = PA1.DETALLE_ID '||
                                                        'AND LOWER(PA1.TIPO_AFECTADO) = :tipoAfectado '||
                                                        'AND LOWER(PA1.AFECTADO_DESCRIPCION) LIKE LOWER(:clienteAfectado))';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAfectado','''cliente''');
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':clienteAfectado','''%'||Lv_ClienteAfectado||'%''');
    END IF;

    IF Lv_LoginAfectado IS NOT NULL THEN
        Lb_Continuar := TRUE;
        Lv_QueryWhere := Lv_QueryWhere ||' AND (SELECT COUNT(PA1.ID_PARTE_AFECTADA) '||
                                                    'FROM DB_SOPORTE.INFO_DETALLE_HIPOTESIS DH1, '||
                                                         'DB_SOPORTE.INFO_DETALLE D1, '||
                                                         'DB_SOPORTE.INFO_PARTE_AFECTADA PA1 '||
                                               'WHERE DH1.CASO_ID = ICAS.ID_CASO '||
                                                 'AND DH1.ID_DETALLE_HIPOTESIS = D1.DETALLE_HIPOTESIS_ID '||
                                                 'AND D1.ID_DETALLE  = PA1.DETALLE_ID '||
                                                 'AND LOWER(PA1.TIPO_AFECTADO) = :tipoAfectado '||
                                                 'AND LOWER(PA1.AFECTADO_NOMBRE) LIKE LOWER(:loginAfectado)) > 0';

        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':tipoAfectado','''cliente''');
        Lv_QueryWhere := REPLACE(Lv_QueryWhere,':loginAfectado','''%'||Lv_LoginAfectado||'%''');
    END IF;

    IF Lv_idDepartamento IS NOT NULL OR Lv_idEmpleado IS NOT NULL OR Lv_idCanton IS NOT NULL THEN

        Lb_Continuar := TRUE;
        Lv_Queryfrom := Lv_Queryfrom || ' ,DB_SOPORTE.INFO_DETALLE_HIPOTESIS idh, '||
                                          'DB_SOPORTE.INFO_CASO_ASIGNACION ica, '||
                                          'DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper';

        Lv_QueryAnd := ' AND ICAS.ID_CASO = IDH.CASO_ID '||
                        'AND idh.ID_DETALLE_HIPOTESIS = ica.DETALLE_HIPOTESIS_ID '||
                        'AND iper.ID_PERSONA_ROL = ica.PERSONA_EMPRESA_ROL_ID '||
                        'AND idh.ID_DETALLE_HIPOTESIS = (SELECT IDHMAX.MAXIMO '||
                                                            'FROM MAXIMO_CASO IDHMAX '||
                                                        'WHERE IDHMAX.CASO_ID = idh.CASO_ID) '||
                        'AND ica.ID_CASO_ASIGNACION = (SELECT ICAMAX.MAXIMO '||
                                                        'FROM  MAXIMO_HIPOTESIS ICAMAX '||
                                                      'WHERE ICAMAX.DETALLE_HIPOTESIS_ID = ica.DETALLE_HIPOTESIS_ID)';

        IF Lv_idDepartamento IS NOT NULL THEN
            Lv_Queryfrom := Lv_Queryfrom ||' ,DB_GENERAL.ADMI_DEPARTAMENTO AD';

            Lv_QueryAnd := Lv_QueryAnd || ' AND AD.ID_DEPARTAMENTO = iper.DEPARTAMENTO_ID '||
                                           'AND AD.ID_DEPARTAMENTO = :departamento_id';

            Lv_QueryAnd := REPLACE(Lv_QueryAnd,':departamento_id',Lv_idDepartamento);
        END IF;

        IF Lv_idEmpleado IS NOT NULL THEN
            Lv_Queryfrom := Lv_Queryfrom ||' ,DB_COMERCIAL.INFO_PERSONA IPERSONA';

            Lv_QueryAnd := Lv_QueryAnd || ' AND IPERSONA.ID_PERSONA = iper.PERSONA_ID '||
                                           'AND IPERSONA.ID_PERSONA = :idPersona';

            Lv_QueryAnd := REPLACE(Lv_QueryAnd,':idPersona',Lv_idEmpleado);
        END IF;

        IF Lv_idCanton IS NOT NULL THEN
            Lv_Queryfrom := Lv_Queryfrom ||' ,DB_COMERCIAL.INFO_OFICINA_GRUPO iog, '||
                                             'DB_GENERAL.ADMI_CANTON AC';

            Lv_QueryAnd := Lv_QueryAnd || ' AND IOG.CANTON_ID = AC.ID_CANTON '||
                                           'AND iog.ID_OFICINA = IPER.OFICINA_ID '||
                                           'AND AC.ID_CANTON = :cantonId';

            Lv_QueryAnd := REPLACE(Lv_QueryAnd,':cantonId',Lv_idCanton);
        END IF;

    END IF;

    Lcl_QueryCasos := Lv_QuerySelect ||
                      Lv_Queryfrom   ||
                      Lv_QueryWhere  ||
                      Lv_QueryAnd    || ' ORDER BY ICAS.ID_CASO DESC';

    DBMS_OUTPUT.PUT_LINE(Lcl_QueryCasos);

    --Criterios
    IF Lv_NumeroCaso IS NULL THEN
        Lv_NumeroCaso := Lv_Todos;
    END IF;

    IF Lv_EstadoCaso IS NULL THEN
        Lv_EstadoCaso := Lv_Todos;
    END IF;

    IF Lv_TipoCaso IS NULL THEN
        Lv_TipoCaso := Lv_Todos;
    ELSE
        OPEN C_TipoCaso(Lv_TipoCaso);
            FETCH C_TipoCaso INTO Lv_TipoCaso;
        CLOSE C_TipoCaso;
    END IF;

    IF Lv_NivelCriticidad IS NULL THEN
        Lv_NivelCriticidad := Lv_Todos;
    ELSE
        OPEN C_NivelCriticidad(Lv_NivelCriticidad);
            FETCH C_NivelCriticidad INTO Lv_NivelCriticidad;
        CLOSE C_NivelCriticidad;
    END IF;

    IF Lv_TituloInicial IS NULL THEN
        Lv_TituloInicial := Lv_Todos;
    END IF;

    IF Lv_VersionInicial IS NULL THEN
        Lv_VersionInicial := Lv_Todos;
    END IF;

    IF Lv_TituloFinal IS NULL THEN
        Lv_TituloFinal := Lv_Todos;
    END IF;

    IF Lv_TituloFinalHip IS NULL THEN
        Lv_TituloFinalHip := Lv_Todos;
    ELSE
        OPEN C_Hipotesis(Lv_TituloFinalHip);
        FETCH C_Hipotesis INTO Lv_TituloFinalHip;
        CLOSE C_Hipotesis;
    END IF;

    IF Lv_VersionFinal IS NULL THEN
        Lv_VersionFinal := Lv_Todos;
    END IF;

    IF Lv_LoginAfectado IS NULL THEN
        Lv_LoginAfectado := Lv_Todos;
    END IF;

    IF Lv_ClienteAfectado IS NULL THEN
        Lv_ClienteAfectado := Lv_Todos;
    END IF;

    IF Lv_idDepartamento IS NULL THEN
        Lv_idDepartamento := '-';
    ELSE
        OPEN C_Departamento(Lv_idDepartamento);
        FETCH C_Departamento INTO Lv_idDepartamento;
        CLOSE C_Departamento;
    END IF;

    IF Lv_idEmpleado IS NULL THEN
        Lv_idEmpleado := '-';
    ELSE
        OPEN C_Persona (Lv_idEmpleado);
        FETCH C_Persona INTO Lv_idEmpleado;
        CLOSE C_Persona;
    END IF;

    IF Lv_UsrCreacion IS NULL THEN
        Lv_UsrCreacion := Lv_Todos;
    END IF;

    IF Lv_UsrCierra IS NULL THEN
        Lv_UsrCierra := Lv_Todos;
    END IF;

    IF Lv_FeAperturaDesde IS NULL THEN
        Lv_FeAperturaDesde := Lv_Todos;
    END IF;

    IF Lv_FeAperturaHasta IS NULL THEN
        Lv_FeAperturaHasta := Lv_Todos;
    END IF;

    IF Lv_FeCierreDesde IS NULL THEN
        Lv_FeCierreDesde := Lv_Todos;
    END IF;

    IF Lv_FeCierreHasta IS NULL THEN
        Lv_FeCierreHasta := Lv_Todos;
    END IF;

    --Se crea el archivo
    Lf_Archivo := UTL_FILE.FOPEN(Lt_NombreDirectorio,Lv_NombreArchivo,'w',32767);

    --Criterios del Reporte
    UTL_FILE.PUT_LINE(Lf_Archivo,

              'USUARIO QUE GENERA:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_UsuarioSolicita||chr(13)
            ||'FECHA DE GENERACION:'||Lv_Delimitador
            ||Lv_Delimitador||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||chr(13)||chr(13)

            ||'NUMERO DE CASO:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_NumeroCaso||Lv_Delimitador
            ||Lv_Delimitador||'ESTADO:'||Lv_Delimitador||Lv_Delimitador||Lv_EstadoCaso||chr(13)

            ||'TIPO DE CASO:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_TipoCaso||Lv_Delimitador
            ||Lv_Delimitador||'NIVEL DE CRITICIDAD:'||Lv_Delimitador||Lv_Delimitador||Lv_NivelCriticidad||chr(13)

            ||'TITULO INICIAL:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_TituloInicial||Lv_Delimitador
            ||Lv_Delimitador||'VERSION INICIAL:'||Lv_Delimitador||Lv_Delimitador||Lv_VersionInicial||chr(13)

            ||'TITULO FINAL:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_TituloFinal||'|'||Lv_TituloFinalHip||Lv_Delimitador
            ||Lv_Delimitador||'VERSION FINAL:'||Lv_Delimitador||Lv_Delimitador||Lv_VersionFinal||chr(13)

            ||'LOGIN AFECTADO:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_LoginAfectado||Lv_Delimitador
            ||Lv_Delimitador||'CLIENTE AFECTADO:'||Lv_Delimitador||Lv_Delimitador||Lv_ClienteAfectado||chr(13)

            ||'FILIAL ASIGNADA:'||Lv_Delimitador
            ||Lv_Delimitador||'-'||Lv_Delimitador
            ||Lv_Delimitador||'AREA ASIGNADA:'||Lv_Delimitador||Lv_Delimitador||'-'||chr(13)

            ||'DEPARTAMENTO ASIGNADO:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_idDepartamento||Lv_Delimitador
            ||Lv_Delimitador||'EMPLEADO ASIGNADO:'||Lv_Delimitador||Lv_Delimitador||Lv_idEmpleado||chr(13)

            ||'USUARIO DE CREACION:'||Lv_Delimitador
            ||Lv_Delimitador||Lv_UsrCreacion||Lv_Delimitador
            ||Lv_Delimitador||'USUARIO DE CIERRE:'||Lv_Delimitador||Lv_Delimitador||Lv_UsrCierra||chr(13)

            ||'FECHA DE APERTURA:'||Lv_Delimitador
                            ||'DESDE:'||Lv_Delimitador||Lv_FeAperturaDesde||Lv_Delimitador||Lv_Delimitador
            ||'FECHA DE CIERRE:'||Lv_Delimitador
                            ||'DESDE:'||Lv_Delimitador||Lv_FeCierreDesde||chr(13)
            ||Lv_Delimitador||'HASTA:'||Lv_Delimitador||Lv_FeAperturaHasta||Lv_Delimitador||Lv_Delimitador
            ||Lv_Delimitador||'HASTA:'||Lv_Delimitador||Lv_FeCierreHasta||chr(13)||chr(13)||chr(13));

    -- Detalle del Reporte
    Lv_CabeceraHipotesisFile := 'TITULO FINAL'||Lv_Delimitador;
    IF Lt_ConsultaArbolHipotesis = 'S' THEN
        Lv_CabeceraHipotesisFile := 'NIVEL 1'||Lv_Delimitador||'NIVEL 2'||Lv_Delimitador||'NIVEL 3'||Lv_Delimitador;
    END IF;

    UTL_FILE.PUT_LINE(Lf_Archivo,
                 'NUMERO DE CASO'||Lv_Delimitador
               ||'TITULO INICIAL'||Lv_Delimitador
               ||Lv_CabeceraHipotesisFile
               ||'FECHA DE APERTURA'||Lv_Delimitador
               ||'FECHA DE CIERRE'||Lv_Delimitador
               ||'ESTADO'||Lv_Delimitador
               ||'VERSION INICIAL'||Lv_Delimitador
               ||'VERSION FINAL'||Lv_Delimitador
               ||'AFECTADOS (LOGIN/ELEMENTO)'||Lv_Delimitador
               ||'AFECTADOS (CLIENTE/INTERFACES)' ||Lv_Delimitador
               ||'CAJA'||Lv_Delimitador
               ||'OLT'||Lv_Delimitador
               ||'DIRECCION'||Lv_Delimitador
               ||'CONTACTO'||Lv_Delimitador
               ||'DEPARTAMENTO'||Lv_Delimitador
               ||'TAREA ASIGNADA'||Lv_Delimitador
               ||'ESTADO TAREA'||Lv_Delimitador
               ||'ESTADO SERVICIO'||Lv_Delimitador
               ||'TIEMPO TOTAL'||Lv_Delimitador
               ||'DEPARTAMENTO ULT. TAREA FINALIZADA'||Lv_Delimitador
               ||'CASOS ANTERIORES'||Lv_Delimitador);

    OPEN Lrf_ReporteCasos FOR Lcl_QueryCasos;

        LOOP

            FETCH Lrf_ReporteCasos INTO Lr_Casos;

            EXIT WHEN Lrf_ReporteCasos%NOTFOUND;

            OPEN C_UltimaDepCierraTarea(Lr_Casos.ID_CASO);
            FETCH C_UltimaDepCierraTarea INTO Lc_UltimaDepCierraTarea;
            CLOSE C_UltimaDepCierraTarea;

            Lv_DepartamentoCierra := Lc_UltimaDepCierraTarea.DEPARTAMENTO;

            IF UPPER(Lv_PrefijoEmpresa) = 'TN' THEN

                OPEN C_Parametros(Lv_DepartamentoCierra);
                FETCH C_Parametros INTO Ln_Cantidad;
                CLOSE C_Parametros;

                IF Ln_Cantidad > 0 THEN

                    OPEN C_NombreCanton(Lc_UltimaDepCierraTarea.PERSONA_EMPRESA_ROL_ID);
                    FETCH C_NombreCanton INTO Lv_Canton;
                    CLOSE C_NombreCanton;

                    IF Lv_Canton IS NOT NULL THEN
                        Lv_DepartamentoCierra := Lv_DepartamentoCierra || ' - '||Lv_Canton;
                    END IF;

                END IF;

            END IF;

          --Cambio
            Lc_ultimosCasos := 'N/A';

            IF Lr_Casos.TITULO_FIN_HIP IS NOT NULL THEN

                IF Lt_ConsultaArbolHipotesis = 'S' THEN
                    OPEN C_HipotesisArbol(Lr_Casos.TITULO_FIN_HIP);
                        FETCH C_HipotesisArbol INTO Lv_NombreHipotesisArbolN3, Ln_HipotesisIdArbolN3;
                    CLOSE C_HipotesisArbol;
                    OPEN C_HipotesisArbol(Ln_HipotesisIdArbolN3);
                        FETCH C_HipotesisArbol INTO Lv_NombreHipotesisArbolN2, Ln_HipotesisIdArbolN2;
                    CLOSE C_HipotesisArbol;
                    OPEN C_HipotesisArbol(Ln_HipotesisIdArbolN2);
                        FETCH C_HipotesisArbol INTO Lv_NombreHipotesisArbolN1, Ln_HipotesisIdArbolN1;
                    CLOSE C_HipotesisArbol;
                ELSE 
                    OPEN C_Hipotesis(Lr_Casos.TITULO_FIN_HIP);
                        FETCH C_Hipotesis INTO Lv_TituloFinal;
                    CLOSE C_Hipotesis;
                END IF;

            ELSE
                Lv_TituloFinal := Lr_Casos.TITULO_FIN;
            END IF;

            OPEN C_GetTiempoCaso(Lr_Casos.ID_CASO);
                FETCH C_GetTiempoCaso INTO Lv_TiempoCasoSolucion;
            CLOSE C_GetTiempoCaso;

            IF Lv_TiempoCasoSolucion IS NOT NULL THEN
                Lv_TiempoCasoSolucion := Lv_TiempoCasoSolucion ||' minutos';
            END IF;

            OPEN C_GetOneDetalleByIdCaso(Lr_Casos.ID_CASO);
              FETCH C_GetOneDetalleByIdCaso
                INTO Lc_GetOneDetalleByIdCaso;
                  Lb_tieneDatos := C_GetOneDetalleByIdCaso%FOUND;
            CLOSE C_GetOneDetalleByIdCaso;

            Lv_LoginAfectado   := NULL;
            Lv_ClienteAfectado := NULL;

            IF Lb_tieneDatos THEN

                OPEN C_GetUltimaAsignacion(Lr_Casos.ID_CASO);
                    FETCH C_GetUltimaAsignacion INTO Lv_AsignadoNombre;
                CLOSE C_GetUltimaAsignacion;

                IF Lv_AsignadoNombre IS NULL THEN
                    Lv_AsignadoNombre := 'Sin Asignacion';
                END IF;

                OPEN C_GetOneDetalleByIdCaso(Lr_Casos.ID_CASO);

                    LOOP

                        FETCH C_GetOneDetalleByIdCaso INTO Lc_GetOneDetalleByIdCaso;

                        EXIT WHEN C_GetOneDetalleByIdCaso%NOTFOUND;

                        FOR infoDetalle IN C_getInfoDetalle(Lc_GetOneDetalleByIdCaso.idDetalleHipotesis) LOOP

                            IF infoDetalle.TAREA_ID IS NOT NULL THEN

                                OPEN C_getTareaEstado(infoDetalle.ID_DETALLE);
                                    FETCH C_getTareaEstado INTO Lc_GetTareaEstado;
                                CLOSE C_getTareaEstado;

                                IF Lc_GetTareaEstado.NOMBRE_TAREA IS NOT NULL AND
                                    (LENGTH(Lv_NombreTarea) <= 1000 OR Lv_NombreTarea IS NULL) THEN

                                    IF Lv_NombreTarea IS NULL THEN
                                        Lv_NombreTarea := Lc_GetTareaEstado.NOMBRE_TAREA;
                                    ELSE
                                        Lv_NombreTarea := Lv_NombreTarea||', '||Lc_GetTareaEstado.NOMBRE_TAREA;
                                    END IF;

                                END IF;

                                IF Lc_GetTareaEstado.ESTADO IS NOT NULL AND
                                    (LENGTH(Lv_EstadoTarea) <= 1000 OR Lv_EstadoTarea IS NULL) THEN

                                    IF Lv_EstadoTarea IS NULL THEN
                                        Lv_EstadoTarea := Lc_GetTareaEstado.ESTADO;
                                    ELSE
                                        Lv_EstadoTarea := Lv_EstadoTarea||', '||Lc_GetTareaEstado.ESTADO;
                                    END IF;

                                END IF;

                            END IF;

                            FOR parteAfectada IN C_GetAfectadosPorCaso (infoDetalle.ID_DETALLE) LOOP

                                Lb_EnLimite := FALSE;

                                IF (Lv_LoginAfectado IS NOT NULL AND LENGTH(Lv_LoginAfectado) >= 1000) OR
                                   (Lv_ClienteAfectado IS NOT NULL AND LENGTH(Lv_ClienteAfectado) >= 1000) THEN
                                    Lb_EnLimite := TRUE;
                                END IF;

                                EXIT WHEN Lb_EnLimite;

                                --En caso que la condici�n anterior no se cumpla, se procede a obtener los afectados.

                               IF Lv_LoginAfectado IS NULL THEN
                                    Lv_LoginAfectado := parteAfectada.AFECTADO_NOMBRE;
                                ELSE
                                    Lv_LoginAfectado := Lv_LoginAfectado||', '||parteAfectada.AFECTADO_NOMBRE;
                                END IF;

                                IF Lv_ClienteAfectado IS NULL THEN
                                    Lv_ClienteAfectado :=  parteAfectada.AFECTADO_DESCRIPCION;
                                ELSE
                                    Lv_ClienteAfectado := Lv_ClienteAfectado||', '||parteAfectada.AFECTADO_DESCRIPCION;
                                END IF;

                                EXIT WHEN parteAfectada.TIPO_AFECTADO = 'Elemento';

                                --En caso que la condici�n anterior no se cumpla se sobre entiende que el afectado es Cliente
                                OPEN C_GetPuntoCliente(parteAfectada.AFECTADO_ID);
                                    FETCH C_GetPuntoCliente INTO Lc_GetPuntoCliente;
                                     Lb_tieneDatos := C_GetOneDetalleByIdCaso%FOUND;
                                CLOSE C_GetPuntoCliente;

                                IF Lb_tieneDatos THEN

                                    Lv_Direccion := Lc_GetPuntoCliente.DIRECCION;

                                    FOR CONTACTOS IN C_GetContactosPunto(Lc_GetPuntoCliente.ID_PUNTO) LOOP
                                        IF CONTACTOS.VALOR IS NOT NULL
                                          AND (Lv_Contactos IS NULL OR LENGTH(Lv_Contactos) <= 1000) THEN
                                            IF Lv_Contactos IS NULL THEN
                                                Lv_Contactos := CONTACTOS.VALOR;
                                            ELSE
                                                Lv_Contactos := Lv_Contactos||', '||CONTACTOS.VALOR;
                                            END IF;
                                        END IF;
                                    END LOOP;

                                    OPEN C_GetServiciosPorPunto (Lc_GetPuntoCliente.ID_PUNTO);
                                        FETCH C_GetServiciosPorPunto INTO Lc_GetServiciosPorPunto;
                                        Lb_tieneDatos := C_GetServiciosPorPunto%FOUND;
                                    CLOSE C_GetServiciosPorPunto;

                                    IF Lb_tieneDatos THEN

                                        Lv_EstadoServicio := Lc_GetServiciosPorPunto.ESTADO;

                                        OPEN C_ServicioTecnico (Lc_GetServiciosPorPunto.ID_SERVICIO);
                                            FETCH C_ServicioTecnico INTO Lc_ServicioTecnico;
                                            Lb_tieneDatos := C_ServicioTecnico%FOUND;
                                        CLOSE C_ServicioTecnico;

                                        IF Lb_tieneDatos THEN

                                            IF Lc_ServicioTecnico.ELEMENTO_CONTENEDOR_ID IS NOT NULL THEN
                                                OPEN C_Elmento (Lc_ServicioTecnico.ELEMENTO_CONTENEDOR_ID);
                                                    FETCH C_Elmento INTO Lc_Elmento;
                                                CLOSE C_Elmento;
                                                Lv_Caja := Lc_Elmento.NOMBRE_ELEMENTO;
                                            ELSE
                                                Lv_Caja := NULL;
                                            END IF;

                                            IF Lc_ServicioTecnico.ELEMENTO_ID IS NOT NULL THEN
                                                OPEN C_Elmento (Lc_ServicioTecnico.ELEMENTO_ID);
                                                    FETCH C_Elmento INTO Lc_Elmento;
                                                CLOSE C_Elmento;
                                                Lv_Olt := Lc_Elmento.NOMBRE_ELEMENTO;
                                            ELSE
                                                Lv_Olt := NULL;
                                            END IF;

                                        ELSE

                                            Lv_Caja := NULL;
                                            Lv_Olt  := Lv_ClienteAfectado;

                                        END IF;

                                    ELSE

                                        Lv_Caja := NULL;
                                        Lv_Olt  := Lv_ClienteAfectado;

                                    END IF;

                                ELSE

                                    Lv_Caja := NULL;
                                    Lv_Olt  := Lv_ClienteAfectado;

                                END IF;

                            END LOOP;

                        END LOOP;

                    END LOOP;

                CLOSE C_GetOneDetalleByIdCaso;

            END IF;
            Lv_DetalleHipotesisFile :=  NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                        (TRIM(REPLACE(
                                        REPLACE(
                                            REPLACE(Lv_TituloFinal,Chr(9),' '),Chr(10),' '),
                                                Chr(13),' ')
                                            )
                                        ),'');

            IF Lt_ConsultaArbolHipotesis = 'S' THEN
                Lv_DetalleHipotesisFile :=  NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                            (TRIM(REPLACE(
                                                REPLACE(
                                                    REPLACE(Lv_NombreHipotesisArbolN1,Chr(9),' '),Chr(10),' '),
                                                        Chr(13),' ')
                                                )
                                            ),'')
                                            ||Lv_Delimitador||
                                            NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                            (TRIM(REPLACE(
                                                REPLACE(
                                                    REPLACE(Lv_NombreHipotesisArbolN2,Chr(9),' '),Chr(10),' '),
                                                        Chr(13),' ')
                                                )
                                            ),'')
                                            ||Lv_Delimitador||
                                            NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                            (TRIM(REPLACE(
                                                REPLACE(
                                                    REPLACE(Lv_NombreHipotesisArbolN3,Chr(9),' '),Chr(10),' '),
                                                        Chr(13),' ')
                                                )
                                            ),'');
            END IF;

            UTL_FILE.PUT_LINE(Lf_Archivo,
                                Lr_Casos.NUMERO_CASO||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Casos.TITULO_INI,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                Lv_DetalleHipotesisFile

                                ||Lv_Delimitador||

                                TO_CHAR(Lr_Casos.FE_APERTURA,'RRRR-MM-DD HH24:MI')||Lv_Delimitador||

                                TO_CHAR(Lr_Casos.FE_CIERRE,'RRRR-MM-DD HH24:MI')||Lv_Delimitador||

                                Lr_Casos.ESTADO||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Casos.VERSION_INI,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lr_Casos.VERSION_FIN,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                Lv_LoginAfectado||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lv_ClienteAfectado,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                Lv_Caja||Lv_Delimitador||

                                Lv_Olt||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lv_Direccion,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lv_Contactos,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                Lv_AsignadoNombre||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lv_NombreTarea,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lv_EstadoTarea,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' ')
                                      )
                                ),'')||Lv_Delimitador||

                                Lv_EstadoServicio||Lv_Delimitador||

                                Lv_TiempoCasoSolucion||Lv_Delimitador||

                                Lv_DepartamentoCierra||Lv_Delimitador||

                                NVL(DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN
                                (TRIM(REPLACE(
                                      REPLACE(
                                      REPLACE(Lc_ultimosCasos,Chr(9),' '),Chr(10),' '),
                                             Chr(13),' '))),''));

            --Limpiamos las variables de apoyo
            Lv_TituloFinal          := NULL;
            Lc_GetPuntoCliente      := NULL;
            Lv_LoginAfectado        := NULL;
            Lv_ClienteAfectado      := NULL;
            Lv_Caja                 := NULL;
            Lv_Olt                  := NULL;
            Lv_Direccion            := NULL;
            Lv_Contactos            := NULL;
            Lv_AsignadoNombre       := NULL;
            Lv_NombreTarea          := NULL;
            Lv_EstadoTarea          := NULL;
            Lv_EstadoServicio       := NULL;
            Lv_TiempoCasoSolucion   := NULL;
            Lv_DepartamentoCierra   := NULL;
            Lv_Canton               := NULL;
            Ln_Cantidad             := NULL;
            Lc_ultimosCasos         := NULL;
            Lc_UltimaDepCierraTarea := NULL;

        END LOOP;

    CLOSE Lrf_ReporteCasos;

    --Cierre del Archivo
    UTL_FILE.FCLOSE(Lf_Archivo);

    --Ejecuci�n del comando para crear el archivo comprimido
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lt_ComandoReporte||' '||Lt_RutaDirectorio||Lv_NombreArchivo));

    --Envio del archivo por correo
    DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lt_CorreoRemitente,
                                              Lv_Para||',',
                                              Lt_AsuntoCorreo,
                                              Lt_PlantillaNotificacion,
                                              Lt_NombreDirectorio,
                                              Lv_NombreArchivo||Lt_ExtensionReporte);

    --Eliminaci�n del archivo
    BEGIN
        UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
    EXCEPTION
        WHEN OTHERS THEN
            IF Lv_IpSolicita IS NULL THEN
                Lv_IpSolicita := SYS_CONTEXT('USERENV','IP_ADDRESS');
            END IF;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                 'P_REPORTE_CASOS',
                                                  Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                    DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    END;

    --Mensaje de respuesta
    Pv_Status  := 'ok';
    Pv_Message := 'Proceso ejecutado correctamente';

    --Insertamos la ejecuci�n por ok del reporte.
    IF Lt_InsertaOk IS NULL OR UPPER(Lt_InsertaOk) = 'S' THEN

        IF Lv_IpSolicita IS NULL THEN
            Lv_IpSolicita := SYS_CONTEXT('USERENV','IP_ADDRESS');
        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_CASOS',
                                              Pv_Message,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(Lv_IpSolicita, '127.0.0.1'));
    END IF;

  EXCEPTION

    WHEN OTHERS THEN

        IF Lv_IpSolicita IS NULL THEN
            Lv_IpSolicita := SYS_CONTEXT('USERENV','IP_ADDRESS');
        END IF;

        --Eliminaci�n del archivo
        BEGIN

            IF Lt_NombreDirectorio IS NOT NULL AND Lv_NombreArchivo IS NOT NULL THEN

                UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                IF Lb_Fexists THEN
                    UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo);
                END IF;

                IF Lt_ExtensionReporte IS NOT NULL THEN
                    UTL_FILE.FGETATTR(Lt_NombreDirectorio, Lv_NombreArchivo||Lt_ExtensionReporte, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
                    IF Lb_Fexists THEN
                        UTL_FILE.FREMOVE(Lt_NombreDirectorio,Lv_NombreArchivo||Lt_ExtensionReporte);
                    END IF;
                END IF;

            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                     'P_REPORTE_CASOS',
                                                      Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                        DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                      NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                      SYSDATE,
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        END;

        Pv_Status  := 'fail';
        Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;

        IF Lv_Para IS NULL THEN
            Lv_Para := NVL(Lt_CorreoError,'sistemas@telconet.ec');
        END IF;

        IF Lt_CorreoRemitente IS NULL THEN
            Lt_CorreoRemitente := 'notificaciones_telcos@telconet.ec';
        END IF;

        IF Lt_AsuntoCorreo IS NULL THEN
            Lt_AsuntoCorreo := 'REPORTE DE CASOS (ERROR)';
        ELSE
            Lt_AsuntoCorreo := Lt_AsuntoCorreo || ' (ERROR)';
        END IF;

        IF Lt_PlantillaError IS NOT NULL THEN
            Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[userLogin]]' , Lv_UsuarioSolicita);
            Lt_PlantillaError := REPLACE(Lt_PlantillaError,'[[diaReporte]]', TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS'));
        ELSE
            Lt_PlantillaError := 'Estimado usuario '||Lv_UsuarioSolicita
                ||', el reporte de casos generado el d�a '||TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')
                ||' no se pudo generar. Por favor comunicar a Sistemas';
        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_CASOS',
                                              Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(Lv_IpSolicita, '127.0.0.1'));

        Lv_Json := SUBSTR(Pcl_Json,0,3000);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                             'P_REPORTE_CASOS',
                                              Lv_Codigo||'|1- '||Lv_Json,
                                              NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

        Lv_Json := NULL;
        Lv_Json := SUBSTR(Pcl_Json,3001,6000);
        IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                 'P_REPORTE_CASOS',
                                                  Lv_Codigo||'|2- '||Lv_Json,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(Lv_IpSolicita, '127.0.0.1'));
        END IF;

        Lv_Json := NULL;
        Lv_Json := SUBSTR(Pcl_Json,6001,8000);
        IF Lv_Json IS NOT NULL THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_REPORTES',
                                                 'P_REPORTE_CASOS',
                                                  Lv_Codigo||'|3- '||Lv_Json,
                                                  NVL(Lv_UsuarioSolicita, 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(Lv_IpSolicita, '127.0.0.1'));
        END IF;

        UTL_MAIL.SEND(SENDER     => Lt_CorreoRemitente,
                      RECIPIENTS => Lv_Para,
                      SUBJECT    => Lt_AsuntoCorreo,
                      MESSAGE    => Lt_PlantillaError,
                      MIME_TYPE  => 'text/html; charset=UTF-8');

  END P_REPORTE_CASOS;
--
--
  FUNCTION F_GET_VARCHAR_CLEAN(Fv_Cadena IN CLOB)
      RETURN CLOB IS
  BEGIN
      RETURN TRIM(
              REPLACE(
              REPLACE(
              REPLACE(
              REPLACE(
              TRANSLATE(
              REGEXP_REPLACE(
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|<|>|/|;|.|%|"]|+$', ' ')
              ,'[^A-Za-z0-9������������&()-_ ]' ,' ')
              ,'������������', 'AEIOUNaeioun')
              , Chr(9), ' ')
              , Chr(10), ' ')
              , Chr(13), ' ')
              , Chr(59), ' '));

  END F_GET_VARCHAR_CLEAN;

END SPKG_REPORTES;
/

