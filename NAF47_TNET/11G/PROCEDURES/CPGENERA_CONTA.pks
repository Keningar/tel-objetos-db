CREATE OR REPLACE PROCEDURE NAF47_TNET.CPGENERA_CONTA (

  cia_p                    varchar2,

  ano_p                    number,

  mes_p                    number,

  fecha_p                  date,

  num_asientos_p    IN OUT number,

  pError            IN OUT varchar2

) IS

  /*

  * Mejora para aumento del campo glosa parametrizado el maximo de la glosa

  * @tag  JXZURITA-AUMENTO CAMPO GLOSA

  * @author jxzurita <jxzurita@telconet.ec>

  * @version 2.0 06/10/2021

  */

  /*

  * Se asigna a variable valor de limite de glosa

  * @author banton <banton@telconet.ec>

  * @version 2.1 30/11/2022

  */





  -- --

  -- Genera asientos hacia el modulo de Contabilidad General, resumidos por

  -- tipo de cambio, cuenta contable, centro de costo y tipo de movimiento.

  vcontador       number;

  vtot_db         arcgae.t_debitos%TYPE;

  vtot_cr         arcgae.t_creditos%TYPE;

  vmonto_al       arcgal.monto%TYPE;

  vmonto_dal      arcgal.monto_dol%TYPE;

  vTCamb_C_V      varchar2(1);

  vasiento        arcgae.no_asiento%TYPE;

  vComprobante    Arcgae.no_comprobante%type;

  vTipo_cambio    arcgal.tipo_cambio%TYPE       :=0;

  vano_cg         arcgmc.ano_proce%TYPE;

  vmes_cg         arcgmc.mes_proce%TYPE;

  vfecha          date;

  error_proceso   exception;

  vestado         arcgae.estado%TYPE;

  vAutorizado     arcgae.autorizado%type;

  FECHA1 NUMBER;

  FECHA2 NUMBER;
  GLOSA NUMBER;

  -- Datos de la compa?ia en Conta y en cxp

  CURSOR c_conta IS

    SELECT mc.ano_proce, mc.mes_proce, ct.ind_tipo_asientos

      FROM arcgmc mc, arcpct ct

     WHERE mc.no_cia = cia_p

       AND ct.no_cia = mc.no_cia;

  -- Codigos de diarios de los movimientos pendientes de contabilizar.

  CURSOR c_Diarios IS

    SELECT DISTINCT md.Cod_Diario

      FROM arcpdc dc, arcpmd md

     WHERE dc.no_cia       = cia_p

       AND dc.ind_con      = 'P'

       AND dc.ano          = ano_p

       AND dc.mes          = mes_p

       AND md.no_cia       = dc.no_cia

       AND md.no_docu      = dc.no_docu

       AND md.ind_act      != 'P'

       AND md.fecha        <= vfecha;

  -- movimientos pendientes de contabilizar (en forma resumida)

  CURSOR c_movs(pno_asiento varchar2) IS

    SELECT d.t_camb_c_v,  c.codigo, c.centro_costo,

           c.tipo, c.tipo_cambio, c.moneda,

           c.codigo_tercero,

           sum(c.monto)     M1,

           sum(c.monto_dol) M2

      FROM arcpdc c, arcpmd d

     WHERE c.no_cia        = cia_p

       AND c.no_asiento    = pno_asiento

       AND c.ano           = ano_p

       AND c.mes           = mes_p

       AND c.ind_con       = 'G'          -- el update dentro del cursor rdiario

                                          -- pone este indicador en 'G'

       AND d.no_cia        = c.no_cia

       AND d.no_docu       = c.no_docu

       AND d.fecha        <= vfecha

     GROUP BY d.t_camb_c_v,  c.codigo, c.centro_costo,

              c.tipo, c.tipo_cambio, c.moneda, c.codigo_tercero;

  --

  -- movimientos pendientes de contabilizar (en forma detallada)

  CURSOR c_movs_det(pno_asiento varchar2) IS

    SELECT d.t_camb_c_v,  c.codigo, c.centro_costo,

           c.tipo, c.tipo_cambio, c.moneda,

           c.codigo_tercero, c.no_docu, d.tipo_doc||' '||d.no_fisico||'-'||d.serie_fisico||'-'||c.glosa  DESCRI,

           nvl(c.monto,0)     M1,

           nvl(c.monto_dol,0) M2

      FROM arcpdc c, arcpmd d

     WHERE c.no_cia        = cia_p

       AND c.no_asiento    = pno_asiento

       AND c.ano           = ano_p

       AND c.mes           = mes_p

       AND c.ind_con       = 'G'          -- el update dentro del cursor rdiario

                                          -- pone este indicador en 'G'

       AND d.no_cia        = c.no_cia

       AND d.no_docu       = c.no_docu

       AND d.fecha        <= vfecha

     ORDER BY d.t_camb_c_v,  c.codigo, c.centro_costo,

              c.tipo, c.tipo_cambio, c.moneda, c.codigo_tercero;

  --

  vDescri       arcgae.descri1%type;

  vTipo_asiento varchar2(1);  -- Forma de generar el asiento (R = Resumido, D = detallado)

