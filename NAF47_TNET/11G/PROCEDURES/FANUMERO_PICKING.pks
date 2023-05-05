create or replace procedure            FANUMERO_PICKING (pno_cia      IN varchar2,
                                              pno_centro   IN varchar2,
                                              pno_control  IN OUT varchar2,
                                              msg_error_p  IN OUT varchar2) IS
  Cursor C_Doc Is
    Select tipo
    From   ARFACT
    where  no_cia = pno_cia
    and    ind_fac_dev = 'K';

  Cursor C_Proceso Is
    Select dia_proceso_fact
      From arincd
     Where no_cia = pno_cia
       and centro = pno_centro;

   Lv_tipo        arfact.tipo%type;
   vv_ano_proce   arincd.ano_proce_fact%type;
   vv_mes_proce   arincd.mes_proce_fact%type;
   vv_dia_proceso arincd.dia_proceso_fact%type;

  Begin

      Open C_Doc;
      Fetch C_Doc into Lv_tipo;
      If C_Doc%notfound then
        Close C_Doc;
        msg_error_p := 'Debe configurar en Tipos de Documento, un documento para picking';

      else
        Close C_Doc;
      end if;

      Open  C_Proceso;
      Fetch C_Proceso into vv_dia_proceso;
      Close C_Proceso;

      pno_control :=  Consecutivo.FA(pno_cia,
                                     to_number(to_char(vv_ano_proce,'YYYY')),
                                     to_number(to_char(vv_mes_proce,'MM')),
                                     pno_centro,
                                     '0000',  --:uno.ruta,
                                     Lv_tipo,
                                     'SECUENCIA');

      If nvl(pno_control,'0') = '0'  Then
       msg_error_p := 'No genero numero de picking para, a?o: '||to_number(to_char(vv_ano_proce,'YYYY'))||' mes: '||to_number(to_char(vv_mes_proce,'MM'))||' centro: '||pno_centro||' doc: '||Lv_tipo||' tipo: '||'SECUENCIA';
      end if;

end FANUMERO_PICKING;