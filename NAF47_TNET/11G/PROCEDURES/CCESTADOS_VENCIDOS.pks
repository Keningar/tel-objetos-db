create or replace procedure            CCESTADOS_VENCIDOS
( pno_cia      IN arincd.no_cia%type,
  pcentro      IN arincd.centro%type,
  pf_limite    IN DATE,
  pError       IN OUT varchar2
) IS

  vf_ref          date;
  --
  error_proceso   EXCEPTION;
  --
  cursor c_vencidos(pfecha_ref date) is
    select d.no_cia, d.no_docu, d.tipo_doc, d.rowid rowid_md,
           e.cod_estado cod_estado
    from arccmd d, arccte e
    where d.no_cia   = pno_cia
      and d.centro   = pcentro
      and d.saldo    > 0
      and d.fecha_vence < pfecha_ref
      and d.ind_estado_vencido = 'N'
      and d.no_cia      = e.no_cia
      and d.tipo_doc    = e.tipo_doc
      and e.tipo_estado = 'V';
BEGIN

  vf_ref := pf_limite;

  -- registra en la historia de estado los documentos vencidos
  FOR r IN c_vencidos(vf_ref) LOOP

     -- registra el nuevo estado
     INSERT INTO arcche(
                     no_cia, no_docu, tipo_doc, cod_estado,
                     fecha, usuario)
                VALUES(
                     r.no_cia, r.no_docu, r.tipo_doc, r.cod_estado,
                     vf_ref, USER);
     -- --
     -- enciende el indicador de estado vencido
     update arccmd
        set ind_estado_vencido = 'S'
        where rowid = r.rowid_md;

  END LOOP;

EXCEPTION
  WHEN error_proceso THEN
    pError := nvl(pError, 'Error no descrito en CCESTADOS_VENCIDOS');
  WHEN others THEN
    pError := nvl(sqlerrm,'Exception en CCESTADOS_VENCIDOS');
END;