CREATE OR REPLACE package            INREPORTEVALORIZACION_ME is

  -- Author  : MGUARANDA
  -- Created : 4/2/2009 7:12:27 PM
  -- Purpose : Generacion de Reportess(Resumnidos y detallados) de existencias valorizadas
  --           por fechas

--
PROCEDURE PROCESO_EXISTI_VALORIZADAS_ME(pv_nocia         VARCHAR2,
                                     pd_fecha_desde   DATE,
                                     pd_fecha_hasta   DATE,
                                     pv_centro        VARCHAR2,
                                     pv_indicador     VARCHAR2,
                                     pv_grupo_desde   VARCHAR2,
                                     pv_subgrup_desde VARCHAR2,
                                     pv_grupo_hasta   VARCHAR2,
                                     pv_subgrup_hasta VARCHAR2,
                                     pv_tipoCosto     VARCHAR2,
                                     pv_usuario       VARCHAR2,
                                     pv_error       OUT VARCHAR2
                                     );
--
PROCEDURE PU_REPORTE_DETALLADO_ME(nocia         VARCHAR2,
                                       fecha_desde   DATE,
                                       fecha_hasta   DATE,
                                       centro        VARCHAR2,
                                       indicador     VARCHAR2,
                                       grupo_desde   VARCHAR2,
                                       subgrup_desde VARCHAR2,
                                       grupo_hasta   VARCHAR2,
                                       subgrup_hasta VARCHAR2,
                                       tipo_costo    VARCHAR2,
                                       usuario       VARCHAR2,
                                       error         OUT VARCHAR2
                                       );
--
PROCEDURE PU_COSTOS_ARTICULOS_ME(pv_noCia       VARCHAR2,
                                      pv_Centro      VARCHAR2,
                                      pv_articulo    VARCHAR2,
                                      pv_bodega      VARCHAR2,
                                      pd_fecha_desde DATE,
                                      pd_fecha_hasta DATE,
                                      pv_marca       VARCHAR2,
                                      pv_descripArt  VARCHAR2,
                                      pv_division    VARCHAR2,
                                      pv_subdivision VARCHAR2,
                                      pv_tipoCosto   VARCHAR2,
                                      pv_user        VARCHAR2,
                                      --
                                      pv_fechaBandera VARCHAR2,
                                      pv_indicador    VARCHAR2,
                                      pn_semana       NUMBER,
                                      pn_anio         NUMBER,
                                      pd_fecha2       DATE,
                                      --
                                      pv_error       OUT VARCHAR2
                                      );
--
PROCEDURE PU_TRANSACC_ING_EGR_ME(PV_CIA        VARCHAR2,
                                     PV_CENTROS    VARCHAR2,
                                     PV_BOD        VARCHAR2,
                                     PV_ARTI       VARCHAR2,
                                     PN_SALDO_UN   NUMBER,
                                     PN_SALDO_MO   NUMBER,
                                     PD_FECHADESDE DATE,
                                     PD_FECHA2     DATE,
                                     PV_TIPO_COSTO VARCHAR2,
                                     PN_CANT_INI   OUT NUMBER,
                                     PN_VALOR_INI  OUT NUMBER,
                                     PV_ERROR      OUT VARCHAR2
                                    );
--
PROCEDURE PU_TRANSACC_VALORES_INEG_ME(PV_CIA          VARCHAR2,
                                        PV_CENTROS      VARCHAR2,
                                        PV_BOD          VARCHAR2,
                                        PV_ARTI         VARCHAR2,
                                        PD_FECHADESDE   DATE,
                                        PD_FECHAHASTA   DATE,
                                        PV_TIP_COSTO    VARCHAR2,
                                        PN_CANTING      OUT NUMBER,
                                        PN_VALORING     OUT NUMBER,
                                        PN_CANTEG       OUT NUMBER,
                                        PN_VALOREG      OUT NUMBER,
                                        PV_ERROR        OUT VARCHAR2
                                        );

--
PROCEDURE PU_CANTVALORES_SUMARIZADOS_ME(PN_CANTINICIAL   NUMBER,
                                     PN_VALORINICIAL  NUMBER,
                                     PN_CANTINGRESO   NUMBER,
                                     PN_VALORINGRESO  NUMBER,
                                     PN_CANTEGRESO    NUMBER,
                                     PN_VALOREGRESO   NUMBER,
                                     PN_CANTOTAL_ART  OUT NUMBER,
                                     PN_VALORTOTA_ART OUT NUMBER,
                                     PN_COSTO_PROMED  OUT NUMBER,
                                     PV_ERROR         OUT VARCHAR2
                                    );

--
PROCEDURE PU_PROCESO_CALENDARIO_ME(pv_nocia       VARCHAR2,
                                pd_fechaDesde  DATE,
                                pv_fechBandera OUT VARCHAR2,
                                pv_indicador   OUT VARCHAR2,
                                pn_semana      OUT NUMBER,
                                pn_anio        OUT NUMBER,
                                pd_fecha2      OUT DATE,
                                pv_error       OUT VARCHAR2
                               );
--
PROCEDURE PU_INSERTAR_SALDOS_ME(PV_NOCIA      VARCHAR2,
                                       PV_CENTRO     VARCHAR2,
                                       PV_BODEGA     VARCHAR2,
                                       PV_MARCA      VARCHAR2,
                                       PV_ARTICULO   VARCHAR2,
                                       PV_DESC_ART   VARCHAR2,
                                       PN_EXIST_INI  NUMBER,
                                       PN_VALOR_INI  NUMBER,
                                       PV_DIV        VARCHAR2,
                                       PV_SUBDIV     VARCHAR2,
                                       PN_CANTINGR   NUMBER,
                                       PN_VALORINGR  NUMBER,
                                       PN_CANTEGR    NUMBER,
                                       PN_VALOREGR   NUMBER,
                                       PN_CANTFINAL  NUMBER,
                                       PN_VALORFINAL NUMBER,
                                       PN_COSTO_PROM NUMBER,
                                       PV_USUARIO    VARCHAR2,
                                       PV_ERROR      OUT VARCHAR2
                                       );
--
PROCEDURE PU_ELIMINA_REGISTROS_ME(PV_NOCIA      VARCHAR2,
                                       PV_USUARIO    VARCHAR2,
                                       PV_ERROR      OUT VARCHAR2
                                      );
--

end INREPORTEVALORIZACION_ME;
/


CREATE OR REPLACE package body            INREPORTEVALORIZACION_ME is

-- Author  : MGUARANDA
-- Created : 4/2/2009 7:12:27 PM
-- Purpose : Generacion de Reportess(Resumnidos y detallados) de existencias valorizadas
--           por fechas

