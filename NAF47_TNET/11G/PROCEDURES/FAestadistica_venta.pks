create or replace PROCEDURE            FAestadistica_venta(
  no_cia_p     in     varchar2,
  centro_p     in     varchar2,
  clase_p      in     varchar2,
  categoria_p  in     varchar2,
  no_arti_p    in     varchar2,
  grupo_p      in     varchar2,
  cliente_p    in     varchar2,
  vendedor_p   in     varchar2,
  ruta_p       in     varchar2, -- ruta
  sem_p        in     number,   -- semana
  ind_p        in     number,   -- indicador de semana
  ano_p        in     number,   -- a?o
  mes_p        in     number,   -- mes
  tipo_mov_p   in     varchar2, -- tipo de mov (VEN = Venta, DEV=Devolucion, OFE = Oferta)
  c_unit_p     in     number,   -- Costo unitario del cada articulo (en NOMINAL)
  costo2_p     in     number,   -- Costo 2
  cant_p       in     number,   -- Cantidad de articulos
  mont_p       in     number,   -- Monto de venta por los articulos
  desc_p       in     number,   -- Descuento de la venta de los articulos
  impu_p       in     number,       -- Impuestos (excluidos) por la venta de los articulos
  impu_inc_p   in     number,       -- Impuestos (incluidos) por la venta de los articulos
  moneda_p     in     varchar2,     -- moneda de la factura
  t_cambio_p   in     number,       -- tipo de cambio de la factura
  Pv_doctor    in     varchar2  default null, ---- POS
  msg_error    in out varchar2
) is
  -- --
  -- Realiza las modificaciones para hacer las estadisticas de ventas.
  --
  -- **
  -- NOTAS IMPORTANTES:
  --    1. Las REVERSIONES son denotadas con MONTOS NEGATIVOS
  --    2. Asume que el costo unitario esta expresado en NOMINAL (moneda P)
  --    3. El que llame a este procedimiento debe haber inicializado el PAQUETE MONEDA,
  --       pues se utiliza la funcion redondeo
  -- **
  -- UTILIZADO POR:
  --    .FAactualiza
  --    .FAanula_lineas
  --
  vcant             number := 0;
  vcosto_nomi       number := 0;
  vcosto2_nomi      number := 0;
  vtipo_cambio      number;
  --
  vcant_venta        number := 0;   -- venta
  vcosto_venta       number := 0;
  vmonto_venta       number := 0;
  vcosto2_venta      number := 0;
  vcant_ofe          number := 0;   -- ofertas
  vcosto_ofe         number := 0;
  vcant_devol        number := 0;   -- devoluciones
  vcosto2_ofe        number := 0;
  vmonto_devol       number := 0;
  vcosto_devol       number := 0;
  vcosto2_devol      number := 0;
  --
  vcosto_venta_nomi  number := 0;
  vmonto_venta_nomi  number := 0;
  vcosto2_venta_nomi number := 0;
  vcosto_ofe_nomi    number := 0;
  vmonto_devol_nomi  number := 0;
  vcosto2_ofe_nomi   number := 0;
  vcosto_devol_nomi  number := 0;
  vcosto2_devol_nomi number := 0;
  vdescuento_nomi    number := 0;
  vimpuesto_nomi     number := 0;
  vimpuesto_inc_nomi number := 0;

  --
  vcosto_venta_dol   number := 0;
  vmonto_venta_dol   number := 0;
  vcosto2_venta_dol   number := 0;
  vcosto_ofe_dol     number := 0;
  vmonto_devol_dol   number := 0;
  vcosto2_ofe_dol  number := 0;
  vcosto_devol_dol   number := 0;
  vcosto2_devol_dol  number := 0;
  vdescuento_dol     number := 0;
  vimpuesto_dol      number := 0;
  vimpuesto_inc_dol  number := 0;

  --
  error_proceso    EXCEPTION;
