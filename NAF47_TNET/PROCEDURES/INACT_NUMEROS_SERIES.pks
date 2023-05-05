CREATE EDITIONABLE PROCEDURE            INACT_NUMEROS_SERIES(Pv_NoCia        IN VARCHAR2,
                                                 Pv_NoDocumento  IN VARCHAR2,
                                                 Pn_noLinea      IN NUMBER,
                                                 Pv_noArticulo   IN VARCHAR2,
                                                 Pv_MensajeError IN OUT VARCHAR2) IS
/**
 * Documentacion para INACT_NUMEROS_SERIES
 * Este procedimiento genera la informaci�n de n�meros de series en la tabla INV_DOCUMENTO_SERIE.
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.0 23-07-2017
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 02/08/2018 Se modifica para considerar nuevo campo que guarda la cantidad que representa cada n�mero de serie registrado.
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 30/07/2021 Se modifica para considerar nuevos campos cantidad_segmento y serie_original.
 * 
 * @param Pv_NoCia        IN VARCHAR2 recibe codigo de compania
 * @param Pv_NoDocumento  IN VARCHAR2 recibe numero transaccion inventario
 * @param Pn_noLinea      IN VARCHAR2 recibe n�mero de linea detalle
 * @param Pv_MensajeError IN OUT VARCHAR2 retorma mensaje de error
 */
  -- costo query; 30
  CURSOR C_PRE_NUMEROS_SERIES IS
  /*Actualziaci�n compras locales e Importaciones*/
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO,
           A.LINEA,
           A.NO_ARTICULO,
           A.SERIE,
           A.MAC,
           A.ORIGEN,
           B.BODEGA,
           C.IND_MAC,
           D.MOVIMI,
           A.UNIDADES,
           A.SERIE_ORIGINAL,
           A.CANTIDAD_SEGMENTO
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A,
           NAF47_TNET.ARINML                       B,
           NAF47_TNET.ARINDA                       C,
           NAF47_TNET.ARINVTM                      D
     WHERE A.LINEA = B.LINEA
       AND A.NO_ARTICULO = B.NO_ARTI
       AND A.NO_DOCUMENTO = B.NO_DOCU
       AND A.COMPANIA = B.NO_CIA
       AND A.NO_ARTICULO = C.NO_ARTI
       AND A.COMPANIA = C.NO_CIA
       AND B.TIPO_DOC = D.TIPO_M
       AND B.NO_CIA = D.NO_CIA
       AND A.NO_ARTICULO = NVL(Pv_noArticulo, A.NO_ARTICULO)
       AND A.NO_DOCUMENTO = Pv_NoDocumento
       AND A.COMPANIA = Pv_NoCia
    UNION /*Actualziaci�n importaciones*/
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO,
           A.LINEA,
           A.NO_ARTICULO,
           A.SERIE,
           A.MAC,
           A.ORIGEN,
           B.BODEGA,
           C.IND_MAC,
           'E' MOVIMI, -- cuando es importaci�n es solo ingreso
           A.UNIDADES,
           A.SERIE_ORIGINAL,
           A.CANTIDAD_SEGMENTO
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A,
           NAF47_TNET.ARIMDETFACTURAS              B,
           NAF47_TNET.ARINDA C           
     WHERE A.LINEA = B.NO_LINEA
       AND A.NO_ARTICULO = B.NO_ARTI
       AND A.NO_DOCUMENTO = B.NUM_FAC
       AND A.COMPANIA = B.NO_CIA
       AND A.NO_ARTICULO = C.NO_ARTI
       AND A.COMPANIA = C.NO_CIA
       AND A.NO_ARTICULO = NVL(Pv_noArticulo, A.NO_ARTICULO)
       AND A.NO_DOCUMENTO = Pv_NoDocumento
       AND A.COMPANIA = Pv_NoCia;
  --
  -- costo query: 4
  CURSOR C_VERIFICA_SERIES(Cv_numeroSerie VARCHAR2,
                           Cv_noCompania  VARCHAR2) IS
    SELECT A.ID_BODEGA,
           A.NO_ARTICULO,
           A.ESTADO
      FROM NAF47_TNET.INV_NUMERO_SERIE A
     WHERE A.SERIE = Cv_numeroSerie
       AND A.COMPANIA = Cv_noCompania;
  --
  -- costo query: 4
  CURSOR C_VERIFICA_MAC(Cv_numeroMac  VARCHAR2,
                        Cv_noCompania VARCHAR2) IS
    SELECT A.ID_BODEGA,
           A.NO_ARTICULO,
           A.ESTADO
      FROM NAF47_TNET.INV_NUMERO_SERIE A
     WHERE A.MAC = Cv_numeroMac
       AND A.COMPANIA = Cv_noCompania;
  --
  Lv_CadenaAux     inv_numero_serie.mac%TYPE := NULL;
  Lr_verificaSerie C_VERIFICA_SERIES%ROWTYPE := NULL;
  Lr_verificaMac   C_VERIFICA_MAC%ROWTYPE := NULL;
  Le_Error EXCEPTION;
  --
