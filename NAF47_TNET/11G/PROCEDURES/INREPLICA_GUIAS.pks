CREATE OR REPLACE Procedure NAF47_TNET.INREPLICA_GUIAS(pv_no_docu      in varchar2,
                                            pv_tipo_doc     in varchar2,
                                            pv_no_cia       in varchar2,
                                            pv_centro       in varchar2,
                                            pv_interfaz     in varchar2,
                                            pv_observacion  in varchar2,
                                            pv_error       out varchar2) Is

/*
FEM 03-02-2009 Se modifica el procedimiento para poder agregar el nuevo parametro de interfaz para segun eso
llenar en la tabla de guia de remision los datos solicitados.

FEM 07-05-2009 Se modifica, el procedimiento para que grabe la cedula y el destinatario nuevos del campo arincd
*/

/*
  * Documentaci�n para INREPLICA_GUIAS
  * Se modifica insert a tabla ARINDETREMISION ya que no se declaran campos en el into
  * y se agregaron campos a la tabla por lo que daba error en compilaci�n
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.1 10/07/2019
*/
Cursor c_noLineas Is
  Select s.lineas_guia_remi
     from arinmc s
     where s.no_cia = pv_no_cia;

Cursor c_fecha_proceso Is
 Select d.dia_proceso,d.mes_proce,d.ano_proce
    From arincd d
    Where d.no_cia = pv_no_cia
      And d.centro = pv_centro;

Cursor c_arinme(cv_no_cia     varchar2,
                cv_tipo_doc   varchar2,
                cv_no_docu    varchar2) Is
Select *
  From arinme s
 where s.no_cia = cv_no_cia
   and s.tipo_doc = cv_tipo_doc
   and s.no_docu  = cv_no_docu;

Cursor c_arinme_count(cv_no_cia       varchar2,
                      cv_tipo_doc     varchar2,
                      cv_no_docu      varchar2) Is
Select count(*)
  From arinme s
 Where s.no_cia = cv_no_cia
   And s.tipo_doc = cv_tipo_doc
   And s.no_docu  = cv_no_docu;

cursor c_arinml(cv_no_cia     varchar2,
                cv_no_docu    varchar2) Is
Select *
  From arinml d
 where d.no_cia = cv_no_cia
   and d.no_docu = cv_no_docu;

Cursor C_consignacion (Pv_cia  in varchar2,
                       Pv_cen  in varchar2,
                       Pv_doc  in varchar2) Is
Select *
  From arinencconsignacli
 Where no_cia = Pv_cia
   And centro = Pv_cen
   and no_docu_ref = Pv_doc;

Cursor C_arinvtm (Pv_cia  in varchar2,
                  Pv_int  in varchar2) Is
Select 'X'
  From arinvtm
 Where no_cia    = Pv_cia
   and interface = Pv_int;

Cursor C_cliente (Pv_cia  in varchar2,
                  Pv_cli  in varchar2) Is
Select *
  From arccmc
 where no_cia   = Pv_cia
   and grupo    = grupo
   and no_cliente = Pv_cli;

Cursor C_vendedor (Pv_cia  in varchar2,
                   Pv_cod  in varchar2) Is
Select b.nombre, b.cedula
   from arintb a, arplme b
   Where b.no_cia = a.no_cia
     and b.no_emple = a.codigo
     and a.no_cia = Pv_cia
     and a.codigo = Pv_cod
     and b.estado = 'A';

Cursor c_arinme_canje(cv_no_cia   in varchar2,
                      cv_cen      in varchar2,
                      cv_no_docu  in varchar2) Is
Select *
   From arinme
   where no_cia   = cv_no_cia
     and centro   = cv_cen
     and tipo_doc = 'IC'
     and n_docu_d = cv_no_docu;

Cursor C_obsequios (Cv_cia in varchar2,
                    Cv_cen in varchar2,
                    Cv_doc in varchar2) Is
Select *
   from arinencobsdon
   where no_cia  = Cv_cia
     and centro  = Cv_cen
     and no_docu = Cv_doc;

Cursor C_consumointer (Cv_cia  in varchar2,
                       Cv_doc  in varchar2) Is
Select *
   From arinencconsumointer
   where no_cia = Cv_cia
     and no_docu_refe = Cv_doc;


Cursor C_tran2 (Cv_cia in varchar2,
                Cv_cen in varchar2,
                Cv_doc in varchar2) Is
