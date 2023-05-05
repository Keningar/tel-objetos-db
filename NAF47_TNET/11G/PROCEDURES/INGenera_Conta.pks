create or replace PROCEDURE            INGenera_Conta (
  cia_p                 varchar2,
  centro_p              varchar2,
  ano_p                 number,
  mes_p                 number,
  fecha_p               date,
  cod_diario_p          varchar2,
  num_asiento_p  IN OUT number,
  pError         IN OUT varchar2
  ) IS

  --
  error_proceso exception;
  vencontro    boolean;
  vtmp         number;
  vlinea       number;
  vper_conta   number;
  vper_proce   number;
  vf_asiento   date;
  vestado_ad   arcgae.estado%type;
  diarioC      arcgae.cod_diario%TYPE       := cod_diario_p;
  vano_proce   arcgae.ano%TYPE              := ano_p;
  vmes_proce   arincd.mes_proce%TYPE        := mes_p;
  vno_asiento  arcgae.NO_ASIENTO%TYPE;
  monto_al     arcgal.monto%TYPE;
  monto_Dal    arcgal.monto_DOL%TYPE;
  tot_db       arcgae.t_debitos%TYPE;
  tot_cr       arcgae.t_creditos%TYPE;
  vtcambio     arcgal.tipo_cambio%type;
  vAutorizado  arcgae.autorizado%type;
  --
  -- datos de la compa?ia contable y en inventario
  CURSOR c_datos_cia IS
    SELECT ((mc.ano_proce*100)+mc.mes_proce), c.ind_tipo_asientos_inv
      FROM arcgmc mc, arinmc c
     WHERE mc.no_cia = cia_p
       AND c.no_cia  = mc.no_cia;
  --
  -- informacion contable (en forma resumida)
  CURSOR c_dist_contable IS
    SELECT tipo_mov, cuenta, centro_costo,
           codigo_tercero, tipo_cambio,
           sum(nvl(monto,0)) M1,
           sum(nvl(monto_dol,0)) M2
      FROM arindc
     WHERE no_cia     = cia_p
       AND centro     = centro_p
       AND ind_gen    = 'S'
       AND no_docu IN (select no_docu from arinme where no_cia = cia_p and centro = centro_p and fecha =  fecha_p)
       AND ano        = vano_proce
       AND mes        = vmes_proce
       AND no_asiento = vno_asiento
    GROUP BY tipo_mov, cuenta, centro_costo,tipo_cambio, codigo_tercero
    HAVING (sum(nvl(monto,0)) != 0 OR sum(nvl(monto_dol,0)) != 0);
  --
  -- informacion contable (en forma detallada)
  CURSOR c_dist_contable_det IS
    SELECT d.tipo_mov, d.cuenta, d.centro_costo, d.codigo_tercero,
           d.no_docu, d.tipo_cambio, e.tipo_doc||' '||e.no_fisico||'-'||e.serie_fisico DESCRI,
           nvl(d.monto,0) M1,
           nvl(d.monto_dol,0) M2
      FROM arindc d, arinme e
     WHERE d.no_cia     = cia_p
       AND d.centro     = centro_p
       AND d.ind_gen    = 'S'
       AND e.fecha      = fecha_p
       AND d.ano        = vano_proce
       AND d.mes        = vmes_proce
       AND d.no_asiento = vno_asiento
       AND (nvl(d.monto,0) != 0 OR nvl(d.monto_dol,0) != 0)
       AND e.no_cia     = d.no_cia
       AND e.no_docu    = d.no_docu
    ORDER BY tipo_mov, cuenta, centro_costo, codigo_tercero;
    --
    CURSOR c_asiento_existe (asi_p NUMBER)IS
      SELECT 1
        FROM arcgae
       WHERE no_cia     = cia_p
         AND ano        = ano_p
         AND mes        = mes_p
         AND no_asiento =  asi_p;

    Cursor C_Centro Is
     select nombre
     from   arincd
     where  no_cia = cia_p
     and    centro = centro_p;
  --
  vDescri          arcgae.descri1%type;
  vTipo_asiento    varchar2(1);  -- Forma de generar el asiento (R = Resumido, D = detallado)

  Lv_nombre_centro Arincd.nombre%type;

