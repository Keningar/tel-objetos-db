create or replace procedure            cogenerapedido( pcia in  Varchar2,msg_error out varchar2) is



  no_orden_t   tapordee.no_orden%TYPE;
  max_lin      tapcia.max_lin_ord%TYPE;
  no_soli      tapbiene.no_solic%TYPE;
  linea        taporded.no_linea%TYPE;
  linea_tmp    taporded.no_linea%TYPE;
  indnoinv     tapordee.ind_no_inv%TYPE;
  total        tapordee.total%type;
  total_tmp    tapordee.total%type;
  prove        tapordee.no_prove%type;
  dummy        tapordee.total%type;
  cotizacion   tapordee.total%type;
  vReg_prove   proveedor.datos_r;

  numero_orden number;
  --
  CURSOR c_prove IS
     SELECT DISTINCT e.no_prove, e.adjudicador
       FROM tapcotie e, tapcotid d
      WHERE e.no_cia = pcia
        AND e.no_cia   = d.no_cia
        AND e.no_cotiz = d.no_cotiz
   GROUP BY e.no_prove, e.adjudicador;
  --
  CURSOR c_tapcotid IS
    SELECT d.no_cia,     d.no_cotiz,    d.no_linea, d.no_arti,     d.cod_art_prov,  d.cantidad,
           d.medida,     d.descripcion, d.adjudicado,    d.costo_uni

      FROM tapcotid d, tapcotie e
     WHERE d.no_cia = pcia
       AND d.no_cia      = e.no_cia
       AND d.no_cotiz    = e.no_cotiz
       AND e.no_prove    = prove;

  --  Clase cambio
  CURSOR clase is
    SELECT clase_cambio
      FROM tapcia
     WHERE no_cia = pcia;
  --
  vClase        tapcia.clase_cambio%type;
  vFecha_ret    date;
  vTipo_cambio  arcgal.tipo_cambio%type;
  vMoneda_lim    arcpmp.moneda_limite%type;

