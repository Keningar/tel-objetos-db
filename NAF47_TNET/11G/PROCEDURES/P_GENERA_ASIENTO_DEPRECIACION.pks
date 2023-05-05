create or replace procedure            P_GENERA_ASIENTO_DEPRECIACION(Pv_cia   IN varchar2,
                                                                     Pn_ano   IN number,
                                                                     Pn_mes   IN number,
                                                                     Pd_fecha IN date, 
                                                                     Pv_CodigoDiario IN varchar2,
                                                                     Pn_TipoCambio   IN number,
                                                                     Pv_TcambCV      IN varchar2,
                                                                     Pn_NumAsiento   IN OUT arcgae.no_asiento%type,
                                                                     Pv_Error        IN OUT varchar2 ) IS
/**
Documentación para P_GENERA_ASIENTO_DEPRECIACION
Procedimiento que realiza la generacion del asiento cantables por depereciaciones

@author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
@version 1.0  15/05/2017

@param  Pv_cia   IN varchar2  Recibe el codigo de la empresa 
@param  Pn_ano   IN number Recibe el año de proceso del modulo
@param  Pn_mes   IN number Recibe el mes de proceso del modulo
@param  Pd_fecha IN date Recibe el ultimo dia del mes en proceso
@param  Pv_CodigoDiario IN Recibe el codigo de diario
@param  Pn_TipoCambio   IN Recibe el tipo de cambio
@param  Pv_TcambCV      IN Recibe el tipo Compra o Venta
@param  Pn_NumAsiento   IN OUT number Retorna el numero de asiento generado
@param  Pv_Error        IN OUT varchar2 Retorna mensaje de error
**/

  CURSOR C_DatosCia IS
    SELECT ((mc.ano_proce*100)+mc.mes_proce), ((af.ano*100)+af.mes)
    FROM arcgmc mc, arafmc af
    WHERE mc.no_cia = Pv_cia
    AND af.no_cia  = mc.no_cia;
       
  Cursor C_ActivosDepreciados is  
    Select ma.no_acti,        ma.ctagavo,                   ma.ctadavo,         
      ma.ctagare,             ma.ctadare,                   ma.ctavo,
      ma.ctare,               ma.centro_costo cc,           ma.no_cia,   
      ma.tipo,                hd.depacum_valorig,           hd.depacum_mejoras,
      hd.depacum_revtecs,     hd.depacum_valorig_dol,       hd.depacum_mejoras_dol,
      hd.depacum_revtecs_dol, hd.dep_valorig,               hd.dep_valorig_dol,
      hd.dep_revtecs,         hd.dep_revtecs_dol,           hd.dep_mejoras,
      hd.dep_mejoras_dol          
    From arafma ma, arafhd hd
    Where to_char(ma.f_ingre,'yyyymm') <= to_char(Pd_fecha,'YYYYMM')
    and ma.no_cia  = Pv_cia 
    and ma.f_egre is null        
    and hd.no_cia  = ma.no_cia 
    and hd.no_acti = ma.no_acti
    and nvl(tipo_dep,'N')   = 'N'
    and nvl(hd.dep_valorig,0) > 0 
    and ano = Pn_ano
    and mes = Pn_mes;
  
  Cursor C_CuentasContables is 
    Select debitos, creditos,
      debitos_dol, creditos_dol,
      cuenta, cent_cost 
    From arafau 
    Where no_cia = Pv_cia;

  Ln_ProcesoContabilidad number;
  Ln_ProcesoActivoFijo   number;
  Ln_Registros           number;
  Lv_Asiento      arcgae.no_asiento%type;
  Ln_TotDebe      arcgae.t_debitos%type  := 0;
  Ln_TotHaber     arcgae.t_creditos%type := 0;
  Lv_centro       arcgceco.centro%type; 
  Lv_Estado       arcgae.estado%type;
  Lv_Autoriza     arcgae.autorizado%type;
  Lv_centro_costo arcgal.centro_costo%type;
  Lv_TipoCambio   arafma.tipo_cambio%type;
  Ln_linea        arcgal.no_linea%type;
       
