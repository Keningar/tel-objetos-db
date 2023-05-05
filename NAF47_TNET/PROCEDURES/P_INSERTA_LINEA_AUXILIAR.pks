create or replace procedure            P_INSERTA_LINEA_AUXILIAR (Pv_cia         IN arafau.no_cia%type,
                                                      Pv_Cuenta      IN arafau.cuenta%type,
                                                      Pn_Monto       IN arafau.debitos%type,
                                                      Pn_MontoDol    IN arafau.debitos_dol%type,
                                                      Pv_CentroCosto IN arafau.cent_cost%type,
                                                      Pv_Tipo        IN arcgal.tipo%type  ) is                                                    
/**
Documentacion para P_INSERTA_LINEA_AUXILIAR
Procedimiento que realiza la creacion de linea contable para armar auxiliar 
en la genracion del asiento contable por depreciación.

@author  Martha Navarrete Martinez <mnavarrete@telconet.ec>
@version 1.0  15/05/2017

@param  Pv_cia IN arafau.no_cia%type  Recibe el codigo de la empresa 
@param  Pv_Cuenta IN arafau.cuenta%type  Recibe el codigo de la cuenta contabnle
@param  Pn_Monto IN arafau.debitos%type  Recibe el monto por cuenta y centro
@param  Pn_MontoDol IN arafau.debitos_dol%type  Recibe el monto en dolares por cuenta y centro 
@param  Pv_CentroCosto IN arafau.cent_cost%type  Recibe el centro de costos
@param  Pv_Tipo IN varchar2  Recibe el tipo de movimiento de la cuenta
**/                                                      
                                                      
  Ln_Monto      arafau.debitos%type;
  Ln_MontoDol   arafau.debitos_dol%type;
                        
Begin
  Ln_Monto     := moneda.redondeo(Pn_Monto,'P');
  Ln_MontoDol  := moneda.redondeo(Pn_MontoDol,'D');

  If nvl(Pn_Monto,0) > 0 then
    If Pv_Tipo = 'D' then  -- Generamos un debito por gasto de depreciacion     
      
      update arafau
      set debitos     = nvl(debitos,0) + Ln_Monto,
        debitos_dol   = nvl(debitos_dol,0) + Ln_MontoDol
      where no_cia = Pv_cia    and
        cuenta     = Pv_Cuenta    and
        cent_cost  = Pv_CentroCosto;

      if sql%rowcount = 0 then
        insert into arafau(no_cia, 
                           cuenta, 
                           debitos, 
                           creditos, 
                           debitos_dol, 
                           creditos_dol, 
                           cent_cost)
                    values(Pv_cia, 
                           Pv_Cuenta, 
                           round(Ln_Monto,2), 
                           0,
                           round(Ln_MontoDol,2), 
                           0, 
                           Pv_CentroCosto);
      end if;   
         
    else   -- Generamos un credito por depreciacion acumulada valor original
      update arafau
      set creditos    = nvl(creditos,0)     + Ln_Monto,
        creditos_dol  = nvl(creditos_dol,0) + Ln_MontoDol 
      where no_cia    = Pv_cia   and
        cuenta    = Pv_Cuenta   and
        cent_cost = Pv_CentroCosto;

      if sql%rowcount = 0 then
        insert into arafau(no_cia, 
                           cuenta, 
                           debitos, 
                           creditos,
                           debitos_dol, 
                           creditos_dol, 
                           cent_cost)
                    values(Pv_cia, 
                           Pv_Cuenta, 
                           0, 
                           round(Ln_Monto,2), 
                           0, 
                           round(Ln_MontoDol,2), 
                           Pv_CentroCosto);
      end if;      
    End if; -- Pv_Tipo
  End if; -- Pn_Monto     
End P_INSERTA_LINEA_AUXILIAR;