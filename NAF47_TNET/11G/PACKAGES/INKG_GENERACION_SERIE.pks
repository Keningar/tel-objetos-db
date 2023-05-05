CREATE OR REPLACE PACKAGE            INKG_GENERACION_SERIE IS 
  /**
  * Documentacion para P_PROCESA_SERIE
  * Procedure que registra los números de series de un producto seleccionado.
  * @author Antonio Ayala Torres <afayala@telconet.ec>
  * @version 1.0 11/04/2019
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 05/08/2021 - Se modifica para agregar parametro que recibe unidades por serie 
  *                           y usar nuevo proceso que genera serie en base a formato
  *
  * @param  Pv_NoCia          IN varchar2  Recibe el codigo de la compañía
  * @param  Pv_NoArticulo     IN varchar2  Recibe el articulo
  * @param  Pv_IdBodega       IN varchar2  Recibe la bodega donde se va a generar las series
  * @param  Pv_Ubicacion      IN varchar2  Recibe la ubicación del artículo
  * @param  Pv_CantidadSeries IN varchar2  Recibe la cantidad de series a generar
  * @param  Pv_Error          IN varchar2  Mensajes de error si se generan
  * @param  Pn_UnidadSerie    IN varchar2  Recibe número de unidades que representa cada serie, por defecto es 1

  */
  PROCEDURE P_PROCESA_SERIE ( Pv_NoCia          IN VARCHAR2,
                              Pv_NoArticulo     IN VARCHAR2,
                              Pv_IdBodega       IN VARCHAR2,
                              Pv_Ubicacion      IN VARCHAR2,
                              Pv_CantidadSeries IN NUMBER,
                              Pv_Error          IN OUT VARCHAR2,
                              Pn_UnidadSerie    IN NUMBER DEFAULT 1);
  /**
  * Documentacion para P_FORMATO
  * Procedure genera el numero de serie en base al formatod efinido en el artículo.
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 25/08/2021
  *
  * @param  Pn_FormatoId    IN varchar2  Recibe el codigo del formato del artículo
  * @param  Pn_Cantidad     IN varchar2  Recibe la cantidad segmentada del número de serie
  * @param  Pb_InsertaSerie IN varchar2  Indica si el número de serie se insreta en el maestro de series
  * @param  Pv_NumeroSerie  IN OUT varchar2  Retorna el número de serie generado
  * @param  Pv_Error        IN OUT varchar2  Mensajes de error si se generan
  */
  PROCEDURE P_FORMATO( Pn_FormatoId    IN NUMBER,
                       Pn_Cantidad     IN NUMBER,
                       Pb_InsertaSerie IN BOOLEAN,
                       Pv_NumeroSerie  IN OUT VARCHAR2,
                       Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_SERIE_FORMATO_GENERAL
  * Procedure genera el numero de serie recuperando de las configuraciones cual esta definido como formato general 
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 05/01/2022
  *
  * @param  Pv_ArticuloId   IN varchar2      Recibe el codigo del artículo para generar serie
  * @param  Pn_Cantidad     IN varchar2      Recibe la cantidad segmentada del número de serie
  * @param  Pb_InsertaSerie IN varchar2      Indica si el número de serie se insreta en el maestro de series
  * @param  Pv_EmpresaId    IN varchar2      Recibe el codigo de la compañía
  * @param  Pv_NumeroSerie  IN OUT varchar2  Retorna el número de serie generado
  * @param  Pv_Error        IN OUT varchar2  Mensajes de error si se generan
  */
  PROCEDURE P_SERIE_FORMATO_GENERAL( Pv_ArticuloId   IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pb_InsertaSerie IN BOOLEAN,
                                     Pv_EmpresaId    IN VARCHAR2,
                                     Pv_NumeroSerie  IN OUT VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2);



END INKG_GENERACION_SERIE;
/


CREATE OR REPLACE PACKAGE BODY            INKG_GENERACION_SERIE IS
  -- Procedimiento que genera las series de un artículo 
  PROCEDURE P_PROCESA_SERIE ( Pv_NoCia          IN VARCHAR2,
                              Pv_NoArticulo     IN VARCHAR2,
                              Pv_IdBodega       IN VARCHAR2,
                              Pv_Ubicacion      IN VARCHAR2,
                              Pv_CantidadSeries IN NUMBER,
                              Pv_Error          IN OUT VARCHAR2,
                              Pn_UnidadSerie    IN NUMBER DEFAULT 1) IS
    -- Cursor que consulta serie generada por fecha actual
    CURSOR C_DATOS_ARTICULO IS
      SELECT FORMATO_SERIE_ID
      FROM NAF47_TNET.ARINDA
      WHERE NO_ARTI = Pv_NoArticulo
      AND NO_CIA = Pv_NoCia;
    --
    Lr_DatosArticulo  C_DATOS_ARTICULO%ROWTYPE;
    Lr_NumeroSerie    NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE := NULL;
    Le_Error          EXCEPTION;                            
  BEGIN
    --
    IF C_DATOS_ARTICULO%ISOPEN THEN
      CLOSE C_DATOS_ARTICULO;
    END IF;
    OPEN C_DATOS_ARTICULO;
    FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
    IF C_DATOS_ARTICULO%NOTFOUND THEN
      Pv_Error := 'No se encontró articulo '||Pv_NoArticulo;
      RAISE Le_Error;
    END IF;
    CLOSE C_DATOS_ARTICULO;
    --
    NAF47_TNET.GEK_VAR.P_SET_COMPANIA_ID(Pv_NoCia);
    NAF47_TNET.GEK_VAR.P_SET_ARTICULO_ID(Pv_NoArticulo);
    --

    -- Se generan series del producto seleccionado
    FOR i IN 1..Pv_CantidadSeries LOOP
      --
      NAF47_TNET.INKG_GENERACION_SERIE.P_FORMATO( Pn_FormatoId => Lr_DatosArticulo.Formato_Serie_Id,
                                                  Pn_Cantidad => Pn_UnidadSerie,
                                                  Pb_InsertaSerie => FALSE,
                                                  Pv_NumeroSerie => Lr_NumeroSerie.Serie,
                                                  Pv_MensajeError => Pv_Error);
      --
      IF Pv_Error IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      Lr_NumeroSerie.Compania       := Pv_NoCia;
      Lr_NumeroSerie.No_Articulo    := Pv_NoArticulo;
      Lr_NumeroSerie.Id_Bodega      := Pv_IdBodega;
      Lr_NumeroSerie.Estado         := 'EB';
      Lr_NumeroSerie.Mac            := null;
      Lr_NumeroSerie.Origen         := 'E';
      Lr_NumeroSerie.Ubicacion      := Pv_Ubicacion;
      Lr_NumeroSerie.Unidades       := Pn_UnidadSerie;
      Lr_NumeroSerie.Serie_Anterior := null;
      Lr_NumeroSerie.Usuario_Crea   := user;
      Lr_NumeroSerie.Fecha_Crea     := sysdate;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE (Lr_NumeroSerie,Pv_Error);
          --
      IF Pv_Error IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;      
    --             
  EXCEPTION
    WHEN Le_Error THEN
      Pv_Error := 'Error en INKG_GENERACION_SERIE.P_PROCESA_SERIE. '||Pv_Error;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Error := 'Error en INKG_GENERACION_SERIE.P_PROCESA_SERIE. '||SQLERRM;
      ROLLBACK;  
  END P_PROCESA_SERIE;
  --
  --
  PROCEDURE P_FORMATO( Pn_FormatoId    IN NUMBER,
                       Pn_Cantidad     IN NUMBER,
                       Pb_InsertaSerie IN BOOLEAN,
                       Pv_NumeroSerie  IN OUT VARCHAR2,
                       Pv_MensajeError IN OUT VARCHAR2) IS
    --
    DETALLE_FORMATO_SERIE  CONSTANT VARCHAR2(21) := 'DETALLE-FORMATO-SERIE';
    PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
    --
    CURSOR C_DETALLE_FORMATO IS
      SELECT APD.VALOR4 AS TIPO,
             APD.VALOR5 AS NOMBRE,
             APD.VALOR1 AS VALORES,
             APD.ESTADO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.VALOR2 = TO_CHAR(Pn_FormatoId)
      AND APD.DESCRIPCION = DETALLE_FORMATO_SERIE
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS) 
      ORDER BY TO_NUMBER(VALOR3);
    --
    CURSOR C_DATOS_ARTICULO (Cv_NoArticulo VARCHAR2,
                             Cv_NoCia      VARCHAR2) IS
      SELECT DA.IND_REQUIERE_SERIE,
             DA.GENERA_NUMERO_SERIE,
             DA.IND_MAC
      FROM NAF47_TNET.ARINDA DA
      WHERE DA.NO_ARTI = Cv_NoArticulo
      AND DA.NO_CIA = Cv_NoCia;
    --
    --
    Lv_NoArticulo    NAF47_TNET.ARINDA.NO_ARTI%TYPE := NAF47_TNET.GEK_VAR.F_GET_ARTICULO_ID;
    Lv_NoCia         NAF47_TNET.ARINDA.NO_CIA%TYPE := NAF47_TNET.GEK_VAR.F_GET_COMPANIA_ID;
    Lv_ExtractoSerie VARCHAR2(3000);
    --
    Lt_Resultado     SYS_REFCURSOR;
    Lr_NumeroSerie    NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE;
    Lr_DatosArticulo C_DATOS_ARTICULO%ROWTYPE;
    --
    Le_Error         EXCEPTION;
    --
  BEGIN
    --
    Pv_NumeroSerie :=  NULL;
    --
    IF C_DATOS_ARTICULO%ISOPEN THEN
      CLOSE C_DATOS_ARTICULO;
    END IF;
    OPEN C_DATOS_ARTICULO(Lv_NoArticulo, Lv_NoCia);
    FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
    IF C_DATOS_ARTICULO%NOTFOUND THEN
      Lr_DatosArticulo.Ind_Requiere_Serie := 'N';
      Lr_DatosArticulo.Genera_Numero_Serie := 'N';
      Lr_DatosArticulo.Ind_Mac := 'S';
    END IF;
    CLOSE C_DATOS_ARTICULO;
    --
    IF Lr_DatosArticulo.Ind_Requiere_Serie = 'N' THEN
      Pv_MensajeError := 'Articulo: '||Lv_NoArticulo||' no maneja número de serie por tal motivo no se puede generar serie automática, favor revisar.';
      RAISE Le_Error;
    ELSIF Lr_DatosArticulo.Genera_Numero_Serie = 'N' THEN
      Pv_MensajeError := 'Articulo: '||Lv_NoArticulo||' NO genera serie automática, favor revisar.';
      RAISE Le_Error;
    ELSIF Lr_DatosArticulo.Ind_Mac = 'S' THEN
      Pv_MensajeError := 'Articulo: '||Lv_NoArticulo||' maneja número MAC por tal motivo no se puede generar serie automática, favor revisar.';
      RAISE Le_Error;
    END IF;
    --
    FOR Lr_Formato IN C_DETALLE_FORMATO LOOP
      --
      Lv_ExtractoSerie := NULL;
      --
      IF Lr_Formato.Tipo = 'Variable' THEN
        --
        OPEN Lt_Resultado FOR Lr_Formato.Valores;
        FETCH Lt_Resultado INTO Lv_ExtractoSerie;
        CLOSE Lt_Resultado;
        --
      ELSE
        Lv_ExtractoSerie := Lr_Formato.Valores;
      END IF;
      --
      IF Lv_ExtractoSerie IS NULL THEN
        Pv_MensajeError := 'No se encontró definido valor para formato: '||Pn_FormatoId||' y sub-estructura: '|| Lr_Formato.Nombre||', favor revisar.';
        RAISE Le_Error;
      ELSE
        Pv_NumeroSerie := Pv_NumeroSerie||Lv_ExtractoSerie;
      END IF;
      --
    END LOOP;
    --
    -- se inserta numero serie en maestro de series con estatus fuera de bodega asi se controla la secuencia
    --
    IF Pb_InsertaSerie THEN
      --
      Lr_NumeroSerie.Compania := Lv_NoCia;
      Lr_NumeroSerie.Serie := Pv_NumeroSerie;
      Lr_NumeroSerie.No_Articulo := Lv_NoArticulo;
      Lr_NumeroSerie.Estado := 'FB';
      Lr_NumeroSerie.Unidades := Pn_Cantidad;
      Lr_NumeroSerie.Serie_Anterior := NAF47_TNET.GEK_VAR.F_GET_NUMERO_SERIE;
      Lr_NumeroSerie.Usuario_Crea := USER;
      Lr_NumeroSerie.Fecha_Crea := SYSDATE;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE (Lr_NumeroSerie, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'P_FORMATO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'P_FORMATO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_FORMATO;
  --
  --
  PROCEDURE P_SERIE_FORMATO_GENERAL( Pv_ArticuloId   IN VARCHAR2,
                                     Pn_Cantidad     IN NUMBER,
                                     Pb_InsertaSerie IN BOOLEAN,
                                     Pv_EmpresaId    IN VARCHAR2,
                                     Pv_NumeroSerie  IN OUT VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2) IS
    --
    DETALLE_FORMATO_SERIE  CONSTANT VARCHAR2(21) := 'DETALLE-FORMATO-SERIE';
    PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
    FORMATO_SERIE_AUTOMATICA CONSTANT VARCHAR2(24) := 'FORMATO-SERIE-AUTOMATICA';
    --
    CURSOR C_DETALLE_FORMATO IS
      SELECT APD.VALOR2 AS FORMATO_SERIE,
             APD.VALOR4 AS TIPO,
             APD.VALOR5 AS NOMBRE,
             APD.VALOR1 AS VALORES,
             APD.ESTADO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.EMPRESA_COD = Pv_EmpresaId
      AND APD.DESCRIPCION = DETALLE_FORMATO_SERIE
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS) 
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET FSG
                  WHERE FSG.EMPRESA_COD = APD.EMPRESA_COD
                  AND TO_CHAR(FSG.ID_PARAMETRO_DET) = APD.VALOR2
                  AND FSG.DESCRIPCION = FORMATO_SERIE_AUTOMATICA
                  AND FSG.VALOR2 = NAF47_TNET.GEK_VAR.Gr_Estado.SI
                  AND EXISTS (SELECT NULL 
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                              WHERE APC.ID_PARAMETRO = FSG.PARAMETRO_ID 
                              AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS))
      ORDER BY TO_NUMBER(VALOR3);

    --
    CURSOR C_DATOS_ARTICULO IS
      SELECT DA.IND_REQUIERE_SERIE,
             DA.GENERA_NUMERO_SERIE,
             DA.IND_MAC
      FROM NAF47_TNET.ARINDA DA
      WHERE DA.NO_ARTI = Pv_ArticuloId
      AND DA.NO_CIA = Pv_EmpresaId;
    --
    --
    Lv_ExtractoSerie VARCHAR2(3000);
    --
    Lt_Resultado     SYS_REFCURSOR;
    Lr_NumeroSerie    NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE;
    Lr_DatosArticulo C_DATOS_ARTICULO%ROWTYPE;
    --
    Le_Error         EXCEPTION;
    --
  BEGIN
    --
    Pv_NumeroSerie :=  NULL;
    -- se recupera datos del articulo a generar serie
    IF C_DATOS_ARTICULO%ISOPEN THEN
      CLOSE C_DATOS_ARTICULO;
    END IF;
    OPEN C_DATOS_ARTICULO;
    FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
    IF C_DATOS_ARTICULO%NOTFOUND THEN
      Lr_DatosArticulo.Ind_Requiere_Serie := 'N';
      Lr_DatosArticulo.Genera_Numero_Serie := 'N';
      Lr_DatosArticulo.Ind_Mac := 'S';
    END IF;
    CLOSE C_DATOS_ARTICULO;
    --
    -- se valida que el articulo maneje número de serie 
    IF Lr_DatosArticulo.Ind_Requiere_Serie = 'N' THEN
      Pv_MensajeError := 'Articulo: '||Pv_ArticuloId||' no maneja número de serie por tal motivo no se puede generar serie automática, favor revisar.';
      RAISE Le_Error;
    END IF;
    --
    -- se recuepra el formato general
    FOR Lr_Formato IN C_DETALLE_FORMATO LOOP
      --
      Lv_ExtractoSerie := NULL;
      --
      -- se ejecutan las sentencias configuradas en el formato general para recuperar cada unos de los campos que constituyen el numero de serie
      IF Lr_Formato.Tipo = 'Variable' THEN
        --
        OPEN Lt_Resultado FOR Lr_Formato.Valores;
        FETCH Lt_Resultado INTO Lv_ExtractoSerie;
        CLOSE Lt_Resultado;
        --
      ELSE -- si no es por sentencia se asigna el valor configurado
        Lv_ExtractoSerie := Lr_Formato.Valores;
      END IF;
      --
      -- si no generó nada se emite emnsaje error 
      IF Lv_ExtractoSerie IS NULL THEN
        Pv_MensajeError := 'No se encontró definido valor para formato: '||Lr_Formato.Formato_Serie||' y sub-estructura: '|| Lr_Formato.Nombre||', favor revisar.';
        RAISE Le_Error;
      ELSE -- se generó serie y se asigna a parametro de retorno.
        Pv_NumeroSerie := Pv_NumeroSerie||Lv_ExtractoSerie;
      END IF;
      --
    END LOOP;
    --
    -- se inserta numero serie en maestro de series con estatus fuera de bodega asi se controla la secuencia
    --
    IF Pb_InsertaSerie THEN
      --
      Lr_NumeroSerie.Compania := Pv_EmpresaId;
      Lr_NumeroSerie.Serie := Pv_NumeroSerie;
      Lr_NumeroSerie.No_Articulo := Pv_ArticuloId;
      Lr_NumeroSerie.Estado := 'FB';
      Lr_NumeroSerie.Unidades := Pn_Cantidad;
      Lr_NumeroSerie.Serie_Anterior := NAF47_TNET.GEK_VAR.F_GET_NUMERO_SERIE;
      Lr_NumeroSerie.Usuario_Crea := USER;
      Lr_NumeroSerie.Fecha_Crea := SYSDATE;
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE (Lr_NumeroSerie, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_GENERACION_SERIE.P_SERIE_FORMATO_GENERAL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_GENERACION_SERIE.P_SERIE_FORMATO_GENERAL',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_SERIE_FORMATO_GENERAL;
  --
  --
END INKG_GENERACION_SERIE;
/
