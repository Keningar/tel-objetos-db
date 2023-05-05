create or replace PROCEDURE            INACTUALIZA (
  pno_cia      IN naf47_tnet.arinme.no_cia%type,
  ptipo_doc    IN naf47_tnet.arinme.tipo_doc%type,
  pno_docu     IN naf47_tnet.arinme.no_docu%type,
  msg_error_p  IN OUT varchar2
) IS
  --
  error_proceso      exception;
  vtime_stamp        date;
   Lr_Transaccion     NAF47_TNET.ARINME%ROWTYPE;
  --
  
  --
BEGIN
 NAF47_TNET.INACTUALIZA@GPOETNET(pno_cia, ptipo_doc, pno_docu, msg_error_p);
EXCEPTION
  WHEN error_proceso THEN
       msg_error_p := nvl(msg_error_p, 'ERROR: En procedimiento IN_actualiza');
       return;
  WHEN others THEN
       msg_error_p := sqlerrm;
       return;
END;