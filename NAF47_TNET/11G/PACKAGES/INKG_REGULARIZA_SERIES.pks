CREATE OR REPLACE PACKAGE            INKG_REGULARIZA_SERIES AS
  /**
  * Documentación para NAF47_TNET.INKG_REGULARIZA_SERIES
  * Paquete que contiene prcedimiento para regularizar codigo de series o articulos relacionados
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 02/05/2019 
  */



  /**
  * Documentación para P_REGULARIZA_ARTICULO_SERIES
  * Procedimiento principal para regularización de series a un determinado artículo
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 02/05/2019
  * 
  * @param Pv_Resultado OUT VARCHAR2 Devuelve OK al finalizar el proceso
  * @param Pv_Error     OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_REGULARIZA_ARTICULO_SERIES(Pv_Resultado OUT VARCHAR2,
                                Pv_Error     OUT VARCHAR2);


  /**
  * Documentación para P_INSERTA_RES_REGULARIZACION
  * Procedimiento principal para regularización de series a un determinado artículo
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 02/04/2019
  * 
  * @param Pv_Serie            IN INV_REGULARIZACION_SERIES_RES.SERIE%TYPE Recibe la serie que se va a regularizar
  * @param Pv_ArticuloNo       IN INV_REGULARIZACION_SERIES_RES.ARTICULO_NO%TYPE Recibe el artículo al que debe pertenecer
  * @param Pv_ArticuloAnterior IN INV_REGULARIZACION_SERIES_RES.ARTICULO_ANTERIOR%TYPE Recibe el artículo que tenia asociado actualmente
  * @param Pv_Observacion      IN INV_REGULARIZACION_SERIES_RES.OBSERVACION%TYPE Recibe observación breve de su registro
  * @param Pv_Error            OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */                                

  PROCEDURE P_INSERTA_RES_REGULARIZACION(Pv_Serie            INV_REGULARIZACION_SERIES_RES.SERIE%TYPE,
                                         Pv_ArticuloNo       INV_REGULARIZACION_SERIES_RES.ARTICULO_NO%TYPE,
                                         Pv_ArticuloAnterior INV_REGULARIZACION_SERIES_RES.ARTICULO_ANTERIOR%TYPE,
                                         Pv_Observacion      INV_REGULARIZACION_SERIES_RES.OBSERVACION%TYPE,
                                         Pv_Error            OUT VARCHAR2); 


  /**
  * Documentación para P_REGULARIZA_INST_CUST
  * Procedimiento que regulariza artículo en instalación y custodio
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/05/2019
  * 
  * @param Pv_Compania         IN INV_NUMERO_SERIE.COMPANIA%TYPE Recibe la compañia
  * @param Pv_Serie            IN INV_REGULARIZACION_SERIES_RES.SERIE%TYPE Recibe la serie que se va a regularizar
  * @param Pv_ArticuloNo       IN INV_REGULARIZACION_SERIES_RES.ARTICULO_NO%TYPE Recibe el artículo al que debe pertenecer
  * @param Pv_Error            OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_REGULARIZA_INST_CUST(Pv_Compania         INV_NUMERO_SERIE.COMPANIA%TYPE,
                                   Pv_Serie            INV_NUMERO_SERIE.SERIE%TYPE,
                                   Pv_ArticuloNo       INV_NUMERO_SERIE.NO_ARTICULO%TYPE,
                                   Pv_ArticuloAnterior INV_NUMERO_SERIE.NO_ARTICULO%TYPE,
                                   Pv_Error            OUT VARCHAR2);





  /**
  * Documentación para P_REGULARIZA_MOVIMIENTOS
  * Procedimiento que regulariza los documentos relacionados a la serie y artículo incorectos
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/05/2019
  * 
  * @param Pv_compania      IN VARCHAR2 Recibe el artículo que debe pertenecer la serie
  * @param Pv_NoArtiNuevo   IN VARCHAR2 Recibe el artículo que debe pertenecer la serie
  * @param Pv_Serie         IN VARCHAR2 Recibe la serie que se le va a aplicar el cambio
  * @param Pv_Tipo          IN VARCHAR2 Recibe valor para identificar si el artículo es nuevo o usado
  * @param Pv_Documentos    IN OUT VARCHAR2 Se agregan los documentos que son regularizados
  * @param Pv_Error         OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */


  PROCEDURE P_REGULARIZA_MOVIMIENTOS (Pv_compania    VARCHAR2,
                                      Pv_NoArti      VARCHAR2,
                                      Pv_Serie       VARCHAR2,
                                      Pv_Tipo        VARCHAR2,
                                      Pv_Documentos  IN OUT VARCHAR2,
                                      Pv_Error       OUT VARCHAR2) ;                                 


/**
  * Documentación para P_INSERTA_ARINML
  * Procedimiento que regulariza los documentos relacionados a la serie y artículo incorectos
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/05/2019
  * 
  * @param Pt_DetalleMov    IN ARINML%ROWTYPE Recibe el numero de compañia
  * @param Pv_NoArti        IN ARINML.NO_ARTI%TYPE artículo para nuevo detalle
  * @param Pn_linea         IN NUMBER artículo para nuevo detalle
  * @param Pn_CostoUni      IN ARINMN.COSTO_UNI%TYPE costo unitario del artículo
  * @param Pn_Costo2        IN ARINMN.COSTO2%TYPE costo2 del artículo
  * @param Pv_Error         OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_INSERTA_ARINML (Pt_DetalleMov ARINML%ROWTYPE,
                              Pv_NoArti     ARINML.NO_ARTI%TYPE,
                              Pn_linea      NUMBER,
                              Pn_CostoUni   ARINMN.COSTO_UNI%TYPE, 
                              Pn_Costo2     ARINMN.COSTO2%TYPE,
                              Pv_Error      OUT VARCHAR2) ;

  /**
  * Documentación para P_INSERTA_ARINMN
  * Procedimiento que regulariza histórico de documentos relacionados a la serie y artículo incorectos
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/05/2019
  * 
  * @param Pt_HistDetalleMov    IN ARINML%ROWTYPE Recibe el numero de compañia
  * @param Pv_NoArti            IN ARINML.NO_ARTI%TYPE artículo para nuevo detalle
  * @param Pv_Error             OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_INSERTA_ARINMN (Pt_HistDetalleMov ARINMN%ROWTYPE,
                              Pv_NoArti     ARINML.NO_ARTI%TYPE,
                              Pn_linea      NUMBER,
                              Pv_Error      OUT VARCHAR2) ;


  /**
  * Documentación para P_INSERTA_ARINMA
  * Procedimiento para insertar artículo en ARINMA en caso de que no exista
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/05/2019
  * 
  * @param Pt_Arinma        IN ARINMA%ROWTYPE Recibe el numero de compañia
  * @param Pv_NoArti        IN ARINML.NO_ARTI%TYPE artículo para nuevo detalle
  * @param Pv_Error         OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_INSERTA_ARINMA (Pt_Arinma     ARINMA%ROWTYPE,
                              Pv_NoArti     ARINMA.NO_ARTI%TYPE,
                              Pv_Error      OUT VARCHAR2) ;


  /**
  * Documentación para P_REGULARIZA_CODIGO_SERIES
  * Procedimiento principal para regularización de series ingresadas con formato incorrecto,
  * También se corrigen los movimientos que estan relacionados a la serie 
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 21/05/2019
  * 
  * @param Pv_Resultado OUT VARCHAR2 Devuelve OK al finalizar el proceso
  * @param Pv_Error     OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_REGULARIZA_CODIGO_SERIES(Pv_Resultado OUT VARCHAR2,
                                      Pv_Error     OUT VARCHAR2);

/**
  * Documentación para P_REGULARIZA_INGRESO_EQUIPO
  * Procedimiento principal para regularización de series que no ingresaron por retiro de equipo
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 03/03/2020
  * 
  * @param Pv_Resultado OUT VARCHAR2 Devuelve OK al finalizar el proceso
  * @param Pv_Error     OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */

  PROCEDURE P_REGULARIZA_INGRESO_EQUIPO(Pv_Resultado OUT VARCHAR2,
										Pv_Error     OUT VARCHAR2);
                              
  
  /**
  * Documentación para P_VALIDA_INGRESO_SERIE
  * Procedimiento que valida si la serie para ingresar a bodega
  * 
  * @author Byron Antón <banton@telconet.ec>
  * @version 1.0 06/03/2020
  * 
  * @param Pv_compania      IN VARCHAR2 Recibe el artículo que debe pertenecer la serie
  * @param Pv_NoArtiNuevo   IN VARCHAR2 Recibe el artículo que debe pertenecer la serie
  * @param Pv_Serie         IN VARCHAR2 Recibe la serie que se le va a aplicar el cambio
 * @param Pv_Error          OUT VARCHAR2 Devuelve mensaje de error en caso de que se presente alguno
  */


  PROCEDURE P_VALIDA_INGRESO_SERIE  (Pv_Serie       VARCHAR2,
                                     Pv_Error       OUT VARCHAR2) ;






END INKG_REGULARIZA_SERIES;
/


CREATE OR REPLACE PACKAGE BODY            INKG_REGULARIZA_SERIES AS

  PROCEDURE P_REGULARIZA_ARTICULO_SERIES(Pv_Resultado OUT VARCHAR2,
                                         Pv_Error     OUT VARCHAR2) AS
  
    --Cursor principal que contiene series con su respectivo articulo para regularizar
  CURSOR C_REGULARIZA_SERIES
  IS
    SELECT *
    FROM NAF47_TNET.INV_REGULARIZACION_SERIES
    WHERE ESTADO='I'
    AND EVENTO='A';

  --Cursor que obtiene registros de una serie especifica
  CURSOR C_VERIFICA_SERIE (Cv_Compania NAF47_TNET.INV_NUMERO_SERIE.COMPANIA%TYPE,
                           Cv_Serie NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE) 
  IS
    SELECT * 
    FROM NAF47_TNET.INV_NUMERO_SERIE 
    WHERE COMPANIA=Cv_Compania
    AND SERIE=Cv_Serie
    ORDER BY FECHA_CREA;

  --Obtiene cantidad de registros 
  CURSOR C_TOTAL_SERIE (Cv_Compania NAF47_TNET.INV_NUMERO_SERIE.COMPANIA%TYPE,
                       Cv_Serie NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE,
                       Cv_NoArticulo NAF47_TNET.INV_NUMERO_SERIE.NO_ARTICULO%TYPE ) 
  IS
    SELECT 
      *
    FROM NAF47_TNET.INV_NUMERO_SERIE 
    WHERE COMPANIA=Cv_Compania
    AND SERIE=Cv_Serie
    AND NO_ARTICULO=Cv_NoArticulo
    ORDER BY FECHA_CREA;



   CURSOR C_DATOS_ARTI_BODEGA(Cv_Compania   varchar2,
                              Cv_Bodega     varchar2,
                              Cv_NoArticulo varchar2) IS
     SELECT *
       FROM NAF47_TNET.ARINMA
      WHERE NO_CIA  = Cv_Compania
        AND BODEGA  = Cv_Bodega
        AND NO_ARTI = Cv_NoArticulo;


  Lc_Regulariza  C_REGULARIZA_SERIES%ROWTYPE;
  Lc_Serie       C_VERIFICA_SERIE%ROWTYPE;
  Lc_Arinma      C_DATOS_ARTI_BODEGA%ROWTYPE;
  Lc_TotalSerie  C_TOTAL_SERIE%ROWTYPE;
  Lv_Observacion NAF47_TNET.INV_REGULARIZACION_SERIES_RES.OBSERVACION%TYPE;
  Lv_Resultado   NAF47_TNET.INV_REGULARIZACION_SERIES.OBSERVACION%TYPE;
  Lv_estado      VARCHAR2(5);
  Lv_Evento      VARCHAR2(20);
  Lv_NoDocu      VARCHAR2(50);
  Lv_Tipo        VARCHAR2(5);
  Lv_BodegaN     VARCHAR2(5);
  Lv_BodegaU     VARCHAR2(5);
  Lv_ArtiN       VARCHAR2(20);
  Lv_ArtiU       VARCHAR2(20);
  Lv_Documentos  VARCHAR2(500);
  Lv_Error       VARCHAR2(2000);
  Ln_Commit      NUMBER:=0;
  Ln_Regulariza  NUMBER;
  Ln_ExisteSerie NUMBER:=0;
  Lb_InserArinma BOOLEAN;
  Lb_InserArinmaU BOOLEAN;
  Lb_SerieNueva  BOOLEAN;
  Lb_SerieUsada  BOOLEAN;
  Le_Error       EXCEPTION;
  Le_ErrorBloque EXCEPTION;
