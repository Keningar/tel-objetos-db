CREATE OR REPLACE package            inact_standby is

  -- Author  : MARCIA
  -- Created : 22/03/2007 14:49:23
  -- Purpose :


PROCEDURE Actualiza(
  pcia   IN VARCHAR2,
  pcen   IN VARCHAR2,
  pper   IN VARCHAR2,
  pdoc   IN VARCHAR2,
  pfecha IN date,
  responsable_a   in arinme.respon_stand%type,
  porigen IN VARCHAR2,
  pmensaje OUT VARCHAR2,
  usuario_r in varchar2
) ;

PROCEDURE trae_documentos(
  cia     IN  VARCHAR2,
  TEntr   OUT VARCHAR2,
  TSali   OUT VARCHAR2,
  pformulario OUT VARCHAR2,
  ptipo   IN VARCHAR2,
  pmensaje OUT VARCHAR2);

  PROCEDURE Procesar_encabezado(
  pCia          IN arinme.No_Cia%type,
  pCentro       IN arinme.centro%type,
  pTipo         IN arinme.tipo_doc%type,
  pdocu         IN arinme.No_Docu%type,
  pno_fisico    IN arinme.no_fisico%type,
  pserie_fisico IN arinme.serie_fisico%type,
  pPeriodo      IN arinme.Periodo%type,
  pfecha        IN arinme.fecha%type,
  pObserv       IN arinme.observ1%type,
  pTC           IN arinme.tipo_Cambio%type,
  pTipoRef      IN arinme.Tipo_Refe%type,
  pno_docu_refe IN arinme.no_docu_refe%type,
  pmes          IN arinmeh.mes%type,
  psemana       IN arinmeh.semana%type,
  pind_sem      IN arinmeh.ind_sem%type,
  responsable   in arinme.respon_stand%type,
  pmensaje      OUT VARCHAR2,
  usuario_e varchar2);


  PROCEDURE Verifica_Articulo (
  cia         IN VARCHAR2,
  orig        IN VARCHAR2,
  dest        IN VARCHAR2,
  arti        IN VARCHAR2,
  cost_u      OUT NUMBER,
  cost_e      OUT NUMBER,
  ind_lote_p  OUT VARCHAR2,
  pcosto2     OUT NUMBER, --- Se agrega costo 2 ANR 09/04/2009
  pmensaje    OUT VARCHAR2);


PROCEDURE Procesar_Linea(
  pno_cia     IN varchar2,
  pcentro     IN varchar2,
  pperiodo    IN VARCHAR2,
  ptipo_doc   IN VARCHAR2,
  pno_docu    IN VARCHAR2,
  pfecha      IN DATE,
  pLinea      IN NUMBER,
  pBodega     IN VARCHAR2,
  pArticulo   IN VARCHAR2,
  pUnidades   IN NUMBER,
  pTotal      IN NUMBER,
  pTotal_dol  IN NUMBER,
  pcosto_u    IN NUMBER,
  pobserv1    IN VARCHAR2,
  ptipocambio IN NUMBER,
  ptime_stamp IN DATE,
  pmes        IN NUMBER,
  psemana     IN NUMBER,
  pind_sem    IN VARCHAR2,
  pTotal2     IN NUMBER,
  pTotal_dol2 IN NUMBER,
  pmensaje    OUT VARCHAR2
) ;

   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20033);
   kNum_error      NUMBER := -20033;

  ---  PROCEDURE genera_error(msj_error IN VARCHAR2);
   ---  PROCEDURE mensaje(msj IN VARCHAR2);

   --    FUNCTION  ultimo_error RETURN VARCHAR2;
   --FUNCTION  ultimo_mensaje RETURN VARCHAR2;

end inact_standby;
/


CREATE OR REPLACE package body            inact_standby is

  PROCEDURE Actualiza(
  pcia   IN VARCHAR2,
  pcen   IN VARCHAR2,
  pper   IN VARCHAR2,
  pdoc   IN VARCHAR2,
  pfecha IN date,
  responsable_a   in arinme.respon_stand%type,
  porigen IN VARCHAR2,
  pmensaje out varchar2,
  usuario_r in varchar2
) IS



   -- ---
   -- Actualiza el traslado
   --
