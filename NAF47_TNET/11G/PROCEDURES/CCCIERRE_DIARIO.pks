create or replace procedure            CCCIERRE_DIARIO(Pv_cia                IN  Varchar2,
                                            Pv_centro             IN  Varchar2,
                                            Pd_fecha_cierre       IN  Date,
                                            Pd_ultimo_dia_semana  OUT Date,
                                            Pv_error              OUT Varchar2) is

  /*********valida que no existan facturas al contado con saldos pendientes*/
 /* Cursor c_valida_fact_contado is
    select count(no_docu)cuantas
     from arccmd  a,arfafe c , arccmc e, arcctd f
    where a.no_cia =Pv_cia
      and  a.centro= Pv_centro
      and  a.fecha= Pd_fecha_cierre
      and  a.no_cia = c.no_Cia
      and  a.no_docu = c.no_factu
      and  c.codigo_plazo=(select codigo from arccplazos where no_cia=a.no_cia and plazo=0 and nvl(estado,'I')='A')
      and  nvl(a.saldo,0)>0
      and  nvl(c.ind_anu_dev, 'F')!='A'
      and  a.no_cia = e.no_cia
      and  a.grupo = e.grupo
      and  a.no_cliente =e.no_cliente
      and f.no_cia=a.no_cia
      and f.tipo=a.tipo_doc;*/

  /******************valida que no existan cheques devueltos pendientes**************/
  cursor c_valida_ch_devueltos is
   select count(*)cuantos
     from arccck
    where no_cia=Pv_cia
     and centro=Pv_centro
     and trunc(fec_digitado)= Pd_fecha_cierre
     and nvl(estado,' ')='P';

  -- valida que no se intente cerrar un dia que corresponde al siguiente periodo (semana/mes).
  cursor dia_proc IS
    select dia_proceso_cxc, ano_proce_cxc, semana_proce_cxc,
           indicador_sem_cxc
    from arincd
    where no_cia = Pv_cia
      and centro = Pv_centro;
  --
  Cursor Sem_Proc (asem number, psem number, pid number ) IS
     Select fecha2
       from calendario
      where no_cia    = Pv_cia and
            ano       = asem        and
            semana    = psem        and
            indicador = pid;

  Cursor C_Valida_deposito Is
   select b.descripcion, a.no_docu
   from   arccfpagos a, arccforma_pago b, arccmd c
   where  a.no_cia = Pv_cia
   and    c.centro = Pv_centro
   and    a.no_docu_deposito is null
   and    nvl(b.ind_deposito,'N') = 'S'
   and    c.fecha                = Pd_fecha_cierre
   and    a.no_cia = b.no_cia
   and    a.id_forma_pago = b.forma_pago
   and    a.no_cia = c.no_cia
   and    a.no_docu = c.no_docu;

  --
  cursor c_dia_proc IS
    select dia_proceso_cxc, ano_proce_cxc, indicador_sem_cxc, semana_proce_cxc
    from arincd
    where no_cia = Pv_cia
      and centro = Pv_centro;


  CURSOR c_ultimo_dia(vano NUMBER,vindicador VARCHAR, vsemana VARCHAR) IS
    SELECT fecha2
    FROM calendario
    WHERE no_cia    = Pv_cia
      AND ano       = vano
      AND indicador = vindicador
      AND semana    = vsemana;

  vf_ref                 DATE;
  vultimo_dia_semana     DATE;
  vano                   arincd.ano_proce_cxc%TYPE;
  vindicador             arincd.indicador_sem_cxc%TYPE;
  vsemana_cxc            arincd.semana_proce_cxc%TYPE;

 /* lc_valida_fact_contado c_valida_fact_contado%rowtype;*/ -- comentario la validacion al contado ANR  27/01/2011
  lc_valida_ch_devueltos c_valida_ch_devueltos%rowtype;
  --
  vdia_proc              arincd.dia_proceso_cxc%type;
  vano_proc              arincd.ano_proce_cxc%type;
  vsem_proc              arincd.semana_proce_cxc%type;
  vid_sem                arincd.indicador_sem_cxc%type;
  vfecha                 calendario.fecha2%type;


   Lv_desc_forma_pago    Arccforma_pago.descripcion%type;
   Lv_docu               Arccmd.no_docu%type;


   Lv_error              Varchar2(500);
   Error_proceso         Exception;

