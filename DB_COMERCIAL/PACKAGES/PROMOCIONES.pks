CREATE OR REPLACE PACKAGE DB_COMERCIAL.PROMOCIONES AS 
  ESTADO_SERVICIO_INCORTE varchar2(20) := 'In-Corte';
  CORREO_ENVIA VARCHAR2(50) := 'notificaciones_telcos@telconet.ec';  
  CORREO_RECIBE_MD VARCHAR2(100) := 'belito6@hotmail.com,apenaherrera@telconet.ec';
  CORREO_RECIBE_TTCO VARCHAR2(100) := 'belito6@hotmail.com,apenaherrera@telconet.ec';
  USUARIO_CREACION VARCHAR2(15) := 'telco-promocion';
  TIPO_SOLICITUD_REFE NUMBER := 11;
  TIPO_SOLICITUD_HOME NUMBER := 11;
  TIPO_SOLICITUD_INST NUMBER := 12;
  CORREO_RECIBE_CONFIRMACION  VARCHAR2(100) := 'apenaherrera@telconet.ec';
  --
  procedure p_verificarPromociones(cod_ret out number, msg_ret out varchar2) ;
  procedure p_calculaPuntosPorReferidos(p_fechaEjecucion timeStamp, cod_ret out number, msg_ret out varchar2) ;
  procedure p_creaPuntos(registro INFO_PROMOCION_REFERIDO%rowtype,
      cod_ret out number, msg_ret out varchar2);
  procedure p_activaPuntos(cod_ret out number, msg_ret out varchar2);
  procedure p_verificaPerdidaDePuntos(cod_ret out number, msg_ret out varchar2);
  procedure p_generaSolicitud(cod_ret out number, msg_ret out varchar2);
  --
  function leeValorCaracteristicaPlan(p_servicio number, p_caracteristica varchar2) return number;
  --
  procedure p_enviaCorreo(ASUNTO varchar2, CADENA varchar2,referente_id number,referente varchar2,referido_id number,
  referido varchar2,servicioReferido_id number,nombre_plan varchar2,caracteristica varchar2, prefijo varchar2,cod_ret out number, msg_ret out varchar2);
  procedure p_enviaCorreoFacturacion(ASUNTO varchar2, CADENA varchar2,referente_id number,referente varchar2,
      id_servicio number,nombre_plan varchar2,prefijo varchar2,cod_ret out number, msg_ret out varchar2);
  function addTD(texto varchar2, align varchar2:=null,colspan number:=null, bold number:=0) return varchar2 ;
  procedure p_promociones_por_inst(p_fechaEjecucion timeStamp,cod_ret out number, msg_ret out varchar2) ;
  
 /**
  * Documentaci�n para PROCEDURE 'p_promociones_HOME'.
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 23-12-2016  
  * Se incluyen en el proceso de Promociones los servicios en estado T: Trasladados
  *
  * @param cod_ret in out number,
  * @param msg_ret in out varchar2, 
  */
  procedure p_promociones_HOME(cod_ret out number, msg_ret out varchar2);
  procedure p_enviaCorreoConfirmacion(ASUNTO varchar2, CADENA varchar2,cod_ret out number, msg_ret out varchar2);
  
  