--   vmensaje_error   varchar2(400);
   error_proceso    exception;
   --
   vtime_stamp      date;
   cost_u           arinma.costo_uni%type;
   cost_e           arinda.costo_estandar%type;
   mv_e             arinvtm.tipo_m%type;
   mv_s             arinvtm.tipo_m%type;
   cant             arintl.cantidad%type;
   vlinea           arinml.linea%type := 0;
   vcosto_unit      number;
   vcosto_unit2     number;
   vcosto_u_L       arinlo.costo_lote%type;
   vtotal_lin       arinml.monto%type;
   vtotal_lin2      arinml.monto2%type;
   vtotal_lin_dol   arinml.monto_dol%type;
   vtotal_lin_dol2  arinml.monto2_dol%type;

   vMensaje_e  varchar2(400);

   vind_lote        arinda.ind_lote%type;
   vcant_lin_lote   number;
   --
   vno_docu_e       arinme.no_docu%type;
   vno_docu_s       arinme.no_docu%type;
   vNo_Fisico       arinme.no_fisico%type;
   vSerie_Fisico    arinme.serie_fisico%type;
   --

   --
   vcl_cambio       arcgmc.clase_cambio%TYPE;
   vfecha           date;
   TCambioCV        varchar2(1);
   vTipoCambio      number;
   --
   vtercero_e       arindc.codigo_tercero%type := NULL;
   vtercero_s       arindc.codigo_tercero%type := NULL;

   ln_costo2        arinma.costo2%type;
   --



   -- ---
   -- CURSORES
   --
   --
   CURSOR c_clase_cambio IS
     SELECT clase_cambio
       FROM arcgmc
      WHERE no_cia = pcia;
   --
   CURSOR c_grupo_contable(pno_cia  grupos.no_cia%type,
                           pgrupo   grupos.grupo%type   ) IS
     SELECT grupo, metodo_costo
       FROM grupos
      WHERE no_cia  = pno_cia
        AND grupo   = pgrupo;
   --
   CURSOR c_traslados IS
     SELECT e.bod_orig orig,    e.bod_dest dest,
            e.no_docu  docu,    e.fecha    fecha,
            e.observ1  obse,
            c.centro   centro_d,
            e.rowid    rowid_te
       FROM arinbo b, arinte e, arinbo c
      WHERE e.no_cia      = pCia
        AND e.centro      = pCen
        AND e.no_docu     = pDoc
        AND e.ind_borrado = 'N'
        AND b.no_cia      = e.no_cia
        AND b.codigo      = e.bod_dest
        AND c.no_cia      = e.no_cia
        AND c.codigo      = e.bod_dest;
   --
   CURSOR c_lineas( xcia   varchar2,    xcto   varchar2,    xbor   varchar2,
                    xbde   varchar2,    xdoc   varchar2 ) IS
     SELECT l.no_arti arti,
            nvl(l.cantidad,0) cant, d.ultimo_costo, d.ultimo_costo2,
            d.grupo grupo_costo,l.precio_pvp, l.rowid rowid_tl
       FROM arinda d, arintl l
      WHERE l.no_cia          = xcia
        AND l.centro          = xcto
        AND l.bod_orig        = xbor
        AND l.bod_dest        = xbde
        AND l.no_docu         = xdoc
        AND nvl(l.cantidad,0) > 0
        AND d.no_cia          = l.no_cia
        AND d.no_arti         = l.no_arti
     FOR UPDATE OF cantidad;
   --

   --
   CURSOR c_tercero (cia_p varchar2, tipo_p varchar2) IS
     SELECT codigo_tercero
       FROM arinvtm
      WHERE no_cia     = cia_p
        AND tipo_m     = tipo_p;
   --
   --
   rmc         c_grupo_contable%ROWTYPE;
   rpp         inlib.periodo_proceso_r;
   vformulario control_formu.formulario%type;

	 Ln_total_cabecera   Number := 0;
	 Ln_total2_cabecera  Number := 0;