/***********************************************************************************************
-- Paquete principal llamado desde la forma pinv721
*************************************************************************************************/
PROCEDURE PROCESO_EXISTI_VALORIZADAS_ME(pv_nocia         VARCHAR2,
                                     pd_fecha_desde   DATE,
                                     pd_fecha_hasta   DATE,
                                     pv_centro        VARCHAR2,
                                     pv_indicador     VARCHAR2,
                                     pv_grupo_desde   VARCHAR2,
                                     pv_subgrup_desde VARCHAR2,
                                     pv_grupo_hasta   VARCHAR2,
                                     pv_subgrup_hasta VARCHAR2,
                                     pv_tipoCosto     VARCHAR2,
                                     pv_usuario       VARCHAR2,
                                     pv_error       OUT VARCHAR2
                                     ) IS

 -- Declaracion de cursores locales
 --Cursor para determina en que semana del calendario del sistema se encuentra
 CURSOR C_SEMANA (CV_NO_CIA VARCHAR2,
                  CD_FECHA  DATE) IS
  SELECT 'X'
   FROM CALENDARIO
   WHERE NO_CIA = CV_NO_CIA
   AND CD_FECHA BETWEEN FECHA1
                AND FECHA2;

 -- Declaracion de variables loacales.
 LE_ERROR   EXCEPTION;
 LB_EXISTE  BOOLEAN;
 lv_error   VARCHAR2(200);
 lv_semana  VARCHAR2(1);
 lv_usuario VARCHAR2(50);
--

BEGIN
 -- Seteo de variables
 lv_error   := null;
 --
 lv_usuario := pv_usuario;
 -- Abrir cursor de verificacion de calendario
 OPEN C_SEMANA(pv_nocia,pd_fecha_desde);
 FETCH C_SEMANA INTO lv_semana;
 LB_EXISTE := C_SEMANA%FOUND;
 CLOSE C_SEMANA;
 --
 IF NOT LB_EXISTE THEN
  LV_ERROR := 'No se ha definido calendario semanal';
  RAISE LE_ERROR;
 ELSE
   -- Proceso que genera la data para reportes de existencias valorizadas
   PU_REPORTE_DETALLADO_ME(nocia         => pv_nocia,
                                fecha_desde   => pd_fecha_desde,
                                fecha_hasta   => pd_fecha_hasta,
                                centro        => pv_centro,
                                indicador     => pv_indicador,
                                grupo_desde   => pv_grupo_desde,
                                subgrup_desde => pv_subgrup_desde,
                                grupo_hasta   => pv_grupo_hasta,
                                subgrup_hasta => pv_subgrup_hasta,
                                tipo_costo    => pv_tipoCosto,
                                usuario       => lv_usuario,
                                error         => lv_error);
   --
   IF lv_error IS NOT NULL THEN
     RAISE LE_ERROR;
   END IF;
 END IF;
--
EXCEPTION
 WHEN LE_ERROR THEN
  PV_ERROR := LV_ERROR;
 WHEN OTHERS THEN
  PV_ERROR := 'ERROR: '||'-'||SQLERRM;
END;

/***********************************************************************************************
-- Procedimiento que genera el reporte detallado de existencias valorizadas por fechas
*************************************************************************************************/
PROCEDURE PU_REPORTE_DETALLADO_ME(nocia         VARCHAR2,
                                       fecha_desde   DATE,
                                       fecha_hasta   DATE,
                                       centro        VARCHAR2,
                                       indicador     VARCHAR2,
                                       grupo_desde   VARCHAR2,
                                       subgrup_desde VARCHAR2,
                                       grupo_hasta   VARCHAR2,
                                       subgrup_hasta VARCHAR2,
                                       tipo_costo    VARCHAR2,
                                       usuario       VARCHAR2,
                                       error         OUT VARCHAR2
                                       ) IS

 -- Declaraciones de cursores
 -- Cursor para obtener los articulos que seran evaluados en el proceso de existencias valorizadas
 CURSOR C_ARTICULOS(cv_noCia          VARCHAR2,
                    cv_centro         VARCHAR2,
                    cv_indicador      VARCHAR2,
                    cv_grupo          VARCHAR2,
                    cv_grupohasta     VARCHAR2,
                    cv_subGrupo       VARCHAR2,
                    cv_subGrupo_hasta VARCHAR2
                   )IS
  SELECT /*+RULE*/
          C.CENTRO,
          B.BODEGA,
          A.DIVISION,
          A.SUBDIVISION,
          A.MARCA,
          A.NO_ARTI,
          A.DESCRIPCION
    FROM ARINDA A,
         ARINMA B,
         ARINBO C
    WHERE A.NO_CIA  = B.NO_CIA
    AND   A.NO_ARTI = B.NO_ARTI
    AND   B.NO_CIA  = C.NO_CIA
    AND   B.BODEGA  = C.CODIGO
    AND   A.NO_CIA  = cv_noCia
    AND   C.CENTRO  = DECODE(cv_centro,'%',C.CENTRO,cv_centro)
    AND   (A.IND_CLASIF  = cv_indicador OR cv_indicador = 'X')
    AND   B.BODEGA IN (SELECT BO.CODIGO
                        FROM ARINBO BO
                        WHERE BO.NO_CIA = cv_noCia
                        AND BO.CENTRO = DECODE(cv_centro,'%',BO.CENTRO,cv_centro)
                        AND BO.ACTIVA = 'S'
                        AND BO.MAL_ESTADO = 'S'
                        --AND BO.STAND_BY = 'N'
                      )
    AND   A.DIVISION IN (SELECT DV.DIVISION
                          FROM ARINDIV DV
                          WHERE DV.NO_CIA = cv_noCia
                          AND   DV.DIVISION BETWEEN DECODE(cv_grupo,'%',DV.DIVISION,cv_grupo)
                                            AND     DECODE(cv_grupohasta,'%',DV.DIVISION,cv_grupohasta)
                        )
    AND   A.SUBDIVISION IN (SELECT SDV.SUBDIVISION
                             FROM ARINSUBDIV SDV
                             WHERE SDV.NO_CIA = cv_noCia
                             AND   SDV.SUBDIVISION BETWEEN DECODE(cv_subGrupo,'%',SDV.SUBDIVISION,cv_subGrupo)
                                                   AND     DECODE(cv_subGrupo_hasta,'%',SDV.SUBDIVISION,cv_subGrupo_hasta)
                                                   AND   SDV.DIVISION IN (SELECT DV.DIVISION
                                                                           FROM ARINDIV DV
                                                                           WHERE DV.NO_CIA = cv_noCia
                                                                           AND   DV.DIVISION BETWEEN DECODE(cv_grupo,'%',DV.DIVISION,cv_grupo)
                                                                                             AND     DECODE(cv_grupohasta,'%',DV.DIVISION,cv_grupohasta)
                                                                         )
                           )
    ORDER BY C.CENTRO,B.BODEGA,
             A.DIVISION,A.SUBDIVISION;
 --
 TYPE R_Cursor IS RECORD (CENTRO      VARCHAR2(2),
                          BODEGA      VARCHAR2(4),
                          DIVISION    VARCHAR2(6),
                          SUBDIVISION VARCHAR2(6),
                          MARCA       VARCHAR2(6),
                          NO_ARTI     VARCHAR2(15),
                          DESCRIPCION VARCHAR2(100)
                          );

 TYPE ArticulosExistencias IS TABLE OF R_Cursor;
 Lc_ArticulosExistencias   ArticulosExistencias;

