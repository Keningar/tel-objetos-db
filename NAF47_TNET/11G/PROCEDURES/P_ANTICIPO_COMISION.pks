create or replace procedure            P_ANTICIPO_COMISION (Pv_Cia           arcgae.no_cia%type,
                                                            Pv_NombreCia     arcgmc.nombre%type,
                                                            Pv_TipoEmpl      arplte.tipo_emp%type,
                                                            Pv_TipoEmplDesc  arplte.descrip%type,
                                                            Pn_Anio          Number,
                                                            Pn_Mes           Number,
                                                            Pv_MsgError      OUT VARCHAR2    ) IS
/*
 * Documentacion para PL_ANTICIPO_COMISION
 * Proceso que genera la historia de pagos y descuentos de comisiones
 * tomando en cuenta el saldo incial entregado por Auditoria Interna
 * el cual tiene corte Diciembre/2015
 * 
 * @author Martha Navarrete <mnavarrete@mtelconet.ec>
 * @version 1.0 27/10/2016
 */

 -- OBTENER LOS CODIDGOS DE INGRESO Y DEDUCCION PARA COMISIONES.
  CURSOR C_CODIGO_INGRESO IS
    Select parametro_alterno 
    FROM GE_PARAMETROS
    Where id_empresa = Pv_Cia
    and id_aplicacion = 'PL'
    and id_grupo_parametro = 'ANTICIPO'
    and parametro = 'INGRESO';

  CURSOR C_CODIGO_DEDUCCION IS
    Select parametro_alterno 
    FROM GE_PARAMETROS
    Where id_empresa = Pv_Cia
    and id_aplicacion = 'PL'
    and id_grupo_parametro = 'ANTICIPO'
    and parametro = 'DEDUCCION';
  --
  CURSOR C_SALD0_INICIAL_HIS (C_NoEmple varchar2) IS
    SELECT ANTICIPO_COMISION
    FROM ARPLHS_ANTICIPO_COMISION 
    WHERE NO_CIA= Pv_Cia 
    AND NO_EMPLE = C_NoEmple;
  --
  CURSOR C_DATOS IS  
    SELECT ME.NO_EMPLE, 
      ME.NOMBRE, 
      ME.CEDULA 
    FROM ARPLHS HS, 
      ARPLME ME 
    WHERE HS.NO_CIA=10 AND ANO>=2015 AND CODIGO IN 
    (   Select parametro_alterno 
        FROM GE_PARAMETROS
        Where id_empresa = Pv_Cia 
        and id_aplicacion = 'PL' 
        and id_grupo_parametro = 'ANTICIPO' 
        and parametro = 'INGRESO'
        UNION
        Select parametro_alterno 
        FROM GE_PARAMETROS
        Where id_empresa = Pv_Cia 
        and id_aplicacion = 'PL' 
        and id_grupo_parametro = 'ANTICIPO' 
        and parametro = 'DEDUCCION')
    AND HS.NO_CIA = ME.NO_CIA 
    AND HS.NO_EMPLE = ME.NO_EMPLE 
    AND ME.TIPO_EMP = Pv_TipoEmpl
    UNION 
    SELECT ME.NO_EMPLE, 
      ME.NOMBRE, ME.CEDULA 
    FROM ARPLHS_ANTICIPO_COMISION AC, 
      ARPLME ME 
    WHERE AC.NO_CIA=Pv_Cia 
    AND AC.TIPO_EMP=Pv_TipoEmpl
    AND AC.NO_CIA=ME.NO_CIA 
    AND AC.NO_EMPLE=ME.NO_EMPLE 
    ORDER BY 2;
  --
  CURSOR C_MONTO_INGRESO_MES (C_NoEmple varchar2, C_CodIngreso varchar2, C_BuscarAnio number, C_BuscarMes number) IS
    SELECT MONTO, 
      COD_PLA
    FROM ARPLHS 
    WHERE NO_CIA=Pv_Cia 
    and no_emple = C_NoEmple 
    AND ANO=C_BuscarAnio 
    and mes=C_BuscarMes 
    and tipo_m='I' 
    and codigo=C_CodIngreso;

  CURSOR C_MONTO_DEDUCCION_MES (C_NoEmple varchar2, C_CodDeduccion varchar2, C_BuscarAnio number, C_BuscarMes number) IS
    SELECT MONTO, 
      COD_PLA
    FROM ARPLHS 
    WHERE NO_CIA=Pv_Cia 
    and no_emple = C_NoEmple 
    AND ANO=C_BuscarAnio 
    and mes=C_BuscarMes 
    and tipo_m='D' 
    and codigo=C_CodDeduccion;
  --
  --
  CURSOR C_MONTO_INGRESO_ACUMULADO (C_NoEmple varchar2, C_CodIngreso varchar2, C_BuscarAnio number, C_BuscarMes number) IS
    SELECT SUM(MONTO) 
    FROM ARPLHS 
    WHERE NO_CIA=Pv_Cia 
    and no_emple = C_NoEmple 
    and (ANO_MES >= '201601' 
    and ANO_MES < to_char((Pn_Anio*100)+Pn_Mes) ) 
    and tipo_m='I' 
    and codigo=C_CodIngreso;    

  CURSOR C_MONTO_DEDUCCION_ACUMULADO (C_NoEmple varchar2, C_CodDeduccion varchar2, C_BuscarAnio number, C_BuscarMes number) IS
    SELECT SUM(MONTO)
    FROM ARPLHS 
    WHERE NO_CIA=Pv_Cia 
    and no_emple = C_NoEmple 
    and (ANO_MES >= '201601' 
    and ANO_MES < to_char((Pn_Anio*100)+Pn_Mes) ) 
    and tipo_m='D' 
    and codigo=C_CodDeduccion;
  --
  --
  CURSOR C_MOVIM_BANCOS_MES (C_CodIngreso varchar2, C_NoEmple varchar2) IS
    Select e.cod_diario, 
      c.monto, 
      'Cta. '||c.no_cta||'  Cheque # '||c.cheque dato_banco, 
      c.com
    from arplmi i, 
      arcgmm m, 
      arcgaeh e, 
      arckce c, 
      arplme p
    where i.no_cia = Pv_Cia 
    and i.no_ingre = C_CodIngreso
    and i.no_cia = m.no_cia 
    and m.ano = Pn_Anio 
    and m.mes = Pn_Mes 
    and m.cuenta = i.cuenta_contable
    and e.no_cia = m.no_cia 
    and e.no_asiento = m.no_asiento 
    and e.origen<>'PL' 
    and e.anulado = 'N'
    and c.no_cia = m.no_cia 
    and c.no_secuencia = m.no_docu
    and p.no_cia = m.no_cia 
    and p.nombre = c.beneficiario 
    and p.no_emple = C_NoEmple;

  CURSOR C_MOVIM_BANCOS_TOTAL (C_CodIngreso varchar2, C_NoEmple varchar2) IS
    Select SUM(c.monto) monto
    from arplmi i, 
      arcgmm m, 
      arcgaeh e, 
      arckce c, 
      arplme p
    where i.no_cia = Pv_Cia 
    and i.no_ingre = C_CodIngreso
    and i.no_cia = m.no_cia 
    and (m.periodo >= '201601' 
    and m.periodo < to_char((Pn_Anio*100)+Pn_Mes)  )
    and m.cuenta = i.cuenta_contable
    and e.no_cia = m.no_cia 
    and e.no_asiento = m.no_asiento 
    and e.origen<>'PL' 
    and e.anulado = 'N'
    and c.no_cia = m.no_cia 
    and c.no_secuencia = m.no_docu
    and p.no_cia = m.no_cia 
    and p.nombre = c.beneficiario 
    and p.no_emple = C_NoEmple;


  -- Declaraciones de variables
  Lv_Parametros       VARCHAR2(4000);
  Lv_Registro         VARCHAR2(4000);
  Ln_secuencia        NUMBER := 0;
  --
  Lv_cod_ingreso      arplmi.no_ingre%Type;
  Lv_cod_deduccion    arplmd.no_dedu%Type;
  Ln_filtro_fecha     Number;
  Ln_anio_anterior    Number;
  Ln_mes_anterior     Number;
  Lv_lee_historico    VARCHAR2(1) := 'N';
  Ln_saldo_inicial    Number(17,2);
  Ln_saldo_final      Number(17,2);
  Ln_monto_ingreso    Number(17,2);
  Lv_codpla_ingreso   VARCHAR2(2);
  Ln_monto_deduccion  Number(17,2);
  Lv_codpla_deduccion VARCHAR2(2);
  --
  Ln_monto_total_banco Number(17,2);
  --
