CREATE OR REPLACE PACKAGE DB_COMERCIAL.GeneraInformacionExcel AS

/*
MODULO: Planificación - Reporte General
DESCRIPCION: Procedimiento encargado de procesar la información a exportar en excel 
CREADO POR: Jesús Bozada
*/
  PROCEDURE generarInfoExcelReporteGeneral(estado               IN VARCHAR2,
                                           tipoSolicitud        IN VARCHAR2,
                                           fechaDesdeSolPlanif  IN VARCHAR2,
                                           fechaHastaSolPlanif  IN VARCHAR2,
                                           fechaDesdePlanif     IN VARCHAR2,
                                           fechaHastaPlanif     IN VARCHAR2,
                                           login2               IN VARCHAR2,
                                           descripcionPunto     IN VARCHAR2,
                                           vendedor             IN VARCHAR2,
                                           ciudad               IN VARCHAR2,
                                           numOrdenServicio     IN VARCHAR2,
                                           identificadorArchivo OUT VARCHAR2,
                                           mensajeError         OUT VARCHAR2);
      
/*
MODULO: Planificación - Reporte Asigandas
DESCRIPCION: Procedimiento encargado de procesar la información a exportar en excel 
CREADO POR: Richard Cabrera
*/
  PROCEDURE generarInfoExcelReporteAsigna(estado               IN VARCHAR2, 
                                          fechaDesdeSolPlanif  IN VARCHAR2,
                                          fechaHastaSolPlanif  IN VARCHAR2,
                                          fechaDesdePlanif     IN VARCHAR2,
                                          fechaHastaPlanif     IN VARCHAR2,
                                          login2               IN VARCHAR2,
                                          descripcionPunto     IN VARCHAR2,
                                          vendedor             IN VARCHAR2,
                                          ciudad               IN VARCHAR2,
                                          numOrdenServicio     IN VARCHAR2,
                                          tipoResponsable      IN VARCHAR2,
                                          codigoResponsable    IN VARCHAR2, 
                                          prefijoEmpresa       IN VARCHAR2,
                                          codigoEmpresa        IN VARCHAR2,
                                          identificadorArchivo OUT VARCHAR2,
                                          mensajeError         OUT VARCHAR2);            

      
      
      
END GeneraInformacionExcel;
/


CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.GeneraInformacionExcel AS


PROCEDURE generarInfoExcelReporteGeneral(estado               IN VARCHAR2,
                                         tipoSolicitud        IN VARCHAR2,
                                         fechaDesdeSolPlanif  IN VARCHAR2,
                                         fechaHastaSolPlanif  IN VARCHAR2,
                                         fechaDesdePlanif     IN VARCHAR2,
                                         fechaHastaPlanif     IN VARCHAR2,
                                         login2               IN VARCHAR2,
                                         descripcionPunto     IN VARCHAR2,
                                         vendedor             IN VARCHAR2,
                                         ciudad               IN VARCHAR2,
                                         numOrdenServicio     IN VARCHAR2,
                                         identificadorArchivo OUT VARCHAR2,
                                         mensajeError OUT VARCHAR2 ) IS

