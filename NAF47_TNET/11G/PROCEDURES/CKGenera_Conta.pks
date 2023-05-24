CREATE OR REPLACE PROCEDURE NAF47_TNET.CKGenera_Conta (
  cia_p            varchar2,
  ano_p            number,
  mes_p            number,
  fecha_p          date,
  cta_p            varchar2,
  num_asientos_p   IN OUT number,
  pError           IN OUT varchar2
) IS

  --* Genera asientos en forma detallada, hacia el modulo de Contabilidad General.
  --* Esto lo hace para los movimientos del periodo dado (ano_p, mes_p).
  --* Si el parametro cta_p es nulo, lo genera para todas las cuentas bancarias.
  --* Devuelve en num_asientos_p la cantidad de asientos que genero hacia Contabilidad.
  --* En caso de error, retorna el mismo en el parametro pError.

-- * Variables
  vmonto_al     arcgal.monto%TYPE;
  vmonto_dal    arcgal.monto_dol%TYPE;
  vtot_db       arcgae.t_debitos%TYPE;
  vtot_cr       arcgae.t_creditos%TYPE;
  vno_asiento   arcgae.no_asiento%TYPE;
  vano_cg       arcgmc.ano_proce%TYPE;
  vmes_cg       arcgmc.mes_proce%TYPE;
  vestado       arcgae.estado%TYPE;
  vno_comprobante arcgae.no_comprobante%TYPE;
  vfecha        date;
  vcontador     number;
  error_proceso exception;
  votros_meses  varchar2(1) ;
  vAutorizado   arcgae.autorizado%type ;
  
-- * Cursores
  -- Datos del periodo en proceso de la compa?ia en Contabilidad
  CURSOR c_conta IS
    SELECT ano_proce, mes_proce
      FROM arcgmc
     WHERE no_cia = cia_p;

  --
  -- Datos de la cuenta bancaria
  CURSOR c_datos_cta IS
    SELECT DISTINCT no_cta, cod_diariom, ano_proc, mes_proc
      FROM arckmc
     WHERE no_cia = cia_p
       -- si el parametro viene nulo, genera para todas las cuentas
       AND no_cta LIKE NVL(cta_p, '%');

  --
  -- Distintos tipos de comprobante
  CURSOR c_tipos_comprobante IS
    SELECT DISTINCT tipo_comprobante
      FROM arcktd
     WHERE no_cia = cia_p;

  --
  -- Cheques y Transferencias pendientes de contabilizar.
  CURSOR c_cheques (p_cta varchar2, p_tipo_comp varchar2) IS
    SELECT cl.cod_cont,       cl.tipo_mov,     NVL(cl.monto,0) M1,
           ce.no_secuencia no_docu, cl.tipo_cambio,  cl.centro_costo,
           cl.Monto_dol,      cl.moneda,       ce.rowid rowid_ce,
           cl.rowid rowid_cl, ce.no_secuencia, codigo_tercero,
           ce.tipo_docu||' '||ce.cheque||'-'||ce.serie_fisico||' '||substr(ce.beneficiario, 1,18)||' :'||cl.glosa  DESCRI
      FROM arckcl cl, arckce ce, arcktd td
     WHERE ce.no_cia           = cia_p
       AND ce.no_cta           = p_cta
       AND ce.no_cia           = cl.no_cia
       AND ce.no_secuencia     = cl.no_secuencia
       AND cl.no_cia           = td.no_cia
       AND cl.tipo_docu        = td.tipo_doc
       AND td.tipo_comprobante = p_tipo_comp
       AND ce.ind_act          != 'P'
       AND ce.emitido          = 'S'
       AND NVL(ce.ind_con,'P') = 'P'
       AND NVL(cl.ind_con,'P') = 'P'
       AND ce.fecha        <= vfecha;

  --
  -- Otros movimientos (Depositos, creditos, debitos) pendientes de contabilizar.
  CURSOR c_movs (p_cta varchar2, p_tipo_comp varchar2) IS
    SELECT ml.cod_cont,       ml.tipo_mov,       NVL(ml.monto,0) M1,
           mm.no_docu,        ml.tipo_cambio,    ml.centro_costo,
           mm.t_camb_c_v,     ml.moneda,         ml.monto_dol,
           mm.rowid rowid_mm, ml.rowid rowid_ml, ml.codigo_tercero,
           mm.tipo_doc||' '||mm.no_fisico||'-'||mm.serie_fisico||' :'||ml.glosa DESCRI
      FROM arckml ml, arckmm mm, arcktd td
     WHERE mm.no_cia                    = cia_p
       AND mm.no_cta                    = p_cta
       AND ml.no_cia                    = mm.no_cia
       AND ml.no_docu                   = mm.no_docu
       AND td.no_cia                    = mm.no_cia
       AND td.tipo_doc                  = mm.tipo_doc
       AND td.tipo_comprobante          = p_tipo_comp
       AND NVL(mm.ind_con,'P')          = 'P'
       AND NVL(ml.ind_con,'P')          = 'P'
       AND mm.procedencia               = 'C'
       AND NVL(mm.estado,'P')           != 'P'
       AND mm.ano                       = ano_p
       AND mm.mes                       = mes_p
       AND mm.fecha                    <= vfecha;



