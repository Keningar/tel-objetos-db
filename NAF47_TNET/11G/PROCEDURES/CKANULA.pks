CREATE POR REPLACE ROCEDURE NAF47_TNET.CKANULA(
  pno_cia       IN varchar2,
  ptipo_docu    IN varchar2,
  pno_secuencia IN number,
  pno_cta       IN varchar2,
  msg_error_p   IN OUT varchar2
)  IS
  error_proceso EXCEPTION;
BEGIN
  msg_error_p := NULL;
  CKANULA@GPOETNET(pno_cia => pno_cia,
          ptipo_docu => ptipo_docu,
          pno_secuencia => pno_secuencia,
          pno_cta => pno_cta,
          msg_error_p => msg_error_p);

EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := nvl( msg_error_p, 'Error en anulacion');
    ROLLBACK;
  WHEN others THEN
    msg_error_p := nvl( sqlerrm, 'Error en anulacion');
    ROLLBACK;
END CKANULA;
/