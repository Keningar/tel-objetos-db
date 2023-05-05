create or replace procedure GRABA_LOG(pv_app varchar2, pdata long) is
begin
  insert into tabla_log values(pv_app, pdata);
  commit;
end GRABA_LOG;