BEGIN
  --Cursor principal que contiene las series a regularizar

  FOR Lc_Regulariza IN C_REGULARIZA_SERIES LOOP
    Lv_Observacion :='';
    Lv_Resultado   :='';
    Lv_estado      :='P';
    Lv_Documentos  :='';
    Lb_SerieNueva  :=FALSE;
    Lb_SerieUsada  :=FALSE;
    Lb_InserArinma:=FALSE;
    Lb_InserArinmaU:=FALSE;
    Ln_Regulariza:=0;
    --Consulto en cuantos artículos se encuentran las series
   FOR Lc_Serie IN C_VERIFICA_SERIE(Lc_Regulariza.COMPANIA,Lc_Regulariza.SERIE) LOOP

        --valido columna de artiulo nuevo 
        IF Lc_Regulariza.NO_ARTICULO_N != Lc_Serie.NO_ARTICULO AND SUBSTR(Lc_Serie.NO_ARTICULO,1,2) =Lc_Serie.COMPANIA  THEN

          OPEN C_TOTAL_SERIE (Lc_Serie.COMPANIA,Lc_Serie.SERIE,Lc_Regulariza.NO_ARTICULO_N);
          FETCH C_TOTAL_SERIE INTO Lc_TotalSerie;
            IF  C_TOTAL_SERIE%FOUND THEN
               Ln_ExisteSerie:=1;
            ELSE
               Ln_ExisteSerie:=0;
            END IF;
          CLOSE C_TOTAL_SERIE;

            BEGIN
              --Si no existe un articulo igual actualizo registro con artículo nuevo
              IF Ln_ExisteSerie =0 THEN
                Lv_Observacion:=SUBSTR('Actualiza Nuevo: '||Lc_Regulariza.SERIE||' Articulo real: '||Lc_Regulariza.NO_ARTICULO_N ||' '||'Articulo no real: '||Lc_Serie.NO_ARTICULO||' '||CHR(13),1,2000);
                --Valido que exista el artículo en la bodega
                IF NOT (NAF47_TNET.ARTICULO.EXISTE(Lc_Serie.COMPANIA,Lc_Serie.ID_BODEGA,Lc_Regulariza.NO_ARTICULO_N)) AND Lc_Serie.ESTADO='EB'THEN

                OPEN C_DATOS_ARTI_BODEGA(Lc_Serie.COMPANIA,Lc_Serie.ID_BODEGA,Lc_Serie.NO_ARTICULO);
                FETCH C_DATOS_ARTI_BODEGA INTO Lc_Arinma;
                    IF C_DATOS_ARTI_BODEGA%FOUND THEN
                      P_INSERTA_ARINMA (Lc_Arinma,
                                        Lc_Regulariza.NO_ARTICULO_N,
                                        Lv_Resultado);
                       IF Lv_Resultado IS NOT NULL THEN
                         RAISE Le_ErrorBloque;
                       END IF;
                       Lb_InserArinma:=TRUE;
                    ELSE
                      Lb_InserArinma:=FALSE;
                    END IF;

                CLOSE C_DATOS_ARTI_BODEGA;

                END IF;

                IF  Lc_Serie.ESTADO='EB' THEN
                    Lb_SerieNueva:=TRUE;
                    Lv_BodegaN:=Lc_Serie.ID_BODEGA;
                    Lv_ArtiN:=Lc_Serie.NO_ARTICULO;
                ELSE
                    Lb_SerieNueva:=FALSE;
                END IF;

                 UPDATE NAF47_TNET.INV_NUMERO_SERIE
                 SET NO_ARTICULO= Lc_Regulariza.NO_ARTICULO_N
                 WHERE COMPANIA=Lc_Serie.COMPANIA
                 AND SERIE=Lc_Serie.SERIE
                 AND NO_ARTICULO=Lc_Serie.NO_ARTICULO; 


                UPDATE NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
                SET NO_ARTICULO= Lc_Regulariza.NO_ARTICULO_N
                WHERE COMPANIA=Lc_Serie.COMPANIA
                AND SERIE=Lc_Serie.SERIE
                AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;


              --Caso contrario pongo estado EL
              ELSE
                Lv_Observacion:=SUBSTR('Actualiza estado EL articulo nuevo: '||Lc_Regulariza.SERIE||' Articulo real: '||Lc_Regulariza.NO_ARTICULO_N ||' '||'Articulo no real: '||Lc_Serie.NO_ARTICULO,1,2000);

                UPDATE NAF47_TNET.INV_NUMERO_SERIE
                SET ESTADO= 'EL'
                WHERE COMPANIA=Lc_Serie.COMPANIA
                AND SERIE=Lc_Serie.SERIE
                AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;

                --Si el registro que se elimina es mas reciente que el registro correcto y con diferentes estados
                --Se modifican los estados
                IF Lc_TotalSerie.FECHA_CREA>Lc_Serie.FECHA_CREA and Lc_TotalSerie.ESTADO!=Lc_Serie.ESTADO THEN

                  UPDATE NAF47_TNET.INV_NUMERO_SERIE
                  SET ESTADO= Lc_TotalSerie.ESTADO,
                  ID_BODEGA=Lc_TotalSerie.ID_BODEGA,
                  MAC=Lc_TotalSerie.MAC
                  WHERE COMPANIA=Lc_Serie.COMPANIA
                  AND SERIE=Lc_Serie.SERIE
                  AND NO_ARTICULO=Lc_Regulariza.NO_ARTICULO_N;

                  IF Lc_TotalSerie.ESTADO='EB' THEN
                    Lb_SerieNueva:=TRUE;
                    Lv_BodegaN:=Lc_Serie.ID_BODEGA;
                    Lv_ArtiN:=Lc_Serie.NO_ARTICULO;
                  ELSE
                    Lb_SerieNueva:=FALSE;
                  END IF;

                END IF;
              END IF;


                --Se regulariza los documentos asociados al artículo

                P_REGULARIZA_MOVIMIENTOS (Lc_Regulariza.COMPANIA,
                                          Lc_Regulariza.NO_ARTICULO_N,
                                          Lc_Regulariza.SERIE,
                                          Lc_Regulariza.COMPANIA,--tipo de como inicia el artículo ej: 10 o 18
                                          Lv_Documentos,
                                          Lv_Resultado);


                IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;

                --regularizo serie en instalación y custodio
                P_REGULARIZA_INST_CUST(Lc_Serie.COMPANIA,
                                       Lc_Regulariza.SERIE,
                                       Lc_Regulariza.NO_ARTICULO_N,
                                       Lc_Serie.NO_ARTICULO,
                                       Lv_Resultado);

                IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;                       
                --Registro detalle de regularizacion de de serie y articulos
                P_INSERTA_RES_REGULARIZACION (Lc_Regulariza.SERIE,
                                              Lc_Regulariza.NO_ARTICULO_N,
                                              Lc_Serie.NO_ARTICULO,
                                              Lv_Observacion,
                                              Lv_Resultado);


               IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;  




            EXCEPTION

              WHEN Le_ErrorBloque THEN
                Lv_estado:='E';
              WHEN OTHERS THEN
                Lv_Resultado:=SUBSTR('Error en serie : '||Lc_Regulariza.SERIE||':'||SQLERRM ,1,2000);
                Lv_estado:='E';

            END;
         Lv_Resultado:='Regulariza';
         Ln_Regulariza:=Ln_Regulariza+1;

      --Valida si el artículo a reemplazar es usado US
      ELSIF Lc_Regulariza.NO_ARTICULO_US != Lc_Serie.NO_ARTICULO AND SUBSTR(Lc_Serie.NO_ARTICULO,1,2) ='US'  AND Lc_Regulariza.NO_ARTICULO_US IS NOT NULL THEN



          OPEN C_TOTAL_SERIE (Lc_Serie.COMPANIA,Lc_Serie.SERIE,Lc_Regulariza.NO_ARTICULO_US);
          FETCH C_TOTAL_SERIE INTO Lc_TotalSerie;

            IF C_TOTAL_SERIE%FOUND THEN
              Ln_ExisteSerie:=1;
            ELSE
              Ln_ExisteSerie:=0;
            END IF;
          CLOSE C_TOTAL_SERIE;

            BEGIN
              --Si no existe un articulo igual actualizo registro con artículo nuevo
              IF Ln_ExisteSerie =0 THEN
                Lv_Observacion:=SUBSTR('Actualiza Usado: '||Lc_Regulariza.SERIE||' Articulo real: '||Lc_Regulariza.NO_ARTICULO_US ||' '||'Articulo no real: '||Lc_Serie.NO_ARTICULO||' '||CHR(13),1,2000);

                --Valido que exista el artículo en la bodega
                IF NOT(NAF47_TNET.ARTICULO.EXISTE(Lc_Serie.COMPANIA,Lc_Serie.ID_BODEGA,Lc_Regulariza.NO_ARTICULO_US)) AND Lc_Serie.ESTADO='EB' THEN

                OPEN C_DATOS_ARTI_BODEGA(Lc_Serie.COMPANIA,Lc_Serie.ID_BODEGA,Lc_Serie.NO_ARTICULO);
                FETCH C_DATOS_ARTI_BODEGA INTO Lc_Arinma;
                IF C_DATOS_ARTI_BODEGA%FOUND THEN
                  P_INSERTA_ARINMA (Lc_Arinma,
                                    Lc_Regulariza.NO_ARTICULO_US,
                                    Lv_Resultado);
                   IF Lv_Resultado IS NOT NULL THEN
                     RAISE Le_ErrorBloque;
                   END IF;
                   Lb_InserArinmaU:=TRUE;
                ELSE
                  Lb_InserArinmaU:=FALSE;                      
                END IF;
                CLOSE C_DATOS_ARTI_BODEGA;

                END IF;

                IF  Lc_Serie.ESTADO='EB' THEN
                    Lb_SerieUsada:=TRUE;
                    Lv_BodegaU:=Lc_Serie.ID_BODEGA;
                    Lv_ArtiU:=Lc_Serie.NO_ARTICULO;
                ELSE
                    Lb_SerieUsada:=FALSE;
                END IF;

                UPDATE NAF47_TNET.INV_NUMERO_SERIE
                SET NO_ARTICULO= Lc_Regulariza.NO_ARTICULO_US
                WHERE COMPANIA=Lc_Serie.COMPANIA
                AND SERIE=Lc_Serie.SERIE
                AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;

                UPDATE NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
                SET NO_ARTICULO= Lc_Regulariza.NO_ARTICULO_US
                WHERE COMPANIA=Lc_Serie.COMPANIA
                AND SERIE=Lc_Serie.SERIE
                AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;

              --Caso contrario pongo estado El
              ELSE

                Lv_Observacion:=SUBSTR('Actualiza estado EL articulo usado : '||Lc_Regulariza.SERIE||' Articulo real: '||Lc_Regulariza.NO_ARTICULO_US ||' '||'Articulo no real: '||Lc_Serie.NO_ARTICULO,1,2000);

                UPDATE NAF47_TNET.INV_NUMERO_SERIE
                SET ESTADO= 'EL'
                WHERE COMPANIA=Lc_Serie.COMPANIA
                AND SERIE=Lc_Serie.SERIE
                AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;

                --Si el registro que se elimina es mas reciente que el registro correcto y con diferentes estados
                --Se modifican los estados
                IF Lc_TotalSerie.FECHA_CREA>Lc_Serie.FECHA_CREA and Lc_TotalSerie.ESTADO!=Lc_Serie.ESTADO THEN

                  UPDATE NAF47_TNET.INV_NUMERO_SERIE
                  SET ESTADO= Lc_TotalSerie.ESTADO,
                  ID_BODEGA=Lc_TotalSerie.ID_BODEGA,
                  MAC=Lc_TotalSerie.MAC
                  WHERE COMPANIA=Lc_Serie.COMPANIA
                  AND SERIE=Lc_Serie.SERIE
                  AND NO_ARTICULO=Lc_Regulariza.NO_ARTICULO_US;

                  IF Lc_TotalSerie.ESTADO='EB' THEN
                    Lb_SerieUsada:=TRUE;
                    Lv_BodegaU:=Lc_Serie.ID_BODEGA;
                    Lv_ArtiU:=Lc_Serie.NO_ARTICULO;
                  ELSE
                    Lb_SerieUsada:=FALSE;
                  END IF;

                END IF;

              END IF;


                --Se regulariza los documentos asociados al artículo


                P_REGULARIZA_MOVIMIENTOS (Lc_Regulariza.COMPANIA,
                                          Lc_Regulariza.NO_ARTICULO_US,
                                          Lc_Regulariza.SERIE,
                                          'US',
                                          Lv_Documentos,
                                          Lv_Resultado);

                IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;


                --regularizo serie en instalación y custodio
                P_REGULARIZA_INST_CUST(Lc_Serie.COMPANIA,
                                       Lc_Regulariza.SERIE,
                                       Lc_Regulariza.NO_ARTICULO_US,
                                       Lc_Serie.NO_ARTICULO,
                                       Lv_Resultado);
                IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;

                --Registro detalle de regularizacion de de serie y articulos
                P_INSERTA_RES_REGULARIZACION (Lc_Regulariza.SERIE,
                                              Lc_Regulariza.NO_ARTICULO_US,
                                              Lc_Serie.NO_ARTICULO,
                                              Lv_Observacion,
                                              Lv_Resultado);
                IF Lv_Resultado IS NOT NULL THEN
                  RAISE Le_ErrorBloque;
                END IF;


            EXCEPTION
              WHEN Le_ErrorBloque THEN
                Lv_estado:='E';
              WHEN OTHERS THEN
                Lv_Resultado:=SUBSTR('Error en serie : '||Lc_Regulariza.SERIE||':'||SQLERRM ,1,2000);
                Lv_estado:='E';

            END;
        Lv_Resultado:='Regulariza';
        Ln_Regulariza:=Ln_Regulariza+1;
      END IF;

    END LOOP;

    -- Se actualiza stock del artículo nuevo
    IF Lb_SerieNueva THEN
      BEGIN
          --Se baja stock al artículo actual
          NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO (Lc_Regulariza.COMPANIA,
                                                  Lv_BodegaN,
                                                  Lv_ArtiN,
                                                  'CONSUMO',
                                                  1,
                                                  0,
                                                  NULL,
                                                  Lv_Resultado);
          IF NOT Lb_InserArinma THEN
            --Se suma stock al artículo que se actualiza la serie
            NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO (Lc_Regulariza.COMPANIA,
                                                               Lv_BodegaN,
                                                               Lc_Regulariza.NO_ARTICULO_N,
                                                               'PRODUCCION',
                                                               1,
                                                               0,
                                                               NULL,
                                                               Lv_Resultado);

          END IF;
      EXCEPTION

         WHEN OTHERS THEN
           Lv_Resultado:=SUBSTR('Error en serie : '||Lc_Regulariza.SERIE||':'||SQLERRM ,1,2000);
           Lv_estado:='E';
      END;
    END IF;


    -- Se actualiza stock del artículo usado
    IF Lb_SerieUsada THEN
      BEGIN
          --Se baja stock al artículo actual
          NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO (Lc_Regulariza.COMPANIA,
                                                  Lv_BodegaU,
                                                  Lv_ArtiU,
                                                  'CONSUMO',
                                                  1,
                                                  0,
                                                  NULL,
                                                  Lv_Resultado);


          IF NOT Lb_InserArinmaU THEN
            --Se suma stock al artículo que se actualiza la serie
            NAF47_TNET.INACTUALIZA_SALDOS_ARTICULO (Lc_Regulariza.COMPANIA,
                                                    Lv_BodegaU,
                                                    Lc_Regulariza.NO_ARTICULO_US,
                                                    'PRODUCCION',
                                                    1,
                                                    0,
                                                    NULL,
                                                    Lv_Resultado);

          END IF;
      EXCEPTION

         WHEN OTHERS THEN
           Lv_Resultado:=SUBSTR('Error en serie : '||Lc_Regulariza.SERIE||':'||SQLERRM ,1,2000);
           Lv_estado:='E';    
      END;
    END IF;

    --Se no se modifica el artículo en la serie, se valida si los movimientos estan correctos

    IF Ln_Regulariza<=1 THEN


          --para artículos nuevos
          Lv_Tipo:= Lc_Regulariza.COMPANIA;
          P_REGULARIZA_MOVIMIENTOS (Lc_Regulariza.COMPANIA,
                                   Lc_Regulariza.NO_ARTICULO_N,
                                   Lc_Regulariza.SERIE,
                                   Lv_Tipo,
                                   Lv_Documentos,
                                   Lv_Resultado);

          --para artículos usados
          P_REGULARIZA_MOVIMIENTOS (Lc_Regulariza.COMPANIA,
                                    Lc_Regulariza.NO_ARTICULO_US,
                                    Lc_Regulariza.SERIE,
                                    'US',
                                    Lv_Documentos,
                                    Lv_Resultado);

         Lv_Resultado:='Regulariza';

    END IF;
    UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES
      SET ESTADO=Lv_estado,
      OBSERVACION=SUBSTR(Lv_Resultado||' '|| Lv_Documentos,1,2000),
      FECHA_ACTUALIZACION= SYSDATE,
      USUARIO_ACTUALIZACION= USER
    WHERE SERIE=Lc_Regulariza.SERIE
    AND COMPANIA=Lc_Regulariza.COMPANIA
    AND EVENTO='A';


    IF Ln_Commit >= 100 THEN
      Ln_Commit:=0;
      COMMIT;
    ELSE
      Ln_Commit:=Ln_Commit+1;
    END IF;

  END LOOP;
  COMMIT;

  Pv_Resultado:='OK';

  EXCEPTION
    WHEN OTHERS THEN
       Pv_Error := 'Error en INKG_REGULARIZA_SERIES.P_REGULARIZA_ARTICULO_SERIES: '||SQLERRM; 
  END P_REGULARIZA_ARTICULO_SERIES;


 PROCEDURE P_INSERTA_RES_REGULARIZACION(Pv_Serie            INV_REGULARIZACION_SERIES_RES.SERIE%TYPE,
                                        Pv_ArticuloNo       INV_REGULARIZACION_SERIES_RES.ARTICULO_NO%TYPE,
                                        Pv_ArticuloAnterior INV_REGULARIZACION_SERIES_RES.ARTICULO_ANTERIOR%TYPE,
                                        Pv_Observacion      INV_REGULARIZACION_SERIES_RES.OBSERVACION%TYPE,
                                        Pv_Error            OUT VARCHAR2) AS

