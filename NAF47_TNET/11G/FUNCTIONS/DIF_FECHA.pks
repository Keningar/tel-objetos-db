create or replace FUNCTION            DIF_FECHA
 (F1 DATE
 ,F2 DATE
 ,ANIOS IN OUT NUMBER
 ,MESES IN OUT NUMBER
 ,DIAS IN OUT NUMBER
 )
 RETURN CHAR
 IS
-- PL/SQL Specification
vf1    DATE := f1;
  vf2    DATE := f2;
  vf_aux  DATE;
  vdescri  VARCHAR2(30);

-- PL/SQL Block
BEGIN
  IF vf1 < vf2 THEN
     vf_aux := vf2;
     vf2    := vf1;
     vf1    := vf_aux;
  END IF;
  anios  := TO_NUMBER(TO_CHAR(vf1,'YYYY')) - TO_NUMBER(TO_CHAR(vf2,'YYYY'));
  meses  := TO_NUMBER(TO_CHAR(vf1,'MM')) - TO_NUMBER(TO_CHAR(vf2,'MM'));
  IF meses < 0 THEN
    -- el mes de fecha1 es menor al mes de fecha2,
    -- ejemplo   fecha1     fecha2
    --           5-ene-98   5-12-97
    anios := anios - 1;    -- restar un a?o
    meses := meses + 12;  -- -11 + 12 ==> 1
  END IF;
  dias  := TO_CHAR(vf1,'DD') - TO_CHAR(vf2,'DD');
  IF dias < 0 THEN
    meses  := meses - 1;
    vf_aux := LAST_DAY(vf2);  -- ultima dia del mes
    dias   := TO_NUMBER(TO_CHAR(vf_aux,'DD')) - TO_NUMBER(TO_CHAR(vf2,'DD'));
    dias   := dias + TO_NUMBER(TO_CHAR(vf1,'DD'));
  END IF;
  IF anios = 1 THEN
    vdescri := '1 A?o,';
  ELSIF anios > 1 THEN
    vdescri := TO_CHAR(anios)||' A?os,';
  END IF;
  IF meses = 1 THEN
    vdescri := vdescri ||' 1 mes,';
  ELSIF meses > 1 THEN
    vdescri := vdescri ||TO_CHAR(meses)||' meses,';
  END IF;
  IF dias = 1 THEN
     vdescri := vdescri ||' 1 dia';
  ELSIF dias > 1 THEN
     vdescri := vdescri ||TO_CHAR(dias)||' dias';
  END IF;
  RETURN ( RTRIM(vdescri,',') );
END;