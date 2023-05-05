create or replace procedure            FAGENERA_SOLIC_TRANSFERENCIA(p_cia     varchar,
                                                         p_centro  varchar,
                                                         p_factu   varchar,
                                                         msg_error in out varchar2)  is

	CURSOR C_siguiente  is
	  Select (NVL(MAX(NO_SOLICITUD),0)+1) siguiente
      From arinenc_solicitud
     Where no_cia= p_cia;

  Cursor C_dia_proceso  is
    Select dia_proceso
      from arincd
     where no_cia = p_cia
       and centro = p_centro;

  Cursor C_Existe_Detalle  is
     Select 'x'
       from arfaflc l
      Where l.no_cia   = p_cia
        and l.centrod  = p_centro
        and l.no_factu = p_factu
        and l.solicita_transferencia = 'S';


  Cursor C_lineas_transfiere  is
     Select l.no_cia, l.no_arti, ( l.pedido) solicita
       from arfaflc l
      Where l.no_cia   = p_cia
        and l.centrod  = p_centro
        and l.no_factu = p_factu
        and l.solicita_transferencia = 'S';


  Cursor C_emple_division  is
     Select nvl(me.division,'000') division
       from arplme me
      where me.no_cia = p_cia
        and me.no_emple = user;

  Cursor C_bodega_destino  is
     Select codigo
       from arinbo
      Where no_cia = p_cia
        and centro = p_centro
        and tipobodega = 'A'
        and principal = 'S'
        and rownum = 1;

  vn_docu         arinenc_solicitud.no_docu%type;
  vn_solicitud    arinenc_solicitud.no_solicitud%type;
  vd_dia_proceso  arincd.dia_proceso%type;
  vv_division     arplme.division%type;
  vv_codigo       arinbo.codigo%type;
  error_proceso	  exception;
  vv_Existe       varchar2(1);
  vExiste         Boolean;

BEGIN
    --
  	vn_docu := transa_id.inv(p_cia);
    --
		Open  C_siguiente;
		Fetch C_siguiente into vn_solicitud;
		Close C_siguiente;
    --
	  OPEN  C_dia_proceso;
	  FETCH C_dia_proceso into vd_dia_proceso;
	  CLOSE C_dia_proceso;
    --
	  OPEN  C_emple_division;
	  FETCH C_emple_division into vv_division;
	  CLOSE C_emple_division;
    --
	  OPEN  C_bodega_destino;
	  FETCH C_bodega_destino into vv_codigo;
	  CLOSE C_bodega_destino;
    --
    If vv_division = '000'   Then
       msg_error := 'El empleado con codigo '||user ||'no tiene asociado Division';
       raise error_proceso;
    End if;
    --
    Open  C_Existe_Detalle;
    Fetch C_Existe_Detalle  into vv_Existe;
    vExiste := C_Existe_Detalle%found;
    Close C_Existe_Detalle;
    --
    If  vExiste  THEN
        --
        -- INSERCION DE LA CABECERA
        INSERT  INTO arinenc_solicitud (NO_CIA,         NO_DOCU,          NO_SOLICITUD,
                                        FECHA,          NO_DOCU_REFE,     NO_EMPLE,
                                        NO_DIVISION,    BODEGA_ORIGEN,    BODEGA_DESTINO,
                                        ESTADO,         OBSERV1,          CENTRO,
                                        USUARIO,        TIME_STAMP,
                                        ORIGEN)

                                 Select f.no_cia,        vn_docu,                 vn_solicitud,
                                        vd_dia_proceso,  no_factu,                user,
                                        vv_division,     f.bodega_transferencia,  vv_codigo,
                                        'P',             'FA - Solicitud generada por Pedido # '||no_factu,  f.centrod,
                                        user,            sysdate,
                                        'FA'
                                   from arfafec f
                                  Where no_cia    = p_cia
                                    and centrod   = p_centro
                                    and  no_factu = p_factu;


        For linea  in  C_lineas_transfiere  Loop
            --
            INSERT  INTO arindet_solicitud (NO_CIA, NO_DOCU, NO_ARTI, CANTIDAD)

                                     Select l.no_cia, vn_docu, l.no_arti, (l.pedido) solicita   from arfaflc l
                                      Where l.no_cia    = p_cia
                                        and l.centrod   = p_centro
                                        and  l.no_factu = p_factu
                                        and l.solicita_transferencia = 'S';
        End loop;

    Else
        Close C_Existe_Detalle;
        msg_error := 'No existe lineas de articulos a generar.';
        RAISE error_proceso;
  END IF;


EXCEPTION

  WHEN error_proceso then
       msg_error := nvl(msg_error, 'ERROR EN FAGENERA_SOLIC_TRANSFERENCIA');
       return;
  WHEN others then
       msg_error := 'ERROR EN FAGENERA_SOLIC_TRANSFERENCIA'||sqlerrm(sqlcode);
       return;

END FAGENERA_SOLIC_TRANSFERENCIA;