Select bod_dest, no_docu_ref_transito, transito
   From arinte
   where no_cia = Cv_cia
     and centro = Cv_cen
     and no_docu = cv_doc;

Cursor C_tran3 (Cv_cia in varchar2,
                Cv_cen in varchar2,
                Cv_doc in varchar2) Is
Select bod_dest
   From arinte
   where no_cia = Cv_cia
     and centro = Cv_cen
     and no_docu = cv_doc;

Cursor C_direccion (cv_cia  in varchar2,
                    cv_bod  in varchar2) Is
Select direccion, ruc
   From arincd
   Where no_cia = cv_cia
     And centro in (Select centro
                       From arinbo
                       Where no_cia = cv_cia
                         And codigo = cv_bod);

Cursor C_compania (cv_cia  in varchar2) Is
 Select nombre
    from arinmc
    where no_cia = cv_cia;

Cursor C_bodega (Cv_cia in varchar2,
                 Cv_bod in varchar2) Is
 select descripcion
    from arinbo
    where no_cia = Cv_cia
      and codigo = Cv_bod;

--- Para los documentos que provienen del modulo de facturacion ANR 03/08/2009

Cursor c_arfafe(cv_no_cia     varchar2,
                cv_tipo_doc   varchar2,
                cv_no_factu   varchar2) Is
Select *
  From arfafe s
 where s.no_cia = cv_no_cia
   and s.tipo_doc = cv_tipo_doc
   and s.no_factu  = cv_no_factu;

cursor c_arfafl(cv_no_cia     varchar2,
                cv_no_factu    varchar2) Is
Select *
  From arfafl d
 where d.no_cia = cv_no_cia
   and d.no_factu = cv_no_factu;

Cursor c_arfafe_count(cv_no_cia       varchar2,
                      cv_tipo_doc     varchar2,
                      cv_no_factu      varchar2) Is
Select count(*)
  From arfafe s
 Where s.no_cia = cv_no_cia
   And s.tipo_doc = cv_tipo_doc
   And s.no_factu  = cv_no_factu;

Cursor c_tipo_consig  (cv_no_cia       varchar2,
                      cv_tipo_doc     varchar2) Is
SELECT 'X'
  FROM ARFACT
 WHERE NO_CIA = cv_no_cia
   AND IND_CONSIGNACION = 'S'
   AND TIPO = cv_tipo_doc;

Cursor c_datos_consig (cv_no_cia       varchar2,
                      cv_no_factu     varchar2) Is
Select c.no_cliente, c.nombre_comercial, c.cedula, c.direccion, c.nombre_comercial
  from arfafe f, arccmc c
 Where f.no_cia = cv_no_cia
   and f.no_cia = c.no_cia
   and f.no_factu = cv_no_factu
   and f.grupo = c.grupo
   and f.no_cliente = c.no_cliente;


lv_no_docu                Varchar2(12);
lr_fecha_proceso          c_fecha_proceso%rowtype;
ln_no_lineas              Number;
ln_cont                   Number:=1;
lb_ban                    Boolean:=true;
le_mierror                Exception;
lv_error                  Varchar2(200);
ln_lineas                 Number;
lv_observacion            Varchar2(200);
Lb_Found                  Boolean;
Lb_Found_tipo             Boolean;
Lv_existe                 Varchar2(1):=null;
Lv_existe_tipo            Varchar2(1):=null;
Lc_consig                 C_consignacion%rowtype;
Lc_cliente                C_cliente%rowtype;
Lv_bod_destino            varchar2(5):=null;
Lv_motivo_tras            varchar2(1):=null;
Lv_pers_consig            varchar2(30):=null;
Lc_vendedor               C_vendedor%rowtype;
Lv_cod_destinatario       varchar2(10):=null;
Lv_destinatario           varchar2(100):=null;
Lv_cedula                 varchar2(15):=null;
Lc_c_arinme_canje         c_arinme_canje%rowtype;
Lc_obsequio               C_obsequios%rowtype;
Lv_direccion              varchar2(200):=null;
Lc_Consumo                C_consumointer%rowtype;
Lv_trans2                 arinte.no_docu_ref_transito%type;
Lv_trans3                 arinte.bod_dest%type;
Lv_bod_dest               arinte.bod_dest%type;
Lv_trans                  arinte.transito%type;
Lv_nombre_comercial       arinencremision.nombre_comercial%type:=null;


