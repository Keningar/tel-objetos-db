create or replace function            CC_CCOSTO_SUBCLIENTE(Pv_cia        IN Varchar2,
                                                Pv_grupo      IN Varchar2,
                                                Pv_cliente    IN Varchar2,
                                                Pv_subcliente IN Varchar2) return Varchar2 IS


Cursor C_CC Is
 select b.centro_costo
 from  arcclocales_clientes a, arfa_div_comercial b
 where a.no_cia = Pv_cia
 and   a.grupo  = Pv_grupo
 and   a.no_cliente = Pv_cliente
 and   a.no_sub_cliente = Pv_subcliente
 and   a.no_cia = b.no_cia
 and   a.centro = b.centro
 and   a.div_comercial = b.division;

Lv_cc Arcgceco.centro%type;

begin

--- Funcion que devuelve el centro de costo por subcliente y division comercial relacionada ANR 19/10/2009

  Open C_CC;
  Fetch C_CC into Lv_cc;
  If C_CC%notfound Then
   Close C_CC;
  else
   Close C_CC;
  end if;

  return (Lv_cc);

end CC_CCOSTO_SUBCLIENTE;