BEGIN


  moneda.inicializa(pcia);
  --

  SAVEPOINT inicio_actualiza;


  vmensaje_e := NULL;
  vtime_stamp        := SYSDATE;

  --
  -- Carga la clase de cambio
  OPEN  c_clase_cambio;
  FETCH c_clase_cambio INTO vcl_cambio;
  CLOSE c_clase_cambio;
  --

  TCambioCV  := 'C';
  vTipoCambio := Tipo_Cambio(vcl_cambio, trunc(pfecha), vfecha, TCambioCV);

  IF not inlib.trae_periodo_proceso(pcia, pcen, rpp) THEN
    RAISE error_proceso;
  END IF;

  trae_documentos(pcia, mv_e, mv_s,vformulario,porigen,pmensaje);


  --borrar_traslados;--
  ---- AQUI ESTE PROCESO ESTABA ACTIVO


  --
  -- obtiene los terceros ficticios definidos para el documento de entrada y el de salida.
  OPEN  c_tercero (pCia, mv_e);
  FETCH c_tercero INTO vTercero_e;
  CLOSE c_tercero;

  OPEN  c_tercero (pCia, mv_s);
  FETCH c_tercero INTO vTercero_s;
  CLOSE c_tercero;


  FOR et IN c_traslados LOOP

    -- Numeros de transaccion
    vno_docu_s := et.docu;
    vno_docu_e := transa_id.inv(pCia);

    --
    vNo_fisico    := Consecutivo.INV(pcia, rpp.ano_proce, rpp.mes_proce, pcen, mv_s, 'NUMERO');
    vSerie_Fisico := Consecutivo.INV(pcia, rpp.ano_proce, rpp.mes_proce, pcen, mv_s, 'SERIE');

    -- --
    -- Generando entrada en bodega destino en ARINME y ARINMEH
    -- Registro como referencia, el documento de salida de la bodega origen


    Procesar_Encabezado (pcia,           et.centro_d,
                          mv_e,          vno_docu_e,
                          vno_fisico,    vserie_Fisico,
                          pper,          pfecha,
                          et.obse,       vTipoCambio,
                          mv_s,          vno_docu_s,
                          rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem,responsable_a,pmensaje,usuario_r);

    -- Generando salida en bodega origen en ARINME y ARINMEH
    -- Registro como referencia, el documento de entrada de la bodega destino


    Procesar_Encabezado (pcia,          pcen,
                         mv_s,          vno_docu_s,
                         vno_fisico,    vserie_Fisico,
                         pper,          pfecha,
                         et.obse,       vTipoCambio,
                         mv_e,          vno_docu_e,
                         rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem,responsable_a,pmensaje,usuario_r);


    vlinea   := 0;

    -- ---
    -- Lee las lineas de los traslados
    --
    FOR lt IN c_lineas(pcia, pcen, et.orig, et.dest, vno_docu_s) LOOP

      vlinea  := vlinea + 1;

      -- Obtiene el metodo de costeo para el grupo del articulo actual.
      IF rmc.grupo is null or rmc.grupo != lt.grupo_costo THEN
        rmc.grupo := null;
        OPEN  c_grupo_contable(pcia, lt.grupo_costo);
        FETCH c_grupo_contable INTO rmc;
        CLOSE c_grupo_contable;

        IF rmc.grupo is null THEN
         -- genera_error('No existe el grupo contable: '||lt.grupo_costo);

          pmensaje:='No existe el grupo contable: '||lt.grupo_costo;
          return;

