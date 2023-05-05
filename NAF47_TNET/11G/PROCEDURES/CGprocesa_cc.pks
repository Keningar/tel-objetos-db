create or replace PROCEDURE            CGprocesa_cc(
  pnuciaad    in varchar2,
  panoad      in number,
  pmesad      in number,
  porigenad   in varchar2,
  pcta        in varchar2,
  pcentroc    in varchar2,
  pmnominal   in number,
  pmdolares   in number,
  ptipo_linea in varchar2,
  pmsg_error  in out varchar2
) IS
  -- --
  -- actualiza Centros de Costos, el 0-0-0 y el resto de mayor a menor
  --
  --
  error_proceso  EXCEPTION;
  --
  nivel_CC  number(1)   := 1;
  CCqMayo   varchar2(9) := '000000000';
BEGIN
  ---
  ---  mayoriza el Centro 000-000-000, excepto p. el Asiento de Dif Camb.
  ---  pues este lo hace en dos partes, 1- para la cia (0-0-0) y otro
  ---  para c/u de los Cent. de Costos
  --
  IF pOrigenAD = 'DC' OR pOrigenAD = 'D1' THEN
     -- para evitar desajustes, en caso del AD de difer. cambiario,
     --   este se calcula y mayoriza, centro por centro
     CGMayoriza_CC( pNuciaAD, pAnoAD,    pMesAD,    pCta,
                    pCentroC, pMnominal, pMdolares, pTipo_linea, pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
  ELSE
     CGMayoriza_CC(pNuciaAD, pAnoAD,    pMesAD,    pCta,
                   CCqMayo,  pMnominal, pMdolares, pTipo_linea, pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
     WHILE pCentroC <> CCqMayo LOOP
        CCqMayo := substr(pCentroC,1,nivel_cc*3) ||
                   substr(CCqMayo,LEAST(nivel_cc*3+1,9),GREATEST(9-nivel_cc*3,0));
        CGMayoriza_CC( pNuciaAD, pAnoAD,    pMesAD,    pCta,
                       CCqMayo,  pMnominal, pMdolares, pTipo_linea, pmsg_error);
        if pmsg_error is not null then
           raise error_proceso;
        end if;
        nivel_cc := nivel_cc + 1;
     END LOOP;
   END IF;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGprocesa_cc');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGprocesa_cc');
END CGprocesa_cc;