END PROMOCIONES;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.PROMOCIONES AS 
/*********************************************************************************
 * Procedimiento que verifica si existen condiciones de promociones por ejecutarse para el caso de:
 * 1)  Promociones por Referidos (Calculo y acumulacion de puntos para obtener descuentos en la facturacion del cliente)
 * 2)  Promociones Descuentos en Instalacion por Forma de Pago (Descuento en la factura de instalacion dependiendo la forma de pago aplicable en el contrato )
 * 3)  Promociones Planes Home (Precio Preferencial) :15 % de descuento aplica los tres primeros meses en planes HOME 15/3 y HOME 30/6
 **********************************************************************************/
  procedure p_verificarPromociones(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_verificarPromociones';
    --
  begin
  /*********************************
   * REFERIDOS
   *********************************/
    -- Calcula Puntos de Referidos nuevos
   -- p_calculaPuntosPorReferidos(sysdate, cod_ret, msg_ret);
   -- if(cod_ret!=0)then
   --   null;
   -- end if;
    -- Verifica Perdida de Puntos en el caso de que el referente haya caido en mora
   -- p_verificaPerdidaDePuntos(cod_ret, msg_ret);
   -- if(cod_ret!=0)then
   --   null;
   -- end if;
    -- Activa puntos del Referente en caso de que su referido haya pagado la 3er factura factura del servicio mensual(Factura recurrente automatica)
   -- p_activaPuntos(cod_ret, msg_ret);
   -- if(cod_ret!=0)then
   --   null;
   -- end if;    
    --Genera solicitud de descuento Unico si Referente acumulo el # de puntos definidos como caracteristica del plan para aplicar descuento respectivo
   --  p_generaSolicitud(cod_ret, msg_ret);
   -- if(cod_ret!=0)then
   --    null;
     -- raise errorProcedure;
    --end if;
    -- 
  /*********************************
   * INSTALACION
   *********************************/
   -- 
   -- p_promociones_por_inst(sysdate,cod_ret, msg_ret);
   -- if(cod_ret!=0)then
   --   null;
   -- end if;
    --
   /*********************************
   * PROMOCION PLANES HOME
   *********************************/
    -- 
    p_promociones_HOME(cod_ret, msg_ret);
    if(cod_ret!=0)then
     null;
    end if;
    --
    cod_ret := 0;
    commit;
  exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
      rollback;
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
      rollback;
  end;
/************************************************************************************************************
 * Procedimiento que Calcula los puntos a ser otorgados para los referentes
 * Condiciones:
 * Aplica solo para clientes Netlife que esten al dia en sus pagos
 * Por cada referido que contrate el cliente referente recibira puntos.
 * Si el referido contrata un plan igual o superior que el plan del referente este 
 * recibe #n puntos (Los #n puntos a ganar seran los que tenga configurado el plan como caracteristica de promocion)
 * Si el referido contrata un plan menor que el plan del referente este recibe #n  
 * puntos (Los #n puntos a ganar seran los que tenga configurado el plan como caracteristica de promocion)
 * Si no encuentra definida las caracteristicas para avaluar la creacion de puntos envia mail a marketing indicando que debe 
 * configurarse en los planes dichas caracteristicas "VALOR PTO PLAN INFERIOR", "VALOR PTO PLAN SUPERIOR".
 * Para  realizar la evaluacion entre el plan del referente y el plan del referido toma :
 *     Primer servicio activo del referido
 *     Servicio con mayor valor activo del referente
 * Si Referente entra en mora automaticamente pierde sus puntos
 ***************************************************************************************************************/
  procedure p_calculaPuntosPorReferidos(p_fechaEjecucion timeStamp, cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_calculaPuntosPorReferidos';
    --
    fechaHoy timestamp:= trunc(nvl(p_fechaEjecucion, sysdate));
    fechaManana timestamp := fechaHoy + 1;
    --
    Cursor lc_LeerReferentesReferidos is
     select 
        personRolReferente.id_persona_rol referente_id, 
        nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) referente,
        personRolReferida.id_persona_rol referido_id, 
        nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) referido,
        punto.descripcion_punto, servReferente.valorPlan valorReferente, (servicio.cantidad * servicio.precio_venta) valorReferido,
        servReferente.servicio_id servicioReferente_id,
        servicio.id_servicio servicioReferido_id,
        --punto.id_punto, servicio.producto_id, servicio.plan_id,
        (servHist.fe_creacion) fechActivacion,
        planservicio.nombre_plan, prefijo
      from info_persona_referido referencias
      join info_persona_empresa_rol personRolReferida on personRolReferida.id_persona_rol = referencias.persona_empresa_rol_id
      join info_persona_empresa_rol personRolReferente  on personRolReferente.id_persona_rol  = referencias.ref_persona_empresa_rol_id
      --join info_persona referente  on referente.id_persona         = referencias.referido_id
      join info_persona referente on referente.id_persona        = personRolReferente.persona_id
      join info_persona referida   on referida.id_persona          = personRolReferida.persona_id
      --
      join info_punto punto        on punto.persona_empresa_rol_id = referencias.persona_empresa_rol_id -- personaReferida
      join info_servicio servicio  on servicio.punto_id = punto.id_punto
      join info_servicio_historial servHist on servHist.servicio_id = servicio.id_servicio and servHist.estado = 'Activo'
      --
      join info_plan_cab planservicio on planservicio.id_plan = servicio.plan_id   
      --
      join info_empresa_rol empresarol on empresarol.id_empresa_rol=personRolReferida.empresa_rol_id
      join info_empresa_grupo empresagrup on empresagrup.cod_empresa=empresarol.empresa_cod
      -- mayor servicio referente
      join (
        select persona_empresa_rol_id, valorPlan, 
          (
            select min(id_Servicio) 
            from info_servicio servicio
            join info_punto punto on punto.id_punto = servicio.punto_id
            where punto.persona_empresa_rol_id = serv.persona_empresa_rol_id
              and (servicio.cantidad * servicio.precio_venta) = serv.valorPlan 
            )
          servicio_id
        from ( 
          select punto.persona_empresa_rol_id, max(servicio.cantidad * servicio.precio_venta) valorPlan
          from info_punto punto
          join info_servicio servicio  on servicio.punto_id = punto.id_punto
          join info_servicio_historial servHist on servHist.servicio_id = servicio.id_servicio and servHist.estado = 'Activo'
          where servicio.estado = 'Activo'
          group by persona_empresa_rol_id
        ) serv
    ) servReferente on servReferente.persona_empresa_rol_id = personRolReferente.id_persona_rol
      --
      where servicio.estado = 'Activo' and prefijo in ('MD','TTCO')
      --and servHist.fe_creacion between fechaHoy and fechaManana
      -- para no considerar de nuevo una relacion referente-referido ya agregada
      and not exists(
        select null
        from INFO_PROMOCION_REFERIDO promo
        where promo.referente_id = personRolReferente.id_persona_rol
        and promo.referido_id = personRolReferida.id_persona_rol
      )
      -- para obtener el primer servicio activo del referido
      and servHist.ID_SERVICIO_HISTORIAL = ( 
        select min(hist.ID_SERVICIO_HISTORIAL) 
        from info_servicio_historial hist 
        join info_servicio serv on serv.id_servicio = hist.servicio_id
        join info_punto punto2 on punto2.id_punto = serv.punto_id
        where serv.estado = 'Activo'
        and hist.estado = 'Activo'
        and punto2.persona_empresa_rol_id = personRolReferida.id_persona_rol
      )  
      group by  personRolReferente.id_persona_rol, nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) ,
        personRolReferida.id_persona_rol, nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) ,
        punto.descripcion_punto, servReferente.valorPlan, (servicio.cantidad*servicio.precio_venta),
        servReferente.servicio_id,
        servicio.id_servicio, 
        servHist.fe_creacion,
        planservicio.nombre_plan,
        prefijo      
      ;  
  lr_puntos INFO_PROMOCION_REFERIDO%rowtype;
  --
  contador number:=0;
  puntos number:=0;
  caracteristica varchar2(60);
  texto varchar2(5000);
  ASUNTO VARCHAR2(100);
  CADENA VARCHAR2(300);
  begin
    cod_ret := 20800;
    for datos in lc_LeerReferentesReferidos loop
      lr_puntos.REFERENTE_ID := datos.referente_id;
      lr_puntos.REFERIDO_ID := datos.referido_id;
      cod_ret := 20801;
      MSG_RET := 'Asignado caracteristica ';
      if(datos.valorReferido < datos.valorReferente) then      
        caracteristica := 'PREF VALOR PTO PLAN INFERIOR';
      else
        caracteristica := 'PREF VALOR PTO PLAN SUPERIOR';
      end if;
      --
      cod_ret := 20802;
      MSG_RET := 'Calculando puntos ';
      --Funcion que devuelve valor de la caracteristica del servicio del referido
      lr_puntos.valor_punto := leeValorCaracteristicaPlan(datos.servicioReferido_id, caracteristica);
      --
      IF(lr_puntos.valor_punto IS NULL) THEN        
        cod_ret := 20803;
        MSG_RET := 'Enviando correo no agrega puntos';         
        ASUNTO :=  'TELCOS:PROMOCIONES:Puntos no agregados- No posee configuradas caracteristicas';
        CADENA :=  'La presente es para informarle que existieron problemas al asignar los puntos para las Promociones por no existir caracteristicas definidas en el Plan para ejecutar el calculo en el <strong>Sistema TelcoS+</strong>:';
        promociones.p_enviaCorreo(ASUNTO,CADENA,datos.referente_id,datos.referente,datos.referido_id,datos.referido,datos.servicioReferido_id,datos.nombre_plan,caracteristica,datos.prefijo,cod_ret, msg_ret);                        
      ELSE 
        cod_ret := 20804;
        MSG_RET := 'Asignando referido ';
        lr_puntos.servicio_Referido_id := datos.servicioReferido_id;
        lr_puntos.servicio_Referente_id := datos.servicioReferente_id;
        --FE_CREACION, USR_CREACION, IP_CREACION
        promociones.p_creaPuntos(lr_puntos, cod_ret, msg_ret);
        if (cod_ret!=0) then
          raise errorProcedure;
        end if;
        puntos := puntos + lr_puntos.valor_punto;
        contador := contador + 1;
      END if;
    end loop;
    cod_ret := 0;
    msg_ret := contador || ' referidas. '|| puntos || ' puntos calculados';
    commit;
  exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;

  procedure p_creaPuntos(registro INFO_PROMOCION_REFERIDO%rowtype,
      cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_creaPuntos';
  begin
   cod_ret := 20901;
   msg_ret := 'Ingresando promocion referido';
    INSERT INTO INFO_PROMOCION_REFERIDO (
      ID_PROMOCION_REFERIDO, REFERENTE_ID, REFERIDO_ID, 
      VALOR_PUNTO, SALDO_PUNTO,
      FE_CREACION, USR_CREACION, IP_CREACION, FECHA_ACTIVACION,
      FECHA_ADJUDICADO, DETALLE_SOLICITUD_ID, ESTADO, FECHA_PERDIDO,
      SERVICIO_REFERIDO_ID, SERVICIO_REFERENTE_ID,FECHA_CORREO
    ) VALUES (      
      SEQ_INFO_PROMOCION_REFERIDO.nextval, 
      registro.referente_id, registro.referido_id, 
      registro.valor_punto, registro.valor_punto,      
      sysdate, USUARIO_CREACION, sys_context('USERENV', 'IP_ADDRESS'), null,      
      null, null, 'Pendiente', null,      
      registro.SERVICIO_referido_ID, registro.SERVICIO_referente_ID,null
    );
    cod_ret := 0;
    msg_ret := 'OK';
    commit;
  exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;
/*******************************************************************************************
 * Procedimiento para activar los puntos del cliente referente 
 * Condiciones:
 * Solo aplica para clientes Netlife que esten al dia en sus pagos
 * Los puntos pendientes del referente se activaran solo cuando el cliente referido haya pagado la totalidad
 * de #n facturas de su servicio mensual (Las #n facturas seran las que tenga configurado el plan como caracteristica de promocion)
 * Si no encuentra definida la caracteristica para evaluar la activacion de los puntos envia mail a marketing indicando que debe 
 * configurarse en los planes dicha caracteristica.
  *******************************************************************************************/
  procedure p_activaPuntos(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_activaPuntos';
    --Cursor para sacar los puntos que estan pendientes de activar
    cursor lc_puntosPendientes is
      select *
      from info_promocion_referido promo
      where /*months_between(sysdate, promo.fe_creacion) >= leeValorCaracteristicaPlan(promo.servicio_id, 'PREF TIEMPO FACTURACION REFERIDO')
      and*/ promo.estado = 'Pendiente'
      for update of estado;
      
    --Cursor para sacar los datos para enviar por correo a marketing
    cursor lc_datosPuntosPendientes(c_idpromocion_referido number) is  
      select personRolReferente.id_persona_rol referente_id, 
        nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) referente,
        personRolReferida.id_persona_rol referido_id, 
        nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) referido, 
        punto.descripcion_punto, servicio.id_servicio, planservicio.nombre_plan descripcion_plan, prefijo
     from info_promocion_referido promo     
      join info_persona_empresa_rol personRolReferida on personRolReferida.id_persona_rol = promo.referido_id
      join info_persona_empresa_rol personRolReferente  on personRolReferente.id_persona_rol  = promo.referente_id
      --
      join info_persona referente on referente.id_persona        = personRolReferente.persona_id
      join info_persona referida   on referida.id_persona          = personRolReferida.persona_id
      --      
      join info_punto punto        on punto.persona_empresa_rol_id =personRolReferida.id_persona_rol
      join info_servicio serviciopunto  on serviciopunto.punto_id = punto.id_punto
      join info_servicio servicio on servicio.id_servicio=promo.servicio_referido_id
      --
      join info_plan_cab planservicio on planservicio.id_plan = servicio.plan_id      
      --
      join info_empresa_rol empresarol on empresarol.id_empresa_rol=personRolReferida.empresa_rol_id
      join info_empresa_grupo empresagrup on empresagrup.cod_empresa=empresarol.empresa_cod
      --
       where  promo.id_promocion_referido = c_idpromocion_referido
       
      group by  personRolReferente.id_persona_rol, nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) ,
        personRolReferida.id_persona_rol, nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) ,
        punto.descripcion_punto, 
        servicio.id_servicio,
        planservicio.nombre_plan,promo.estado, prefijo      
     ;
      lr_datosPuntosPendientes lc_datosPuntosPendientes%rowtype;
      
    --Cursor para sacar el numero de facturas pagadas del servicio mensual que tiene el referido y que debe cumplir para activar los
    --puntos del referente , esto en base a la caracteristica "TIEMPO FACTURACION REFERIDO" del plan contratado por el cliente referido
    cursor lc_facturas(c_referido number, c_meses number) is
      select punto.persona_empresa_rol_id,
        count(distinct facturas.mes_emision)
      from info_punto punto 
      join ( 
      -- facturas pagadas
          select pago_det.referencia_id , cab.punto_id, cab.valor_total, 
            to_char(cab.fe_emision, 'yyyymm') mes_emision, sum(pago_det.valor_pago) valor_pago
          from db_financiero.info_pago_det pago_det 
          join info_documento_financiero_cab cab on pago_det.referencia_id = cab.id_documento
          where cab.es_automatica = 'S'
          and cab.recurrente = 'S'
          and cab.tipo_documento_id = 1
          group by pago_det.referencia_id,  cab.punto_id, cab.valor_total, 
            to_char(cab.fe_emision, 'yyyymm')
          having sum(cab.valor_total) <= sum(pago_det.valor_pago)
      ) facturas on punto.id_punto = facturas.punto_id
      where punto.persona_empresa_rol_id = c_referido
      group by punto.persona_empresa_rol_id
      having count(distinct facturas.mes_emision) >= c_meses
      ;
    lr_facturas lc_facturas%rowtype;
    l_meses number;
    contador number:=0;
    puntos number:=0;
    caracteristica varchar2(60);
    texto varchar2(5000);
    ASUNTO VARCHAR2(100);
    CADENA VARCHAR2(300);
  begin
    msg_ret := 'leyendo puntos pendientes';
    caracteristica := 'PREF TIEMPO FACTURACION REFERIDO';   
            
    for puntos in lc_puntosPendientes loop
      l_meses := leeValorCaracteristicaPlan(puntos.servicio_referido_id, caracteristica);
      --Si no tengo caracteristica definida para el plan del referido envio mail informando
      if(l_meses is null) then
      --Valido que se envie un correo por dia
        IF(PUNTOS.FECHA_CORREO IS NULL OR (SYSDATE - PUNTOS.FECHA_CORREO) >= 1) THEN
          --Saco datos para enviar por correo
          open lc_datosPuntosPendientes(puntos.id_promocion_referido);
          fetch lc_datosPuntosPendientes into lr_datosPuntosPendientes;
          close lc_datosPuntosPendientes;    
         cod_ret := 20903;
          MSG_RET := 'Enviando correo no activacion de puntos';         
          ASUNTO :=  'TELCOS:PROMOCIONES:Puntos no activados- No posee configuradas caracteristicas';
          CADENA :=  'La presente es para informarle que existieron problemas al Activar los puntos para las Promociones por no existir caracteristicas definidas en el Plan para ejecutar la activacion de Puntos en el <strong>Sistema TelcoS+</strong>:';
          promociones.p_enviaCorreo(ASUNTO,CADENA,lr_datosPuntosPendientes.referente_id,lr_datosPuntosPendientes.referente,lr_datosPuntosPendientes.referido_id,lr_datosPuntosPendientes.referido,lr_datosPuntosPendientes.id_servicio,lr_datosPuntosPendientes.descripcion_plan,caracteristica,lr_datosPuntosPendientes.prefijo,cod_ret, msg_ret);                                                
            update INFO_PROMOCION_REFERIDO
            set fecha_correo = sysdate
            where current of lc_puntosPendientes;
        END IF;
      else 
        open lc_facturas(puntos.referido_id, l_meses);
        fetch lc_facturas into lr_facturas;
        --  si el cursor devuelve algo se activaria el punto del referente
        if(lc_facturas%found)then
          update INFO_PROMOCION_REFERIDO
          set estado = 'Activo', fecha_activacion = sysdate
          where current of lc_puntosPendientes;
        end if;
        close lc_facturas;
      end if;
    end loop;
    close lc_puntosPendientes;
    COD_RET := 0;
    msg_ret := contador || ' referidas. '|| puntos || ' puntos calculados';
    commit;
  exception 
    when errorProcedure then
      if (lc_puntosPendientes%isopen) then close lc_puntosPendientes; end if;
      if (lc_datosPuntosPendientes%isopen) then close lc_datosPuntosPendientes; end if;
      if(lc_facturas%isopen) then close lc_facturas; end if;
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      if (lc_puntosPendientes%isopen) then close lc_puntosPendientes; end if;
      if (lc_datosPuntosPendientes%isopen) then close lc_datosPuntosPendientes; end if;
      if(lc_facturas%isopen) then close lc_facturas; end if;
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;
  
  /*******************************************************************************************
 * Procedimiento para verificar si el cliente referente ha perdido sus puntos
 * Condiciones:
 * La promocion solo aplica para clientes Netlife que esten al dia en sus pagos
 * 1) Se verifica si el cliente referente posee algun servicio en estado In-Corte en el momento de la ejecucion del script
 * 2) Se verifica  si el cliente referente estuvo en estado In-Corte cuando se activo el servicio de su referido
 *  En ambos casos se cambiara el estado de los puntos que tenga el referente a "Perdido" y se crear� un registro
 * en el historico de los servicios indicando que ha perdido sus puntos por estar en mora.
  *******************************************************************************************/
  procedure p_verificaPerdidaDePuntos(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_verificaPerdidaDePuntos';
    --Cursor que saca los referentes  que tienen puntos pendienres o activos y que se encuentran In-Corte
    cursor lc_referentes is
      select referente_id
      from info_promocion_referido promo
      where promo.estado in ('Pendiente', 'Activo')
      and exists(
        select null
        from info_servicio serv
        join info_punto punto on punto.id_punto = serv.punto_id
        where punto.persona_empresa_rol_id = promo.referente_id
        and serv.estado = promociones.ESTADO_SERVICIO_INCORTE
      )
      group by referente_id;
    
    --Cursor que verifica si referente estuvo en corte durante activacion de su referido 
    cursor lc_tieneActivadoDuranteCorte is
      select rango.referente_id, min(rango.corteInicio) corteInicio, rango.corteFin, 
        pr.id_promocion_referido, pr.servicio_referente_id
      from (
        select referente_id, corteInicio, nvl(corteFin, sysdate) corteFin
        from (
          select punto.persona_empresa_rol_id referente_id, 
                 corteInicio.servicio_id,
                 corteInicio.fe_creacion corteInicio,
            ( select min(corteFin.fe_creacion) corteFin 
              from info_servicio_historial corteFin
              where corteInicio.fe_creacion < corteFin.fe_creacion 
              and corteInicio.servicio_id = corteFin.servicio_id
              and corteFin.estado != promociones.ESTADO_SERVICIO_INCORTE) corteFin
          from info_servicio_historial corteInicio
          join info_servicio servicio on corteInicio.servicio_id = servicio.id_servicio
          join info_punto punto on punto.id_punto = servicio.punto_id
          where corteInicio.estado = promociones.ESTADO_SERVICIO_INCORTE
          )
        ) rango
      join info_promocion_referido pr on pr.referente_id = rango.referente_id
      join info_servicio serv on serv.id_servicio = pr.servicio_referido_id
      where --referente_id = 656
      --and 
      (select min (sh.fe_Creacion) 
      from info_servicio_historial sh 
      where sh.servicio_id = serv.id_servicio
        and sh.estado = 'Activo') between corteInicio and corteFin
      group by rango.referente_id, rango.corteFin, pr.id_promocion_referido, pr.servicio_referente_id
      order by 1, 2, 3;      
     
     --Cursor para tomar referente y actualizar sus puntos a "Perdidos" por estar In-Corte
      cursor lc_puntosPendientesActivos(c_referente number) is    
      select *
      from info_promocion_referido promo
      where promo.estado in ('Pendiente', 'Activo')
        and promo.referente_id = c_referente
      and exists(
        select null
        from info_servicio serv
        join info_punto punto on punto.id_punto = serv.punto_id
        where punto.persona_empresa_rol_id = promo.referente_id
        and serv.estado = ESTADO_SERVICIO_INCORTE
      )
      for update of promo.estado, fecha_perdido;

  begin
    --Se verifica si el cliente referente posee algun servicio en estado In-Corte en el momento de la ejecucion del script
    --Cambio estado de Puntos a Perdido y genero un registro en el Historial del Servicio 
    for referente in lc_referentes loop
      for puntos in lc_puntosPendientesActivos(referente.referente_id) loop
        update INFO_PROMOCION_REFERIDO
        set estado = 'Perdido', fecha_perdido = sysdate
        where current of lc_puntosPendientesActivos;        
      end loop;
      close lc_puntosPendientesActivos;
      -- Por cada servicio del referente que este en corte le genero un registro
      -- en el historial indicando que ha perdido sus puntos por estar en mora
      for servicio in (         
        select serv.id_servicio, serv.estado
        from info_servicio serv
        join info_punto punto on punto.id_punto = serv.punto_id
        where punto.persona_empresa_rol_id = referente.referente_id
        and serv.estado = ESTADO_SERVICIO_INCORTE
        ) loop
        INSERT
        INTO INFO_SERVICIO_HISTORIAL (
            ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION,
            FE_CREACION, IP_CREACION, ESTADO,
            MOTIVO_ID,  OBSERVACION
          ) VALUES (
          SEQ_INFO_SERVICIO_HISTORIAL.nextval, servicio.id_servicio, USUARIO_CREACION,
          sysdate, sys_context('USERENV', 'IP_ADDRESS'), ESTADO_SERVICIO_INCORTE,
          null, 'Perdida de puntos de referidos por estar en mora'
          );
      end loop;
    end loop;
    close lc_referentes;
    --Se verifica  si el cliente referente estuvo en estado In-Corte cuando se activo el servicio de su referido
    --Cambio estado de Puntos a Perdidos y genero un registro en el Historial del Servicio
    for referente in lc_tieneActivadoDuranteCorte loop
      update INFO_PROMOCION_REFERIDO
      set estado = 'Perdido', fecha_perdido = sysdate
      where id_promocion_referido = referente.id_promocion_referido;

      -- Por cada servicio del referente que este en corte le genero un registro
      -- en el historial indicando que ha perdido sus puntos por estar en mora    
      INSERT
      INTO INFO_SERVICIO_HISTORIAL (
          ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION,
          FE_CREACION, IP_CREACION, ESTADO,
          MOTIVO_ID,  OBSERVACION
        ) VALUES (
        SEQ_INFO_SERVICIO_HISTORIAL.nextval, referente.servicio_referente_id, USUARIO_CREACION,
        sysdate, sys_context('USERENV', 'IP_ADDRESS'), ESTADO_SERVICIO_INCORTE,
        null, 'Perdida de puntos de referidos por corte durante activacion'
      );
    end loop;
    close lc_tieneActivadoDuranteCorte;
    commit;
    cod_ret := 0;
    msg_ret := 'OK';
  exception 
    when errorProcedure then
      if(lc_referentes%isopen)then close lc_referentes; end if;
      if(lc_tieneActivadoDuranteCorte%isopen)then close lc_tieneActivadoDuranteCorte; end if;      
      if(lc_puntosPendientesActivos%isopen)then close lc_puntosPendientesActivos; end if;
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      if(lc_referentes%isopen)then close lc_referentes; end if;
      if(lc_tieneActivadoDuranteCorte%isopen)then close lc_tieneActivadoDuranteCorte; end if;      
      if(lc_puntosPendientesActivos%isopen)then close lc_puntosPendientesActivos; end if;
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;
 /****************************************************************************************************************
 * Procedimiento para generar solicitud de descuento en la siguiente facturacion del referente
 * Condiciones:
 * La promocion solo aplica para clientes Netlife que esten al dia en sus pagos
 * Cada #N puntos en estado activo que tenga acumulado el cliente referente recibira un porcentaje de descuento en su facturacion,
 * el valor del porcentaje de descuento esta definido como una caracteristica del plan
 *(Los Puntos del referente pasan a estado Activo solo cuando el cliente referido haya pagado #n facturas de su servicio mensual) 
 * El numero de Puntos y el numero de facturas que debe complirse son Caracteristicas configurables en los planes
 * Por cada Solicitud de Descuento generada se enviara un correo a Facturacion indicando que se otorgo el descuento 
 * respectivo.
  ****************************************************************************************************************/
  procedure p_generaSolicitud(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_generaSolicitud';
    caracteristica varchar2(60):= 'PREF NUMERO PUNTOS REFERIDO';
    caracteristicadesc varchar2(60):= 'PREF PORCENTAJE DESCUENTO';
    --cursor para sacar todos los referentes que tienen puntos activos
    cursor lc_referentesActivos(c_caracteristica varchar2) is
      select referente_id--, servicio_referente_id
        --,nvl(leeValorCaracteristicaPlan(servicio_referido_id, c_caracteristica), -1) puntosReferido
      from info_promocion_referido p
      where p.estado = 'Activo'
      and p.saldo_punto > 0
      --having sum(saldo_punto) >= leeValorCaracteristicaPlan(servicio_referido_id, c_caracteristica)
      group by referente_id--, servicio_referente_id
      --, nvl(promociones.leeValorCaracteristicaPlan(servicio_referido_id, c_caracteristica), -1)
      ;
    --cursor para sacar todos los puntos activos de un referente especifico 
    CURSOR lc_puntosActivos(c_referente number) is
      select *
      from INFO_PROMOCION_REFERIDO p
      where p.estado = 'Activo'
      and p.saldo_punto > 0
      and referente_id = c_referente
      --for update of estado, saldo_punto, fecha_Adjudicado
      ;
     --cursor para sacar la cantidad de puntos activos de un referente
     CURSOR lc_cantidadPuntosActivos(c_referente number) is
      select sum(p.saldo_punto) cantidadPuntosActivos
      from INFO_PROMOCION_REFERIDO p
      where p.estado = 'Activo'
      and p.saldo_punto > 0
      and referente_id = c_referente      
      ;
       lr_cantidadPuntosActivos lc_cantidadPuntosActivos%rowtype;
      
     --Cursor para sacar los datos para enviar por correo a marketing
    cursor lc_datosPuntosActivos(c_idpromocion_referido number) is  
      select personRolReferente.id_persona_rol referente_id, 
        nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) referente,
        personRolReferida.id_persona_rol referido_id, 
        nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) referido, 
        punto.descripcion_punto, servicio.id_servicio, planservicio.nombre_plan descripcion_plan, prefijo
     from info_promocion_referido promo     
      join info_persona_empresa_rol personRolReferida on personRolReferida.id_persona_rol = promo.referido_id
      join info_persona_empresa_rol personRolReferente  on personRolReferente.id_persona_rol  = promo.referente_id
      --
      join info_persona referente on referente.id_persona        = personRolReferente.persona_id
      join info_persona referida   on referida.id_persona          = personRolReferida.persona_id
      --      
      join info_punto punto        on punto.persona_empresa_rol_id =personRolReferida.id_persona_rol
      join info_servicio serviciopunto  on serviciopunto.punto_id = punto.id_punto
      join info_servicio servicio on servicio.id_servicio=promo.servicio_referido_id
      --
      join info_plan_cab planservicio on planservicio.id_plan = servicio.plan_id
      --      
      join info_empresa_rol empresarol on empresarol.id_empresa_rol=personRolReferida.empresa_rol_id
      join info_empresa_grupo empresagrup on empresagrup.cod_empresa=empresarol.empresa_cod
      --
       where promo.id_promocion_referido = c_idpromocion_referido
       
      group by  personRolReferente.id_persona_rol, nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) ,
        personRolReferida.id_persona_rol, nvl(referida.Razon_Social, referida.nombres || ' ' || referida.apellidos) ,
        punto.descripcion_punto, 
        servicio.id_servicio,
        planservicio.nombre_plan,promo.estado,prefijo      
     ;
      lr_datosPuntosActivos lc_datosPuntosActivos%rowtype;
   
    --Cursor para sacar los datos para enviar por correo a Facturacion
    cursor lc_datosReferente(c_referente_id number,c_servicio_referente_id number) is  
      select personRolReferente.id_persona_rol referente_id, 
        nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) referente,      
        punto.descripcion_punto, servicio.id_servicio, planservicio.nombre_plan descripcion_plan, prefijo
     from info_persona_empresa_rol personRolReferente  
      --
      join info_persona referente on referente.id_persona        = personRolReferente.persona_id                
      join info_punto punto        on punto.persona_empresa_rol_id =personRolReferente.id_persona_rol
      join info_servicio servicio  on servicio.punto_id = punto.id_punto
      --
      join info_plan_cab planservicio on planservicio.id_plan = servicio.plan_id
       --
      join info_empresa_rol empresarol on empresarol.id_empresa_rol=personRolReferente.empresa_rol_id
      join info_empresa_grupo empresagrup on empresagrup.cod_empresa=empresarol.empresa_cod
      --
       where personRolReferente.id_persona_rol  = c_referente_id
       and servicio.id_servicio=c_servicio_referente_id
       
      group by  personRolReferente.id_persona_rol, nvl(referente.razon_Social, referente.nombres || ' ' || referente.apellidos) ,       
        punto.descripcion_punto, 
        servicio.id_servicio,
        planservicio.nombre_plan, prefijo     
     ;
      lr_datosReferente lc_datosReferente%rowtype;
    --
    cursor lC_SolicitudPendiente(C_SERVICIO_ID NUMBER) is
      SELECT C.ID_DETALLE_SOLICITUD, 
        C.MOTIVO_ID,
        C.PRECIO_DESCUENTO,
        C.PORCENTAJE_DESCUENTO,
        C.TIPO_DOCUMENTO,
        C.OBSERVACION,
        C.DETALLE_PROCESO_ID,
        C.FE_CREACION,
        D.ID_SOLICITUD_HISTORIAL,
        D.DETALLE_SOLICITUD_ID,
        D.FE_CREACION FE_APROBACION
      FROM INFO_DETALLE_SOLICITUD c
      join INFO_DETALLE_SOL_HIST D on C.ID_DETALLE_SOLICITUD = D.DETALLE_SOLICITUD_ID
      WHERE d.estado = 'Aprobado'
        and c.estado = 'Aprobado'
        and tipo_solicitud_id = TIPO_SOLICITUD_REFE
        AND SERVICIO_ID = C_SERVICIO_ID;
    --
    lR_SolicitudPendiente lC_SolicitudPendiente %rowtype;
    cantidad_puntos_activos number :=0;  
    acumulaPuntos number :=0;
    puntosReferidos number := null;
    procentajeDescuento number := null;
    numero_solicitud number;
    numero_hist_solicitud number;
    texto varchar2(5000);
    ASUNTO VARCHAR2(200);
    CADENA VARCHAR2(300);
  begin
    cod_ret := 1;
    msg_ret := 'Leyendo referentes';
 
    for lr_referente in lc_referentesActivos(caracteristica) loop    
      --
      msg_ret := 'verificar caracteristica';
      acumulaPuntos :=0;
      cod_ret := 2;
      msg_ret := 'Leyendo puntos';
      --          
      open lc_cantidadPuntosActivos(lr_referente.referente_id);
      fetch lc_cantidadPuntosActivos into lr_cantidadPuntosActivos;
      
      if(lc_cantidadPuntosActivos%found)then
         --cantidad de puntos activos que tiene un cliente referente
         cantidad_puntos_activos := lr_cantidadPuntosActivos.cantidadPuntosActivos;
      end if;
      close lc_cantidadPuntosActivos;  
      
      cod_ret := 3;
      msg_ret := 'Leyendo Cantidad de puntos';     
      
      for lr_puntosActivos in lc_puntosActivos(lr_referente.referente_id) loop          
         cod_ret := 4;
         msg_ret := 'Leyendo puntos Activos';           
        --puntosReferidos := lr_referente.puntosReferido;
        --Funcion que devuelve valor de la caracteristica del servicio del referido
        puntosReferidos := promociones.leeValorCaracteristicaPlan(lr_puntosActivos.servicio_referido_id, caracteristica);
        if(puntosReferidos is null)then
           --Saco datos para enviar por correo indicando que no hay configuradas caracteristicas para el plan del referido
               cod_ret := 432;
           open lc_datosPuntosActivos(lr_puntosActivos.id_promocion_referido);
           fetch lc_datosPuntosActivos into lr_datosPuntosActivos;
           close lc_datosPuntosActivos;   
           
           cod_ret := 21000;
           MSG_RET := 'Enviando correo no adjudica puntos';         
           ASUNTO :=  'TELCOS+:PROMOCIONES:Puntos no adjudicados, no es posible generar Solicitud de Descuento- No posee configuradas caracteristicas';
           CADENA :=  'La presente es para informarle que existieron problemas al adjudicar los puntos para las Promociones con lo cual no es posible generar la Solicitud de Descuento por no existir caracteristicas definidas en el Plan para ejecutar el calculo en el <strong>Sistema TelcoS+</strong>:';        
           promociones.p_enviaCorreo(ASUNTO,CADENA,lr_datosPuntosActivos.referente_id,lr_datosPuntosActivos.referente,lr_datosPuntosActivos.referido_id,lr_datosPuntosActivos.referido,lr_datosPuntosActivos.id_servicio,lr_datosPuntosActivos.descripcion_plan,caracteristica,lr_datosPuntosActivos.prefijo,cod_ret, msg_ret);                                                          
        else  
             cod_ret := 5;
             msg_ret := 'Leyendo descuento';  
            --Saco caracteristica "PORCENTAJE DESCUENTO" para generar la solicitud con el descuento respectivo                  
            procentajeDescuento := promociones.leeValorCaracteristicaPlan(lr_puntosActivos.servicio_referido_id, caracteristicadesc);
            if(procentajeDescuento is null)then
               --Saco datos para enviar por correo indicando que no hay configuradas caracteristicas para el plan del referido
               cod_ret := 54;
               open lc_datosPuntosActivos(lr_puntosActivos.id_promocion_referido);
               fetch lc_datosPuntosActivos into lr_datosPuntosActivos;
               close lc_datosPuntosActivos;            
               cod_ret := 21100;
               MSG_RET := 'Enviando correo no genera solicitud de descuento';         
               ASUNTO :=  'TELCOS+:PROMOCIONES:Puntos no adjudicados, no es posible generar Solicitud de Descuento- No posee configuradas caracteristicas';
               CADENA :=  'La presente es para informarle que existieron problemas al adjudicar los puntos para las Promociones por no existir %descuento configurado con lo cual no es posible generar la Solicitud de Descuento por no existir caracteristicas definidas en el Plan para ejecutar el calculo en el <strong>Sistema TelcoS+</strong>:';        
               promociones.p_enviaCorreo(ASUNTO,CADENA,lr_datosPuntosActivos.referente_id,lr_datosPuntosActivos.referente,lr_datosPuntosActivos.referido_id,lr_datosPuntosActivos.referido,lr_datosPuntosActivos.id_servicio,lr_datosPuntosActivos.descripcion_plan,caracteristicadesc,lr_datosPuntosActivos.prefijo,cod_ret, msg_ret);                                                          
            else
               cod_ret := 6;
               msg_ret := 'Verifico Solicitud existente';  
              -- ANTES DE VERIFICAR ALGO CONFIRMAMOS SI LA SOLICITUD SE VA A PODER GENERAR
              OPEN lc_SolicitudPendiente(lr_puntosActivos.servicio_referente_id);
              FETCH lc_SolicitudPendiente INTO lR_SolicitudPendiente;
               
               cod_ret := 7;
               msg_ret := 'Verifica solicitud se podra generar';  
              if(lc_SolicitudPendiente%notfound)then
                acumulaPuntos := acumulaPuntos + lr_puntosActivos.saldo_punto;
                cod_ret := 8;
                msg_ret := 'cantidad_puntos_activos= '|| cantidad_puntos_activos  ||'  puntosReferidos=  '||puntosReferidos
                ||' acumulaPuntos:' || acumulaPuntos;               
                --acumulador de puntos activos del cliente referente 
                --Si la cantidad de total de puntos activos que posee un Referente es mayor o igual a NUMERO PUNTOS REFERIDO 
                --configurados en la caracteristica del plan
                if(cantidad_puntos_activos >= puntosReferidos) then                
                cod_ret := 81;
                    if(acumulaPuntos >= puntosReferidos) then                 
                       --
                       cod_ret := 3;
                       msg_ret := 'Ingresando detalle de solicitud';
                       numero_solicitud  := SEQ_INFO_DETALLE_SOLICITUD.nextval;
                       INSERT
                        INTO INFO_DETALLE_SOLICITUD (
                         ID_DETALLE_SOLICITUD, SERVICIO_ID,     TIPO_SOLICITUD_ID,
                         MOTIVO_ID,        USR_CREACION,        FE_CREACION,
                         PRECIO_DESCUENTO, PORCENTAJE_DESCUENTO,TIPO_DOCUMENTO,
                         OBSERVACION,      ESTADO,        USR_RECHAZO,
                         FE_RECHAZO,       DETALLE_PROCESO_ID,  FE_EJECUCION
                       ) VALUES (                        
                        numero_solicitud, lr_puntosActivos.servicio_referente_id, TIPO_SOLICITUD_REFE,                        
                        1, USUARIO_CREACION, sysdate,                        
                        null, procentajeDescuento, null,                        
                        'Por cumplimiento de puntos de referidos', 'Aprobado', null,                        
                        null, null, null);
                        cod_ret := 4;
                        msg_ret := 'Adjudicando puntos con saldo';
                        --guardo Historico de la Solicitud generada
                        numero_hist_solicitud  := SEQ_INFO_DETALLE_SOL_HIST.nextval;
                       cod_ret := 4124;
                        INSERT INTO info_detalle_sol_hist(
                        ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,
                        FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION, 
                        USR_CREACION, FE_CREACION, IP_CREACION, MOTIVO_ID
                        ) VALUES(numero_hist_solicitud,numero_solicitud,'Aprobado',
                        null, null,'Por cumplimiento de puntos de referidos',
                        USUARIO_CREACION, sysdate, sys_context('USERENV', 'IP_ADDRESS'),1);
                        --actualizo estado y valor de puntos
                        cod_ret := 612;
                        update INFO_PROMOCION_REFERIDO
                        set fecha_Adjudicado = sysdate, saldo_punto = acumulaPuntos - puntosReferidos,
                        estado = decode( acumulaPuntos - puntosReferidos, 0 , 'Adjudicado', estado),
                        detalle_solicitud_id = numero_solicitud
                        where ID_PROMOCION_REFERIDO = lr_puntosActivos.ID_PROMOCION_REFERIDO;
                        --construyo salida de mail para enviar a facturacion
                        cod_ret := 6;
                        open lc_datosReferente(lr_referente.referente_id,lr_puntosActivos.servicio_referente_id);
                        fetch lc_datosReferente into lr_datosReferente;
                        close lc_datosReferente;           
                        cod_ret := 7;
                        MSG_RET := 'Enviando correo a facturacion indicando solicitud creada con '|| procentajeDescuento ||' de descuento';         
                        ASUNTO :=  'TELCOS:FACTURACION:Clientes que aplicaron Promocion por Referidos';
                        CADENA :=  'La presente es para informarle que se adjudicaron los puntos por promocion de referidos y al cliente se le genero en el <strong>Sistema TelcoS+</strong> una Solicitud #'|| numero_solicitud ||' con el  '|| procentajeDescuento ||' % de descuento en su facturacion : ';
                        promociones.p_enviaCorreoFacturacion(ASUNTO,CADENA,lr_datosReferente.referente_id,lr_datosReferente.referente,lr_datosReferente.id_servicio,lr_datosReferente.descripcion_plan,lr_datosReferente.prefijo,cod_ret, msg_ret); 
                        exit;
                    else
                       cod_ret := 52;
                       msg_ret := 'Adjudicando puntos sin saldo';
                       update INFO_PROMOCION_REFERIDO
                       set estado = 'Adjudicado', fecha_Adjudicado = sysdate, saldo_punto = 0, detalle_solicitud_id = numero_solicitud
                       where ID_PROMOCION_REFERIDO = lr_puntosActivos.ID_PROMOCION_REFERIDO;
                    end if;
                    --
                end if;
              end if;
              close lc_SolicitudPendiente;
            end if;             
            --
        end if;
     end loop; 
   end loop;   
      --null;
    cod_ret := 0;
    msg_ret := 'Terminado';
    commit;
  exception 
    when errorProcedure then 
     if(lc_referentesActivos%isopen)then close lc_referentesActivos; end if;
      if(lc_puntosActivos%isopen)then close lc_puntosActivos; end if;
      if(lc_datosReferente%isopen)then close lc_datosReferente; end if;
      if(lc_cantidadPuntosActivos%isopen)then close lc_cantidadPuntosActivos; end if;
      if(lc_SolicitudPendiente%isopen) then close lc_SolicitudPendiente; end if;
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      if(lc_referentesActivos%isopen)then close lc_referentesActivos; end if;
      if(lc_puntosActivos%isopen)then close lc_puntosActivos; end if;
      if(lc_datosReferente%isopen)then close lc_datosReferente; end if;
      if(lc_cantidadPuntosActivos%isopen)then close lc_cantidadPuntosActivos; end if; 
      if(lc_SolicitudPendiente%isopen) then close lc_SolicitudPendiente; end if;      
      IF COD_RET = 0 THEN COD_RET := 100000; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;
