create or replace PROCEDURE            FFLIBRO_COMPRAS
 (pNocia        IN VARCHAR2
 ,pNo_docu      IN VARCHAR2
 ,pNo_linea     IN NUMBER
 ,pError        OUT VARCHAR2
 )
 IS

  CURSOR c_documento (pcia VARCHAR2, pno_docu VARCHAR2, pNo_Linea Number)IS
     SELECT dd.tipo_doc, dd.no_docu, dd.Razon_Social nombre,
            dd.transa_id,          dd.moneda, dd.tipo_cambio,
            dd.id_tributario       cedula,
            nvl(dd.grabado,0)      gravado,
            nvl(dd.excento,0)      exento,
            dd.fecha_docu          fecha,
            nvl(dd.monto_bienes,0) monto_bienes,
            nvl(dd.monto_serv,0)   monto_serv,
            dd.no_fisico,
            dd.no_serie,
            dd.no_prove
       FROM taffdd dd
      WHERE dd.no_cia                 = pCia
        AND dd.no_docu                = pNo_docu
        AND dd.No_Linea               = pNo_Linea;

  CURSOR c_Impuesto (pcia VARCHAR2, pTransa VARCHAR2, pNo_Linea Number)IS
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
       FROM arcgimp iv, taffdi ti
      WHERE ti.no_cia                 = pCia
        AND ti.no_cia                 = iv.no_cia
        AND ti.Transa_id              = pTransa
        AND ti.No_linea               = pNo_Linea
        AND ti.clave                  = iv.clave
        AND NVL(iv.ind_retencion,'N') = 'N';

    vImp_Sin_Cred_Fiscal arcpti.monto%type;
    Reg_imp              c_Impuesto%rowtype;
    Reg_doc              c_Documento%rowtype;
    vFactor              taffdd.tipo_cambio%type;
    error_proceso        exception;
    -- ---
    --
    FUNCTION IIF(vsn VARCHAR2, vcond VARCHAR2,
                 vval1 NUMBER, vval2 NUMBER) RETURN NUMBER IS
    BEGIN
      IF vsn = vcond THEN
         RETURN (vval1);
      ELSE
         RETURN (vval2);
      END IF;
    END;
 BEGIN

    pError := NULL;
    OPEN  c_Documento (pNoCia, pno_docu, pNo_Linea);
    FETCH c_Documento INTO Reg_doc;
    IF c_Documento%FOUND THEN

       OPEN  c_impuesto (pNoCia, Reg_doc.transa_id, pNo_Linea);
       FETCH c_impuesto INTO Reg_imp;

       vImp_Sin_Cred_Fiscal := IIF(Reg_Imp.aplica1, 'N', Reg_Imp.imp1, 0) +
                               IIF(Reg_Imp.aplica2, 'N', Reg_Imp.imp2, 0) +
                               IIF(Reg_Imp.aplica3, 'N', Reg_Imp.imp3, 0) +
                               IIF(Reg_Imp.aplica4, 'N', Reg_Imp.imp4, 0) +
                               IIF(Reg_Imp.aplica5, 'N', Reg_Imp.imp5, 0) +
                               IIF(Reg_Imp.aplica6, 'N', Reg_Imp.imp6, 0) ;

		    --
		    -- Por ser libros legales, se reportan en moneda nominal, por lo que se deben convertir los montos a
		    -- moneda nominal.
		    vFactor := 1;
		    IF Reg_doc.moneda = 'D' THEN

		    	IF Reg_doc.tipo_cambio is null THEN
		    		pError := 'El tipo de cambio del documento no puede ser nulo';
		    		RAISE error_proceso;
		    	END IF;
		    	--
		    	-- si el documento fue en dolares, se convertira a nominal (multiplicando por el tipo de cambio)
		    	vFactor := Reg_doc.tipo_cambio;
		    END IF;

           INSERT INTO ARCGLCO (no_cia, id_tributario, tipo_doc,
			        no_docu, fecha, no_prove, nombre,
				Valor_CIF, valor_gravado, valor_exento,
				valor_Imp1,
				valor_Imp2,
				valor_Imp3,
				valor_Imp4,
				valor_Imp5,
				valor_Imp6,
				ano, mes, total,
				no_fisico, serie_fisico,
				monto_bienes, monto_serv)
             VALUES(pNoCia, Reg_doc.cedula, Reg_doc.tipo_doc,
                    Reg_doc.no_docu, Reg_doc.fecha,Reg_doc.no_prove,Reg_doc.nombre,
                     0, Reg_Doc.gravado * vFactor,Reg_doc.exento * vFactor,
                    DECODE(NVL(Reg_Imp.aplica1,'S'),'S', NVL(Reg_Imp.imp1,0), 0 ) * vFactor,
                    DECODE(NVL(Reg_Imp.aplica2,'S'),'S', NVL(Reg_Imp.imp2,0), 0 ) * vFactor,
                    DECODE(NVL(Reg_Imp.aplica3,'S'),'S', NVL(Reg_Imp.imp3,0), 0 ) * vFactor,
                    DECODE(NVL(Reg_Imp.aplica4,'S'),'S', NVL(Reg_Imp.imp4,0), 0 ) * vFactor,
                    DECODE(NVL(Reg_Imp.aplica5,'S'),'S', NVL(Reg_Imp.imp5,0), 0 ) * vFactor,
                    DECODE(NVL(Reg_Imp.aplica6,'S'),'S', NVL(Reg_Imp.imp6,0), 0 ) * vFactor,
                    TO_NUMBER(TO_CHAR(Reg_Doc.fecha, 'RRRR')),
                    TO_NUMBER(TO_CHAR(Reg_Doc.fecha, 'MM')),
                    (Reg_Doc.gravado + Reg_Doc.exento +
                    NVL(Reg_Imp.imp1,0) + NVL(Reg_Imp.imp2,0) + NVL(Reg_Imp.imp3,0) +
                    NVL(Reg_Imp.imp4,0) + NVL(Reg_Imp.imp5,0) + NVL(Reg_Imp.imp6,0))* vFactor,
                    Reg_doc.no_fisico, Reg_doc.no_serie,
                    Reg_doc.monto_bienes * vFactor, Reg_doc.monto_serv * vFactor);
       CLOSE c_impuesto;
       CLOSE c_documento;
    ELSE
       CLOSE c_documento;
       pError := 'No se encontro el documento ! ! !';
    END IF;

EXCEPTION
  WHEN error_proceso THEN
       pError := 'FFLIBRO_COMPRAS : '||pError;
       return;
  WHEN others THEN
       pError := 'FFLIBRO_COMPRAS : '||sqlerrm;
       return;
END FFLIBRO_COMPRAS;