--          vmensaje_error := 'No existe el grupo contable: '||lt.grupo_costo;
  --        RAISE error_proceso;
        END IF;
      END IF;

      -- Obtiene las cuentas contables de inventario de Bodega Origen y
      -- bodega destino
      --NO VALIDAR EN ESTE CASO DE STAD BY PORQUE NO SE VA A GENERAR ASIENTO COTNABLE

    /*  IF NOT inlib.trae_cuentas_conta(pCia, lt.Grupo_Costo, et.dest, rCtas_Destino) THEN
        vmensaje_error := 'No existe Codigo Contable de inventario para el grupo '||
                          lt.grupo_costo||' y bodega '||et.dest;
        RAISE error_proceso;
      END IF;
      IF NOT inlib.trae_cuentas_conta(pCia, lt.Grupo_Costo, et.orig, rCtas_Origen) THEN
        vmensaje_error := 'No existe Codigo Contable de inventario para el grupo '||
                          lt.grupo_costo||' y bodega '||et.orig;
        RAISE error_proceso;
      END IF;*/


      -- Recupera el costo unitario del articulo en la bodega origen
      -- y Verifica la existencia del articulo en bodega destino

      Verifica_Articulo( pcia,    et.orig, et.dest, lt.arti,
                         cost_u,  cost_e,  vind_lote, ln_costo2, pmensaje); --- Se agrega costo 2 ANR 09/04/2009

      IF (rmc.metodo_costo = 'P') THEN
        vcosto_unit := nvl(cost_u,0);
        vcosto_unit2 := nvl(ln_costo2,0); ---- ANR se agrega costo2 09/04/2009
        vcosto_u_L  := vcosto_unit;
      ELSE
        IF (rmc.metodo_costo = 'E') AND (cost_e IS NULL) THEN
         --genera_error('El articulo '|| lt.arti ||' no tiene definido costo estandar');

         pmensaje:='El articulo '|| lt.arti ||' no tiene definido costo estandar';
         return;

          --vmensaje_error := 'El articulo '|| lt.arti ||' no tiene definido costo estandar';
          --RAISE error_proceso;
        END IF;
        vcosto_unit := nvl(cost_e,0);
        vcosto_unit2 := nvl(cost_e,0); ---- ANR En el caso de que sea estandar seria el mismo costo 09/04/2009

        vcosto_u_L  := vcosto_unit;
      END IF;

      vtotal_lin      := moneda.redondeo(nvl(abs(lt.cant * vcosto_unit), 0), 'P');
      vtotal_lin2     := moneda.redondeo(nvl(abs(lt.cant * vcosto_unit2), 0), 'P');
      vtotal_lin_dol  := moneda.redondeo(nvl(vtotal_lin / vTipoCambio,0), 'D');
      vtotal_lin_dol2 := moneda.redondeo(nvl(vtotal_lin2 / vTipoCambio,0), 'D');

      -- ---
      -- Procesa la ENTRADA en la bodega DESTINO
      --
      Procesar_linea(pcia,          et.centro_d,
                     pper,          mv_e,
                     vno_docu_e,    pfecha, vlinea,     et.dest,
                     lt.arti,
                     lt.cant,       vtotal_lin, vtotal_lin_dol,
                     lt.precio_pvp,   et.obse,
                     vTipoCambio,   vtime_stamp,
                     rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem,
                     vtotal_lin2,vtotal_lin_dol2, pmensaje); --- Se agrega el total 2 del costo 2 ANR 09/04/2009

      --
      -- Actualiza saldos del inventario.
      INActualiza_saldos_articulo (pCia, et.dest, lt.arti, 'TRASLADO',
                                   lt.cant, nvl(vtotal_lin,0),  Null, vmensaje_e);
      IF vmensaje_e is not null THEN

        RAISE error_proceso;
      END IF;

      --- Transfiere el costo a la bodega stand by

		      Update arinma set
		              costo_uni  = vcosto_unit,
                  ult_costo  = lt.ultimo_costo,
                  costo2     = vcosto_unit2,
                  ult_costo2 = lt.ultimo_costo2,
                  monto2     = vcosto_unit2 * (sal_ant_un + comp_un - vent_un - cons_un + otrs_un)
          Where no_cia  = pCia
          and   no_arti = lt.arti
          and   bodega  = et.dest;

      --
      -- ---
      -- Procesa la SALIDA de la bodega ORIGEN
      --
      Procesar_linea(pcia,  pcen,  pper,       mv_s,
                     vno_docu_s,   pfecha, vlinea,     et.orig,
                       lt.arti,
                     lt.cant,      vtotal_lin, vtotal_lin_dol,
                     lt.precio_pvp,  et.obse,
                     vTipoCambio, vtime_stamp,
                     rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem, vtotal_lin2, vtotal_lin_dol2, pmensaje);

      -- ---
      -- pone la cantidad del traslado en 0
      UPDATE arintl
         SET cantidad_solicitada = cantidad
       WHERE rowid = lt.rowid_tl;

      -- --
      -- Rebaja el saldo de inventario
      -- NOTA: Esta actualizacion de ARINMA debe realizarse despues
      --       del poner en 0, la cantidad en arintl, para que el trigger
      --       de arintl actualiza salidas pendientes y no se dispare
      --       el ck_saldo de arinma.
      --  No hay problema con el saldo del articulo porque el saldo
      -- solamente guarda existencias reales. ANR 23/03/2007
      INActualiza_saldos_articulo (pCia, et.orig, lt.arti, 'TRASLADO',
                                   -lt.cant, -nvl(vtotal_lin,0),  Null, vmensaje_e);
      IF vmensaje_e is not null THEN

        RAISE error_proceso;
      END IF;

	      --- En la bodega origen se actualiza solamente el costo 2 ANR 27/04/2009

		      Update arinma set
                  costo2     = vcosto_unit2,
                  ult_costo2 = lt.ultimo_costo2,
                  monto2     = vcosto_unit2 * (sal_ant_un + comp_un - vent_un - cons_un + otrs_un)
          Where no_cia  = pCia
          and   no_arti = lt.arti
          and   bodega  = et.orig;


--- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
--- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (pCia, lt.arti);

      -- ---
      -- Actualiza movimientos en lotes
      --
      vcant_lin_lote := 0;

		      Ln_total_cabecera  := vtotal_lin + Ln_total_cabecera;
		      Ln_total2_cabecera := vtotal_lin2 + Ln_total2_cabecera;


   END LOOP;


	    Update ARINME
	    set    mov_tot  = Ln_Total_cabecera,
	           mov_tot2 = Ln_Total2_cabecera
	    Where  no_cia  = pcia
	    and    no_docu = vno_docu_s;

	    Update ARINMEH
	    set    mov_tot  = Ln_Total_cabecera,
	           mov_tot2 = Ln_Total2_cabecera
	    Where  no_cia  = pcia
	    and    no_docu = vno_docu_s;

	    Update ARINME
	    set    mov_tot  = Ln_Total_cabecera,
	           mov_tot2 = Ln_Total2_cabecera
	    Where  no_cia  = pcia
	    and    no_docu = vno_docu_e;

	    Update ARINMEH
	    set    mov_tot  = Ln_Total_cabecera,
	           mov_tot2 = Ln_Total2_cabecera
	    Where  no_cia  = pcia
	    and    no_docu = vno_docu_e;

    -- marca el encabezado del traslado como borrado

    UPDATE arinte
       SET ind_borrado = 'S'
     WHERE ROWID = et.rowid_te;


  END LOOP;

exception
  when inlib.error then
--   genera_error(inlib.ultimo_error);
      pmensaje:=inlib.ultimo_error;
     ROLLBACK to inicio_actualiza;

  when transa_id.error then
--     genera_error(transa_id.ultimo_error);
pmensaje:=transa_id.ultimo_error;
     ROLLBACK to inicio_actualiza;

  when Consecutivo.Error then
     --genera_error(Consecutivo.Ultimo_Error);
   pmensaje:=Consecutivo.Ultimo_Error;
   return;

  when error_proceso then
     --genera_error( 'No fue posible traer el periodo en proceso, centro: '||pcen);
     pmensaje:='No fue posible traer el periodo en proceso, centro: '||pcen;
     ROLLBACK to inicio_actualiza;

  when others then
     --genera_error('Se ha detectado el siguiente error : '||sqlerrm);
     pmensaje:='Se ha detectado el siguiente error : '||sqlerrm;

     ROLLBACK to inicio_actualiza;

end;

PROCEDURE trae_documentos(
  cia     IN  VARCHAR2,
  TEntr   OUT VARCHAR2,
  TSali   OUT VARCHAR2,
  pformulario OUT VARCHAR2,
  ptipo   IN VARCHAR2,
  pmensaje  out varchar2
)
IS
  -- --
  -- Este procedimiento trae los tipos de documentos de entrada y salida
  -- de traslados



BEGIN
  -- Busca tipo de documento de traslado de entrada
  BEGIN
    SELECT tipo_m
      INTO TEntr
      FROM arinvtm
     WHERE no_cia = cia  AND
           movimi = 'E'  AND
           trasla = 'S' AND
           STAND_BY = 'S' AND
           nvl(RESERVA,'N') = DECODE (PTIPO,'R','S','T','N');


 EXCEPTION
      WHEN NO_DATA_FOUND THEN
      pmensaje:='El documento de traslado de entrada no se encuentra definido';
      return;
