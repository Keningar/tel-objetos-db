CREATE OR REPLACE procedure NAF47_TNET.CP_ACTUALIZA_DOC_CK(Pv_NoCia  in ARCPHE.NO_CIA%Type,
                                                ptipo_doc in ARCPHE.TIPO_DOC%Type) is

begin

  for Lr_Doc in (SELECT no_cia,
                        tipo_doc,
                        no_docu,
                        no_prove,
                        monto,
                        tipo_refe,
                        no_refe,
                        moneda_refe,
                        monto_refe
                   FROM NAF47_TNET.ARCPRD A
                  where A.no_docu not in
                        (SELECT no_secuencia
                           FROM NAF47_TNET.ARCKRD
                          where tipo_docu = ptipo_doc
                            and NO_CIA = Pv_NoCia)
                    and A.tipo_doc = ptipo_doc
                    and A.NO_CIA = Pv_NoCia) loop

    INSERT INTO NAF47_TNET.arckrd
      (no_cia,
       tipo_docu,
       no_secuencia,
       no_prove,
       monto,
       tipo_refe,
       no_refe,
       moneda_refe,
       monto_refe)
    VALUES
      (Lr_Doc.no_cia,
       Lr_Doc.tipo_doc,
       Lr_Doc.no_docu,
       Lr_Doc.no_prove,
       Lr_Doc.monto,
       Lr_Doc.tipo_refe,
       Lr_Doc.no_refe,
       Lr_Doc.moneda_refe,
       Lr_Doc.monto_refe);

    commit;

  end loop;

  dbms_output.put_line('Proceso terminado satisfactoriamente');
exception
  when others then
    dbms_output.put_line(sqlerrm);

end CP_ACTUALIZA_DOC_CK;
/