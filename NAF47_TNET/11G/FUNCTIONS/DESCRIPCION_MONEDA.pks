create or replace function            DESCRIPCION_MONEDA(PCIA VARCHAR2,PPROVEEDOR VARCHAR2,PTIPO VARCHAR2) return varchar2 is
  descripcion varchar2(200);
  cursor c_convenio is
     select b.descripcion
     from arcpmp a, monedas b
     where a.no_cia = pcia
     and a.no_prove = pproveedor
     and a.moneda_convenio= b.id_moneda;

  cursor c_lista is
     select b.descripcion
     from arcpmp a, monedas b
     where a.no_cia = pcia
     and a.no_prove = pproveedor
     and a.moneda= b.id_moneda;


des varchar2(100);
exis boolean;

begin
  if ptipo = 'C' then
     open c_convenio;
     fetch c_convenio into des;
     exis:=c_convenio%found;
     close c_convenio;
     if exis then
       descripcion:=des;
     else
       descripcion:=null;
      end if;
  else--if ptipo = 'P' or ptipo = 'L' then
    open c_lista;
     fetch c_lista into des;
     exis:=c_lista%found;
     close c_lista;
     if exis then
       descripcion:=des;
     else
       descripcion:=null;
      end if;

  end if;

  return(descripcion);
end DESCRIPCION_MONEDA;