create or replace procedure            INCARGA_INICIAL(P_CIA    VARCHAR2,
                                            P_CENTRO VARCHAR2,
                                            p_error  out VARCHAR2) is

--  Carga de datos de Estructuras en NAF

  Cursor c_SaldoIni is
    SELECT  a.docum, a.fecha, a.bode, a.observacion, a.ind_procesado
    FROM MIGRA_CABEING a
    where no_cia = P_CIA
      and centro = P_CENTRO
      and ind_procesado = 'N'
    order by docum, fecha;

  Cursor C_Detalle (Lv_docum Varchar2) Is
   SELECT cant, costuni, costuni2, codigo
     From MIGRA_SALDOING
    where no_cia=P_CIA
    and docum = Lv_docum
    and cant > 0;

  Cursor C_Articulo (Lv_arti Varchar2) is
   select ind_lote
   from   arinda
   where  no_cia = P_CIA
   and    no_arti = Lv_arti;


  CURSOR c_tipo_doc  IS
       SELECT m.movimi, m.consum,  m.produccion,
              m.compra, m.ventas,  m.interface,
              m.cta_contrapartida, m.cta_contrapartida_dol, m.tipo_m
         FROM arinvtm m
        WHERE m.no_cia    =  p_cia
          and m.interface = 'CD'
          AND m.movimi = 'E';

  lv_error        varchar2(500);
  rtd             c_tipo_doc%ROWTYPE;
  vtime_stamp     date;
  error_proceso   exception;
  cNo_Docu        varchar2(12);

  Ln_contador     Number := 0;

  Lv_lote         Arinda.ind_lote%type;


Begin
  Open  c_tipo_doc;
  Fetch c_tipo_doc into rtd;
  Close c_tipo_doc;

  For i in c_SaldoIni loop

          cNo_Docu := TRANSA_ID.inv(P_CIA);

          INSERT INTO ARINME(NO_CIA,        CENTRO,                TIPO_DOC,
                             PERIODO,        RUTA,                  NO_DOCU,
                             ESTADO,         FECHA,                 IMP_VENTAS,
                             IMP_INCLUIDO,   IMP_ESPECIAL,          DESCUENTO,
                             MOV_TOT,        TIPO_CAMBIO,           MONTO_DIGITADO_COMPRA,
                             MONTO_BIENES,   MONTO_IMPORTAC,        MONTO_SERV,
                             ORIGEN,         OBSERV1,               NO_FISICO)

           VALUES (P_CIA,                                P_CENTRO,       rtd.tipo_m,
                   To_number(To_char(i.FECHA,'YYYY')),   '0000',          cNo_Docu,
                   'P',                                  i.FECHA,         0,
                   0,                                    0,               0,
                   0,                                    1,               0,
                   0,                                    0,               0,
                   'IN',                                 i.observacion,   i.docum);

                   -- los campos de monto quedan en 0 para actualizarlos posterior a la carga del detalle

 For j in C_Detalle (i.docum) Loop

 Ln_contador := Ln_contador + 1;


  Begin


    INSERT INTO ARINML (NO_CIA,      CENTRO,       TIPO_DOC,
                        PERIODO,     RUTA,         NO_DOCU,
                        LINEA,       LINEA_EXT,    BODEGA,
                        NO_ARTI,     UNIDADES,
                        MONTO, TIPO_CAMBIO,  MONTO_DOL,
                        IND_OFERTA,  CENTRO_COSTO, monto2, monto2_dol)
            Values    (P_CIA, P_CENTRO, rtd.tipo_m,
                       To_number(To_char(i.FECHA,'YYYY')), '0000',     cNo_Docu,
                       Ln_contador, Ln_contador,     i.bode,
                       trim(j.codigo),                       j.cant,
                       nvl(j.cant,0)*nvl(j.costuni,0),    1,          nvl(j.cant,0)*nvl(j.costuni,0),
                       'N',                                '000000000', nvl(j.cant,0)*nvl(j.costuni2,0),

nvl(j.cant,0)*nvl(j.costuni2,0));

    EXCEPTION
            WHEN others THEN
                 p_error := 'INCARGA_INICIAL_ARINML : '||sqlerrm;
                 rollback;
                 return;
     End;


    --
    --

    Open C_Articulo (trim(j.codigo));
    Fetch C_Articulo into Lv_lote;
    If C_Articulo%notfound then
      Close C_Articulo;
         p_error := 'Articulo no existe : '||trim(j.codigo);
        RAISE error_proceso;
    else
      Close C_Articulo;
    end if;

    If Lv_lote = 'L' then


    Begin
        Insert into Arinmo (NO_CIA,    CENTRO,      TIPO_DOC,
                            PERIODO,   RUTA,        NO_DOCU,
                            LINEA,     NO_LOTE,     UNIDADES,
                            MONTO,     DESCUENTO_L, IMP_VENTAS_L,
                            UBICACION, FECHA_VENCE)
                 Values    (P_CIA, P_CENTRO, rtd.tipo_m,
                            To_number(To_char(i.FECHA,'YYYY')), '0000',   cNo_Docu,
                            Ln_contador,   'L_INICIA', j.cant,
                            0,     0,           0,
                            null,         sysdate+365);

          EXCEPTION
            WHEN others THEN
                 p_error := 'INCARGA_INICIAL_ARINMO : '||sqlerrm;
                 rollback;
                 return;
     End;

     end if;

    --
    --
    --

    end loop;

    --    Actualizacion de Carga Inicial
    vtime_stamp := SYSDATE;
    CI_INact_produccion(p_cia,        rtd.tipo_m,             cNo_Docu,
                        rtd.movimi,   rtd.cta_contrapartida,  vtime_stamp,  lv_error);
    --

    if lv_error is null then
      Update MIGRA_CABEING
         Set fecha_proceso = sysdate,  ind_procesado = 'S'
       Where  no_cia = P_CIA
         and  centro = P_CENTRO
         and  docum = i.docum;
      commit;
      else
         p_error := 'INCARGA_INICIALES : '||lv_error;
        RAISE error_proceso;
    end if;
    --
  End loop;
  --
EXCEPTION
  WHEN error_proceso THEN
       rollback;
       return;
  WHEN others THEN
       p_error := 'INCARGA_INICIAL : '||sqlerrm;
       rollback;
       return;

End INCARGA_INICIAL;