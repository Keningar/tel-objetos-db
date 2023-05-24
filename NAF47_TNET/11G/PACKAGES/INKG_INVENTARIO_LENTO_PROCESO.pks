CREATE OR REPLACE package NAF47_TNET.INKG_INVENTARIO_LENTO_PROCESO is
  --
  TYPE TypeDatosArticulo IS RECORD (
    NO_CIA            NAF47_TNET.ARINDA.NO_CIA%TYPE,
    NO_ARTI           NAF47_TNET.ARINDA.NO_ARTI%TYPE,
    TIPO_ARTICULO     NAF47_TNET.ARINDA.TIPO_ARTICULO%TYPE,
    MANEJA_SERIE      NAF47_TNET.ARINDA.IND_REQUIERE_SERIE%TYPE,
    STOCK             NUMBER(12),
    CANTIDAD_SERIE    NUMBER(12),
    UNIDADES_SERIE    NUMBER(12)
  );
  --
  /**
  * Documentacion para P_PROCESAR 
  * Procedure que procesa inventario de lento movimiento y ser� ejecutado desde JOB
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 18/11/2018
  *
  * @param Pv_NoCia IN VARCHAR2 Recibe cdigo de empresa
  */
  PROCEDURE P_PROCESAR ( Pv_NoCia IN OUT VARCHAR2);
  --
