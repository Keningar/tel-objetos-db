create or replace procedure            CCCIERRE_PERIODICO(Pv_cia       IN  Varchar2,
                                               Pv_centro    IN  Varchar2,
                                               Pn_anio      IN  Number,
                                               Pn_mes       IN  Number,
                                               Pv_semana    IN  Varchar2,
                                               Pv_indicador IN  Varchar2,
                                               Pv_error     OUT Varchar2) is
  --
  CURSOR c_fecha_proce IS
    SELECT dia_proceso_cxc
      FROM arincd
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro;
  --
  CURSOR c_ultimo_dia IS
    SELECT fecha2
      FROM calendario
     WHERE no_cia    = Pv_cia
       AND ano       = Pn_anio
       AND semana    = Pv_semana
       AND indicador = Pv_indicador;
  --

/**** Verifica pendientes ***/

  CURSOR c_doc_pendientes IS
    SELECT no_liq, no_agente
      FROM arccmd
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND estado = 'P'
       AND ((ano is null OR semana is null) OR
            (ano = Pn_anio AND mes = Pn_mes AND semana <= Pv_semana));

  CURSOR c_doc_pend_cont IS
    SELECT 'x'
      FROM arccdc
     WHERE no_cia  = Pv_cia
       AND centro  = Pv_centro
       AND ind_con = 'P';


/**** Cambio de periodo ****/

  -- Este procedimiento actualiza la fecha en proceso para la
  -- compania a cerrar.

Cursor C_Saldos Is
 SELECT ms.no_cia,  ms.grupo,  ms.no_cliente, ms.moneda,  ms.saldo_actual
   FROM arccms ms, arccmc mc
  WHERE ms.no_cia     = Pv_cia
    AND mc.no_cia     = ms.no_cia
    AND mc.grupo      = ms.grupo
    AND mc.no_cliente = ms.no_cliente
    AND mc.centro     = Pv_centro;

Cursor C_Fecha Is
  SELECT fecha2 + 1
    FROM calendario
   WHERE no_cia    = Pv_cia
     AND ano       = Pn_anio
     AND semana    = Pv_semana
     AND indicador = Pv_indicador;

  --
  vnuevo_mes          arincd.mes_proce_cxc%type;
  vnuevo_ano          arincd.ano_proce_cxc%type;
  vnueva_sem          arincd.semana_proce_cxc%type;
  vnuevo_ind          arincd.indicador_sem_cxc%type;
  --
  vfecha              calendario.fecha1%type;

  vencontrado         boolean;
  vdummy              varchar2(2);
  vno_liq             arccmd.no_liq%type;
  vvendedor           arccmd.no_agente%type;

  vultimo_dia_semana  DATE;
  vfecha_cxc          DATE;

  Lv_error            Varchar2(500);
  error_proceso       Exception;