BEGIN

  -- obtiene un numero de asiento
  num_asiento_p := transa_id.cg(cia_p);


  -- Obtiene datos de la compa?ia
  OPEN  c_datos_cia;
  FETCH c_datos_cia INTO vper_conta, vTipo_asiento;
  CLOSE c_datos_cia;

  -- Determina el estado del asiento (P=Pendiente u O=Otros meses)
  vper_proce := (vano_proce*100)+vmes_proce;
  if vper_proce < vper_conta then
     vestado_ad  := 'O';
     vAutorizado := 'S';
  else
     vestado_ad  := 'P';
     vAutorizado := 'N';
  end if;

  --
  vlinea      := 0;
  vno_asiento := num_asiento_p;
  tot_db      := 0;
  tot_cr      := 0;

  vf_asiento  := TRUNC(fecha_p);
  --- La fecha del asiento contable siempre debe generarse con la fecha de las transacciones ANR 03/08/2011
  /*IF to_char(vf_asiento,'YYYYMM') > vper_proce THEN
    vf_asiento := LAST_DAY(to_date(vper_proce,'YYYYMM')); -- ultimo dia del mes en proceso
  ELSIF to_char(vf_asiento,'YYYYMM') < vper_proce then
    vf_asiento := to_date(vper_proce,'YYYYMM');  -- primer dia del mes en proceso
  END IF;*/

  --- Se valida que la fecha sea igual al mes y anio ANR 03/08/2011 ***/

  If to_number(to_char(fecha_p,'MM')) != vmes_proce Then
     pError := 'El mes de proceso: '||vmes_proce||' no corresponde al mes de la fecha: '||to_char(fecha_p,'dd/mm/yyyy')||' para el centro: '||centro_p;
     raise error_proceso;
  end if;

   If to_number(to_char(fecha_p,'YYYY')) != vano_proce Then
     pError := 'El a?o de proceso: '||vano_proce||' no corresponde al a?o de la fecha: '||to_char(fecha_p,'dd/mm/yyyy')||' para el centro: '||centro_p;
     raise error_proceso;
  end if;