-- *   Funciones Internas
  --
  FUNCTION Asiento_Pendiente (pcia varchar2, pcta varchar2,
                              pano number,   pmes number) RETURN boolean IS

    --* Devuelve TRUE si existen movimientos pendientes de generar
    --* contablemente y FALSE sino.

    vtmp         varchar2(1);
    vencontro_ck boolean;
    vencontro_om boolean;
    --
    -- Cheques y transferencias pendientes de contabilizar.
    CURSOR c_cheques IS
     SELECT 'x'
       FROM arckce
      WHERE no_cia   = pcia
        AND no_cta   = pcta
        AND ind_act != 'P'
        AND NVL(ind_con,'P') = 'P'
        AND emitido = 'S'
        AND fecha  <= vfecha
        AND ROWNUM  = 1;

   --
   -- Otros movimeintos pendientes de contabilizar.
   CURSOR c_movs IS
     SELECT 'x'
       FROM arckmm
      WHERE no_cia           = pcia
        AND no_cta           = pcta
        AND NVL(ind_con,'P') = 'P'
        AND procedencia      = 'C'
        AND estado          != 'P'
        AND ano              = pano
        AND mes              = pmes
        AND fecha        <= vfecha
        AND ROWNUM = 1;

  BEGIN  -- Asiento_Pendiente
    --* Busca cheques y transferencias pendientes de contabilizar
    OPEN  c_cheques;
    FETCH c_cheques INTO vtmp;
    vencontro_ck := c_cheques%FOUND;
    CLOSE c_cheques;

    --* Busca si existen otros movimientos pendientes de contabilizar.
    OPEN  c_movs;
    FETCH c_movs INTO vtmp;
    vencontro_om := c_movs%FOUND;
    CLOSE c_movs;

    RETURN((vencontro_ck OR vencontro_om));

  END;  -- Asiento_Pendiente


-- ---
-- Cuerpo principal del procedimiento
--
BEGIN -- CKGenera_Conta

  num_asientos_p  := 0;

  OPEN  c_conta;
  FETCH c_conta INTO vano_cg, vmes_cg;
  CLOSE c_conta;

  FOR cta IN c_datos_cta LOOP
  	-- Cursor para recorrer todas las cuentas bancarias de la compania. Esto solo
  	-- cuando el parametro cta_p es nulo. En otro caso, solo entraria una vez para
  	-- la cuenta dada.

    IF NVL(cta.ano_proc,0)= 0 OR NVL(cta.mes_proc,0) = 0 THEN
    	pError := 'Error en la definicion del periodo en proceso para la cuenta '||cta.no_cta;
    	RAISE error_proceso;
    END IF;

    IF (ano_p*100)+mes_p < (vano_cg*100)+vmes_cg THEN
  	  -- si el periodo a generar del asiento es menor que el de proceso de la Conta,
  	  -- el estado sera de otros meses.
  	  vEstado     := 'O';
  	  vAutorizado := 'S';
    ELSE
      vestado     := 'P';
      vAutorizado := 'N';
    END IF;

    votros_meses  := 'N';

    IF (ano_p*100)+ mes_p < (cta.ano_proc*100) + cta.mes_proc  THEN
    	-- determina si el asiento a generar es de algun movimiento de meses
    	-- anteriores al de la cuenta bancaria.
      votros_meses := 'S';
    END IF;

    vfecha  := NVL(fecha_p, sysdate);
    IF TO_CHAR(vfecha, 'RRRRMM') > TO_CHAR((ano_p*100)+mes_p) THEN
      vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');
      vfecha  := LAST_DAY(vfecha);
    ELSIF TO_CHAR(vfecha, 'RRRRMM') < TO_CHAR((ano_p*100)+mes_p) THEN
      vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');
    ELSE
    	-- si la fecha esta en el periodo, entonces no la calcula sino que la deja como default.
    	vfecha := vfecha;
    END IF;

