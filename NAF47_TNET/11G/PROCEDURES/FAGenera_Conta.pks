create or replace PROCEDURE            FAGenera_Conta (
  p_cia               varchar2,
  p_centro            varchar2,
  p_diario            varchar2,
  p_ano               number,
  p_mes               number,
  p_fecha             date,
  p_cant       IN OUT number,
  p_msg_error  IN OUT varchar2
) IS
  --
  -- datos de la compa?ia en Contabilidad y Facturacion
  CURSOR Periodo_CG IS
    SELECT mc.ano_proce, mc.mes_proce, c.ind_tipo_asientos_fac
      FROM arcgmc mc, arfamc c
     WHERE mc.no_cia = p_cia
       AND c.no_cia  = mc.no_cia;
  --
  -- distribucion contable (resumida)
  CURSOR c_movs (pasiento varchar2) IS
    SELECT codigo,   centro_costo, codigo_tercero tercero,
           tipo_mov, moneda,       tipo_cambio,
           SUM(NVL(monto,0))       monto,       -- Monto nominal
           SUM(NVL(monto_dol, 0))  monto_dol    -- Monto dolares
      FROM arfadc
     WHERE no_cia     = p_cia
       AND centrod    = p_centro
       AND ano        = p_ano
       AND mes        = p_mes
       AND ind_gen    = 'G'
       AND no_asiento = pasiento
     GROUP BY codigo,   centro_costo, codigo_tercero,
              tipo_mov, moneda,       tipo_cambio;
  --
  -- distribucion contable (detallada)
  CURSOR c_movs_det (pasiento varchar2) IS
    SELECT d.codigo,   d.centro_costo, d.codigo_tercero tercero,
           d.tipo_mov, d.moneda,       d.tipo_cambio,  d.no_docu,
           e.tipo_doc||' '||e.no_fisico||'-'||e.serie_fisico DESCRI,
           nvl(d.monto,0)       monto,       -- Monto nominal
           nvl(d.monto_dol, 0)  monto_dol    -- Monto dolares
      FROM arfadc d, arfafe e
     WHERE d.no_cia     = p_cia
       AND d.centrod    = p_centro
       AND d.ano        = p_ano
       AND d.mes        = p_mes
       AND d.ind_gen    = 'G'
       AND d.no_asiento = pasiento
       AND e.no_cia     = d.no_cia
       AND e.no_factu   = d.no_docu
     ORDER BY d.codigo,   d.centro_costo, d.codigo_tercero,
              d.tipo_mov, d.moneda,       d.tipo_cambio;
   --

   Cursor C_Centro Is
   select nombre
   from   arincd
   where  no_cia = p_cia
   and    centro = p_centro;

   v_debtot      arcgae.t_debitos%type;
   v_credtot     arcgae.t_creditos%type;
   monto1        arcgal.monto%type;
   monto1_dol    arcgal.monto_dol%type;
   v_contador    number(6);
   vMes_Conta    Arcgmc.mes_proce%type;
   vAno_Conta    Arcgmc.Ano_proce%type;
   vEstado       Arcgae.estado%type;
   vComprobante  Arcgae.no_comprobante%type;
   vasiento      arfadc.no_asiento%type;
   --
   error_proceso exception;
   vDescri       arcgae.descri1%type;
   vTipo_asiento varchar2(1);  -- Forma de generar el asiento (R = Resumido, D = detallado)
   vAutorizado   arcgae.autorizado%type;

   Lv_NomCentro  Arincd.nombre%type;