BEGIN
  vtipo_cambio := nvl(t_cambio_p,0);
  --
  vcant        := nvl(cant_p,0);
  vcosto_nomi  := moneda.redondeo(nvl(cant_p,0) * nvl(c_unit_p,0), 'P');
  vcosto2_nomi := moneda.redondeo(nvl(cant_p,0) * nvl(costo2_p,0), 'P');

  --
  if tipo_mov_p = 'VEN' then
     vcant_venta  := nvl(cant_p,0);
     vcosto_venta := vcosto_nomi;
     vcosto2_venta := vcosto2_nomi;
     vmonto_venta := nvl(mont_p,0);
  elsif tipo_mov_p = 'OFE' then
     vcant_ofe    := nvl(cant_p,0);
     vcosto_ofe   := vcosto_nomi;
     vcosto2_ofe  := vcosto2_nomi;
  elsif tipo_mov_p = 'DEV' then
     vcant_devol  := nvl(cant_p,0);
     vcosto_devol := vcosto_nomi;
     vcosto2_devol := vcosto2_nomi;
     vmonto_devol := nvl(mont_p,0);
  else
     msg_error := 'ERROR: El indicador de tipo: '||tipo_mov_p||' para actualizar estadistica es incorrecto';
     raise error_proceso;
  end if;
  --
  if moneda_p = 'P' then
     vcosto_venta_nomi  := vcosto_venta;
     vcosto_ofe_nomi    := vcosto_ofe;
     vcosto_devol_nomi  := vcosto_devol;

     vcosto2_venta_nomi  := vcosto2_venta;
     vcosto2_ofe_nomi    := vcosto2_ofe;
     vcosto2_devol_nomi  := vcosto2_devol;


     vmonto_venta_nomi  := vmonto_venta;
     vmonto_devol_nomi  := vmonto_devol;
     vdescuento_nomi    := nvl(desc_p,0);
     vimpuesto_nomi     := nvl(impu_p,0);
     vimpuesto_inc_nomi := nvl(impu_inc_p,0);
     --
     if vtipo_cambio != 0 then
        vcosto_venta_dol  := vcosto_venta / vtipo_cambio;
        vcosto_ofe_dol    := vcosto_ofe   / vtipo_cambio;
        vcosto_devol_dol  := vcosto_devol / vtipo_cambio;

        vcosto2_venta_dol  := vcosto2_venta / vtipo_cambio;
        vcosto2_ofe_dol    := vcosto2_ofe   / vtipo_cambio;
        vcosto2_devol_dol  := vcosto2_devol / vtipo_cambio;


        vmonto_venta_dol  := vmonto_venta / vtipo_cambio;
        vmonto_devol_dol  := vmonto_devol / vtipo_cambio;
        vdescuento_dol    := nvl(desc_p,0) / vtipo_cambio;
        vimpuesto_dol     := nvl(impu_p,0) / vtipo_cambio;
        vimpuesto_inc_dol := nvl(impu_inc_p,0) / vtipo_cambio;

     end if;
  else
     -- La moneda_p es Dolares
     vcosto_venta_nomi  := vcosto_venta;
     vcosto_ofe_nomi    := vcosto_ofe;
     vcosto_devol_nomi  := vcosto_devol;

     vcosto2_venta_nomi  := vcosto2_venta;
     vcosto2_ofe_nomi    := vcosto2_ofe;
     vcosto2_devol_nomi  := vcosto2_devol;

     vmonto_venta_nomi  := moneda.redondeo(vmonto_venta * vtipo_cambio,'P');
     vmonto_devol_nomi  := moneda.redondeo(vmonto_devol * vtipo_cambio, 'P');
     vdescuento_nomi    := moneda.redondeo(nvl(desc_p,0) * vtipo_cambio, 'P');
     vimpuesto_nomi     := moneda.redondeo(nvl(impu_p,0) * vtipo_cambio, 'P');
     vimpuesto_inc_nomi := moneda.redondeo(nvl(impu_inc_p,0) * vtipo_cambio, 'P');
     --
     if vtipo_cambio != 0 then
        vcosto_venta_dol  := vcosto_venta / vtipo_cambio;
        vcosto_ofe_dol    := vcosto_ofe / vtipo_cambio;
        vcosto_devol_dol  := vcosto_devol / vtipo_cambio;

        vcosto2_venta_dol  := vcosto2_venta / vtipo_cambio;
        vcosto2_ofe_dol    := vcosto2_ofe / vtipo_cambio;
        vcosto2_devol_dol  := vcosto2_devol / vtipo_cambio;

     end if;
     vmonto_venta_dol  := vmonto_venta;
     vmonto_devol_dol  := vmonto_devol;
     vdescuento_dol    := nvl(desc_p,0);
     vimpuesto_dol     := nvl(impu_p,0);
     vimpuesto_inc_dol := nvl(impu_inc_p,0);
  end if;
  --