--     Genera_Error('El documento de traslado de entrada no se encuentra definido');


      WHEN TOO_MANY_ROWS THEN
      pmensaje:='Existe mas de un tipo de documento de Traslado de Entrada, verifique que solo haya uno.';
      return;
      --Genera_Error('Existe mas de un tipo de documento de Traslado de Entrada, verifique que solo haya uno.');*/


  END;

  BEGIN
  -- Busca tipo de documento de traslado de ajuste
    SELECT tipo_m, formulario
      INTO TSali, Pformulario
      FROM arinvtm
     WHERE no_cia = cia  AND
           movimi = 'S'  AND
           trasla = 'S'  AND
           STAND_BY = 'S' AND
           nvl(RESERVA,'N') = DECODE (PTIPO,'R','S','T','N');

    IF Pformulario IS NULL THEN
    pmensaje:='El documento de traslado de salida no tiene formulario asociado.';
    return;

    END IF ;

 EXCEPTION
      WHEN NO_DATA_FOUND THEN
      pmensaje:='El documento de traslado de salida no se encuentra definido';
      return;

      WHEN TOO_MANY_ROWS THEN
      pmensaje:='Existe mas de un tipo de documento de Traslado de Salida, verifique que solo haya uno.';
      return;


  END;
END;

PROCEDURE Procesar_encabezado(
  pCia          IN arinme.No_Cia%type,
  pCentro       IN arinme.centro%type,
  pTipo         IN arinme.tipo_doc%type,
  pdocu         IN arinme.No_Docu%type,
  pno_fisico    IN arinme.no_fisico%type,
  pserie_fisico IN arinme.serie_fisico%type,
  pPeriodo      IN arinme.Periodo%type,
  pfecha        IN arinme.fecha%type,
  pObserv       IN arinme.observ1%type,
  pTC           IN arinme.tipo_Cambio%type,
  pTipoRef      IN arinme.Tipo_Refe%type,
  pno_docu_refe IN arinme.no_docu_refe%type,
  pmes          IN arinmeh.mes%type,
  psemana       IN arinmeh.semana%type,
  pind_sem      IN arinmeh.ind_sem%type,
  responsable   in arinme.respon_stand%type,
  pmensaje      out varchar2,
  usuario_e     in varchar2
) IS

BEGIN


-- registra el encabezado del movimiento
   INSERT INTO ARINME (No_Cia,  Centro,      Tipo_Doc,
                       Periodo, Ruta,        No_Docu,
                       Fecha,   Estado,
                       Observ1, Tipo_Cambio,
                       No_Fisico,   Serie_Fisico,
                       Tipo_Refe,   no_docu_refe,RESPON_STAND,usuario)
               VALUES (pCia,       pCentro,     pTipo,
                       pPeriodo,   '0000',      pDocu,
                       pFecha,     'D',
                       pobserv,    pTC,
                       pno_fisico, pserie_fisico,
                       pTipoRef,   pno_docu_refe,responsable,usuario_e);


-- registra el encabezado del movimiento en el historico

   INSERT INTO ARINMEH (No_Cia,    Centro,      Tipo_Doc,
                        Periodo,   Ruta,        No_Docu,
                        Fecha,
                        Observ1,   Tipo_Cambio,
                        No_Fisico, Serie_Fisico,
                        Tipo_Refe, no_docu_refe,
                        mes,        semana,      ind_sem,RESPON_STAND,usuario)
                VALUES (pCia,       pCentro,     pTipo,
                        pPeriodo,   '0000',      pDocu,
                        pFecha,
                        pobserv,    pTC,
                        pno_fisico, pserie_fisico,
                        pTipoRef,   pno_docu_refe,
                        pmes,       psemana,     pind_sem,responsable,usuario_e);

exception
  when others then
      pmensaje:= 'Error al crear la transaccion'||sqlerrm;
      return;
END;