BEGIN
  FOR A IN C_PRE_NUMEROS_SERIES LOOP
    
    IF A.MOVIMI = 'E' THEN
      -- se verifica que numero serie ya se encuentra ingresado
      IF C_VERIFICA_SERIES%ISOPEN THEN CLOSE C_VERIFICA_SERIES; END IF;
      OPEN C_VERIFICA_SERIES(A.SERIE, A.COMPANIA);
      FETCH C_VERIFICA_SERIES INTO Lr_verificaSerie;
      IF C_VERIFICA_SERIES%FOUND THEN
        IF Lr_verificaSerie.ESTADO = 'EB' THEN
          Pv_MensajeError := 'Serie ' || A.SERIE || ' se encuentra ingresada en la bodega ' || Lr_verificaSerie.ID_BODEGA || ' con articulo ' || Lr_verificaSerie.NO_ARTICULO;
          RAISE Le_Error;
        END IF;
      END IF;
      CLOSE C_VERIFICA_SERIES;
      
      IF A.IND_MAC = 'S' THEN

        Lv_CadenaAux := REPLACE(A.MAC, '.', '');
      
        if Lv_CadenaAux is null then
          Pv_MensajeError := 'N�mero de MAC: ' || A.MAC || ' asociado al articulo: ' || A.NO_ARTICULO ||' del documento: '||A.NO_DOCUMENTO ||', no se puede ingresar.';
          RAISE Le_Error;
        end if;
         
        IF LENGTH(Lv_CadenaAux) != 12 THEN
          Pv_MensajeError := 'N�mero de MAC: ' || A.MAC || ' asociado al articulo: ' || A.NO_ARTICULO ||' del documento: '||A.NO_DOCUMENTO ||', no tiene 12 caracteres.';
          RAISE Le_Error;
        ELSE
          FOR i IN 1 .. LENGTH(Lv_CadenaAux) LOOP
            IF (ascii(SUBSTR(Lv_CadenaAux, i, 1)) < 65 OR ascii(SUBSTR(Lv_CadenaAux, i, 1)) > 70) AND 
              (ascii(SUBSTR(Lv_CadenaAux, i, 1)) < 48 OR ascii(SUBSTR(Lv_CadenaAux, i, 1)) > 57) THEN
              Pv_MensajeError := 'N�mero de MAC: ' || A.MAC || ' asociado al articulo: ' || A.NO_ARTICULO ||' del documento: '||A.NO_DOCUMENTO || ', no tiene formato hexadecimal.';
              RETURN;
            END IF;
          END LOOP;
        END IF;
      ELSE
        IF A.MAC IS NOT NULL THEN
          Pv_MensajeError := 'El articulo: ' || A.NO_ARTICULO ||' del documento: '||A.NO_DOCUMENTO || ', no permite ingreso de n�mero MAC.';
          RETURN;
        END IF;
      END IF;
      
      -- se verifica que numero MAC ya se encuentra ingresado
      IF C_VERIFICA_MAC%ISOPEN THEN CLOSE C_VERIFICA_MAC; END IF;
      OPEN C_VERIFICA_MAC(A.MAC, A.COMPANIA);
      FETCH C_VERIFICA_MAC INTO Lr_verificaMac;
      IF C_VERIFICA_MAC%FOUND THEN
        IF Lr_verificaMac.ESTADO = 'EB' THEN
          Pv_MensajeError := 'N�mero Mac ' || A.MAC || ' se encuentra ingresada en la bodega ' || Lr_verificaMac.ID_BODEGA || ' con articulo ' || Lr_verificaMac.NO_ARTICULO;
          RAISE Le_Error;
        END IF;
      END IF;
      CLOSE C_VERIFICA_MAC;
   
    END IF;
    
    -- todo OK se procede a asociar serien en tabla kardex de series
    BEGIN
      INSERT INTO INV_DOCUMENTO_SERIE
        (COMPANIA,
         ID_DOCUMENTO,
         LINEA,
         SERIE,
         MAC,
         UNIDADES,
         SERIE_ORIGINAL,
         CANTIDAD_SEGMENTO,
         USUARIO_CREA,
         FECHA_CREA)
      VALUES
        (a.compania,
         a.no_documento,
         NVL(Pn_noLinea, a.linea),
         a.serie,
         a.mac,
         a.unidades,
         a.serie_original,
         a.cantidad_segmento,
         USER,
         SYSDATE);
    EXCEPTION
      WHEN OTHERS THEN
        Pv_MensajeError := 'Error insertando datos en INV_DOCUMENTO_SERIE. ' || SQLERRM;
        RAISE Le_Error;
    END;
    --

    -- se actualiza numero de serie
    UPDATE INV_NUMERO_SERIE
       SET ID_BODEGA         = decode(A.MOVIMI, 'E', a.bodega, 'S', NULL),
           ESTADO            = decode(A.MOVIMI, 'E', 'EB', 'S', 'FB'),
           MAC               = a.mac,
           UNIDADES          = a.unidades,
           CANTIDAD_SEGMENTO = a.cantidad_segmento,
           USUARIO_MODIFICA  = USER,
           FECHA_MODIFICA    = SYSDATE
     WHERE SERIE = a.serie
       AND NO_ARTICULO = a.no_articulo
       AND COMPANIA = a.compania;
  
    -- combinacion Serie, Mac, Articulo no existen para la compa�ia, se inserta 
    IF SQL%ROWCOUNT = 0 THEN
      BEGIN        
        INSERT INTO INV_NUMERO_SERIE
          (COMPANIA,
           SERIE,
           MAC,
           UNIDADES,
           NO_ARTICULO,
           ID_BODEGA,
           ESTADO,
           CANTIDAD_SEGMENTO,
           SERIE_ANTERIOR,
           USUARIO_CREA,
           FECHA_CREA)
        VALUES
          (a.compania,
           a.serie,
           a.mac,
           a.unidades,
           a.no_articulo,
           decode(A.MOVIMI, 'E', a.bodega, 'S', NULL),
           decode(A.MOVIMI, 'E', 'EB', 'S', 'FB'),
           a.cantidad_segmento,
           a.serie_original,
           USER,
           SYSDATE);
      EXCEPTION
        WHEN OTHERS THEN
          Pv_MensajeError := 'Error insertando datos en INV_NUMERO_SERIE. ' || SQLERRM;
          RAISE Le_Error;
      END;
    END IF;
  END LOOP;
  
  
  -- nuevo procepo para control de equipos y custodios
  AFK_CONTROL_CUSTODIO.P_ARTICULO_CONTROL (Pv_NoDocumento, Pv_NoCia, Pv_MensajeError);
  --
  IF Pv_MensajeError IS NOT NULL THEN
    RAISE Le_Error;
  END IF;


EXCEPTION
  WHEN Le_Error THEN
    Pv_MensajeError := 'INACT_NUMEROS_SERIES. ' || Pv_MensajeError;
    
  WHEN OTHERS THEN
    Pv_MensajeError := 'Error en INACT_NUMEROS_SERIES. ' || SQLERRM;
END INACT_NUMEROS_SERIES;
/