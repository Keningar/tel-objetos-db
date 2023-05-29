CREATE OR REPLACE package NAF47_TNET.INK_PROCESA_REPORTE is

  /**
  * Documentacion para NAF47_TNET.INK_PROCESA_REPORTE
  * Paquete que contiene funcion para obtener informacin en consulta de series 
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 - Se modifica para aumentar length de campo observacion  
  */

  type Pr_MovSeries is record(
    fecha                 NAF47_TNET.arinmn.fecha%type,
    time_stamp            NAF47_TNET.arinmn.time_stamp%type,
    bodega                NAF47_TNET.arinbo.codigo%type,
    nombre_bodega         NAF47_TNET.arinbo.descripcion%type,
    tipo_documento        NAF47_TNET.arinmn.tipo_doc%type,
    desc_tipo_documento   NAF47_TNET.arinvtm.descri%type,
    clase_movimiento      NAF47_TNET.arinvtm.movimi%type,
    es_consumo            NAF47_TNET.arinvtm.consum%type,
    es_transferencia      NAF47_TNET.arinvtm.trasla%type,
    id_documento          NAF47_TNET.arinmn.no_docu%type,
    usuario               NAF47_TNET.arinme.usuario%type,
    id_articulo           NAF47_TNET.arinda.no_arti%type,
    nombre_articulo       NAF47_TNET.arinda.descripcion%type,
    unidades              NAF47_TNET.arinmn.unidades%type,
    numero_serie          NAF47_TNET.inv_numero_serie.serie%type,
    numero_mac            NAF47_TNET.inv_numero_serie.mac%type,
    empl_ingresa          varchar2(1000),
    empl_transfiere       varchar2(1000),
    empl_despacha_cons    varchar2(1000),
    empl_responsable_cons varchar2(1000),
    cont_responsable_cons varchar2(1000),
    solicitanate_cons     varchar2(1000),
    empl_despacha         varchar2(1000),
    empl_responsable      varchar2(1000),
    cont_responsable      varchar2(1000),
    solicitante           varchar2(1000),
    observaciones         varchar2(1000),
    estado_bodega         varchar2(50),
    estado_instalacion    varchar2(50),
    grupo_activo          NAF47_TNET.ARINDA.TIPO_ARTICULO%type);

  type rf_MovSeries is ref cursor return Pr_MovSeries;

  -------------------------------------------------------------------------
  /**
  * Documentacion para in_f_movimiento_series
  * Funcion que obtiene informacion de series relacioandas a articulos
  *
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoCentro IN varchar2  Recibe el codigo del centro de didtribucion
  * @param  Pv_FechaInicio IN date  Recibe la fecha de inicio para busqueda  
  * @param  Pv_FechaFin    IN date  Recibe la fecha de fin para busqueda
  * @param  Pv_NoBodega    IN varchar2  Recibe el codigo de bodega
  * @param  Pv_ClaseMov    IN varchar2  Recibe la clase de movimiento 
  * @param  Pv_TipoDoc     IN varchar2  Recibe el codigo del tipo de documento
  * @param  Pv_SoloBodZonal IN varchar2  Recibe indicado de bodega zonal
  * @param  Pv_IdArticulo   IN varchar2  Recibe el codigo del articulo
  *
  *
  * @author  llindao <llindao@telconet.ec>
  * @version 1.0  
  *
  * @author mnavarrete <mnavarrete@telconet.ec> 
  * @version 1.1  19/07/2017 Se modifica select de obtencion de informacion para usuario despachos manuales 
  *
  * @author emunoz <emunoz@telconet.ec> 
  * @version 1.2  06/06/2021 Se modifica select de obtencion de informacion para usuario despachos manuales 
  *
  * @author Luis Lindao <llindao@telconet.ec> 
  * @version 1.3  24/04/2022 - Se modifica para recuperar correctamente la descripción del tipo de artículo
  *
  * @author Elvis Munoz <llindao@telconet.ec> 
  * @version 1.4  12/07/2022 - Se modifica para recuperar correctamente el ultimo movimiento de un articulo  
  **/
  function in_f_movimiento_series(Pv_NoCia        Varchar2,
                                  Pv_NoCentro     Varchar2,
                                  Pv_FechaInicio  Date,
                                  Pv_FechaFin     Date,
                                  Pv_NoBodega     Varchar2,
                                  Pv_ClaseMov     Varchar2,
                                  Pv_TipoDoc      Varchar2,
                                  Pv_SoloBodZonal Varchar2,
                                  Pv_IdArticulo   Varchar2,
                                  Pv_UltimosMovi  VARCHAR2 DEFAULT 'N')
    return rf_MovSeries;

  /**
  * Documentacion para in_f_estado_articulo_series
  * Funcion que obtiene la describcion de los estados de bodegas
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoArticulo      IN varchar2  Recibe el codigo del articulo
  * @param  Pv_NoSerie      IN varchar2  Recibe el codigo de la serie del articulo
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0   
  */
  FUNCTION IN_F_ESTADO_X_BODEGA(Pv_NoCia      IN VARCHAR2,
                                Pv_NoArticulo IN VARCHAR2,
                                Pv_NoSerie    IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para in_f_estado_articulo_series
  * Funcion que obtiene la describcion de los estados del articulo de instlacion
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoArticulo      IN varchar2  Recibe el codigo del articulo
  * @param  Pv_NoSerie      IN varchar2  Recibe el codigo de la serie del articulo
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0   
  */
  FUNCTION IN_F_ESTADO_INSTALACION(Pv_NoCia      IN VARCHAR2,
                                   Pv_NoArticulo IN VARCHAR2,
                                   Pv_NoSerie    IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para in_f_estado_articulo_series
  * Funcion que obtiene la describcion de los estados del articulo de instlacion
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoDocu      IN varchar2  Recibe el codigo del articulo
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0   
  */

  FUNCTION IN_F_RESPONSABLE(Pv_NoCia    IN VARCHAR2,
                            Pv_TipoDocu IN VARCHAR2,
                            Pv_NoDocu   IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para in_f_estado_articulo_series
  * Funcion que obtiene el grupo de activo
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_IdArticulo      IN varchar2  Recibe el codigo del articulo
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0   
  */
  FUNCTION IN_F_GRUPO_ACTIVO(Pv_IdEmpresa  IN VARCHAR,
                             Pv_IdArticulo IN VARCHAR2) RETURN VARCHAR;
 
/**
  * Documentacion para IN_P_PROCESA_ULTIMO_MOV
  * Funcion que obtiene la informacion de los ultimos movimientos de articulos por bodega
  *
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoCentro IN varchar2  Recibe el codigo del centro de didtribucion
  * @param  Pv_FechaInicio IN date  Recibe la fecha de inicio para busqueda  
  * @param  Pv_FechaFin    IN date  Recibe la fecha de fin para busqueda
  * @param  Pv_NoBodega    IN varchar2  Recibe el codigo de bodega
  * @param  Pv_ClaseMov    IN varchar2  Recibe la clase de movimiento 
  * @param  Pv_TipoDoc     IN varchar2  Recibe el codigo del tipo de documento
  * @param  Pv_SoloBodZonal IN varchar2  Recibe indicado de bodega zonal
  * @param  Pv_IdArticulo   IN varchar2  Recibe el codigo del articulo
  * @param  Pv_MensajeError OUT VARCHAR2 Devuelve mensaje de error ocurrido dentro del procedimiento
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0 12/07/2022   
  
  */
  PROCEDURE IN_P_PROCESA_ULTIMO_MOV (Pv_IdEmpresa       IN VARCHAR,
                                   Pv_IdCentro        IN VARCHAR2,
                                   Pd_FechaInicio     IN DATE,
                                   Pd_FechaFin        IN DATE,
                                   Pv_IdBodega        IN VARCHAR2,
                                   Pv_ClaseMovimiento IN VARCHAR2,
                                   Pv_TipoDocumento   IN VARCHAR2,
                                   Pv_EsBodegaZonal   IN VARCHAR2,
                                   Pv_IdArticulo      IN VARCHAR2,
                                   Pv_MensajeError    OUT VARCHAR2);
  
  /**
  * Documentacion para IN_P_MOVIMIENTOS_NACIONAL
  * Procedimiento que genera la informacion de los ultimos movimientos de items
  *
  * @param  Pv_cia      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_NoCentro IN varchar2  Recibe el codigo del centro de didtribucion
  * @param  Pv_FechaInicio IN date  Recibe la fecha de inicio para busqueda  
  * @param  Pv_FechaFin    IN date  Recibe la fecha de fin para busqueda
  * @param  Pv_NoBodega    IN varchar2  Recibe el codigo de bodega
  * @param  Pv_ClaseMov    IN varchar2  Recibe la clase de movimiento 
  * @param  Pv_TipoDoc     IN varchar2  Recibe el codigo del tipo de documento
  * @param  Pv_SoloBodZonal IN varchar2  Recibe indicado de bodega zonal
  * @param  Pv_IdArticulo   IN varchar2  Recibe el codigo del articulo
  * @param  Pv_MensajeError OUT VARCHAR2 Devuelve mensaje de error ocurrido dentro del procedimiento
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0 12/07/2022
  
  */
  PROCEDURE IN_P_MOVIMIENTOS_NACIONAL(Pv_IdEmpresa        IN VARCHAR2,
                                      Pv_IdCentro     IN VARCHAR2,
                                      Pv_FechaInicio  IN DATE,
                                      Pv_FechaFin     IN DATE,
                                      Pv_NoBodega     IN VARCHAR2,
                                      Pv_ClaseMov     IN VARCHAR2,
                                      Pv_TipoDoc      IN VARCHAR2,
                                      Pv_SoloBodZonal IN VARCHAR2,
                                      Pv_IdArticulo   IN VARCHAR2,
                                      Pv_MensajeError OUT VARCHAR2); 

   /**
  * Documentacion para IN_P_BORRA_MOVIMIENTOS_TEMP
  * Procedimiento que borra la informacion generada por medio del reporte de movimientos a excel Ultimos movimientos y los de movimientos a nivel nacional
  *
  * @param  Pv_IdEmpresa      IN varchar2  Recibe el codigo de la empresa
  * @param  Pv_Usuario IN varchar2  Recibe el codigo del usuario para la eliminacion
  * @param  Pv_TipoReporte IN date  Recibe el tipo de reporte para la eliminacion MU-Ultimos Movimientos o MN-Movimientos a Nivel Nacional 
  * @param  Pv_MensajeError OUT VARCHAR2 Devuelve mensaje de error ocurrido dentro del procedimiento
  * @author  emunoz <emunoz@telconet.ec>
  * @version 1.0 12/07/2022 
  
  */                                     
  PROCEDURE IN_P_BORRA_MOVIMIENTOS_TEMP(Pv_IdEmpresa IN VARCHAR2,
                                        Pv_Usuario IN VARCHAR2 ,
                                        Pv_TipoReporte IN VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2 );                            

end INK_PROCESA_REPORTE;
/

CREATE OR REPLACE package body NAF47_TNET.INK_PROCESA_REPORTE is

  function in_f_movimiento_series(Pv_NoCia        Varchar2,
                                  Pv_NoCentro     Varchar2,
                                  Pv_FechaInicio  Date,
                                  Pv_FechaFin     Date,
                                  Pv_NoBodega     Varchar2,
                                  Pv_ClaseMov     Varchar2,
                                  Pv_TipoDoc      Varchar2,
                                  Pv_SoloBodZonal Varchar2,
                                  Pv_IdArticulo   Varchar2,
                                  Pv_UltimosMovi  VARCHAR2 DEFAULT 'N')
    return rf_MovSeries is
    c_movimientos rf_MovSeries;
    Lv_MensajeError     VARCHAR2(3000):=NULL;
  begin
    if Pv_UltimosMovi = 'N' THEN
      open c_movimientos for
        select b.fecha,
               a.time_stamp,
               a.bodega,
               (select x.descripcion
                  from NAF47_TNET.arinbo x
                 where x.codigo = a.bodega
                   and x.no_cia = a.no_cia) nombre_bodega,
               a.tipo_doc tipo_documento,
               td.descri desc_tipo_documento,
               td.movimi clase_movimiento,
               td.consum es_consumo,
               td.trasla es_transferencia,
               a.no_docu id_documento,
               b.usuario,
               a.no_arti id_articulo,
               (select replace(replace(x.descripcion, chr(13), ' '),
                               chr(10),
                               ' ')
                  from NAF47_TNET.arinda x
                 where x.no_arti = a.no_arti
                   and x.no_cia = a.no_cia) nombre_articulo,
               a.unidades,
               replace(replace(c.serie, chr(13), ' '),chr(10),' ') AS numero_serie,
               c.mac numero_mac,
               -- usuarios ingresos --
               (select e.no_emple || ' - ' || e.nombre
                  from NAF47_TNET.tasgusuario u, naf47_tnet.v_empleados_empresas e
                 where u.usuario = b.usuario
                   and u.no_cia = b.no_cia
                   and u.id_empleado = e.no_emple
                   and u.no_cia = e.no_cia) empl_ingresa,
               -- usuarios transferencias --
               (select e.no_emple || ' - ' || e.nombre
                  from NAF47_TNET.arinte                          t,
                       NAF47_TNET.tasgusuario                     u,
                       naf47_tnet.v_empleados_empresas e
                 where t.usuario = u.usuario
                   and t.no_cia = u.no_cia
                   and u.id_empleado = e.no_emple
                   and u.no_cia = e.no_cia
                   and t.no_docu = b.no_docu
                   and t.no_cia = b.no_cia) empl_transfiere,
               -- usuarios consumos --
               (select e.no_emple || ' - ' || e.nombre
                  from NAF47_TNET.arinencconsumointer             v,
                       NAF47_TNET.tasgusuario                     u,
                       naf47_tnet.v_empleados_empresas e
                 where v.usuario_ingresa = u.usuario
                   and v.no_cia = u.no_cia
                   and u.id_empleado = e.no_emple
                   and u.no_cia = e.no_cia
                   and v.no_cia = b.no_cia
                   and v.no_docu = b.no_docu_refe
                   and v.tipo_doc = b.tipo_doc
                   and v.centro = b.centro) empl_despacha_cons,
               (select v.emple_solic || ' - ' || e.nombre
                  from NAF47_TNET.arinencconsumointer             v,
                       naf47_tnet.v_empleados_empresas e
                 where v.emple_solic = e.no_emple
                   and v.no_cia = e.no_cia
                   and v.no_cia = b.no_cia
                   and v.no_docu = b.no_docu_refe
                   and v.tipo_doc = b.tipo_doc
                   and v.centro = b.centro) empl_responsable_cons,
               (select v.emple_solic || ' - ' || c.nombre
                  from NAF47_TNET.arinencconsumointer v, arinmcnt c
                 where v.emple_solic = c.no_contratista
                   and v.no_cia = c.no_cia
                   and v.no_cia = b.no_cia
                   and v.no_docu = b.no_docu_refe
                   and v.tipo_doc = b.tipo_doc
                   and v.centro = b.centro) cont_responsable_cons,
               (select v.emple_aprueba || ' - ' || e.nombre
                  from NAF47_TNET.arinencconsumointer             v,
                       naf47_tnet.v_empleados_empresas e
                 where v.emple_aprueba = e.no_emple
                   and v.no_cia = e.no_cia
                   and v.no_cia = b.no_cia
                   and v.no_docu = b.no_docu_refe
                   and v.tipo_doc = b.tipo_doc
                   and v.centro = b.centro) solicitanate_cons,
               -- usuario despachos manuales --
               (select w.user_realiza || ' - ' || e.nombre
                  from NAF47_TNET.inv_cab_solicitud_requisicion   w,
                       naf47_tnet.v_empleados_empresas e
                 where w.user_realiza = e.no_emple
                   and w.no_cia_emp_realiza = e.no_cia
                   and w.numero_solicitud = b.numero_solicitud
                   and w.tipo_documento = b.tipo_doc
                   and w.centro = b.centro
                   and w.no_cia = b.no_cia) empl_despacha,
               
               (select w.emple_solic || ' - ' || e.nombre
                  from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
                 where w.emple_solic = e.no_emple
                   and w.no_cia = e.no_cia
                   and w.no_docu = b.no_docu
                   and w.no_cia = b.no_cia) empl_responsable,
               
               (select w.usuario_aprobacion || ' - ' || c.nombre
                  from NAF47_TNET.inv_cab_solicitud_requisicion w, NAF47_TNET.arinmcnt c
                 where w.usuario_aprobacion = c.no_contratista
                   and w.no_cia_responsable = c.no_cia
                   and w.numero_solicitud = b.numero_solicitud
                   and w.tipo_documento = b.tipo_doc
                   and w.centro = b.centro
                   and w.no_cia = b.no_cia) cont_responsable,
               
               (select w.empleado_solicitante || ' - ' || e.nombre
                  from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
                 where w.empleado_solicitante = e.no_emple
                   and w.no_cia = e.no_cia
                   and w.no_docu = b.no_docu
                   and w.no_cia = b.no_cia) solicitante,
               
               replace(replace(replace(b.observ1, chr(13), ' '), chr(10), ' '),';',', ') observaciones,
               NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_X_BODEGA(A.NO_CIA,
                                                                   A.NO_ARTI,
                                                                   C.SERIE) estado_bodega,
               NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_INSTALACION(A.NO_CIA,
                                                                      A.NO_ARTI,
                                                                      C.SERIE) estado_instalacion,

               (select tipo_articulo 
                from naf47_tnet.arinda da 
                where da.no_arti = a.no_arti 
                and da.no_cia = a.no_cia) as grupo_activo
          from NAF47_TNET.arinmn a, NAF47_TNET.arinme b, NAF47_TNET.inv_documento_serie c, NAF47_TNET.arinvtm td
         where a.no_docu = b.no_docu
           and a.no_cia = b.no_cia
           and a.tipo_doc = td.tipo_m
           and a.no_cia = td.no_cia
           and a.no_linea = c.linea(+)
           and a.no_docu = c.id_documento(+)
           and a.no_cia = c.compania(+)
           and a.no_cia = Pv_NoCia
           and a.centro = Pv_NoCentro
           and a.fecha >= Pv_FechaInicio
           and a.fecha <= Pv_FechaFin
           and a.no_arti = nvl(Pv_IdArticulo, a.no_arti)
           and a.bodega = nvl(Pv_NoBodega, a.bodega)
           and td.movimi = nvl(Pv_ClaseMov, td.movimi)
           and td.tipo_m = nvl(Pv_TipoDoc, td.tipo_m)
           and exists
         (select null
                  from NAF47_TNET.arinbo c
                 where c.codigo = a.bodega
                   and c.no_cia = a.no_cia
                   and (Pv_SoloBodZonal = 'N' or
                       (c.no_emple is not null and Pv_SoloBodZonal = 'S')))
         order by a.bodega, a.fecha, a.time_stamp;
    ELSIF Pv_UltimosMovi = 'S' THEN
    NAF47_TNET.INK_PROCESA_REPORTE.IN_P_PROCESA_ULTIMO_MOV(Pv_NoCia,
                                                   Pv_NoCentro,
                                                   Pv_FechaInicio,
                                                   Pv_FechaFin,
                                                   Pv_NoBodega, 
                                                   Pv_ClaseMov, 
                                                   Pv_TipoDoc, 
                                                   Pv_SoloBodZonal,
                                                   Pv_IdArticulo,
                                                   Lv_MensajeError);
      OPEN C_Movimientos FOR 
      /*costo= 1*/
        SELECT A.FECHA,
                A.TIME_STAMP,
                A.BODEGA,
                A.NOMBRE_BODEGA,
                A.TIPO_DOCUMENTO,
                A.DESC_TIPO_DOCUMENTO,
                A.CLASE_MOVIMIENTO,
                A.ES_CONSUMO,
                A.ES_TRANSFERENCIA,
                A.ID_DOCUMENTO,
                A.USUARIO,
                A.ID_ARTICULO,
                A.NOMBRE_ARTICULO,
                A.UNIDADES,
                A.NUMERO_SERIE,
                A.NUMERO_MAC,
                A.EMPL_INGRESA,
                A.EMPL_TRANSFIERE,
                A.EMPL_DESPACHA_CONS,
                A.EMPL_RESPONSABLE_CONS,
                A.CONT_RESPONSABLE_CONS,
                A.SOLICITANATE_CONS,
                A.EMPL_DESPACHA,
                A.EMPL_RESPONSABLE,
                A.CONT_RESPONSABLE,
                A.SOLICITANTE,
                A.OBSERVACIONES,
                A.ESTADO_BODEGA,
                A.ESTADO_INSTALACION,
                A.GRUPO_ACTIVO
          FROM NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP A
          WHERE A.NO_CIA=Pv_NoCia
            AND A.USUARIO_CREA=USER
            AND A.TIPO_REPORTE='MU'
            AND A.ID_DOCUMENTO = (SELECT MAX(TO_NUMBER(ID_DOCUMENTO))
                    FROM NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP B
                   WHERE A.NO_CIA = B.NO_CIA
                     AND A.ID_ARTICULO = B.ID_ARTICULO
                     AND A.BODEGA = B.BODEGA)
       ORDER BY A.FECHA DESC,A.BODEGA ASC;
    END IF;
    return(c_movimientos);
  
  end in_f_movimiento_series;
  FUNCTION IN_F_ESTADO_X_BODEGA(Pv_NoCia      IN VARCHAR2,
                                Pv_NoArticulo IN VARCHAR2,
                                Pv_NoSerie    IN VARCHAR2) RETURN VARCHAR2 IS
    CURSOR C_LeeEstadoBodega IS
      SELECT DECODE(B.ESTADO, 'EB', 'En Bodega', 'FB', 'Fuera Bodega') DESC_ESTADO
        FROM NAF47_TNET.INV_NUMERO_SERIE B
       WHERE B.COMPANIA = Pv_NoCia
         AND B.NO_ARTICULO = Pv_NoArticulo
         AND B.SERIE = Pv_NoSerie;
    Lv_EstadoBODEGA VARCHAR2(100) := NULL;
  BEGIN
    --Estado del Item en Bodega
    IF C_LeeEstadoBodega%ISOPEN THEN
      CLOSE C_LeeEstadoBodega;
    END IF;
    OPEN C_LeeEstadoBodega;
    FETCH C_LeeEstadoBodega
      INTO Lv_EstadoBODEGA;
    CLOSE C_LeeEstadoBodega;
  
    RETURN Lv_EstadoBODEGA;
  
  END IN_F_ESTADO_X_BODEGA;

  FUNCTION IN_F_ESTADO_INSTALACION(Pv_NoCia      IN VARCHAR2,
                                   Pv_NoArticulo IN VARCHAR2,
                                   Pv_NoSerie    IN VARCHAR2) RETURN VARCHAR2 IS
    CURSOR C_LeeEstadoInstalacion IS
      SELECT DECODE(ESTADO,
                    'PI',
                    'Pend. Instalar',
                    'IN',
                    'Instalado',
                    'PR',
                    'Pend. Retirar',
                    'RE',
                    'Retirado',
                    'IB',
                    'Ingr. a Bodega',
                    'NE',
                    'No Entregado') ESTADO
        FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
       WHERE A.ID_COMPANIA = Pv_NoCia
         AND A.ID_ARTICULO = Pv_NoArticulo
         AND A.NUMERO_SERIE = Pv_NoSerie
         AND A.ID_INSTALACION =
             (SELECT MAX(ID_INSTALACION)
                FROM NAF47_TNET.IN_ARTICULOS_INSTALACION B
               WHERE B.ID_COMPANIA = A.ID_COMPANIA
                 AND B.ID_ARTICULO = A.ID_ARTICULO
                 AND B.NUMERO_SERIE = A.NUMERO_SERIE);
    Lv_EstadoInstalacion VARCHAR2(100) := NULL;
  BEGIN
    --Estado del Item por Instalacion
    IF C_LeeEstadoInstalacion%ISOPEN THEN
      CLOSE C_LeeEstadoInstalacion;
    END IF;
    OPEN C_LeeEstadoInstalacion;
    FETCH C_LeeEstadoInstalacion
      INTO Lv_EstadoInstalacion;
    CLOSE C_LeeEstadoInstalacion;
  
    RETURN Lv_EstadoInstalacion;
  
  END IN_F_ESTADO_INSTALACION;

  PROCEDURE IN_P_ESTADO_ARTICULO_SERIES(Pv_NoCia             IN VARCHAR2,
                                        Pv_NoArticulo        IN VARCHAR2,
                                        Pv_NoSerie           IN VARCHAR2,
                                        Pv_EstadoBODEGA      OUT VARCHAR2,
                                        Pv_EstadoInstalacion OUT VARCHAR2,
                                        Pv_MensajeError      OUT VARCHAR2) IS
    CURSOR C_LeeEstadoBodega IS
      SELECT DECODE(ESTADO, 'EB', 'EN BODEGA', 'FB', 'FUERA BODEGA') DESC_ESTADO
        FROM NAF47_TNET.INV_NUMERO_SERIE B
       WHERE B.COMPANIA = Pv_NoCia
         AND B.NO_ARTICULO = Pv_NoArticulo
         AND B.SERIE = Pv_NoSerie;
  
    CURSOR C_LeeEstadoInstalacion IS
      SELECT DECODE(ESTADO,
                    'PI',
                    'Pendiente Instalar',
                    'IN',
                    'Instalado',
                    'PR',
                    'Pendiente Retirar',
                    'RE',
                    'Retirado',
                    'IB',
                    'Ingresado a Bodega',
                    'NE',
                    'No Entregado') ESTADO
        FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
       WHERE A.ID_COMPANIA = Pv_NoCia
         AND A.ID_ARTICULO = Pv_NoArticulo
         AND A.NUMERO_SERIE = Pv_NoSerie
         AND ID_INSTALACION =
             (SELECT MAX(ID_INSTALACION)
                FROM NAF47_TNET.IN_ARTICULOS_INSTALACION B
               WHERE B.ID_COMPANIA = A.ID_COMPANIA
                 AND B.ID_ARTICULO = A.ID_ARTICULO
                 AND B.NUMERO_SERIE = A.NUMERO_SERIE);
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_NoCia IS NULL THEN
      Pv_MensajeError := 'El Codigo de Empresa no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_NoArticulo IS NULL THEN
      Pv_MensajeError := 'El Codigo del Articulo no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
  
    --Estado del Item en Bodega
    IF C_LeeEstadoBodega%ISOPEN THEN
      CLOSE C_LeeEstadoBodega;
    END IF;
    OPEN C_LeeEstadoBodega;
    FETCH C_LeeEstadoBodega
      INTO Pv_EstadoBODEGA;
    CLOSE C_LeeEstadoBodega;
    --Estado del Item por Instalacion
    IF C_LeeEstadoInstalacion%ISOPEN THEN
      CLOSE C_LeeEstadoInstalacion;
    END IF;
    OPEN C_LeeEstadoInstalacion;
    FETCH C_LeeEstadoInstalacion
      INTO Pv_EstadoInstalacion;
    CLOSE C_LeeEstadoInstalacion;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_REPORTE.IN_P_ESTADO_ARTICULO_SERIES ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_REPORTE.IN_P_ESTADO_ARTICULO_SERIES ' ||
                         SQLCODE || ' - ' || SQLERRM;
      RETURN;
    
  END IN_P_ESTADO_ARTICULO_SERIES;

  FUNCTION IN_F_RESPONSABLE(Pv_NoCia    IN VARCHAR2,
                            Pv_TipoDocu IN VARCHAR2,
                            Pv_NoDocu   IN VARCHAR2) RETURN VARCHAR2 IS
    CURSOR C_LeeResponsable IS
      SELECT EMPLE_SOLIC
        FROM NAF47_TNET.ARINME
       WHERE NO_CIA = Pv_NoCia
         AND TIPO_DOC = Pv_TipoDocu
         AND NO_DOCU = Pv_NoDocu;
  
    Lv_Responsable VARCHAR2(300) := NULL;
  BEGIN
    IF C_LeeResponsable%ISOPEN THEN
      CLOSE C_LeeResponsable;
    END IF;
    OPEN C_LeeResponsable;
    FETCH C_LeeResponsable
      INTO Lv_Responsable;
    CLOSE C_LeeResponsable;
    RETURN Lv_Responsable;
  END IN_F_RESPONSABLE;
  --
  --

  FUNCTION IN_F_GRUPO_ACTIVO(Pv_IdEmpresa  IN VARCHAR,
                             Pv_IdArticulo IN VARCHAR2) RETURN VARCHAR IS
    CURSOR C_LeeGrupo IS
      SELECT B.DESCRIPCION
        FROM NAF47_TNET.ARINDA A, NAF47_TNET.ARINDIV B
       WHERE A.NO_CIA = B.NO_CIA
         AND A.DIVISION = B.DIVISION
         AND A.NO_CIA = Pv_IdEmpresa
         AND A.NO_ARTI = Pv_IdArticulo;
    Lv_Descripcion NAF47_TNET.ARINDIV.DESCRIPCION%type := null;
  BEGIN
    IF C_LeeGrupo%ISOPEN THEN
      CLOSE C_LeeGrupo;
    END IF;
    OPEN C_LeeGrupo;
    FETCH C_LeeGrupo
      INTO Lv_Descripcion;
    CLOSE C_LeeGrupo;
  
    RETURN Lv_Descripcion;
  
  END IN_F_GRUPO_ACTIVO;

  PROCEDURE IN_P_PROCESA_ULTIMO_MOV (Pv_IdEmpresa       IN VARCHAR,
                                   Pv_IdCentro        IN VARCHAR2,
                                   Pd_FechaInicio     IN DATE,
                                   Pd_FechaFin        IN DATE,
                                   Pv_IdBodega        IN VARCHAR2,
                                   Pv_ClaseMovimiento IN VARCHAR2,
                                   Pv_TipoDocumento   IN VARCHAR2,
                                   Pv_EsBodegaZonal   IN VARCHAR2,
                                   Pv_IdArticulo      IN VARCHAR2,
                                   Pv_MensajeError    OUT VARCHAR2) IS
/* Costo= 180 */
CURSOR C_LeeData IS
   SELECT MAX(FECHA) FECHA,
               TIME_STAMP,
               BODEGA,
               NOMBRE_BODEGA,
               TIPO_DOCUMENTO,
               DESC_TIPO_DOCUMENTO,
               CLASE_MOVIMIENTO,
               ES_CONSUMO,
               ES_TRANSFERENCIA,
               ID_DOCUMENTO,
               USUARIO,
               ID_ARTICULO,
               NOMBRE_ARTICULO,
               UNIDADES,
               NUMERO_SERIE,
               NUMERO_MAC,
               EMPL_INGRESA,
               EMPL_TRANSFIERE,
               EMPL_DESPACHA_CONS,
               EMPL_RESPONSABLE_CONS,
               CONT_RESPONSABLE_CONS,
               solicitanate_cons,
               EMPL_DESPACHA,
               EMPL_RESPONSABLE,
               CONT_RESPONSABLE,
               SOLICITANTE,
               OBSERVACIONES,
               ESTADO_BODEGA,
               ESTADO_INSTALACION,
               GRUPO_ACTIVO
          FROM ( 
  
   select b.fecha,
           a.time_stamp,
           a.bodega,
           (select x.descripcion
              from NAF47_TNET.arinbo x
             where x.codigo = a.bodega
               and x.no_cia = a.no_cia) nombre_bodega,
           a.tipo_doc tipo_documento,
           td.descri desc_tipo_documento,
           td.movimi clase_movimiento,
           td.consum es_consumo,
           td.trasla es_transferencia,
           a.no_docu id_documento,
           b.usuario,
           a.no_arti id_articulo,
           (select replace(replace(x.descripcion, chr(13), ' '),
                           chr(10),
                           ' ')
              from NAF47_TNET.arinda x
             where x.no_arti = a.no_arti
               and x.no_cia = a.no_cia) nombre_articulo,
           a.unidades,
           c.serie numero_serie,
           c.mac numero_mac ,
    -- usuarios ingresos --
    (select e.no_emple || ' - ' || e.nombre
       from NAF47_TNET.tasgusuario u, naf47_tnet.v_empleados_empresas e
      where u.usuario = b.usuario
        and u.no_cia = b.no_cia
        and u.id_empleado = e.no_emple
        and u.no_cia = e.no_cia) empl_ingresa,
    -- usuarios transferencias --
    (select e.no_emple || ' - ' || e.nombre
       from NAF47_TNET.arinte                          t,
            NAF47_TNET.tasgusuario                     u,
            naf47_tnet.v_empleados_empresas e
      where t.usuario = u.usuario
        and t.no_cia = u.no_cia
        and u.id_empleado = e.no_emple
        and u.no_cia = e.no_cia
        and t.no_docu = b.no_docu
        and t.no_cia = b.no_cia) empl_transfiere,
    -- usuarios consumos --
    (select e.no_emple || ' - ' || e.nombre
       from NAF47_TNET.arinencconsumointer             v,
            NAF47_TNET.tasgusuario                     u,
            naf47_tnet.v_empleados_empresas e
      where v.usuario_ingresa = u.usuario
        and v.no_cia = u.no_cia
        and u.id_empleado = e.no_emple
        and u.no_cia = e.no_cia
        and v.no_cia = b.no_cia
        and v.no_docu = b.no_docu_refe
        and v.tipo_doc = b.tipo_doc
        and v.centro = b.centro) empl_despacha_cons,
    (select v.emple_solic || ' - ' || e.nombre
       from NAF47_TNET.arinencconsumointer             v,
            naf47_tnet.v_empleados_empresas e
      where v.emple_solic = e.no_emple
        and v.no_cia = e.no_cia
        and v.no_cia = b.no_cia
        and v.no_docu = b.no_docu_refe
        and v.tipo_doc = b.tipo_doc
        and v.centro = b.centro) empl_responsable_cons,
    (select v.emple_solic || ' - ' || c.nombre
       from NAF47_TNET.arinencconsumointer v, arinmcnt c
      where v.emple_solic = c.no_contratista
        and v.no_cia = c.no_cia
        and v.no_cia = b.no_cia
        and v.no_docu = b.no_docu_refe
        and v.tipo_doc = b.tipo_doc
        and v.centro = b.centro) cont_responsable_cons,
    (select v.emple_aprueba || ' - ' || e.nombre
       from NAF47_TNET.arinencconsumointer             v,
            naf47_tnet.v_empleados_empresas e
      where v.emple_aprueba = e.no_emple
        and v.no_cia = e.no_cia
        and v.no_cia = b.no_cia
        and v.no_docu = b.no_docu_refe
        and v.tipo_doc = b.tipo_doc
        and v.centro = b.centro) solicitanate_cons,
    -- usuario despachos manuales --
    (select w.user_realiza || ' - ' || e.nombre
       from NAF47_TNET.inv_cab_solicitud_requisicion   w,
            naf47_tnet.v_empleados_empresas e
      where w.user_realiza = e.no_emple
        and w.no_cia_emp_realiza = e.no_cia
        and w.numero_solicitud = b.numero_solicitud
        and w.tipo_documento = b.tipo_doc
        and w.centro = b.centro
        and w.no_cia = b.no_cia) empl_despacha,
    
    (select w.emple_solic || ' - ' || e.nombre
       from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
      where w.emple_solic = e.no_emple
        and w.no_cia = e.no_cia
        and w.no_docu = b.no_docu
        and w.no_cia = b.no_cia) empl_responsable,
    
    (select w.usuario_aprobacion || ' - ' || c.nombre
       from NAF47_TNET.inv_cab_solicitud_requisicion w, NAF47_TNET.arinmcnt c
      where w.usuario_aprobacion = c.no_contratista
        and w.no_cia_responsable = c.no_cia
        and w.numero_solicitud = b.numero_solicitud
        and w.tipo_documento = b.tipo_doc
        and w.centro = b.centro
        and w.no_cia = b.no_cia) cont_responsable,
    
    (select w.empleado_solicitante || ' - ' || e.nombre
       from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
      where w.empleado_solicitante = e.no_emple
        and w.no_cia = e.no_cia
        and w.no_docu = b.no_docu
        and w.no_cia = b.no_cia) solicitante,
    
    replace(replace(b.observ1, chr(13), ' '), chr(10), ' ') observaciones,
    NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_X_BODEGA(A.NO_CIA,
                                                        A.NO_ARTI,
                                                        C.SERIE) estado_bodega,
    NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_INSTALACION(A.NO_CIA,
                                                           A.NO_ARTI,
                                                           C.SERIE) estado_instalacion,
    
    NAF47_TNET.INK_PROCESA_REPORTE.IN_F_GRUPO_ACTIVO(A.NO_CIA,
                                                     A.NO_ARTI) grupo_activo
      from NAF47_TNET.arinmn              a,
           NAF47_TNET.arinme              b,
           NAF47_TNET.inv_documento_serie c,
           NAF47_TNET.arinvtm             td
     where a.no_docu = b.no_docu
       and a.no_cia = b.no_cia
       and a.tipo_doc = td.tipo_m
       and a.no_cia = td.no_cia
       and a.no_linea = c.linea(+)
       and a.no_docu = c.id_documento(+)
       and a.no_cia = c.compania(+)
       and a.no_cia = Pv_IdEmpresa
       and a.centro = nvl(Pv_IdCentro,a.centro)
       and a.fecha >= Pd_FechaInicio
       and a.fecha <= Pd_FechaFin
       and a.no_arti = nvl(Pv_IdArticulo, a.no_arti)
       and a.bodega = nvl(Pv_IdBodega ,a.bodega)
       and td.movimi = nvl(Pv_ClaseMovimiento, td.movimi)
       and td.tipo_m = nvl(Pv_TipoDocumento, td.tipo_m)
       and exists
     (select null
              from NAF47_TNET.arinbo c
             where c.codigo = a.bodega
               and c.no_cia = a.no_cia
               and (Pv_EsBodegaZonal = 'N' or
                   (c.no_emple is not null and Pv_EsBodegaZonal = 'S')))
    
     )
         GROUP BY FECHA,
               TIME_STAMP,
               BODEGA,
               NOMBRE_BODEGA,
               TIPO_DOCUMENTO,
               DESC_TIPO_DOCUMENTO,
               CLASE_MOVIMIENTO,
               ES_CONSUMO,
               ES_TRANSFERENCIA,
               ID_DOCUMENTO,
               USUARIO,
               ID_ARTICULO,
               NOMBRE_ARTICULO,
               UNIDADES,
               NUMERO_SERIE,
               NUMERO_MAC,
               EMPL_INGRESA,
               EMPL_TRANSFIERE,
               EMPL_DESPACHA_CONS,
               EMPL_RESPONSABLE_CONS,
               CONT_RESPONSABLE_CONS,
               solicitanate_cons,
               EMPL_DESPACHA,
               EMPL_RESPONSABLE,
               CONT_RESPONSABLE,
               SOLICITANTE,
               OBSERVACIONES,
               ESTADO_BODEGA,
               ESTADO_INSTALACION,
               GRUPO_ACTIVO order by  fecha DESC,bodega ASC;

CURSOR C_LeeSecMovimiento IS
   SELECT MAX(NVL(ID_MOVIMIENTO_EXEL,0)) + 1
     FROM NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP
   WHERE NO_CIA=Pv_IdEmpresa;
   

Ln_SecMovimiento NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP.ID_MOVIMIENTO_EXEL%TYPE:=NULL;
Le_Error EXCEPTION;
BEGIN
 
  NAF47_TNET.INK_PROCESA_REPORTE.IN_P_BORRA_MOVIMIENTOS_TEMP(Pv_IdEmpresa,
                                                             USER,
                                                             'MU',
                                                             Pv_MensajeError);
  IF Pv_MensajeError IS NOT NULL THEN
   RAISE Le_Error;
  END IF;
                                        
  FOR A IN C_LeeData LOOP
    --
     --
    IF C_LeeSecMovimiento%ISOPEN THEN CLOSE C_LeeSecMovimiento; END IF;
    OPEN C_LeeSecMovimiento;
    FETCH C_LeeSecMovimiento INTO Ln_SecMovimiento;
    CLOSE C_LeeSecMovimiento;
    IF Ln_SecMovimiento IS NULL THEN 
      Ln_SecMovimiento := 1;
    END IF;
    --
    INSERT INTO NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP(NO_CIA,
                                                     FECHA,
                                                     TIME_STAMP,
                                                     BODEGA,
                                                     NOMBRE_BODEGA,
                                                     TIPO_DOCUMENTO,
                                                     DESC_TIPO_DOCUMENTO,
                                                     CLASE_MOVIMIENTO,
                                                     ES_CONSUMO,
                                                     ES_TRANSFERENCIA,
                                                     ID_DOCUMENTO,
                                                     USUARIO,
                                                     ID_ARTICULO,
                                                     NOMBRE_ARTICULO,
                                                     UNIDADES,
                                                     NUMERO_SERIE,
                                                     NUMERO_MAC,
                                                     EMPL_INGRESA,
                                                     EMPL_TRANSFIERE,
                                                     EMPL_DESPACHA_CONS,
                                                     EMPL_RESPONSABLE_CONS,
                                                     CONT_RESPONSABLE_CONS,
                                                     SOLICITANATE_CONS,
                                                     EMPL_DESPACHA,
                                                     EMPL_RESPONSABLE,
                                                     CONT_RESPONSABLE,
                                                     SOLICITANTE,
                                                     OBSERVACIONES,
                                                     ESTADO_BODEGA,
                                                     ESTADO_INSTALACION,
                                                     GRUPO_ACTIVO,
                                                     USUARIO_CREA,
                                                     TIPO_REPORTE,
                                                     ID_MOVIMIENTO_EXEL )
                                                  VALUES
                                                    (Pv_IdEmpresa,
                                                     A.FECHA,
                                                     A.TIME_STAMP,
                                                     A.BODEGA,
                                                     A.NOMBRE_BODEGA,
                                                     A.TIPO_DOCUMENTO,
                                                     A.DESC_TIPO_DOCUMENTO,
                                                     A.CLASE_MOVIMIENTO,
                                                     A.ES_CONSUMO,
                                                     A.ES_TRANSFERENCIA,
                                                     A.ID_DOCUMENTO,
                                                     A.USUARIO,
                                                     A.ID_ARTICULO,
                                                     A.NOMBRE_ARTICULO,
                                                     A.UNIDADES,
                                                     A.NUMERO_SERIE,
                                                     A.NUMERO_MAC,
                                                     A.EMPL_INGRESA,
                                                     A.EMPL_TRANSFIERE,
                                                     A.EMPL_DESPACHA_CONS,
                                                     A.EMPL_RESPONSABLE_CONS,
                                                     A.CONT_RESPONSABLE_CONS,
                                                     A.SOLICITANATE_CONS,
                                                     A.EMPL_DESPACHA,
                                                     A.EMPL_RESPONSABLE,
                                                     A.CONT_RESPONSABLE,
                                                     A.SOLICITANTE,
                                                     A.OBSERVACIONES,
                                                     A.ESTADO_BODEGA,
                                                     A.ESTADO_INSTALACION,
                                                     A.GRUPO_ACTIVO,
                                                     USER,
                                                     'MU',
                                                     Ln_SecMovimiento);
  END LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
     Pv_MensajeError :='Error No Controlado en INK_PROCESA_REPORTE.IN_P_PROCESA_ULTIMO_MOV '||SQLCODE||' - '||SQLERRM;
END IN_P_PROCESA_ULTIMO_MOV; 


  PROCEDURE IN_P_MOVIMIENTOS_NACIONAL(Pv_IdEmpresa        IN VARCHAR2,
                                    Pv_IdCentro     IN VARCHAR2,
                                    Pv_FechaInicio  IN DATE,
                                    Pv_FechaFin     IN DATE,
                                    Pv_NoBodega     IN VARCHAR2,
                                    Pv_ClaseMov     IN VARCHAR2,
                                    Pv_TipoDoc      IN VARCHAR2,
                                    Pv_SoloBodZonal IN VARCHAR2,
                                    Pv_IdArticulo   IN VARCHAR2,
                                    Pv_MensajeError OUT VARCHAR2) IS  
 /* Costo = 179*/
 CURSOR C_LeeMovimientos IS
  select b.fecha,
         a.time_stamp,
         a.bodega,
         (select x.descripcion
            from NAF47_TNET.arinbo x
           where x.codigo = a.bodega
             and x.no_cia = a.no_cia) nombre_bodega,
         a.tipo_doc tipo_documento,
         td.descri desc_tipo_documento,
         td.movimi clase_movimiento,
         td.consum es_consumo,
         td.trasla es_transferencia,
         a.no_docu id_documento,
         b.usuario,
         a.no_arti id_articulo,
         (select replace(replace(x.descripcion, chr(13), ' '), chr(10), ' ')
            from NAF47_TNET.arinda x
           where x.no_arti = a.no_arti
             and x.no_cia = a.no_cia) nombre_articulo,
         a.unidades,
         c.serie numero_serie,
         c.mac numero_mac,
         a.centro,
         -- usuarios ingresos --
         (select e.no_emple || ' - ' || e.nombre
            from NAF47_TNET.tasgusuario u, naf47_tnet.v_empleados_empresas e
           where u.usuario = b.usuario
             and u.no_cia = b.no_cia
             and u.id_empleado = e.no_emple
             and u.no_cia = e.no_cia) empl_ingresa,
         -- usuarios transferencias --
         (select e.no_emple || ' - ' || e.nombre
            from NAF47_TNET.arinte               t,
                 NAF47_TNET.tasgusuario          u,
                 naf47_tnet.v_empleados_empresas e
           where t.usuario = u.usuario
             and t.no_cia = u.no_cia
             and u.id_empleado = e.no_emple
             and u.no_cia = e.no_cia
             and t.no_docu = b.no_docu
             and t.no_cia = b.no_cia) empl_transfiere,
         -- usuarios consumos --
         (select e.no_emple || ' - ' || e.nombre
            from NAF47_TNET.arinencconsumointer  v,
                 NAF47_TNET.tasgusuario          u,
                 naf47_tnet.v_empleados_empresas e
           where v.usuario_ingresa = u.usuario
             and v.no_cia = u.no_cia
             and u.id_empleado = e.no_emple
             and u.no_cia = e.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) empl_despacha_cons,
         (select v.emple_solic || ' - ' || e.nombre
            from NAF47_TNET.arinencconsumointer  v,
                 naf47_tnet.v_empleados_empresas e
           where v.emple_solic = e.no_emple
             and v.no_cia = e.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) empl_responsable_cons,
         --
          (select v.emple_solic
            from NAF47_TNET.arinencconsumointer  v,
                 naf47_tnet.v_empleados_empresas e
           where v.emple_solic = e.no_emple
             and v.no_cia = e.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) NO_empl_responsable_cons, -------
         -- 
         (select v.emple_solic || ' - ' || c.nombre
            from NAF47_TNET.arinencconsumointer v, arinmcnt c
           where v.emple_solic = c.no_contratista
             and v.no_cia = c.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) cont_responsable_cons,
         
         (select v.emple_solic
            from NAF47_TNET.arinencconsumointer v, arinmcnt c
           where v.emple_solic = c.no_contratista
             and v.no_cia = c.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) NO_EMPL_CONT_RESPONSABLE_CONS,--
                 
         (select v.emple_aprueba || ' - ' || e.nombre
            from NAF47_TNET.arinencconsumointer  v,
                 naf47_tnet.v_empleados_empresas e
           where v.emple_aprueba = e.no_emple
             and v.no_cia = e.no_cia
             and v.no_cia = b.no_cia
             and v.no_docu = b.no_docu_refe
             and v.tipo_doc = b.tipo_doc
             and v.centro = b.centro) solicitanate_cons,
         -- usuario despachos manuales --
         (select w.user_realiza || ' - ' || e.nombre
            from NAF47_TNET.inv_cab_solicitud_requisicion w,
                 naf47_tnet.v_empleados_empresas          e
           where w.user_realiza = e.no_emple
             and w.no_cia_emp_realiza = e.no_cia
             and w.numero_solicitud = b.numero_solicitud
             and w.tipo_documento = b.tipo_doc
             and w.centro = b.centro
             and w.no_cia = b.no_cia) empl_despacha,
         --
         (select w.user_realiza
            from NAF47_TNET.inv_cab_solicitud_requisicion w,
                 naf47_tnet.v_empleados_empresas          e
           where w.user_realiza = e.no_emple
             and w.no_cia_emp_realiza = e.no_cia
             and w.numero_solicitud = b.numero_solicitud
             and w.tipo_documento = b.tipo_doc
             and w.centro = b.centro
             and w.no_cia = b.no_cia) NO_EMPL_DESPACHA,---
         --
         (select w.emple_solic || ' - ' || e.nombre
            from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
           where w.emple_solic = e.no_emple
             and w.no_cia = e.no_cia
             and w.no_docu = b.no_docu
             and w.no_cia = b.no_cia) empl_responsable,
         --
         (select w.emple_solic
            from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
           where w.emple_solic = e.no_emple
             and w.no_cia = e.no_cia
             and w.no_docu = b.no_docu
             and w.no_cia = b.no_cia) NO_EMPL_RESPONSABLE,
         --
         (select w.usuario_aprobacion || ' - ' || c.nombre
            from NAF47_TNET.inv_cab_solicitud_requisicion w,
                 NAF47_TNET.arinmcnt                      c
           where w.usuario_aprobacion = c.no_contratista
             and w.no_cia_responsable = c.no_cia
             and w.numero_solicitud = b.numero_solicitud
             and w.tipo_documento = b.tipo_doc
             and w.centro = b.centro
             and w.no_cia = b.no_cia) cont_responsable,
             
             
         (select w.usuario_aprobacion
            from NAF47_TNET.inv_cab_solicitud_requisicion w,
                 NAF47_TNET.arinmcnt                      c
           where w.usuario_aprobacion = c.no_contratista
             and w.no_cia_responsable = c.no_cia
             and w.numero_solicitud = b.numero_solicitud
             and w.tipo_documento = b.tipo_doc
             and w.centro = b.centro
             and w.no_cia = b.no_cia) NO_EMPL_cont_responsable,---
             
         (select w.empleado_solicitante || ' - ' || e.nombre
            from NAF47_TNET.arinme w, naf47_tnet.v_empleados_empresas e
           where w.empleado_solicitante = e.no_emple
             and w.no_cia = e.no_cia
             and w.no_docu = b.no_docu
             and w.no_cia = b.no_cia) solicitante,
         
         replace(replace(b.observ1, chr(13), ' '), chr(10), ' ') observaciones,
         NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_X_BODEGA(A.NO_CIA,
                                                             A.NO_ARTI,
                                                             C.SERIE) estado_bodega,
         NAF47_TNET.INK_PROCESA_REPORTE.IN_F_ESTADO_INSTALACION(A.NO_CIA,
                                                                A.NO_ARTI,
                                                                C.SERIE) estado_instalacion,
         
         NAF47_TNET.INK_PROCESA_REPORTE.IN_F_GRUPO_ACTIVO(A.NO_CIA,
                                                          A.NO_ARTI) grupo_activo
    from NAF47_TNET.arinmn              a,
         NAF47_TNET.arinme              b,
         NAF47_TNET.inv_documento_serie c,
         NAF47_TNET.arinvtm             td
   where a.no_docu = b.no_docu
     and a.no_cia = b.no_cia
     and a.tipo_doc = td.tipo_m
     and a.no_cia = td.no_cia
     and a.no_linea = c.linea(+)
     and a.no_docu = c.id_documento(+)
     and a.no_cia = c.compania(+)
     and a.no_cia = Pv_IdEmpresa
     and a.centro = NVL(Pv_IdCentro, a.centro)
     and a.fecha >= Pv_FechaInicio
     and a.fecha <= Pv_FechaFin
     and a.no_arti = nvl(Pv_IdArticulo, a.no_arti)
     and a.bodega = nvl(Pv_NoBodega, a.bodega)
     and td.movimi = nvl(Pv_ClaseMov, td.movimi)
     and td.tipo_m = nvl(Pv_TipoDoc, td.tipo_m)
     and exists
   (select null
            from NAF47_TNET.arinbo c
           where c.codigo = a.bodega
             and c.no_cia = a.no_cia
             and (Pv_SoloBodZonal = 'N' or
                 (c.no_emple is not null and Pv_SoloBodZonal = 'S')))
   order by a.bodega, a.fecha, a.time_stamp;
 CURSOR C_LeeDatoEmpleado(Cv_IdEmpleado IN VARCHAR2) IS
  SELECT NOMBRE_DEPTO,
         OFICINA_CANTON,
         OFICINA_PROVINCIA, 
         ESTADO,
         NOMBRE_PROVINCIA,
         NOMBRE_CANTON,
         NOMBRE
    FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS 
   WHERE NO_CIA =Pv_IdEmpresa
     AND NO_EMPLE=Cv_IdEmpleado;
 --
 --

 CURSOR C_LeeSecMovimiento IS
   SELECT MAX(NVL(ID_MOVIMIENTO_EXEL,0)) + 1
     FROM NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP
   WHERE NO_CIA=Pv_IdEmpresa;
   
  Lr_DatosEmpleados             C_LeeDatoEmpleado%ROWTYPE:=NULL;  
  Lv_NombreDepartamentoRes      VARCHAR2(100); 
  Lv_NombreDepartamentoDes      VARCHAR2(200); --Tecnica Sucrusal
  Ln_SecMovimiento              NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP.ID_MOVIMIENTO_EXEL%TYPE:=NULL;
  Lv_Solicitante                VARCHAR2(1000):=NULL;
  Lv_Responsable                VARCHAR2(10):=NULL;
  Lv_ResponsableAlt             VARCHAR2(1000):=NULL;
  Lv_NombreResponsable          VARCHAR2(85):=NULL;
  Lv_EstadoEmplResponsable      VARCHAR2(10):=NULL;
  Le_Error EXCEPTION;
 
 BEGIN
   
 NAF47_TNET.INK_PROCESA_REPORTE.IN_P_BORRA_MOVIMIENTOS_TEMP(Pv_IdEmpresa,
                                                            USER,
                                                            'MN',
                                                            Pv_MensajeError);
  IF Pv_MensajeError IS NOT NULL THEN
    RAISE Le_Error;
  END IF;
  
          
 FOR A IN C_LeeMovimientos LOOP
    --
    IF C_LeeSecMovimiento%ISOPEN THEN CLOSE C_LeeSecMovimiento; END IF;
    OPEN C_LeeSecMovimiento;
    FETCH C_LeeSecMovimiento INTO Ln_SecMovimiento;
    CLOSE C_LeeSecMovimiento;
    IF Ln_SecMovimiento IS NULL THEN 
      Ln_SecMovimiento := 1;
    END IF;
    --
    Lr_DatosEmpleados :=NULL;
    IF C_LeeDatoEmpleado%ISOPEN THEN CLOSE C_LeeDatoEmpleado; END IF;
    OPEN C_LeeDatoEmpleado(A.NO_EMPL_DESPACHA);
    FETCH C_LeeDatoEmpleado INTO Lr_DatosEmpleados;-- 
    CLOSE C_LeeDatoEmpleado;
    --
    --
    Lv_NombreDepartamentoDes :=Lr_DatosEmpleados.NOMBRE_DEPTO||'-'||Lr_DatosEmpleados.NOMBRE_PROVINCIA||'-'||Lr_DatosEmpleados.NOMBRE_CANTON;
    --   
    --
    IF (Lr_DatosEmpleados.NOMBRE_DEPTO IS NULL AND Lr_DatosEmpleados.NOMBRE_PROVINCIA IS NULL AND Lr_DatosEmpleados.NOMBRE_CANTON IS NULL ) THEN
      Lv_NombreDepartamentoDes:=NULL;
    END IF;
    --
    --
    --
    IF A.clase_movimiento = 'E' THEN
      Lv_Responsable := null; 
      Lv_Solicitante := null;
      Lv_ResponsableAlt := NULL;
    -- Usuarios para Transferencias
    ELSIF A.es_transferencia = 'S' THEN
      Lv_Responsable := null; 
      Lv_Solicitante := null;
      Lv_ResponsableAlt := NULL;
    --Usuarios para Consumo
    ELSIF A.es_consumo = 'S' then
      Lv_Solicitante := A.SOLICITANATE_CONS;
      -- responsable puede ser empleado o contratista
      IF A.NO_empl_responsable_cons IS NOT NULL THEN
        Lv_Responsable    := A.NO_EMPL_RESPONSABLE_CONS; 
        Lv_ResponsableAlt := A.EMPL_RESPONSABLE_CONS;
      ELSE
        Lv_Responsable    := A.NO_EMPL_CONT_RESPONSABLE_CONS; 
        Lv_ResponsableAlt := A.CONT_RESPONSABLE_CONS;
      END IF;
    -- usuario para despachos varios
    ELSE
      Lv_Solicitante := A.SOLICITANTE;
      -- Responsable puede ser Empleado o Contratista
      IF A.NO_empl_responsable IS NOT NULL THEN
        Lv_Responsable    := A.NO_EMPL_RESPONSABLE; 
        Lv_ResponsableAlt := A.EMPL_RESPONSABLE; 
      ELSE
        Lv_Responsable    := A.NO_EMPL_CONT_RESPONSABLE; 
        Lv_ResponsableAlt := A.CONT_RESPONSABLE;
      END IF;
    END IF;
    
    -- no esta asignado entonces es registro anterior a la imprementacion de solicitantes --
    IF Lv_Solicitante IS NULL THEN
      Lv_Solicitante :=  Lv_ResponsableAlt;
    END IF;
    --
    --
    --
    Lr_DatosEmpleados :=NULL;
    IF C_LeeDatoEmpleado%ISOPEN THEN CLOSE C_LeeDatoEmpleado; END IF;
    OPEN C_LeeDatoEmpleado(Lv_Responsable);
    FETCH C_LeeDatoEmpleado INTO Lr_DatosEmpleados;
    CLOSE C_LeeDatoEmpleado;
    
    Lv_NombreDepartamentoRes := SUBSTR(Lr_DatosEmpleados.NOMBRE_DEPTO,1,60);
    Lv_NombreResponsable     := substr(Lv_Responsable||' - '||Lr_DatosEmpleados.NOMBRE,1,85);
    IF (Lv_Responsable IS NULL AND Lr_DatosEmpleados.NOMBRE IS NULL) THEN
      Lv_NombreResponsable :=NULL;
    END IF;
    --
        Lv_EstadoEmplResponsable :=NULL;
    IF NVL(Lr_DatosEmpleados.ESTADO,'X')='A' THEN
      Lv_EstadoEmplResponsable :='Activo';
    ELSE
      Lv_EstadoEmplResponsable :='Inactivo';
    END IF;

    
    INSERT INTO NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP
                                                    (NO_CIA,
                                                     FECHA,
                                                     TIME_STAMP,
                                                     BODEGA,
                                                     NOMBRE_BODEGA,
                                                     TIPO_DOCUMENTO,
                                                     DESC_TIPO_DOCUMENTO,
                                                     CLASE_MOVIMIENTO,
                                                     ES_CONSUMO,
                                                     ES_TRANSFERENCIA,
                                                     ID_DOCUMENTO,
                                                     USUARIO,
                                                     ID_ARTICULO,
                                                     NOMBRE_ARTICULO,
                                                     UNIDADES,
                                                     NUMERO_SERIE,
                                                     NUMERO_MAC,
                                                     EMPL_INGRESA,
                                                     EMPL_TRANSFIERE,
                                                     EMPL_DESPACHA_CONS,
                                                     EMPL_RESPONSABLE_CONS,
                                                     CONT_RESPONSABLE_CONS,
                                                     SOLICITANATE_CONS,
                                                     EMPL_DESPACHA,
                                                     EMPL_RESPONSABLE,
                                                     CONT_RESPONSABLE,
                                                     SOLICITANTE,
                                                     OBSERVACIONES,
                                                     ESTADO_BODEGA,
                                                     ESTADO_INSTALACION,
                                                     GRUPO_ACTIVO,
                                                     USUARIO_CREA,
                                                     TIPO_REPORTE,
                                                     DEPARTAMENTO_DESPACHO,
                                                     DEPARTAMENTO_RESPONSABLE,
                                                     ID_MOVIMIENTO_EXEL,
                                                     ESTADO_EMPLEADO_RESPONSABLE  )
                                                  VALUES
                                                    (Pv_IdEmpresa,
                                                     A.FECHA,
                                                     A.TIME_STAMP,
                                                     A.BODEGA,
                                                     A.NOMBRE_BODEGA,
                                                     A.TIPO_DOCUMENTO,
                                                     A.DESC_TIPO_DOCUMENTO,
                                                     A.CLASE_MOVIMIENTO,
                                                     A.ES_CONSUMO,
                                                     A.ES_TRANSFERENCIA,
                                                     A.ID_DOCUMENTO,
                                                     A.USUARIO,
                                                     A.ID_ARTICULO,
                                                     A.NOMBRE_ARTICULO,
                                                     A.UNIDADES,
                                                     A.NUMERO_SERIE,
                                                     A.NUMERO_MAC,
                                                     A.EMPL_INGRESA,
                                                     A.EMPL_TRANSFIERE,
                                                     A.EMPL_DESPACHA_CONS,
                                                     A.EMPL_RESPONSABLE_CONS,
                                                     A.CONT_RESPONSABLE_CONS,
                                                     A.SOLICITANATE_CONS,
                                                     A.EMPL_DESPACHA,
                                                     Lv_NombreResponsable,
                                                     A.CONT_RESPONSABLE,
                                                     Lv_Solicitante,
                                                     A.OBSERVACIONES,
                                                     A.ESTADO_BODEGA,
                                                     A.ESTADO_INSTALACION,
                                                     A.GRUPO_ACTIVO,
                                                     USER,
                                                     'MN',
                                                     Lv_NombreDepartamentoDes,
                                                     Lv_NombreDepartamentoRes,
                                                     Ln_SecMovimiento,
                                                     Lv_EstadoEmplResponsable);
 END LOOP;        
  COMMIT;      
         
 
 EXCEPTION 
   WHEN Le_Error THEN
     RETURN;
   WHEN OTHERS THEN
     Pv_MensajeError :='Error No Controlado en '||SQLCODE||' - '||SQLERRM;        
     RETURN;
 END IN_P_MOVIMIENTOS_NACIONAL;                                      
                         
  PROCEDURE IN_P_BORRA_MOVIMIENTOS_TEMP(Pv_IdEmpresa     IN VARCHAR2,
                                      Pv_Usuario       IN VARCHAR2 ,
                                      Pv_TipoReporte   IN VARCHAR2,
                                      Pv_MensajeError OUT VARCHAR2 ) IS
  Le_Error EXCEPTION;
  BEGIN
   
   DELETE  
     FROM NAF47_TNET.ARIN_MOVIMIENTOS_EXEL_TEMP
    WHERE NO_CIA=Pv_IdEmpresa
      AND USUARIO_CREA=Pv_Usuario
      AND TIPO_REPORTE=Pv_TipoReporte;
  commit;
  EXCEPTION
  WHEN Le_Error THEN
     RETURN;
  WHEN OTHERS THEN
     Pv_MensajeError :='Error No Controlado en INK_PROCESA_REPORTE.IN_P_BORRA_MOVIMIENTOS_TEMP '||SQLCODE||' - '||SQLERRM;
     RETURN;
  END IN_P_BORRA_MOVIMIENTOS_TEMP;
end INK_PROCESA_REPORTE;
/
