CREATE OR REPLACE PROCEDURE NAF47_TNET.IN_ACT_ARTICULOS_RECURRENTES(PV_ERROR OUT VARCHAR2) AS
/**
* @author     TN Jimmy Gilces
* @proposito  Modificacion de Proceso para acoplarlo a las revisiones pre/post algoritmo
*/
  /**
  * Documentacion para IN_ACT_ARTICULOS_RECURRENTES 
  *
  * Procedimiento que actualiza valores minimos y maximos de art�culos recurrentes 
  *
  * @author banton <banton@telconet.ec>
  * @version 1.0 
  * 08/07/2020
  *
  * @author banton <banton@telconet.ec>
  * @version 1.1 04/04/2022 - Se modifica para referenciar secuencia de base 19c
  * 
  * @param PV_ERROR OUT VARCHAR2 retorma mensaje de error
  * 
  * Se agrega filtro de estado en actualizacion de registros 
  * @author banton <banton@telconet.ec>
  * @version 1.1 
  * 17/05/2021
  *
  * Se cambia el valor del filtro estado a T, debido a las nuevas pantallas de modificacion
  * de articulos.
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.2
  * 08/08/2022
  */

  CURSOR C_REGISTROS IS
    SELECT ID_EMPRESA,
           ID_ARTICULO,
           ID_REGION,
           ANIO,
           MES,
           CANTIDAD_MINIMA,
           CANTIDAD_MAXIMA
      FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
     WHERE ESTADO = 'T';--CAMBIO DE ESTADO A T POR NUEVAS PANTALLAS DE MODIFICACION DE ARTICULOS, ANTE ESTADO ERA I

  CURSOR C_EXISTE_ART_REC(Cv_IdEmpresa  NAF47_TNET.ARIN_ARTICULO_RECURRENTE.ID_EMPRESA_ARTICULO%TYPE,
                          Cv_IdArticulo NAF47_TNET.ARIN_ARTICULO_RECURRENTE.ID_ARTICULO%TYPE,
                          Cv_IdRegion   NAF47_TNET.ARIN_ARTICULO_RECURRENTE.ID_REGION%TYPE) IS
  
    SELECT ID_ARTICULO_RECURRENTE
      FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE
     WHERE ID_EMPRESA_ARTICULO = Cv_IdEmpresa
       AND ID_ARTICULO = Cv_IdArticulo
       AND ID_REGION = Cv_IdRegion;

  CURSOR C_EXISTE_REGISTROS IS
    SELECT COUNT(*) TOTAL
      FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
     WHERE ESTADO = 'T';--CAMBIO DE ESTADO A T POR NUEVAS PANTALLAS DE MODIFICACION DE ARTICULOS, ANTE ESTADO ERA I

  CURSOR C_VERIFICA_ARTICULO(Cn_NoCia  NAF47_TNET.ARINDA.NO_CIA%TYPE,
                             Cn_NoArti NAF47_TNET.ARINDA.NO_ARTI%TYPE) IS
    SELECT 'S' EXISTE
      FROM NAF47_TNET.ARINDA
     WHERE NO_CIA = Cn_NoCia
       AND NO_ARTI = Cn_NoArti;

  Lc_ExisteArtRec C_EXISTE_ART_REC%ROWTYPE;
  Lb_Existe       BOOLEAN;
  LnCommit        NUMBER := 0;
  Ln_Total        NUMBER;
  Lv_Estado       VARCHAR2(1);
  Lv_Articulo     VARCHAR2(1);
  Lv_NoCia        VARCHAR2(2) := '10';
  Lv_Observacion  NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.OBSERVACION%TYPE;

