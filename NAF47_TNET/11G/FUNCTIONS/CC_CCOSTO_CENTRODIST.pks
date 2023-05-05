create or replace function            CC_CCOSTO_CENTRODIST(Pv_cia        IN Varchar2,
                                                Pv_centro     IN Varchar2) return Varchar2 IS


Cursor C_CC Is
 select b.centro_costo
 from   arincd b
 where  b.no_cia = Pv_cia
 and    b.centro = Pv_centro;

Lv_cc Arcgceco.centro%type;

begin

/*** Funcion que devuelve el centro de costo del centro de distribucion
     Normalmente esta funcion es llamada para procesos de POS que por cada
     centro de distribucion se configura un centro de costos ANR 07/12/2010 ***/

  Open C_CC;
  Fetch C_CC into Lv_cc;
  If C_CC%notfound Then
   Close C_CC;
  else
   Close C_CC;
  end if;

  return (Lv_cc);

end CC_CCOSTO_CENTRODIST;