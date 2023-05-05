create or replace function            inverifica_conta(Pv_cia     IN Varchar2,
                                            Pv_docu    IN Varchar2,
                                            Pv_mensaje OUT Varchar2) return  Boolean is

--- Verifica que asiento contable exista

Cursor C_Existe Is
 select 'X'
 from   arindc
 where  no_cia = Pv_cia
 and    no_docu = Pv_docu;

--- Verifica que el asiento de inventarios cuadre ANR 26/11/2010

Cursor C_Verif Is
 select nvl(sum(decode(tipo_mov,'D',monto)),0) debitos,
        nvl(sum(decode(tipo_mov,'C',monto)),0) creditos
 from   arindc
 where  no_cia = Pv_cia
 and    no_docu = Pv_docu
 having nvl(sum(decode(tipo_mov,'D',monto)),0) - nvl(sum(decode(tipo_mov,'C',monto)),0) != 0;

 Ln_debitos  Number(17,2);
 Ln_creditos Number(17,2);

 Lv_dummy    Varchar2(1);

begin

  Open C_Existe;
  Fetch C_Existe into Lv_dummy;
  If C_Existe%notfound Then
  Close C_Existe;
      Pv_mensaje :='No se ha generado asiento contable para el No. docu: '||Pv_docu||' Debitos: '||Ln_debitos||' Creditos: '||Ln_creditos;
      return (TRUE);
  else
  Close C_Existe;

      Open C_Verif;
      Fetch C_Verif into Ln_debitos, Ln_creditos;
      If C_Verif%notfound Then
      Close C_Verif;
      return (FALSE);
      else
      Close C_Verif;
      Pv_mensaje :='Hay diferencia en el asiento contable. No. docu: '||Pv_docu||' Debitos: '||Ln_debitos||' Creditos: '||Ln_creditos;
      return (TRUE);
      end if;

  end if;

end inverifica_conta;