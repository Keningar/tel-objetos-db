CREATE OR REPLACE package            INK_TRANSFERENCIA_EMPRESAS is

  -- Author  : LLINDAO
  -- Created : 02/01/2014 15:04:52
  -- Purpose : 
  
  -----------------------------------------------------------------------
  -- Procedimiento que genera despacho por transferencia entre empresa --
  -----------------------------------------------------------------------
   PROCEDURE IN_P_PROCESA_DESPACHO ( Pv_IdDocumento  IN     VARCHAR2,
                                     Pv_IdCentro     IN     VARCHAR2,
                                     Pv_IdCompania   IN     VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2);
                                   
  -------------------------------------------------------------------------------------
  -- proceso que desde la empresa origen genera documento ingreso en empresa destino --
  -------------------------------------------------------------------------------------
  PROCEDURE IN_P_PROCESA_INGRESO_DESTINO ( Pv_IdDocOrigen     IN     VARCHAR2,
                                           Pv_IdCentroOrigen  IN     VARCHAR2,
                                           Pv_IdCiaOrigen     IN     VARCHAR2,
                                           Pv_IdDocDestino    IN OUT VARCHAR2,
                                           Pv_MensajeError    IN OUT VARCHAR2);

  ---------------------------------------------------------------------------
  -- Proceso carga los articulos al ingreso a bodega de la empresa destino --
  ---------------------------------------------------------------------------
  PROCEDURE IN_P_CARGA_ARTICULOS_DESTINO ( Pv_IdDocOrigen     IN     VARCHAR2,
                                           Pv_IdCentroOrigen  IN     VARCHAR2,
                                           Pv_IdCiaOrigen     IN     VARCHAR2,
                                           Pv_IdDocDestino    IN     VARCHAR2,
                                           Pv_IdCentroDestino IN     VARCHAR2,
                                           Pv_IdCiaDestino    IN     VARCHAR2,
                                           Pv_MensajeError    IN OUT VARCHAR2);

  ------------------------------------------------------------------------------
  -- Proceso que generara los nuevos articulos a la empresa que se transfiere --
  ------------------------------------------------------------------------------
  PROCEDURE IN_P_GENERA_ARTICULOS ( Pv_IdDocOrigen    IN     VARCHAR2,
                                    Pv_IdCentroOrigen IN     VARCHAR2,
                                    Pv_IdCiaOrigen    IN     VARCHAR2,
                                    Pv_IdCompania     IN     VARCHAR2,
                                    Pv_BodegaDestino  IN     VARCHAR2,
                                    Pv_MensajeError   IN OUT VARCHAR2);

  -----------------------------------------------------------
  -- Proceso que crea las clases de articulos si no existe --
  -----------------------------------------------------------
  PROCEDURE IN_P_CREA_CLASE_ARTICULO ( Pv_IdClase      IN     VARCHAR2,
                                       Pv_IdCiaOrigen  IN     VARCHAR2,
                                       Pv_IdCompania   IN     VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2);

  -----------------------------------------------------------
  -- Proceso que crea las clases de articulos si no existe --
  -----------------------------------------------------------
  PROCEDURE IN_P_CREA_CATEGORIA_ARTICULO ( Pv_IdCategoria  IN     VARCHAR2,
                                           Pv_IdClase      IN     VARCHAR2,
                                           Pv_IdCiaOrigen  IN     VARCHAR2,
                                           Pv_IdCompania   IN     VARCHAR2,
                                           Pv_MensajeError IN OUT VARCHAR2);

  -----------------------------------------------------------
  -- Proceso que crea las clases de articulos si no existe --
  -----------------------------------------------------------
  PROCEDURE IN_P_CREA_MEDIDA ( Pv_IdMedida     IN     VARCHAR2,
                               Pv_IdCiaOrigen  IN     VARCHAR2,
                               Pv_IdCompania   IN     VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2);

  ------------------------------------------------------------------
  -- Proceso que crea grupo, subgrupo, linea, narcas si no existe --
  ------------------------------------------------------------------
  PROCEDURE IN_P_CREA_PARAMETROS ( Pv_IdGrupo      IN     VARCHAR2,
                                   Pv_IdSubGrupo   IN     VARCHAR2,
                                   Pv_IdLinea      IN     VARCHAR2,
                                   Pv_IdMarca      IN     VARCHAR2,
                                   Pv_IdCiaOrigen  IN     VARCHAR2,
                                   Pv_IdCompania   IN     VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2);

  -----------------------------------------------------
  -- Proceso que crea codigo de arancel si no existe --
  -----------------------------------------------------
  PROCEDURE IN_P_CREA_ARANCEL ( Pv_IdArancel    IN     VARCHAR2,
                                Pv_IdCiaOrigen  IN     VARCHAR2,
                                Pv_IdCompania   IN     VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2);

  ---------------------------------------------------
  -- Proceso que crea area que aplica si no existe --
  ---------------------------------------------------
  PROCEDURE IN_P_CREA_AREA_APLICA ( Pv_IdAreaAplica IN     VARCHAR2,
                                    Pv_IdCiaOrigen  IN     VARCHAR2,
                                    Pv_IdCompania   IN     VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2);

  --------------------------------------------------------
  -- Proceso que crea codigo de consumidor si no existe --
  --------------------------------------------------------
  PROCEDURE IN_P_CREA_CONSUMIDOR ( Pv_IdConsumidor IN     VARCHAR2,
                                    Pv_IdCiaOrigen  IN     VARCHAR2,
                                    Pv_IdCompania   IN     VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2);
  
  --------------------------------------------------
  -- Proceso que crea Grupo Contable si no existe --
  --------------------------------------------------
  PROCEDURE IN_P_CREA_GRUPO_CONTABLE ( Pv_IdGrupoCont IN     VARCHAR2,
                                       Pv_IdCiaOrigen  IN     VARCHAR2,
                                       Pv_IdCompania   IN     VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2);

  -------------------------------------------------
  -- Proceso que crea Tipo Producto si no existe --
  -------------------------------------------------
  PROCEDURE IN_P_CREA_TIPO_PRODUCTO ( Pv_IdTipoProd   IN     VARCHAR2,
                                      Pv_IdCiaOrigen  IN     VARCHAR2,
                                      Pv_IdCompania   IN     VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2);
                                      
  ---------------------------------------------------------
  -- Proceso que crea Presentacion Artículo si no existe --
  ---------------------------------------------------------
  PROCEDURE IN_P_CREA_PRESENTACION ( Pv_IdPresentacion IN     VARCHAR2,
                                     Pv_IdCiaOrigen    IN     VARCHAR2,
                                     Pv_IdCompania     IN     VARCHAR2,
                                     Pv_MensajeError   IN OUT VARCHAR2);

end INK_TRANSFERENCIA_EMPRESAS;
/


