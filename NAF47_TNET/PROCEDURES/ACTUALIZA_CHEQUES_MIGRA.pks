CREATE OR REPLACE PROCEDURE NAF47_TNET.ACTUALIZA_CHEQUES_MIGRA(p_no_cia          IN arckmm.no_cia%TYPE,
                                                    p_no_docu         IN arckmm.no_docu%TYPE,
                                                    p_transa_id       IN arckmm.no_docu%TYPE,
                                                    p_user            IN arckmm.usuario_creacion%TYPE,
                                                    p_ind_otros_meses IN arckmm.ind_otros_meses%TYPE,
                                                    msg_error_p       IN OUT VARCHAR2) IS

/**
 * Documentacion para ACTUALIZA_CHEQUES_MIGRA
 * Procedimiento que realiza la migracion de transacciones bancarias migradas desde Telcos al modulo de Bancos
 * 
 * @author yoveri
 * @version 1.0 01/01/2007
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 22/03/2017 Se modifica para distribuir la asignación del campo migra_arckmm.no_fisico en los campos arckmm.no_fisico y 
                           arckmm.serie_fisico distribuidos en 15 caracteres cada uno, esta distribución se realizaba desde Telcos en migra_arckmm
                           pero por proceso de cuadre de informacion se necesita que dicho campo pase intacto en la estructura migra_arckmm
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 18-09-2017 Se modifica para considerar nuevo pk de la tabla migra_arckmm (No_Cia, Id_Migracion)
 *
 * @param p_no_cia          IN arckmm.no_cia%TYPE recibe codigo de compania
 * @param p_no_docu         IN arckmm.no_docu%TYPE recibe numero de documento migrado
 * @param p_transa_id       IN arckmm.no_docu%TYPE recibe numero transaccion migrado
 * @param p_user            IN arckmm.usuario_creacion%TYPE recibe login de usuario que procesa
 * @param p_ind_otros_meses IN arckmm.ind_otros_meses%TYPE recibe indicador para generar registro como mes cerrado
 * @param msg_error_p       IN OUT VARCHAR2 retorma mensaje de error
 */
  --
  cursor c_documento_migrado is
    SELECT no_cia,
           no_cta,
           procedencia,
           tipo_doc,
           fecha,
           beneficiario,
           comentario,
           monto,
           descuento_pp,
           estado,
           conciliado,
           mes,
           ano,
           fecha_anulado,
           ind_borrado,
           ind_otromov,
           moneda_cta,
           tipo_cambio,
           tipo_ajuste,
           ind_dist,
           t_camb_c_v,
           mes_conciliado,
           ano_conciliado,
           trim(no_fisico) no_fisico, -- quitar espacios
           trim(serie_fisico) serie_fisico,-- quitar espacios
           ind_con,
           id_migracion,
           'TN' origen,
           usuario_anula,
           usuario_procesa,
           fecha_procesa,
           fecha_doc,
           ind_division,
           cod_division
      FROM migra_arckmm
     WHERE no_cia = p_no_cia
       AND id_migracion = p_no_docu;
  --
  Lv_Error       VARCHAR2(500);
  Error_proceso  EXCEPTION;
  Lr_DocMig      C_DOCUMENTO_MIGRADO%ROWTYPE := NULL;
  Lv_NoFisicoAux MIGRA_ARCKMM.NO_FISICO%TYPE := NULL;
  --
