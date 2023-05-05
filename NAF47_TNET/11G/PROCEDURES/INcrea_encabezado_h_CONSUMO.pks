create or replace PROCEDURE            INcrea_encabezado_h_CONSUMO(
  me_rowid_p   IN rowid,
  pmes         IN number,
  psemana      IN number,
  pind_sem     IN varchar2
) IS
BEGIN
   -- Graba el documento en el historico de encabezado de documento
   INSERT INTO arinmeh(no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                       fecha, no_fisico, serie_fisico, conduce,
                       no_prove, tipo_refe, no_refe, serie_refe, moneda_refe_cxp,
                       imp_ventas, descuento, mov_tot,
                       tot_art_iv, observ1, tipo_cambio, no_docu_refe,
                       mes, semana, ind_sem,
                       tipo_doc_d, n_docu_d, origen,
                       fecha_aplicacion, usuario)
                SELECT no_cia, centro, tipo_doc, periodo, '01', no_docu,
                       fecha_registro , no_fisico , null, null,
                       null, null, null, null, null,
                       null, null, null,
                       null, observacion , null, no_docu,
                       TO_CHAR(fecha_registro,'MM'), null, null,
                       tipo_doc, nO_docu, 'IN',
                       sysdate, user
                  FROM arinencconsumointer
                 WHERE rowid  = me_rowid_p;

END;