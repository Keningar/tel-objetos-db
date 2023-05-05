create or replace PROCEDURE            CGAnular_asientos_reservados (
   pNo_cia      in  arcgaeh.no_cia%type,
   pAno         in  arcgaeh.ano%type,
   pMes         in  arcgaeh.mes%type,
   pForm_ing    in  arcgmc.form_ingreso%type,
   pForm_egr    in  arcgmc.form_egreso%type,
   pForm_tra    in  arcgmc.form_traspaso%type,
   pCod_diario  in  arcgaeh.cod_diario%type,
   pmsg_error   in out varchar2
 ) IS
    -- Este proceso verifica si existen asientos reservados que no han sido utilizados, de ser asi,
    -- debe insertar estos asientos en el ARCGAE como asientos nulos.
    --
    error_proceso   EXCEPTION;
    --
    vultimo        number;
    vsiguiente     number;
    vfecha         DATE;
    vfecha1        DATE;
    vError_for     formulario.registro_error;
    vDatos_for     formulario.datos_formulario;
    vDatos_for_per formulario.datos_formu_periodo;
    --
    vError          varchar2(100) := NULL;
    --
    -- Definimos procedimiento interno para insertar en la tabla arcgaeh.
    PROCEDURE inserta_arcgaeh_nulo (
       pNo_cia     in arcgaeh.no_cia%type
       ,pAno        in arcgaeh.ano%type
       ,pMes        in arcgaeh.mes%type
       ,pFecha      in arcgaeh.fecha%type
       ,pCod_diario in arcgaeh.cod_diario%type
       ,pTipo_comp  in arcgaeh.tipo_comprobante%type
       ,pNo_comp    in arcgaeh.no_comprobante%type
       ,pError      in out varchar2
    ) IS
      vdescri1    arcgaeh.descri1%type := 'Asiento anulado';
      vno_asiento arcgaeh.no_asiento%type;
    BEGIN
      pError := null;
      vno_asiento := transa_id.cg(pno_cia);
      IF nvl(vno_asiento,'0') = '0' THEN
        pError := 'No fue posible generar el numero de transaccion';
      ELSE
        insert into arcgaeh (no_cia, ano, mes, no_asiento, fecha, descri1, estado,
                             autorizado, origen, t_debitos, t_creditos, cod_diario,
                             t_camb_c_v, tipo_cambio, tipo_comprobante, no_comprobante,
                             anulado)
                      values(
                             pno_cia, pano, pmes, vno_asiento, pfecha, vdescri1 , 'A',
                             'S', 'CG', 0, 0, pcod_diario,
                             'C', 0, ptipo_comp, pno_comp,
                             'A');
      END IF;
    EXCEPTION
      WHEN transa_id.error THEN
         pError := transa_id.ultimo_error;
    END;
    --
BEGIN
  pmsg_error := null;
  -- Obtenemos la fecha de los asientos
  vfecha1  := to_date('01'||lpad(to_char(pmes),2,'0')||to_char(pano), 'ddmmRRRR');
  vfecha   := last_day(vfecha1);
  --
  -- Anulamos la reserva del formulario de traspaso.
  --
  -- Obtenemos los datos del formulario de traspaso.
  vDatos_for := formulario.datos(pno_cia,pform_tra);
  IF vDatos_for.ind_reseteo in ('RA','RN') THEN
     vDatos_for_per := formulario.datos_periodo(pno_cia,pform_tra, (pAno*100+pMes));
     vsiguiente     := vDatos_for_per.siguiente;
     vultimo        := vDatos_for_per.num_final;
     FOR r1 IN vsiguiente .. vultimo LOOP
       inserta_arcgaeh_nulo(pno_cia, pano, pmes, vfecha, pcod_diario, 'T', vsiguiente, vError);
       if vError is not null then
          pmsg_error := vError;
          raise error_proceso;
       end if;
     END LOOP;
  END IF;
  --
  -- Anulamos la reserva del formulario de egreso.
  --
  -- Obtenemos los datos del formulario de egreso.
  vDatos_for := formulario.datos(pno_cia,pform_egr);
  IF vDatos_for.ind_reseteo in ('RA','RN') THEN
    IF pform_egr != pform_tra THEN
       vDatos_for_per := formulario.datos_periodo(pno_cia,pform_egr, (pAno*100+pMes));
       vsiguiente     := vDatos_for_per.siguiente;
       vultimo        := vDatos_for_per.num_final;
       FOR r1 IN vsiguiente .. vultimo LOOP
         inserta_arcgaeh_nulo(pno_cia, pano, pmes, vfecha, pcod_diario, 'E', vsiguiente, vError);
         if vError is not null then
            raise error_proceso;
         end if;
       END LOOP;
    END IF;
  END IF;
  --
  -- Anulamos la reserva del formulario de ingreso.
  --
  -- Obtenemos los datos del formulario de ingreso.
  vDatos_for := formulario.datos(pno_cia,pform_ing);
  IF vDatos_for.ind_reseteo in ('RA','RN') THEN
    IF (pform_ing  != pform_tra) and
       (pform_ing  != pform_egr) THEN
      --
      vDatos_for_per := formulario.datos_periodo(pno_cia,pform_ing, (pAno*100+pMes));
      vsiguiente     := vDatos_for_per.siguiente;
      vultimo        := vDatos_for_per.num_final;
      FOR r1 IN vsiguiente .. vultimo LOOP
        inserta_arcgaeh_nulo(pno_cia, pano, pmes, vfecha, pcod_diario, 'I', vsiguiente, vError);
        if vError is not null then
           raise error_proceso;
        end if;
      END LOOP;
    END IF;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := nvl(vError, 'CGanular_asientos_reservados');
  WHEN others THEN
    pmsg_error := nvl(sqlerrm,'CGanular_asientos_reservados');
END;