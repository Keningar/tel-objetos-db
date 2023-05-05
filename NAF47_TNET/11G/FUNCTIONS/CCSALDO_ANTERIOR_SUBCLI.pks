create or replace FUNCTION            CCSALDO_ANTERIOR_SUBCLI(PV_NOCIA      VARCHAR2,
                                                   PV_CENTRO     VARCHAR2,
                                                   PV_GRUPO      VARCHAR2,
                                                   PV_CLIENTE    VARCHAR2,
                                                   PV_SUBCLIENTE VARCHAR2,
                                                   PD_FECHADESDE DATE
                                                   )RETURN NUMBER IS
 --
 CURSOR C_SALDO_UNIF(CV_NOCIA       VARCHAR2,
                     CV_CENTRO      VARCHAR2,
                     CV_GRUPO       VARCHAR2,
                     CV_CLIENTE     VARCHAR2,
                     CV_SUBCLIENTE  VARCHAR2,
                     CD_FECHA_DESDE DATE
                    )IS
  SELECT NVL(SUM(ta.DEBITOS),0) - NVL(SUM(ta.CREDITOS),0) TOTAL
   FROM v_documentos_estado_cta ta
   WHERE ta.ESTADO <> 'P'
   AND  ta.NO_CIA = CV_NOCIA
   AND  ta.GRUPO = CV_GRUPO
   AND  ta.NO_CLIENTE = CV_CLIENTE
   AND  ta.SUB_CLIENTE = CV_SUBCLIENTE
   AND (CV_CENTRO = '%' OR ta.CENTRO = CV_CENTRO)
   AND  ta.FECHA < CD_FECHA_DESDE;

-- Declaracion de variables
 LN_SALDO_UNIF  NUMBER;

BEGIN
 -- Setear variables
 LN_SALDO_UNIF  := 0;
 --
 --
 OPEN C_SALDO_UNIF(PV_NOCIA,PV_CENTRO,PV_GRUPO,PV_CLIENTE,PV_SUBCLIENTE,PD_FECHADESDE);
 FETCH C_SALDO_UNIF INTO LN_SALDO_UNIF;
 CLOSE C_SALDO_UNIF;
 --
 RETURN(LN_SALDO_UNIF);
END CCSALDO_ANTERIOR_SUBCLI;