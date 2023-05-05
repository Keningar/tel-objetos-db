create or replace procedure            FACREA_GUIA_REMISION(Pv_cia           IN  Varchar2,
                                                 Pv_factu         IN  Varchar2,
                                                 Pv_Error         OUT Varchar2) is

    Cursor C_Bodega Is
     select b.centrod, a.bodega, b.fecha, b.tipo_doc, b.grupo, b.no_cliente, b.subcliente
     from   arfafl a, arfafe b
     where  a.no_cia    = Pv_cia
     and    a.no_factu  = Pv_factu
     and    a.no_cia    = b.no_cia
     and    a.no_factu  = b.no_factu;

    Cursor C_Guia_Remision Is
     Select 'X'
     From   arinencremision
     Where  no_cia = Pv_cia
     and    no_docu_refe = Pv_factu;

    Cursor C_Cliente (Lv_grupo Varchar2, Lv_cliente Varchar2) Is
     Select nombre, cedula
     From   Arccmc
     Where  no_cia = Pv_cia
     And    grupo  = Lv_grupo
     And    no_cliente = Lv_cliente;

    Cursor C_SubCliente (Lv_grupo Varchar2, Lv_cliente Varchar2, Lv_subcliente Varchar2) Is
     Select direccion
     From   Arcclocales_clientes
     Where  no_cia = Pv_cia
     And    grupo  = Lv_grupo
     And    no_cliente = Lv_cliente
     And    no_sub_cliente = Lv_subcliente;

    Cursor C_Transportista Is
      select b.cedula
      from   arintransporte a, arcpmp b
      where  a.no_cia   = Pv_Cia
      and    a.no_cia   = b.no_cia
      and    a.no_prove = b.no_prove;

    Cursor C_Datos_Pedido Is
    select *
      from arfafec
     where no_cia = Pv_cia and no_factu in
    (select no_pedido from arfafe where no_cia = Pv_cia and no_factu = Pv_factu);

    Cursor C_Empleado (Lv_centro Varchar2, Lv_ruta_despacho Varchar2) Is
     select a.no_emple, b.cedula
     from   arfa_rutas_despacho a, arplme b
     where  a.no_cia   = Pv_cia
     and    a.centro   = Lv_centro
     and    a.cod_ruta = Lv_ruta_despacho
     and    a.no_cia   = b.no_cia
     and    a.no_emple = b.no_emple;

     --
     --
     Ped                        Arfafec%rowtype;
     --
     --
     Lv_nombre_cliente          Arccmc.nombre%type;
     Lv_cedula_cliente          Arccmc.cedula%type;
     Lv_direccion_subcliente    Arcclocales_clientes.direccion%type;
     Lv_cedula_transportista    Arcpmp.cedula%type;
     Ld_fecha_entrega           date;
     Ld_fecha_pedido            date;
     Lv_dummy                   Varchar2(1);
     Lv_codigo_transportista    Varchar2(6);
     Lv_bodega                  Arinbo.codigo%type;
     Ld_fecha_factura           Arfafe.fecha%type;
     Lv_tipo_doc                Arfafe.tipo_doc%type;
     Lv_grupo                   Arfafe.grupo%type;
     Lv_cliente                 Arfafe.no_cliente%type;
     Lv_subcliente              Arfafe.subcliente%type;
     Lv_centro                  Arfafe.centrod%type;

     vmsg_Error                 Varchar2(500);
     Error_proceso              Exception;

