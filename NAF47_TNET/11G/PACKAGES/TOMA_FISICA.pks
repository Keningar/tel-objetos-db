CREATE OR REPLACE PACKAGE            Toma_Fisica IS
  /*--Este paquete presenta una serie de procedimientos y funciones (tanto privados como publicos)*/
  --necesarias para la realizacion del proceso de Toma Fisica

   --* Preparacion
   --  Este procedimiento se encarga preparar los articulos para la toma fisica.
   --
   --* Realizar_Ajuste
   --  Este procedimiento se encarga de realizar el ajuste de los articulos que fueron
   --  introducidas las cantidades existentes de productos
   --
   --* Cancelacion
   --  Este procedimiento se encarga de cancelar los articulos preparados para
   --  la toma fisica.
   --
  PROCEDURE Preparacion (cia_p        in varchar2,
                          centro_p     in varchar2,
                          bod1_p       in varchar2,
                          bod2_p       in varchar2,
                          marca_d_p    in varchar2,
                          marca_h_p    in varchar2,
                          division_d_p in varchar2,
                          division_h_p in varchar2,
                          subdivision_d_p in varchar2,
                          subdivision_h_p in varchar2,
                          articulo_d_p in varchar2,
                          articulo_h_p in varchar2);
  --
  --
     PROCEDURE realizar_ajuste (cia_p        varchar2,
                              centro_p     varchar2,
                              fecha_p      date,
                              tipodoc_e_p  varchar2,
                              tipodoc_s_p  varchar2,
                              no_docu_e_p  IN OUT varchar2,
                              no_docu_s_p  IN OUT varchar2,
                              tot_e_p      IN OUT number,
                              tot_s_p      IN OUT number,
                              bod1_p       varchar2,
                              bod2_p       varchar2,
                              marca_d_p    varchar2,
                              marca_h_p    varchar2,
                              division_d_p varchar2,
                              division_h_p varchar2,
                              subdivision_d_p varchar2,
                              subdivision_h_p varchar2,
                              articulo_d_p varchar2,
                              articulo_h_p varchar2);

 PROCEDURE cancelacion (cia_p        varchar2,
                        centro_p     varchar2,
                        bod1_p       varchar2,
                        bod2_p       varchar2,
                        marca_d_p    varchar2,
                        marca_h_p    varchar2,
                        division_d_p varchar2,
                        division_h_p varchar2,
                        subdivision_d_p varchar2,
                        subdivision_h_p varchar2,
                        articulo_d_p varchar2,
                        articulo_h_p varchar2);
  --
  --
  FUNCTION ultimo_error RETURN VARCHAR2 ;
  --
  error           EXCEPTION;
  PRAGMA          EXCEPTION_INIT(error, -20037);
  kNum_error      NUMBER := -20037;
END;
/


CREATE OR REPLACE PACKAGE BODY            Toma_Fisica IS

  /*******[ PARTE: PRIVADA ]  ****************
  * Declaracion de Procedimientos o funciones PRIVADOS
  */
  vMensaje_error       VARCHAR2(160);
  PROCEDURE limpia_error IS
  BEGIN
     vMensaje_error := NULL;
  END;
  --
  PROCEDURE genera_error(msj_error IN VARCHAR2)IS
  BEGIN
    vMensaje_error := substr(msj_error,1,160);
    RAISE_APPLICATION_ERROR(kNum_error, msj_error);
  END;
  --
  --El procedimiento Procesar_encabezado es utilizado en el procedimiento
  --Realizar_ajuste
  PROCEDURE procesar_encabezado(pCia          IN arinme.no_cia%type,
                                pCentro       IN arinme.centro%type,
                                pTipo         IN arinme.tipo_doc%type,
                                pdocu         IN arinme.no_docu%type,
                                pno_fisico    IN arinme.no_fisico%type,
                                pserie_fisico IN arinme.serie_fisico%type,
                                pPeriodo      IN arinme.Periodo%type,
                                pfecha        IN arinme.fecha%type,
                                pObserv       IN arinme.observ1%type,
                                pTC           IN arinme.tipo_cambio%type,
                                pmes          IN arinmeh.mes%type,
                                psemana       IN arinmeh.semana%type,
                                pind_sem      IN arinmeh.ind_sem%type) IS

  BEGIN
    -- registra el encabezado del movimiento
    INSERT INTO arinme (no_cia,  centro,      tipo_doc,
    	                  periodo, ruta,        no_docu,
                        fecha,   estado,
                        observ1, tipo_cambio,
                        no_fisico,   serie_fisico,
                        Usuario,Fecha_Aplicacion)
                VALUES (pCia,       pCentro,     pTipo,
                        pPeriodo,   '0000',      pDocu,
                        pFecha,     'D',
                        pobserv,    pTC,
                        pno_fisico, pserie_fisico,
                        user,sysdate);

    -- registra el encabezado del movimiento en el historico

    INSERT INTO arinmeh (No_Cia,    Centro,      Tipo_Doc,
                         Periodo,   Ruta,        No_Docu,
                         Fecha,
                         Observ1,   Tipo_Cambio,
                         No_Fisico, Serie_Fisico,
                         mes,        semana,      ind_sem,
                         Usuario,fecha_aplicacion)
                 VALUES (pCia,       pCentro,     pTipo,
                         pPeriodo,   '0000',      pDocu,
                         pFecha,
                         pobserv,    pTC,
                         pno_fisico, pserie_fisico,
                         pmes,       psemana,     pind_sem,
                         user,sysdate);
  END; --Procesar_Encabezado
  --
  --
  --El procedimiento Procesar_Linea es utilizado en el procedimiento
  --Realizar_ajuste
  PROCEDURE procesar_linea (pcia         IN varchar2,
                            pcentro      IN varchar2,
                            pperiodo     IN varchar2,
                            pTipo_doc    IN varchar2,
                            pno_docu     IN varchar2,
                            pfecha       IN date,
                            pLin         IN number,
                            pBodega      IN varchar2,
                            pArticulo    IN varchar2,
                            pUnidades    IN number,
                            pTotal       IN number,
                            pTotal_dol   IN number,
                            pCosto_u     IN number,
                            ptipocambio  IN number,
                            ptime_stamp  IN date,
                            pmes         IN number,
                            psemana      IN number,
                            pind_sem     IN varchar2,
                            p_monto2		  in Number,
												    p_monto2_dol	in number,
												    p_costo2			in number) IS

    vruta        arinmn.ruta%type;

  BEGIN

    If ptipocambio is null then
     null;
    End If;

    vruta  := '0000';

    /*-- Actualiza valores en ARINML. Si ya existe registro, lo modifica y sino lo inserta*/
    UPDATE arinml
       SET unidades  = nvl(unidades,0)  + abs(pUnidades),
           monto     = nvl(monto,0)     + abs(pTotal),
           monto_dol = nvl(monto_dol,0) + abs(pTotal_dol),
           monto2    = nvl(monto2,0)     + abs(p_monto2),
           monto2_dol = nvl(monto2_dol,0) + abs(p_monto2_dol)