-- Declaracion de variables locales
 LV_ERROR       VARCHAR2(2000);
 lv_articulo    VARCHAR2(50);
 lv_bodega      VARCHAR2(50);
 lv_tipoCosto   VARCHAR2(2);
 lv_usuario     VARCHAR2(50);
 LE_ERROR       EXCEPTION;
 ld_fecha_desde DATE;
 ld_fecha_hasta DATE;
 --
 lv_fechaBandera VARCHAR2(1);
 lv_indicador    VARCHAR2(2);
 ln_semana       NUMBER;
 ln_anio         NUMBER;
 ld_fecha2       DATE;

--
BEGIN
 -- Setear variables
 ld_fecha_desde := fecha_desde;
 ld_fecha_hasta := fecha_hasta;
 lv_tipoCosto   := tipo_costo;
 lv_error       := NULL;
 lv_usuario     := usuario;

 --- logica para las fechas del calendario
 PU_PROCESO_CALENDARIO_ME(pv_nocia       => nocia,
                       pd_fechaDesde  => fecha_desde,
                       pv_fechBandera => lv_fechaBandera,
                       pv_indicador   => lv_indicador,
                       pn_semana      => ln_semana,
                       pn_anio        => ln_anio,
                       pd_fecha2      => ld_fecha2,
                       pv_error       => lv_error
                      );
 --
 IF lv_error IS NOT NULL THEN
  RAISE LE_ERROR;
 END IF;
 ---
 OPEN C_ARTICULOS(nocia,centro,indicador,
                  grupo_desde,grupo_hasta,
                  subgrup_desde,subgrup_hasta
                 );
 FETCH C_ARTICULOS BULK COLLECT INTO Lc_ArticulosExistencias;
 CLOSE C_ARTICULOS;
 --
 IF Lc_ArticulosExistencias.COUNT >0 THEN
   -- Proceso de obtener la data de los articulos.
   FOR r_art IN Lc_ArticulosExistencias.FIRST..Lc_ArticulosExistencias.LAST LOOP
     --
     lv_articulo := Lc_ArticulosExistencias(r_art).no_arti;
     lv_bodega   := Lc_ArticulosExistencias(r_art).bodega;
     --
     PU_COSTOS_ARTICULOS_ME(pv_noCia        => nocia,
                                 pv_Centro       => Lc_ArticulosExistencias(r_art).centro,
                                 pv_articulo     => lv_articulo,
                                 pv_bodega       => lv_bodega,
                                 pd_fecha_desde  => ld_fecha_desde,
                                 pd_fecha_hasta  => ld_fecha_hasta,
                                 pv_marca        => Lc_ArticulosExistencias(r_art).marca,
                                 pv_descripArt   => Lc_ArticulosExistencias(r_art).descripcion,
                                 pv_division     => Lc_ArticulosExistencias(r_art).division,
                                 pv_subdivision  => Lc_ArticulosExistencias(r_art).subdivision,
                                 pv_tipoCosto    => lv_tipoCosto,
                                 pv_user         => lv_usuario,
                                 pv_fechaBandera => lv_fechaBandera,
                                 pv_indicador    => lv_indicador,
                                 pn_semana       => ln_semana,
                                 pn_anio         => ln_anio,
                                 pd_fecha2       => ld_fecha2,
                                 pv_error       => lv_error
                                );
     --
     IF lv_error IS NULL THEN
         lv_articulo := null;
         lv_bodega   := null;
     ELSE
        RAISE LE_ERROR;
     END IF;
   --
   END LOOP;
 --
 ELSE
  LV_ERROR := 'No se encontro Informacion para esta consulta';
  RAISE LE_ERROR;
 END IF;
--
EXCEPTION
 WHEN LE_ERROR THEN
  error := LV_ERROR;
 WHEN OTHERS THEN
  ERROR := 'ERROR: '||'-'||SQLERRM;

END;

/***********************************************************************************************
-- Procedimiento que permite obtener los valores iniciales semanales(saldos) del artioculo
*************************************************************************************************/
PROCEDURE PU_COSTOS_ARTICULOS_ME(pv_noCia        VARCHAR2,
                                      pv_Centro       VARCHAR2,
                                      pv_articulo     VARCHAR2,
                                      pv_bodega       VARCHAR2,
                                      pd_fecha_desde  DATE,
                                      pd_fecha_hasta  DATE,
                                      pv_marca        VARCHAR2,
                                      pv_descripArt   VARCHAR2,
                                      pv_division     VARCHAR2,
                                      pv_subdivision  VARCHAR2,
                                      pv_tipoCosto    VARCHAR2,
                                      pv_user         VARCHAR2,
                                      pv_fechaBandera VARCHAR2,
                                      pv_indicador    VARCHAR2,
                                      pn_semana       NUMBER,
                                      pn_anio         NUMBER,
                                      pd_fecha2       DATE,
                                      pv_error        OUT VARCHAR2
                                     ) IS

 -- Declaraciones de cursores locales
 --Obteniedo saldo historico semanal
  CURSOR C_SALDO_MENSUAL(CV_NOCIA     VARCHAR2,
                         CV_CENTRO    VARCHAR2,
                         CV_BODEGA    VARCHAR2,
                         CN_INDICADOR NUMBER,
                         CN_SEMANA    NUMBER,
                         CN_ANIO      NUMBER,
                         CV_ARTICULO  VARCHAR2,
                         CV_tipoCosto VARCHAR2
                         ) IS
   SELECT H.SALDO_UN,
          DECODE(CV_tipoCosto,'C1',H.SALDO_MO,H.SALDO_MO2) SALDO_COSTO
    FROM ARINHA H
    WHERE H.NO_CIA  = CV_NOCIA
    AND   H.CENTRO  = CV_CENTRO
    AND   H.BODEGA  = CV_BODEGA
    AND   H.IND_SEM = CN_INDICADOR
    AND   H.SEMANA  = CN_SEMANA
    AND   H.ANO     = CN_ANIO
    AND   H.NO_ARTI = CV_ARTICULO;

 -- Declaraciones locales
 LE_ERROR         EXCEPTION;
 LV_ERROR         VARCHAR2(200);
 LR_SALDO_MENSUAL C_SALDO_MENSUAL%ROWTYPE;
 LV_NOCIA         VARCHAR2(3);
 LV_CENTRO        VARCHAR2(2);
 LV_BODEGA        VARCHAR2(4);
 LV_ARTICULO      VARCHAR2(15);
 LV_MARCA         VARCHAR2(6);
 LV_USUARIO       VARCHAR2(50);
 LV_DESCRIPART    VARCHAR2(100);
 LN_CANT_INI      NUMBER;
 LN_VALOR_INI     NUMBER;
 LN_CANTING       NUMBER;
 LN_VALORING      NUMBER;
 LN_CANTEG        NUMBER;
 LN_VALOREG       NUMBER;
 LN_CANTOTAL_ART  NUMBER;
 LN_VALORTOTA_ART NUMBER;
 LN_COSTO_PROMED  NUMBER;
 LD_FECHA2_AUX    DATE;