BEGIN
  msg_error_p := NULL;
  -- se recupera el documento migrado
  if c_documento_migrado%isopen then close c_documento_migrado; end if;
  open c_documento_migrado;
  fetch c_documento_migrado into Lr_DocMig;
  close c_documento_migrado;

  if length(Lr_DocMig.No_Fisico) > 15 then
    Lv_NoFisicoAux := Lr_DocMig.No_Fisico;
    Lr_DocMig.No_Fisico := substr(Lv_NoFisicoAux, 1, 15);
    Lr_DocMig.Serie_Fisico := substr(Lv_NoFisicoAux, 16, 15);
  else
    Lr_DocMig.Serie_Fisico := '0';
  end if;

  -- Inserto el encabezado
  BEGIN
    INSERT INTO arckmm
      (no_cia,
       no_cta,
       procedencia,
       tipo_doc,
       no_docu,
       fecha,
       beneficiario,
       comentario,
       monto,
       descuento_pp,
       estado,
       conciliado,
       mes,
       ano,
       fecha_anulado,
       ind_borrado,
       ind_otromov,
       moneda_cta,
       tipo_cambio,
       tipo_ajuste,
       ind_dist,
       t_camb_c_v,
       ind_otros_meses,
       mes_conciliado,
       ano_conciliado,
       no_fisico,
       serie_fisico,
       ind_con,
       numero_ctrl,
       origen,
       usuario_creacion,
       usuario_anula,
       usuario_actualiza,
       fecha_actualiza,
       fecha_doc,
       ind_division,
       cod_division)
VALUES
      ( Lr_DocMig.no_cia,
        Lr_DocMig.no_cta,
        Lr_DocMig.procedencia,
        Lr_DocMig.tipo_doc,
        p_transa_id,
        Lr_DocMig.fecha,
        Lr_DocMig.beneficiario,
        Lr_DocMig.comentario,
        Lr_DocMig.monto,
        Lr_DocMig.descuento_pp,
        Lr_DocMig.estado,
        Lr_DocMig.conciliado,
        Lr_DocMig.mes,
        Lr_DocMig.ano,
        Lr_DocMig.fecha_anulado,
        Lr_DocMig.ind_borrado,
        Lr_DocMig.ind_otromov,
        Lr_DocMig.moneda_cta,
        Lr_DocMig.tipo_cambio,
        Lr_DocMig.tipo_ajuste,
        Lr_DocMig.ind_dist,
        Lr_DocMig.t_camb_c_v,
        p_ind_otros_meses,
        Lr_DocMig.mes_conciliado,
        Lr_DocMig.ano_conciliado,
        Lr_DocMig.no_fisico,
        Lr_DocMig.serie_fisico,
        Lr_DocMig.ind_con,
        Lr_DocMig.id_migracion,
        Lr_DocMig.origen,
        p_user,
        Lr_DocMig.usuario_anula,
        Lr_DocMig.usuario_procesa,
        Lr_DocMig.fecha_procesa,
        Lr_DocMig.fecha_doc,
        Lr_DocMig.ind_division,
        Lr_DocMig.cod_division);
  EXCEPTION
    WHEN OTHERS THEN
      Lv_Error := 'No se pudo insertar arckmm ' || p_no_docu || ' ' || SQLERRM;
      RAISE error_proceso;
  END;

  -- Inserto el detalle
  BEGIN

    INSERT INTO arckml
      (no_cia,
       procedencia,
       tipo_doc,
       no_docu,
       cod_cont,
       centro_costo,
       tipo_mov,
       monto,
       monto_dol,
       tipo_cambio,
       moneda,
       no_asiento,
       modificable,
       codigo_tercero,
       ind_con,
       ano,
       mes,
       monto_dc,
       glosa,
       excede_presupuesto)

      SELECT no_cia,
             procedencia,
             tipo_doc,
             p_transa_id,
             cod_cont,
             centro_costo,
             tipo_mov,
             monto,
             monto_dol,
             tipo_cambio,
             moneda,
             no_asiento,
             modificable,
             codigo_tercero,
             ind_con,
             ano,
             mes,
             monto_dc,
             glosa,
             excede_presupuesto
        FROM migra_arckml
       WHERE no_cia = p_no_cia
         AND migracion_id = p_no_docu;

  EXCEPTION
    WHEN OTHERS THEN
      Lv_Error := 'No se pudo insertar arckml ' || p_no_docu || ' ' || SQLERRM;
      RAISE Error_proceso;

  END;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := Lv_Error;
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'Error en actualiza ' || SQLERRM;
    RETURN;
END ACTUALIZA_CHEQUES_MIGRA;
/