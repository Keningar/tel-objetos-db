create or replace function            F_TAM_GLOSA_CONT(pv_empresa varchar2, pv_proceso varchar2, pn_value_anterior number ) return number  is
  ln_resultado number;
begin

     select to_number(nvl(p.parametro, pn_value_anterior)) into ln_resultado
    from NAF47_TNET.GE_GRUPOS_PARAMETROS g, NAF47_TNET.GE_PARAMETROS p 
    where g.id_empresa = p.id_empresa
    and g.id_aplicacion = p.id_aplicacion
    and g.id_grupo_parametro = p.id_grupo_parametro
    and g.estado = p.estado
    and g.id_aplicacion = 'CG'
    and g.id_grupo_parametro = pv_proceso
    and g.id_empresa = pv_empresa
    and g.estado = 'A';

  return(ln_resultado);
  
exception
  when no_data_found then
    ln_resultado:= pn_value_anterior;
    return ln_resultado;
  when too_many_rows then
    ln_resultado:= pn_value_anterior;  
    return ln_resultado;
  when others then 
    ln_resultado:= pn_value_anterior;
    return ln_resultado;
end F_TAM_GLOSA_CONT;