--
BEGIN
 -- Setear variables
 LN_CANT_INI      :=0;
 LN_VALOR_INI     :=0;
 LN_CANTING       :=0;
 LN_VALORING      :=0;
 LN_CANTEG        :=0;
 LN_VALOREG       :=0;
 LN_CANTOTAL_ART  :=0;
 LN_VALORTOTA_ART :=0;
 LN_COSTO_PROMED  :=0;
 LV_ERROR      :=NULL;
 LV_NOCIA      :=NULL;
 LV_CENTRO     :=NULL;
 LV_BODEGA     :=NULL;
 LV_ARTICULO   :=NULL;
 LV_MARCA      :=NULL;
 LV_USUARIO    :=NULL;
 LV_DESCRIPART :=NULL;
 LD_FECHA2_AUX := pd_fecha2;
 --

 IF pv_fechaBandera = 'N' THEN
   -- PROCESO QUE OBTENDRA LOS SALDOS(EN ARINHA)
   OPEN C_SALDO_MENSUAL(pv_noCia,pv_Centro,pv_bodega,
                        pv_indicador,pn_semana,
                        pn_anio,pv_articulo,pv_tipoCosto
                        );
   FETCH C_SALDO_MENSUAL INTO LR_SALDO_MENSUAL;
   CLOSE C_SALDO_MENSUAL;

   -- PROCESO PARA OBTENER DE LAS TRANSACCIONES LOS INGRESOS/EGRESOS PARA LA CANTIDAD/VALOR INICIALES
   PU_TRANSACC_ING_EGR_ME(PV_CIA        => pv_noCia,
                              PV_CENTROS    => pv_Centro,
                              PV_BOD        => pv_bodega,
                              PV_ARTI       => pv_articulo,
                              PN_SALDO_UN   => LR_SALDO_MENSUAL.SALDO_UN,
                              PN_SALDO_MO   => LR_SALDO_MENSUAL.SALDO_COSTO,
                              PD_FECHADESDE => pd_fecha_desde,
                              PD_FECHA2     => LD_FECHA2_AUX,
                              PV_TIPO_COSTO => pv_tipoCosto,
                              PN_CANT_INI   => LN_CANT_INI,
                              PN_VALOR_INI  => LN_VALOR_INI,
                              PV_ERROR      => LV_ERROR
                              );
    --
    IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
    END IF;
    --
    LV_NOCIA      := pv_noCia;
    LV_CENTRO     := pv_Centro;
    LV_BODEGA     := pv_bodega;
    LV_ARTICULO   := pv_articulo;
    LV_MARCA      := pv_marca;
    LV_DESCRIPART := pv_descripArt;
    LV_USUARIO    := pv_user;

    -- PROCESO PARA OBTENER  DE LAS TRANSACCIONES DE LOS INGRESOS/EGRESOS PARA LAS CANTIDADES/VALORES DE INGRESO/EGRESO
    PU_TRANSACC_VALORES_INEG_ME(PV_CIA          => LV_NOCIA,
                                  PV_CENTROS      => LV_CENTRO,
                                  PV_BOD          => LV_BODEGA,
                                  PV_ARTI         => LV_ARTICULO,
                                  PD_FECHADESDE   => pd_fecha_desde,
                                  PD_FECHAHASTA   => pd_fecha_hasta,
                                  PV_TIP_COSTO    => pv_tipoCosto,
                                  PN_CANTING      => LN_CANTING,
                                  PN_VALORING     => LN_VALORING,
                                  PN_CANTEG       => LN_CANTEG,
                                  PN_VALOREG      => LN_VALOREG,
                                  PV_ERROR        => LV_ERROR
                                  );
    --
    IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
    END IF;

    -- PROCESO POARA OBTENER VALORES TOTALES DE LAS CANTIDADES DE INGRESOS/EGRESOS DEL ARTICULO
    PU_CANTVALORES_SUMARIZADOS_ME(PN_CANTINICIAL   => LN_CANT_INI,
                               PN_VALORINICIAL  => LN_VALOR_INI,
                               PN_CANTINGRESO   => LN_CANTING,
                               PN_VALORINGRESO  => LN_VALORING,
                               PN_CANTEGRESO    => LN_CANTEG,
                               PN_VALOREGRESO   => LN_VALOREG,
                               PN_CANTOTAL_ART  => LN_CANTOTAL_ART,
                               PN_VALORTOTA_ART => LN_VALORTOTA_ART,
                               PN_COSTO_PROMED  => LN_COSTO_PROMED,
                               PV_ERROR         => LV_ERROR
                              );
    --
    IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
    END IF;

    --IF LN_COSTO_PROMED > 0 THEN
     -- INSERTAR EN TABLA TEMPORAL LOS VALORES OBTENIDOS EN LOS PROCESOS DE SALDOS.
     PU_INSERTAR_SALDOS_ME(PV_NOCIA      => LV_NOCIA,
                                  PV_CENTRO     => LV_CENTRO,
                                  PV_BODEGA     => LV_BODEGA,
                                  PV_MARCA      => LV_MARCA,
                                  PV_ARTICULO   => LV_ARTICULO,
                                  PV_DESC_ART   => LV_DESCRIPART,
                                  PN_EXIST_INI  => LN_CANT_INI,
                                  PN_VALOR_INI  => LN_VALOR_INI,
                                  PV_DIV        => pv_division,
                                  PV_SUBDIV     => pv_subdivision,
                                  PN_CANTINGR   => LN_CANTING,
                                  PN_VALORINGR  => LN_VALORING,
                                  PN_CANTEGR    => LN_CANTEG,
                                  PN_VALOREGR   => LN_VALOREG,
                                  PN_CANTFINAL  => LN_CANTOTAL_ART,
                                  PN_VALORFINAL => LN_VALORTOTA_ART,
                                  PN_COSTO_PROM => LN_COSTO_PROMED,
                                  PV_USUARIO    => LV_USUARIO,
                                  PV_ERROR      => LV_ERROR
                                 );
     --
     IF LV_ERROR IS NOT NULL THEN
      RAISE LE_ERROR;
     END IF;
    --END IF;
  --
 ELSE
   -- PROCESO QUE OBTENDRA LOS SALDOS(EN ARINHA)
   OPEN C_SALDO_MENSUAL(pv_noCia,pv_Centro,pv_bodega,
                        pv_indicador,pn_semana,
                        pn_anio,pv_articulo,pv_tipoCosto
                        );
   FETCH C_SALDO_MENSUAL INTO LR_SALDO_MENSUAL;
   CLOSE C_SALDO_MENSUAL;

   -- PROCESO QUE INSERTA EN TABLA TEMPORAL LOS SALDOS.
   LV_NOCIA      := pv_noCia;
   LV_CENTRO     := pv_Centro;
   LV_BODEGA     := pv_bodega;
   LV_ARTICULO   := pv_articulo;
   LV_MARCA      := pv_marca;
   LV_USUARIO    := pv_user;
   LV_DESCRIPART := pv_descripArt;
   LN_CANT_INI   := LR_SALDO_MENSUAL.SALDO_UN;
   LN_VALOR_INI  := LR_SALDO_MENSUAL.SALDO_COSTO;

   -- PROCESO PARA OBTENER  DE LAS TRANSACCIONES DE LOS INGRESOS/EGRESOS PARA LAS CANTIDADES/VALORES DE INGRESO/EGRESO
   PU_TRANSACC_VALORES_INEG_ME(PV_CIA          => LV_NOCIA,
                                 PV_CENTROS      => LV_CENTRO,
                                 PV_BOD          => LV_BODEGA,
                                 PV_ARTI         => LV_ARTICULO,
                                 PD_FECHADESDE   => pd_fecha_desde,
                                 PD_FECHAHASTA   => pd_fecha_hasta,
                                 PV_TIP_COSTO    => pv_tipoCosto,
                                 PN_CANTING      => LN_CANTING,
                                 PN_VALORING     => LN_VALORING,
                                 PN_CANTEG       => LN_CANTEG,
                                 PN_VALOREG      => LN_VALOREG,
                                 PV_ERROR        => LV_ERROR
                                 );
    --
    IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
    END IF;

    -- PROCESO POARA OBTENER VALORES TOTALES DE LAS CANTIDADES DE INGRESOS/EGRESOS DEL ARTICULO
    PU_CANTVALORES_SUMARIZADOS_ME(PN_CANTINICIAL   => LN_CANT_INI,
                               PN_VALORINICIAL  => LN_VALOR_INI,
                               PN_CANTINGRESO   => LN_CANTING,
                               PN_VALORINGRESO  => LN_VALORING,
                               PN_CANTEGRESO    => LN_CANTEG,
                               PN_VALOREGRESO   => LN_VALOREG,
                               PN_CANTOTAL_ART  => LN_CANTOTAL_ART,
                               PN_VALORTOTA_ART => LN_VALORTOTA_ART,
                               PN_COSTO_PROMED  => LN_COSTO_PROMED,
                               PV_ERROR         => LV_ERROR
                              );
    --
    IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
    END IF;

   -- insertar en tabla temporal los valores generados
   --IF LN_COSTO_PROMED > 0 THEN
     PU_INSERTAR_SALDOS_ME(PV_NOCIA      => LV_NOCIA,
                                  PV_CENTRO     => LV_CENTRO,
                                  PV_BODEGA     => LV_BODEGA,
                                  PV_MARCA      => LV_MARCA,
                                  PV_ARTICULO   => LV_ARTICULO,
                                  PV_DESC_ART   => LV_DESCRIPART,
                                  PN_EXIST_INI  => NVL(LN_CANT_INI,0),
                                  PN_VALOR_INI  => NVL(LN_VALOR_INI,0),
                                  PV_DIV        => pv_division,
                                  PV_SUBDIV     => pv_subdivision,
                                  PN_CANTINGR   => LN_CANTING,
                                  PN_VALORINGR  => LN_VALORING,
                                  PN_CANTEGR    => LN_CANTEG,
                                  PN_VALOREGR   => LN_VALOREG,
                                  PN_CANTFINAL  => LN_CANTOTAL_ART,
                                  PN_VALORFINAL => LN_VALORTOTA_ART,
                                  PN_COSTO_PROM => LN_COSTO_PROMED,
                                  PV_USUARIO    => LV_USUARIO,
                                  PV_ERROR      => LV_ERROR
                                 );
     --
     IF LV_ERROR IS NOT NULL THEN
      RAISE LE_ERROR;
     END IF;
   --END IF;
   --
 END IF;
 --