/*---- Se agrega monto 2 ANR 07/07/2009*/
     WHERE no_cia    = pcia
       AND no_docu   = pno_docu
       AND linea     = pLin
       AND bodega    = pbodega
       AND no_arti   = particulo;

    IF sql%rowcount = 0 THEN
      /*** [Insercion de una linea en la tabla ARINML] ***/
      INSERT INTO arinml(NO_CIA,   CENTRO,   TIPO_DOC,   PERIODO,
                         RUTA,     NO_DOCU,  LINEA,      LINEA_EXT,
                         BODEGA,   NO_ARTI,
                         UNIDADES, MONTO,    MONTO_DOL,
                         Time_Stamp, monto2, monto2_dol)
                  VALUES(pcia,     pcentro,  pTipo_doc,  pperiodo,
                         vruta,    pno_docu, pLin,       pLin,
                         pBodega,  pArticulo,
                         abs(pUnidades), abs(pTotal), abs(pTotal_dol),
                         sysdate, abs(p_monto2), abs(p_monto2_dol));
/*---- Se agrega monto 2 ANR 07/07/2009*/
    END IF;

    /*-- Actualiza valores en ARINMN. Si ya existe registro, lo modifica y sino lo inserta*/
    UPDATE arinmn
       SET costo_uni = abs(pCosto_u),
           unidades  = nvl(unidades,0)  + abs(pUnidades),
           monto     = nvl(monto,0)     + abs(pTotal)
     WHERE no_cia    = pcia
       AND no_docu   = pno_docu
       AND no_linea  = plin
       AND bodega    = pbodega
       AND no_arti   = particulo;

    IF sql%rowcount = 0 THEN
      /*** [Insercion de una linea en la tabla ARINMN] ***/
      INinserta_mn( pcia,      pcentro, ptipo_doc, pno_docu,
                    pperiodo,  pmes,    psemana,   pind_sem,
                    vruta,     pLin,    pbodega,   particulo,
                    pfecha,    abs(pUnidades),     abs(pTotal),
                    null,      null,
                    null,      null,
                    abs(pTotal)/abs(punidades), ptime_stamp,'000000000','N',0,p_monto2,			p_costo2);
    END IF;

  EXCEPTION
    WHEN others THEN
         genera_error('Se ha originado el siguiente error: '||SQLERRM);
  END;--Procesar_Linea
  --
  --
  -- El procedimiento Procesar_linea_lote es utilizado en el procedimiento
  -- Realizar_ajuste
  PROCEDURE procesar_linea_lote(ciap       IN varchar2,
                                cenp       IN varchar2,
                                tdocp      IN varchar2,
                                perp       IN varchar2,
                                rutap      IN varchar2,
                                docup      IN varchar2,
                                lineap     IN number,
                                lotep      IN varchar2,
                                bodep      IN varchar2,
                                artip      IN varchar2,
                                unip       IN number,
                                ubicp      IN varchar2,
                                fechavp    IN date)    IS

  BEGIN

    -- Registra la linea del lote en el movimiento del mes (ARINMO)
    INSERT INTO arinmo(no_cia,    centro,   tipo_doc,  periodo,
                       ruta,      no_docu,  linea,     no_lote,
                       unidades,  monto,    ubicacion, fecha_vence )
        	      VALUES(ciap,      cenp,     tdocp,     perp,
                       rutap,     docup,    lineap,    lotep,
                       unip,
                       0,---montop, --- los lotes solo manejan unidades ANR 07/07/2009
                       ubicp,     fechavp );

    -- Registra la linea del lote, en el HISTORICO (ARINMT)
    INSERT INTO arinmt(no_cia,  centro,   tipo_doc,  ano,
                       ruta,    no_docu,  no_linea,  bodega,
                       no_arti, no_lote,  unidades,  venta,   descuento)
          	    VALUES(ciaP,    cenp,     tdocp,     perp,
                       rutap,   docup,    lineap,    bodep,
                       artip,   lotep,    unip,
                       0,---montop,  --- los lotes manejan solo unidades ANR 07/07/2009
                       0);

  EXCEPTION
    WHEN others THEN
         genera_error('Se ha originado el siguiente error: '||SQLERRM);
  END;


  /*******[ PARTE: PUBLICA ] *************************
  * Declaracion de Procedimientos o funciones PUBLICAS
  *
  */
  --
  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
    RETURN(vMensaje_error);
  END ultimo_error;
  --
  --

  PROCEDURE preparacion ( cia_p        varchar2,
                          centro_p     varchar2,
                          bod1_p       varchar2,
                          bod2_p       varchar2,
                          marca_d_p    varchar2,
                          marca_h_p    varchar2,
                          division_d_p varchar2,
                          division_h_p varchar2,
                          subdivision_d_p varchar2,
                          subdivision_h_p varchar2,
                          articulo_d_p varchar2,
                          articulo_h_p varchar2) IS

  -- Este procedimiento se encarga preparar los articulos para la
  -- toma fisica, esto es en el campo EXIST_PREP deja el saldo actual,
  -- en COSTO_PREP el costo unitario y el indicador PROCESO_TOMA en 'S'
  -- Toma los articulos que se prepararon para la toma fisica y los almacena
  -- en la tabla ARINTF y los que poseen lotes en la tabla ARINTFLO
  --
  vgrp_conta     arinda.grupo%type;
  vcosto         arinma.costo_uni%type;
  --
  Cursor c_arti_prep Is
    Select d.descripcion, m.no_cia, m.bodega, m.no_arti, d.marca, d.division, d.subdivision,

      (Select grupo grupo_contable
         from arinda
        where no_cia=cia_p
          and no_arti = m.no_arti) grupo_contable

         From arinma m, arinbo b, arinda d
        Where m.no_cia = cia_p
          and b.no_cia = m.no_cia
          and b.centro = centro_p
          and b.codigo = m.bodega
          and b.tipobodega = 'A'
          and (bodega between bod1_p and bod2_p)
          and (m.no_cia, m.no_arti) in (Select no_cia, no_arti
                                          From arinda
                                         where no_cia=cia_p
                                           and marca between nvl(marca_d_p,marca) and nvl(marca_h_p,marca)
                                           and division between nvl(division_d_p,division) and nvl(division_h_p,division)
                                           and subdivision between nvl(subdivision_d_p,subdivision) and nvl(subdivision_h_p,subdivision)
                                           and no_arti between nvl(articulo_d_p,no_arti) and nvl(articulo_h_p,no_arti))
          and nvl(m.proceso_toma,'N') = 'N'
          and m.no_cia = d.no_cia
          and m.no_arti = d.no_arti;

  Begin
    For c in c_arti_prep Loop
     ----
      If vgrp_conta is null or vgrp_conta != c.grupo_contable Then
        -- Obtiene el metodo de costeo para el grupo del articulo actual.
        vcosto := articulo.costo(c.no_cia, c.no_arti, c.bodega);
        --
        Update arinma  --- la toma fisica no debe modificar costos ANR 07/07/2009
           Set exist_prep   = NVL(SAL_ANT_UN,0) + NVL(COMP_UN,0)+ NVL(OTRS_UN,0)-
                              NVL(VENT_UN,0)    - NVL(CONS_UN,0),
               costo_prep   = vcosto,
               proceso_toma = 'S'
         Where no_cia    = c.no_cia
           And bodega    = c.bodega
           And no_arti   = c.no_arti;
         --

