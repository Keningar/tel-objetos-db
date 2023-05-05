CREATE OR REPLACE PACKAGE            PLMARCAS AS
  -- -----------------------------------------------------------
  --  El paquete PLMARCAS contiene los procedimientos y funciones
  --  necesarios para el manejo de marcas de tarjeta.
  -- -----------------------------------------------------------
  --
  -- Determina si las fechas estan en ingles
  FUNCTION Es_Fecha_Ingles
  RETURN BOOLEAN;

  -- Recibe una fecha y determina que numero de dia es.
  -- Decodifica la fecha para que siempre la semana empiece con lunes=1.
  FUNCTION Decodifique_Dia( pFecha in date
                          ) RETURN NUMBER;
  FUNCTION formatea_hora( pHora in number
                         ) RETURN VARCHAR2;
  --
  PROCEDURE convierte_fechas_rango( pEntra	    IN DATE,
			  	    pHora_r_entra   IN NUMBER,
				    pHora_r_sale    IN NUMBER,
				    pDia_marca_ini  IN VARCHAR2,
				    pRango_entra    IN OUT DATE,
																  	pRango_sale			IN OUT DATE );
  --
  FUNCTION es_entrada_temprana (pNo_cia 	 IN  VARCHAR2,
  			        pNo_hora   IN  VARCHAR2,
				pCodigo    IN  VARCHAR2,
				pHora_ini  IN  NUMBER
				)RETURN BOOLEAN;
  --
  FUNCTION es_primer_rango_de_extra(pNo_cia   IN VARCHAR2,
				    pNo_hora  IN VARCHAR2,
				    pCodigo   IN VARCHAR2,
				    pHoraini  IN NUMBER,
				    pOrden    IN NUMBER
				   )RETURN BOOLEAN;

  -- Esta funcion indica si el rango es el primer rango requerido
  FUNCTION es_primer_rango_requerido(pNo_cia 	  IN VARCHAR2,
	   			     pNo_hora	  IN VARCHAR2,
				     pCodigo		IN VARCHAR2,
				     phora_ini  IN NUMBER
				   )RETURN BOOLEAN;

  -- Esta funcion indica si el empleado existe o no existe.
   FUNCTION existe_empleado ( pNo_cia 	 arplme.no_cia%TYPE,
			      pNo_emple arplme.no_emple%TYPE,
			      pEstado   out arplme.estado%TYPE
			    ) RETURN BOOLEAN;

  --Esta funcion indica si el empleado debe trabajar en determinado dia,
  -- segun el horario
  FUNCTION es_dia_requerido( pCia      in arplhora.no_cia%type,
			     pHorario  in arplhora.no_hora%type,
			     pNo_emple in arplme.no_emple%type,
			     pFecha    in date
			    ) RETURN boolean;

  -- Esta funcion devuelve TRUE si el empleado estuvo en reposo o en vacaciones
  -- para la fecha indicada
  FUNCTION en_reposo_vacaciones (pNo_cia		arplappp.no_cia%TYPE,
    	 		         pNo_emple arplappp.no_emple%TYPE,
				 pFecha	  DATE
				) RETURN BOOLEAN;

  -- Este procedimiento determina si las marcas del empleado son validas.
  PROCEDURE valida_marcas( pNo_cia	  arpltm.no_cia%TYPE,
			   pCod_pla   arpltm.cod_pla%TYPE,
			   pNo_emple	arpltm.no_emple%TYPE
			  );

  -- Este procedimiento calcula el total de horas laboradas de un empleado
  -- de acuerdo al horario en el que se encuentra clasificada la marca de reloj.
  PROCEDURE horas (	pNo_cia		      IN  VARCHAR2,
		  	pCod_pla	      IN  VARCHAR2,
		  	pNo_emple  	      IN  VARCHAR2,
		  	pNo_horario	      IN  VARCHAR2,
		  	pEntra		      IN  DATE,
		  	pSale		      IN  DATE,
		        pMinimo_entrada_temp  IN  NUMBER,
			pMinimo_hrs_ext       IN  NUMBER,
			pMax_tardia           IN  NUMBER,
			pHoras_trabajadas     OUT NUMBER
			 );
	--
  FUNCTION ultimo_error RETURN VARCHAR2 ;
  --
  error           EXCEPTION;
  PRAGMA          EXCEPTION_INIT(error, -20039);
  kNum_error      NUMBER := -20039;

   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State

   PRAGMA RESTRICT_REFERENCES(formatea_hora, WNDS);