/*
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
*/

    IF Asiento_Pendiente (cia_p, cta.no_cta, ano_p, mes_p) THEN
    	-- si existen movimientos por contabilizar.

      FOR l_tipo_mov IN c_tipos_comprobante LOOP
        -- --
        -- Inicializar los valores de las variables que se utilizan
        --

        vcontador    := 1;
        vtot_db      := 0;
        vtot_cr      := 0;
        vno_asiento  := NULL;

        -- ---
        -- Inserta las lineas del asiento para los movimientos generados
        -- por la emision de cheques, solo cuando el asiento no es de movimientos
        -- de otros meses, pues los cheques y transferencias solo se hacen en el
        -- periodo en proceso
        --
        IF votros_meses  = 'N' THEN
          FOR fila IN c_cheques(cta.no_cta, l_tipo_mov.tipo_comprobante) LOOP

            IF vcontador = 1 THEN
            	-- Entra solo una vez a crear el encabezado por cada tipo de comprobante.
              vno_asiento    := transa_id.cg(cia_p);
              num_asientos_p := num_asientos_p + 1;

              -- -------------------------------------------------------------------
              -- Crea el Encabezado del Asiento, posteriormente le pone el total
              -- de debitos y creditos del mismo.
              --
              INSERT INTO arcgae (NO_CIA,     ANO,                MES,
                          NO_ASIENTO,         FECHA,              ESTADO,
                          AUTORIZADO,         ANULADO,            COD_DIARIO,
                          ORIGEN,             TIPO_COMPROBANTE,   NO_COMPROBANTE,
                          DESCRI1)
                   VALUES (cia_p,             ano_p,              mes_p,
                          vno_asiento,        vfecha,             vestado,
                          vautorizado,        'N',                cta.cod_diariom,
                          'CK',               l_tipo_mov.tipo_comprobante, 0,
                          SUBSTR('ASIENTO DETALLADO GENERADO DESDE CHEQUES Y CONCILIACIONES, CUENTA BANCARIA '||cta.no_cta||'-'||fila.descri,1,240));
            END IF;

            vmonto_al := 0;
            IF (fila.TIPO_MOV = 'C') then
              vmonto_al   := -1*fila.M1;
              vmonto_dal  := -1*nvl(fila.monto_dol,0);
              vtot_cr     := NVL(vtot_cr,0)+nvl(fila.M1,0);
            ELSE
              vmonto_al   := fila.M1;
              vmonto_dal  := nvl(fila.monto_dol,0);
              vtot_db     := NVL(vtot_db,0)+nvl(fila.M1,0);
            END IF;

            INSERT INTO ARCGAL (NO_CIA,        ANO,          MES,
                                NO_ASIENTO,    NO_LINEA,     CUENTA,
                                MONTO,         TIPO,         DESCRI,
                                NO_DOCU,       COD_DIARIO,   MONEDA,
                                TIPO_CAMBIO,   CENTRO_COSTO, MONTO_DOL,
                                CODIGO_TERCERO,fecha)
                 VALUES (cia_p,               ano_p,             mes_p,
                         vno_asiento,         vcontador,         fila.cod_cont,
                         vmonto_al,           fila.tipo_mov,     substr(fila.descri,1,50),
                         fila.no_docu,        cta.cod_diariom,   fila.moneda,
                         fila.tipo_cambio,    fila.centro_costo, vmonto_dal,
                         fila.codigo_tercero, vfecha);

            vcontador := NVL(vcontador,0) + 1;

            -- Actualiza no_asiento para la linea del cheque procesada --
            UPDATE arckcl
               SET ind_con    = 'G',
                   ano        = ano_p,
                   mes        = mes_p,
                   no_asiento = vno_asiento
             WHERE rowid = fila.rowid_cl;

            -- Actualiza el indicador de contabilizado para el cheque o transferencia
            UPDATE arckce
               SET ind_con    = 'G',
                   no_asiento = vno_asiento
             WHERE rowid = fila.rowid_ce;

            -- Actualiza el indicador de contabilizado para el mismo movimiento en ARCKMM
            UPDATE arckmm
               SET ind_con = 'G'
             WHERE no_cia  = cia_p
               AND no_docu = fila.no_secuencia;

          END LOOP;   -- de cheques y transferencias
        END IF; -- de votros_meses = 'N'

        -- ----------------------------------------------------------------
        -- Inserta las lineas de asiento para los movimientos generados
        -- por el ingresos de otros movimientos
        --
        FOR fila in c_movs (cta.no_cta, l_tipo_mov.tipo_comprobante) loop
          IF vcontador  = 1 THEN
            vno_asiento := transa_id.cg(cia_p);

            num_asientos_p := num_asientos_p + 1;

            -- -------------------------------------------------------------------
            -- Crea el Encabezado del Asiento, posteriormente le pone el total
            -- de debitos y creditos del mismo
            -- -------------------------------------------------------------------

            INSERT INTO ARCGAE (NO_CIA,      ANO,                   MES,
                        NO_ASIENTO,          FECHA,                 ESTADO,
                        AUTORIZADO,          ANULADO,               COD_DIARIO,
                        ORIGEN,              TIPO_COMPROBANTE,      NO_COMPROBANTE,
                        DESCRI1)
                 VALUES (cia_p,              ano_p,                mes_p,
                        vno_asiento,         vfecha,               vestado,
                        vAutorizado,         'N',                  cta.cod_diariom,
                        'CK',                l_tipo_mov.tipo_comprobante, 0,
                        SUBSTR('ASIENTO DETALLADO GENERADO DESDE CHEQUES Y CONCILIACIONES, CUENTA BANCARIA '||cta.no_cta||' - '||fila.descri,1,240));

          END IF;

          vmonto_al := 0;
          IF (fila.tipo_mov = 'C') THEN
            vmonto_al   := -1*fila.m1;
            vmonto_dal  := -1*nvl(fila.monto_dol,0);
            vtot_cr     := nvl(vtot_cr,0)+nvl(fila.m1,0);
          ELSE
            vmonto_al   := fila.m1;
            vmonto_dal  := nvl(fila.monto_dol,0);
            vtot_db     := nvl(vtot_db,0)+nvl(fila.m1,0);
          END IF;

          INSERT INTO arcgal (no_cia,      ano,          mes,
                              no_asiento,  no_linea,     cuenta,
                              monto,       tipo,         descri,
                              no_docu,     cod_diario,   moneda,
                              tipo_cambio, centro_costo, monto_dol,
                              codigo_tercero,fecha)
                      VALUES (cia_p,               ano_p,             mes_p,
                              vno_asiento,         vcontador,         fila.cod_cont,
                              vmonto_al,           fila.tipo_mov,     SUBSTR(fila.descri,1,50),
                              fila.no_docu,        cta.cod_diariom,   fila.moneda,
                              fila.tipo_cambio,    fila.centro_costo, vmonto_dal,
                              fila.codigo_tercero, vfecha);

          vcontador := nvl(vcontador,0)+1;

          -- Actualiza no_asiento para la linea del movimiento procesada --
          UPDATE arckml
             SET ind_con    = 'G',
                 ano        = ano_p,
                 mes        = mes_p,
                 no_asiento = vno_asiento
           WHERE rowid = fila.rowid_ml;

          --
          UPDATE arckmm
             SET ind_con  = 'G'
           WHERE rowid = fila.rowid_mm;

        END LOOP;  -- movimientos
        --
        -- --
        -- Actualiza el total de debitos y creditos del encabezado del asiento
        --
        IF vno_asiento IS NOT NULL THEN

          IF vestado = 'O' THEN
          	-- obtiene numero de comprobante, cuando el asiento generado corresponde
          	-- es de un periodo ya cerrado en Contabilidad.
            vno_comprobante := Consecutivo.cg(cia_p,ano_p,mes_p,l_tipo_mov.tipo_comprobante,'COMPROBANTE');
          ELSE
            vno_comprobante := 0;
          END IF;

          -- Actualiza datos del encabezado del asiento generado
          UPDATE arcgae
             SET t_debitos      = vtot_db,
                 t_creditos     = vtot_cr,
                 t_camb_c_v     = 'V',
                 no_comprobante = vno_comprobante
           WHERE no_cia     = cia_p
             AND no_asiento = vno_asiento;
        END IF;

      END LOOP; -- tipos de comprobante

    END IF;  -- de asientos_pendientes

  END LOOP; -- ctas bancarias

EXCEPTION
	WHEN error_proceso THEN
       pError := 'ERROR en CKGENERA_CONTA : '||pError;

	WHEN transa_id.error THEN
       pError := transa_id.ultimo_error;

	WHEN consecutivo.error THEN
       pError := consecutivo.ultimo_error;

	WHEN others THEN
       pError := 'ERROR en CKGENERA_CONTA : '||sqlerrm;

END; -- CKGenera_Conta
/