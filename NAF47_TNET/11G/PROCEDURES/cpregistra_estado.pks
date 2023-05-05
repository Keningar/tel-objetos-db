create or replace PROCEDURE            cpregistra_estado(
    pno_cia      in     ARCPHE.NO_CIA%Type,
    pNo_Prove    in     ARCPHE.NO_PROVE%Type,
    pno_docu     in     ARCPHE.NO_DOCU%Type,
    ptipo_doc    in     ARCPHE.TIPO_DOC%Type,
    ptipo_estado in     ARCPTE.TIPO_ESTADO%TYPE,
    pcod_Estado  in out ARCPHE.COD_ESTADO%Type
  ) IS
    Cursor c_Saldo (
                      pCia      in     ARCPHE.NO_CIA%Type,
                      pProve    in     ARCPHE.NO_PROVE%Type,
                      pDocu     in     ARCPHE.NO_DOCU%Type,
                      pTipo     in     ARCPHE.TIPO_DOC%Type) IS
             Select Saldo, cod_estado, rowid rowid_md
               From arcpmd
              Where No_Cia   = pCia
                And No_Prove = pProve
                And No_Docu  = pDocu
                And Tipo_Doc = pTipo;
    cursor c_estado(pcia         in varchar2,
                    pTipo_doc    in varchar2,
                    pTipo_estado in varchar2) is
             select cod_estado
               from arcpte
              where no_cia      = pCia
                and tipo_doc    = pTipo_doc
                and tipo_estado = pTipo_estado;
    vEstado  ARCPTE.COD_ESTADO%TYPE;
    rdoc     c_saldo%rowtype;
  BEGIN
     OPEN  c_estado(pno_cia, ptipo_doc, ptipo_estado);
     FETCH c_estado INTO vEstado;
     CLOSE c_estado;
     IF vEstado IS NOT NULL AND pTipo_Estado = 'F' THEN
        Open  c_Saldo (pno_cia, pNo_prove, pNo_Docu, pTipo_Doc);
        Fetch c_Saldo INTO rdoc;
        Close c_Saldo;
        IF rdoc.saldo = 0 and
           (rdoc.cod_estado is null or rdoc.cod_estado != vEstado) then
           update arcpmd
              set cod_estado = vEstado
            Where RowID = rdoc.RowId_Md;
        else
           vEstado := NULL;
        end if;
     END IF;
     IF vEstado IS NOT NULL THEN
         INSERT INTO arcphe(no_cia,      No_Prove,       tipo_doc,      no_docu,
                            cod_estado,  fecha,          usuario)
                     VALUES(pno_cia,     pNo_Prove,      ptipo_doc,     pno_docu,
                            vEstado,     TRUNC(sysdate), USER);
     END IF;
     pCod_Estado := vEstado;
  END; -- registra_estado