--- Hace el mismo proceso que estaba antes ANR 28/12/2010
If Pv_doctor is null Then

  update arfaev
    set venta_unidades = nvl(venta_unidades, 0) + vcant_venta,
        promo_unidades = nvl(promo_unidades, 0) + vcant_ofe,
        devol_unidades = nvl(devol_unidades,0)  + vcant_devol,
        costo_venta    = nvl(costo_venta,0)     + vcosto_venta_nomi,
        venta_dinero   = nvl(venta_dinero, 0)   + vmonto_venta_nomi,
        descuento      = nvl(descuento, 0)      + vdescuento_nomi,
        impuesto       = nvl(impuesto, 0)       + vimpuesto_nomi,
        impuesto_inc   = nvl(impuesto_inc, 0)   + vimpuesto_inc_nomi,
        costo_promo    = nvl(costo_promo,0)     + vcosto_ofe_nomi,
        costo_devol    = nvl(costo_devol,0)     + vcosto_devol_nomi,
        devol_dinero   = nvl(devol_dinero,0)    + vmonto_devol_nomi,
        costo_venta_dol    = nvl(costo_venta_dol,0)     + vcosto_venta_dol,
        venta_dinero_dol   = nvl(venta_dinero_dol, 0)   + vmonto_venta_dol,
        descuento_dol      = nvl(descuento_dol, 0)      + vdescuento_dol,
        impuesto_dol       = nvl(impuesto_dol, 0)       + vimpuesto_dol,
        impuesto_inc_dol   = nvl(impuesto_inc_dol, 0)   + vimpuesto_inc_dol,
        costo_promo_dol    = nvl(costo_promo_dol, 0)    + vcosto_ofe_dol,
        costo_devol_dol    = nvl(costo_devol_dol,0)     + vcosto_devol_dol,
        devol_dinero_dol   = nvl(devol_dinero_dol,0)    + vmonto_devol_dol,
        costo2_venta       = nvl(costo2_venta,0)     + vcosto2_venta_nomi,
        costo2_venta_dol   = nvl(costo2_venta_dol,0)     + vcosto2_venta_dol,
        costo2_devol       = nvl(costo2_devol,0)     + vcosto2_devol_nomi,
        costo2_devol_dol   = nvl(costo2_devol_dol,0)     + vcosto2_devol_dol,
        costo2_promo       = nvl(costo2_promo,0)     + vcosto2_ofe_nomi,
        costo2_promo_dol   = nvl(costo2_promo_dol, 0)    + vcosto2_ofe_dol
  where (no_cia     = no_cia_p)
    and (centro     = centro_p)
    and (articulo   = no_arti_p)
    and (grupo      = grupo_p)
    and (no_cliente = cliente_p)
    and (vendedor   = vendedor_p)
    and (ruta       = ruta_p)
    and (semana     = sem_p)
    and (ind_sem    = ind_p)
    and (ano        = ano_p)
    and (moneda     = moneda_p);
  if (sql%rowcount = 0) then
     insert into arfaev(no_cia, centro, clase, categoria, articulo,
              grupo, no_cliente, vendedor, ruta, semana, ind_sem,
              ano,   mes,  moneda,
              venta_unidades, promo_unidades, devol_unidades,
              costo_venta,  venta_dinero, descuento, impuesto, impuesto_inc,
              costo_promo,
              costo_devol,  devol_dinero,
              costo_venta_dol,  venta_dinero_dol, descuento_dol, impuesto_dol,
              impuesto_inc_dol, costo_promo_dol,
              costo_devol_dol,  devol_dinero_dol,
              costo2_venta,
              costo2_venta_dol,
              costo2_devol,
              costo2_devol_dol,
              costo2_promo,
              costo2_promo_dol)
          values(
              no_cia_p, centro_p, clase_p, categoria_p, no_arti_p,
              grupo_p, cliente_p, vendedor_p, ruta_p, sem_p, ind_p,
              ano_p,   mes_p, moneda_p,
              vcant_venta,   vcant_ofe,   vcant_devol,
              vcosto_venta_nomi, vmonto_venta_nomi, vdescuento_nomi, vimpuesto_nomi, vimpuesto_inc_nomi,
              vcosto_ofe_nomi,
              vcosto_devol_nomi, vmonto_devol_nomi,
              vcosto_venta_dol, vmonto_venta_dol, vdescuento_dol, vimpuesto_dol,
              vimpuesto_inc_dol, vcosto_ofe_dol,
              vcosto_devol_dol, vmonto_devol_dol,
              vcosto2_venta_nomi,vcosto2_venta_dol,
              vcosto2_devol_nomi,vcosto2_devol_dol,
              vcosto2_ofe_nomi,vcosto2_ofe_dol);

  end if;

  --- registra el doctor
  else

  update arfaev
    set venta_unidades = nvl(venta_unidades, 0) + vcant_venta,
        promo_unidades = nvl(promo_unidades, 0) + vcant_ofe,
        devol_unidades = nvl(devol_unidades,0)  + vcant_devol,
        costo_venta    = nvl(costo_venta,0)     + vcosto_venta_nomi,
        venta_dinero   = nvl(venta_dinero, 0)   + vmonto_venta_nomi,
        descuento      = nvl(descuento, 0)      + vdescuento_nomi,
        impuesto       = nvl(impuesto, 0)       + vimpuesto_nomi,
        impuesto_inc   = nvl(impuesto_inc, 0)   + vimpuesto_inc_nomi,
        costo_promo    = nvl(costo_promo,0)     + vcosto_ofe_nomi,
        costo_devol    = nvl(costo_devol,0)     + vcosto_devol_nomi,
        devol_dinero   = nvl(devol_dinero,0)    + vmonto_devol_nomi,
        costo_venta_dol    = nvl(costo_venta_dol,0)     + vcosto_venta_dol,
        venta_dinero_dol   = nvl(venta_dinero_dol, 0)   + vmonto_venta_dol,
        descuento_dol      = nvl(descuento_dol, 0)      + vdescuento_dol,
        impuesto_dol       = nvl(impuesto_dol, 0)       + vimpuesto_dol,
        impuesto_inc_dol   = nvl(impuesto_inc_dol, 0)   + vimpuesto_inc_dol,
        costo_promo_dol    = nvl(costo_promo_dol, 0)    + vcosto_ofe_dol,
        costo_devol_dol    = nvl(costo_devol_dol,0)     + vcosto_devol_dol,
        devol_dinero_dol   = nvl(devol_dinero_dol,0)    + vmonto_devol_dol,
        costo2_venta       = nvl(costo2_venta,0)     + vcosto2_venta_nomi,
        costo2_venta_dol   = nvl(costo2_venta_dol,0)     + vcosto2_venta_dol,
        costo2_devol       = nvl(costo2_devol,0)     + vcosto2_devol_nomi,
        costo2_devol_dol   = nvl(costo2_devol_dol,0)     + vcosto2_devol_dol,
        costo2_promo       = nvl(costo2_promo,0)     + vcosto2_ofe_nomi,
        costo2_promo_dol   = nvl(costo2_promo_dol, 0)    + vcosto2_ofe_dol
  where (no_cia     = no_cia_p)
    and (centro     = centro_p)
    and (articulo   = no_arti_p)
    and (grupo      = grupo_p)
    and (no_cliente = cliente_p)
    and (vendedor   = vendedor_p)
    and (cod_doctor = pv_doctor)
    and (ruta       = ruta_p)
    and (semana     = sem_p)
    and (ind_sem    = ind_p)
    and (ano        = ano_p)
    and (moneda     = moneda_p);
  if (sql%rowcount = 0) then
     insert into arfaev(no_cia, centro, clase, categoria, articulo,
              grupo, no_cliente, vendedor, ruta, semana, ind_sem,
              ano,   mes,  moneda,
              venta_unidades, promo_unidades, devol_unidades,
              costo_venta,  venta_dinero, descuento, impuesto, impuesto_inc,
              costo_promo,
              costo_devol,  devol_dinero,
              costo_venta_dol,  venta_dinero_dol, descuento_dol, impuesto_dol,
              impuesto_inc_dol, costo_promo_dol,
              costo_devol_dol,  devol_dinero_dol,
              costo2_venta,
              costo2_venta_dol,
              costo2_devol,
              costo2_devol_dol,
              costo2_promo,
              costo2_promo_dol, cod_doctor)
          values(
              no_cia_p, centro_p, clase_p, categoria_p, no_arti_p,
              grupo_p, cliente_p, vendedor_p, ruta_p, sem_p, ind_p,
              ano_p,   mes_p, moneda_p,
              vcant_venta,   vcant_ofe,   vcant_devol,
              vcosto_venta_nomi, vmonto_venta_nomi, vdescuento_nomi, vimpuesto_nomi, vimpuesto_inc_nomi,
              vcosto_ofe_nomi,
              vcosto_devol_nomi, vmonto_devol_nomi,
              vcosto_venta_dol, vmonto_venta_dol, vdescuento_dol, vimpuesto_dol,
              vimpuesto_inc_dol, vcosto_ofe_dol,
              vcosto_devol_dol, vmonto_devol_dol,
              vcosto2_venta_nomi,vcosto2_venta_dol,
              vcosto2_devol_nomi,vcosto2_devol_dol,
              vcosto2_ofe_nomi,vcosto2_ofe_dol, pv_doctor);

  end if;

  end if;

EXCEPTION
  when error_proceso then
      msg_error := nvl(msg_error, sqlerrm);
      return;
  when others then
      msg_error := 'ACTUALIZA ESTADISTICA: '|| sqlerrm;
      return;
END;