CREATE OR REPLACE package body            INK_TRANSFERENCIA_EMPRESAS is

  -----------------------------------------------------------------------
  -- Procedimiento que genera despacho por transferencia entre empresa --
  -----------------------------------------------------------------------
  PROCEDURE IN_P_PROCESA_DESPACHO ( Pv_IdDocumento  IN     VARCHAR2,
                                    Pv_IdCentro     IN     VARCHAR2,
                                    Pv_IdCompania   IN     VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
                                    
    CURSOR C_PARAMETROS IS    
      SELECT ANO_PROCE, 
             MES_PROCE,
             DIA_PROCESO
        FROM ARINCD
       WHERE NO_CIA = Pv_IdCompania
         AND CENTRO = Pv_IdCentro;
    --
    CURSOR C_CLASE_CAMBIO IS
      SELECT CLASE_CAMBIO
        FROM ARCGMC 
       WHERE NO_CIA = Pv_IdCompania;
    --
    CURSOR C_DOCUMENTO IS
      SELECT ID_COMPANIA,
              ID_CENTRO,
              TIPO_DOCUMENTO,
              ID_DOCUMENTO,
              ORIGEN,
              OBSERVACION,
              ID_PRESUPUESTO
        FROM IN_TRANSFERENCIA_EMPRESA 
       WHERE ID_DOCUMENTO = Pv_IdDocumento
         AND ID_CENTRO = Pv_IdCentro
         AND ID_COMPANIA = Pv_IdCompania
         AND ESTADO = 'P';
    --
    CURSOR C_DETALLE_DOCUMENTO IS
      select B.ID_BODEGA, 
             A.ID_COMPANIA,
             A.ID_CENTRO,
             A.ID_DOCUMENTO,
             A.ID_ARTICULO,
             A.CANTIDAD
        from IN_DETALLE_TRANSFERENCIA_EMPR A,
             IN_TRANSFERENCIA_EMPRESA B
       WHERE A.ID_DOCUMENTO = B.ID_DOCUMENTO
         AND A.ID_CENTRO = B.ID_CENTRO
         AND A.ID_COMPANIA = B.ID_COMPANIA
         AND A.ID_DOCUMENTO = Pv_IdDocumento
         AND A.ID_CENTRO = Pv_IdCentro
         AND A.ID_COMPANIA = Pv_IdCompania;

  Lv_AnioProceso   arincd.ano_proce%type;
  Lv_MesProceso    arincd.mes_proce%type;
  Lv_DiaProceso    arincd.dia_proceso%type;
  Ln_Linea         number := 0;
  Le_Error         exception;
  Lr_Arinme        ARINME%ROWTYPE := NULL; 
  Lv_ClaseCambio       arcgmc.clase_cambio%TYPE;
  Ld_Fecha           date;
  --
  BEGIN
    null;
    
    Lr_Arinme := null;
 
    --  Almacena en las variables respectivas la semana en proceso de la
    --  compañía.
    
    OPEN  C_PARAMETROS;
    FETCH C_PARAMETROS INTO Lv_AnioProceso,
                            Lv_MesProceso,
                            Lv_DiaProceso;
    IF C_PARAMETROS%NOTFOUND THEN
      Pv_MensajeError := 'La definición del calendario es incorrecta.';
      RAISE Le_Error;
    END IF;
    CLOSE C_PARAMETROS;
    
    OPEN  C_CLASE_CAMBIO;
    FETCH C_CLASE_CAMBIO INTO Lv_ClaseCambio;
    CLOSE C_CLASE_CAMBIO;  
    Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lv_ClaseCambio, Lv_DiaProceso, Ld_Fecha, 'C');
     
    -- Se recuepran los datos del documento a transferir
    IF C_DOCUMENTO%ISOPEN THEN CLOSE C_DOCUMENTO; END IF;
    OPEN C_DOCUMENTO;
    FETCH C_DOCUMENTO INTO Lr_Arinme.No_Cia,
                           Lr_Arinme.Centro,
                           Lr_Arinme.Tipo_Doc,
                           Lr_Arinme.No_Docu,
                           Lr_Arinme.Origen,
                           Lr_Arinme.Observ1,
                           Lr_Arinme.Id_Presupuesto;
    IF C_DOCUMENTO%NOTFOUND THEN
      Pv_MensajeError := 'No existe documento de transferencia '||Pv_IdDocumento;
      RAISE Le_Error;
    END IF;
    CLOSE C_DOCUMENTO;
    
    --Salida
    Lr_Arinme.No_Fisico    := Consecutivo.INV( Lr_Arinme.No_Cia,  
                                               Lv_AnioProceso, 
                                               Lv_MesProceso, 
                                               Lr_Arinme.Centro, 
                                               Lr_Arinme.Tipo_Doc,
                                               'NUMERO');
    Lr_Arinme.Serie_Fisico := Consecutivo.INV( Lr_Arinme.No_Cia,  
                                               Lv_AnioProceso, 
                                               Lv_MesProceso, 
                                               Lr_Arinme.Centro, 
                                               Lr_Arinme.Tipo_Doc,
                                               'SERIE');
    Lr_Arinme.Periodo := Lv_AnioProceso;
    Lr_Arinme.Fecha := Lv_DiaProceso;
    Lr_Arinme.Ruta := '0000';
    Lr_Arinme.Estado := 'P';
    Lr_Arinme.Usuario := user;
    Lr_Arinme.Fecha_Aplicacion := sysdate;
         
    -- 
    -- Generando Salida   en ARINME y ARINMEH
    -- Registro como referencia, el documento de salida 
    --
    BEGIN
      INSERT INTO ARINME 
                ( NO_CIA,      CENTRO,           TIPO_DOC,
                  TIPO_CAMBIO, PERIODO,          RUTA, 
                  NO_DOCU ,    ESTADO,           FECHA,
                  NO_FISICO,   SERIE_FISICO,     ORIGEN,
                  USUARIO,     FECHA_APLICACION, NUMERO_SOLICITUD, 
                  OBSERV1,     id_presupuesto) 
         VALUES ( Lr_Arinme.No_Cia,      Lr_Arinme.Centro,           Lr_Arinme.Tipo_Doc,
                  Lr_Arinme.Tipo_Cambio, Lr_Arinme.Periodo,          Lr_Arinme.Ruta,
                  Lr_Arinme.No_Docu,     Lr_Arinme.Estado,           Lr_Arinme.Fecha,
                  Lr_Arinme.No_Fisico,   Lr_Arinme.Serie_Fisico,     Lr_Arinme.Origen,
                  Lr_Arinme.Usuario,     Lr_Arinme.Fecha_Aplicacion, Lr_Arinme.No_Docu, 
                  Lr_Arinme.Observ1,     Lr_Arinme.Id_Presupuesto );
                            
    exception
      when others then
        Pv_MensajeError := 'Error insertar arinme: '|| sqlerrm;
        raise Le_Error;
    end;
    
    ---------------------
    -- Procesa detalle --
    ---------------------
    FOR Lr_Detalle in C_DETALLE_DOCUMENTO LOOP
      
      Ln_Linea := Ln_Linea + 1;
      
      BEGIN
        INSERT INTO ARINML
                  ( NO_CIA,      CENTRO,      TIPO_DOC, 
                    PERIODO,     RUTA,        NO_DOCU,
                    LINEA,       LINEA_EXT,   BODEGA,
                    NO_ARTI,     UNIDADES,    TIPO_CAMBIO, 
                    IND_OFERTA )
           VALUES ( Lr_Detalle.id_compania, Lr_Detalle.Id_Centro, Lr_Arinme.Tipo_Doc,
                    Lr_Arinme.Periodo,      Lr_Arinme.Ruta,       Lr_Detalle.Id_Documento,
                    Ln_Linea,               Ln_Linea,             Lr_Detalle.Id_Bodega ,
                    Lr_Detalle.Id_Articulo, Lr_Detalle.Cantidad,  Lr_Arinme.Tipo_Cambio,
                    'N');
      EXCEPTION
        WHEN OTHERS THEN
          Pv_MensajeError := 'Error insertar detalle arinml: '|| sqlerrm;
          RAISE Le_Error;
      END;
    
    -- se inserta el detalle de los numeros de series
    BEGIN
      INSERT INTO INV_DOCUMENTO_SERIE
               ( COMPANIA, ID_DOCUMENTO, LINEA,
                 SERIE,    USUARIO_CREA, FECHA_CREA)
          SELECT ID_COMPANIA,  ID_DOCUMENTO, Ln_Linea,
                 NUMERO_SERIE, USER,         SYSDATE
            FROM IN_SERIE_TRANSFERENCIA_EMPRESA
           WHERE ID_DOCUMENTO = Pv_IdDocumento
             AND ID_CENTRO = Pv_IdCentro
             AND ID_COMPANIA = Pv_IdCompania;
    EXCEPTION
      WHEN OTHERS THEN
      Pv_MensajeError := 'Error insertar detalle INV_DOCUMENTO_SERIE: '|| sqlerrm;
      RAISE Le_Error;
    END;
    
    -- Se cambia estado de numero de serie
    UPDATE INV_NUMERO_SERIE A
       SET A.ESTADO = 'FB',
           A.ID_BODEGA = NULL,
           A.USUARIO_MODIFICA = USER,
           A.FECHA_MODIFICA = SYSDATE
     WHERE EXISTS (SELECT NULL FROM IN_SERIE_TRANSFERENCIA_EMPRESA B
                    WHERE B.NUMERO_SERIE = A.SERIE
                      AND B.ID_ARTICULO = A.NO_ARTICULO
                      AND B.ID_COMPANIA = A.COMPANIA
                      AND B.ID_DOCUMENTO = Pv_IdDocumento
                      AND B.ID_CENTRO = Pv_IdCentro
                      AND B.ID_COMPANIA = Pv_IdCompania);
    END LOOP;
    
    ---------------------------------
    --Genera Movimientos contables --
    ---------------------------------    
    INACTUALIZA( Lr_Arinme.No_Cia,
                 Lr_Arinme.Tipo_Doc,
                 Lr_Arinme.No_Docu,
                 Pv_MensajeError);
    --  
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;  
    END IF;
    
   
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.INP_PROCESA_DESPACHO. '||Sqlerrm;
      rollback;
  END IN_P_PROCESA_DESPACHO;
  
  -------------------------------------------------------------------------------------
  -- proceso que desde la empresa origen genera documento ingreso en empresa destino --
  -------------------------------------------------------------------------------------
  PROCEDURE IN_P_PROCESA_INGRESO_DESTINO ( Pv_IdDocOrigen     IN     VARCHAR2,
                                           Pv_IdCentroOrigen  IN     VARCHAR2,
                                           Pv_IdCiaOrigen     IN     VARCHAR2,
                                           Pv_IdDocDestino    IN OUT VARCHAR2,
                                           Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    CURSOR C_TRANSFERENCIA IS
      SELECT A.ID_COMPANIA_DESTINO, 
             A.ID_CENTRO_DESTINO,
             A.TIPO_DOCUMENTO_DESTINO
        FROM IN_TRANSFERENCIA_EMPRESA A
       WHERE A.ID_DOCUMENTO = Pv_IdDocOrigen
         AND A.ID_CENTRO    = Pv_IdCentroOrigen
         AND A.ID_COMPANIA  = Pv_IdCiaOrigen;
    --
    CURSOR C_FECHA_PROCESO (Cv_IdCentro   VARCHAR2,
                            Cv_IdCompania VARCHAR2) IS
      SELECT DIA_PROCESO, TO_CHAR(DIA_PROCESO,'YYYY') PERIODO
        FROM ARINCD
       WHERE NO_CIA = Cv_IdCompania
         AND CENTRO = Cv_IdCentro;
    --
    CURSOR C_CLASE_CAMBIO (Cv_IdCompania VARCHAR2) IS
      SELECT clase_cambio
        FROM arcgmc
       WHERE no_cia = Cv_IdCompania;
    --
    CURSOR C_MONTO_TOTAL ( Cv_IdDocumento VARCHAR2,
                           Cv_IdCompania  VARCHAR2) IS
      SELECT SUM(A.MONTO) MONTO
        FROM ARINML A
       WHERE A.NO_DOCU = Cv_IdDocumento
         AND A.NO_CIA = Cv_IdCompania;
     
    Le_Error  Exception;
    Lv_FechaAux     date := null;
    --Lr_Trans        in_transferencia_empresa%rowtype := null;
    Lr_Arinme       arinme%rowtype := null;
    Lv_ClaseCambio  arcgmc.clase_cambio%type := null;
    Ln_Monto        arinme.mov_tot%type := 0;
    --Lv_IdEmpDestino in_transferencia_empresa.id_compania_destino%type := null;
    --Lv_IdCenDestino in_transferencia_empresa.id_centro_destino%type := null;
    --
  BEGIN
    -- documento a transferir
    IF C_TRANSFERENCIA%ISOPEN THEN CLOSE C_TRANSFERENCIA; END IF;
    OPEN C_TRANSFERENCIA;
    FETCH C_TRANSFERENCIA INTO Lr_Arinme.No_Cia,
                               Lr_Arinme.Centro,
                               Lr_Arinme.Tipo_Doc;
    IF C_TRANSFERENCIA%NOTFOUND THEN
      Pv_MensajeError := 'No se encontró documento de transferencia: '||Pv_IdCiaOrigen||'- '||Pv_IdDocOrigen;
      Raise Le_Error;
    END IF;
    CLOSE C_TRANSFERENCIA;
    
    -- fecha de proceso compania destino
    IF C_FECHA_PROCESO%ISOPEN THEN CLOSE C_FECHA_PROCESO; END IF;
    OPEN C_FECHA_PROCESO (Lr_Arinme.Centro, Lr_Arinme.No_Cia);
    FETCH C_FECHA_PROCESO INTO Lr_Arinme.Fecha, Lr_Arinme.Periodo;
    IF C_FECHA_PROCESO%NOTFOUND THEN
      Pv_MensajeError := 'No se ha definido fecha de proceso para empresa: '||Pv_IdCiaOrigen||' centro: '||Pv_IdCentroOrigen;
      Raise Le_Error;
    END IF;
    CLOSE C_FECHA_PROCESO;
    --
    IF C_CLASE_CAMBIO%ISOPEN THEN CLOSE C_CLASE_CAMBIO; END IF;
    OPEN C_CLASE_CAMBIO (Lr_Arinme.No_Cia);
    FETCH C_CLASE_CAMBIO INTO Lv_ClaseCambio;
    IF C_CLASE_CAMBIO%NOTFOUND THEN
      Pv_MensajeError := 'No se encontro clase de cambio para empresa: '||Pv_IdCiaOrigen;
      Raise Le_Error;
    END IF;
    CLOSE C_CLASE_CAMBIO;
    -- numero documento
    Lr_Arinme.No_Docu := transa_id.inv(Lr_Arinme.no_cia);
    -- tipo de cambio
    Lr_Arinme.tipo_cambio := Tipo_Cambio(Lv_ClaseCambio,  
                                         Lr_Arinme.Fecha, 
                                         Lv_FechaAux,
                                         'C');
                                      
    -- Asignacion de campos fijo
    Lr_Arinme.Estado := 'P';
    Lr_Arinme.Fecha_Aplicacion := sysdate;
    Lr_Arinme.Usuario := user;
    Lr_Arinme.no_fisico := Lr_Arinme.No_Docu;
    Lr_Arinme.serie_fisico := 0;
    Lr_Arinme.Ruta := '0000';
    Lr_Arinme.Observ1 := 'INGRESO A BODEGA GENERADO AUTOMATICAMENTE DESDE EMPRESA: '||Pv_IdCiaOrigen||', CENTRO: '||Pv_IdCentroOrigen||', DOCUMENTO: '||Pv_IdDocOrigen;
    
    INSERT INTO ARINME 
               (NO_CIA,    CENTRO,       TIPO_DOC,
                NO_DOCU,   FECHA,        OBSERV1,
                PERIODO,   TIPO_CAMBIO,  ESTADO,  
                NO_FISICO, SERIE_FISICO, RUTA,
                USUARIO,   FECHA_APLICACION)
        VALUES (Lr_Arinme.no_cia,    Lr_Arinme.centro,       Lr_Arinme.tipo_doc,
                Lr_Arinme.no_docu,   Lr_Arinme.fecha,        Lr_Arinme.observ1,
                Lr_Arinme.periodo,   Lr_Arinme.tipo_cambio,  Lr_Arinme.estado,
                Lr_Arinme.no_fisico, Lr_Arinme.serie_fisico, Lr_Arinme.ruta,
                Lr_Arinme.usuario,   Lr_Arinme.fecha_aplicacion);
               
    
    IN_P_CARGA_ARTICULOS_DESTINO ( Pv_IdDocOrigen,
                                   Pv_IdCentroOrigen,
                                   Pv_IdCiaOrigen,
                                   Lr_Arinme.no_docu,
                                   Lr_Arinme.centro,
                                   Lr_Arinme.no_cia,
                                   Pv_MensajeError);
    
    IF Pv_MensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    
    -- Actualiza relacion documento ingreso con documento transf
    
    update in_detalle_transferencia_empr a
       set a.id_ingreso_bodega = Lr_Arinme.No_Docu,
           a.tipo_doc_destino = Lr_Arinme.Tipo_Doc,
           a.id_centro_destino = Lr_Arinme.Centro,
           a.id_compania_destino = Lr_Arinme.No_Cia,
           a.estado = 'T'
     where a.id_documento = Pv_IdDocOrigen
       and a.id_centro = Pv_IdCentroOrigen
       and a.id_compania = Pv_IdCiaOrigen;
    
    -- Actualiza montos totales de cabecera
    IF C_MONTO_TOTAL%ISOPEN THEN CLOSE C_MONTO_TOTAL; END IF;
    OPEN C_MONTO_TOTAL(Lr_Arinme.no_docu, Lr_Arinme.no_cia) ;
    FETCH C_MONTO_TOTAL INTO Ln_Monto;
    IF C_MONTO_TOTAL%NOTFOUND THEN
      Ln_Monto := 0;
    END IF;
    CLOSE C_MONTO_TOTAL;
    
    UPDATE ARINME
       SET MONTO_BIENES = Ln_Monto,
           MONTO_DIGITADO_COMPRA = Ln_Monto,
           MOV_TOT = Ln_Monto
     WHERE NO_DOCU = Lr_Arinme.no_docu
       AND NO_CIA = Lr_Arinme.no_cia;
       
    INACTUALIZA( Lr_Arinme.no_cia,
                 Lr_Arinme.Tipo_Doc,
                 Lr_Arinme.No_Docu,
                 Pv_MensajeError);
    
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := 'Cia: '||Lr_Arinme.no_cia||', Doc: '||Lr_Arinme.Tipo_Doc||'-'||Lr_Arinme.No_Docu||'. '||Pv_MensajeError;
      Raise Le_Error;
    END IF;
    
    Pv_IdDocDestino := Lr_Arinme.No_Docu;

  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_PROCESA_INGRESO_DESTINO. '||Sqlerrm;
      rollback;
  END IN_P_PROCESA_INGRESO_DESTINO;
  
  ---------------------------------------------------------------------------
  -- Proceso carga los articulos al ingreso a bodega de la empresa destino --
  ---------------------------------------------------------------------------
  PROCEDURE IN_P_CARGA_ARTICULOS_DESTINO ( Pv_IdDocOrigen     IN     VARCHAR2,
                                           Pv_IdCentroOrigen  IN     VARCHAR2,
                                           Pv_IdCiaOrigen     IN     VARCHAR2,
                                           Pv_IdDocDestino    IN     VARCHAR2,
                                           Pv_IdCentroDestino IN     VARCHAR2,
                                           Pv_IdCiaDestino    IN     VARCHAR2,
                                           Pv_MensajeError    IN OUT VARCHAR2) IS

    --
    CURSOR C_ARTICULOS IS
      SELECT B.ID_BODEGA_DESTINO,
             C.CLASE,
             C.CATEGORIA,
             'N' IND_IV,
             A.ID_ARTICULO,
             A.CANTIDAD,
             (0.01 * A.CANTIDAD) MONTO,
             '000000000' CENTRO_COSTO,
             0 IMPUESTO_L_INCUIDO
        FROM IN_DETALLE_TRANSFERENCIA_EMPR A,
             IN_TRANSFERENCIA_EMPRESA B,
             ARINDA C
       WHERE A.ID_DOCUMENTO = B.ID_DOCUMENTO
         AND A.ID_CENTRO    = B.ID_CENTRO
         AND A.ID_COMPANIA  = B.ID_COMPANIA
         AND A.ID_ARTICULO  = C.NO_ARTI
         AND A.ID_COMPANIA  = C.NO_CIA
         AND A.ID_DOCUMENTO = Pv_IdDocOrigen
         AND A.ID_CENTRO    = Pv_IdCentroOrigen
         AND A.ID_COMPANIA  = Pv_IdCiaOrigen
         AND A.ESTADO = 'P' 
         AND A.ID_INGRESO_BODEGA IS NULL;
    --
    CURSOR C_DOCUMENTO IS
      SELECT A.NO_CIA, A.NO_DOCU, A.CENTRO, A.TIPO_DOC, 
             A.PERIODO, A.RUTA, A.TIPO_CAMBIO, NVL(MAX(B.LINEA),0) LINEA
        FROM ARINME A,
             ARINML B
       WHERE A.NO_DOCU = B.NO_DOCU (+)
         AND A.NO_CIA  = B.NO_CIA (+)
         AND A.NO_DOCU = Pv_IdDocDestino
         AND A.CENTRO  = Pv_IdCentroDestino
         AND A.NO_CIA  = Pv_IdCiaDestino
       GROUP BY A.NO_CIA, A.NO_DOCU, A.CENTRO, A.TIPO_DOC, 
                A.PERIODO, A.RUTA, A.TIPO_CAMBIO;
    --
    Lr_Documento C_DOCUMENTO%ROWTYPE := NULL;
    Le_Error     Exception;
    --
  BEGIN
    IF C_DOCUMENTO%ISOPEN THEN CLOSE C_DOCUMENTO; END IF;
    OPEN C_DOCUMENTO;
    FETCH C_DOCUMENTO INTO Lr_Documento;
    IF C_DOCUMENTO%NOTFOUND THEN
      Pv_MensajeError := 'No existe documento destino '||Pv_IdCiaDestino||'-'||Pv_IdDocDestino;
      Raise Le_Error;
    END IF;
    CLOSE C_DOCUMENTO;

    FOR Lr_Articulo in C_ARTICULOS LOOP
      -- Verificar que exista documento sino se lo crea 
      IN_P_GENERA_ARTICULOS ( Pv_IdDocOrigen,
                              Pv_IdCentroOrigen,
                              Pv_IdCiaOrigen,
                              Pv_IdCiaDestino,
                              Lr_Articulo.Id_Bodega_Destino,-- insertar en arinma
                              Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      Lr_Documento.Linea := nvl(Lr_Documento.Linea,0) + 1;
      
      INSERT INTO ARINML 
                 (NO_CIA,       CENTRO,              TIPO_DOC,
                  PERIODO,      RUTA,                NO_DOCU,
                  LINEA,        LINEA_EXT,           BODEGA,
                  CLASE,        CATEGORIA,           NO_ARTI,
                  IND_IV,       UNIDADES,            MONTO,
                  TIPO_CAMBIO,  MONTO_DOL,           LINEA_ORDEN, 
                  CENTRO_COSTO, IMPUESTO_L_INCLUIDO, TIME_STAMP, 
                  MONTO2,       MONTO2_DOL,          UNIDADES_COMP)
          VALUES (Lr_Documento.no_cia,      Lr_Documento.centro,            Lr_Documento.tipo_doc,
                  Lr_Documento.periodo,     Lr_Documento.ruta,              Lr_Documento.no_docu,
                  Lr_Documento.linea,       Lr_Documento.linea,             Lr_Articulo.Id_Bodega_Destino,
                  Lr_Articulo.Clase,        Lr_Articulo.categoria,          Lr_Articulo.Id_Articulo,
                  Lr_Articulo.ind_iv,       Lr_Articulo.Cantidad,           Lr_Articulo.monto,
                  Lr_Documento.tipo_cambio, Lr_Articulo.monto,              Lr_Documento.linea, 
                  Lr_Articulo.centro_costo, Lr_Articulo.Impuesto_l_Incuido, sysdate, 
                  Lr_Articulo.monto,        Lr_Articulo.monto,              Lr_Articulo.Cantidad);

       
      INSERT INTO INV_DOCUMENTO_SERIE 
                ( COMPANIA,
                  ID_DOCUMENTO,
                  LINEA,
                  SERIE,
                  USUARIO_CREA,
                  FECHA_CREA,
                  MAC )
        SELECT Lr_Documento.no_cia,
               Lr_Documento.No_Docu,
               Lr_Documento.Linea,
               A.NUMERO_SERIE,
               USER,
               SYSDATE,
               NULL
          FROM IN_SERIE_TRANSFERENCIA_EMPRESA A
         WHERE A.ID_ARTICULO = Lr_Articulo.Id_Articulo
           AND A.ID_DOCUMENTO = Pv_IdDocOrigen
           AND A.ID_CENTRO    = Pv_IdCentroOrigen
           AND A.ID_COMPANIA  = Pv_IdCiaOrigen;
 
    END LOOP;
    
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CARGA_ARTICULOS_DESTINO. '||Sqlerrm;
      rollback;
  END IN_P_CARGA_ARTICULOS_DESTINO;


  ------------------------------------------------------------------------------
  -- Proceso que generara los nuevos articulos a la empresa que se transfiere --
  ------------------------------------------------------------------------------
  PROCEDURE IN_P_GENERA_ARTICULOS ( Pv_IdDocOrigen    IN     VARCHAR2,
                                    Pv_IdCentroOrigen IN     VARCHAR2,
                                    Pv_IdCiaOrigen    IN     VARCHAR2,
                                    Pv_IdCompania     IN     VARCHAR2,
                                    Pv_BodegaDestino  IN     VARCHAR2,
                                    Pv_MensajeError   IN OUT VARCHAR2) IS
    --
    CURSOR C_ARTICULO_CREAR IS
      SELECT A.NO_CIA,
             A.CLASE,
             A.CATEGORIA,
             A.NO_ARTI,
             A.DESCRIPCION,
             A.UNIDAD,
             A.PESO,
             A.CODIGO,
             A.MARCA,
             A.GRUPO,
             A.MAXIMO,
             A.MINIMO,
             A.MONEDA_PRECIOBASE,
             A.PRECIOBASE,
             A.IMP_VEN,
             A.FABRICACION,
             A.DISC_EXC,
             A.IND_ACTIVO,
             A.APLICA_IMPUESTO,
             A.NOMBRE_LARGO,
             A.IND_REQUIERE_SERIE,
             A.IND_IMPORTA,
             A.IND_PERMISO_SALUD,
             A.DIVISION,
             A.SUBDIVISION,
             A.LINEA_PRODUCTO,
             A.AREA,
             A.PRESENTACION,
             A.CONSUMIDOR,
             A.CONTROL_SECUENCIA,
             A.CONTENIDO_PRODUCTO,
             SYSDATE                   TSTAMP,
             USER                      USUARIO,
             A.IND_CLASIF,
             A.ALTURA,
             A.ANCHO,
             A.LARGO,
             A.ARMABLE,
             SYSDATE                   FECHA_CREACION,
             A.MODELO,
             A.NOM_GENERICO,
             A.IND_CONTROL_ACTIVO_FIJO,
             A.USADO_INSTALACION,
             A.CODIGO_ARANCEL,
             A.TIPO_PRODUCTO
        FROM ARINDA A
       WHERE A.NO_CIA = Pv_IdCiaOrigen
         AND EXISTS (SELECT NULL FROM IN_DETALLE_TRANSFERENCIA_EMPR B
                      WHERE B.ID_ARTICULO = A.NO_ARTI
                        AND B.ID_COMPANIA = A.NO_CIA
                        AND B.ID_DOCUMENTO = Pv_IdDocOrigen
                        AND B.ID_CENTRO = Pv_IdCentroOrigen)
         AND NOT EXISTS (SELECT NULL FROM ARINDA C
                          WHERE C.NO_ARTI = A.NO_ARTI
                            AND C.NO_CIA = Pv_IdCompania); 
    -- 
    CURSOR C_ARTICULO_BODEGA IS
      SELECT Pv_IdCompania ID_COMPANIA,
             A.NO_ARTI ID_ARTICULO,
             Pv_BodegaDestino ID_BODEGA
        FROM ARINDA A
       WHERE A.NO_CIA = Pv_IdCiaOrigen
         AND EXISTS (SELECT NULL FROM IN_DETALLE_TRANSFERENCIA_EMPR B
                      WHERE B.ID_ARTICULO = A.NO_ARTI
                        AND B.ID_COMPANIA = A.NO_CIA
                        AND B.ID_DOCUMENTO = Pv_IdDocOrigen
                        AND B.ID_CENTRO = Pv_IdCentroOrigen
                     )
         AND NOT EXISTS (SELECT NULL FROM ARINMA C
                          WHERE C.NO_ARTI = A.NO_ARTI
                            AND C.BODEGA = Pv_BodegaDestino
                            AND C.NO_CIA = Pv_IdCompania
                            );
    --
    CURSOR C_NUMEROS_SERIES IS
      SELECT Pv_IdCompania ID_COMPANIA,
             A.NUMERO_SERIE,
             B.NO_ARTICULO,
             Pv_BodegaDestino ID_BODEGA,
             'EB' ESTADO,
             B.MAC,
             USER,
             SYSDATE
       FROM IN_SERIE_TRANSFERENCIA_EMPRESA A,
             INV_NUMERO_SERIE B
       WHERE A.NUMERO_SERIE = B.SERIE
         AND A.ID_ARTICULO = B.NO_ARTICULO
         AND A.ID_COMPANIA  = B.COMPANIA
         AND A.ID_DOCUMENTO = Pv_IdDocOrigen
         AND A.ID_CENTRO    = Pv_IdCentroOrigen
         AND A.ID_COMPANIA  = Pv_IdCiaOrigen;
      
    --
    Le_Error        Exception;
    --
  BEGIN
    -- Se empieza generacion de articulo en nueva empresa.
    FOR Lr_Art in C_ARTICULO_CREAR LOOP
      
      -- se verifica que exista clase
      IN_P_CREA_CLASE_ARTICULO ( Lr_Art.Clase,
                                 Lr_Art.No_Cia,
                                 Pv_IdCompania,
                                 Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- se verifica que exista categoria
      IN_P_CREA_CATEGORIA_ARTICULO ( Lr_Art.Categoria,
                                     Lr_Art.Clase,
                                     Lr_Art.No_Cia,
                                     Pv_IdCompania,
                                     Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica que exista la medida
      IN_P_CREA_MEDIDA ( Lr_Art.Unidad,
                         Lr_Art.No_Cia,
                         Pv_IdCompania,
                         Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica grupo, subgrupo, linea, marca
      IN_P_CREA_PARAMETROS ( Lr_Art.Division,
                             Lr_Art.Subdivision,
                             Lr_Art.Linea_Producto,
                             Lr_Art.Marca,
                             Lr_Art.No_Cia,
                             Pv_IdCompania,
                             Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica arancel
      IN_P_CREA_ARANCEL ( Lr_Art.Codigo_Arancel,
                          Pv_IdCiaOrigen,
                          Pv_IdCompania,
                          Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica area a que aplica
      IN_P_CREA_AREA_APLICA ( Lr_Art.Area,
                              Pv_IdCiaOrigen,
                              Pv_IdCompania,
                              Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica codigo de consumidor
      IN_P_CREA_CONSUMIDOR ( Lr_Art.Consumidor,
                             Pv_IdCiaOrigen,
                             Pv_IdCompania,
                             Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica grupo contable 
      IN_P_CREA_GRUPO_CONTABLE ( Lr_Art.Grupo,
                                 Lr_Art.No_Cia,
                                 Pv_IdCompania,
                                 Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica tipo de producto
      IN_P_CREA_TIPO_PRODUCTO ( Lr_Art.Tipo_Producto,
                                Lr_Art.No_Cia,
                                Pv_IdCompania,
                                Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      -- verifica presentacion
      IN_P_CREA_PRESENTACION ( Lr_Art.Presentacion,
                               Lr_Art.No_Cia,
                               Pv_IdCompania,
                               Pv_MensajeError);
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      
      ----------------------------------------------------------------------------------------------------------------
      -- si no se presentaron novedades en la creacion de los parametros referenciales, se procede a crear articulo --
      ----------------------------------------------------------------------------------------------------------------
      INSERT INTO ARINDA 
                ( NO_CIA,             CLASE,                   CATEGORIA,          NO_ARTI,
                  DESCRIPCION,        UNIDAD,                  PESO,               CODIGO,
                  MARCA,              GRUPO,                   MAXIMO,             MINIMO,
                  MONEDA_PRECIOBASE,  PRECIOBASE,              IMP_VEN,            FABRICACION,
                  DISC_EXC,           IND_ACTIVO,              APLICA_IMPUESTO,    NOMBRE_LARGO,
                  IND_REQUIERE_SERIE, IND_IMPORTA,             IND_PERMISO_SALUD,  DIVISION,
                  SUBDIVISION,        LINEA_PRODUCTO,          AREA,               PRESENTACION,
                  CONSUMIDOR,         CONTROL_SECUENCIA,       CONTENIDO_PRODUCTO, TSTAMP,
                  USUARIO,            IND_CLASIF,              ALTURA,             ANCHO,
                  LARGO,              ARMABLE,                 FECHA_CREACION,     MODELO,
                  NOM_GENERICO,       IND_CONTROL_ACTIVO_FIJO, USADO_INSTALACION,  CODIGO_ARANCEL,
                  TIPO_PRODUCTO )
         VALUES ( Pv_IdCompania,             Lr_Art.clase,                   Lr_Art.categoria,          Lr_Art.no_arti,
                  Lr_Art.descripcion,        Lr_Art.unidad,                  Lr_Art.peso,               Lr_Art.codigo,
                  Lr_Art.marca,              Lr_Art.grupo,                   Lr_Art.maximo,             Lr_Art.minimo,
                  Lr_Art.moneda_preciobase,  Lr_Art.preciobase,              Lr_Art.imp_ven,            Lr_Art.fabricacion,
                  Lr_Art.disc_exc,           Lr_Art.ind_activo,              Lr_Art.aplica_impuesto,    Lr_Art.nombre_largo,
                  Lr_Art.ind_requiere_serie, Lr_Art.ind_importa,             Lr_Art.ind_permiso_salud,  Lr_Art.division,
                  Lr_Art.subdivision,        Lr_Art.linea_producto,          Lr_Art.area,               Lr_Art.presentacion,
                  Lr_Art.consumidor,         Lr_Art.control_secuencia,       Lr_Art.contenido_producto, Lr_Art.tstamp,
                  Lr_Art.usuario,            Lr_Art.ind_clasif,              Lr_Art.altura,             Lr_Art.ancho,
                  Lr_Art.largo,              Lr_Art.armable,                 Lr_Art.fecha_creacion,     Lr_Art.modelo,
                  Lr_Art.nom_generico,       Lr_Art.ind_control_activo_fijo, Lr_Art.usado_instalacion,  Lr_Art.codigo_arancel,
                  Lr_Art.tipo_producto);
      
    END LOOP;
    
    -- ARTICULOS BODEGAS
    FOR Lr_Arinma IN C_ARTICULO_BODEGA LOOP
      --------------------------
      -- Se inserta en ARINMA --
      --------------------------
      INCREA_ARTICULO( Lr_Arinma.Id_Compania,
                       Lr_Arinma.Id_Bodega,
                       Lr_Arinma.Id_Articulo,
                       'S', 
                       Pv_MensajeError);
      
      IF  Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      /*
      INSERT INTO ARINMA 
                ( NO_CIA, BODEGA, NO_ARTI, ACTIVO)
         VALUES ( Lr_Arinma.Id_Compania, Lr_Arinma.Id_Bodega, Lr_Arinma.Id_Articulo, 'S');
      */
    END LOOP;
    
    ---------------------------------------------------------------------------
    -- Ciclo que verifica si exist la serie o es nueva en la empresa destino --
    ---------------------------------------------------------------------------
    FOR Lr_Serie in C_NUMEROS_SERIES LOOP
      
      UPDATE INV_NUMERO_SERIE
         SET ESTADO = Lr_Serie.Estado,
             ID_BODEGA = Lr_Serie.Id_Bodega,
             USUARIO_MODIFICA = user,
             FECHA_MODIFICA = sysdate
       WHERE SERIE = Lr_Serie.Numero_Serie
         AND NO_ARTICULO = Lr_Serie.No_Articulo
         AND COMPANIA = Lr_Serie.Id_Compania
         AND ESTADO = 'FB';
      
      IF SQL%ROWCOUNT = 0 THEN-- no exiate se ingresa 
        BEGIN
          INSERT INTO INV_NUMERO_SERIE
                    ( COMPANIA,     SERIE,     NO_ARTICULO,
                      ID_BODEGA,    ESTADO,    MAC,
                      USUARIO_CREA, FECHA_CREA )
             VALUES ( Lr_Serie.Id_Compania, Lr_Serie.Numero_Serie, Lr_Serie.No_Articulo,
                      Lr_Serie.Id_Bodega,   Lr_Serie.Estado,       Lr_Serie.Mac,
                      USER,                 SYSDATE);
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_GENERA_ARTICULOS. Numero de serie '||Lr_Serie.Numero_Serie||' ya se encuentra habilitado para empresa '||Lr_Serie.Id_Compania;
            Raise Le_Error;
          WHEN OTHERS THEN
            Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_GENERA_ARTICULOS. '||Sqlerrm;
            Raise Le_Error;
        END;
      END IF; -- fin no existe
    END LOOP; --fin numeros de series
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_GENERA_ARTICULOS. '||Sqlerrm;
      rollback;
  END IN_P_GENERA_ARTICULOS;

  -----------------------------------------------------------
  -- Proceso que crea las clases de articulos si no existe --
  -----------------------------------------------------------
  PROCEDURE IN_P_CREA_CLASE_ARTICULO ( Pv_IdClase      IN     VARCHAR2,
                                       Pv_IdCiaOrigen  IN     VARCHAR2,
                                       Pv_IdCompania   IN     VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_CLASE (Cv_IdClase     VARCHAR2,
                    CV_IdCompania  VARCHAR2) IS
      SELECT *
        FROM ARINCA
        WHERE CODIGO = Cv_IdClase
          AND NO_CIA = Cv_IdCompania;
    --
    Lr_Clase        arinca%rowtype := null;
    Lb_InsClase     boolean := false;
    Le_Error        Exception;
    --
  BEGIN
    IF C_CLASE%ISOPEN THEN CLOSE C_CLASE; END IF;
    OPEN C_CLASE (Pv_IdClase, Pv_IdCompania) ;
    FETCH C_CLASE INTO Lr_Clase;
    Lb_InsClase := C_CLASE%NOTFOUND;
    CLOSE C_CLASE;
    
    IF Lb_InsClase THEN
      -- se recuperan datos de clase de compania origen
      IF C_CLASE%ISOPEN THEN CLOSE C_CLASE; END IF;
      OPEN C_CLASE (Pv_IdClase, Pv_IdCiaOrigen) ;
      FETCH C_CLASE INTO Lr_Clase;
      IF C_CLASE%NOTFOUND THEN
        Pv_MensajeError := 'No existe clase a replicar en compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdClase;
        RAISE Le_Error;
      END IF;
      CLOSE C_CLASE;
      
      INSERT INTO ARINCA
                ( NO_CIA,
                  CODIGO, 
                  DESCRIPCION,
                  CONTROL_ESTAD, 
                  APLICA_IMPUESTO,
                  PORC_INV_SEGURIDAD,
                  IND_MAT_PUB )
         VALUES ( Pv_IdCompania,
                  Lr_Clase.codigo, 
                  Lr_Clase.descripcion,
                  Lr_Clase.control_estad, 
                  Lr_Clase.aplica_impuesto,
                  Lr_Clase.porc_inv_seguridad,
                  Lr_Clase.ind_mat_pub);
    END IF;
    
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_CLASE_ARTICULO. '||Sqlerrm;
      rollback;
  end IN_P_CREA_CLASE_ARTICULO;
  
  -----------------------------------------------------------
  -- Proceso que crea las clases de articulos si no existe --
  -----------------------------------------------------------
  PROCEDURE IN_P_CREA_CATEGORIA_ARTICULO ( Pv_IdCategoria  IN     VARCHAR2,
                                           Pv_IdClase      IN     VARCHAR2,
                                           Pv_IdCiaOrigen  IN     VARCHAR2,
                                           Pv_IdCompania   IN     VARCHAR2,
                                           Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_CATEGORIA ( Cv_IdCategoria VARCHAR2,
                         Cv_IdClase     VARCHAR2,
                         Cv_IdCompania  VARCHAR2) IS
      SELECT *
        FROM ARINCAT
        WHERE CODIGO = Cv_IdCategoria
          AND CLASE  = Cv_IdClase
          AND NO_CIA = Cv_IdCompania;
    --
    Lr_Categoria    arincat%rowtype := null;
    Lb_InsCategoria boolean := false;
    Le_Error        Exception;
    --
  BEGIN
    IF C_CATEGORIA%ISOPEN THEN CLOSE C_CATEGORIA; END IF;
    OPEN C_CATEGORIA (Pv_IdCategoria, Pv_IdClase, Pv_IdCompania) ;
    FETCH C_CATEGORIA INTO Lr_Categoria;
    Lb_InsCategoria := C_CATEGORIA%NOTFOUND;
    CLOSE C_CATEGORIA;
    
    IF Lb_InsCategoria THEN
      -- se recuperan datos de clase de compania origen
      IF C_CATEGORIA%ISOPEN THEN CLOSE C_CATEGORIA; END IF;
      OPEN C_CATEGORIA (Pv_IdCategoria, Pv_IdClase, Pv_IdCiaOrigen) ;
      FETCH C_CATEGORIA INTO Lr_Categoria;
      IF C_CATEGORIA%NOTFOUND THEN
        Pv_MensajeError := 'No existe Categoria Artículo a replicar en compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdClase;
        RAISE Le_Error;
      END IF;
      CLOSE C_CATEGORIA;
      
      INSERT INTO ARINCAT
                ( NO_CIA,
                  CLASE,
                  CODIGO,
                  DESCRIPCION)
         VALUES ( Pv_IdCompania,
                  Lr_Categoria.Clase,
                  Lr_Categoria.codigo, 
                  Lr_Categoria.Descripcion);
    END IF;
    
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_CATEGORIA_ARTICULO. '||Sqlerrm;
      rollback;
  end IN_P_CREA_CATEGORIA_ARTICULO;

  ------------------------------------------------------------------------
  -- Proceso que crea las unidades de medidas de articulos si no existe --
  ------------------------------------------------------------------------
  PROCEDURE IN_P_CREA_MEDIDA ( Pv_IdMedida     IN     VARCHAR2,
                               Pv_IdCiaOrigen  IN     VARCHAR2,
                               Pv_IdCompania   IN     VARCHAR2,
                               Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_MEDIDA ( Cv_IdMedida   VARCHAR2,
                         Cv_IdCompania VARCHAR2) IS
      SELECT *
        FROM ARINUM
       WHERE UNIDAD = Cv_IdMedida
         AND NO_CIA = Cv_IdCompania;
    --
    Lr_Medida    arinum%rowtype := null;
    Lb_InsMedida boolean := false;
    Le_Error     Exception;
    --
  BEGIN
    IF C_MEDIDA%ISOPEN THEN CLOSE C_MEDIDA; END IF;
    OPEN C_MEDIDA (Pv_IdMedida, Pv_IdCompania) ;
    FETCH C_MEDIDA INTO Lr_Medida;
    Lb_InsMedida := C_MEDIDA%NOTFOUND;
    CLOSE C_MEDIDA;
    
    IF Lb_InsMedida THEN
      -- se recuperan datos de clase de compania origen
      IF C_MEDIDA%ISOPEN THEN CLOSE C_MEDIDA; END IF;
      OPEN C_MEDIDA (Pv_IdMedida, Pv_IdCiaOrigen) ;
      FETCH C_MEDIDA INTO Lr_Medida;
      IF C_MEDIDA%NOTFOUND THEN
        Pv_MensajeError := 'No existe Unidad de Medida a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdMedida;
        RAISE Le_Error;
      END IF;
      CLOSE C_MEDIDA;
      
      INSERT INTO ARINUM
                ( NO_CIA,
                  UNIDAD,
                  NOM,
                  TIPO,
                  IND_FACT_CANTIDAD,
                  ABREVIATURA, 
                  ACTIVO )
         VALUES ( Pv_IdCompania,
                  Lr_Medida.unidad,
                  Lr_Medida.nom,
                  Lr_Medida.tipo,
                  Lr_Medida.ind_fact_cantidad,
                  Lr_Medida.abreviatura, 
                  Lr_Medida.activo);
    END IF;
    
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_MEDIDA. '||Sqlerrm;
      rollback;
  end IN_P_CREA_MEDIDA;

  ------------------------------------------------------------------
  -- Proceso que crea grupo, subgrupo, linea, narcas si no existe --
  ------------------------------------------------------------------
  PROCEDURE IN_P_CREA_PARAMETROS ( Pv_IdGrupo      IN     VARCHAR2,
                                   Pv_IdSubGrupo   IN     VARCHAR2,
                                   Pv_IdLinea      IN     VARCHAR2,
                                   Pv_IdMarca      IN     VARCHAR2,
                                   Pv_IdCiaOrigen  IN     VARCHAR2,
                                   Pv_IdCompania   IN     VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_GRUPO ( Cv_IdGrupo    VARCHAR2,
                     Cv_IdCompania VARCHAR2) IS
      SELECT *
        FROM ARINDIV
       WHERE DIVISION = Cv_IdGrupo
         AND NO_CIA = Cv_IdCompania;
    --
    CURSOR C_SUBGRUPO ( Cv_IdSubGrupo VARCHAR2,
                        Cv_IdGrupo    VARCHAR2,
                        Cv_IdCompania VARCHAR2) IS
      SELECT *
        FROM ARINSUBDIV A
       WHERE A.SUBDIVISION = Cv_IdSubGrupo
         AND A.DIVISION    = Cv_IdGrupo
         AND A.NO_CIA      = Cv_IdCompania;
    --
    CURSOR C_LINEA ( Cv_IdLinea    VARCHAR2,
                     Cv_IdCompania VARCHAR2) IS
      SELECT *
        FROM LINEA
       WHERE NO_LINEA = Cv_IdLinea 
         AND NO_CIA = Cv_IdCompania;
    --
    CURSOR C_MARCAS ( Cv_IdMarca    VARCHAR2,
                      Cv_IdCompania VARCHAR2) IS
      SELECT *
        FROM MARCAS 
       WHERE CODIGO = Cv_IdMarca
         AND NO_CIA = Cv_IdCompania;
    --
    Lr_Grupo       arindiv%rowtype := null;
    Lr_SubGrupo    arinsubdiv%rowtype := null;
    Lr_Linea       linea%rowtype := null;
    Lr_Marca       marcas%rowtype := null;
    --
    Lb_InsGrupo    boolean := false;
    Lb_InsSubGrupo boolean := false;
    Lb_InsLinea    boolean := false;
    Lb_InsMarca    boolean := false;
    Le_Error       Exception;
    --
  BEGIN
    
    IF C_GRUPO%ISOPEN THEN CLOSE C_GRUPO; END IF;
    OPEN C_GRUPO (Pv_IdGrupo, Pv_IdCompania) ;
    FETCH C_GRUPO INTO Lr_Grupo;
    Lb_InsGrupo := C_GRUPO%NOTFOUND;
    CLOSE C_GRUPO;
    
    IF Lb_InsGrupo THEN
      -- se recuperan datos de clase de compania origen
      IF C_GRUPO%ISOPEN THEN CLOSE C_GRUPO; END IF;
      OPEN C_GRUPO (Pv_IdGrupo, Pv_IdCiaOrigen) ;
      FETCH C_GRUPO INTO Lr_Grupo;
      IF C_GRUPO%NOTFOUND THEN
        Pv_MensajeError := 'No existe Grupo de inventarios a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdGrupo;
        RAISE Le_Error;
      END IF;
      CLOSE C_GRUPO;
      
      INSERT INTO ARINDIV
                ( NO_CIA,
                  DIVISION,
                  DESCRIPCION,
                  TIME_STAMP,
                  ESTADO,
                  REPLICA_AF,
                  SE_DEPRECIA,
                  VIDA_UTIL,
                  REVALORIZA)
         VALUES ( Pv_IdCompania,
                  Lr_Grupo.division,
                  Lr_Grupo.descripcion,
                  sysdate,
                  Lr_Grupo.estado,
                  Lr_Grupo.replica_af,
                  Lr_Grupo.se_deprecia,
                  Lr_Grupo.vida_util,
                  Lr_Grupo.revaloriza);
      
      -- se debe relicar Activo Fijo
      UPDATE ARAFMT A
         SET A.DESCRI = Lr_Grupo.Descripcion,
             A.IND_DEPRECIACION = Lr_Grupo.Se_Deprecia,
             A.IND_REVALORIZA = Lr_Grupo.Revaloriza,
             A.VIDA_UTIL = Lr_Grupo.Vida_Util
       WHERE TIPO = Lr_Grupo.Division
         AND NO_CIA = Pv_IdCompania;
         
      IF SQL%ROWCOUNT = 0 THEN -- no existe en activos fijos
        INSERT INTO ARAFMT 
                  ( NO_CIA,
                    TIPO,
                    DESCRI,
                    IND_DEPRECIACION,
                    IND_REVALORIZA,
                    VIDA_UTIL )
           VALUES ( Pv_IdCompania,
                    Lr_Grupo.Division,
                    Lr_Grupo.Descripcion,
                    Lr_Grupo.Se_Deprecia,
                    Lr_Grupo.Revaloriza,
                    Lr_Grupo.Vida_Util);
      END IF;
    END IF;
    
    --*-*-*-*-*-*-*-*-*-*-*---
    -- se verifica subgrupo --
    --*-*-*-*-*-*-*-*-*-*-*---
    IF C_SUBGRUPO%ISOPEN THEN CLOSE C_SUBGRUPO; END IF;
    OPEN C_SUBGRUPO (Pv_IdSubGrupo, Pv_IdGrupo, Pv_IdCompania) ;
    FETCH C_SUBGRUPO INTO Lr_SubGrupo;
    Lb_InsSubGrupo := C_SUBGRUPO%NOTFOUND;
    CLOSE C_SUBGRUPO;
    IF Lb_InsSubGrupo THEN
      -- se recuperan datos de clase de compania origen
      IF C_SUBGRUPO%ISOPEN THEN CLOSE C_SUBGRUPO; END IF;
      OPEN C_SUBGRUPO (Pv_IdSubGrupo, Pv_IdGrupo, Pv_IdCiaOrigen) ;
      FETCH C_SUBGRUPO INTO Lr_SubGrupo;
      IF C_SUBGRUPO%NOTFOUND THEN
        Pv_MensajeError := 'No existe Sub Grupo de inventarios a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdGrupo||' '||Pv_IdSubGrupo;
        RAISE Le_Error;
      END IF;
      CLOSE C_SUBGRUPO;
      
      INSERT INTO ARINSUBDIV
                ( NO_CIA,
                  DIVISION,
                  SUBDIVISION,
                  DESCRIPCION,
                  TIME_STAMP,
                  ESTADO) 
         VALUES ( Pv_IdCompania,
                  Lr_SubGrupo.Division,
                  Lr_SubGrupo.Subdivision,
                  Lr_Grupo.descripcion,
                  sysdate,
                  'A');
      
      -- se debe replicar Activo Fijo
      UPDATE ARAFGR A
         SET A.DESCRI = Lr_SubGrupo.Descripcion
       WHERE GRUPO = Lr_SubGrupo.Subdivision
         AND TIPO = Lr_SubGrupo.Division
         AND NO_CIA = Pv_IdCompania;
         
      IF SQL%ROWCOUNT = 0 THEN -- no existe en activos fijos
        INSERT INTO ARAFGR
                  ( NO_CIA,
                    TIPO,
                    GRUPO,
                    DESCRI)
           VALUES ( Pv_IdCompania,
                    Lr_SubGrupo.Division,
                    Lr_SubGrupo.Subdivision,
                    Lr_Grupo.Descripcion);
      END IF;
    END IF;

    --*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*---
    -- se verifica Linea de Articulos --
    --*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*---
    IF C_LINEA%ISOPEN THEN CLOSE C_LINEA; END IF;
    OPEN C_LINEA (Pv_IdLinea, Pv_IdCompania) ;
    FETCH C_LINEA INTO Lr_Linea;
    Lb_InsLinea := C_LINEA%NOTFOUND;
    CLOSE C_LINEA;
    
    IF Lb_InsLinea THEN
      -- se recuperan datos de clase de compania origen
      IF C_LINEA%ISOPEN THEN CLOSE C_LINEA; END IF;
      OPEN C_LINEA (Pv_IdLinea, Pv_IdCiaOrigen) ;
      FETCH C_LINEA INTO Lr_Linea;
      IF C_LINEA%NOTFOUND THEN
        Pv_MensajeError := 'No existe Linea de Producto inventarios a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdLinea;
        RAISE Le_Error;
      END IF;
      CLOSE C_LINEA;
      
      INSERT INTO LINEA
                ( NO_CIA,
                  NO_LINEA,
                  DESCRIPCION,
                  DIVISION,
                  SUBDIVISION ) 
         VALUES ( Pv_IdCompania,
                  Lr_Linea.No_Linea,
                  Lr_Linea.descripcion,
                  Lr_Linea.division,
                  Lr_Linea.subdivision);
      
      -- se debe replicar Activo Fijo
      IF Lr_Linea.division IS NOT NULL AND Lr_Linea.subdivision IS NOT NULL THEN
        
        Lr_Linea.No_Linea := lpad(to_number(Lr_Linea.No_Linea), 3, '0');
        
        UPDATE ARAFSG A
           SET A.DESCRI = Lr_Linea.Descripcion
         WHERE SUBGRUPO = Lr_Linea.No_Linea
           AND GRUPO    = Lr_Linea.Subdivision
           AND TIPO     = Lr_Linea.Division
           AND NO_CIA   = Pv_IdCompania;
           
        IF SQL%ROWCOUNT = 0 THEN -- no existe en activos fijos
          INSERT INTO ARAFSG
                    ( NO_CIA,
                      TIPO,
                      GRUPO,
                      SUBGRUPO,
                      DESCRI)
             VALUES ( Pv_IdCompania,
                      Lr_Linea.Division,
                      Lr_Linea.Subdivision,
                      Lr_Linea.No_Linea,
                      Lr_Linea.Descripcion);
        END IF; -- fin actualizacion
      END IF; --fin grupo subgrupo no nulo
    END IF;-- fin inserta registro

    --*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*---
    -- se verifica Marca de articulos --
    --*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*---
    IF C_MARCAS%ISOPEN THEN CLOSE C_MARCAS; END IF;
    OPEN C_MARCAS (Pv_IdMarca, Pv_IdCompania) ;
    FETCH C_MARCAS INTO Lr_Marca;
    Lb_InsMarca := C_MARCAS%NOTFOUND;
    CLOSE C_MARCAS;
    IF Lb_InsMarca THEN
      -- se recuperan datos de clase de compania origen
      IF C_MARCAS%ISOPEN THEN CLOSE C_MARCAS; END IF;
      OPEN C_MARCAS (Pv_IdMarca, Pv_IdCiaOrigen) ;
      FETCH C_MARCAS INTO Lr_Marca;
      IF C_MARCAS%NOTFOUND THEN
        Pv_MensajeError := 'No existe Marca de inventarios a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdGrupo||' '||Pv_IdMarca;
        RAISE Le_Error;
      END IF;
      CLOSE C_MARCAS;
      
      INSERT INTO MARCAS
                ( NO_CIA,
                  CODIGO,
                  DESCRIPCION) 
         VALUES ( Pv_IdCompania,
                  Lr_Marca.Codigo,
                  Lr_Marca.descripcion);
      
      -- se debe replicar Activo Fijo
      UPDATE AF_MARCAS
         SET DESCRIPCION = Lr_Marca.Descripcion
       WHERE COD_MARCA = TO_NUMBER(Lr_Marca.Codigo)
         AND NO_CIA = Pv_IdCompania;
         
      IF SQL%ROWCOUNT = 0 THEN -- no existe en activos fijos
        INSERT INTO AF_MARCAS
                  ( NO_CIA,
                    COD_MARCA,
                    DESCRIPCION)
           VALUES ( Pv_IdCompania,
                    TO_NUMBER(Lr_Marca.Codigo),
                    Lr_Marca.Descripcion);
      END IF;
    END IF;
    
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_PARAMETROS. '||Sqlerrm;
      rollback;
  end IN_P_CREA_PARAMETROS;
    
  -----------------------------------------------------
  -- Proceso que crea codigo de arancel si no existe --
  -----------------------------------------------------
  PROCEDURE IN_P_CREA_ARANCEL ( Pv_IdArancel    IN     VARCHAR2,
                                Pv_IdCiaOrigen  IN     VARCHAR2,
                                Pv_IdCompania   IN     VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_ARANCEL ( Cv_IdArancel VARCHAR2,
                       Cv_IdEmpresa VARCHAR2) IS
      SELECT *
        FROM ARIMARANCEL
       WHERE COD_ARANCEL = Cv_IdArancel
         AND NO_CIA      = Cv_IdEmpresa;
    --
    Lr_Arancel    arimarancel%rowtype := null;
    Lb_InsArancel boolean := false;
    Le_Error      Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdArancel IS NULL THEN
      RETURN;
    END IF;
    
    IF C_ARANCEL%ISOPEN THEN CLOSE C_ARANCEL; END IF;
    OPEN C_ARANCEL (Pv_IdArancel, Pv_IdCompania) ;
    FETCH C_ARANCEL INTO Lr_Arancel;
    Lb_InsArancel := C_ARANCEL%NOTFOUND;
    CLOSE C_ARANCEL;
    
    IF Lb_InsArancel THEN
      -- se recuperan datos de clase de compania origen
      IF C_ARANCEL%ISOPEN THEN CLOSE C_ARANCEL; END IF;
      OPEN C_ARANCEL (Pv_IdArancel, Pv_IdCiaOrigen) ;
      FETCH C_ARANCEL INTO Lr_Arancel;
      IF C_ARANCEL%NOTFOUND THEN
        Pv_MensajeError := 'No existe Código Arancel a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdArancel;
        RAISE Le_Error;
      END IF;
      CLOSE C_ARANCEL;
      
      INSERT INTO ARIMARANCEL
                ( NO_CIA,
                  COD_ARANCEL,
                  POR_ARANCEL,
                  DESCRIPCION,
                  DIGITO,
                  SALVAG,
                  FODINFA,
                  UFIS,
                  COD_RES,
                  COD_ORES,
                  CONDIC,
                  PORC_IVA,
                  TEXTOIVA,
                  SIINEN,
                  INEN,
                  ESTADO,
                  PORC_IVA_2,
                  APLICA_ICE,
                  PORC_ICE )
         VALUES ( Pv_IdCompania,
                  Lr_Arancel.cod_arancel,
                  Lr_Arancel.por_arancel,
                  Lr_Arancel.descripcion,
                  Lr_Arancel.digito,
                  Lr_Arancel.salvag,
                  Lr_Arancel.fodinfa,
                  Lr_Arancel.ufis,
                  Lr_Arancel.cod_res,
                  Lr_Arancel.cod_ores,
                  Lr_Arancel.condic,
                  Lr_Arancel.porc_iva,
                  Lr_Arancel.textoiva,
                  Lr_Arancel.siinen,
                  Lr_Arancel.inen,
                  Lr_Arancel.estado,
                  Lr_Arancel.porc_iva_2,
                  Lr_Arancel.aplica_ice,
                  Lr_Arancel.porc_ice);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_ARANCEL. '||Sqlerrm;
      rollback;
  END IN_P_CREA_ARANCEL;
  
  ---------------------------------------------------
  -- Proceso que crea area que aplica si no existe --
  ---------------------------------------------------
  PROCEDURE IN_P_CREA_AREA_APLICA ( Pv_IdAreaAplica IN     VARCHAR2,
                                    Pv_IdCiaOrigen  IN     VARCHAR2,
                                    Pv_IdCompania   IN     VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_AREA_APLICA ( Cv_IdArea    VARCHAR2,
                           Cv_IdEmpresa VARCHAR2) IS
      SELECT *
        FROM AREA_APLICA
       WHERE NO_AREA = Cv_IdArea
         AND NO_CIA  = Cv_IdEmpresa;
    --
    Lr_AreaAplica area_aplica%rowtype := null;
    Lb_InsArancel boolean := false;
    Le_Error      Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdAreaAplica IS NULL THEN
      RETURN;
    END IF;
    
    IF C_AREA_APLICA%ISOPEN THEN CLOSE C_AREA_APLICA; END IF;
    OPEN C_AREA_APLICA (Pv_IdAreaAplica, Pv_IdCompania) ;
    FETCH C_AREA_APLICA INTO Lr_AreaAplica;
    Lb_InsArancel := C_AREA_APLICA%NOTFOUND;
    CLOSE C_AREA_APLICA;
    
    IF Lb_InsArancel THEN
      -- se recuperan datos de clase de compania origen
      IF C_AREA_APLICA%ISOPEN THEN CLOSE C_AREA_APLICA; END IF;
      OPEN C_AREA_APLICA (Pv_IdAreaAplica, Pv_IdCiaOrigen) ;
      FETCH C_AREA_APLICA INTO Lr_AreaAplica;
      IF C_AREA_APLICA%NOTFOUND THEN
        Pv_MensajeError := 'No existe Area que Aplica a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdAreaAplica;
        RAISE Le_Error;
      END IF;
      CLOSE C_AREA_APLICA;
      
      INSERT INTO AREA_APLICA
                ( NO_CIA,
                  NO_AREA,
                  DESCRIPCION )
         VALUES ( Pv_IdCompania,
                  Lr_AreaAplica.no_area,
                  Lr_AreaAplica.descripcion);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_AREA_APLICA. '||Sqlerrm;
      rollback;
  END IN_P_CREA_AREA_APLICA;  
  
  --------------------------------------------------------
  -- Proceso que crea codigo de consumidor si no existe --
  --------------------------------------------------------
  PROCEDURE IN_P_CREA_CONSUMIDOR ( Pv_IdConsumidor IN     VARCHAR2,
                                    Pv_IdCiaOrigen  IN     VARCHAR2,
                                    Pv_IdCompania   IN     VARCHAR2,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_CONSUMIDOR ( Cv_IdConsumidor    VARCHAR2,
                          Cv_IdEmpresa VARCHAR2) IS
      SELECT *
        FROM CONSUMIDOR
       WHERE NO_CONSUMIDOR = Cv_IdConsumidor
         AND NO_CIA        = Cv_IdEmpresa;
    --
    Lr_Consumidor    consumidor%rowtype := null;
    Lb_InsConsumidor boolean := false;
    Le_Error         Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdConsumidor IS NULL THEN
      RETURN;
    END IF;
    
    IF C_CONSUMIDOR%ISOPEN THEN CLOSE C_CONSUMIDOR; END IF;
    OPEN C_CONSUMIDOR (Pv_IdConsumidor, Pv_IdCompania) ;
    FETCH C_CONSUMIDOR INTO Lr_Consumidor;
    Lb_InsConsumidor := C_CONSUMIDOR%NOTFOUND;
    CLOSE C_CONSUMIDOR;
    
    IF Lb_InsConsumidor THEN
      -- se recuperan datos de clase de compania origen
      IF C_CONSUMIDOR%ISOPEN THEN CLOSE C_CONSUMIDOR; END IF;
      OPEN C_CONSUMIDOR (Pv_IdConsumidor, Pv_IdCiaOrigen) ;
      FETCH C_CONSUMIDOR INTO Lr_Consumidor;
      IF C_CONSUMIDOR%NOTFOUND THEN
        Pv_MensajeError := 'No existe Código Consumidor a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdConsumidor;
        RAISE Le_Error;
      END IF;
      CLOSE C_CONSUMIDOR;
      
      INSERT INTO CONSUMIDOR
                ( NO_CIA,
                  NO_CONSUMIDOR,
                  DESCRIPCION )
         VALUES ( Pv_IdCompania,
                  Lr_Consumidor.no_consumidor,
                  Lr_Consumidor.descripcion);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_CONSUMIDOR. '||Sqlerrm;
      rollback;
  END IN_P_CREA_CONSUMIDOR;

  --------------------------------------------------
  -- Proceso que crea Grupo Contable si no existe --
  --------------------------------------------------
  PROCEDURE IN_P_CREA_GRUPO_CONTABLE ( Pv_IdGrupoCont IN     VARCHAR2,
                                       Pv_IdCiaOrigen  IN     VARCHAR2,
                                       Pv_IdCompania   IN     VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_GRUPO_CONTABLE ( Cv_IdGrupoCont    VARCHAR2,
                              Cv_IdEmpresa VARCHAR2) IS
      SELECT *
        FROM GRUPOS
       WHERE GRUPO  = Cv_IdGrupoCont
         AND NO_CIA = Cv_IdEmpresa;
    --
    Lr_GrupoCont    grupos%rowtype := null;
    Lb_InsGrupoCont boolean := false;
    Le_Error        Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdGrupoCont IS NULL THEN
      RETURN;
    END IF;
    
    IF C_GRUPO_CONTABLE%ISOPEN THEN CLOSE C_GRUPO_CONTABLE; END IF;
    OPEN C_GRUPO_CONTABLE (Pv_IdGrupoCont, Pv_IdCompania) ;
    FETCH C_GRUPO_CONTABLE INTO Lr_GrupoCont;
    Lb_InsGrupoCont := C_GRUPO_CONTABLE%NOTFOUND;
    CLOSE C_GRUPO_CONTABLE;
    
    IF Lb_InsGrupoCont THEN
      -- se recuperan datos de clase de compania origen
      IF C_GRUPO_CONTABLE%ISOPEN THEN CLOSE C_GRUPO_CONTABLE; END IF;
      OPEN C_GRUPO_CONTABLE (Pv_IdGrupoCont, Pv_IdCiaOrigen) ;
      FETCH C_GRUPO_CONTABLE INTO Lr_GrupoCont;
      IF C_GRUPO_CONTABLE%NOTFOUND THEN
        Pv_MensajeError := 'No existe Grupo Contable a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdGrupoCont;
        RAISE Le_Error;
      END IF;
      CLOSE C_GRUPO_CONTABLE;
      
      INSERT INTO GRUPOS
                ( NO_CIA,
                  GRUPO,
                  DESCRIPCION,
                  METODO_COSTO,
                  IND_PROD_SERV,
                  REQUISICION)
         VALUES ( Pv_IdCompania,
                  Lr_GrupoCont.grupo,
                  Lr_GrupoCont.descripcion,
                  Lr_GrupoCont.metodo_costo,
                  Lr_GrupoCont.ind_prod_serv,
                  Lr_GrupoCont.requisicion);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_GRUPO_CONTABLE. '||Sqlerrm;
      rollback;
  END IN_P_CREA_GRUPO_CONTABLE;  

  -------------------------------------------------
  -- Proceso que crea Tipo Producto si no existe --
  -------------------------------------------------
  PROCEDURE IN_P_CREA_TIPO_PRODUCTO ( Pv_IdTipoProd   IN     VARCHAR2,
                                      Pv_IdCiaOrigen  IN     VARCHAR2,
                                      Pv_IdCompania   IN     VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_TIPO_PRODUCTO ( Cv_IdTipoProd    VARCHAR2,
                             Cv_IdEmpresa VARCHAR2) IS
      SELECT *
        FROM ARIMTIPPRODUC
       WHERE TIPO_PRODUCTO = Cv_IdTipoProd
         AND NO_CIA        = Cv_IdEmpresa;
    --
    Lr_TipoProd    arimtipproduc%rowtype := null;
    Lb_InsTipoProd boolean := false;
    Le_Error       Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdTipoProd IS NULL THEN
      RETURN;
    END IF;
    
    IF C_TIPO_PRODUCTO%ISOPEN THEN CLOSE C_TIPO_PRODUCTO; END IF;
    OPEN C_TIPO_PRODUCTO (Pv_IdTipoProd, Pv_IdCompania) ;
    FETCH C_TIPO_PRODUCTO INTO Lr_TipoProd;
    Lb_InsTipoProd := C_TIPO_PRODUCTO%NOTFOUND;
    CLOSE C_TIPO_PRODUCTO;
    
    IF Lb_InsTipoProd THEN
      -- se recuperan datos de clase de compania origen
      IF C_TIPO_PRODUCTO%ISOPEN THEN CLOSE C_TIPO_PRODUCTO; END IF;
      OPEN C_TIPO_PRODUCTO (Pv_IdTipoProd, Pv_IdCiaOrigen) ;
      FETCH C_TIPO_PRODUCTO INTO Lr_TipoProd;
      IF C_TIPO_PRODUCTO%NOTFOUND THEN
        Pv_MensajeError := 'No existe Tipo Producto a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdTipoProd;
        RAISE Le_Error;
      END IF;
      CLOSE C_TIPO_PRODUCTO;
      
      INSERT INTO ARIMTIPPRODUC
                ( NO_CIA,
                  TIPO_PRODUCTO,
                  DESCRIPCION)
         VALUES ( Pv_IdCompania,
                  Lr_TipoProd.tipo_producto,
                  Lr_TipoProd.descripcion);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_TIPO_PRODUCTO. '||Sqlerrm;
      rollback;
  END IN_P_CREA_TIPO_PRODUCTO;  

  ---------------------------------------------------------
  -- Proceso que crea Presentacion Artículo si no existe --
  ---------------------------------------------------------
  PROCEDURE IN_P_CREA_PRESENTACION ( Pv_IdPresentacion IN     VARCHAR2,
                                     Pv_IdCiaOrigen    IN     VARCHAR2,
                                     Pv_IdCompania     IN     VARCHAR2,
                                     Pv_MensajeError   IN OUT VARCHAR2) IS
    --
    CURSOR C_PRESENTACION ( Cv_IdPresentacion VARCHAR2,
                            Cv_IdEmpresa      VARCHAR2) IS
      SELECT *
        FROM PRESENTACION
       WHERE NO_PRESENTACION = Cv_IdPresentacion
         AND NO_CIA          = Cv_IdEmpresa;
    --
    Lr_Presentacion    presentacion%rowtype := null;
    Lb_InsPresentacion boolean := false;
    Le_Error           Exception;
    --
  BEGIN
    
    Pv_MensajeError := null;
    
    IF Pv_IdPresentacion IS NULL THEN
      RETURN;
    END IF;
    
    IF C_PRESENTACION%ISOPEN THEN CLOSE C_PRESENTACION; END IF;
    OPEN C_PRESENTACION (Pv_IdPresentacion, Pv_IdCompania) ;
    FETCH C_PRESENTACION INTO Lr_Presentacion;
    Lb_InsPresentacion := C_PRESENTACION%NOTFOUND;
    CLOSE C_PRESENTACION;
    
    IF Lb_InsPresentacion THEN
      -- se recuperan datos de clase de compania origen
      IF C_PRESENTACION%ISOPEN THEN CLOSE C_PRESENTACION; END IF;
      OPEN C_PRESENTACION (Pv_IdPresentacion, Pv_IdCiaOrigen) ;
      FETCH C_PRESENTACION INTO Lr_Presentacion;
      IF C_PRESENTACION%NOTFOUND THEN
        Pv_MensajeError := 'No existe Presentación Artículo a replicar desde compañía origen '||Pv_IdCiaOrigen||' '||Pv_IdPresentacion;
        RAISE Le_Error;
      END IF;
      CLOSE C_PRESENTACION;
      
      INSERT INTO PRESENTACION
                ( NO_CIA,
                  NO_PRESENTACION,
                  DESCRIPCION)
         VALUES ( Pv_IdCompania,
                  Lr_Presentacion.no_presentacion,
                  Lr_Presentacion.descripcion);
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      rollback;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_TRANSFERENCIA_EMPRESAS.IN_P_CREA_PRESENTACION. '||Sqlerrm;
      rollback;
  END IN_P_CREA_PRESENTACION; 
  
end INK_TRANSFERENCIA_EMPRESAS;
/
