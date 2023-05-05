create or replace PROCEDURE            AFGENERADEP_CONTA(
 pCia             arcgae.no_cia%type,
 pCodigo_diario   arcgae.cod_diario%type,
 pFecha           arcgae.fecha%type,
 pAno_proce       arcgae.ano%type,
 pMes_proce       arcgae.mes%type,
 pTipo_cambio     arcgae.tipo_cambio%type,
 pAsiento         out arcgae.no_asiento%type,
 pNo_lineas       out number,
 pMsg_error       out varchar2
) IS

  CURSOR  c_lineas_depreciacion IS
		SELECT codigo, tipo, centro_costo,
		      sum(nvl(monto,0)) monto,
		      sum(nvl(monto_dol,0)) monto_dol
		 FROM arafdc_dep
		WHERE no_cia  = pCia
		  AND ind_con = 'P'
		  AND ano     = pAno_proce
		  AND mes     = pMes_proce
		GROUP BY codigo, tipo, centro_costo
		ORDER BY tipo ASC;

	CURSOR c_periodo_conta IS
		SELECT ano_proce, mes_proce
	  	FROM arcgmc
	   WHERE no_cia = pCia;

	--
	--
	vLinea         arcgal.no_linea%type   := 1;
	vTot_debitos   arcgae.t_debitos%type  := 0;
	vTot_creditos  arcgae.t_creditos%type := 0;
	vNo_asiento    arcgae.no_asiento%type;
	vTipo_cambio   arcgal.tipo_cambio%type;
	vEstado        arcgae.estado%type;
	vCentro_costo  arcgal.centro_costo%type;
	vAutorizado    arcgae.autorizado%type;
	vAno_conta     arcgmc.ano_proce%type;
	vMes_conta     arcgmc.mes_proce%type;
	vMensaje       varchar2(250);
	error_proceso  exception;