end INKG_INVENTARIO_LENTO_PROCESO;
/
CREATE OR REPLACE package body NAF47_TNET.INKG_INVENTARIO_LENTO_PROCESO is
  --
  TIPO_EVENTO     CONSTANT VARCHAR2(30) := 'DespachoAutomatico';
  CD_FECHA_FINAL  CONSTANT DATE := TO_DATE('31/12/2020','DD/MM/YYYY');
  TOTAL_MINUTOS   CONSTANT NUMBER(3) := 480;
  HORA_INICIO     CONSTANT VARCHAR2(8) := '09:00:00';
  HORA_FIN        CONSTANT VARCHAR2(8) := '17:59:29';
  TIPO_DOCUMENTO  CONSTANT VARCHAR2(2) := 'EM';
  ESTADO_PROCESO  CONSTANT VARCHAR2(1) := 'I';
  JEFE_BODEGA_R2  CONSTANT VARCHAR2(6) := '1946';
  JEFE_BODEGA_R1  CONSTANT VARCHAR2(6) := '1962';
  PROCESO         CONSTANT VARCHAR2(10):= 'InvLento';
  ORIGEN          CONSTANT VARCHAR2(2) := 'IN';

  --
 /*
  * Documentacion para F_VERIFICA_NUMEROS_SERIE 
  * Function valida los numeros de series a usar para proceso automatico inventario lento movimiento
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 18/11/202020
  *
  * @param Pr_NumeroSerie   IN OUT VARCHAR2 Recibe nmero de contratista en NAF
  * @param Pr_DatosArticulo IN     VARCHAR2 Recibe cdigo de empresa
  * @return                        BOOLEAN retorna si proceso fue sastisfactorio o No
  */
  FUNCTION F_VERIFICA_NUMEROS_SERIE (Pr_NumeroSerie   IN OUT NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE,
                                     Pr_DatosArticulo IN TypeDatosArticulo) RETURN BOOLEAN IS
    --
    CURSOR C_SERIE_GENERADA (Cv_Formato VARCHAR2) IS
      SELECT TO_NUMBER(NVL(MAX(SUBSTR(INS.SERIE, 14, 4)),'0')) CANTIDAD
      FROM INV_NUMERO_SERIE INS
      WHERE INS.FECHA_CREA >= TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 00:00:00','DD/MM/YYYY HH24:MI:SS')
      AND INS.FECHA_CREA <= TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY HH24:MI:SS')
      AND INS.SERIE LIKE Cv_Formato;
    --
    Ln_UnidadPendiente NUMBER(9) := 0;
    Ln_Secuencia       NUMBER(4) := 0;
    Lv_MensajeError    VARCHAR2(3000);
    --
  BEGIN
    --
    IF Pr_DatosArticulo.MANEJA_SERIE = 'N' OR -- Si no maneja serie no se verifica nada
      Pr_DatosArticulo.STOCK = Pr_DatosArticulo.UNIDADES_SERIE THEN -- si no hay inconsistencia termina verificacion
      RETURN TRUE;
    END IF;
    --
    --
    IF Pr_DatosArticulo.Stock < Pr_DatosArticulo.UNIDADES_SERIE THEN
       --
       RETURN (Pr_DatosArticulo.Stock < Pr_DatosArticulo.UNIDADES_SERIE);
       --
    END IF;
    --
    --se debe generar numero serie
    IF Pr_DatosArticulo.TIPO_ARTICULO = 'Fibra' THEN
      Pr_NumeroSerie.Unidades := 2000;  
    ELSE
      Pr_NumeroSerie.Unidades := 1;
    END IF;
    --
    Ln_UnidadPendiente := Pr_DatosArticulo.Stock - Pr_DatosArticulo.UNIDADES_SERIE;
    --
    LOOP
      --
      IF Ln_UnidadPendiente < Pr_NumeroSerie.Unidades THEN
        Pr_NumeroSerie.Unidades := Ln_UnidadPendiente;
      END IF;
      --
      IF C_SERIE_GENERADA%ISOPEN THEN
        CLOSE C_SERIE_GENERADA;
      END IF;
      OPEN C_SERIE_GENERADA('SEG-'||TO_CHAR(TRUNC(SYSDATE),'DDMMYYYY')||'%');
      FETCH C_SERIE_GENERADA INTO Ln_Secuencia;
      IF C_SERIE_GENERADA%NOTFOUND THEN
        Ln_Secuencia := 0;
      END IF;
      CLOSE C_SERIE_GENERADA;
      --
      Ln_Secuencia := nvl(Ln_Secuencia,0) + 1;
      --
      Pr_NumeroSerie.Serie := 'SEG-'||TO_CHAR(TRUNC(SYSDATE),'DDMMYYYY')||'-'||LPAD(Ln_Secuencia,4,'0');
      --
      NAF47_TNET.INKG_TRANSACCION.P_INSERTA_MAESTRO_SERIE (Pr_NumeroSerie, Lv_MensajeError);
      --
      IF Lv_MensajeError IS NOT NULL THEN
       DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                            'INKG_INVENTARIO_LENTO_PROCESO.P_PROCESAR',
                                            'INKG_INVENTARIO_LENTO_PROCESO.F_VERIFICA_NUMEROS_SERIE. '||Lv_MensajeError,
                                            NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                            SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));  
        --        
        RETURN FALSE;
      END IF;

      Ln_UnidadPendiente := Ln_UnidadPendiente - Pr_NumeroSerie.Unidades;
      --
      EXIT WHEN Ln_UnidadPendiente = 0;
    END LOOP;
    --
    RETURN TRUE;
    --
  END F_VERIFICA_NUMEROS_SERIE;
  --
 /*
  * Documentacion para P_ASIGNA_DATOS_PROCESO
  * Procedure que define por articulo las cantidades y en cuantos dias realizar los despachos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 18/11/2020
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe c�digo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_ASIGNA_DATOS_PROCESO ( Pv_NoCia        IN VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_DATOS_PROCESAR IS
      SELECT COMPANIA,
             SERIE AS SECUENCIA,
             NO_ARTICULO_N,
             CANTIDAD_PROCESAR,
             SALDO,
             OBSERVACION
      FROM NAF47_TNET.INV_REGULARIZACION_SERIES
      WHERE EVENTO = TIPO_EVENTO
      AND TOTAL_DIAS IS NULL
      AND COMPANIA = Pv_NoCia;
    --
    CURSOR C_DATOS_ARTICULO (Cv_NoCia  VARCHAR2,
                             Cv_NoArti VARCHAR2) IS
      SELECT DA.IND_REQUIERE_SERIE,
             DA.TIPO_ARTICULO,
             VAS.BODEGA,
             VAS.STOCK,
             (SELECT COUNT(INS.UNIDADES) 
              FROM INV_NUMERO_SERIE INS
              WHERE INS.NO_ARTICULO = VAS.NO_ARTI
              AND INS.ID_BODEGA = VAS.BODEGA
              AND INS.COMPANIA = VAS.NO_CIA ) AS CANTIDAD_SERIE,
             (SELECT SUM(INS.UNIDADES) 
              FROM INV_NUMERO_SERIE INS
              WHERE INS.NO_ARTICULO = VAS.NO_ARTI
              AND INS.ID_BODEGA = VAS.BODEGA
              AND INS.COMPANIA = VAS.NO_CIA ) AS TOTAL_SERIE
      FROM NAF47_TNET.ARINBO BO,
           NAF47_TNET.ARINDA DA,
           NAF47_TNET.V_ARTICULO_STOCK VAS
      WHERE VAS.NO_CIA = Cv_NoCia
      AND VAS.NO_ARTI = Cv_NoArti
      AND VAS.STOCK > 0
      AND BO.TRANSITO = 'N'
      AND BO.MAL_ESTADO = 'N'
      AND VAS.BODEGA = BO.CODIGO
      AND VAS.NO_CIA = BO.NO_CIA
      AND VAS.NO_ARTI = DA.NO_ARTI
      AND VAS.NO_CIA = DA.NO_CIA;
    --
    --
    Lr_Articulo      C_DATOS_ARTICULO%ROWTYPE;
    Lr_NumeroSerie   NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE;
    Lr_DatosArticulo NAF47_TNET.INKG_INVENTARIO_LENTO_PROCESO.TypeDatosArticulo;
    --
    Ln_CantidadDias     NUMBER(6) := 0;
    Ln_DiasIntervalo    NUMBER(6) := 0;
    Ln_CantidadDespacho NUMBER(6) := 0;
    Ln_CantidadSeries   NUMBER(6) := 0;
    Lb_Calcular         BOOLEAN;

    --
    Ln_Stock            NUMBER(9) := 0;
    --
  BEGIN
    --
    Ln_CantidadDias := CD_FECHA_FINAL - TRUNC(SYSDATE);
    --
    FOR Lr_Datos IN C_DATOS_PROCESAR LOOP
      --
      Ln_Stock := 0;
      Ln_CantidadSeries := 0;
      Lb_Calcular := TRUE;
      --
      FOR Lr_Articulo IN C_DATOS_ARTICULO (Lr_Datos.Compania, Lr_datos.No_Articulo_n) LOOP
        --
        Lr_DatosArticulo.NO_CIA := Lr_Datos.Compania;
        Lr_DatosArticulo.NO_ARTI := Lr_Datos.No_Articulo_n;
        Lr_DatosArticulo.TIPO_ARTICULO := Lr_Articulo.Tipo_Articulo;
        Lr_DatosArticulo.MANEJA_SERIE := NVL(Lr_Articulo.Ind_Requiere_Serie,'N');
        Lr_DatosArticulo.STOCK := Lr_Articulo.Stock;
        Lr_DatosArticulo.CANTIDAD_SERIE := Lr_Articulo.Cantidad_Serie;
        Lr_DatosArticulo.UNIDADES_SERIE := NVL(Lr_Articulo.Total_Serie,0);
        --
        --
        Lr_NumeroSerie.Compania := Lr_Datos.Compania;
        Lr_NumeroSerie.No_Articulo := Lr_Datos.No_Articulo_n;
        Lr_NumeroSerie.Id_Bodega := Lr_Articulo.Bodega;
        Lr_NumeroSerie.Estado := 'EB';
        Lr_NumeroSerie.Usuario_Crea := USER;
        Lr_NumeroSerie.Fecha_Crea := SYSDATE;
        --
        --
        Lb_Calcular := F_VERIFICA_NUMEROS_SERIE (Lr_NumeroSerie, Lr_DatosArticulo);
        --
        Ln_CantidadSeries := Lr_Articulo.Cantidad_Serie;
        Ln_Stock := Lr_Articulo.Stock;
        --
      END LOOP;
      --
      -- se corrige el stock a procesar en base al stock en bodegas si no existe inconsistencias de numeros de series
      IF (Ln_Stock != Lr_Datos.Cantidad_Procesar OR Ln_CantidadSeries != 0)  AND Lb_Calcular THEN
        --el calculo debe realziarse por cantidad de series  (Fibra)
        IF Ln_CantidadSeries != 0 THEN
          Lr_Datos.Cantidad_Procesar := Ln_CantidadSeries;
          Lr_Datos.Saldo := Ln_CantidadSeries;
        ELSE
          Lr_Datos.Cantidad_Procesar := Ln_Stock;
          Lr_Datos.Saldo := Ln_Stock;
        END IF;
        --
        UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES A
        SET CANTIDAD_PROCESAR = Lr_Datos.Cantidad_Procesar,
            SALDO = Lr_Datos.Saldo
        WHERE COMPANIA = Lr_Datos.Compania
        AND SERIE = Lr_Datos.Secuencia
        AND NO_ARTICULO_N = Lr_Datos.No_Articulo_n
        AND EVENTO = TIPO_EVENTO
        AND TOTAL_DIAS IS NULL;
        --
      END IF;
      --
      --
      IF Lb_Calcular AND Lr_Datos.Cantidad_Procesar != 0 THEN
        --
        IF TRUNC(Ln_CantidadDias/Lr_Datos.Cantidad_Procesar) = 0 THEN
          Ln_DiasIntervalo := CEIL(Ln_CantidadDias/Lr_Datos.Cantidad_Procesar);
        ELSE
          Ln_DiasIntervalo := TRUNC(Ln_CantidadDias/Lr_Datos.Cantidad_Procesar);
        END IF;
        --
        Ln_CantidadDespacho := ROUND(Lr_Datos.Cantidad_Procesar/(TRUNC(Ln_CantidadDias/Ln_DiasIntervalo)));
        --
        UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES A
        SET TOTAL_DIAS = Ln_CantidadDias,
            DIAS_INTERVALO = Ln_DiasIntervalo,
            CANTIDAD_X_DESPACHO = Ln_CantidadDespacho,
            FECHA_ACTUALIZACION = TRUNC(SYSDATE)
        WHERE COMPANIA = Lr_Datos.Compania
        AND SERIE = Lr_Datos.Secuencia
        AND NO_ARTICULO_N = Lr_Datos.No_Articulo_n
        AND EVENTO = TIPO_EVENTO
        AND TOTAL_DIAS IS NULL;
        --
      ELSIF (NVL(Ln_Stock,0) - nvl(Lr_Datos.Cantidad_Procesar,0)) != 0 THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                               'INKG_INVENTARIO_LENTO_PROCESO.P_ASIGNA_DATOS_PROCESO',
                                                'Error stock VS total Series '||
                                                ' Articulo: '||Lr_datos.No_Articulo_n||
                                                ', Stock: '||NVL(Ln_Stock,0)||
                                                ', Stock Archivo: '||nvl(Lr_Datos.Cantidad_Procesar,0),
                                                NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                                SYSDATE,
                                                NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));  
      END IF;
      --
      --
    END LOOP;
    --
    COMMIT;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'INKG_INVENTARIO_LENTO_PROCESO.P_ASIGNA_DATOS_PROCESO. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
  END P_ASIGNA_DATOS_PROCESO;
  --
  --
 /*
  * Documentacion para P_GENERA_INGRESOS_BODEGA
  * Procedure que genera ingresos a bodegas en base a los parametros definidos en proceso asigna datos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 18/11/2020
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe c�digo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_GENERA_INGRESOS_BODEGA (Pv_NoCia        IN VARCHAR2,
                                      Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_TOTAL_REGISTROS IS
      SELECT COUNT(SERIE) CANTIDAD_PROCESAR
      FROM NAF47_TNET.INV_REGULARIZACION_SERIES
      WHERE EVENTO = TIPO_EVENTO
      AND COMPANIA = Pv_NoCia
      AND TOTAL_DIAS IS NOT NULL
      AND SALDO > 0;
    --
    CURSOR C_DATOS_PROCESAR (Cn_RegistroProcesar NUMBER) IS
      SELECT COMPANIA,
             SERIE AS SECUENCIA,
             NO_ARTICULO_N,
             CANTIDAD_PROCESAR,
             SALDO,
             OBSERVACION,
             DIAS_INTERVALO,
             CANTIDAD_X_DESPACHO,
             FECHA_ACTUALIZACION AS FECHA_ULTIMO_PROCESO
      FROM NAF47_TNET.INV_REGULARIZACION_SERIES
      WHERE EVENTO = TIPO_EVENTO
      AND COMPANIA = Pv_NoCia
      AND TOTAL_DIAS IS NOT NULL
      AND SALDO > 0
      AND (FECHA_ACTUALIZACION + DIAS_INTERVALO) = TRUNC(SYSDATE)
      AND ROWNUM <= Cn_RegistroProcesar;
    --
    CURSOR C_STOCK_ARTICULO (Cv_NoArti VARCHAR2,
                             Cv_NoCia  VARCHAR2) IS
      SELECT M.NO_CIA,
             B.CENTRO,
             M.NO_ARTI,  
             M.BODEGA,
             D.IND_REQUIERE_SERIE AS MANEJA_SERIE,
             NVL(M.SAL_ANT_UN,0) + NVL(M.COMP_UN,0) + NVL(M.OTRS_UN,0) - NVL(M.VENT_UN,0) - NVL(M.CONS_UN,0) CANTIDAD
       FROM NAF47_TNET.ARINBO B,
            NAF47_TNET.ARINDA D, 
            NAF47_TNET.ARINMA M
       WHERE M.NO_ARTI = Cv_NoArti
       AND M.NO_CIA = Cv_NoCia
       AND NVL(M.SAL_ANT_UN,0) + NVL(M.COMP_UN,0) + NVL(M.OTRS_UN,0) - NVL(M.VENT_UN,0) - NVL(M.CONS_UN,0) > 0
       AND M.BODEGA = B.CODIGO
       AND M.NO_CIA = B.NO_CIA
       AND M.NO_CIA = D.NO_CIA
       AND M.NO_ARTI = D.NO_ARTI;
    --
    CURSOR C_VERIFICA_DOCUMENTO (Cv_Bodega VARCHAR2,
                                 Cv_Centro VARCHAR2,
                                 Cv_NoCia  VARCHAR2) IS
      SELECT *
      FROM NAF47_TNET.ARINME A
      WHERE NO_CIA = Cv_NoCia
      AND CENTRO = Cv_Centro
      AND ID_BODEGA = Cv_Bodega
      AND ESTADO = ESTADO_PROCESO;
    --
    -- Se recupera los datos del perioso para asignar al despacho --
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
    --
    -- se recupera centro de costo de responsable
    CURSOR C_CCOSTO_RESP ( Cv_IdResponsable VARCHAR2,
                           Cv_NoCia         VARCHAR2) IS
      SELECT A.CENTRO_COSTO
      FROM NAF47_TNET.ARPLME A
      WHERE A.NO_EMPLE = Cv_IdResponsable
      AND A.NO_CIA = Cv_NoCia;
    --
    -- cursor que recupera secuencia de arinml --
    CURSOR C_SEC_ARINML (Cv_NoDocumento VARCHAR2,
                         Cv_NoCia       VARCHAR2) IS
      SELECT MAX(A.LINEA)
      FROM NAF47_TNET.ARINML A
      WHERE A.NO_DOCU = Cv_NoDocumento
      AND A.NO_CIA = Cv_NoCia;
    --
    CURSOR C_NUMERO_SERIE ( Cv_Noarti VARCHAR2,
                            Cv_Bodega VARCHAR2,
                            Cv_NoCia  VARCHAR2 ) IS
      SELECT INS.SERIE,
             INS.MAC,
             INS.UNIDADES
      FROM NAF47_TNET.INV_NUMERO_SERIE INS
      WHERE INS.COMPANIA = Cv_NoCia
      AND INS.NO_ARTICULO = Cv_Noarti
      AND INS.ID_BODEGA = Cv_Bodega
      AND INS.ESTADO = 'EB';
    --
    CURSOR C_TIPO_CONSUMO (Cv_Centro VARCHAR2,
                           Cv_NoCia  VARCHAR2) IS
      SELECT A.CODIGO
      FROM ARINTIPOCONSUMOINTER A
      WHERE A.NO_CIA = Cv_NoCia
      AND A.CENTRO = Cv_Centro
      AND UPPER(DESCRIPCION) LIKE '%HERRAMIENTA%';
    --
    Lr_Arinme   NAF47_TNET.ARINME%ROWTYPE;
    Lr_Arinml   NAF47_TNET.ARINML%ROWTYPE;
    Lr_DocSerie NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE;
    Lr_DatosPeriodo  C_DATOS_PERIODO%ROWTYPE := NULL;
    Lr_NumeroSerie   C_NUMERO_SERIE%ROWTYPE := NULL;
    --
    Ln_TotalRegistros NUMBER(6) := 0;
    Ln_CantidadSerie  NUMBER(6) := 0;
    --
    Ld_FechaAux       DATE := NULL;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    -- no esta dentro de horario no se ejecuta nada
    IF TRIM(TO_CHAR(SYSDATE,'HH24:MI:SS')) < HORA_INICIO OR TRIM(TO_CHAR(SYSDATE,'HH24:MI:SS')) > HORA_FIN THEN
      RETURN;
    END IF;
    --
    -- Se deteremina el total de registros a procesar para determinar cantidad a despachar por minuto.
    IF C_TOTAL_REGISTROS%ISOPEN THEN
      CLOSE C_TOTAL_REGISTROS;
    END IF;
    OPEN C_TOTAL_REGISTROS;
    FETCH C_TOTAL_REGISTROS INTO Ln_TotalRegistros;
    IF C_TOTAL_REGISTROS%NOTFOUND THEN
      Ln_TotalRegistros := 0;
    END IF;
    CLOSE C_TOTAL_REGISTROS;
    --
    -- no hay datos a procesar
    IF NVL(Ln_TotalRegistros,0) = 0 THEN
      RETURN;
    END IF;
    --
    --
    FOR Lr_Datos IN C_DATOS_PROCESAR (CEIL(Ln_TotalRegistros/TOTAL_MINUTOS)) LOOP
      --
      --
      Ln_CantidadSerie := 0;
      --
      FOR Lr_Stock IN C_STOCK_ARTICULO (Lr_Datos.No_Articulo_n, Lr_Datos.Compania) LOOP
        --
        -- Se recupera documento genrado por bodega
        IF C_VERIFICA_DOCUMENTO%ISOPEN THEN
          CLOSE C_VERIFICA_DOCUMENTO;
        END IF;
        OPEN C_VERIFICA_DOCUMENTO(Lr_Stock.Bodega,
                                  Lr_Stock.Centro,
                                  Lr_Stock.No_Cia);
        FETCH C_VERIFICA_DOCUMENTO INTO Lr_Arinme;
        IF C_VERIFICA_DOCUMENTO%NOTFOUND THEN
          Lr_Arinme := NULL;
        END IF;
        CLOSE C_VERIFICA_DOCUMENTO;
        --
        -- si no existe se genera nuevo documento
        IF Lr_Arinme.No_Docu IS NULL THEN
          --
          Lr_Arinme.No_Cia := Lr_Stock.No_Cia;
          Lr_Arinme.Centro := Lr_Stock.Centro;
          Lr_Arinme.Tipo_Doc := TIPO_DOCUMENTO;
          Lr_Arinme.Ruta := '0000';
          Lr_Arinme.Estado := ESTADO_PROCESO;
          Lr_Arinme.Id_Bodega := Lr_Stock.Bodega;
          Lr_Arinme.Observ1 := 'DESPACHO DE MATERIALES Y EQUIPOS PARA REALIZAR SOPORTES '||UPPER(Lr_Datos.Observacion);
          --
          IF C_TIPO_CONSUMO%ISOPEN THEN
            CLOSE C_TIPO_CONSUMO;
          END IF;
          OPEN C_TIPO_CONSUMO(Lr_Arinme.Centro,
                              Lr_Arinme.No_Cia);
          FETCH C_TIPO_CONSUMO INTO Lr_Arinme.Tipo_Consumo_Interno;
          IF C_TIPO_CONSUMO%NOTFOUND THEN
            Lr_Arinme.Tipo_Consumo_Interno := NULL;
          END IF;
          CLOSE C_TIPO_CONSUMO;
          --
          IF Lr_Arinme.Tipo_Consumo_Interno IS NULL THEN
            --
            Pv_MensajeError := 'Centro distribuci�n '||Lr_Arinme.Centro||' no tiene asignado tipo consumo para herramientas';
            RAISE Le_Error;
            --
          END IF;
          --
          Lr_Arinme.Conduce := PROCESO;
          --
          IF Lr_Arinme.Centro IN ('02','11','12','13','14','15','16','17') THEN
            Lr_Arinme.Emple_Solic := JEFE_BODEGA_R2;
          ELSE
            Lr_Arinme.Emple_Solic := JEFE_BODEGA_R1;
          END IF;
          -- se recuperan parametros para asignar a documentos inventarios.
          IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
          OPEN C_DATOS_PERIODO (Lr_Arinme.Centro,
                                Lr_Arinme.No_Cia);
          FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
          IF C_DATOS_PERIODO%NOTFOUND THEN
            Pv_MensajeError := 'La definici�n del calendario del inventario es incorrecta.';
            RAISE Le_Error;
          END IF;
          CLOSE C_DATOS_PERIODO;
          --
          -- se busca centro de costo de empleado responsable
          IF C_CCOSTO_RESP%ISOPEN THEN CLOSE C_CCOSTO_RESP; END IF;
          OPEN C_CCOSTO_RESP (Lr_Arinme.Emple_Solic,
                              Lr_Arinme.No_Cia);
          FETCH C_CCOSTO_RESP INTO Lr_Arinme.c_Costo_Emplesol;
          IF C_CCOSTO_RESP%NOTFOUND THEN
            Pv_MensajeError := 'Empleado solicitante no tiene asignado centro de costo, favor verifique con RRHH';
            RAISE Le_Error;
          END IF;
          CLOSE C_CCOSTO_RESP;
          --
          --
          Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lr_DatosPeriodo.Clase_Cambio,
                                               Lr_DatosPeriodo.Dia_Proceso,
                                               Ld_FechaAux,
                                               'C');
          --
          Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
          Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
          Lr_Arinme.No_Cia_Responsable := Lr_Arinme.No_Cia;
          Lr_Arinme.Empleado_Solicitante := Lr_Arinme.Emple_Solic;
          Lr_Arinme.No_Cia_Solicitante := Lr_Arinme.No_Cia;
          Lr_Arinme.Origen := ORIGEN;
          Lr_Arinme.No_Docu := naf47_tnet.Transa_Id.Inv(Lr_Arinme.No_Cia);
          Lr_Arinme.No_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia, Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'NUMERO');
          Lr_Arinme.Serie_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia,  Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'SERIE');

          -- Se inserta registro en cabecera de documentos de inventarios
          BEGIN
            INSERT INTO NAF47_TNET.ARINME
                 ( NO_CIA,             CENTRO,               TIPO_DOC,
                   TIPO_CAMBIO,        PERIODO,              RUTA,
                   NO_DOCU,            ESTADO,               FECHA,
                   NO_FISICO,          SERIE_FISICO,         ORIGEN,
                   USUARIO,            FECHA_APLICACION,     EMPLE_SOLIC,
                   NO_CIA_RESPONSABLE, C_COSTO_EMPLESOL,     OBSERV1,
                   ID_BODEGA,          EMPLEADO_SOLICITANTE, NO_CIA_SOLICITANTE,
                   CONDUCE,            TIPO_CONSUMO_INTERNO, NO_DEVOLUCIONES)
            VALUES
                 ( Lr_Arinme.No_Cia,             Lr_Arinme.Centro,               Lr_Arinme.Tipo_Doc,
                   Lr_Arinme.Tipo_Cambio,        Lr_Arinme.Periodo,              Lr_Arinme.Ruta,
                   Lr_Arinme.No_Docu,            Lr_Arinme.Estado,               Lr_Arinme.Fecha,
                   Lr_Arinme.No_Fisico,          Lr_Arinme.Serie_Fisico,         Lr_Arinme.Origen,
                   USER,                         SYSDATE,                        Lr_Arinme.Emple_Solic,
                   Lr_Arinme.No_Cia_Responsable, Lr_Arinme.c_Costo_Emplesol,     Lr_Arinme.Observ1,
                   Lr_Arinme.Id_Bodega,          Lr_Arinme.Empleado_Solicitante, Lr_Arinme.No_Cia_Solicitante,
                   Lr_Arinme.Conduce,            Lr_Arinme.Tipo_Consumo_Interno, Lr_Arinme.No_Devoluciones);

          EXCEPTION
            WHEN OTHERS THEN
              Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_INSERTA_ARINME: '||SQLERRM;
              RAISE Le_Error;
          END P_INSERTA_ARINME;
          --
          COMMIT;
          --
        END IF;
        --
        -- se procede a ingresar detalle de inventario
        Lr_Arinml.No_Cia := Lr_Arinme.No_Cia;
        Lr_Arinml.Centro := Lr_Arinme.Centro;
        Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
        Lr_Arinml.Periodo := Lr_Arinme.Periodo;
        Lr_Arinml.Ruta := Lr_Arinme.Ruta;
        Lr_Arinml.No_Docu := Lr_Arinme.No_Docu;
        Lr_Arinml.Bodega := Lr_Arinme.Id_Bodega;
        Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
        Lr_Arinml.Ind_Oferta := 'N';
        Lr_Arinml.Centro_Costo := Lr_Arinme.c_Costo_Emplesol;
        Lr_Arinml.No_Arti := Lr_Datos.No_Articulo_n;
        -------------------------------------------------      
        -- se recupera la secuencia correspondiente
        IF C_SEC_ARINML%ISOPEN THEN CLOSE C_SEC_ARINML; END IF;
        OPEN C_SEC_ARINML( Lr_Arinml.No_Docu,
                           Lr_Arinml.No_Cia);
        FETCH C_SEC_ARINML INTO Lr_Arinml.Linea;
        CLOSE C_SEC_ARINML;
        --
        Lr_Arinml.Linea := nvl(Lr_Arinml.Linea,0) + 1;
        Lr_Arinml.Linea_Ext := Lr_Arinml.Linea;
        Lr_Arinml.Unidades := 0;
        -- insertar detalle documento inventario --
        NAF47_TNET.INK_PROCESA_PEDIDOS.P_INSERTA_ARINML( Lr_Arinml,
                                                         Pv_MensajeError);

        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        -------------------------------------------------
        --
        IF Lr_Stock.Maneja_Serie = 'S' THEN
          --
          Lr_DocSerie.Compania := Lr_Arinml.No_Cia;
          Lr_DocSerie.No_Documento := Lr_Arinml.No_Docu;
          Lr_DocSerie.No_Articulo := Lr_Arinml.No_Arti;
          Lr_DocSerie.Linea := Lr_Arinml.Linea;
          Lr_DocSerie.Origen := ORIGEN;
          Lr_DocSerie.Usuario_Crea := USER;
          Lr_DocSerie.Fecha_Crea := SYSDATE;
          --
          IF C_NUMERO_SERIE%ISOPEN THEN
            CLOSE C_NUMERO_SERIE;
          END IF;
          OPEN C_NUMERO_SERIE (Lr_Stock.No_Arti,
                               Lr_Stock.Bodega,
                               Lr_Stock.No_Cia);
          FETCH C_NUMERO_SERIE INTO Lr_NumeroSerie;
          --
          LOOP
            --
            Ln_CantidadSerie := Ln_CantidadSerie + 1;
            Lr_Arinml.Unidades := NVL(Lr_Arinml.Unidades,0) + Lr_NumeroSerie.Unidades;
            --
            Lr_DocSerie.Serie := Lr_NumeroSerie.Serie;
            Lr_DocSerie.Mac := Lr_NumeroSerie.Mac;
            Lr_DocSerie.Unidades := Lr_NumeroSerie.Unidades;     
            --
            NAF47_TNET.INKG_TRANSACCION.P_INSERTA_NUMERO_SERIE(Lr_DocSerie,
                                                               Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --            
            EXIT WHEN C_NUMERO_SERIE%FOUND AND Ln_CantidadSerie >= Lr_Datos.Cantidad_x_Despacho;
          END LOOP;
          --
          --
        ELSIF Lr_Datos.Cantidad_x_Despacho >= Lr_Stock.Cantidad THEN
          Ln_CantidadSerie := Lr_Stock.Cantidad;
          Lr_Arinml.Unidades := Lr_Stock.Cantidad;
        ELSIF Lr_Datos.Cantidad_x_Despacho < Lr_Stock.Cantidad THEN
          Ln_CantidadSerie := Lr_Datos.Cantidad_x_Despacho;
          Lr_Arinml.Unidades := Lr_Datos.Cantidad_x_Despacho;
        END IF;
        --
        UPDATE NAF47_TNET.ARINML
        SET UNIDADES = Lr_Arinml.Unidades
        WHERE LINEA = Lr_Arinml.Linea
        AND NO_ARTI = Lr_Arinml.No_Arti
        AND NO_DOCU = Lr_Arinml.No_Docu
        AND NO_CIA = Lr_Arinml.No_Cia;
        --
      END LOOP;
      --
      UPDATE NAF47_TNET.INV_REGULARIZACION_SERIES A
      SET A.ESTADO = (CASE 
                        WHEN (A.SALDO - Ln_CantidadSerie) = 0 THEN
                          'P'
                        ELSE
                          'I'
                        END
                     ),
          A.SALDO = A.SALDO - Ln_CantidadSerie,
          A.FECHA_ACTUALIZACION = TRUNC(SYSDATE)
      WHERE EVENTO = TIPO_EVENTO
      AND COMPANIA = Lr_Datos.Compania
      AND NO_ARTICULO_N = Lr_Datos.No_Articulo_n
      AND TOTAL_DIAS IS NOT NULL
      AND SALDO > 0
      AND (FECHA_ACTUALIZACION + DIAS_INTERVALO) = TRUNC(SYSDATE);

      --
      COMMIT;
      --
    END LOOP;

  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'INKG_INVENTARIO_LENTO_PROCESO.P_GENERA_INGRESOS_BODEGA. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'INKG_INVENTARIO_LENTO_PROCESO.P_GENERA_INGRESOS_BODEGA. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
  END P_GENERA_INGRESOS_BODEGA;
  --
  --
 /*
  * Documentacion para P_ACTUALIZA_DOCUMENTOS
  * Procedure que actualiza los documentos generados por inventario lento movimiento.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 18/11/2020
  *
  * @param Pv_NoCia        IN VARCHAR2 Recibe c�digo de empresa
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_ACTUALIZA_DOCUMENTOS ( Pv_NoCia        IN     VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2) IS

    -- cursor que recupera los despachos por pedidos a actualziar.
    CURSOR C_DOCUMENTOS_ACTUALIZAR IS
      SELECT A.NO_CIA, 
             A.CENTRO, 
             A.TIPO_DOC, 
             A.NO_DOCU, 
             A.FECHA
      FROM NAF47_TNET.ARINME A
      WHERE A.NO_CIA = Pv_NoCia
      AND A.ESTADO = ESTADO_PROCESO
      AND A.CONDUCE = PROCESO;
    --
    -- cursor que recupera el dia proceso del centro de distribucion.
    CURSOR C_DIA_PROCESO (Cv_Centro VARCHAR2,
                          Cv_NoCia  VARCHAR2) IS
      SELECT CD.DIA_PROCESO
      FROM NAF47_TNET.ARINCD CD
      WHERE CD.CENTRO = Cv_Centro
      AND CD.NO_CIA = Cv_NoCia;
    --
    Le_Error      Exception;
    Ld_DiaProceso DATE := NULL;
    --
  BEGIN
    --
    FOR Lr_Doc IN C_DOCUMENTOS_ACTUALIZAR LOOP
      --
      --se recupera dia proceso
      IF C_DIA_PROCESO%ISOPEN THEN
        CLOSE C_DIA_PROCESO;
      END IF;
      --
      OPEN C_DIA_PROCESO ( Lr_doc.Centro,
                           Lr_doc.No_Cia);
      FETCH C_DIA_PROCESO INTO Ld_DiaProceso;
      IF C_DIA_PROCESO%NOTFOUND THEN
        Ld_DiaProceso := NULL;
      END IF;
      CLOSE C_DIA_PROCESO;
      --
      IF Ld_DiaProceso IS NULL THEN
        Pv_MensajeError := 'No se pudo determinar dia proceso para centro: '||Lr_doc.Centro||', empresa: '||Pv_NoCia;
        RAISE Le_Error;
      END IF;    
      -- se valida que documento despacho generado se enuentre en dia proceso
      -- con esto se evita inconsistencia por cierre diario ejecutado en el mismo momento que se despacha
      -- solicitud de pedidos.
      IF Lr_Doc.Fecha != Ld_DiaProceso THEN
        Pv_MensajeError := 'Fecha proceso ha cambiado a '||to_char(Ld_DiaProceso,'dd/mm/yyyy')||' y no concuerda con fecha documento '||
          to_char(Lr_Doc.Fecha,'dd/mm/yyyy')||', debe volver a intentar el despacho.';
        RAISE Le_Error;
      END IF;
      --
      UPDATE NAF47_TNET.ARINME
      SET ESTADO = 'P'
      WHERE NO_CIA = Lr_Doc.No_Cia
      AND NO_DOCU = Lr_Doc.No_Docu;

      -- proceso que actualiza el movimiento de inventarios.
      NAF47_TNET.INACTUALIZA( Lr_Doc.NO_CIA ,
                              Lr_Doc.TIPO_DOC,
                              Lr_Doc.NO_DOCU,
                              Pv_MensajeError);

      IF Pv_MensajeError IS NOT NULL THEN
        Pv_MensajeError := 'Centro: '||Lr_Doc.Centro||'. '||Pv_MensajeError;
        RAISE Le_Error;
      END IF;
      --
      COMMIT;
      --
    END LOOP;

  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'INKG_INVENTARIO_LENTO_PROCESO.P_ACTUALIZA_DOCUMENTOS. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'INKG_INVENTARIO_LENTO_PROCESO.P_ACTUALIZA_DOCUMENTOS. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
  END P_ACTUALIZA_DOCUMENTOS;
  --
  --
  PROCEDURE P_PROCESAR ( Pv_NoCia IN OUT VARCHAR2) IS
    --
    Pv_MensajeError VARCHAR2(3000);
    Le_Error        EXCEPTION;
    --
  BEGIN
    P_ASIGNA_DATOS_PROCESO ( Pv_NoCia,
                             Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    --
    --
    P_GENERA_INGRESOS_BODEGA( Pv_NoCia,
                              Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    --
    --
    P_ACTUALIZA_DOCUMENTOS ( Pv_NoCia,
                             Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      Raise Le_Error;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_INVENTARIO_LENTO_PROCESO.P_PROCESAR',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_INVENTARIO_LENTO_PROCESO.P_PROCESAR',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_PROCESAR;

end INKG_INVENTARIO_LENTO_PROCESO;
/