CREATE OR REPLACE PACKAGE            CGLIB IS
      -- --
    --
     TYPE companias_r IS RECORD(
        no_cia                arcgmc.no_cia%type,
        nombre                arcgmc.nombre%type,
        nombre_largo          arcgmc.nombre_largo%type,
        ano_proce             arcgmc.ano_proce%type,
        mes_proce             arcgmc.mes_proce%type,
        mes_cierre            arcgmc.mes_cierre%type,
        moneda_func           arcgmc.moneda_func%type,
        mon_reg_cont          arcgmc.mon_reg_cont%type,
        promedio              arcgmc.promedio%type,
        repre                 arcgmc.repre%type,
        direccion             arcgmc.direccion%type,
        acepta_tercero        arcgmc.acepta_tercero%type,
        codigo_tercero        arcgmc.codigo_tercero%type,
        tipo_id_tributario    arcgmc.tipo_id_tributario%type,
        id_tributario         arcgmc.id_tributario%type,
        condicion_tributaria  arcgmc.condicion_tributaria%type,
        clase_cambio          arcgmc.clase_cambio%type,
        cc_cualquier_nivel    arcgmc.cc_cualquier_nivel%type,
        formato_cta           arcgmc.formato_cta%type,
        cta_und               arcgmc.cta_und%type,
        cta_perdidas          arcgmc.cta_perdidas%type,
        cta_perdidas_ajuste   arcgmc.cta_perdidas_ajuste%type,
        cta_ajuste_nom        arcgmc.cta_ajuste_nom%type,
        cta_ajuste_dol        arcgmc.cta_ajuste_dol%type,
        cta_u_c_hist          arcgmc.cta_u_c_hist%type,
        cta_p_c_hist          arcgmc.cta_p_c_hist%type,
        cta_u_c_cte           arcgmc.cta_u_c_cte%type,
        cta_p_c_cte           arcgmc.cta_p_c_cte%type,
        cod_diario_difcam     arcgmc.cod_diario_difcam%type,
        f_u_difcambio         arcgmc.f_u_difcambio%type,
        cta_ud                arcgmc.cta_ud%type,
        cta_pd                arcgmc.cta_pd%type
     );
    -- ---
    -- Funcion que devuelve los datos de la compa?ia.
    FUNCTION trae_datos_cia(
       pCia        IN     arcgmc.no_cia%type,
       pDatos_Cia  IN OUT companias_r
    ) RETURN BOOLEAN;
    -- --
    -- Devuelve el periodo fiscal asociado a un a?o dado.
    FUNCTION obtiene_ano_fiscal_actual(
       pCia         IN     arcgmc.no_cia%type
    ) RETURN number;
    -- --
    -- Devuelve el periodo fiscal asociado a una fecha dada.
    FUNCTION  obt_periodo_fiscal_f(
       pCia         IN     arcgmc.no_cia%type,
       pano_fiscal  IN     number,
       pperiodo_ini OUT    date,
       pperiodo_fin OUT    date
    ) RETURN BOOLEAN;


    FUNCTION  valide_maneja_ajuste_infl(PCIA in varchar2) RETURN boolean;
    --  Retorna si la compa?ia maneja ajsutes por inflacion

    FUNCTION utiliza_conversion(pCia in varchar2)RETURN boolean;
    -- Retorna TRUE si la compania utiliza conversion de estados financierios

    PROCEDURE valida_asiento_apertura( pCia       in arcgae.no_cia%type,
                                       pNo_asiento in arcgae.no_asiento%type);
    -- Valida si el asiento de apertura esta balanceado en nominal o en nominal y dolares

    FUNCTION es_fecha_inicial ( pCia in varchar2, pMes in number, pAno in number) RETURN boolean;
    -- Retorna TRUE si la fecha dada corresponde a la fecha de inicio de la compania

    -- --
    -- Valida si ya se efectuo el cierre de libros a la fecha 'pFecha'
    FUNCTION valida_cierre_libros(
       pCia              IN arcgms.no_cia%type,
       pFecha            IN arcgae.fecha%type,
       ptipo_comprobante IN varchar2    --C(compras) D(diario) H(honorarios) M(mayor) V(ventas)
    ) RETURN BOOLEAN;

    FUNCTION  ultimo_error RETURN VARCHAR2;
    --
    error           EXCEPTION;
    PRAGMA          EXCEPTION_INIT(error, -20027);
    kNum_error      NUMBER := -20027;
    --
    -- ---
    -- Define restricciones de procedimientos y funciones
    --    WNDS = Writes No Database State
    --    RNDS = Reads  No Database State
    --    WNPS = Writes No Package State
    --    RNPS = Reads  No Package State



    PRAGMA RESTRICT_REFERENCES(trae_datos_cia,     WNDS);
    PRAGMA RESTRICT_REFERENCES(obtiene_ano_fiscal_actual,   WNDS);
    PRAGMA RESTRICT_REFERENCES(obt_periodo_fiscal_f, WNDS);
    PRAGMA RESTRICT_REFERENCES(valide_maneja_ajuste_infl, WNDS);

