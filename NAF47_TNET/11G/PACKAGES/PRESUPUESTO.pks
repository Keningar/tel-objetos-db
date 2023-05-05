CREATE OR REPLACE PACKAGE presupuesto AS
   -- ---
   -- El paquete presupuesto contiene reune una serie de procedimientos y
   -- funciones necesarias para la ejecucion del proceso de presupuesto
   --
   --
   --
   PROCEDURE Mayorizacion (pCia         Varchar2,
                           pmes_Cierre  Varchar2,
                           pPeriodo     Varchar2);
   --
   PROCEDURE acumula (pCia        Varchar2,
                      pMes_Cierre Varchar2,
                      pPeriodo    Varchar2);
   --
   --
   FUNCTION  ultimo_error   RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20036);
   kNum_error      NUMBER := -20036;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   

   --Agregado por Yoveri S.A. (FEM) 03-2012  Modulo de Presupuesto
   Procedure pu_detalle_movimiento(Pv_cia         in varchar2,
                                   Pn_presupuesto in arprdm.id_presupuesto%type,
                                   Pv_tipo_mov    in arprdm.tipo_movimiento%type,
                                   Pn_valor       in arprdm.valor%type,
                                   Pv_tipo_doc    in arprdm.tipo_documento%type,
                                   Pv_fisico      in arprdm.no_fisico%type,
                                   Pn_secuencial  in arprdm.no_secuencia%type,
                                   Pd_fec_aut     in arprdm.fecha_autoriza%type,
                                   Pv_user_aut    in arprdm.usuario_autoriza%type,
                                   Pv_ind_resta   in varchar2,
                                   Pv_modulo      in arprdm.modulo%type,
                                   Pv_mensaje     in out varchar2,
                                   Pv_error       in out varchar2);

   Procedure pu_actualiza_detalle(Pv_cia             in varchar2,
                                  Pn_cod_presupuesto in number,
                                  Pv_tipo            in varchar2,
                                  Pn_valor           in number,
                                  Pv_resta           in varchar2,
                                  Pv_error           in out varchar2);

   Procedure Pu_reconstruye_saldo (Pv_cia         in varchar2,
                                   Pn_presupuesto in number,
                                   Pv_error       in out varchar2);
END; -- presupuesto;

/


