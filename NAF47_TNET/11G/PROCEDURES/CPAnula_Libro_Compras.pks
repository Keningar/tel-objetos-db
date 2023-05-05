create or replace PROCEDURE            CPAnula_Libro_Compras(
  pCia             arcpmd.no_cia%type,
  pTipo_doc        arcpmd.tipo_doc%TYPE,
  pNo_Docu         arcpmd.no_docu%TYPE,
  pTipo_doc_anular arcpmd.tipo_doc%TYPE,
  pNo_Docu_anular arcpmd.no_docu%TYPE
) IS
  -- Actualiza el libro de compras si el documento a anular
  -- y el documento de anulacion lo afectan en forma diferente.
  -- Si el documento a anular afecta el libro, y el de anulacion no,
  -- se elimina el doc a anular del libro de compras.
  -- En el otro caso, se elimina el doc de anulacion del libro.

  CURSOR c_afecta_libro(pTipo_doc arcptd.tipo_doc%TYPE) IS
    SELECT nvl(afecta_libro,'N') afecta_libro
      FROM arcptd
     WHERE no_cia   = pCia
       AND tipo_doc = pTipo_doc;

  vDoc_afecta_libro arcptd.afecta_libro%TYPE;
  vAnu_afecta_libro arcptd.afecta_libro%TYPE;
BEGIN
  -- Documento de anulacion
  OPEN  c_afecta_libro(pTipo_doc);
  FETCH c_afecta_libro INTO vDoc_afecta_libro;
  CLOSE c_afecta_libro;

  -- Documento a anular
  OPEN  c_afecta_libro(pTipo_doc_anular);
  FETCH c_afecta_libro INTO vAnu_afecta_libro;
  CLOSE c_afecta_libro;

  IF vDoc_afecta_libro <> vAnu_afecta_libro THEN

    IF vDoc_afecta_libro = 'C' THEN
      -- El documento de anulacion afecta el libro de compras,
      -- pero el doc a anular no.
      -- Eliminar el doc de anulacion del libro de compras
      DELETE FROM arcglco
       WHERE no_cia   = pCia
         AND tipo_doc = pTipo_doc
         AND no_docu  = pNo_docu;

    ELSE -- vDoc_afecta_libro <> 'C'
      -- El documento a anular afecta el libro de compras,
      -- pero el doc de anulacion no.
      -- Eliminar el doc a anular del libro de compras
      DELETE FROM arcglco
       WHERE no_cia   = pCia
         AND tipo_doc = pTipo_doc_anular
         AND no_docu  = pNo_docu_anular;
    END IF;

  END IF;

END CPAnula_Libro_Compras;