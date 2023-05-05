create or replace function            PVCANCELA_TARJETA(Pv_cia          VARCHAR2,
                                             Pv_centro       VARCHAR2,
                                             Pv_docu         VARCHAR2,
                                             Pv_tipo         VARCHAR2,
                                             Pv_tipo_cancela VARCHAR2,
                                             Pv_error        OUT VARCHAR2) return number is

cursor c_monto is
  select no_cliente,m_original,tipo_doc
  from arccmd
  where no_cia = pv_cia
  and no_docu  = Pv_docu
  and tipo_doc = Pv_tipo;

cursor c_refe(Pv_tipo varchar2,pcliente varchar2) is
  select no_docu_refe
  from   pvcuentas_por_cobrar
  where  no_cia     = pv_cia
  and    centro     = Pv_centro
  and    tipo_doc   = Pv_tipo
  and    no_cliente = pcliente
  and    no_docu    = Pv_docu;

cursor c_banco is
  select b.banco
  from   arccmd a, pvbancos b
  where  a.no_cia = b.no_cia
  and    a.no_cia = pv_cia
  and    a.no_docu = Pv_docu
  and    a.no_cia = b.no_cia
  and    a.grupo=b.grupo_cliente
  and    a.no_cliente = b.no_cliente;

cursor c_resta_comision (pbanco varchar2) is
  select resta_comision
  from   argetb
  where  banco = pbanco;


cursor c_cancela is
  select decode(nvl(cobro_comision,'N'),'S','C',decode(nvl(tipo_retencion,'N'),'S','R',decode(nvl(ind_cobro,'N'),'S','F','x')))
  from
  (select tipo,IND_COBRO, TIPO_RETENCION,cobro_comision
   from   arcctd
   where  no_cia = Pv_cia
   and    nvl(ind_tarjeta_credito,'N')= 'S'
  UNION ALL
   select tipo,IND_COBRO, TIPO_RETENCION,cobro_comision
   from   arcctd
   where  no_cia = Pv_cia
   and    nvl(tipo_retencion,'N')= 'S')
   where  tipo = Pv_tipo_cancela;

cursor c_porc (prefe varchar2,pcliente varchar2)is
  select monto,porc_retencion,porc_tarjeta
  from   pvforma_pago
  where  no_cia = pv_cia
  and    no_transa_caja  = prefe
  and    no_cliente_banco = pcliente;

cursor c_imp is
  select porcentaje
  from   arcgimp
  where  no_cia = pv_cia
  and    ind_retencion = 'N'
  and    afecta in ('V','A')
  and    ind_aplica_servicios = 'S'
  and    ind_vigente = 'S';

  vcliente      varchar2(7);
  vmonto        number:=0;
  vtipo         varchar2(3);
  vmont_orig    number:=0;
  vporc_ret     number:=0;
  vporc_com     number:=0;
  vcancela      varchar2(1);
  vdocu         varchar2(12);
  vret          number:=0;
  vcom          number:=0;
  vresult       number:=0;
  vbanco        varchar2(3);
  vrcom         varchar2(1);
  vimp          number:=0;
  vbase         number:=0;

begin

  open c_monto;
  fetch c_monto into vcliente,vmonto,vtipo;
  close c_monto;

  open c_refe(vtipo,vcliente);
  fetch c_refe into vdocu;
  close c_Refe;

  open c_porc(vdocu,vcliente);
  fetch c_porc into vmont_orig,vporc_ret,vporc_com;
  close c_porc;

  open c_cancela;
  fetch c_cancela into vcancela;
  close c_cancela;

  open c_banco;
  fetch c_banco into vbanco;
  close c_banco;

  open c_resta_comision(vbanco);
  fetch c_resta_comision  into vrcom;
  close c_resta_comision;

  open c_imp;
  fetch c_imp into vimp;
  close c_imp;

  vimp:=(vimp/100)+1;


  if nvl(vrcom,'N') = 'S' then
      vcom:=trunc(round((nvl(vmonto,0)*nvl(vporc_com,0))/100,3),2);
      vbase:=trunc(round((nvl(vmonto,0)/vimp ),3),2)-vcom;
     vret:=TRUNC(ROUND((nvl(vbase,0)*nvl(vporc_ret,0))/100,3),2);
  else
      vcom:=round((nvl(vmonto,0)*nvl(vporc_com,0))/100,2);
      vbase:=round((nvl(vmonto,0)/vimp ),2);
        vret:=ROUND((nvl(vbase,0)*nvl(vporc_ret,0))/100,2);
  end if;


  if vcancela = 'F' then
      vresult:=nvl(vmonto,0)-nvl(vret,0)-nvl(vcom,0);
  elsif vcancela = 'C' then
      vresult:=nvl(vcom,0);
  elsif vcancela = 'R' then
      vresult:=  nvl(vret,0);
  end if;

  return(ROUND(vresult,2));

end PVCANCELA_TARJETA;