/*---  Debe actualizar el monto 2 y el saldo valuado para todas las bodegas ANR 07/07/2009
Inserta los articulos preparados para la toma fisica en la tabla ARINTF*/


        INSERT INTO arintf (no_cia,   no_toma,    bodega,        no_arti,        tom_fisic, marca,    division,   subdivision,   usuario_genera, tstamp, descripcion)
                    Values (c.no_cia, 1,          c.bodega,      c.no_arti,      null, c.marca,  c.division, c.subdivision, user,   Sysdate, c.descripcion);
        --
        UPDATE arinlo
           SET exist_prep   = saldo_unidad,
               costo_prep   = 0,
               proceso_toma = 'S',
               costo2       = 0
         WHERE no_cia    = cia_p
           AND bodega    = c.bodega
           AND no_arti   = c.no_arti;
        --
        /*--Inserta los articulos con lotes preparados para la toma fisica en la tabla ARINTFLO*/
        INSERT INTO arintflo (no_cia, no_toma, bodega, no_arti, no_lote,  tom_fisic)
             SELECT no_cia, 1, bodega, no_arti, no_lote,  null
               FROM arinlo
              WHERE no_cia    = c.no_cia
                AND bodega    = c.bodega
                AND no_arti   = c.no_arti;
        --
      END IF;
    END LOOP;
  EXCEPTION
    WHEN articulo.error THEN
         genera_error(articulo.ultimo_error);
    WHEN others THEN
  	  	 genera_error(sqlerrm);
  END; --Preparacion
  --
  --
  PROCEDURE realizar_ajuste (cia_p           varchar2,
                             centro_p        varchar2,
                             fecha_p         date,
                             tipodoc_e_p     varchar2,
                             tipodoc_s_p     varchar2,
                             no_docu_e_p     IN OUT varchar2,
                             no_docu_s_p     IN OUT varchar2,
                             tot_e_p         IN OUT number,
                             tot_s_p         IN OUT number,
                             bod1_p          varchar2,
                             bod2_p          varchar2,
                             marca_d_p       varchar2,
                             marca_h_p       varchar2,
                             division_d_p    varchar2,
                             division_h_p    varchar2,
                             subdivision_d_p varchar2,
                             subdivision_h_p varchar2,
                             articulo_d_p    varchar2,
                             articulo_h_p    varchar2) Is
    -- --
    -- Este procedimiento se encarga de realizar el ajuste para los articulos
    -- que hayan presentado alguna diferencia con respecto al conteo fisico.
    -- El proceso solo toma en cuenta aquellos articulos cuyo indicador de
    -- toma fisica este en 'S' y que tengan diferencia.  Si el campo
    -- tom_fisic es nulo, entonces el articulo no se toma en cuenta.
    --
    error_proceso  exception;
    vMsg_error     varchar2 (240);
    --
    vtime_stamp    date;
    vno_docu       arinme.no_docu%type;
    vno_docu_e     arinme.no_docu%type;
    vno_docu_s     arinme.no_docu%type;
    --
    me             number := 0;
    ms             number := 0;

    me2            number := 0;
    ms2            number := 0;

    lin_e          number := 0;
    lin_s          number := 0;
    vtdoc          arinml.tipo_doc%type;
    vlin           arinml.linea%type;
    --
    vrctas         inlib.cuentas_contables_r;
    vtmov_inv      arindc.tipo_mov%type;
    vtmov_aju      arindc.tipo_mov%type;
    vTercero_dc    arindc.codigo_tercero%type := NULL;
    vTercero_e     arindc.codigo_tercero%type := NULL;
    vTercero_s     arindc.codigo_tercero%type := NULL;
    vcta_inv       arincc.cta_inventario%type;
    vcta_aju       arincc.cta_ajuste%type;
    vcentro_costo  arincc.centro_costo%type;
    --
    vdifeaux       number;
    vtdife_un      arinma.otrs_un%type;
    vtdife_mon     arinma.otrs_mon%type;
    vdife          arinma.otrs_un%type;
    vmonto         arinml.monto%type;
    vmonto_dol     arinml.monto%type;
    --
    vmonto2         arinml.monto2%type;
    vmonto2_dol     arinml.monto2%type;
    --

    vcl_cambio     arcgmc.clase_cambio%TYPE;
    vTipoCambio    arindc.tipo_cambio%TYPE;
    vf_aux         date;
    --
    rpp            INLIB.periodo_proceso_r;
    --
    --
    CURSOR c_grupo_contable(pno_cia  grupos.no_cia%type, pgrupo   grupos.grupo%type) IS
    	SELECT grupo, metodo_costo
        FROM grupos
     	 WHERE no_cia  = pno_cia
         AND grupo   = pgrupo;
    --
    CURSOR c_clase_cambio IS
    	SELECT clase_cambio
        FROM arcgmc
     	 WHERE no_cia = cia_p;
    --
    -- Selecciona las lineas de los articulos con toma_fisica diferente de NULL
    CURSOR c_lee_ajustes IS
    SELECT t.bodega bode, t.no_toma,
           t.no_arti arti,
           nvl(a.exist_prep,0) exist_prep,
           nvl(t.tom_fisic, a.exist_prep) tom_fisic,
           nvl(a.costo_prep,0) costo_unit,
           nvl(a.costo2,0) costo2_unit,
           d.grupo grupo_conta,
           d.ind_lote indlote,
           t.no_cia,
           a.rowid rowid_arinma,
           t.rowid rowid_arintf
   	  From arintf t, arinda d, arinma a, arinbo b
     Where t.no_cia = cia_p
       And (t.bodega BETWEEN bod1_p AND bod2_p)
       and t.marca between nvl(marca_d_p,t.marca) and nvl(marca_h_p,t.marca)
       and t.division between nvl(division_d_p,t.division) and nvl(division_h_p,t.division)
       and t.subdivision between nvl(subdivision_d_p,t.subdivision) and nvl(subdivision_h_p,t.subdivision)
       and t.no_arti between nvl(articulo_d_p,t.no_arti) and nvl(articulo_h_p,t.no_arti)
       And t.tom_fisic is not null
       And t.no_cia = d.no_cia
       And t.no_arti = d.no_arti
       And d.no_cia = a.no_cia
       And d.no_arti = a.no_arti
       And a.bodega = t.bodega
       And nvl(a.proceso_toma,'N')  = 'S'
       And b.no_cia = a.no_cia
       And b.centro = centro_p
       And b.codigo = t.bodega
       And b.tipobodega = 'A';
    --
    -- Selecciona los articulos de lotes para toma fisica
    CURSOR c_lotes ( cia_c  varchar2,	bod_c  varchar2,  art_c  varchar2 ) IS
    SELECT f.no_lote, l.exist_prep, l.costo_prep, f.tom_fisic,
           l.ubicacion, l.fecha_vence, f.no_arti,
           l.rowid rowid_lote
      FROM arinlo l, arintflo f
     WHERE f.no_cia    = l.no_cia
       AND f.bodega    = l.bodega
       AND f.no_arti   = l.no_arti
       AND f.no_lote   = l.no_lote
       AND f.no_cia    = cia_c
       AND f.bodega    = bod_c
       AND f.no_arti   = art_c
       AND f.tom_fisic is not null;
    --
    CURSOR c_conteo (cia_p varchar2, bode_p varchar2, arti_p varchar2, fecha_p date) IS
    SELECT max(no_toma)
      FROM arinhtf
     WHERE no_cia  = cia_p
       AND bodega  = bode_p
       AND no_arti = arti_p
       AND fecha   = fecha_p;
    --
    CURSOR c_tercero (cia_p varchar2, tipo_p varchar2) IS
    SELECT codigo_tercero, formulario
      FROM arinvtm
     WHERE no_cia     = cia_p
       AND tipo_m     = tipo_p;

    --
    rmc             c_grupo_contable%rowtype;
    vConteo         arinhtf.no_toma%type;
    v_Formulario_e  arinvtm.formulario%type;
    v_Formulario_s  arinvtm.formulario%type;
    nsiguiente_e    control_formu.siguiente%type;
    nsiguiente_s    control_formu.siguiente%type;
    --

  BEGIN

    vtime_stamp  := SYSDATE;

    IF not INLIB.trae_periodo_proceso(cia_p, centro_p, rpp) THEN
      vMsg_error := 'No fue posible traer datos del periodo en proceso, centro: '||centro_p;
      RAISE error_proceso;
    END IF;

    -- Carga la clase de cambio
    OPEN  c_clase_cambio;
    FETCH c_clase_cambio INTO vcl_cambio;
    CLOSE c_clase_cambio;

    -- Tipo de cambio
    vTipoCambio   := Tipo_Cambio(vcl_cambio, fecha_p, vf_aux, 'C');

    -- obtiene la secuencia para el numero de transaccion
    vno_docu_e := transa_id.inv(cia_p);
    vno_docu_s := transa_id.inv(cia_p);

    IF nvl(vTipoCambio,0) = 0 THEN
      vMsg_error := 'El tipo de cambio es 0 para la fecha: '||to_char(fecha_p,'dd/mm/rrrr');
      RAISE error_proceso;
    END IF;

	  /*-- obtiene los terceros ficticios definidos para el documento de entrada y el de salida.*/
	  OPEN  c_tercero (cia_p, Tipodoc_e_p);
	  FETCH c_tercero INTO vTercero_e, v_Formulario_e;
	  CLOSE c_tercero;
    nsiguiente_e :=  formulario.siguiente(cia_p, v_Formulario_e, null);

	  OPEN  c_tercero (cia_p, Tipodoc_s_p);
	  FETCH c_tercero INTO vTercero_s, v_Formulario_s;
	  CLOSE c_tercero;
    nsiguiente_s :=  formulario.siguiente(cia_p, v_Formulario_s, null);

    -- Inserta Encabezado de documentos
    -- Entrada por ajuste
    Procesar_Encabezado (cia_p, centro_p, tipodoc_e_p, vno_docu_e,
                         nsiguiente_e, null,
                         rpp.ano_proce, fecha_p,
                         'Ajuste de Entrada por Toma Fisica',   vTipoCambio,
                         rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem );

    Procesar_Encabezado (cia_p, centro_p, tipodoc_s_p, vno_docu_s,
                         nsiguiente_s, null,
                         rpp.ano_proce, fecha_p,
                         'Ajuste de Salida por Toma Fisica',   vTipoCambio,
                         rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem );
    --
    --
    FOR aj IN c_lee_ajustes LOOP
      IF rmc.grupo is null or rmc.grupo != aj.grupo_conta THEN
        rmc.grupo := null;
        OPEN  c_grupo_contable(cia_p, aj.grupo_conta);
        FETCH c_grupo_contable INTO rmc;
        CLOSE c_grupo_contable;

        IF rmc.grupo is null THEN
          vMsg_error := 'No existe el grupo contable: '||aj.grupo_conta;
          RAISE error_proceso;
        END IF;
    	END IF;
    	-- Busca los codigos contable para cada articulo traido en el cursor
    	IF not INLIB.trae_cuentas_conta(cia_p, aj.grupo_conta, aj.bode, vrctas) THEN
        vMsg_error := 'Error al traer las cuentas contables, '||
                       'Grupo: '||aj.grupo_conta||' Bodega: '||aj.bode;
        RAISE error_proceso;
    	END IF;

    	vcta_inv      := vrctas.cta_inventario;
    	vcentro_costo := vrctas.centro_costo;

    	IF vcta_inv is null THEN
        vMsg_error := 'No se ha definido cuenta de inventarios para el grupo '||aj.grupo_conta||
                       ' y bodega '||aj.Bode;
        RAISE error_proceso;
    	END IF;

    	IF vcentro_costo is null THEN
        vMsg_error := 'No se ha definido centro de costo para el grupo '||aj.grupo_conta||
                      ' y bodega '||aj.Bode;
        RAISE error_proceso;
    	END IF;
      --
      -- Obtiene la cantidad de conteos realizada para el articulo en la fecha dada
      OPEN  c_conteo(aj.no_cia, aj.bode, aj.arti, fecha_p);
      FETCH c_conteo INTO vconteo;
      CLOSE c_conteo;

      vconteo := nvl(vconteo,0) + 1;
      --
      -- Inserta en el historico de Toma Fisicas.
      INSERT INTO arinhtf (NO_CIA,     NO_TOMA,      BODEGA,   NO_ARTI,
                           FECHA,      TOM_FISIC,    EXIST_PREP )
                   VALUES (aj.no_cia,  vconteo,      aj.bode,  aj.arti,
                           fecha_p,    aj.tom_fisic, aj.exist_prep);
    	--
    	IF aj.indLote = 'N' THEN
    	  --
    	  -- si el articulo NO maneja lotes
        vdifeaux   := nvl(aj.tom_fisic - aj.exist_prep, 0);
        vdife      := abs(vdifeaux);
        vmonto     := moneda.redondeo(nvl(vdife * aj.costo_unit, 0), 'P');
        vmonto_dol := moneda.redondeo(vmonto / vTipoCambio, 'D');
