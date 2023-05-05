create or replace PROCEDURE            INCIERRE_DIARIO(Pv_cia                IN VARCHAR2,
                                            Pv_centro             IN VARCHAR2,
                                            Pd_dia_proceso        IN DATE,
                                            Pn_anio               IN NUMBER,
                                            Pn_mes                IN NUMBER,
                                            Pd_vultimo_dia_semana OUT DATE,
                                            Pv_error              OUT VARCHAR2) IS

  /**** El proceso de cierre diario de inventarios PINV208 se lo pasa a un
  proceso de base de datos para unificar este proceso al ser ejecutado
  en cualquier otro modulo ANR 17/01/2011 ****/

  CURSOR c_semana_proce IS
    SELECT ano_proce,
           indicador_sem,
           semana_proce
      FROM arincd
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro;

  CURSOR c_ultimo_dia(vano NUMBER, vindicador VARCHAR2, vsemana VARCHAR2) IS
    SELECT fecha2
      FROM calendario
     WHERE no_cia = Pv_cia
       AND ano = vano
       AND indicador = vindicador
       AND semana = vsemana;

  CURSOR C_last_mes IS
    SELECT fecha1,
           fecha2,
           dias_habiles
      FROM calendario
     WHERE no_cia = Pv_cia
       AND ano = Pn_anio
       AND mes = Pn_mes
     ORDER BY 3;

  --- Hace un barrido del articulo y busca si existen inconsistencias en costos, si existen inconsistencia,
  --- avisa y no se va a poder hacer el cierre diario ANR 08/12/2009

  CURSOR C_Valida_costos IS
    SELECT no_arti FROM Arinda WHERE no_cia = Pv_cia;

  /***** Validaciones en relacion a pendientes ****/

  CURSOR c_mov_pend IS
    SELECT DISTINCT arinme.tipo_doc||' - '||arinvtm.descri
      FROM arinme,
           arinvtm
     WHERE arinme.tipo_doc = arinvtm.tipo_m
       AND arinme.no_cia = arinvtm.no_cia
       AND arinme.no_cia = Pv_cia
       AND arinme.centro = Pv_centro
       AND trunc(arinme.fecha) <= Pd_dia_proceso
       AND arinme.estado = 'P';

  CURSOR pend_trasla IS
    SELECT no_docu
      FROM arinte
     WHERE arinte.no_cia = Pv_cia
       AND arinte.centro = Pv_centro
       AND trunc(arinte.fecha) <= Pd_dia_proceso
       AND arinte.estado = 'P';

  CURSOR act_pend_consignaciones(p_no_cia      VARCHAR2,
                                 p_centro      VARCHAR2,
                                 p_dia_proceso DATE) IS
    SELECT 'X'
      FROM arinencconsignacli
     WHERE no_cia = p_no_cia
       AND centro = p_centro
       AND trunc(fecha_registro) <= p_dia_proceso
       AND estado = 'P';

  CURSOR act_pend_reordenproduccion(p_no_cia VARCHAR2, p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencreordenproduccion
     WHERE no_cia = p_no_cia
       AND centro = Pv_centro
       AND trunc(fecha) <= p_dia_proceso
       AND estado = 'P';

  CURSOR act_pend_consumointer(p_no_cia      VARCHAR2,
                               p_centro      VARCHAR2,
                               p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencconsumointer g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND trunc(g.fecha_registro) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_act_pend_sol_req(p_no_cia      VARCHAR2,
                            p_centro      VARCHAR2,
                            p_dia_proceso DATE) IS
    SELECT 'x'
      FROM inv_cab_solicitud_requisicion g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND trunc(g.fecha) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_arinencobsdon(p_no_cia      VARCHAR2,
                         p_centro      VARCHAR2,
                         p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencobsdon g
     WHERE g.no_cia = p_no_cia
       AND g.centro = p_centro
       AND trunc(g.fecha_solic) <= p_dia_proceso
       AND g.estado = 'P';

  /*Cursor C_arinenc_solicitud (p_no_cia       varchar2,
                            p_dia_proceso  date) Is
  Select 'x'
    From arinenc_solicitud g
   Where g.no_cia       = p_no_cia
     and g.centro       = Pv_centro
     and trunc(g.fecha) <= p_dia_proceso
     and g.estado       = 'P';*/

  CURSOR pend_manif IS
    SELECT 'x'
      FROM arinem
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND trunc(fecha) <= Pd_dia_proceso;

  CURSOR C_arinencreclamo(p_no_cia VARCHAR2, p_dia_proceso DATE) IS
    SELECT 'x'
      FROM arinencreclamo g
     WHERE g.no_cia = p_no_cia
       AND trunc(g.fecha) <= p_dia_proceso
       AND g.estado = 'P';

  CURSOR C_arinencremision IS
    SELECT 'x'
      FROM arinencremision
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro
       AND trunc(fecha_registro) <= Pd_dia_proceso
       AND estado = 'P';

  Lv_Dato  VARCHAR2(1000) := NULL;
  Lb_Found BOOLEAN := FALSE;

  vultimo_dia_semana DATE;
  vano               arincd.ano_proce%TYPE;
  vindicador         arincd.indicador_sem%TYPE;
  vsemana            arincd.semana_proce%TYPE;
  Ld_fecha1          DATE;
  Ld_fecha2          DATE;

  Lv_mensaje VARCHAR2(300);
  Lv_error   VARCHAR2(500);

  error_proceso EXCEPTION;

BEGIN

  /**** Verifica transacciones pendientes  ****/

  ---
  OPEN C_arinencremision;
  FETCH C_arinencremision INTO Lv_Dato;
  Lb_Found := C_arinencremision%FOUND;
  CLOSE C_arinencremision;

  IF Lb_Found THEN
    Lv_error := 'Existen guias pendientes de procesar para este dia, Favor revisar';
    RAISE Error_proceso;
  END IF;

  ---
  OPEN c_mov_pend;
  FETCH c_mov_pend INTO Lv_Dato;
  Lb_Found := c_mov_pend%FOUND;
  CLOSE c_mov_pend;

  IF Lb_Found THEN
    Lv_error := 'Existe el documento(s) :' || Lv_Dato ||' pendiente de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  --
  --
  -- llindao: Antes de validar las transferencias se actualiza las transferencias en transito
  --          para que se procesen el siguiente dia.
  update arinte
     set fecha = Pd_dia_proceso + 1
   Where no_cia = Pv_cia
     And centro = Pv_centro
     And trunc(fecha) <= Pd_dia_proceso
     and estado = 'P'
     and exists (select null 
                   from arinbo 
                  where arinbo.codigo = arinte.bod_orig
                    and arinbo.centro = arinte.centro
                    and arinbo.no_cia = arinte.no_cia
                    and arinbo.transito = 'S');
  
  -- valida trsnaferencias pendientes --
  OPEN pend_trasla;
  FETCH pend_trasla INTO Lv_Dato;
  Lb_Found := pend_trasla%FOUND;
  CLOSE pend_trasla;

  IF Lb_Found THEN
    Lv_error := 'Existe la Transferencia: ' || Lv_Dato ||' pendiente de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  OPEN act_pend_consignaciones(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH act_pend_consignaciones
    INTO Lv_Dato;
  Lb_Found := act_pend_consignaciones%FOUND;
  CLOSE act_pend_consignaciones;

  IF Lb_Found THEN
    Lv_error := 'Existe Solicitudes de Consignaciones pendiente de actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  OPEN act_pend_reordenproduccion(Pv_cia, Pd_dia_proceso);
  FETCH act_pend_reordenproduccion
    INTO Lv_Dato;
  Lb_Found := act_pend_reordenproduccion%FOUND;
  CLOSE act_pend_reordenproduccion;

  IF Lb_Found THEN
    Lv_error := 'Existe Solicitudes de Reordenamiento pendiente de actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  OPEN act_pend_consumointer(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH act_pend_consumointer
    INTO Lv_Dato;
  Lb_Found := act_pend_consumointer%FOUND;
  CLOSE act_pend_consumointer;

  IF Lb_Found THEN
    Lv_error := 'Existe(n) Solicitudes de Consumo Interno pendiente(s) de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  OPEN C_act_pend_sol_req(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH C_act_pend_sol_req
    INTO Lv_Dato;
  Lb_Found := C_act_pend_sol_req%FOUND;
  CLOSE C_act_pend_sol_req;

  IF Lb_Found THEN
    Lv_error := 'Existe Requisiciones pendientes de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  OPEN C_arinencobsdon(Pv_cia, Pv_centro, Pd_dia_proceso);
  FETCH C_arinencobsdon
    INTO Lv_Dato;
  Lb_Found := C_arinencobsdon%FOUND;
  CLOSE C_arinencobsdon;

  IF Lb_Found THEN
    Lv_error := 'Existe(n) Obsequios y/o Donaciones pendiente(s) de Actualizar, Favor revisar';
    RAISE Error_proceso;
  END IF;
  ---

  /*
  Open C_arinenc_solicitud(Pv_cia, Pd_dia_proceso);
  Fetch C_arinenc_solicitud into Lv_Dato;
  Lb_Found:= C_arinenc_solicitud%Found;
  Close C_arinenc_solicitud;
  
  If Lb_Found then
    Lv_error := 'Existe(n) Solicitudes de Transferencias pendiente(s) de Procesar, favor revisar';
    Raise Error_proceso;
  End If;
  ---
  */

  OPEN C_arinencreclamo(Pv_cia, Pd_dia_proceso);
  FETCH C_arinencreclamo
    INTO Lv_Dato;
  Lb_Found := C_arinencreclamo%FOUND;
  CLOSE C_arinencreclamo;

  IF Lb_Found THEN
    Lv_error := 'Existe(n) Solicitudes de reclamo a proveedor pendiente(s) de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;

  OPEN pend_manif;
  FETCH pend_manif
    INTO Lv_Dato;
  Lb_Found := pend_manif%FOUND;
  CLOSE pend_manif;

  IF Lb_Found THEN
    Lv_error := 'Existe(n) Manifiesto(s) pendiente(s) de Actualizar, favor revisar';
    RAISE Error_proceso;
  END IF;

  ---- 'Verificando costos, por favor espere...';

  FOR i IN C_Valida_costos LOOP
    --- Funcion para validar que los costos estes correctos antes de procesar costos ANR 08/12/2009
    Lv_mensaje := substr(inverifica_costos(Pv_cia, i.no_arti), 1, 300);
  
    IF Lv_mensaje IS NOT NULL THEN
      Lv_error := 'Realice la correccion en costos: ' || Lv_mensaje ||
                  ' , no puede hacer el cierre diario de inventarios';
      RAISE error_proceso;
    END IF;
  
  END LOOP;

  ---'Validando registros pendientes...';

  OPEN c_semana_proce;
  FETCH c_semana_proce
    INTO vano,
         vindicador,
         vsemana;
  CLOSE c_semana_proce;

  OPEN c_ultimo_dia(vano, vindicador, vsemana);
  FETCH c_ultimo_dia
    INTO vultimo_dia_semana;
  CLOSE c_ultimo_dia;
  ---

  FOR i IN C_last_mes LOOP
    IF nvl(i.dias_habiles, 0) = 6 THEN
      Ld_fecha1 := i.fecha1;
      Ld_fecha2 := i.fecha2;
    END IF;
  END LOOP;

  ---
  UPDATE arinme
     SET estado = 'M'
   WHERE no_cia = Pv_cia
     AND centro = Pv_centro
     AND estado = 'D';
  ---
  OPEN c_semana_proce;
  FETCH c_semana_proce
    INTO vano,
         vindicador,
         vsemana;
  CLOSE c_semana_proce;
  ---
  OPEN c_ultimo_dia(vano, vindicador, vsemana);
  FETCH c_ultimo_dia
    INTO vultimo_dia_semana;
  CLOSE c_ultimo_dia;

  --- 'Actualizando dia de proceso de Inventarios...';

  --- Si es un dia que sea lunes, martes, miercoles o Jueves le aumenta la fecha + 1
  IF Pd_dia_proceso < vultimo_dia_semana THEN
    --- Actualiza el dia de la fecha de inventarios
    UPDATE arincd
       SET dia_proceso = dia_proceso + 1
     WHERE no_cia = Pv_cia
       AND centro = Pv_centro;
  END IF;

  ---

  Pd_vultimo_dia_semana := vultimo_dia_semana;

EXCEPTION
  WHEN Error_proceso THEN
    Pv_error := Lv_error;
    RETURN;
  WHEN OTHERS THEN
    Pv_error := 'Error en INCIERRE_DIARIO: ' || SQLERRM;
    RETURN;
END INCIERRE_DIARIO;