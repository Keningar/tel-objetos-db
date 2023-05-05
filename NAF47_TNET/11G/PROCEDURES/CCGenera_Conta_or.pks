create or replace PROCEDURE            CCGenera_Conta_or (
  cia_p                 varchar2,
  centro_p              varchar2,
  ano_p                 number,
  mes_p                 number,
  fecha_p               date,
  num_asientos_p IN OUT number,
  pError         IN OUT varchar2
) IS
  -- Genera asientos hacia el modulo de Contabilidad General, en forma
  -- resumida o detallada. En el caso de asientos resumidos, estos se generan por
  -- tipo de cambio, cuenta contable, centro de costo y tipo de movimiento.
  -- Datos de la compa?ia en Conta y en CxC
  CURSOR c_conta IS
    SELECT mc.ano_proce, mc.mes_proce, ct.ind_tipo_asientos_cxc
      FROM arcgmc mc, arccct ct
     WHERE mc.no_cia = cia_p
       AND ct.no_cia = mc.no_cia;
  -- Codigos de diarios de los movimientos pendientes de contabilizar.
  CURSOR c_Diarios IS
    SELECT DISTINCT md.Cod_Diario
      FROM arccdc_or dc, arccmd_otros_rec md
     WHERE dc.no_cia       = cia_p
       AND dc.centro       = centro_p
       --AND md.fecha        = fecha_p  --IRQS  15/12/2009
       AND nvl(dc.fec_aplic,md.fecha)        = fecha_p  --Stalyn Arevalo 22/03/2009
       AND dc.ind_con      = 'P'
       AND md.no_cia       = dc.no_cia
       AND md.centro       = dc.centro
       AND md.no_docu      = dc.no_docu
       AND md.estado      != 'P';
  --
  -- Movimientos pendientes de contabilizar (Resumido)
  CURSOR c_mov_dc(pno_asiento varchar2) IS
     SELECT c.codigo, c.centro_costo, c.tipo, c.tipo_cambio, c.moneda,
            c.codigo_tercero,
            sum(nvl(c.monto,0)) M1,
            sum(nvl(c.monto_dol,0)) M2
       FROM arccdc_or c
      WHERE c.no_cia     = cia_p
        AND c.centro     = centro_p
        AND c.no_asiento = pno_asiento
        AND c.ano        = ano_p        -- el ano y el mes, asi como el ind_con = G de
        AND c.mes        = mes_p        -- esta tabla, se "setearon" en el update que
        AND c.ind_con    = 'G'          -- hace dentro del cursor rdiario.
     GROUP BY c.codigo, c.centro_costo,
              c.tipo, c.tipo_cambio, c.moneda, c.codigo_tercero;
  --
  -- Movimientos pendientes de contabilizar (Detallado)
  CURSOR c_mov_dc_det(pno_asiento varchar2) IS
     SELECT c.codigo, c.centro_costo, c.tipo, c.tipo_cambio, c.moneda,
            c.codigo_tercero, c.no_docu, d.tipo_doc||' '||d.no_fisico||'-'||d.serie_fisico DESCRI,
            nvl(c.monto,0) M1,
            nvl(c.monto_dol,0) M2
       FROM arccdc_or c, arccmd_otros_rec d
      WHERE c.no_cia     = cia_p
        AND c.centro     = centro_p
        AND c.no_asiento = pno_asiento
        AND c.ano        = ano_p        -- el ano y el mes, asi como el ind_con = G de
        AND c.mes        = mes_p        -- esta tabla, se "setearon" en el update que
        AND c.ind_con    = 'G'          -- hace dentro del cursor rdiario.
        AND d.no_cia     = c.no_cia
        AND d.no_docu    = c.no_docu
     ORDER BY c.no_docu, c.moneda, c.tipo, c.codigo, c.centro_costo;

  --
  error_proceso exception;
  --
  vasiento      arcgae.no_asiento%TYPE;
  vComprobante  arcgae.no_comprobante%TYPE;
  --
  vcontador     number;
  vtot_db       arcgae.t_debitos%TYPE;
  vtot_cr       arcgae.t_creditos%TYPE;
  vmonto_al     arcgal.monto%TYPE;
  vmonto_dal    arcgal.monto_dol%TYPE;
  vTipo_cambio  arcgal.tipo_cambio%TYPE       :=0;
  --
  vano_cg       arcgmc.ano_proce%TYPE;
  vmes_cg       arcgmc.mes_proce%TYPE;
  vestado       arcgae.estado%TYPE;
  vfecha        date;
  --
  vDescri       arcgae.descri1%type;
  vDescri2      arcgal.descri%type;
  --
  vTipo_asiento varchar2(1);  -- Forma de generar el asiento (R = Resumido, D = detallado)
  vAutorizado   arcgae.autorizado%type;
