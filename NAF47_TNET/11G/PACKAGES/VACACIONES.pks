CREATE OR REPLACE PACKAGE            VACACIONES AS
  -- ---
  --  El paquete Vacaciones contiene los procedimientos y funciones
  --  necesarios para el manejo y control de vacaciones.
  --


  -- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente de aumento de vacaciones.
  PROCEDURE aumenta(
    pCia    			in arplvac.no_cia%type,
    pNo_emple 		in arplvac.no_emple%type,
    pDias_vac 		in arplvac.dias_normales%type,
    pPeriodo 		  in arplvac.periodo%type default 0,
    pFecha    	  in date,
    pTipo_accion 	in arplvac.tipo_a%type,
    pNo_accion   	in arplvac.no_accion%type
 ) ;
  --
  --
 	-- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente de disminucion de vacaciones.
  PROCEDURE disminuye(
    pCia    			in arplvac.no_cia%type,
    pNo_emple  		in arplvac.no_emple%type,
    pDias_vac  		in arplvac.dias_normales%type,
    pPeriodo    	in arplvac.periodo%type,
    pFecha        in date,
    pTipo_accion  in arplvac.tipo_a%type,
    pNo_accion    in arplvac.no_accion%type
  ) ;
  --
  --
  -- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente que permite registrar vacaciones
	-- al cierre de la Nomina
  PROCEDURE registra (
		pOrigen    in arplvac.no_cia%type,
		pCia       in arplvac.no_emple%type,
		pFecha     in date,
            pCod_pla   in arplcp.codpla%type default null
	) ;

  -- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente que permite borrar registros de vacaciones
  PROCEDURE borrado(
	  pCia      in arplvac.no_cia%type,
		pNo_emple in arplvac.no_emple%type,
		pPeriodo  in arplvac.periodo%type,
		pDias     in arplvac.dias_normales%type
	) ;

  --Este procedimiento aumenta el numero de dias de vacaciones
  -- establecido para el empleado de manera mensual
  PROCEDURE aumenta_mensual(
    pNo_cia 			arplvac.no_cia%type,
    pNo_emple 		arplvac.no_emple%type,
    pDias_vac 		arplvac.dias_normales%type,
    pPeriodo 		  arplvac.periodo%type default 0,
    pF_inicio    	date,
    pTipo_a      	arplvac.tipo_a%type,
    pNo_accion   	arplvac.no_accion%type
 );
  --
  --
  --Este procedimiento disminuye el numero de dias de vacaciones
  --para el empleado de manera mensual
  PROCEDURE disminuye_mensual(
    pNo_cia  			arplvac.no_cia%type,
    pNo_emple  		arplvac.no_emple%type,
    pDias_vac  		arplvac.dias_normales%type,
    pPeriodo_vac 	arplvac.periodo%type,
    pFec_ini      date,
    pTipo_a       arplvac.tipo_a%type,
    pNo_accion    arplvac.no_accion%type
  );
  --
  --
  --Este procedimiento permite registrar vacaciones mensualemente al cierre de la Nomina
  PROCEDURE registra_mensual (
   pOrigen     in varchar2,
   pCia        in varchar2,
   pFecha_ref  in date,
   pCod_pla    in varchar2 default null
  );
  --
  -- Este procedimiento permite borrar un registro de vacaciones
  PROCEDURE borrado_mensual(
		pCia      in arplvac.no_cia%type,
		pNo_emple in arplvac.no_emple%type,
		pPeriodo  in arplvac.periodo%type,
		pDias     in arplvac.dias_normales%type
	);


  --Este procedimiento aumenta el numero de dias de vacaciones establecido
  --para el empleado de manera anual
  PROCEDURE aumenta_anual(
	   pNo_cia	    arplvac.no_cia%type,
	   pNo_emple	  arplvac.no_emple%type,
	   pDias_vac	  arplvac.dias_normales%type,
	   pF_inicio    date,
	   pTipo_a      arplvac.tipo_a%type,
	   pNo_accion   arplvac.no_accion%type
	);
  --
  --
  --Este procedimiento disminuye el numero de dias de vacaciones
  --para el empleado de manera anual
  PROCEDURE disminuye_anual(
	   pNo_cia	     arplvac.no_cia%type,
	   pNo_emple	   arplvac.no_emple%type,
	   pDias_vac	   arplvac.dias_normales%type,
	   pFec_ini      date,
	   pTipo_a       arplvac.tipo_a%type,
	   pNo_accion    arplvac.no_accion%type
	 );
  --
  --
  --Este procedimiento permite registrar vacaciones anualmente al cierre de la Nomina
  PROCEDURE registra_anual (
    pOrig	   in varchar2,
    pNo_cia	   in arplvac.no_cia%type,
    pFecha_ref in date,
    pCod_pla   in varchar2 default null
  );

  --Este procedimiento permite borrar un registro de vacaciones
	PROCEDURE borrado_anual(
		pCia         in arplvac.no_cia%type,
		pNo_emple    in arplvac.no_emple%type,
		pPeriodo     in arplvac.periodo%type,
		pDias        in arplvac.dias_normales%type
	) ;

  --Retorna la cantidad de dias que acumula el empleado por mes
  FUNCTION cantidad_dias_acumula(
   pNo_cia	    in arplvac.no_cia%type,
   pNo_emple	  in arplvac.no_emple%type,
   pFecha_refe  in date
 ) RETURN NUMBER;

  --
  --
  FUNCTION ultimo_error RETURN VARCHAR2 ;
  --
  error           EXCEPTION;
  PRAGMA          EXCEPTION_INIT(error, -20038);
  kNum_error      NUMBER := -20038;

