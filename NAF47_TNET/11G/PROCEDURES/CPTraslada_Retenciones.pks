create or replace PROCEDURE            CPTraslada_Retenciones (
  pCia         arcpmd.no_cia%type,
  pNo_Prove    arcpmd.no_prove%TYPE,
  pTipo_Doc    arcpmd.tipo_doc%TYPE,
  pNo_Docu     arcpmd.no_docu%TYPE,
  pTipo_Cambio arcpmd.tipo_cambio%TYPE
) IS
  --
  -- Retenciones incluidas - Guatemala.
  -- Copia las retenciones incluidas de un documento
  -- de ARCPTI a ARCBBO. El estado de la boleta queda en NULL
  -- hasta que se genere la nota de retencion.
  -- El monto y la base deben pasarse en Nominal.
  --
BEGIN
  INSERT INTO arcbbo(no_cia, no_prove, no_docu, clave, porcentaje,
                     no_fisico, serie_fisico, concepto,
                     monto, base, estatus_boleta)
  SELECT a.no_cia, a.no_prove, a.no_docu, a.clave, a.porcentaje,
         b.no_fisico, b.serie_fisico, b.concepto,
         decode(c.tipo_mov, 'D', -1, 1)*decode(b.moneda, 'P', a.monto, moneda.redondeo(a.monto*pTipo_Cambio, 'D')),
         decode(b.moneda, 'P', a.base,  moneda.redondeo(a.base*pTipo_Cambio, 'D')),
         NULL
    FROM arcpti a, arcpmd b, arcptd c
   WHERE a.no_cia         = pCia
     AND a.no_docu        = pNo_docu
     AND a.ind_imp_ret    = 'R'
     AND a.comportamiento = 'I'
     AND b.no_cia         = a.no_cia
     AND b.no_docu        = a.no_docu
     AND c.no_cia         = b.no_cia
     AND c.tipo_doc       = b.tipo_doc;
END CPTraslada_Retenciones;