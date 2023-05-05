create or replace PROCEDURE            "INCIERRE_PERIODICO" (Pv_cia          IN VARCHAR2,
                                               Pv_centro      IN VARCHAR2,
                                               Pd_dia_proceso IN DATE,
                                               Pn_Anio        IN NUMBER,
                                               Pn_Mes         IN NUMBER,
                                               Pv_semana      IN VARCHAR2,
                                               Pv_indicador   IN VARCHAR2,
                                               Pv_Error       OUT VARCHAR2) IS

  -- Realiza todas las validaciones de que no haya nada pendiente de actualizar
  -- antes de cerrar el periodo.
  --
  
  /**
  * Documentacion para INCIERRE_PERIODICO
  * Se modifico la validaci¿n de la consulta c_asiento_pend para sensar el periodo de cierre de mes.
  * @author Miguel Angulo S¿nchez <jmangulos@telconet.ec>
  * @version 1.1 07/08/2019
  **/

  CURSOR c_asiento_pend IS
    SELECT a.fecha
      FROM arinmeh a
     WHERE a.no_cia = Pv_cia
       AND a.centro = Pv_centro
       AND a.fecha >= TO_DATE('01/'||Pn_Mes||'/'||Pn_Anio,'dd/mm/yyyy')
       AND a.fecha <= LAST_DAY(TO_DATE('01/'||Pn_Mes||'/'||Pn_Anio, 'dd/mm/yyyy'))
       AND EXISTS (SELECT NULL
              FROM arindc b
             WHERE b.no_cia = a.no_cia
               AND b.centro = a.centro
               AND b.tipo_doc = a.tipo_doc
               AND b.no_docu = a.no_docu
               AND b.ind_gen = 'N')
     GROUP BY a.fecha;
  --
  --
  CURSOR c_pend_trasla IS
    SELECT 1
      FROM arinte
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND TRUNC(fecha) <= Pd_dia_proceso
       AND estado = 'P';
  --
  CURSOR c_pend_manifi IS
    SELECT 1
      FROM arinem
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND TRUNC(fecha) <= Pd_dia_proceso;
  --
  CURSOR c_mov_pend_arinma IS
    SELECT ma.bodega,
           ma.no_arti
      FROM arinma ma,
           arinbo bo
     WHERE ma.no_cia = bo.no_cia
       AND ma.bodega = bo.codigo
       AND ma.no_cia = Pv_cia
       AND bo.centro = Pv_centro
       AND (ma.sal_pend_un != 0 OR ma.ent_pend_un != 0)
       AND rownum = 1;
  --
  CURSOR c_dia_proc IS
    SELECT dia_proceso
      FROM arincd
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro;
  --
  CURSOR c_fecha_fin IS
    SELECT TRUNC(fecha2)
      FROM calendario
     WHERE no_cia = Pv_cia
       AND ano = Pn_Anio
       AND semana = Pv_semana
       AND indicador = Pv_indicador;
  --
  CURSOR C_last_mes IS
    SELECT *
      FROM calendario
     WHERE no_cia = Pv_cia
       AND ano = Pn_Anio
       AND mes = Pn_Mes
     ORDER BY 3;

  --- Verifica si para el cierre esta en fin de mes o no ANR 17/06/2009

  CURSOR C_Fin_Mes IS
    SELECT fecha2
      FROM calendario
     WHERE no_cia = Pv_cia
       AND ano = Pn_Anio
       AND mes = Pn_Mes
       AND semana = Pv_semana
       AND indicador = Pv_indicador
       AND fecha2 <= Pd_dia_proceso;

  /**** Validaciones ****/

  CURSOR c_mov_pend IS
    SELECT DISTINCT tipo_doc
      FROM arinme
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND TRUNC(fecha) <= Pd_dia_proceso
       AND estado = 'P'
       AND rownum = 1;

  CURSOR act_pend_consignaciones(p_no_cia      VARCHAR2,
                                 p_centro      VARCHAR2,
                                 p_dia_proceso DATE) IS
    SELECT 'X'
      FROM arinencconsignacli
     WHERE no_cia = p_no_cia
       AND centro = p_centro
       AND TRUNC(fecha_registro) <= p_dia_proceso
       AND estado = 'P';

  CURSOR act_pend_reordenproduccion(p_no_cia      VARCHAR2,
                                    p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencreordenproduccion
     WHERE no_cia = p_no_cia
       AND centro = Pv_centro
       AND TRUNC(fecha) <= p_dia_proceso
       AND estado = 'P';

  CURSOR act_pend_consumointer(p_no_cia      VARCHAR2,
                               p_centro      VARCHAR2,
                               p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencconsumointer g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND TRUNC(g.fecha_registro) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_act_pend_sol_req(p_no_cia      VARCHAR2,
                            p_centro      VARCHAR2,
                            p_dia_proceso DATE) IS
    SELECT 'x'
      FROM inv_cab_solicitud_requisicion g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND TRUNC(g.fecha) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_arinencobsdon(p_no_cia      VARCHAR2,
                         p_centro      VARCHAR2,
                         p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencobsdon g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND TRUNC(g.fecha_solic) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_arinenc_solicitud(p_no_cia      VARCHAR2,
                             p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinenc_solicitud g
     WHERE g.no_cia = p_no_cia
       AND g.centro = Pv_centro
       AND TRUNC(g.fecha) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR pend_manif IS
    SELECT 'x'
      FROM arinem
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND TRUNC(fecha) <= Pd_dia_proceso;

  CURSOR C_arinencreclamo(p_no_cia      VARCHAR2,
                          p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencreclamo g
     WHERE g.no_cia = p_no_cia
       AND TRUNC(g.fecha) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_arinencremision IS
    SELECT 'x'
      FROM arinencremision
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND TRUNC(fecha_registro) <= Pd_dia_proceso
       AND estado = 'P';

  /**** Cursores para hacer el cierre mensual ***/
  --
  CURSOR c_lee_artic IS
    SELECT a.bodega,
           a.no_arti,
           a.ult_costo,
           DECODE(g.metodo_costo, 'P', a.costo_uni, 'E', d.costo_estandar) costo_uni,
           NVL(a.sal_ant_un, 0) + NVL(a.comp_un, 0) + NVL(a.otrs_un, 0) - NVL(a.vent_un, 0) - NVL(a.cons_un, 0) saldo_un,
           NVL(a.sal_ant_mo, 0) + NVL(a.comp_mon, 0) + NVL(a.otrs_mon, 0) - NVL(a.vent_mon, 0) - NVL(a.cons_mon, 0) saldo_mon,
           costo2,
           ult_costo2,
           monto2
      FROM arinbo bo,
           arinda d,
           arinma a,
           grupos g
     WHERE a.no_cia = Pv_cia
       AND bo.centro = Pv_centro
       AND g.no_cia = d.no_cia
       AND g.grupo = d.grupo
       AND bo.no_cia = a.no_cia
       AND bo.codigo = a.bodega
       AND d.no_cia = a.no_cia
       AND d.no_arti = a.no_arti;

  Lv_Dato  VARCHAR2(100) := NULL;
  Lb_Found BOOLEAN := FALSE;
  --
  vFound     BOOLEAN;
  vtipom     VARCHAR2(1);
  vpend      arinme.tipo_doc%TYPE;
  vbode_pend arinma.bodega%TYPE;
  varti_pend arinma.no_arti%TYPE;
  vfecha_in  arincd.dia_proceso%TYPE;
  Ld_fecha1  DATE;
  Ld_fecha2  DATE;

  Ld_fin_mes calendario.fecha2%TYPE;

  Ld_fecha_fin_semana DATE;
  vfecha              DATE;

  Lv_Error VARCHAR2(500);
  error_proceso EXCEPTION;

BEGIN

  --Recupera la fecha del proceso
  OPEN c_dia_proc;
  FETCH c_dia_proc
    INTO vfecha_in;
  vfound := c_dia_proc%FOUND;
  CLOSE c_dia_proc;

  IF NOT vfound THEN
    Lv_Error := 'No se ha definido la fecha de proceso de Inventario';
    RAISE error_proceso;
  END IF;

  --Copn este cursor recupero el ultimo viernes laboral del mes.
  FOR i IN C_last_mes LOOP
    IF NVL(i.dias_habiles, 0) = 6 THEN
      Ld_fecha1 := i.fecha1;
      Ld_fecha2 := i.fecha2;
    END IF;
  END LOOP;

  --Recupera la fecha2 de calendario osea la fecha tope del rango de semana.
  OPEN c_fecha_fin;
  FETCH c_fecha_fin
    INTO Ld_fecha_fin_semana;
  vFound := c_fecha_fin%FOUND;
  CLOSE c_fecha_fin;

  IF NOT vFound THEN
    Lv_Error := 'ERROR: No fue posible encontrar la semana: ' || Pv_semana || ' - ' || Pv_indicador || '   del ' || TO_CHAR(Pn_Mes) || '/' || TO_CHAR(Pn_Anio);
    RAISE error_proceso;
  END IF;

  ------------------------------------------------------------------
  -- Antes de realizar el cierre de mes debe chequearse que ya se
  -- haya ejecutado el proceso de generacion del asiento contable
  ------------------------------------------------------------------
  --- Esta validacion del asiento contable solamente se la puede hacer cuando la semana a cerrar sea igual al fin de mes ANR 17/06/0009

  OPEN C_Fin_Mes;
  FETCH C_Fin_Mes
    INTO Ld_fin_mes;
  IF C_Fin_Mes%NOTFOUND THEN
    Lv_Error := 'No se puede ejecutar el cierre periodico porque no se encuentra con fecha que indique que es fin de mes!!!';
    RAISE error_proceso;
  ELSE
    CLOSE C_Fin_Mes;

    FOR Lr_Asiento IN c_asiento_pend LOOP
      IF Lv_Error IS NULL THEN
        Lv_Error := Lr_Asiento.Fecha;
      ELSE
        Lv_Error := Lv_Error || ', ' || Lr_Asiento.Fecha;
      END IF;
    END LOOP;

    IF Lv_Error IS NOT NULL THEN
      Lv_Error := 'Existen asientos pendientes generar en las fechas: ' || Lv_Error;
      RAISE error_proceso;
    END IF;

    /*
    OPEN c_asiento_pend;
    FETCH c_asiento_pend
      INTO vtipom;
    vFound := c_asiento_pend%FOUND;
    CLOSE c_asiento_pend;

    IF vFound THEN
      Lv_Error := 'Debe ejecutar el proceso de generacion de asientos, porque el cierre periodico esta en una fecha con fin de mes: ' || TO_CHAR(Ld_Fin_mes, 'DD/MM/YYYY') || ' y existen asientos pendientes de generar a contabilidad';
      RAISE error_proceso;
    END IF;
    */
  END IF;

  /***** Validaciones sobre pendientes de inventarios ****/

  OPEN C_arinencremision;
  FETCH C_arinencremision
    INTO Lv_Dato;
  Lb_Found := C_arinencremision%FOUND;
  CLOSE C_arinencremision;

  IF Lb_Found THEN
    Lv_Error := 'Existen guias pendientes de procesar para este dia, Favor revisar';
    RAISE error_proceso;
  END IF;

  ---
  OPEN c_mov_pend;
  FETCH c_mov_pend
    INTO Lv_Dato;
  Lb_Found := c_mov_pend%FOUND;
  CLOSE c_mov_pend;

  IF Lb_Found THEN
    Lv_Error := 'Existe el documento(s) :' || Lv_Dato || ' pendiente de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN act_pend_consignaciones(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH act_pend_consignaciones
    INTO Lv_Dato;
  Lb_Found := act_pend_consignaciones%FOUND;
  CLOSE act_pend_consignaciones;

  IF Lb_Found THEN
    Lv_Error := 'Existe Solicitudes de Consignaciones pendiente de actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN act_pend_reordenproduccion(Pv_cia, Pd_dia_proceso);
  FETCH act_pend_reordenproduccion
    INTO Lv_Dato;
  Lb_Found := act_pend_reordenproduccion%FOUND;
  CLOSE act_pend_reordenproduccion;

  IF Lb_Found THEN
    Lv_Error := 'Existe Solicitudes de Reordenamiento pendiente de actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN act_pend_consumointer(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH act_pend_consumointer
    INTO Lv_Dato;
  Lb_Found := act_pend_consumointer%FOUND;
  CLOSE act_pend_consumointer;

  IF Lb_Found THEN
    Lv_Error := 'Existe(n) Solicitudes de Consumo Interno pendiente(s) de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN C_act_pend_sol_req(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH C_act_pend_sol_req
    INTO Lv_Dato;
  Lb_Found := C_act_pend_sol_req%FOUND;
  CLOSE C_act_pend_sol_req;

  IF Lb_Found THEN
    Lv_Error := 'Existe Requisiciones pendientes de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN C_arinencobsdon(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH C_arinencobsdon
    INTO Lv_Dato;
  Lb_Found := C_arinencobsdon%FOUND;
  CLOSE C_arinencobsdon;

  IF Lb_Found THEN
    Lv_Error := 'Existe(n) Obsequios y/o Donaciones pendiente(s) de Actualizar, Favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN C_arinenc_solicitud(Pv_cia, Pd_dia_proceso);
  FETCH C_arinenc_solicitud
    INTO Lv_Dato;
  Lb_Found := C_arinenc_solicitud%FOUND;
  CLOSE C_arinenc_solicitud;

  IF Lb_Found THEN
    Lv_Error := 'Existe(n) Solicitudes de Transferencias pendiente(s) de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;
  ---

  OPEN C_arinencreclamo(Pv_cia, Pd_dia_proceso);
  FETCH C_arinencreclamo
    INTO Lv_Dato;
  Lb_Found := C_arinencreclamo%FOUND;
  CLOSE C_arinencreclamo;

  IF Lb_Found THEN
    Lv_Error := 'Existe(n) Solicitudes de reclamo a proveedor pendiente(s) de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;

  OPEN pend_manif;
  FETCH pend_manif
    INTO Lv_Dato;
  Lb_Found := pend_manif%FOUND;
  CLOSE pend_manif;

  IF Lb_Found THEN
    Lv_Error := 'Existe(n) Manifiesto(s) pendiente(s) de Actualizar, favor revisar';
    RAISE error_proceso;
  END IF;

  ------------------------------------------------------------------
  -- Antes de realizar el cierre de mes debe chequearse que no
  -- existan traslados pendientes.
  ------------------------------------------------------------------

  --Si la fecha del proceso (vfecha_in) es igual al ultimo viernes del mes (Ld_fecha2) entonces verifico que NO HAYA TRANFERENCIA pendiente.
  IF vfecha_in = Ld_fecha2 THEN
    OPEN c_pend_trasla;
    FETCH c_pend_trasla
      INTO vpend;
    vFound := c_pend_trasla%FOUND;
    CLOSE c_pend_trasla;

    IF vFound THEN
      Lv_Error := 'Existen Transferencias pendientes en el centro ' || Pv_centro || ', deben ser actualizados o borrados para poder pasar al siguiente mes';
      RAISE error_proceso;
    END IF;
    ------------------------------------------------------------------
    -- Antes de realizar el cierre de mes debe chequearse que no
    -- existan entradas o salidas pendientes.
    ------------------------------------------------------------------
    OPEN c_mov_pend_arinma;
    FETCH c_mov_pend_arinma
      INTO vbode_pend,
           varti_pend;
    vFound := c_mov_pend_arinma%FOUND;
    CLOSE c_mov_pend_arinma;

    IF vFound THEN
      Lv_Error := 'Existen entradas o salidas pendientes para el centro: ' || Pv_centro || ', deben ser actualizados o borrados para poder pasar al siguiente mes';
      RAISE error_proceso;
    END IF;

  END IF;
  ------------------------------------------------------------------
  -- Antes de realizar el cierre de mes debe chequearse que no
  -- existan manifiestos pendientes.
  ------------------------------------------------------------------
  OPEN c_pend_manifi;
  FETCH c_pend_manifi
    INTO vpend;
  vFound := c_pend_manifi%FOUND;
  CLOSE c_pend_manifi;

  IF vFound THEN
    Lv_Error := 'Existen manifiestos pendientes en el centro, deben ser actualizados o borrados';
    RAISE error_proceso;
  END IF;
  --
  --Recupera la fecha2 de calendario osea la fecha tope del rango de semana.
  OPEN c_fecha_fin;
  FETCH c_fecha_fin
    INTO Ld_fecha_fin_semana;
  vFound := c_fecha_fin%FOUND;
  CLOSE c_fecha_fin;

  IF NOT vFound THEN
    Lv_Error := 'ERROR: No fue posible encontrar la semana: ' || Pv_semana || ' - ' || Pv_indicador || '   del ' || TO_CHAR(Pn_Mes) || '/' || TO_CHAR(Pn_Anio);
    RAISE error_proceso;
  END IF;
  --

  ---Verifica que la fecha de proceso (vfecha_in) sea igual al ultimo dia de la semana del periodo.
  IF vfecha_in = Ld_fecha_fin_semana THEN
    UPDATE arincd
       SET dia_proceso = dia_proceso + 1
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro;
  END IF;

  /**** Realiza el cierre de saldos de inventarios ****/

  FOR ra IN c_lee_artic LOOP

    --- Verifica si el saldo valuado en montos esta con diferencias en negativo le pone cero ANR 06/07/2009
    --- El rango permitido va a ser entre -0.001 hasta -0.05

    IF ra.saldo_mon BETWEEN - 0.001 AND - 0.05 THEN
      ra.saldo_mon := 0;
    END IF;

    BEGIN
      INSERT INTO arinha
        (NO_CIA,
         CENTRO,
         ANO,
         SEMANA,
         IND_SEM,
         BODEGA,
         CLASE,
         CATEGORIA,
         NO_ARTI,
         ULT_COSTO,
         SALDO_UN,
         SALDO_MO,
         COSTO_UNI,
         costo_uni2,
         ult_costo2,
         saldo_mo2)
      VALUES
        (Pv_cia,
         Pv_centro,
         Pn_Anio,
         Pv_semana,
         Pv_indicador,
         ra.bodega,
         NULL,
         NULL,
         ra.no_arti,
         ra.ult_costo,
         ra.saldo_un,
         ra.saldo_mon,
         ra.costo_uni,
         ra.costo2,
         ra.ult_costo2,
         ra.monto2);
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Error := 'Error al insertar ARINHA. Bodega: ' || ra.bodega || ' Articulo: ' || ra.no_arti || ' ' || SQLERRM;
        RAISE error_proceso;
    END;

  END LOOP;

  --- Actualizacion en caso de encontrar diferencias en centavos

  UPDATE arinma
     SET sal_ant_un = NVL(sal_ant_un, 0) + NVL(comp_un, 0) + NVL(otrs_un, 0) - NVL(vent_un, 0) - NVL(cons_un, 0),
         sal_ant_mo = 0, --- Actualiza en cero el saldo valuado en caso de diferencias
         comp_un    = 0,
         comp_mon   = 0,
         vent_un    = 0,
         vent_mon   = 0,
         cons_un    = 0,
         cons_mon   = 0,
         otrs_un    = 0,
         otrs_mon   = 0
   WHERE no_cia = Pv_cia
     AND (NVL(sal_ant_mo, 0) + NVL(comp_mon, 0) + NVL(otrs_mon, 0) - NVL(vent_mon, 0) - NVL(cons_mon, 0)) BETWEEN - 0.001 AND - 0.05
     AND (NVL(comp_un, 0) != 0 OR NVL(vent_un, 0) != 0 OR NVL(cons_un, 0) != 0 OR NVL(otrs_un, 0) != 0 OR NVL(sal_ant_un, 0) != 0 OR NVL(comp_mon, 0) != 0 OR NVL(vent_mon, 0) != 0 OR NVL(cons_mon, 0) != 0 OR NVL(otrs_mon, 0) != 0 OR NVL(sal_ant_mo, 0) != 0);

  --- Actualizacion normal

  UPDATE arinma
     SET sal_ant_un = NVL(sal_ant_un, 0) + NVL(comp_un, 0) + NVL(otrs_un, 0) - NVL(vent_un, 0) - NVL(cons_un, 0),
         sal_ant_mo = NVL(sal_ant_mo, 0) + NVL(comp_mon, 0) + NVL(otrs_mon, 0) - NVL(vent_mon, 0) - NVL(cons_mon, 0),
         comp_un    = 0,
         comp_mon   = 0,
         vent_un    = 0,
         vent_mon   = 0,
         cons_un    = 0,
         cons_mon   = 0,
         otrs_un    = 0,
         otrs_mon   = 0
   WHERE no_cia = Pv_cia
     AND (NVL(sal_ant_mo, 0) + NVL(comp_mon, 0) + NVL(otrs_mon, 0) - NVL(vent_mon, 0) - NVL(cons_mon, 0)) NOT BETWEEN - 0.001 AND - 0.05
     AND (NVL(comp_un, 0) != 0 OR NVL(vent_un, 0) != 0 OR NVL(cons_un, 0) != 0 OR NVL(otrs_un, 0) != 0 OR NVL(sal_ant_un, 0) != 0 OR NVL(comp_mon, 0) != 0 OR NVL(vent_mon, 0) != 0 OR NVL(cons_mon, 0) != 0 OR NVL(otrs_mon, 0) != 0 OR NVL(sal_ant_mo, 0) != 0);

  /**** Actualiza la fecha de proceso ****/

  vfecha := (Ld_fecha_fin_semana + 1);

  UPDATE arincd
     SET (ano_proce, mes_proce, semana_proce, indicador_sem, dia_proceso) =
         (SELECT ano,
                 mes,
                 semana,
                 indicador,
                 fecha1
            FROM calendario
           WHERE no_cia = Pv_cia
             AND TRUNC(vfecha) >= TRUNC(fecha1)
             AND TRUNC(vfecha) <= TRUNC(fecha2))
   WHERE no_cia = Pv_cia
     AND centro = Pv_centro;

EXCEPTION
  WHEN Error_proceso THEN
    Pv_Error := Lv_Error;
    RETURN;
  WHEN OTHERS THEN
    Pv_Error := 'Error en INCIERRE_PERIODICO: ' || SQLERRM;
    RETURN;

END INCIERRE_PERIODICO;