/****************************************************************************************************************
 * Funcion que devuelve el valor que tiene configurada una caracteristica para un servicio especifico.
 * parametros que recibe: Servicio y Caracteristica 
 * Parametro que devuelve: Valor
  ****************************************************************************************************************/ 
  function leeValorCaracteristicaPlan(p_servicio number, p_caracteristica varchar2) return number is
    Cursor lc_Caracteristica is
      SELECT planServCarac.VALOR
      FROM INFO_SERVICIO_PLAN_CARACT planServCarac
      join INFO_PLAN_CARACTERISTICA planCarac on planCarac.ID_PLAN_CARACTERISITCA = planServCarac.PLAN_CARACTERISTICA_ID
      join admi_caracteristica carac on carac.ID_CARACTERISTICA = planCarac.CARACTERISTICA_ID
      where planServCarac.SERVICIO_ID = p_servicio
        and carac.descripcion_caracteristica = p_caracteristica
        and carac.tipo = 'PROMOCION'
        and planServCarac.ESTADO = 'Activo';
    --
    lr_Caracteristica lc_Caracteristica%rowtype;
  begin
    open lc_Caracteristica;
    fetch lc_Caracteristica into lr_Caracteristica;
    close lc_Caracteristica;        
     return to_number(replace(lr_Caracteristica.VALOR,',','.'),'9999.99');
  exception 
    when others then
      if (lc_Caracteristica%isopen) then close lc_Caracteristica; end if;
      return null;
  end;
  
 /****************************************************************************************************************
 * Procedimiento para envio de mail 
 * Condiciones:
 * Se envia mail cuando no encuentra caracteristicas definidas para el calculo de puntajes y adjudicacion de puntos
 * en promociones de referidos
 *****************************************************************************************************************/
  procedure p_enviaCorreo(ASUNTO varchar2, CADENA varchar2,referente_id number,referente varchar2,referido_id number,
      referido varchar2,servicioReferido_id number,nombre_plan varchar2,caracteristica varchar2,prefijo varchar2,
      cod_ret out number, msg_ret out varchar2) is 
      errorProcedure exception;
      nameProcedure varchar2(60) := 'PROMOCIONES.p_enviaCorreo';
      texto varchar2(3000);
      correo_recibe varchar2(100);
      desc_empresa varchar2(20);
  begin   
    if(prefijo ='TTCO') then
          correo_recibe:=CORREO_RECIBE_TTCO;
          desc_empresa:='Transtelco';
    else  if(prefijo ='MD') then
              correo_recibe:=CORREO_RECIBE_MD;
              desc_empresa:='Megadatos';
          end if;   
    end if;
   texto := '<html>  <head>    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">  </head>  <body>    
               <table align="center" width="100%" cellspacing="0" cellpadding="5"><tr><td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">            
               <img alt=""  src="http://images.telconet.net/others/telcos/logo.png"/>        
               </td></tr>      
               <tr><td style="border:1px solid #6699CC;">          
               <table width="100%" cellspacing="0" cellpadding="5">        
               <tr><td colspan="2"><table cellspacing="0" cellpadding="2">
                 <tr>
                 <td colspan="2">Estimado usuario:</td>
                 </tr>
                 <tr><td></td></tr>
                 <tr>
               <td colspan="2">' || CADENA || '</td>
                 </tr>
                 <tr>
               <td><strong>Referente:</strong></td>
               <td  align="left">'|| referente_id || '-' || referente || '</td>
                 </tr>
                 <tr>
               <td><strong>Referido:</strong></td>
               <td  align="left">'|| referido_id  || '-' || referido  || '</td>
                 </tr>
                 <tr>
               <td><strong>Servicio:</strong></td>
               <td  align="left">'|| servicioReferido_id  || '-' || nombre_plan || '</td>
                 </tr>
                 <tr>
               <td><strong>Motivo:</strong></td>
              <td  align="left"> Caracteristica <b>'|| caracteristica ||  '</b> no esta definida para el servicio</td>
                </tr>              
                <tr><td></td></tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2">Atentamente,</td>
                </tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2"><strong>Sistema TelcoS+</strong></td>
                </tr>
                </table></td></tr><tr><td colspan="2"><br></td></tr></table></td></tr><tr><td></td></tr><tr><td><strong><font size="2" face="Tahoma">'|| desc_empresa  ||'</font></strong></p></td></tr></table></body></html>';  
                              
              UTL_MAIL.SEND (sender => CORREO_ENVIA,
                  recipients      => correo_recibe,                  
                  subject         => ASUNTO,
                  message         => texto,
                  mime_type       => 'text/html; charset=UTF-8'
                 );            
    commit;
    cod_ret := 0;
   exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;  
  /************************************************************************************************************
 * Procedimiento para envio de mail 
 * Condiciones:
 * Se envia mail cuando se genera una solicitud de descuento Unico en la Facturacion del Cliente este correo es 
 * enviado a facturacion
 ***************************************************************************************************************/
        
 procedure p_enviaCorreoFacturacion(ASUNTO varchar2, CADENA varchar2,referente_id number,referente varchar2,
      id_servicio number,nombre_plan varchar2, prefijo varchar2,cod_ret out number, msg_ret out varchar2) is 
      errorProcedure exception;
      nameProcedure varchar2(60) := 'PROMOCIONES.p_enviaCorreoFacturacion';
      texto varchar2(3000);
      correo_recibe varchar2(100);
      desc_empresa varchar2(20);
  begin   
    if(prefijo ='TTCO') then
          correo_recibe:=CORREO_RECIBE_TTCO;
          desc_empresa:='Transtelco';
    else  if(prefijo ='MD') then
              correo_recibe:=CORREO_RECIBE_MD;
              desc_empresa:='Megadatos';
          end if;   
    end if;
   texto := '<html>  <head>    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">  </head>  <body>    
               <table align="center" width="100%" cellspacing="0" cellpadding="5"><tr><td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">            
               <img alt=""  src="http://images.telconet.net/others/telcos/logo.png"/>        
               </td></tr><tr>        
               <td style="border:1px solid #6699CC;">          
               <table width="100%" cellspacing="0" cellpadding="5">        
               <tr><td colspan="2"><table cellspacing="0" cellpadding="2">
                 <tr>
                 <td colspan="2">Estimado usuario:</td>
                 </tr>
                 <tr><td></td></tr>
                 <tr>
               '||addTD(CADENA , null, 2, 0)|| '
                 </tr>
                 <tr>
               '||addTD('Referente' , null, null, 1)|| '
               '||addTD( referente_id || '-' || referente , 'left', null)|| '
                  </tr>
                 <tr>
               '||addTD('Servicio' , null, null, 1)|| '
               '||addTD( id_servicio  || '-' || nombre_plan , 'left', null)|| '
                 </tr>                                 
                <tr><td></td></tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2">Atentamente,</td>
                </tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2"><strong>Sistema TelcoS+</strong></td>
                </tr>
                </table></td></tr><tr><td colspan="2"><br></td></tr></table>
              </td></tr><tr><td></td></tr><tr><td><strong><font size="2" face="Tahoma">'|| desc_empresa  ||'</font></strong></p></td></tr></table></body></html>';  
                            
              UTL_MAIL.SEND (sender => CORREO_ENVIA,
                  recipients      => correo_recibe,                  
                  subject         => ASUNTO,
                  message         => texto,
                  mime_type       => 'text/html; charset=UTF-8'
                 );            
    commit;
    cod_ret := 0;
   exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;  
  
  function addTD(texto varchar2, align varchar2:=null,colspan number:=null, bold number:=0) return varchar2 is
    l_align   varchar2(2000) := null;
    l_colspan varchar2(2000) := null;
    l_texto varchar(2000):=texto;
  begin
    if(colspan is not null) then
      l_colspan := 'colspan="'||colspan||'"'; 
    end if;
    if(align is not null) then
      l_align := 'align="'||align||'"'; 
    end if;
    if(bold=1)then
      l_texto := '<strong>'||texto||'</strong>';
    end if;
    return '<td '||l_align||' '||l_colspan||' >'||l_texto||'</td>';
  end;
  /***********************************************************************************
  * Prodecimento que verifica si existen promociones en Instalacion por forma de Pago
  *************************************************************************************/
  procedure p_promociones_por_inst(p_fechaEjecucion timeStamp,cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_promociones_por_inst';  
    --
    fechaHoy timestamp:= trunc(nvl(p_fechaEjecucion, sysdate));
    fechaManana timestamp := fechaHoy + 1;
    --
    Cursor lc_LeerPromoFormaPago is
       select per.id_persona,pemprol.id_persona_rol,pto.id_punto,pto.login,
        serv.id_servicio servicio_id,servHist.fe_creacion as fecha_activacion,
        tipo_orden,serv.plan_id,prod.id_producto,nombre_plan,descripcion_producto,
        instalacion,serv.cantidad, serv.precio_venta,
        per.identificacion_cliente,per.nombres, per.apellidos, per.razon_social, pemprol.estado estadoPerEmRol,
        id_contrato, numero_contrato, forma_pago_id, descripcion_forma_pago, cont.estado estadoContrato,
        contfp.id_datos_pago,tipcta.descripcion_cuenta, tipcta.es_tarjeta,
        tipcta.id_tipo_cuenta tipo_cuenta_id, sp1.plan_caracteristica_id
        from info_persona per
         join info_persona_empresa_rol pemprol on per.id_persona=pemprol.persona_id
         join info_empresa_rol emprol on pemprol.empresa_rol_id=emprol.id_empresa_rol
         join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa
         --
         join info_contrato cont on pemprol.id_persona_rol=cont.persona_empresa_rol_id
         join admi_forma_pago fp on cont.forma_pago_id=fp.id_forma_pago
         left join info_contrato_forma_pago contfp on contfp.contrato_id=cont.id_contrato
         left join admi_tipo_cuenta tipcta on tipcta.id_tipo_cuenta=contfp.tipo_cuenta_id
         --
         join info_punto pto on pemprol.id_persona_rol= pto.persona_empresa_rol_id
         join info_servicio serv on pto.id_punto=serv.punto_id
         join info_servicio_historial servHist on servHist.servicio_id = serv.id_servicio and servHist.estado = 'Activo'    
         join info_plan_cab planc on planc.id_plan=serv.plan_id
         join info_plan_det pland on planc.id_plan=pland.plan_id
         join admi_producto prod on  pland.producto_id=prod.id_producto and (instalacion is not null and instalacion!=0)
         JOIN INFO_SERVICIO_PLAN_CARACT SP1 ON Serv.ID_SERVICIO = SP1.SERVICIO_ID
         JOIN info_plan_caracteristica PC1 ON pc1.id_plan_caracterisitca = sp1.plan_caracteristica_id
         JOIN ADMI_CARACTERISTICA C1 ON C1.ID_CARACTERISTICA = pc1.caracteristica_id AND c1.descripcion_caracteristica = 'PINST APLICA PROMOCION'
         where --empgrup.cod_empresa='09' and 
         serv.estado='Activo'  
          and tipo_orden='N' and prefijo in ('MD')
         -- para obtener el primer servicio activo
          and servHist.ID_SERVICIO_HISTORIAL = ( 
                select min(hist.ID_SERVICIO_HISTORIAL) 
                   from info_servicio_historial hist 
                   where hist.estado = 'Activo'      
                   and hist.servicio_id = serv.id_servicio
          )
        and not exists (
          select null
          from INFO_PROMOCION_INSTALACION pi
          where pi.servicio_id = serv.id_servicio
        )
        --and servHist.fe_creacion >= fechaHoy and servHist.fe_creacion < fechaManana
      group by (per.id_persona,pemprol.id_persona_rol,pto.id_punto,pto.login,
         serv.id_servicio,tipo_orden,serv.plan_id,prod.id_producto,nombre_plan,descripcion_producto,
         instalacion,serv.cantidad, serv.precio_venta,servHist.fe_creacion,
         per.identificacion_cliente,per.nombres, per.apellidos, per.razon_social, pemprol.estado,
         id_contrato, numero_contrato, forma_pago_id, descripcion_forma_pago, cont.estado,
         contfp.id_datos_pago,tipcta.descripcion_cuenta, tipcta.es_tarjeta,
        tipcta.id_tipo_cuenta, sp1.plan_caracteristica_id)
         order by per.id_persona;   
       --
    contador number:=0;
    L_NUMERO_PROMOCION_INST number;
    L_porcentaje_Descuento  number;
    L_SEQ_INFO_DETALLE_SOLICITUD number;
    l_seq_INFO_PROMOCION_INSTAL number;
    l_numero_hist_solicitud number;
    forma_pago number:=0;
    caracteristica varchar2(60):='FORMA PAGO';
    texto varchar2(5000);
    ASUNTO VARCHAR2(100);
    CADENA VARCHAR2(300);
    cursor lC_SolicitudPendienteInst(C_SERVICIO_ID NUMBER) is
      SELECT C.ID_DETALLE_SOLICITUD, 
        C.MOTIVO_ID,
        C.PRECIO_DESCUENTO,
        C.PORCENTAJE_DESCUENTO,
        C.TIPO_DOCUMENTO,
        C.OBSERVACION,
        C.DETALLE_PROCESO_ID,
        C.FE_CREACION,
        D.ID_SOLICITUD_HISTORIAL,
        D.DETALLE_SOLICITUD_ID,
        D.FE_CREACION FE_APROBACION
      FROM INFO_DETALLE_SOLICITUD c
      join INFO_DETALLE_SOL_HIST D on C.ID_DETALLE_SOLICITUD = D.DETALLE_SOLICITUD_ID
      WHERE d.estado = 'Aprobado'
        and c.estado = 'Aprobado'
        and tipo_solicitud_id = TIPO_SOLICITUD_INST
        AND SERVICIO_ID = C_SERVICIO_ID;
    --
    lR_SolicitudPendienteInst lC_SolicitudPendienteInst %rowtype;
    cursor lC_porcentajeFormaPago(c_plan_caracteristica_id number, c_forma_pago_id number, c_tipo_cuenta_id number) is
      SELECT PORCENTAJE_DESCUENTO
      FROM INFO_PLAN_CARACT_FORMA_PAGO 
      where PLAN_CARACTERISTICA_ID = c_plan_caracteristica_id
        and FORMA_PAGO_ID = c_forma_pago_id
        and nvl(TIPO_CUENTA_ID, -1) = nvl(c_tipo_cuenta_id, -1);
  begin     
    for datos in lc_LeerPromoFormaPago loop
      L_porcentaje_Descuento := null;
      OPEN lc_SolicitudPendienteInst(DATOS.servicio_id);
      FETCH lc_SolicitudPendienteInst INTO lR_SolicitudPendienteInst;
      if(lc_SolicitudPendienteInst%notfound)then
        cod_ret := 22000;
        MSG_RET := 'Verificando forma de pago ';
        --
        open lC_porcentajeFormaPago(datos.plan_caracteristica_id, datos.forma_pago_id, datos.tipo_cuenta_id);
        fetch lC_porcentajeFormaPago into L_porcentaje_Descuento;
        if(lC_porcentajeFormaPago%notfound)then
          L_porcentaje_Descuento := null;
        end if;
        close lC_porcentajeFormaPago;
        
        IF(L_porcentaje_Descuento IS NOT NULL) THEN        
           cod_ret := 3;
           msg_ret := 'Ingresando detalle de solicitud';
           L_SEQ_INFO_DETALLE_SOLICITUD  := SEQ_INFO_DETALLE_SOLICITUD.nextval;
          l_seq_INFO_PROMOCION_INSTAL := seq_INFO_PROMOCION_INSTALACION.nextval;
           INSERT
              INTO INFO_DETALLE_SOLICITUD (
                  ID_DETALLE_SOLICITUD, SERVICIO_ID,     TIPO_SOLICITUD_ID,
                  MOTIVO_ID,        USR_CREACION,        FE_CREACION,
                   PRECIO_DESCUENTO, PORCENTAJE_DESCUENTO,TIPO_DOCUMENTO,
                   OBSERVACION,      ESTADO,        USR_RECHAZO,
                   FE_RECHAZO,       DETALLE_PROCESO_ID,  FE_EJECUCION
               ) VALUES (                        
               --ID_DETALLE_SOLICITUD, SERVICIO_ID,     TIPO_SOLICITUD_ID,
                L_SEQ_INFO_DETALLE_SOLICITUD, DATOS.servicio_id, TIPO_SOLICITUD_INST,
               --MOTIVO_ID,        USR_CREACION,        FE_CREACION,
                1, USUARIO_CREACION, sysdate,
               --PRECIO_DESCUENTO, PORCENTAJE_DESCUENTO,TIPO_DOCUMENTO,
                DATOS.instalacion, L_porcentaje_Descuento, null,                        
               --OBSERVACION,      ESTADO,        USR_RECHAZO,
               'Por promocion instalacion #promo:'||l_seq_INFO_PROMOCION_INSTAL, 'Aprobado', null,                        
               --FE_RECHAZO,       DETALLE_PROCESO_ID,  FE_EJECUCION
                null, null, null);
                cod_ret := 4;
                msg_ret := 'generando historia de solicitud';
                --guardo Historico de la Solicitud generada
                l_numero_hist_solicitud  := SEQ_INFO_DETALLE_SOL_HIST.nextval;
             INSERT INTO info_detalle_sol_hist(
               ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,
               FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION, 
               USR_CREACION, FE_CREACION, IP_CREACION, MOTIVO_ID
             ) VALUES(
               --ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,
                l_numero_hist_solicitud,L_SEQ_INFO_DETALLE_SOLICITUD,'Aprobado',
               --FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION, 
                null, null,'Por promocion instalacion #promo:'||l_seq_INFO_PROMOCION_INSTAL,
               --USR_CREACION, FE_CREACION, IP_CREACION, MOTIVO_ID
               USUARIO_CREACION, sysdate, sys_context('USERENV', 'IP_ADDRESS'),1);
               --
          cod_ret := 22100;
          INSERT INTO INFO_PROMOCION_INSTALACION
            (
              ID_PROMOCION_INST,  PERSONA_EMPRESA_ROL_ID,    SERVICIO_ID,
              FORMA_PAGO_ID,    TIPO_CUENTA_ID,    PORCENTAJE_DESCUENTO,
              DETALLE_SOLICITUD_ID,    FE_CREACION,    USR_CREACION,    IP_CREACION
            ) VALUES (
              --ID_PROMOCION_INST,  PERSONA_EMPRESA_ROL_ID,    SERVICIO_ID,
              l_seq_INFO_PROMOCION_INSTAL, datos.id_persona_rol, datos.servicio_id,
              --FORMA_PAGO_ID,    TIPO_CUENTA_ID,    PORCENTAJE_DESCUENTO,
              datos.forma_pago_id, datos.tipo_Cuenta_id, L_porcentaje_Descuento,
              --DETALLE_SOLICITUD_ID,    FE_CREACION,    USR_CREACION,    IP_CREACION
              L_SEQ_INFO_DETALLE_SOLICITUD, sysdate, USUARIO_CREACION, sys_context('USERENV', 'IP_ADDRESS')
            );
          --
        end if;
      
      END IF;
      close lc_SolicitudPendienteInst;
    end loop;  
        
    commit;
    cod_ret := 0;
    msg_ret := 'OK';
    exception 
     when errorProcedure then
       if(lc_SolicitudPendienteInst%isopen) then close lc_SolicitudPendienteInst; end if;      
       Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
     WHEN OTHERS THEN
      if(lc_SolicitudPendienteInst%isopen) then close lc_SolicitudPendienteInst; end if;      
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;
  /************************************************************************************************
   * PROCEDIMIENTO QUE GENERA LAS SOLICITUDES DE PROMOCIONES PARA PLANES HOME SE CONSIDERA QUE LOS 
   * SERVICIOS QUE POSEEN ESTA PROMO DEBEN TENER CONFIGURADAS LAS CARACTERISTICAS:
   * PHOM FECHA INICIO, PHOM PORCENTAJE DESCUENTO, PHOM NUMERO DE MESES
   * SOLO GENERAN  SOLICITUD DE PROMO LOS SERVICIOS QUE CUMPLEN:
   * 1) ESTADO DEL SERVICIO ACTIVO
   * 2) POSEER LAS 3 CARACTERISTICAS PROMOCIONALES EN ESTADO ACTIVO (PHOM FECHA INICIO, 
   *    PHOM PORCENTAJE DESCUENTO, PHOM NUMERO DE MESES)
   * 3) QUE EL TIPO DE ORDEN REGISTRADA EN EL SERVICIO SEA : NUEVO , NO SE CONSIDERAN LOS TRASLADOS
   *    NI REHUBICACIONES
   * 4) QUE NO EXISTA UNA PROMO PARA EL MISMO SERVICIO Y PLAN EN ESTADO FINALIZADA ES DECIR SI SE CONSIDERAN 
   *    PROMOCIONES PARA CAMBIOS DE PLANES REALIZADOS PERO HACIA PLANES PROMO DIFERENTES, SI UN CLIENTE YA CUMPLIO
   *    UNA PROMO CON UN PLAN ESPECIFICO ESTA NO SE  VUELVE A DAR CON EL MISMO PLAN PERO SI CON OTRO PLAN PROMO.
   ************************************************************************************************/
  procedure p_promociones_HOME(cod_ret out number, msg_ret out varchar2) is
    errorProcedure exception;
    nameProcedure varchar2(60) := 'PROMOCIONES.p_promociones_HOME';     
    texto varchar2(5000);
    ASUNTO VARCHAR2(200);
    CADENA VARCHAR2(300);
    
    --Cursor para sacar todos los servicios que entran en el proceso de promociones Home
    CURSOR LCUR_DATOS IS
    SELECT SP1.ID_SERVICIO_PLAN_CARACT,
        SP1.SERVICIO_ID,
        S.PUNTO_ID,
        SP1.PLAN_CARACTERISTICA_ID,
        SP1.VALOR,
        S.PLAN_ID,       
        SP1.FE_CREACION,
        sp1.ESTADO,
        TO_DATE(SP1.VALOR, 'dd/mm/yyyy') FECHA_INICIO_PROMO,
        P.PERSONA_EMPRESA_ROL_ID      
      FROM INFO_SERVICIO S
      JOIN INFO_SERVICIO_PLAN_CARACT SP1 ON S.ID_SERVICIO = SP1.SERVICIO_ID and SP1.ESTADO='Activo'
      JOIN INFO_PUNTO P ON P.ID_PUNTO = S.PUNTO_ID
      JOIN INFO_PERSONA_EMPRESA_ROL PER ON PER.ID_PERSONA_ROL = P.PERSONA_EMPRESA_ROL_ID      
      JOIN INFO_PLAN_CARACTERISTICA PC1 ON PC1.ID_PLAN_CARACTERISITCA = SP1.PLAN_CARACTERISTICA_ID   
      and PC1.PLAN_ID=S.PLAN_ID
      join INFO_PLAN_CAB PLANC on PLANC.ID_PLAN=S.PLAN_ID    
      JOIN ADMI_CARACTERISTICA C1 ON C1.ID_CARACTERISTICA = PC1.CARACTERISTICA_ID 
      AND C1.DESCRIPCION_CARACTERISTICA = 'PHOM FECHA INICIO'
      WHERE NOT EXISTS (
        SELECT NULL
        FROM INFO_PROMOCION_PLAN PP
        WHERE pp.SERVICIO_ID = s.ID_SERVICIO
        AND PP.PLAN_ID = s.plan_id
        AND NUMERO_MESES = NUMERO_SOLICITUDES_GENERADAS
        AND ESTADO = 'Finalizada'
      ) AND S.TIPO_ORDEN IN ('N','T') and S.ESTADO in ('Activo')   
      --Que no exista una solicitud de descuento generada por el proceso Promo en estado Aprobada
      and NOT EXISTS (
         SELECT NULL
	    FROM INFO_DETALLE_SOLICITUD c
	    join INFO_DETALLE_SOL_HIST D on C.ID_DETALLE_SOLICITUD = D.DETALLE_SOLICITUD_ID
	    WHERE d.estado = 'Aprobado'
	      and c.estado = 'Aprobado'
	      and tipo_solicitud_id = TIPO_SOLICITUD_HOME
	      and c.USR_CREACION = USUARIO_CREACION
	      AND c.SERVICIO_ID = S.ID_SERVICIO
       )          
      ;           
      ----
    --Cursor para sacar el estado del maximo registro por servicio en las tablas que poseen los #Procesos Generados
    --para verificar si su ultimo proceso fue fallido y no volver a procesarlo hasta que sea regularizado
    CURSOR LCUR_MAX_PROCESO_SERV(C_SERVICIO_ID NUMBER) IS
        SELECT PPD.ID_PROCESO_PROMOCION_DET, PPD.SERVICIO_ID, PPD.ESTADO as ESTADO_MAX
         FROM INFO_PROCESO_PROMOCION_DET PPD 
         WHERE  PPD.ID_PROCESO_PROMOCION_DET in (
            SELECT MAX(PPD.ID_PROCESO_PROMOCION_DET)
             FROM INFO_PROCESO_PROMOCION_CAB PPC,
              INFO_PROCESO_PROMOCION_DET PPD 
             WHERE  PPC.ID_PROCESO_PROMOCION=PPD.PROCESO_PROMOCION_ID AND
             PPC.TIPO_PROCESO='PromoPlanes' 
             AND PPD.SERVICIO_ID=C_SERVICIO_ID)
             ;
      
    LREG_MAX_PROCESO_SERV LCUR_MAX_PROCESO_SERV%ROWTYPE;
    
    --Cursor para sacar el registro de la tabla que contiene el mapeo de promociones por servicio, plan_id y estado        
    CURSOR LCUR_PROMOCION_PLAN(C_SERVICIO_ID NUMBER, C_PLAN_ID NUMBER) IS
      SELECT *
      FROM INFO_PROMOCION_PLAN PP
      WHERE PP.SERVICIO_ID = C_SERVICIO_ID
      AND PP.PLAN_ID = C_PLAN_ID
      AND PP.ESTADO = 'Activo'
    ;
    LREG_PROMOCION_PLAN LCUR_PROMOCION_PLAN%ROWTYPE;
    
    --Cursor para verificar si el registro de la tabla que contiene el mapeo de las promociones 
    --se tiene que el servicio a consultar realizo Cambio de plan es decir si el servicio tiene un plan diferente,
    --para esos casos se procedera a inactivar la promocion.
    CURSOR LCUR_PROMOCION_PLAN_ANTERIOR(C_SERVICIO_ID NUMBER, C_PLAN_ID NUMBER) IS
      SELECT *
      FROM INFO_PROMOCION_PLAN PP
      WHERE PP.SERVICIO_ID = C_SERVICIO_ID
      AND PP.PLAN_ID != C_PLAN_ID
      AND PP.ESTADO = 'Activo'
    ;
    LREG_PROMOCION_PLAN_ANTERIOR LCUR_PROMOCION_PLAN_ANTERIOR%ROWTYPE;
    
    --Cursor para sacar si existen solicitudes pendientes de tipo 11: SOLICITUD DESCUENTO UNICO para el servicio
    --en ese caso no genera solicitudes el proceso de promos
    cursor LC_SolicitudPendiente(C_SERVICIO_ID NUMBER) is
      SELECT C.ID_DETALLE_SOLICITUD, 
        C.MOTIVO_ID,
        C.PRECIO_DESCUENTO,
        C.PORCENTAJE_DESCUENTO,
        C.TIPO_DOCUMENTO,
        C.OBSERVACION,
        C.DETALLE_PROCESO_ID,
        C.FE_CREACION,
        C.USR_CREACION,
        D.ID_SOLICITUD_HISTORIAL,
        D.DETALLE_SOLICITUD_ID,
        D.FE_CREACION FE_APROBACION
      FROM INFO_DETALLE_SOLICITUD c
      join INFO_DETALLE_SOL_HIST D on C.ID_DETALLE_SOLICITUD = D.DETALLE_SOLICITUD_ID
      WHERE d.estado = 'Aprobado'
        and c.estado = 'Aprobado'
        and tipo_solicitud_id = TIPO_SOLICITUD_HOME
        and c.USR_CREACION != USUARIO_CREACION
        AND SERVICIO_ID = C_SERVICIO_ID;
    --
    LR_SolicitudPendiente LC_SolicitudPendiente %rowtype;    
    
    --Cursor que inactiva la tabla de mapeo de promos si se hizo cambio de Plan
    cursor lc_regulariza_cambios_plan is
        select serv.ID_SERVICIO, serv.PLAN_ID,serv.PUNTO_ID,serv.ESTADO ESTADO_SERVICIO,
	  promo.ID_PROMOCION_PLAN,promo.SERVICIO_ID ID_SERVICIO_PROMO,promo.PLAN_ID PLAN_ID_PROMO, promo.ESTADO ESTADO_PROMO
	from info_servicio serv             	  
	    join INFO_PROMOCION_PLAN promo on promo.SERVICIO_ID=serv.ID_SERVICIO and promo.PLAN_ID!=serv.PLAN_ID
	  where  EXISTS (
	      SELECT PP.*
	      FROM INFO_PROMOCION_PLAN PP
	      WHERE pp.SERVICIO_ID = serv.ID_SERVICIO
	      AND PP.PLAN_ID != serv.plan_id
	      AND PP.NUMERO_SOLICITUDES_GENERADAS<PP.NUMERO_MESES
	      AND PP.ESTADO = 'Activo'
	    ) 
	    AND serv.TIPO_ORDEN IN ('N','T')
	  group by serv.ID_SERVICIO, serv.PLAN_ID,serv.PUNTO_ID,serv.ESTADO ,
	  promo.ID_PROMOCION_PLAN,promo.SERVICIO_ID,promo.PLAN_ID, promo.ESTADO	
	;
	
	cursor LCUR_PROMOCION_FINALIZA(C_ID_PROMOCION_PLAN NUMBER) is
	  SELECT ID_PROMOCION_PLAN,
	  PERSONA_EMPRESA_ROL_ID,
	  SERVICIO_ID,
	  FE_INICIO,
	  NUMERO_SOLICITUDES_GENERADAS,
	  PORCENTAJE_DESCUENTO,
	  NUMERO_MESES,
	  FE_CREACION,
	  USR_CREACION,
	  IP_CREACION,
	  PLAN_ID,
	  ESTADO
	FROM INFO_PROMOCION_PLAN 
	where 	 
	 ID_PROMOCION_PLAN=C_ID_PROMOCION_PLAN AND
	 NUMERO_SOLICITUDES_GENERADAS=NUMERO_MESES AND
	 ESTADO='Activo';
	 LREG_PROMOCION_FINALIZA LCUR_PROMOCION_FINALIZA %rowtype; 

    L_PORCENTAJE_DESCUENTO NUMBER;
    L_NUMERO_MESES NUMBER;
    l_numero_solicitud NUMBER;
    l_numero_hist_solicitud NUMBER;    
    L_NUMERO_PROMOCION_PLAN NUMBER;
    L_NUMERO_SOLICITUDES_GENERADAS NUMBER;
    
    L_ID_PROCESO_PROMOCION_DET NUMBER;
    L_ID_PROCESO_PROMOCION NUMBER;    
    L_CANTIDAD_SERVICIOS NUMBER;
    L_CANTIDAD_SOLICITUDES_PROC NUMBER;
    L_CANTIDAD_SOLICITUDES_NOPROC NUMBER;
    L_OBSERVACION VARCHAR2(300);
    L_BANDERA_PROCESA NUMBER;
    L_EXISTE_CABECERA NUMBER;
    L_FECHA VARCHAR(50);
  BEGIN
    -- EL CURSOR ME TRAE SOLO LAS PROMOCIONES DE HOME QUE AUN NO ESTEN INGRESADAS EN INFO_PROMOCION_PLAN O QUE AUN ESTANDO 
    -- EL NUMERO DE SOLICITUDES INGRESADAS SEA MENOR A NUMERO DE MESES POR EL CUAL ES VALIDO LA SOLICITUD  
    cod_ret := 1;
    msg_ret := 'Iniciando Proceso de Promociones en Planes';
   
    L_EXISTE_CABECERA :=0;
    L_CANTIDAD_SERVICIOS :=0;
    L_CANTIDAD_SOLICITUDES_NOPROC :=0;
    L_NUMERO_SOLICITUDES_GENERADAS :=0;
    FOR DATOS IN LCUR_DATOS LOOP       
	--Se verifica que la fecha de inicio de la promo sea menor a la fecha del sistema
	IF(DATOS.FECHA_INICIO_PROMO < sysdate) THEN
	      L_BANDERA_PROCESA :=1;
	      L_OBSERVACION := '';
	     	      
	      cod_ret := 3;
	      msg_ret := 'Inactivando Mapeo de Promociones si servicio realizo Cambio de Plan de un Promo hacia otro Promo';
      
	      --Se verifica si existen cambio de plan para la tabla que contiene el mapeo de las promo ,si ha cambiado el plan_id para el servicio 
	      --se procede a Inactiva el registro del plan anterior, esto si el cliente hace cambio de Plan "de una Promo a otra promo nueva" 
	      --en ese caso se inactiva la PROMO
	      OPEN LCUR_PROMOCION_PLAN_ANTERIOR(DATOS.SERVICIO_ID, DATOS.PLAN_ID);
	      FETCH LCUR_PROMOCION_PLAN_ANTERIOR INTO LREG_PROMOCION_PLAN_ANTERIOR;
	      IF(LCUR_PROMOCION_PLAN_ANTERIOR%FOUND) THEN
		  UPDATE INFO_PROMOCION_PLAN
		  SET ESTADO = 'Inactivo'
		  WHERE SERVICIO_ID = DATOS.SERVICIO_ID
		  AND PLAN_ID != DATOS.PLAN_ID
		  AND ESTADO = 'Activo';
	      END IF;
	      CLOSE LCUR_PROMOCION_PLAN_ANTERIOR;
	      
	      cod_ret := 4;
	      msg_ret := 'Obteniendo el estado del ultimo Proceso ejecutado del Servicio para verificar si FALLO o si esta FINALIZADO';
      
	      --obtengo el estado del ultimo proceso Promo del servicio para verificar si su estado es FALLO o FINALIZADO
	      --en ese caso que hubiese Fallado no debo volver a escribir el registro Fallido en el LOG
	      OPEN LCUR_MAX_PROCESO_SERV(DATOS.servicio_id);
	      FETCH LCUR_MAX_PROCESO_SERV INTO LREG_MAX_PROCESO_SERV;
	      if(LCUR_MAX_PROCESO_SERV%found) then
		  if(LREG_MAX_PROCESO_SERV.ESTADO_MAX='Fallo') then
		      L_BANDERA_PROCESA := 0;
		  end if;
	      end if;
	      CLOSE LCUR_MAX_PROCESO_SERV;
	      
	      cod_ret := 5;
	      msg_ret := 'Verificando si existen Solicitudes Aprobadas de tipo 11: SOLICITUD DESCUENTO UNICO para el servicio no generadas por el proceso PROMO';                            
	      
	      --Se verifica si existen Solicitudes Pendientes de tipo 11: SOLICITUD DESCUENTO UNICO para el servicio
	      OPEN LC_SolicitudPendiente(DATOS.servicio_id);
	      FETCH LC_SolicitudPendiente INTO LR_SolicitudPendiente;
	    
	      --Si no  existen registros de solicitudes de tipo : 11 (Solicitudes Aprobadas listas para ser usadas en la prox facturacion)
	      --se procede a generar la solicitud de descuento respectiva por Promocion
	      IF(LC_SolicitudPendiente%notfound) then	      	          
		  	      
		  --Obtengo el porcentaje de descuento y el numero de meses de la promocion
		  L_NUMERO_MESES         := leeValorCaracteristicaPlan(DATOS.SERVICIO_ID, 'PHOM NUMERO DE MESES');
		  L_PORCENTAJE_DESCUENTO := leeValorCaracteristicaPlan(DATOS.SERVICIO_ID, 'PHOM PORCENTAJE DESCUENTO');
		  
		  cod_ret := 6;
		  msg_ret := 'Obteniendo PHOM PORCENTAJE DESCUENTO y PHOM NUMERO DE MESES para procesar la Solicitud de descuento por Promocion';    
		  --Si no posee las caracteristicas de porcentaje o #meses guardo log de ejecucion Fallido
		  if (L_PORCENTAJE_DESCUENTO is NULL) then 
		      L_OBSERVACION :='No se genera solicitud de descuento Promo porque no posee caracteristica PHOM PORCENTAJE DESCUENTO';
		  END IF; 
		  if (L_NUMERO_MESES is NULL) then 
		      L_OBSERVACION :='No se genera solicitud de descuento Promo porque no posee caracteristica PHOM NUMERO DE MESES';
		  END IF; 
		  
		   if (L_PORCENTAJE_DESCUENTO is NULL or L_NUMERO_MESES is NULL 
		       or L_PORCENTAJE_DESCUENTO <=0 or L_NUMERO_MESES <=0) then 
			-- Si tengo al menos 1 registro por intentar Procesar entonces registro cabecera del Proceso
			if(L_EXISTE_CABECERA = 0 and L_BANDERA_PROCESA = 1) then 
			    cod_ret := 2;
			    msg_ret := 'Guardando Cabecera del Proceso Promociones';
		            L_EXISTE_CABECERA := 1;
			    --Escribo Log en la tabla INFO_PROCESO_PROMOCION_CAB por cada proceso que se ejecuta.
			    L_ID_PROCESO_PROMOCION := SEQ_INFO_PROCESO_PROMOCION_CAB.NEXTVAL;    
			    Insert into INFO_PROCESO_PROMOCION_CAB
			    (ID_PROCESO_PROMOCION,TIPO_PROCESO,CANTIDAD_SERVICIOS,CANTIDAD_SOLICITUDES_PROC,CANTIDAD_SOLICITUDES_NOPROC,ESTADO,
			    FE_CREACION,USR_CREACION,IP_CREACION) values 
			    (L_ID_PROCESO_PROMOCION,'PromoPlanes',0,0,0,'Pendiente',
			    sysdate,USUARIO_CREACION,sys_context('USERENV', 'IP_ADDRESS'));
			end if;
		  end if;
		  
		  if (L_PORCENTAJE_DESCUENTO is NULL or L_NUMERO_MESES is NULL) then 
			if(L_BANDERA_PROCESA = 1) then
			      L_CANTIDAD_SERVICIOS :=L_CANTIDAD_SERVICIOS+1;
			      L_CANTIDAD_SOLICITUDES_NOPROC :=L_CANTIDAD_SOLICITUDES_NOPROC+1;
			      
			      cod_ret := 7;
			      msg_ret := 'Guardando detalle de registro no procesado no encontro Porcentaje: ' || L_PORCENTAJE_DESCUENTO || ' Numero de meses: ' || L_NUMERO_MESES;    		
			      L_ID_PROCESO_PROMOCION_DET :=SEQ_INFO_PROCESO_PROMOCION_DET.NEXTVAL;
			      Insert into INFO_PROCESO_PROMOCION_DET 
			      (ID_PROCESO_PROMOCION_DET,PROCESO_PROMOCION_ID,FE_CREACION,FE_ULT_MOD,
			      USR_CREACION,USR_ULT_MOD,IP_CREACION,PUNTO_ID,SERVICIO_ID,PROMOCION_PLAN_ID,OBSERVACION,ESTADO)
			      values (L_ID_PROCESO_PROMOCION_DET,L_ID_PROCESO_PROMOCION,sysdate,null,
			      USUARIO_CREACION,null, sys_context('USERENV', 'IP_ADDRESS'),DATOS.PUNTO_ID,DATOS.SERVICIO_ID,
			      NULL,L_OBSERVACION,'Fallo');
			end if;	
		   ELSIF(L_PORCENTAJE_DESCUENTO >0 and L_NUMERO_MESES >0) then
		   
		        L_CANTIDAD_SERVICIOS :=L_CANTIDAD_SERVICIOS+1;
		        -- Si tengo al menos 1 registro por intentar Procesar entonces registro cabecera del Proceso
			if(L_EXISTE_CABECERA = 0) then 
			    cod_ret := 2;
			    msg_ret := 'Guardando Cabecera del Proceso Promociones';
		            L_EXISTE_CABECERA := 1;
			    --Escribo Log en la tabla INFO_PROCESO_PROMOCION_CAB por cada proceso que se ejecuta.
			    L_ID_PROCESO_PROMOCION := SEQ_INFO_PROCESO_PROMOCION_CAB.NEXTVAL;    
			    Insert into INFO_PROCESO_PROMOCION_CAB
			    (ID_PROCESO_PROMOCION,TIPO_PROCESO,CANTIDAD_SERVICIOS,CANTIDAD_SOLICITUDES_PROC,CANTIDAD_SOLICITUDES_NOPROC,ESTADO,
			    FE_CREACION,USR_CREACION,IP_CREACION) values 
			    (L_ID_PROCESO_PROMOCION,'PromoPlanes',0,0,0,'Pendiente',
			    sysdate,USUARIO_CREACION,sys_context('USERENV', 'IP_ADDRESS'));
			end if;
			
			cod_ret := 8;
			msg_ret := 'Guardando Promo en tabla de Mapeo de Promociones';    
			
			OPEN LCUR_PROMOCION_PLAN(DATOS.SERVICIO_ID, DATOS.PLAN_ID);		
			FETCH LCUR_PROMOCION_PLAN INTO LREG_PROMOCION_PLAN;
			IF (LCUR_PROMOCION_PLAN%FOUND) THEN	
			    UPDATE INFO_PROMOCION_PLAN
			    SET NUMERO_SOLICITUDES_GENERADAS = NUMERO_SOLICITUDES_GENERADAS + 1
			    WHERE ID_PROMOCION_PLAN          = LREG_PROMOCION_PLAN.ID_PROMOCION_PLAN;
			    L_NUMERO_PROMOCION_PLAN :=LREG_PROMOCION_PLAN.ID_PROMOCION_PLAN;
			ELSE
			    L_NUMERO_PROMOCION_PLAN :=SEQ_INFO_PROMOCION_PLAN.NEXTVAL;
			    LREG_PROMOCION_PLAN.NUMERO_SOLICITUDES_GENERADAS := 0;
			    INSERT INTO INFO_PROMOCION_PLAN (
			      ID_PROMOCION_PLAN,    PERSONA_EMPRESA_ROL_ID,    
			      SERVICIO_ID,  PLAN_ID,  FE_INICIO,    NUMERO_SOLICITUDES_GENERADAS,
			      PORCENTAJE_DESCUENTO,    NUMERO_MESES, 
			      FE_CREACION, USR_CREACION,    IP_CREACION, ESTADO
			    ) VALUES (		  
			      L_NUMERO_PROMOCION_PLAN, DATOS.persona_empresa_rol_id, 		  
			      DATOS.SERVICIO_ID, datos.plan_id, DATOS.FECHA_INICIO_PROMO, LREG_PROMOCION_PLAN.NUMERO_SOLICITUDES_GENERADAS+1,		  
			      L_PORCENTAJE_DESCUENTO, L_NUMERO_MESES, 		  
			      SYSDATE, USUARIO_CREACION, sys_context('USERENV', 'IP_ADDRESS'), 'Activo'
			    );
			END IF;
			close LCUR_PROMOCION_PLAN;
			cod_ret := 9;
			msg_ret := 'Verificando si termino la promocion';    
			
			--Verifico si finalizo la promo
			OPEN LCUR_PROMOCION_FINALIZA(L_NUMERO_PROMOCION_PLAN);		
			FETCH LCUR_PROMOCION_FINALIZA INTO LREG_PROMOCION_FINALIZA;
			IF (LCUR_PROMOCION_FINALIZA%FOUND) THEN	
			      --Si ya se cumplio los meses de Promo , debo finalizar la tabla que contiene el mapeo de Promociones
			      update INFO_PROMOCION_PLAN set estado='Finalizada' 
			      where ID_PROMOCION_PLAN=LREG_PROMOCION_FINALIZA.ID_PROMOCION_PLAN
			      and NUMERO_SOLICITUDES_GENERADAS=NUMERO_MESES AND ESTADO='Activo';
			END IF;
			close LCUR_PROMOCION_FINALIZA;	
			
			cod_ret := 10;
			msg_ret := 'Ingresando detalle de solicitud';
			L_numero_solicitud  := SEQ_INFO_DETALLE_SOLICITUD.nextval;
			INSERT
			    --guardo solicitud generada por promo
			    INTO INFO_DETALLE_SOLICITUD (
				ID_DETALLE_SOLICITUD, SERVICIO_ID,     TIPO_SOLICITUD_ID,
				MOTIVO_ID,        USR_CREACION,        FE_CREACION,
				PRECIO_DESCUENTO, PORCENTAJE_DESCUENTO,TIPO_DOCUMENTO,
				OBSERVACION,      ESTADO,        USR_RECHAZO,
				FE_RECHAZO,       DETALLE_PROCESO_ID,  FE_EJECUCION
			    ) VALUES (                        		  
			      L_numero_solicitud, DATOS.servicio_id, TIPO_SOLICITUD_HOME,                        		  
			      1, USUARIO_CREACION, sysdate,		  
			      null, L_porcentaje_Descuento, null,                        		  
			    'Por promocion planes home promo#:'||L_NUMERO_PROMOCION_PLAN||' '||
			    (LREG_PROMOCION_PLAN.NUMERO_SOLICITUDES_GENERADAS+1)||'/'||L_NUMERO_MESES, 'Aprobado', null,                        		  
			      null, null, null);
			cod_ret := 11;
			msg_ret := 'Generando historia de solicitud';
			--guardo Historico de la Solicitud generada
			L_numero_hist_solicitud  := SEQ_INFO_DETALLE_SOL_HIST.nextval;
			INSERT INTO info_detalle_sol_hist(
			    ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,
			    FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION, 
			    USR_CREACION, FE_CREACION, IP_CREACION, MOTIVO_ID
			  ) VALUES(		  
			      L_numero_hist_solicitud,L_numero_solicitud,'Aprobado',		  
			      null, null,'Por promocion planes home promo#:'||L_NUMERO_PROMOCION_PLAN||' '||
			      (LREG_PROMOCION_PLAN.NUMERO_SOLICITUDES_GENERADAS+1)||'/'||L_NUMERO_MESES,		  
			    USUARIO_CREACION, sysdate, sys_context('USERENV', 'IP_ADDRESS'),1);
			
			L_NUMERO_SOLICITUDES_GENERADAS := L_NUMERO_SOLICITUDES_GENERADAS+1;	
			   
			--Guardo registro que servicio se proceso con exito estado Finalizado
			L_OBSERVACION :='Registro Procesado, se genero Solicitud de descuento por Promocion promo#:'||L_NUMERO_PROMOCION_PLAN||' '||
			    (LREG_PROMOCION_PLAN.NUMERO_SOLICITUDES_GENERADAS+1)||'/'||L_NUMERO_MESES;
			L_ID_PROCESO_PROMOCION_DET :=SEQ_INFO_PROCESO_PROMOCION_DET.NEXTVAL;
			Insert into INFO_PROCESO_PROMOCION_DET 
				      (ID_PROCESO_PROMOCION_DET,PROCESO_PROMOCION_ID,FE_CREACION,FE_ULT_MOD,
				      USR_CREACION,USR_ULT_MOD,IP_CREACION,PUNTO_ID,SERVICIO_ID,
				      PROMOCION_PLAN_ID,OBSERVACION,ESTADO)
				values (L_ID_PROCESO_PROMOCION_DET,L_ID_PROCESO_PROMOCION,sysdate,null,
				      USUARIO_CREACION,null, sys_context('USERENV', 'IP_ADDRESS'),DATOS.PUNTO_ID,DATOS.SERVICIO_ID,
				      L_NUMERO_PROMOCION_PLAN,L_OBSERVACION,'Finalizado');
			    
		   ELSIF(L_PORCENTAJE_DESCUENTO <=0) then	    
		        if(L_BANDERA_PROCESA = 1) then
		                L_CANTIDAD_SERVICIOS :=L_CANTIDAD_SERVICIOS+1;
				L_CANTIDAD_SOLICITUDES_NOPROC :=L_CANTIDAD_SOLICITUDES_NOPROC+1;
				L_OBSERVACION :='No se genera solicitud de descuento Promo la Caracteristica PHOM PORCENTAJE DESCUENTO esta mal definida';
				L_ID_PROCESO_PROMOCION_DET :=SEQ_INFO_PROCESO_PROMOCION_DET.NEXTVAL;
				Insert into INFO_PROCESO_PROMOCION_DET 
				      (ID_PROCESO_PROMOCION_DET,PROCESO_PROMOCION_ID,FE_CREACION,FE_ULT_MOD,
				      USR_CREACION,USR_ULT_MOD,IP_CREACION,PUNTO_ID,SERVICIO_ID,PROMOCION_PLAN_ID,OBSERVACION,ESTADO)
				values (L_ID_PROCESO_PROMOCION_DET,L_ID_PROCESO_PROMOCION,sysdate,null,
				      USUARIO_CREACION,null, sys_context('USERENV', 'IP_ADDRESS'),DATOS.PUNTO_ID,DATOS.SERVICIO_ID,
				      NULL,L_OBSERVACION,'Fallo');
			 end if;
	           ELSIF(L_NUMERO_MESES <=0) then	    
	                 if(L_BANDERA_PROCESA = 1) then
	                        L_CANTIDAD_SERVICIOS :=L_CANTIDAD_SERVICIOS+1;
				L_CANTIDAD_SOLICITUDES_NOPROC :=L_CANTIDAD_SOLICITUDES_NOPROC+1;
				L_OBSERVACION :='No se genera solicitud de descuento Promo la Caracteristica PHOM NUMERO DE MESES esta mal definida';
				L_ID_PROCESO_PROMOCION_DET :=SEQ_INFO_PROCESO_PROMOCION_DET.NEXTVAL;
				Insert into INFO_PROCESO_PROMOCION_DET 
				      (ID_PROCESO_PROMOCION_DET,PROCESO_PROMOCION_ID,FE_CREACION,FE_ULT_MOD,
				      USR_CREACION,USR_ULT_MOD,IP_CREACION,PUNTO_ID,SERVICIO_ID,PROMOCION_PLAN_ID,OBSERVACION,ESTADO)
				values (L_ID_PROCESO_PROMOCION_DET,L_ID_PROCESO_PROMOCION,sysdate,null,
				      USUARIO_CREACION,null, sys_context('USERENV', 'IP_ADDRESS'),DATOS.PUNTO_ID,DATOS.SERVICIO_ID,
				      NULL,L_OBSERVACION,'Fallo');
			  end if;
		    END IF;									
	      ELSE
		    --Si ya posee una solicitud en estado Aprobada no debo generar otra hasta que sea finalizada
		    --Si la solicitud existente se  encuentra Aprobada y no fue generada por el proceso PROMO entonces 
		    --guardo log de ejecucion Fallido ya que no se genera solicitud porque han registrado una solicitud manual		    
		    cod_ret := 12;
		    msg_ret := 'Existen Solicitudes de descuento de tipo 11: SOLICITUD DESCUENTO UNICO para el servicio no generadas por Proceso Promo y Aprobadas se genera LOG de Fallo';    
		  
		    if(LR_SolicitudPendiente.USR_CREACION!=USUARIO_CREACION) then 
			  if(L_BANDERA_PROCESA = 1) then			        
			        -- Si tengo al menos 1 registro por intentar Procesar entonces registro cabecera del Proceso
				if(L_EXISTE_CABECERA = 0) then 
				    cod_ret := 2;
				    msg_ret := 'Guardando Cabecera del Proceso Promociones';
			            L_EXISTE_CABECERA := 1;
				    --Escribo Log en la tabla INFO_PROCESO_PROMOCION_CAB por cada proceso que se ejecuta.
				    L_ID_PROCESO_PROMOCION := SEQ_INFO_PROCESO_PROMOCION_CAB.NEXTVAL;    
				    Insert into INFO_PROCESO_PROMOCION_CAB
				    (ID_PROCESO_PROMOCION,TIPO_PROCESO,CANTIDAD_SERVICIOS,CANTIDAD_SOLICITUDES_PROC,CANTIDAD_SOLICITUDES_NOPROC,ESTADO,
				    FE_CREACION,USR_CREACION,IP_CREACION) values 
				    (L_ID_PROCESO_PROMOCION,'PromoPlanes',0,0,0,'Pendiente',
				    sysdate,USUARIO_CREACION,sys_context('USERENV', 'IP_ADDRESS'));
				end if;
				
				L_CANTIDAD_SERVICIOS :=L_CANTIDAD_SERVICIOS+1;
				L_CANTIDAD_SOLICITUDES_NOPROC :=L_CANTIDAD_SOLICITUDES_NOPROC+1;
				L_OBSERVACION :='No se genera solicitud de descuento Promo porque ya posee una solicitud Aprobada no generada por el proceso PROMO';
				L_ID_PROCESO_PROMOCION_DET :=SEQ_INFO_PROCESO_PROMOCION_DET.NEXTVAL;
				Insert into INFO_PROCESO_PROMOCION_DET 
				      (ID_PROCESO_PROMOCION_DET,PROCESO_PROMOCION_ID,FE_CREACION,FE_ULT_MOD,
				      USR_CREACION,USR_ULT_MOD,IP_CREACION,PUNTO_ID,SERVICIO_ID,PROMOCION_PLAN_ID,OBSERVACION,ESTADO)
				values (L_ID_PROCESO_PROMOCION_DET,L_ID_PROCESO_PROMOCION,sysdate,null,
				      USUARIO_CREACION,null, sys_context('USERENV', 'IP_ADDRESS'),DATOS.PUNTO_ID,DATOS.SERVICIO_ID,
				      NULL,L_OBSERVACION,'Fallo');
			  end if;
		    end if;     
	      END IF;
	      close LC_SolicitudPendiente;
	END IF;
    END LOOP;
    
    --Regula Cambios de Plan existentes, si se realizo cambio de plan "De un promo a un plan No promo" y posee registro en la tabla de
    --mapeo de Promociones en estado Activo donde el NUMERO_SOLICITUDES_GENERADAS<NUMERO_MESES DE LA PROMO se debe proceder a Inactivar el registro.
    for datos_regula_cambios_plan in lc_regulariza_cambios_plan loop   
       --Inactivo la promo
	update INFO_PROMOCION_PLAN set estado='Inactivo' 
	where ID_PROMOCION_PLAN=datos_regula_cambios_plan.ID_PROMOCION_PLAN;
    end loop; 
    
    --Actualizo cabecera del log del proceso de promociones para guardar los contadores de registros procesados
    update INFO_PROCESO_PROMOCION_CAB
	set CANTIDAD_SERVICIOS=L_CANTIDAD_SERVICIOS,
	CANTIDAD_SOLICITUDES_PROC=L_NUMERO_SOLICITUDES_GENERADAS,
	CANTIDAD_SOLICITUDES_NOPROC=L_CANTIDAD_SOLICITUDES_NOPROC,
	ESTADO='Activo'
	where ID_PROCESO_PROMOCION=L_ID_PROCESO_PROMOCION;
    
    --ENVIO CORREO DE CONFIRMACION QUE EL PROCESO DE PROMOCIONES POR PLANES HOME SE EJECUTO CON EXITO
    cod_ret := 8000;
    MSG_RET := 'Enviando correo de confirmacion que proceso se ejecuto con exito';         
    ASUNTO :=  'TELCOS:PROMOCIONES:PROCESO DE PROMOCIONES DE PLANES HOME';
    CADENA :=  'La presente es para informarle que se ejecutaron las Promociones, se generaron # '|| L_NUMERO_SOLICITUDES_GENERADAS  ||' solicitudes de descuento en el <strong>Sistema TelcoS+</strong> para su proxima Facturacion. ';
    promociones.p_enviaCorreoConfirmacion(ASUNTO,CADENA,cod_ret, msg_ret);     
    SELECT TO_CHAR(SysDate,'YYYY/MM/DD HH24:MI:SS') todays_date
    INTO L_FECHA FROM dual;
    cod_ret := 0;
    msg_ret := 'Se ejecutaron las Promociones, fecha de ejecucion: '|| L_FECHA ||', se generaron # '|| L_NUMERO_SOLICITUDES_GENERADAS  ||' solicitudes de descuento en el Sistema TelcoS+ para su proxima Facturacion. ';
    commit;
  exception 
     when errorProcedure then     
       if(LCUR_MAX_PROCESO_SERV%isopen) then close LCUR_MAX_PROCESO_SERV; end if;
       if(lc_SolicitudPendiente%isopen) then close lc_SolicitudPendiente; end if;
       if(LCUR_PROMOCION_FINALIZA%isopen) then close LCUR_PROMOCION_FINALIZA; end if;       
       if(LCUR_PROMOCION_PLAN%isopen) then close LCUR_PROMOCION_PLAN; end if;
       if(LCUR_PROMOCION_PLAN_ANTERIOR%isopen) then close LCUR_PROMOCION_PLAN_ANTERIOR; end if;
       Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
       rollback;
     WHEN OTHERS THEN
       if(LCUR_MAX_PROCESO_SERV%isopen) then close LCUR_MAX_PROCESO_SERV; end if;
       if(lc_SolicitudPendiente%isopen) then close lc_SolicitudPendiente; end if;
       if(LCUR_PROMOCION_FINALIZA%isopen) then close LCUR_PROMOCION_FINALIZA; end if;       
       if(LCUR_PROMOCION_PLAN%isopen) then close LCUR_PROMOCION_PLAN; end if;
       if(LCUR_PROMOCION_PLAN_ANTERIOR%isopen) then close LCUR_PROMOCION_PLAN_ANTERIOR; end if;
       --
       IF COD_RET = 0 THEN COD_RET := 1; END IF;
       rollback;
       Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;

/************************************************************************************************************
 * Procedimiento para envio de mail de confirmacion de que el Paquete se ejecuto con exito
 * Condiciones:
 * Se envia mail confirmando que se ejecuto el proceso de PROMOCIONES que genera las solicitudes de descuento Unico 
 * en la Facturacion del Cliente este correo es enviado a facturacion y a Soporte de Sistemas para su validacion de 
 * que el proceso se ejecuto con exito 
 ***************************************************************************************************************/
        
 procedure p_enviaCorreoConfirmacion(ASUNTO varchar2, CADENA varchar2,cod_ret out number, msg_ret out varchar2) is 
      errorProcedure exception;
      nameProcedure varchar2(60) := 'PROMOCIONES.p_enviaCorreoConfirmacion';
      texto varchar2(3000);
      correo_recibe varchar2(100);
      desc_empresa varchar2(20);
  begin   
   correo_recibe:=CORREO_RECIBE_CONFIRMACION;
   desc_empresa:='Megadatos';
   texto := '<html>  <head>    <meta http-equiv=Content-Type content="text/html; charset=UTF-8">  </head>  <body>    
               <table align="center" width="100%" cellspacing="0" cellpadding="5"><tr><td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">            
               <img alt=""  src="http://images.telconet.net/others/telcos/logo.png"/>        
               </td></tr><tr>        
               <td style="border:1px solid #6699CC;">          
               <table width="100%" cellspacing="0" cellpadding="5">        
               <tr><td colspan="2"><table cellspacing="0" cellpadding="2">
                 <tr>
                 <td colspan="2">Estimado usuario:</td>
                 </tr>
                 <tr><td></td></tr>
                 <tr>
               '||addTD(CADENA , null, 2, 0)|| '
                 </tr>                                            
                <tr><td></td></tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2">Atentamente,</td>
                </tr>
                <tr><td></td></tr>
                <tr>
                <td colspan="2"><strong>Sistema TelcoS+</strong></td>
                </tr>
                </table></td></tr><tr><td colspan="2"><br></td></tr></table>
              </td></tr><tr><td></td></tr><tr><td><strong><font size="2" face="Tahoma">'|| desc_empresa  ||'</font></strong></p></td></tr></table></body></html>';  
                            
              UTL_MAIL.SEND (sender => CORREO_ENVIA,
                  recipients      => correo_recibe,                  
                  subject         => ASUNTO,
                  message         => texto,
                  mime_type       => 'text/html; charset=UTF-8'
                 );            
    commit;
    cod_ret := 0;
   exception 
    when errorProcedure then
      Util.PRESENTAERROR(NULL, NULL, COD_RET , MSG_RET , NAMEPROCEDURE );
    WHEN OTHERS THEN
      IF COD_RET = 0 THEN COD_RET := 1; END IF;
      Util.PRESENTAERROR(SQLCODE, SQLERRM, COD_RET , MSG_RET , NAMEPROCEDURE );
  end;     
  
END PROMOCIONES;
/