/*
  OPEN  c_asiento_existe(vno_asiento);
  FETCH c_asiento_existe INTO vtmp;
  vencontro := c_asiento_existe%FOUND;
  CLOSE c_asiento_existe;
  IF vencontro THEN
    pError := 'El asiento '||vno_asiento||' ya existe en contabilidad '||
              to_char(ano_p) || '-' || to_char(mes_p);
    RAISE error_proceso;
  END IF;  */

  Open C_Centro;
  Fetch C_Centro into Lv_nombre_centro;
  If C_Centro%notfound Then
  Close C_Centro;
  Lv_nombre_centro := null;
  else
  Close C_Centro;
  end if;

  IF vTipo_asiento = 'R' THEN
     vDescri := 'ASIENTO RESUMIDO GENERADO DESDE INVENTARIOS '||' CENTRO: '||centro_p||' '||LV_NOMBRE_CENTRO;
  ELSE -- vTipo_asiento = D
    vDescri := 'ASIENTO DETALLADO GENERADO DESDE INVENTARIOS '||' CENTRO: '||centro_p||' '||LV_NOMBRE_CENTRO;
  END IF;

  INSERT INTO arcgae(no_cia,        ano,        mes,        no_asiento,
                     fecha,         estado,     autorizado, descri1,
                     origen,        t_camb_c_v, cod_diario, tipo_comprobante,
                     no_comprobante)
              VALUES(cia_p, vano_proce,    vmes_proce, vno_asiento,
                     vf_asiento,  vestado_ad, 'N',     vDescri,
                     'IN',              'C',        diarioC, 'T',
                     '0');

  -- Marca las lineas de detalle contable, con las que se generara el asiento
  UPDATE arindc
     SET ind_gen    = 'S',
         ano        = vano_proce,
         mes        = vmes_proce,
         no_asiento = vno_asiento
   WHERE no_cia   = cia_p
     AND centro   = centro_p
     AND ind_gen  = 'N'
     AND no_docu IN (select no_docu from arinme where no_cia = cia_p and centro = centro_p and fecha =  fecha_p);

  IF vTipo_asiento = 'R' THEN
    --
    -- si el asiento se genera en forma resumida...
    FOR fila IN c_dist_contable LOOP

      vTcambio := fila.tipo_cambio;

      monto_al  := 0;
      monto_dal := 0;
      IF (fila.tipo_mov = 'C') then
        monto_al  := nvl(-1 * fila.M1, 0);
        monto_dal := nvl(-1 * fila.M2, 0);
        tot_cr    := nvl(TOT_CR,0) + nvl(fila.M1,0);
      ELSE
        monto_al  := nvl(fila.M1, 0);
        monto_dal := nvl(fila.M2, 0);
        tot_db    := nvl(TOT_DB,0) + nvl(fila.M1,0);
      END IF;

      vlinea := vlinea + 1;

      INSERT INTO ARCGAL(NO_CIA,   ANO,        MES,         NO_ASIENTO,
                         NO_LINEA, CUENTA,     NO_DOCU,     TIPO,
                         DESCRI,   COD_DIARIO, TIPO_CAMBIO,
                         CC_1,
                         CC_2,
                         CC_3,
                         MONEDA,      MONTO,   MONTO_DOL, codigo_tercero)
                  VALUES(cia_p,    vano_proce,     vmes_proce,     vno_asiento,
                         vlinea,         fila.cuenta, vno_asiento, fila.TIPO_MOV,
                         'Mov. de inventario',          diarioC,     vTcambio,
                         substr(fila.centro_costo,1,3),
                         substr(fila.centro_costo,4,3),
                         substr(fila.centro_costo,7,3),
                         'P',            MONTO_AL,    MONTO_DAL,    fila.codigo_tercero );

    END LOOP;  -- del asiento resumido
  ELSE  -- vtipo_asiento = 'D'
    --
    -- si el asiento se genera en forma detallada...
    FOR fila IN c_dist_contable_det LOOP

      monto_al  := 0;
      monto_dal := 0;
      IF (fila.tipo_mov = 'C') then
        monto_al  := nvl(-1 * fila.M1, 0);
        monto_dal := nvl(-1 * fila.M2, 0);
        tot_cr    := nvl(TOT_CR,0) + nvl(fila.M1,0);
      ELSE
        monto_al  := nvl(fila.M1, 0);
        monto_dal := nvl(fila.M2, 0);
        tot_db    := nvl(TOT_DB,0) + nvl(fila.M1,0);
      END IF;

      vlinea := vlinea + 1;

      INSERT INTO ARCGAL(NO_CIA,   ANO,        MES,         NO_ASIENTO,
                         NO_LINEA, CUENTA,     NO_DOCU,     TIPO,
                         DESCRI,   COD_DIARIO, TIPO_CAMBIO,
                         CC_1,
                         CC_2,
                         CC_3,
                         MONEDA,      MONTO,   MONTO_DOL, codigo_tercero)
                  VALUES(cia_p,    vano_proce,     vmes_proce,     vno_asiento,
                         vlinea,         fila.cuenta, fila.no_docu, fila.tipo_mov,
                         fila.descri,    diarioC,   fila.tipo_cambio,
                         substr(fila.centro_costo,1,3),
                         substr(fila.centro_costo,4,3),
                         substr(fila.centro_costo,7,3),
                         'P',            MONTO_AL,    MONTO_DAL,    fila.codigo_tercero );

    END LOOP;  -- del asiento detallado
  END IF; -- de la forma de generar el asiento (R/D)

  IF vlinea = 0 THEN

    DELETE arcgae
      WHERE no_cia     = cia_p
        AND ano        = vano_proce
        AND mes        = vmes_proce
        AND no_asiento = vno_asiento;

  ELSE
    UPDATE arcgae
       SET t_debitos  = tot_db,
           t_creditos = tot_cr,
           autorizado = vAutorizado
     WHERE no_cia = cia_p
       AND ano    = vano_proce
       AND mes    = vmes_proce
       AND no_asiento = vno_asiento;

  END IF;
-- NULL;
EXCEPTION
  WHEN error_proceso THEN
       pError := 'INGENERA_CONTA : '||pError;
  WHEN transa_id.error THEN
       pError := nvl(transa_id.ultimo_error,'INGenera_Conta');
  WHEN others THEN
       pError := sqlerrm;
END;