BEGIN

    Open c_datos_pedido; --- Se asignan los datos del pedido
    Fetch c_datos_pedido into Ped;
    Close c_datos_pedido;

  --- Para el registro del transporte, deben guardarse estos datos
  --- Actualiza valores para la guia ANR 07/10/2009

    Open C_Bodega;
    Fetch C_Bodega into Lv_centro, Lv_Bodega, Ld_fecha_factura, Lv_tipo_doc, Lv_grupo, Lv_cliente, Lv_subcliente;
    If C_Bodega%notfound Then
      Close C_Bodega;
       vmsg_Error := 'No existe detalle del documento: '||Pv_factu;
       raise Error_Proceso;
    else
      Close C_Bodega;
    end if;

    Open  C_Guia_Remision;
    Fetch C_Guia_Remision into Lv_dummy;
    If C_Guia_Remision%notfound Then
      Close C_Guia_Remision;

                          Inreplica_guias(Pv_factu,
                                          Lv_tipo_doc,
                                          Pv_cia,
                                          Lv_centro,
                                          'FA',--- Interfaz de tipo de documento de facturacion
                                          null,
                                          vmsg_Error);

                        If vmsg_Error is not null Then
                         raise Error_proceso;
                        end if;

      else

        Close C_Guia_Remision;

      end if;

                 --- Datos del cliente

                Open C_Cliente (Lv_grupo, Lv_cliente);
                Fetch C_Cliente into Lv_nombre_cliente, Lv_cedula_cliente;
                If C_Cliente%notfound Then
                  Close C_Cliente;
                else
                  Close C_Cliente;
                end if;

                --- Datos del subcliente

                Open C_SubCliente (Lv_grupo, Lv_cliente, Lv_subcliente);
                Fetch C_SubCliente into Lv_direccion_subcliente;
                If C_SubCliente%notfound Then
                  Close C_SubCliente;
                else
                  Close C_SubCliente;
                end if;

            ---a.  Plazo de entrega: debe calcular 10 dias despues de la fecha del pedido
            ---b.  Punto de Llegada: Segun el Local ingresado en el pedido debe traer la direccion asociada.
              Ld_fecha_entrega := Ld_fecha_pedido + 10;

              --- Para el caso de que la fecha de entrega sea menor a la fecha de la factura
              If Ld_fecha_entrega < Ld_fecha_factura Then
               Ld_fecha_entrega := Ld_fecha_factura;
              end if;

						---- Recupera por medio de la ruta interna los datos del empleado, si no encuentra, recupera los datos del transportista ANR 07/10/2009

							If Ped.ruta_despacho is not null and Ped.tipo_despacho != 'M' Then

									Open  C_Empleado (Lv_centro, Ped.ruta_despacho);
									Fetch C_Empleado into Lv_codigo_transportista, Lv_cedula_transportista;
									If C_Empleado%notfound Then
									 Close C_Empleado;
									 Lv_codigo_transportista := null;
									 Lv_cedula_transportista := null;
									else
									 Close C_Empleado;
									end if;

							elsif Ped.ruta_despacho is null and Ped.tipo_despacho != 'M'  Then

								Lv_codigo_transportista := Ped.codigo_transportista;

								Open C_Transportista;
								Fetch C_Transportista into Lv_cedula_transportista;
									If C_Transportista%notfound Then
									 Close C_Transportista;
									 Lv_cedula_transportista := null;
									else
									 Close C_Transportista;
									end if;

							elsif Ped.tipo_despacho = 'M' Then	 --- si el retiro es por ventanilla o mostrador, muestra datos que se ingresaron en el pedido ANR 29/10/2009

									Lv_codigo_transportista := null;
									Lv_cedula_transportista := Ped.tdv_cedula;

							end if;

                  Update Arinencremision
                  Set    guia_factura           = 'S', --- Marco si es de tipo factura
                         bodega_origen          = Lv_Bodega,
                         bodega_destino         = null,
                         motivo_traslado        = 'V',
                         fecha_llegada          = Ld_fecha_entrega,
                         codigo_transportista   = Lv_codigo_transportista,
                         codigo_destinatario    = Lv_cliente,
                         direccion_destinatario = Lv_direccion_subcliente,
                         bloque                 = null,
                         nombre_destinatario    = Lv_nombre_cliente,
                         ced_destinatario       = Lv_cedula_cliente,
                         ced_transportista      = Lv_cedula_transportista,
                         punto_entrega          = null,
                         nombre_comercial       = Lv_nombre_cliente,
                         observacion            = null
                  Where  no_cia                 = Pv_cia
                  And    no_docu_refe           = Pv_factu;

EXCEPTION
  WHEN error_proceso THEN
       Pv_Error := vmsg_error;
  WHEN OTHERS THEN
       Pv_Error := 'Error al crear guia de remision: '||sqlerrm;
end FACREA_GUIA_REMISION;