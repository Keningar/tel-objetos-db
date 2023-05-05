create or replace function            Generar_Password(p_length number := 9,p_strength number := 0) return varchar2 is
  passwordEmpleado    varchar2(20) := '';
  vowels              varchar2(10) := 'aeuy';
  consonants          varchar2(50) := 'bdghjmnpqrstvz';
  alt                 number       := mod(to_number(to_char(sysdate,'DDMMYYYYHHMMSS')),2);
BEGIN
    if (p_strength = 1) then
        consonants := consonants||'BDGHJLMNPQRSTVWXZ';
    end if;
  
    if (p_strength = 2) then
        vowels := vowels||'AEUY';
    end if;
  
    if (p_strength = 4) then
        consonants := consonants||'23456789';
    end if;
  
    if (p_strength = 8) then
        consonants := consonants||'@#$%';
    end if;
    
    if (p_strength = 9) then
        consonants := consonants||'23456789'||'@#$%'||'BDGHJLMNPQRSTVWXZ';
        vowels := vowels||'AEUY';
    end if;
    
    select substr(listagg(substr(vowels||consonants, level, 1)) within group(order by dbms_random.value), 1, p_length) into passwordEmpleado from dual connect by level <= p_length;
  
  RETURN passwordEmpleado;
END Generar_Password;