--Cursor para generar tipo de datos a recorrer luego de recuperar información del query dinamico
  CURSOR queryTipoDeCampos
  IS
    SELECT ds.ID_DETALLE_SOLICITUD                       AS idDetalleSolicitud,
      s.id_servicio                                      AS idServicio,
      p.id_punto                                         AS idPunto,
      ot.id_orden_trabajo                                AS idOrdenTrabajo,
      ot.numero_Orden_Trabajo                            AS numero_Orden_Trabajo ,
      se.nombre_Sector                                   AS nombre_Sector ,
      pa.nombre_Parroquia                                AS nombre_Parroquia,
      ca.nombre_Canton                                   AS nombre_Canton,
      pe.razon_Social                                    AS razon_Social,      
      pe.nombres                                         AS nombres,
      pe.apellidos                                       AS apellidos,
      p.usr_Vendedor                                     AS usr_Vendedor,
      p.login                                            AS login,
      p.longitud                                         AS longitud,
      p.latitud                                          AS latitud,
      p.direccion                                        AS direccion,
      p.RUTA_CROQUIS                                     AS ruta_Croquis,
      ds.fe_Creacion                                     AS fe_Creacion,
      ds.estado                                          AS estado,
      dsh.ID_SOLICITUD_HISTORIAL                         AS id_Detalle_Sol_Hist,
      dsh.fe_Ini_Plan                                    AS fe_Ini_Plan,
      dsh.fe_Fin_Plan                                    AS fe_Fin_Plan,
      dsh.usr_Creacion                                   AS usrPlanifica,
      dsh.motivo_Id                                      AS motivo_Id,
      CONCAT(peVend.nombres,CONCAT('',peVend.apellidos)) AS nombre_Vendedor ,
      admiTip.ID_TIPO_SOLICITUD                          AS tipoSolicitudId,
      (SELECT pro.descripcion_Producto
      FROM Admi_Producto pro
      WHERE pro.ID_PRODUCTO=s.producto_Id
      ) AS desPro,
    (SELECT plan.nombre_Plan
    FROM Info_Plan_Cab plan
    WHERE plan.ID_PLAN=s.plan_Id
    )                             AS desPlan,
    s.tipo_orden                  AS tipo_orden,
    admiTip.descripcion_solicitud AS descripcion_solicitud
  FROM Info_Detalle_Sol_Hist dsh,
    Info_Orden_Trabajo ot,
    Info_Servicio s,
    Info_Detalle_Solicitud ds,
    Info_Persona pe,
    Info_Persona_Empresa_Rol per,
    Admi_Sector se,
    Admi_Parroquia pa,
    Admi_Tipo_Solicitud admiTip ,
    Admi_Canton ca,
    Info_Punto p
  LEFT JOIN Info_Persona peVend
  ON peVend.login                = p.usr_Vendedor
  WHERE ot.ID_ORDEN_TRABAJO      = s.orden_Trabajo_Id
  AND ot.punto_Id                = p.id_punto
  AND s.id_servicio              = ds.servicio_Id
  AND ds.ID_DETALLE_SOLICITUD    = dsh.detalle_Solicitud_Id
  AND p.persona_Empresa_Rol_Id   = per.ID_PERSONA_ROL
  AND per.persona_Id             = pe.id_persona
  AND p.sector_Id                = se.id_sector
  AND se.parroquia_Id            = pa.id_parroquia
  AND pa.canton_Id               = ca.id_canton
  AND ds.tipo_Solicitud_Id       =admiTip.ID_TIPO_SOLICITUD
  AND dsh.ID_SOLICITUD_HISTORIAL =
    (SELECT MAX(dshMax.ID_SOLICITUD_HISTORIAL)
    FROM Info_Detalle_Sol_Hist dshMax
    WHERE dshMax.detalle_Solicitud_Id = dsh.detalle_Solicitud_Id
    );
    
    --variables utilizadas en el procedimiento
    strwhere                VARCHAR2(5000) := '';
    strsql                  VARCHAR2(9000) := '';
    TYPE estadosTodosArray IS VARRAY(5) OF VARCHAR2(20);
    estados estadosTodosArray;
    type tmp_tbm IS  REF  CURSOR;
    emp_record queryTipoDeCampos%ROWTYPE;
    emp_tbl tmp_tbm;
    nombreProductoPlan      VARCHAR2(4000) := '';
    cliente                 VARCHAR2(4000) := '';
    coordenadas             VARCHAR2(4000) := '';
    feSolicitaPlanificacion VARCHAR2(4000) := '';
    fechaPlanificacionReal  VARCHAR2(4000) := '';
    fePlanificada           VARCHAR2(4000) := '';
    HoraIniPlanificada      VARCHAR2(4000) := '';
    HoraFinPlanificada      VARCHAR2(4000) := '';
    nombrePlanifica         VARCHAR2(4000) := '';
    nombreMotivo            VARCHAR2(4000) := '';
    contactos               VARCHAR2(4000) := '';
    tipoOrden               VARCHAR2(4000) := '';
    numero_archivo          NUMBER         :=0;
    contador_archivo        NUMBER         := 0;
    numero_registros_commit NUMBER         :=0;
    
  BEGIN
  
    IF (estado = 'Todos') THEN
      estados := estadosTodosArray('TODOS-Planifica', 'Planificada');
    ELSE
      estados := estadosTodosArray(estado);
    END IF;
    
    --Se recorren registros dependiendo del estado recibido como parametro
    FOR i IN 1 .. estados.count
    LOOP
      strwhere := '';
      strsql   := '';
      strsql   :=
      'SELECT   ds.ID_DETALLE_SOLICITUD                  AS idDetalleSolicitud,                    
      s.id_servicio                                      AS idServicio,                    
      p.id_punto                                         AS idPunto,                    
      ot.id_orden_trabajo                                AS idOrdenTrabajo,                    
      ot.numero_Orden_Trabajo                            AS numero_Orden_Trabajo ,                    
      se.nombre_Sector                                   AS nombre_Sector ,                    
      pa.nombre_Parroquia                                AS nombre_Parroquia,                    
      ca.nombre_Canton                                   AS nombre_Canton,                    
      pe.razon_Social                                    AS razon_Social,                    
      pe.nombres                                         AS nombres,                    
      pe.apellidos                                       AS apellidos,                    
      p.usr_Vendedor                                     AS usr_Vendedor,                    
      p.login                                            AS login,                    
      p.longitud                                         AS longitud,                    
      p.latitud                                          AS latitud,                    
      p.direccion                                        AS direccion,                    
      p.RUTA_CROQUIS                                     AS ruta_Croquis,                    
      ds.fe_Creacion                                     AS fe_Creacion,                    
      ds.estado                                          AS estado,                    
      dsh.ID_SOLICITUD_HISTORIAL                         AS id_Detalle_Sol_Hist,                    
      dsh.fe_Ini_Plan                                    AS fe_Ini_Plan,                    
      dsh.fe_Fin_Plan                                    AS fe_Fin_Plan,                    
      dsh.usr_Creacion                                   AS usrPlanifica,                    
      dsh.motivo_Id                                      AS motivo_Id,                    
      CONCAT(peVend.nombres,CONCAT('''',peVend.apellidos)) AS nombre_Vendedor ,                    
      admiTip.ID_TIPO_SOLICITUD                          AS tipoSolicitudId,  
      
      (SELECT pro.descripcion_Producto                    
      FROM Admi_Producto pro                    
      WHERE pro.ID_PRODUCTO=s.producto_Id                    
      ) AS desPro,   
      
      (SELECT plan.nombre_Plan                  
      FROM Info_Plan_Cab plan                  
      WHERE plan.ID_PLAN=s.plan_Id          
      ) AS desPlan ,  
      
      s.tipo_orden as tipo_orden,
      
      admiTip.descripcion_solicitud as descripcion_solicitud  
      
      FROM Info_Detalle_Sol_Hist dsh,                   
      Info_Orden_Trabajo ot, Info_Servicio s,                 
      Info_Detalle_Solicitud ds,                  
      Info_Persona pe, Info_Persona_Empresa_Rol per,                 
      Admi_Sector se, Admi_Parroquia pa,                 
      Admi_Tipo_Solicitud admiTip ,                 
      Admi_Canton ca,                                                    
      Info_Punto p                                                                                          
      
      
      LEFT JOIN Info_Persona peVend on peVend.login = p.usr_Vendedor                                             
      
      WHERE                  
      ot.ID_ORDEN_TRABAJO = s.orden_Trabajo_Id                  
      AND ot.punto_Id = p.id_punto                 
      AND s.id_servicio = ds.servicio_Id                  
      AND ds.ID_DETALLE_SOLICITUD = dsh.detalle_Solicitud_Id                   
      AND p.persona_Empresa_Rol_Id = per.ID_PERSONA_ROL                  
      AND per.persona_Id = pe.id_persona                  
      AND p.sector_Id = se.id_sector                  
      AND se.parroquia_Id = pa.id_parroquia                  
      AND pa.canton_Id = ca.id_canton                  
      AND ds.tipo_Solicitud_Id=admiTip.ID_TIPO_SOLICITUD                       
      AND dsh.ID_SOLICITUD_HISTORIAL = (SELECT MAX(dshMax.ID_SOLICITUD_HISTORIAL)                       
      FROM Info_Detalle_Sol_Hist dshMax                      
      WHERE dshMax.detalle_Solicitud_Id = dsh.detalle_Solicitud_Id)  '  ;
      
      --se comienza a generar el query dinamicamente dependiendo de los parametros ingresados
      
      IF LENGTH(fechaDesdeSolPlanif)>0 THEN
        strwhere                   := strwhere || 'AND ds.fe_Creacion >= to_date('''||fechaDesdeSolPlanif||''',''dd/mm/yyyy'') ';
      END IF;
      IF LENGTH(fechaHastaSolPlanif)>0 THEN
        strwhere                   := strwhere || 'AND ds.fe_Creacion <= to_date('''||fechaHastaSolPlanif||''',''dd/mm/yyyy'')';
      END IF;
      IF LENGTH(login2)>0 THEN
        strwhere      := strwhere || 'AND UPPER(p.login) like ''%'||upper(trim(login2))||'%'' ';
      END IF;
      IF LENGTH(descripcionPunto)>0 THEN
        strwhere                := strwhere || 'AND UPPER(p.descripcion_Punto) like ''%'||upper(trim(descripcionPunto))||'%'' ';
      END IF;
      IF LENGTH(numOrdenServicio)>0 THEN
        strwhere                := strwhere || 'AND ot.numero_Orden_Trabajo like '''||numOrdenServicio||'%'' ';
      END IF;
      IF LENGTH(ciudad)>0 THEN
        strwhere      := strwhere || 'AND UPPER(ca.nombre_Canton) like ''%'||upper(trim(ciudad))||'%'' ';
      END IF;
      IF LENGTH(vendedor)>0 THEN
        strwhere        := strwhere || 'AND CONCAT(LOWER(peVend.nombres),CONCAT('' '',LOWER(peVend.apellidos)))  like ''%'||lower(trim(vendedor))||'%''';
      END IF;
      IF LENGTH(tipoSolicitud)>0 THEN
        IF (tipoSolicitud     = 'SOLICITUD CAMBIO EQUIPO' OR tipoSolicitud = 'SOLICITUD RETIRO EQUIPO' OR tipoSolicitud = 'SOLICITUD PLANIFICACION') THEN
          strwhere           := strwhere || 'AND LOWER(admiTip.descripcion_Solicitud) = '''||LOWER(tipoSolicitud)||''' ';
        ELSE
          strwhere := strwhere || 'AND ( LOWER(admiTip.descripcion_Solicitud) = LOWER(''SOLICITUD CAMBIO EQUIPO'')  or LOWER(admiTip.descripcion_Solicitud) = LOWER(''SOLICITUD RETIRO EQUIPO'') or LOWER(admiTip.descripcion_Solicitud) = LOWER(''SOLICITUD PLANIFICACION'')) ';
        END IF;
      END IF;
      IF LENGTH(estados(i))          >0 THEN
        IF estado                    = 'PrePlanificada' THEN
          strwhere                  := strwhere || 'AND (LOWER(ds.estado) = LOWER(''PrePlanificada'')) ';
          strwhere                  := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''PrePlanificada'')) ';
        ELSIF estados(i)             = 'Planificada' THEN
          strwhere                  := strwhere || 'AND (LOWER(ds.estado) = LOWER(''Planificada'') OR LOWER(ds.estado) = LOWER(''Replanificada'')) ';
          strwhere                  := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''Planificada'') OR LOWER(dsh.estado) = LOWER(''Replanificada''))  ';
          IF LENGTH(fechaDesdePlanif)>0 THEN
            strwhere                := strwhere || 'AND dsh.fe_Ini_Plan >= to_date('''||fechaDesdePlanif||''',''dd/mm/yyyy'') ';
            
          END IF;
          IF LENGTH(fechaHastaPlanif)>0 THEN
            strwhere                := strwhere || 'AND dsh.fe_Ini_Plan <= to_date('''||fechaHastaPlanif||''',''dd/mm/yyyy'') ';
            
          END IF;
        ELSIF estados(i) = 'Detenido' THEN
          strwhere      := strwhere || 'AND (LOWER(ds.estado) = LOWER(''Detenido'')) ';
          strwhere      := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''Detenido''))  ';
        ELSIF estados(i) = 'Anulado' THEN
          strwhere      := strwhere || 'AND (LOWER(ds.estado) = LOWER(''Anulado'')) ';
          strwhere      := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''Anulado''))  ';
        ELSIF estados(i) = 'Rechazada' THEN
          strwhere      := strwhere || 'AND (LOWER(ds.estado) = LOWER(''Rechazada'')) ';
          strwhere      := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''Rechazada''))  ';
        ELSIF estados(i) = 'TODOS-Planifica' THEN
          strwhere      := strwhere || 'AND (LOWER(ds.estado) = LOWER(''PrePlanificada'') OR LOWER(ds.estado) = LOWER(''Detenido'') OR LOWER(ds.estado) = LOWER(''Anulado'') OR LOWER(ds.estado) = LOWER(''Rechazada'') OR LOWER(ds.estado) = LOWER(''Planificada'') OR LOWER(ds.estado) = LOWER(''AsignadoTarea'') OR LOWER(ds.estado) = LOWER(''Asignada'')) ';
          strwhere      := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''PrePlanificada'') OR LOWER(dsh.estado) = LOWER(''Detenido'') OR LOWER(dsh.estado) = LOWER(''Anulado'') OR LOWER(dsh.estado) = LOWER(''Rechazada'') OR LOWER(dsh.estado) = LOWER(''Planificada'') OR LOWER(dsh.estado) = LOWER(''AsignadoTarea'') OR LOWER(dsh.estado) = LOWER(''Asignada'')) ';
        ELSE
          strwhere := strwhere || 'AND (LOWER(ds.estado) = LOWER(''PrePlanificada'') OR LOWER(ds.estado) = LOWER(''Planificada'') OR LOWER(ds.estado) = LOWER(''Replanificada'') OR LOWER(ds.estado) = LOWER(''Detenido'') OR LOWER(ds.estado) = LOWER(''Anulado'') OR LOWER(ds.estado) = LOWER(''Rechazada'')) ';
          strwhere := strwhere || 'AND (LOWER(dsh.estado) = LOWER(''PrePlanificada'') OR LOWER(dsh.estado) = LOWER(''Planificada'') OR LOWER(dsh.estado) = LOWER(''Replanificada'') OR LOWER(ds.estado) = LOWER(''Detenido'') OR LOWER(dsh.estado) = LOWER(''Anulado'') OR LOWER(dsh.estado) = LOWER(''Rechazada'')) ';
        END IF;
      END IF;
      
      strsql := strsql || strwhere;
      strsql := strsql || '  ORDER BY ds.estado ASC   ';
        
      --se ejecuta el query generado dinamicamente, en caso de traer registros se  recorrer y procesa la información 

      OPEN emp_tbl FOR strsql;
      
      LOOP
        FETCH emp_tbl INTO emp_record;
        EXIT WHEN emp_tbl%NOTFOUND;
        
        
            IF (contador_archivo    =0) THEN
              numero_archivo       := SEQ_NUMERO_ARCHIVO.NEXTVAL;
              identificadorArchivo := TO_CHAR(numero_archivo);
              contador_archivo     :=contador_archivo+1;
            END IF;
            nombreProductoPlan                  := '';
            nombreProductoPlan                  := emp_record.desPro ||emp_record.desPlan;
            cliente                             := '';
            IF ((LENGTH(emp_record.razon_Social) >0) OR (LENGTH(emp_record.nombres)>0) )THEN
              IF (LENGTH(emp_record.razon_Social)>0) THEN
                cliente                         := emp_record.razon_Social;
              ELSE
                cliente:= emp_record.nombres||' '||emp_record.apellidos;
              END IF;
            END IF;
            coordenadas                    := '';
            IF ((LENGTH(emp_record.longitud)>0) OR (LENGTH(emp_record.latitud)>0) )THEN
              coordenadas                  := emp_record.longitud||', '||emp_record.latitud;
            END IF;
            feSolicitaPlanificacion                   := '';
            IF (LENGTH(TO_CHAR(emp_record.fe_Creacion))>0) THEN
              feSolicitaPlanificacion                 := TO_CHAR(emp_record.fe_Creacion,'dd/mm/yyyy hh24:mi');
            END IF;
            fechaPlanificacionReal                     := '';
            fePlanificada                              := '';
            HoraIniPlanificada                         := '';
            HoraFinPlanificada                         := '';
            nombrePlanifica                            := '';
            IF ( (upper(emp_record.estado)              = upper('Planificada')) OR (upper(emp_record.estado) = upper('Replanificada'))) THEN
              IF LENGTH(TO_CHAR(emp_record.fe_Ini_Plan))>0 THEN
                fePlanificada                          := TO_CHAR(emp_record.fe_Ini_Plan,'dd/mm/yyyy');
                HoraIniPlanificada                     := TO_CHAR(emp_record.fe_Ini_Plan,'hh24:mi');
              END IF;
              IF LENGTH(TO_CHAR(emp_record.fe_Fin_Plan))>0 THEN
                HoraFinPlanificada                     := TO_CHAR(emp_record.fe_Fin_Plan,'hh24:mi');
              END IF;
              IF LENGTH(emp_record.usrPlanifica)>0 THEN
                BEGIN
                  SELECT nombres
                    || ' '
                    || apellidos
                  INTO nombrePlanifica
                  FROM INFO_PERSONA
                  WHERE LOGIN = emp_record.usrPlanifica
                  AND ROWNUM  =1;
                EXCEPTION
                WHEN OTHERS THEN
                  nombrePlanifica:='';
                END;
              END IF;
              fechaPlanificacionReal := fePlanificada || ' (' || HoraIniPlanificada || ' - ' || HoraFinPlanificada || ')';
            END IF;
            nombreMotivo                  := '';
            IF LENGTH(emp_record.motivo_Id)>0 THEN
              BEGIN
                SELECT nombre_Motivo
                INTO nombreMotivo
                FROM ADMI_MOTIVO
                WHERE ID_MOTIVO = emp_record.motivo_Id
                AND ROWNUM      =1;
              EXCEPTION
              WHEN OTHERS THEN
                nombreMotivo:='';
              END;
            END IF;
            --agregar contactos
            contactos := '';
            BEGIN
              SELECT
                LISTAGG(pfc.valor, ' - ') WITHIN GROUP (
              ORDER BY pfc.valor)
              INTO contactos
              FROM Info_Punto pto,
                Info_Persona_Empresa_Rol iper,
                Info_Persona p,
                Info_Persona_Forma_Contacto pfc,
                Admi_Forma_Contacto afc
              WHERE pto.persona_Empresa_Rol_Id           = iper.ID_PERSONA_ROL
              AND iper.persona_Id                        =p.id_persona
              AND p.id_persona                           = pfc.persona_Id
              AND afc.id_forma_contacto                  = pfc.forma_Contacto_Id
              AND lower(pto.login)                       = lower(emp_record.login)
              AND lower(pfc.estado)                      = lower('Activo')
              AND pfc.valor                             IS NOT NULL
              AND lower(afc.descripcion_Forma_Contacto) IN ('telefono fijo','telefono movil','telefono movil claro','telefono movil movistar',
                                                            'telefono movil cnt')
              GROUP BY pfc.estado;
            EXCEPTION
            WHEN OTHERS THEN
              nombrePlanifica:='';
            END;
            tipoOrden               := '';
            IF(emp_record.tipo_orden = 'N') THEN
              tipoOrden             := 'Nueva';
            ELSE
              IF(emp_record.tipo_orden = 'R') THEN
                tipoOrden             := 'Reubicacion';
              ELSE
                IF(emp_record.tipo_orden = 'T') THEN
                  tipoOrden             := 'Traslado';
                ELSE
                  tipoOrden := 'Nueva';
                END IF;
              END IF;
            END IF;
            
            --se insertan registros luego de procesar la información de cada campo utilizado
            INSERT
            INTO Info_registro_excel
              (
                id_registro_excel, --
                numero_archivo_id, --
                numeroOrdenTrabajo, --*
                cliente, --
                nombreVendedor, --
                login,  --
                nombreProductoPlan, --
                ciudad, --
                coordenadas, --
                direccion, --
                nombreSector, --
                contactos, --
                tipoOrden, --
                feSolicitaPlanificacion, --
                fechaPlanificacionReal, --
                nombrePlanifica,--*
                estado, --
                nombreMotivo,--*
                descripcion --
              )
              VALUES
              (
                SEQ_INFO_REGISTRO_EXCEL.NEXTVAL,
                numero_archivo,
                emp_record.numero_Orden_Trabajo,
                cliente,
                emp_record.nombre_Vendedor,
                emp_record.login,
                nombreProductoPlan,
                emp_record.nombre_Canton,
                coordenadas,
                emp_record.direccion,
                emp_record.nombre_Sector,
                contactos,
                tipoOrden,
                feSolicitaPlanificacion,
                fechaPlanificacionReal,
                nombrePlanifica,
                emp_record.estado,
                nombreMotivo,
                emp_record.descripcion_solicitud 
              );
            numero_registros_commit    := numero_registros_commit + 1;
            IF (numero_registros_commit = 100) THEN
                 COMMIT;
                numero_registros_commit := 0;
            END IF;
            
            
    END LOOP;
    COMMIT;
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  mensajeError:=SUBSTR(SQLERRM,1,250);
END;


PROCEDURE generarInfoExcelReporteAsigna(estado               IN VARCHAR2,
                                        fechaDesdeSolPlanif  IN VARCHAR2,
                                        fechaHastaSolPlanif  IN VARCHAR2,
                                        fechaDesdePlanif     IN VARCHAR2,
                                        fechaHastaPlanif     IN VARCHAR2,
                                        login2               IN VARCHAR2,
                                        descripcionPunto     IN VARCHAR2,
                                        vendedor             IN VARCHAR2,
                                        ciudad               IN VARCHAR2,
                                        numOrdenServicio     IN VARCHAR2,
                                        tipoResponsable      IN VARCHAR2,
                                        codigoResponsable    IN VARCHAR2,  
                                        prefijoEmpresa       IN VARCHAR2,
                                        codigoEmpresa        IN VARCHAR2,
                                        identificadorArchivo OUT VARCHAR2,
                                        mensajeError         OUT VARCHAR2) IS

        
  --Cursor para generar tipo de datos a recorrer luego de recuperar información del query dinamico
  CURSOR queryTipoDeCampos IS
  SELECT  d.ID_DETALLE                                         as idDetalle, 
          da.ID_DETALLE_ASIGNACION                             as idDetalleAsignacion, 
		  d.FE_CREACION                                        as feAsignada, 
          da.FE_CREACION                                       as feAsignadaDetalle, 
		  da.ASIGNADO_ID                                       as asignacion_id,   
          da.ASIGNADO_NOMBRE                                   as asignacion_nombre, 
          da.REF_ASIGNADO_ID                                   as ref_asignacion_id, 
          da.REF_ASIGNADO_NOMBRE                               as ref_asignado, 
		  ds.ID_DETALLE_SOLICITUD                              as idDetalleSolicitud, 
          s.ID_SERVICIO                                        as idServicio, 
		  p.ID_PUNTO                                           as idPunto, 
          ot.ID_ORDEN_TRABAJO                                  as idOrdenTrabajo, 
          t.ID_TAREA                                           as idTarea, 
          t.NOMBRE_TAREA                                       as NOMBRE_TAREA, 
		  ot.NUMERO_ORDEN_TRABAJO                              as NUMERO_ORDEN_TRABAJO, 
          se.NOMBRE_SECTOR                                     as NOMBRE_SECTOR, 
          pa.NOMBRE_PARROQUIA                                  as NOMBRE_PARROQUIA, 
          ca.NOMBRE_CANTON                                     as NOMBRE_CANTON, 
		  pe.RAZON_SOCIAL                                      as RAZON_SOCIAL, 
          pe.NOMBRES                                           as NOMBRES, 
          pe.APELLIDOS                                         as APELLIDOS, 
          p.USR_VENDEDOR                                       as USR_VENDEDOR,  
          p.LOGIN                                              as login, 
          p.LATITUD                                            as latitud,
          p.LONGITUD                                           as longitud,
		  p.LONGITUD                                           as longitud1, 
          p.LATITUD                                            as latitud1,
          p.DIRECCION                                          as direccion, 
          p.RUTA_CROQUIS                                       as rutaCroquis, 
          ds.FE_CREACION                                       as FE_CREACION, 
          ds.ESTADO                                            as estado,				
		  dsh.ID_SOLICITUD_HISTORIAL                           as idDetalleSolHist, 
          dsh.MOTIVO_ID                                        as motivo_id, 
          dsh.USR_CREACION                                     as usrAsigna, 
          p.OBSERVACION                                        as observacion, 
          dsh.OBSERVACION                                      as observacionSolicitud,
		  dshPlan.ID_SOLICITUD_HISTORIAL                       as idDetalleSolHistPlanifica, 
          dshPlan.MOTIVO_ID                                    as motivoPlanifica, 
		  dshPlan.FE_INI_PLAN                                  as FE_INI_PLAN, 
          dshPlan.FE_FIN_PLAN                                  as FE_FIN_PLAN, 
          dshPlan.USR_CREACION                                 as usrPlanifica, 				
		  CONCAT(peVend.NOMBRES,CONCAT(' ',peVend.APELLIDOS))  as nombreVendedor,
          admiTip.ID_TIPO_SOLICITUD                            as tipoSolicitudId ,
          admiTip.DESCRIPCION_SOLICITUD                        as descripcionSolicitud,
          
          (select b.INTERFACE_ELEMENTO_ID 
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO)                      as existe_serv_tec,
          
          (select c.NOMBRE_INTERFACE_ELEMENTO 
          from Info_Interface_Elemento c
          where c.ID_INTERFACE_ELEMENTO = (
          select b.INTERFACE_ELEMENTO_ID 
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                     as name_interf,
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = (select b.ELEMENTO_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                     as name_elem, 
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = 
          (select b.ELEMENTO_CONTENEDOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                     as name_caja, 
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = 
          (select b.ELEMENTO_CONECTOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                     as name_splitter,
          
          (select c.NOMBRE_INTERFACE_ELEMENTO 
          from INFO_INTERFACE_ELEMENTO c 
          where c.ID_INTERFACE_ELEMENTO = 
          (select b.INTERFACE_ELEMENTO_CONECTOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                     as int_splitter,
          
          
          (SELECT 'LAN:'||i.VALOR IPS_CLIENTE 
          FROM Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = 
          (SELECT C.ID_PRODUCTO_CARACTERISITICA FROM 
          ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO 
          FROM Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = 'INTERNET DEDICADO' 
          and  a.ESTADO = 'Activo'
          and  a.EMPRESA_COD = codigoEmpresa)
          AND C.CARACTERISTICA_ID = (SELECT B.ID_CARACTERISTICA 
          FROM Admi_Caracteristica B 
          WHERE B.DESCRIPCION_CARACTERISTICA = 'IP LAN' 
          AND B.ESTADO = 'Activo')))                                 as ipPlan,
          
          
          (SELECT i.VALOR  MASCARA_LAN FROM 
          Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = (SELECT 
          C.ID_PRODUCTO_CARACTERISITICA 
          FROM ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO FROM 
          Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = 'INTERNET DEDICADO' and  
          a.ESTADO = 'Activo' and  a.EMPRESA_COD = codigoEmpresa)
          AND C.CARACTERISTICA_ID = (SELECT B.ID_CARACTERISTICA 
          FROM Admi_Caracteristica B 
          WHERE B.DESCRIPCION_CARACTERISTICA = 'MASCARA LAN' AND 
          B.ESTADO = 'Activo')))                                     as mascaraLan,
          
          
          (SELECT i.VALOR  MASCARA_LAN FROM Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = 
          (SELECT C.ID_PRODUCTO_CARACTERISITICA FROM 
          ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO FROM Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = 'INTERNET DEDICADO' and  
          a.ESTADO = 'Activo' and  a.EMPRESA_COD = codigoEmpresa) AND C.CARACTERISTICA_ID = (SELECT
          B.ID_CARACTERISTICA FROM 
          Admi_Caracteristica B 
          WHERE B.DESCRIPCION_CARACTERISTICA = 'GATEWAY LAN' AND 
          B.ESTADO = 'Activo')))                                     as gatewayLan,
          
          (select d.DESCRIPCION_PRODUCTO nombre_producto 
          from admi_producto d where d.ID_PRODUCTO = (select 
          g.producto_id from Info_Servicio g where g.ID_SERVICIO 
          = s.ID_SERVICIO))                                          as name_producto,
            
          (select d.NOMBRE_PLAN nombre_plan from INFO_PLAN_CAB d
          where d.ID_PLAN = (select g.PLAN_ID from Info_Servicio g 
          where g.ID_SERVICIO = s.ID_SERVICIO))                      as name_plan,
          
          (select (h.NOMBRES ||' '|| h.APELLIDOS)  
          from INFO_PERSONA h where h.LOGIN = dsh.USR_CREACION)      as name_usuario,
          
          (select j.TIPO_ORDEN from INFO_SERVICIO j 
          where j.ID_SERVICIO = s.ID_SERVICIO)                       as id_tipoOrden


          FROM 
          Info_Empresa_Rol er,Info_Empresa_Grupo eg,
					Info_Detalle_Sol_Hist dsh,Info_Detalle_Sol_Hist dshPlan, 
					Info_Orden_Trabajo ot,Info_Servicio s,
					Info_Detalle_Solicitud ds, 
					Admi_Proceso pr,Admi_Tarea t, 
					Info_Persona pe,Info_Persona_Empresa_Rol per,
					Admi_Sector se,Admi_Parroquia pa,Admi_Canton ca, 
					Info_Detalle d,Info_Detalle_Asignacion da,
					Admi_Tipo_Solicitud admiTip,Info_Punto p

          LEFT JOIN Info_Persona peVend 
          ON peVend.LOGIN = p.USR_VENDEDOR 
          
          WHERE ot.ID_ORDEN_TRABAJO = s.ORDEN_TRABAJO_ID 
					AND ot.PUNTO_ID = p.ID_PUNTO
					AND s.ID_SERVICIO = ds.SERVICIO_ID 
					AND p.PERSONA_EMPRESA_ROL_ID = per.ID_PERSONA_ROL 
					AND per.PERSONA_ID = pe.ID_PERSONA 
					AND p.SECTOR_ID = se.ID_SECTOR 
					AND se.PARROQUIA_ID = pa.ID_PARROQUIA 
					AND pa.CANTON_ID = ca.ID_CANTON 
					
					AND ds.ID_DETALLE_SOLICITUD = dsh.DETALLE_SOLICITUD_ID 
					AND ds.TIPO_SOLICITUD_ID = admiTip.ID_TIPO_SOLICITUD
					AND dsh.ID_SOLICITUD_HISTORIAL = (SELECT MAX(dshMax.ID_SOLICITUD_HISTORIAL) 
								  FROM Info_Detalle_Sol_Hist dshMax
								  WHERE dshMax.DETALLE_SOLICITUD_ID = dsh.DETALLE_SOLICITUD_ID) 
					
					AND ds.ID_DETALLE_SOLICITUD = dshPlan.DETALLE_SOLICITUD_ID 
					AND dshPlan.ID_SOLICITUD_HISTORIAL = (SELECT MAX(dshPlanMax.ID_SOLICITUD_HISTORIAL) 
									  FROM Info_Detalle_Sol_Hist dshPlanMax
									  WHERE dshPlanMax.DETALLE_SOLICITUD_ID = dshPlan.DETALLE_SOLICITUD_ID
									  AND (LOWER(dshPlanMax.ESTADO) = LOWER('Planificada') OR 
                    LOWER(dshPlanMax.ESTADO) = LOWER('Replanificada'))) 
													 
					AND d.TAREA_ID = t.ID_TAREA 
					AND t.PROCESO_ID = pr.ID_PROCESO 
					AND upper(pr.NOMBRE_PROCESO) like '%SOLICITAR NUEVO SERVICIO%'
					
					AND d.DETALLE_SOLICITUD_ID = ds.ID_DETALLE_SOLICITUD			
								
					AND da.DETALLE_ID = d.ID_DETALLE 
          
					AND da.ID_DETALLE_ASIGNACION = (SELECT MAX(daMax.ID_DETALLE_ASIGNACION) 
          FROM Info_Detalle_Asignacion daMax
					WHERE daMax.DETALLE_ID = da.DETALLE_ID)
          
					AND er.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          AND er.EMPRESA_COD = eg.COD_EMPRESA
          AND eg.PREFIJO = 'TN';
          
    
    --variables utilizadas en el procedimiento
    strwhere                long := '';
    strsql                  long:= '';
    TYPE estadosTodosArray IS VARRAY(5) OF VARCHAR2(20);
    estados estadosTodosArray;
    type tmp_tbm IS  REF  CURSOR;
    emp_record queryTipoDeCampos%ROWTYPE;
    emp_tbl tmp_tbm;
    nombreProductoPlan      VARCHAR2(4000) := '';
    cliente                 VARCHAR2(4000) := '';
    coordenadas             VARCHAR2(4000) := '';
    feSolicitaPlanificacion VARCHAR2(4000) := '';
    fechaPlanificacionReal  VARCHAR2(4000) := '';
    fePlanificada           VARCHAR2(4000) := '';
    HoraIniPlanificada      VARCHAR2(4000) := '';
    HoraFinPlanificada      VARCHAR2(4000) := '';
    nombrePlanifica         VARCHAR2(4000) := '';
    nombreMotivo            VARCHAR2(4000) := '';
    contactos               VARCHAR2(4000) := '';
    tipoOrden               VARCHAR2(4000) := '';
    numero_archivo          NUMBER         := 0;
    contador_archivo        NUMBER         := 0;
    numero_registros_commit NUMBER         := 0;
    
    nombre_interface        varchar2(200);
    nombre_elemento         varchar2(200);    
    caja                    varchar2(200);    
    splitter                varchar2(200);    
    intSplitter             varchar2(200);   
    ipsCliente              varchar2(1000);
    ipsClienteComplemento   varchar2(1000);
    nombre_vendedor         varchar2(200); 
    nombre_sector           varchar2(200); 
    nombre_ciudad           varchar2(200); 
    nombre_cliente          varchar2(200); 
    longitud                varchar2(50);
    latitud                 varchar2(50);
    nombre_cordenadas       varchar2(200); 
    fecha_asignada          varchar2(200); 
    
    nombreAsigna            varchar2(200):=''; 
    asignadoNombre          varchar2(200):=''; 
    refAsignadoNombre       varchar2(200):=''; 
    asignado                varchar2(200):=''; 
    nombreTarea             varchar2(200):=''; 
    name_asigna             varchar2(200):=''; 
    telefonos               varchar2(200):=''; 
    

  BEGIN

      strwhere := '';
      strsql   := '';
      strsql   :=
      '  SELECT  d.ID_DETALLE                                    as idDetalle, 
          da.ID_DETALLE_ASIGNACION                               as idDetalleAsignacion, 
		  d.FE_CREACION                                          as feAsignada, 
          da.FE_CREACION                                         as feAsignadaDetalle, 
		  da.ASIGNADO_ID                                         as asignacion_id,   
          da.ASIGNADO_NOMBRE                                     as asignacion_nombre, 
          da.REF_ASIGNADO_ID                                     as ref_asignacion_id, 
          da.REF_ASIGNADO_NOMBRE                                 as ref_asignado, 
		  ds.ID_DETALLE_SOLICITUD                                as idDetalleSolicitud, 
          s.ID_SERVICIO                                          as idServicio, 
		  p.ID_PUNTO                                             as idPunto, 
          ot.ID_ORDEN_TRABAJO                                    as idOrdenTrabajo, 
          t.ID_TAREA                                             as idTarea, 
          t.NOMBRE_TAREA                                         as NOMBRE_TAREA, 
		  ot.NUMERO_ORDEN_TRABAJO                                as NUMERO_ORDEN_TRABAJO, 
          se.NOMBRE_SECTOR                                       as NOMBRE_SECTOR, 
          pa.NOMBRE_PARROQUIA                                    as NOMBRE_PARROQUIA, 
          ca.NOMBRE_CANTON                                       as NOMBRE_CANTON, 
		  pe.RAZON_SOCIAL                                        as RAZON_SOCIAL, 
          pe.NOMBRES                                             as NOMBRES, 
          pe.APELLIDOS                                           as APELLIDOS, 
          p.USR_VENDEDOR                                         as USR_VENDEDOR,  
          p.LOGIN                                                as login, 
          p.LATITUD                                              as latitud,
          p.LONGITUD                                             as longitud,
		  p.LONGITUD                                             as longitud1, 
          p.LATITUD                                              as latitud1,
          p.DIRECCION                                            as direccion, 
          p.RUTA_CROQUIS                                         as rutaCroquis, 
          ds.FE_CREACION                                         as FE_CREACION, 
          ds.ESTADO                                              as estado,				
		  dsh.ID_SOLICITUD_HISTORIAL                             as idDetalleSolHist, 
          dsh.MOTIVO_ID                                          as motivo_id, 
          dsh.USR_CREACION                                       as usrAsigna, 
          p.OBSERVACION                                          as observacion, 
          dsh.OBSERVACION                                        as observacionSolicitud,
		  dshPlan.ID_SOLICITUD_HISTORIAL                         as idDetalleSolHistPlanifica, 
          dshPlan.MOTIVO_ID                                      as motivoPlanifica, 
		  dshPlan.FE_INI_PLAN                                    as FE_INI_PLAN, 
          dshPlan.FE_FIN_PLAN                                    as FE_FIN_PLAN, 
          dshPlan.USR_CREACION                                   as usrPlanifica, 				
		  CONCAT(peVend.NOMBRES,CONCAT('' '',peVend.APELLIDOS))  as nombreVendedor,
          admiTip.ID_TIPO_SOLICITUD                              as tipoSolicitudId ,
          admiTip.DESCRIPCION_SOLICITUD                          as descripcionSolicitud,
          
          (select b.INTERFACE_ELEMENTO_ID 
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO)                   as existe_serv_tec,
          
          (select c.NOMBRE_INTERFACE_ELEMENTO 
          from Info_Interface_Elemento c
          where c.ID_INTERFACE_ELEMENTO = (
          select b.INTERFACE_ELEMENTO_ID 
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                  as name_interf,
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = (select b.ELEMENTO_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                  as name_elem, 
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = 
          (select b.ELEMENTO_CONTENEDOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                  as name_caja, 
          
          (select c.NOMBRE_ELEMENTO from INFO_ELEMENTO c 
          where c.ID_ELEMENTO = 
          (select b.ELEMENTO_CONECTOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                  as name_splitter,
          
          (select c.NOMBRE_INTERFACE_ELEMENTO 
          from INFO_INTERFACE_ELEMENTO c 
          where c.ID_INTERFACE_ELEMENTO = 
          (select b.INTERFACE_ELEMENTO_CONECTOR_ID
          from Info_Servicio_Tecnico b 
          where b.SERVICIO_ID = s.ID_SERVICIO))                  as int_splitter,
          
          
          (SELECT ''LAN:''||i.VALOR IPS_CLIENTE 
          FROM Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = 
          (SELECT C.ID_PRODUCTO_CARACTERISITICA FROM 
          ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO 
          FROM Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = ''INTERNET DEDICADO'' 
          and  a.ESTADO = ''Activo'' and  a.EMPRESA_COD = '''||codigoEmpresa||''')
          AND C.CARACTERISTICA_ID = (SELECT B.ID_CARACTERISTICA 
          FROM Admi_Caracteristica B 
          WHERE B.DESCRIPCION_CARACTERISTICA = ''IP LAN'' 
          AND B.ESTADO = ''Activo'')))                           as ipPlan,
          
          
          (SELECT i.VALOR  MASCARA_LAN FROM 
          Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = (SELECT 
          C.ID_PRODUCTO_CARACTERISITICA 
          FROM ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO FROM 
          Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = ''INTERNET DEDICADO'' 
          and  a.ESTADO = ''Activo''  and  a.EMPRESA_COD = '''||codigoEmpresa||''')
          AND C.CARACTERISTICA_ID = (SELECT B.ID_CARACTERISTICA 
          FROM Admi_Caracteristica B 
          WHERE B.DESCRIPCION_CARACTERISTICA = ''MASCARA LAN'' 
          AND B.ESTADO = ''Activo'')))                           as mascaraLan,
          
          
          (SELECT i.VALOR  MASCARA_LAN FROM 
          Info_Servicio_Prod_Caract i 
          where i.SERVICIO_ID = s.ID_SERVICIO and 
          i.PRODUCTO_CARACTERISITICA_ID = 
          (SELECT C.ID_PRODUCTO_CARACTERISITICA FROM 
          ADMI_PRODUCTO_CARACTERISTICA C 
          WHERE C.PRODUCTO_ID = (SELECT a.ID_PRODUCTO FROM 
          Admi_Producto a 
          where a.DESCRIPCION_PRODUCTO = ''INTERNET DEDICADO'' 
          and  a.ESTADO = ''Activo''  and  a.EMPRESA_COD = '''||codigoEmpresa||''') AND C.CARACTERISTICA_ID =
          (SELECT B.ID_CARACTERISTICA FROM 
          Admi_Caracteristica B WHERE 
          B.DESCRIPCION_CARACTERISTICA = ''GATEWAY LAN'' AND 
          B.ESTADO = ''Activo'')))                               as gatewayLan,
          
          (select d.DESCRIPCION_PRODUCTO nombre_producto 
          from admi_producto d where d.ID_PRODUCTO = (select 
          g.producto_id from Info_Servicio g 
          where g.ID_SERVICIO = s.ID_SERVICIO))                  as name_producto,
            
          (select d.NOMBRE_PLAN nombre_plan from 
          INFO_PLAN_CAB d where d.ID_PLAN 
          = (select g.PLAN_ID from Info_Servicio g 
          where g.ID_SERVICIO = s.ID_SERVICIO))                  as name_plan,
          
          (select (h.NOMBRES ||'' ''|| h.APELLIDOS)  
          from INFO_PERSONA h where h.LOGIN = dsh.USR_CREACION)  as name_usuario,
          
          (select j.TIPO_ORDEN from INFO_SERVICIO j 
          where j.ID_SERVICIO = s.ID_SERVICIO)                   as id_tipoOrden


          FROM 
          Info_Empresa_Rol er,Info_Empresa_Grupo eg,
					Info_Detalle_Sol_Hist dsh,Info_Detalle_Sol_Hist dshPlan, 
					Info_Orden_Trabajo ot,Info_Servicio s,
					Info_Detalle_Solicitud ds, 
					Admi_Proceso pr,Admi_Tarea t, 
					Info_Persona pe,Info_Persona_Empresa_Rol per,
					Admi_Sector se,Admi_Parroquia pa,Admi_Canton ca, 
					Info_Detalle d,Info_Detalle_Asignacion da,
					Admi_Tipo_Solicitud admiTip,Info_Punto p

          LEFT JOIN Info_Persona peVend 
          ON peVend.LOGIN = p.USR_VENDEDOR 
          
          WHERE ot.ID_ORDEN_TRABAJO = s.ORDEN_TRABAJO_ID 
					AND ot.PUNTO_ID = p.ID_PUNTO
					AND s.ID_SERVICIO = ds.SERVICIO_ID 
					AND p.PERSONA_EMPRESA_ROL_ID = per.ID_PERSONA_ROL 
					AND per.PERSONA_ID = pe.ID_PERSONA 
					AND p.SECTOR_ID = se.ID_SECTOR 
					AND se.PARROQUIA_ID = pa.ID_PARROQUIA 
					AND pa.CANTON_ID = ca.ID_CANTON 
					
					AND ds.ID_DETALLE_SOLICITUD = dsh.DETALLE_SOLICITUD_ID 
					AND ds.TIPO_SOLICITUD_ID = admiTip.ID_TIPO_SOLICITUD
					AND dsh.ID_SOLICITUD_HISTORIAL = (SELECT MAX(dshMax.ID_SOLICITUD_HISTORIAL) 
								  FROM Info_Detalle_Sol_Hist dshMax
								  WHERE dshMax.DETALLE_SOLICITUD_ID = dsh.DETALLE_SOLICITUD_ID) 
					
					AND ds.ID_DETALLE_SOLICITUD = dshPlan.DETALLE_SOLICITUD_ID 
					AND dshPlan.ID_SOLICITUD_HISTORIAL = (SELECT MAX(dshPlanMax.ID_SOLICITUD_HISTORIAL) 
									  FROM Info_Detalle_Sol_Hist dshPlanMax
									  WHERE dshPlanMax.DETALLE_SOLICITUD_ID = dshPlan.DETALLE_SOLICITUD_ID
									  AND (LOWER(dshPlanMax.ESTADO) = LOWER(''Planificada'') 
                    OR LOWER(dshPlanMax.ESTADO) = LOWER(''Replanificada''))) 
													 
					AND d.TAREA_ID = t.ID_TAREA 
					AND t.PROCESO_ID = pr.ID_PROCESO 
					AND upper(pr.NOMBRE_PROCESO) like ''%SOLICITAR NUEVO SERVICIO%''
					
					AND d.DETALLE_SOLICITUD_ID = ds.ID_DETALLE_SOLICITUD			
								
					AND da.DETALLE_ID = d.ID_DETALLE 
          
					AND da.ID_DETALLE_ASIGNACION = (SELECT MAX(daMax.ID_DETALLE_ASIGNACION) 
          FROM Info_Detalle_Asignacion daMax
					WHERE daMax.DETALLE_ID = da.DETALLE_ID)
          
					AND er.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          AND er.EMPRESA_COD = eg.COD_EMPRESA
          AND eg.PREFIJO = '''||prefijoEmpresa||'''';
          

        --se comienza a generar el query dinamicamente dependiendo de los parametros ingresados                              
        IF LENGTH(fechaDesdePlanif)>0 THEN 
          strwhere                   := strwhere || 
          ' AND dshPlan.FE_INI_PLAN >= to_date('''||fechaDesdePlanif||''',''dd/mm/yyyy'') ';
        END IF;
        IF LENGTH(fechaHastaPlanif)>0 THEN 
          strwhere                   := strwhere || 
          ' AND dshPlan.FE_INI_PLAN <= to_date('''||fechaHastaPlanif||''',''dd/mm/yyyy'') ';
        END IF;
        IF LENGTH(fechaDesdePlanif)>0 THEN 
          strwhere                   := strwhere || 
          ' AND d.FE_CREACION >= to_date('''||fechaDesdePlanif||''',''dd/mm/yyyy'') ';
        END IF;
        IF LENGTH(fechaHastaPlanif)>0 THEN 
          strwhere                   := strwhere || 
          ' AND d.FE_CREACION <= to_date('''||fechaHastaPlanif||''',''dd/mm/yyyy'') ';
        END IF;
        IF LENGTH(login2)>0 THEN
          strwhere      := strwhere || ' AND UPPER(p.LOGIN) like ''%'||upper(trim(login2))||'%'' ';
        END IF;
        IF LENGTH(descripcionPunto)>0 THEN
          strwhere                := strwhere || 
          ' AND UPPER(p.DESCRIPCION_PUNTO) like ''%'||upper(trim(descripcionPunto))||'%'' ';
        END IF;
        IF LENGTH(numOrdenServicio)>0 THEN
          strwhere                := strwhere || 
          ' AND ot.NUMERO_ORDEN_TRABAJO like ''%'||numOrdenServicio||'%'' ';
        END IF;
        IF LENGTH(ciudad)>0 THEN
          strwhere                := strwhere || 
          ' AND UPPER(ca.NOMBRE_CANTON) like ''%'||upper(trim(ciudad))||'%'' ';
        END IF;
        IF LENGTH(vendedor)>0 THEN          
          strwhere                := strwhere || 
          ' AND CONCAT(lower(peVend.NOMBRES),CONCAT('' '',LOWER(peVend.APELLIDOS))) 
          like ''%'||lower(trim(vendedor))||'%''  ';          
        END IF;        
        IF (estado = 'Todos') THEN          
          strwhere                := strwhere || 
          ' AND ( LOWER(ds.ESTADO) = LOWER(''Asignada'')  OR LOWER(ds.ESTADO) = LOWER(''AsignadoTarea'')) ';
          strwhere                := strwhere || 
          ' AND ( LOWER(dsh.ESTADO) = LOWER(''Asignada'')  OR LOWER(dsh.ESTADO) = LOWER(''AsignadoTarea'')) ';
        ELSE          
          strwhere                := strwhere || 
          ' AND (LOWER(ds.ESTADO) = LOWER('''||estado||''')) ';
          strwhere                := strwhere || 
          ' AND (LOWER(dsh.ESTADO) = LOWER('''||estado||''')) ';
        END IF;
        IF LENGTH(tipoResponsable)>0 THEN         
            IF tipoResponsable = 'empleado' THEN 
              strwhere                := strwhere || 
              ' AND da.ASIGNADO_ID is not null AND da.REF_ASIGNADO_ID is not null ';
                IF LENGTH(codigoResponsable)>0 THEN 
                  strwhere                := strwhere || ' AND da.REF_ASIGNADO_ID = '''||codigoResponsable||''' ';
                END IF;
            ELSIF  tipoResponsable = 'empresaExterna' THEN     
              strwhere                := strwhere || 
              ' AND da.ASIGNADO_ID is not null AND (da.REF_ASIGNADO_ID is null OR da.REF_ASIGNADO_ID = 0) ';
              strwhere                := strwhere || 
              ' AND (SELECT count(*) FROM Info_Detalle_Colaborador dr 
              WHERE dr.DETALLE_ASIGNACION_ID = da.ID_DETALLE_ASIGNACION) = 0 '; 
                IF LENGTH(codigoResponsable)>0 THEN 
                  strwhere                := strwhere || ' AND da.ASIGNADO_ID = '||codigoResponsable||' ';
                END IF;
            ELSIF  tipoResponsable = 'cuadrilla' THEN   
              strwhere                := strwhere || 
              ' AND da.ASIGNADO_ID is not null AND (da.REF_ASIGNADO_ID is null OR da.REF_ASIGNADO_ID = 0) ';
              strwhere                := strwhere || 
              ' AND (SELECT count(*) FROM Info_Detalle_Colaborador dr 
              WHERE dr.DETALLE_ASIGNACION_ID = da.ID_DETALLE_ASIGNACION) > 0 ';
                IF LENGTH(codigoResponsable)>0 THEN 
                  strwhere                := strwhere || ' AND da.ASIGNADO_ID = '||codigoResponsable||' ';
                END IF;
            END IF;
        END IF;

      strsql := strsql || strwhere;
      strsql := strsql || '  ORDER BY ds.FE_CREACION DESC   ';
      

    OPEN emp_tbl FOR strsql;
      
      LOOP
   
        FETCH emp_tbl INTO emp_record;
        EXIT WHEN emp_tbl%NOTFOUND;
      
        
            IF (contador_archivo = 0) THEN
              numero_archivo       := SEQ_NUMERO_ARCHIVO.NEXTVAL;
              identificadorArchivo := TO_CHAR(numero_archivo);
              contador_archivo     := contador_archivo+1;
            END IF;
              
            
            
        IF LENGTH(emp_record.idServicio)>0 THEN   
                    
            IF LENGTH(emp_record.existe_serv_tec)>0 THEN--Valida que existe Servicio Tecnico
              
              nombre_interface := nvl(emp_record.name_interf,'');       
              nombre_elemento  := nvl(emp_record.name_elem,'');        
              caja             := nvl(emp_record.name_caja,'');  
              splitter         := nvl(emp_record.name_splitter,'');  
              intSplitter      := nvl(emp_record.int_splitter,'');  
            
            ELSE
            
              nombre_interface := '';       
              nombre_elemento  := '';
              caja             := '';
              splitter         := '';
              intSplitter      := '';
                        
            END IF;
            
            ipsCliente :='';
            ipsCliente := ipsCliente ||emp_record.ipPlan||' '||emp_record.mascaraLan||' '||emp_record.gatewayLan;
            

            --Se arma la trama de las IP
            BEGIN          
            SELECT LISTAGG(f.TIPO_IP||':'||f.IP||' '||f.MASCARA||' '||f.GATEWAY, ';') WITHIN GROUP (
              ORDER BY f.TIPO_IP||':'||f.IP||' '||f.MASCARA||' '||f.GATEWAY)
              into ipsClienteComplemento
              FROM Info_Ip f 
              WHERE f.SERVICIO_ID = emp_record.idServicio and f.ESTADO = 'Activo'
              group by f.SERVICIO_ID;

            EXCEPTION
            WHEN OTHERS THEN
              ipsClienteComplemento := '';
            
            END;


            ipsCliente := ipsCliente||';'||ipsClienteComplemento;
            
            if (ipsCliente = '  ;') then
              ipsCliente := '';
            end if;

            nombreProductoPlan  := emp_record.name_producto || emp_record.name_plan;

            nombre_vendedor     := emp_record.USR_VENDEDOR;
            nombre_sector       := emp_record.NOMBRE_SECTOR;
            nombre_ciudad       := emp_record.NOMBRE_CANTON;
            nombre_cliente      := emp_record.RAZON_SOCIAL;
            nombre_cordenadas   := to_char(emp_record.LONGITUD)||','||emp_record.latitud;
            fecha_asignada      := emp_record.feAsignada;

            --inicializo variables
            fechaPlanificacionReal := '';
            fePlanificada          := '';
            HoraIniPlanificada     := '';
            HoraFinPlanificada     := '';
            nombrePlanifica        := '';       
            
            
            IF (upper(emp_record.estado) = 'PLANIFICADA') OR (upper(emp_record.estado) = 'REPLANIFICADA')
            OR (upper(emp_record.estado) = 'ASIGNADOTAREA') OR (upper(emp_record.estado) = 'ASIGNADA')
            OR (upper(emp_record.estado) = 'FINALIZADA') THEN
    
               fePlanificada                          := TO_CHAR(emp_record.fe_Ini_Plan,'dd/mm/yyyy');
               HoraIniPlanificada                     := TO_CHAR(emp_record.fe_Ini_Plan,'HH24:MI');
               HoraFinPlanificada                     := TO_CHAR(emp_record.fe_Fin_Plan,'HH24:MI');


            fechaPlanificacionReal := fePlanificada||' (' || HoraIniPlanificada ||' - '||HoraFinPlanificada||') ';    
    
            END IF; 

            nombreAsigna :='';
            asignadoNombre :='';
            refAsignadoNombre :='';
            Asignado :='';
            nombreTarea :='';

            if (upper(emp_record.estado) = 'ASIGNADOTAREA') OR (upper(emp_record.estado) = 'ASIGNADA')
            OR (upper(emp_record.estado) = 'FINALIZADA') THEN
    
              IF LENGTH(emp_record.usrAsigna)>0 THEN
       
                name_asigna := nvl(emp_record.name_usuario,'');
                            
              END IF;

              asignadoNombre    :=  nvl(emp_record.asignacion_nombre,'');
              refAsignadoNombre :=  nvl(emp_record.ref_asignado,'');
              Asignado          :=  asignadoNombre ||' - '||refAsignadoNombre;
    
              nombreTarea       :=  emp_record.NOMBRE_TAREA;

              tipoOrden :=       emp_record.id_tipoOrden;

              if (tipoOrden = 'N') then
                tipoOrden := 'Nueva';  
              elsif  (tipoOrden = 'R') then
                tipoOrden := 'Reubicacion'; 
              elsif  (tipoOrden = 'T') then
                tipoOrden := 'Traslado';  
              else
                tipoOrden := 'Nueva';
              end if;
              
              --Arma la trama de contactos
              BEGIN
                SELECT
                LISTAGG(pfc.valor, ' - ') WITHIN GROUP (
                ORDER BY pfc.valor)
                INTO telefonos
               FROM Info_Punto pto,
                Info_Persona_Empresa_Rol iper,
                Info_Persona p,
                Info_Persona_Forma_Contacto pfc,
                Admi_Forma_Contacto afc
              WHERE pto.persona_Empresa_Rol_Id           = iper.ID_PERSONA_ROL
              AND iper.persona_Id                        = p.id_persona
              AND p.id_persona                           = pfc.persona_Id
              AND afc.id_forma_contacto                  = pfc.forma_Contacto_Id
              AND lower(pto.login)                       = lower(emp_record.login)
              AND lower(pfc.estado)                      = lower('Activo')
              AND pfc.valor                             IS NOT NULL
              AND lower(afc.descripcion_Forma_Contacto) IN ('telefono fijo','telefono movil','telefono movil claro',
                                                            'telefono movil movistar','telefono movil cnt')
              GROUP BY pfc.estado;
            EXCEPTION
            WHEN OTHERS THEN
              telefonos:='';
            END;

            END IF;  


        END IF;
        
        
          IF (emp_record.RAZON_SOCIAL IS NULL OR emp_record.RAZON_SOCIAL = '' OR emp_record.RAZON_SOCIAL = ' ')THEN
            cliente := emp_record.NOMBRES||' '||emp_record.APELLIDOS;         
          ELSE                    
            cliente := emp_record.RAZON_SOCIAL; 
          END IF;


          --se insertan registros luego de procesar la información de cada campo utilizado
            INSERT
            INTO Info_registro_excel
              (
                id_registro_excel,        
                numero_archivo_id,        
                numeroOrdenTrabajo,   
                cliente,                 
                nombreVendedor,          
                login,                   
                nombreProductoPlan,      
                ciudad,                  
                coordenadas,             
                direccion,             
                nombreSector,             
                contactos,                
                tipoOrden,                
                feSolicitaPlanificacion,
                fechaPlanificacionReal,  
                nombrePlanifica,
                estado,                  
                nombreMotivo,
                descripcion,            
                observacion,             
                nombre_tarea,             
                nombre_asigna,           
                observacion_solicitud,    
                asignado,                 
                nombre_elemento,          
                nombre_interface,         
                ips_cliente,             
                caja,                     
                splitter,                
                id_splitter               
              )
              VALUES
              (
                SEQ_INFO_REGISTRO_EXCEL.NEXTVAL,
                numero_archivo,
                null,
                cliente,
                emp_record.nombreVendedor,
                emp_record.login,
                nombreProductoPlan,
                emp_record.NOMBRE_CANTON,
                nombre_cordenadas,
                emp_record.direccion,
                emp_record.NOMBRE_SECTOR,
                telefonos,
                tipoOrden,
                fecha_asignada,
                fechaPlanificacionReal,
                null,
                emp_record.estado,
                null,
                emp_record.descripcionSolicitud,
                emp_record.observacion,
                nombreTarea,
                name_asigna,
                emp_record.observacionSolicitud,
                Asignado,
                emp_record.name_elem,
                emp_record.name_interf,
                ipsCliente,
                emp_record.name_caja,
                emp_record.name_splitter,
                emp_record.int_splitter
              );
              
            numero_registros_commit    := numero_registros_commit + 1;
            IF (numero_registros_commit = 100) THEN
                 COMMIT;
                numero_registros_commit := 0;
            END IF;
  

      END LOOP;
      COMMIT; 
      
    
      
EXCEPTION
WHEN OTHERS THEN
  mensajeError:=SUBSTR(SQLERRM,1,250);
END;

END GeneraInformacionExcel;
/
