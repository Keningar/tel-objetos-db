create or replace function            PL_F_CALCULA_DIAS_TRABAJADOS ( Pd_FechaIngreso IN DATE,
                                                          Pd_FechaEgreso  IN DATE DEFAULT SYSDATE,
                                                          Pn_Anio         IN NUMBER ) return NUMBER is
  Ln_NumeroDias      NUMBER := 0;
  Ld_FechaIniCalculo DATE := TO_DATE('01/01/'||Pn_Anio,'DD/MM/YYYY');
  Ld_FechaFinCalculo DATE := TO_DATE('31/12/'||Pn_Anio,'DD/MM/YYYY');
  --
begin
  
  IF Pd_FechaIngreso > Ld_FechaIniCalculo THEN 
    Ld_FechaIniCalculo := Pd_FechaIngreso; --si es menor la fecha de ingreso, se calcula en base a esa fecha
  END IF;
  
  IF NVL(Pd_FechaEgreso,SYSDATE) < Ld_FechaFinCalculo THEN
    Ld_FechaFinCalculo := Pd_FechaEgreso;
  END IF;
  
  -- numero de meses se multiplica por 30 dias de cada mes
  Ln_NumeroDias := mod (floor (months_between (Ld_FechaFinCalculo, Ld_FechaIniCalculo)), 12) * 30;

  -- Se suma numero de dias 
  Ln_NumeroDias := Ln_NumeroDias + (Ld_FechaFinCalculo - add_months(Ld_FechaIniCalculo, FLOOR (MONTHS_BETWEEN (Ld_FechaFinCalculo, Ld_FechaIniCalculo))));

  return(Ln_NumeroDias);
end PL_F_CALCULA_DIAS_TRABAJADOS;