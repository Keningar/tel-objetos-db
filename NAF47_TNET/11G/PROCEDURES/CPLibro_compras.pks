create or replace PROCEDURE            CPLibro_compras (
  pNo_cia   IN varchar2,
  pNo_prov  IN varchar2,
  pTipo_doc IN varchar2,
  pNo_docu  IN varchar2,
  pError    OUT varchar2
) IS
  --
  -- Datos del documento a registrar en el libro.
  CURSOR c_documentos (pCia  varchar2, pProve varchar2, pTipo varchar2,
                       pDocu varchar2) IS
    SELECT mp.nombre, mp.cedula, mp.codigo_tercero,
           md.no_fisico, md.serie_fisico,
           nvl(md.gravado,0) gravado,
           nvl(md.excentos,0) exento,
           md.monto_bienes, md.monto_serv, md.monto_importac,
           md.fecha, md.numero_ctrl, md.moneda, md.tipo_cambio
      FROM arcpmp mp, arcpmd md
     WHERE mp.no_cia     = pCia
       AND mp.no_cia     = md.no_cia
       AND mp.no_prove   = pProve
       AND mp.no_prove   = md.no_prove
       AND md.tipo_doc   = pTipo
       AND md.no_docu    = pDocu;
  --
  CURSOR c_impuestos (pCia  varchar2, pProve varchar2, pTipo varchar2,
                      pDocu varchar2)IS
    SELECT DECODE(iv.columna, 1, ti.monto, 0) imp1,
           DECODE(iv.columna, 2, ti.monto, 0) imp2,
           DECODE(iv.columna, 3, ti.monto, 0) imp3,
           DECODE(iv.columna, 4, ti.monto, 0) imp4,
           DECODE(iv.columna, 5, ti.monto, 0) imp5,
           DECODE(iv.columna, 6, ti.monto, 0) imp6,
           DECODE(iv.columna, 1, aplica_cred_fiscal) aplica1,
           DECODE(iv.columna, 2, aplica_cred_fiscal) aplica2,
           DECODE(iv.columna, 3, aplica_cred_fiscal) aplica3,
           DECODE(iv.columna, 4, aplica_cred_fiscal) aplica4,
           DECODE(iv.columna, 5, aplica_cred_fiscal) aplica5,
           DECODE(iv.columna, 6, aplica_cred_fiscal) aplica6
      FROM arcgimp iv, arcpti ti
     WHERE ti.no_cia                 = pCia
       AND ti.no_cia                 = iv.no_cia
       AND ti.no_prove               = pProve
       AND ti.tipo_doc               = pTipo
       AND ti.no_docu                = pDocu
       AND ti.clave                  = iv.clave
       AND NVL(iv.ind_retencion,'N') = 'N';
  --
  vImp_Sin_Cred_Fiscal arcpti.monto%type;
  vReg_Imp  c_impuestos%rowtype;
  vReg_Doc  c_documentos%rowtype;
  vFactor   number;
  vEncontro boolean;
  -- ---
  error_proceso exception;
  --
  FUNCTION iif(vsn   varchar2, vcond varchar2,
               vval1 number,   vval2 number) RETURN number IS
  BEGIN
    IF vsn = vcond THEN
      RETURN (vval1);
    ELSE
      RETURN (vval2);
    END IF;
  END;

BEGIN
  pError := NULL;
  OPEN  c_documentos (pNo_cia, pNo_prov, pTipo_doc, pNo_docu);
  FETCH c_documentos INTO vReg_Doc;
  vEncontro := c_documentos%found;
  CLOSE c_documentos;

  IF vEncontro THEN
    OPEN  c_impuestos (pNo_cia, pNo_prov, pTipo_doc, pNo_docu);
    FETCH c_impuestos INTO vReg_Imp;
    vImp_Sin_Cred_Fiscal := iif(vReg_Imp.aplica1, 'N', vReg_Imp.imp1, 0) +
                            iif(vReg_Imp.aplica2, 'N', vReg_Imp.imp2, 0) +
                            iif(vReg_Imp.aplica3, 'N', vReg_Imp.imp3, 0) +
                            iif(vReg_Imp.aplica4, 'N', vReg_Imp.imp4, 0) +
                            iif(vReg_Imp.aplica5, 'N', vReg_Imp.imp5, 0) +
                            iif(vReg_Imp.aplica6, 'N', vReg_Imp.imp6, 0) ;

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


    INSERT INTO arcglco (No_cia, Tipo_Doc, No_Docu, Fecha,
                         No_Prove, Nombre, id_tributario,
                         no_fisico, serie_fisico,
                         Valor_CIF, Valor_Gravado, Valor_Exento,
                         monto_bienes, monto_serv,
                         monto_importac,
                         Valor_Imp1,   Valor_Imp2, Valor_Imp3,
                         Valor_Imp4,   Valor_Imp5, Valor_Imp6,
                         Ano,          Mes,        Total,
                         Codigo_Tercero)
                 VALUES (pNo_cia, pTipo_doc, pNo_docu, vReg_Doc.fecha,
                         pNo_prov, vReg_Doc.nombre, vReg_Doc.cedula,
                         vReg_Doc.no_fisico,    vReg_doc.serie_fisico,
                         0, (vReg_Doc.gravado * vFactor), (vReg_Doc.exento  * vFactor),
                         (vReg_doc.monto_bienes * vFactor), (vReg_doc.monto_serv * vFactor),
                         (vReg_doc.monto_importac * vFactor),
                         (decode(nvl(vReg_Imp.aplica1,'S'),'S', nvl(vReg_Imp.imp1,0), 0 ) * vFactor),
                         (decode(nvl(vReg_Imp.aplica2,'S'),'S', nvl(vReg_Imp.imp2,0), 0 ) * vFactor),
                         (decode(nvl(vReg_Imp.aplica3,'S'),'S', nvl(vReg_Imp.imp3,0), 0 ) * vFactor),
                         (decode(nvl(vReg_Imp.aplica4,'S'),'S', nvl(vReg_Imp.imp4,0), 0 ) * vFactor),
                         (decode(nvl(vReg_Imp.aplica5,'S'),'S', nvl(vReg_Imp.imp5,0), 0 ) * vFactor),
                         (decode(nvl(vReg_Imp.aplica6,'S'),'S', nvl(vReg_Imp.imp6,0), 0 ) * vFactor),
                         to_number(to_char(vReg_Doc.fecha, 'RRRR')),
                         to_number(to_char(vReg_Doc.fecha, 'MM')),
                         (vReg_Doc.gravado + vReg_Doc.exento +
                         nvl(vReg_Imp.imp1,0) + nvl(vReg_Imp.imp2,0) + nvl(vReg_Imp.imp3,0) +
                         nvl(vReg_Imp.imp4,0) + nvl(vReg_Imp.imp5,0) + nvl(vReg_Imp.imp6,0)) * vFactor,
                         vReg_doc.codigo_tercero);
    CLOSE c_impuestos;
  ELSE
    pError := 'ERROR AL INSERTAR EN LIBRO DE COMPRAS : No se encontro el documento ! ! !';
  END IF;
EXCEPTION
  WHEN error_proceso THEN
       pError := 'CPLIBRO_COMPRAS : '||pError;
       return;
  WHEN others THEN
       pError := 'CPLIBRO_COMPRAS : '||sqlerrm;
       return;
END CPLIBRO_COMPRAS;