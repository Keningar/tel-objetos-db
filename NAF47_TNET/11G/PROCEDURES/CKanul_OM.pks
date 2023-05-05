create or replace PROCEDURE            CKanul_OM(
  pno_cia      IN varchar2,
  pno_transa   IN number,
  pno_cta      IN varchar2,
  msg_error_p  IN OUT varchar2
 ) IS
   vfound       BOOLEAN;
   vf_anula     arckmm.fecha_anulado%TYPE;
   --
   error_proceso   EXCEPTION;
   --
   CURSOR c_datos_mm IS
	   SELECT tipo_doc, no_cta, fecha,
	          monto, moneda_cta, tipo_cambio, procedencia,
	          estado, conciliado, mes, ano, ind_con,rowid
	   FROM arckmm
	   WHERE no_cia   = pno_cia
	     AND no_docu  = pno_transa;
	 --
	 CURSOR c_datos_cta(pno_cta varchar2) IS
	   SELECT ano_proc, mes_proc
	   FROM arckmc
	   WHERE no_cia   = pno_cia
	     AND no_cta   = pno_cta;
	 --
   vrmm        c_datos_mm%rowtype;
   vrcta       c_datos_cta%rowtype;
   --
BEGIN
	   -- --
	   -- Obtiene los datos relaiconados al movimiento
	   OPEN  c_datos_mm;
     FETCH c_datos_mm INTO vrmm;
     vfound := c_datos_mm%FOUND;
     CLOSE c_datos_mm;
     IF not vfound THEN
      	msg_error_p := ' El no existe el documento  ';
      	RAISE error_proceso;
     END IF;
     if pno_cta is null OR pno_cta != vrmm.no_cta then
        msg_error_p  := 'La cuenta de bancaria no coincide con la de la transa. No.'||pno_transa;
        raise error_proceso;
     end if;
     -- El a?o y mes en proceso de la cuenta bancaria
     OPEN  c_datos_cta(vrmm.no_cta);
     FETCH c_datos_cta INTO vrcta;
     CLOSE c_datos_cta;
  	 ---
		 -- Validaciones sobre el movimiento
		 IF ( (vrmm.mes <> vrcta.mes_proc) OR (vrmm.ano <> vrcta.ano_proc)) THEN
      	msg_error_p := 'No se pueden anular movimientos que NO son del periodo en proceso';
        Raise error_proceso;
     END IF;
     IF nvl(vrmm.estado,'*') = 'A' THEN
      	msg_error_p := 'El movimiento ya fue anulado';
        Raise error_proceso;
     END IF;
     IF nvl(vrmm.estado,'*') = 'P' THEN
        msg_error_p := 'El movimiento aun esta pendiente';
        Raise error_proceso;
     END IF;
     IF nvl(vrmm.conciliado,'*') = 'S' THEN
    	   msg_error_p := 'El movimiento no se puede anular porque ya fue conciliado';
    	   Raise error_proceso;
     END IF;
     IF nvl(vrmm.procedencia,'*') = 'B' THEN
    	   msg_error_p := 'No se puede anular documentos del banco ';
    	   Raise error_proceso;
     END IF;
     -- Determina fecha de anulacion
     vf_anula  := last_day(to_date('01'||lpad(to_char(vrcta.mes_proc),2,'0')
                              ||to_char(vrcta.ano_proc),'ddmmrrrr'));
     -- --
     -- Actualiza el estado en el maestro de movimientos (ARCKMM) con
     -- 1. Estado del documento en "A"
     -- 2. Se guarda la fecha de anulacion
     -- 3. Se cambia el indicador de Conciliado, puesto que si fue anulado
     --    debe registrarse como conciliado tambien.
     UPDATE arckmm
       SET estado        = 'A',
           fecha_anulado = vf_anula,
           usuario_anula = upper(user)
       WHERE no_cia    = pno_cia
       AND no_docu   = pno_transa;
     --
     -- --
     -- Borra referencias de Ajuste para el documento a Anular para que no
     -- sean tomadas en cuenta en el proceso de Conciliacion.
     DELETE arckra
      WHERE no_cia  = pno_cia
        AND no_docu = pno_transa;
     --
     -- --
     -- Actualiza el saldo de la cuenta bancaria
     CKactualiza_saldo_cta(pno_cia, vrmm.no_cta, vrmm.tipo_doc,
                           (- vrmm.monto), vrmm.tipo_cambio,
                           vrmm.estado,
                           vrmm.ano, vrmm.mes, vrmm.fecha, msg_error_p);
     --
     -- Si el movimiento ya fue generado a Contabilidad se debe
     -- reversar la distribucion contable
     IF nvl(vrmm.ind_con,'*') = 'P' THEN
       -- Actualiza el ARCKML
       -- Pone ind_con en X para indicar que las lineas de ese movimiento
       -- son descartados
       UPDATE arckml
          SET ind_con = 'X'
          WHERE no_cia = pno_cia
          AND no_docu  = pno_transa;
       --
       UPDATE arckmm
   	     SET ind_con   = 'G'
  	     WHERE rowid = vrmm.rowid;
     ELSIF nvl(vrmm.ind_con,'*') = 'G' THEN
	     -- Actualiza el ARCKML
	     -- Inserta de nuevo las lineas de la distribucion contable
	     -- pero con el tipo de movimiento inverso y con indicador de
	     -- contabilizado Pendiente
	     INSERT INTO arckml(
	               no_cia, procedencia, tipo_doc, no_docu,
	               cod_cont, centro_costo, tipo_mov,
                 monto_dc, monto, monto_dol, moneda,
                 tipo_cambio, modificable, codigo_tercero, ind_con)
           SELECT no_cia, procedencia, tipo_doc, no_docu,
                 cod_cont, centro_costo, decode(tipo_mov,'D','C','D'),
                 monto_dc, monto, monto_dol, moneda,
                 tipo_cambio, modificable, codigo_tercero, 'P'
            FROM arckml
            WHERE no_cia   = pno_cia
              AND no_docu  = pno_transa
              AND ind_con  = 'G';
       --
	     -- Pone el documento pendiente de contabilizar
       UPDATE arckmm
         SET ind_con = 'P'
         WHERE rowid = vrmm.rowid;
  	  END IF;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := nvl(msg_error_p, 'ERROR en ckanula_om');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := nvl(sqlerrm,'ERROR en anulacion de otros movimientos');
    RETURN;
END;