END; -- PLMARCAS Specification
/


CREATE OR REPLACE PACKAGE BODY            plmarcas AS
  -- -----------------------------------------------------------
  --  El paquete PLMARCAS contiene los procedimientos y funciones
  --  necesarios para el manejo de marcas de reloj.
  -- -----------------------------------------------------------
  --
  -- ---------- PARTE: PRIVADA ------------------------
  --- Declaracion de Procedimientos o funciones PRIVADOS
  -- --------------------------------------------------
  vMensaje_error       VARCHAR2(160);
  --
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
  -- ---------- PARTE: PUBLICA ------------------------
  -- Declaracion de Procedimientos o funciones PUBLICAS
  -- --------------------------------------------------
  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
    RETURN(vMensaje_error);
  END ultimo_error;
  -- --
  --  FUNCTION: es_fecha_ingles
  --  Determina si las fechas estan en ingles
  -- --
  FUNCTION es_fecha_ingles
  RETURN BOOLEAN IS
  BEGIN
	  IF  to_char(to_date('03092001','ddmmyyyy'),'D') = '2' then
		  -- La fecha esta en ingles.
		  RETURN(TRUE);
	  ELSE
	  	RETURN(FALSE);
	  END IF;
  END; -- Es_Fecha_Ingles

  -- --
  -- FUNCTION: decodifique_dia
  -- Recibe una fecha y determina que numero de dia es.
  -- Decodifica la fecha para que siempre la semana empiece con lunes=1.
  -- --
  FUNCTION decodifique_dia(
     pFecha in date
  ) RETURN NUMBER IS
    vDia number(1);
  BEGIN
  	vDia := to_number(to_char(pFecha,'D'));
  	IF es_fecha_ingles THEN
  	  SELECT decode(vdia,1, 7, vDia-1)
  	  INTO vDia
  	  FROM dual;
  	END IF;
  	RETURN(vDia);
  END; -- Decodifique_Dia

 --
  FUNCTION formatea_hora(
     pHora in number
  ) RETURN varchar2 IS

    vHora_formateada varchar2(10);

  BEGIN
		vHora_formateada := lpad(ltrim(to_char(trunc(pHora/3600),'99')),  2,'0')||':';

		IF to_char(mod(pHora,3600)/60,'99') = '   ' THEN
		  vHora_formateada := vHora_formateada||'00';
		ELSE
		  vHora_formateada := vHora_formateada||lpad(ltrim(to_char(mod(pHora,3600)/60,'99')),2,'0');
		END IF;

		RETURN(vHora_formateada);
  END; -- formatea_hora


  -- --
  --  PROCEDURE: convierte_fechas_rango
  --  Convierte la hora de entrada y salida del rango en fecha-hora de
  --  entrada y fecha-hora de salida. Dependiendo de si la marca
  --  empieza y termina en el mismo o en diferente dia.
  -- --
  PROCEDURE convierte_fechas_rango(
  	pEntra					IN DATE, 			-- fecha y hora de marca de entrada
  	pHora_r_entra   IN NUMBER,    -- hora de entrada del rango
  	pHora_r_sale    IN NUMBER,    -- hora de salida  del rango
  	pDia_marca_ini  IN VARCHAR2,  -- dia de la marca de entrada
  	pRango_entra		IN OUT DATE,  -- fecha y hora entrada del rango
  	pRango_sale			IN OUT DATE   -- fecha y hora salida  del rango
  )IS
  --
  vFechai DATE;
  vFechaf DATE;
  vSegxd  CONSTANT number := 86400; -- segundos por dia = 24 hor * 60 min * 60 seg
  --
	BEGIN
	  vFechai:= trunc(pEntra);
	  IF pDia_marca_ini = 'S' THEN --siguiente dia
  	 	vFechai:= vFechai + 1;
  	ELSIF pDia_marca_ini = 'A' THEN --siguiente dia
    	vFechai:= vFechai - 1;
  	END IF;
	  vFechai:= vFechai + (pHora_r_entra/vSegxd);
  	IF pHora_r_entra <= pHora_r_sale THEN --rango en el mismo dia
	 		vFechaf := trunc(vFechai) + (pHora_r_sale/vSegxd);
  	ELSE --rango con cambio de dia
	    vfechaf := trunc(vFechai) + 1 + (pHora_r_sale/vSegxd);
  	END IF;
	  pRango_entra:= vFechai;
  	pRango_sale := vFechaf;
	END; -- convierte_fechas_rango

  -- --
  -- PROCEDURE: es_entrada_temprana
  -- --
	FUNCTION es_entrada_temprana (
		pNo_cia 	 IN  VARCHAR2,
    pNo_hora   IN  VARCHAR2,
    pCodigo    IN  VARCHAR2,
    pHora_ini  IN  NUMBER)
	RETURN BOOLEAN IS
  	--La entrada temprana corresponde a el rango anterior al primer rango requerido
  	CURSOR c_rangos_x_horario  IS
   	 SELECT hora_ini, nvl(requerido,'N') requerido
   	 FROM  arplraho
   	 WHERE  no_cia   =  pNo_cia
   	   AND  no_hora  =  pNo_hora
   	   AND  codigo   =  pCodigo
   	 ORDER BY orden;
   --
 	 vHora_ant arplraho.hora_ini%TYPE;
 	 --
	BEGIN
 		vHora_ant := NULL;
 		FOR i in c_rangos_x_horario LOOP
   		IF i.requerido='S' THEN -- primer rango requerido
     		IF nvl(vHora_ant,-1) = pHora_ini THEN
	        RETURN(TRUE);
  		  END IF;
   		END IF;
   		vHora_ant:= i.hora_ini;
 		END LOOP; -- c_rangos_x_horario
 		RETURN(FALSE);
	END; -- es_entrada_temprana

  -- --
  -- PROCEDURE: es_primer_rango_de_extra
  -- Se determina si este rango es el primer rango para pagar extras
  -- en cuyo caso se debe revisar el tiempo minimo para pago de extras
  -- --
	FUNCTION es_primer_rango_de_extra(
  	pNo_cia   IN VARCHAR2,
    pNo_hora  IN VARCHAR2,
    pCodigo   IN VARCHAR2,
    pHoraini  IN NUMBER,
    pOrden    IN NUMBER)
	RETURN BOOLEAN IS
	--
  CURSOR c_rango_anterior_requerido  IS
    SELECT nvl(requerido,'N') requerido
    FROM   arplraho
    WHERE  no_cia   =  pNo_cia
      AND  no_hora  =  pNo_hora
      AND  codigo   =  pCodigo
      AND  orden    <  pOrden
    ORDER BY orden DESC;
  --
  vRango_req arplraho.requerido%type;
  vExiste BOOLEAN;
  --
	BEGIN
    OPEN c_rango_anterior_requerido;
    FETCH c_rango_anterior_requerido INTO vRango_req;
    vExiste:= c_rango_anterior_requerido%FOUND;
    CLOSE c_rango_anterior_requerido;

    RETURN(vExiste AND NVL(vRango_req,'X')='S');
	END; -- es_primer_rango_de_extra

  -- --
  -- PROCEDURE: es_primer_rango_requerido
  -- Se determina si este rango es el primer rango requerido del horario.
  -- --
	FUNCTION Es_primer_rango_requerido(
		pNo_cia 	IN VARCHAR2, -- compa?ia
 		pNo_hora 	IN VARCHAR2, -- horario
 		pCodigo  	IN VARCHAR2, -- codigo del dia
 		phora_ini IN NUMBER    -- hora en que inicia el rango
 	) RETURN BOOLEAN IS

   CURSOR c_rango is
	   SELECT hora_ini
	   FROM arplraho
	   WHERE no_cia  = pNo_cia
	     AND no_hora = pNo_hora
	     AND codigo  = pCodigo
	     AND nvl(requerido,'S') ='S'
	   ORDER BY orden;

	  vhora arplraho.hora_ini%TYPE;
	BEGIN
		OPEN c_rango;
		FETCH c_rango INTO vhora;
		CLOSE c_rango;
		IF nvl(vhora,0) = phora_ini THEN
			RETURN(TRUE);
		ELSE
			RETURN(FALSE);
		END IF;
	END; -- es_primer_rango_requerido

  -- --
  -- FUNCION: existe_empleado
  -- Esta funcion devuelve TRUE si el empleado existe.
  -- Y si existe devuelve en vEstado el estado en el que se encuentra el empleado.
  -- --
  FUNCTION existe_empleado (
     pNo_cia 	 arplme.no_cia%TYPE,
     pNo_emple arplme.no_emple%TYPE,
     pEstado   out arplme.estado%TYPE
  ) RETURN BOOLEAN IS

    CURSOR  c_empleado is
      SELECT estado
      FROM  arplme
      WHERE no_cia   = pNo_cia
        AND no_emple = pNo_emple;

	  vExiste BOOLEAN;
	BEGIN
	  pEstado := NULL;
	  OPEN  c_empleado;
	  FETCH c_empleado INTO pEstado;
	  vExiste := c_empleado%found;
	  CLOSE c_empleado;
	  RETURN(vExiste);
	END; -- Existe_Empleado

  --
  -- Esta funcion retora True si la fecha que recibe como
  -- parametro corresponde a un dia en que el empleado
  -- debe trabajar, es decir, si el dia esta definido dentro
  -- de su horario de trabajo. En caso contrario, retorna False.
  FUNCTION es_dia_requerido(
   pCia      in arplhora.no_cia%type,
   pHorario  in arplhora.no_hora%type,
   pNo_emple in arplme.no_emple%type,
   pFecha    in date
  ) RETURN boolean IS

    CURSOR c_cod_dia_semana (pDia arpldise.dia_ini%type) IS
      SELECT codigo
        FROM arpldiho
       WHERE no_cia  = pCia
         AND no_hora = pHorario
         AND codigo IN (SELECT codigo
                          FROM arpldise
                         WHERE no_cia = pCia
                           AND ((pDia  = dia_ini OR pDia = dia_fin) OR
                                (dia_ini < dia_fin AND dia_ini <= pDia and pDia <= dia_fin) OR
                                (dia_fin < dia_ini AND (dia_fin >= pDia or pDia >= dia_ini)))
                        );

    CURSOR c_rango_requerido (pCodigo arpldiho.codigo%type) is
		  SELECT 'x'
		    FROM arplraho
		   WHERE no_cia  = pCia
		     AND no_hora = pHorario
		     AND codigo  = pCodigo
		     AND nvl(requerido,'S') ='S'
		   ORDER BY orden;

	   vCodigo      arpldiho.codigo%type;
	   vDia					arpldise.dia_ini%type;
	   vRequerido   varchar2(1);
	   vExiste 			boolean;

	 BEGIN
	 	 -- Obtiene el numero que corresponde al dia del feriado
	 	 vDia := decodifique_dia(pFecha);

	 	 -- Obtiene codigo de dias por horario
	 	 OPEN  c_cod_dia_semana (vDia);
	 	 FETCH c_cod_dia_semana INTO vCodigo;
	 	 vExiste := c_cod_dia_semana%found;
	 	 CLOSE c_cod_dia_semana;

	 	 IF vExiste THEN
	 	 	 -- Determina si dia es requerido
	 	 	 OPEN   c_rango_requerido (vCodigo);
	 	 	 FETCH  c_rango_requerido INTO vRequerido;
	 	 	 vExiste := c_rango_requerido%found;
	 	 	 CLOSE  c_rango_requerido;

	 	 	 IF vExiste THEN
	 	 	 	 RETURN(TRUE);
	 	 	 END IF;
	 	 END IF;
	 	 RETURN(FALSE);
	 END; -- es_dia_requerido


  -- --
  -- FUNCION: en_reposo_vacaciones
  -- Esta funcion devuelve TRUE si el empleado estuvo en reposo o en
  -- vacaciones para la fecha indicada.
  -- --
	FUNCTION en_reposo_vacaciones (
			pNo_cia		arplappp.no_cia%TYPE,
			pNo_emple arplappp.no_emple%TYPE,
			pFecha	  DATE
	) RETURN BOOLEAN IS
	--
  	CURSOR  c_reposo_vacac IS
	    SELECT 'x'
      FROM arplappp ap
      WHERE ap.no_cia    = pNo_cia
        AND ap.fecha     = pFecha
        AND ap.no_emple  = pNo_emple
        AND ap.clase_mov IN ('I','V');
   --
     vDummy  VARCHAR2(1);
     vExiste BOOLEAN;
   --
   BEGIN
   	 OPEN  c_reposo_vacac;
   	 FETCH c_reposo_vacac INTO vDummy;
   	 vExiste := c_reposo_vacac%FOUND;
   	 CLOSE c_reposo_vacac;
     RETURN(vExiste);
   END; -- en_reposo_vacaciones

	 -- --
	 -- PROCEDURE: valida_marcas
   -- Este procedimiento determina si las marcas del empleado son validas.
   -- --
  PROCEDURE valida_marcas(
     pNo_cia	  arpltm.no_cia%TYPE,
     pCod_pla   arpltm.cod_pla%TYPE,
	   pNo_emple	arpltm.no_emple%TYPE
  ) IS
    --
 	  vObservaciones arpltm.observaciones%TYPE;
	  vEstado				 arplme.estado%TYPE;
	  vFecha_Desde   DATE;
	  vFecha_Hasta   DATE;
	  vProcesa_Tarje arplme.procesa_tarj%TYPE;
	  vHorario_emp	 arplme.no_hora%TYPE;
	  vHorario       arplme.no_hora%TYPE;
	  vExiste        BOOLEAN;
	  vDia					 NUMBER;
	  vDummy         varchar2(1);
    --
  	CURSOR c_marcas IS
  	  SELECT no_cia, no_emple, horario, fecha_entra,
  	         hora_entra, fecha_sale, hora_sale, rowid
	      FROM arpltm
	     WHERE no_cia   = pNo_cia
	       AND cod_pla  = pCod_pla
	       AND no_emple = pNo_emple;
	  --
    CURSOR c_planilla IS
	     SELECT f_tarj_desde, f_tarj_hasta
	       FROM arplcp p, arplme e
 	      WHERE e.no_cia   = pNo_cia
	        AND e.no_emple = pNo_emple
	        AND e.no_cia   = p.no_cia
	        AND p.codpla   = pCod_pla;
	  --
	   CURSOR c_empleado IS
	     SELECT no_hora
	       FROM arplme
 	      WHERE no_cia      = pNo_cia
	        AND no_emple    = pNo_emple
	        AND procesa_tarj= 'S';
	  --
	  CURSOR c_obtiene_cod_dxsem (pHorario varchar2, pDia number) IS
      SELECT 'x'
        FROM arpldiho
       WHERE no_cia  = pNo_cia
         AND no_hora = pHorario
         AND codigo IN (SELECT codigo
                          FROM arpldise
                         WHERE no_cia = pNo_cia
                           AND ((pDia  = dia_ini OR pDia = dia_fin) OR
                                (dia_ini < dia_fin AND dia_ini <= pDia and pDia <= dia_fin) OR
                                (dia_fin < dia_ini AND (dia_fin >= pDia or pDia >= dia_ini)))
                       );

  BEGIN
	  -- Prepara los registros
	  UPDATE arpltm
	     SET marca_correcta = 'N',
		       observaciones  = NULL
	   WHERE no_cia   =  pNo_cia
	     AND cod_pla  =  pCod_pla
	     AND no_emple =  pNo_emple;

  	-- Valida condiciones del  empleado
	  vObservaciones := NULL;
	  IF existe_empleado(pNo_cia, pNo_emple, vEstado) THEN
	  	IF vEstado = 'I' THEN
	  		-- Empleado esta inactivo
	  		vObservaciones := vObservaciones||' Empleado esta inactivo.';
	  	ELSE
	  		-- Valida que el empleado pertenezca a la planilla
	  		OPEN  c_planilla;
	  		FETCH c_planilla INTO vFecha_desde, vFecha_hasta;
	  		vExiste := c_planilla%found;
	  		CLOSE c_planilla;
	  		IF not vExiste THEN
	  			vObservaciones := vObservaciones||' El empleado no pertenece a la nomina.';
	  	  ELSE
		  		  -- Valida si salario de empleado depende de marca y obtiene el horario
		  		vhorario_emp := NULL;
		  		OPEN  c_empleado;
		  		FETCH c_empleado INTO vhorario_emp;
		  		vExiste := c_empleado%found;
		  		CLOSE c_empleado;
		  		IF not vExiste THEN
		  			vObservaciones := vObservaciones||' El salario del empleado no depende de las marcas.';
		      END IF;  -- Salario depende de marcas
		    END IF; --	Valida planilla
      END IF; -- Validad estado
	  ELSE
	  	 -- Empleado no existe
       vObservaciones	:= vObservaciones||' Empleado no existe.';
	  END IF;

 	  -- Valida marcas de tarjeta
    IF vObservaciones IS NULL THEN
  	  FOR i IN  c_marcas LOOP
  	  	vObservaciones := null;
		   	vHorario := nvl(i.horario, vHorario_emp);
		    IF vHorario IS NULL THEN
		     	vObservaciones := vObservaciones||' Falta definir el horario del empleado.';
		    ELSIF (i.fecha_entra IS NULL) OR  (i.hora_entra IS NULL) THEN
   				vObservaciones := vObservaciones||' Falta definir la marca de entrada.';
   		 	ELSIF (i.fecha_sale IS NULL) OR  (i.hora_sale IS NULL) THEN
   				vObservaciones := vObservaciones||' Falta definir la marca de salida.';
   			ELSIF (i.fecha_entra = i.fecha_sale) AND (i.hora_entra = i.hora_sale)THEN
   				vObservaciones := vObservaciones||' Hora de entrada es igual a la hora de salida.';
   			ELSIF (i.fecha_entra > i.fecha_sale) OR (i.fecha_entra = i.fecha_sale and i.hora_entra >= i.hora_sale)THEN
   				vObservaciones := vObservaciones||' Hora de entrada es mayor a la hora de salida.';
   			ELSIF trunc(i.fecha_entra) NOT BETWEEN vfecha_desde AND vfecha_hasta THEN
   				vObservaciones := vObservaciones||' Fecha no corresponde al rango de carga.';
   			ELSIF en_reposo_vacaciones(pNo_cia, pNo_emple, i.Fecha_entra) THEN
   				vObservaciones := vObservaciones||' El empleado se encontraba en reposo o en vacaciones.';
   			ELSE
  				vDia := decodifique_dia(i.fecha_entra);
   				OPEN  c_obtiene_cod_dxsem (vHorario, vDia);
          FETCH c_obtiene_cod_dxsem INTO vDummy;
          vExiste := c_obtiene_cod_dxsem%FOUND;
          CLOSE c_obtiene_cod_dxsem;
          IF NOT vExiste THEN
             vObservaciones := 'El dia no corresponde al horario '||vHorario;
          END IF;
   			END IF;
   		  -- Actualiza estado de la marca
       	UPDATE arpltm
    	     SET marca_correcta  = decode(vObservaciones, NULL, 'S', 'N'),
    	         observaciones   = vObservaciones,
    	         horario         = vHorario
   	     WHERE rowid = i.rowid;
  	  END LOOP; -- c_marcas
  	ELSE
 		  -- Actualiza estado de la marca para todas las marcas del empleado
     	UPDATE arpltm
         SET marca_correcta  = decode(vObservaciones, NULL, 'S', 'N'),
   	         observaciones   = vObservaciones
  	   WHERE no_cia   =  pNo_cia
	       AND cod_pla  =  pCod_pla
	       AND no_emple =  pNo_emple;
  	END IF;
  END; -- valida_marcas

  -- --
  /* PROCEDURE: horas
   Calcula el total de horas laboradas de un empleado, de acuerdo a las
	 marcas de reloj  y a los rangos de  horario en que esta se pueda
	 clasificar.

	 Consideraciones en definicion de horarios:
     1. Cada horario define los dias a laborar, por ejemplo lunes a viernes.
     2. Luego para los dias a  laborar por horario,  se definen los rangos
     de horas laborables.
     3.  Es importante definir  todas   las posibles horas  que laborara un
     empleado, puesto que el rango que NO este definido NO sera considerado
     en el calculo de las horas laboradas.  Por ejemplo:  si el  horario de
     lunes a viernes es de 8:00 am hasta 5:00 pm, se debe incluir al menos un
     rango previo a las 8:00 am (para considerar una posible entrada temprana)
     y de igual forma, al menos uno despues de las 5:00 pm (para considerar
     posibles horas extra)

   Adicionalmente para cada rango se debe Indicar:
     1. el orden de aplicacion con respecto a los otros rangos
     2. si es requerido(hora ordinaria) o no (entrada temprana, hora extra).
     3. si un rango pertenece al dia de la marca, al siguiente o al anterior.
        Esto se utiliza en los horarios mixtos o nocturnos, para determinar
        el cambio de dia.

   Calculo horas laboradas:
     1. Con base en la marca de entrada del empleado y el horario asociado,
     se buscan los rangos que se deben aplicar y se verifica el tipo de hora
     laborable, asi como la tasa multiplicativa.
     2. solo se calcula extra y entrada temprana si los Minutos de cada una
     exceden al minimo definido en los parametros (ARPLPAR) en la forma FPL109
     Mantenimiento de Parametros del Sistema.  Y solo se aprueban horas extra
     para el empleado que devenga extras (ARPLME), segun definicion en la
     forma FRH103 Mantenimiento de  Empleados.
   */
   -- --
	PROCEDURE horas (
  	pNo_cia								IN 	VARCHAR2,
  	pCod_pla							IN  VARCHAR2,
  	pNo_emple  						IN	VARCHAR2,			-- no. de empleado
  	pNo_horario						IN	VARCHAR2,	 	  -- cod. horario
  	pEntra								IN	DATE, 				-- Fecha-Hora de entrada
  	pSale									IN	DATE,         -- Fecha-Hora de salida
	  pMinimo_entrada_temp	IN  NUMBER,       -- Minutos para pagar entrada temprana
	  pMinimo_hrs_ext     	IN  NUMBER,       -- Horas para pagar horas extra
	  pMax_tardia						IN  NUMBER, 			-- Tiempo maximo para no descontar una tardia
	  pHoras_trabajadas			OUT	NUMBER				-- retorna el total de horas trabajadas
	)IS
   --
   CURSOR c_obtiene_cod_dxsem (c_hora VARCHAR2, ndia NUMBER) IS
     SELECT DISTINCT codigo
       FROM arpldiho
      WHERE no_cia  = pNo_cia
        AND no_hora = c_hora
        AND codigo IN (SELECT codigo
                         FROM arpldise
                        WHERE no_cia = pNo_cia
                          AND ((ndia = dia_ini OR ndia = dia_fin) OR
                               (dia_ini < dia_fin AND dia_ini <= ndia AND ndia <= dia_fin) OR
                               (dia_fin < dia_ini AND (dia_fin >= ndia or ndia >= dia_ini)))
                      );

   CURSOR c_recorre_rangos_dia (c_hora VARCHAR2, cod VARCHAR2) IS
     SELECT tipo_hora,hora_ini,hora_fin,tasa_ingreso,
            nvl(requerido,'N') requerido, dia_marca_ini, orden
       FROM arplraho
      WHERE no_cia   =  pNo_cia
        AND no_hora  =  c_hora
        AND codigo   =  cod
   ORDER BY orden;
   --
   vNdia         number(1);
   vExiste       boolean;
   vCod_diaxsem  arpldiho.codigo%TYPE;
   vHora_entra   arplmaen.h_entra%TYPE;
   vHora_sale    arplmaen.h_sale%TYPE;
   vDia_entra    arplmaen.d_entra%TYPE;
   vDia_sale     arplmaen.d_sale%TYPE;
   vRango_entra  arplmaen.d_entra%TYPE; -- formar fecha con hora de entrada de rango
   vRango_sale   arplmaen.d_sale%TYPE;  -- formar fecha con hora de salida de rango
   vEntra_calc   arplmaen.d_entra%TYPE;
   vSale_calc    arplmaen.d_sale%TYPE;
   vCant_horas   arplmade.cantidad%TYPE;
   vHtrabajada   arplmaen.trabajadas%TYPE;
   vTardia       arplpar.max_tardia%TYPE;
   vTiene_extras boolean;
   vSegxdia      constant number := 86400;   -- segundos por dia  = 24 hor * 60 Min * 60 seg
   --
	BEGIN

		vNdia := Decodifique_dia(pEntra);

    OPEN  c_obtiene_cod_dxsem (pNo_horario,vNdia);
    FETCH c_obtiene_cod_dxsem INTO vCod_diaxsem;
    vExiste := c_obtiene_cod_dxsem%FOUND;
    CLOSE c_obtiene_cod_dxsem;
    IF not vExiste THEN
    	genera_error('Empleado '||pNo_emple||', dia no corresponde al horario:'||pNo_horario);
    END IF;

    vTiene_extras:=FALSE;

    -- Separa fechas y horas de marca del empleado
    vHora_entra:= to_number(to_char(pEntra,'SSSSS'));
    vHora_sale := to_number(to_char(pSale,'SSSSS'));
    vDia_entra := trunc(pEntra);
    vDia_sale  := trunc(pSale);

    --Recorre rangos que podrian aplicar para el periodo laborado
    FOR i IN c_recorre_rangos_dia (pNo_horario, vCod_diaxsem) LOOP

    	vCant_horas := 0;

      convierte_fechas_rango(pEntra,i.hora_ini,i.hora_fin,i.dia_marca_ini,
                             vRango_entra, vRango_sale);
      IF NOT ((pEntra < vRango_entra AND pSale < vRango_entra) OR
              (pEntra > vRango_sale  AND pSale > vRango_sale))  THEN -- rango si aplica
        IF pEntra < vRango_entra THEN -- entrada fuera de rango
          vEntra_calc := vRango_entra;
        ELSE
          vEntra_calc := pEntra;
          -- verifica entrada tardia
          IF Es_primer_rango_requerido(pNo_cia, pNo_horario, vCod_diaxsem, i.hora_ini)
          AND (vEntra_calc > vRango_Entra) AND nvl(pMax_tardia,0)<>0 THEN
             vTardia := (vEntra_calc - vRango_entra) * vSegxDia;
             IF vTardia > pMax_tardia THEN
             	 vEntra_calc := pEntra;
             ELSE
             	 vEntra_calc := vRango_entra;
             END IF;
          END IF;
        END IF;
        IF pSale > vRango_sale THEN  -- salida fuera de rango
          vSale_calc := vRango_sale;
        ELSE
          vSale_calc := pSale;
        END IF;

        vCant_horas := (vSale_calc - vEntra_calc) * vSegxdia;

        IF Es_Entrada_Temprana(pNo_cia, pNo_horario, vCod_diaxsem, i.hora_ini) THEN
          IF vCant_horas < pMinimo_entrada_temp  THEN -- no cumple el Minimo de entrada temprano
             vCant_horas:=0;
          END IF;
        ELSIF NOT vTiene_extras THEN
          IF Es_Primer_Rango_de_Extra(pNo_cia, pNo_horario, vCod_diaxsem, i.hora_ini, i.orden) THEN
            IF vCant_horas < pMinimo_hrs_ext THEN -- no cumple el Minimo de extras
	            vCant_horas:=0;
	          ELSE
	            vTiene_extras:=TRUE;
	          END IF;
          END IF;
        END IF;

        IF vCant_horas <> 0 THEN
        	BEGIN
        		UPDATE arplmade SET cantidad = nvl(cantidad,0)+ vCant_horas
        		 WHERE no_cia  = pNo_cia
        		   AND no_emple= pNo_emple
        		   AND horario = pNo_horario
        		   AND d_entra = trunc(pEntra)
        		   AND h_entra = vHora_entra
        		   AND tipo_hora = i.tipo_hora
        		   AND tasa_mult = i.tasa_Ingreso;

        		IF sql%rowcount=0 THEN
	        		INSERT INTO arplmade (no_cia, no_emple, horario,
	        		                      d_entra, h_entra,
  	      		   	                  tipo_hora, tasa_mult, cantidad)
							    	    		VALUES (pNo_cia, pNo_emple, pNo_horario,
							    	    		        trunc(pEntra), vHora_entra,
							      	  		 	      i.tipo_hora, i.tasa_ingreso, vCant_horas );
      	  	END IF;
        	EXCEPTION WHEN OTHERS THEN
        		genera_error('Al Insertar ARPLMADE '||sqlerrm);
        	END;
        END IF;
      END IF;
      vHtrabajada := nvl(vHtrabajada,0) + nvl(vCant_horas,0);
	  END LOOP;
	  --Retorna las horas trabajadas
	  pHoras_trabajadas 	:=	vHtrabajada;
  END; -- Horas
	--
END; -- PLmarcas Body
/