BEGIN

  OPEN  periodo_Cg;
  FETCH periodo_Cg INTO vano_conta, vmes_conta, vTipo_asiento;
  CLOSE periodo_Cg;

  -- Si el ano y mes del asiento a generar es menor que el de la Contabilidad,
  -- el asiento se traslada como de otros meses, sino se traslada pendiente.
  IF ((vano_conta*100) + vmes_conta) > ((p_ano*100) + p_mes) THEN
     vEstado     := 'O';
     vAutorizado := 'S';
  ELSE
     vEstado     := 'P';
     vAutorizado := 'N';
  END IF;
  --
  -- Obtiene Numero de Transaccion a generar hacia Contabilidad.
  vasiento := Transa_Id.CG(p_cia);
  --
  -- ---
  -- Marca las lineas del detalle contable que sera generado
  -- a contabilidad
  --
  UPDATE arfadc a
     SET ind_gen    = 'G',
         no_asiento = vasiento
   WHERE a.no_cia  = p_cia
     AND a.centrod = p_centro
     AND ano     = p_ano
     AND mes     = p_mes
     AND a.ind_gen = 'P'; /*
    and  exists (select null from arfafe b
                   where a.no_cia = b.no_cia
                   and  a.no_docu = b.no_factu
                   and  b.fecha= p_fecha
                   and nvl(b.ind_anu_dev,'F')  <> 'A');  */
  --
  v_debTot   := 0;
  v_credTot  := 0;
  v_contador := 0;
  --
  -- Insersion del Encabezado de asiento en ARCGAE

  IF vTipo_asiento = 'R' THEN
  	vDescri := 'ASIENTO RESUMIDO GENERADO DESDE FACTURACION DEL DIA '|| p_fecha;
  ELSE -- vTipo_asiento = D
  	vDescri := 'ASIENTO DETALLADO GENERADO DESDE FACTURACION';
  END IF;

  INSERT INTO arcgae(no_cia,  ano,             mes,
              no_asiento,     impreso,         fecha,
              descri1,
              estado,         autorizado,      origen,
              cod_diario,     t_camb_c_v,      Tipo_Comprobante,
              no_comprobante, anulado)
       VALUES (p_cia,         p_ano,           p_mes,
              vasiento,       'N',             p_fecha,
              vDescri,
              vEstado,        'N',             'FA',
              p_diario,       'V',             'T',
              '0',            'N');

  -- Insercion de las lineas del asiento en ARCGAL

  IF vTipo_asiento = 'R' THEN
  	--
  	-- si el asiento es resumido..
    FOR f1 IN c_movs (vasiento) LOOP

      IF (f1.tipo_mov = 'C') THEN
         v_CredTot  := NVL(v_CredTot,0) + NVL(f1.monto,0);
         monto1     := NVL(f1.monto * -1,0);
         monto1_dol := NVL(f1.monto_dol * -1,0);
      ELSE
         v_DebTot   := NVL(v_DebTot,0) + NVL(f1.monto,0);
         monto1     := NVL(f1.monto,0);
         monto1_dol := NVL(f1.monto_dol,0);
      END IF;

      IF monto1 != 0 OR monto1_dol  != 0 THEN
         v_contador := v_contador + 1;

         Open C_Centro;
         Fetch C_Centro into Lv_NomCentro;
         If C_Centro%notfound Then
          Close C_Centro;
         else
          Close C_Centro;
         end if;

         INSERT INTO arcgal (no_cia, ano,          mes,
                     no_asiento,     no_linea,     cuenta,
                     cod_diario,     moneda,       tipo_cambio,
                     fecha,          centro_costo, tipo,
                     monto,          monto_dol,    codigo_tercero, descri)
              VALUES (p_cia,         p_ano,           p_mes,
                     vasiento,       v_contador,      f1.codigo,
                     p_diario,       f1.moneda,       f1.tipo_cambio,
                     p_fecha,        f1.centro_costo, f1.tipo_mov,
                     monto1,         monto1_dol,      f1.tercero, 'ASIENTO GENERADO DE FACTURACION EL '||p_fecha||' '||Lv_Nomcentro);
      END IF;

    END LOOP;  -- del asiento resumido.
  ELSE -- vTipo_asiento = 'D'
  	--
  	-- si el asiento es detallado..
    FOR f1 IN c_movs_det (vasiento) LOOP

      IF (f1.tipo_mov = 'C') THEN
         v_CredTot  := NVL(v_CredTot,0) + NVL(f1.monto,0);
         monto1     := NVL(f1.monto * -1,0);
         monto1_dol := NVL(f1.monto_dol * -1,0);
      ELSE
         v_DebTot   := NVL(v_DebTot,0) + NVL(f1.monto,0);
         monto1     := NVL(f1.monto,0);
         monto1_dol := NVL(f1.monto_dol,0);
      END IF;

      IF monto1 != 0 OR monto1_dol  != 0 THEN
         v_contador := v_contador + 1;

         INSERT INTO arcgal (no_cia, ano,          mes,
                     no_asiento,     no_linea,     cuenta,
                     cod_diario,     moneda,       tipo_cambio,
                     fecha,          centro_costo, tipo,
                     monto,          monto_dol,    codigo_tercero,
                     no_docu,        descri)
              VALUES (p_cia,         p_ano,           p_mes,
                     vasiento,       v_contador,      f1.codigo,
                     p_diario,       f1.moneda,       f1.tipo_cambio,
                     p_fecha,        f1.centro_costo, f1.tipo_mov,
                     monto1,         monto1_dol,      f1.tercero,
                     f1.no_docu,     nvl(f1.descri,'ASIENTO GENERADO DE FACTURACION EL '||p_fecha||' '||Lv_Nomcentro));
      END IF;

    END LOOP;  -- del asiento detallado
  END IF;  -- del tipo de asiento (R/D)
  -- ---
  -- Actualiza total de debitos,  creditos y numero de comprobante en
  -- el encabezado del asiento

  IF v_contador != 0 THEN

     -- Existian movimientos a trasladar a contabilidad

     p_cant := p_cant + 1;

     IF vEstado = 'O' THEN
        vComprobante :=  Consecutivo.CG(p_Cia, p_ano, p_mes, 'T', 'COMPROBANTE');
     ELSE
        vComprobante := '0';
     END IF;

     UPDATE arcgae
        SET t_debitos      = v_DebTot,
            t_creditos     = v_CredTot,
            no_Comprobante = vComprobante,
            autorizado     = vAutorizado
      WHERE no_cia         = p_Cia
        AND ano            = p_ano
        AND mes            = p_mes
        AND no_asiento     = vasiento;


  ELSE
     -- como no genero lineas, borra el encabezado previamente creado.
     DELETE arcgae
      WHERE no_cia     = p_cia
        AND ano        = p_ano
        AND mes        = p_mes
        AND no_asiento = vasiento;

     p_msg_error := ' No hay lineas pendientes de trasladar a contabilidad !!!';
     RAISE error_proceso;
  END IF;

EXCEPTION
  WHEN error_proceso THEN
       p_msg_error := p_msg_error;
  WHEN Transa_ID.ERROR THEN
       p_msg_error := 'FAGENERA_CONTA : '||Transa_Id.Ultimo_Error;
  WHEN Consecutivo.ERROR THEN
       p_msg_error := 'FAGENERA_CONTA : '||Consecutivo.Ultimo_Error;
  WHEN OTHERS THEN
       p_msg_error := 'FAGENERA_CONTA : '||sqlerrm;
END;