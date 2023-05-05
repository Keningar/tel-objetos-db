create or replace procedure            INinserta_dc(
  cia_p     in varchar2,
  cen_p     in varchar2,      -- centro
  tip_p     in varchar2,      -- tipo documento
  doc_p     in varchar2,      -- num. transaccion
  mov_p     in varchar2,      -- tipo de movimiento contable
  pcta      in varchar2,      -- cuenta contable
  tot_p     in number,        -- monto
  cc        in varchar2,
  tot_d     in number,        -- monto en dolares
  tipo_c    in number,
  tercero_p in varchar2       -- Codigo de tercero
) is
  -- Este procedimiento se encarga de alimentar la tabla ARINDC.
  -- Si el registro existe actualiza el monto, sino, lo inserta en la tabla.
  --
  vcc       arindc.centro_costo%type;
  vTercero  arindc.codigo_tercero%type;
BEGIN
  -- inicializa variables con el centro de costo asociado al centro de distribucion.
  IF NOT cuenta_contable.acepta_cc(cia_p, pcta) THEN
    -- si la cuenta contable no acepta centro de costo, no se usa el del centro de
    -- distribucion sino el 000-000-000
    vcc    := '000000000';
  ELSE
    vcc    := cc;
  END IF;

  vTercero := null;
  IF cuenta_contable.acepta_tercero(cia_p, pcta) THEN
    vTercero := tercero_p;
  END IF;

  IF nvl(tot_p,0) != 0 or nvl(tot_d,0) != 0 THEN
     update arindc
       set monto       = nvl(monto, 0) + nvl(tot_p, 0),
           monto_dol   = nvl(monto_dol,0) + nvl(tot_d,0),
           tipo_cambio = nvl(tipo_c,0)
       where no_cia                   = cia_p
	     and no_docu                  = doc_p
		 and centro                   = cen_p
		 and tipo_doc                 = tip_p
		 and tipo_mov                 = mov_p
		 and cuenta                   = pcta
		 and centro_costo             = vcc
		 and nvl(codigo_tercero, 'A') = nvl(vTercero, 'A');  -- Cuando el codigo de tercero es nulo
     --
     if (sql%rowcount = 0) then
        insert into arindc (no_cia,    centro,      tipo_doc,       no_docu,
	                      tipo_mov,  cuenta,      monto,          centro_costo,
	  			    monto_dol, tipo_cambio, codigo_tercero)
               values (          cia_p,        cen_p,  tip_p,        doc_p,
					   mov_p,        pcta,   nvl(tot_p,0), vcc,
					   nvl(tot_d,0), tipo_c, vTercero);
     end if;
  END IF;
END;