create or replace PROCEDURE            CGPaso (
  pCia        in arcgae.no_Cia%type,
  pcod_diario in arcgae.cod_diario%type,
  pfecha      in arcgae.fecha%type,
  pmsg_error  in out varchar2
) IS
  --Cabecera temporal para paso de diarios
  CURSOR CABECERA IS  SELECT * FROM MIGRA_ARCGAE WHERE no_cia = pCia
            AND LTRIM(RTRIM(cod_diario)) = NVL(LTRIM(RTRIM(pcod_diario)),LTRIM(RTRIM(cod_diario)))
            AND transferido = 'N'
            AND fecha = NVL(pfecha,fecha);


  --Detalle temporal para paso de diarios
  CURSOR DETALLE (C_ASIENTO VARCHAR2) IS
         SELECT * FROM MIGRA_ARCGAL WHERE no_cia  = pCia  AND no_asiento = C_ASIENTO
          AND transferido = 'N' ;

  vno_asiento     MIGRA_arcgae.no_asiento%type;   --Variable para secuencia de vno_asiento
  monto           MIGRA_arcgal.monto%type;        --Acopla

BEGIN
  FOR C IN CABECERA  LOOP

   --Genera el numero de la transaccion por compa?ia

   vno_asiento := TRANSA_ID.CG(pCia);
   --
   INSERT into ARCGAE (no_cia,           ano,            mes,
                       no_asiento,       impreso,        fecha,
                       descri1,          estado,         autorizado,
                       origen,           t_debitos,      t_creditos,
                       cod_diario,       t_camb_c_v,     tipo_cambio,
                       tipo_comprobante, no_comprobante, anulado,
                       Usuario_Creacion)
         VALUES (c.no_cia,          c.ano,          c.mes,
                vno_asiento,       'N',            c.fecha,
                c.descri1,         'P',            'N',
                c.origen,          c.t_debitos,    c.t_creditos,
                RTRIM(LTRIM(c.cod_diario)),      c.t_camb_c_v,   c.tipo_cambio,
                c.tipo_comprobante, 0,              'N',
                USER);

    --
     FOR  D IN DETALLE(C.NO_ASIENTO) LOOP
           IF D.TIPO = 'C'  THEN
              MONTO := D.MONTO*-1;
           ELSE
              MONTO := D.MONTO;
           END IF;
   --
   -- crea lineas del nuevo asiento
           INSERT into ARCGAL(no_cia,       ano,       mes,           no_asiento,
                              no_linea,     descri,    cuenta,        no_docu,
                              cod_diario,   moneda,    tipo_cambio,   fecha,
                              monto,        cc_1,      cc_2,          cc_3,
                              centro_costo, tipo,      monto_dol,     codigo_tercero,
                              linea_ajuste_precision)
                       VALUES (D.no_cia,       D.ano,    D.mes,         vno_asiento,
                               D.no_linea,     D.descri, rtrim(ltrim(D.cuenta)), D.no_docu,
                               RTRIM(LTRIM(D.cod_diario)),   D.moneda, D.tipo_cambio, D.fecha,
                               monto, D.cc_1,   D.cc_2,        D.cc_3,
                               D.centro_costo, D.tipo,
                               monto, RTRIM(LTRIM(D.codigo_tercero)),
                               D.linea_ajuste_precision);

   END LOOP;
  END LOOP;

--

EXCEPTION
  WHEN transa_id.error THEN
     pmsg_error := nvl(transa_id.ultimo_error,'Copia_asiento: Error por transa_id');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm,'copia_asiento: Error desconocido');

end CGPASO;