PROCEDURE Verifica_Articulo (
  cia         IN VARCHAR2,
  orig        IN VARCHAR2,
  dest        IN VARCHAR2,
  arti        IN VARCHAR2,
  cost_u      OUT NUMBER,
  cost_e      OUT NUMBER,
  ind_lote_p  OUT VARCHAR2,
  pcosto2     OUT NUMBER, --- Se agrega costo 2 ANR 09/04/2009
  pmensaje    out varchar2
) IS

-- Chequea la existencia del articulo en la bodega origen y destino.
-- Si no existe en la bodega destino crea el articulo.
-- Si el articulo existe en la bodega origen devuelve el costo unitario
-- de este en la variable cost.

  vmsg_error    varchar2(500);
  error_proceso exception;
  vafecta_costo arinma.afecta_costo%type;
BEGIN

  -- Selecciona Costos y otros datos del articulo en la bodega origen
  BEGIN
    SELECT m.costo_uni, d.costo_estandar, d.ind_lote, m.afecta_costo, costo2
      INTO cost_u, cost_e, ind_lote_p, vafecta_costo, pcosto2 --- Se agrega costo 2 ANR 09/04/2009
      FROM arinda d, ARINMA M
     WHERE m.NO_CIA    = cia         AND
           m.BODEGA    = orig        AND
           m.NO_ARTI   = arti        and
           d.NO_CIA    = m.no_cia    AND
           d.NO_ARTI   = m.no_arti;
    EXCEPTION
      WHEN No_Data_Found THEN
     pmensaje:= 'El articulo '||arti||' no existe '||
                       'en la bodega ORIGEN';
     return;


    END;

    --
       INCrea_Articulo(cia, dest, arti, vafecta_costo, vmsg_error);
    IF vmsg_error is not null THEN
      RAISE error_proceso;
    END IF;

  EXCEPTION
  WHEN error_proceso THEN
      pmensaje:='Error al crear el articulo'||sqlerrm;
      return;


END;


PROCEDURE Procesar_Linea(
  pno_cia     IN varchar2,
  pcentro     IN varchar2,
  pperiodo    IN VARCHAR2,
  ptipo_doc   IN VARCHAR2,
  pno_docu    IN VARCHAR2,
  pfecha      IN DATE,
  pLinea      IN NUMBER,
  pBodega     IN VARCHAR2,
  pArticulo   IN VARCHAR2,
  pUnidades   IN NUMBER,
  pTotal      IN NUMBER,
  pTotal_dol  IN NUMBER,
  pcosto_u    IN NUMBER,
  pobserv1    IN VARCHAR2,
  ptipocambio IN NUMBER,
  ptime_stamp IN DATE,
  pmes        IN NUMBER,
  psemana     IN NUMBER,
  pind_sem    IN VARCHAR2,
  pTotal2     IN NUMBER,
  pTotal_dol2 IN NUMBER,
  Pmensaje    out varchar2

) IS

  vruta         arinml.ruta%type        := '0000';

BEGIN


  INSERT INTO ARINML(NO_CIA, CENTRO, TIPO_DOC, PERIODO, RUTA, NO_DOCU,
                     LINEA, LINEA_EXT, BODEGA,  NO_ARTI,
                     UNIDADES, MONTO, MONTO_DOL, TIPO_CAMBIO,Precio_Venta, monto2, monto2_dol)
         VALUES (pno_cia, pcentro, ptipo_doc, pperiodo, vruta, pno_docu,
                 pLinea, pLinea, pBodega,  pArticulo,
                 abs(pUnidades), abs(pTotal), abs(ptotal_dol), ptipocambio,pcosto_u, abs(pTotal2), abs(ptotal_dol2));

  INinserta_mn( pno_cia, pcentro, ptipo_doc, pno_docu,
                pperiodo, pmes, psemana, pind_sem, vruta,
                pLinea, pbodega,
                particulo, pfecha,  abs(punidades), abs(pTotal),
                null,
                null, null, null,
                abs(pTotal)/abs(punidades), ptime_stamp, '000000000','N',pcosto_u, abs(pTotal2), abs(ptotal_dol2));
--ANR se agrega el monto2 (vmonto_neto2));



exception
  when others then
      Pmensaje:= 'Error al crear el detalle de la transaccion'||sqlerrm;
      return;
END;

end;
/
