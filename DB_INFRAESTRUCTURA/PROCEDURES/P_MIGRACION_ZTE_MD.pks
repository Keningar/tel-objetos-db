create or replace Procedure                           P_Migracion_Zte_Md(
    Pv_Tipo_Proceso In Varchar2)
Is
  /*
  * Procedimiento que realiza la migración de servicios de Internet
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 23-01-2021
  */
  Procedure P_Migracion_Internet_Zte_Md
  Is
    --
    Cursor C_Getdatazte
    Is
      Select Tmp_Migra.Id_Registro Id_Registro,
        Tmp_Migra.Id_Pon_Antiguo Id_Pon_Antiguo,
        Tmp_Migra.Nombre_Pon_Antiguo Nombre_Pon_Antiguo,
        Tmp_Migra.Id_Pon_Nuevo Id_Pon_Nuevo,
        Tmp_Migra.Nombre_Pon_Nuevo Nombre_Pon_Nuevo,
        Tmp_Migra.Ont_Id Ont_Id,
        Tmp_Migra.Service_Profile Service_Profile,
        Tmp_Migra.Serie Serie,
        Tmp_Migra.Line_Profile Line_Profile,
        Tmp_Migra.Vlan Vlan,
        Tmp_Migra.Login Login,
        Tmp_Migra.Ip_Olt_Antiguo Ip_Olt_Antiguo,
        Tmp_Migra.Ip_Olt_Nuevo Ip_Olt_Nuevo
      From Db_Infraestructura.Tmp_Migra_Olt_Zte Tmp_Migra
      Where Tmp_Migra.Tipo_Registro   = 'INTERNET'
      And Tmp_Migra.Estado          ='Pendiente';
    --
    Cursor C_Getolt (Cv_Ip_Olt Varchar2, Cv_Nombre_Interface Varchar2)
    Is
      Select Ie.Id_Elemento,
        Iie.Id_Interface_Elemento,
        Ie.Nombre_Elemento,
        Iie.Nombre_Interface_Elemento
      From Db_Infraestructura.Info_Interface_Elemento Iie,
        Db_Infraestructura.Info_Elemento Ie,
        Db_Infraestructura.Info_Ip Iip
      Where Iip.Ip                      = Cv_Ip_Olt
      And Iip.Elemento_Id               = Ie.Id_Elemento
      And Iie.Elemento_Id               = Ie.Id_Elemento
      And Iip.Estado                    = 'Activo'
      And Iie.Nombre_Interface_Elemento = Cv_Nombre_Interface
      And Rownum                       <= 1;
    Cursor C_Getcaracteristica (Ci_Id_Servicio Number, Cv_Nombre_Caracteristica Varchar2)
    Is
      Select Isc.Id_Servicio_Prod_Caract,
        Isc.Valor
      From Db_Comercial.Info_Servicio_Prod_Caract Isc
      Join Db_Comercial.Admi_Producto_Caracteristica Apc
      On Apc.Id_Producto_Caracterisitica = Isc.Producto_Caracterisitica_Id
      Join Db_Comercial.Admi_Caracteristica Ac
      On Ac.Id_Caracteristica             = Apc.Caracteristica_Id
      Where Ac.Descripcion_Caracteristica = Cv_Nombre_Caracteristica
      And Isc.Estado                      = 'Activo'
      And Apc.Estado                      = 'Activo'
      And Isc.Servicio_Id                 = Ci_Id_Servicio
      And Rownum                         <= 1;
    --
    Cursor C_Getservicioporlogin (Cv_Login Varchar2)
    Is
    Select Serv.Id_Servicio Id_Servicio,
        Serv.Estado Estado_Internet,
        Ie.Nombre_Elemento Nombre_Olt,
        Iie.Nombre_Interface_Elemento Nombre_Interface_Olt
      From Db_Comercial.Info_Servicio Serv,
        Db_Comercial.Info_Servicio_Tecnico Serv_Tec,
        Db_Infraestructura.Info_Elemento Ie,
        Db_Infraestructura.Info_Interface_Elemento Iie,
        Db_Comercial.Info_Punto Pto,
        Db_Comercial.Info_Plan_Cab Planc,
        Db_Comercial.Info_Plan_Det Pland,
        Db_Comercial.Admi_Producto Prod
      Where Serv.Plan_Id            = Planc.Id_Plan
      And Planc.Id_Plan             = Pland.Plan_Id
      And Pland.Producto_Id         = Prod.Id_Producto
      And Prod.Nombre_Tecnico       = 'INTERNET'
      And (Serv.Estado              = 'Activo'
      Or Serv.Estado                = 'In-Corte')
      And Serv.Punto_Id             = Pto.Id_Punto
      And Serv.Id_Servicio          = Serv_Tec.Servicio_Id
      And Serv_Tec.Elemento_Id      = Ie.Id_Elemento
      And Iie.Id_Interface_Elemento = Serv_Tec.Interface_Elemento_Id
      And Pto.Login                 = Cv_Login
      And Rownum <= 1;
    --
    Cursor C_Getservicioporserie (Cv_Serie Varchar2)
    Is
    Select Serv.Id_Servicio Id_Servicio,
        Serv.Estado Estado_Internet,
        Ie.Nombre_Elemento Nombre_Olt,
        Iie.Nombre_Interface_Elemento Nombre_Interface_Olt
      From Db_Comercial.Info_Servicio Serv,
        Db_Comercial.Info_Servicio_Tecnico Serv_Tec,
        Db_Infraestructura.Info_Elemento Ie,
        Db_Infraestructura.Info_Elemento Iecpe,
        Db_Infraestructura.Info_Interface_Elemento Iie,
        Db_Comercial.Info_Punto Pto,
        Db_Comercial.Info_Plan_Cab Planc,
        Db_Comercial.Info_Plan_Det Pland,
        Db_Comercial.Admi_Producto Prod
      Where Serv.Plan_Id            = Planc.Id_Plan
      And Planc.Id_Plan             = Pland.Plan_Id
      And Pland.Producto_Id         = Prod.Id_Producto
      And Prod.Nombre_Tecnico       = 'INTERNET'
      And (Serv.Estado              = 'Activo'
      Or Serv.Estado                = 'In-Corte')
      And Serv.Punto_Id             = Pto.Id_Punto
      And Serv.Id_Servicio          = Serv_Tec.Servicio_Id
      And Serv_Tec.Elemento_Id      = Ie.Id_Elemento
      And Iie.Id_Interface_Elemento = Serv_Tec.Interface_Elemento_Id
      And Serv_Tec.Elemento_Cliente_Id = Iecpe.Id_Elemento
      And Upper(Iecpe.Serie_Fisica) = Upper(Cv_Serie)
      And Rownum <= 1;
    --
    Lr_Infoolt C_Getolt%Rowtype;
    Lr_Infocaracteristica C_Getcaracteristica%Rowtype;
    Lr_Infocliente C_Getservicioporlogin%Rowtype;
    Ln_Idoltnuevo                  Number        := 0;
    Ln_Idcaracteristica            Number        := 0;
    Lv_Nombreoltnuevo              Varchar2(200) := '';
    Lv_Nombreinterfacenuevo        Varchar2(200) := '';
    Ln_Idinterfacenuevo            Number        := 0;
    Lv_Valorcaracteristicaanterior Varchar2(200) := '';
    Lv_Mensaje                     Varchar2(4000):= '';
    Ln_Idserviciointernet          Number        := 0;
    Lv_Estadointernet              Varchar2(200) := '';
    Lv_Nombreolt                   Varchar2(200) := '';
    Lv_Nombreinterfaceolt          Varchar2(200) := '';
  Begin
    For I_Data In C_Getdatazte
    Loop
      Open C_Getservicioporlogin (I_Data.Login);
      Fetch C_Getservicioporlogin Into Lr_Infocliente;
      If C_Getservicioporlogin%Found Then
        Ln_Idserviciointernet := Lr_Infocliente.Id_Servicio;
        Lv_Estadointernet     := Lr_Infocliente.Estado_Internet;
        Lv_Nombreolt          := Lr_Infocliente.Nombre_Olt;
        Lv_Nombreinterfaceolt := Lr_Infocliente.Nombre_Interface_Olt;
      Else
        Ln_Idserviciointernet := 0;
        Lv_Estadointernet     := '';
        Lv_Nombreolt          := '';
        Lv_Nombreinterfaceolt := '';
      End If;
      Close C_Getservicioporlogin;
      If Ln_Idserviciointernet = 0 Then
        Open C_Getservicioporserie (I_Data.Serie);
        Fetch C_Getservicioporserie Into Lr_Infocliente;
        If C_Getservicioporserie%Found Then
          Ln_Idserviciointernet := Lr_Infocliente.Id_Servicio;
          Lv_Estadointernet     := Lr_Infocliente.Estado_Internet;
          Lv_Nombreolt          := Lr_Infocliente.Nombre_Olt;
          Lv_Nombreinterfaceolt := Lr_Infocliente.Nombre_Interface_Olt;
        Else
          Ln_Idserviciointernet := 0;
          Lv_Estadointernet     := '';
          Lv_Nombreolt          := '';
          Lv_Nombreinterfaceolt := '';
        End If;
        Close C_Getservicioporserie;
      End If;
      If Ln_Idserviciointernet > 0 Then
        Lv_Mensaje := '';
        Open C_Getolt (I_Data.Ip_Olt_Nuevo, I_Data.Nombre_Pon_Nuevo);
        Fetch C_Getolt Into Lr_Infoolt;
        If C_Getolt%Found Then
          Ln_Idoltnuevo           := Lr_Infoolt.Id_Elemento;
          Lv_Nombreoltnuevo       := Lr_Infoolt.Nombre_Elemento;
          Lv_Nombreinterfacenuevo := Lr_Infoolt.Nombre_Interface_Elemento;
          Ln_Idinterfacenuevo     := Lr_Infoolt.Id_Interface_Elemento;
        Else
          Ln_Idoltnuevo       := 0;
          Ln_Idinterfacenuevo := 0;
          Lv_Nombreoltnuevo   := '';
        End If;
        Close C_Getolt;
        If Ln_Idoltnuevo > 0 Then
          Lv_Mensaje    := 'Migración de Data ZTE<br>';
          Lv_Mensaje    := Lv_Mensaje || '<b>Olt Anterior</b>:         ';
          Lv_Mensaje    := Lv_Mensaje || Lv_Nombreolt || '<br>';
          Lv_Mensaje    := Lv_Mensaje || '<b>Puerto olt Anterior</b>:      ';
          Lv_Mensaje    := Lv_Mensaje || Lv_Nombreinterfaceolt || '<br>';
          Lv_Mensaje    := Lv_Mensaje || '<b>Olt Nuevo</b>:        ';
          Lv_Mensaje    := Lv_Mensaje || Lv_Nombreoltnuevo || '<br>';
          Lv_Mensaje    := Lv_Mensaje || '<b>Puerto olt Nuevo</b>:         ';
          Lv_Mensaje    := Lv_Mensaje || Lv_Nombreinterfacenuevo || '<br>';
          Update Db_Comercial.Info_Servicio_Tecnico
          Set Elemento_Id         = Ln_Idoltnuevo,
            Interface_Elemento_Id = Ln_Idinterfacenuevo
          Where Servicio_Id       = Ln_Idserviciointernet;
          Open C_Getcaracteristica (Ln_Idserviciointernet, 'INDICE CLIENTE');
          Fetch C_Getcaracteristica Into Lr_Infocaracteristica;
          If C_Getcaracteristica%Found Then
            Ln_Idcaracteristica            := Lr_Infocaracteristica.Id_Servicio_Prod_Caract;
            Lv_Valorcaracteristicaanterior := Lr_Infocaracteristica.Valor;
          Else
            Ln_Idcaracteristica            := 0;
            Lv_Valorcaracteristicaanterior := '';
          End If;
          Close C_Getcaracteristica;
          If Ln_Idcaracteristica > 0 Then
            Lv_Mensaje          := Lv_Mensaje || '<b>Indice Cliente Anterior</b>:  ';
            Lv_Mensaje          := Lv_Mensaje || Lv_Valorcaracteristicaanterior || '<br>';
            Update Db_Comercial.Info_Servicio_Prod_Caract
            Set Valor                     = I_Data.Ont_Id,
              Fe_Ult_Mod                  = Sysdate,
              Usr_Ult_Mod                 = 'MIGRA_ZTE'
            Where Id_Servicio_Prod_Caract = Ln_Idcaracteristica;
            Lv_Mensaje                   := Lv_Mensaje || '<b>Indice Cliente Nuevo</b>:  ';
            Lv_Mensaje                   := Lv_Mensaje || I_Data.Ont_Id || '<br>';
          End If;
          Open C_Getcaracteristica (Ln_Idserviciointernet, 'SERVICE-PROFILE');
          Fetch C_Getcaracteristica Into Lr_Infocaracteristica;
          If C_Getcaracteristica%Found Then
            Ln_Idcaracteristica            := Lr_Infocaracteristica.Id_Servicio_Prod_Caract;
            Lv_Valorcaracteristicaanterior := Lr_Infocaracteristica.Valor;
          Else
            Ln_Idcaracteristica            := 0;
            Lv_Valorcaracteristicaanterior := '';
          End If;
          Close C_Getcaracteristica;
          If Ln_Idcaracteristica > 0 Then
            Lv_Mensaje          := Lv_Mensaje || '<b>Service Profile Anterior</b>:  ';
            Lv_Mensaje          := Lv_Mensaje || Lv_Valorcaracteristicaanterior || '<br>';
            Update Db_Comercial.Info_Servicio_Prod_Caract
            Set Valor                     = I_Data.Service_Profile,
              Fe_Ult_Mod                  = Sysdate,
              Usr_Ult_Mod                 = 'MIGRA_ZTE'
            Where Id_Servicio_Prod_Caract = Ln_Idcaracteristica;
            Lv_Mensaje                   := Lv_Mensaje || '<b>Service Profile Nuevo</b>:  ';
            Lv_Mensaje                   := Lv_Mensaje || I_Data.Service_Profile || '<br>';
          End If;
          Insert
          Into Db_Comercial.Info_Servicio_Historial
            (
              Id_Servicio_Historial,
              Servicio_Id,
              Usr_Creacion,
              Fe_Creacion,
              Ip_Creacion,
              Estado,
              Observacion
            )
            Values
            (
              Db_Comercial.Seq_Info_Servicio_Historial.Nextval,
              Ln_Idserviciointernet,
              'MIGRA_ZTE',
              Sysdate,
              '127.0.0.1',
              Lv_Estadointernet,
              Lv_Mensaje
            );
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Finalizado',
            Observacion     = Lv_Mensaje
          Where Id_Registro = I_Data.Id_Registro;
        Else
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Error',
            Observacion     = 'No existe información en Telcos del nuevo OLT y Puerto Pon a migrar.'
          Where Id_Registro = I_Data.Id_Registro;
        End If;
      Else
        Update Db_Infraestructura.Tmp_Migra_Olt_Zte
        Set Estado        = 'Error',
          Observacion     = 'No existe información en Telcos del login o número de serie que se encuentra en el reporte.'
        Where Id_Registro = I_Data.Id_Registro;
      End If;
      Commit;
    End Loop;
  Exception
  When Others Then
    Db_General.Gnrlpck_Util.Insert_Error('P_MIGRACION_INTERNET_ZTE_MD', 'P_MIGRACION_INTERNET_ZTE_MD', Sqlerrm, 'DB_INFRAESTRUCTURA', Sysdate, Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1'));
  End P_Migracion_Internet_Zte_Md;
/*
* Procedimiento que realiza la migración de Ips de servicios
*
* @author Jesús Bozada <jbozada@telconet.ec>
* @version 1.0 23-01-2021
*/
  Procedure P_Migracion_Ip_Zte_Md
  Is
    --
    Cursor C_Getdatazte
    Is
      Select Tmp_Migra.Id_Registro,
        Tmp_Migra.Ip_Antigua,
        Tmp_Migra.Ip_Nueva,
        Tmp_Migra.Scope_Antiguo,
        Tmp_Migra.Scope_Nuevo
      From Db_Infraestructura.Tmp_Migra_Olt_Zte Tmp_Migra
      Where Tmp_Migra.Tipo_Registro = 'IP'
      And Tmp_Migra.Estado          ='Pendiente';
    --
    Cursor C_Getcaracteristica (Ci_Id_Servicio Number, Cv_Nombre_Caracteristica Varchar2)
    Is
      Select Isc.Id_Servicio_Prod_Caract,
        Isc.Valor
      From Db_Comercial.Info_Servicio_Prod_Caract Isc
      Join Db_Comercial.Admi_Producto_Caracteristica Apc
      On Apc.Id_Producto_Caracterisitica = Isc.Producto_Caracterisitica_Id
      Join Db_Comercial.Admi_Caracteristica Ac
      On Ac.Id_Caracteristica             = Apc.Caracteristica_Id
      Where Ac.Descripcion_Caracteristica = Cv_Nombre_Caracteristica
      And Isc.Estado                      = 'Activo'
      And Apc.Estado                      = 'Activo'
      And Isc.Servicio_Id                 = Ci_Id_Servicio
      And Rownum                         <= 1;
    --
    Cursor C_Getipmigrar (Cv_Id_Ip Varchar2)
    Is
      Select Iip.Id_Ip,
        Iip.Servicio_Id,
        Iserv.Estado
      From Db_Infraestructura.Info_Ip Iip,
        Db_Comercial.Info_Servicio Iserv
      Where Iip.Estado    = 'Activo'
      And Iip.Servicio_Id = Iserv.Id_Servicio
      And (Iserv.Estado   = 'Activo'
      Or Iserv.Estado     = 'In-Corte')
      And Iip.Ip          = Cv_Id_Ip
      And Rownum         <= 1;
    --
    Cursor C_Getcantidadipmigrar (Cv_Id_Ip Varchar2)
    Is
      Select Count(1) As Cantidad
      From Db_Infraestructura.Info_Ip Iip
      Where Iip.Estado = 'Activo'
      And Iip.Ip       = Cv_Id_Ip;
    --
    Lr_Infocaracteristica C_Getcaracteristica%Rowtype;
    Lr_Infoipmigrar C_Getipmigrar%Rowtype;
    Lr_Infocantidadipmigrar C_Getcantidadipmigrar%Rowtype;
    Ln_Idcaracteristica            Number        := 0;
    Ln_Idipanterior                Number        := 0;
    Ln_Idservicioanterior          Number        := 0;
    Ln_Cantidadips                 Number        := 0;
    Lv_Estadoservicio              Varchar2(50)  := '';
    Lv_Valorcaracteristicaanterior Varchar2(200) := '';
    Lv_Mensaje                     Varchar2(4000):= '';
  Begin
    For I_Data In C_Getdatazte
    Loop
      Open C_Getipmigrar (I_Data.Ip_Antigua);
      Fetch C_Getipmigrar Into Lr_Infoipmigrar;
      If C_Getipmigrar%Found Then
        Ln_Idipanterior       := Lr_Infoipmigrar.Id_Ip;
        Ln_Idservicioanterior := Lr_Infoipmigrar.Servicio_Id;
        Lv_Estadoservicio     := Lr_Infoipmigrar.Estado;
      Else
        Ln_Idipanterior       := 0;
        Ln_Idservicioanterior := 0;
        Lv_Estadoservicio     := '';
      End If;
      Close C_Getipmigrar;
      If Ln_Idipanterior > 0 Then
        Open C_Getcantidadipmigrar (I_Data.Ip_Antigua);
        Fetch C_Getcantidadipmigrar Into Lr_Infocantidadipmigrar;
        If C_Getcantidadipmigrar%Found Then
          Ln_Cantidadips := Lr_Infocantidadipmigrar.Cantidad;
        Else
          Ln_Cantidadips := 0;
        End If;
        Close C_Getcantidadipmigrar;
        If Ln_Cantidadips = 1 Then
          Lv_Mensaje     := 'Migración de Data ZTE<br>';
          Lv_Mensaje     := Lv_Mensaje || '<b>Ip anterior</b>: ';
          Lv_Mensaje     := Lv_Mensaje || I_Data.Ip_Antigua || '<br>';
          Lv_Mensaje     := Lv_Mensaje || '<b>Ip nueva</b>: ';
          Lv_Mensaje     := Lv_Mensaje || I_Data.Ip_Nueva || '<br>';
          Update Db_Infraestructura.Info_Ip
          Set Ip      = I_Data.Ip_Nueva
          Where Id_Ip = Ln_Idipanterior;
          Open C_Getcaracteristica (Ln_Idservicioanterior, 'SCOPE');
          Fetch C_Getcaracteristica Into Lr_Infocaracteristica;
          If C_Getcaracteristica%Found Then
            Ln_Idcaracteristica            := Lr_Infocaracteristica.Id_Servicio_Prod_Caract;
            Lv_Valorcaracteristicaanterior := Lr_Infocaracteristica.Valor;
          Else
            Ln_Idcaracteristica            := 0;
            Lv_Valorcaracteristicaanterior := '';
          End If;
          Close C_Getcaracteristica;
          If Ln_Idcaracteristica > 0 Then
            Lv_Mensaje          := Lv_Mensaje || '<b>Scope Anterior</b>: ';
            Lv_Mensaje          := Lv_Mensaje || Lv_Valorcaracteristicaanterior || '<br>';
            Update Db_Comercial.Info_Servicio_Prod_Caract
            Set Valor                     = I_Data.Scope_Nuevo,
              Fe_Ult_Mod                  = Sysdate,
              Usr_Ult_Mod                 = 'MIGRA_ZTE'
            Where Id_Servicio_Prod_Caract = Ln_Idcaracteristica;
            Lv_Mensaje                   := Lv_Mensaje || '<b>Scope Nuevo</b>: ';
            Lv_Mensaje                   := Lv_Mensaje || I_Data.Scope_Nuevo || '<br>';
          End If;
          Insert
          Into Db_Comercial.Info_Servicio_Historial
            (
              Id_Servicio_Historial,
              Servicio_Id,
              Usr_Creacion,
              Fe_Creacion,
              Ip_Creacion,
              Estado,
              Observacion
            )
            Values
            (
              Db_Comercial.Seq_Info_Servicio_Historial.Nextval,
              Ln_Idservicioanterior,
              'MIGRA_ZTE',
              Sysdate,
              '127.0.0.1',
              Lv_Estadoservicio,
              Lv_Mensaje
            );
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Finalizado',
            Observacion     = Lv_Mensaje
          Where Id_Registro = I_Data.Id_Registro;
        Else
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Error',
            Observacion     = 'Existe más de una IP Activa, no se puede realizar la migración por inconsistencia de data.'
          Where Id_Registro = I_Data.Id_Registro;
        End If;
      Else
        Update Db_Infraestructura.Tmp_Migra_Olt_Zte
        Set Estado        = 'Error',
          Observacion     = 'No existe información en Telcos de la ip anterior a migrar.'
        Where Id_Registro = I_Data.Id_Registro;
      End If;
      Commit;
    End Loop;
  Exception
  When Others Then
    Db_General.Gnrlpck_Util.Insert_Error('P_MIGRACION_IP_ZTE_MD', 'P_MIGRACION_IP_ZTE_MD', Sqlerrm, 'DB_INFRAESTRUCTURA', Sysdate, Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1'));
  End P_Migracion_Ip_Zte_Md;
/*
* Procedimiento que realiza la migración de enlaces de olts
*
* @author Jesús Bozada <jbozada@telconet.ec>
* @version 1.0 04-02-2021
*/
  Procedure P_Migracion_Enlaces_Zte_Md
  Is
    --
    Cursor C_Getdatazte
    Is
      Select Tmp_Migra.Id_Registro,
        Tmp_Migra.Nombre_Elemento_Antiguo,
        Tmp_Migra.Nombre_Pon_Antiguo,
        Tmp_Migra.Nombre_Elemento_Nuevo,
        Tmp_Migra.Nombre_Pon_Nuevo
      From Db_Infraestructura.Tmp_Migra_Olt_Zte Tmp_Migra
      Where Tmp_Migra.Tipo_Registro = 'ENLACE'
      And Tmp_Migra.Estado          ='Pendiente';
    --
    Cursor C_Getinfoenlace (Cv_Nombre_Ele_Ant Varchar2, Cv_Nombre_Ie_Ant Varchar2, Cv_Nombre_Ele_Nue Varchar2, Cv_Nombre_Ie_Nue Varchar2)
    Is
      Select Ien.Id_Enlace,
        Ien.Interface_Elemento_Ini_Id As Id_Interface_Elemento_Ant,
        Nvl(
        (Select Id_Interface_Elemento
        From Db_Infraestructura.Info_Elemento Iele,
          Db_Infraestructura.Info_Interface_Elemento Iiel
        Where Iele.Id_Elemento             = Iiel.Elemento_Id
        And Iele.Nombre_Elemento           = Cv_Nombre_Ele_Nue
        And Iele.Estado                    = 'Activo'
        And Iiel.Nombre_Interface_Elemento = Cv_Nombre_Ie_Nue
        And Iiel.Estado                    = 'not connect'
        And rownum <= 1
        ), 0) As Id_Interface_Elemento_Nuevo
      From Db_Infraestructura.Info_Elemento Iel,
        Db_Infraestructura.Info_Interface_Elemento Iie,
        Db_Infraestructura.Info_Enlace Ien
      Where Iel.Id_Elemento             = Iie.Elemento_Id
      And Iie.Id_Interface_Elemento     = Ien.Interface_Elemento_Ini_Id
      And Iel.Nombre_Elemento           = Cv_Nombre_Ele_Ant
      And Iie.Nombre_Interface_Elemento = Cv_Nombre_Ie_Ant
      And Iie.Estado                    = 'connected'
      And Ien.Estado                    = 'Activo';
      --
      Lr_Infoenlace C_Getinfoenlace%Rowtype;
      Lr_Infoenlacereg Db_Infraestructura.Info_Enlace%Rowtype;
      Ln_Idenlace         Number := 0;
      Ln_Id_Int_Ele_Nuevo Number := 0;
    Begin
      For I_Data In C_Getdatazte
      Loop
        Open C_Getinfoenlace (I_Data.Nombre_Elemento_Antiguo, I_Data.Nombre_Pon_Antiguo, I_Data.Nombre_Elemento_Nuevo, I_Data.Nombre_Pon_Nuevo);
        Fetch C_Getinfoenlace Into Lr_Infoenlace;
        If C_Getinfoenlace%Found Then
          Ln_Idenlace         := Lr_Infoenlace.Id_Enlace;
          Ln_Id_Int_Ele_Nuevo := Lr_Infoenlace.Id_Interface_Elemento_Nuevo;
        Else
          Ln_Idenlace        := 0;
          Ln_Id_Int_Ele_Nuevo:= 0;
        End If;
        Close C_Getinfoenlace;
        If Ln_Idenlace           > 0 Then
          If Ln_Id_Int_Ele_Nuevo > 0 Then
            Update Db_Infraestructura.Info_Interface_Elemento
            Set Estado                  = 'not connect',
              Fe_Ult_Mod                = Sysdate,
              Usr_Ult_Mod               ='MIGRA_ZTE'
            Where Id_Interface_Elemento = Lr_Infoenlace.Id_Interface_Elemento_Ant;
            Update Db_Infraestructura.Info_Enlace
            Set Estado      = 'Eliminado'
            Where Id_Enlace = Lr_Infoenlace.Id_Enlace;
            Select *
            Into Lr_Infoenlacereg
            From Db_Infraestructura.Info_Enlace
            Where Id_Enlace = Lr_Infoenlace.Id_Enlace;
            Insert
            Into Db_Infraestructura.Info_Enlace
              (
                Id_Enlace,
                Interface_Elemento_Ini_Id,
                Interface_Elemento_Fin_Id,
                Tipo_Medio_Id,
                Capacidad_Input,
                Unidad_Medida_Input,
                Capacidad_Output,
                Unidad_Medida_Output,
                Capacidad_Ini_Fin,
                Unidad_Medida_Up,
                Capacidad_Fin_Ini,
                Unidad_Medida_Down,
                Tipo_Enlace,
                Estado,
                Usr_Creacion,
                Fe_Creacion,
                Ip_Creacion,
                Buffer_Hilo_Id
              )
              Values
              (
                Db_Infraestructura.Seq_Info_Enlace.Nextval,
                Ln_Id_Int_Ele_Nuevo,
                Lr_Infoenlacereg.Interface_Elemento_Fin_Id,
                Lr_Infoenlacereg.Tipo_Medio_Id,
                Lr_Infoenlacereg.Capacidad_Input,
                Lr_Infoenlacereg.Unidad_Medida_Input,
                Lr_Infoenlacereg.Capacidad_Output,
                Lr_Infoenlacereg.Unidad_Medida_Output,
                Lr_Infoenlacereg.Capacidad_Ini_Fin,
                Lr_Infoenlacereg.Unidad_Medida_Up,
                Lr_Infoenlacereg.Capacidad_Fin_Ini,
                Lr_Infoenlacereg.Unidad_Medida_Down,
                Lr_Infoenlacereg.Tipo_Enlace,
                'Activo',
                'MIGRA_ZTE',
                Sysdate,
                '127.0.0.1',
                Lr_Infoenlacereg.Buffer_Hilo_Id
              );
            Update Db_Infraestructura.Info_Interface_Elemento
            Set Estado                  = 'connected'
            Where Id_Interface_Elemento = Ln_Id_Int_Ele_Nuevo;
            Update Db_Infraestructura.Tmp_Migra_Olt_Zte
            Set Estado        = 'Finalizado',
              Observacion     = 'Enlace actualizado correctamente',
              Fe_Ult_Mod      = Sysdate,
              Usr_Ult_Mod     = 'MIGRA_ZTE'
            Where Id_Registro = I_Data.Id_Registro;
          Else
            Update Db_Infraestructura.Tmp_Migra_Olt_Zte
            Set Estado        = 'Error',
              Observacion     = 'No existe información en Telcos del nombre de olt y puerto nuevo a migrar.',
              Fe_Ult_Mod      = Sysdate,
              Usr_Ult_Mod     = 'MIGRA_ZTE'
            Where Id_Registro = I_Data.Id_Registro;
          End If;
        Else
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Error',
            Observacion     = 'No existe información en Telcos del enlace asociado al nombre de olt y puerto connected anterior a migrar.',
            Fe_Ult_Mod      = Sysdate,
            Usr_Ult_Mod     = 'MIGRA_ZTE'
          Where Id_Registro = I_Data.Id_Registro;
        End If;
        Commit;
      End Loop;
    Exception
    When Others Then
      Db_General.Gnrlpck_Util.Insert_Error('P_MIGRACION_ENLACES_ZTE_MD', 'P_MIGRACION_ENLACES_ZTE_MD', Sqlerrm, 'DB_INFRAESTRUCTURA', Sysdate, Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1'));
    End P_Migracion_Enlaces_Zte_Md;
    /*
    * Procedimiento que realiza la migración de enlaces y nombres de splitters de servicio
    *
    * @author Jesús Bozada <jbozada@telconet.ec>
    * @version 1.0 04-02-2021
    */
    Procedure P_Migracion_Splitter_Zte_Md
    Is
      --
      Cursor C_Getdatazte
      Is
        Select Tmp_Migra.Id_Registro,
          Tmp_Migra.Nombre_Elemento_Antiguo,
          Tmp_Migra.Nombre_Elemento_Nuevo
        From Db_Infraestructura.Tmp_Migra_Olt_Zte Tmp_Migra
        Where Tmp_Migra.Tipo_Registro = 'SPLITTER'
        And Tmp_Migra.Estado          ='Pendiente';
      --
      Cursor C_Getinfoelemento (Cv_Nombre_Ele_Ant Varchar2)
      Is
        Select Iel.Id_Elemento
        From Db_Infraestructura.Info_Elemento Iel,
          Db_Infraestructura.Admi_Modelo_Elemento Ame,
          Db_Infraestructura.Admi_Tipo_Elemento Ate
        Where Iel.Modelo_Elemento_Id = Ame.Id_Modelo_Elemento
        And Ame.Tipo_Elemento_Id     = Ate.Id_Tipo_Elemento
        And Iel.Nombre_Elemento      = Cv_Nombre_Ele_Ant
        And Ate.Nombre_Tipo_Elemento = 'SPLITTER'
        And Iel.Estado               = 'Activo';
      --
      Lr_Infoelemento C_Getinfoelemento%Rowtype;
      Ln_Idelemento Number := 0;
    Begin
      For I_Data In C_Getdatazte
      Loop
        Open C_Getinfoelemento (I_Data.Nombre_Elemento_Antiguo);
        Fetch C_Getinfoelemento Into Lr_Infoelemento;
        If C_Getinfoelemento%Found Then
          Ln_Idelemento := Lr_Infoelemento.Id_Elemento;
        Else
          Ln_Idelemento := 0;
        End If;
        Close C_Getinfoelemento;
        If Ln_Idelemento > 0 Then
          Update Db_Infraestructura.Info_Elemento
          Set Nombre_Elemento = I_Data.Nombre_Elemento_Nuevo
          Where Id_Elemento   = Ln_Idelemento;
          Insert
          Into Db_Infraestructura.Info_Historial_Elemento
            (
              Id_Historial,
              Elemento_Id,
              Estado_Elemento,
              Capacidad,
              Observacion,
              Usr_Creacion,
              Fe_Creacion,
              Ip_Creacion
            )
            Values
            (
              Db_Infraestructura.Seq_Info_Historial_Elemento.Nextval,
              Ln_Idelemento,
              'Activo',
              Null,
              'Se actualizó el nombre el elemento correctamente. Nombre anterior: '
              ||I_Data.Nombre_Elemento_Antiguo
              || ', Nombre Nuevo: '
              || I_Data.Nombre_Elemento_Nuevo,
              'MIGRA_ZTE',
              Sysdate,
              Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1')
            );
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Finalizado',
            Observacion     = 'Splitter actualizado correctamente',
            Fe_Ult_Mod      = Sysdate,
            Usr_Ult_Mod     = 'MIGRA_ZTE'
          Where Id_Registro = I_Data.Id_Registro;
        Else
          Update Db_Infraestructura.Tmp_Migra_Olt_Zte
          Set Estado        = 'Error',
            Observacion     = 'No existe información en Telcos con el nombre del elemento splitter anterior en estado Activo a migrar.',
            Fe_Ult_Mod      = Sysdate,
            Usr_Ult_Mod     = 'MIGRA_ZTE'
          Where Id_Registro = I_Data.Id_Registro;
        End If;
        Commit;
      End Loop;
    Exception
    When Others Then
      Db_General.Gnrlpck_Util.Insert_Error('P_MIGRACION_SPLITTER_ZTE_MD', 'P_MIGRACION_SPLITTER_ZTE_MD', Sqlerrm, 'DB_INFRAESTRUCTURA', Sysdate, Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1'));
    End P_Migracion_Splitter_Zte_Md;
  Begin
    If Pv_Tipo_Proceso = 'INTERNET' Then
      P_Migracion_Internet_Zte_Md();
    Elsif Pv_Tipo_Proceso = 'ENLACE' Then
      P_Migracion_Enlaces_Zte_Md();
    Elsif Pv_Tipo_Proceso = 'SPLITTER' Then
      P_Migracion_Splitter_Zte_Md();
    Elsif Pv_Tipo_Proceso = 'IP' Then
      P_Migracion_Ip_Zte_Md();
    End If;
  Exception
  When Others Then
    Db_General.Gnrlpck_Util.Insert_Error('P_MIGRACION_ZTE_MD', 'P_MIGRACION_ZTE_MD', Sqlerrm, 'DB_INFRAESTRUCTURA', Sysdate, Nvl(Sys_Context('USERENV','IP_ADDRESS'), '127.0.0.1'));
  End P_Migracion_Zte_Md;