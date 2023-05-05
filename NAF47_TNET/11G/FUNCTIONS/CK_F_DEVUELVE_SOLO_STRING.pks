create or replace function            CK_F_DEVUELVE_SOLO_STRING(Pv_Cadena in varchar2)
                                                      return varchar2 is


  lv_texto_acum       varchar2(30) := '';
  lv_texto            varchar2(30) := '';
  lv_texto_original   varchar2(30) := '';
  lv_longitud_cad     number;
  lv_caracter         varchar2(1)  := '-';

begin
  
    select trim(Pv_Cadena) texto, length(Pv_Cadena) tamanio
      into lv_texto_original, lv_longitud_cad
     from dual;
  
    for j in 1 .. lv_longitud_cad loop

      lv_texto := substr(lv_texto_original, j, 1);
      if lv_texto <> lv_caracter then
         lv_texto_acum := lv_texto_acum || lv_texto;
      end if;
    end loop;
  
    return lv_texto_acum;
  
end CK_F_DEVUELVE_SOLO_STRING;