create or replace PROCEDURE            cpreprocesa_saldos_cxp(Pv_Cia   IN VARCHAR2,
                                                   Pv_prove IN VARCHAR2,
                                                   Pv_Error OUT VARCHAR2) IS
  /**** Proceso que permite reprocesar saldos de cuentas por pagar ARCPSA, ARCPMS, ARCPMP
  Realizado por ANR 20/11/2009 ***/

  --- Obtengo la fecha de inicio de transacciones por cada compania y proveedor
  --- Independiente de cualquier estado ANR 30/11/2009

  CURSOR C_Fecha_Inicio_Prove IS
    SELECT MIN(last_day(fecha)) inicio_fecha--,
--    MAX(last_day(fecha)) inicio_fecha ----'31/12/2010' fin_fecha
      FROM Arcpmd
     WHERE no_cia = Pv_cia; --- se debe escoger lo minimo y maximo por compania

  CURSOR C_Fecha_Fin_Prove IS
    SELECT (TO_DATE('01/' || a.mes_proc || '/' || a.ano_proc, 'dd/mm/yyyy') - 1) fecha
      FROM arcpct a
     WHERE a.no_cia = Pv_cia; --- se debe escoger lo minimo y maximo por compania

  /* Los saldos no pueden ser con los movimientos porque hay meses que el proveedor
     no tiene movimientos y para estos casos no se va a generar los saldos ANR 02-02-2011 
  select min(last_day(fecha)) inicio_fecha, max(last_day(fecha)) fin_fecha
  From   Arcpmd
  Where  no_cia   = Pv_cia
  And    no_prove = Pv_prove;*/

  CURSOR C_Movimientos(Ln_Mes  NUMBER,
                       Ln_Anio NUMBER) IS
    SELECT NVL(SUM(DECODE(b.tipo_mov, 'D', a.monto)), 0) monto_debitos,
           NVL(SUM(DECODE(b.tipo_mov, 'C', a.monto)), 0) monto_creditos
      FROM arcpmd a,
           arcptd b
     WHERE a.no_cia = Pv_cia
       AND a.ind_act in  ('D','M','A')
       AND NVL(a.anulado, 'N') = 'N'
       AND a.no_prove = Pv_prove
       AND TO_NUMBER(TO_CHAR(fecha, 'MM')) = Ln_Mes
       AND TO_NUMBER(TO_CHAR(fecha, 'YYYY')) = Ln_Anio
       AND a.no_cia = b.no_cia
       AND a.tipo_doc = b.tipo_doc;

  CURSOR C_Arcpms IS
    SELECT 'X'
      FROM arcpms
     WHERE no_cia = Pv_cia
       AND no_prove = Pv_prove;

  Ld_Fecha_inicio    DATE;
  Ld_Fecha_fin       DATE;
  Ld_Fecha_siguiente DATE;

  Ln_monto_debitos  NUMBER := 0;
  Ln_monto_creditos NUMBER := 0;

  Ln_saldo_anterior NUMBER := 0;
  Ln_saldo          NUMBER := 0;

  Ln_contador NUMBER := 0;

  Lv_Error VARCHAR2(300);
  Error_proceso EXCEPTION;

  Lv_dummy VARCHAR2(1);

