create or replace PROCEDURE            CGdistribuir_cc (
    pCia       in varchar2,
    pAno       in varchar2,
    pMes       in varchar2,
    pTipoDist  in varchar2,
    pmsg_error in out varchar2
) IS
  --
  error_proceso  EXCEPTION;
  --
  vMoneda       arcgMS.moneda%type;
  vTipo         arcgAL.tipo%type;
  vMonto_nom    arcgD_CC.m_dist_nom%type  :=0;
  vMonto_dol    arcgD_CC.m_dist_dol%type  :=0;
  --
  CURSOR centros IS
    SELECT cuenta, centro_costo,
           m_dist_nom, m_dist_dol
       FROM arcghd_cc
      WHERE no_cia  = pCia
        AND ano     = pAno
        AND mes     = pMes
      ORDER BY  cuenta;
  --
  PROCEDURE MAYORI_CENTROS (pnuciaAD   VARCHAR2, panoAD    number,   pmesAD number,
                            pOrigenAD  VARCHAR2, pCta      VARCHAR2, pCentroC VARCHAR2,
                            pMnominal  number,   pMdolares number,   ptipo_linea VARCHAR2,
                            perror     in out varchar2) IS
    -- DISTRIBUYE los Costos por C.C., de mayor a menor
    -- o sea, mayoriza por centros
    nivel_CC   number(1) := 1;
    CCqMayo    varchar2(9):= '000000000';
  BEGIN
    WHILE pCentroC <> CCqMayo LOOP
        CCqMayo := substr(pCentroC,1,nivel_cc*3) ||
                   substr(CCqMayo,LEAST(nivel_cc*3+1,9),GREATEST(9-nivel_cc*3,0));
        CGMayoriza_CC( pNuciaAD, pAnoAD,    pMesAD,    pCta,
                       CCqMayo,  pMnominal, pMdolares, pTipo_linea, perror);
        if perror is not null then
           EXIT;
        end if;
        nivel_cc := nivel_cc + 1;
     END LOOP;
  END;
  --
BEGIN
   FOR cen IN centros LOOP
       IF nvl(cen.M_dist_Nom,0) >= 0 THEN
            vtipo := 'D';
       ELSE
            vtipo := 'C';
       END IF;
       IF pTipoDist = 'REVERSAR' THEN
            vMonto_nom := nvl(cen.M_dist_Nom,0)* -1;
            vMonto_dol := nvl(cen.M_dist_dol,0)* -1;
       ELSE
            vMonto_nom := nvl(cen.M_dist_Nom,0);
            vMonto_dol := nvl(cen.M_dist_dol,0);
       END IF;
       IF vMonto_nom <> 0 THEN
            MAYORI_CENTROS (pCia,       pAno,       pMes,
                           'CE',       cen.cuenta, cen.centro_costo,
                           vMonto_nom, vMonto_dol, vTipo,
                           pmsg_error);
       END IF;
   END LOOP;
   --
   -- ACTUALIZA EL INDICADOR EN MC
   UPDATE arcgMC
      SET indicador_cc_distbs = 'S'
      WHERE no_cia = pCia;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGdistribuir_cc');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGdistribuir_cc');
END;