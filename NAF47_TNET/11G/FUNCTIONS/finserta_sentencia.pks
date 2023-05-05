create or replace function finserta_sentencia(forma in varchar2, sentencia in varchar2) return number  is
  
begin
    insert into trc_forma_select (FORMA, DATA)
    values (forma, sentencia);
    commit;
  return 1;  
end finserta_sentencia;