EXCEPTION
 WHEN LE_ERROR THEN
  pv_error := LV_ERROR;
 WHEN OTHERS THEN
  pv_error := 'ERROR: '||'-'||SQLERRM;
--
END;

/**************************************************************************************************
-- Procedimiento que permite obtener los saldos del articulo segun trnasacciones de ingreso/egreso
***************************************************************************************************/
PROCEDURE PU_TRANSACC_ING_EGR_ME(PV_CIA        VARCHAR2,
                                     PV_CENTROS    VARCHAR2,
                                     PV_BOD        VARCHAR2,
                                     PV_ARTI       VARCHAR2,
                                     PN_SALDO_UN   NUMBER,
                                     PN_SALDO_MO   NUMBER,
                                     PD_FECHADESDE DATE,
                                     PD_FECHA2     DATE,
                                     PV_TIPO_COSTO VARCHAR2,
                                     PN_CANT_INI   OUT NUMBER,
                                     PN_VALOR_INI  OUT NUMBER,
                                     PV_ERROR      OUT VARCHAR2
                                    )IS
 -- Declaracion de cursores locales
 -- Cursor quer obtiene los valores de unidades y monto de las transacciones de entrada
 CURSOR C_TRANS_INGRESO(CV_CIA        VARCHAR2,
                        CV_CENTRO     VARCHAR2,
                        CD_FECHA2     DATE,
                        CD_FECHADESDE DATE,
                        CV_BOD        VARCHAR2,
                        CV_ARTI       VARCHAR2,
                        CV_TIPOCOSTO  VARCHAR2
                       )IS
  SELECT ML.UNIDADES,
         DECODE(CV_TIPOCOSTO,'C1',NVL(ML.MONTO,0),NVL(ML.MONTO2,0)) COSTO
   FROM ARINML ML
   WHERE ML.NO_CIA = CV_CIA
   AND   ML.CENTRO = CV_CENTRO
   AND   ML.NO_DOCU  IN (SELECT ME.NO_DOCU
                          FROM  ARINME ME
                          WHERE ME.NO_CIA = CV_CIA
                          AND   ME.CENTRO = CV_CENTRO
                          AND   ME.FECHA >= CD_FECHA2 + 1
                          AND   ME.FECHA <= CD_FECHADESDE - 1
                          AND   ME.ESTADO <> 'P'
                          AND  ME.TIPO_DOC IN (SELECT VT.TIPO_M
                                                FROM ARINVTM VT
                                                WHERE VT.NO_CIA = CV_CIA
                                                AND   VT.MOVIMI = 'E'
                                              ))
   AND   ML.BODEGA = CV_BOD
   AND   ML.NO_ARTI = CV_ARTI;

 -- Cursor quer obtiene los valores de unidades y monto de las transacciones de Salida
 CURSOR C_TRANS_EGRESOS(CV_CIA        VARCHAR2,
                        CV_CENTRO     VARCHAR2,
                        CD_FECHA2     DATE,
                        CD_FECHADESDE DATE,
                        CV_BOD        VARCHAR2,
                        CV_ARTI       VARCHAR2,
                        CV_TIPOCOSTO  VARCHAR2
                       )IS
  SELECT ML.UNIDADES,
         DECODE(CV_TIPOCOSTO,'C1',NVL(ML.MONTO,0),NVL(ML.MONTO2,0)) COSTO
   FROM ARINML ML
   WHERE ML.NO_CIA = CV_CIA
   AND   ML.CENTRO = CV_CENTRO
   AND   ML.NO_DOCU  IN (SELECT ME.NO_DOCU
                          FROM  ARINME ME
                          WHERE ME.NO_CIA = CV_CIA
                          AND   ME.CENTRO = CV_CENTRO
                          AND   ME.FECHA >= CD_FECHA2 + 1
                          AND   ME.FECHA <= CD_FECHADESDE - 1
                          AND   ME.ESTADO <> 'P'
                          AND  ME.TIPO_DOC IN (SELECT VT.TIPO_M
                                                FROM ARINVTM VT
                                                WHERE VT.NO_CIA = CV_CIA
                                                AND   VT.MOVIMI = 'S'
                                              ))
   AND   ML.BODEGA = CV_BOD
   AND   ML.NO_ARTI = CV_ARTI;

 -- Decclaracion de variables locales
 LN_UNIDADES_IG  NUMBER;
 LN_MONTO_IG     NUMBER;
 LN_UNIDADES_EG  NUMBER;
 LN_MONTO_EG     NUMBER;
 LN_CANTIDAD_INI NUMBER;
 LN_VALOR_INI    NUMBER;