END;  -- Vacaciones
/


CREATE OR REPLACE PACKAGE BODY            VACACIONES AS
--  El paquete Vacaciones contiene los procedimientos y funciones
--  necesarios para el manejo y control de vacaciones.

/*******[ PARTE: PRIVADA ]  ****************
* Declaracion de Procedimientos o funciones PRIVADOS
*/
	vMensaje_error       VARCHAR2(160);
	PROCEDURE limpia_error IS
	BEGIN
	  vMensaje_error := NULL;
	END;
	--
	PROCEDURE genera_error(msj_error IN VARCHAR2)IS
	BEGIN
	  vMensaje_error := substr(msj_error,1,160);
	  RAISE_APPLICATION_ERROR(kNum_error, msj_error);
	END;


	--
	/*******[ PARTE: PUBLICA ] *************************
	* Declaracion de Procedimientos o funciones PUBLICAS
	*
	*/
	--
	FUNCTION ultimo_error RETURN VARCHAR2 IS
	BEGIN
	 RETURN(vMensaje_error);
	END ultimo_error;

	--
	--
	-- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente de aumento de vacaciones.
	PROCEDURE aumenta(
		pCia    	in arplvac.no_cia%type,
		pNo_emple 	in arplvac.no_emple%type,
		pDias_vac 	in arplvac.dias_normales%type,
		pPeriodo 	in arplvac.periodo%type default 0,
		pFecha    	in date,
		pTipo_accion 	in arplvac.tipo_a%type,
		pNo_accion   	in arplvac.no_accion%type
	) IS
	CURSOR c_acumula_vacaciones IS
		SELECT tipo_acumula_vacac
 		  FROM arplmc
		 WHERE no_cia = pCia;

	  vAcumula arplmc.tipo_acumula_vacac%type;
	BEGIN
		OPEN  c_acumula_vacaciones;
		FETCH c_acumula_vacaciones INTO vAcumula;
		CLOSE c_acumula_vacaciones;

		IF vAcumula = 'M' THEN
			aumenta_mensual(pCia, pNo_emple, pDias_vac, pPeriodo,
			                pFecha, pTipo_accion,pNo_accion);
		ELSIF vAcumula = 'A' THEN
			aumenta_anual(pCia, pNo_emple,  pDias_vac,
			              pFecha, pTipo_accion, pNo_accion);
		END IF;
	END;

	--
	--
	-- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente de disminucion de vacaciones.
	PROCEDURE disminuye(
		pCia          in arplvac.no_cia%type,
		pNo_emple     in arplvac.no_emple%type,
		pDias_vac     in arplvac.dias_normales%type,
		pPeriodo      in arplvac.periodo%type,
		pFecha        in date,
		pTipo_accion  in arplvac.tipo_a%type,
		pNo_accion    in arplvac.no_accion%type
	) IS

	CURSOR c_acumula_vacaciones IS
		SELECT tipo_acumula_vacac
		  FROM arplmc
		 WHERE no_cia = pCia;

	  vAcumula arplmc.tipo_acumula_vacac%type;

	BEGIN
		OPEN  c_acumula_vacaciones;
		FETCH c_acumula_vacaciones INTO vAcumula;
		CLOSE c_acumula_vacaciones;

		IF vAcumula = 'M' THEN
			 disminuye_mensual(pCia, pNo_emple, pDias_vac, pPeriodo,
			                   pFecha, pTipo_accion, pNo_accion);
		ELSIF vAcumula = 'A' THEN
			disminuye_anual(pCia, pNo_emple, pDias_vac,
			                pFecha, pTipo_accion, pNo_accion);
		END IF;
	END;

	--
	-- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente que permite registrar vacaciones
	-- al cierre de la Nomina.
      PROCEDURE registra (
	  pOrigen    in arplvac.no_cia%type,
	  pCia       in arplvac.no_emple%type,
	  pFecha     in date,
	  pCod_pla   in arplcp.codpla%type default null
	) IS
        --
        CURSOR c_acumula_vacaciones IS
	    SELECT tipo_acumula_vacac
 		FROM arplmc
	     WHERE no_cia = pCia;
	  --
	  vAcumula arplmc.tipo_acumula_vacac%type;
	BEGIN
	  OPEN  c_acumula_vacaciones;
	  FETCH c_acumula_vacaciones INTO vAcumula;
	  CLOSE c_acumula_vacaciones;
	  IF vAcumula = 'M' THEN
	    registra_mensual(pOrigen, pCia, pFecha, pCod_pla);
	  ELSIF vAcumula = 'A' THEN
	    registra_anual(pOrigen, pCia, pFecha, pCod_pla);
	  END IF;
	END;

	-- Este procedimiento determina si las vacaciones se acumulan anual o mensualmente
	-- y llama al procedimiento correspondiente que permite registrar vacaciones
	-- al cierre de la Nomina
      PROCEDURE borrado (
		pCia      in arplvac.no_cia%type,
		pNo_emple in arplvac.no_emple%type,
		pPeriodo  in arplvac.periodo%type,
		pDias     in arplvac.dias_normales%type
	) IS

	CURSOR c_acumula_vacaciones IS
		SELECT tipo_acumula_vacac
 		  FROM arplmc
		 WHERE no_cia = pCia;

	 vAcumula arplmc.tipo_acumula_vacac%type;
	BEGIN
		OPEN  c_acumula_vacaciones;
		FETCH c_acumula_vacaciones INTO vAcumula;
		CLOSE c_acumula_vacaciones;
		IF vAcumula = 'M' THEN
		   borrado_mensual(pCia, pNo_emple, pPeriodo,	pDias);
		ELSIF vAcumula = 'A' THEN
		   borrado_anual(pCia, pNo_emple, pPeriodo,	pDias);
		END IF;
	END;

  --------------------------------------
  --   PROCEDIMIENTOS MENSUALES
  --------------------------------------
	PROCEDURE aumenta_mensual(
		pNo_cia	     arplvac.no_cia%type,
		pNo_emple	   arplvac.no_emple%type,
		pDias_vac	   arplvac.dias_normales%type,
		pPeriodo 		 arplvac.periodo%type default 0,
		pF_inicio    date,
		pTipo_a      arplvac.tipo_a%type,
		pNo_accion   arplvac.no_accion%type
	) IS

	--
	vDias_vac		 arplvac.dias_normales%type;
	vPeriodo 		 arplvac.periodo%type;
	vFecha_ing   arplme.f_ingreso%type;

	-- Selecciona el periodo de vacaciones actual del empleado
	CURSOR c_periodo_proceso IS
	  SELECT max(periodo)
	    FROM arplpervac
	   WHERE no_cia   = pNo_cia
	     AND no_emple = pNo_emple ;

	CURSOR c_datos IS
		SELECT f_ingreso
		  FROM arplme
		 WHERE no_cia   = pno_cia
		   AND no_emple = pno_emple;

	BEGIN

	  vDias_vac := nvl(pDias_vac,0);
	  vperiodo  := pPeriodo;

	  IF vperiodo = 0 THEN
		OPEN  c_periodo_proceso;
		FETCH c_periodo_proceso INTO vPeriodo;
		CLOSE c_periodo_proceso;
	  END IF;

	 IF vPeriodo is null or vPeriodo = 0 THEN
		-- es un empleado nuevo y se le otorgan vacaciones adicionales
		OPEN  c_datos;
		FETCH c_datos INTO vfecha_ing;
		CLOSE c_datos;

		IF vFecha_ing is null THEN
		   vacaciones.genera_error('El empleado no tiene expediente de vacaciones y no se encuentra la fecha de ingreso.');
		END IF;
	 	vPeriodo := to_number(to_char(vfecha_ing,'YYYY'));
          END IF;

	  INSERT INTO arplvac(no_cia, no_emple, fecha_mov,
	                    origen, tipo_mov, tipo_a,
	                    no_accion, dias_normales, gestion, periodo)
	           VALUES(pNo_cia, pNo_emple, pF_inicio,
	                  'H', '+', pTipo_a, pNo_accion,
	                  vDias_vac, pF_inicio, vPeriodo);
	END;-- aumenta_mensual

        ---
        --
	PROCEDURE disminuye_mensual(
		pNo_cia	      arplvac.no_cia%type,
		pNo_emple     arplvac.no_emple%type,
		pDias_vac     arplvac.dias_normales%type,
		pPeriodo_vac  arplvac.periodo%type,
		pFec_ini      date,
		pTipo_a       arplvac.tipo_a%type,
		pNo_accion    arplvac.no_accion%type
	) IS

	vDias_vac	  arplvac.dias_normales%type;
	vperiodo 		arplvac.periodo%type;

	BEGIN

	  vDias_vac := nvl(pDias_vac,0);
	  vperiodo  := pPeriodo_vac;

	  IF vDias_vac <= 0 or nvl(vperiodo,0)=0 THEN
	    vacaciones.genera_error('La cantidad de dias a disminuir es cero o no se especifico el periodo.');
	  END IF;

		INSERT INTO arplvac(no_cia, no_emple, fecha_mov,
		                    origen, tipo_mov, tipo_a,
		                    no_accion, dias_normales, gestion, periodo)
		            VALUES(pNo_cia, pNo_emple, pFec_ini,
		                   'H','-', pTipo_a, pNo_accion,
		                   vDias_vac, pFec_ini, vperiodo);
	END; --disminuye_mensual

      --
      --
      PROCEDURE registra_mensual (
	  pOrigen    in varchar2,
	  pCia       in varchar2,
	  pFecha_ref in date,
	  pCod_pla   in varchar2 default null
	) IS
	  --
	  -- Este procedimiento registra las vacaciones de los empleados por mes.
	  -- Unicamente lo usara el modulo de Planillas en el cierre (FPL4022).  Los otros
	  -- movimientos como disfrute de vacaciones o aumentos se haran a traves
	  -- de otros procedimientos.

        CURSOR c_empleados IS
	    SELECT me.no_emple, me.f_ingreso
		FROM arplme me, arplcp cp
	     WHERE me.no_cia      = pCia
		 AND me.estado_prop = 'A'
		 AND cp.no_cia      = me.no_cia
		 AND cp.tipo_emp    = me.tipo_emp
		 AND cp.codpla      = nvl(pCod_pla, cp.codpla);

        CURSOR c_saldo_ult_periodo (pc_no_emple in varchar2)IS
	    SELECT periodo, dias_ganados
		FROM arplpervac
	     WHERE no_cia   = pCia
		 AND no_emple = pc_no_emple
		 AND periodo IN (SELECT max(periodo)
		                   FROM arplpervac
		                  WHERE no_cia   = pCia
		                    AND no_emple = pc_no_emple ) ;

        CURSOR c_ult_gestion (pc_no_emple in varchar2, p_periodo in number) IS
		SELECT gestion
		  FROM arplvac
		 WHERE no_cia   = pCia
		   AND no_emple = pc_no_emple
		   AND origen   = 'P'
		   AND gestion IN (SELECT max(gestion)
		                     FROM arplvac
		                    WHERE no_cia   = pCia
		                      AND no_emple = pc_no_emple
		                      AND periodo  = p_periodo
		                      AND origen   = 'P' ) ;

		v_ult_gestion   date;
		v_periodo       arplpervac.periodo%type;
		v_dias_ganados  arplpervac.dias_ganados%type;
		v_meses         number(3);
		v_dias_vac      number(5,2);
		vEncontro       boolean;
		vfecha_ini_per	arplme.f_ingreso%type; -- fecha de inicio del periodo actual de vacaciones.

	BEGIN

		FOR me IN c_empleados LOOP

			-- obtiene los datos del ultimo periodo de vacaciones
			v_periodo:= null;
			v_dias_ganados := null;
			OPEN  c_saldo_ult_periodo(me.no_emple);
			FETCH c_saldo_ult_periodo INTO v_periodo, v_dias_ganados;
			vEncontro := c_saldo_ult_periodo%found;
			CLOSE c_saldo_ult_periodo;

			IF not vEncontro THEN-- quiere decir que el empleado es nuevo
				v_periodo     := to_number(to_char(me.f_ingreso,'YYYY'));
				v_ult_gestion := me.f_ingreso;
			ELSE -- revisa la ultima fecha de gestion que tuvo.
				OPEN  c_ult_gestion (me.no_emple, v_periodo);
				FETCH c_ult_gestion into v_ult_gestion;
				CLOSE c_ult_gestion;
			END IF;

			-- construye la fecha de inicio del periodo de vacaciones.
			IF to_char(me.f_ingreso,'DDMM') = '2902' THEN
			  vFecha_ini_per := last_day(to_date('0102'||to_char(v_periodo),'DDMMYYYY'));
			ELSE
			  vfecha_ini_per := to_date(to_char(me.f_ingreso,'DDMM')||to_char(v_periodo),'DDMMYYYY');
			END IF;

			v_meses := months_between(pFecha_ref, v_ult_gestion);

			IF v_meses >= 1 THEN -- Debe registrar nuevas vacaciones.

				v_dias_vac := cantidad_dias_acumula(pCia, me.no_emple, pFecha_ref);

				v_ult_gestion := add_months(v_ult_gestion,1);

				IF abs(months_between(v_ult_gestion, vfecha_ini_per)) >= 12 THEN
				  v_periodo := v_periodo + 1;
			  END IF;

			  INSERT INTO arplvac (no_cia, no_emple, gestion, fecha_mov,
			                       origen,tipo_mov, dias_normales, periodo)
			                VALUES(pCia, me.no_emple, v_ult_gestion, pFecha_ref,
			                       'P', '+', v_dias_vac, v_periodo);

		  END IF; --v_meses >= 1

	 END LOOP;

	END; -- registra_mensual
      --
      --
      PROCEDURE borrado_mensual(
	  pCia      in arplvac.no_cia%type,
        pNo_emple in arplvac.no_emple%type,
	  pPeriodo  in arplvac.periodo%type,
	  pDias     in arplvac.dias_normales%type
	) IS

	BEGIN
 	 UPDATE arplvac
	    SET dias_normales = dias_normales - nvl(pDias,0)
	  WHERE no_cia   = pCia
	    AND no_emple = pNo_emple
	    AND periodo  = pPeriodo
	    AND origen   = 'H'
	    AND tipo_mov = '-'
	    AND dias_normales <> 0
	    AND rownum = 1;
	END; --borrado_mensual


      --------------------------------------
      --   PROCEDIMIENTOS ANUALES
      --------------------------------------
      --
      --
	PROCEDURE aumenta_anual(
		pNo_cia	     arplvac.no_cia%type,
		pNo_emple	   arplvac.no_emple%type,
		pDias_vac	   arplvac.dias_normales%type,
		pF_inicio    date,
		pTipo_a      arplvac.tipo_a%type,
		pNo_accion   arplvac.no_accion%type
	) IS


	--
 	vDias_vac    arplvac.saldo_normales%type;
	vDias	     arplvac.saldo_normales%type;

	BEGIN

	  vDias_vac := nvl(pDias_vac,0);

	  INSERT INTO arplvac(no_cia, no_emple, fecha_mov, origen,
	                    tipo_mov, tipo_a, no_accion, dias_normales,
	                    gestion, periodo)
	            VALUES(pNo_cia, pNo_emple, pF_inicio, 'H',
	                   'O', pTipo_a, pNo_accion, vDias_vac,
	                   pF_inicio, to_number(to_char(pF_inicio,'rrrr')));

	  -- --
	  --  Aumenta el saldo de la ultima gestion liquidada
	  IF vDias_vac > 0 THEN
		 UPDATE arplvac
		   SET saldo_normales = nvl(saldo_normales,0) + vDias_vac
		   WHERE no_cia   = pNo_cia
		     AND no_emple = pNo_emple
		     AND tipo_mov = 'A'
		     AND gestion  = (SELECT MAX(gestion)
		                     FROM arplvac
		                     WHERE no_cia   = pNo_cia
		                       AND no_emple = pNo_emple
		                       AND tipo_mov = 'A'
		                       AND nvl(saldo_normales,0) = 0);
	  END IF;
	END;-- aumenta_anual
	---
        --
	PROCEDURE disminuye_anual(
		pNo_cia	     arplvac.no_cia%type,
		pNo_emple    arplvac.no_emple%type,
		pDias_vac    arplvac.dias_normales%type,
		pFec_ini     date,
		pTipo_a      arplvac.tipo_a%type,
		pNo_accion   arplvac.no_accion%type
	) IS

		vDias_vac	  arplvac.saldo_normales%type;
		vDias	  arplvac.saldo_normales%type;

	-- Selecciona los periodos de vacaciones con saldo
	CURSOR c_gestiones IS
		SELECT gestion, saldo_normales, rowid
		 FROM arplvac
		WHERE no_cia    = pNo_cia
		  AND no_emple  = pNo_emple
		  AND tipo_mov  = 'A'
		  AND saldo_normales     > 0
		ORDER BY gestion,fecha_mov;

	BEGIN

		vDias_vac := nvl(pDias_vac,0);

		IF vDias_vac <= 0 THEN
		   RETURN;
		END IF;

		-- Actualiza saldo de gestiones
		FOR rv IN c_gestiones LOOP
		  vDias     := least(vDias_vac, nvl(rv.saldo_normales,0));
		  vDias_vac := vDias_vac - vDias;

		  UPDATE arplvac
		    SET saldo_normales   = nvl(saldo_normales,0) - vDias
		    WHERE rowid = rv.rowid;

		  INSERT INTO arplvac(no_cia, no_emple, fecha_mov, origen,
		                      tipo_mov, tipo_a, no_accion, dias_normales,
		                      gestion, periodo)
			          VALUES(pNo_cia, pNo_emple, pFec_ini, 'H',
			                 'O', ptipo_a, pNo_accion, -vDias,
			                 rv.gestion, to_number(to_char(rv.gestion,'rrrr')));

		  IF vDias_vac <= 0 THEN
		     EXIT;
		  END IF;
		END LOOP;

		-- --
		--  Si queda un saldo, lo descuenta de la ultima gestion registrada
		--  dejando negativo (lo que significa que pidio vacaciones por adelantado)
		IF vDias_vac > 0 THEN
		  UPDATE arplvac
		    SET saldo_normales = nvl(saldo_normales,0) - vDias_vac
		    WHERE no_cia   = pNo_cia
		      AND no_emple = pNo_emple
		      AND tipo_mov = 'A'
		      AND gestion  = (SELECT MAX(gestion)
		                      FROM arplvac
		                      WHERE no_cia   = pNo_cia
		                        AND no_emple = pNo_emple
		                        AND tipo_mov = 'A');
		END IF;
	END; --disminuye_anual
      --
      --

      PROCEDURE registra_anual (
	  pOrig        in varchar2,
	  pNo_cia      in arplvac.no_cia%type,
	  pFecha_ref   in date,
	  pCod_pla     in varchar2 default null
	) IS

	  vF_lim_vac    date;   -- fecha limite para que tome las vacaciones	--
	  vNo_emple	    arplme.no_emple%type;
	  vOrigen	      arplvac.origen%type;
	  vUlt_gestion	arplvac.gestion%type;
	  vGestion	    arplvac.gestion%type;
	  vDias_ade	    arplvac.saldo_normales%type;
	  vDias_vac	    arplpan.dias_vac%type;
	  vCant		      number(5);
	  vAnos		      number(5);
	  vEncontrado   boolean;

	-- ---
	-- Selecciona empleados
	CURSOR c_emp IS
	  SELECT e.no_emple, e.f_ingreso, e.f_reingreso,
	         e.acumula_vacac, nvl(e.plazo_vacac,0) plazo_vac
	    FROM arplme e, arplcp cp
	   WHERE e.no_cia    = pNo_cia
	     AND e.estado    = 'A'
 	     AND cp.no_cia   = e.no_cia
	     AND cp.tipo_emp = e.tipo_emp
	     AND cp.codpla   = nvl(pCod_pla, cp.codpla)
	   ORDER BY e.no_emple;

	-- Selecciona la ultima gestion registrada
	CURSOR c_ult_gestion IS
	  SELECT MAX(gestion)
	    FROM arplvac
	   WHERE no_cia   = pNo_cia
	     AND no_emple = vNo_emple
	     AND tipo_mov = 'A';

	-- Devuelve el saldo de la gestion indicada
	CURSOR c_saldo_gestion(pGestion DATE) IS
	  SELECT nvl(saldo_normales,0) saldo
	    FROM arplvac
	   WHERE no_cia   = pNo_cia
	     AND no_emple = vNo_emple
	     AND to_char(gestion,'MMRRRR') = to_char(pGestion,'MMRRRR')
	     AND tipo_mov = 'A';

	-- Selecciona los periodos de vacaciones vencidos
	CURSOR c_gestiones_viejas(pgestion_ref DATE) IS
		SELECT gestion,saldo_normales,rowid
		FROM arplvac
		WHERE no_cia    = pNo_cia
		  AND no_emple  = vNo_emple
		  AND gestion   <= pGestion_ref
		  AND tipo_mov  = 'A'
		  AND saldo_normales     > 0;

	-- Selecciona la cantidad de dias de vacaciones segun su antiguedad
	CURSOR c_dias_vac(pAnos NUMBER) IS
		SELECT dias_vac
		FROM arplpan
		WHERE ano_ant = (SELECT MAX(ano_ant)
		                 FROM arplpan
		                 WHERE ano_ant <= pAnos) ;
	BEGIN

		IF porig NOT IN ('P','H') THEN
		   vOrigen := 'P';
		ELSE
		   vOrigen := pOrig;
		END IF;

		FOR re IN c_emp LOOP

		  vNo_emple := re.no_emple;

		  OPEN c_ult_gestion;
		  FETCH c_ult_gestion INTO vUlt_gestion;
		  CLOSE c_ult_gestion;

		  IF vUlt_gestion IS NULL THEN  -- Es su primera gestion
		    vGestion := trunc(re.f_ingreso);
		  ELSE
		    vGestion := add_months(vUlt_gestion,12);
		  END IF;

		  vF_lim_vac := add_months(vGestion,12) + re.plazo_vac;
		  vCant := months_between(pFecha_ref, nvl(vGestion, re.f_ingreso));

		  IF vCant >= 12 THEN		-- Verifica si ya existe la gestion

		    vDias_ade := 0;
		    OPEN  c_saldo_gestion(vGestion);
		    FETCH c_saldo_gestion INTO vDias_ade;
		    vEncontrado := c_saldo_gestion%FOUND;
		    CLOSE c_saldo_gestion;

		    IF NOT vEncontrado THEN

		      -- Obtiene el saldo de la ultima gestion,
		      -- Si es negativo ==> que se pidieron vacaciones por adelantado
		      vDias_ade := 0;
		      OPEN  c_saldo_gestion(vUlt_gestion);
		      FETCH c_saldo_gestion INTO vDias_ade;
		      CLOSE c_saldo_gestion;

		      IF nvl(vDias_ade,0) >= 0 THEN
		        vDias_ade := 0;
		      ELSE
		        -- El saldo prestado de la ultima gestion, lo deja en 0, pues
		        -- sera liquidado con la nueva gestion, si no alcanza el
		        -- saldo de la nueva gesti?n sera negativa
		        vDias_ade := abs(vdias_ade);
		        UPDATE arplvac
		          SET saldo_normales = 0
		          WHERE no_cia   = pNo_cia
		            AND no_emple = vNo_emple
		            AND gestion  = vUlt_gestion
		            AND tipo_mov = 'A';
		      END IF;

		      -- Determina la antiguedad para saber los dias de vacacion que le tocan
		      vCant := months_between(pFecha_ref, re.f_ingreso);
		      vAnos := trunc(vCant/12,0);

		      vDias_vac := 0;
		      OPEN  c_dias_vac(vAnos);
		      FETCH c_dias_vac INTO vDias_vac;
		      CLOSE c_dias_vac;

		      -- Inserta el aumento de vacaciones
		      INSERT INTO arplvac(no_cia, no_emple, gestion,
		                          fecha_mov, origen, tipo_mov,
		                          dias_normales, saldo_normales,
		                          periodo)
			          VALUES(pNo_cia, vNo_emple, vGestion,
			                 pFecha_ref, vOrigen, 'A',
			                 vDias_vac, vDias_vac - vDias_ade,
			                 to_number(to_char(vGestion,'rrrr')));

		      IF nvl(re.acumula_vacac,'N') = 'N' AND vF_lim_vac < pFecha_ref THEN
		        -- Liquida saldo de vacaciones de periodos vencidos
		        -- Valen solo los ultimos 2 periodos
		        FOR rv IN c_gestiones_viejas( add_months(vgestion, -24) ) LOOP

		          -- Inserta una reduccion por Vencimiento de vacaciones
		          INSERT INTO arplvac(no_cia, no_emple, gestion, fecha_mov,
		                              origen, tipo_mov, dias_normales)
						              VALUES(pNo_cia, vNo_emple, rv.gestion, pFecha_ref,
						                     vOrigen, 'V', -rv.saldo_normales);

		          -- Actualiza el saldo de la gestion
		          UPDATE arplvac
		            SET saldo_normales = 0
		            WHERE rowid = rv.rowid;

		        END LOOP;
		      END IF;--nvl(vDias_ade,0) >= 0
		    END IF; --sino se encontro
		  END IF;  --if vCant > 12
		END LOOP; -- ciclo

	END;-- registra_anual
	--
	PROCEDURE borrado_anual(
		pCia      in arplvac.no_cia%type,
		pNo_emple in arplvac.no_emple%type,
		pPeriodo  in arplvac.periodo%type,
		pDias     in arplvac.dias_normales%type
	) IS

		CURSOR c_ult_gestion IS
			SELECT MIN(gestion)
		  	FROM arplvac
		 	 WHERE no_cia   = pCia
			   AND no_emple = pNo_emple
			   AND tipo_mov = 'O';

	 vGestion arplvac.gestion%type;

	BEGIN
		OPEN  c_ult_gestion;
		FETCH c_ult_gestion INTO vGestion;
		CLOSE c_ult_gestion;

		UPDATE arplvac
		   SET dias_normales = dias_normales + nvl(pDias,0)
		WHERE no_cia   = pCia
		  AND no_emple = pNo_emple
		  AND gestion  = vGestion
		  AND origen   = 'H'
		  AND tipo_mov = 'O'
		  AND dias_normales <> 0
		  AND rownum = 1;
	END; --borrado_anual
  --
	--
	FUNCTION cantidad_dias_acumula(
		pNo_cia	     in arplvac.no_cia%type,
		pNo_emple	   in arplvac.no_emple%type,
		pFecha_refe  in date
	) RETURN NUMBER IS

	CURSOR c_empleado IS
		SELECT f_ingreso
		  FROM arplme
		 WHERE no_cia   = pNo_cia
		   AND no_emple = pNo_emple
		   AND estado   = 'A';

	-- Selecciona la cantidad de dias de vacaciones segun su antiguedad
	CURSOR c_dias_vac(pAnos arplpan.ano_ant%type) IS
		 SELECT dias_vac
		   FROM arplpan
		  WHERE ano_ant = (SELECT max(ano_ant)
		                     FROM arplpan
		                    WHERE ano_ant <= pAnos) ;

	 vDias_vacacion arplvac.dias_normales%type;
	 vFecha_ingreso arplme.f_ingreso%type;
	 vEncontro      boolean;
	 vCantidad      number(5);
	 vAnos          number(5);
	BEGIN
		OPEN  c_empleado;
		FETCH c_empleado INTO vFecha_ingreso;
		vEncontro := c_empleado%found;
		CLOSE c_empleado;
		IF not vEncontro THEN
		   genera_error('El empleado '||pNo_emple||' no esta definido');
		END IF;

		-- Determina la antiguedad para saber los dias de vacacion que le
		-- corresponden de vacaciones
		vCantidad := months_between(pFecha_refe, vFecha_ingreso);
		vAnos     := trunc(vCantidad/12,0);

		vDias_vacacion := 0;
		OPEN  c_dias_vac(vAnos);
		FETCH c_dias_vac INTO vDias_vacacion;
		CLOSE c_dias_vac;

		RETURN(round(vDias_vacacion/12,2));
	END;--cantidad_dias_acumula


END;  -- Vacaciones BODY
/