CREATE OR REPLACE PACKAGE BODY presupuesto AS
   --
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   vMensaje_error   VARCHAR2(160);
   vMensaje         VARCHAR2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := msj_error;
      vMensaje       := msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(msj IN VARCHAR2) IS
   BEGIN
      vMensaje  := msj;
   END;
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje);
   END ultimo_mensaje;
   --
   --
   -- --
   PROCEDURE prepara_mayorizacion (
     pCia    Varchar2,
     ano_ini number,
     mes_ini number,
     ano_fin number,
     mes_fin number
   ) IS
   -- --
   -- cursor para volver a limpiar el presupuesto del periodo
   cursor p1 is
       select cuenta, ind_mov, ind_presup
         from arcgms
        where no_cia = pCia
          and ind_presup = 'S';
  BEGIN
    -- --
    -- prepara_mayorizacion el presupuesto
    --
    update arcghc_c
      set   pres_ac = null, presu = presu_ini
      where no_cia   = pCia
         and ( (ano = ano_ini and mes >= mes_ini) or
               (ano = ano_fin and mes <= mes_fin) );
    --
    for f1 in p1 loop
        -- No debemos modificar aquellas cuentas en las que se especifico el presupuesto
        if f1.ind_mov = 'N' and f1.ind_presup = 'N' then
          update arcghc_c
            set presu = NULL
            where no_cia   = pCia
              and cuenta   = f1.cuenta
              and presu is not NULL
              and ((ano = ano_ini and mes >= mes_ini) or
                   (ano = ano_fin and mes <= mes_fin));
        end if;
     END loop;
  END prepara_mayorizacion;
  --
  --
  PROCEDURE Actualiza_HCC (
    pno_cia Varchar2,
    pano    Number,
    pmes    Number,
    pcta    Varchar2,
    pcc1    Varchar2,
    pcc2    Varchar2,
    pcc3    Varchar2,
    pPresu  Number
  ) IS
  BEGIN
     update arcghc_c
        set presu = nvl(presu,0) + pPresu
      where no_cia  = pNo_Cia
        and cuenta  = pcta
        and cc_1    = pcc1
        and cc_2    = pcc2
        and cc_3    = pcc3
        and ano     = pano
        and mes     = pmes ;
      if sql%rowcount = 0 then
         insert into arcghc_c(no_cia, ano,  mes,  periodo,
                              cuenta, presu,  cc_1, cc_2, cc_3)
                values (pno_CIA, pano, pmes, (pano * 100) + pmes,
                        pcta, ppresu,  pcc1, pcc2, pcc3);
      end if;
  END Actualiza_HCC;
  --
  --
  PROCEDURE Mayoriza_Centro (
    p_Cia   Varchar2,
    cuenta  VARCHAR2,
    vcc1    VARCHAR2,
    vcc2    VARCHAR2,
    vcc3    VARCHAR2,
    p_ano   NUMBER,
    p_mes   NUMBER,
    p_presu NUMBER,
    pn      NUMBER,
    pj      NUMBER
  ) IS
    -- Mayoriza el monto presupuestado, para el centro de  costos especificado
    vCtaProceso  VarChar2(15);
    indica_presu VarChar2(1);
    --
    Cursor Acepta_Presup (pcta varchar2) IS
      select ind_presup
      from arcgms
      where no_cia = p_CIA
       and cuenta = pcta;
  BEGIN
    vCtaProceso := cuenta;
    LOOP
      Open Acepta_Presup (vCtaProceso);
      Fetch Acepta_Presup into indica_presu;
      Close Acepta_Presup;
      IF NVL(indica_presu,'S') = 'N' then
         --         Aplica el presupuesto a las cuentas de mayor
         --        (No reciben movimientos => No aceptan Presupuesto)
         Actualiza_Hcc(p_cia, p_ano, p_mes, vCtaProceso, vcc1, vcc2, vcc3, p_presu);
      END IF;
      If Cuenta_Contable.Nivel(p_Cia, vCtaProceso) = 1 Then
         exit;
      ELSE
         vCtaProceso := Cuenta_Contable.Padre(p_Cia, vCtaProceso);
      End If;
    END LOOP; -- loop de mayorizacion
  END mayoriza_centro;
  --
  --
  PROCEDURE agregacion_CC(
    pCia    Varchar2,
    ano_ini number,
    mes_ini number,
    ano_fin number,
    mes_fin number
  ) IS
    --
    cursor nivel3  is
      select a.no_cia,           a.ano,  a.mes,  a.cuenta,
             nvl(presu,0) presu, a.cc_1, a.cc_2, a.cc_3
      from arcghc_c a, arcgms b
      where a.no_cia         =  pCia
        and a.cc_3           != '000'
        and nvl(a.presu, 0)  !=   0
        and ((a.ano = ano_ini   AND a.mes between mes_ini AND 12) OR
             (a.ano = ano_fin    AND a.mes between 1       AND mes_fin))
        and b.no_cia         = a.no_cia
        and b.cuenta         = a.cuenta
        and b.activa         = 'S'
        and b.ind_presup     = 'S';
    --
    cursor nivel2  is
      select a.no_cia,           a.ano,  a.mes,  a.cuenta,
             nvl(presu,0) presu, a.cc_1, a.cc_2, a.cc_3
      from arcghc_c a, arcgms b
      where a.no_cia        =  pCia
        and a.cc_2         != '000'
        and a.cc_3          =  '000'
        and nvl(a.presu,0) !=   0
        and ((a.ano = ano_ini  and a.mes between mes_ini and 12) or
            (a.ano = ano_fin  and a.mes between 1 and mes_fin))
        and b.no_cia        = a.no_cia
        and b.cuenta        = a.cuenta
        and b.activa        = 'S'
        and b.ind_presup    = 'S';
    cursor nivel1  is
      select a.no_cia,           a.ano,  a.mes,  a.cuenta,
             nvl(presu,0) presu, a.cc_1, a.cc_2, a.cc_3
       from arcghc_c a, arcgms b
      where a.no_cia          = pCia
        and a.cc_1           != '000'
        and a.cc_2            =  '000'
        and a.cc_3            =  '000'
        and nvl(a.presu,0)   !=   0
        and ((a.ano = ano_ini  and a.mes between mes_ini and 12) or
             (a.ano = ano_fin  and a.mes between 1 and mes_fin))
        and b.no_cia          = a.no_cia
        and b.cuenta          = a.cuenta
        and b.activa     = 'S'
        and b.ind_presup = 'S';
    --
    cursor nivel0  is
      select a.no_cia,           a.ano,  a.mes,  a.cuenta,
             nvl(presu,0) presu, a.cc_1, a.cc_2, a.cc_3
       from arcghc_c a, arcgms b
      where a.no_cia     = pCia
        and a.cc_1       = '000'
        and nvl(a.presu,0)   !=   0
        and ((a.ano      = ano_ini  and a.mes between mes_ini and 12) or
             (a.ano      = ano_fin  and a.mes between 1 and mes_fin))
        and b.no_cia     = a.no_cia
        and b.cuenta     = a.cuenta
        and b.activa     = 'S'
        and b.ind_presup = 'S';
  BEGIN
    FOR n3 IN nivel3 LOOP
      Actualiza_HCC(pCia, n3.ano, n3.mes, n3.cuenta, n3.cc_1, n3.cc_2, '000', n3.presu);
      Mayoriza_Centro(pCia, n3.cuenta, n3.cc_1, n3.cc_2, n3.cc_3,  n3.ano, n3.mes, n3.presu, 3,0);
    END LOOP;   -- del cursor n3
    --
    FOR n2 IN nivel2 LOOP
      Actualiza_HCC(pCia, n2.ano, n2.mes, n2.cuenta, n2.cc_1, '000', '000', n2.presu);
      Mayoriza_Centro (pCia, n2.cuenta, n2.cc_1, n2.cc_2, n2.cc_3,  n2.ano, n2.mes, n2.presu, 3,0);
    END LOOP;   -- del cursor n2
    --
    FOR n1 IN nivel1 LOOP
      Actualiza_HCC(pCia, n1.ano, n1.mes, n1.cuenta, '000', '000', '000', n1.presu);
      Mayoriza_Centro (pCia, n1.cuenta, n1.cc_1, n1.cc_2, n1.cc_3,  n1.ano, n1.mes, n1.presu, 3,0);
    END LOOP;   -- del cursor n1
    --
    FOR n0 IN nivel0 LOOP
      Mayoriza_Centro (pCia, n0.cuenta, n0.cc_1, n0.cc_2, n0.cc_3,  n0.ano, n0.mes, n0.presu, 3,0);
    END LOOP;   -- del cursor n0
  END;
  --
  --
  /*******[ PARTE: PUBLICA ]
  * Declaracion de Procedimientos o funciones PUBLICOS
  *
  */
  --
  PROCEDURE Mayorizacion (
    pCia Varchar2,    pmes_Cierre Varchar2,
    pPeriodo Varchar2
  ) IS
    ano_ini ARCGMC.ANO_PROCE%TYPE;
    ano_fin ARCGMC.ANO_PROCE%TYPE;
    mes_ini number(2);
    mes_fin number(2);
  BEGIN
    -- --
    -- Obtiene el periodo sobre el cual debe aplicar
    --
    if pmes_cierre=12 then
       ano_ini:=pperiodo;
       ano_fin:=pperiodo;
       mes_ini:=1;
       mes_fin:=12;
    else
       ano_ini:=pperiodo-1;
       ano_fin:=pperiodo;
       mes_ini:=pmes_cierre+1;
       mes_fin:=pmes_cierre;
    end if;
    --
    prepara_mayorizacion(pCia, ano_ini, mes_ini, ano_fin, mes_fin);
    Agregacion_CC(pCia, ano_ini, mes_ini, ano_fin, mes_fin);
    --
  END mayorizacion;
  --
  --
  PROCEDURE acumula (
    pCia        Varchar2,
    pMes_Cierre Varchar2,
    pPeriodo    Varchar2
  ) IS
    --
    ano_ini      arcgmc.ano_proce%type;
    ano_fin      arcgmc.ano_proce%type;
    mp           number;          -- Mes que esta acumulando actualmente
    prim_mes     number := 1;     -- Indicador del primier periodo
    vPresu_acum  number := 0;
    vMes_ini     number;
    cta_ant      arcgms.Cuenta%type:= ' ';
    cta_act      arcgms.Cuenta%type:= ' ';
    ctro_ant     varchar2(9) := ' ';
    ctro_act     varchar2(9) := ' ';
    --
    CURSOR C1(m_ini number) IS
           select cuenta,  nvl(presu,0) presu, ano,  mes,
                  nvl(pres_ac,0) pres_ac, cc_1,               cc_2, cc_3
             from arcghc_c
            where no_cia = pCia
              and ((ano = ano_ini and  mes >= m_ini) OR
                  (ano = ano_fin) and mes <= pmes_cierre)
           order by cuenta, cc_1, cc_2, cc_3, ano, mes;
  BEGIN
    -- Obtiene el ano de inicio y fin del periodo
    if pmes_cierre=12 then
      ano_ini:=pperiodo;
      ano_fin:=pperiodo;
    else
      ano_ini:=pperiodo-1;
      ano_fin:=pperiodo;
    end if;
    -- --
    -- Determina en que mes iniciar el proceso, el proceso acumula un mes
    --   y este mismo acumulado lo lleva al siguiente mes
    if pmes_cierre = 12 then
      vMes_ini := 1;
    else
      vMes_ini := pmes_cierre+1;
    end if;
    for f1 in c1(vmes_ini) loop
      cta_act  := f1.cuenta;
      ctro_act := f1.cc_1||f1.cc_2||f1.cc_3;
      If cta_act != cta_ant OR ctro_act != ctro_ant THEN
         vPresu_acum := 0;
      END IF;
      --
      update arcghc_c
         set pres_ac = f1.presu + vPresu_acum
       where no_cia  = pCIA
         and ano     = f1.ano
         and mes     = f1.mes
         and cuenta  = f1.cuenta
         and cc_1    = f1.cc_1
         and cc_2    = f1.cc_2
         and cc_3    = f1.cc_3;
       --
       vPresu_acum := vPresu_acum + f1.presu;
       cta_ant     := cta_act;
       ctro_ant    := ctro_act;
     end loop;
  END Acumula;
  
