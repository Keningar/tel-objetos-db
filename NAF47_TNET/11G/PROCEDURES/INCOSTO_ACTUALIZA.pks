create or replace procedure            INCOSTO_ACTUALIZA(PvCia IN Varchar2, PvArti IN Varchar2) is

--- ANR 27/04/2009

begin
 --- El monto 2 y saldo valuado se actualiza, para todas las bodegas
          Update arinma set
                  sal_ant_mo = costo_uni * sal_ant_un,
                  comp_mon   = costo_uni * comp_un,
                  vent_mon   = costo_uni * vent_un,
                  cons_mon   = costo_uni * cons_un,
                  otrs_mon   = costo_uni * otrs_un,
                  monto2     = costo2 * (sal_ant_un + comp_un - vent_un - cons_un + otrs_un)
          Where no_cia  = PvCia
          and   no_arti = PvArti;

end INCOSTO_ACTUALIZA;