--- se agrega para el costo 2 ANR 07/07/2009
        vmonto2     := moneda.redondeo(nvl(vdife * aj.costo2_unit, 0), 'P');
        vmonto2_dol := moneda.redondeo(vmonto2 / vTipoCambio, 'D');



        IF vdifeaux > 0 THEN
          -- Fisicamente hay MAS
          lin_e       := lin_e + 1;
          me          := me + vmonto;
          me2         := me2 + vmonto2;
          vtdife_un   := vdife;
          vtdife_mon  := vmonto;
          vtdoc       := tipodoc_e_p;
          vno_docu    := vno_docu_e;
          vlin        := lin_e;
          vtmov_inv   := 'D';
          vtmov_aju   := 'C';
        	vcta_aju    := vrctas.cta_ajuste;
        	vTercero_dc := vTercero_e;

        ELSIF vdifeaux < 0 THEN
          -- Fisicamente hay MENOS
          lin_s       := lin_s + 1;
          ms          := ms + vmonto;
          ms2         := ms2 + vmonto2;
          vtdife_un   := -vdife;
          vtdife_mon  := -vmonto;
          vtdoc       := tipodoc_s_p;
          vno_docu    := vno_docu_s;
          vlin        := lin_s;
          vtmov_inv   := 'C';
          vtmov_aju   := 'D';
        	vcta_aju    := vrctas.cta_ajuste_sal;
        	vTercero_dc := vTercero_s;

        ELSE -- no hay diferencias
          vtdife_un  := 0;
          vtdife_mon := 0;
        END IF;

        IF nvl(vdifeaux,0) <> 0 THEN

        	IF vcta_aju is null THEN
            vMsg_error := 'No se ha definido alguna de las cuentas de ajuste para el grupo '||aj.grupo_conta||
                          ' y bodega '||aj.Bode;
            RAISE error_proceso;
    	    END IF;

          --
         /* -- Si existe diferencia, procesa la distribucion contable y las lineas por la diferencia*/
          INinserta_dc(cia_p,      centro_p,       vtdoc,
                       vno_docu,    vtmov_inv,     vcta_inv,
                       vmonto,      vcentro_costo, vmonto_dol,
                       vTipoCambio, vTercero_Dc);
          INinserta_dc(cia_p,     centro_p,        vtdoc,
                       vno_docu,    vtmov_aju,     vcta_aju,
                       vmonto,      vcentro_costo, vmonto_dol,
                       vTipoCambio, vTercero_Dc);
          --
          Procesar_Linea(cia_p,       centro_p,       rpp.ano_proce,    vtdoc,
                         vno_docu,    fecha_p,        vlin,             aj.bode,
                         aj.arti,     vdife,
                         vmonto,      vmonto_dol,
                         aj.costo_unit,    vTipoCambio,
                         vTime_stamp, rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem,
                         vmonto2,
												 vmonto2_dol,
												 aj.costo2_unit);  --- se agrego el monto 2 ANR 07/07/2009
        END IF;
      ELSE -- aj.indlote = L
        --
        -- Si el articulo maneja lotes
        vtdife_un  := 0;
        vtdife_mon := 0;
        ---*******
        FOR j IN c_lotes (cia_p, aj.bode, aj.arti) LOOP
          ---
          vdifeaux   := nvl(nvl(j.tom_fisic, j.exist_prep) - j.exist_prep, 0);
          vdife      := abs( vdifeaux );
          vmonto     := moneda.redondeo(nvl(vdife * aj.costo_unit, 0), 'P');
          vmonto_dol := moneda.redondeo(vmonto / vTipoCambio, 'D');
          vmonto2     := moneda.redondeo(nvl(vdife * aj.costo2_unit, 0), 'P');
          vmonto2_dol := moneda.redondeo(vmonto2 / vTipoCambio, 'D');

          IF vdifeaux > 0 THEN   -- genera movimiento de entrada en lotes
            -- Fisicamente hay MAS
            lin_e       := lin_e + 1;
            me          := me + vmonto;
            me2         := me2 + vmonto2;
            vtdife_un   := vtdife_un + vdife;
            vtdife_mon  := vtdife_mon + vmonto;
            vtdoc       := tipodoc_e_p;
            vno_docu    := vno_docu_e;
            vlin        := lin_e;
            vtmov_inv   := 'D';
            vtmov_aju   := 'C';
        	  vcta_aju    := vrctas.cta_ajuste;
        	  vTercero_dc := vTercero_e;
          ELSIF vdifeaux < 0 THEN
            -- Fisicamente hay MENOS
            lin_s       := lin_s + 1;
            ms          := ms + vmonto;
            ms2         := ms2 + vmonto2;
            vtdife_un   := vtdife_un - vdife;
            vtdife_mon  := vtdife_mon - vmonto;
            vtdoc       := tipodoc_s_p;
            vno_docu    := vno_docu_s;
            vlin        := lin_s;
            vtmov_inv   := 'C';
            vtmov_aju   := 'D';
        	  vcta_aju    := vrctas.cta_ajuste_sal;
        	  vTercero_dc := vTercero_e;
          END IF;
          --
          IF vdife != 0 OR vmonto != 0 THEN
            --
            -- Si hay diferencia, procesa las lineas y lotes y la distribucion contable
        	  IF vcta_aju is null THEN
              vMsg_error := 'No se ha definido alguna de las cuentas de ajuste para el grupo '||aj.grupo_conta||
                            ' y bodega '||aj.Bode;
              RAISE error_proceso;
    	      END IF;

            INinserta_dc(cia_p,       centro_p,      vtdoc,
                         vno_docu,    vtmov_inv,     vcta_inv,
                         vmonto,      vcentro_costo, vmonto_dol,
                         vTipoCambio, vTercero_dc);

           	INinserta_dc(cia_p,     centro_p,        vtdoc,
                         vno_docu,    vtmov_aju,     vcta_aju,
                         vmonto,      vcentro_costo, vmonto_dol,
                         vTipoCambio, vTercero_dc);
           	--
            Procesar_Linea(cia_p,       centro_p,      rpp.ano_proce,    vtdoc,
                           vno_docu,    fecha_p,        vlin,             aj.bode,
                           aj.arti,     vdife,
                           vmonto,      vmonto_dol, j.costo_prep,     vTipoCambio,
                           vTime_stamp, rpp.mes_proce, rpp.semana_proce, rpp.indicador_sem,
                           vmonto2,
												   vmonto2_dol,
												   aj.costo2_unit);  --- se agrego el monto 2 ANR 07/07/2009
            --
           	Procesar_linea_lote(cia_p,   centro_p, vtdoc,       rpp.ano_proce,
                                '0000',  vno_docu, vlin,        j.no_lote,
                                aj.bode,  aj.arti,
                                vdife,   j.ubicacion, j.fecha_vence);
            --
           	-- Se actualiza en ARINLO el saldo de unidades y el monto actual
           	-- luego de efectuar el ajuste fisico teorico para un articulo de una
           	-- bodega.
            --
           	UPDATE arinlo
               SET saldo_unidad = nvl(saldo_unidad,0) + nvl(sign(vdifeaux) * vdife,0) ,
                   saldo_monto  = 0,
                   exist_prep   = null,
                   costo_prep   = null,
                   proceso_toma = 'N'
             WHERE rowid = j.rowid_lote;
             ---
          END IF;

          -- Inserta en el historico de Toma Fisicas por lote
					INSERT INTO arinhtflo (NO_CIA,    NO_TOMA, BODEGA,      NO_ARTI,
					                       NO_LOTE,   FECHA,   TOM_FISIC,   EXIST_PREP )
					               VALUES (aj.no_cia, vconteo, aj.bode,     aj.arti,
					                       j.no_lote, Fecha_p, j.tom_fisic, j.exist_prep);

        END LOOP;  -- c_lotes
        ---*******
        --
        -- Se eliminan de la tabla ARINTFLO, los lotes del articulo al cual se realizo
        -- el proceso de toma fisica, para que en la proxima toma fisica,
        -- dicha tabla este limpia.
        DELETE FROM arintflo
         WHERE no_cia  = aj.no_cia
           AND bodega  = aj.bode
           AND no_arti = aj.arti
           AND no_toma = aj.no_toma;
       	--
    	END IF; -- (aj.indLote = 'N')
      --
    	vtdife_un  := nvl(vtdife_un,0);
    	vtdife_mon := nvl(vtdife_mon,0);
    	--
    	-- Actualiza_Saldos_Articulo
    	UPDATE arinma  --- la toma fisica no debe modificar costos ANR 07/07/2009
         SET exist_prep   = NULL,
             otrs_un      = nvl(otrs_un,0)  + vtdife_un,
           	 costo_prep   = NULL,
           	 proceso_toma = 'N'
       WHERE rowid = aj.rowid_arinma;