BEGIN  -- CCGenera_Conta

  num_asientos_p := 0;
  OPEN  c_conta;
  FETCH c_conta INTO vano_cg, vmes_cg, vTipo_asiento;
  CLOSE c_conta;
  IF NVL(ano_p,0) = 0 OR NVL(mes_p, 0) = 0 THEN
  	pError := 'Periodo a generar, incorrecto ';
   	RAISE error_proceso;
  END IF;
  IF (ano_p*100)+mes_p < (vano_cg*100)+vmes_cg THEN
  	-- si el periodo a generar del asiento es menor que el de proceso de la Conta,
  	-- el estado sera de otros meses.
  	vestado     := 'O';
      vAutorizado := 'S';
  ELSE
  	-- sino, entonces se genera asiento con estado pendiente
    vestado     := 'P';
    vAutorizado := 'N';
  END IF;
  --
  -- ajusta la fecha del asiento, si la fecha dada como parametro
  -- no esta dentro del a?o y mes en proceso
  vfecha  := NVL(fecha_p, trunc(sysdate) );
  IF TO_CHAR(vfecha, 'RRRRMM') > TO_CHAR((ano_p*100)+mes_p) THEN
     vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');
     vfecha  := LAST_DAY(vfecha);
  ELSIF TO_CHAR(vfecha, 'RRRRMM') < TO_CHAR((ano_p*100)+mes_p) THEN
     vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');
  ELSE
  	-- si la fecha esta en el periodo, entonces no la calcula sino que la deja como default.
  	vfecha := vfecha;
  END IF;
  --
  -- Genera un asiento agrupando por el codigo de diario de cada movimiento
  FOR rdiario IN c_diarios LOOP
    vcontador := 0;
    --
    vasiento  := Transa_ID.cg(cia_p);
    -- --
    -- marca las linea de detalle contable que seran generadas
    UPDATE arccdc_or dc
       SET ind_con    = 'G',
           no_asiento = vasiento,
           ano        = ano_p,
           mes        = mes_p
       WHERE no_cia   = cia_p
         AND centro   = centro_p
         AND ind_con  = 'P'
         AND exists (SELECT 'x'
                       FROM arccmd_otros_rec
                      WHERE no_cia     = dc.no_cia
                        AND centro     = dc.centro
                        AND no_docu    = dc.no_docu
                        AND cod_diario = rdiario.cod_diario
                        AND NVL(DC.FEC_APLIC,FECHA ) = fecha_p
                        AND estado    != 'P');
    -- ---
    -- Inserta el encabezado del movimiento
    --
    IF vTipo_asiento = 'R' THEN
    	vDescri := 'ASIENTO RESUMIDO GENERADO DESDE CUENTAS POR COBRAR - FECHA : '||fecha_p;
    ELSE -- vTipo_asiento = D
    	vDescri := 'ASIENTO DETALLADO GENERADO DESDE CUENTAS POR COBRAR - FECHA : '||fecha_p;
    END IF;
    INSERT INTO arcgae (NO_CIA,           ANO,        MES,
                        NO_ASIENTO,       FECHA,      ESTADO,
                        AUTORIZADO,       T_DEBITOS,  T_CREDITOS,
                        COD_DIARIO,       ORIGEN,
                        TIPO_COMPROBANTE, NO_COMPROBANTE,   T_CAMB_C_V,
                        DESCRI1)
                VALUES (
                        cia_p,           ano_p,      mes_p,
                        vasiento,        vfecha,     vestado,
                        'N',             0,                0,
                        rdiario.cod_diario,   'CC',
                        'T', '0',  'C',
                        vDescri);
    vtot_db   := 0;
    vtot_cr   := 0;
    --
    IF vTipo_asiento = 'R' THEN
    	--
    	-- si el asiento es resumido
      FOR fila IN c_mov_dc (vasiento) LOOP
        IF (fila.TIPO = 'C') THEN
          vmonto_al  := nvl(fila.M1,0) * -1;
          vmonto_dal := nvl(fila.M2,0) * -1;
          vtot_cr    := nvl(vtot_cr,0) + nvl(fila.M1,0);
        ELSE
          vmonto_al  := nvl(fila.M1,0);
          vmonto_dal := nvl(fila.M2,0);
          vtot_db    := nvl(vtot_db,0) + nvl(fila.M1,0);
        END IF;
        vTipo_cambio := fila.tipo_cambio;
        vcontador := NVL(vcontador,0) + 1;
        vDescri2 := 'GENERADO POR MOD. DE CxC - FECHA : '||fecha_p;
        INSERT INTO arcgal(NO_CIA, ANO,            MES,
                    NO_ASIENTO,    NO_LINEA,       CUENTA,
                    MONTO,         TIPO,           COD_DIARIO,
                    TIPO_CAMBIO,   MONEDA,         CENTRO_COSTO,
                    MONTO_DOL,     CODIGO_TERCERO, DESCRI)
           VALUES ( cia_p,         ano_p,          mes_p,
                    vasiento,      vcontador,      fila.codigo,
                    vmonto_al,     fila.tipo,      rdiario.cod_diario,
                    vtipo_cambio,  fila.moneda,    fila.centro_costo,
                    vmonto_dal,    fila.codigo_tercero, vDescri2 );
      END LOOP; -- de las filas de AL en el asiento resumido
    ELSE -- vTipo_asiento = 'D'
    	--
    	-- si el asiento es detallado
      FOR fila IN c_mov_dc_det (vasiento) LOOP
        IF (fila.TIPO = 'C') THEN
          vmonto_al  := nvl(fila.M1,0) * -1;
          vmonto_dal := nvl(fila.M2,0) * -1;
          vtot_cr    := nvl(vtot_cr,0) + nvl(fila.M1,0);
        ELSE
          vmonto_al  := nvl(fila.M1,0);
          vmonto_dal := nvl(fila.M2,0);
          vtot_db    := nvl(vtot_db,0) + nvl(fila.M1,0);
        END IF;
        vTipo_cambio := fila.tipo_cambio;
        vcontador := NVL(vcontador,0) + 1;
        vDescri2 := SUBSTR(fila.descri||' FECHA : '||fecha_p,1,140);
        INSERT INTO arcgal(NO_CIA, ANO,            MES,
                    NO_ASIENTO,    NO_LINEA,       CUENTA,
                    MONTO,         TIPO,           COD_DIARIO,
                    TIPO_CAMBIO,   MONEDA,         CENTRO_COSTO,
                    MONTO_DOL,     CODIGO_TERCERO, NO_DOCU, DESCRI)
           VALUES ( cia_p,         ano_p,          mes_p,
                    vasiento,      vcontador,      fila.codigo,
                    vmonto_al,     fila.tipo,      rdiario.cod_diario,
                    vtipo_cambio,  fila.moneda,    fila.centro_costo,
                    vmonto_dal,    fila.codigo_tercero, fila.no_docu, vDescri2/*fila.descri*/);
      END LOOP; -- de las filas de AL en el asiento detallado.
    END IF; -- del tipo de asiento (R o D)
    --
    -- --
    -- Revisa si ingreso alguna linea de asiento, sino debe eliminar
    -- el encabezado de asiento generado
    --
    IF vcontador < 1 THEN
      -- sino ingreso detalle contable, borra el encabezado creado
      DELETE arcgae
       WHERE no_cia     = cia_p
         AND ano        = ano_p
         AND mes        = mes_p
         AND no_asiento = vasiento;
    ELSE
      num_asientos_p := nvl(num_asientos_p,0) + 1;
      -- ---------------------------------------------------
      -- Actualiza los debitos y creditos del encabezado del
      -- asiento que se genero
      -- ----------------------------------------------------
      IF vEstado = 'O' THEN
        -- si el asiento corresponde a un mes ya cerrado por Conta
        vComprobante :=  Consecutivo.CG(cia_p,ano_p, mes_p, 'T', 'COMPROBANTE');
      ELSE
        vComprobante := '0';
      END IF;
      UPDATE arcgae
         SET t_debitos      = vtot_db,
             t_creditos     = vtot_cr,
             No_Comprobante = vComprobante,
             autorizado     = vAutorizado
       WHERE no_cia     = cia_p
         AND ano        = ano_p
         AND mes        = mes_p
         AND no_asiento = vasiento;
    END IF;  -- Registro al menos una linea
  END LOOP;  -- Codigos de diario
EXCEPTION
	WHEN error_proceso THEN
       pError := 'CCGENERA_CONTA : '||pError;
	WHEN transa_id.error THEN
       pError := nvl(transa_id.ultimo_error,'ERROR en CCGenera_Conta');
	WHEN consecutivo.error THEN
       pError := nvl(consecutivo.ultimo_error,'ERROR en CCGenera_Conta');
	WHEN others THEN
       pError := sqlerrm;
END;  -- CCGenera_Conta