END;   -- CGLIB
/


CREATE OR REPLACE PACKAGE BODY            CGLIB IS


    /*******[ PARTE: PRIVADA ]
    * Declaracion de Procedimientos o funciones PRIVADOS
    *
    */
    -- ---
    -- TIPOS
    --
    --
    vMensaje_error      VARCHAR2(160);
    gTstamp             number;
    vrCia               companias_r;
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

    /*******[ PARTE: PUBLICA ]
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
    FUNCTION trae_datos_cia(
       pCia        IN     arcgmc.no_cia%type,
       pDatos_Cia  IN OUT companias_r
    ) RETURN boolean IS

       --
       CURSOR c_datos_cia IS
         SELECT no_cia,         nombre,          nombre_largo,       ano_proce,
                mes_proce,      mes_cierre,      moneda_func,        mon_reg_cont,
                promedio,       repre,           direccion,          acepta_tercero,
                codigo_tercero, tipo_id_tributario,                  id_tributario,
                condicion_tributaria,            clase_cambio,       cc_cualquier_nivel,
                formato_cta,    cta_und,         cta_perdidas,       cta_perdidas_ajuste,
                cta_ajuste_nom, cta_ajuste_dol,  cta_u_c_hist,       cta_p_c_hist,
                cta_u_c_cte,    cta_p_c_cte,     cod_diario_difcam,  f_u_difcambio,
                cta_ud,         cta_pd
           FROM arcgmc
          WHERE no_cia = pCia;

       vExiste  boolean;
       vtstamp  number;
    BEGIN
      limpia_error;
	    vtstamp := TO_CHAR(sysdate, 'SSSSS');
      vExiste := TRUE;
      if (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) OR
         vrCia.no_cia  is null   OR vrcia.no_cia  != pCia   THEN
         --
         --
         OPEN  c_datos_cia;
         FETCH c_datos_cia INTO vrCia;
         vExiste := c_datos_cia%FOUND;
         CLOSE c_datos_cia;

         gTstamp := TO_CHAR(sysdate, 'SSSSS');
      end if;
      pDatos_Cia  := vrcia;
      RETURN (vExiste);
    END;
    --

    -- --
    --
   FUNCTION  valide_maneja_ajuste_infl(PCIA in varchar2) RETURN boolean IS

	CURSOR C_maneja_ajuste is
		SELECT nvl(ind_maneja_ajustes,'N') maneja
		  FROM arcgmc
		 WHERE no_cia = pcia;

	vmaneja varchar2(1);
  vExiste boolean;
BEGIN
  open c_maneja_ajuste;
  fetch c_maneja_ajuste into vmaneja;
  vExiste := c_maneja_ajuste%found;
  close c_maneja_ajuste;
  if vExiste then
  	return(vmaneja='S');
  else
  	return(vExiste);
  end if;

  EXCEPTION
      WHEN others THEN
           Genera_error (sqlerrm);
END;

    FUNCTION obt_periodo_fiscal_f(
       pCia         IN     arcgmc.no_cia%type,
       pAno_Fiscal  IN     number,
       pperiodo_ini OUT    date,
       pperiodo_fin OUT    date
    ) RETURN BOOLEAN IS
      --
      vExiste Boolean;
      vRegCia Companias_r;

    BEGIN

    	vexiste := Trae_datos_cia (pCia, vRegCia);
    	IF not vexiste THEN
    		Genera_error ('La compa?ia '||pCia||' no esta definida');
    	END IF;

    	-- calcula la fecha de inicio del periodo
    	pperiodo_ini    := ADD_MONTHS(to_date('01-'||lpad(to_char(vRegCia.mes_cierre),2,'0')||'-'||to_char(pAno_Fiscal-1),'DD-MM-RRRR'),1);

    	-- calcula la fecha final del periodo
    	pperiodo_fin    := LAST_DAY(to_date('01-'||lpad(to_char(vRegCia.mes_cierre),2,'0')||'-'||to_char(pAno_Fiscal),'DD-MM-RRRR'));

      return(vexiste);

    EXCEPTION
      WHEN others THEN
           Genera_error (sqlerrm);
    END ;

    FUNCTION obtiene_ano_fiscal_actual(
       pCia           IN     arcgmc.no_cia%type
    ) RETURN number IS
      --
      vexiste     boolean;
      vRegCia     companias_r;
      vAno_fiscal number;



    BEGIN

    	vexiste := Trae_datos_cia (pCia, vRegCia);
    	IF not vexiste THEN
    		Genera_error ('La compa?ia '||pCia||' no esta definida');
    	ELSIF vRegCia.mes_cierre = 12 THEN
    		vAno_fiscal := vRegCia.ano_proce;
    	ELSIF vRegCia.mes_proce <= vRegCia.mes_cierre THEN
    		vAno_fiscal := vRegCia.ano_proce;
    	ELSE
    		vAno_fiscal := vRegCia.ano_proce +  1;
    	END IF;

      return(vAno_Fiscal);

    EXCEPTION
      WHEN others THEN
           Genera_error (sqlerrm);
    END;

---
FUNCTION utiliza_conversion(
	pCia in varchar2
)RETURN BOOLEAN IS

-- Esta funcion retorna TRUE si la compania dada como parametro
-- utiliza utiliza conversion
 CURSOR c_utiliza_conversion IS
	 SELECT ind_utiliza_conversion
	   FROM arcgmc
	  WHERE no_cia = pCia;

	 vUtiliza_conversion  arcgmc.ind_utiliza_conversion%type;

BEGIN

   OPEN  c_utiliza_conversion;
   FETCH c_utiliza_conversion INTO vUtiliza_conversion;
   CLOSE c_utiliza_conversion;

   IF vUtiliza_conversion = 'S' THEN
   	  RETURN(TRUE);
   ELSE
   	  RETURN(FALSE);
   END IF;

EXCEPTION
   WHEN others THEN
      Genera_error (sqlerrm);
END;


--
--
PROCEDURE valida_asiento_apertura
(
  pCia        in arcgae.no_cia%type,
  pNo_asiento in arcgae.no_asiento%type
)IS
-- 1. Este procedimiento valida que el asiento de apertura
-- este balanceado en moneda nominal.
-- 2. Si ademas la compa?ia maneja conversion de estados
-- financieros, tambien se valida que el asiento este
-- balanceado en dolares
-- 3. Valida que Activo = Pasivo + Capital en moneda nominal
-- 4. Valida que Activo = Pasivo + Capital en moneda dolares si
-- la compa?ia  utiliza la convesion de estados financieros

 CURSOR c_asiento_cuadra IS
   SELECT no_asiento, sum(monto), sum(monto_dol)
     FROM  arcgal
    WHERE no_cia    = pCia
      AND no_asiento = pNo_asiento
  GROUP BY no_asiento;

  CURSOR c_balanceado IS
    SELECT sum(decode(ms.clase, 'A', monto, 0)) monto_nom_activos,
           sum(decode(ms.clase, 'A', monto_dol, 0)) monto_dol_activos,
	   sum(decode(ms.clase, 'P', monto, 'C', monto, 'I', monto, 'G', monto, 0)) monto_nom_otros,
	   sum(decode(ms.clase, 'P', monto_dol, 'C', monto_dol, 'I', monto_dol, 'G', monto_dol, 0)) monto_dol_otros
    FROM arcgal al, arcgms ms
    WHERE al.no_cia     = pCia
     AND ms.no_cia     = al.no_cia
     AND ms.cuenta     = al.cuenta
     AND al.no_asiento = pNo_asiento;

  CURSOR c_ctas_orden IS
    SELECT sum(decode(al.tipo,'D', al.monto,0)) debitos_nom,
           sum(decode(al.tipo,'C', al.monto,0)) creditos_nom,
           sum(decode(al.tipo,'D', al.monto_dol,0)) debitos_dol,
           sum(decode(al.tipo,'C', al.monto_dol,0)) creditos_dol
     FROM arcgal al, arcgms ms
     WHERE al.no_cia     = pCia
       AND ms.no_cia     = al.no_cia
       AND ms.cuenta     = al.cuenta
       AND al.no_asiento = pNo_asiento
       and ms.clase      = 'O';

   vNo_asiento          arcgae.no_asiento%type;
   vSuma_nom            arcgal.monto%type;
   vSuma_dol            arcgal.monto_dol%type;
   vMonto_nom_activos 	arcgal.monto%type;
   vMonto_dol_activos 	arcgal.monto_dol%type;
   vMonto_nom_otros   	arcgal.monto%type;
   vMonto_dol_otros  	arcgal.monto_dol%type;
   vDebitos_nom         arcgal.monto%type;
   vDebitos_dol         arcgal.monto_dol%type;
   vCreditos_nom        arcgal.monto%type;
   vCreditos_dol        arcgal.monto_dol%type;

BEGIN
    --Valida que el asiento este cuadrado
    OPEN  c_asiento_cuadra;
    FETCH c_asiento_cuadra INTO vNo_asiento,vSuma_nom, vSuma_dol;
    CLOSE c_asiento_cuadra;

    IF vSuma_nom <> 0 THEN
 	genera_error('El asiento de Apertura no esta cuadrado en moneda '||moneda.nombre(pCia,'P'));
    END IF;

    IF vSuma_dol <> 0  AND utiliza_conversion(pCia)  THEN
	genera_error('El asiento de Apertura no esta cuadrado en moneda '||moneda.nombre(pCia,'D'));
   END IF;

    --Valida que el asiento este balanceado
    --Activos = Pasivos +  Capital (incluye las cuentas de ingreso y gasto)
    OPEN  c_balanceado;
    FETCH c_balanceado INTO vMonto_nom_activos, vMonto_dol_activos, vMonto_nom_otros, vMonto_dol_otros;
    CLOSE c_balanceado;

    IF vMonto_nom_activos <> abs(vMonto_nom_otros)THEN
  	 genera_error('El asiento de Apertura no esta balanceado en moneda '
 	               ||moneda.nombre(pCia,'P')||'( Activos debe ser igual a Pasivos + Capital )');
    END IF;

    IF vMonto_dol_activos <> abs(vMonto_dol_otros) AND utiliza_conversion(pCia) THEN
  	 genera_error('El asiento de Apertura no esta balanceado en moneda '
	  	               ||moneda.nombre(pCia,'D')||'( Activos debe ser igual a Pasivos + Capital )');
    END IF;


    --Valida que las cuentas de orden del asiento esten balanceadas
    OPEN  c_ctas_orden;
    FETCH c_ctas_orden INTO vDebitos_nom, vCreditos_nom, vDebitos_dol, vCreditos_dol;
    CLOSE c_ctas_orden;

    IF nvl(vDebitos_nom,0) <> nvl(abs(vCreditos_nom),0) THEN
  	 genera_error('Las cuentas de Orden del asiento de Apertura no cuadran en moneda'
  	               ||moneda.nombre(pCia,'P'));
    END IF;

    IF ( nvl(vDebitos_dol,0) <> nvl(abs(vCreditos_dol),0) ) AND utiliza_conversion(pCia) THEN
  	 genera_error('Las cuentas de Orden del asiento de Apertura no cuadran en moneda'
  	               ||moneda.nombre(pCia,'D'));
    END IF;

END;
--
--

FUNCTION es_fecha_inicial
( pCia in varchar2,
  pMes in number,
  pAno in number
) RETURN BOOLEAN IS
	-- Esta funcion retorna TRUE si el a?o y mes dados como parametros corresponden
	-- al a?o y mes de inicio de la compania, en caso contrario, retorna FALSE.
	CURSOR c_fecha_proceso IS
		SELECT mes_ini, ano_ini
  		FROM arcgmc
	   WHERE no_cia = pCia;

	  vMes_ini  arcgmc.mes_ini%type;
	  vAno_ini  arcgmc.ano_ini%type;
BEGIN
  OPEN  c_fecha_proceso;
  FETCH c_fecha_proceso INTO vMes_ini, vAno_ini;
  CLOSE c_fecha_proceso;

  IF ( to_date(lpad(to_char(vMes_ini),2,'0')||to_char(vAno_ini),'MMYYYY')
      = to_date(lpad(to_char(pMes),2,'0')||to_char(pAno),'MMYYYY') )  THEN
     RETURN(TRUE);
  ELSE
  	 RETURN(FALSE);
  END IF;

END;

FUNCTION valida_cierre_libros(
  pCia              in arcgms.no_cia%type,
  pFecha            in arcgae.fecha%type,
  ptipo_comprobante in varchar2
) RETURN BOOLEAN IS
  -- Valida si ya se efectuo el cierre de libros a la fecha 'pFecha'
  --
  -- Obtenemos la fecha para el tipo de libro legal
    CURSOR c_fecha_cierre_libro (pno_cia           in varchar,
                                 ptipo_comprobante in varchar) IS
    SELECT decode(ptipo_comprobante,    'C',fecha_lc,   --libro compras
                                        'D',fecha_ld,   --libro diario
                                        'H',fecha_lh,   --libro honorarios
                                        'M',fecha_lm,   --libro mayor
                                        'V',fecha_lv) fecha_cierre_libro  --libro ventas
      FROM arcgmc
     WHERE no_cia = pno_cia;
  --
  vfecha_cierre_libro   arcgmc.fecha_lc%TYPE;
  vCierreLibro          BOOLEAN;
BEGIN
  vCierreLibro := FALSE;
  OPEN  c_fecha_cierre_libro(pCia, ptipo_comprobante);
  FETCH c_fecha_cierre_libro INTO vfecha_cierre_libro;
  IF c_fecha_cierre_libro%notfound OR ptipo_comprobante IS NULL THEN
    CLOSE c_fecha_cierre_libro;
    genera_error( 'Error en asignacion de fecha de cierre de libro ' );
  END IF;
  CLOSE c_fecha_cierre_libro;
  RETURN(pfecha <= vfecha_cierre_libro);
END;

END;  --cglib
/