Begin
  -- Seccion de validacion de parametros.
  If pv_no_docu is null then
    Lv_error := 'El Documento no puede ser enviado nulo';
    Raise le_mierror;
  End If;
  ---
  If pv_tipo_doc is null then
    Lv_error := 'No existe tipo de Documento para procesar';
    Raise le_mierror;
  End If;
  ---
  If pv_no_cia is null then
    Lv_error := 'El codigo de la compa?ia no puede ser nulo';
    Raise le_mierror;
  End If;
  ---
  If pv_centro is null then
    Lv_error := 'No puede ser nulo el codigo del centro';
    Raise le_mierror;
  End If;
  ---
  If pv_interfaz is null then
    Lv_error := 'El codigo de la interfaz no puede ser nulo';
    Raise le_mierror;
  End If;
  ---
  Open C_arinvtm(pv_no_cia, pv_interfaz);
  Fetch C_arinvtm into Lv_existe;
  Lb_Found := C_arinvtm%found;
  Close C_arinvtm;
  ---
  If not Lb_Found then
   Lv_error := 'El codigo de la interfaz '||pv_interfaz||' enviado no existe, favor verificar';
   Raise le_mierror;
  End If;
  ---
  If pv_interfaz in ('CS','CE') then
     ---Para el caso que entre por una consignacion
     Open C_consignacion(pv_no_cia, pv_centro, pv_no_docu);
     Fetch C_consignacion into Lc_consig;
     Close C_consignacion;
     ---
     Lv_bod_destino  := Lc_consig.Bodega_Destino;
     Lv_motivo_tras  := 'C';
     Lv_pers_consig  := Lc_consig.No_Cliente_Vend;
     ---
     If Lc_consig.Tipo_Consigncliente = 'C' then
       ---
       Open C_cliente(pv_no_cia, Lv_pers_consig);
       Fetch C_cliente into Lc_cliente;
       Close C_cliente;
       ---
     Else
       ---
       Open C_vendedor(pv_no_cia, Lv_pers_consig);
       Fetch C_vendedor into Lc_vendedor;
       Close C_vendedor;
       ---
     End If;
     ---
     Lv_cod_destinatario := Lv_pers_consig;
     Lv_destinatario     := nvl(Lc_cliente.Nombre,Lc_vendedor.Nombre);
     Lv_cedula           := nvl(Lc_cliente.Cedula,Lc_vendedor.Cedula);
     ---
  elsif pv_interfaz in ('CJ') then
     ---Para que entre en el caso de que sea un canje
     Open c_arinme_canje(pv_no_cia,pv_centro,pv_no_docu);
     Fetch c_arinme_canje into Lc_c_arinme_canje;
     Close c_arinme_canje;
     ---
     Lv_motivo_tras      := 'V';
     Lv_bod_destino      := Lc_c_arinme_canje.bodega_local;
     Lv_cod_destinatario := Lc_c_arinme_canje.no_cliente;
     ---
     Open C_cliente(pv_no_cia, Lv_cod_destinatario);
     Fetch C_cliente into Lc_cliente;
     Close C_cliente;
     ---
     Lv_destinatario     := nvl(Lc_cliente.Nombre,Lc_vendedor.Nombre);
     Lv_cedula           := nvl(Lc_cliente.Cedula,Lc_vendedor.Cedula);
     ---
  elsif pv_interfaz in ('OD') then
     ---Para el caso de los obsequios y/o donaciones.
     Open C_obsequios(pv_no_cia, pv_centro, pv_no_docu);
     Fetch C_obsequios into Lc_obsequio;
     Close C_obsequios;
     ---
     Open C_cliente(pv_no_cia, Lc_obsequio.Cod_Cliente);
     Fetch C_cliente into Lc_cliente;
     Close C_cliente;
     ---
     Lv_motivo_tras      := 'O';
     Lv_cod_destinatario := Lc_obsequio.Cod_Cliente;
     Lv_destinatario     := nvl(Lc_obsequio.Beneficiario,Lc_cliente.Nombre);
     Lv_cedula           := nvl(Lc_obsequio.Cedula,Lc_cliente.Cedula);
     Lv_direccion        := Lc_obsequio.Direccion;
     ---
  elsif pv_interfaz in ('CF') then
     --- Para el caso de que venga por consumo interno...
     Open C_consumointer(pv_no_cia,pv_no_docu);
     Fetch C_consumointer into Lc_consumo;
     Close C_consumointer;
     ---
     Lv_pers_consig:= Lc_consumo.Emple_Solic;
     ---
     Open C_vendedor(pv_no_cia, Lv_pers_consig);
     Fetch C_vendedor into Lc_vendedor;
     Close C_vendedor;
     ---
     Lv_motivo_tras      := 'E';
     Lv_cod_destinatario := Lc_consumo.Emple_Solic;
     Lv_destinatario     := Lc_vendedor.Nombre;
     Lv_cedula           := Lc_vendedor.Cedula;
     ---
  Elsif pv_interfaz in ('BO') then
      --Para cuando venga por transferencia.
      Open C_tran2(pv_no_cia, pv_centro, pv_no_docu);
      Fetch C_tran2 into Lv_bod_dest, Lv_trans2, Lv_trans;
      Close C_tran2;

      --Se agrega para poder tomar la direccion de la misma bodega.
      Open C_direccion(pv_no_cia, Lv_bod_dest);
      Fetch C_direccion into Lv_direccion, Lv_cedula;
      Close C_direccion;

      Open C_compania(pv_no_cia);
      Fetch C_compania into Lv_destinatario;
      Close C_compania;

      Open C_bodega(pv_no_cia, Lv_bod_dest);
      Fetch C_bodega into Lv_nombre_comercial;
      Close C_bodega;
      ---
      If nvl(Lv_trans,'N') = 'S' then
         Open C_tran3(pv_no_cia, pv_centro, pv_no_docu);
         Fetch C_tran3 into Lv_trans3;
         Close C_tran3;
         Lv_bod_destino:= Lv_trans3;
      else
         Lv_bod_destino:= Lv_bod_dest;
      End if;
      ---
      Lv_motivo_tras:= 'E';
      ---
  --- Para los documentos que vienen de facturacion ANR 03/08/2009

  Elsif pv_interfaz = 'FA' Then

    Lv_motivo_tras      := null;
    Lv_bod_destino      := null;
    Lv_cod_destinatario := null;
    Lv_destinatario     := null;
    Lv_cedula           := null;
    Lv_direccion        := null;
    Lv_nombre_comercial := null;

  ---
  lv_observacion :='No. Doc: '||pv_no_docu ||' - '||' Tipo Doc: '||pv_tipo_doc||' - '||' Centro: '||pv_centro||' - ';
  lv_observacion := SUBSTR(lv_observacion || pv_observacion,1,200);
  ---

  End If;

  If pv_interfaz != 'FA' Then ---- Para los documentos que no provienen de facturacion ANR 03/08/2009
  ---
  Open c_arinme_count(pv_no_cia,pv_tipo_doc,pv_no_docu);
  Fetch c_arinme_count into ln_lineas;
  Close c_arinme_count;
  ---
  If ln_lineas = 0 Then
   lv_error := 'No existen registros que procesar';
   Raise le_mierror;
  End If;
  ---
  Open c_noLineas;
  Fetch c_noLineas into ln_no_lineas;
  Close c_noLineas;
  ---
  open c_fecha_proceso;
  fetch c_fecha_proceso into lr_fecha_proceso;
  close c_fecha_proceso;
  ---
  lv_observacion :='No. Doc: '||pv_no_docu ||' - '||' Tipo Doc: '||pv_tipo_doc||' - '||' Centro: '||pv_centro||' - ';
  lv_observacion := SUBSTR(lv_observacion || pv_observacion,1,200);
  ---
  For i in c_arinme(pv_no_cia,pv_tipo_doc,pv_no_docu) Loop
      ---
      For j in c_arinml(i.no_cia,i.no_docu) Loop
           If lb_ban Then
              ---
              lv_no_docu := Transa_Id.Inv(i.no_cia);
              ---
              Insert into arinencremision(no_cia,               centro,
                                          no_transa,            fecha_registro,
                                          guia_factura,         estado,
                                          no_docu_refe,         impreso,
                                          bodega_origen,        fecha_llegada,
                                          observacion,          TSTAMP,
                                          motivo_traslado,      bodega_destino,
                                          codigo_destinatario,  nombre_destinatario,
                                          ced_destinatario,     direccion_destinatario,
                                          nombre_comercial)
                                   values(i.no_cia,             pv_centro,
                                          lv_no_docu,           lr_fecha_proceso.dia_proceso,
                                          'N',                  'P',
                                          pv_no_docu,           'N',
                                          j.bodega,             lr_fecha_proceso.dia_proceso + 10,
                                          lv_observacion,       sysdate,
                                          Lv_motivo_tras,       Lv_bod_destino,
                                          Lv_cod_destinatario,  Lv_destinatario,
                                          Lv_cedula,            substr(Lv_direccion,1,200),
                                          Lv_nombre_comercial);
              ---
              ln_cont := 1;
              lb_ban  := False;
              ---
           End If;
           ---
           Insert Into arindetremision (
             NO_CIA,
             NO_TRANSA,
             ANIO,
             MES,
             NO_LINEA,
             NO_ARTI,
             CANTIDAD
           )
           
           values(
             j.no_cia,
             lv_no_docu,
             lr_fecha_proceso.ano_proce,
             lr_fecha_proceso.mes_proce,
             ln_cont,
             j.no_arti,
             j.unidades
            );
           ln_cont:=ln_cont + 1;
           If ln_cont > ln_no_lineas Then
             lb_ban := true;
           End if;
      End Loop;
  End Loop;

  else ---- para los documentos que provienen de facturacion ANR 03/08/2009

  ---
  Open  c_tipo_consig(pv_no_cia,pv_tipo_doc);
  Fetch c_tipo_consig into Lv_existe_tipo;
  Lb_Found_tipo := c_tipo_consig%found;
  Close c_tipo_consig;
  ---
  -- La factura que se ingresa
  If  Lb_Found_tipo   and  pv_interfaz = 'FA'  then

    Open  c_datos_consig (pv_no_cia, pv_no_docu);
    Fetch c_datos_consig into Lv_cod_destinatario, Lv_destinatario, Lv_cedula, Lv_direccion,Lv_nombre_comercial;
    Close c_datos_consig;

  End If;
  ---
  ---
  Open c_arfafe_count(pv_no_cia,pv_tipo_doc,pv_no_docu);
  Fetch c_arfafe_count into ln_lineas;
  Close c_arfafe_count;
  ---
  If ln_lineas = 0 Then
   lv_error := 'No existen registros que procesar';
   Raise le_mierror;
  End If;
  ---
  Open c_noLineas;
  Fetch c_noLineas into ln_no_lineas;
  Close c_noLineas;
  ---
  open c_fecha_proceso;
  fetch c_fecha_proceso into lr_fecha_proceso;
  close c_fecha_proceso;

  For i in c_arfafe(pv_no_cia,pv_tipo_doc,pv_no_docu) Loop
      ---
      For j in c_arfafl(i.no_cia,i.no_factu) Loop
           If lb_ban Then
              ---
              lv_no_docu := Transa_Id.Inv(i.no_cia);
              ---
              ---- Todos los datos relacionados a la guia de remision se llenan en la pantalla FFA40_43 ANR 19/08/2009

              Insert into arinencremision(no_cia,               centro,
                                          no_transa,            fecha_registro,
                                          guia_factura,         estado,
                                          no_docu_refe,         impreso,
                                          bodega_origen,        fecha_llegada,
                                          observacion,          TSTAMP,
                                          motivo_traslado,      bodega_destino,
                                          codigo_destinatario,  nombre_destinatario,
                                          ced_destinatario,     direccion_destinatario,
                                          nombre_comercial)
                                   values(i.no_cia,             pv_centro,
                                          lv_no_docu,           lr_fecha_proceso.dia_proceso,
                                          'S',                  'P',
                                          pv_no_docu,           'N',
                                          j.bodega,             lr_fecha_proceso.dia_proceso + 10, --- para que se actualice fecha de llegada
                                          lv_observacion,       sysdate,
                                          Lv_motivo_tras,       Lv_bod_destino,
                                          Lv_cod_destinatario,  Lv_destinatario,
                                          Lv_cedula,            substr(Lv_direccion,1,200),
                                          Lv_nombre_comercial);
              ---
              ln_cont := 1;
              lb_ban  := False;
              ---
           End If;
           ---
           Insert Into arindetremision (
             NO_CIA,
             NO_TRANSA,
             ANIO,
             MES,
             NO_LINEA,
             NO_ARTI,
             CANTIDAD
           )
           values(
             j.no_cia,
             lv_no_docu,
             lr_fecha_proceso.ano_proce,
             lr_fecha_proceso.mes_proce,
             ln_cont,
             j.no_arti,
             j.pedido
           );
           ln_cont:=ln_cont + 1;
           If ln_cont > ln_no_lineas Then
             lb_ban := true;
           End if;
      End Loop;
  End Loop;

  end if;


  Exception
    when le_mierror then
         pv_error := lv_error;
    when others then
         pv_error := 'Se presento el siguiente error durante el proceso: '||sqlerrm;
End INREPLICA_GUIAS;
/