BEGIN -- CPGenera_Conta

  Moneda.Inicializa(cia_p);

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

      vestado     := 'P';

      vAutorizado := 'N';

  END IF;

  --

  -- ajusta la fecha del asiento, si la fecha dada como parametro

  -- no esta dentro del a?o y mes en proceso

  vfecha  := NVL(to_char(fecha_p,'ddmmyyyy'), trunc(sysdate) );

  FECHA1 := TO_NUMBER(TO_CHAR(vfecha, 'RRRRMM'));

  FECHA2 := TO_NUMBER(TO_CHAR((ano_p*100)+mes_p));



  IF TO_NUMBER(TO_CHAR(vfecha, 'RRRRMM')) > TO_NUMBER(TO_CHAR((ano_p*100)+mes_p)) THEN

     vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');

     vfecha  := LAST_DAY(vfecha);

  ELSIF TO_NUMBER(TO_CHAR(vfecha, 'RRRRMM')) < TO_NUMBER(TO_CHAR((ano_p*100)+mes_p)) THEN

     vfecha  := TO_DATE('01'||TO_CHAR(mes_p,'00')||TO_CHAR(ano_p),'DDMMRRRR');

  ELSE

    -- si la fecha esta en el periodo, entonces no la calcula sino que la deja como default.

    vfecha := vfecha;

  END IF;

  -------------------------------------------------------------

  -- se actualiza campo que indica contabilizado a pendiente --

  -- a aquellos que se encuentran registros que tienen nulos --

  -------------------------------------------------------------

  UPDATE arcpdc dc

     SET dc.ind_con = 'P'

   WHERE dc.no_cia       = cia_p

     AND dc.ano          = ano_p

     AND dc.mes          = mes_p

     AND dc.ind_con      IS NULL

     AND EXISTS (SELECT NULL

                   FROM arcpmd md

                  WHERE md.no_cia = dc.no_cia

                    AND md.no_docu = dc.no_docu

                    AND md.ind_act != 'P'

                    AND md.fecha <= vfecha);



  -- Genera un asiento agrupando por el codigo de diario de cada movimiento

  FOR rdiario  IN c_diarios LOOP

    vcontador := 0;

    vtot_db   := 0;

    vtot_cr   := 0;

    --

    vasiento  := Transa_ID.cg(cia_p);

    -- --

    -- marca las linea de detalle contable que deben ser generadas

    UPDATE arcpdc dc

       SET ind_con    = 'G',

           no_asiento = vasiento

     WHERE no_cia     = cia_p

       AND ind_con    = 'P'

       AND ano        = ano_p

       AND mes        = mes_p

       AND exists (SELECT no_docu

                     FROM arcpmd

                    WHERE no_cia     = dc.no_cia

                      AND no_docu    = dc.no_docu

                      AND cod_diario = rdiario.cod_diario

                      AND fecha        <= to_char(vfecha,'ddmmyyyy')

                      AND ind_act    != 'P');

    -- --

    -- Inserta el encabezado del movimiento

    --

    IF vTipo_asiento = 'R' THEN

      vDescri := 'ASIENTO RESUMIDO GENERADO DESDE CUENTAS POR PAGAR';

    ELSE -- vTipo_asiento = D

      vDescri := 'ASIENTO DETALLADO GENERADO DESDE CUENTAS POR PAGAR';

    END IF;

    INSERT INTO arcgae (NO_CIA,   ANO,        MES,

                        NO_ASIENTO,       FECHA,      ESTADO,

                        AUTORIZADO,       T_DEBITOS,  T_CREDITOS,

                        COD_DIARIO,       ORIGEN,

                        TIPO_COMPROBANTE, NO_COMPROBANTE,

                        DESCRI1)

                VALUES (cia_p,           ano_p,      mes_p,

                        vasiento,        vfecha,     vestado,

                        'N',             0,                0,

                        rdiario.cod_diario,   'CP',

                        'T', '0',

                        vDescri);

    --

    IF vTipo_asiento = 'R' THEN

      --

      -- si el asiento es resumido.

      FOR fila IN c_movs (vasiento) LOOP

         vmonto_al := 0;

         IF (fila.tipo = 'C') THEN

            vmonto_al  := Moneda.redondeo(-1*fila.M1, 'P');

            vmonto_dal := Moneda.redondeo(-1*fila.M2, 'D');

            vtot_cr    := NVL(vtot_cr,0) + NVL(fila.M1,0);

         ELSE

            vmonto_al  := Moneda.redondeo(fila.M1, 'P');

            vmonto_dal := Moneda.redondeo(fila.M2, 'D');

            vtot_db    := NVL(vtot_db,0) + NVL(fila.M1,0);

         END IF;

         vTipo_cambio := fila.tipo_cambio;

         vcontador := NVL(vcontador,0) + 1;

         INSERT INTO arcgal (  NO_CIA,        ANO,            MES,

                               NO_ASIENTO,    NO_LINEA,       CUENTA,

                               MONTO,         TIPO,           COD_DIARIO,

                               TIPO_CAMBIO,   MONEDA,         CENTRO_COSTO,

                               MONTO_DOL,     CODIGO_TERCERO, DESCRI)

                     VALUES (  cia_p,         ano_p,          mes_p,

                               vasiento,      vcontador,      fila.codigo,

                               vmonto_al,     fila.tipo,      rdiario.cod_diario,

                               vtipo_cambio,  fila.moneda,    fila.centro_costo,

                               vmonto_dal,    fila.codigo_tercero, 'GENERADO POR MOD. DE CxP' );

         vTCamb_C_V := fila.t_Camb_C_V;

      END LOOP; -- de las filas de AL en un asiento resumido.

    ELSE -- vtipo_asiento = 'D'

      --

      -- si el asiento es detallado

      FOR fila IN c_movs_det (vasiento) LOOP

         vmonto_al := 0;

         IF (fila.tipo = 'C') THEN

            vmonto_al  := Moneda.redondeo(-1*fila.M1, 'P');

            vmonto_dal := Moneda.redondeo(-1*fila.M2, 'D');

            vtot_cr    := NVL(vtot_cr,0) + NVL(fila.M1,0);

         ELSE

            vmonto_al  := Moneda.redondeo(fila.M1, 'P');

            vmonto_dal := Moneda.redondeo(fila.M2, 'D');

            vtot_db    := NVL(vtot_db,0) + NVL(fila.M1,0);

         END IF;

         vTipo_cambio := fila.tipo_cambio;

         vcontador := NVL(vcontador,0) + 1;
         GLOSA :=  F_TAM_GLOSA_CONT(cia_p,'AG_CPGENERACONTA',50);

         INSERT INTO arcgal (  NO_CIA,        ANO,            MES,

                               NO_ASIENTO,    NO_LINEA,       CUENTA,

                               MONTO,         TIPO,           COD_DIARIO,

                               TIPO_CAMBIO,   MONEDA,         CENTRO_COSTO,

                               MONTO_DOL,     CODIGO_TERCERO, NO_DOCU, DESCRI)

                     VALUES (  cia_p,         ano_p,          mes_p,

                               vasiento,      vcontador,      fila.codigo,

                               vmonto_al,     fila.tipo,      rdiario.cod_diario,

                               vtipo_cambio,  fila.moneda,    fila.centro_costo,

                               vmonto_dal,    fila.codigo_tercero,

                               fila.no_docu,

                               --JXZURITA-AUMENTO CAMPO GLOSA INICIO

                               --substr(fila.descri,1,50)

                               substr(fila.descri,1, GLOSA)

                               --JXZURITA-AUMENTO CAMPO GLOSA FIN

                               );

         vTCamb_C_V := fila.t_Camb_C_V;

      END LOOP; -- de las filas de AL en un asiento detallado

    END IF;  -- del tipo de asiento (R / D)

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

       -- asiento

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

             t_camb_c_v     = vtcamb_c_v,

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

       pError := 'CPGENERA_CONTA : '||pError;

  WHEN transa_id.error THEN

       pError := nvl(transa_id.ultimo_error,'CPGENERA_CONTA');

  WHEN consecutivo.error THEN

       pError := nvl(consecutivo.ultimo_error,'CPGENERA_CONTA');

  WHEN others THEN

       pError := sqlerrm;

END;  -- CPGenera_Conta
/