--
BEGIN
 -- Setear variables
 LN_UNIDADES_IG  := 0;
 LN_MONTO_IG     := 0;
 LN_UNIDADES_EG  := 0;
 LN_MONTO_EG     := 0;

 -- BARRER LAS TRANSACCIONES DE INGRESO
 FOR r_transIg IN C_TRANS_INGRESO(PV_CIA,PV_CENTROS,PD_FECHA2,
                                  PD_FECHADESDE,PV_BOD,PV_ARTI,
                                  PV_TIPO_COSTO
                                 )LOOP
  --
  LN_UNIDADES_IG := LN_UNIDADES_IG + r_transIg.UNIDADES;
  LN_MONTO_IG    := LN_MONTO_IG    + r_transIg.COSTO;
 END LOOP;

 -- BARRER LAS TRANSACCIONES DE EGRESO
 FOR r_transEg IN  C_TRANS_EGRESOS(PV_CIA,PV_CENTROS,PD_FECHA2,
                                   PD_FECHADESDE,PV_BOD,PV_ARTI,
                                   PV_TIPO_COSTO
                                  )LOOP
  --
  LN_UNIDADES_EG := LN_UNIDADES_EG + r_transEg.UNIDADES;
  LN_MONTO_EG    := LN_MONTO_EG    + r_transEg.COSTO;
 END LOOP;

 -- Realizar calculo para obtener cantidad_inicial y valor inicial
  LN_CANTIDAD_INI := NVL(PN_SALDO_UN,0) + NVL(LN_UNIDADES_IG,0) - NVL(LN_UNIDADES_EG,0);
  LN_VALOR_INI    := NVL(PN_SALDO_MO,0) + NVL(LN_MONTO_IG,0) - NVL(LN_MONTO_EG,0);

 -- Asignar los valores a los parametros de salida
 PN_CANT_INI  := LN_CANTIDAD_INI;
 PN_VALOR_INI := LN_VALOR_INI;
--
EXCEPTION
 WHEN OTHERS THEN
  pv_error := 'ERROR: '||'-'||SQLERRM;
END;

/**************************************************************************************************
-- Procedimiento que permite obtener los saldos del articulo segun trnasacciones de ingreso/egreso
***************************************************************************************************/
PROCEDURE PU_TRANSACC_VALORES_INEG_ME(PV_CIA          VARCHAR2,
                                        PV_CENTROS      VARCHAR2,
                                        PV_BOD          VARCHAR2,
                                        PV_ARTI         VARCHAR2,
                                        PD_FECHADESDE   DATE,
                                        PD_FECHAHASTA   DATE,
                                        PV_TIP_COSTO    VARCHAR2,
                                        PN_CANTING      OUT NUMBER,
                                        PN_VALORING     OUT NUMBER,
                                        PN_CANTEG       OUT NUMBER,
                                        PN_VALOREG      OUT NUMBER,
                                        PV_ERROR        OUT VARCHAR2
                                        )IS

 -- Declaracion de cursores locales
 -- Cursor quer obtiene los valores de unidades y monto de las transacciones de entrada
 CURSOR C_TRANS_INGRESO(CV_CIA        VARCHAR2,
                        CV_CENTRO     VARCHAR2,
                        CD_FECHADESDE DATE,
                        CD_FECHAHASTA DATE,
                        CV_BOD        VARCHAR2,
                        CV_ARTI       VARCHAR2,
                        CV_TIPCOSTO   VARCHAR2
                       )IS
  SELECT ML.UNIDADES,
         DECODE(CV_TIPCOSTO,'C1',NVL(ML.MONTO,0),NVL(ML.MONTO2,0)) COSTO
   FROM ARINML ML
   WHERE ML.NO_CIA = CV_CIA
   AND   ML.CENTRO = CV_CENTRO
   AND   ML.NO_DOCU  IN (SELECT ME.NO_DOCU
                          FROM  ARINME ME
                          WHERE ME.NO_CIA = CV_CIA
                          AND   ME.CENTRO = CV_CENTRO
                          AND   ME.FECHA >= CD_FECHADESDE
                          AND   ME.FECHA <= CD_FECHAHASTA
                          AND   ME.ESTADO <> 'P'
                          AND  ME.TIPO_DOC IN (SELECT VT.TIPO_M
                                                FROM ARINVTM VT
                                                WHERE VT.NO_CIA = CV_CIA
                                                AND   VT.MOVIMI = 'E'
                                              ))
   AND   ML.BODEGA = CV_BOD
   AND   ML.NO_ARTI = CV_ARTI;

 -- Cursor quer obtiene los valores de unidades y monto de las transacciones de entrada
 CURSOR C_TRANS_EGRESOS(CV_CIA        VARCHAR2,
                        CV_CENTRO     VARCHAR2,
                        CD_FECHADESDE DATE,
                        CD_FECHAHASTA DATE,
                        CV_BOD        VARCHAR2,
                        CV_ARTI       VARCHAR2,
                        CV_TIPCOSTO   VARCHAR2
                       )IS
  SELECT ML.UNIDADES,
         DECODE(CV_TIPCOSTO,'C1',NVL(ML.MONTO,0),NVL(ML.MONTO2,0)) COSTO
   FROM ARINML ML
   WHERE ML.NO_CIA = CV_CIA
   AND   ML.CENTRO = CV_CENTRO
   AND   ML.NO_DOCU  IN (SELECT ME.NO_DOCU
                          FROM  ARINME ME
                          WHERE ME.NO_CIA = CV_CIA
                          AND   ME.CENTRO = CV_CENTRO
                          AND   ME.FECHA >= CD_FECHADESDE
                          AND   ME.FECHA <= CD_FECHAHASTA
                          AND   ME.ESTADO <> 'P'
                          AND  ME.TIPO_DOC IN (SELECT VT.TIPO_M
                                                FROM ARINVTM VT
                                                WHERE VT.NO_CIA = CV_CIA
                                                AND   VT.MOVIMI = 'S'
                                              ))
   AND   ML.BODEGA = CV_BOD
   AND   ML.NO_ARTI = CV_ARTI;

 -- Decclaracion de variables locales
 LV_ERROR        VARCHAR2(200);
 LN_UNIDADES_IG  NUMBER;
 LN_MONTO_IG     NUMBER;
 LN_UNIDADES_EG  NUMBER;
 LN_MONTO_EG     NUMBER;

