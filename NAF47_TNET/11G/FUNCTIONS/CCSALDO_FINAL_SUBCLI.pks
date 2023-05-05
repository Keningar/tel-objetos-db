create or replace FUNCTION            CCSALDO_FINAL_SUBCLI(PV_NOCIA          VARCHAR2,
                                                PV_GRUPO          VARCHAR2,
                                                PV_CLIENTE        VARCHAR2,
                                                PV_SUBCLIENTE     VARCHAR2,
                                                PV_CENTRO         VARCHAR2,
                                                PD_FECHADESDE     DATE,
                                                PD_FECHAHASTA     DATE,
                                                PN_SALDO_ANTERIOR NUMBER
                                                )RETURN NUMBER IS
 -- Declaraciones de Cursores
 CURSOR C_SALDOSDEBITO_CREDITOS(CV_NOCIA          VARCHAR2,
                                CV_GRUPO          VARCHAR2,
                                CV_CLIENTE        VARCHAR2,
                                CV_SUBCLIENTE     VARCHAR2,
                                CV_CENTRO         VARCHAR2,
                                CD_FECHADESDE     DATE,
                                CD_FECHAHASTA     DATE
                                ) IS
  SELECT SUM(ta.DEBITOS) DEBITOS, SUM(ta.CREDITOS) CREDITOS
   FROM v_documentos_estado_cta ta
   WHERE ta.ESTADO <> 'P'
   AND  ta.NO_CIA = CV_NOCIA
   AND  ta.GRUPO = CV_GRUPO
   AND  ta.NO_CLIENTE = CV_CLIENTE
   AND  ta.SUB_CLIENTE = CV_SUBCLIENTE
   AND (CV_CENTRO = '%' OR ta.CENTRO = CV_CENTRO)
   AND  ta.FECHA BETWEEN CD_FECHADESDE
                 AND CD_FECHAHASTA;

 -- Declaracion de variables locales
 LN_SALDO_DEB  NUMBER;
 LN_SALDO_CRE  NUMBER;
 LN_SALDOFINAL NUMBER;
 --
BEGIN
 --
 LN_SALDO_DEB := 0;
 LN_SALDO_CRE := 0;
 --
 OPEN C_SALDOSDEBITO_CREDITOS(PV_NOCIA,PV_GRUPO,PV_CLIENTE,
                              PV_SUBCLIENTE,PV_CENTRO,PD_FECHADESDE,PD_FECHAHASTA
                             );
 FETCH C_SALDOSDEBITO_CREDITOS INTO LN_SALDO_DEB,LN_SALDO_CRE;
 CLOSE C_SALDOSDEBITO_CREDITOS;
 --
 LN_SALDOFINAL := PN_SALDO_ANTERIOR + LN_SALDO_DEB - LN_SALDO_CRE;
 --
 RETURN(LN_SALDOFINAL);
END CCSALDO_FINAL_SUBCLI;