BEGIN

  /*verifica_pendientes;*/

  -- Revisa que no existan documentos pendientes de actualizar
  OPEN  c_doc_pendientes;
  FETCH c_doc_pendientes INTO vno_liq, vvendedor;
  vencontrado := c_doc_pendientes%found;
  CLOSE c_doc_pendientes;

  IF vencontrado THEN
    IF vno_liq is not null THEN
      Lv_error := 'Existen movimientos de la liquidacion '||vno_liq||', vendedor: '||
                vvendedor||', pendientes de actualizar.';
      raise error_proceso;
    ELSE
      Lv_error := 'Existen documentos pendientes de actualizar.';
      raise error_proceso;
    END IF;
    RAISE error_proceso;
  END IF;
  --
  -- Revisa que no existan documentos pendientes de generar el asiento
  OPEN  c_doc_pend_cont;
  FETCH c_doc_pend_cont INTO vdummy;
  vencontrado := c_doc_pend_cont%found;
  CLOSE c_doc_pend_cont;

  IF vencontrado THEN
    Lv_error := 'No se ha generado al Asiento a Contabilidad.';
    raise error_proceso;
  END IF;

  -- Adelante el dia el proceso cuando este corresponde al ultimo dia del periodo
  OPEN  c_fecha_proce;
  FETCH c_fecha_proce INTO vfecha_cxc;
  IF c_fecha_proce%NOTFOUND THEN
    CLOSE c_fecha_proce;
    Lv_error := 'No se ha definido la fecha en proceso de CxC';
    RAISE error_proceso;
  END IF;
  CLOSE c_fecha_proce;

  OPEN  c_ultimo_dia;
  FETCH c_ultimo_dia INTO vultimo_dia_semana;
  IF c_ultimo_dia%NOTFOUND THEN
    CLOSE c_ultimo_dia;
    Lv_error := 'No se ha definido el periodo en proceso';
    RAISE error_proceso;
  END IF;
  CLOSE c_ultimo_dia;

  IF vfecha_cxc = vultimo_dia_semana THEN
	  UPDATE arincd
	     SET dia_proceso_cxc = dia_proceso_cxc + 1
	   WHERE no_Cia = Pv_cia
	     AND centro = Pv_centro;

  END IF;

  --
  -- Actualiza el Maestro de Documentos
  UPDATE arccmd
     SET estado  = 'A'
   WHERE no_cia  = Pv_cia
     AND centro  = Pv_centro
     AND estado  not in ('P', 'A');

   -- Actualiza las fecha en proceso
   /*fecha_proc;*/

  Open C_Fecha;
  Fetch C_Fecha into vFecha;
  If C_Fecha%notfound then
   Close C_Fecha;
    Lv_error := 'No existe registro en calendario para el a?o: '||Pn_anio||' Semana: '||Pv_semana||' Indicador: '||Pv_indicador;
    raise error_proceso;
  else
   Close C_Fecha;
  end if;

  Begin
  SELECT ano, mes, semana, indicador
    INTO vnuevo_ano, vnuevo_mes, vnueva_sem, vnuevo_ind
    FROM calendario
   WHERE no_cia    = Pv_cia
     AND trunc(vfecha) >= trunc(fecha1)
     AND trunc(vfecha) <= trunc(fecha2);
  Exception
  When no_data_found Then
   Lv_error := 'No se encontro registro en calendario, para fecha: '||vfecha;
   raise error_proceso;
  When Others Then
   Lv_error := 'Error en calendario '||sqlerrm;
   raise error_proceso;
  End;

  UPDATE arincd
     SET ano_proce_cxc     = vnuevo_ano,
         mes_proce_cxc     = vnuevo_mes,
         semana_proce_cxc  = vnueva_sem,
         indicador_sem_cxc = vnuevo_ind,
         dia_proceso_cxc   = vfecha
   WHERE no_cia = Pv_cia
     AND centro = Pv_centro;

  --
  -- si cambia de mes, registra el historico de saldos.
  IF (vnuevo_ano*100)+vnuevo_mes > (Pn_anio*100)+ Pn_mes THEN
    --
   For i in C_Saldos Loop

    Update Arccmc
    Set    saldo_ante = i.saldo_actual
    Where  no_cia     = Pv_cia
    And    grupo      = i.grupo
    And    no_cliente = i.no_cliente;

    -- Inserta en Composicion de Saldos la informacion de los clientes que pertenecen al
    -- centro que se esta cerrando.
    INSERT INTO arccsa (NO_CIA,  GRUPO,   NO_CLIENTE,
                        ANO,     MES,     MONEDA,  SALDO)
                Values  (Pv_cia, i.grupo, i.no_cliente, Pn_anio, Pn_mes, i.moneda, i.saldo_actual);

   End Loop;

    --- Debe guardar en el historico de saldos mensuales por subcliente

    INSERT INTO arccsa_subcliente (NO_CIA,  GRUPO,   NO_CLIENTE, SUBCLIENTE,
                        ANO,     MES,     MONEDA,  SALDO)
       SELECT ms.no_cia,  ms.grupo,  ms.no_cliente, ms.subcliente,
              Pn_anio, Pn_mes, ms.moneda,  ms.saldo_actual
         FROM arccms_subcliente ms, arcclocales_clientes mc
        WHERE ms.no_cia         = Pv_cia
          AND mc.no_cia         = ms.no_cia
          AND mc.grupo          = ms.grupo
          AND mc.no_cliente     = ms.no_cliente
          AND mc.no_sub_cliente = ms.subcliente
          AND mc.centro         = Pv_centro;

  END IF;

Exception
	When Error_proceso Then
	 Pv_error := Lv_error;
	 return;
	When Others Then
	 Pv_error := 'Error en CCCIERRE_PERIODICO: '||sqlerrm;
	 return;
end CCCIERRE_PERIODICO;