--
BEGIN
 -- Seteo de variables
 LN_UNIDADES_IG  := 0;
 LN_MONTO_IG     := 0;
 LN_UNIDADES_EG  := 0;
 LN_MONTO_EG     := 0;

 -- BARRER LAS TRANSACCIONES DE INGRESO
 FOR r_transIg IN C_TRANS_INGRESO(PV_CIA,PV_CENTROS,PD_FECHADESDE,
                                  PD_FECHAHASTA,PV_BOD,PV_ARTI,
                                  PV_TIP_COSTO
                                 )LOOP
  --
  LN_UNIDADES_IG := LN_UNIDADES_IG + r_transIg.UNIDADES;
  LN_MONTO_IG    := LN_MONTO_IG    + r_transIg.Costo;
 END LOOP;

 -- BARRER LAS TRANSACCIONES DE EGRESO
 FOR r_transEg IN  C_TRANS_EGRESOS(PV_CIA,PV_CENTROS,PD_FECHADESDE,
                                   PD_FECHAHASTA,PV_BOD,PV_ARTI,
                                   PV_TIP_COSTO
                                  )LOOP
  --
  LN_UNIDADES_EG := LN_UNIDADES_EG + r_transEg.UNIDADES;
  LN_MONTO_EG    := LN_MONTO_EG    + r_transEg.Costo;
 END LOOP;

 -- Asignar los valores a los parametros de salida
 PN_CANTING  :=  NVL(LN_UNIDADES_IG,0);
 PN_VALORING :=  NVL(LN_MONTO_IG,0);
 PN_CANTEG   :=  NVL(LN_UNIDADES_EG,0);
 PN_VALOREG  :=  NVL(LN_MONTO_EG,0);
--
EXCEPTION
 WHEN  OTHERS THEN
  LV_ERROR := 'Error General  '||SQLERRM;
  PV_ERROR := LV_ERROR;
END;

/**************************************************************************************************
-- Procedimiento que permite Insertar en la tabla temporal los saldos acumulados
***************************************************************************************************/
PROCEDURE PU_CANTVALORES_SUMARIZADOS_ME(PN_CANTINICIAL   NUMBER,
                                     PN_VALORINICIAL  NUMBER,
                                     PN_CANTINGRESO   NUMBER,
                                     PN_VALORINGRESO  NUMBER,
                                     PN_CANTEGRESO    NUMBER,
                                     PN_VALOREGRESO   NUMBER,
                                     PN_CANTOTAL_ART  OUT NUMBER,
                                     PN_VALORTOTA_ART OUT NUMBER,
                                     PN_COSTO_PROMED  OUT NUMBER,
                                     PV_ERROR         OUT VARCHAR2
                                    )IS
 --Declaraciones de variables locales
 LN_CANTOTAL_ART  NUMBER;
 LN_VALORTOTA_ART NUMBER;
--
BEGIN
 -- Calculo
 LN_CANTOTAL_ART :=  NVL(PN_CANTINICIAL,0) + NVL(PN_CANTINGRESO,0) - NVL(PN_CANTEGRESO,0);
 LN_VALORTOTA_ART := NVL(PN_VALORINICIAL,0) + NVL(PN_VALORINGRESO,0) - NVL(PN_VALOREGRESO,0);
 -- Asignar a los parametros de salida
 PN_CANTOTAL_ART  := LN_CANTOTAL_ART;
 PN_VALORTOTA_ART := LN_VALORTOTA_ART;
 IF LN_CANTOTAL_ART <> 0 THEN
  PN_COSTO_PROMED  := LN_VALORTOTA_ART/LN_CANTOTAL_ART;
 ELSE
  PN_COSTO_PROMED :=0;
 END IF;
--
EXCEPTION
 WHEN OTHERS THEN
  pv_error := 'ERROR: '||'-'||SQLERRM;
END;

/**************************************************************************************************
-- Procedimiento que permite Insertar en la tabla temporal los saldos acumulados
***************************************************************************************************/
PROCEDURE PU_PROCESO_CALENDARIO_ME(pv_nocia       VARCHAR2,
                                pd_fechaDesde  DATE,
                                pv_fechBandera OUT VARCHAR2,
                                pv_indicador   OUT VARCHAR2,
                                pn_semana      OUT NUMBER,
                                pn_anio        OUT NUMBER,
                                pd_fecha2      OUT DATE, -- DEFAUL NULL
                                pv_error       OUT VARCHAR2
                               )IS
 -- Declaracion de cursores
 --Cursor para obtener informacion del calendario
 CURSOR C_SEMANA (CV_NO_CIA VARCHAR2,
                  CD_FECHA  DATE) IS
  SELECT ANO,SEMANA,MES,INDICADOR,FECHA1,FECHA2
   FROM CALENDARIO
   WHERE NO_CIA = CV_NO_CIA
   AND CD_FECHA BETWEEN FECHA1
                AND FECHA2;
 ---
 CURSOR C_FECHA_ANT (CV_NO_CIA VARCHAR2,
                     CD_FECHA  DATE
                    ) IS
  SELECT ANO,SEMANA,MES,INDICADOR,FECHA1,FECHA2
   FROM CALENDARIO
   WHERE NO_CIA = CV_NO_CIA
   AND   FECHA2 = CD_FECHA;

 -- Declaracion de variables
 LR_CALENDARIO     C_SEMANA%ROWTYPE;
 --
 LN_PRIMER_DIA     NUMBER:=01;
 LN_DIA_DESDE      NUMBER;
 LN_MES_DESDE      NUMBER;
 LN_ANIO_DESDE     NUMBER;
 LD_FECHA1_CAL     DATE;
 LD_FECHA_AUX      DATE;
 LD_FECHA_AUX1     DATE;
 LV_DIA            VARCHAR2(4);
 LV_MES            VARCHAR2(4);
 LV_ANIO           VARCHAR2(4);
 LV_FECHA          VARCHAR2(30);
 LR_CALENDARIO_ANT C_FECHA_ANT%ROWTYPE;
 --