Procedure pu_detalle_movimiento(Pv_cia         in varchar2,
                                Pn_presupuesto in arprdm.id_presupuesto%type,
                                Pv_tipo_mov    in arprdm.tipo_movimiento%type,
                                Pn_valor       in arprdm.valor%type,
                                Pv_tipo_doc    in arprdm.tipo_documento%type,
                                Pv_fisico      in arprdm.no_fisico%type,
                                Pn_secuencial  in arprdm.no_secuencia%type,
                                Pd_fec_aut     in arprdm.fecha_autoriza%type,
                                Pv_user_aut    in arprdm.usuario_autoriza%type,
                                Pv_ind_resta   in varchar2,
                                Pv_modulo      in arprdm.modulo%type,
                                Pv_mensaje     in out varchar2,
                                Pv_error       in out varchar2) Is
  
    Cursor C_existe is
    select 'X'
       from arprem b
       where b.id_presupuesto = Pn_presupuesto
         and b.no_cia         = Pv_cia;
    
    Cursor C_saldo is
    select ((nvl(a.valor_inicial,0) - nvl(a.valor_disminuido,0) + nvl(a.valor_aumento,0)) -
           (nvl(a.valor_comprometido,0) + nvl(a.valor_devengado,0) + nvl(a.valor_ejecutado,0))) disponible
      from arprem a
     where a.no_cia = Pv_cia
       and a.id_presupuesto = Pn_presupuesto
       and a.estado = 'A';

    Le_error                Exception;
    Lv_error                Varchar2(2000):=Null;
    Pv_error_act            Varchar2(2000):=Null;  
    Lv_existe               Varchar2(1):=Null;
    Lv_estado               Varchar2(1):=Null;
    Ln_saldo                Number:=0;
    Lv_no_docu              varchar2(20):=null;
    Ln_sec                  number;
  
  Begin
    ---
    presupuesto.pu_detalle_movimiento@gpoetnet(Pv_cia,
                          Pn_presupuesto ,
                          Pv_tipo_mov    ,
                          Pn_valor       ,
                          Pv_tipo_doc    ,
                          Pv_fisico      ,
                          Pn_secuencial  ,
                          Pd_fec_aut     ,
                          Pv_user_aut    ,
                          Pv_ind_resta   ,
                          Pv_modulo      ,
                          Pv_mensaje     ,
                          Pv_error       );
    
  Exception
    When Le_error then
      Pv_error := Lv_error;
    When others then
      Pv_error := sqlerrm;
  End;
  
  Procedure pu_actualiza_detalle(Pv_cia             in varchar2,
                               Pn_cod_presupuesto in number,
                               Pv_tipo            in varchar2,
                               Pn_valor           in number,
                               Pv_resta           in varchar2,
                               Pv_error           in out varchar2) Is

