create or replace PROCEDURE            CKACTUALIZA(
  pno_cia       IN varchar2,
  ptipo_docu    IN varchar2,
  pno_secuencia IN number,
  pno_cta       IN varchar2,
  msg_error_p   IN OUT varchar2
)  IS
  error_proceso EXCEPTION;
BEGIN
  msg_error_p := NULL;
  moneda.inicializa(pno_cia);
  IF (ptipo_docu = 'CK') THEN
         CKact_cheq(pno_cia, pno_secuencia, pno_cta, msg_error_p);
  ELSIF (ptipo_docu  = 'TR') THEN
      CKact_tr(pno_cia, pno_secuencia, pno_cta, msg_error_p);
  ELSE
     CKact_om(pno_cia, pno_secuencia, pno_cta, msg_error_p);
  END IF;
  
  if msg_error_p is not null then
    raise error_proceso;
  end if;
  
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := nvl( msg_error_p, 'Error en actualiza');
    ROLLBACK;
  WHEN others THEN
    msg_error_p := nvl( sqlerrm, 'Error en actualiza');
    ROLLBACK;
END CKACTUALIZA;