BEGIN

  OPEN C_Fecha_Inicio_Prove;
  FETCH C_Fecha_Inicio_Prove INTO Ld_Fecha_inicio;--,Ld_Fecha_fin;
  IF C_Fecha_Inicio_Prove%NOTFOUND THEN
    CLOSE C_Fecha_Inicio_Prove;
  ELSE
    CLOSE C_Fecha_Inicio_Prove;
  END IF;


  OPEN C_Fecha_Fin_Prove;
  FETCH C_Fecha_Fin_Prove INTO Ld_Fecha_fin;--
  IF C_Fecha_Fin_Prove%NOTFOUND THEN
    CLOSE C_Fecha_Fin_Prove;
  ELSE
    CLOSE C_Fecha_Fin_Prove;
  END IF;

  --- Elimino los registros de saldos mensuales por proveedor
  DELETE Arcpsa
   WHERE no_cia = Pv_cia
     AND no_prove = Pv_prove;

  LOOP
  
    Ld_Fecha_siguiente := add_months(Ld_Fecha_inicio, Ln_contador);
  
    OPEN C_Movimientos(TO_NUMBER(TO_CHAR(Ld_Fecha_siguiente, 'MM')), --
                       TO_NUMBER(TO_CHAR(Ld_Fecha_siguiente, 'YYYY')));
    FETCH C_Movimientos
      INTO Ln_monto_debitos,
           Ln_monto_creditos;
    IF C_Movimientos%NOTFOUND THEN
      CLOSE C_Movimientos;
      Ln_monto_debitos  := 0;
      Ln_monto_creditos := 0;
    ELSE
      CLOSE C_Movimientos;
    END IF;
  
    --- Voy cargando el saldo inicial y el saldo por cada mes
  
    Ln_saldo_anterior := Ln_saldo;
  
    Ln_saldo := Ln_saldo_anterior + Ln_monto_creditos - Ln_monto_debitos;
    
    if Ld_Fecha_siguiente <= Ld_Fecha_fin then
      BEGIN
        INSERT INTO ARCPSA
          (no_cia,
           no_prove,
           ano,
           mes,
           moneda,
           saldo,
           debitos,
           creditos,
           saldo_ant)
        VALUES
          (Pv_cia,
           Pv_prove,
           TO_NUMBER(TO_CHAR(Ld_fecha_siguiente, 'YYYY')),
           TO_NUMBER(TO_CHAR(Ld_fecha_siguiente, 'MM')),
           'P',
           Ln_saldo,
           Ln_monto_debitos,
           Ln_monto_creditos,
           Ln_saldo_anterior);
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Error := 'Error al crear registros en ARCPSA, para saldos mensuales. Proveedor: ' || Pv_prove || ' ' || SQLERRM;
          RAISE Error_proceso;
      END;
    
    End If;
    
    Ln_contador := Ln_contador + 1;
  
    EXIT WHEN Ld_Fecha_siguiente > Ld_Fecha_fin;
  END LOOP;

  -- corrige saldo anterior en tabla de proveedores
  update arcpmp a
     set a.sal_ant = Ln_saldo_anterior
   where a.no_prove = Pv_prove
     and no_cia = Pv_cia;

  --- Actualizo el saldo final del proveedor
  OPEN C_Arcpms;
  FETCH C_Arcpms
    INTO Lv_dummy;
   IF C_Arcpms%NOTFOUND THEN
    CLOSE C_Arcpms;
  
    INSERT INTO arcpms
      (no_cia,
       no_prove,
       moneda,
       saldo_actual)
    VALUES
      (Pv_cia,
       Pv_prove,
       'P',
       Ln_saldo);
  
  ELSE
    CLOSE C_Arcpms;
  
    UPDATE Arcpms
       SET saldo_actual = Ln_saldo
     WHERE no_cia = Pv_cia
       AND no_prove = Pv_prove;
  
  END IF;

  --- Crear registro para proveedores que no tienen movimientos 

  /*insert into arcpms (no_cia, no_prove, moneda, saldo_actual)
          select no_cia, no_prove, 'P',0 from arcpmp where no_cia =  '01' and no_prove not in
          (select no_prove from arcpms where no_cia = '01')
          
  insert into  arcpsa (no_cia, no_prove, ano, mes, moneda, saldo, debitos, creditos, saldo_ant)
        select no_cia, no_prove, 2010, 12, 'P', 0, 0, 0, 0 from arcpmp where no_cia =  '01' and no_prove not in          
          (select no_prove from arcpsa where ano = 2010 and mes = 12 and 
          no_cia = '01')
          
          */

EXCEPTION
  WHEN Error_proceso THEN
    Pv_Error := Lv_Error;
  WHEN OTHERS THEN
    Pv_Error := 'Error en recalculo de saldos cxp ' || SQLERRM;
END cpreprocesa_saldos_cxp;