BEGIN

 -- Abrir cursor de verificacion de calendario
 OPEN  C_SEMANA(pv_noCia,pd_fechaDesde);
 FETCH C_SEMANA INTO LR_CALENDARIO;
 CLOSE C_SEMANA;
 --
 LN_DIA_DESDE := TO_NUMBER(TO_CHAR(PD_FECHADESDE,'dd'));
 --
 IF LN_DIA_DESDE = 1 THEN
  LD_FECHA1_CAL :=  LR_CALENDARIO.FECHA1 -1;
  --
  OPEN  C_FECHA_ANT(pv_noCia,LD_FECHA1_CAL);
  FETCH C_FECHA_ANT INTO LR_CALENDARIO_ANT;
  CLOSE C_FECHA_ANT;
  --
  pv_fechBandera := 'S';
  pv_indicador   := LR_CALENDARIO_ANT.INDICADOR;
  pn_semana      := LR_CALENDARIO_ANT.SEMANA;
  pn_anio        := LR_CALENDARIO_ANT.ANO;
  pd_fecha2      := NULL;
  --
 ELSE
  LN_MES_DESDE := TO_NUMBER(TO_CHAR(PD_FECHADESDE,'mm'));
  LN_ANIO_DESDE := TO_NUMBER(TO_CHAR(PD_FECHADESDE,'yyyy'));
  ---
  LV_DIA  := TO_CHAR(LN_PRIMER_DIA);
  LV_MES  := TO_CHAR(LN_MES_DESDE);
  LV_ANIO := TO_CHAR(LN_ANIO_DESDE);
  --
  LV_FECHA      := LV_DIA||'/'||LV_MES||'/'||LV_ANIO;
  LD_FECHA_AUX  := TO_DATE(LV_FECHA,'DD/MM/YYYY');
  --
  LD_FECHA_AUX1  := LD_FECHA_AUX -1;
  --
  OPEN  C_FECHA_ANT(pv_noCia,LD_FECHA_AUX1);
  FETCH C_FECHA_ANT INTO LR_CALENDARIO_ANT;
  CLOSE C_FECHA_ANT;
  --
  pv_fechBandera := 'N';
  pv_indicador   := LR_CALENDARIO_ANT.INDICADOR;
  pn_semana      := LR_CALENDARIO_ANT.SEMANA;
  pn_anio        := LR_CALENDARIO_ANT.ANO;
  pd_fecha2      := LR_CALENDARIO_ANT.FECHA2;
  --
 END IF;
 --
EXCEPTION
 WHEN OTHERS THEN
  pv_error := 'ERROR: '||'-'||SQLERRM;
END;

/**************************************************************************************************
-- Procedimiento que permite Insertar en la tabla temporal los saldos acumulados
***************************************************************************************************/
PROCEDURE PU_INSERTAR_SALDOS_ME(PV_NOCIA      VARCHAR2,
                                       PV_CENTRO     VARCHAR2,
                                       PV_BODEGA     VARCHAR2,
                                       PV_MARCA      VARCHAR2,
                                       PV_ARTICULO   VARCHAR2,
                                       PV_DESC_ART   VARCHAR2,
                                       PN_EXIST_INI  NUMBER,
                                       PN_VALOR_INI  NUMBER,
                                       PV_DIV        VARCHAR2,
                                       PV_SUBDIV     VARCHAR2,
                                       PN_CANTINGR   NUMBER,
                                       PN_VALORINGR  NUMBER,
                                       PN_CANTEGR    NUMBER,
                                       PN_VALOREGR   NUMBER,
                                       PN_CANTFINAL  NUMBER,
                                       PN_VALORFINAL NUMBER,
                                       PN_COSTO_PROM NUMBER,
                                       PV_USUARIO    VARCHAR2,
                                       PV_ERROR      OUT VARCHAR2
                                       )IS
 -- Declaracion de variables locales
 LV_ERROR VARCHAR2(200);
--
BEGIN
 -- Setear variables
 LV_ERROR := NULL;
 --
  INSERT INTO ARINVEXIST_VALORIZADAS (COD_CIA,
                                          CENTRO,
                                          BODEGA,
                                          MARCA,
                                          DIVISION,
                                          SUBDIVISION,
                                          COD_ARTICULO,
                                          DESCRIPC_ARTICULO,
                                          EXIST_INICIO,
                                          VALOR_INICIAL,
                                          CANT_INGRESO,
                                          VALOR_INGRESO,
                                          CANT_EGRESO,
                                          VALOR_EGRESO,
                                          CATIDAD_FINAL,
                                          VALOR_FINAL,
                                          COSTO_PROMEDIO,
                                          USUARIO
                                         )
                            VALUES       (PV_NOCIA,
                                          PV_CENTRO,
                                          PV_BODEGA,
                                          PV_MARCA,
                                          PV_DIV,
                                          PV_SUBDIV,
                                          PV_ARTICULO,
                                          PV_DESC_ART,
                                          PN_EXIST_INI,
                                          PN_VALOR_INI,
                                          PN_CANTINGR,
                                          PN_VALORINGR,
                                          PN_CANTEGR,
                                          PN_VALOREGR,
                                          PN_CANTFINAL,
                                          PN_VALORFINAL,
                                          PN_COSTO_PROM,
                                          PV_USUARIO
                                         );
 COMMIT;

EXCEPTION
 WHEN  OTHERS THEN
  LV_ERROR := 'Error General  '||SQLERRM;
  PV_ERROR := LV_ERROR;
  ROLLBACK;
END;
--
/**************************************************************************************************
-- Procedimiento que permite Borrar los registros de la tabla temporal por usuario que genero el
-- Reporte
***************************************************************************************************/
PROCEDURE PU_ELIMINA_REGISTROS_ME(PV_NOCIA      VARCHAR2,
                                       PV_USUARIO    VARCHAR2,
                                       PV_ERROR      OUT VARCHAR2
                                      )IS
 -- Declaracion de variables locales
 LV_ERROR VARCHAR2(200);
--
BEGIN
 -- Setear variables
 LV_ERROR := NULL;
 --
 DELETE ARINVEXIST_VALORIZADAS T
  WHERE T.COD_CIA = PV_NOCIA
  AND   T.USUARIO = PV_USUARIO;
 --
 COMMIT;
--
EXCEPTION
 WHEN  OTHERS THEN
  LV_ERROR := 'Error General  '||SQLERRM;
  PV_ERROR := LV_ERROR;
  ROLLBACK;
END;
--
END INREPORTEVALORIZACION_ME;
/