BEGIN

  OPEN C_EXISTE_REGISTROS;
  FETCH C_EXISTE_REGISTROS
    INTO Ln_Total;
  CLOSE C_EXISTE_REGISTROS;

  IF NVL(Ln_Total, 0) > 0 THEN
  
    -----1 Actualizar ARINDA-----
    UPDATE NAF47_TNET.ARINDA
       SET ES_RECURRENTE = 'N'
     WHERE NO_CIA = Lv_NoCia
       AND ES_RECURRENTE = 'S';
  
    -----2 ACTUALIZAR ARINDA CON RECURRENTES-------
    UPDATE NAF47_TNET.ARINDA
       SET ES_RECURRENTE = 'S'
     WHERE NO_CIA = Lv_NoCia
       AND NO_ARTI IN (SELECT ID_ARTICULO
                         FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
                        WHERE ESTADO = 'T'--CAMBIO DE ESTADO A T POR NUEVAS PANTALLAS DE MODIFICACION DE ARTICULOS, ANTE ESTADO ERA I
                          AND CANTIDAD_MAXIMA > 0
                          AND CANTIDAD_MINIMA > 0);
  
    -----4 ELIMINAR------------------------
    DELETE FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE;
  
    FOR Lc_registros IN C_REGISTROS LOOP
      Lv_Estado   := NULL;
      Lv_Articulo := NULL;
      OPEN C_VERIFICA_ARTICULO(Lc_registros.ID_EMPRESA,
                               Lc_registros.ID_ARTICULO);
      FETCH C_VERIFICA_ARTICULO
        INTO Lv_Articulo;
      CLOSE C_VERIFICA_ARTICULO;
      IF NVL(Lv_Articulo, 'N') = 'S' THEN
        OPEN C_EXISTE_ART_REC(Lc_registros.ID_EMPRESA,
                              Lc_registros.ID_ARTICULO,
                              Lc_registros.ID_REGION);
        FETCH C_EXISTE_ART_REC
          INTO Lc_ExisteArtRec;
        Lb_Existe := C_EXISTE_ART_REC%FOUND;
        CLOSE C_EXISTE_ART_REC;
      
        --Si existe el articulo se actualiza el max y min
        IF Lb_Existe THEN
          UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE
             SET CANTIDAD_MINIMA = Lc_registros.CANTIDAD_MINIMA,
                 CANTIDAD_MAXIMA = NVL(Lc_registros.CANTIDAD_MAXIMA,
                                       CANTIDAD_MAXIMA)
           WHERE ID_ARTICULO_RECURRENTE =
                 Lc_ExisteArtRec.ID_ARTICULO_RECURRENTE;
        
          Lv_Estado      := 'R';
          Lv_Observacion := 'OK';
          --Si no existe se verifica que el valor maximo sea mayor a cero
        ELSIF NVL(Lc_registros.CANTIDAD_MAXIMA, 0) > 0 THEN
          INSERT INTO NAF47_TNET.ARIN_ARTICULO_RECURRENTE
            (ID_ARTICULO_RECURRENTE,
             ID_EMPRESA_ARTICULO,
             ID_ARTICULO,
             ID_REGION,
             CANTIDAD_MINIMA,
             CANTIDAD_MAXIMA,
             USR_CREACION,
             FECHA_CREACION,
             IP_CREACION)
          VALUES
            (NAF47_TNET.SEQ_ARIN_ARTICULO_RECURRENTE.NEXTVAL@GPOETNET,
             Lc_registros.ID_EMPRESA,
             Lc_registros.ID_ARTICULO,
             Lc_registros.ID_REGION,
             Lc_registros.CANTIDAD_MINIMA,
             Lc_registros.CANTIDAD_MAXIMA,
             USER,
             SYSDATE,
             GEK_CONSULTA.F_RECUPERA_IP);
          Lv_Estado      := 'R';
          Lv_Observacion := 'OK';
        
        ELSE
          Lv_Estado      := 'E';
          Lv_Observacion := 'Art�culo nuevo debe tener valor maximo';
        
        END IF;
      ELSE
        Lv_Estado      := 'E';
        Lv_Observacion := 'Art�culo no existe en maestro';
      END IF;
      UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
         SET ESTADO        = Lv_Estado,
             OBSERVACION   = Lv_Observacion,
             USR_ULT_MOD   = USER,
             FECHA_ULT_MOD = SYSDATE
       WHERE ID_EMPRESA = Lc_registros.ID_EMPRESA
         AND ID_ARTICULO = Lc_registros.ID_ARTICULO
         AND ID_REGION = Lc_registros.ID_REGION
         AND ANIO = Lc_registros.ANIO
         AND MES = Lc_registros.MES
         AND ESTADO = 'T';
      LnCommit := LnCommit + 1;
    
      IF LnCommit >= 500 THEN
        LnCommit := 0;
        COMMIT;
      END IF;
    
    END LOOP;
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    PV_ERROR := 'Error general: ' || SQLERRM;
    ROLLBACK;
END IN_ACT_ARTICULOS_RECURRENTES;
/