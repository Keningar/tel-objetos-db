create or replace procedure            FAVENTANILLA_PROCESAR_LOTE (pno_cia          Varchar2,
                                                        pcentro          Varchar2,
                                                        pno_docu         Varchar2,
                                                        pLinea           Varchar2,
                                                        pbodega          Varchar2,
                                                        particulo        Varchar2,
                                                        pcantidad        Number,
                                                        perror           IN OUT Varchar2) IS

  Cursor C_Stock_Lote (c_bodega varchar2, c_articulo varchar2)is
    Select SUM(saldo_unidad)
      from arinlo
      where no_cia = pno_cia
      and bodega   = c_bodega
      and no_arti  = c_articulo
      and nvl(saldo_unidad, 0)  > 0
      and articulo.existencia_lote(no_cia, no_arti, bodega, no_lote) > 0
      and fecha_vence >= trunc(sysdate)
      order by fecha_vence;

  Cursor C_Disponible_Lote (c_bodega varchar2, c_articulo varchar2)is
    Select no_lote,  ubicacion,  fecha_vence, articulo.existencia_lote(no_cia, no_arti, bodega, no_lote) disponible
      from arinlo
      where no_cia = pno_cia
      and bodega   = c_bodega
      and no_arti  = c_articulo
      and nvl(saldo_unidad, 0)  > 0
      and articulo.existencia_lote(no_cia, no_arti, bodega, no_lote) > 0
      and fecha_vence >= trunc(sysdate)
      order by fecha_vence;

  vn_unidades_lotes arinlo.saldo_unidad%type := 0;  -- Cantidad de articulos en lotes disponibles
  v_cantidad         arinmo.unidades%type := 0;  -- Cantidad de articulos por asignar
  vn_Lote            arinmo.no_lote%type  := 0;  -- Numero de lote asociado
  v_unid_asigna      arinmo.unidades%type := 0;  -- Cantidad de articulos asociados a cada lote ARINMO
  v_monto            arinmo.monto%type    := 0;  -- (v_unid_asigna * costo_lote)
  v_ubicacion        arinmo.ubicacion%type   := 0;
  v_fecha            arinmo.fecha_vence%type;
  Error_Proceso     exception;

  BEGIN
    -- Verificar si tengo la misma cantidad de unidades asignadas en cabecera contra unidades en lotes
    Open  C_Stock_Lote(pbodega, particulo);
    Fetch C_Stock_Lote into vn_unidades_lotes;
    Close C_Stock_Lote;

    If nvl(vn_unidades_lotes,0) = 0  then
      RAISE Error_Proceso;
    End if;


    /* Eleccion de lotes a utilizar y preasignacion de acuerdo al saldo existente
     Saldo Disponible(Saldo_real - Pendiente) de articulos de una bodega  */
    v_cantidad := 0;
    v_cantidad := pcantidad;  -- Variable para ir disminuyendo las unidades ya asignadas por lote

    For i in C_Disponible_Lote(pbodega, particulo)  Loop

        -- Verifico cantidad a asignar de acuerdo a lo disponible por lote
        If i.disponible  >=  v_cantidad   Then
          v_unid_asigna := v_cantidad;
          v_cantidad    := nvl(v_cantidad,0) - nvl(v_unid_asigna,0);

        Elsif i.disponible  <  v_cantidad  Then
          v_unid_asigna := i.disponible;
          v_cantidad    := nvl(v_cantidad,0) - nvl(v_unid_asigna,0);
        End if;

        If  nvl(v_unid_asigna,0)  >  0  Then

        BEGIN


             INSERT INTO ARFAFLC_LOTE  (NO_CIA,   CENTROD,    NO_FACTU,
                                        BODEGA,   NO_ARTI,    NO_LINEA,
                                        NO_LOTE,  UNIDADES,   FECHA_VENCE,  UBICACION)

                                VALUES (pno_cia,     pcentro,             pno_docu,
                                        pbodega,     particulo,           pLinea,
                                        i.no_lote,   abs(v_unid_asigna),  i.fecha_vence, i.ubicacion);

            EXCEPTION
               WHEN OTHERS THEN
                   perror := 'Error al crear lote. Trans.: '||pno_docu ||' Articulo: '||particulo||' Linea: '||pLinea||' Lote: '||i.no_lote||' '||SQLERRM;
                   RAISE Error_Proceso;
          END;
        --
        End if;
        --
      End Loop;

EXCEPTION
   WHEN Error_Proceso THEN
      perror := perror;
   WHEN OTHERS THEN
       perror := 'Error al procesar lote '||SQLERRM;

end FAVENTANILLA_PROCESAR_LOTE;