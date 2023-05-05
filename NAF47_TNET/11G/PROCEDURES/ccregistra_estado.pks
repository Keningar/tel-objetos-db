create or replace PROCEDURE            ccregistra_estado(
    pno_cia      in arcche.no_cia%type,
    pno_docu     in arcche.no_docu%type,
    ptipo_doc    in arcche.tipo_doc%type,
    ptipo_estado in arccte.tipo_estado%type,
    pcod_Estado  in out arccte.cod_estado%type
  ) IS
    vEstado  ARCCTE.COD_ESTADO%TYPE;
    --
    cursor c_estado is
      select cod_estado
      from arccte
      where no_cia      = pno_cia
        and tipo_doc    = pTipo_doc
        and tipo_estado = pTipo_estado;
    --
    cursor c_saldo_doc is
      select saldo, cod_estado, rowid
      from arccmd
      where no_cia  = pno_cia
        and no_docu = pno_docu;
    --
    rdoc     c_saldo_doc%rowtype;
  BEGIN
     OPEN c_estado;
     FETCH c_estado INTO vEstado;
     CLOSE c_estado;
     if vEstado IS NOT NULL AND pTipo_estado = 'F' then
        open c_saldo_doc;
        fetch c_saldo_doc into rdoc;
        close c_saldo_doc;
        if rdoc.saldo = 0 and
          (rdoc.cod_estado is null or rdoc.cod_estado != vEstado) then
           update arccmd
             set cod_estado = vestado
             where rowid = rdoc.rowid;
        else
          vEstado := NULL;
        end if;
     end if;
     IF vEstado IS NOT NULL THEN
         INSERT INTO arcche(no_cia, tipo_doc, no_docu,
                            cod_estado, fecha, usuario)
                VALUES(pno_cia, ptipo_doc, pno_docu,
                       vEstado, TRUNC(sysdate), USER);
     END IF;
     pcod_estado := vEstado;
  END; -- ccregistra_estado