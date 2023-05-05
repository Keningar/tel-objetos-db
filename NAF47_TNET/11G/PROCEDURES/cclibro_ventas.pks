create or replace PROCEDURE            cclibro_ventas (
  pNo_cia     IN varchar2,
  pTipo_doc   IN varchar2,
  pNo_docu    IN varchar2,
  pError      OUT varchar2
) IS
  --
  -- Datos del documento.
  CURSOR c_documentos (pcia varchar2, pTipo varchar2, pDocu varchar2) IS
    SELECT mc.nombre,
           mc.codigo_tercero cedula,
           nvl(md.gravado,0) gravado,
           nvl(md.exento,0) exento,
           md.monto_bienes, md.monto_serv, md.monto_exportac,
           md.fecha, md.moneda, md.tipo_cambio
      FROM arccmc mc, arccmd md
     WHERE mc.no_cia     = pCia
       AND mc.no_cia     = md.no_cia
       AND mc.grupo      = md.grupo
       AND mc.no_cliente = md.no_cliente
       AND md.tipo_doc   = pTipo
       AND md.no_docu    = pDocu;
  --
  CURSOR c_Impuestos (pcia varchar2, pTipo varchar2, pDocu varchar2) IS
    SELECT decode(iv.columna, 1, ti.monto, 0) imp1,
           decode(iv.columna, 2, ti.monto, 0) imp2,
           decode(iv.columna, 3, ti.monto, 0) imp3,
           decode(iv.columna, 4, ti.monto, 0) imp4,
           decode(iv.columna, 5, ti.monto, 0) imp5,
           decode(iv.columna, 6, ti.monto, 0) imp6
      FROM arcgimp iv, arccti ti
     WHERE ti.no_cia                 = pCia
       AND ti.no_cia                 = iv.no_cia
       AND ti.tipo_doc               = pTipo
       AND ti.no_docu                = pDocu
       AND ti.clave                  = iv.clave
       AND nvl(iv.ind_retencion,'N') = 'N';
  --
  vReg_Imp  c_impuestos%rowtype;
  vReg_Doc  c_documentos%rowtype;
  vFactor   number;
  vEncontro boolean;
  -- ---
  error_proceso exception;
  --
BEGIN
  pError := NULL;
  OPEN  c_documentos (pNo_Cia, pTipo_Doc, pNo_Docu);
  FETCH c_documentos INTO vReg_Doc;
  vencontro := c_documentos%found;
  CLOSE c_documentos;

  IF vencontro THEN
    OPEN  c_impuestos (pNo_Cia, pTipo_Doc, pNo_Docu);
    FETCH c_impuestos INTO vReg_Imp;

    --
    -- Por ser libros legales, se reportan en moneda nominal, por lo que se deben convertir los montos a
    -- moneda nominal.
    vFactor := 1;
    IF vReg_doc.moneda = 'D' THEN

    	IF vReg_doc.tipo_cambio is null THEN
    		pError := 'El tipo de cambio del documento no puede ser nulo';
    		RAISE error_proceso;
    	END IF;
    	--
    	-- si el documento fue en dolares, se convertira a nominal (multiplicando por el tipo de cambio)
    	vFactor := vReg_doc.tipo_cambio;
    END IF;

    INSERT INTO arcglve (no_cia, codigo_tercero, tipo_doc,
                         no_docu, fecha, punto,
                         nombre,  valor_exp,
                         valor_gravado, valor_exento,
                         monto_bienes, monto_serv,
                         monto_exportac,
                         valor_Imp1,   valor_Imp2, valor_Imp3,
                         valor_Imp4,   valor_Imp5, valor_Imp6,
                         ano,          mes,        total)
                 VALUES (pNo_Cia, vReg_Doc.cedula, pTipo_Doc,
			                   pNo_Docu, vReg_Doc.fecha, 0,
                         vReg_Doc.nombre, 0, (vReg_Doc.gravado * vFactor),
                         (vReg_Doc.exento * vFactor),
                         (vReg_Doc.monto_bienes * vFactor), (vReg_doc.monto_serv * vFactor),
                         (vReg_doc.monto_exportac * vFactor),
                         (nvl(vReg_Imp.imp1,0) * vFactor),  (nvl(vReg_Imp.imp2,0) * vFactor), (nvl(vReg_Imp.imp3,0) * vFactor),
                         (nvl(vReg_Imp.imp4,0) * vFactor),  (nvl(vReg_Imp.imp5,0) * vFactor), (nvl(vReg_Imp.imp6,0) * vFactor),
                         to_number(to_char(vReg_Doc.fecha, 'RRRR')),
                         to_number(to_char(vReg_Doc.fecha, 'MM')),
                         (vReg_Doc.gravado + vReg_Doc.exento +
                         nvl(vReg_Imp.imp1,0) + nvl(vReg_Imp.imp2,0) + nvl(vReg_Imp.imp3,0) +
                         nvl(vReg_Imp.imp4,0) + nvl(vReg_Imp.imp5,0) + nvl(vReg_Imp.imp6,0)) * vFactor);
    CLOSE c_impuestos;
  ELSE
    pError := 'CCLIBRO_VENTAS : No se encontro el documento';
    return;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
       pError := 'CCLIBRO_VENTAS : '||pError;
       return;
  WHEN others THEN
       pError := 'CCLIBRO_VENTAS : '||sqlerrm||' tercero '||vREg_doc.cedula;
       return;
END CCLIBRO_VENTAS;