BEGIN
  --Borra los asientos contables generados por el proceso en periodos anteriores 
  Delete from arafau
  Where no_cia = Pv_cia;

  Lv_Asiento := transa_id.cg(Pv_cia);
  Pn_NumAsiento := Lv_Asiento;
  
  -- Obtiene datos de la compania
  IF C_DatosCia%ISOPEN THEN CLOSE C_DatosCia; END IF;
  OPEN  C_DatosCia;
  FETCH C_DatosCia INTO Ln_ProcesoContabilidad, Ln_ProcesoActivoFijo;
  CLOSE C_DatosCia;
   
  IF (Ln_ProcesoContabilidad <= Ln_ProcesoActivoFijo) THEN
    Lv_Estado := 'P';
    Lv_Autoriza := 'N';
  ELSE
    Lv_Estado := 'O';
    Lv_Autoriza := 'S';
  END IF;
  --
  IF C_ActivosDepreciados%ISOPEN THEN CLOSE C_ActivosDepreciados; END IF;
  FOR Lc_Activo IN C_ActivosDepreciados LOOP 
    -- Actualizamos la fecha de depreciacion de activos.
    update arafma
    set f_depre = to_date('01'||to_char(Pn_mes,'00')||to_char(Pn_ano),'DDMMYYYY')
    where no_cia = Pv_cia 
    and no_acti = Lc_Activo.no_acti;

    -- ------------------------------------------------------------
    -- Generamos un debito por GASTO de depreciacion VALOR ORIGINAL
    -- ------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagavo) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,          
                             Lc_Activo.ctagavo,  
                             Lc_Activo.dep_valorig, 
                             Lc_Activo.dep_valorig_dol,  
                             Lv_centro,      
                             'D');

    -- --------------------------------------------------------------
    -- Generamos un credito por DEPRECIACION acumulada VALOR ORIGINAL
    -- --------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadavo) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,         
                             Lc_Activo.ctadavo,  
                             Lc_Activo.dep_valorig,
                             Lc_Activo.dep_valorig_dol, 
                             Lv_centro,      
                             'C');

    -- ------------------------------------------------------------
    -- Generamos un debito por GASTO de depreciacion REVALUACIONES
    -- ------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagare) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,         
                             Lc_Activo.ctagare, 
                             Lc_Activo.dep_revtecs,
                             Lc_Activo.dep_revtecs_dol, 
                             Lv_centro,      
                             'D');

    -- --------------------------------------------------------------
    -- Generamos un credito por DEPRECIACION acumulada REVALUACIONES
    -- --------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadare) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,         
                             Lc_Activo.ctadare, 
                             Lc_Activo.dep_revtecs,
                             Lc_Activo.dep_revtecs_dol,  
                             Lv_centro,      
                             'C');

    -- ------------------------------------------------------------
    -- Generamos un debito por GASTO de depreciacion MEJORAS
    -- ------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctagavo) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;     
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,         
                             Lc_Activo.ctagavo, 
                             Lc_Activo.dep_mejoras,
                             Lc_Activo.dep_mejoras_dol, 
                             Lv_centro,      
                             'D');

    -- --------------------------------------------------------------
    -- Generamos un credito por DEPRECIACION acumulada MEJORAS
    -- --------------------------------------------------------------
    If cuenta_contable.acepta_cc(Pv_cia, Lc_Activo.ctadavo) then
      Lv_centro := Lc_Activo.cc;
    else
      Lv_centro := '000000000';          
    end if;
    P_INSERTA_LINEA_AUXILIAR(Pv_cia,         
                             Lc_Activo.ctadavo, 
                             Lc_Activo.dep_mejoras,
                             Lc_Activo.dep_mejoras_dol, 
                             Lv_centro,      
                             'C');

    Ln_Registros := Ln_Registros + 1;
  End loop;  -- C_ActivosDepreciados

  -----------------------------------------------------
  If Ln_Registros = 0 then
    update arafmc 
    set ind_calculo_dep = 'S'
    where no_cia = Pv_cia;
    
    Pv_Error := '<ATENCION> No se genero ningun Asiento';
  else
    -- ------------------------------------------------
    -- Genera el movimiento en contabilidad
    -- ------------------------------------------------
    insert into arcgae(no_cia,     
                       ano,    
                       mes,              
                       no_asiento, 
                       fecha,      
                       estado, 
                       autorizado,       
                       COD_DIARIO,
                       t_camb_c_v, 
                       origen, 
                       tipo_comprobante, 
                       no_comprobante, 
                       anulado,    
                       descri1)
                values(Pv_cia, 
                       Pn_ano,    
                       Pn_mes, 
                       Lv_Asiento,
                       Pd_fecha,  
                       Lv_Estado, 
                       Lv_autoriza, 
                       Pv_CodigoDiario,
                       Pv_TcambCV, 
                       'AD',    
                       'T', 
                       0,
                       'N',         
                       'DEPRECIACION MENSUAL DE ACTIVO FIJOS');

    IF C_CuentasContables%ISOPEN THEN CLOSE C_CuentasContables; END IF;
    FOR Lc_Cuentas IN C_CuentasContables LOOP -- j IN C_CuentasContables LOOP
      Lv_centro_costo := centro_costo.rellenad(Pv_cia,'0');

      IF nvl(Lc_Cuentas.debitos,0) > nvl(Lc_Cuentas.creditos,0) THEN
        
        IF nvl(Lc_Cuentas.debitos_dol,0) != 0 OR nvl(Lc_Cuentas.creditos_dol,0) != 0 THEN           
          Lv_TipoCambio := moneda.redondeo((nvl(Lc_Cuentas.debitos,0)-nvl(Lc_Cuentas.creditos,0))/                                  
                           (nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0)),'P');
        ELSE
          Lv_TipoCambio := moneda.redondeo(Pn_TipoCambio,'P');
        END IF;

        insert into arcgal(no_cia,
                           ano,
                           mes,
                           no_asiento,
                           no_linea,
                           cuenta,
                           tipo,
                           cod_diario,
                           tipo_cambio,
                           moneda,
                           centro_costo,
                           monto,
                           monto_dol,
                           descri)
                    values(Pv_cia,          
                           Pn_ano,         
                           Pn_mes,     
                           Lv_Asiento,
                           Ln_Linea,                
                           Lc_Cuentas.cuenta,     
                           'D',      
                           Pv_CodigoDiario,
                           Lv_TipoCambio,         
                           'P',                                         
                           nvl(Lc_Cuentas.cent_cost,    Lv_centro_costo), 
                           nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0),           
                           nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0),
                           'DEPREC.MENSUAL DE A.FIJOS' ); --estan redondeados  
                     
        Ln_TotDebe := moneda.redondeo(nvl(Ln_TotDebe,0)+(nvl(Lc_Cuentas.debitos,0)-nvl(Lc_Cuentas.creditos,0)),'P');
        Ln_linea   := nvl(Ln_linea,0) + 1;
            
      ELSIF nvl(Lc_Cuentas.creditos,0) > nvl(Lc_Cuentas.debitos,0) THEN
          
        IF nvl(Lc_Cuentas.debitos_dol,0) != 0 OR nvl(Lc_Cuentas.creditos_dol,0) != 0 THEN
          Lv_TipoCambio := moneda.redondeo((nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0))/
                          (nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0)),'P');
        ELSE
          Lv_TipoCambio := moneda.redondeo(Pn_TipoCambio,'P');
        END IF;

        insert into arcgal(no_cia,     
                           ano,      
                           mes,    
                           no_asiento, 
                           no_linea,    
                           cuenta,   
                           tipo,   
                           cod_diario,
                           tipo_cambio, 
                           moneda,
                           centro_costo, 
                           monto, 
                           monto_dol,    
                           descri)
                    values(Pv_cia,  
                           Pn_ano, 
                           Pn_mes,     
                           Lv_Asiento, 
                           Ln_Linea,        
                           Lc_Cuentas.cuenta,    
                           'C',      
                           Pv_CodigoDiario,
                           Lv_TipoCambio, 'P', 
                           nvl(Lc_Cuentas.cent_cost, Lv_centro_costo), 
                           nvl(Lc_Cuentas.debitos,0)    -nvl(Lc_Cuentas.creditos,0),        
                           nvl(Lc_Cuentas.debitos_dol,0)-nvl(Lc_Cuentas.creditos_dol,0),
                           'DEPREC.MENSUAL DE A.FIJOS');   --estan redondeados
  
        Ln_TotHaber := moneda.redondeo(nvl(Ln_TotHaber,0)+(nvl(Lc_Cuentas.creditos,0)-nvl(Lc_Cuentas.debitos,0)),'P');
        Ln_Linea    := nvl(Ln_Linea,0)+1;  
      end if;
    End loop; -- C_CuentasContables                
    -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    -- Actualiza los totales en el encabezado del asiento
    -- y indicador del calculo de depreciacion
    -- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    update arcgae
    set t_debitos  = Ln_TotDebe,
      t_creditos = Ln_TotHaber
    where no_cia     = Pv_cia 
    and ano        = Pn_ano 
    and mes        = Pn_mes 
    and no_asiento = Lv_Asiento;

    update arafmc 
    set ind_calculo_dep = 'S',
      ind_depre_generada = 'N'    
    where no_cia = Pv_cia;
  End if; 
End;