BEGIN
  -- trae ultima orden de compra emitida y
  -- el maximo numero de lineas por orden de compra
  SELECT max_lin_ord
    INTO max_lin
    FROM tapcia
   WHERE no_cia = pcia;

  --
  -- clase de cambio
  OPEN  clase;
  FETCH clase INTO vClase;
  CLOSE clase;

  FOR prov IN c_prove LOOP

    Prove    := Prov.no_prove;
 ----   indnoinv := Prov.no_inve;
    total    := 0;

    -- Obtiene el siguiente numero de orden de compra
    numero_orden  := consecutivo.co(pcia,
                                     to_number(to_char(sysdate,'MM')),
                                     to_number(to_char(sysdate,'RRRR')),
                                     'ORDEN',
                                     'NUMERO');


    -- Determina el tipo de cambio de la orden segun el proveedor
    vReg_prove := proveedor.trae_datos(pcia,prov.no_prove );
    vMoneda_lim := vReg_prove.moneda_limite;


    IF vMoneda_lim = 'D' THEN
      vTipo_cambio := Tipo_cambio(vClase,sysdate,vFecha_ret,'C');
    ELSE
      vTipo_cambio := 1;
    END IF;

    -- inserta el encabezado de la orden de compra
    INSERT INTO tapordee (no_cia, no_orden, no_prove, fecha, monto,
                          total, estado, adjudicador, ind_no_inv,tipo_cambio,moneda)
                  VALUES (pcia, numero_orden, Prov.no_prove,  sysdate, 0,
                          0, 'P', prov.adjudicador, indnoinv,vTipo_cambio,vMoneda_lim);



    -- pone contador de lineas en 1
    linea := 1;

    -- lee las lineas de la cotizacion
    FOR lin IN c_tapcotid LOOP

      IF nvl(lin.adjudicado,0) > 0 THEN

        -- si existe una linea con la misma cotizacion la actualiza
        UPDATE taporded d
           SET d.cantidad  = d.cantidad + lin.adjudicado
         WHERE d.no_cia    = pcia
           AND d.no_orden  = numero_orden
           AND d.no_arti   = lin.no_arti
           AND upper(d.descripcion) = upper(lin.descripcion)
           AND upper(d.medida)      = upper(lin.medida)
           AND d.cod_art_prov       = lin.cod_art_prov;




        -- si la linea no existia inserta una con el contador de lineas
        -- e icrementa el contador de linea
        IF sql%notfound THEN
          INSERT INTO taporded (no_cia, no_orden, no_linea,   no_arti,
                                descripcion, medida, cod_art_prov, cantidad, costo_uni)
                        VALUES (pcia,numero_orden, linea,
                                lin.no_arti, lin.descripcion, lin.medida, lin.cod_art_prov,
                                lin.adjudicado, lin.costo_uni);

          linea_tmp := linea;

          -- incrementa el numero de linea
          linea := linea + 1;

        -- si la linea existia busca el numero de linea que actualizo
        ELSE

          SELECT d.no_linea
            INTO linea_tmp
            FROM taporded d
           WHERE d.no_cia    = pcia
             AND d.no_orden  = numero_orden
             AND d.no_arti   = lin.no_arti
             AND upper(d.descripcion) = upper(lin.descripcion)
             AND upper(d.medida)      = upper(lin.medida)
             AND d.cod_art_prov       = lin.cod_art_prov;
        END IF;

        -- actualiza la tabla tapsoldoc
        UPDATE tapsoldoc
           SET no_docu    = numero_orden,
               no_linea_d = linea_tmp,
               tipo = 'O'
         WHERE no_cia     = pcia
           AND no_docu    = lin.no_cotiz
           AND no_linea_d = lin.no_linea
           AND tipo       = 'C';


      ELSE

        -- borra las lineas que no fueron adjudicadas de la tabla tapsoldoc
        DELETE tapsoldoc
         WHERE no_cia = pcia
          and  no_docu = lin.no_cotiz
          and  no_linea_d = lin.no_linea
          and  tipo = 'C';

      END IF;

      -- cambia el estado de la solicitud de A a O (Adjudicado - Orden de
      -- Compra)


      IF nvl(lin.adjudicado,0) > 0 THEN


        SELECT no_solic
         INTO no_soli
         FROM tapsoldoc
         WHERE no_cia  = pcia
           AND no_docu = numero_orden
           AND no_linea_d = linea_tmp
           AND tipo       = 'O'
           AND rownum     < 2;

       -- Cambia estado solo si esta como estado 'A' pues si no debe ser 'E' y
        -- no debe modificarlo.

        UPDATE tapbiene
           SET estado   = 'O'
         WHERE no_cia   = pcia
           AND no_solic = no_soli
           AND estado   = 'C' ;


        -- Actualiza historico de fechas.

        BEGIN
          SELECT 0
            INTO dummy
            FROM taphsoli
           WHERE no_cia   = pcia
             AND no_solic = no_soli
             AND estado   = 'O';


        EXCEPTION
        	WHEN no_data_found THEN
               INSERT INTO taphsoli (no_cia, no_solic, estado, fecha_f)
                             VALUES (pcia,no_soli,'O',SYSDATE);
        END;

        -- actualiza el total
        total := total + (NVL(lin.adjudicado,0) * NVL(lin.Costo_Uni,0));

      END IF;

      cotizacion := lin.no_cotiz;



    END LOOP;

    -- actualiza el total del encabezado
    total_tmp  := total;
    no_orden_t := numero_orden;

    UPDATE tapordee e
       SET e.monto = total_tmp,
           e.total = total_tmp
     WHERE e.no_cia = pcia
      AND e.no_orden = no_orden_t;





  --
  -- borra las cotizaciones de la tablas que fueron generadas como ordenes.
 DELETE tapcotid d
   WHERE d.no_cia  = pcia
     AND nvl(d.adjudicado,0) > 0
     AND to_number(d.no_cotiz)= cotizacion;
 -- between to_number(:desde_coti)
  --                                 and to_number(:hasta_coti);

  --
  -- borra encabezados que no tengan detalle.


  DELETE tapcotie e
   WHERE e.no_cia = pcia
     AND to_number(e.no_cotiz)  = cotizacion
     AND e.no_cotiz not in (SELECT distinct no_cotiz
                              FROM tapcotid d
                             WHERE d.no_cia = e.no_cia
                               AND d.no_cotiz = e.no_cotiz);

  DELETE tapsoldoc d
   WHERE d.no_cia = pcia
     AND to_number(d.no_docu) = cotizacion
     AND d.tipo = 'C'
     AND d.no_docu not in (SELECT no_cotiz
                              FROM tapcotie e
                             WHERE e.no_cia = d.no_cia
                               AND e.no_cotiz = d.no_docu);

  END LOOP;

  --proceso_concluido(NULL);

EXCEPTION
  WHEN CONSECUTIVO.error THEN
     msg_error := 'Error al generar consecutivo de pedido : '||msg_error;
     return;
  WHEN OTHERS THEN
     msg_error := 'Error al generar Pedido : '||sqlerrm;
     return;

end;