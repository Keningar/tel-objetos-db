create or replace FUNCTION            PLDIFERENCIA_FECHAS(
  pF1	   date,
  pF2	   date,
  pAnios	 in out number,
  pMeses	 in out number,
  pDias	 in out number
) RETURN CHAR IS

  vDif_meses number(5,2);
  vF1	       date := pF1;
  vF2			 	 date := pF2;
  vF_aux	   date;
  vDescri	   varchar2(30);

BEGIN
  IF vF1 < vF2 THEN
     vF_aux := vF2;
     vF2    := vF1;
     vF1    := vF_aux;
  END IF;

  vDif_meses := abs(months_between(vf1,vf2));
  pAnios     := trunc(vDif_meses/12);
  pMeses     := trunc(vDif_meses) - (pAnios*12);
  pDias      := to_char(vF1,'DD') - to_char(vF2,'DD');

  IF pDias < 0 THEN
    vF_aux := LAST_DAY(vf2);	-- ultima dia del mes
    pDias  := to_number(to_char(vf_aux,'DD')) - to_number(to_char(vf2,'DD'));
    pDias  := pDias + to_number(to_char(vf1,'DD'));
  END IF;

  IF pAnios = 1 THEN
    vDescri := '1 A?o,';
  ELSIF pAnios > 1 THEN
    vDescri := to_char(pAnios)||' A?os,';
  END IF;
  IF pMeses = 1 THEN
    vDescri := vDescri ||' 1 mes,';
  ELSIF pMeses > 1 THEN
    vDescri := vDescri ||to_char(pMeses)||' meses,';
  END IF;
  IF pDias = 1 THEN
     vDescri := vDescri ||' 1 dia';
  ELSIF pDias > 1 THEN
     vDescri := vDescri ||to_char(pDias)||' dias';
  END IF;
  RETURN ( RTRIM(vDescri,',') );
END;