BEGIN

  --Obtiene el numero de transaccion
  vNo_asiento := transa_id.cg(pCia);

	--Obtiene el periodo en proceso de Contabilidad
	OPEN  c_periodo_conta;
	FETCH c_periodo_conta INTO vAno_conta, vMes_conta;
	CLOSE c_periodo_conta;

  IF (vAno_conta * 100+ vMes_conta) <= (pAno_proce*100+ pMes_proce) THEN
     vEstado     := 'P';
     vAutorizado := 'N';
  ELSE --En caso que el asiento fuera un mes anterior a Contabilidad
     vEstado     := 'O';
     vAutorizado := 'S';
  END IF;

  -- Genera el movimiento hacia Contabilidad
  INSERT INTO arcgae(no_cia,     ano,         mes,              no_asiento,
                     fecha,      estado,      autorizado,       cod_diario,
                     t_camb_c_v, origen,      tipo_comprobante, no_comprobante,
                     anulado,    descri1)
							VALUES(pCia,       pAno_proce,  pMes_proce,       vNo_asiento,
							       pFecha,     vEstado,     'N',              pCodigo_diario,
							       'C',        'AD',        'T',              0,
							       'N',        'DEPRECIACION MENSUAL DE ACTIVO FIJOS');

	FOR i IN c_lineas_depreciacion LOOP

		--Valida que la cuenta acepta centro de costo
		IF cuenta_contable.acepta_cc(pCia, i.codigo) THEN
			 vCentro_costo := i.centro_costo;
		ELSE
		   vCentro_costo := centro_costo.rellenad(pCia,'0');
		END IF;

		--Obtiene y valida el tipo de cambio
		IF i.monto_dol <= 0 THEN
			 pMsg_error := 'Existen montos de dolares menores o iguales que 0';
		   RAISE error_proceso;
		ELSE
		   vTipo_cambio := moneda.redondeo( nvl(i.monto,0) / nvl(i.monto_dol,0), 'P');
		END IF;

		IF vTipo_cambio <= 0 THEN
		   pMsg_error := 'El tipo de cambio es cero o negativo';
		   RAISE error_proceso;
		END IF;

    IF i.tipo = 'D' THEN -- si es debito

		  INSERT INTO arcgal(no_cia,         ano,        mes,         no_asiento,
	                       no_linea,       cuenta,     tipo,        cod_diario,
	                       tipo_cambio,    moneda,     centro_costo,
	                       monto,          monto_dol)
			            VALUES(pCia,           pAno_proce, pMes_proce,  vNo_asiento,
							           vLinea,         i.codigo,   'D',         pCodigo_diario,
			    				       vTipo_cambio,   'P',        vCentro_costo,
			           				 nvl(i.monto,0),  nvl(i.monto_dol,0)  --debitos se guardan positivos
			           				 ); --los valores de ARAFDC_DEP estan redondeados


	    vTot_debitos := moneda.redondeo( nvl(vTot_debitos,0) + nvl(i.monto,0),'P');
	  	vLinea       := nvl(vLinea,0) + 1;

	  ELSIF i.tipo = 'C' THEN  -- si es credito

      INSERT INTO arcgal(no_cia,          ano,        mes,        no_asiento,
                         no_linea,        cuenta,     tipo,       cod_diario,
                         tipo_cambio,     moneda,     centro_costo,
                         monto,           monto_dol)
		 	            VALUES(pCia,            pAno_proce, pMes_proce,  vNo_asiento,
							           vLinea,          i.codigo,   'C',         pCodigo_diario,
							           vTipo_cambio,    'P',        vCentro_costo,
							           -nvl(i.monto,0),  -nvl(i.monto_dol,0) --creditos se guarda negativo
							           );   --Valores de ARAFDC_DEP estan redondeados

      vTot_creditos := moneda.redondeo( nvl(vTot_creditos,0) + nvl(i.monto,0),'P');
      vLinea        := nvl(vLinea,0) + 1;

	  END IF;  -- de tipo

		-- Actualiza los movimientos indicando que ya fue
		-- generado el movimiento contable
		UPDATE arafdc_dep
		  SET ind_con    = 'G',
		      no_asiento = vNo_asiento
		WHERE no_cia       = pCia
		  AND codigo       = i.codigo
		  AND tipo         = i.tipo
		  AND centro_costo = i.centro_costo;

	END LOOP;  -- c_lineas_depreciacion

	IF vLinea > 1 THEN
	 UPDATE arcgae
	    SET t_debitos  = vTot_debitos,
	        t_creditos = vTot_creditos,
	        autorizado = vAutorizado
	  WHERE no_cia     = pCia
	    AND ano        = pAno_proce
	    AND mes        = pMes_proce
	    AND no_asiento = vNo_asiento;

	 pNo_lineas := vLinea;

	ELSE  -- Si no existen lineas, borra el encabezado
		  DELETE arcgae
		   WHERE no_cia     = pCia
	     AND ano        = pAno_proce
	     AND mes        = pMes_proce
	     AND no_asiento = vNo_asiento;
	  pNo_lineas := 0;
	END IF;

	--Actualiza los indicadores a nivel de compa?ia
	UPDATE arafmc
	  SET ind_calculo_dep    = 'S',  --Indica que el asiento de depreciacion se genero
	  															 --y ya no se puede generar otro asiento en el mes
	      ind_depre_generada = 'N'   --Indicador que se puede correr el proceso de
	                                 --Depreciacion
	WHERE no_cia = pCia;

	--Retorna el # de asiento generado
	pAsiento        := vNo_asiento;

EXCEPTION

	WHEN cuenta_contable.error THEN
			 pMsg_error := 'AFGENERADEP_CONTA : '||cuenta_contable.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN centro_costo.error THEN
			 pMsg_error := 'AFGENERADEP_CONTA : '||centro_costo.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN error_proceso THEN
			 pMsg_error := 'AFGENERADEP_CONTA : '||nvl(pMsg_error,vMensaje);
			 ROLLBACK;
			 RETURN;

	WHEN transa_id.error THEN
			 pMsg_error := 'AFGENERADEP_CONTA : '||transa_id.ultimo_error;
			 ROLLBACK;
			 RETURN;

	WHEN others THEN
  		 pMsg_error := 'AFGENERADEP_CONTA : '||sqlerrm;
			 ROLLBACK;
			 RETURN;
END;