Le_error       exception;
Lv_error       varchar2(5000):=null;
 
  Begin
    If Pv_cia is null then
      Lv_error := 'El codigo de la compa?ia debe ser ingresado';
      raise le_error;
    End if;
    
    If Pn_cod_presupuesto is null then
      Lv_error := 'El codigo de presupuesto debe ser ingresado';
      raise le_error;    
    End if;
    
    If Pv_tipo is null then
      Lv_error := 'El tipo de movimiento debe ser ingresado';
      raise le_error;      
    End if;
    
    If nvl(Pn_valor,0) = 0 then
      Lv_error := 'El valor debe de ser ingresado';
      raise le_error;      
    End if;
    
    update arprem a
       set a.valor_comprometido = decode(Pv_tipo,'COM',(nvl(a.valor_comprometido,0) + Pn_valor), nvl(a.valor_comprometido,0)),
           a.valor_devengado    = decode(Pv_tipo,'DEV',(nvl(a.valor_devengado,0) + Pn_valor),nvl(a.valor_devengado,0)),
           a.valor_ejecutado    = decode(Pv_tipo,'EJE',(nvl(a.valor_ejecutado,0) + Pn_valor),nvl(a.valor_ejecutado,0)),
           a.valor_aumento      = decode(Pv_tipo,'AUM',(nvl(a.valor_aumento,0) + Pn_valor),nvl(a.valor_aumento,0)),
           a.valor_disminuido   = decode(Pv_tipo,'DIS',(nvl(a.valor_disminuido,0) + Pn_valor),nvl(a.valor_disminuido,0)),
           a.usuario_modifica   = user,
           a.fecha_modifica     = sysdate
     where a.id_presupuesto     = Pn_cod_presupuesto
       and a.no_cia             = Pv_cia;

    If nvl(Pv_resta,'N') = 'S' then   
      If Pv_tipo = 'COM' then
        null;
      elsif Pv_tipo = 'DEV' then
        update arprem
           set valor_comprometido = nvl(valor_comprometido,0) - Pn_valor
         where no_cia         = Pv_cia
           and id_presupuesto = Pn_cod_presupuesto;
      elsif Pv_tipo = 'EJE' then
        update arprem
           set valor_devengado = nvl(valor_devengado,0) - Pn_valor
         where no_cia         = Pv_cia
           and id_presupuesto = Pn_cod_presupuesto;    
      elsif Pv_tipo = 'AUM' then
        update arprem
           set valor_aumento = nvl(valor_aumento,0) + Pn_valor
         where no_cia         = Pv_cia
           and id_presupuesto = Pn_cod_presupuesto;      
      else
        update arprem
           set valor_disminuido = nvl(valor_disminuido,0) + Pn_valor
         where no_cia         = Pv_cia
           and id_presupuesto = Pn_cod_presupuesto;       
      End if;
    End if;
        
   Exception
     When Le_error Then
       Pv_error := Lv_error;
     When others then
       Pv_error := 'Error pu_actualiza_detalle :'||sqlerrm;
  End;
  
  Procedure Pu_reconstruye_saldo (Pv_cia         in varchar2,
                                Pn_presupuesto in number,
                                Pv_error       in out varchar2) Is
  
