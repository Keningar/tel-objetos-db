create or replace PROCEDURE            ACTUALIZA_ASIENTOS_MIGRA(p_no_cia     IN arcgae.no_cia%TYPE,
                                                                p_no_asiento IN arcgae.no_asiento%TYPE,
                                                                p_cod_diario IN arcgae.cod_diario%TYPE,
                                                                p_trans_id   IN arcgae.no_asiento%TYPE,
                                                                p_user       IN arcgae.usuario_creacion%TYPE,
                                                                msg_error_p  IN OUT VARCHAR2) IS
/**
 * Documentacion para ACTUALIZA_ASIENTOS_MIGRA
 * Procedimiento que realiza la migracion de los asientos contables Telcos a NAF-Contabilidad
 * 
 * @author yoveri
 * @version 1.0 01/01/2007
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 30/09/2016
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 18/09/2017 Se modifica para considerar el nuevo pk de la tabla migra_arcgae (No_Cia, Id_Migracion)
 * 
 * @param p_no_cia     IN arcgae.no_cia%TYPE recibe codigo de compania
 * @param p_no_asiento IN arcgae.no_asiento%TYPE recibe numero de asiento generado en TELCOS
 * @param p_cod_diario IN arcgae.cod_diario%TYPE recibe codigo de diaro
 * @param p_trans_id   IN arcgae.no_asiento%TYPE recibe numero de asiento asignado para modulo contable
 * @param p_user       IN arcgae.usuario_creacion%TYPE recibe login de usuario que procesa
 * @param msg_error_p  IN OUT VARCHAR2 retorma mensaje de error
 */

  -- Cursor que recupera Rango de fechas de los registros seleccionados a migrar --
  CURSOR c_fechas IS
    SELECT MIN(fecha) fecha_minima,
           MAX(fecha) fecha_maxima
      FROM migra_arcgae a
     WHERE a.no_cia = p_no_cia
       AND a.cod_diario = p_cod_diario
       AND a.numero_ctrl = p_trans_id;
  --
  Lv_error       VARCHAR2(500);
  Ld_FechaMin    DATE := NULL;
  Ld_FechaMax    DATE := NULL;
  Lv_RangoFechas VARCHAR2(100) := NULL;
  Lv_Periodo     VARCHAR2(100) := NULL;
  --
  Error_proceso EXCEPTION;
  --
