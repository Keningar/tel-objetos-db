create or replace PROCEDURE            InCierreDiarioJob IS

  CURSOR C_DATOSJOB IS
  SELECT CD.NO_CIA,CD.CENTRO,CD.NOMBRE, DIA_PROCESO
    FROM ARINCD CD
   ORDER BY 1,2;

  CURSOR C_ACT_MOV_PEND(P_NO_CIA        VARCHAR2,
                        P_CENTRO        VARCHAR2,
                        P_DIA_PROCESO   DATE) IS
  SELECT *
    FROM ARINME
   WHERE NO_CIA   = P_NO_CIA
     AND CENTRO   = P_CENTRO
     AND FECHA    <= P_DIA_PROCESO
     AND ESTADO   = 'P';

  CURSOR ACT_PEND_TRASLA(P_NO_CIA       VARCHAR2,
                         P_CENTRO       VARCHAR2,
                         P_DIA_PROCESO  DATE) IS
  SELECT *
    FROM ARINTE
   WHERE NO_CIA = P_NO_CIA
     AND CENTRO = P_CENTRO
     AND FECHA  <= P_DIA_PROCESO;

  CURSOR ACT_PEND_MANIF(P_NO_CIA        VARCHAR2,
                        P_CENTRO        VARCHAR2,
                        P_DIA_PROCESO   DATE) IS
  SELECT *
    FROM ARINEM
   WHERE NO_CIA = P_NO_CIA
     AND CENTRO = P_CENTRO
     AND FECHA  <= P_DIA_PROCESO;

  CURSOR ACT_PEND_CONSIGNACIONES(P_NO_CIA      VARCHAR2,
                                 P_CENTRO      VARCHAR2,
                                 P_DIA_PROCESO DATE) IS
  SELECT *
    FROM ARINENCCONSIGNACLI
   WHERE NO_CIA = P_NO_CIA
     AND CENTRO = P_CENTRO
     AND FECHA_REGISTRO <= P_DIA_PROCESO
     AND ESTADO = 'P';

  CURSOR ACT_PEND_REORDENPRODUCCION(P_NO_CIA       VARCHAR2,
                                    P_DIA_PROCESO  DATE) IS
  SELECT *
    FROM ARINENCREORDENPRODUCCION
   WHERE NO_CIA = P_NO_CIA
     AND FECHA <=  P_DIA_PROCESO
     AND ESTADO = 'P';

  CURSOR ACT_PEND_CONSUMOINTER(P_NO_CIA       VARCHAR2,
                               P_CENTRO       VARCHAR2,
                               P_DIA_PROCESO  DATE) IS
  SELECT *
    FROM ARINENCCONSUMOINTER G
   WHERE G.NO_CIA = P_NO_CIA
     AND G.CENTRO = P_CENTRO
     AND G.FECHA_REGISTRO <= P_DIA_PROCESO
     AND G.ESTADO = 'P';

  CURSOR C_MOV_PEND(NO_CIA       VARCHAR2,
                    CENTRO       VARCHAR2,
                    DIA_PROCESO  DATE) IS
  SELECT DISTINCT TIPO_DOC
    FROM ARINME
   WHERE NO_CIA   = NO_CIA
     AND CENTRO   = CENTRO
     AND FECHA    <= DIA_PROCESO
     AND ESTADO   = 'P';

  CURSOR PEND_TRASLA(NO_CIA      VARCHAR2,
                     CENTRO      VARCHAR2,
                     DIA_PROCESO DATE) IS
  SELECT 1
    FROM ARINTE
   WHERE NO_CIA = NO_CIA
     AND CENTRO = CENTRO
     AND FECHA  <= DIA_PROCESO;

  CURSOR PEND_MANIF(NO_CIA      VARCHAR2,
                    CENTRO      VARCHAR2,
                    DIA_PROCESO DATE) IS
  SELECT 1
    FROM ARINEM
   WHERE NO_CIA = NO_CIA
     AND CENTRO = CENTRO
     AND FECHA  <= DIA_PROCESO;

  CURSOR C_SEMANA_PROCE(NO_CIA        VARCHAR2,
                        CENTRO        VARCHAR2) IS
  SELECT ANO_PROCE,INDICADOR_SEM,SEMANA_PROCE, mes_proce
    FROM ARINCD
   WHERE NO_CIA = NO_CIA
     AND CENTRO = CENTRO;

  CURSOR C_ULTIMO_DIA(NO_CIA     VARCHAR2,
                      VANO       NUMBER,
                      VINDICADOR VARCHAR,
                      VSEMANA    VARCHAR) Is
  SELECT FECHA2
    FROM CALENDARIO
   WHERE NO_CIA    = NO_CIA
     AND ANO       = VANO
     AND INDICADOR = VINDICADOR
     AND SEMANA    = VSEMANA;

  CURSOR C_VALIDA_EJECUCION(NO_CIA VARCHAR2) IS
  SELECT H.CIERRE_JOB
    FROM ARINMC H
   WHERE H.NO_CIA = NO_CIA;

  CURSOR C_TIPO_DOC(NO_CIA  VARCHAR2,
                    TIP_DOC VARCHAR2) IS
  SELECT B.DESCRI
    FROM ARINVTM B
   WHERE B.NO_CIA = NO_CIA
     AND B.TIPO_M = TIP_DOC;

  CURSOR C_ACT_PEND_SOL_REQ(P_NO_CIA 			VARCHAR2,
													  P_CENTRO 			VARCHAR2,
													  P_DIA_PROCESO DATE) IS
  SELECT *
    FROM INV_CAB_SOLICITUD_REQUISICION G
   WHERE G.NO_CIA = P_NO_CIA
     AND G.CENTRO = P_CENTRO
     AND TRUNC(G.FECHA) <= P_DIA_PROCESO
     AND G.ESTADO = 'P';

  CURSOR C_ARINENCOBSDON (P_NO_CIA 			VARCHAR2,
												  P_CENTRO 			VARCHAR2,
												  P_DIA_PROCESO DATE) IS
  SELECT *
    FROM ARINENCOBSDON G
   WHERE G.NO_CIA = P_NO_CIA
     AND G.CENTRO = P_CENTRO
     AND TRUNC(G.FECHA_SOLIC) <= P_DIA_PROCESO
     AND G.ESTADO = 'P';

  CURSOR C_ARINENCRECLAMO (P_NO_CIA 			VARCHAR2,
												   P_DIA_PROCESO 	DATE) IS
  SELECT *
    FROM ARINENCRECLAMO G
   WHERE G.NO_CIA = P_NO_CIA
     AND TRUNC(G.FECHA) <= P_DIA_PROCESO
     AND G.ESTADO = 'P';

  CURSOR C_ARINENC_SOLICITUD (P_NO_CIA 			 VARCHAR2,
								 						  P_DIA_PROCESO  DATE) IS
  SELECT *
    FROM ARINENC_SOLICITUD G
   WHERE G.NO_CIA 		  = P_NO_CIA
     AND TRUNC(G.FECHA) = P_DIA_PROCESO
     AND G.ESTADO       = 'P';

  CURSOR C_LAST_MES (P_NO_CIA 			VARCHAR2,
										 P_CENTRO 			VARCHAR2,
										 P_MES          NUMBER) IS
  SELECT *
    FROM CALENDARIO
   WHERE NO_CIA = P_NO_CIA
     AND ANO    = P_CENTRO
     AND MES    = P_MES
   ORDER BY 3;

   VULTIMO_DIA_SEMANA    DATE;
   VANO                  ARINCD.ANO_PROCE%TYPE;
   VINDICADOR            ARINCD.INDICADOR_SEM%TYPE;
   VSEMANA               ARINCD.SEMANA_PROCE%TYPE;
   VA_PEND               VARCHAR2(1);
   ENCONTRO              BOOLEAN;
   VREGPEND              C_MOV_PEND%ROWTYPE;
   VMENSAJE              VARCHAR2(80) := NULL;
   LV_MENSAJE            VARCHAR2(2000);
   LD_CIERRE_JOB         DATE;
   LD_HORA_JOB           DATE;
   LV_TIPO_DOC           VARCHAR2(60);
   LV_FECHA_PROCESO      VARCHAR2(12);
   Lv_ano                ARINCD.ANO_PROCE%TYPE;
   Lv_indicador          ARINCD.INDICADOR_SEM%TYPE;
   Lv_semana             ARINCD.SEMANA_PROCE%TYPE;
   LV_ULTIMO_DIA_SEMANA  DATE;
   Lv_error              varchar2(500):=null;
   Ld_fecha1					   date;
   Ld_fecha2					   date;
   Ln_mes                number;

