create or replace PROCEDURE            CPLIBRO_HONORARIOS (
  pNo_cia   IN varchar2,
  pNo_prov  IN varchar2,
  pTipo_doc IN varchar2,
  pNo_docu  IN varchar2,
  pMoneda   IN varchar2,
  pError    OUT varchar2
) IS
  --
  -- Datos del documento a registrar en el libro.
  CURSOR c_documentos (pCia  varchar2, pProve varchar2,
                       pTipo varchar2, pDocu  varchar2) IS
    SELECT mp.nombre, mp.cedula, mp.codigo_tercero,
           md.no_fisico, md.serie_fisico,
           nvl(md.monto,0) monto, substr(md.detalle, 1,80) detalle,
           md.fecha, md.tipo_cambio,
           to_char(fecha,'mm') mes, to_char(fecha,'yyyy') anno
      FROM arcpmp mp, arcpmd md
     WHERE mp.no_cia     = pCia
       AND mp.no_prove   = pProve
       AND md.tipo_doc   = pTipo
       AND md.no_docu    = pDocu
       AND mp.no_cia     = md.no_cia
       AND mp.no_prove   = md.no_prove;

  reg_doc       c_documentos%rowtype;
  vEncontro     boolean;
  error_proceso exception;

BEGIN
  pError := NULL;
  OPEN  c_documentos (pNo_cia, pNo_prov, pTipo_doc, pNo_docu);
  FETCH c_documentos INTO reg_doc;
  vEncontro := c_documentos%found;
  CLOSE c_documentos;
  IF NOT vEncontro THEN
  	pError := 'El documento '||pNo_docu||' no esta defindio';
  	RAISE error_proceso;
  END IF;

  INSERT INTO arcglho (no_cia, no_docu, no_fisico, serie_fisico,
		       ano, mes, fecha,
     		       cod_interno, nombre, detalle,
    		       monto_bruto, porc_reten, monto_reten, monto_neto,
    		       origen, id_tributario, codigo_tercero)
               VALUES (pNo_cia, pNo_docu, reg_doc.no_fisico, reg_doc.serie_fisico,
                       reg_doc.anno, reg_doc.mes, reg_doc.fecha,
                       0, reg_doc.nombre, nvl(reg_doc.detalle,' . '),
                       reg_doc.monto, 0, 0, reg_doc.monto,
                       'CP', reg_doc.cedula, reg_doc.codigo_tercero);


EXCEPTION
  WHEN error_proceso THEN
       pError := 'CPLIBRO_HONORARIOS : '||pError;
       return;
  WHEN others THEN
       pError := 'CPLIBRO_HONORARIOS : '||sqlerrm;
       return;
END CPLIBRO_HONORARIOS;