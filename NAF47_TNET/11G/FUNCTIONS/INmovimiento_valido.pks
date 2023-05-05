create or replace FUNCTION            INmovimiento_valido (
    pcia         in varchar2,
    ptipo_doc    in varchar2,
    pno_docu     in varchar2,
    msg_error_p  in out varchar2
) RETURN BOOLEAN
IS
  -- ---
  -- Esta funcion se encarga de revisar que el movimiento especificado por los parametros, sea
  -- valido, es decir, que cumpla las siguientes caracteristicas :
  --  1. En los articulos que manejan lotes, las unidades del articulo sean igual a la
  --         sumatoria de las unidades de los lotes en que se desgloza.
  --  2. El numero de conduce no sea nulo (para despachos y recepciones)
  --
  vdummy    varchar2(2);
  vfound    BOOLEAN;
  --
  CURSOR mov_invalidos IS
     SELECT 'X'
     FROM arinml ML, arinda DA
     WHERE ML.no_cia    = pcia
       AND ML.no_docu   = pno_docu
       AND DA.no_cia    = ML.no_cia
       AND DA.clase     = ML.clase
       AND DA.categoria = ML.categoria
       AND DA.no_arti   = ML.no_arti
       AND DA.ind_lote  = 'L'
       AND ML.unidades <> (SELECT NVL(SUM(unidades), 0)
                           FROM arinmo MO
                           WHERE MO.no_cia   = ML.no_cia   and
                                 MO.no_docu  = ML.no_docu  and
                                 MO.linea    = ML.linea  )
       AND ROWNUM < 2;
BEGIN
  OPEN mov_invalidos;
  FETCH mov_invalidos INTO vdummy;
  vfound := mov_invalidos%found;
  CLOSE mov_invalidos;
  --
  IF vfound then
     msg_error_p := 'El movimiento: '|| ptipo_doc||' No.Transa.'||pno_docu||
                    ', presenta inconsistentes en las unidades de una linea con el total de unidades en el desglose de sus lotes';
     RETURN(FALSE);
  else
     RETURN(TRUE);
  end if;
EXCEPTION
  when others then
    msg_error_p := 'ERROR en Proc. movimiento_valido: '||sqlerrm;
    RETURN (FALSE);
END;