BEGIN

For I in c_datosJob loop
  --recupero los valores del mes y anio del Mantenimiento de compa?ia Pinv100
  open c_valida_ejecucion(i.no_cia);
  fetch c_valida_ejecucion into ld_cierre_job;
  close c_valida_ejecucion;
  ld_hora_job := sysdate;
  lv_fecha_proceso := to_char(i.dia_proceso,'dd/mm/yyyy');

  --pregunto si la hora configurada es igual a la hora de ejecucion del job
  --si se configura a las 21:00  el job intentara ejecutar cada hora
  --cuando encuentre la coincidencia  osea las 21:00 ejecuta este proceso
  if to_char(ld_cierre_job,'hh24') <> to_char(ld_hora_job,'hh24') then
      return;
  end if;

  --FEM desde aqui se modifica 30-01-2009
  	Open c_semana_proce(i.no_cia, i.centro);
  	Fetch c_semana_proce Into Lv_ano,Lv_indicador,Lv_semana,Ln_mes;
  	Close c_semana_proce;

  	Open c_ultimo_dia(i.no_cia, Lv_ano,lv_indicador,lv_semana);
  	Fetch c_ultimo_dia into lv_ultimo_dia_semana;
  	Close c_ultimo_dia;
  	---
  	If lv_fecha_proceso = vultimo_dia_semana Then
      ---
  		in_cierre_fin_semana(i.no_cia, i.centro, lv_fecha_proceso, Lv_error);
      ---
      If Lv_error is not null then
      	lv_mensaje:= Lv_error;
        ---
        InCierreDiario_Mail_Job (pv_novedad     => lv_mensaje,
                                 pv_dia_proceso => lv_fecha_proceso,
                                 pv_compania    => i.no_cia,
                                 pv_centro      => i.centro);
        Return;
        ---
      End if;
  	End If;

    For j in C_last_mes(i.no_cia, i.centro, ln_mes) loop
  	 	If nvl(j.dias_habiles,0) = 6 then
  	 		Ld_fecha1 := j.fecha1;
  	 		Ld_fecha2 := j.fecha2;
  		End If;
    End Loop;

    --En caso de que sea el ultimo viernes del mes y tenga registros pendientes debe de enviar una alerta.
    If lv_fecha_proceso = Ld_fecha2 then
      ---
    	in_cierre_fin_mes(i.no_cia, i.centro, lv_fecha_proceso, Lv_error);
      ---
      If Lv_error is not null then
        ---
      	lv_mensaje:= Lv_error;
        ---
        InCierreDiario_Mail_Job (pv_novedad     => lv_mensaje,
                                 pv_dia_proceso => lv_fecha_proceso,
                                 pv_compania    => i.no_cia,
                                 pv_centro      => i.centro);
        Return;
        ---
      End If;
    End If;

    -- FIN FEM 30-01-2009

	--=========================================
  For j in c_act_mov_pend(i.no_cia,i.centro,i.dia_proceso) loop
    Update arinme
       set fecha = i.dia_proceso + 1
     Where no_cia   = j.no_cia
       and centro   = j.centro
       and fecha    <= i.dia_proceso
       and estado   = 'P';
  End Loop;

  For k in act_pend_trasla(i.no_cia,i.centro,i.dia_proceso) Loop
  	update arinte
       set fecha = i.dia_proceso + 1
     where no_cia = k.no_cia
       and centro = k.centro
       and fecha  <= i.dia_proceso
       and estado = 'P';
  End loop;

  For l in act_pend_manif(i.no_cia,i.centro,i.dia_proceso) Loop
  	Update arinem set fecha = i.dia_proceso + 1
     Where no_cia = l.no_cia
       And centro = l.centro
       And fecha  <= i.dia_proceso;
  End Loop;

  --encabezado de consignaciones
  For m in act_pend_consignaciones (i.no_cia,i.centro,i.dia_proceso) Loop
    Update arinencconsignacli
       set fecha_registro = i.dia_proceso + 1
     where no_cia = m.no_cia
       and centro = m.centro
       and fecha_registro <= i.dia_proceso
       and estado = 'P';
  End Loop;

    --encabezado de reordenamiento de articulos
  For n in act_pend_reordenproduccion (i.no_cia,i.dia_proceso)loop
    Update arinencreordenproduccion
       set fecha = i.dia_proceso + 1
     where no_cia = n.no_cia
       and fecha <= i.dia_proceso
       and estado = 'P';
  End Loop;

    --encabezado de consumo interno
  For o in act_pend_consumointer(i.no_cia,i.centro,i.dia_proceso)loop
    update arinencconsumointer
       set fecha_registro  = i.dia_proceso + 1
     Where no_cia = o.no_cia
       And centro = o.centro
       And fecha_registro  <= i.dia_proceso
       And estado = 'P';
  End Loop;

  For f in C_act_pend_sol_req(i.no_cia,i.centro,i.dia_proceso)loop
    update inv_cab_solicitud_requisicion
       set fecha  = i.dia_proceso + 1
     where no_cia = f.no_cia
       and centro = f.centro
       and trunc(fecha) <= i.dia_proceso
       and estado = 'P';
  End loop;

  For e in C_arinencobsdon(i.no_cia,i.centro,i.dia_proceso)loop
    update arinencobsdon
       set fecha_solic = i.dia_proceso + 1
     where no_cia = e.no_cia
       and centro = e.centro
       and trunc(fecha_solic) <= i.dia_proceso
       and estado = 'P';
  End loop;

  For r in C_arinencreclamo(i.no_cia,i.dia_proceso)loop
    update arinencreclamo
       set fecha  = i.dia_proceso + 1
     where no_cia = r.no_cia
       and trunc(fecha) <= i.dia_proceso
       and estado = 'P';
  End loop;

  For a in C_arinenc_solicitud(i.no_cia,i.dia_proceso) loop
    update arinenc_solicitud
       set fecha  = i.dia_proceso + 1
     where no_cia = a.no_cia
       and trunc(fecha) <= i.dia_proceso
       and estado = 'P';
  End loop;

  Open c_mov_pend(i.no_cia,i.centro,i.dia_proceso);
  Fetch c_mov_pend into vregPend;
  encontro := c_mov_pend%Found;
  Close c_mov_pend;

  IF encontro then
    ---
    Open C_TIPO_DOC(i.no_cia, vregPend.tipo_doc);
    Fetch C_TIPO_DOC into LV_TIPO_DOC;
    Close C_TIPO_DOC;
    ---
  	lv_mensaje:='No se puede cerrar el dia, pues existen movimientos de tipo '||LV_TIPO_DOC ||' pendientes de actualizar '||'Compania '||i.no_cia||' Centro costo '||i.centro||', Intente realizar el cierre manualmente';
    ---
    InCierreDiario_Mail_Job (pv_novedad     => lv_mensaje,
                             pv_dia_proceso => lv_fecha_proceso,
                             pv_compania    => i.no_cia,
                             pv_centro      => i.centro);
  ElSE
    ---
   	Open pend_trasla(i.no_cia,i.centro,i.dia_proceso);
   	Fetch pend_trasla into va_pend;
   	encontro := pend_trasla%found;
   	Close pend_trasla;
    ---
   	If encontro then
   	  lv_mensaje:='Existen traslados pendientes en el centro, deben ser actualizados o borrados antes de efectuar el cierre '||'Compania '||i.no_cia||' Centro costo '||i.centro||', Intente realizar el cierre manualmente';
      InCierreDiario_Mail_Job (pv_novedad     => lv_mensaje,
                               pv_dia_proceso => lv_fecha_proceso,
                               pv_compania    => i.no_cia,
                               pv_centro      => i.centro);

   	else -- no hay traslados pend
   		open pend_manif(i.no_cia,i.centro,i.dia_proceso);
   		fetch pend_manif into va_pend;
   		encontro := pend_manif%found;
   		close pend_manif;

   		If encontro then
   			lv_mensaje:= 'Existen manifiestos pendientes en el centro, deben ser actualizados o borrados antes de efectuar el cierre '||'Compania '||i.no_cia||' Centro costo '||i.centro||', Intente realizar el cierre manualmente';
            InCierreDiario_Mail_Job (pv_novedad     => lv_mensaje,
                                     pv_dia_proceso => lv_fecha_proceso,
                                     pv_compania    => i.no_cia,
                                     pv_centro      => i.centro);
  	  else -- no hay manif pend
				vmensaje:=Val_Cierre(i.no_cia,i.centro);
				If vmensaje is null then
	     		UPDATE ARINME
  	   	    SET ESTADO = 'M'
    	 		 WHERE no_cia = i.no_cia
     	 	     and centro = i.centro
     	   	   and estado = 'D';

    			OPEN  c_semana_proce(i.no_cia,i.centro);
	  			FETCH c_semana_proce INTO vano,vindicador,vsemana,Ln_mes;
	  			CLOSE c_semana_proce;

	  			OPEN  c_ultimo_dia(i.no_cia,vano,vindicador,vsemana);
	  			FETCH c_ultimo_dia INTO vultimo_dia_semana;
	  			CLOSE c_ultimo_dia;

    			IF i.dia_proceso < vultimo_dia_semana THEN
    		 		 		--actualiza el dia de la fecha de inventarios
    			 	  	update arincd
    		   	  	   set dia_proceso = dia_proceso + 1
    		   	  	 where (no_cia = i.no_cia)
    		   	   	   and (centro = i.centro);
          END IF;

          InCierreDiario_Mail_Job (pv_novedad    => lv_mensaje,
                                   pv_dia_proceso => lv_fecha_proceso,
                                   pv_compania   => i.no_cia,
                                   pv_centro => i.centro);
          lv_mensaje:= null;
   				Commit;
   			End If; -- Val cierre
			End If; -- manif pend
		End If; -- traslados pend
End If; -- movs pend
End Loop;
End;