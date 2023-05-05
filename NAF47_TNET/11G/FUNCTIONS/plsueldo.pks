create or replace function            plsueldo(pcia in Varchar2, pemple in Varchar2) return number is
  Result number;

Cursor C_Emple is
select ----nivel, sub_nivel,
       1,2,
       sal_bas, nvl(ind_nivel_salarial,'N')
from   arplme
where  no_cia = pcia
and    no_emple = pemple;

Cursor C_Sueldo_Nivel (lv_nivel varchar2, lv_sub_nivel varchar2) is
 SELECT sal_bas
    FROM arplnsal
    WHERE no_cia    = pcia
      AND nivel     = lv_nivel
      AND sub_nivel = lv_sub_nivel;

lv_nivel          arplnsal.nivel%type := null;
lv_sub_nivel      arplnsal.sub_nivel%type := null;
ln_sueldo         arplme.sal_bas%type := null;
ln_sueldo_ns      arplme.sal_bas%type := null;
lv_nivel_salarial arplme.ind_nivel_salarial%type := null;

begin

  Open C_Emple;
  Fetch C_Emple into lv_nivel, lv_sub_nivel, ln_sueldo, lv_nivel_salarial;
  Close C_Emple;

  if lv_nivel_salarial = 'N' then

      Result := ln_sueldo;

  else


      Open C_Sueldo_Nivel (lv_nivel, lv_sub_nivel);
      Fetch C_Sueldo_Nivel into ln_sueldo_ns;
      Close C_Sueldo_Nivel;


      Result := ln_sueldo_ns;

  end if;

  return(Result);

end plsueldo;