BEGIN

  INSERT INTO NAF47_TNET.INV_REGULARIZACION_SERIES_RES(
      SERIE,
      ARTICULO_NO,
      ARTICULO_ANTERIOR,
      OBSERVACION
  )
  VALUES (
      Pv_Serie,
      Pv_ArticuloNo,
      Pv_ArticuloAnterior,
      Pv_Observacion
  );
  EXCEPTION
    WHEN OTHERS THEN
       Pv_Error := 'Error en INKG_REGULARIZA_SERIES.P_INSERTA_RES_REGULARIZACION: '||SQLERRM; 
  END P_INSERTA_RES_REGULARIZACION;

  PROCEDURE P_REGULARIZA_INST_CUST(Pv_Compania         INV_NUMERO_SERIE.COMPANIA%TYPE,
                                   Pv_Serie            INV_NUMERO_SERIE.SERIE%TYPE,
                                   Pv_ArticuloNo       INV_NUMERO_SERIE.NO_ARTICULO%TYPE,
                                   Pv_ArticuloAnterior INV_NUMERO_SERIE.NO_ARTICULO%TYPE,
                                   Pv_Error            OUT VARCHAR2) AS

  BEGIN
    --Actualizo artículo de la instalación
    UPDATE NAF47_TNET.IN_ARTICULOS_INSTALACION
    SET ID_ARTICULO=Pv_ArticuloNo
    WHERE NUMERO_SERIE=Pv_Serie 
    AND ID_COMPANIA=Pv_Compania
    AND ID_ARTICULO=Pv_ArticuloAnterior;

    --Actualizo el artículo en el custodio
    UPDATE NAF47_TNET.ARAF_CONTROL_CUSTODIO
    SET NO_ARTICULO=Pv_ArticuloNo
    WHERE ARTICULO_ID=Pv_Serie
    AND EMPRESA_ID=Pv_Compania;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error en INKG_REGULARIZA_SERIES.P_REGULARIZA_INST_CUST: '||SQLERRM;   
  END;



  PROCEDURE P_INSERTA_ARINML (Pt_DetalleMov ARINML%ROWTYPE,
                              Pv_NoArti     ARINML.NO_ARTI%TYPE,
                              Pn_linea      NUMBER,
                              Pn_CostoUni   ARINMN.COSTO_UNI%TYPE,
                              Pn_Costo2     ARINMN.COSTO2%TYPE,
                              Pv_Error      OUT VARCHAR2) AS

  BEGIN
    INSERT INTO NAF47_TNET.ARINML (
                 NO_CIA,
                 CENTRO,
                 TIPO_DOC,
                 PERIODO,
                 RUTA,
                 NO_DOCU,
                 LINEA,
                 LINEA_EXT,
                 BODEGA,
                 CLASE,
                 CATEGORIA,
                 NO_ARTI,
                 IND_IV,
                 UNIDADES,
                 MONTO,
                 DESCUENTO_L,
                 IMPUESTO_L,
                 TIPO_CAMBIO,
                 MONTO_DOL,
                 IND_OFERTA,
                 NO_ORDEN,
                 LINEA_ORDEN,
                 CENTRO_COSTO,
                 IMPUESTO_L_INCLUIDO,
                 DANADOS,
                 BODEGA_LOCAL,
                 PRECIO_VENTA,
                 CANTIDAD_EQ,
                 UNIDAD_EQ,
                 UNIDAD_EMPAQUE,
                 CANTIDAD_EMPAQUE,
                 CODIGO_ALTERNO,
                 IMPUESTOS_COSTO,
                 RECONOCE_RECLAMOPROV,
                 CONFIRMA_RECLAMOPROV,
                 TIME_STAMP,
                 MONTO2,
                 MONTO2_DOL,
                 UNIDADES_COMP,
                 APLICA_CANJE
            ) VALUES (
                Pt_DetalleMov.NO_CIA,
                Pt_DetalleMov.CENTRO,
                Pt_DetalleMov.TIPO_DOC,
                Pt_DetalleMov.PERIODO,
                Pt_DetalleMov.RUTA,
                Pt_DetalleMov.NO_DOCU,
                Pn_linea,
                Pn_linea,--LINEA_EXT
                Pt_DetalleMov.BODEGA,
                Pt_DetalleMov.CLASE,
                Pt_DetalleMov.CATEGORIA,
                Pv_NoArti,
                Pt_DetalleMov.IND_IV,
                1,
                (1*Pn_CostoUni),--MONTO
                Pt_DetalleMov.DESCUENTO_L,
                Pt_DetalleMov.IMPUESTO_L,
                Pt_DetalleMov.TIPO_CAMBIO,
                (1*Pn_CostoUni),--MONTO_DOL,
                Pt_DetalleMov.IND_OFERTA,
                Pt_DetalleMov.NO_ORDEN,
                Pt_DetalleMov.LINEA_ORDEN,
                Pt_DetalleMov.CENTRO_COSTO,
                Pt_DetalleMov.IMPUESTO_L_INCLUIDO,
                Pt_DetalleMov.DANADOS,
                Pt_DetalleMov.BODEGA_LOCAL,
                Pt_DetalleMov.PRECIO_VENTA,
                Pt_DetalleMov.CANTIDAD_EQ,
                Pt_DetalleMov.UNIDAD_EQ,
                Pt_DetalleMov.UNIDAD_EMPAQUE,
                Pt_DetalleMov.CANTIDAD_EMPAQUE,
                Pt_DetalleMov.NO_ARTI,--Código donde se originó el movimiento
                Pt_DetalleMov.IMPUESTOS_COSTO,
                Pt_DetalleMov.RECONOCE_RECLAMOPROV,
                Pt_DetalleMov.CONFIRMA_RECLAMOPROV,
                Pt_DetalleMov.TIME_STAMP,
                (1*Pn_Costo2),--MONTO2
                (1*Pn_Costo2),--MONTO2_DOL
                Pt_DetalleMov.UNIDADES_COMP,
                Pt_DetalleMov.APLICA_CANJE
            );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error:='Error en P_INSERTA_ARINML: '|| SQLERRM;          
  END P_INSERTA_ARINML;

  PROCEDURE P_INSERTA_ARINMN (Pt_HistDetalleMov ARINMN%ROWTYPE,
                              Pv_NoArti     ARINML.NO_ARTI%TYPE,
                              Pn_linea      NUMBER,
                              Pv_Error      OUT VARCHAR2) AS

  BEGIN
    INSERT INTO NAF47_TNET.ARINMN (
        NO_CIA,
        CENTRO,
        TIPO_DOC,
        ANO,
        RUTA,
        NO_DOCU,
        NO_LINEA,
        BODEGA,
        CLASE,
        CATEGORIA,
        NO_ARTI,
        COSTO_UNI,
        FECHA,
        UNIDADES,
        MONTO,
        COSTO,
        COSTO_ANT,
        VENDEDOR,
        VENTA,
        DESCUENTO,
        IND_OFERTA,
        TIPO_REFE,
        NO_REFE,
        CONDUCE,
        OBSERV1,
        NO_PROVE,
        TIME_STAMP,
        MES,
        PERIODO_PROCE,
        SEMANA,
        CENTRO_COSTO,
        PRECIO_VENTA,
        MONTO2,
        COSTO2,
        COSTO_UNO_PROMEDIO,
        COSTO_DOS_PROMEDIO
    ) VALUES (
        Pt_HistDetalleMov.NO_CIA,
        Pt_HistDetalleMov.CENTRO,
        Pt_HistDetalleMov.TIPO_DOC,
        Pt_HistDetalleMov.ANO,
        Pt_HistDetalleMov.RUTA,
        Pt_HistDetalleMov.NO_DOCU,
        Pn_Linea,
        Pt_HistDetalleMov.BODEGA,
        Pt_HistDetalleMov.CLASE,
        Pt_HistDetalleMov.CATEGORIA,
        Pv_NoArti,
        Pt_HistDetalleMov.COSTO_UNI,
        Pt_HistDetalleMov.FECHA,
        1,--UNIDADES
        (1*Pt_HistDetalleMov.COSTO_UNI),--MONTO
        Pt_HistDetalleMov.COSTO,
        Pt_HistDetalleMov.COSTO_ANT,
        Pt_HistDetalleMov.VENDEDOR,
        Pt_HistDetalleMov.VENTA,
        Pt_HistDetalleMov.DESCUENTO,
        Pt_HistDetalleMov.IND_OFERTA,
        Pt_HistDetalleMov.TIPO_REFE,
        Pt_HistDetalleMov. NO_REFE,
        Pt_HistDetalleMov.CONDUCE,
        Pt_HistDetalleMov.OBSERV1,
        Pt_HistDetalleMov.NO_PROVE,
        Pt_HistDetalleMov.TIME_STAMP,
        Pt_HistDetalleMov.MES,
        Pt_HistDetalleMov.PERIODO_PROCE,
        Pt_HistDetalleMov.SEMANA,
        Pt_HistDetalleMov.CENTRO_COSTO,
        Pt_HistDetalleMov.PRECIO_VENTA,
        (1*Pt_HistDetalleMov.COSTO2),--MONTO2
        Pt_HistDetalleMov.COSTO2,
        Pt_HistDetalleMov.COSTO_UNO_PROMEDIO,
        Pt_HistDetalleMov.COSTO_DOS_PROMEDIO
        );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error:='Error en P_INSERTA_ARINMN: '|| SQLERRM;       
  END  P_INSERTA_ARINMN;

  PROCEDURE P_INSERTA_ARINMA (Pt_Arinma     ARINMA%ROWTYPE,
                              Pv_NoArti     ARINMA.NO_ARTI%TYPE,
                              Pv_Error      OUT VARCHAR2) AS

  BEGIN

    INSERT INTO NAF47_TNET.ARINMA (
        NO_CIA,
        BODEGA,
        NO_ARTI,
        CLASE,
        CATEGORIA,
        UBICACION,
        SAL_ANT_UN,
        COMP_UN,
        OTRS_UN,
        VENT_UN,
        CONS_UN,
        SAL_PEND_UN,
        ENT_PEND_UN,
        PEDIDOS_PEND,
        MANIFIESTOPEND,
        SAL_ANT_MO,
        COMP_MON,
        OTRS_MON,
        VENT_MON,
        CONS_MON,
        COSTO_UNI,
        PROCESO_SOLI,
        NO_SOLIC,
        ULT_COSTO,
        AFECTA_COSTO,
        FEC_U_VEN,
        PROCESO_TOMA,
        EXIST_PREP,
        COSTO_PREP,
        CANT_NO_INV,
        ACTIVO,
        FEC_U_COMP,
        COSTO2,
        MONTO2,
        ULT_COSTO2
    ) VALUES (
        Pt_Arinma.NO_CIA,
        Pt_Arinma.BODEGA,
        Pv_NoArti,
        Pt_Arinma.CLASE,
        Pt_Arinma.CATEGORIA,
        Pt_Arinma.UBICACION,
        1, --SAL_ANT_UN
        0, --COMP_UN
        0, --OTRS_UN
        0, --VENT_UN
        0, --CONS_UN
        0, --SAL_PEND_UN
        0, --ENT_PEND_UN
        0, --PEDIDOS_PEND,
        0, --MANIFIESTOPEND
        Pt_Arinma.SAL_ANT_MO,
        0, --COMP_MON
        0, --OTRS_MON
        0, --VENT_MON
        0, --CONS_MON
        Pt_Arinma.COSTO_UNI,
        Pt_Arinma.PROCESO_SOLI,
        Pt_Arinma.NO_SOLIC,
        Pt_Arinma.ULT_COSTO,
        Pt_Arinma.AFECTA_COSTO,
        Pt_Arinma.FEC_U_VEN,
        Pt_Arinma.PROCESO_TOMA,
        Pt_Arinma.EXIST_PREP,
        Pt_Arinma.COSTO_PREP,
        Pt_Arinma.CANT_NO_INV,
        Pt_Arinma.ACTIVO,
        Pt_Arinma.FEC_U_COMP,
        Pt_Arinma.COSTO2,
        Pt_Arinma.MONTO2,
        Pt_Arinma.ULT_COSTO2
    );

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error:='Error en P_INSERTA_ARINMA: '|| SQLERRM; 
  END P_INSERTA_ARINMA;   


  PROCEDURE P_REGULARIZA_MOVIMIENTOS (Pv_compania    VARCHAR2,
                                      Pv_NoArti      VARCHAR2,
                                      Pv_Serie       VARCHAR2,
                                      Pv_Tipo        VARCHAR2,
                                      Pv_Documentos  IN OUT VARCHAR2,
                                      Pv_Error       OUT VARCHAR2) AS

   CURSOR C_MOVIMIENTOS_ARTICULO(Cv_Serie INV_DOCUMENTO_SERIE.SERIE%TYPE,
                                Cv_Articulo ARINMN.NO_ARTI%TYPE) IS
    SELECT
    IDS.SERIE,
    IDS.COMPANIA,
    ME.TIPO_DOC,
    TM.DESCRI        TIPO_DOCUMENTO,
    IDS.ID_DOCUMENTO,
    IDS.LINEA,
    MN.BODEGA,
    BO.DESCRIPCION   NOMBRE_BODEGA,
    MN.NO_ARTI,
    MN.UNIDADES,
    MN.COSTO_UNI,
    MN.COSTO2,
    MN.FECHA,
    DECODE(TM.MOVIMI, 'E', 1, 0) ENTRADA,
    DECODE(TM.MOVIMI, 'S', 1, 0) SALIDA,
    ME.NO_PEDIDO,
    ME.USUARIO,
    ME.OBSERV1,
    TO_DATE(MN.TIME_STAMP,'DD/MM/YYYY HH24:MI:SS')
    FROM
    NAF47_TNET.ARINVTM               TM,
    NAF47_TNET.ARINBO                BO,
    NAF47_TNET.ARINME                ME,
    NAF47_TNET.ARINMN                MN,
    NAF47_TNET.INV_DOCUMENTO_SERIE   IDS
    WHERE
    ME.TIPO_DOC = TM.TIPO_M
    AND ME.NO_CIA = TM.NO_CIA
    AND MN.BODEGA = BO.CODIGO
    AND MN.NO_CIA = BO.NO_CIA
    AND MN.NO_DOCU = ME.NO_DOCU
    AND MN.NO_CIA = ME.NO_CIA
    AND IDS.LINEA = MN.NO_LINEA
    AND IDS.ID_DOCUMENTO = MN.NO_DOCU
    AND IDS.COMPANIA = MN.NO_CIA
    AND IDS.COMPANIA = Pv_compania
    AND IDS.SERIE = Cv_Serie
    AND MN.NO_ARTI!=Cv_Articulo
    AND SUBSTR(MN.NO_ARTI,1,2)=Pv_Tipo
    ORDER BY TIME_STAMP, ID_DOCUMENTO;

    CURSOR C_DETALLE_MOVIMIENTO (Cv_Compania ARINML.NO_CIA%type,
                               Cv_Documento ARINML.NO_DOCU%type,
                               Cv_Linea ARINML.linea%type) IS

    SELECT *
    FROM NAF47_TNET.ARINML 
    WHERE NO_CIA=Cv_Compania 
    AND NO_DOCU=Cv_Documento 
    AND LINEA=Cv_Linea;

    CURSOR C_HIST_DETALLE_MOVIMIENTO (Cv_Compania ARINMN.NO_CIA%type,
                                    Cv_Documento ARINMN.NO_DOCU%type,
                                    Cv_Linea ARINMN.NO_LINEA%type) IS

    SELECT *
    FROM NAF47_TNET.ARINMN 
    WHERE NO_CIA=Cv_Compania 
    AND NO_DOCU=Cv_Documento 
    AND NO_LINEA=Cv_Linea;  


  CURSOR C_LINEA_DETALLE (Cv_Compania ARINMN.NO_CIA%type,
                          Cv_Documento ARINMN.NO_DOCU%type)IS
  SELECT
    NVL(MAX(LINEA), 0) + 1
  FROM
    NAF47_TNET.ARINML
  WHERE
    NO_CIA = Cv_Compania
    AND NO_DOCU = Cv_Documento;


  CURSOR C_EXISTE_DOC_ARTICULO(Cv_Compania  ARINML.NO_CIA%type,
                               Cv_Documento ARINML.NO_DOCU%type,
                               Cv_NoArti    ARINML.NO_ARTI%type)IS

  SELECT COUNT(*)TOTAL,LINEA
  FROM NAF47_TNET.ARINML 
  WHERE NO_CIA=Cv_Compania 
  AND NO_DOCU=Cv_Documento 
  AND NO_ARTI=Cv_NoArti
  GROUP BY LINEA ;

  CURSOR C_EXISTE_DOC_ARTICULO_HIST(Cv_Compania  ARINMN.NO_CIA%type,
                                    Cv_Documento ARINMN.NO_DOCU%type,
                                    Cv_NoArti    ARINMN.NO_ARTI%type)IS

  SELECT COUNT(*)TOTAL,NO_LINEA
  FROM NAF47_TNET.ARINMN 
  WHERE NO_CIA=Cv_Compania 
  AND NO_DOCU=Cv_Documento 
  AND NO_ARTI=Cv_NoArti
  GROUP BY NO_LINEA;



  Lc_DetMovimiento     C_DETALLE_MOVIMIENTO%ROWTYPE; 
  Lc_HistDetMovimiento C_HIST_DETALLE_MOVIMIENTO%ROWTYPE;
  Lc_ExisteDocArti     C_EXISTE_DOC_ARTICULO%ROWTYPE;
  Lc_ExisteDocArtiH    C_EXISTE_DOC_ARTICULO_HIST%ROWTYPE;
  Lv_Error             VARCHAR2(2000);
  Ln_linea             ARINML.LINEA%TYPE;
  Ln_ExisteDocArtiH    NUMBER;
  Ln_ExisteDocArti     number;
  Le_Error             EXCEPTION;
  BEGIN

     --Verifico si existen movimientos con artículos que no corrsponden
     FOR LC_MovimientoArticulo IN  C_MOVIMIENTOS_ARTICULO(Pv_Serie,Pv_NoArti ) LOOP
       IF LC_MovimientoArticulo.UNIDADES>=0 THEN

         --obtengo el número maximo de linea + 1
         OPEN  C_LINEA_DETALLE(LC_MovimientoArticulo.COMPANIA,
                                   LC_MovimientoArticulo.ID_DOCUMENTO);
         FETCH C_LINEA_DETALLE INTO Ln_linea;
         CLOSE C_LINEA_DETALLE;

         --obtengo información del movimiento a regularizar
         OPEN C_DETALLE_MOVIMIENTO (LC_MovimientoArticulo.COMPANIA,
                                    LC_MovimientoArticulo.ID_DOCUMENTO,
                                    LC_MovimientoArticulo.LINEA);
         FETCH C_DETALLE_MOVIMIENTO INTO Lc_DetMovimiento;

           IF C_DETALLE_MOVIMIENTO%FOUND THEN


             OPEN C_EXISTE_DOC_ARTICULO(LC_MovimientoArticulo.COMPANIA,
                                        LC_MovimientoArticulo.ID_DOCUMENTO,
                                        Pv_NoArti);
             FETCH C_EXISTE_DOC_ARTICULO INTO LC_ExisteDocArti;

             IF C_EXISTE_DOC_ARTICULO%FOUND THEN
               Ln_ExisteDocArti:=Lc_ExisteDocArti.TOTAL;
             END IF;
             CLOSE C_EXISTE_DOC_ARTICULO;

             --Valido si que ya se generado registro por otras series
             IF NVL(Ln_ExisteDocArti,0)=0 THEN
               --Se inserta nueva linea 
               P_INSERTA_ARINML (Lc_DetMovimiento,
                                 Pv_NoArti,
                                 Ln_linea,
                                 LC_MovimientoArticulo.COSTO_UNI,
                                 LC_MovimientoArticulo.COSTO2,
                                 Lv_Error) ;
               IF Lv_Error IS NOT NULL THEN
                 IF C_DETALLE_MOVIMIENTO%ISOPEN THEN
                   CLOSE C_DETALLE_MOVIMIENTO;
                 END IF;
                 RAISE Le_Error;
               END IF;                  
             ELSE
               --Se actualiza registro ya existente
               UPDATE NAF47_TNET.ARINML 
               SET UNIDADES=UNIDADES+1,
               MONTO=(UNIDADES+1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO_DOL=(UNIDADES+1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO2=(UNIDADES+1)*LC_MovimientoArticulo.COSTO2,
               MONTO2_DOL=(UNIDADES+1)*LC_MovimientoArticulo.COSTO2
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
               AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
               AND NO_ARTI=Pv_NoArti;

               Ln_linea:=Lc_ExisteDocArti.LINEA;

             END IF;

              --Si las unidades van a quedar en 0 se actualiza las unidades al detalle de documento  
             IF (Lc_DetMovimiento.UNIDADES-1)>0 THEN 

               UPDATE NAF47_TNET.ARINML 
               SET UNIDADES=UNIDADES-1,
               MONTO=(UNIDADES-1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO_DOL=(UNIDADES-1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO2=(UNIDADES-1)*LC_MovimientoArticulo.COSTO2,
               MONTO2_DOL=(UNIDADES-1)*LC_MovimientoArticulo.COSTO2,
               CODIGO_ALTERNO=Pv_NoArti
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
                 AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
                 AND LINEA=LC_MovimientoArticulo.LINEA;

             ELSE
               --Caso contrario elimino registro que queda en 0
               DELETE FROM NAF47_TNET.ARINML
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
                AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
                AND LINEA=LC_MovimientoArticulo.LINEA;
             END IF; 
           END IF;

         CLOSE C_DETALLE_MOVIMIENTO;

         OPEN C_HIST_DETALLE_MOVIMIENTO (LC_MovimientoArticulo.COMPANIA,
                                    LC_MovimientoArticulo.ID_DOCUMENTO,
                                    LC_MovimientoArticulo.LINEA);
         FETCH C_HIST_DETALLE_MOVIMIENTO INTO Lc_HistDetMovimiento;
           IF C_HIST_DETALLE_MOVIMIENTO%FOUND THEN


             OPEN C_EXISTE_DOC_ARTICULO_HIST(LC_MovimientoArticulo.COMPANIA,
                                        LC_MovimientoArticulo.ID_DOCUMENTO,
                                        Pv_NoArti);
             FETCH C_EXISTE_DOC_ARTICULO_HIST INTO Lc_ExisteDocArtiH;
               IF  C_EXISTE_DOC_ARTICULO_HIST%FOUND THEN
                 Ln_ExisteDocArtiH:=Lc_ExisteDocArtiH.TOTAL;
               END IF;
             CLOSE C_EXISTE_DOC_ARTICULO_HIST;

             --Valido si que ya se generado registro por otrs series
             IF NVL(Ln_ExisteDocArtiH,0)=0 THEN
               --Se inserta nueva linea en histórico de detalle de documento 
               P_INSERTA_ARINMN (Lc_HistDetMovimiento,
                                 Pv_NoArti,
                                 Ln_linea,
                                 Lv_Error);

               IF Lv_Error IS NOT NULL THEN
                 IF C_HIST_DETALLE_MOVIMIENTO%ISOPEN THEN
                   CLOSE C_HIST_DETALLE_MOVIMIENTO;
                 END IF;
                 RAISE Le_Error;
               END IF;
             ELSE
               --Se actualiza registro ya existente
               UPDATE NAF47_TNET.ARINMN 
               SET UNIDADES=UNIDADES+1,
               MONTO=(UNIDADES+1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO2=(UNIDADES+1)*LC_MovimientoArticulo.COSTO2
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
               AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
               AND NO_ARTI=Pv_NoArti;
             END IF;

             --Si las unidades van a quedar en 0 se actualiza las unidades al detalle de documento  
             IF (Lc_HistDetMovimiento.UNIDADES-1)>0 THEN 
               UPDATE NAF47_TNET.ARINMN 
               SET UNIDADES=UNIDADES-1,
               MONTO=(UNIDADES-1)*LC_MovimientoArticulo.COSTO_UNI,
               MONTO2=(UNIDADES-1)*LC_MovimientoArticulo.COSTO2
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
                 AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
                 AND NO_LINEA=LC_MovimientoArticulo.LINEA;

             ELSE
               --Caso contrario elimino registro que queda en 0
               DELETE FROM NAF47_TNET.ARINMN
               WHERE NO_CIA=LC_MovimientoArticulo.COMPANIA 
                 AND NO_DOCU=LC_MovimientoArticulo.ID_DOCUMENTO 
                 AND NO_LINEA=LC_MovimientoArticulo.LINEA;
             END IF;
           END IF;
         CLOSE C_HIST_DETALLE_MOVIMIENTO;

         --Actualizo linea en documento de la serie
         UPDATE NAF47_TNET.INV_DOCUMENTO_SERIE
         SET LINEA=Ln_linea
         WHERE COMPANIA=LC_MovimientoArticulo.COMPANIA 
         AND ID_DOCUMENTO= LC_MovimientoArticulo.ID_DOCUMENTO
         AND LINEA=LC_MovimientoArticulo.LINEA
         AND SERIE=Pv_Serie;

         Pv_Documentos:=Pv_Documentos||LC_MovimientoArticulo.ID_DOCUMENTO||'-';
       END IF;
     END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_Error:='Error en P_REGULARIZA_MOVIMIENTOS:'|| Lv_Error;  
    WHEN OTHERS THEN
      Pv_Error:='Error en P_REGULARIZA_MOVIMIENTOS:'|| SQLERRM;
  END P_REGULARIZA_MOVIMIENTOS; 


  PROCEDURE P_REGULARIZA_CODIGO_SERIES(Pv_Resultado OUT VARCHAR2,
                                       Pv_Error     OUT VARCHAR2)AS


  --Cursor que contiene series para corregir
  CURSOR C_Regulariza
  IS
    SELECT *
    FROM NAF47_TNET.INV_REGULARIZACION_SERIES
    WHERE ESTADO='I'
    AND EVENTO='S';

  --Cursor que obtiene registros de una serie especifica
  CURSOR C_VERIFICA_SERIE (Cv_Compania NAF47_TNET.INV_NUMERO_SERIE.COMPANIA%TYPE,
                           Cv_Serie NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE)
  IS
    SELECT *
    FROM NAF47_TNET.INV_NUMERO_SERIE
    WHERE COMPANIA=Cv_Compania
    AND SERIE=Cv_Serie
    AND ESTADO!='EL'
    ORDER BY FECHA_CREA;

  --Cursor que obtiene registro de una serie con un articulo especifio
  CURSOR C_VERIFICA_SERIE_ART (Cv_Compania   NAF47_TNET.INV_NUMERO_SERIE.COMPANIA%TYPE,
                               Cv_Serie      NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE,
                               Cv_NoArticulo NAF47_TNET.INV_NUMERO_SERIE.NO_ARTICULO%TYPE)
  IS
    SELECT *
    FROM NAF47_TNET.INV_NUMERO_SERIE
    WHERE COMPANIA=Cv_Compania
    AND SERIE=Cv_Serie
    AND NO_ARTICULO= Cv_NoArticulo
    AND ESTADO!='EL'
    ORDER BY FECHA_CREA;
   
   
  CURSOR C_MOVIMIENTO_SERIE (Cv_Compania NAF47_TNET.INV_DOCUMENTO_SERIE.COMPANIA%TYPE,
                             Cv_Serie NAF47_TNET.INV_DOCUMENTO_SERIE.SERIE%TYPE)
  IS
    SELECT COMPANIA,
       ID_DOCUMENTO,
       LINEA,
       SERIE
    FROM NAF47_TNET.INV_DOCUMENTO_SERIE
    WHERE COMPANIA = Cv_Compania
    AND SERIE  = Cv_Serie;



  Lc_Serie       C_VERIFICA_SERIE%ROWTYPE;
  Lc_SerieArt    C_VERIFICA_SERIE_ART%ROWTYPE;
  Lv_Error       NAF47_TNET.INV_REGULARIZACION_SERIES.OBSERVACION%TYPE;
  Lv_Observacion NAF47_TNET.INV_REGULARIZACION_SERIES.OBSERVACION%TYPE;
  Lv_Estado      VARCHAR2(5);
  Ln_Commit      NUMBER:=0;

  BEGIN
    --Cursor principal que contiene las series a regularizar

    FOR Lc_Regulariza IN C_Regulariza LOOP
     Lv_estado:='P';
     Lv_Observacion:='';

     IF Lc_Regulariza.SERIE!=Lc_Regulariza.SERIE_N AND Lc_Regulariza.SERIE_N IS NOT NULL THEN

       BEGIN
         --verifico registro con serie incorrecta
         FOR Lc_Serie IN C_VERIFICA_SERIE(Lc_Regulariza.COMPANIA,Lc_Regulariza.SERIE) LOOP
          IF C_VERIFICA_SERIE_ART%ISOPEN THEN CLOSE C_VERIFICA_SERIE_ART; END IF;
           --Valido si no existe una serie correcta
           OPEN C_VERIFICA_SERIE_ART(Lc_Serie.COMPANIA, Lc_Regulariza.SERIE_N, Lc_Serie.NO_ARTICULO);
           FETCH C_VERIFICA_SERIE_ART INTO Lc_SerieArt;

           IF C_VERIFICA_SERIE_ART%FOUND THEN
             UPDATE NAF47_TNET.INV_NUMERO_SERIE
             SET ESTADO='EL'
             WHERE SERIE=Lc_Serie.SERIE
             AND COMPANIA=Lc_Serie.COMPANIA
             AND NO_ARTICULO=Lc_Serie.NO_ARTICULO;

             IF Lc_Serie.FECHA_CREA>Lc_SerieArt.FECHA_CREA AND Lc_Serie.ESTADO!=Lc_SerieArt.ESTADO THEN
               UPDATE NAF47_TNET.INV_NUMERO_SERIE
                SET ESTADO=Lc_Serie.ESTADO,
                ID_BODEGA=Lc_Serie.ID_BODEGA,
                MAC=Lc_Serie.MAC
                WHERE SERIE=Lc_SerieArt.SERIE
                AND COMPANIA=Lc_SerieArt.COMPANIA
                AND NO_ARTICULO=Lc_SerieArt.NO_ARTICULO;
              END IF;
                Lv_Observacion:='INV_NUMERO_SERIE ESTADO = EL ';
            ELSE

              --Actualiza codigo de serie existente por el codigo correcto

              UPDATE NAF47_TNET.INV_NUMERO_SERIE
              SET SERIE=Lc_Regulariza.SERIE_N,
              SERIE_ANTERIOR=Lc_Regulariza.SERIE --Se guarda codigo de serie que se actualiza
              WHERE SERIE=Lc_Regulariza.SERIE
              AND COMPANIA=Lc_Regulariza.COMPANIA
              AND ESTADO!='EL';

              --Valido si se actualiza registros en INV_NUMERO_SERIE
              IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:='INV_NUMERO_SERIE ';
              END IF;

            END IF;

            CLOSE C_VERIFICA_SERIE_ART;

          END LOOP;
         
          --Se valida si existen movimientos con la serie que tiene codigo incorrecto
          Lv_Observacion:=Lv_Observacion||'INV_DOCUMENTO_SERIE[';
          FOR Lc_Movimientos in C_MOVIMIENTO_SERIE(Lc_Regulariza.COMPANIA,Lc_Regulariza.SERIE)LOOP
             --Actualizo la serie en movimientos realizados a la serie
            UPDATE NAF47_TNET.INV_DOCUMENTO_SERIE
             SET SERIE=Lc_Regulariza.SERIE_N
            WHERE COMPANIA=Lc_Regulariza.COMPANIA
            AND ID_DOCUMENTO=Lc_Movimientos.ID_DOCUMENTO
            AND LINEA=Lc_Movimientos.LINEA
            AND SERIE=Lc_Regulariza.SERIE;
           
            Lv_Observacion:=Lv_Observacion||Lc_Movimientos.ID_DOCUMENTO||'-';
          END LOOP;
         
          Lv_Observacion:=Lv_Observacion||']';
         
            --Actualizo pre ingreso de la serie
            UPDATE NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
              SET SERIE=Lc_Regulariza.SERIE_N
            WHERE SERIE=Lc_Regulariza.SERIE
            AND COMPANIA=Lc_Regulariza.COMPANIA;

            --Valido si se actualiza registros en INV_PRE_INGRESO_NUMERO_SERIE
            IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:= Lv_Observacion||' INV_PRE_INGRESO_NUMERO_SERIE ';
            END IF;

            --Actualizo la serie en la esctructura que detalla los articulos que fueron instalados

            UPDATE NAF47_TNET.IN_ARTICULOS_INSTALACION
              SET NUMERO_SERIE=Lc_Regulariza.SERIE_N
            WHERE NUMERO_SERIE=Lc_Regulariza.SERIE
            AND ID_COMPANIA=Lc_Regulariza.COMPANIA;

            --Valido si se actualiza registros en IN_ARTICULOS_INSTALACION
            IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:= Lv_Observacion||' IN_ARTICULOS_INSTALACION ';
            END IF;

            --Actualizo la serie al custodio asignado
            UPDATE NAF47_TNET.ARAF_CONTROL_CUSTODIO
              SET ARTICULO_ID=Lc_Regulariza.SERIE_N
            WHERE ARTICULO_ID=Lc_Regulariza.SERIE
            AND EMPRESA_ID=Lc_Regulariza.COMPANIA;


            --Valido si se actualiza registros en ARAF_CONTROL_CUSTODIO
            IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:= Lv_Observacion||' ARAF_CONTROL_CUSTODIO ';
            END IF; 
           
            --Actualizo en DB_INFRAESTRUCTURA.INFO_ELEMENTO
            UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
            SET SERIE_FISICA =Lc_Regulariza.SERIE_N,
            OBSERVACION=OBSERVACION|| 'Regularización de serie solicitada por bodega '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||' Serie anterior:'||Lc_Regulariza.SERIE
            WHERE SERIE_FISICA =Lc_Regulariza.SERIE;
           
            --Valido si se actualizaron registros
            IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:= Lv_Observacion||' DB_INFRAESTRUCTURA.INFO_ELEMENTO ';
            END IF;
           
            --Actualizo en DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD
            UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD 
            SET NUMERO_SERIE =Lc_Regulariza.SERIE_N,
            OBSERVACION=SUBSTR(OBSERVACION||' Regularización de serie solicitada por bodega '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||' Serie anterior:'||Lc_Regulariza.SERIE,1,500)
            WHERE NUMERO_SERIE =Lc_Regulariza.SERIE;
           
             --Valido si se actualizaron registros
            IF SQL%ROWCOUNT>0 THEN
                Lv_Observacion:= Lv_Observacion||' DB_INFRAESTRUCTURA.INFO_ELEMENTO_TRAZABILIDAD ';
            END IF;
            Lv_Observacion:='Tablas actualizadas: '||Lv_Observacion;   
           
        EXCEPTION
          WHEN OTHERS THEN
            Lv_estado:='E';
            Lv_Observacion:='Error: '||SQLERRM;
       END;
     END IF;

      --Actualizo la bitacora
      UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES
        SET ESTADO=Lv_estado,
        OBSERVACION=Lv_Observacion,
        FECHA_ACTUALIZACION= SYSDATE,
        USUARIO_ACTUALIZACION= USER
        WHERE SERIE=Lc_Regulariza.SERIE
        AND COMPANIA=Lc_Regulariza.COMPANIA
        AND EVENTO='S';
        IF Ln_Commit >= 100 THEN
          Ln_Commit:=0;
          COMMIT;
        ELSE
          Ln_Commit:=Ln_Commit+1;                      
        END IF;


    END LOOP;

    COMMIT;
    Pv_Resultado:='OK'; 
    EXCEPTION
      WHEN OTHERS THEN
        Pv_Error:= 'Error en P_REGULARIZA_CODIGO_SERIES: '||SQLERRM;
  END P_REGULARIZA_CODIGO_SERIES;

  PROCEDURE P_REGULARIZA_INGRESO_EQUIPO(Pv_Resultado OUT VARCHAR2,
										Pv_Error     OUT VARCHAR2) AS
                       
  --Cursor principal que contiene series con su respectivo articulo para regularizar
  CURSOR C_REGULARIZA_SERIES
  IS
    SELECT *
    FROM NAF47_TNET.INV_REGULARIZACION_SERIES
    WHERE ESTADO='I'
    AND EVENTO='R'
    AND  NO_ARTICULO_N IS NOT NULL
    ;
    
  CURSOR C_DATOS_PERIODO ( Cv_Centro VARCHAR2,
                           Cv_NoCia  VARCHAR2) IS
    SELECT P.ANO_PROCE,
           P.DIA_PROCESO,
           P.MES_PROCE,
           C.CLASE_CAMBIO
      FROM NAF47_TNET.ARINCD P,
           NAF47_TNET.ARCGMC C
     WHERE P.NO_CIA = C.NO_CIA
       AND P.CENTRO = Cv_Centro
       AND P.NO_CIA = Cv_NoCia; 
       
  CURSOR C_TIPO_DOC (Cv_NoCia  VARCHAR2) IS
    SELECT PARAMETRO
      FROM NAF47_TNET.GE_PARAMETROS
    WHERE ID_APLICACION = 'IN'
	  AND ID_GRUPO_PARAMETRO = 'DOC_RETIRO_EQ'
	  AND DESCRIPCION = 'ING.  EQUIP  RETIRADOS/CLIENTES'
	  AND ID_EMPRESA = Cv_NoCia ;
  
  CURSOR C_ARTICULO_INGRESO (Cv_noArti NAF47_TNET.ARINDA.NO_ARTI%TYPE,
                             Cv_NoCia NAF47_TNET.ARINDA.NO_CIA%TYPE ) IS
    SELECT DA.NO_ARTI_USADO 
      FROM NAF47_TNET.ARINDA  DA 
    WHERE NO_ARTI=Cv_noArti 
    AND NO_CIA=Cv_NoCia;
    
  CURSOR C_VERIFICA_REPOSITORIO(Cv_Serie Varchar2) IS
  SELECT ID_COMPANIA,ID_ARTICULO,ID_EMPRESA_DESPACHA,ID_CENTRO FROM NAF47_TNET.IN_ARTICULOS_INSTALACION 
  WHERE NUMERO_SERIE=Cv_Serie
  AND ID_INSTALACION = (SELECT MAX(ID_INSTALACION) FROM NAF47_TNET.IN_ARTICULOS_INSTALACION 
  WHERE NUMERO_SERIE=Cv_Serie);
  
  CURSOR C_CUSTODIO (Cv_Responsable NAF47_TNET.ARPLME.NOMBRE%TYPE ) IS
  SELECT NO_EMPLE,CEDULA,NO_CIA
        FROM NAF47_TNET.ARPLME
       WHERE NOMBRE = Cv_Responsable 
         --AND ESTADO = 'A'
         ;  
  
  CURSOR C_ELEMENTO (Cv_Serie NAF47_TNET.V_EQUIPOS_TELCOS.NUMERO_SERIE%TYPE) IS
  SELECT ID_ELEMENTO,ESTADO_ELEMENTO,ESTADO_SERVICIO 
    FROM NAF47_TNET.V_EQUIPOS_TELCOS 
  WHERE NUMERO_SERIE=Cv_Serie
  AND ESTADO_ELEMENTO='Activo';
  
  CURSOR C_MAC (Cv_Serie NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE) IS
  SELECT MAC 
    FROM NAF47_TNET.INV_NUMERO_SERIE 
  WHERE SERIE=Cv_Serie
  AND FECHA_CREA = (SELECT MAX(FECHA_CREA) FROM INV_NUMERO_SERIE WHERE SERIE=Cv_Serie);
  
   
  Lr_DatosPeriodo             C_DATOS_PERIODO%ROWTYPE := NULL;
  Lr_Arinme                   NAF47_TNET.ARINME%ROWTYPE := NULL;
  Lr_Arinml                   NAF47_TNET.ARINML%ROWTYPE := NULL;
  Lr_InvPreIngresoNumeroSerie NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE := NULL;
  Lc_Custodio                 C_CUSTODIO%ROWTYPE:=NULL;
  Lc_Elemento                 C_ELEMENTO%ROWTYPE:=NULL;
  Lc_VerificaRepositorio      C_VERIFICA_REPOSITORIO%ROWTYPE:=NULL;
  Lv_Serie                    NAF47_TNET.IN_ARTICULOS_INSTALACION.NUMERO_SERIE%TYPE;
  Lv_TipoDocumento            NAF47_TNET.GE_PARAMETROS.PARAMETRO%TYPE:= NULL;
  LV_Mac                      NAF47_TNET.INV_NUMERO_SERIE.MAC%TYPE;
  Lv_MensajeError             VARCHAR2(2000);
  Lv_Estado                   VARCHAR2(2);
  Ln_Commit                   NUMBER:=0;
  Ld_FechaAux                 DATE := NULL;
  Lb_Repositorio              BOOLEAN;
  Le_Error                    EXCEPTION;
  BEGIN

    FOR Lc_RegularizaSeries IN C_REGULARIZA_SERIES LOOP
       Lr_Arinme:=NULL;
       Lr_Arinml:=NULL;
       Lb_Repositorio:=TRUE;
       Lr_InvPreIngresoNumeroSerie :=NULL;
       BEGIN
            P_VALIDA_INGRESO_SERIE  (Lc_RegularizaSeries.SERIE,
                                     Lv_MensajeError);
                                     
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            
            IF C_CUSTODIO%ISOPEN THEN 
             CLOSE C_CUSTODIO; 
            END IF;
             --Se verifica si custodio existe y está activo 
             OPEN C_CUSTODIO (Lc_RegularizaSeries.RESPONSABLE);
			 FETCH C_CUSTODIO INTO Lc_Custodio;
               IF C_CUSTODIO%NOTFOUND THEN
                 Lv_MensajeError:='NO existe el empleado: '||Lc_RegularizaSeries.RESPONSABLE;
                 RAISE Le_Error;
               END IF;
		CLOSE C_CUSTODIO;
             
           IF C_VERIFICA_REPOSITORIO%ISOPEN THEN
              CLOSE C_VERIFICA_REPOSITORIO; 
            END IF;
 
            --Se verifica registro en repositorio
            OPEN C_VERIFICA_REPOSITORIO (Lc_RegularizaSeries.serie);
		    FETCH C_VERIFICA_REPOSITORIO INTO Lc_VerificaRepositorio;
              IF C_VERIFICA_REPOSITORIO%NOTFOUND THEN
                Lb_Repositorio :=FALSE;
              ELSE
                --Si la compañiaa regularizar es diferente a la despachada
                IF Lc_RegularizaSeries.COMPANIA!= Lc_VerificaRepositorio.ID_EMPRESA_DESPACHA THEN
                  
                  Lv_MensajeError:='Serie : '||Lc_RegularizaSeries.SERIE|| ' fue despachada a otra compania, se debe indicar con que artículo y centro se debe ingresar';
                  RAISE Le_Error;
                
                END IF;
              END IF;
		    CLOSE C_VERIFICA_REPOSITORIO;
            
            ---------
                     
            IF C_ARTICULO_INGRESO%ISOPEN THEN 
                CLOSE C_ARTICULO_INGRESO; 
            END IF;
                --Se escoge articulo usado para el ingreso
                OPEN C_ARTICULO_INGRESO(Lc_RegularizaSeries.NO_ARTICULO_N,
                                            Lc_RegularizaSeries.COMPANIA);
                FETCH C_ARTICULO_INGRESO INTO Lr_Arinml.No_Arti;
                
                IF C_ARTICULO_INGRESO%NOTFOUND OR Lr_Arinml.No_Arti IS NULL THEN
                  Lr_Arinml.No_Arti:=Lc_RegularizaSeries.NO_ARTICULO_N;
                END IF;
            
                CLOSE C_ARTICULO_INGRESO;
            
                                  
                IF C_DATOS_PERIODO%ISOPEN THEN 
                  CLOSE C_DATOS_PERIODO; 
                END IF;
                OPEN C_DATOS_PERIODO (Lc_RegularizaSeries.CENTRO,
                                      Lc_RegularizaSeries.COMPANIA);
                FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
                IF C_DATOS_PERIODO%NOTFOUND THEN
                  Lv_MensajeError := 'La definición del calendario del inventario es incorrecta.';
                  RAISE Le_Error;
                END IF;
                CLOSE C_DATOS_PERIODO;
                
                IF C_ELEMENTO%ISOPEN THEN 
                CLOSE C_ELEMENTO; 
                END IF;
            
            UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO a
            SET A.ESTADO = 'Retirado'
            WHERE A.ID_ELEMENTO = lc_Elemento.ID_ELEMENTO
            AND A.ESTADO = 'Activo';
            
            IF Lc_RegularizaSeries.MAC IS NULL THEN
              IF C_MAC%ISOPEN THEN 
                CLOSE C_MAC; 
              END IF;
              
              OPEN C_MAC(Lc_RegularizaSeries.SERIE);
              FETCH C_MAC INTO LV_Mac;
              CLOSE C_MAC;
            ELSE
            LV_Mac:=Lc_RegularizaSeries.MAC;
            END IF;
            
                                     
            IF C_TIPO_DOC%ISOPEN THEN 
              CLOSE C_TIPO_DOC; 
            END IF;
            
            OPEN C_TIPO_DOC(Lc_RegularizaSeries.COMPANIA);
            FETCH C_TIPO_DOC INTO Lv_TipoDocumento;
            CLOSE C_TIPO_DOC;
            
            --Se obtiene infirmacion para ingresar el movimiento
            Lr_Arinme.No_Cia := Lc_RegularizaSeries.COMPANIA;
            Lr_Arinme.No_Cia_Responsable := Lc_RegularizaSeries.COMPANIA;
            Lr_Arinme.Centro := Lc_RegularizaSeries.CENTRO;
            Lr_Arinme.Tipo_Doc := Lv_TipoDocumento;
            Lr_Arinme.Ruta := '0000';
            Lr_Arinme.Estado := 'P';
            Lr_Arinme.Origen := 'IN';
            Lr_Arinme.Id_Bodega := Lc_RegularizaSeries.BODEGA_ID;
            Lr_Arinme.Observ1 := 'INGRESO POR REGULARIZACION MASIVA';
    
            
            
            Lr_Arinme.TIPO_CAMBIO := NAF47_TNET.TIPO_CAMBIO(Lr_DatosPeriodo.Clase_Cambio,
                                                            Lr_DatosPeriodo.Dia_Proceso,
                                                            Ld_FechaAux,
                                                           'C');
            Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
            Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
                
            Lr_Arinme.No_Docu := Transa_Id.Inv(Lr_Arinme.No_Cia);
            Lr_Arinme.No_Fisico := NAF47_TNET.CONSECUTIVO.INV(Lr_Arinme.No_Cia, Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'NUMERO');
            Lr_Arinme.Serie_Fisico := NAF47_TNET.CONSECUTIVO.INV(Lr_Arinme.No_Cia,  Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'SERIE');
            Lr_Arinme.MONTO_DIGITADO_COMPRA:=0.01;
            NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINME(Lr_Arinme,
                                                          Lv_MensajeError); 
                
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            
            
            --Lr_Arinml.No_Arti := Lc_RegularizaSeries.NO_ARTICULO_N ;
            Lr_Arinml.No_Cia := Lc_RegularizaSeries.COMPANIA;
            Lr_Arinml.Centro := Lc_RegularizaSeries.CENTRO;
            Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
            Lr_Arinml.Periodo := Lr_Arinme.Periodo;
            Lr_Arinml.Ruta := Lr_Arinme.Ruta;
            Lr_Arinml.No_Docu := Lr_Arinme.NO_DOCU;
            Lr_Arinml.Bodega := Lr_Arinme.ID_BODEGA;
            Lr_Arinml.Unidades := 1;
            Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
            Lr_Arinml.Ind_Oferta := 'N';
            Lr_Arinml.Ind_IV := 'N';
            Lr_Arinml.Monto:=0.01;
            Lr_Arinml.Monto_Dol:=0.01;
            Lr_Arinml.Monto2:=0.01;
            Lr_Arinml.Monto2_Dol:=0.01;
            Lr_Arinml.Time_Stamp:= Sysdate;
            
            Lr_Arinml.Linea := 1;
            Lr_Arinml.Linea_Ext := 1;
            -- insertar detalle documento inventario --
            NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINML(Lr_Arinml,
                                                         Lv_MensajeError); 
                                                         
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            Lr_InvPreIngresoNumeroSerie.Compania     := Lc_RegularizaSeries.COMPANIA;
            Lr_InvPreIngresoNumeroSerie.No_Documento := Lr_Arinme.NO_DOCU; 
            Lr_InvPreIngresoNumeroSerie.No_Articulo  := Lr_Arinml.No_Arti;
            Lr_InvPreIngresoNumeroSerie.Serie        := Lc_RegularizaSeries.serie;
            Lr_InvPreIngresoNumeroSerie.Mac          := LV_Mac;
            Lr_InvPreIngresoNumeroSerie.Origen       := 'IN';
            Lr_InvPreIngresoNumeroSerie.Usuario_Crea := User;
            Lr_InvPreIngresoNumeroSerie.Fecha_Crea   := Sysdate; 
            
            Lr_InvPreIngresoNumeroSerie.Linea := nvl(Lr_InvPreIngresoNumeroSerie.Linea,0) + 1;		
             
            -- Se registra en INV_PRE_INGRESO_NUMERO_SERIE                                      
            NAF47_TNET.INKG_TRANSACCION.P_INSERTA_NUMERO_SERIE(Lr_InvPreIngresoNumeroSerie,
                                                               Lv_MensajeError); 
                
                                    
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            
            IF  Lb_Repositorio THEN
                --Se actualiza el repositorio a Retirado
                NAF47_TNET.AFK_PROCESOS.IN_P_RETIRA_INSTALACION(Lc_RegularizaSeries.COMPANIA,
                                                                Lr_Arinml.No_Arti,
                                                                'AF',
                                                                Lc_Custodio.Cedula,
                                                                Lc_RegularizaSeries.serie,
                                                                1,
                                                                'RE',
                                                                Lv_MensajeError);
                                                                
               IF Lv_MensajeError IS NOT NULL THEN
                  RAISE Le_Error;
                END IF;
            END IF;
            
            --Proceso de actualizacion de movimientos
            NAF47_TNET.INACTUALIZA(Lr_Arinme.No_Cia,
                        	   Lr_Arinme.Tipo_Doc,
                        	   Lr_Arinme.No_Docu,
                        	   Lv_MensajeError);
                        
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            
         
         -----------
         Lv_Estado:='P';
         Lv_MensajeError:=NULL;
         
         
       EXCEPTION 
       WHEN Le_Error THEN
         Lv_Estado:='E';
         
       WHEN OTHERS THEN
         Lv_Estado:='E';
         Lv_MensajeError:='Error: '||SQLERRM;
       END;
       
       UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES
         SET ESTADO=Lv_Estado,
         OBSERVACION=SUBSTR(DECODE(Lv_MensajeError,NULL,'Ingresado',Lv_MensajeError),1,2000),
         FECHA_ACTUALIZACION= SYSDATE,
         USUARIO_ACTUALIZACION= USER
       WHERE SERIE=Lc_RegularizaSeries.serie
       AND COMPANIA=Lc_RegularizaSeries.COMPANIA
       AND EVENTO='R';
       
       IF Ln_Commit >= 50 THEN
         Ln_Commit:=0;
        COMMIT;
       ELSE
         Ln_Commit:=Ln_Commit+1;
       END IF;  
    END LOOP; 
    COMMIT;
     Pv_Resultado:='OK';
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error:='Error General '|| SQLERRM;
  END P_REGULARIZA_INGRESO_EQUIPO;
  
  PROCEDURE P_VALIDA_INGRESO_SERIE  (Pv_Serie       VARCHAR2,
                                     Pv_Error       OUT VARCHAR2) AS
                                     
    CURSOR C_NUMERO_SERIE IS
    SELECT COMPANIA,
           NO_ARTICULO, 
           ID_BODEGA,
           ESTADO
      FROM NAF47_TNET.INV_NUMERO_SERIE
     WHERE SERIE  = Pv_Serie
       AND ESTADO = 'EB';
       
    CURSOR C_VERIFICA_REPOSITORIO IS
    SELECT A.ESTADO,
           DECODE(A.ESTADO, 'RE','RETIRADO','PI','PENDIENTE INSTALAR','IN','INSTALADO') DESC_ESTADO,
           A.FE_CREACION, 
           A.FE_ULT_MOD,
           A.ID_INSTALACION
      FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
     WHERE A.ID_INSTALACION = ( SELECT MAX(ID_INSTALACION)
                                  FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
                                WHERE A.NUMERO_SERIE = Pv_Serie)
     AND A.NUMERO_SERIE = Pv_Serie;   
    
    Lr_NumeroSerie    C_NUMERO_SERIE%ROWTYPE := null; 
    Lr_Instalacion    C_VERIFICA_REPOSITORIO%ROWTYPE:= NULL;
    Lb_Serie          BOOLEAN;
    Le_Error          EXCEPTION;
    BEGIN
      
       --Si existe se valida que este fuera de bodega para reingresarse.
      IF C_NUMERO_SERIE%ISOPEN THEN CLOSE C_NUMERO_SERIE; END IF;
      OPEN C_NUMERO_SERIE;
      FETCH C_NUMERO_SERIE INTO Lr_NumeroSerie;
      IF C_NUMERO_SERIE%FOUND THEN
  	    Pv_Error:= 'Numero serie se encuentra en bodega '||Lr_NumeroSerie.id_bodega||
              ' asociado a producto '||Lr_NumeroSerie.no_articulo||
              ' de la Empresa '||Lr_NumeroSerie.compania;
        Lb_Serie:= FALSE;
        
      ELSE
         Lb_Serie:= TRUE;
      END IF;
  CLOSE C_NUMERO_SERIE;
  
   -- Se verifica si numero de serie existe en el repositorio --
    
  IF C_VERIFICA_REPOSITORIO%ISOPEN THEN CLOSE C_VERIFICA_REPOSITORIO; END IF;
  OPEN C_VERIFICA_REPOSITORIO;
  FETCH C_VERIFICA_REPOSITORIO INTO Lr_Instalacion;
  CLOSE C_VERIFICA_REPOSITORIO;
  
  IF Lr_Instalacion.ESTADO <>'IN' AND Lb_Serie = TRUE THEN
       UPDATE  NAF47_TNET.IN_ARTICULOS_INSTALACION
       SET ESTADO='IN',
       SALDO=0
       WHERE NUMERO_SERIE = Pv_Serie
       AND ID_INSTALACION=Lr_Instalacion.ID_INSTALACION;
       
  ELSIF Lb_Serie = FALSE THEN
       
       --Si está en bodega y en repositorio se notifica
       Pv_Error:=Pv_Error|| ' -  No. Serie '||Pv_Serie||' se encuentra en Repositorio en estado '|| Lr_Instalacion.DESC_ESTADO;
       RAISE Le_Error;
  END IF;
  
  --Si solo la serie se encuentra en bodega
  IF Pv_Error IS NOT NULL THEN
    UPDATE NAF47_TNET.INV_NUMERO_SERIE
      SET ESTADO='FB',
      ID_BODEGA=NULL
    WHERE SERIE = Pv_Serie
    AND ESTADO='EB';
    
  END IF;
  
  EXCEPTION
  
  WHEN Le_Error THEN
  
    NULL;
  
  WHEN OTHERS THEN
    Pv_Error:='Error en P_VALIDA_INGRESO_SERIE: '|| SQLERRM;
  END P_VALIDA_INGRESO_SERIE;


END INKG_REGULARIZA_SERIES;
/