/*---  Debe actualizar el monto 2 y el saldo valuado para todas las bodegas ANR 07/07/2009*/

    INCOSTO_ACTUALIZA (aj.no_cia, aj.arti);

    	-- Se elimina el registro de la tabla ARINTF
    	-- para que en la proxima toma fisica, dicha tabla este limpia.
    	DELETE FROM arintf
       WHERE rowid = aj.rowid_arintf;
    	--
    END LOOP;
    --
    -- elimina movimientos que no se registraron
    --
    IF me > 0 THEN

    	UPDATE arinme
         SET mov_tot = me,
             mov_tot2 = me2
     	 WHERE no_cia   = cia_p
     	   AND no_docu  = vno_docu_e;

    	UPDATE arinmeh
         SET mov_tot = me,
             mov_tot2 = me2
     	 WHERE no_cia   = cia_p
     	   AND no_docu  = vno_docu_e;
    ELSE

      DELETE arinme
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_e;

      DELETE arinmeh
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_e;


    END IF;
    --
    IF ms > 0 THEN

      UPDATE arinme
         SET mov_tot  = ms,
             mov_tot2 = ms2
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_s;

      UPDATE arinmeh
         SET mov_tot  = ms,
             mov_tot2 = ms2
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_s;

    ELSE

      DELETE arinme
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_s;

      DELETE arinmeh
       WHERE no_cia   = cia_p
         AND no_docu  = vno_docu_s;

    END IF;
    --
    -- parametros de salida
    --
    tot_e_p     := me;
    tot_s_p     := ms;
    no_docu_e_p := vno_docu_e;
    no_docu_s_p := vno_docu_s;

  EXCEPTION
    WHEN transa_id.error THEN
         genera_error(transa_id.ultimo_error);
    WHEN error_proceso THEN
         genera_error(NVL(vMsg_error, 'ERROR_PROCESO ajuste inventario'));
    WHEN OTHERS THEN
         genera_error(NVL(sqlerrm, 'ERROR no tratado en ajuste_inventario'));
  END; -- Realizar ajuste
  --
  -- Cancelacion de la Toma Fisica
  --

  PROCEDURE cancelacion ( cia_p        varchar2,
                          centro_p     varchar2,
                          bod1_p       varchar2,
                          bod2_p       varchar2,
                          marca_d_p    varchar2,
                          marca_h_p    varchar2,
                          division_d_p varchar2,
                          division_h_p varchar2,
                          subdivision_d_p varchar2,
                          subdivision_h_p varchar2,
                          articulo_d_p varchar2,
                          articulo_h_p varchar2) IS

    -- Este procedimiento se encarga de cancelar los articulos preparados para
    -- la toma fisica, esto es para los articulos dentro del rango
    -- y con PROCESO_TOMA = 'S', pone este indicador en 'N' y deja en nulo
    -- los campos que tienen que ver con el proceso de toma fisica.
    -- y borra los datos almacenados en las tablas: ARINTF y ARINTFLO

    CURSOR c_arti_arintf IS
     SELECT no_cia, bodega, no_arti,  rowid rowid_arintf
        FROM arintf
       WHERE no_cia = cia_p
         AND (bodega between bod1_p AND bod2_p)
         and marca between nvl(marca_d_p,marca) and nvl(marca_h_p,marca)
         and division between nvl(division_d_p,division) and nvl(division_h_p,division)
         and subdivision between nvl(subdivision_d_p,subdivision) and nvl(subdivision_h_p,subdivision)
         and no_arti between nvl(articulo_d_p,no_arti) and nvl(articulo_h_p,no_arti);

    CURSOR c_arti_arintflo (p_cia varchar2, p_bodega varchar2, p_articulo varchar2)IS
      SELECT no_cia, bodega, no_arti,  no_lote, rowid rowid_arintflo
        FROM arintflo
       WHERE no_cia  = p_cia
         AND bodega  = p_bodega
         AND no_arti = p_articulo;

  BEGIN
    If centro_p is null then
       Null;
    End If;

    -- Cancela la toma fisica para los articulos que no tienen lotes asociados
    FOR C IN c_arti_arintf LOOP
      UPDATE arinma
         SET exist_prep   = NULL,
             costo_prep   = NULL,
             proceso_toma = 'N'
       WHERE no_cia    = c.no_cia
         AND bodega    = c.bodega
         AND no_arti   = c.no_arti;

      --
      --Cancela la toma fisica para los articulos que tienen lotes asociados
      FOR l IN c_arti_arintflo (c.no_cia, c.bodega, c.no_arti) LOOP
        UPDATE arinlo
           SET exist_prep = null,
               costo_prep = null,
               proceso_toma = 'N'
         WHERE no_cia    = l.no_cia
           AND bodega    = l.bodega
           AND no_arti   = l.no_arti
           AND no_lote   = l.no_lote;
         --
			   -- Borra los datos de la tabla ARINTFLO
         DELETE FROM ARINTFLO
           WHERE rowid = l.rowid_arintflo;
         --
      END LOOP;
      --
      -- Borra los datos de la tabla ARINTF
      DELETE FROM ARINTF
        WHERE rowid = c.rowid_arintf;
    --
    END LOOP;

  EXCEPTION
     WHEN others THEN
          genera_error(sqlerrm);
  END; -- Cancelacion
  --
END;
/