BEGIN
  --
  msg_error_p := NULL;
  --
  -- se recupera rango de fechas para inicializar el concepto del asiento contable a generar --
  IF c_fechas%ISOPEN THEN
    CLOSE c_fechas;
  END IF;
  OPEN c_fechas;
  FETCH c_fechas
    INTO Ld_FechaMin,
         Ld_FechaMax;
  IF c_fechas%NOTFOUND THEN
    Ld_FechaMin := NULL;
    Ld_FechaMax := NULL;
  END IF;
  CLOSE c_fechas;
  --
  -- Se inicializa concepto de asientos contables
  IF Ld_FechaMin IS NOT NULL THEN
    IF Ld_FechaMin = Ld_FechaMax THEN
      Lv_RangoFechas := ' DEL ' || TO_CHAR(Ld_FechaMin, 'DD/MM/YYYY');
    ELSE
      Lv_RangoFechas := ' DESDE ' || TO_CHAR(Ld_FechaMin, 'DD/MM/YYYY') ||
                        ' HASTA ' || TO_CHAR(Ld_FechaMax, 'DD/MM/YYYY');
    END IF;
  END IF;

  Lv_Periodo := ' DE ' ||
                TRIM(to_char(Ld_FechaMin,
                             'MONTH',
                             'NLS_DATE_LANGUAGE=SPANISH')) || ' ' ||
                to_char(Ld_FechaMin, 'YYYY');

  -- Se inserta registro de asiento contable migrado en base a registros seleccionados --
  BEGIN
    INSERT INTO arcgae
      (no_asiento,
       no_cia,
       ano,
       mes,
       impreso,
       fecha,
       descri1,
       estado,
       autorizado,
       origen,
       t_debitos,
       t_creditos,
       cod_diario,
       t_camb_c_v,
       tipo_cambio,
       tipo_comprobante,
       no_comprobante,
       anulado,
       usuario_creacion)
      SELECT a.numero_ctrl,
             a.no_cia,
             to_number(to_char(MAX(a.fecha), 'yyyy')),
             to_number(to_char(MAX(a.fecha), 'mm')),
             a.impreso,
             MAX(a.fecha),
             (SELECT z.descripcion ||
                     decode(z.parametro_alterno,
                            'PERIODO',
                            Lv_Periodo,
                            'FECHA',
                            Lv_RangoFechas)
                FROM ge_grupos_parametros y,
                     ge_parametros        z
               WHERE y.id_grupo_parametro = z.id_grupo_parametro
                 AND y.id_aplicacion = z.id_aplicacion
                 AND y.id_empresa = z.id_empresa
                 AND z.id_empresa = A.NO_CIA
                 AND z.parametro = A.COD_DIARIO
                 AND z.id_grupo_parametro = 'CONCEPTOS_MIGRADOS'
                 AND y.estado = 'A'
                 AND z.estado = 'A') descri1,
             a.estado,
             a.autorizado,
             a.origen,
             SUM(a.t_debitos) t_debitos,
             SUM(a.t_debitos),
             DECODE(a.ORIGEN,
                    'MD',
                    a.COD_DIARIO,
                    'TN',
                    a.COD_DIARIO,
                    'CONTG') COD_DIARIO,
             a.t_camb_c_v,
             a.tipo_cambio,
             a.tipo_comprobante,
             '0' NO_COMPROBANTE,
             a.anulado,
             p_user
        FROM migra_arcgae a
       WHERE a.no_cia = p_no_cia
         AND a.cod_diario = p_cod_diario
         AND a.numero_ctrl = p_trans_id
       GROUP BY a.numero_ctrl,
                a.no_cia,
                a.impreso,
                a.COD_DIARIO,
                a.estado,
                a.autorizado,
                a.ORIGEN,
                a.t_camb_c_v,
                a.tipo_cambio,
                a.tipo_comprobante,
                a.anulado;

  EXCEPTION
    WHEN OTHERS THEN
      Lv_error := 'No se pudo insertar arcgae ' || p_no_asiento || ' ' ||
                  SQLERRM;
      RAISE error_proceso;
  END;

  -- Se inserta detalle de asiento en base a los registros seleccionados --
  BEGIN
    INSERT INTO arcgal
      (no_cia,
       ano,
       mes,
       no_asiento,
       no_linea,
       cuenta,
       descri,
       cod_diario,
       moneda,
       tipo_cambio,
       monto,
       centro_costo,
       tipo,
       monto_dol,
       cc_1,
       cc_2,
       cc_3,
       linea_ajuste_precision)
      SELECT no_cia,
             ano,
             (SELECT to_number(to_char(MAX(fecha), 'mm'))
                FROM migra_arcgae
               WHERE no_cia = p_no_cia
                 AND cod_diario = p_cod_diario
                 AND numero_ctrl = p_trans_id),
             p_trans_id,
             row_number() over(PARTITION BY no_cia ORDER BY no_cia),
             cuenta,
             descri,
             p_cod_diario,
             moneda,
             tipo_cambio,
             monto,
             centro_costo,
             tipo,
             monto_dol,
             cc_1,
             cc_2,
             cc_3,
             linea_ajuste_precision
        FROM migra_arcgal a
       WHERE exists (select null
                     from migra_arcgae b
                     where b.id_migracion = a.migracion_id
                     and b.no_cia = a.no_cia
                     and b.numero_ctrl = p_trans_id
                     and b.cod_diario = p_cod_diario
                     and b.no_cia = p_no_cia);

  EXCEPTION
    WHEN OTHERS THEN
      Lv_error := 'No se pudo insertar arcgal ' || p_no_asiento || ' ' ||
                  SQLERRM;
      RAISE Error_proceso;
  END;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := lv_error;
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'Error en actualiza ' || SQLERRM;
    RETURN;
END;
