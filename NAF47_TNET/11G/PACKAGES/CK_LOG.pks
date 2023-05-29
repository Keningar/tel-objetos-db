CREATE OR REPLACE package NAF47_TNET.CK_LOG is

  type r_documentos is record
     ( no_cia     arckmm.no_cia%type,
       no_docu    arckmm.no_docu%type,
       no_cta     arckmm.no_cta%type,
       fecha_crea arckmm.time_stamp%type   
       );
  
  type t_documentos is ref cursor return r_documentos;

  ------------------------------------
  -- proeso que verifica los saldos --
  ------------------------------------
  procedure p_verifica_saldos ( Pv_NoCia      Varchar2,
                                Pv_noCuenta   Varchar2,
                                Pn_AnioInicio Number,
                                Pn_MesInicio  Number,
                                Pv_TipoProceso varchar2,
                                Pr_Documentos t_documentos);
  ------------------------------------
  -- procedimiento que registra LOG --
  ------------------------------------
  procedure p_inserta_log ( Pv_NoCia         Varchar2,
                            Pv_NoCuenta      Varchar2,
                            Pc_DocProcesados clob,
                            Pv_Observaciones Varchar2,
                            Pd_FechaIniProc  date);

end ck_log;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.CK_LOG IS
  
  ------------------------------------
  -- proeso que verifica los saldos --
  ------------------------------------
  procedure p_verifica_saldos ( Pv_NoCia      Varchar2,
                                Pv_noCuenta   Varchar2,
                                Pn_AnioInicio Number,
                                Pn_MesInicio  Number,
                                Pv_TipoProceso varchar2,
                                Pr_Documentos t_documentos) IS
    --
    cursor c_cuentas_bancarias is
      select a.no_cia,  
             a.no_cta, 
             a.ano_proc anio_inicio,-- si es solo un mes estos seran
             a.mes_proc mes_inicio, -- los valores iniciales que reciban
             a.ano_proc anio_proceso, 
             a.mes_proc mes_proceso,
             to_date('01/'||a.mes_proc||'/'||a.ano_proc, 'dd/mm/yyyy') fecha_ini_mes_proc,
             last_day(to_date('01/'||a.mes_proc||'/'||a.ano_proc, 'dd/mm/yyyy')) fecha_fin_mes_proc
        from naf47_tnet.arckmc a
       where a.no_cia = Pv_NoCia
         and a.no_cta = Pv_noCuenta;

    --
    cursor c_saldos_historicos (Cv_NoCuenta   Varchar2,
                                Cn_AnioInicio Number,
                                Cn_MesInicio  Number,
                                Cn_AnioFin    Number,
                                Cn_MesFin     Number,
                                Cv_NoCia      Varchar2) is
      select a.ano, 
             a.mes, 
             a.che_mes, 
             a.che_anulmesant, 
             a.dep_mes,
             a.deb_mes, 
             a.cre_mes, 
             a.saldo_fin_c, 
             a.saldo_conciliado,
             to_date('01/'||a.mes||'/'||a.ano, 'dd/mm/yyyy') fecha_inicio,
             last_day(to_date('01/'||a.mes||'/'||a.ano, 'dd/mm/yyyy')) fecha_fin
        from naf47_tnet.arckhc a
       where (a.ano*100)+a.mes >= (Cn_AnioInicio*100)+Cn_MesInicio
         and (a.ano*100)+a.mes <= (Cn_AnioFin*100)+Cn_MesFin
         and a.no_cta = Cv_NoCuenta
         and a.no_cia = Cv_NoCia
       order by a.ano, a.mes;
    --
    cursor c_saldos_linea (Cv_NoCuenta Varchar2,
                           Cv_NoCia    Varchar2) is
      select no_cta,
             sal_mes_ant, 
             che_mes, 
             che_anulmesant, 
             dep_mes, 
             deb_mes, 
             cre_mes
        from arckmc a
       where no_cia = Cv_NoCia
         and no_cta = Cv_NoCuenta;
    --
    cursor c_movimientos (Cv_NoCuenta    Varchar2,
                          Cd_FechaInicio date,
                          Cd_FechaFin    date,
                          Cv_NoCia       Varchar2) is
      select nvl(sum(egresos),0) egresos,
             nvl(sum(anulados),0) anulados,
             nvl(sum(depositos),0) depositos,
             nvl(sum(creditos),0) creditos,
             nvl(sum(debitos),0) debitos
        from (select decode(tipo_doc, 'CK', a.monto, 'TR', a.monto, 0) egresos,
                     0 anulados,
                     decode(tipo_doc, 'DP', a.monto, 0) depositos,
                     decode(tipo_doc, 'NC', a.monto, 0) debitos,
                     decode(tipo_doc, 'ND', a.monto, 0) creditos
                from naf47_tnet.arckmm a
               where no_cia = Pv_NoCia
                 and fecha >= Cd_FechaInicio
                 and fecha <= Cd_FechaFin
                 and (estado in ('D','M') OR (estado = 'A' and a.fecha_anulado > Cd_FechaFin))
                 and no_cta = Pv_noCuenta
                 and a.procedencia = 'C'
               union all
              select 0       egresos,
                     a.monto anulados,
                     0       depositos,
                     0       creditos,
                     0       debitos
                from naf47_tnet.arckmm a
               where no_cia = Pv_NoCia
                 and tipo_doc in ('CK', 'TR')
                 and estado = 'A'
                 and fecha < Cd_FechaInicio
                 and fecha_anulado >= Cd_FechaInicio
                 and fecha_anulado <= Cd_FechaFin
                 and no_cta = Pv_noCuenta
                 and a.procedencia = 'C');
    --
    sl  c_saldos_linea%rowtype := null;
    mv  c_movimientos%rowtype := null;
    si  c_saldos_historicos%rowtype := null;
    cta c_cuentas_bancarias%rowtype := null;
    dp  r_documentos;
    --
    Ln_MesAntIni       number := 0;
    Ln_AnioAntIni      number := 0;
    Ln_SaldoInicialMes number := 0;
    Lb_DifHis          boolean := false;
    Lb_DifLin          boolean := false;
    ln_Cantidad        number(5) := 0;
    ld_fechaInicio     date := null;
    Lv_Observaciones   arck_log.observaciones%type := null;
    lc_documentos      arck_log.doc_procesados%type := null;
    --
    Le_Salir           exception;
    --
    
  BEGIN
    
    -- se lee datos de la cueta bancaria a evaluar saldos --
    if c_cuentas_bancarias%isopen then close c_cuentas_bancarias; end if;
    open c_cuentas_bancarias;
    fetch c_cuentas_bancarias into cta;
    if c_cuentas_bancarias%notfound then
      raise le_salir;
    end if;
    close c_cuentas_bancarias;
    
    -- si anio y mes viene por parametro estos seran los periodos iniciales --
    if Pn_AnioInicio is not null then
      cta.anio_inicio := Pn_AnioInicio;
    end if;
    
    if Pn_MesInicio is not null then
      cta.mes_inicio := Pn_MesInicio;
    end if;

    -- se determina perido anterior al inicial para recuperar saldo final ó saldo incial mes inicio --
    if cta.mes_inicio = 1 then
      Ln_AnioAntIni := cta.anio_inicio - 1;
      Ln_MesAntIni := 12;
    else
      Ln_AnioAntIni := cta.anio_inicio;
      Ln_MesAntIni := cta.mes_inicio - 1;
    end if;
    
    -- se recupera el saldo incial del periodo inicial, leyendo el saldo final de mes anterior
    if c_saldos_historicos%isopen then close c_saldos_historicos; end if;
    open c_saldos_historicos (cta.no_cta,
                              Ln_AnioAntIni,
                              Ln_MesAntIni,
                              Ln_AnioAntIni,
                              Ln_MesAntIni,
                              cta.no_cia);
    fetch c_saldos_historicos into si;
    if c_saldos_historicos%notfound then
      Ln_SaldoInicialMes := 0;
    else
      Ln_SaldoInicialMes := si.saldo_fin_c;
    end if;
    close c_saldos_historicos;
    
    
    Lv_Observaciones := 'Validando cuenta: '||Pv_NoCuenta||'.'||chr(13)||' Saldos Historicos';
    /*Lv_Observaciones := Lv_Observaciones||' cta: '||cta.no_cta
                                        ||' Anio Ini: '||Ln_AnioAntIni
                                        ||' Mes Ini: '||Ln_MesAntIni
                                        ||' Ln_SaldoInicialMes: '||Ln_SaldoInicialMes||chr(13);*/

    -- lectura del sldo historico desde donde realiza la actualizacion hasta el periodo proceso --
    for sh in c_saldos_historicos ( cta.no_cta,
                                    cta.anio_inicio,
                                    cta.mes_inicio,
                                    cta.anio_proceso,
                                    cta.mes_proceso,
                                    cta.no_cia) loop

      
      -- se verifican movimientos de periodo evaluado --
      if c_movimientos%isopen then close c_movimientos; end if;
      open c_movimientos( cta.no_cia,
                          sh.fecha_inicio,
                          sh.fecha_fin,
                          cta.no_cia
                        );
      fetch c_movimientos into mv;
      if c_movimientos%notfound then
        mv:= null;
      end if;
      close c_movimientos;

      -- se compara movimientos y saldos historicos
      if mv.egresos != sh.che_mes then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldo Hist Cheque: '||sh.che_mes||' Mov Cheque: '||mv.egresos||(chr(13));
        Lb_DifHis := true;
      end if;
      --
      if mv.anulados != sh.che_anulmesant then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldo Anulados: '||sh.che_anulmesant||' Mov Hist Anulados: '||mv.anulados||chr(13);
        Lb_DifHis := true;
      end if;
      --
      if mv.depositos != sh.dep_mes then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldo Deposito: '||sh.dep_mes||' Mov Hist Deposito: '||mv.depositos||chr(13);
        Lb_DifHis := true;
      end if;
      --
      if mv.creditos != sh.cre_mes then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldo Creditos: '||' Mov Hist creditos: '||mv.egresos||sh.cre_mes||chr(13);
        Lb_DifHis := true;
      end if;
      --
      if mv.debitos != sh.deb_mes then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldo Debitos: '||sh.deb_mes||' Mov Hist Debitos: '||mv.debitos||chr(13);
        Lb_DifHis := true;
      end if;
        
      if sh.saldo_fin_c != (Ln_SaldoInicialMes - mv.egresos + mv.anulados + mv.depositos + mv.debitos - mv.creditos) then
        Lv_Observaciones := Lv_Observaciones||'Periodo: '||sh.Ano||'-'||sh.mes||' Saldos Final Hist: '||sh.saldo_fin_c||' Saldo Final Mov: '||(Ln_SaldoInicialMes - mv.egresos + mv.anulados + mv.depositos + mv.debitos - mv.creditos)||chr(13);
        Lb_DifHis := true;
      end if;
      
      -- se guarda saldo final para verificar siguiente mes como saldo inicial
      Ln_SaldoInicialMes := Ln_SaldoInicialMes -
                            mv.egresos+
                            mv.anulados+
                            mv.depositos +
                            mv.debitos -
                            mv.creditos;
    end loop;
    
    -- si no hubo diferencias se agrega novedad OK --
    if not Lb_DifHis then
      Lv_Observaciones := Lv_Observaciones||' Saldos OK'||chr(13);
    end if;
    
    
    Lv_Observaciones := Lv_Observaciones||'Validando Saldos Linea cuenta: '||Pv_NoCuenta||' Periodo: '||cta.anio_proceso||'-'||cta.mes_proceso||chr(13);

    -- Se verifican los saldos en linea de las cuentas bancarias
    if c_saldos_linea%isopen then close c_saldos_linea; end if;
    open c_saldos_linea (cta.no_cta, cta.no_cia);
    fetch c_saldos_linea into sl;
    if c_saldos_linea%notfound then
      sl := null;
    end if;
    close c_saldos_linea;

    mv := null;
    -- movimientos actuales del periodo procesos
    if c_movimientos%isopen then close c_movimientos; end if;
    open c_movimientos( cta.no_cta,
                        cta.fecha_ini_mes_proc,
                        cta.fecha_fin_mes_proc,
                        cta.no_cia
                      );
    fetch c_movimientos into mv;
    if c_movimientos%notfound then
      mv := null;
    end if;
    close c_movimientos;

    if sl.no_cta is not null then
      -- se verifican saldos mensuales en linea
      -- Saldo inicial Mes diferente
      if nvl(sl.sal_mes_ant,0) != nvl(Ln_SaldoInicialMes,0) then 
        Lv_Observaciones := Lv_Observaciones||' Saldo Inicial Hist: '||nvl(Ln_SaldoInicialMes,0)||' Saldo Incial: '||nvl(sl.sal_mes_ant,0)||chr(13);
        Lb_DifLin := true;
      end if;
      
      --Total Cheques mes diferente
      if nvl(sl.che_mes,0) != nvl(mv.egresos,0) then 
        Lv_Observaciones := Lv_Observaciones||' Saldo Cheques: '||nvl(sl.che_mes,0)||' Mov Cheques: '||nvl(mv.egresos,0)||chr(13);
        Lb_DifLin := true;
      end if; 
      
      --Total CK Anulados mes anterior dif
      if nvl(sl.che_anulmesant,0) != nvl(mv.anulados,0) then 
        Lv_Observaciones := Lv_Observaciones||' Saldo Cheq-Anula: '||nvl(sl.che_anulmesant,0)||' Mov Cheq-Anula: '||nvl(mv.anulados,0)||chr(13);
        Lb_DifLin := true;
      end if; 
      
      -- Total DEP mes diferente
      if nvl(sl.dep_mes,0) != nvl(mv.depositos,0)  then 
        Lv_Observaciones := Lv_Observaciones||' Saldo Depósitos: '||nvl(sl.dep_mes,0)||' Mov Depósitos: '||nvl(mv.depositos,0)||chr(13);
        Lb_DifLin := true;
      end if;
      
      -- Total CRE mes diferente
      if nvl(sl.cre_mes,0) != nvl(mv.creditos,0)  then 
        Lv_Observaciones := Lv_Observaciones||' Saldo Créditos: '||nvl(sl.cre_mes,0)||' Mov Créditos: '||nvl(mv.creditos,0)||chr(13);
        Lb_DifLin := true;
      end if;
      
      -- Total DEB mes diferente
      if nvl(sl.deb_mes,0) != nvl(mv.debitos,0) then
        Lv_Observaciones := Lv_Observaciones||' Saldo Débitos: '||nvl(sl.deb_mes,0)||' Mov Débitos: '||nvl(mv.debitos,0)||chr(13);
        Lb_DifLin := true;
      end if;
    end if;
    
    -- si no hubo diferencias se registra novedad OK
    if not Lb_DifLin then
      Lv_Observaciones := Lv_Observaciones||' Saldos Linea OK'||chr(13);
    end if;
    
    -- se recopilan los documentos procesados --
    loop
      fetch Pr_Documentos into dp;  
      exit when Pr_Documentos%notfound;
      -- se recupera horta inicio proceso --
      if Ln_Cantidad = 0 then
        ld_fechaInicio := dp.fecha_crea;
      end if;
      
      lc_documentos := lc_documentos || dp.no_docu || ';';
      Ln_Cantidad := Ln_Cantidad + 1;
    end loop;
    
    -- no hubo diferencias 
    if not Lb_DifLin and not Lb_DifHis then
      Lv_Observaciones :=  'Ejecutando proceso '||Pv_TipoProceso||'. Cuenta: '||Pv_NoCuenta||' no presenta diferencias.';
    Else
      Lv_Observaciones :=  'Ejecutando proceso '||Pv_TipoProceso||' '||Lv_Observaciones;
    end if;

    
    -- si se presentaron diferencias se inserta log.
    ck_log.p_inserta_log ( Pv_NoCia, 
                           Pv_NoCuenta, 
                           lc_documentos,
                           Lv_Observaciones,
                           ld_fechaInicio);
  EXCEPTION
    WHEN Le_Salir THEN 
      ROLLBACK;
    WHEN OTHERS  THEN
      ROLLBACK;
  END p_verifica_saldos;

  ------------------------------------
  -- procedimiento que registra LOG --
  ------------------------------------
  procedure p_inserta_log ( Pv_NoCia         Varchar2,
                            Pv_NoCuenta      Varchar2,
                            Pc_DocProcesados clob,
                            Pv_Observaciones Varchar2,
                            Pd_FechaIniProc  date) is
    --
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
    cursor c_secuencia is
      select max(secuencia) secuencia
        from arck_log
       where no_cia = Pv_NoCia;
    --
    s  c_secuencia%rowtype := null;
    --
  begin
    
    
    ----------------------
    if c_secuencia%isopen then close c_secuencia; end if;
    open c_secuencia;
    fetch c_secuencia into s;
    close c_secuencia;
    s.secuencia := nvl(s.secuencia,0) + 1;
    ----------------------

      insert into arck_log
           ( no_cia,
             secuencia,
             no_cta,
             doc_procesados,
             observaciones,
             usuario_proceso,
             hora_inicio,
             hora_fin
            )
        values
           ( Pv_NoCia, 
             s.secuencia, 
             Pv_NoCuenta,
             Pc_DocProcesados,
             Pv_Observaciones,
             user,
             Pd_FechaIniProc,
             sysdate);
    --
    commit;
    --
    
  end p_inserta_log;

end ck_log;
/