Cursor C_detalle Is
 Select id_detalle_presupuesto, id_presupuesto, tipo_movimiento, valor, usuario, tipo_documento, 
        no_fisico, estado, fecha_autoriza, usuario_autoriza, ind_resta, tstamp, usuario_crea
   From arprdm b
  Where b.id_presupuesto = Pn_presupuesto
    and b.estado = 'A';

Le_error       Exception;
Lv_error       Varchar2(5000):= Null;

  Begin
    Update arprem a
       set a.valor_comprometido = 0,
           a.valor_devengado    = 0,
           a.valor_ejecutado    = 0,
           a.valor_aumento      = 0,
           a.valor_disminuido   = 0,
           a.usuario_modifica   = null,
           a.fecha_modifica     = null
     where a.id_presupuesto = Pn_presupuesto
       and a.no_cia         = Pv_cia;
    
    If sql%notfound then
      Lv_error := 'No existe el registro seleccionado';
      raise Le_error;
    End if;
     
    For i in C_detalle loop
       pu_actualiza_detalle(Pv_cia,
                            i.id_presupuesto,
                            i.tipo_movimiento,
                            i.valor,
                            i.ind_resta,
                            Lv_error);
       If Lv_error is not null then
         exit;
       end if;
    End loop;
  Exception
    When Le_error then
      Pv_error := Lv_error;
    When Others then
      Pv_error := 'Pu_reconstruye_saldo :'||sqlerrm;
  End;  
  
END;   -- BODY presupuesto

/
