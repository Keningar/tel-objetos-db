create or replace PROCEDURE            AFGENERAMOV_CONTA(
  pCia             arcgae.no_cia%type,
  pCodigo_diario   arcgae.cod_diario%type,
  pFecha           arcgae.fecha%type,
  pAno_proce       arcgae.ano%type,
  pMes_proce       arcgae.mes%type,
  pTipo_cambio     arcgae.tipo_cambio%type,
  pNo_lineas       out number,
  pAsiento         out arcgae.no_asiento%type,
  pMsg_error       out varchar2

) IS

	CURSOR c_movimientos  IS
		SELECT codigo, tipo,a.centro_costo,
		       a.no_docu, b.tipo_cambio,
		       sum(nvl(a.monto,0)) monto,
		       sum(nvl(a.monto_dol,0)) monto_dol
		 FROM arafdc a, arafhm b
		WHERE a.no_cia  = pCia
		  AND a.ind_con = 'A'
		  AND a.no_cia  = b.no_cia
		  AND a.no_docu = b.no_docu
		  AND a.fecha   = b.fecha
		  AND a.tipo_m  = b.tipo_m
		GROUP BY a.codigo,tipo, a.centro_costo,a.no_docu,b.tipo_cambio
		ORDER BY tipo ASC;

	CURSOR c_periodo_conta IS
		SELECT ano_proce, mes_proce
 		  FROM arcgmc
		 WHERE no_cia = pCia;

	vLin            arcgal.no_linea%type   := 1;
	vTot_debitos    arcgae.t_debitos%type  := 0;
	vTot_creditos   arcgae.t_creditos%type := 0;
	vTipo_cambio    arafhm.tipo_cambio%type;
	vEstado         arcgae.estado%type;
	vCentro_costo   arafdc.centro_costo%type;
	vAutorizado     arcgae.autorizado%type;
	vNo_asiento     arcgae.no_asiento%type;
	vAno_conta      arcgmc.ano_proce%type;
	vMes_conta      arcgmc.mes_proce%type;
	error_proceso   exception;

BEGIN

  OPEN  c_periodo_conta;
  FETCH c_periodo_conta INTO vAno_conta, vMes_conta;
  CLOSE c_periodo_conta;

  IF (vAno_conta * 100+ vMes_conta) <= (pAno_proce*100+ pMes_proce) THEN
    vEstado     := 'P';
    vAutorizado := 'N';
  ELSE
    vEstado     := 'O';
    vAutorizado := 'S';
  END IF;

  --Obtiene el numero de transaccion
  vNo_asiento := transa_id.cg(pCia);

  -- Generar encabezado del movimiento
  INSERT INTO arcgae(no_cia,    ano,              mes,            no_asiento,
                     fecha,     descri1,          estado,         autorizado,
                     t_debitos, t_creditos,       cod_diario,     t_camb_c_v,
                     origen,    tipo_comprobante, no_comprobante, anulado  )
              VALUES(pCia,       pAno_proce,       pMes_proce,     vNo_asiento,
								     pFecha,    'MOVIMIENTOS DE ACTIVOS FIJOS',   vEstado,     'N',
		     						 0,           0,               pCodigo_diario, 'C',
		     						 'AC',       'T',              0,            'N');

  FOR rm in c_movimientos LOOP

    IF cuenta_contable.acepta_cc(pCia,rm.codigo) THEN
       vCentro_costo := rm.centro_costo;
    ELSE
     	vCentro_costo := centro_costo.rellenad(pCia,'0');
    END IF;

    IF (rm.monto_dol <= 0) and  (moneda.redondeo(rm.monto/rm.tipo_cambio,'D') <> 0) THEN
    	 pMsg_error := 'Existen montos de dolares menores que 0';
       RAISE error_proceso;
    END IF;

    IF rm.tipo = 'D' THEN -- si es debito

      INSERT INTO arcgal( no_cia,      ano,        mes,       no_asiento,
												  no_linea,    cuenta,     tipo,      cod_diario,
            		          tipo_cambio, moneda,     centro_costo,
            		          monto,       monto_dol,  no_docu)
	                  VALUES(pCia,       pAno_proce, pMes_proce, vNo_asiento,
	                         vLin,       rm.codigo,  'D',        pCodigo_diario,
	                         rm.tipo_cambio,  'P',    vCentro_costo,
	                         nvl(rm.monto,0),  rm.monto_dol, rm.no_docu);

      vTot_debitos := nvl(vTot_debitos,0) + nvl(rm.monto,0);
      vLin := nvl(vLin,0) + 1;

    ELSE -- si es credito

        INSERT INTO arcgal( no_cia,      ano,    mes,       no_asiento,
		           							no_linea,    cuenta, tipo,      cod_diario,
		            						tipo_cambio, moneda, centro_costo,
		            						monto,       monto_dol, no_docu)
								     VALUES(pCia,           pAno_proce,  pMes_proce,   vNo_asiento,
								            vLin,           rm.codigo,   'C',           pCodigo_diario,
									          rm.tipo_cambio, 'P',         vCentro_costo,
									          nvl(rm.monto,0)*-1, nvl(rm.monto_dol,0)*-1, rm.no_docu);

        vTot_creditos := nvl(vTot_creditos,0) + nvl(rm.monto,0);
        vLin := nvl(vLin,0) + 1;

    END IF;

    -- Actualiza los movimientos indicando que ya fue
    -- generado el movimiento contable
    UPDATE arafdc
       SET ind_con = 'G',
           no_asiento = vNo_asiento
     WHERE no_cia       = pCia
       AND codigo       = rm.codigo
       AND tipo         = rm .tipo
       AND no_docu      = rm.no_docu
       AND centro_costo = rm.centro_costo;

  END LOOP;

   IF vLin > 1 THEN
     UPDATE arcgae
        SET t_debitos  = vTot_debitos,
            t_creditos = vTot_creditos,
            autorizado = vAutorizado
      WHERE no_cia     = pCia
        AND ano        = pAno_proce
        AND mes        = pMes_proce
        AND no_asiento = vNo_asiento;
     pNo_lineas := vLin;

   ELSE  -- Si no existen lineas, borra el encabezado
   	  DELETE arcgae
   	   WHERE no_cia     = pCia
         AND ano        = pAno_proce
         AND mes        = pMes_proce
         AND no_asiento = vNo_asiento;
      pNo_lineas := 0;

   END IF;

   pAsiento   := vNo_asiento;

EXCEPTION
  WHEN cuenta_contable.error THEN
			 pMsg_error := 'AFGENERAMOV_CONTA : '||cuenta_contable.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN centro_costo.error THEN
			 pMsg_error := 'AFGENERAMOV_CONTA : '||centro_costo.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN transa_id.error THEN
			 pMsg_error := 'AFGENERAMOV_CONTA'||transa_id.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN error_proceso THEN
 			 pMsg_error := 'AFGENERAMOV_CONTA'||pMsg_error;
			 ROLLBACK;
			 RETURN;

 WHEN others THEN
     pMsg_error := 'AFGENERAMOV_CONTA'||sqlerrm;
     ROLLBACK;
     RETURN;
END;