BEGIN
 --Encabezado
  Lv_Parametros := 'COMPANIA:' || ';' || Pv_NombreCia;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,  dato)
                                     VALUES (Pv_Cia,   user, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'RESUMEN DE ANTICIPOS DE COMISIONES';
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,  dato)
                                     VALUES (Pv_Cia,   user, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'TIPO DE EMPLEADO:' || ';' || Pv_TipoEmplDesc;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,  dato)
                                    VALUES (Pv_Cia,   user, Ln_secuencia, Lv_Parametros);
  --
  Lv_Parametros := 'ANIO :' || Pn_Anio || ';' || 'MES :' || Pn_Mes ;
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,  dato)
                                     VALUES (Pv_Cia,   user, Ln_secuencia, Lv_Parametros);
    --
  Lv_Parametros := 'TIPO EMPLEADO'||';'||'EMPLEADO'||';'||'CEDULA'||';'||'NOMBRE'||';'||
                   'ANIO'||';'||'MES'||';'||'SALDO INICIAL'||';'||'TIPO INGRESO'||';'||'INGRESO'||';'||
                   'TIPO DEDUCCION'||';'||'DEDUCCION'||';'||'SALDO FINAL'||';'||'DATOS BANCO'||';'||'COMENTARIO';
  Ln_secuencia := Ln_secuencia + 1;
  INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,  dato)
                                     VALUES (Pv_Cia,   user, Ln_secuencia, Lv_Parametros);

  --****************************************************************
  -- OBTENER LOS CODIGOS DE INGRESO Y DEDUCCION
  --****************************************************************
  IF C_CODIGO_INGRESO%ISOPEN THEN 
    CLOSE C_CODIGO_INGRESO;  
  END IF;
  
  OPEN  C_CODIGO_INGRESO;
  FETCH C_CODIGO_INGRESO INTO Lv_cod_ingreso;
  CLOSE C_CODIGO_INGRESO;

  IF C_CODIGO_DEDUCCION%ISOPEN THEN 
    CLOSE C_CODIGO_DEDUCCION;  
  END IF;
  
  OPEN  C_CODIGO_DEDUCCION;
  FETCH C_CODIGO_DEDUCCION INTO Lv_cod_deduccion;
  CLOSE C_CODIGO_DEDUCCION;

  -- OBTENER TODOS LOS CODIGO DE EMPLEADOS QUE TIENEN MOVIMIENTO EN LE ANIO Y MES
  Ln_filtro_fecha := (Pn_Anio * 100) + Pn_Mes;

  If Ln_filtro_fecha = 201601 Then 
    Ln_anio_anterior := 2015; 
    Ln_mes_anterior := 12; 
    Lv_lee_historico := 'S';  
  End if;

  If Ln_filtro_fecha > 201601 Then
    If  Pn_Mes = 12 Then  
        Ln_anio_anterior := Pn_Anio - 1;  
        Ln_mes_anterior := 1;
      else
        Ln_anio_anterior := Pn_Anio;  
        Ln_mes_anterior := Pn_Mes - 1;
    End if;
  End if;

  -- OBTENER TODOS LOS DOCUMENTOS ANTERIORES A LA FECHA INDICADA Y EL GRUPO.
  IF NVL(Lv_lee_historico,'N') = 'S'  Then

    -- Se determina codigos de empleados a presentar
    For Lc_Datos in C_DATOS  loop -- I_Datos

      Ln_saldo_final := 0;
      Ln_monto_ingreso := 0;
      Lv_codpla_ingreso := '';
      Ln_monto_deduccion := 0;
      Lv_codpla_deduccion := '';
      --
      Open  C_SALD0_INICIAL_HIS (Lc_Datos.NO_EMPLE);
      Fetch C_SALD0_INICIAL_HIS into Ln_saldo_inicial;
      Close C_SALD0_INICIAL_HIS;

      Open  C_MONTO_INGRESO_MES (Lc_Datos.NO_EMPLE, Lv_cod_ingreso, Pn_Anio, Pn_Mes);
      Fetch C_MONTO_INGRESO_MES into Ln_monto_ingreso, Lv_codpla_ingreso;
      Close C_MONTO_INGRESO_MES;

      Open  C_MONTO_DEDUCCION_MES (Lc_Datos.NO_EMPLE, Lv_cod_deduccion, Pn_Anio, Pn_Mes);
      Fetch C_MONTO_DEDUCCION_MES into Ln_monto_deduccion, Lv_codpla_deduccion;
      Close C_MONTO_DEDUCCION_MES;

      Ln_saldo_final := nvl(Ln_saldo_inicial,0) + nvl(Ln_monto_ingreso,0) - nvl(Ln_monto_deduccion,0);

      Lv_Registro := ''''||Pv_TipoEmplDesc||';'||Lc_Datos.NO_EMPLE||';'||Lc_Datos.CEDULA||';'||Lc_Datos.NOMBRE||';'||Pn_Anio||';'||
                        Pn_Mes||';'||Ln_saldo_inicial||';'||Lv_codpla_ingreso||';'||Ln_monto_ingreso||';'||
                        Lv_codpla_deduccion||';'||Ln_monto_deduccion ||';'|| Ln_saldo_final ;
      Ln_secuencia := Ln_secuencia + 1;

      INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,    dato)
                                         VALUES (Pv_Cia, user,    Ln_secuencia, Lv_Registro);

      --****************************************************************
      -- MOVIMIENTOS GENERADOS DESDE BANCOS
      --****************************************************************
      For Lc_MovBancos in C_MOVIM_BANCOS_MES (Lv_cod_ingreso, Lc_Datos.NO_EMPLE) loop

        Lv_Registro := ''''||Pv_TipoEmplDesc||';'||Lc_Datos.NO_EMPLE||';'||Lc_Datos.CEDULA||';'||Lc_Datos.NOMBRE||';'||
                             Pn_Anio||';'||Pn_Mes||';'|| 0 ||';'||Lc_MovBancos.cod_diario||';'||Lc_MovBancos.monto||';;;'|| 
                             Lc_MovBancos.monto||';'||Lc_MovBancos.dato_banco||';'||Lc_MovBancos.com;
        Ln_secuencia := Ln_secuencia + 1;

        INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,    dato)
                                           VALUES (Pv_Cia, user,    Ln_secuencia, Lv_Registro);
      End loop;
     --
    End Loop;  -- C_DATOS_HISTORIA

  ELSE
    --****************************************************************
    -- DATOS DIFERENTES A DICIEMBRE/2015
    --****************************************************************
    For Lc_Diferente in C_DATOS  loop   --  I_Diferente
      --*********************************************
      -- SALDO ANTERIOR DIFERENTE A DICIEMBRE/2015
      --*********************************************
      Ln_saldo_inicial := 0;
      Ln_saldo_final   := 0;
      --
      Ln_monto_ingreso := 0;
      Lv_codpla_ingreso := '';
      Ln_monto_deduccion := 0;
      Lv_codpla_deduccion := '';
      --
      Open  C_SALD0_INICIAL_HIS (Lc_Diferente.NO_EMPLE);
      Fetch C_SALD0_INICIAL_HIS into Ln_saldo_inicial;
      Close C_SALD0_INICIAL_HIS;
                               
      Open  C_MOVIM_BANCOS_TOTAL (Lv_cod_ingreso, Lc_Diferente.no_emple);
      Fetch C_MOVIM_BANCOS_TOTAL into Ln_monto_total_banco;
      Close C_MOVIM_BANCOS_TOTAL;

      Open  C_MONTO_INGRESO_ACUMULADO (Lc_Diferente.no_emple, Lv_cod_ingreso, Ln_anio_anterior, Ln_mes_anterior);
      Fetch C_MONTO_INGRESO_ACUMULADO into Ln_monto_ingreso;
      Close C_MONTO_INGRESO_ACUMULADO;

      Open  C_MONTO_DEDUCCION_ACUMULADO (Lc_Diferente.no_emple, Lv_cod_deduccion, Ln_anio_anterior, Ln_mes_anterior);
      Fetch C_MONTO_DEDUCCION_ACUMULADO into Ln_monto_deduccion;
      Close C_MONTO_DEDUCCION_ACUMULADO;

      Ln_saldo_inicial := nvl(Ln_saldo_inicial,0) + nvl(Ln_monto_total_banco,0) + 
                          nvl(Ln_monto_ingreso,0) - nvl(Ln_monto_deduccion,0);
      --  Datos del mes 
      Ln_monto_ingreso := 0;
      Lv_codpla_ingreso := '';
      Ln_monto_deduccion := 0;
      Lv_codpla_deduccion := '';

      Open  C_MONTO_INGRESO_MES (Lc_Diferente.no_emple, Lv_cod_ingreso, Pn_Anio, Pn_Mes);
      Fetch C_MONTO_INGRESO_MES into Ln_monto_ingreso, Lv_codpla_ingreso;
      Close C_MONTO_INGRESO_MES;

      Open  C_MONTO_DEDUCCION_MES (Lc_Diferente.no_emple, Lv_cod_deduccion, Pn_Anio, Pn_Mes);
      Fetch C_MONTO_DEDUCCION_MES into Ln_monto_deduccion, Lv_codpla_deduccion;
      Close C_MONTO_DEDUCCION_MES;
      --
      Ln_saldo_final := nvl(Ln_saldo_inicial,0) + nvl(Ln_monto_ingreso,0) - nvl(Ln_monto_deduccion,0);

      Lv_Registro := ''''||Pv_TipoEmplDesc||';'||Lc_Diferente.NO_EMPLE||';'||Lc_Diferente.CEDULA||';'||Lc_Diferente.NOMBRE||';'||
                           Pn_Anio||';'||Pn_Mes||';'||Ln_saldo_inicial||';'||Lv_codpla_ingreso||';'||Ln_monto_ingreso||';'||
                           Lv_codpla_deduccion||';'||Ln_monto_deduccion ||';'|| Ln_saldo_final ;
      Ln_secuencia := Ln_secuencia + 1;

      INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,    dato)
                                         VALUES (Pv_Cia, user,    Ln_secuencia, Lv_Registro);

      --****************************************************************
      -- MOVIMIENTOS GENERADOS DESDE BANCOS
      --****************************************************************
      For Lc_MovMes in C_MOVIM_BANCOS_MES (Lv_cod_ingreso, Lc_Diferente.NO_EMPLE) loop

        Lv_Registro := ''''||Pv_TipoEmplDesc||';'||Lc_Diferente.NO_EMPLE||';'||Lc_Diferente.CEDULA||';'||Lc_Diferente.NOMBRE
                      ||';'||Pn_Anio||';'||Pn_Mes||';'|| 0 ||';'||Lc_MovMes.cod_diario||';'||Lc_MovMes.monto
                      ||';;;'||Lc_MovMes.monto;
        Ln_secuencia := Ln_secuencia + 1;

        INSERT INTO ARPLREPORTE_ANTICIPO_COMISION (no_cia, usuario, secuencia,    dato)
                                           VALUES (Pv_Cia,   user,  Ln_secuencia, Lv_Registro);
      End loop;
      --
    End loop;
  End if;
  --
  --
EXCEPTION
  WHEN others then
       Pv_MsgError := 'P_ANTICIPO_COMISION : Error en insercion';
       return;
END P_ANTICIPO_COMISION;