/**** El proceso de cierre diario de cuentas por cobrar PCXC205 se lo pasa a un
      proceso de base de datos para unificar este proceso al ser ejecutado
      en cualquier otro modulo ANR 27/01/2011 ****/

Begin

 Open dia_proc;
 Fetch dia_proc into vdia_proc, vano_proc, vsem_proc, vid_sem;
 Close dia_proc;

 Open Sem_Proc(vano_proc, vsem_proc, vid_sem);
 Fetch Sem_Proc into vfecha;
 Close Sem_Proc;


  /***
  El dia de ayer realice el cierre diario del centro de distribucion Guayaquil
  y me permitio cerrar el dia habiendo depositos pendientes de realizar, esto deberia ser validado ya que por seguridad no se deberia permitir  realizar el cierre sin depositar todo lo que se recibio, ademas al siguiente dia se mezclara los cobros recibidos en un dia y otro ya que la pantalla de Depositos de cobros no  permite el ingreso de fecha para consultar sino que muestra como fecha la fecha del dia de proceso, sin embargo la informacion del detalle no corresponde solo a esa fecha sino lo que esta pendiente de deposito aunque no pertenezca a esa fecha, eso puede causar confusion.
  Realizado por ANR 16/12/2009  ***/

  Open C_Valida_deposito;
  Fetch C_Valida_deposito into Lv_desc_forma_pago, Lv_docu;
  If C_Valida_deposito%notfound Then
    Close C_Valida_deposito;
  else
    Close C_Valida_deposito;
    Lv_error := 'Para hacer el cierre, es obligatorio hacer el deposito de: '||Lv_desc_forma_pago||' , que esta en el cobro: '||Lv_docu;
    raise error_proceso;
  end if;

  /********* valida que no existan facturas al contado con saldos pendientes*/
 /* open c_valida_fact_contado;
  fetch c_valida_fact_contado into lc_valida_fact_contado;
  close c_valida_fact_contado;

  if nvl(lc_valida_fact_contado.cuantas,0)>0 then
     Lv_error := 'Existe(n) '||nvl(lc_valida_fact_contado.cuantas,0)||' factura(s) al contado con saldo';
     raise error_proceso;
  end if;*/

  /***********valida que no existan cheques devueltos pendientes*****/
  open c_valida_ch_devueltos;
  fetch c_valida_ch_devueltos into lc_valida_ch_devueltos;
  close c_valida_ch_devueltos;

  if nvl(lc_valida_ch_devueltos.cuantos,0)>0 then
     Lv_error := 'Existe(n) '||nvl(lc_valida_ch_devueltos.cuantos,0)||' cheque(s) devuelto(s) en estado pendiente';
     raise error_proceso;
  end if;

  /**** Procede a hacer el cierre diario de cxc ****/


  OPEN c_dia_proc;
  FETCH c_dia_proc INTO vf_ref, vano, vindicador, vsemana_cxc;
  CLOSE c_dia_proc;

  OPEN  c_ultimo_dia(vano,vindicador,vsemana_cxc);
  FETCH c_ultimo_dia INTO vultimo_dia_semana;
  CLOSE c_ultimo_dia;

  --
  CCESTADOS_VENCIDOS(Pv_cia, Pv_centro, vf_ref, Lv_error);
  IF Lv_error IS NOT NULL THEN
     raise error_proceso;
  END IF;

  --
  UPDATE ARCCMD
    SET  estado  = 'M'
    WHERE no_cia  = Pv_cia
      AND centro  = Pv_centro
      AND estado  = 'D';

  IF Pd_fecha_cierre < vultimo_dia_semana THEN

    UPDATE arincd
      SET dia_proceso_cxc = dia_proceso_cxc + 1
      WHERE no_Cia = Pv_cia
        AND centro = Pv_centro;

  END IF;

  Pd_ultimo_dia_semana := vultimo_dia_semana;

Exception
  When Error_proceso Then
   Pv_error := Lv_error;
   return;
  When Others Then
   Pv_error := 'Error en CCCIERRE_DIARIO: '||sqlerrm;
   return;
end CCCIERRE_DIARIO;