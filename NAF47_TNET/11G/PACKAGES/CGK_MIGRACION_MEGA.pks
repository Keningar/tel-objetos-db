CREATE OR REPLACE PACKAGE            CGK_MIGRACION_MEGA IS

  -- Author  : EMUNOZ
  -- Created : 24/01/2013 15:28:00
  -- Purpose :

  /*
  * Mejora para aumento del campo glosa parametrizado el maximo de la glosa
  * @tag  JXZURITA-AUMENTO CAMPO GLOSA
  * @author jxzurita <jxzurita@telconet.ec>
  * @version 2.0 06/10/2021
  */
  
  

  --------------------------------------------
  -- procdimiento que carga Plan de Cuentas --
  --------------------------------------------
  PROCEDURE CGP_PLAN_CUENTAS(Pv_NoCia        IN VARCHAR2,
                             Pv_MensajeError IN OUT VARCHAR2);

  ------------------------------------------------
  -- Procedimiento que carga el balance general --
  ------------------------------------------------
  PROCEDURE CGP_BALANCE_GENERAL(Pv_NoCia        IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2);

  -------------------------------------
  -- Migración de Asientos Contables --
  -------------------------------------
  PROCEDURE CGP_ASIENTOS_CONTABLES(Pv_NoCia        IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2);
  -----------------------------------------------
  -- Precedimiento que inserta Cuenta Contable --
  -----------------------------------------------
  PROCEDURE CGP_INSERTA_CUENTA(Pr_PlanCuentas  IN OUT ARCGMS%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);
  ------------------------------------------------
  -- Procedimiento que inserta Asiento Contable --
  ------------------------------------------------
  PROCEDURE CGP_INSERTA_ASIENTO(Pr_AsientoContable IN OUT ARCGAE%ROWTYPE,
                                Pv_MensajeError    IN OUT VARCHAR2);
  ------------------------------------------------------------
  -- Procedimiento que inserta detalle de asiento contable. --
  ------------------------------------------------------------
  PROCEDURE CGP_INSERTA_DETALLE(Pr_DetalleAsiento IN OUT ARCGAL%ROWTYPE,
                                Pv_MensajeError   IN OUT VARCHAR2);
  --
  --Procedimiento que registra las facturas
  --
  PROCEDURE CGP_FACTURAS(Pv_IdEmpresa    IN VARCHAR2,
                         Pv_FechaDesde   IN VARCHAR2,
                         Pv_FechaHasta   IN VARCHAR2,
                         Pv_MensajeError OUT VARCHAR2);
  --Procedimiento que inserta el detalle contable
  PROCEDURE CGP_INSERTA_MOVIMIENTO(Pr_MovimientoFact IN ARCPDC%ROWTYPE,
                                   Pv_MensajeError   OUT VARCHAR2);

  --Procedimiento que inserta impuestos
  PROCEDURE CGP_INSERTA_IMPUESTO(Pr_Impuestos    IN ARCPTI%ROWTYPE,
                                 Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CP_GENERA_NC_MEGA(pCia          arcgae.no_cia%TYPE,
                              pMesAno_proce VARCHAR2,
                              pCod_Asiento  CG_M_ASIENTO_CONTABLE.Codigo_Asiento%TYPE,
                              pMsg_error    OUT VARCHAR2);

  --Procedimiento que migra las liquidaciones de compras
  PROCEDURE CGP_LIQUI_COMPRAS(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_FechaDesde   IN VARCHAR2,
                              Pv_FechaHasta   IN VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2);

  --Procedimiento que migra las facturas de costos y las de provisiones 
  PROCEDURE CGP_FACTURAS_25(Pv_IdEmpresa    IN VARCHAR2,
                            Pv_FechaDesde   IN VARCHAR2,
                            Pv_FechaHasta   IN VARCHAR2,
                            Pv_MensajeError OUT VARCHAR2);

  --Procedimiento que migra las liquidaciones de compras
  PROCEDURE CGP_FACTURAS_08(Pv_IdEmpresa    IN VARCHAR2,
                            Pv_FechaDesde   IN VARCHAR2,
                            Pv_FechaHasta   IN VARCHAR2,
                            Pv_MensajeError OUT VARCHAR2);

  --Procedimiento los diarios registrados como Tipo 01_05_07_11_12_14_20_21_26
  --01 DIARIOS
  --05 FACTURACION
  --07 FACTURAS MANUALES
  --11 NOTAS DE CREDITO
  --12 DIARIO DE AJUSTE
  --14 DIARIO DE AJUSTES CLIENTES
  --20 INGRESO CIERRES DE CAJA
  --21 INGRESOS GUAYAQUIL
  --26 DEPOSITOS COSTA
  PROCEDURE CGP_MIGRA_TIPOS_DIARIOS(Pv_IdEmpresa    IN VARCHAR2,
                                    Pv_FechaDesde   IN VARCHAR2,
                                    Pv_FechaHasta   IN VARCHAR2,
                                    Pv_MensajeError OUT VARCHAR2);
  --Procedimiento que inserta la distribucion iva
  PROCEDURE CGP_INSERTA_DET_IVA(Pr_DistribucionIVA IN CP_DETALLE_TRIBUTO_IVA%ROWTYPE,
                                Pv_MensajeError    OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_DOCUMENTO(Pr_Documentos   IN ARCPMD%ROWTYPE,
                                  Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_DET_CONTABLE(Pr_DetalleContable IN ARCPDC%ROWTYPE,
                                     Pv_MensajeError    OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_RETENCIONES(Pr_Retenciones  IN ARCPTI%ROWTYPE,
                                    Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_ARCKCE(Pr_Arckce       IN ARCKCE%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_ARCKCL(Pr_Arckcl       IN ARCKCL%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_ARCKRD(Pr_Arckrd       IN ARCKRD%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_ARCKMM(Pr_Arckmm       IN ARCKMM%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INSERTA_ARCKML(Pr_Arckml       IN ARCKML%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_CONSULTA_DESCUADRE(Pv_IdEmpresa    IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CGP_INICIALIZA(Pv_IdEmpresa    IN VARCHAR2,
                           Pv_Fecha        IN VARCHAR2,
                           Pv_Inicializa   IN VARCHAR2,
                           Pv_MensajeError OUT VARCHAR2);
  --arckcl**
--arckrd**
--arckmm**
--arckml    
/*PROCEDURE CGP_INSERTA_ARCGAE(Pr_Arcgae       IN ARCGAE%ROWTYPE,
                             Pv_MensajeError OUT VARCHAR2);*/
END CGK_MIGRACION_MEGA;
/


CREATE OR REPLACE PACKAGE BODY            CGK_MIGRACION_MEGA IS
  --------------------------------------------
  -- procdimiento que carga Plan de Cuentas --
  --------------------------------------------
  PROCEDURE CGP_PLAN_CUENTAS(Pv_NoCia        IN VARCHAR2,
                             Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR c_cuentas_contables IS
      SELECT *
        FROM cg_m_plan_cuentas
       WHERE compania = Pv_NoCia
       ORDER BY 2;
    --
    CURSOR c_verifica_cuenta(Cv_NoCuenta   VARCHAR2,
                             Cv_NoCompania VARCHAR2) IS
      SELECT *
        FROM arcgms a
       WHERE a.cuenta = Cv_NoCuenta
         AND a.no_cia = Cv_NoCompania;
    --
    CURSOR c_verifica_cuenta_migra(Cv_NoCuenta   VARCHAR2,
                                   Cv_NoCompania VARCHAR2) IS
      SELECT *
        FROM cg_m_plan_cuentas a
       WHERE a.ID_CUENTA_CONTABLE = Cv_NoCuenta
         AND a.COMPANIA = Cv_NoCompania;
    --
    Lr_CtaCble     arcgms%ROWTYPE := NULL;
    Lv_CuentaPadre arcgms.cuenta%TYPE := NULL;
    --
    Lr_ExisteCta arcgms%ROWTYPE := NULL;
    Lr_CtaPadre  CG_M_PLAN_CUENTAS%ROWTYPE := NULL;
    --Lr_CtaPadre_MIGRA CG_M_PLAN_CUENTAS%ROWTYPE := NULL;
    --Lr_Cuentas   arcgms%ROWTYPE := NULL;
    Le_Error EXCEPTION;
    --
  BEGIN
    -- se cambia la cuanta sin formato
  
    FOR Lr_Migrar IN c_cuentas_contables LOOP
      -- Se inicializa
      Lr_CtaCble := NULL;
      -- Se Asigna los datos a variables
      Lr_CtaCble.No_Cia       := Lr_Migrar.Compania;
      Lr_CtaCble.Cuenta       := RPAD(Lr_Migrar.Id_Cuenta_Contable, '10', '0');
      Lr_CtaCble.Descri       := SUBSTR(Lr_Migrar.Nombre, 1, 35);
      Lr_CtaCble.Descri_Larga := SUBSTR(Lr_Migrar.Nombre, 1, 100);
      Lr_CtaCble.Tipo         := Lr_Migrar.Tipo;
      Lr_CtaCble.Clase        := Lr_Migrar.Clase;
      Lr_CtaCble.Naturaleza   := Lr_Migrar.Naturaleza;
      Lr_CtaCble.Ind_Mov      := Lr_Migrar.Ultimo_Nivel;
    
      CASE LENGTH(Lr_CtaCble.Cuenta)
      --when 13 then Lr_CtaCble.Nivel := 7;
        WHEN 10 THEN
          Lr_CtaCble.Nivel := 6;
        WHEN 7 THEN
          Lr_CtaCble.Nivel := 5;
        WHEN 5 THEN
          Lr_CtaCble.Nivel := 4;
        WHEN 3 THEN
          Lr_CtaCble.Nivel := 3;
        WHEN 2 THEN
          Lr_CtaCble.Nivel := 2;
        WHEN 1 THEN
          Lr_CtaCble.Nivel := 1;
      END CASE;
    
      CASE LENGTH(Lr_Migrar.Id_Cuenta_Contable)
      --when 13 then Lv_CuentaPadre := Substr(Lr_Migrar.Id_Cuenta_Contable,1,10);
        WHEN 10 THEN
          Lv_CuentaPadre := SUBSTR(Lr_Migrar.Id_Cuenta_Contable, 1, 7);
        WHEN 7 THEN
          Lv_CuentaPadre := SUBSTR(Lr_Migrar.Id_Cuenta_Contable, 1, 5);
        WHEN 5 THEN
          Lv_CuentaPadre := SUBSTR(Lr_Migrar.Id_Cuenta_Contable, 1, 3);
        WHEN 3 THEN
          Lv_CuentaPadre := SUBSTR(Lr_Migrar.Id_Cuenta_Contable, 1, 2);
        WHEN 2 THEN
          Lv_CuentaPadre := SUBSTR(Lr_Migrar.Id_Cuenta_Contable, 1, 1);
        WHEN 1 THEN
          Lv_CuentaPadre := NULL;
      END CASE;
    
      --Lr_CtaCble.Padre := rpad(Lv_CuentaPadre,'13','0');
      Lr_CtaCble.Padre := RPAD(Lv_CuentaPadre, '10', '0');
      --Lr_CtaCble.Cuenta := rpad(Lr_Migrar.Id_Cuenta_Contable,'13','0');
      Lr_CtaCble.Cuenta := RPAD(Lr_Migrar.Id_Cuenta_Contable, '10', '0');
      Lr_CtaCble.Nivel  := Lr_Migrar.Nivel;
      -- se valida si la cuenta existe
      IF c_verifica_cuenta%ISOPEN THEN
        CLOSE c_verifica_cuenta;
      END IF;
      OPEN c_verifica_cuenta(Lr_CtaCble.Cuenta, --se cambia a formato NAF
                             Lr_CtaCble.No_Cia);
      FETCH c_verifica_cuenta
        INTO Lr_ExisteCta;
      IF c_verifica_cuenta%NOTFOUND THEN
        Lr_ExisteCta := NULL;
      END IF;
      CLOSE c_verifica_cuenta;
    
      -- La cuenta existe, solo se actualiza
      IF Lr_ExisteCta.cuenta IS NOT NULL THEN
      
        UPDATE arcgms a
           SET a.descri       = SUBSTR(Lr_CtaCble.Descri, 1, 35),
               a.descri_larga = SUBSTR(Lr_CtaCble.Descri_Larga, 1, 100),
               --a.nivel             = Lr_CtaCble.Nivel,
               a.ind_mov           = Lr_CtaCble.Ind_Mov,
               a.debitos           = 0,
               a.creditos          = 0,
               a.saldo_per_ant     = 0,
               a.saldo_mes_ant     = 0,
               a.saldo_per_ant_dol = 0,
               a.saldo_mes_ant_dol = 0,
               a.debitos_dol       = 0,
               a.creditos_dol      = 0,
               creditos_pend       = 0,
               debitos_pend        = 0,
               presup_cambio       = 'N',
               monetaria           = 'N',
               tcambio_conversion  = 'C',
               naturaleza          = Lr_Migrar.Naturaleza,
               nivel               = Lr_Migrar.Nivel
         WHERE a.cuenta = Lr_Migrar.Id_Cuenta_Contable
           AND a.no_cia = Lr_Migrar.Compania;
        --
      
      ELSE
      
        -- se recupera cuenta contable padre para que cuenta nueva herede los mismo atributos
        Lr_CtaPadre := NULL;
        IF c_verifica_cuenta_migra%ISOPEN THEN
          CLOSE c_verifica_cuenta_migra;
        END IF;
        OPEN c_verifica_cuenta_migra(Lr_CtaCble.Padre, Lr_CtaCble.No_Cia);
        FETCH c_verifica_cuenta_migra
          INTO Lr_CtaPadre;
        IF c_verifica_cuenta_migra%NOTFOUND THEN
          Pv_MensajeError := 'No existe cuenta padre ' || cuenta_contable.formatea(Lr_CtaCble.No_Cia, Lr_CtaCble.Padre);
          RAISE Le_Error;
        END IF;
        CLOSE c_verifica_cuenta_migra;
        --
        --
        -- se valida si la cuenta existe
        --
        IF Lr_CtaCble.Naturaleza IS NULL THEN
          Lr_CtaCble.Naturaleza := Lr_CtaPadre.Naturaleza;
        END IF;
      
        CGK_MIGRACION_MEGA.CGP_INSERTA_CUENTA(Lr_CtaCble, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        --
      END IF;
      -- se actualiza la cuenta NAF
      UPDATE cg_m_plan_cuentas a
         SET a.id_cuenta_naf = Lr_CtaCble.Cuenta
       WHERE a.id_cuenta_contable = Lr_Migrar.Id_Cuenta_Contable
         AND a.compania = Lr_Migrar.Compania;
    
    END LOOP;
  
    --dbms_output.put_line ('Se han insertado '||Ln_Inserta||' cuentas nuevas y actualizado '||Ln_Actualiza||' cuentas ya existentes');
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error al procesar migracion. ' || Lr_CtaCble.Cuenta || '  ' || Lr_CtaCble.Descri || '  ' || Lr_CtaCble.Nivel || ' ' || Lr_CtaCble.Ind_Mov || SQLERRM;
      ROLLBACK;
  END CGP_PLAN_CUENTAS;

  ------------------------------------------------
  -- Procedimiento que carga el balance general --
  ------------------------------------------------
  PROCEDURE CGP_BALANCE_GENERAL(Pv_NoCia        IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2) IS
    CURSOR c_saldos_migrar IS
      SELECT a.compania,
             b.id_cuenta_naf,
             a.saldo,
             b.tipo,
             b.naturaleza,
             DECODE(b.tipo, 'AC', DECODE(sign(a.saldo), 1, a.saldo, -1, 0), 'PA', DECODE(sign(a.saldo), 1, 0, -1, (a.saldo * -1)), 'PT', DECODE(sign(a.saldo), 1, 0, -1, (a.saldo * -1))) debito,
             DECODE(b.tipo, 'AC', DECODE(sign(a.saldo), 1, 0, -1, (a.saldo * -1)), 'PA', DECODE(sign(a.saldo), 1, a.saldo, -1, 0), 'PT', DECODE(sign(a.saldo), 1, a.saldo, -1, 0)) credito
        FROM cg_m_balance_general a,
             cg_m_plan_cuentas    b
       WHERE a.id_cuenta_contable = b.id_cuenta_contable
         AND a.compania = b.compania
         AND b.ultimo_nivel = 'S'
         AND A.SALDO <> 0
         AND a.compania = Pv_NoCia
       ORDER BY a.id_cuenta_contable;
    --
    CURSOR c_asiento_apertura IS
      SELECT *
        FROM arcgae a
       WHERE a.origen = 'AP'
         AND a.no_cia = Pv_NoCia;
    --
    CURSOR C_TotalAsiento(Cv_IdEmpresa IN VARCHAR2) IS
      SELECT SUM(DECODE(TIPO, 'D', NVL(MONTO, 0), 0)) DEBITO,
             SUM(DECODE(TIPO, 'C', 0, NVL(MONTO, 0))) CREDITO,
             C.NO_ASIENTO
        FROM ARCGAL D,
             ARCGAE C
       WHERE D.NO_ASIENTO = C.NO_ASIENTO
         AND D.NO_CIA = C.NO_CIA
         AND C.ORIGEN = 'AP'
         AND C.NO_CIA = Cv_IdEmpresa
       GROUP BY C.NO_ASIENTO;
  
    Lr_CabAsiento ARCGAE%ROWTYPE := NULL;
    Lr_DetAsiento ARCGAL%ROWTYPE := NULL;
    Le_Error EXCEPTION;
    --
  BEGIN
    -- se busca el asiento apertura
    IF c_asiento_apertura%ISOPEN THEN
      CLOSE c_asiento_apertura;
    END IF;
    OPEN c_asiento_apertura;
    FETCH c_asiento_apertura
      INTO Lr_CabAsiento;
    IF c_asiento_apertura%NOTFOUND THEN
      Lr_CabAsiento.No_Cia     := Pv_NoCia;
      Lr_CabAsiento.Fecha      := TO_DATE('01/01/2013', 'DD/MM/YYYY');
      Lr_CabAsiento.Descri1    := 'SALDOS INICIALES AL 01/01/2013';
      Lr_CabAsiento.t_Debitos  := 0;
      Lr_CabAsiento.t_Creditos := 0;
      Lr_CabAsiento.Cod_Diario := 'P';
      Lr_CabAsiento.Origen     := 'AP';
    
      -- se debe validar que la fecha con que se va a crear se enceuntre dentro del periodo proceso.
    
      CGK_MIGRACION_MEGA.CGP_INSERTA_ASIENTO(Lr_CabAsiento, Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    ELSE
      -- si existe se procede a eliminar pues se va a reprocesar
    
      -- se debe validar que la fecha con que se va a crear se enceuntre dentro del periodo proceso.
    
      DELETE arcgal
       WHERE no_asiento = Lr_CabAsiento.No_Asiento
         AND no_cia = Lr_CabAsiento.No_Cia;
    END IF;
    CLOSE c_asiento_apertura;
  
    -- insercion de detalle
    FOR bg IN c_saldos_migrar LOOP
      -- inicializacion
      Lr_DetAsiento := NULL;
      -- asignacion
      Lr_DetAsiento.no_cia       := Lr_CabAsiento.No_Cia;
      Lr_DetAsiento.no_asiento   := Lr_CabAsiento.No_Asiento;
      Lr_DetAsiento.Ano          := Lr_CabAsiento.Ano;
      Lr_DetAsiento.Mes          := Lr_CabAsiento.Mes;
      Lr_DetAsiento.cuenta       := bg.id_cuenta_naf;
      Lr_DetAsiento.descri       := SUBSTR(Lr_CabAsiento.Descri1, 1, 100);
      Lr_DetAsiento.cod_diario   := Lr_CabAsiento.Cod_Diario;
      Lr_DetAsiento.fecha        := Lr_CabAsiento.Fecha;
      Lr_DetAsiento.centro_costo := '000000000';
      Lr_DetAsiento.Tipo         := bg.naturaleza;
      Lr_DetAsiento.monto_dol    := Lr_DetAsiento.monto;
      Lr_DetAsiento.cc_1         := '000';
      Lr_DetAsiento.cc_2         := '000';
      Lr_DetAsiento.cc_3         := '000';
    
      IF bg.Debito > 0 THEN
        Lr_DetAsiento.tipo  := 'D';
        Lr_DetAsiento.monto := bg.debito;
      ELSIF bg.Credito > 0 THEN
        Lr_DetAsiento.tipo  := 'C';
        Lr_DetAsiento.monto := bg.credito * -1;
      END IF;
      --dbms_output.put_line(Lr_DetAsiento.Cuenta);
      CGK_MIGRACION_MEGA.CGP_INSERTA_DETALLE(Lr_DetAsiento, Pv_MensajeError);
      --
      --Pv_MensajeError := Pv_MensajeError || ', Cuenta ' || Lr_DetAsiento.cuenta;
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END LOOP;
    --
    IF C_TotalAsiento%ISOPEN THEN
      CLOSE C_TotalAsiento;
    END IF;
    OPEN C_TotalAsiento(Pv_NoCia);
    FETCH C_TotalAsiento
      INTO Lr_CabAsiento.t_Debitos,
           Lr_CabAsiento.t_Creditos,
           Lr_CabAsiento.No_Asiento;
    CLOSE C_TotalAsiento;
    --
    UPDATE ARCGAE G
       SET G.T_DEBITOS  = Lr_CabAsiento.t_Debitos,
           G.T_CREDITOS = Lr_CabAsiento.t_Creditos
     WHERE G.NO_ASIENTO = Lr_CabAsiento.No_Asiento
       AND G.NO_CIA = Pv_NoCia;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'CGK_MIGRACION_MEGA.CGP_BALANCE_GENERAL: ' || Lr_DetAsiento.Cuenta || ' ' || Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'CGK_MIGRACION_MEGA.CGP_BALANCE_GENERAL, Error no controlado. ' || SQLERRM;
      ROLLBACK;
  END;

  -------------------------------------
  -- Migracion de Asientos Contables --
  -------------------------------------
  PROCEDURE CGP_ASIENTOS_CONTABLES(Pv_NoCia        IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR c_cabecera IS
      SELECT *
        FROM cg_m_asiento_contable a
       WHERE a.compania = Pv_NoCia
       ORDER BY a.fecha;
    --
    CURSOR c_detalleasiento(Pv_NoAsiento   VARCHAR2,
                            Pv_TipoAsiento VARCHAR2,
                            Pv_NoCompania  VARCHAR2) IS
      SELECT *
        FROM cg_m_detalle_asiento a
       WHERE a.id_asiento = Pv_NoAsiento
         AND a.tipo_asiento = Pv_TipoAsiento
         AND a.compania = Pv_NoCompania;
    --
    CURSOR c_homologacion_cuenta(Pv_IdCuenta   VARCHAR2,
                                 Pv_NoCompania VARCHAR2) IS
      SELECT a.id_cuenta_naf
        FROM cg_m_plan_cuentas a
       WHERE a.id_cuenta_contable = Pv_IdCuenta
         AND a.compania = Pv_NoCompania;
    --
  
    --
    Lr_CabAsiento arcgae%ROWTYPE := NULL;
    Lr_DetAsiento arcgal%ROWTYPE := NULL;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
  
    FOR Lr_MigrAsiento IN c_cabecera LOOP
      Lr_CabAsiento := NULL;
      --
      Lr_CabAsiento.No_Cia     := Lr_MigrAsiento.Compania;
      Lr_CabAsiento.Fecha      := Lr_MigrAsiento.Fecha;
      Lr_CabAsiento.Descri1    := SUBSTR(Lr_MigrAsiento.Concepto, 1, 240);
      Lr_CabAsiento.t_Debitos  := Lr_MigrAsiento.Total_Debitos;
      Lr_CabAsiento.t_Creditos := Lr_MigrAsiento.Total_Creditos;
      Lr_CabAsiento.Cod_Diario := Lr_MigrAsiento.Tipo_Asiento;
    
      CGK_MIGRACION_MEGA.CGP_INSERTA_ASIENTO(Lr_CabAsiento, Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    
      FOR Lr_MigraDetalle IN c_detalleasiento(Lr_MigrAsiento.Id_Asiento, Lr_MigrAsiento.Tipo_Asiento, Lr_MigrAsiento.Compania) LOOP
        IF c_homologacion_cuenta%ISOPEN THEN
          CLOSE c_homologacion_cuenta;
        END IF;
        OPEN c_homologacion_cuenta(Lr_MigraDetalle.Id_Cuenta_Contable, Lr_MigraDetalle.Compania);
        FETCH c_homologacion_cuenta
          INTO Lr_DetAsiento.Cuenta;
        IF c_homologacion_cuenta%NOTFOUND THEN
          Pv_MensajeError := 'No se ha homologado cuenta: ' || Lr_MigraDetalle.Id_Cuenta_Contable;
          RAISE Le_Error;
        END IF;
        CLOSE c_homologacion_cuenta;
      
        Lr_DetAsiento.no_cia       := Lr_CabAsiento.No_Cia;
        Lr_DetAsiento.ano          := TO_NUMBER(TO_CHAR(Lr_CabAsiento.Fecha, 'yyyy'));
        Lr_DetAsiento.mes          := TO_NUMBER(TO_CHAR(Lr_CabAsiento.Fecha, 'mm'));
        Lr_DetAsiento.no_asiento   := Lr_CabAsiento.No_Asiento;
        Lr_DetAsiento.descri       := SUBSTR(Lr_MigraDetalle.Concepto, 1, 100);
        Lr_DetAsiento.cod_diario   := Lr_MigraDetalle.Tipo_Asiento;
        Lr_DetAsiento.Centro_Costo := REPLACE(Lr_MigraDetalle.Id_Centro_Costo, '-', '');
        Lr_DetAsiento.cc_1         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 1, 3);
        Lr_DetAsiento.cc_2         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 5, 3);
        Lr_DetAsiento.cc_3         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 8, 3);
      
        IF Lr_MigraDetalle.Debe > 0 THEN
          Lr_DetAsiento.tipo      := 'D';
          Lr_DetAsiento.monto     := Lr_MigraDetalle.Debe;
          Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Debe;
        ELSIF Lr_MigraDetalle.Haber > 0 THEN
          Lr_DetAsiento.tipo      := 'C';
          Lr_DetAsiento.monto     := Lr_MigraDetalle.Haber * -1;
          Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Haber * -1;
        END IF;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_DETALLE(Lr_DetAsiento, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END LOOP;
    
    END LOOP;
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_ASIENTOS_CONTABLES. ' || SQLERRM;
      ROLLBACK;
  END CGP_ASIENTOS_CONTABLES;

  -----------------------------------------------
  -- Precedimiento que inserta Cuenta Contable --
  -----------------------------------------------
  PROCEDURE CGP_INSERTA_CUENTA(Pr_PlanCuentas  IN OUT ARCGMS%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    --
    Pr_PlanCuentas.moneda            := 'P';
    Pr_PlanCuentas.activa            := 'S';
    Pr_PlanCuentas.debitos           := 0;
    Pr_PlanCuentas.creditos          := 0;
    Pr_PlanCuentas.saldo_per_ant     := 0;
    Pr_PlanCuentas.saldo_mes_ant     := 0;
    Pr_PlanCuentas.saldo_per_ant_dol := 0;
    Pr_PlanCuentas.saldo_mes_ant_dol := 0;
    Pr_PlanCuentas.debitos_dol       := 0;
    Pr_PlanCuentas.creditos_dol      := 0;
    Pr_PlanCuentas.creditos_pend     := 0;
    Pr_PlanCuentas.debitos_pend      := 0;
    --
    Pr_PlanCuentas.ind_presup         := 'N';
    Pr_PlanCuentas.presup_cambio      := 'N';
    Pr_PlanCuentas.permiso_con        := 'S';
    Pr_PlanCuentas.permiso_che        := 'S';
    Pr_PlanCuentas.permiso_cxp        := 'S';
    Pr_PlanCuentas.permiso_pla        := 'S';
    Pr_PlanCuentas.permiso_afijo      := 'S';
    Pr_PlanCuentas.permiso_inv        := 'S';
    Pr_PlanCuentas.permiso_aprov      := 'S';
    Pr_PlanCuentas.permiso_fact       := 'S';
    Pr_PlanCuentas.permiso_cxc        := 'S';
    Pr_PlanCuentas.monetaria          := 'N';
    Pr_PlanCuentas.tcambio_conversion := 'C';
    Pr_PlanCuentas.ind_tercero        := 'N';
    --
    INSERT INTO arcgms a
      (a.no_cia,
       a.cuenta,
       a.descri,
       a.descri_larga,
       a.nivel,
       a.ind_mov,
       a.tipo,
       a.clase,
       a.naturaleza,
       a.acepta_cc,
       a.padre,
       a.moneda,
       a.activa,
       a.debitos,
       a.creditos,
       a.saldo_per_ant,
       a.saldo_mes_ant,
       a.saldo_per_ant_dol,
       a.saldo_mes_ant_dol,
       a.debitos_dol,
       a.creditos_dol,
       a.creditos_pend,
       a.debitos_pend,
       a.ind_presup,
       a.presup_cambio,
       a.permiso_con,
       a.permiso_che,
       a.permiso_cxp,
       a.permiso_pla,
       a.permiso_afijo,
       a.permiso_inv,
       a.permiso_aprov,
       a.permiso_fact,
       a.permiso_cxc,
       a.monetaria,
       a.tcambio_conversion,
       a.ind_tercero)
    VALUES
      (Pr_PlanCuentas.No_Cia,
       Pr_PlanCuentas.Cuenta,
       SUBSTR(Pr_PlanCuentas.Descri, 1, 35),
       SUBSTR(Pr_PlanCuentas.Descri_Larga, 1, 100),
       Pr_PlanCuentas.nivel,
       Pr_PlanCuentas.Ind_Mov,
       Pr_PlanCuentas.tipo,
       Pr_PlanCuentas.clase,
       Pr_PlanCuentas.naturaleza,
       Pr_PlanCuentas.acepta_cc,
       Pr_PlanCuentas.padre,
       Pr_PlanCuentas.moneda,
       Pr_PlanCuentas.activa,
       Pr_PlanCuentas.debitos,
       Pr_PlanCuentas.creditos,
       Pr_PlanCuentas.saldo_per_ant,
       Pr_PlanCuentas.saldo_mes_ant,
       Pr_PlanCuentas.saldo_per_ant_dol,
       Pr_PlanCuentas.saldo_mes_ant_dol,
       Pr_PlanCuentas.debitos_dol,
       Pr_PlanCuentas.creditos_dol,
       Pr_PlanCuentas.creditos_pend,
       Pr_PlanCuentas.debitos_pend,
       Pr_PlanCuentas.ind_presup,
       Pr_PlanCuentas.presup_cambio,
       Pr_PlanCuentas.permiso_con,
       Pr_PlanCuentas.permiso_che,
       Pr_PlanCuentas.permiso_cxp,
       Pr_PlanCuentas.permiso_pla,
       Pr_PlanCuentas.permiso_afijo,
       Pr_PlanCuentas.permiso_inv,
       Pr_PlanCuentas.permiso_aprov,
       Pr_PlanCuentas.permiso_fact,
       Pr_PlanCuentas.permiso_cxc,
       Pr_PlanCuentas.monetaria,
       Pr_PlanCuentas.tcambio_conversion,
       Pr_PlanCuentas.ind_tercero);
  
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_CUENTA - ' || Pr_PlanCuentas.Cuenta || '. ' || SQLERRM;
      ROLLBACK;
  END CGP_INSERTA_CUENTA;

  ------------------------------------------------
  -- Precedimiento que inserta asiento contable --
  ------------------------------------------------
  PROCEDURE CGP_INSERTA_ASIENTO(Pr_AsientoContable IN OUT ARCGAE%ROWTYPE,
                                Pv_MensajeError    IN OUT VARCHAR2) IS
  BEGIN
    
    if Pr_AsientoContable.no_asiento is null then 
      Pr_AsientoContable.no_asiento       := transa_id.cg(Pr_AsientoContable.no_cia);
    end if;
    Pr_AsientoContable.ano              := TO_NUMBER(TO_CHAR(Pr_AsientoContable.fecha, 'yyyy'));
    Pr_AsientoContable.mes              := TO_NUMBER(TO_CHAR(Pr_AsientoContable.fecha, 'mm'));
    Pr_AsientoContable.estado           := 'P';
    Pr_AsientoContable.autorizado       := 'N';
    Pr_AsientoContable.tipo_comprobante := 'T';
    Pr_AsientoContable.t_camb_c_v       := 'C';
    Pr_AsientoContable.tipo_cambio      := 1.00000;
    Pr_AsientoContable.no_comprobante   := 0;
    Pr_AsientoContable.anulado          := 'N';
    Pr_AsientoContable.usuario_creacion := USER;
    --
    IF Pr_AsientoContable.origen IS NULL THEN
      Pr_AsientoContable.origen := 'CG';
    END IF;
    --
    INSERT INTO arcgae
      (no_cia,
       ano,
       mes,
       no_asiento,
       fecha,
       descri1,
       estado,
       autorizado,
       origen,
       t_debitos,
       t_creditos,
       cod_diario,
       t_camb_c_v,
       tipo_cambio,
       tipo_comprobante,
       no_comprobante,
       anulado,
       usuario_creacion)
    VALUES
      (Pr_AsientoContable.no_cia,
       Pr_AsientoContable.ano,
       Pr_AsientoContable.mes,
       Pr_AsientoContable.no_asiento,
       Pr_AsientoContable.fecha,
       Pr_AsientoContable.descri1,
       Pr_AsientoContable.estado,
       Pr_AsientoContable.autorizado,
       Pr_AsientoContable.origen,
       Pr_AsientoContable.t_debitos,
       Pr_AsientoContable.t_creditos,
       Pr_AsientoContable.cod_diario,
       Pr_AsientoContable.t_camb_c_v,
       Pr_AsientoContable.tipo_cambio,
       Pr_AsientoContable.tipo_comprobante,
       Pr_AsientoContable.no_comprobante,
       Pr_AsientoContable.anulado,
       Pr_AsientoContable.usuario_creacion);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ASIENTO. ' || SQLERRM;
      ROLLBACK;
  END CGP_INSERTA_ASIENTO;

  -----------------------------------------------------------
  -- Procedimiento que ingresa detalle de asiento contable --
  -----------------------------------------------------------
  PROCEDURE CGP_INSERTA_DETALLE(Pr_DetalleAsiento IN OUT ARCGAL%ROWTYPE,
                                Pv_MensajeError   IN OUT VARCHAR2) IS
    CURSOR C_Linea IS
      SELECT NVL(MAX(No_Linea), 0) + 1
        FROM arcgal b
       WHERE b.no_asiento = Pr_DetalleAsiento.No_Asiento
         AND b.no_cia = Pr_DetalleAsiento.No_Cia;
  BEGIN
    IF C_Linea%ISOPEN THEN
      CLOSE C_Linea;
    END IF;
    OPEN C_Linea;
    FETCH C_Linea
      INTO Pr_DetalleAsiento.No_Linea;
    IF C_Linea%NOTFOUND THEN
      Pr_DetalleAsiento.no_linea := 1;
    END IF;
    CLOSE C_Linea;
  
    Pr_DetalleAsiento.moneda                 := 'P';
    Pr_DetalleAsiento.tipo_cambio            := 1.000;
    Pr_DetalleAsiento.linea_ajuste_precision := 'N';
    --Pr_DetalleAsiento.ano                    := TO_NUMBER(TO_CHAR(Pr_DetalleAsiento.fecha, 'yyyy'));
    --Pr_DetalleAsiento.mes                    := TO_NUMBER(TO_CHAR(Pr_DetalleAsiento.fecha, 'mm'));
  
    INSERT INTO arcgal
      (no_cia,
       ano,
       mes,
       no_asiento,
       no_linea,
       cuenta,
       descri,
       cod_diario,
       moneda,
       tipo_cambio,
       fecha,
       monto,
       centro_costo,
       tipo,
       monto_dol,
       cc_1,
       cc_2,
       cc_3,
       CODIGO_TERCERO)
    VALUES
      (Pr_DetalleAsiento.no_cia,
       Pr_DetalleAsiento.ano,
       Pr_DetalleAsiento.mes,
       Pr_DetalleAsiento.no_asiento,
       Pr_DetalleAsiento.no_linea,
       Pr_DetalleAsiento.cuenta,
       Pr_DetalleAsiento.descri,
       Pr_DetalleAsiento.cod_diario,
       Pr_DetalleAsiento.moneda,
       Pr_DetalleAsiento.tipo_cambio,
       Pr_DetalleAsiento.fecha,
       NVL(Pr_DetalleAsiento.monto, 0),
       Pr_DetalleAsiento.centro_costo,
       Pr_DetalleAsiento.tipo,
       Pr_DetalleAsiento.monto_dol,
       Pr_DetalleAsiento.cc_1,
       Pr_DetalleAsiento.cc_2,
       Pr_DetalleAsiento.cc_3,
       Pr_DetalleAsiento.Codigo_Tercero);
  
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_DETALLE. ' || Pr_DetalleAsiento.no_asiento || ' ' || Pr_DetalleAsiento.cuenta || '. ' || SQLERRM;
      ROLLBACK;
  END CGP_INSERTA_DETALLE;
  PROCEDURE CGP_FACTURAS(Pv_IdEmpresa    IN VARCHAR2,
                         Pv_FechaDesde   IN VARCHAR2,
                         Pv_FechaHasta   IN VARCHAR2,
                         Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeeDocumentos(Pv_NoCompania VARCHAR2) IS
      SELECT DISTINCT DA.ID_PROVEEDOR,
                      DA.CONCEPTO,
                      DA.HABER MONTO,
                      --LPAD(DA.NUMERO_DOCUMENTO, 9, '0') NUMERO_DOCUMENTO,
                      DA.NUMERO_DOCUMENTO,
                      AC.CODIGO_ASIENTO,
                      UPPER(SUBSTR(LPAD(DA.NUMERO_DOCUMENTO, 9, '0'), 1, 1)) NUM_ERR,
                      LPAD(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'F#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), 12, '0') NUMERO_DOCUMENTO2,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'F#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))) NUMERO_DOCUMENTO3
        FROM CG_M_DETALLE_ASIENTO  DA,
             CG_M_ASIENTO_CONTABLE AC
       WHERE DA.TIPO_ASIENTO = AC.TIPO_ASIENTO
         AND DA.ID_ASIENTO = AC.ID_ASIENTO
         AND DA.COMPANIA = Pv_NoCompania
         AND DA.TIPO_DOCUMENTO = 'FP'
         AND AC.CODIGO_ASIENTO = '08'
         AND TRUNC(AC.FECHA) >= Pv_FechaDesde
         AND TRUNC(AC.FECHA) <= Pv_FechaHasta
            --AND DA.ID_PROVEEDOR = '4279'--'3782' --,'3703'
         AND NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%')
            --AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'))
         AND INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'F#', 1, 1) > 0;
    --
    /*CURSOR C_LeeCuentasRetenc(PvIdEmpresa      IN VARCHAR2,
                            Pv_IdAsiento     IN VARCHAR2,
                            Pv_NumeroFactura IN VARCHAR2) IS
    SELECT CR.* --ID_CUENTA_CONTABLE
      FROM CG_M_DETALLE_ASIENTO     DA,
           CG_M_CUENTAS_RETENCIONES CR
     WHERE DA.ID_CUENTA_CONTABLE = CR.ID_CUENTA_CONTABLE
       AND DA.COMPANIA = CR.COMPANIA
       AND CR.TIPO = 'IVA'
       AND DA.ID_ASIENTO = Pv_IdAsiento
       AND UPPER(REPLACE(DA.CONCEPTO, ' ', '')) LIKE ('%' || REPLACE(UPPER(Pv_NumeroFactura), ' ', '') || '%')
       AND CR.COMPANIA = PvIdEmpresa;*/
  
    /*SELECT PC.ID_CUENTA_CONTABLE
     FROM CG_M_DETALLE_ASIENTO DA,
          CG_M_PLAN_CUENTAS    PC
    WHERE DA.ID_CUENTA_CONTABLE = PC.ID_CUENTA_CONTABLE
      AND DA.COMPANIA = PC.COMPANIA
      AND PC.NOMBRE LIKE ('%IVA%')
      AND DA.ID_ASIENTO = Pv_IdAsiento
      AND UPPER(REPLACE(DA.CONCEPTO, ' ', '')) LIKE ('%' || UPPER(Pv_NumeroFactura) || '%')
      AND PC.COMPANIA = PvIdEmpresa;*/
    --
    CURSOR C_LeeTotalRetenciones(CvIdEmpresa      IN VARCHAR2,
                                 Cv_IdAsiento     IN VARCHAR2,
                                 Cv_NumeroFactura IN VARCHAR2,
                                 Cv_IdProveedor   IN VARCHAR2) IS
      SELECT NVL(SUM(TOTRET), 0)
        FROM CG_M_DETALLE_RETENCIONES DR
       WHERE DR.DESFAC = Cv_NumeroFactura
         AND DR.CODPRO = Cv_IdProveedor
         AND DR.NUMDOC = Cv_IdAsiento
         AND DR.CODEMP = CvIdEmpresa;
  
    /*SELECT NVL(SUM(DA.HABER), 0)
     FROM CG_M_DETALLE_ASIENTO DA,
          CG_M_PLAN_CUENTAS    PC
    WHERE DA.ID_CUENTA_CONTABLE = PC.ID_CUENTA_CONTABLE
      AND DA.COMPANIA = PC.COMPANIA
      AND DA.ID_ASIENTO = Pv_IdAsiento
      AND UPPER(REPLACE(DA.CONCEPTO, ' ', '')) LIKE ('%' || REPLACE(UPPER(Pv_NumeroFactura), ' ', '') || '%')
      AND DA.ID_PROVEEDOR IS NULL
      AND PC.COMPANIA = PvIdEmpresa;*/
    --
  
    --Leo la distribucion contable de la factura
    CURSOR C_LeeDetContable(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdAsiento IN VARCHAR2,
                            Cv_IdFactura IN VARCHAR2,
                            Cv_Concepto  IN VARCHAR2) IS
      SELECT DA.*
        FROM CG_M_DETALLE_ASIENTO DA
       WHERE ID_ASIENTO = Cv_IdAsiento
         AND /*UPPER(REPLACE(DA.CONCEPTO, ' ', '')) LIKE ('%' || REPLACE(UPPER(Cv_IdFactura), ' ', '') || '%')
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 AND */
             NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%')
         AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'))
            --AND REPLACE(UPPER(DA.CONCEPTO), ' ', '') LIKE REPLACE(UPPER((Cv_Concepto)), ' ', '')
         AND REPLACE(UPPER(DA.CONCEPTO), ' ', '') LIKE ('%' || REPLACE(UPPER((Cv_IdFactura)), ' ', '') || '%')
            --AND DA.ID_PROVEEDOR IS NULL
         AND DA.ITEGAS IS NULL
         AND NVL(DA.ID_PROVEEDOR, 'X') <> '9999'
         AND DA.COMPANIA = Cv_IdEmpresa;
    --
    /*  CURSOR C_LeeImpuestos(Cv_IdEmpresa   IN VARCHAR2,
                        Cv_IdProveedor IN VARCHAR2) IS
    SELECT DR.*
      FROM CG_M_DETALLE_RETENCIONES DR
     WHERE DR.CODPRO = Cv_IdProveedor
       AND DR.CODEMP = Cv_IdEmpresa;*/
  
    CURSOR C_LeeInfoFactura(Cv_IdEmpresa   IN VARCHAR2, --
                            Cv_IdAsiento   IN VARCHAR2, --
                            Cv_IdFactura   IN VARCHAR2,
                            Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             --DC.CODSUS,--
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             SUM(DC.BASSINRET) BASSINRET,
             SUM(DC.MONIVABIE) MONIVABIE,
             SUM(DC.NUMREN) NUMREN,
             SUM(DC.BASIMPICE) BASIMPICE,
             SUM(DC.MONICE) MONICE,
             SUM(DC.BASENOGRAIVA) BASENOGRAIVA,
             SUM(DC.MONRETIVASER100) MONRETIVASER100,
             SUM(DC.MONRETIVASER) MONRETIVASER,
             SUM(DC.MONRETIVABIE) MONRETIVABIE,
             SUM(DC.MONIVASER) MONIVASER,
             SUM(DC.MONIVA) MONIVA,
             SUM(DC.BASIMPIVA) BASIMPIVA,
             SUM(DC.BASIMPCER) BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND DC.NUMSECCOM LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%') --TO_NUMBER(Cv_IdFactura)
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa
       GROUP BY DC.CODIVASER100, --
                DC.FECCADCOM, --
                DC.FECEMICOM, --
                DC.FECREGCON, --
                DC.FECACTREG, --
                DC.FECCREREG, --
                DC.FECEMICMO, --
                DC.SINRET, --
                DC.TRADEV, --
                DC.CODIVABIE, --
                DC.CODIVASER, --
                DC.CODPORIVA, --
                DC.NUMAUTCOM, --
                DC.NUMAUTCMO, --
                DC.IDEPRO, --
                DC.NUMDOC, --
                DC.CODEMP, --
                DC.TIPCOM, --
                --DC.CODSUS,--
                DC.TIPCOMMNC, --
                DC.CODPORICE, --
                DC.CODCOM, --
                DC.NUMSECCOM, --
                DC.CODPRO, --
                DC.NUMSEREST, --
                DC.NUMSERCMOPTE, --
                DC.NUMSERCMOEST, --
                DC.NUMSERPTE, --
                DC.REGCREPOR, --
                DC.REGACTPOR, --
                DC.CODSINRET, --
                DC.NUMSECCMO;
  
    /*      SELECT DC.*
     FROM CG_M_DETALLE_COMPROBANTES DC
    WHERE DC.Numdoc = Cv_IdAsiento
      AND TO_NUMBER(DC.NUMSECCOM) = TO_NUMBER(Cv_IdFactura)
      AND DC.CODPRO = Cv_IdProveedor
      AND DC.CODEMP = Cv_IdEmpresa;*/
    --
    CURSOR C_LeeImpuestos(Cv_IdEmpresa   IN VARCHAR2,
                          Cv_IdAsiento   IN VARCHAR2,
                          Cv_IdProveedor IN VARCHAR2,
                          Cv_IdFactura   IN VARCHAR2,
                          Cv_IdFactura2  IN VARCHAR2) IS
      SELECT *
        FROM (SELECT B.NUMAUTFAC,
                     B.SERFAC,
                     SUM(NVL(BASRET, 0)) BASRET,
                     SUM(NVL(TOTRET, 0)) TOTRET,
                     SUM(NVL(PORRET, 0)) PORRET,
                     A.CONRETFUEAIR CODIGO_SRI
                FROM CG_M_DETALLE_RENTA_SRI   A,
                     CG_M_DETALLE_RETENCIONES B
               WHERE A.CODREN = B.CODREN
                 AND A.CODEMP = B.CODEMP
                 AND A.NUMDOC = B.NUMDOC
                 AND B.NUMDOC = Cv_IdAsiento
                 AND (B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%') OR B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura2) || '%'))
                 AND B.CODPRO = Cv_IdProveedor --'4608'
                 AND A.CODEMP = Cv_IdEmpresa
               GROUP BY B.NUMAUTFAC,
                        B.SERFAC,
                        A.CONRETFUEAIR)
       WHERE CODIGO_SRI IS NOT NULL;
  
    /*    SELECT B.*,
          DECODE(A.CODSEC, 'RT_COMF', 'R', 'RT_COMI', 'I') IND_IMP_RET,
          A.CONRETFUEAIR CODIGO_SRI
     FROM CG_M_CUENTAS_RETENCIONES A,
          CG_M_DETALLE_RETENCIONES B
    WHERE A.CODRET = B.CODRET
      AND A.CODEMP = B.CODEMP
      AND B.NUMDOC = Cv_IdAsiento
      AND (B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%') OR B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura2) || '%'))
      AND B.CODPRO = Cv_IdProveedor --'4608'
      AND A.CODEMP = Cv_IdEmpresa; --'15'*/
  
    /*   SELECT B.*,
          DECODE(A.CODSEC, 'RT_COMF', 'R', 'RT_COMI', 'R') IND_IMP_RET,
          A.CONRETFUEAIR CODIGO_SRI
     FROM CG_M_DETALLE_RENTA_SRI   A,
          CG_M_DETALLE_RETENCIONES B
    WHERE A.CODREN = B.CODREN
      AND A.CODEMP = B.CODEMP
      AND B.NUMDOC = Cv_IdAsiento
      AND (B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%') OR B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura2) || '%'))
      AND B.CODPRO = Cv_IdProveedor --'4608'
      AND A.CODEMP = Cv_IdEmpresa;*/
    --
  
    --
    CURSOR C_CodigosSRI(Cv_IdEmpresa   IN VARCHAR2,
                        Cn_CodigoReten IN VARCHAR2) IS
      SELECT IMP.*
        FROM /*CG_M_DETALLE_RENTA_SRI SRI,
             */ ARCGIMP IMP
       WHERE /*SRI.CONRETFUEAIR = */
       IMP.SRI_RETIMP_RENTA = Cn_CodigoReten
       AND /*SRI.CODEMP = */
       IMP.NO_CIA = Cv_IdEmpresa;
    /*         AND SRI.CODREN = Cn_CodigoReten
             AND IMP.NO_CIA = Cv_IdEmpresa;
    */
    CURSOR C_DetalleSustentos(Cv_IdEmpresa   IN VARCHAR2, --
                              Cv_IdAsiento   IN VARCHAR2, --
                              Cv_IdFactura   IN VARCHAR2,
                              Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODSUS,
             DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             BASSINRET,
             MONIVABIE,
             NUMREN,
             BASIMPICE,
             MONICE,
             BASENOGRAIVA,
             MONRETIVASER100,
             MONRETIVASER,
             MONRETIVABIE,
             MONIVASER,
             MONIVA,
             BASIMPIVA,
             BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND DC.NUMSECCOM LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%')
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa;
    --
    CURSOR C_LeeAplicacionImp(Cv_IdSustento IN VARCHAR2) IS
      SELECT APLICA_C_TRIBUTARIO
        FROM SRI_SUSTENTO_COMPROBANTE
       WHERE CODIGO = Cv_IdSustento;
    --
    CURSOR C_LeeDistCont(Cv_IdEmpresa       IN VARCHAR2,
                         Cv_IdDocumento     IN VARCHAR2,
                         Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT NVL(SUM(DECODE(TIPO, 'D', MONTO, 0)), 0) DEBITO,
             NVL(SUM(DECODE(TIPO, 'C', 0, MONTO)), 0) CREDITO
        FROM ARCPDC
       WHERE NO_DOCU = Cv_IdDocumento
         AND TIPO_DOC = Cv_IdTipoDocumento
         AND NO_CIA = Cv_IdEmpresa;
  
    Lv_NumeroFact    VARCHAR2(12) := NULL;
    Lv_NumeroFactDet VARCHAR2(12) := NULL;
    --Lr_CuentasRete    CG_M_CUENTAS_RETENCIONES%ROWTYPE := NULL;
    Lr_Documentos     ARCPMD%ROWTYPE := NULL;
    Lr_Totales        ARCPMD%ROWTYPE := NULL;
    Lr_MovimientoFact CG_M_DETALLE_ASIENTO%ROWTYPE := NULL;
    Lr_DetalleCont    ARCPDC%ROWTYPE := NULL;
    Lv_NoDocu         ARCPMD.NO_DOCU%TYPE := NULL;
    Lr_DetFactura     C_LeeInfoFactura%ROWTYPE := NULL;
    Le_Error EXCEPTION;
    Lr_Retenciones     ARCPTI%ROWTYPE := NULL;
    Lr_RegSRI          C_CodigosSRI%ROWTYPE := NULL;
    Lr_DetTributoIva   CP_DETALLE_TRIBUTO_IVA%ROWTYPE := NULL;
    Lv_AplicaCreditTri VARCHAR2(2) := NULL;
    Ln_SecuenciaSust   NUMBER(2);
  
    --Lv_TipoImpuesto C_LeeImpuestos%ROWTYPE := NULL;
  BEGIN
    FOR Lr_Migra IN C_LeeDocumentos(Pv_IdEmpresa) LOOP
      Lv_NumeroFact    := NULL;
      Lv_NumeroFactDet := NULL;
      /*      IF Lr_Migra.NUM_ERR <> '0' THEN
        Lv_NumeroFact := Lr_Migra.NUMERO_DOCUMENTO2;
      ELSE
        Lv_NumeroFact := Lr_Migra.NUMERO_DOCUMENTO;
      END IF;*/
    
      BEGIN
        Lv_NumeroFactDet := TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO);
        Lv_NumeroFact    := LPAD(TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO), 9, '0');
      EXCEPTION
        WHEN value_error THEN
          Lv_NumeroFactDet := TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO2);
          Lv_NumeroFact    := LPAD(TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO2), 9, '0');
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('No se procesa fact. ' || Lv_NumeroFact || ' asiento ' || Lr_Migra.Id_Asiento);
          --DBMS_OUTPUT.put_line('Error de Numero Factura ' || Lv_NumeroFact);
      END;
      --
      Lr_DetFactura := NULL;
      IF C_LeeInfoFactura%ISOPEN THEN
        CLOSE C_LeeInfoFactura;
      END IF;
      OPEN C_LeeInfoFactura(Pv_IdEmpresa, --
                            Lr_Migra.Id_Asiento,
                            Lv_NumeroFact,
                            Lr_Migra.Id_Proveedor);
      FETCH C_LeeInfoFactura
        INTO Lr_DetFactura;
      CLOSE C_LeeInfoFactura;
      --
      --
      Lr_Documentos.GRAVADO  := NVL(Lr_DetFactura.BASIMPIVA, 0);
      Lr_Documentos.EXCENTOS := NVL(Lr_DetFactura.BASIMPCER, 0);
      Lr_Documentos.TOT_IMP  := round(Lr_DetFactura.MONIVA, 2);
      --BASIMPCER,BASEIMPIVA
      /*Lr_Totales.SUBTOTAL*/
      Lr_Documentos.Subtotal := ROUND(NVL(Lr_DetFactura.BASIMPIVA, 0) + NVL(Lr_DetFactura.BASIMPCER, 0), 2);
      /*Lr_Totales.Monto*/
      --Lr_Documentos.Monto := Lr_Totales.SUBTOTAL + NVL(Lr_DetFactura.BASIMPIVA, 0);
      --
      --Lr_Documentos.Monto    := Lr_Totales.Monto;
      --Lr_Documentos.Subtotal := Lr_Documentos.Subtotal;--Lr_Totales.SUBTOTAL;
    
      IF NVL(Lr_DetFactura.Basimpiva, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA     := 'B';
        Lr_Documentos.TIPO_DOC        := 'FB';
        Lr_Documentos.CODIGO_SUSTENTO := '01';
        Lr_Documentos.Monto_Bienes    := Lr_Documentos.GRAVADO;
      ELSIF NVL(Lr_DetFactura.MONIVASER, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA     := 'S';
        Lr_Documentos.TIPO_DOC        := 'FV';
        Lr_Documentos.Monto_Serv      := Lr_Documentos.GRAVADO;
        Lr_Documentos.CODIGO_SUSTENTO := '02';
      ELSIF NVL(Lr_DetFactura.Basimpcer, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA     := 'S';
        Lr_Documentos.TIPO_DOC        := 'FV';
        Lr_Documentos.Monto_Serv      := Lr_Documentos.GRAVADO;
        Lr_Documentos.CODIGO_SUSTENTO := '02';
      ELSE
        Lr_Documentos.TIPO_COMPRA := 'V';
      END IF;
      /*IF NVL(Lr_DetFactura.BASIMPIVA, 0) > 0 THEN
        Lr_Documentos.CODIGO_SUSTENTO := '01';
      ELSE
        Lr_Documentos.CODIGO_SUSTENTO := '02';
      END IF;*/
      --
      IF C_LeeTotalRetenciones%ISOPEN THEN
        CLOSE C_LeeTotalRetenciones;
      END IF;
      OPEN C_LeeTotalRetenciones(Pv_IdEmpresa, --
                                 Lr_Migra.ID_ASIENTO,
                                 Lr_DetFactura.Numseccom,
                                 Lr_DetFactura.Codpro);
      FETCH C_LeeTotalRetenciones
        INTO Lr_Totales.TOT_RET;
      CLOSE C_LeeTotalRetenciones;
      --
      Lr_Documentos.TOT_RET := Lr_Totales.TOT_RET;
      --
      Lr_Documentos.NO_CIA      := Pv_IdEmpresa;
      Lr_Documentos.NO_PROVE    := Lr_Migra.ID_PROVEEDOR;
      Lr_Documentos.IND_ACT     := 'P';
      Lr_Documentos.NO_FISICO   := LPAD(Lv_NumeroFact, 9, '0');
      Lr_Documentos.IND_OTROMOV := 'N';
      Lr_Documentos.FECHA       := Lr_Migra.FECHA;
      Lr_Documentos.SALDO       := (Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/
                                    +nvl(Lr_Documentos.TOT_IMP, 0) /*NVL(Lr_Totales.TOT_IMP, 0)*/
                                    -NVL(Lr_Totales.TOT_RET, 0));
      --Lr_Documentos.TOT_DB      := NVL(Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/, 0) +nvl(Lr_Documentos.TOT_IMP,0) /*NVL(Lr_Totales.TOT_IMP, 0)*/;
      --Lr_Documentos.TOT_CR      := NVL(Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/, 0) +NVL(Lr_Documentos.TOT_IMP,0) /*NVL(Lr_Totales.TOT_IMP, 0)*/;
      --
      Lr_Documentos.FECHA_VENCE   := Lr_Migra.FECHA + 360;
      Lr_Documentos.BLOQUEADO     := 'N';
      Lr_Documentos.MONEDA        := 'P';
      Lr_Documentos.TIPO_CAMBIO   := 1;
      Lr_Documentos.MONTO_NOMINAL := Lr_Documentos.Monto; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
      Lr_Documentos.SALDO_NOMINAL := Lr_Documentos.SALDO; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
      --
      Lr_Documentos.T_CAMB_C_V           := 'V';
      Lr_Documentos.DETALLE              := SUBSTR(Lr_Migra.CONCEPTO, 1, 100);
      Lr_Documentos.IND_OTROS_MESES      := 'N';
      Lr_Documentos.FECHA_DOCUMENTO      := Lr_Migra.Fecha;
      Lr_Documentos.FECHA_VENCE_ORIGINAL := Lr_Migra.Fecha;
      Lr_Documentos.ORIGEN               := 'CP';
      Lr_Documentos.ANULADO              := 'N';
      Lr_Documentos.IND_ESTADO_VENCIDO   := 'N';
      Lr_Documentos.TOT_IMP_ESPECIAL     := 0;
      Lr_Documentos.COD_DIARIO           := '08'; --CONFIRMAR;
      Lr_Documentos.TOT_RET_ESPECIAL     := 0;
    
      Lr_Documentos.DERECHO_DEVOLUCION_IVA := 'N';
      Lr_Documentos.FECHA_CADUCIDAD        := Lr_DetFactura.FECCADCOM; --Lr_Migra.Fecha + 360;
      Lr_Documentos.USUARIO                := USER;
      Lr_Documentos.FACTURA_EVENTUAL       := 'N';
      Lr_Documentos.TIPO_RET               := 'R2'; --REVISAR
      Lr_Documentos.NO_AUTORIZACION        := Lr_DetFactura.NUMAUTCOM;
      Lr_Documentos.SERIE_FISICO           := Lr_DetFactura.NUMSEREST || Lr_DetFactura.NUMSERPTE;
      Lr_Documentos.DESC_C                 := 0;
      Lr_Documentos.DESC_P                 := 0;
      Lr_Documentos.PLAZO_C                := 0;
      Lr_Documentos.PLAZO_P                := 0;
      Lr_Documentos.Motivo                 := Lr_Migra.Codigo_Asiento || ' ' || Lr_Migra.Id_Asiento;
      Lr_Documentos.Monto                  := Lr_Documentos.SUBTOTAL + round(Lr_Documentos.TOT_IMP, 2) - Lr_Documentos.TOT_RET;
      Lv_NoDocu                            := transa_id.cp(Pv_IdEmpresa); ---Se genera la secuencia del documento
      BEGIN
        INSERT INTO ARCPMD
          (NO_CIA,
           NO_PROVE,
           TIPO_DOC,
           NO_DOCU,
           IND_ACT,
           NO_FISICO,
           IND_OTROMOV,
           FECHA,
           SUBTOTAL, ---
           SALDO, --
           GRAVADO, --
           EXCENTOS, --
           TOT_DB, --
           TOT_CR, --
           FECHA_VENCE,
           BLOQUEADO, --
           MONEDA, --
           TIPO_CAMBIO, --
           MONTO_NOMINAL,
           SALDO_NOMINAL,
           TIPO_COMPRA,
           T_CAMB_C_V, --
           DETALLE, --
           IND_OTROS_MESES, --
           FECHA_DOCUMENTO, --
           FECHA_VENCE_ORIGINAL, --
           ORIGEN, --
           ANULADO, --
           IND_ESTADO_VENCIDO, --
           TOT_IMP, --
           TOT_RET, --
           TOT_IMP_ESPECIAL, --
           COD_DIARIO, --
           TOT_RET_ESPECIAL, --
           CODIGO_SUSTENTO, --
           DERECHO_DEVOLUCION_IVA, --
           FECHA_CADUCIDAD, --
           USUARIO, --
           FACTURA_EVENTUAL, --
           TIPO_RET, --
           TARJETA_CORP,
           NO_AUTORIZACION,
           SERIE_FISICO,
           MONTO,
           DESC_C,
           DESC_P,
           PLAZO_C,
           PLAZO_P,
           motivo)
        VALUES
          (Pv_IdEmpresa, --
           Lr_Migra.ID_PROVEEDOR,
           Lr_Documentos.TIPO_DOC, --FACTURAS DE COSTOS
           Lv_NoDocu,
           'P', --estado
           Lr_Documentos.No_Fisico, --NO_FISICO
           'N', --IND_OTROMOV
           Lr_Migra. FECHA,
           Lr_Documentos.SUBTOTAL,
           Lr_Documentos.SALDO,
           Lr_Documentos.GRAVADO,
           Lr_Documentos.EXCENTOS,
           Lr_Documentos.TOT_CR,
           Lr_Documentos.TOT_DB,
           Lr_Documentos.FECHA_VENCE,
           Lr_Documentos.BLOQUEADO,
           Lr_Documentos.MONEDA,
           Lr_Documentos.TIPO_CAMBIO,
           Lr_Documentos.MONTO_NOMINAL,
           Lr_Documentos.SALDO_NOMINAL,
           Lr_Documentos.TIPO_COMPRA,
           Lr_Documentos.T_CAMB_C_V,
           SUBSTR(Lr_Migra.CONCEPTO, 1, 100),
           Lr_Documentos.IND_OTROS_MESES,
           Lr_Documentos.FECHA_DOCUMENTO,
           Lr_Documentos.FECHA_VENCE_ORIGINAL,
           Lr_Documentos.ORIGEN,
           Lr_Documentos.ANULADO,
           Lr_Documentos.IND_ESTADO_VENCIDO,
           Lr_Documentos.TOT_IMP,
           Lr_Documentos.TOT_RET,
           Lr_Documentos.TOT_IMP_ESPECIAL,
           Lr_Documentos.COD_DIARIO,
           Lr_Documentos.TOT_RET_ESPECIAL,
           Lr_Documentos.CODIGO_SUSTENTO,
           Lr_Documentos.DERECHO_DEVOLUCION_IVA,
           Lr_Documentos.FECHA_CADUCIDAD,
           Lr_Documentos.USUARIO,
           Lr_Documentos.FACTURA_EVENTUAL,
           Lr_Documentos.TIPO_RET,
           Lr_Documentos.TARJETA_CORP,
           Lr_Documentos.NO_AUTORIZACION,
           Lr_Documentos.SERIE_FISICO,
           Lr_Documentos.Monto,
           Lr_Documentos.DESC_C,
           Lr_Documentos.DESC_P,
           Lr_Documentos.PLAZO_C,
           Lr_Documentos.PLAZO_P,
           Lr_Documentos.Motivo);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error' || SQLCODE || ' ' || SQLERRM || ' ' || Lr_Documentos.NO_FISICO);
      END;
    
      --Lr_DetalleCont := NULL;
      FOR Lr_DetCont IN C_LeeDetContable(Pv_IdEmpresa, --
                                         Lr_Migra.ID_ASIENTO,
                                         Lv_NumeroFactDet,
                                         Lr_Migra.Concepto
                                         /*Lr_Migra.NUMERO_DOCUMENTO3*/) LOOP
        Lr_DetalleCont.NO_CIA   := Pv_IdEmpresa;
        Lr_DetalleCont.NO_PROVE := Lr_Migra.ID_PROVEEDOR;
        Lr_DetalleCont.TIPO_DOC := Lr_Documentos.TIPO_DOC;
        Lr_DetalleCont.NO_DOCU  := Lv_NoDocu;
        Lr_DetalleCont.CODIGO   := Lr_DetCont.ID_CUENTA_CONTABLE;
        IF Lr_DetCont.DEBE > 0 THEN
          Lr_DetalleCont.TIPO      := 'D';
          Lr_DetalleCont.MONTO     := ROUND(Lr_DetCont.DEBE, 2);
          Lr_DetalleCont.MONTO_DOL := ROUND(Lr_DetCont.DEBE, 2);
          Lr_DetalleCont.MONTO_DC  := ROUND(Lr_DetCont.DEBE, 2);
        ELSIF Lr_DetCont.HABER > 0 THEN
          Lr_DetalleCont.TIPO      := 'C';
          Lr_DetalleCont.MONTO     := ROUND(Lr_DetCont.HABER, 2);
          Lr_DetalleCont.MONTO_DOL := ROUND(Lr_DetCont.HABER, 2);
          Lr_DetalleCont.MONTO_DC  := ROUND(Lr_DetCont.HABER, 2);
        
        END IF;
      
        --Lr_DetalleCont.MONTO              := Lr_DetCont.;
        Lr_DetalleCont.MES     := TO_NUMBER(TO_CHAR(Lr_Migra.FECHA, 'MM'));
        Lr_DetalleCont.ANO     := TO_NUMBER(TO_CHAR(Lr_Migra.FECHA, 'YYYY'));
        Lr_DetalleCont.IND_CON := 'P';
      
        Lr_DetalleCont.MONEDA         := 'P';
        Lr_DetalleCont.TIPO_CAMBIO    := 1;
        Lr_DetalleCont.NO_ASIENTO     := NULL;
        Lr_DetalleCont.CENTRO_COSTO   := '000000000';
        Lr_DetalleCont.MODIFICABLE    := 'N';
        Lr_DetalleCont.CODIGO_TERCERO := NULL;
        --JXZURITA-AUMENTO CAMPO GLOSA INICIO
        --Lr_DetalleCont.GLOSA              := SUBSTR(Lr_DetCont.CONCEPTO, 1, 100);
        Lr_DetalleCont.GLOSA              := SUBSTR(Lr_DetCont.CONCEPTO, 1, F_TAM_GLOSA_CONT(Lr_DetalleCont.no_cia,'AG_CGKMIGRACIONMEGA',100));
        --JXZURITA-AUMENTO CAMPO GLOSA FIN
        
        Lr_DetalleCont.EXCEDE_PRESUPUESTO := NULL;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_MOVIMIENTO(Lr_DetalleCont, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        Lr_MovimientoFact := NULL;
      
      --
      END LOOP;
      --
      IF C_LeeDistCont%ISOPEN THEN
        CLOSE C_LeeDistCont;
      END IF;
      OPEN C_LeeDistCont(Pv_IdEmpresa, Lv_NoDocu, Lr_Documentos.TIPO_DOC);
      FETCH C_LeeDistCont
        INTO Lr_Documentos.TOT_DB,
             Lr_Documentos.TOT_CR;
      CLOSE C_LeeDistCont;
      --
      UPDATE ARCPMD FA
         SET FA.TOT_DB = Lr_Documentos.TOT_DB,
             FA.TOT_CR = Lr_Documentos.TOT_CR
       WHERE FA.NO_DOCU = Lv_NoDocu
         AND FA.TIPO_DOC = Lr_Documentos.TIPO_DOC
         AND FA.NO_CIA = Pv_IdEmpresa;
    
      --inserta impuestos
      Lr_Retenciones := NULL;
      FOR Lr_Impuestos IN C_LeeImpuestos(Pv_IdEmpresa, --
                                         Lr_Migra.ID_ASIENTO,
                                         Lr_documentos.NO_PROVE,
                                         Lv_NumeroFact,
                                         Lv_NumeroFact
                                         --Lr_Migra.NUMERO_DOCUMENTO2,
                                         --Lr_Migra.NUMERO_DOCUMENTO
                                         ) LOOP
        --Lr_Retenciones.No_Cia
        Lr_RegSRI := NULL;
        IF C_CodigosSRI%ISOPEN THEN
          CLOSE C_CodigosSRI;
        END IF;
        OPEN C_CodigosSRI(Pv_IdEmpresa, Lr_Impuestos.Codigo_Sri); --Lr_Impuestos.CODREN);
        FETCH C_CodigosSRI
          INTO Lr_RegSRI;
        CLOSE C_CodigosSRI;
        Lr_Retenciones.NO_CIA   := Pv_IdEmpresa;
        Lr_Retenciones.NO_PROVE := Lr_Documentos.NO_PROVE;
        Lr_Retenciones.TIPO_DOC := Lr_Documentos.TIPO_DOC;
        Lr_Retenciones.NO_DOCU  := Lv_NoDocu;
        IF Lr_Impuestos.Porret NOT IN (30, 70, 100) THEN
          Lr_Retenciones.CLAVE            := Lr_RegSRI.Clave;
          Lr_Retenciones.SRI_RETIMP_RENTA := Lr_Impuestos.Codigo_Sri; --Lr_RegSRI.SRI_RETIMP_RENTA; --REVISAR
        ELSE
          IF Lr_Impuestos.PORRET = 30 THEN
            Lr_Retenciones.CLAVE            := 34;
            Lr_Retenciones.SRI_RETIMP_RENTA := '1';
          ELSIF Lr_Impuestos.PORRET = 70 THEN
            Lr_Retenciones.CLAVE            := 35;
            Lr_Retenciones.SRI_RETIMP_RENTA := '2';
          ELSIF Lr_Impuestos.PORRET = 100 THEN
            Lr_Retenciones.CLAVE            := 36;
            Lr_Retenciones.SRI_RETIMP_RENTA := '3';
          END IF;
        END IF;
        Lr_Retenciones.PORCENTAJE         := Lr_Impuestos.PORRET;
        Lr_Retenciones.MONTO              := Lr_Impuestos.TOTRET;
        Lr_Retenciones.IND_IMP_RET        := 'R';
        Lr_Retenciones.APLICA_CRED_FISCAL := 'N';
        /*        IF Lr_Impuestos.IND_IMP_RET = 'I' THEN
                  Lr_Retenciones.APLICA_CRED_FISCAL := 'S';
                ELSE
                  Lr_Retenciones.APLICA_CRED_FISCAL := 'N';
                END IF;
        */ --
        Lr_Retenciones.BASE           := Lr_Impuestos.BASRET;
        Lr_Retenciones.COMPORTAMIENTO := 'E';
        Lr_Retenciones.ID_SEC         := NULL;
        Lr_Retenciones.NO_REFE        := Lv_NoDocu;
        Lr_Retenciones.SECUENCIA_RET  := Lr_Impuestos.SERFAC;
        Lr_Retenciones.FECHA_IMPRIME  := NULL;
      
        Lr_Retenciones.SERVICIO_BIENES := NULL;
        Lr_Retenciones.AUTORIZACION    := Lr_Impuestos.NUMAUTFAC;
        Lr_Retenciones.FECHA_ANULA     := NULL;
        Lr_Retenciones.BASE_GRAVADA    := NULL;
        Lr_Retenciones.BASE_EXCENTA    := NULL;
        --dbms_output.put_line(Lr_Retenciones.NO_PROVE || 'insert && ' || Lr_Retenciones.TIPO_DOC || '&& ' || Lr_Retenciones.NO_DOCU || '&& ' || Lr_Retenciones.CLAVE || '&& ' || Lr_Retenciones.ID_SEC || '&& ' || Lr_Retenciones.NO_CIA || '&& ' || Lr_Retenciones.NO_REFE || '&& ' || Lr_Retenciones.CODIGO_TERCERO || '&& ' || Lr_Retenciones.SECUENCIA_RET || '&& ' || Lr_Retenciones.SERVICIO_BIENES || '**' || Lr_Migra.Id_Asiento);
        CGK_MIGRACION_MEGA.CGP_INSERTA_IMPUESTO(Lr_Retenciones, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          dbms_output.put_line(Lr_Retenciones.NO_PROVE || '&&' || Lr_Retenciones.TIPO_DOC || '&&' || Lr_Retenciones.NO_DOCU || '&&' || Lr_Retenciones.CLAVE || '&&' || Lr_Retenciones.ID_SEC || '&&' || Lr_Retenciones.NO_CIA || '&&' || Lr_Retenciones.NO_REFE || '&&' || Lr_Retenciones.CODIGO_TERCERO || '&&' || Lr_Retenciones.SECUENCIA_RET || '&&' || Lr_Retenciones.SERVICIO_BIENES || '**' || Lr_Migra.Id_Asiento);
          Pv_MensajeError := 'Error en CGP_INSERTA_IMPUESTO. ret ' || Pv_MensajeError;
          RAISE Le_Error;
        END IF;
      
      END LOOP;
      --
      --INSERTAR IVA EN EL DETALLE DE IMPUESTOS
      Lr_Retenciones          := NULL;
      Lr_Retenciones.NO_CIA   := Pv_IdEmpresa;
      Lr_Retenciones.NO_PROVE := Lr_Documentos.NO_PROVE;
      Lr_Retenciones.TIPO_DOC := Lr_Documentos.TIPO_DOC;
      Lr_Retenciones.NO_DOCU  := Lv_NoDocu;
      Lr_Retenciones.CLAVE    := '00';
      --Lr_RegSRI.Clave;
      Lr_Retenciones.SRI_RETIMP_RENTA := NULL; --Lr_RegSRI.SRI_RETIMP_RENTA; --REVISAR
    
      Lr_Retenciones.PORCENTAJE         := 12;
      Lr_Retenciones.MONTO              := round(Lr_DetFactura.Moniva, 2);
      Lr_Retenciones.IND_IMP_RET        := 'I';
      Lr_Retenciones.APLICA_CRED_FISCAL := 'S';
      Lr_Retenciones.BASE               := round(Lr_DetFactura.Basimpiva, 2); --Lr_Impuestos.BASRET;
      Lr_Retenciones.COMPORTAMIENTO     := 'E';
      Lr_Retenciones.ID_SEC             := NULL;
      Lr_Retenciones.NO_REFE            := Lv_NoDocu;
      Lr_Retenciones.SECUENCIA_RET      := NULL; --Lr_Impuestos.SERFAC;
      Lr_Retenciones.FECHA_IMPRIME      := NULL;
    
      Lr_Retenciones.SERVICIO_BIENES := NULL;
      Lr_Retenciones.AUTORIZACION    := NULL;
      Lr_Retenciones.FECHA_ANULA     := NULL;
      Lr_Retenciones.BASE_GRAVADA    := NULL;
      Lr_Retenciones.BASE_EXCENTA    := NULL;
      --
      CGK_MIGRACION_MEGA.CGP_INSERTA_IMPUESTO(Lr_Retenciones, Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        Pv_MensajeError := 'Error en CGP_INSERTA_IMPUESTO. iva ' || Pv_MensajeError;
        RAISE Le_Error;
      END IF;
    
      --Detalle de sustentos
      Ln_SecuenciaSust := 1;
      FOR Lr_DetSustento IN C_DetalleSustentos(Pv_IdEmpresa, Lr_Migra.ID_ASIENTO, Lv_NumeroFact, Lr_Documentos.NO_PROVE) LOOP
        --18582202
        Lr_DetTributoIva                   := NULL;
        Lr_DetTributoIva.ID_EMPRESa        := Pv_IdEmpresa;
        Lr_DetTributoIva.ID_TIPO_DOCUMENTO := Lr_Documentos.Tipo_Doc;
        Lr_DetTributoIva.ID_DOCUMENTO      := Lv_NoDocu;
        Lr_DetTributoIva.ID_SUSTENTO       := Lr_DetSustento.CODSUS;
        Lr_DetTributoIva.Secuencia         := Ln_SecuenciaSust;
        Lr_DetTributoIva.MONTO_BASE_IVA    := NVL(Lr_DetSustento.BASIMPIVA, 0);
        Lr_DetTributoIva.MONTO_BASE_CERO   := NVL(Lr_DetSustento.BASIMPCER, 0);
        Lr_DetTributoIva.MONTO_NETO        := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0);
        Lr_DetTributoIva.MONTO_IVA         := NVL(Lr_DetSustento.Moniva, 0);
        Lr_DetTributoIva.MONTO_TOTAL       := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0) + NVL(Lr_DetSustento.Moniva, 0);
        IF (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0)) = 0 THEN
          Lr_DetTributoIva.PORCENTAJE := 0;
        ELSE
          Lr_DetTributoIva.PORCENTAJE := ((NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0)) * 100) / (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0));
        END IF;
        --Lr_DetTributoIva.PORCENTAJE        := ((NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0)) * 100) / (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0));
        Lr_DetTributoIva.USUARIO_CREA := Lr_DetSustento.REGCREPOR;
        Lr_DetTributoIva.FECHA_CREA   := Lr_DetSustento.FECACTREG;
        Lv_AplicaCreditTri            := NULL;
        IF C_LeeAplicacionImp%ISOPEN THEN
          CLOSE C_LeeAplicacionImp;
        END IF;
        OPEN C_LeeAplicacionImp(Lr_DetSustento.CODSUS);
        FETCH C_LeeAplicacionImp
          INTO Lv_AplicaCreditTri;
        CLOSE C_LeeAplicacionImp;
      
        Lr_DetTributoIva.APLICA_CREDITO_IVA := Lv_AplicaCreditTri;
        Lr_DetTributoIva.COMENTARIO         := 'MIGRACION HIPERK-NAF ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY') || ', ASIENTO # ' || Lr_Migra.ID_ASIENTO || '  ' || Lr_DetSustento.Codcom || ' ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro;
        IF NVL(Lr_DetSustento.MONIVA, 0) = 0 THEN
          Lr_DetTributoIva.PORCENTAJE_RETENCION := 0;
        ELSE
          Lr_DetTributoIva.PORCENTAJE_RETENCION := ((NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0)) * 100) / NVL(Lr_DetSustento.MONIVA, 1);
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) = 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'SE';
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) = 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BI';
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BS';
        END IF;
      
        Lr_DetTributoIva.MONTO_BASE_RETENCION := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
        --IF Lr_DetSustento.Codporiva=2 THEN
        Lr_DetTributoIva.MONTO_IVA_RETENCION   := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
        Lr_DetTributoIva.MONTO_TOTAL_RETENCION := Lr_DetTributoIva.MONTO_BASE_RETENCION + Lr_DetTributoIva.MONTO_IVA_RETENCION;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_DET_IVA(Lr_DetTributoIva, Pv_MensajeError);
      
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := Pv_MensajeError || ' fact. ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro || ' comen:' || Lr_DetTributoIva.Comentario;
          RAISE Le_Error;
        END IF;
        Ln_SecuenciaSust := Ln_SecuenciaSust + 1;
      END LOOP;
    
      Lv_NoDocu := NULL;
      --
      UPDATE CG_M_ASIENTO_CONTABLE AC
         SET AC.MIGRADO = 'S'
       WHERE AC.Id_Asiento = Lr_Migra.Id_Asiento
         AND AC.COMPANIA = Pv_IdEmpresa;
    
    END LOOP;
    --transa_id.cp(:uno.no_cia);    
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_FACTURAS. ' || SQLCODE || ' ' || SQLERRM || '  elvis ' || Lr_Documentos.No_Fisico;
      ROLLBACK;
  END CGP_FACTURAS;
  --Procedimiento que inserta el detalle contable
  PROCEDURE CGP_INSERTA_MOVIMIENTO(Pr_MovimientoFact IN ARCPDC%ROWTYPE,
                                   Pv_MensajeError   OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCPDC
      (NO_CIA, --
       NO_PROVE,
       TIPO_DOC,
       NO_DOCU,
       CODIGO,
       TIPO,
       MONTO,
       MES,
       ANO,
       IND_CON,
       MONTO_DOL,
       MONEDA,
       TIPO_CAMBIO,
       NO_ASIENTO,
       CENTRO_COSTO,
       MODIFICABLE,
       CODIGO_TERCERO,
       MONTO_DC,
       GLOSA,
       EXCEDE_PRESUPUESTO)
    VALUES
      (Pr_MovimientoFact.NO_CIA,
       Pr_MovimientoFact.NO_PROVE,
       Pr_MovimientoFact.TIPO_DOC,
       Pr_MovimientoFact.NO_DOCU,
       Pr_MovimientoFact.CODIGO,
       Pr_MovimientoFact.TIPO,
       Pr_MovimientoFact.MONTO,
       Pr_MovimientoFact.MES,
       Pr_MovimientoFact.ANO,
       Pr_MovimientoFact.IND_CON,
       Pr_MovimientoFact.MONTO_DOL,
       Pr_MovimientoFact.MONEDA,
       Pr_MovimientoFact.TIPO_CAMBIO,
       Pr_MovimientoFact.NO_ASIENTO,
       Pr_MovimientoFact.CENTRO_COSTO,
       Pr_MovimientoFact.MODIFICABLE,
       Pr_MovimientoFact.CODIGO_TERCERO,
       Pr_MovimientoFact.MONTO_DC,
       Pr_MovimientoFact.GLOSA,
       Pr_MovimientoFact.EXCEDE_PRESUPUESTO);
  
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_MOVIMIENTO. ' || SQLCODE || ' ' || SQLERRM;
      ROLLBACK;
  END CGP_INSERTA_MOVIMIENTO;
  --
  --Procedimiento que inserta impuestos
  PROCEDURE CGP_INSERTA_IMPUESTO(Pr_Impuestos    IN ARCPTI%ROWTYPE,
                                 Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCPTI
      (NO_CIA,
       NO_PROVE,
       TIPO_DOC,
       NO_DOCU,
       CLAVE,
       PORCENTAJE,
       MONTO,
       IND_IMP_RET,
       APLICA_CRED_FISCAL,
       BASE,
       COMPORTAMIENTO,
       NO_REFE,
       ANULADA,
       SRI_RETIMP_RENTA)
    VALUES
      (Pr_Impuestos.NO_CIA,
       Pr_Impuestos.NO_PROVE,
       Pr_Impuestos.TIPO_DOC,
       Pr_Impuestos.NO_DOCU,
       Pr_Impuestos.CLAVE,
       Pr_Impuestos.PORCENTAJE,
       Pr_Impuestos.MONTO,
       Pr_Impuestos.IND_IMP_RET,
       Pr_Impuestos.APLICA_CRED_FISCAL,
       Pr_Impuestos.BASE,
       Pr_Impuestos.COMPORTAMIENTO,
       Pr_Impuestos.NO_REFE,
       Pr_Impuestos.ANULADA,
       Pr_Impuestos.SRI_RETIMP_RENTA);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_IMPUESTO. ' || SQLCODE || ' ' || SQLERRM;
      ROLLBACK;
    
  END CGP_INSERTA_IMPUESTO;
  --
  PROCEDURE CP_GENERA_NC_MEGA(pCia          arcgae.no_cia%TYPE,
                              pMesAno_proce VARCHAR2,
                              pCod_Asiento  CG_M_ASIENTO_CONTABLE.Codigo_Asiento%TYPE,
                              pMsg_error    OUT VARCHAR2) IS
    CURSOR c_movimientos IS
      SELECT DISTINCT id_asiento,
                      concepto
        FROM CG_M_DETALLE_ASIENTO
       WHERE COMPANIA = pCia
         AND ID_ASIENTO IN (SELECT ID_ASIENTO
                              FROM CG_M_ASIENTO_CONTABLE
                             WHERE COMPANIA = pCia
                               AND CODIGO_ASIENTO = pCod_Asiento
                               AND TO_CHAR(FECHA, 'mmyyyy') = pMesAno_proce)
         AND Upper(concepto) LIKE '%NC#%'
       ORDER BY concepto;
  
    CURSOR c_No_fisico(c_asiento  VARCHAR2,
                       c_concepto VARCHAR2) IS
      SELECT DISTINCT (SUBSTR(SUBSTR(concepto, instr(concepto, 'NC#')), -- Cadena
                              1, -- Inicio
                              instr(SUBSTR(concepto, instr(concepto, 'NC#')), ' ', 1, 2))) -- Final
        FROM cg_m_detalle_asiento
       WHERE COMPANIA = pCia
         AND concepto = c_concepto
         AND id_asiento = c_asiento;
  
    CURSOR c_proveedor(c_asiento  VARCHAR2,
                       c_concepto VARCHAR2) IS
      SELECT DISTINCT id_proveedor,
                      numero_documento
        FROM cg_m_detalle_asiento
       WHERE COMPANIA = pCia
         AND concepto = c_concepto
         AND id_proveedor IS NOT NULL
         AND id_asiento = c_asiento;
  
    CURSOR c_datos_cabecera(c_asiento  VARCHAR2,
                            c_concepto VARCHAR2) IS
      SELECT id_asiento,
             fecha,
             codigo_asiento
        FROM CG_M_ASIENTO_CONTABLE
       WHERE COMPANIA = pCia
         AND id_asiento = c_asiento;
  
    CURSOR c_detalle(c_asiento  VARCHAR2,
                     c_concepto VARCHAR2) IS
      SELECT id_cuenta_contable,
             REPLACE(id_centro_costo, '-', '') id_centro_costo,
             DECODE(debe, 0, 'C', 'D') tipo,
             DECODE(debe, 0, haber, debe) monto,
             'Asiento:' || id_asiento || ' - ' || 'Linea:' || linea || ' - ' || concepto glosa,
             id_proveedor,
             numero_documento
        FROM cg_m_detalle_asiento
       WHERE COMPANIA = pCia
         AND id_asiento = c_asiento
         AND concepto = c_concepto;
  
    CURSOR c_referencias(c_asiento  VARCHAR2,
                         c_concepto VARCHAR2) IS
      SELECT id_proveedor,
             LPAD(numero_documento, 9, '0') numero_documento,
             DECODE(debe, 0, haber, debe) monto
        FROM cg_m_detalle_asiento
       WHERE COMPANIA = pCia
         AND id_asiento = c_asiento
         AND concepto = c_concepto
         AND id_proveedor IS NOT NULL
         AND numero_documento IS NOT NULL;
  
    CURSOR c_dato_refe(c_prove  VARCHAR2,
                       c_fisico VARCHAR2) IS
      SELECT tipo_doc,
             no_docu,
             saldo
        FROM arcpmd
       WHERE no_cia = pCia
         AND saldo <> 0
         AND no_prove = c_prove
         AND no_fisico = c_fisico
         AND ind_act <> 'P'
         AND anulado = 'N';
  
    vv_proveedor      arcpmp.no_prove%TYPE;
    vv_documento      cg_m_detalle_asiento.numero_documento%TYPE;
    vv_noDocu         VARCHAR2(12);
    vv_id_asiento     CG_M_ASIENTO_CONTABLE.ID_ASIENTO%TYPE;
    vd_fecha          CG_M_ASIENTO_CONTABLE.Fecha%TYPE;
    vv_codigo_asiento CG_M_ASIENTO_CONTABLE.Codigo_Asiento%TYPE;
    Lv_Error          VARCHAR2(500);
    Error_Proceso EXCEPTION;
    vv_tipo_refe arcprd.tipo_refe%TYPE;
    vv_docu_refe arcprd.no_refe%TYPE;
    vn_saldo_doc arcpmd.saldo%TYPE;
    vv_no_fisico arcpmd.no_fisico%TYPE;
    --
  
  BEGIN
    -- Obtiene las notas de credito a generarse.
    FOR i IN c_movimientos LOOP
    
      --  Obtengo el numero fisico de la NC
      OPEN c_No_Fisico(i.id_asiento, i.concepto);
      FETCH c_No_Fisico
        INTO vv_no_fisico;
      CLOSE c_No_Fisico;
    
      -- Con la descripcion obtengo las los datos necesarios para llenar las tablas 
      -- Proveedor
      OPEN c_proveedor(i.id_asiento, i.concepto);
      FETCH c_proveedor
        INTO vv_proveedor,
             vv_documento;
      CLOSE c_proveedor;
    
      -- Se obtiene no_docu 
      vv_noDocu := transa_id.cp(pCia);
    
      -- Datos de cabecera
      OPEN c_datos_cabecera(i.id_asiento, i.concepto);
      FETCH c_datos_cabecera
        INTO vv_id_asiento,
             vd_fecha,
             vv_codigo_asiento;
      CLOSE c_datos_cabecera;
    
      -- Llenado de ARCPMD
      BEGIN
        INSERT INTO ARCPMD
          (no_cia,
           no_prove,
           tipo_doc,
           no_docu,
           ind_act,
           no_fisico,
           serie_fisico,
           fecha,
           subtotal,
           monto,
           saldo,
           gravado,
           tot_refer,
           tot_db,
           tot_cr,
           moneda,
           tipo_cambio,
           monto_nominal,
           saldo_nominal,
           detalle,
           origen,
           tot_imp,
           cod_diario,
           codigo_sustento,
           no_autorizacion,
           fecha_caducidad,
           usuario)
        VALUES
          (pCia,
           vv_proveedor,
           'NC',
           vv_noDocu,
           'P',
           LPAD(vv_no_fisico, 9, '0'),
           '001001',
           vd_fecha,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           'P',
           1,
           0,
           0,
           'Asiento: ' || vv_id_asiento || ' - ' || i.concepto,
           'MI',
           0,
           15,
           '01',
           NULL,
           vd_fecha + 365,
           'NAF47_TNET');
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Error := 'Error al crear registro en ARCPMD.' || SQLERRM;
          RAISE Error_Proceso;
      END;
    
      FOR d IN c_detalle(i.id_asiento, i.concepto) LOOP
        -- Llenado de ARCPDC
        BEGIN
          INSERT INTO ARCPDC
            (no_cia,
             no_prove,
             tipo_doc,
             no_docu,
             codigo,
             tipo,
             monto,
             mes,
             ano,
             ind_con,
             monto_dol,
             moneda,
             tipo_cambio,
             centro_costo,
             modificable,
             monto_dc,
             glosa)
          VALUES
            (pCia,
             vv_proveedor,
             'NC',
             vv_noDocu,
             d.id_cuenta_contable,
             d.tipo,
             d.monto,
             TO_CHAR(vd_fecha, 'MM'),
             TO_CHAR(vd_fecha, 'YYYY'),
             'P',
             d.monto,
             'P',
             1,
             d.id_centro_costo,
             'N',
             d.monto,
             --JXZURITA-AUMENTO CAMPO GLOSA INICIO
             --SUBSTR(d.glosa, 1, 100)
             SUBSTR(d.glosa, 1, F_TAM_GLOSA_CONT(pCia,'AG_CGKMIGRACIONMEGA',100))
             --JXZURITA-AUMENTO CAMPO GLOSA FIN
             );
        EXCEPTION
          WHEN OTHERS THEN
            Lv_Error := 'Error al crear registro en ARCPDC.' || SQLERRM;
            RAISE Error_Proceso;
        END;
      END LOOP;
    
      -- Llenado de ARCPRD    
      FOR r IN c_referencias(i.id_asiento, i.concepto) LOOP
      
        -- Buscar la factura y con que tipo se grabo
        OPEN c_dato_refe(vv_proveedor, r.numero_documento);
        FETCH c_dato_refe
          INTO vv_tipo_refe,
               vv_docu_refe,
               vn_saldo_doc;
        IF c_dato_refe%NOTFOUND THEN
          CLOSE c_dato_refe;
          Lv_Error := 'No existe la facrura a referenciar: ' || r.numero_documento;
          RAISE error_proceso;
        ELSE
          CLOSE c_dato_refe;
        END IF;
      
        IF r.monto > vn_saldo_doc THEN
          Lv_Error := 'El valor a referenciar es mayor al saldo disponible. Documento: ' || r.numero_documento;
          RAISE error_proceso;
        END IF;
      
        -- Llenado de ARCPRD
        BEGIN
          INSERT INTO ARCPRD
            (no_cia,
             tipo_doc,
             no_docu,
             tipo_refe,
             no_refe,
             monto,
             monto_refe,
             moneda_refe,
             fec_aplic,
             ano,
             mes,
             ind_procesado,
             no_prove)
          VALUES
            (pCia,
             'NC',
             vv_noDocu,
             vv_tipo_refe,
             vv_docu_refe,
             r.monto,
             r.monto,
             r.monto,
             vd_fecha,
             TO_CHAR(vd_fecha, 'YYYY'),
             TO_CHAR(vd_fecha, 'MM'),
             'N',
             r.id_proveedor);
        EXCEPTION
          WHEN OTHERS THEN
            Lv_Error := 'Error al crear registro en ARCPRD.' || SQLERRM;
            RAISE Error_Proceso;
        END;
      END LOOP;
    
      -- Llenado de ARCPTI    
      FOR t IN c_detalle(i.id_asiento, i.concepto) LOOP
        IF t.id_cuenta_contable = '6110201035' THEN
          BEGIN
            INSERT INTO ARCPTI
              (no_cia,
               no_prove,
               tipo_doc,
               no_docu,
               clave,
               porcentaje,
               monto,
               ind_imp_ret,
               aplica_cred_fiscal,
               base,
               comportamiento,
               no_refe)
            VALUES
              (pCia,
               vv_proveedor,
               'NC',
               vv_noDocu,
               '01',
               12,
               t.monto,
               'I',
               'S',
               (t.monto / 12) * 100,
               'E',
               vv_noDocu);
          EXCEPTION
            WHEN OTHERS THEN
              Lv_Error := 'Error al crear registro en ARCPDC.' || SQLERRM;
              RAISE Error_Proceso;
          END;
        END IF;
      END LOOP;
    END LOOP; -- c_movimientos
  
  EXCEPTION
    WHEN error_proceso THEN
      pMsg_error := 'ARCPMD :' || pMsg_error;
      ROLLBACK;
      RETURN;
    
    WHEN OTHERS THEN
      pMsg_error := 'ARCPMD :' || SQLERRM;
      ROLLBACK;
      RETURN;
    
  END CP_GENERA_NC_MEGA;
  --
  --Procedimiento que migra las liquidaciones de compras
  PROCEDURE CGP_LIQUI_COMPRAS(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_FechaDesde   IN VARCHAR2,
                              Pv_FechaHasta   IN VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS
    --
    CURSOR C_LeeLiquiCompras(Cv_IdEmpresa  IN VARCHAR,
                             Cd_FechaDesde IN VARCHAR2,
                             Cd_FechaHasta IN VARCHAR2) IS
      SELECT DISTINCT DA.ID_PROVEEDOR,
                      DA.CONCEPTO,
                      DA.HABER MONTO,
                      DA.DEBE MONTO2,
                      LPAD(DA.NUMERO_DOCUMENTO, 10, '0') NUMERO_DOCUMENTO,
                      AC.CODIGO_ASIENTO,
                      UPPER(SUBSTR(LPAD(DA.NUMERO_DOCUMENTO, 9, '0'), 1, 1)) NUM_ERR,
                      LPAD(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), 12, '0') NUMERO_DOCUMENTO2,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      REPLACE(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), '#', '') NUMERO_DOCUMENTO3 --,
      --DA.LINEA
        FROM CG_M_DETALLE_ASIENTO  DA,
             CG_M_ASIENTO_CONTABLE AC
       WHERE DA.TIPO_ASIENTO = AC.TIPO_ASIENTO
         AND DA.ID_ASIENTO = AC.ID_ASIENTO
         AND DA.COMPANIA = Cv_IdEmpresa
         AND DA.TIPO_DOCUMENTO = 'FP'
         AND AC.CODIGO_ASIENTO = '08'
            --AND DA.ID_PROVEEDOR = '4009'
         AND TRUNC(AC.FECHA) >= Cd_FechaDesde
         AND TRUNC(AC.FECHA) <= Cd_FechaHasta
         AND DA.ID_PROVEEDOR IS NOT NULL --= '4287' --,'3703'
         AND NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%')
            --AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'))
            --AND upper(DA.Concepto) LIKE ('%14504%')
         AND INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) > 0;
  
    CURSOR C_LeeDetalleContable(Pv_IdEmpresa  IN VARCHAR2,
                                Cv_IdAsiento  IN VARCHAR2, --
                                Cv_NoFactura  IN VARCHAR2,
                                Cd_FechaDesde IN VARCHAR2,
                                Cd_FechaHasta IN VARCHAR2) IS
      SELECT DISTINCT DA.ID_PROVEEDOR,
                      DA.TIPO_DOCUMENTO,
                      DA.CONCEPTO,
                      DA.HABER, -- MONTO,
                      DA.DEBE, -- MONTO2,
                      LPAD(DA.NUMERO_DOCUMENTO, 10, '0') NUMERO_DOCUMENTO,
                      AC.CODIGO_ASIENTO,
                      UPPER(SUBSTR(LPAD(DA.NUMERO_DOCUMENTO, 10, '0'), 1, 1)) NUM_ERR,
                      LPAD(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), 12, '0') NUMERO_DOCUMENTO2,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      REPLACE(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), '#', '') NUMERO_DOCUMENTO3,
                      DA.LINEA,
                      DA.ID_CUENTA_CONTABLE
        FROM CG_M_DETALLE_ASIENTO  DA,
             CG_M_ASIENTO_CONTABLE AC
       WHERE DA.TIPO_ASIENTO = AC.TIPO_ASIENTO
         AND DA.ID_ASIENTO = AC.ID_ASIENTO
         AND DA.COMPANIA = Pv_IdEmpresa
            --AND DA.TIPO_DOCUMENTO = 'PV'
         AND AC.CODIGO_ASIENTO = '08'
         AND TRUNC(AC.FECHA) >= Cd_FechaDesde
         AND TRUNC(AC.FECHA) <= Cd_FechaHasta
            --AND DA.ID_PROVEEDOR IS NULL --= '4287' --,'3703'
         AND NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%')
         AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'))
         AND AC.ID_ASIENTO = Cv_IdAsiento
         AND REPLACE(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), '#', '') LIKE ('%' || Cv_NoFactura || '%')
            --AND upper(DA.Concepto) LIKE ('%DIAS%GEOVANNY%LC#14521%')
         AND DA.ITEGAS IS NULL
         AND NVL(DA.ID_PROVEEDOR, 'X') <> '9999'
         AND INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'LC#', 1, 1) > 0;
    --
    CURSOR C_LeeInfoFactura(Cv_IdEmpresa   IN VARCHAR2, --
                            Cv_IdAsiento   IN VARCHAR2, --
                            Cv_IdFactura   IN VARCHAR2,
                            Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             --DC.CODSUS,--
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             SUM(DC.BASSINRET) BASSINRET,
             SUM(DC.MONIVABIE) MONIVABIE,
             SUM(DC.NUMREN) NUMREN,
             SUM(DC.BASIMPICE) BASIMPICE,
             SUM(DC.MONICE) MONICE,
             SUM(DC.BASENOGRAIVA) BASENOGRAIVA,
             SUM(DC.MONRETIVASER100) MONRETIVASER100,
             SUM(DC.MONRETIVASER) MONRETIVASER,
             SUM(DC.MONRETIVABIE) MONRETIVABIE,
             SUM(DC.MONIVASER) MONIVASER,
             SUM(DC.MONIVA) MONIVA,
             SUM(DC.BASIMPIVA) BASIMPIVA,
             SUM(DC.BASIMPCER) BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND DC.NUMSECCOM LIKE ('%' || Cv_IdFactura || '%') --TO_NUMBER(Cv_IdFactura)
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa
       GROUP BY DC.CODIVASER100, --
                DC.FECCADCOM, --
                DC.FECEMICOM, --
                DC.FECREGCON, --
                DC.FECACTREG, --
                DC.FECCREREG, --
                DC.FECEMICMO, --
                DC.SINRET, --
                DC.TRADEV, --
                DC.CODIVABIE, --
                DC.CODIVASER, --
                DC.CODPORIVA, --
                DC.NUMAUTCOM, --
                DC.NUMAUTCMO, --
                DC.IDEPRO, --
                DC.NUMDOC, --
                DC.CODEMP, --
                DC.TIPCOM, --
                --DC.CODSUS,--
                DC.TIPCOMMNC, --
                DC.CODPORICE, --
                DC.CODCOM, --
                DC.NUMSECCOM, --
                DC.CODPRO, --
                DC.NUMSEREST, --
                DC.NUMSERCMOPTE, --
                DC.NUMSERCMOEST, --
                DC.NUMSERPTE, --
                DC.REGCREPOR, --
                DC.REGACTPOR, --
                DC.CODSINRET, --
                DC.NUMSECCMO;
    --
    CURSOR C_DetalleSustentos(Cv_IdEmpresa   IN VARCHAR2, --
                              Cv_IdAsiento   IN VARCHAR2, --
                              Cv_IdFactura   IN VARCHAR2,
                              Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODSUS,
             DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             BASSINRET,
             MONIVABIE,
             NUMREN,
             BASIMPICE,
             MONICE,
             BASENOGRAIVA,
             MONRETIVASER100,
             MONRETIVASER,
             MONRETIVABIE,
             MONIVASER,
             MONIVA,
             BASIMPIVA,
             BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND DC.NUMSECCOM LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%')
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa;
    --}
    CURSOR C_LeeAplicacionImp(Cv_IdSustento IN VARCHAR2) IS
      SELECT APLICA_C_TRIBUTARIO
        FROM SRI_SUSTENTO_COMPROBANTE
       WHERE CODIGO = Cv_IdSustento;
    --
    CURSOR C_LeeDistCont(Cv_IdEmpresa       IN VARCHAR2,
                         Cv_IdDocumento     IN VARCHAR2,
                         Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT NVL(SUM(DECODE(TIPO, 'D', MONTO, 0)), 0) DEBITO,
             NVL(SUM(DECODE(TIPO, 'C', 0, MONTO)), 0) CREDITO
        FROM ARCPDC
       WHERE NO_DOCU = Cv_IdDocumento
         AND TIPO_DOC = Cv_IdTipoDocumento
         AND NO_CIA = Cv_IdEmpresa;
  
    Lr_Documentos ARCPMD%ROWTYPE := NULL;
    --Lr_Totales        ARCPMD%ROWTYPE := NULL;
    Lr_MovimientoFact CG_M_DETALLE_ASIENTO%ROWTYPE := NULL;
    Lr_DetalleCont    ARCPDC%ROWTYPE := NULL;
    Lv_NoDocu         ARCPMD.NO_DOCU%TYPE := NULL;
    Lr_DetFactura     C_LeeInfoFactura%ROWTYPE := NULL;
    Lr_Retenciones    ARCPTI%ROWTYPE := NULL;
    Le_Error EXCEPTION;
    Lv_NumeroFactDet   VARCHAR2(50) := NULL;
    Lr_DetTributoIva   CP_DETALLE_TRIBUTO_IVA%ROWTYPE := NULL;
    Lv_AplicaCreditTri VARCHAR2(2) := NULL;
    Ln_SecuenciaSust   NUMBER(10) := 0;
  
  BEGIN
  
    FOR Lr_Migra IN C_LeeLiquiCompras(Pv_IdEmpresa, Pv_FechaDesde, Pv_FechaHasta) LOOP
      Lr_DetFactura    := NULL;
      Lv_NumeroFactDet := NULL;
      BEGIN
        Lv_NumeroFactDet := TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO3);
      
        IF C_LeeInfoFactura%ISOPEN THEN
          CLOSE C_LeeInfoFactura;
        END IF;
        OPEN C_LeeInfoFactura(Pv_IdEmpresa, --
                              Lr_Migra.Id_Asiento,
                              Lr_Migra.NUMERO_DOCUMENTO3,
                              Lr_Migra.Id_Proveedor);
        FETCH C_LeeInfoFactura
          INTO Lr_DetFactura;
        CLOSE C_LeeInfoFactura;
      EXCEPTION
        WHEN value_error THEN
          DBMS_OUTPUT.put_line('No de Factura Erronea LC' || Lv_NumeroFactDet);
          Lr_Documentos.Detalle := Lr_Documentos.Detalle || 'No de Factura Erronea ' || Lv_NumeroFactDet;
          --RAISE Le_Error;
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error de Numero Factura LC ' || Lv_NumeroFactDet);
          Lr_Documentos.Detalle := Lr_Documentos.Detalle || 'No de Factura Erronea ' || Lv_NumeroFactDet;
          --RAISE Le_Error;
      END;
    
      --
      --
      Lr_Documentos.GRAVADO  := NVL(Lr_DetFactura.BASIMPIVA, 0);
      Lr_Documentos.EXCENTOS := NVL(Lr_DetFactura.BASIMPCER, 0);
      Lr_Documentos.TOT_IMP  := round(Lr_DetFactura.MONIVA, 2);
      --BASIMPCER,BASEIMPIVA
      /*Lr_Totales.SUBTOTAL*/
      Lr_Documentos.Subtotal := ROUND(NVL(Lr_DetFactura.BASIMPIVA, 0) + NVL(Lr_DetFactura.BASIMPCER, 0), 2);
      /*Lr_Totales.Monto    */
      --Lr_Documentos.Monto := NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_DetFactura.BASIMPIVA, 0);
      --
      --Lr_Documentos.Monto    := Lr_Totales.Monto;
      --Lr_Documentos.Subtotal := Lr_Totales.SUBTOTAL;
    
      IF NVL(Lr_DetFactura.MONIVABIE, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA  := 'B';
        Lr_Documentos.TIPO_DOC     := 'FB';
        Lr_Documentos.Monto_Bienes := Lr_Documentos.GRAVADO;
      ELSIF NVL(Lr_DetFactura.MONIVASER, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA := 'S';
        Lr_Documentos.TIPO_DOC    := 'FV';
        Lr_Documentos.Monto_Serv  := Lr_Documentos.GRAVADO;
      ELSIF NVL(Lr_DetFactura.Basimpcer, 0) > 0 THEN
        Lr_Documentos.TIPO_COMPRA     := 'S';
        Lr_Documentos.TIPO_DOC        := 'FV';
        Lr_Documentos.Monto_Serv      := Lr_Documentos.GRAVADO;
        Lr_Documentos.CODIGO_SUSTENTO := '02';
      
      ELSE
        Lr_Documentos.TIPO_COMPRA := 'V';
      END IF;
      IF NVL(Lr_DetFactura.BASIMPIVA, 0) > 0 THEN
        Lr_Documentos.CODIGO_SUSTENTO := '01';
      ELSE
        Lr_Documentos.CODIGO_SUSTENTO := '02';
      END IF;
      --
      Lr_Documentos.TOT_RET     := 0; --las Liquidaciones no tienen retenciones
      Lr_Documentos.NO_CIA      := Pv_IdEmpresa;
      Lr_Documentos.NO_PROVE    := Lr_Migra.ID_PROVEEDOR;
      Lr_Documentos.IND_ACT     := 'P';
      Lr_Documentos.NO_FISICO   := LPAD(Lr_Migra.NUMERO_DOCUMENTO3, 9, '0');
      Lr_Documentos.IND_OTROMOV := 'N';
      Lr_Documentos.FECHA       := Lr_Migra.FECHA;
      Lr_Documentos.SALDO       := (Lr_Documentos.Subtotal + NVL(Lr_Documentos.TOT_IMP, 0)); -- - NVL(Lr_Totales.TOT_RET, 0));
      Lr_Documentos.TOT_DB      := NVL(Lr_Documentos.Subtotal, 0) + NVL(Lr_Documentos.TOT_IMP, 0);
      Lr_Documentos.TOT_CR      := NVL(Lr_Documentos.Subtotal, 0) + NVL(Lr_Documentos.TOT_IMP, 0);
      --
      Lr_Documentos.FECHA_VENCE   := Lr_Migra.FECHA + 360;
      Lr_Documentos.BLOQUEADO     := 'N';
      Lr_Documentos.MONEDA        := 'P';
      Lr_Documentos.TIPO_CAMBIO   := 1;
      Lr_Documentos.MONTO_NOMINAL := Lr_Documentos.SALDO; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
      Lr_Documentos.SALDO_NOMINAL := Lr_Documentos.SALDO; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
      --
      Lr_Documentos.T_CAMB_C_V           := 'V';
      Lr_Documentos.DETALLE              := SUBSTR(Lr_Migra.CONCEPTO || ' -MIGRA HK ' || Lr_Migra.ID_ASIENTO, 1, 100);
      Lr_Documentos.IND_OTROS_MESES      := 'N';
      Lr_Documentos.FECHA_DOCUMENTO      := Lr_Migra.Fecha;
      Lr_Documentos.FECHA_VENCE_ORIGINAL := Lr_Migra.Fecha;
      Lr_Documentos.ORIGEN               := 'CP';
      Lr_Documentos.ANULADO              := 'N';
      Lr_Documentos.IND_ESTADO_VENCIDO   := 'N';
      Lr_Documentos.TOT_IMP_ESPECIAL     := 0;
      Lr_Documentos.COD_DIARIO           := '08'; --CONFIRMAR;
      Lr_Documentos.TOT_RET_ESPECIAL     := 0;
    
      Lr_Documentos.DERECHO_DEVOLUCION_IVA := 'N';
      Lr_Documentos.FECHA_CADUCIDAD        := Lr_DetFactura.FECCADCOM; --Lr_Migra.Fecha + 360;
      Lr_Documentos.USUARIO                := USER;
      Lr_Documentos.FACTURA_EVENTUAL       := 'N';
      Lr_Documentos.TIPO_RET               := 'R2'; --REVISAR
      Lr_Documentos.NO_AUTORIZACION        := Lr_DetFactura.NUMAUTCOM;
      Lr_Documentos.SERIE_FISICO           := Lr_DetFactura.NUMSEREST || Lr_DetFactura.NUMSERPTE;
      Lr_Documentos.DESC_C                 := 0;
      Lr_Documentos.DESC_P                 := 0;
      Lr_Documentos.PLAZO_C                := 0;
      Lr_Documentos.PLAZO_P                := 0;
      Lr_Documentos.Monto                  := Lr_Documentos.SUBTOTAL + round(Lr_Documentos.TOT_IMP, 2) - Lr_Documentos.TOT_RET;
      Lv_NoDocu                            := transa_id.cp(Pv_IdEmpresa);
      ---
      BEGIN
        INSERT INTO ARCPMD
          (NO_CIA,
           NO_PROVE,
           TIPO_DOC,
           NO_DOCU,
           IND_ACT,
           NO_FISICO,
           IND_OTROMOV,
           FECHA,
           SUBTOTAL, ---
           SALDO, --
           GRAVADO, --
           EXCENTOS, --
           TOT_DB, --
           TOT_CR, --
           FECHA_VENCE,
           BLOQUEADO, --
           MONEDA, --
           TIPO_CAMBIO, --
           MONTO_NOMINAL,
           SALDO_NOMINAL,
           TIPO_COMPRA,
           T_CAMB_C_V, --
           DETALLE, --
           IND_OTROS_MESES, --
           FECHA_DOCUMENTO, --
           FECHA_VENCE_ORIGINAL, --
           ORIGEN, --
           ANULADO, --
           IND_ESTADO_VENCIDO, --
           TOT_IMP, --
           TOT_RET, --
           TOT_IMP_ESPECIAL, --
           COD_DIARIO, --
           TOT_RET_ESPECIAL, --
           CODIGO_SUSTENTO, --
           DERECHO_DEVOLUCION_IVA, --
           FECHA_CADUCIDAD, --
           USUARIO, --
           FACTURA_EVENTUAL, --
           TIPO_RET, --
           TARJETA_CORP,
           NO_AUTORIZACION,
           SERIE_FISICO,
           MONTO,
           DESC_C,
           DESC_P,
           PLAZO_C,
           PLAZO_P)
        VALUES
          (Pv_IdEmpresa, --
           Lr_Migra.ID_PROVEEDOR,
           Lr_Documentos.TIPO_DOC, --FACTURAS DE COSTOS
           Lv_NoDocu,
           Lr_Documentos.IND_ACT, --estado
           LPAD(Lr_Documentos.NO_FISICO, 9, '0'), --NO_FISICO
           'N', --IND_OTROMOV
           Lr_Migra. FECHA,
           Lr_Documentos.SUBTOTAL,
           Lr_Documentos.SALDO,
           Lr_Documentos.GRAVADO,
           Lr_Documentos.EXCENTOS,
           Lr_Documentos.TOT_CR,
           Lr_Documentos.TOT_DB,
           Lr_Documentos.FECHA_VENCE,
           Lr_Documentos.BLOQUEADO,
           Lr_Documentos.MONEDA,
           Lr_Documentos.TIPO_CAMBIO,
           Lr_Documentos.MONTO_NOMINAL,
           Lr_Documentos.SALDO_NOMINAL,
           Lr_Documentos.TIPO_COMPRA,
           Lr_Documentos.T_CAMB_C_V,
           SUBSTR(Lr_Migra.CONCEPTO || '-' || Lr_Documentos.Detalle, 1, 100),
           Lr_Documentos.IND_OTROS_MESES,
           Lr_Documentos.FECHA_DOCUMENTO,
           Lr_Documentos.FECHA_VENCE_ORIGINAL,
           Lr_Documentos.ORIGEN,
           Lr_Documentos.ANULADO,
           Lr_Documentos.IND_ESTADO_VENCIDO,
           Lr_Documentos.TOT_IMP,
           Lr_Documentos.TOT_RET,
           Lr_Documentos.TOT_IMP_ESPECIAL,
           Lr_Documentos.COD_DIARIO,
           Lr_Documentos.TOT_RET_ESPECIAL,
           Lr_Documentos.CODIGO_SUSTENTO,
           Lr_Documentos.DERECHO_DEVOLUCION_IVA,
           Lr_Documentos.FECHA_CADUCIDAD,
           Lr_Documentos.USUARIO,
           Lr_Documentos.FACTURA_EVENTUAL,
           Lr_Documentos.TIPO_RET,
           Lr_Documentos.TARJETA_CORP,
           Lr_Documentos.NO_AUTORIZACION,
           Lr_Documentos.SERIE_FISICO,
           Lr_Documentos.Monto,
           Lr_Documentos.DESC_C,
           Lr_Documentos.DESC_P,
           Lr_Documentos.PLAZO_C,
           Lr_Documentos.PLAZO_P);
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error' || SQLCODE || ' ' || SQLERRM || ' ' || Lr_Documentos.NO_FISICO);
      END;
      --Detalle Contable
      FOR Lr_Detalle IN C_LeeDetalleContable(Pv_IdEmpresa,
                                             Lr_Migra.ID_ASIENTO, --Cv_IdAsiento  IN VARCHAR2, --
                                             Lr_Migra.NUMERO_DOCUMENTO3, --Cv_NoFactura  IN VARCHAR2,
                                             Pv_FechaDesde,
                                             Pv_FechaHasta) LOOP
        Lr_DetalleCont          := NULL;
        Lr_DetalleCont.NO_CIA   := Pv_IdEmpresa;
        Lr_DetalleCont.NO_PROVE := Lr_Migra.ID_PROVEEDOR;
        Lr_DetalleCont.TIPO_DOC := Lr_Documentos.TIPO_DOC;
        Lr_DetalleCont.NO_DOCU  := Lv_NoDocu;
        Lr_DetalleCont.CODIGO   := Lr_Detalle.ID_CUENTA_CONTABLE;
        IF Lr_Detalle.DEBE > 0 THEN
          Lr_DetalleCont.TIPO      := 'D';
          Lr_DetalleCont.MONTO     := ROUND(Lr_Detalle.DEBE, 2);
          Lr_DetalleCont.MONTO_DOL := ROUND(Lr_Detalle.DEBE, 2);
          Lr_DetalleCont.MONTO_DC  := ROUND(Lr_Detalle.DEBE, 2);
        ELSIF Lr_Detalle.HABER > 0 THEN
          Lr_DetalleCont.TIPO      := 'C';
          Lr_DetalleCont.MONTO     := ROUND(Lr_Detalle.HABER, 2);
          Lr_DetalleCont.MONTO_DOL := ROUND(Lr_Detalle.HABER, 2);
          Lr_DetalleCont.MONTO_DC  := ROUND(Lr_Detalle.HABER, 2);
        
        END IF;
      
        --Lr_DetalleCont.MONTO              := Lr_DetCont.;
        Lr_DetalleCont.MES     := TO_NUMBER(TO_CHAR(Lr_Migra.FECHA, 'MM'));
        Lr_DetalleCont.ANO     := TO_NUMBER(TO_CHAR(Lr_Migra.FECHA, 'YYYY'));
        Lr_DetalleCont.IND_CON := 'P';
      
        Lr_DetalleCont.MONEDA         := 'P';
        Lr_DetalleCont.TIPO_CAMBIO    := 1;
        Lr_DetalleCont.NO_ASIENTO     := NULL;
        Lr_DetalleCont.CENTRO_COSTO   := '000000000';
        Lr_DetalleCont.MODIFICABLE    := 'N';
        Lr_DetalleCont.CODIGO_TERCERO := NULL;
      
        Lr_DetalleCont.GLOSA              := SUBSTR(Lr_Detalle.CONCEPTO, 1, 100);
        --JXZURITA-AUMENTO CAMPO GLOSA INICIO
        --Lr_DetalleCont.GLOSA              := SUBSTR(Lr_Detalle.CONCEPTO, 1, 100);
        Lr_DetalleCont.GLOSA              := SUBSTR(Lr_Detalle.CONCEPTO, 1, F_TAM_GLOSA_CONT(Lr_DetalleCont.no_cia,'AG_CGKMIGRACIONMEGA',100));
        --JXZURITA-AUMENTO CAMPO GLOSA FIN
        
        Lr_DetalleCont.EXCEDE_PRESUPUESTO := NULL;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_MOVIMIENTO(Lr_DetalleCont, --
                                                  Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        Lr_MovimientoFact := NULL;
      END LOOP;
      --
      IF C_LeeDistCont%ISOPEN THEN
        CLOSE C_LeeDistCont;
      END IF;
      OPEN C_LeeDistCont(Pv_IdEmpresa, Lv_NoDocu, Lr_Documentos.TIPO_DOC);
      FETCH C_LeeDistCont
        INTO Lr_Documentos.TOT_DB,
             Lr_Documentos.TOT_CR;
      CLOSE C_LeeDistCont;
      --
      UPDATE ARCPMD FA
         SET FA.TOT_DB = Lr_Documentos.TOT_DB,
             FA.TOT_CR = Lr_Documentos.TOT_CR
       WHERE FA.NO_DOCU = Lv_NoDocu
         AND FA.TIPO_DOC = Lr_Documentos.TIPO_DOC
         AND FA.NO_CIA = Pv_IdEmpresa;
    
      --INSERTAR IVA EN EL DETALLE DE IMPUESTOS
      Lr_Retenciones          := NULL;
      Lr_Retenciones.NO_CIA   := Pv_IdEmpresa;
      Lr_Retenciones.NO_PROVE := Lr_Documentos.NO_PROVE;
      Lr_Retenciones.TIPO_DOC := Lr_Documentos.TIPO_DOC;
      Lr_Retenciones.NO_DOCU  := Lv_NoDocu;
      Lr_Retenciones.CLAVE    := '00';
      --Lr_RegSRI.Clave;
      Lr_Retenciones.SRI_RETIMP_RENTA := NULL; --Lr_RegSRI.SRI_RETIMP_RENTA; --REVISAR
    
      Lr_Retenciones.PORCENTAJE         := 12;
      Lr_Retenciones.MONTO              := round(Lr_DetFactura.Moniva, 2);
      Lr_Retenciones.IND_IMP_RET        := 'I';
      Lr_Retenciones.APLICA_CRED_FISCAL := 'S';
      Lr_Retenciones.BASE               := round(Lr_DetFactura.Basimpiva, 2); --Lr_Impuestos.BASRET;
      Lr_Retenciones.COMPORTAMIENTO     := 'E';
      Lr_Retenciones.ID_SEC             := NULL;
      Lr_Retenciones.NO_REFE            := Lv_NoDocu;
      Lr_Retenciones.SECUENCIA_RET      := NULL; --Lr_Impuestos.SERFAC;
      Lr_Retenciones.FECHA_IMPRIME      := NULL;
    
      Lr_Retenciones.SERVICIO_BIENES := NULL;
      Lr_Retenciones.AUTORIZACION    := NULL;
      Lr_Retenciones.FECHA_ANULA     := NULL;
      Lr_Retenciones.BASE_GRAVADA    := NULL;
      Lr_Retenciones.BASE_EXCENTA    := NULL;
      --
      CGK_MIGRACION_MEGA.CGP_INSERTA_IMPUESTO(Lr_Retenciones, Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        Pv_MensajeError := 'Error en CGP_INSERTA_IMPUESTO. ' || Pv_MensajeError;
        RAISE Le_Error;
      END IF;
      --
      --Detalle de sustentos
      Ln_SecuenciaSust := 1;
      FOR Lr_DetSustento IN C_DetalleSustentos(Pv_IdEmpresa, Lr_Migra.ID_ASIENTO, Lr_DetFactura.Numseccom, Lr_Documentos.NO_PROVE) LOOP
        --18582202
        Lr_DetTributoIva                   := NULL;
        Lr_DetTributoIva.ID_EMPRESa        := Pv_IdEmpresa;
        Lr_DetTributoIva.ID_TIPO_DOCUMENTO := Lr_Documentos.Tipo_Doc;
        Lr_DetTributoIva.ID_DOCUMENTO      := Lv_NoDocu;
        Lr_DetTributoIva.ID_SUSTENTO       := Lr_DetSustento.CODSUS;
        Lr_DetTributoIva.Secuencia         := Ln_SecuenciaSust;
        Lr_DetTributoIva.MONTO_BASE_IVA    := NVL(Lr_DetSustento.BASIMPIVA, 0);
        Lr_DetTributoIva.MONTO_BASE_CERO   := NVL(Lr_DetSustento.BASIMPCER, 0);
        Lr_DetTributoIva.MONTO_NETO        := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0);
        Lr_DetTributoIva.MONTO_IVA         := NVL(Lr_DetSustento.Moniva, 0);
        Lr_DetTributoIva.MONTO_TOTAL       := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0) + NVL(Lr_DetSustento.Moniva, 0);
        IF (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0)) = 0 THEN
          Lr_DetTributoIva.PORCENTAJE := 0;
        ELSE
          Lr_DetTributoIva.PORCENTAJE := ((NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0)) * 100) / (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0));
        END IF;
        Lr_DetTributoIva.USUARIO_CREA := Lr_DetSustento.REGCREPOR;
        Lr_DetTributoIva.FECHA_CREA   := Lr_DetSustento.FECACTREG;
        Lv_AplicaCreditTri            := NULL;
        IF C_LeeAplicacionImp%ISOPEN THEN
          CLOSE C_LeeAplicacionImp;
        END IF;
        OPEN C_LeeAplicacionImp(Lr_DetSustento.CODSUS);
        FETCH C_LeeAplicacionImp
          INTO Lv_AplicaCreditTri;
        CLOSE C_LeeAplicacionImp;
      
        Lr_DetTributoIva.APLICA_CREDITO_IVA := Lv_AplicaCreditTri;
        Lr_DetTributoIva.COMENTARIO         := 'MIGRACION HIPERK-NAF ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY') || ', ASIENTO # ' || Lr_Migra.ID_ASIENTO || '  ' || Lr_DetSustento.Codcom || ' ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro || ' ' || Lr_DetSustento.Numren;
        --Lr_DetTributoIva.COMENTARIO         := 'MIGRACION HIPERK-NAF ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY') || ', ASIENTO # ' || Lr_Migra.ID_ASIENTO;
      
        IF NVL(Lr_DetSustento.MONIVA, 0) = 0 THEN
          Lr_DetTributoIva.PORCENTAJE_RETENCION := 12;
        ELSE
          Lr_DetTributoIva.PORCENTAJE_RETENCION := ((NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0)) * 100) / NVL(Lr_DetSustento.MONIVA, 1);
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) = 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'SE';
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) = 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BI';
        END IF;
        IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
          Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BS';
        END IF;
      
        Lr_DetTributoIva.MONTO_BASE_RETENCION  := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
        Lr_DetTributoIva.MONTO_IVA_RETENCION   := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
        Lr_DetTributoIva.MONTO_TOTAL_RETENCION := Lr_DetTributoIva.MONTO_BASE_RETENCION + Lr_DetTributoIva.MONTO_IVA_RETENCION;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_DET_IVA(Lr_DetTributoIva, Pv_MensajeError);
      
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := Pv_MensajeError || ' fact. ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro || ' comen:' || Lr_DetTributoIva.Comentario;
          RAISE Le_Error;
        END IF;
        Ln_SecuenciaSust := Ln_SecuenciaSust + 1;
        --
      
        UPDATE CG_M_ASIENTO_CONTABLE AC
           SET AC.MIGRADO = 'S'
         WHERE AC.Id_Asiento = Lr_Migra.Id_Asiento
           AND AC.COMPANIA = Pv_IdEmpresa;
      
      END LOOP;
      --
      Lv_NoDocu := NULL;
    END LOOP;
    --END CGP_LIQUI_COMPRAS;
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_LIQUI_COMPRAS. ' || SQLCODE || ' ' || SQLERRM || '  elvis ' || Lr_Documentos.No_Fisico;
      ROLLBACK;
  END CGP_LIQUI_COMPRAS;
  --
  --Procedimiento que migra las facturas de costos y las de provisiones 
  PROCEDURE CGP_FACTURAS_25(Pv_IdEmpresa    IN VARCHAR2,
                            Pv_FechaDesde   IN VARCHAR2,
                            Pv_FechaHasta   IN VARCHAR2,
                            Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeeFacturas IS
      SELECT DISTINCT DA.ID_PROVEEDOR,
                      DA.TIPO_DOCUMENTO,
                      DA.CONCEPTO,
                      DA.DEBE,
                      DA.HABER,
                      SUBSTR(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''), INSTR(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''), '-', 1, 2) + 1, LENGTH(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''))) NUMERO_DOCUMENTO,
                      AC.CODIGO_ASIENTO,
                      UPPER(SUBSTR(LPAD(DA.NUMERO_DOCUMENTO, 9, '0'), 1, 1)) NUM_ERR,
                      LPAD(SUBSTR(REPLACE(DA.CONCEPTO, ' ', ''), INSTR(REPLACE(DA.CONCEPTO, ' ', ''), 'FC', 1, 1) + 2, LENGTH(REPLACE(DA.CONCEPTO, ' ', ''))), 8, '0') NUMERO_DOCUMENTO2,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      AC.TOTAL_DEBITOS,
                      AC.TOTAL_CREDITOS,
                      AC.TIPO_ASIENTO
        FROM CG_M_DETALLE_ASIENTO  DA,
             CG_M_ASIENTO_CONTABLE AC
       WHERE DA.TIPO_ASIENTO = AC.TIPO_ASIENTO
         AND DA.ID_ASIENTO = AC.ID_ASIENTO
         AND DA.COMPANIA = Pv_IdEmpresa
         AND DA.TIPO_DOCUMENTO IN ('FC', 'PV', 'FP')
         AND AC.CODIGO_ASIENTO = '25'
         AND TRUNC(AC.FECHA) >= Pv_FechaDesde
         AND TRUNC(AC.FECHA) <= Pv_FechaHasta
            --AND DA.ID_PROVEEDOR = '3703'
         AND DA.ID_PROVEEDOR IS NOT NULL
         AND NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%');
    --AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'));
  
    CURSOR C_LeeDetalleCont(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdAsiento IN VARCHAR2,
                            Cv_Concepto  IN VARCHAR2) IS
      SELECT DISTINCT DA.ID_PROVEEDOR,
                      DA.TIPO_DOCUMENTO,
                      DA.CONCEPTO,
                      DA.HABER, -- MONTO,
                      DA.DEBE, -- MONTO2,
                      SUBSTR(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''), INSTR(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''), '-', 1, 2) + 1, LENGTH(REPLACE(DA.NUMERO_DOCUMENTO, ' ', ''))) NUMERO_DOCUMENTO, --LPAD(DA.NUMERO_DOCUMENTO, 10, '0') NUMERO_DOCUMENTO,
                      AC.CODIGO_ASIENTO,
                      UPPER(SUBSTR(LPAD(DA.NUMERO_DOCUMENTO, 9, '0'), 1, 1)) NUM_ERR,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      DA.LINEA,
                      DA.ID_CUENTA_CONTABLE,
                      DA.ID_CENTRO_COSTO,
                      DA.ITEGAS
        FROM CG_M_DETALLE_ASIENTO  DA,
             CG_M_ASIENTO_CONTABLE AC
       WHERE DA.TIPO_ASIENTO = AC.TIPO_ASIENTO
         AND DA.ID_ASIENTO = AC.ID_ASIENTO
         AND DA.COMPANIA = Pv_IdEmpresa
         AND AC.CODIGO_ASIENTO = '25'
         AND TRUNC(AC.FECHA) >= Pv_FechaDesde
         AND TRUNC(AC.FECHA) <= Pv_FechaHasta
         AND NOT UPPER(DA.CONCEPTO) LIKE ('%NC#%')
            --AND NOT UPPER(DA.CONCEPTO) LIKE (UPPER('%Cerrar%'))
         AND AC.ID_ASIENTO = Cv_IdAsiento
         AND DA.ITEGAS IS NULL
         AND NVL(DA.ID_PROVEEDOR, 'X') <> '9999'
         AND REPLACE(DA.CONCEPTO, ' ', '') LIKE ('%' || REPLACE(Cv_Concepto, ' ', '') || '%');
  
    --
    CURSOR C_LeeInfoFactura(Cv_IdEmpresa   IN VARCHAR2, --
                            Cv_IdAsiento   IN VARCHAR2, --
                            Cv_IdFactura   IN VARCHAR2,
                            Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             --DC.CODSUS,--
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             SUM(DC.BASSINRET) BASSINRET,
             SUM(DC.MONIVABIE) MONIVABIE,
             SUM(DC.NUMREN) NUMREN,
             SUM(DC.BASIMPICE) BASIMPICE,
             SUM(DC.MONICE) MONICE,
             SUM(DC.BASENOGRAIVA) BASENOGRAIVA,
             SUM(DC.MONRETIVASER100) MONRETIVASER100,
             SUM(DC.MONRETIVASER) MONRETIVASER,
             SUM(DC.MONRETIVABIE) MONRETIVABIE,
             SUM(DC.MONIVASER) MONIVASER,
             SUM(DC.MONIVA) MONIVA,
             SUM(DC.BASIMPIVA) BASIMPIVA,
             SUM(DC.BASIMPCER) BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND DC.NUMSECCOM LIKE ('%' || Cv_IdFactura || '%') --TO_NUMBER(Cv_IdFactura)
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa
       GROUP BY DC.CODIVASER100, --
                DC.FECCADCOM, --
                DC.FECEMICOM, --
                DC.FECREGCON, --
                DC.FECACTREG, --
                DC.FECCREREG, --
                DC.FECEMICMO, --
                DC.SINRET, --
                DC.TRADEV, --
                DC.CODIVABIE, --
                DC.CODIVASER, --
                DC.CODPORIVA, --
                DC.NUMAUTCOM, --
                DC.NUMAUTCMO, --
                DC.IDEPRO, --
                DC.NUMDOC, --
                DC.CODEMP, --
                DC.TIPCOM, --
                --DC.CODSUS,--
                DC.TIPCOMMNC, --
                DC.CODPORICE, --
                DC.CODCOM, --
                DC.NUMSECCOM, --
                DC.CODPRO, --
                DC.NUMSEREST, --
                DC.NUMSERCMOPTE, --
                DC.NUMSERCMOEST, --
                DC.NUMSERPTE, --
                DC.REGCREPOR, --
                DC.REGACTPOR, --
                DC.CODSINRET, --
                DC.NUMSECCMO;
    ---
    CURSOR C_LeeTotalRetenciones(CvIdEmpresa      IN VARCHAR2,
                                 Cv_IdAsiento     IN VARCHAR2,
                                 Cv_NumeroFactura IN VARCHAR2,
                                 Cv_IdProveedor   IN VARCHAR2) IS
      SELECT NVL(SUM(TOTRET), 0)
        FROM CG_M_DETALLE_RETENCIONES DR
       WHERE DR.DESFAC = Cv_NumeroFactura
         AND DR.CODPRO = Cv_IdProveedor
         AND DR.NUMDOC = Cv_IdAsiento
         AND DR.CODEMP = CvIdEmpresa;
    ---
    CURSOR C_LeeImpuestos(Cv_IdEmpresa   IN VARCHAR2,
                          Cv_IdAsiento   IN VARCHAR2,
                          Cv_IdProveedor IN VARCHAR2,
                          Cv_IdFactura   IN VARCHAR2,
                          Cv_IdFactura2  IN VARCHAR2) IS
      SELECT *
        FROM (SELECT B.NUMAUTFAC,
                     B.SERFAC,
                     SUM(NVL(BASRET, 0)) BASRET,
                     SUM(NVL(TOTRET, 0)) TOTRET,
                     SUM(NVL(PORRET, 0)) PORRET,
                     A.CONRETFUEAIR CODIGO_SRI
                FROM CG_M_DETALLE_RENTA_SRI   A,
                     CG_M_DETALLE_RETENCIONES B
               WHERE A.CODREN = B.CODREN
                 AND A.CODEMP = B.CODEMP
                 AND A.NUMDOC = B.NUMDOC
                 AND B.NUMDOC = Cv_IdAsiento
                 AND (B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura) || '%') OR B.DESFAC LIKE ('%' || TO_NUMBER(Cv_IdFactura2) || '%'))
                 AND B.CODPRO = Cv_IdProveedor --'4608'
                 AND A.CODEMP = Cv_IdEmpresa
               GROUP BY B.NUMAUTFAC,
                        B.SERFAC,
                        A.CONRETFUEAIR)
       WHERE CODIGO_SRI IS NOT NULL;
    --
  
    --
    CURSOR C_CodigosSRI(Cv_IdEmpresa   IN VARCHAR2,
                        Cn_CodigoReten IN VARCHAR2) IS
      SELECT IMP.*
        FROM ARCGIMP IMP
       WHERE IMP.SRI_RETIMP_RENTA = Cn_CodigoReten
         AND IMP.NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_DetalleSustentos(Cv_IdEmpresa   IN VARCHAR2, --
                              Cv_IdAsiento   IN VARCHAR2, --
                              Cv_IdFactura   IN VARCHAR2,
                              Cv_IdProveedor IN VARCHAR2) IS
    
      SELECT DC.CODSUS,
             DC.CODIVASER100, --
             DC.FECCADCOM, --
             DC.FECEMICOM, --
             DC.FECREGCON, --
             DC.FECACTREG,
             DC.FECCREREG,
             DC.FECEMICMO,
             DC.SINRET,
             DC.TRADEV,
             DC.CODIVABIE,
             DC.CODIVASER,
             DC.CODPORIVA,
             DC.NUMAUTCOM,
             DC.NUMAUTCMO,
             DC.IDEPRO,
             DC.NUMDOC,
             DC.CODEMP,
             DC.TIPCOM,
             DC.TIPCOMMNC,
             DC.CODPORICE,
             DC.CODCOM,
             DC.NUMSECCOM,
             DC.CODPRO,
             DC.NUMSEREST,
             DC.NUMSERCMOPTE,
             DC.NUMSERCMOEST,
             DC.NUMSERPTE,
             DC.REGCREPOR,
             DC.REGACTPOR,
             DC.CODSINRET,
             DC.NUMSECCMO,
             BASSINRET,
             MONIVABIE,
             NUMREN,
             BASIMPICE,
             MONICE,
             BASENOGRAIVA,
             MONRETIVASER100,
             MONRETIVASER,
             MONRETIVABIE,
             MONIVASER,
             MONIVA,
             BASIMPIVA,
             BASIMPCER
        FROM CG_M_DETALLE_COMPROBANTES DC
       WHERE DC.Numdoc = Cv_IdAsiento
         AND TO_NUMBER(DC.NUMSECCOM) = TO_NUMBER(Cv_IdFactura)
         AND DC.CODPRO = Cv_IdProveedor
         AND DC.CODEMP = Cv_IdEmpresa;
    --
    CURSOR C_LeeAplicacionImp(Cv_IdSustento IN VARCHAR2) IS
      SELECT APLICA_C_TRIBUTARIO
        FROM SRI_SUSTENTO_COMPROBANTE
       WHERE CODIGO = Cv_IdSustento;
    --
    CURSOR C_LeeNoAsiento(Cv_Idempresa   IN VARCHAR2,
                          Cv_Descripcion IN VARCHAR2) IS
      SELECT NO_ASIENTO
        FROM ARCGAE
       WHERE NO_CIA = Cv_Idempresa
         AND REPLACE(Descri1, ' ', '') = REPLACE(Cv_Descripcion, ' ', '');
    --
    CURSOR C_LeeDistCont(Cv_IdEmpresa       IN VARCHAR2,
                         Cv_IdDocumento     IN VARCHAR2,
                         Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT NVL(SUM(DECODE(TIPO, 'D', MONTO, 0)), 0) DEBITO,
             NVL(SUM(DECODE(TIPO, 'C', 0, MONTO)), 0) CREDITO
        FROM ARCPDC
       WHERE NO_DOCU = Cv_IdDocumento
         AND TIPO_DOC = Cv_IdTipoDocumento
         AND NO_CIA = Cv_IdEmpresa;
  
    Lr_Documentos     ARCPMD%ROWTYPE := NULL;
    Lr_Totales        ARCPMD%ROWTYPE := NULL;
    Lr_MovimientoFact CG_M_DETALLE_ASIENTO%ROWTYPE := NULL;
    Lr_DetalleCont    ARCPDC%ROWTYPE := NULL;
    Lv_NoDocu         ARCPMD.NO_DOCU%TYPE := NULL;
    Lr_DetFactura     C_LeeInfoFactura%ROWTYPE := NULL;
    Lr_Retenciones    ARCPTI%ROWTYPE := NULL;
    Le_Error EXCEPTION;
    Lb_GenAsientoCont  BOOLEAN := FALSE;
    Lr_CabAsiento      ARCGAE%ROWTYPE := NULL;
    Lr_DetAsiento      ARCGAL%ROWTYPE := NULL;
    Lv_NumeroFact      VARCHAR2(20) := NULL;
    Lr_RegSRI          C_CodigosSRI%ROWTYPE := NULL;
    Lr_DetTributoIva   CP_DETALLE_TRIBUTO_IVA%ROWTYPE := NULL;
    Lv_AplicaCreditTri VARCHAR2(2) := NULL;
    Ln_SecuenciaSust   NUMBER(10) := 0;
  BEGIN
    FOR Lr_MigrAsiento IN C_LeeFacturas LOOP
      IF UPPER(Lr_MigrAsiento.NUMERO_DOCUMENTO) LIKE ('%PROV%') THEN
        --Genera asiento contable directamente
        Lb_GenAsientoCont := TRUE;
      ELSE
        Lb_GenAsientoCont := FALSE;
      END IF;
      --
      IF Lb_GenAsientoCont THEN
        --envia a contabilidad
        Lr_CabAsiento := NULL;
        --
        Lr_CabAsiento.NO_CIA     := Pv_IdEmpresa; --Lr_MigrAsiento.Compania;
        Lr_CabAsiento.FECHA      := Lr_MigrAsiento.FECHA;
        Lr_CabAsiento.DESCRI1    := SUBSTR(Lr_MigrAsiento.CONCEPTO || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 240);
        Lr_CabAsiento.T_DEBITOS  := Lr_MigrAsiento.TOTAL_DEBITOS;
        Lr_CabAsiento.T_CREDITOS := Lr_MigrAsiento.TOTAL_CREDITOS;
        Lr_CabAsiento.COD_DIARIO := Lr_MigrAsiento.Codigo_Asiento;
        --Lr_CabAsiento.Tipo_Comprobante :=Lr_MigrAsiento.TIPO_ASIENTO;
      
        CGK_MIGRACION_MEGA.CGP_INSERTA_ASIENTO(Lr_CabAsiento, --
                                               Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --Detalle de asientos
        Lr_DetAsiento := NULL;
        FOR Lr_MigraDetalle IN C_LeeDetalleCont(Pv_IdEmpresa, --
                                                Lr_MigrAsiento.ID_ASIENTO,
                                                Lr_MigrAsiento.Numero_Documento
                                                /*Lr_MigrAsiento.CONCEPTO*/) LOOP
        
          IF C_LeeNoAsiento%ISOPEN THEN
            CLOSE C_LeeNoAsiento;
          END IF;
          OPEN C_LeeNoAsiento(Pv_IdEmpresa, --
                              SUBSTR(Lr_MigrAsiento.Concepto || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 240));
        
          FETCH C_LeeNoAsiento
            INTO Lr_CabAsiento.No_Asiento;
          CLOSE C_LeeNoAsiento;
        
          Lr_DetAsiento.NO_CIA     := Lr_CabAsiento.No_Cia;
          Lr_DetAsiento.ANO        := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.FECHA, 'yyyy'));
          Lr_DetAsiento.MES        := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.FECHA, 'mm'));
          Lr_DetAsiento.no_asiento := Lr_CabAsiento.No_Asiento;
        
          --Lr_DetAsiento.NO_ASIENTO := Lr_CabAsiento.No_Asiento;
          Lr_DetAsiento.DESCRI     := SUBSTR(Lr_MigraDetalle.CONCEPTO || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 100);
          Lr_DetAsiento.COD_DIARIO := Lr_MigrAsiento.Codigo_Asiento; --Lr_MigraDetalle.Tipo_Asiento;
          Lr_DetAsiento.Cuenta     := Lr_MigraDetalle.Id_Cuenta_Contable;
          IF Lr_MigraDetalle.Itegas = '195001' THEN
            --GYE
            Lr_DetAsiento.Centro_Costo := '001001001';
          ELSIF Lr_MigraDetalle.Itegas = '195000' THEN
            --UIO
            Lr_DetAsiento.Centro_Costo := '001001002';
          ELSE
            IF SUBSTR(Lr_MigraDetalle.Id_Cuenta_Contable, 1, 1) NOT IN ('5', '6', '2') THEN
              Lr_DetAsiento.Centro_Costo := '000000000';
            ELSIF SUBSTR(Lr_MigraDetalle.Id_Cuenta_Contable, 1, 1) IN ('2') THEN
              Lr_DetAsiento.Centro_Costo := '000000000';
            ELSE
              Lr_DetAsiento.Centro_Costo := '001001002';
            END IF;
            Lr_DetAsiento.Codigo_Tercero := SUBSTR(Lr_MigraDetalle.Itegas, 1, 18);
          END IF;
          -- Lr_DetAsiento.CENTRO_COSTO := REPLACE(Lr_MigraDetalle.Id_Centro_Costo, '-', '');
          Lr_DetAsiento.Codigo_Tercero := SUBSTR(Lr_DetAsiento.Codigo_Tercero || ' ' || Lr_MigrAsiento.Codigo_Asiento || ' - ' || Lr_MigrAsiento.Id_Asiento, 1, 18);
          Lr_DetAsiento.CC_1           := SUBSTR(Lr_DetAsiento.Centro_Costo, 1, 3);
          Lr_DetAsiento.CC_2           := SUBSTR(Lr_DetAsiento.Centro_Costo, 4, 3);
          Lr_DetAsiento.CC_3           := SUBSTR(Lr_DetAsiento.Centro_Costo, 7, 3);
        
          IF Lr_MigraDetalle.Debe > 0 THEN
            Lr_DetAsiento.tipo      := 'D';
            Lr_DetAsiento.monto     := Lr_MigraDetalle.Debe;
            Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Debe;
          ELSIF Lr_MigraDetalle.Haber > 0 THEN
            Lr_DetAsiento.tipo      := 'C';
            Lr_DetAsiento.monto     := Lr_MigraDetalle.Haber * -1;
            Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Haber * -1;
          END IF;
          CGK_MIGRACION_MEGA.CGP_INSERTA_DETALLE(Lr_DetAsiento, --
                                                 Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            Pv_MensajeError := 'cuenta ' || Lr_MigraDetalle.Id_Cuenta_Contable;
            RAISE Le_Error;
          END IF;
        END LOOP;
        Lb_GenAsientoCont := TRUE;
      ELSE
        --INSERTA FACTURAS
        --
        --
        Lv_NumeroFact := NULL;
        --Lv_NumeroFactDet := NULL;
        /*      IF Lr_Migra.NUM_ERR <> '0' THEN
          Lv_NumeroFact := Lr_Migra.NUMERO_DOCUMENTO2;
        ELSE
          Lv_NumeroFact := Lr_Migra.NUMERO_DOCUMENTO;
        END IF;*/
      
        BEGIN
          --Lv_NumeroFactDet := TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO);
          Lv_NumeroFact := TO_NUMBER(Lr_MigrAsiento.NUMERO_DOCUMENTO);
        EXCEPTION
          WHEN value_error THEN
            --Lv_NumeroFactDet := TO_NUMBER(Lr_Migra.NUMERO_DOCUMENTO2);
            Lv_NumeroFact := TO_NUMBER(Lr_MigrAsiento.NUMERO_DOCUMENTO2);
            DBMS_OUTPUT.put_line('Error de Numero Factura 25' || Lv_NumeroFact || ', Asiento ' || Lr_MigrAsiento.Id_Asiento);
          WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Error de Numero Factura 25 ' || Lv_NumeroFact || ', Asiento ' || Lr_MigrAsiento.Id_Asiento);
            Lv_NumeroFact := TO_NUMBER(Lr_MigrAsiento.NUMERO_DOCUMENTO2);
            --Lv_NumeroFact :=LPAD(SUBSTR(REPLACE(Lr_MigrAsiento.CONCEPTO, ' ', ''), INSTR(REPLACE(Lr_MigrAsiento.CONCEPTO, ' ', ''), 'FC', 1, 1) + 2, LENGTH(REPLACE(Lr_MigrAsiento.CONCEPTO, ' ', ''))), 12, '0');
        END;
        --
        Lr_DetFactura := NULL;
        IF C_LeeInfoFactura%ISOPEN THEN
          CLOSE C_LeeInfoFactura;
        END IF;
        OPEN C_LeeInfoFactura(Pv_IdEmpresa, --
                              Lr_MigrAsiento.Id_Asiento,
                              Lv_NumeroFact,
                              Lr_MigrAsiento.Id_Proveedor);
        FETCH C_LeeInfoFactura
          INTO Lr_DetFactura;
        CLOSE C_LeeInfoFactura;
        --
        IF C_LeeTotalRetenciones%ISOPEN THEN
          CLOSE C_LeeTotalRetenciones;
        END IF;
        OPEN C_LeeTotalRetenciones(Pv_IdEmpresa, --
                                   Lr_MigrAsiento.ID_ASIENTO,
                                   Lr_DetFactura.Numseccom,
                                   Lr_DetFactura.Codpro);
        FETCH C_LeeTotalRetenciones
          INTO Lr_Totales.TOT_RET;
        CLOSE C_LeeTotalRetenciones;
        --
        Lr_Documentos.GRAVADO  := NVL(Lr_DetFactura.BASIMPIVA, 0);
        Lr_Documentos.EXCENTOS := NVL(Lr_DetFactura.BASIMPCER, 0);
        Lr_Documentos.TOT_IMP  := round(Lr_DetFactura.MONIVA, 2);
        --BASIMPCER,BASEIMPIVA
        /*Lr_Totales.SUBTOTAL*/
        Lr_Documentos.Subtotal := ROUND(NVL(Lr_DetFactura.BASIMPIVA, 0) + NVL(Lr_DetFactura.BASIMPCER, 0), 2);
        /*Lr_Totales.Monto*/
        -- Lr_Documentos.Monto := Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/
        --                        +NVL(Lr_DetFactura.BASIMPIVA, 0) - NVL(Lr_Totales.TOT_RET, 0);
        --
        --Lr_Documentos.Monto    := Lr_Totales.Monto;
        --Lr_Documentos.Subtotal := Lr_Documentos.Subtotal;--Lr_Totales.SUBTOTAL;
      
        IF NVL(Lr_DetFactura.Basimpiva, 0) > 0 THEN
          Lr_Documentos.TIPO_COMPRA     := 'B';
          Lr_Documentos.TIPO_DOC        := 'FB';
          Lr_Documentos.CODIGO_SUSTENTO := '01';
          Lr_Documentos.Monto_Bienes    := Lr_Documentos.GRAVADO;
        ELSIF NVL(Lr_DetFactura.MONIVASER, 0) > 0 THEN
          Lr_Documentos.TIPO_COMPRA     := 'S';
          Lr_Documentos.TIPO_DOC        := 'FV';
          Lr_Documentos.Monto_Serv      := Lr_Documentos.GRAVADO;
          Lr_Documentos.CODIGO_SUSTENTO := '02';
        ELSIF NVL(Lr_DetFactura.Basimpcer, 0) > 0 THEN
          Lr_Documentos.TIPO_COMPRA     := 'S';
          Lr_Documentos.TIPO_DOC        := 'FV';
          Lr_Documentos.Monto_Serv      := Lr_Documentos.GRAVADO;
          Lr_Documentos.CODIGO_SUSTENTO := '02';
        
        ELSE
          Lr_Documentos.TIPO_COMPRA := 'V';
        END IF;
        /*IF NVL(Lr_DetFactura.BASIMPIVA, 0) > 0 THEN
          Lr_Documentos.CODIGO_SUSTENTO := '01';
        ELSE
          Lr_Documentos.CODIGO_SUSTENTO := '02';
        END IF;*/
        --
      
        --
        Lr_Documentos.TOT_RET     := Lr_Totales.TOT_RET;
        Lr_Documentos.NO_CIA      := Pv_IdEmpresa;
        Lr_Documentos.NO_PROVE    := Lr_MigrAsiento.ID_PROVEEDOR;
        Lr_Documentos.IND_ACT     := 'P';
        Lr_Documentos.NO_FISICO   := Lv_NumeroFact;
        Lr_Documentos.IND_OTROMOV := 'N';
        Lr_Documentos.FECHA       := Lr_MigrAsiento.FECHA;
        Lr_Documentos.SALDO       := (Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/
                                      +NVL(Lr_Documentos.TOT_IMP, 0) /*NVL(Lr_Totales.TOT_IMP, 0)*/
                                      -NVL(Lr_Totales.TOT_RET, 0));
        --Lr_Documentos.TOT_DB      := NVL(Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/, 0) + NVL(Lr_Documentos.TOT_IMP /*Lr_Totales.TOT_IMP*/, 0);
        --Lr_Documentos.TOT_CR      := NVL(Lr_Documentos.Subtotal /*Lr_Totales.SUBTOTAL*/, 0) + NVL(Lr_Documentos.TOT_IMP /*Lr_Totales.TOT_IMP*/, 0);
        --
        Lr_Documentos.FECHA_VENCE   := Lr_MigrAsiento.FECHA + 360;
        Lr_Documentos.BLOQUEADO     := 'N';
        Lr_Documentos.MONEDA        := 'P';
        Lr_Documentos.TIPO_CAMBIO   := 1;
        Lr_Documentos.MONTO_NOMINAL := Lr_Documentos.Monto; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
        Lr_Documentos.SALDO_NOMINAL := Lr_Documentos.SALDO; --NVL(Lr_Totales.SUBTOTAL, 0) + NVL(Lr_Totales.TOT_IMP, 0) - NVL(Lr_Totales.TOT_RET, 0);
        --
        Lr_Documentos.T_CAMB_C_V           := 'V';
        Lr_Documentos.DETALLE              := SUBSTR(Lr_MigrAsiento.CONCEPTO, 1, 100);
        Lr_Documentos.IND_OTROS_MESES      := 'N';
        Lr_Documentos.FECHA_DOCUMENTO      := Lr_MigrAsiento.Fecha;
        Lr_Documentos.FECHA_VENCE_ORIGINAL := Lr_MigrAsiento.Fecha;
        Lr_Documentos.ORIGEN               := 'CP';
        Lr_Documentos.ANULADO              := 'N';
        Lr_Documentos.IND_ESTADO_VENCIDO   := 'N';
        Lr_Documentos.TOT_IMP_ESPECIAL     := 0;
        Lr_Documentos.COD_DIARIO           := '08'; --CONFIRMAR;
        Lr_Documentos.TOT_RET_ESPECIAL     := 0;
      
        Lr_Documentos.DERECHO_DEVOLUCION_IVA := 'N';
        Lr_Documentos.FECHA_CADUCIDAD        := Lr_DetFactura.FECCADCOM; --Lr_Migra.Fecha + 360;
        Lr_Documentos.USUARIO                := USER;
        Lr_Documentos.FACTURA_EVENTUAL       := 'N';
        Lr_Documentos.TIPO_RET               := 'R2'; --REVISAR
        Lr_Documentos.NO_AUTORIZACION        := Lr_DetFactura.NUMAUTCOM;
        Lr_Documentos.SERIE_FISICO           := Lr_DetFactura.NUMSEREST || Lr_DetFactura.NUMSERPTE;
        Lr_Documentos.DESC_C                 := 0;
        Lr_Documentos.DESC_P                 := 0;
        Lr_Documentos.PLAZO_C                := 0;
        Lr_Documentos.PLAZO_P                := 0;
        Lr_Documentos.Monto                  := Lr_Documentos.SUBTOTAL + round(Lr_Documentos.TOT_IMP, 2) - Lr_Documentos.TOT_RET;
        Lv_NoDocu                            := transa_id.cp(Pv_IdEmpresa); ---Se genera la secuencia del documento
        BEGIN
          INSERT INTO ARCPMD
            (NO_CIA,
             NO_PROVE,
             TIPO_DOC,
             NO_DOCU,
             IND_ACT,
             NO_FISICO,
             IND_OTROMOV,
             FECHA,
             SUBTOTAL, ---
             SALDO, --
             GRAVADO, --
             EXCENTOS, --
             TOT_DB, --
             TOT_CR, --
             FECHA_VENCE,
             BLOQUEADO, --
             MONEDA, --
             TIPO_CAMBIO, --
             MONTO_NOMINAL,
             SALDO_NOMINAL,
             TIPO_COMPRA,
             T_CAMB_C_V, --
             DETALLE, --
             IND_OTROS_MESES, --
             FECHA_DOCUMENTO, --
             FECHA_VENCE_ORIGINAL, --
             ORIGEN, --
             ANULADO, --
             IND_ESTADO_VENCIDO, --
             TOT_IMP, --
             TOT_RET, --
             TOT_IMP_ESPECIAL, --
             COD_DIARIO, --
             TOT_RET_ESPECIAL, --
             CODIGO_SUSTENTO, --
             DERECHO_DEVOLUCION_IVA, --
             FECHA_CADUCIDAD, --
             USUARIO, --
             FACTURA_EVENTUAL, --
             TIPO_RET, --
             TARJETA_CORP,
             NO_AUTORIZACION,
             SERIE_FISICO,
             MONTO,
             DESC_C,
             DESC_P,
             PLAZO_C,
             PLAZO_P)
          VALUES
            (Pv_IdEmpresa, --
             Lr_MigrAsiento.ID_PROVEEDOR,
             Lr_Documentos.TIPO_DOC, --FACTURAS DE COSTOS
             Lv_NoDocu,
             'P', --estado
             LPAD(Lr_Documentos.No_Fisico, 9, '0'), --NO_FISICO
             'N', --IND_OTROMOV
             Lr_MigrAsiento. FECHA,
             Lr_Documentos.SUBTOTAL,
             Lr_Documentos.SALDO,
             Lr_Documentos.GRAVADO,
             Lr_Documentos.EXCENTOS,
             Lr_Documentos.TOT_CR,
             Lr_Documentos.TOT_DB,
             Lr_Documentos.FECHA_VENCE,
             Lr_Documentos.BLOQUEADO,
             Lr_Documentos.MONEDA,
             Lr_Documentos.TIPO_CAMBIO,
             Lr_Documentos.MONTO_NOMINAL,
             Lr_Documentos.SALDO_NOMINAL,
             Lr_Documentos.TIPO_COMPRA,
             Lr_Documentos.T_CAMB_C_V,
             SUBSTR(Lr_MigrAsiento.CONCEPTO, 1, 100),
             Lr_Documentos.IND_OTROS_MESES,
             Lr_Documentos.FECHA_DOCUMENTO,
             Lr_Documentos.FECHA_VENCE_ORIGINAL,
             Lr_Documentos.ORIGEN,
             Lr_Documentos.ANULADO,
             Lr_Documentos.IND_ESTADO_VENCIDO,
             Lr_Documentos.TOT_IMP,
             Lr_Documentos.TOT_RET,
             Lr_Documentos.TOT_IMP_ESPECIAL,
             Lr_Documentos.COD_DIARIO,
             Lr_Documentos.TOT_RET_ESPECIAL,
             Lr_Documentos.CODIGO_SUSTENTO,
             Lr_Documentos.DERECHO_DEVOLUCION_IVA,
             Lr_Documentos.FECHA_CADUCIDAD,
             Lr_Documentos.USUARIO,
             Lr_Documentos.FACTURA_EVENTUAL,
             Lr_Documentos.TIPO_RET,
             Lr_Documentos.TARJETA_CORP,
             Lr_Documentos.NO_AUTORIZACION,
             Lr_Documentos.SERIE_FISICO,
             Lr_Documentos.Monto,
             Lr_Documentos.DESC_C,
             Lr_Documentos.DESC_P,
             Lr_Documentos.PLAZO_C,
             Lr_Documentos.PLAZO_P);
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Error' || SQLCODE || ' ' || SQLERRM || ' ' || Lr_Documentos.NO_FISICO);
        END;
        --
        --Distribucion contable
        FOR Lr_DetCont IN C_LeeDetalleCont(Pv_IdEmpresa, --
                                           Lr_MigrAsiento.ID_ASIENTO,
                                           Lr_MigrAsiento.Numero_Documento
                                           --Lr_MigrAsiento.Concepto
                                           /*Lr_Migra.NUMERO_DOCUMENTO3*/) LOOP
          Lr_DetalleCont.NO_CIA   := Pv_IdEmpresa;
          Lr_DetalleCont.NO_PROVE := Lr_MigrAsiento.ID_PROVEEDOR;
          Lr_DetalleCont.TIPO_DOC := Lr_Documentos.TIPO_DOC;
          Lr_DetalleCont.NO_DOCU  := Lv_NoDocu;
          Lr_DetalleCont.CODIGO   := Lr_DetCont.ID_CUENTA_CONTABLE;
          IF Lr_DetCont.DEBE > 0 THEN
            Lr_DetalleCont.TIPO      := 'D';
            Lr_DetalleCont.MONTO     := ROUND(Lr_DetCont.DEBE, 2);
            Lr_DetalleCont.MONTO_DOL := ROUND(Lr_DetCont.DEBE, 2);
            Lr_DetalleCont.MONTO_DC  := ROUND(Lr_DetCont.DEBE, 2);
          ELSIF Lr_DetCont.HABER > 0 THEN
            Lr_DetalleCont.TIPO      := 'C';
            Lr_DetalleCont.MONTO     := ROUND(Lr_DetCont.HABER, 2);
            Lr_DetalleCont.MONTO_DOL := ROUND(Lr_DetCont.HABER, 2);
            Lr_DetalleCont.MONTO_DC  := ROUND(Lr_DetCont.HABER, 2);
          
          END IF;
        
          --Lr_DetalleCont.MONTO              := Lr_DetCont.;
          Lr_DetalleCont.MES     := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.FECHA, 'MM'));
          Lr_DetalleCont.ANO     := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.FECHA, 'YYYY'));
          Lr_DetalleCont.IND_CON := 'P';
        
          Lr_DetalleCont.MONEDA         := 'P';
          Lr_DetalleCont.TIPO_CAMBIO    := 1;
          Lr_DetalleCont.NO_ASIENTO     := NULL;
          Lr_DetalleCont.CENTRO_COSTO   := '000000000';
          Lr_DetalleCont.MODIFICABLE    := 'N';
          Lr_DetalleCont.CODIGO_TERCERO := NULL;
        
          
          
          --JXZURITA-AUMENTO CAMPO GLOSA INICIO
          --Lr_DetalleCont.GLOSA              := SUBSTR(Lr_DetCont.Concepto || ' -MIGRA HIPERK ' || Lr_DetCont.Id_Asiento || ' ' || Lr_DetCont.Codigo_Asiento, 1, 100);
          Lr_DetalleCont.GLOSA              := SUBSTR(Lr_DetCont.Concepto || ' -MIGRA HIPERK ' || Lr_DetCont.Id_Asiento || ' ' || Lr_DetCont.Codigo_Asiento, 1, F_TAM_GLOSA_CONT(Lr_DetalleCont.no_cia,'AG_CGKMIGRACIONMEGA',100));
          --JXZURITA-AUMENTO CAMPO GLOSA FIN
          Lr_DetalleCont.EXCEDE_PRESUPUESTO := NULL;
          --
          CGK_MIGRACION_MEGA.CGP_INSERTA_MOVIMIENTO(Lr_DetalleCont, --
                                                    Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          Lr_MovimientoFact := NULL;
        END LOOP;
      
        IF C_LeeDistCont%ISOPEN THEN
          CLOSE C_LeeDistCont;
        END IF;
        OPEN C_LeeDistCont(Pv_IdEmpresa, Lv_NoDocu, Lr_Documentos.TIPO_DOC);
        FETCH C_LeeDistCont
          INTO Lr_Documentos.TOT_DB,
               Lr_Documentos.TOT_CR;
        CLOSE C_LeeDistCont;
        --
        UPDATE ARCPMD FA
           SET FA.TOT_DB = Lr_Documentos.TOT_DB,
               FA.TOT_CR = Lr_Documentos.TOT_CR
         WHERE FA.NO_DOCU = Lv_NoDocu
           AND FA.TIPO_DOC = Lr_Documentos.TIPO_DOC
           AND FA.NO_CIA = Pv_IdEmpresa;
        --Retenciones
        --inserta impuestos
        Lr_Retenciones := NULL;
        FOR Lr_Impuestos IN C_LeeImpuestos(Pv_IdEmpresa, --
                                           Lr_MigrAsiento.ID_ASIENTO,
                                           Lr_documentos.NO_PROVE,
                                           Lv_NumeroFact,
                                           Lv_NumeroFact
                                           --Lr_Migra.NUMERO_DOCUMENTO2,
                                           --Lr_Migra.NUMERO_DOCUMENTO
                                           ) LOOP
          --Lr_Retenciones.No_Cia
          Lr_RegSRI := NULL;
          IF C_CodigosSRI%ISOPEN THEN
            CLOSE C_CodigosSRI;
          END IF;
          OPEN C_CodigosSRI(Pv_IdEmpresa, Lr_Impuestos.Codigo_Sri); --Lr_Impuestos.CODREN);
          FETCH C_CodigosSRI
            INTO Lr_RegSRI;
          CLOSE C_CodigosSRI;
          Lr_Retenciones.NO_CIA   := Pv_IdEmpresa;
          Lr_Retenciones.NO_PROVE := Lr_Documentos.NO_PROVE;
          Lr_Retenciones.TIPO_DOC := Lr_Documentos.TIPO_DOC;
          Lr_Retenciones.NO_DOCU  := Lv_NoDocu;
          IF Lr_Impuestos.Porret NOT IN (30, 70, 100) THEN
            Lr_Retenciones.CLAVE            := Lr_RegSRI.Clave;
            Lr_Retenciones.SRI_RETIMP_RENTA := Lr_Impuestos.Codigo_Sri; --Lr_RegSRI.SRI_RETIMP_RENTA; --REVISAR
          ELSE
            IF Lr_Impuestos.PORRET = 30 THEN
              Lr_Retenciones.CLAVE            := 34;
              Lr_Retenciones.SRI_RETIMP_RENTA := '1';
            ELSIF Lr_Impuestos.PORRET = 70 THEN
              Lr_Retenciones.CLAVE            := 35;
              Lr_Retenciones.SRI_RETIMP_RENTA := '2';
            ELSIF Lr_Impuestos.PORRET = 100 THEN
              Lr_Retenciones.CLAVE            := 36;
              Lr_Retenciones.SRI_RETIMP_RENTA := '3';
            END IF;
          END IF;
          Lr_Retenciones.PORCENTAJE         := Lr_Impuestos.PORRET;
          Lr_Retenciones.MONTO              := Lr_Impuestos.TOTRET;
          Lr_Retenciones.IND_IMP_RET        := 'R';
          Lr_Retenciones.APLICA_CRED_FISCAL := 'N';
          Lr_Retenciones.BASE               := Lr_Impuestos.BASRET;
          Lr_Retenciones.COMPORTAMIENTO     := 'E';
          Lr_Retenciones.ID_SEC             := NULL;
          Lr_Retenciones.NO_REFE            := Lv_NoDocu;
          Lr_Retenciones.SECUENCIA_RET      := Lr_Impuestos.SERFAC;
          Lr_Retenciones.FECHA_IMPRIME      := NULL;
        
          Lr_Retenciones.SERVICIO_BIENES := NULL;
          Lr_Retenciones.AUTORIZACION    := Lr_Impuestos.NUMAUTFAC;
          Lr_Retenciones.FECHA_ANULA     := NULL;
          Lr_Retenciones.BASE_GRAVADA    := NULL;
          Lr_Retenciones.BASE_EXCENTA    := NULL;
          --DBMS_OUTPUT.put_line(Lr_Retenciones.NO_PROVE||' '||Lr_Retenciones.TIPO_DOC||' '||Lr_Retenciones.NO_DOCU||' '||Lr_Retenciones.CLAVE||' '||Lr_Retenciones.ID_SEC||' '||Lr_Retenciones.NO_CIA||' '||Lr_Retenciones.NO_REFE||' '||Lr_Retenciones.CODIGO_TERCERO||' '||Lr_Retenciones.SECUENCIA_RET||' '||Lr_Retenciones.SERVICIO_BIENES);
          CGK_MIGRACION_MEGA.CGP_INSERTA_IMPUESTO(Lr_Retenciones, Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            Pv_MensajeError := 'Error en CGP_INSERTA_RETENCIONES. ' || Pv_MensajeError || ' ' || Lr_MigrAsiento.ID_ASIENTO;
            RAISE Le_Error;
          END IF;
        
        END LOOP;
        --
        --INSERTAR IVA EN EL DETALLE DE IMPUESTOS
        Lr_Retenciones          := NULL;
        Lr_Retenciones.NO_CIA   := Pv_IdEmpresa;
        Lr_Retenciones.NO_PROVE := Lr_Documentos.NO_PROVE;
        Lr_Retenciones.TIPO_DOC := Lr_Documentos.TIPO_DOC;
        Lr_Retenciones.NO_DOCU  := Lv_NoDocu;
        Lr_Retenciones.CLAVE    := '00';
        --Lr_RegSRI.Clave;
        Lr_Retenciones.SRI_RETIMP_RENTA := NULL; --Lr_RegSRI.SRI_RETIMP_RENTA; --REVISAR
      
        Lr_Retenciones.PORCENTAJE         := 12;
        Lr_Retenciones.MONTO              := round(Lr_DetFactura.Moniva, 2);
        Lr_Retenciones.IND_IMP_RET        := 'I';
        Lr_Retenciones.APLICA_CRED_FISCAL := 'S';
        Lr_Retenciones.BASE               := round(Lr_DetFactura.Basimpiva, 2); --Lr_Impuestos.BASRET;
        Lr_Retenciones.COMPORTAMIENTO     := 'E';
        Lr_Retenciones.ID_SEC             := NULL;
        Lr_Retenciones.NO_REFE            := Lv_NoDocu;
        Lr_Retenciones.SECUENCIA_RET      := NULL; --Lr_Impuestos.SERFAC;
        Lr_Retenciones.FECHA_IMPRIME      := NULL;
      
        Lr_Retenciones.SERVICIO_BIENES := NULL;
        Lr_Retenciones.AUTORIZACION    := NULL;
        Lr_Retenciones.FECHA_ANULA     := NULL;
        Lr_Retenciones.BASE_GRAVADA    := NULL;
        Lr_Retenciones.BASE_EXCENTA    := NULL;
        --
        ---DBMS_OUTPUT.put_line(Lr_MigrAsiento.Numero_Documento || ' ' || Lr_MigrAsiento.Id_Asiento || ' ' || Lr_Retenciones.NO_PROVE || ' ' || Lr_Retenciones.TIPO_DOC || ' ' || Lr_Retenciones.NO_DOCU || ' ' || Lr_Retenciones.CLAVE || ' ' || Lr_Retenciones.ID_SEC || ' ' || Lr_Retenciones.NO_CIA || ' ' || Lr_Retenciones.NO_REFE || ' ' || Lr_Retenciones.CODIGO_TERCERO || ' ' || Lr_Retenciones.SECUENCIA_RET || ' ' || Lr_Retenciones.SERVICIO_BIENES);
        CGK_MIGRACION_MEGA.CGP_INSERTA_IMPUESTO(Lr_Retenciones, --
                                                Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := 'Error en CGP_INSERTA_IMPUESTO. ' || Pv_MensajeError || ' ' || Lr_MigrAsiento.ID_ASIENTO;
          RAISE Le_Error;
        END IF;
      
        --Detalle de sustentos 
        Ln_SecuenciaSust := 1;
        FOR Lr_DetSustento IN C_DetalleSustentos(Pv_IdEmpresa, Lr_MigrAsiento.ID_ASIENTO, Lv_NumeroFact, Lr_Documentos.NO_PROVE) LOOP
          --18582202
          Lr_DetTributoIva                   := NULL;
          Lr_DetTributoIva.ID_EMPRESa        := Pv_IdEmpresa;
          Lr_DetTributoIva.ID_TIPO_DOCUMENTO := Lr_Documentos.Tipo_Doc;
          Lr_DetTributoIva.ID_DOCUMENTO      := Lv_NoDocu;
          Lr_DetTributoIva.ID_SUSTENTO       := Lr_DetSustento.CODSUS;
          Lr_DetTributoIva.Secuencia         := Ln_SecuenciaSust;
          Lr_DetTributoIva.MONTO_BASE_IVA    := NVL(Lr_DetSustento.BASIMPIVA, 0);
          Lr_DetTributoIva.MONTO_BASE_CERO   := NVL(Lr_DetSustento.BASIMPCER, 0);
          Lr_DetTributoIva.MONTO_NETO        := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0);
          Lr_DetTributoIva.MONTO_IVA         := NVL(Lr_DetSustento.Moniva, 0);
          Lr_DetTributoIva.MONTO_TOTAL       := NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0) + NVL(Lr_DetSustento.Moniva, 0);
          IF (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0)) = 0 THEN
            Lr_DetTributoIva.PORCENTAJE := 0;
          ELSE
            Lr_DetTributoIva.PORCENTAJE := ((NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0)) * 100) / (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0));
          END IF;
          --Lr_DetTributoIva.PORCENTAJE        := ((NVL(Lr_DetSustento.BASIMPIVA, 0) + NVL(Lr_DetSustento.BASIMPCER, 0)) * 100) / (NVL(Lr_Documentos.GRAVADO, 1) + NVL(Lr_Documentos.EXCENTOS, 0));
          Lr_DetTributoIva.USUARIO_CREA := Lr_DetSustento.REGCREPOR;
          Lr_DetTributoIva.FECHA_CREA   := Lr_DetSustento.FECACTREG;
          Lv_AplicaCreditTri            := NULL;
          IF C_LeeAplicacionImp%ISOPEN THEN
            CLOSE C_LeeAplicacionImp;
          END IF;
          OPEN C_LeeAplicacionImp(Lr_DetSustento.CODSUS);
          FETCH C_LeeAplicacionImp
            INTO Lv_AplicaCreditTri;
          CLOSE C_LeeAplicacionImp;
        
          Lr_DetTributoIva.APLICA_CREDITO_IVA := Lv_AplicaCreditTri;
          --Lr_DetTributoIva.COMENTARIO         := 'MIGRACION HIPERK-NAF ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY') || ', ASIENTO # ' || Lr_MigrAsiento.ID_ASIENTO;
          Lr_DetTributoIva.COMENTARIO := 'MIGRACION HIPERK-NAF ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY') || ', ASIENTO # ' || Lr_MigrAsiento.ID_ASIENTO || '  ' || Lr_DetSustento.Codcom || ' ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro;
          IF NVL(Lr_DetSustento.MONIVA, 0) = 0 THEN
            Lr_DetTributoIva.PORCENTAJE_RETENCION := 0;
          ELSE
            Lr_DetTributoIva.PORCENTAJE_RETENCION := ((NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0)) * 100) / NVL(Lr_DetSustento.MONIVA, 1);
          END IF;
          IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) = 0 THEN
            Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'SE';
          END IF;
          IF NVL(Lr_DetSustento.MONRETIVASER, 0) = 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
            Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BI';
          END IF;
          IF NVL(Lr_DetSustento.MONRETIVASER, 0) > 0 AND NVL(Lr_DetSustento.MONRETIVABIE, 0) > 0 THEN
            Lr_DetTributoIva.ID_TIPO_TRANSACCION := 'BS';
          END IF;
        
          Lr_DetTributoIva.MONTO_BASE_RETENCION := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
          --IF Lr_DetSustento.Codporiva=2 THEN
          Lr_DetTributoIva.MONTO_IVA_RETENCION   := NVL(Lr_DetSustento.MONRETIVASER, 0) + NVL(Lr_DetSustento.MONRETIVABIE, 0);
          Lr_DetTributoIva.MONTO_TOTAL_RETENCION := Lr_DetTributoIva.MONTO_BASE_RETENCION + Lr_DetTributoIva.MONTO_IVA_RETENCION;
          --
          CGK_MIGRACION_MEGA.CGP_INSERTA_DET_IVA(Lr_DetTributoIva, Pv_MensajeError);
        
          IF Pv_MensajeError IS NOT NULL THEN
            Pv_MensajeError := Pv_MensajeError || ' fact. ' || Lr_DetSustento.Numseccom || ' ' || Lr_DetSustento.Codpro || ' comen:' || Lr_DetTributoIva.Comentario;
            RAISE Le_Error;
          END IF;
          Ln_SecuenciaSust := Ln_SecuenciaSust + 1;
          -- 
          UPDATE CG_M_ASIENTO_CONTABLE AC
             SET AC.MIGRADO = 'S'
           WHERE AC.Id_Asiento = Lr_MigrAsiento.Id_Asiento
             AND AC.COMPANIA = Pv_IdEmpresa;
          --
        END LOOP;
      
        --
        --END LOOP;
      END IF;
      --
      Lb_GenAsientoCont := FALSE;
      Lv_NoDocu         := NULL;
    END LOOP;
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_FACTURAS_25. ' || SQLCODE || ' ' || SQLERRM;
      ROLLBACK;
  END CGP_FACTURAS_25;

  --
  --Procedimiento que migra las liquidaciones de compras
  PROCEDURE CGP_FACTURAS_08(Pv_IdEmpresa    IN VARCHAR2,
                            Pv_FechaDesde   IN VARCHAR2,
                            Pv_FechaHasta   IN VARCHAR2,
                            Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeeFacturas IS
      SELECT D.*
        FROM ARCPMD D
       WHERE NO_CIA = '08'
         AND TRUNC(D.FECHA) >= Pv_FechaDesde
         AND TRUNC(D.FECHA) <= Pv_FechaHasta;
    --
    CURSOR C_LeeDocRelaCk(Cv_IdEmpresa   IN VARCHAR2,
                          Cv_TipoDocu    IN VARCHAR2,
                          Cv_IdDocumento IN VARCHAR2) IS
      SELECT *
        FROM ARCPMD
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_DOCU = Cv_IdDocumento
         AND TIPO_DOC = Cv_TipoDocu;
  
    --
    Lr_DocumentoRelac ARCPMD%ROWTYPE := NULL;
    --
    CURSOR C_LeeCodDiario(Cv_IdEmpresa    IN VARCHAR2,
                          Cv_CodigoDiario IN VARCHAR2) IS
      SELECT C.*
        FROM arcgcd C
       WHERE C.COD_DIARIO = Cv_CodigoDiario
         AND C.NO_CIA = Cv_IdEmpresa;
  
    Lr_Diarios arcgcd%ROWTYPE := NULL;
  
    CURSOR C_LeeDetalleContable(Cv_IdDocumento     IN VARCHAR2,
                                Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT DC.*
        FROM ARCPDC DC
       WHERE DC.NO_DOCU = Cv_IdDocumento
         AND DC.TIPO_DOC = Cv_IdTipoDocumento
         AND DC.NO_CIA = '08';
    --
    --
    CURSOR C_LeeRetenciones(Cv_IdDocumento     IN VARCHAR2,
                            Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT TI.*
        FROM ARCPTI TI
       WHERE TI.NO_DOCU = Cv_IdDocumento
         AND TI.TIPO_DOC = Cv_IdTipoDocumento
         AND TI.NO_CIA = '08';
    --
    CURSOR C_LeeArckce IS
      SELECT *
        FROM ARCKCE CH
       WHERE NO_CIA = '08'
         AND TRUNC(CH.FECHA) >= Pv_FechaDesde
         AND TRUNC(CH.FECHA) <= Pv_FechaHasta;
    --
    CURSOR C_LeeArckcl(Cn_NoDocumento   IN NUMBER,
                       Cv_TipoDocumento IN VARCHAR2) IS
      SELECT *
        FROM ARCKCL CL
       WHERE CL.NO_SECUENCIA = Cn_NoDocumento
         AND CL.TIPO_DOCU = Cv_TipoDocumento
         AND NO_CIA = '08';
  
    CURSOR C_LeeArckrd(Cn_NoDocumento   IN NUMBER,
                       Cv_TipoDocumento IN VARCHAR2) IS
      SELECT rd.*
        FROM arckrd rd
       WHERE RD.NO_SECUENCIA = Cn_NoDocumento
         AND RD.TIPO_DOCU = Cv_TipoDocumento
         AND NO_CIA = '08';
    --
    CURSOR C_LeeArckmm(Cv_TipoDocumento IN VARCHAR2, --
                       Cv_IdDocumento   IN VARCHAR2) IS
      SELECT mm.*
        FROM arckmm MM
       WHERE MM.NO_DOCU = Cv_IdDocumento
         AND MM.TIPO_DOC = Cv_TipoDocumento
         AND NO_CIA = '08';
    --
    CURSOR C_LeeArckml(Cv_TipoDocumento IN VARCHAR2, --
                       Cv_IdDocumento   IN VARCHAR2) IS
      SELECT ml.*
        FROM arckml ml
       WHERE ml.no_docu = Cv_IdDocumento
         AND ml.tipo_doc = Cv_TipoDocumento
         AND ml.no_cia = '08';
    --
    CURSOR C_LeeAsiento IS
      SELECT GAE.*
        FROM ARCGAE GAE
       WHERE NO_CIA = '08'
         AND GAE.FECHA >= Pv_FechaDesde
         AND GAE.FECHA <= Pv_FechaHasta;
  
    --
    CURSOR C_LeeDetAsiento(Cv_NoAsiento IN VARCHAR2) IS
      SELECT GAL.*
        FROM ARCGAL GAL
       WHERE NO_ASIENTO = Cv_NoAsiento
         AND NO_CIA = '08';
    --
    CURSOR C_LeeCheque(Cv_IdEmpresa IN VARCHAR2,
                       Cn_Secuencia IN NUMBER,
                       Cv_TipoDocu  IN VARCHAR2) IS
      SELECT *
        FROM ARCKCE
       WHERE NO_SECUENCIA = Cn_Secuencia
         AND TIPO_DOCU = Cv_TipoDocu
         AND NO_CIA = Cv_IdEmpresa;
  
    Lr_Documento   ARCPMD%ROWTYPE := NULL;
    Lr_DetalleCont ARCPDC%ROWTYPE := NULL;
    Lr_Retenciones ARCPTI%ROWTYPE := NULL;
    Lr_Arckce      ARCKCE%ROWTYPE := NULL;
    Lr_ArckceTemp  ARCKCE%ROWTYPE := NULL;
    Lr_Arckrd      ARCKRD%ROWTYPE := NULL;
    Lr_Arckcl      ARCKCL%ROWTYPE := NULL;
    Lr_Arckmm      ARCKMM%ROWTYPE := NULL;
    Lr_Arckml      ARCKML%ROWTYPE := NULL;
    Lr_Arcgae      ARCGAE%ROWTYPE := NULL;
    Lr_Arcgal      ARCGAL%ROWTYPE := NULL;
    --arckcl
    --arckrd
    --arckmm
    --arckml
    Le_Error EXCEPTION;
  BEGIN
    FOR Lr_MigraFacturas IN C_LeeFacturas LOOP
      --Inserta Factura
      Lr_Documento.NO_CIA                   := Pv_IdEmpresa;
      Lr_Documento.NO_PROVE                 := Lr_MigraFacturas.NO_PROVE;
      Lr_Documento.TIPO_DOC                 := Lr_MigraFacturas.TIPO_DOC;
      Lr_Documento.NO_DOCU                  := Lr_MigraFacturas.NO_DOCU;
      Lr_Documento.IND_ACT                  := Lr_MigraFacturas.IND_ACT;
      Lr_Documento.NO_FISICO                := Lr_MigraFacturas.NO_FISICO;
      Lr_Documento.SERIE_FISICO             := Lr_MigraFacturas.SERIE_FISICO;
      Lr_Documento.IND_OTROMOV              := Lr_MigraFacturas.IND_OTROMOV;
      Lr_Documento.FECHA                    := Lr_MigraFacturas.FECHA;
      Lr_Documento.SUBTOTAL                 := Lr_MigraFacturas.SUBTOTAL;
      Lr_Documento.MONTO                    := Lr_MigraFacturas.MONTO;
      Lr_Documento.SALDO                    := Lr_MigraFacturas.SALDO;
      Lr_Documento.GRAVADO                  := Lr_MigraFacturas.GRAVADO;
      Lr_Documento.EXCENTOS                 := Lr_MigraFacturas.EXCENTOS;
      Lr_Documento.DESCUENTO                := Lr_MigraFacturas.DESCUENTO;
      Lr_Documento.TOT_REFER                := Lr_MigraFacturas.TOT_REFER;
      Lr_Documento.TOT_DB                   := Lr_MigraFacturas.TOT_DB;
      Lr_Documento.TOT_CR                   := Lr_MigraFacturas.TOT_CR;
      Lr_Documento.FECHA_VENCE              := Lr_MigraFacturas.FECHA_VENCE;
      Lr_Documento.DESC_C                   := Lr_MigraFacturas.DESC_C;
      Lr_Documento.NO_ORDEN                 := Lr_MigraFacturas.NO_ORDEN;
      Lr_Documento.DESC_P                   := Lr_MigraFacturas.DESC_P;
      Lr_Documento.PLAZO_C                  := Lr_MigraFacturas.PLAZO_C;
      Lr_Documento.PLAZO_P                  := Lr_MigraFacturas.PLAZO_P;
      Lr_Documento.BLOQUEADO                := Lr_MigraFacturas.BLOQUEADO;
      Lr_Documento.MOTIVO                   := Lr_MigraFacturas.MOTIVO;
      Lr_Documento.MONEDA                   := Lr_MigraFacturas.MONEDA;
      Lr_Documento.TIPO_CAMBIO              := Lr_MigraFacturas.TIPO_CAMBIO;
      Lr_Documento.MONTO_NOMINAL            := Lr_MigraFacturas.MONTO_NOMINAL;
      Lr_Documento.SALDO_NOMINAL            := Lr_MigraFacturas.SALDO_NOMINAL;
      Lr_Documento.TIPO_COMPRA              := Lr_MigraFacturas.TIPO_COMPRA;
      Lr_Documento.MONTO_BIENES             := Lr_MigraFacturas.MONTO_BIENES;
      Lr_Documento.MONTO_SERV               := Lr_MigraFacturas.MONTO_SERV;
      Lr_Documento.MONTO_IMPORTAC           := Lr_MigraFacturas.MONTO_IMPORTAC;
      Lr_Documento.NO_CTA                   := Lr_MigraFacturas.NO_CTA;
      Lr_Documento.NO_SECUENCIA             := Lr_MigraFacturas.NO_SECUENCIA;
      Lr_Documento.T_CAMB_C_V               := Lr_MigraFacturas.T_CAMB_C_V;
      Lr_Documento.DETALLE                  := Lr_MigraFacturas.DETALLE;
      Lr_Documento.IND_OTROS_MESES          := Lr_MigraFacturas.IND_OTROS_MESES;
      Lr_Documento.FECHA_DOCUMENTO          := Lr_MigraFacturas.FECHA_DOCUMENTO;
      Lr_Documento.FECHA_VENCE_ORIGINAL     := Lr_MigraFacturas.FECHA_VENCE_ORIGINAL;
      Lr_Documento.CANT_PRORROGAS           := Lr_MigraFacturas.CANT_PRORROGAS;
      Lr_Documento.ORIGEN                   := Lr_MigraFacturas.ORIGEN;
      Lr_Documento.NUMERO_CTRL              := Lr_MigraFacturas.NUMERO_CTRL;
      Lr_Documento.ANULADO                  := Lr_MigraFacturas.ANULADO;
      Lr_Documento.USUARIO_ANULA            := Lr_MigraFacturas.USUARIO_ANULA;
      Lr_Documento.MOTIVO_ANULA             := Lr_MigraFacturas.MOTIVO_ANULA;
      Lr_Documento.COD_ESTADO               := Lr_MigraFacturas.COD_ESTADO;
      Lr_Documento.IND_ESTADO_VENCIDO       := Lr_MigraFacturas.IND_ESTADO_VENCIDO;
      Lr_Documento.ANO_ANULADO              := Lr_MigraFacturas.ANO_ANULADO;
      Lr_Documento.MES_ANULADO              := Lr_MigraFacturas.MES_ANULADO;
      Lr_Documento.TOT_DPP                  := Lr_MigraFacturas.TOT_DPP;
      Lr_Documento.TOT_IMP                  := Lr_MigraFacturas.TOT_IMP;
      Lr_Documento.TOT_RET                  := Lr_MigraFacturas.TOT_RET;
      Lr_Documento.TOT_IMP_ESPECIAL         := Lr_MigraFacturas.TOT_IMP_ESPECIAL;
      Lr_Documento.COD_DIARIO               := Lr_MigraFacturas.COD_DIARIO;
      Lr_Documento.TOT_RET_ESPECIAL         := Lr_MigraFacturas.TOT_RET_ESPECIAL;
      Lr_Documento.N_DOCU_A                 := Lr_MigraFacturas.N_DOCU_A;
      Lr_Documento.CONCEPTO                 := Lr_MigraFacturas.CONCEPTO;
      Lr_Documento.CODIGO_SUSTENTO          := Lr_MigraFacturas.CODIGO_SUSTENTO;
      Lr_Documento.NO_AUTORIZACION          := Lr_MigraFacturas.NO_AUTORIZACION;
      Lr_Documento.DERECHO_DEVOLUCION_IVA   := Lr_MigraFacturas.DERECHO_DEVOLUCION_IVA;
      Lr_Documento.FECHA_CADUCIDAD          := Lr_MigraFacturas.FECHA_CADUCIDAD;
      Lr_Documento.FECHA_ACTUALIZACION      := Lr_MigraFacturas.FECHA_ACTUALIZACION;
      Lr_Documento.COMP_RET                 := Lr_MigraFacturas.COMP_RET;
      Lr_Documento.IND_IMPRESION_RET        := Lr_MigraFacturas.IND_IMPRESION_RET;
      Lr_Documento.IND_REIMPRESION_RET      := Lr_MigraFacturas.IND_REIMPRESION_RET;
      Lr_Documento.USUARIO                  := Lr_MigraFacturas.USUARIO;
      Lr_Documento.MONTO_FISICO             := Lr_MigraFacturas.MONTO_FISICO;
      Lr_Documento.PEDIDO                   := Lr_MigraFacturas.PEDIDO;
      Lr_Documento.NO_AUTORIZACION_COMP     := Lr_MigraFacturas.NO_AUTORIZACION_COMP;
      Lr_Documento.FECHA_VALIDEZ            := Lr_MigraFacturas.FECHA_VALIDEZ;
      Lr_Documento.FECHA_VALIDEZ_COMP       := Lr_MigraFacturas.FECHA_VALIDEZ_COMP;
      Lr_Documento.TIPO_FACTURA             := Lr_MigraFacturas.TIPO_FACTURA;
      Lr_Documento.TIPO_HIST                := Lr_MigraFacturas.TIPO_HIST;
      Lr_Documento.FECHA_ANULA              := Lr_MigraFacturas.FECHA_ANULA;
      Lr_Documento.USUARIO_ACTUALIZA        := Lr_MigraFacturas.USUARIO_ACTUALIZA;
      Lr_Documento.FACTURA_GASTO            := Lr_MigraFacturas.FACTURA_GASTO;
      Lr_Documento.COMPRA_ACTIVO            := Lr_MigraFacturas.COMPRA_ACTIVO;
      Lr_Documento.NO_RETENC_IVA            := Lr_MigraFacturas.NO_RETENC_IVA;
      Lr_Documento.NO_RETENC_FUENTE         := Lr_MigraFacturas.NO_RETENC_FUENTE;
      Lr_Documento.COMP_RET_SERIE           := Lr_MigraFacturas.COMP_RET_SERIE;
      Lr_Documento.COMP_RET_ANULADA         := Lr_MigraFacturas.COMP_RET_ANULADA;
      Lr_Documento.EXCENTO_BIENES           := Lr_MigraFacturas.EXCENTO_BIENES;
      Lr_Documento.EXCENTO_SERV             := Lr_MigraFacturas.EXCENTO_SERV;
      Lr_Documento.FACTURA_EVENTUAL         := Lr_MigraFacturas.FACTURA_EVENTUAL;
      Lr_Documento.TIPO_RET                 := Lr_MigraFacturas.TIPO_RET;
      Lr_Documento.COD_VENDEDOR             := Lr_MigraFacturas.COD_VENDEDOR;
      Lr_Documento.TARJETA_CORP             := Lr_MigraFacturas.TARJETA_CORP;
      Lr_Documento.PLAZO_C1                 := Lr_MigraFacturas.PLAZO_C1;
      Lr_Documento.FECHA_VENCE1             := Lr_MigraFacturas.FECHA_VENCE1;
      Lr_Documento.DIRIGIDO                 := Lr_MigraFacturas.DIRIGIDO;
      Lr_Documento.NUMERO_PAGOS             := Lr_MigraFacturas.NUMERO_PAGOS;
      Lr_Documento.TIPO_COMPROBANTE         := Lr_MigraFacturas.TIPO_COMPROBANTE;
      Lr_Documento.CODIGO_DESTINO           := Lr_MigraFacturas.CODIGO_DESTINO;
      Lr_Documento.NO_AUTORIZACION_IMPRENTA := Lr_MigraFacturas.NO_AUTORIZACION_IMPRENTA;
      Lr_Documento.CENTRO                   := Lr_MigraFacturas.CENTRO;
      Lr_Documento.REFERENCIA               := Lr_MigraFacturas.REFERENCIA;
      Lr_Documento.TOTAL_BRUTO_INVENTARIOS  := Lr_MigraFacturas.TOTAL_BRUTO_INVENTARIOS;
      Lr_Documento.DESCUENTO_INVENTARIO     := Lr_MigraFacturas.DESCUENTO_INVENTARIO;
      Lr_Documento.SRI_RETIMP_RENTA         := Lr_MigraFacturas.SRI_RETIMP_RENTA;
      Lr_Documento.NO_EMBARQUE              := Lr_MigraFacturas.NO_EMBARQUE;
      Lr_Documento.VERIFICADOR              := Lr_MigraFacturas.VERIFICADOR;
      Lr_Documento.CORRELATIVO              := Lr_MigraFacturas.CORRELATIVO;
      Lr_Documento.CODIGO_REGIMEN           := Lr_MigraFacturas.CODIGO_REGIMEN;
      Lr_Documento.CODIGO_DISTRITO          := Lr_MigraFacturas.CODIGO_DISTRITO;
      Lr_Documento.ID_PRESUPUESTO           := Lr_MigraFacturas.ID_PRESUPUESTO;
      Lr_Documento.CLAVE_ACCESO             := Lr_MigraFacturas.CLAVE_ACCESO;
      Lr_Documento.DETALLE_RECHAZO          := Lr_MigraFacturas.DETALLE_RECHAZO;
      Lr_Documento.NOMBRE_ARCHIVO           := Lr_MigraFacturas.NOMBRE_ARCHIVO;
      Lr_Documento.FECHA_RETENCION          := Lr_MigraFacturas.FECHA_RETENCION;
      --
      CGK_MIGRACION_MEGA.CGP_INSERTA_DOCUMENTO(Lr_Documento, --
                                               Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    
      --
      ---
      FOR Lr_MigraDet IN C_LeeDetalleContable(Lr_Documento.No_Docu, Lr_MigraFacturas.Tipo_Doc) LOOP
        Lr_DetalleCont.NO_CIA             := Pv_IdEmpresa; --Lr_MigraDet.NO_CIA;
        Lr_DetalleCont.NO_PROVE           := Lr_MigraDet.NO_PROVE;
        Lr_DetalleCont.TIPO_DOC           := Lr_MigraDet.TIPO_DOC;
        Lr_DetalleCont.NO_DOCU            := Lr_MigraDet.NO_DOCU;
        Lr_DetalleCont.CODIGO             := Lr_MigraDet.CODIGO;
        Lr_DetalleCont.TIPO               := Lr_MigraDet.TIPO;
        Lr_DetalleCont.MONTO              := Lr_MigraDet.MONTO;
        Lr_DetalleCont.MES                := Lr_MigraDet.MES;
        Lr_DetalleCont.ANO                := Lr_MigraDet.ANO;
        Lr_DetalleCont.IND_CON            := Lr_MigraDet.IND_CON;
        Lr_DetalleCont.MONTO_DOL          := Lr_MigraDet.MONTO_DOL;
        Lr_DetalleCont.MONEDA             := Lr_MigraDet.MONEDA;
        Lr_DetalleCont.TIPO_CAMBIO        := Lr_MigraDet.TIPO_CAMBIO;
        Lr_DetalleCont.NO_ASIENTO         := Lr_MigraDet.NO_ASIENTO;
        Lr_DetalleCont.CENTRO_COSTO       := Lr_MigraDet.CENTRO_COSTO;
        Lr_DetalleCont.MODIFICABLE        := Lr_MigraDet.MODIFICABLE;
        Lr_DetalleCont.CODIGO_TERCERO     := Lr_MigraDet.CODIGO_TERCERO;
        Lr_DetalleCont.MONTO_DC           := Lr_MigraDet.MONTO_DC;
        Lr_DetalleCont.GLOSA              := Lr_MigraDet.GLOSA;
        Lr_DetalleCont.EXCEDE_PRESUPUESTO := Lr_MigraDet.EXCEDE_PRESUPUESTO;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_DET_CONTABLE(Lr_DetalleCont, --
                                                    Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      --
      --
      END LOOP;
      FOR Lr_Ret IN C_LeeRetenciones(Lr_MigraFacturas.NO_DOCU, Lr_MigraFacturas.Tipo_Doc) LOOP
        Lr_Retenciones.NO_CIA             := Pv_IdEmpresa;
        Lr_Retenciones.NO_PROVE           := Lr_Ret.NO_PROVE;
        Lr_Retenciones.TIPO_DOC           := Lr_Ret.TIPO_DOC;
        Lr_Retenciones.NO_DOCU            := Lr_Ret.NO_DOCU;
        Lr_Retenciones.CLAVE              := Lr_Ret.CLAVE;
        Lr_Retenciones.PORCENTAJE         := Lr_Ret.PORCENTAJE;
        Lr_Retenciones.MONTO              := Lr_Ret.MONTO;
        Lr_Retenciones.IND_IMP_RET        := Lr_Ret.IND_IMP_RET;
        Lr_Retenciones.APLICA_CRED_FISCAL := Lr_Ret.APLICA_CRED_FISCAL;
        Lr_Retenciones.BASE               := Lr_Ret.BASE;
        Lr_Retenciones.CODIGO_TERCERO     := Lr_Ret.CODIGO_TERCERO;
        Lr_Retenciones.COMPORTAMIENTO     := Lr_Ret.COMPORTAMIENTO;
        Lr_Retenciones.ID_SEC             := Lr_Ret.ID_SEC;
        Lr_Retenciones.NO_REFE            := Lr_Ret.NO_REFE;
        Lr_Retenciones.SECUENCIA_RET      := Lr_Ret.SECUENCIA_RET;
        Lr_Retenciones.ANULADA            := Lr_Ret.ANULADA;
        Lr_Retenciones.FECHA_IMPRIME      := Lr_Ret.FECHA_IMPRIME;
        Lr_Retenciones.SRI_RETIMP_RENTA   := Lr_Ret.SRI_RETIMP_RENTA;
        Lr_Retenciones.SERVICIO_BIENES    := Lr_Ret.SERVICIO_BIENES;
        Lr_Retenciones.AUTORIZACION       := Lr_Ret.AUTORIZACION;
        Lr_Retenciones.FECHA_ANULA        := Lr_Ret.FECHA_ANULA;
        Lr_Retenciones.BASE_GRAVADA       := Lr_Ret.BASE_GRAVADA;
        Lr_Retenciones.BASE_EXCENTA       := Lr_Ret.BASE_EXCENTA;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_RETENCIONES(Lr_Retenciones, --
                                                   Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END LOOP;
    
    END LOOP;
    --
    --Migra Pagos de la 08
    FOR Lr_MigraArckce IN C_LeeArckce LOOP
    
      Lr_Arckce                      := NULL;
      Lr_Arckce.NO_CIA               := Pv_IdEmpresa; --Lr_MigraArckce.NO_CIA;
      Lr_Arckce.NO_CTA               := Lr_MigraArckce.NO_CTA;
      Lr_Arckce.TIPO_DOCU            := Lr_MigraArckce.TIPO_DOCU;
      Lr_Arckce.NO_SECUENCIA         := Lr_MigraArckce.NO_SECUENCIA;
      Lr_Arckce.CHEQUE               := Lr_MigraArckce.CHEQUE;
      Lr_Arckce.SERIE_FISICO         := Lr_MigraArckce.SERIE_FISICO;
      Lr_Arckce.FECHA                := Lr_MigraArckce.FECHA;
      Lr_Arckce.MONTO                := Lr_MigraArckce.MONTO;
      Lr_Arckce.BENEFICIARIO         := Lr_MigraArckce.BENEFICIARIO;
      Lr_Arckce.IND_ACT              := Lr_MigraArckce.IND_ACT;
      Lr_Arckce.COM                  := Lr_MigraArckce.COM;
      Lr_Arckce.IND_CON              := Lr_MigraArckce.IND_CON;
      Lr_Arckce.NO_PROVE             := Lr_MigraArckce.NO_PROVE;
      Lr_Arckce.ANULADO              := Lr_MigraArckce.ANULADO;
      Lr_Arckce.FECHA_ANULADO        := Lr_MigraArckce.FECHA_ANULADO;
      Lr_Arckce.EMITIDO              := Lr_MigraArckce.EMITIDO;
      Lr_Arckce.TOT_REF              := Lr_MigraArckce.TOT_REF;
      Lr_Arckce.TOT_DIFE_CAM         := Lr_MigraArckce.TOT_DIFE_CAM;
      Lr_Arckce.TOT_DB               := Lr_MigraArckce.TOT_DB;
      Lr_Arckce.TOT_CR               := Lr_MigraArckce.TOT_CR;
      Lr_Arckce.SALDO                := Lr_MigraArckce.SALDO;
      Lr_Arckce.MONEDA_CTA           := Lr_MigraArckce.MONEDA_CTA;
      Lr_Arckce.TIPO_CAMBIO          := Lr_MigraArckce.TIPO_CAMBIO;
      Lr_Arckce.MONTO_NOMINAL        := Lr_MigraArckce.MONTO_NOMINAL;
      Lr_Arckce.SALDO_NOMINAL        := Lr_MigraArckce.SALDO_NOMINAL;
      Lr_Arckce.AUTORIZA             := Lr_MigraArckce.AUTORIZA;
      Lr_Arckce.ORIGEN               := Lr_MigraArckce.ORIGEN;
      Lr_Arckce.T_CAMB_C_V           := Lr_MigraArckce.T_CAMB_C_V;
      Lr_Arckce.NO_ASIENTO           := Lr_MigraArckce.NO_ASIENTO;
      Lr_Arckce.UBICACION            := Lr_MigraArckce.UBICACION;
      Lr_Arckce.FECHA_VENCE          := Lr_MigraArckce.FECHA_VENCE;
      Lr_Arckce.TOT_DPP              := Lr_MigraArckce.TOT_DPP;
      Lr_Arckce.NUMERO_CTRL          := Lr_MigraArckce.NUMERO_CTRL;
      Lr_Arckce.TIPO_TRANSFE         := Lr_MigraArckce.TIPO_TRANSFE;
      Lr_Arckce.BANCO_TRANSFE        := Lr_MigraArckce.BANCO_TRANSFE;
      Lr_Arckce.CTA_BCO_TRANSFE      := Lr_MigraArckce.CTA_BCO_TRANSFE;
      Lr_Arckce.IND_NEGOCIABLE       := Lr_MigraArckce.IND_NEGOCIABLE;
      Lr_Arckce.IND_RETENCION        := Lr_MigraArckce.IND_RETENCION;
      Lr_Arckce.MONEDA_PAGO          := Lr_MigraArckce.MONEDA_PAGO;
      Lr_Arckce.USUARIO_CREACION     := Lr_MigraArckce.USUARIO_CREACION;
      Lr_Arckce.USUARIO_MODIFICACION := Lr_MigraArckce.USUARIO_MODIFICACION;
      Lr_Arckce.FECHA_ACTUALIZA      := Lr_MigraArckce.FECHA_ACTUALIZA;
      Lr_Arckce.TIPO_D               := Lr_MigraArckce.TIPO_D;
      Lr_Arckce.IND_GEN_ARCH         := Lr_MigraArckce.IND_GEN_ARCH;
      Lr_Arckce.ID_PRESUPUESTO       := Lr_MigraArckce.ID_PRESUPUESTO;
      Lr_Arckce.PAGO_ORDEN_COMPRA    := Lr_MigraArckce.PAGO_ORDEN_COMPRA;
      Lr_Arckce.ID_PROV_ORDEN        := Lr_MigraArckce.ID_PROV_ORDEN;
      --
      IF C_LeeCheque%ISOPEN THEN
        CLOSE C_LeeCheque;
      END IF;
      OPEN C_LeeCheque(Pv_IdEmpresa, Lr_Arckce.No_Secuencia, Lr_Arckce.Tipo_Docu);
      FETCH C_LeeCheque
        INTO Lr_ArckceTemp;
      CLOSE C_LeeCheque;
      IF Lr_ArckceTemp.NO_SECUENCIA IS NULL THEN
        CGK_MIGRACION_MEGA.CGP_INSERTA_ARCKCE(Lr_Arckce, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      --
      FOR Lr_MigraArckcl IN C_LeeArckcl(Lr_MigraArckce.NO_SECUENCIA, Lr_MigraArckce.Tipo_Docu) LOOP
        Lr_Arckcl                    := NULL;
        Lr_Arckcl.NO_CIA             := Pv_IdEmpresa; --Lr_MigraArckcl.NO_CIA;
        Lr_Arckcl.NO_SECUENCIA       := Lr_MigraArckcl.NO_SECUENCIA;
        Lr_Arckcl.TIPO_DOCU          := Lr_MigraArckcl.TIPO_DOCU;
        Lr_Arckcl.COD_CONT           := Lr_MigraArckcl.COD_CONT;
        Lr_Arckcl.CENTRO_COSTO       := Lr_MigraArckcl.CENTRO_COSTO;
        Lr_Arckcl.CODIGO_TERCERO     := Lr_MigraArckcl.CODIGO_TERCERO;
        Lr_Arckcl.TIPO_MOV           := Lr_MigraArckcl.TIPO_MOV;
        Lr_Arckcl.MONTO              := Lr_MigraArckcl.MONTO;
        Lr_Arckcl.MONTO_DOL          := Lr_MigraArckcl.MONTO_DOL;
        Lr_Arckcl.MONEDA             := Lr_MigraArckcl.MONEDA;
        Lr_Arckcl.NO_ASIENTO         := Lr_MigraArckcl.NO_ASIENTO;
        Lr_Arckcl.TIPO_CAMBIO        := Lr_MigraArckcl.TIPO_CAMBIO;
        Lr_Arckcl.MODIFICABLE        := Lr_MigraArckcl.MODIFICABLE;
        Lr_Arckcl.IND_CON            := Lr_MigraArckcl.IND_CON;
        Lr_Arckcl.ANO                := Lr_MigraArckcl.ANO;
        Lr_Arckcl.MES                := Lr_MigraArckcl.MES;
        Lr_Arckcl.MONTO_DC           := Lr_MigraArckcl.MONTO_DC;
        Lr_Arckcl.GLOSA              := Lr_MigraArckcl.GLOSA;
        Lr_Arckcl.EXCEDE_PRESUPUESTO := Lr_MigraArckcl.EXCEDE_PRESUPUESTO;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_ARCKCL(Lr_Arckcl, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END LOOP;
      --
      FOR Lr_MigraArckrd IN C_LeeArckrd(Lr_MigraArckce.NO_SECUENCIA, Lr_MigraArckce.Tipo_Docu) LOOP
        Lr_Arckrd                   := NULL;
        Lr_Arckrd.NO_CIA            := Pv_IdEmpresa; --Lr_Arckrd.NO_CIA;
        Lr_Arckrd.TIPO_DOCU         := Lr_MigraArckrd.TIPO_DOCU;
        Lr_Arckrd.NO_SECUENCIA      := Lr_MigraArckrd.NO_SECUENCIA;
        Lr_Arckrd.TIPO_REFE         := Lr_MigraArckrd.TIPO_REFE;
        Lr_Arckrd.NO_REFE           := Lr_MigraArckrd.NO_REFE;
        Lr_Arckrd.NO_PROVE          := Lr_MigraArckrd.NO_PROVE;
        Lr_Arckrd.MONTO             := Lr_MigraArckrd.MONTO;
        Lr_Arckrd.BCO_PROVE         := Lr_MigraArckrd.BCO_PROVE;
        Lr_Arckrd.CTA_BCO_PROVE     := Lr_MigraArckrd.CTA_BCO_PROVE;
        Lr_Arckrd.MONEDA_REFE       := Lr_MigraArckrd.MONEDA_REFE;
        Lr_Arckrd.MONTO_REFE        := Lr_MigraArckrd.MONTO_REFE;
        Lr_Arckrd.DESCUENTO_PP      := Lr_MigraArckrd.DESCUENTO_PP;
        Lr_Arckrd.DESCUENTO_PP_REFE := Lr_MigraArckrd.DESCUENTO_PP_REFE;
        Lr_Arckrd.ID_PRESUPUESTO    := Lr_MigraArckrd.ID_PRESUPUESTO;
        --
        Lr_DocumentoRelac := NULL;
        IF C_LeeDocRelaCk%ISOPEN THEN
          CLOSE C_LeeDocRelaCk;
        END IF;
        OPEN C_LeeDocRelaCk(Pv_IdEmpresa, --
                            Lr_MigraArckrd.TIPO_REFE,
                            Lr_MigraArckrd.NO_REFE);
        FETCH C_LeeDocRelaCk
          INTO Lr_DocumentoRelac;
        CLOSE C_LeeDocRelaCk;
        IF Lr_DocumentoRelac.No_Docu IS NOT NULL THEN
          CGK_MIGRACION_MEGA.CGP_INSERTA_ARCKRD(Lr_Arckrd, Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            Pv_MensajeError := Pv_MensajeError || ' -  ' || Lr_MigraArckrd.TIPO_DOCU || ' -- ' || Lr_MigraArckrd.NO_REFE;
            RAISE Le_Error;
          END IF;
        ELSE
          dbms_output.put_line('No Exite Tipo Documento ' || Lr_MigraArckrd.TIPO_REFE || ' , Documento ' || Lr_MigraArckrd.NO_REFE);
        END IF;
      END LOOP;
      FOR Lr_MigraArckmm IN C_LeeArckmm(Lr_Arckce.Tipo_Docu, --
                                        Lr_Arckce.NO_SECUENCIA) LOOP
      
        Lr_Arckmm                   := NULL;
        Lr_Arckmm.NO_CIA            := Pv_IdEmpresa; --Lr_MigraArckmm.NO_CIA;
        Lr_Arckmm.NO_CTA            := Lr_MigraArckmm.NO_CTA;
        Lr_Arckmm.PROCEDENCIA       := Lr_MigraArckmm.PROCEDENCIA;
        Lr_Arckmm.TIPO_DOC          := Lr_MigraArckmm.TIPO_DOC;
        Lr_Arckmm.NO_DOCU           := Lr_MigraArckmm.NO_DOCU;
        Lr_Arckmm.FECHA             := Lr_MigraArckmm.FECHA;
        Lr_Arckmm.BENEFICIARIO      := Lr_MigraArckmm.BENEFICIARIO;
        Lr_Arckmm.COMENTARIO        := Lr_MigraArckmm.COMENTARIO;
        Lr_Arckmm.MONTO             := Lr_MigraArckmm.MONTO;
        Lr_Arckmm.DESCUENTO_PP      := Lr_MigraArckmm.DESCUENTO_PP;
        Lr_Arckmm.ESTADO            := Lr_MigraArckmm.ESTADO;
        Lr_Arckmm.CONCILIADO        := Lr_MigraArckmm.CONCILIADO;
        Lr_Arckmm.MES               := Lr_MigraArckmm.MES;
        Lr_Arckmm.ANO               := Lr_MigraArckmm.ANO;
        Lr_Arckmm.FECHA_ANULADO     := Lr_MigraArckmm.FECHA_ANULADO;
        Lr_Arckmm.IND_BORRADO       := Lr_MigraArckmm.IND_BORRADO;
        Lr_Arckmm.IND_OTROMOV       := Lr_MigraArckmm.IND_OTROMOV;
        Lr_Arckmm.MONEDA_CTA        := Lr_MigraArckmm.MONEDA_CTA;
        Lr_Arckmm.TIPO_CAMBIO       := Lr_MigraArckmm.TIPO_CAMBIO;
        Lr_Arckmm.TIPO_AJUSTE       := Lr_MigraArckmm.TIPO_AJUSTE;
        Lr_Arckmm.IND_DIST          := Lr_MigraArckmm.IND_DIST;
        Lr_Arckmm.T_CAMB_C_V        := Lr_MigraArckmm.T_CAMB_C_V;
        Lr_Arckmm.IND_OTROS_MESES   := Lr_MigraArckmm.IND_OTROS_MESES;
        Lr_Arckmm.MES_CONCILIADO    := Lr_MigraArckmm.MES_CONCILIADO;
        Lr_Arckmm.ANO_CONCILIADO    := Lr_MigraArckmm.ANO_CONCILIADO;
        Lr_Arckmm.NO_FISICO         := Lr_MigraArckmm.NO_FISICO;
        Lr_Arckmm.SERIE_FISICO      := Lr_MigraArckmm.SERIE_FISICO;
        Lr_Arckmm.IND_CON           := Lr_MigraArckmm.IND_CON;
        Lr_Arckmm.NUMERO_CTRL       := Lr_MigraArckmm.NUMERO_CTRL;
        Lr_Arckmm.ORIGEN            := Lr_MigraArckmm.ORIGEN;
        Lr_Arckmm.USUARIO_CREACION  := Lr_MigraArckmm.USUARIO_CREACION;
        Lr_Arckmm.USUARIO_ANULA     := Lr_MigraArckmm.USUARIO_ANULA;
        Lr_Arckmm.USUARIO_ACTUALIZA := Lr_MigraArckmm.USUARIO_ACTUALIZA;
        Lr_Arckmm.FECHA_ACTUALIZA   := Lr_MigraArckmm.FECHA_ACTUALIZA;
        Lr_Arckmm.FECHA_DOC         := Lr_MigraArckmm.FECHA_DOC;
        Lr_Arckmm.IND_DIVISION      := Lr_MigraArckmm.IND_DIVISION;
        Lr_Arckmm.COD_DIVISION      := Lr_MigraArckmm.COD_DIVISION;
        Lr_Arckmm.TIME_STAMP        := Lr_MigraArckmm.TIME_STAMP;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_ARCKMM(Lr_Arckmm, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END LOOP;
      --
      FOR Lr_MigraArckml IN C_LeeArckml(Lr_Arckce.Tipo_Docu, --
                                        Lr_Arckce.NO_SECUENCIA) LOOP
        Lr_Arckml                    := NULL;
        Lr_Arckml.NO_CIA             := Pv_IdEmpresa; --Lr_MigraArckml.NO_CIA;
        Lr_Arckml.PROCEDENCIA        := Lr_MigraArckml.PROCEDENCIA;
        Lr_Arckml.TIPO_DOC           := Lr_MigraArckml.TIPO_DOC;
        Lr_Arckml.NO_DOCU            := Lr_MigraArckml.NO_DOCU;
        Lr_Arckml.COD_CONT           := Lr_MigraArckml.COD_CONT;
        Lr_Arckml.CENTRO_COSTO       := Lr_MigraArckml.CENTRO_COSTO;
        Lr_Arckml.TIPO_MOV           := Lr_MigraArckml.TIPO_MOV;
        Lr_Arckml.MONTO              := Lr_MigraArckml.MONTO;
        Lr_Arckml.MONTO_DOL          := Lr_MigraArckml.MONTO_DOL;
        Lr_Arckml.TIPO_CAMBIO        := Lr_MigraArckml.TIPO_CAMBIO;
        Lr_Arckml.MONEDA             := Lr_MigraArckml.MONEDA;
        Lr_Arckml.NO_ASIENTO         := Lr_MigraArckml.NO_ASIENTO;
        Lr_Arckml.MODIFICABLE        := Lr_MigraArckml.MODIFICABLE;
        Lr_Arckml.CODIGO_TERCERO     := Lr_MigraArckml.CODIGO_TERCERO;
        Lr_Arckml.IND_CON            := Lr_MigraArckml.IND_CON;
        Lr_Arckml.ANO                := Lr_MigraArckml.ANO;
        Lr_Arckml.MES                := Lr_MigraArckml.MES;
        Lr_Arckml.MONTO_DC           := Lr_MigraArckml.MONTO_DC;
        Lr_Arckml.GLOSA              := Lr_MigraArckml.GLOSA;
        Lr_Arckml.EXCEDE_PRESUPUESTO := Lr_MigraArckml.EXCEDE_PRESUPUESTO;
        --
        CGK_MIGRACION_MEGA.CGP_INSERTA_ARCKML(Lr_Arckml, Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END LOOP;
    
    END LOOP;
    --
    FOR Lr_MigraArcgae IN C_LeeAsiento LOOP
      Lr_Arcgae                   := NULL;
      Lr_Arcgae.NO_CIA            := Pv_IdEmpresa; --Lr_MigraArcgae.NO_CIA;
      Lr_Arcgae.ANO               := Lr_MigraArcgae.ANO;
      Lr_Arcgae.MES               := Lr_MigraArcgae.MES;
      Lr_Arcgae.NO_ASIENTO        := Lr_MigraArcgae.NO_ASIENTO;
      Lr_Arcgae.IMPRESO           := Lr_MigraArcgae.IMPRESO;
      Lr_Arcgae.FECHA             := Lr_MigraArcgae.FECHA;
      Lr_Arcgae.DESCRI1           := Lr_MigraArcgae.DESCRI1;
      Lr_Arcgae.ESTADO            := Lr_MigraArcgae.ESTADO;
      Lr_Arcgae.AUTORIZADO        := Lr_MigraArcgae.AUTORIZADO;
      Lr_Arcgae.ORIGEN            := Lr_MigraArcgae.ORIGEN;
      Lr_Arcgae.T_DEBITOS         := Lr_MigraArcgae.T_DEBITOS;
      Lr_Arcgae.T_CREDITOS        := Lr_MigraArcgae.T_CREDITOS;
      Lr_Arcgae.COD_DIARIO        := Lr_MigraArcgae.COD_DIARIO;
      Lr_Arcgae.T_CAMB_C_V        := Lr_Arcgae.T_CAMB_C_V;
      Lr_Arcgae.TIPO_CAMBIO       := Lr_Arcgae.TIPO_CAMBIO;
      Lr_Arcgae.TIPO_COMPROBANTE  := Lr_MigraArcgae.TIPO_COMPROBANTE;
      Lr_Arcgae.NO_COMPROBANTE    := Lr_MigraArcgae.NO_COMPROBANTE;
      Lr_Arcgae.ANULADO           := Lr_MigraArcgae.ANULADO;
      Lr_Arcgae.USUARIO_CREACION  := Lr_MigraArcgae.USUARIO_CREACION;
      Lr_Arcgae.USUARIO_ACTUALIZA := Lr_MigraArcgae.USUARIO_ACTUALIZA;
      Lr_Arcgae.FECHA_ACTUALIZA   := Lr_MigraArcgae.FECHA_ACTUALIZA;
      Lr_Arcgae.USUARIO_ANULA     := Lr_MigraArcgae.USUARIO_ANULA;
      Lr_Arcgae.FECHA_ANULA       := Lr_MigraArcgae.FECHA_ANULA;
      Lr_Arcgae.NUMERO_CTRL       := Lr_MigraArcgae.NUMERO_CTRL;
      --
      Lr_Diarios := NULL;
      IF C_LeeCodDiario%ISOPEN THEN
        CLOSE C_LeeCodDiario;
      END IF;
      OPEN C_LeeCodDiario(Pv_IdEmpresa, Lr_Arcgae.COD_DIARIO);
      FETCH C_LeeCodDiario
        INTO Lr_Diarios;
      CLOSE C_LeeCodDiario;
      --
      IF Lr_Diarios.Cod_Diario IS NOT NULL THEN
        CGK_MIGRACION_MEGA.CGP_INSERTA_ASIENTO(Lr_Arcgae, --
                                               Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := Pv_MensajeError || ' - ' || Lr_Arcgae.COD_DIARIO;
          RAISE Le_Error;
        END IF;
        --
      ELSE
        DBMS_OUTPUT.put_line('No existe Diario ' || Lr_Arcgae.COD_DIARIO);
      END IF;
      FOR Lr_MigraArcgal IN C_LeeDetAsiento(Lr_Arcgae.NO_ASIENTO) LOOP
        Lr_Arcgal                        := NULL;
        Lr_Arcgal.NO_CIA                 := Pv_IdEmpresa; --Lr_MigraArcgal.NO_CIA;
        Lr_Arcgal.ANO                    := Lr_MigraArcgal.ANO;
        Lr_Arcgal.MES                    := Lr_MigraArcgal.MES;
        Lr_Arcgal.NO_ASIENTO             := Lr_MigraArcgal.NO_ASIENTO;
        Lr_Arcgal.NO_LINEA               := Lr_MigraArcgal.NO_LINEA;
        Lr_Arcgal.CUENTA                 := Lr_MigraArcgal.CUENTA;
        Lr_Arcgal.DESCRI                 := Lr_MigraArcgal.DESCRI;
        Lr_Arcgal.NO_DOCU                := Lr_MigraArcgal.NO_DOCU;
        Lr_Arcgal.COD_DIARIO             := Lr_MigraArcgal.COD_DIARIO;
        Lr_Arcgal.MONEDA                 := Lr_MigraArcgal.MONEDA;
        Lr_Arcgal.TIPO_CAMBIO            := Lr_MigraArcgal.TIPO_CAMBIO;
        Lr_Arcgal.FECHA                  := Lr_MigraArcgal.FECHA;
        Lr_Arcgal.MONTO                  := Lr_MigraArcgal.MONTO;
        Lr_Arcgal.CENTRO_COSTO           := Lr_MigraArcgal.CENTRO_COSTO;
        Lr_Arcgal.TIPO                   := Lr_MigraArcgal.TIPO;
        Lr_Arcgal.MONTO_DOL              := Lr_MigraArcgal.MONTO_DOL;
        Lr_Arcgal.CC_1                   := Lr_MigraArcgal.CC_1;
        Lr_Arcgal.CC_2                   := Lr_MigraArcgal.CC_2;
        Lr_Arcgal.CC_3                   := Lr_MigraArcgal.CC_3;
        Lr_Arcgal.CODIGO_TERCERO         := Lr_MigraArcgal.CODIGO_TERCERO;
        Lr_Arcgal.LINEA_AJUSTE_PRECISION := Lr_MigraArcgal.LINEA_AJUSTE_PRECISION;
        Lr_Arcgal.EXCEDE_PRESUPUESTO     := Lr_MigraArcgal.EXCEDE_PRESUPUESTO;
        Lr_Diarios                       := NULL;
        IF C_LeeCodDiario%ISOPEN THEN
          CLOSE C_LeeCodDiario;
        END IF;
        OPEN C_LeeCodDiario(Pv_IdEmpresa, Lr_Arcgal.COD_DIARIO);
        FETCH C_LeeCodDiario
          INTO Lr_Diarios;
        CLOSE C_LeeCodDiario;
        --
        IF Lr_Diarios.Cod_Diario IS NOT NULL THEN
        
          CGK_MIGRACION_MEGA.CGP_INSERTA_DETALLE(Lr_Arcgal, --
                                                 Pv_MensajeError);
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
        ELSE
          DBMS_OUTPUT.put_line('No existe Diario ' || Lr_Arcgal.COD_DIARIO);
        END IF;
      
      END LOOP;
    END LOOP;
    --
    --arckcl--
    --arckrd --
    --arckmm--
    --arckml
    --Migra Asientos de la 08
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_FACTURAS_08. ' || SQLCODE || ' ' || SQLERRM;
      ROLLBACK;
  END CGP_FACTURAS_08;
  ---
  --Procedimiento los diarios registrados 
  --01 DIARIOS
  --05 FACTURACION
  --07 FACTURAS MANUALES
  --11 NOTAS DE CREDITO
  --12 DIARIO DE AJUSTE
  --14 DIARIO DE AJUSTES CLIENTES
  --20 INGRESO CIERRES DE CAJA
  --21 INGRESOS GUAYAQUIL
  --26 DEPOSITOS COSTA

  PROCEDURE CGP_MIGRA_TIPOS_DIARIOS(Pv_IdEmpresa    IN VARCHAR2,
                                    Pv_FechaDesde   IN VARCHAR2,
                                    Pv_FechaHasta   IN VARCHAR2,
                                    Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeeFacturas IS
      SELECT DISTINCT AC.CODIGO_ASIENTO,
                      AC.ID_ASIENTO,
                      AC.FECHA,
                      AC.TOTAL_DEBITOS,
                      AC.TOTAL_CREDITOS,
                      AC.TIPO_ASIENTO,
                      AC.COMPANIA,
                      AC.CONCEPTO
        FROM CG_M_ASIENTO_CONTABLE AC
       WHERE AC.COMPANIA = Pv_IdEmpresa
         AND AC.CODIGO_ASIENTO IN ('01', '05', '07', '11', '12', '14', '20', '21', '26') --= '01'
         AND TRUNC(AC.FECHA) >= Pv_FechaDesde
         AND TRUNC(AC.FECHA) <= Pv_FechaHasta;
  
    CURSOR C_LeeDetalleCont(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdAsiento IN VARCHAR2) IS
      SELECT *
        FROM CG_M_DETALLE_ASIENTO
       WHERE ID_ASIENTO = Cv_IdAsiento
         AND COMPANIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeNoAsiento(Cv_Idempresa   IN VARCHAR2,
                          Cv_Descripcion IN VARCHAR2) IS
      SELECT NO_ASIENTO
        FROM ARCGAE
       WHERE NO_CIA = Cv_Idempresa
         AND REPLACE(Descri1, ' ', '') = REPLACE(Cv_Descripcion, ' ', '');
    --
    CURSOR C_TotalesCab(Cv_IdEmpresa IN VARCHAR2,
                        Cv_NoAsiento IN VARCHAR2) IS
      SELECT *
        FROM ARCGAE
       WHERE NO_ASIENTO = Cv_NoAsiento
         AND NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_TotalesDet(Cv_IdEmpresa IN VARCHAR2,
                        Cv_NoAsiento IN VARCHAR2) IS
      SELECT SUM(NVL(DECODE(TIPO, 'C', -1 * MONTO_DOL, 0), 0)) CREDITO,
             SUM(NVL(DECODE(TIPO, 'D', 0, -1 * MONTO_DOL), 0)) DEBITO
        FROM arcgal
       WHERE no_cia = Cv_IdEmpresa
         AND no_asiento = Cv_NoAsiento;
  
    Lr_CabAsiento    ARCGAE%ROWTYPE := NULL;
    Lr_DetAsiento    ARCGAL%ROWTYPE := NULL;
    Lr_DetAsientoTot C_TotalesDet%ROWTYPE := NULL;
    --Ln_NoAsiento ARCGAE.NO_ASIENTO%TYPE:=NULL;
    Le_Error EXCEPTION;
  BEGIN
    FOR Lr_MigrAsiento IN C_LeeFacturas LOOP
      Lr_CabAsiento := NULL;
      --
      Lr_CabAsiento.No_Cia     := Lr_MigrAsiento.Compania;
      Lr_CabAsiento.Fecha      := Lr_MigrAsiento.Fecha;
      Lr_CabAsiento.Descri1    := SUBSTR(Lr_MigrAsiento.Concepto || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 240);
      Lr_CabAsiento.t_Debitos  := Lr_MigrAsiento.Total_Debitos;
      Lr_CabAsiento.t_Creditos := Lr_MigrAsiento.Total_Creditos;
      Lr_CabAsiento.Cod_Diario := Lr_MigrAsiento.CODIGO_ASIENTO;
      Lr_CabAsiento.Impreso    := 'N';
    
      CGK_MIGRACION_MEGA.CGP_INSERTA_ASIENTO(Lr_CabAsiento, --
                                             Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      FOR Lr_MigraDetalle IN C_LeeDetalleCont(Lr_MigrAsiento.Compania, Lr_MigrAsiento.Id_Asiento) LOOP
        IF C_LeeNoAsiento%ISOPEN THEN
          CLOSE C_LeeNoAsiento;
        END IF;
        OPEN C_LeeNoAsiento(Pv_IdEmpresa, --
                            SUBSTR(Lr_MigrAsiento.Concepto || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 240));
      
        FETCH C_LeeNoAsiento
          INTO Lr_CabAsiento.No_Asiento;
        CLOSE C_LeeNoAsiento;
        Lr_DetAsiento            := NULL;
        Lr_DetAsiento.no_cia     := Lr_CabAsiento.No_Cia;
        Lr_DetAsiento.ano        := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.Fecha /*Lr_CabAsiento.Fecha*/, 'yyyy'));
        Lr_DetAsiento.mes        := TO_NUMBER(TO_CHAR(Lr_MigrAsiento.Fecha /*Lr_CabAsiento.Fecha*/, 'mm'));
        Lr_DetAsiento.no_asiento := Lr_CabAsiento.No_Asiento;
        Lr_DetAsiento.descri     := SUBSTR(Lr_MigraDetalle.Concepto || ' -MIGRA HIPERK ' || Lr_MigrAsiento.ID_ASIENTO, 1, 100);
        Lr_DetAsiento.cod_diario := Lr_MigrAsiento.Codigo_Asiento; --Lr_CabAsiento.Cod_Diario;
        IF Lr_MigraDetalle.Itegas = '195001' THEN
          --GYE
          Lr_DetAsiento.Centro_Costo := '001001001';
        ELSIF Lr_MigraDetalle.Itegas = '195000' THEN
          --UIO
          Lr_DetAsiento.Centro_Costo := '001001002';
        ELSE
          IF SUBSTR(Lr_MigraDetalle.Id_Cuenta_Contable, 1, 1) NOT IN ('5', '6') THEN
            Lr_DetAsiento.Centro_Costo := '000000000';
          ELSE
            Lr_DetAsiento.Centro_Costo := '001001002';
          END IF;
          Lr_DetAsiento.Codigo_Tercero := Lr_MigraDetalle.Itegas;
        END IF;
        --Lr_DetAsiento.Centro_Costo := REPLACE(Lr_MigraDetalle.Id_Centro_Costo, '-', '');
        /*        Lr_DetAsiento.cc_1         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 1, 3);
        Lr_DetAsiento.cc_2         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 5, 3);
        Lr_DetAsiento.cc_3         := SUBSTR(Lr_MigraDetalle.Id_Centro_Costo, 8, 3);*/
        Lr_DetAsiento.cc_1 := SUBSTR(Lr_DetAsiento.Centro_Costo, 1, 3);
        Lr_DetAsiento.cc_2 := SUBSTR(Lr_DetAsiento.Centro_Costo, 4, 3);
        Lr_DetAsiento.cc_3 := SUBSTR(Lr_DetAsiento.Centro_Costo, 7, 3);
      
        Lr_DetAsiento.Cuenta := Lr_MigraDetalle.Id_Cuenta_Contable;
      
        IF Lr_MigraDetalle.Debe > 0 THEN
          Lr_DetAsiento.tipo      := 'D';
          Lr_DetAsiento.monto     := Lr_MigraDetalle.Debe;
          Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Debe;
        ELSIF Lr_MigraDetalle.Haber > 0 THEN
          Lr_DetAsiento.tipo      := 'C';
          Lr_DetAsiento.monto     := Lr_MigraDetalle.Haber * -1;
          Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Haber * -1;
        ELSIF Lr_MigraDetalle.Debe = '0' THEN
          Lr_DetAsiento.tipo      := 'D';
          Lr_DetAsiento.monto     := Lr_MigraDetalle.Haber * -1;
          Lr_DetAsiento.monto_dol := Lr_MigraDetalle.Haber * -1;
        
        END IF;
        ---
        Lr_DetAsiento.Codigo_Tercero := Lr_DetAsiento.Codigo_Tercero || ' ' || Lr_MigrAsiento.Codigo_Asiento || ' ' || Lr_MigrAsiento.Id_Asiento;
        CGK_MIGRACION_MEGA.CGP_INSERTA_DETALLE(Lr_DetAsiento, --
                                               Pv_MensajeError);
        ---
        IF Pv_MensajeError IS NOT NULL THEN
          Pv_MensajeError := Pv_MensajeError || ' ASIENTO ' || Lr_MigrAsiento.ID_ASIENTO || ' , codigo ' || Lr_MigrAsiento.Codigo_Asiento;
          RAISE Le_Error;
        END IF;
      
      END LOOP;
      --
      UPDATE CG_M_ASIENTO_CONTABLE
         SET ID_ASIENTO_NAF = Lr_CabAsiento.No_Asiento
       WHERE ID_ASIENTO = Lr_MigrAsiento.Id_Asiento
         AND COMPANIA = '15';
      --
      Lr_CabAsiento := NULL;
      IF C_TotalesCab%ISOPEN THEN
        CLOSE C_TotalesCab;
      END IF;
      OPEN C_TotalesCab(Pv_IdEmpresa, --
                        Lr_CabAsiento.No_Asiento);
      FETCH C_TotalesCab
        INTO Lr_CabAsiento;
      CLOSE C_TotalesCab;
      IF ROUND(NVL(Lr_CabAsiento.t_Debitos, 0), 2) <> ROUND(NVL(Lr_CabAsiento.t_Creditos, 0), 2) THEN
        Pv_MensajeError := 'Error de Total Credito y Debito en el Asiento ' || Lr_CabAsiento.No_Asiento || ' en el T. Credito ' || ROUND(NVL(Lr_CabAsiento.t_Creditos, 0), 2) || ' y T. Debido ' || ROUND(NVL(Lr_CabAsiento.t_Debitos, 0), 2);
        RAISE Le_Error;
      END IF;
      --
      Lr_DetAsiento := NULL;
      IF C_TotalesDet%ISOPEN THEN
        CLOSE C_TotalesDet;
      END IF;
      OPEN C_TotalesDet(Pv_IdEmpresa, --
                        Lr_CabAsiento.No_Asiento);
      FETCH C_TotalesDet
        INTO Lr_DetAsientoTot;
      CLOSE C_TotalesDet;
      --
      IF ROUND(NVL(Lr_DetAsientoTot.DEBITO, 0), 2) <> ROUND(NVL(Lr_DetAsientoTot.CREDITO, 0), 2) THEN
        Pv_MensajeError := 'El Detalle de Asiento ' || Lr_CabAsiento.No_Asiento || 'difiere con Total Credito ' || ROUND(NVL(Lr_DetAsientoTot.CREDITO, 0), 2) || ' y Total Debido ' || ROUND(NVL(Lr_DetAsientoTot.DEBITO, 0), 2);
        RAISE Le_Error;
      END IF;
      --
      IF Lr_CabAsiento.t_Creditos <> ROUND(NVL(Lr_DetAsientoTot.CREDITO, 0), 2) THEN
        Pv_MensajeError := 'El Asiento ' || Lr_CabAsiento.No_Asiento || ' con T. Credito' || Lr_CabAsiento.t_Creditos || ' y T. Debido del Detalle Diefieren ' || ROUND(NVL(Lr_DetAsientoTot.CREDITO, 0), 2);
        RAISE Le_Error;
      END IF;
      ---
      IF Lr_CabAsiento.t_debitos <> ROUND(NVL(Lr_DetAsientoTot.DEBITO, 0), 2) THEN
        Pv_MensajeError := 'El Asiento ' || Lr_CabAsiento.No_Asiento || ' con T. Debito' || Lr_CabAsiento.t_Debitos || ' y T. Debido del Detalle Diefieren ' || ROUND(NVL(Lr_DetAsientoTot.DEBITO, 0), 2);
        RAISE Le_Error;
      END IF;
      --
      UPDATE CG_M_ASIENTO_CONTABLE AC
         SET AC.MIGRADO = 'S'
       WHERE AC.Id_Asiento = Lr_MigrAsiento.Id_Asiento
         AND AC.COMPANIA = Pv_IdEmpresa;
      --
    END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_MIGRA_TIPOS_DIARIOS ' || SQLCODE || ' - ' || SQLERRM;
      ROLLBACK;
  END CGP_MIGRA_TIPOS_DIARIOS;

  --Procedimiento que inserta la distribucion iva
  PROCEDURE CGP_INSERTA_DET_IVA(Pr_DistribucionIVA IN CP_DETALLE_TRIBUTO_IVA%ROWTYPE,
                                Pv_MensajeError    OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    INSERT INTO CP_DETALLE_TRIBUTO_IVA
      (ID_EMPRESA,
       ID_TIPO_DOCUMENTO,
       ID_DOCUMENTO,
       ID_SUSTENTO,
       PORCENTAJE,
       MONTO_BASE_IVA,
       MONTO_BASE_CERO,
       MONTO_IVA,
       MONTO_NETO,
       MONTO_TOTAL,
       COMENTARIO,
       USUARIO_CREA,
       FECHA_CREA,
       APLICA_CREDITO_IVA,
       PORCENTAJE_RETENCION,
       ID_TIPO_TRANSACCION,
       MONTO_BASE_RETENCION,
       MONTO_IVA_RETENCION,
       MONTO_TOTAL_RETENCION,
       SECUENCIA)
    VALUES
      (Pr_DistribucionIVA.ID_EMPRESA,
       Pr_DistribucionIVA.ID_TIPO_DOCUMENTO,
       Pr_DistribucionIVA.ID_DOCUMENTO,
       Pr_DistribucionIVA.ID_SUSTENTO,
       Pr_DistribucionIVA.PORCENTAJE,
       Pr_DistribucionIVA.MONTO_BASE_IVA,
       Pr_DistribucionIVA.MONTO_BASE_CERO,
       Pr_DistribucionIVA.MONTO_IVA,
       Pr_DistribucionIVA.MONTO_NETO,
       Pr_DistribucionIVA.MONTO_TOTAL,
       Pr_DistribucionIVA.COMENTARIO,
       Pr_DistribucionIVA.USUARIO_CREA,
       Pr_DistribucionIVA.FECHA_CREA,
       Pr_DistribucionIVA.APLICA_CREDITO_IVA,
       Pr_DistribucionIVA.PORCENTAJE_RETENCION,
       Pr_DistribucionIVA.ID_TIPO_TRANSACCION,
       Pr_DistribucionIVA.MONTO_BASE_RETENCION,
       Pr_DistribucionIVA.MONTO_IVA_RETENCION,
       Pr_DistribucionIVA.MONTO_TOTAL_RETENCION,
       Pr_DistribucionIVA.Secuencia);
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_DET_IVA. ' || SQLCODE || ' ' || SQLERRM;
      ROLLBACK;
    
  END CGP_INSERTA_DET_IVA;
  PROCEDURE CGP_INSERTA_DOCUMENTO(Pr_Documentos   IN ARCPMD%ROWTYPE,
                                  Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCPMD
      (NO_CIA,
       NO_PROVE,
       TIPO_DOC,
       NO_DOCU,
       IND_ACT,
       NO_FISICO,
       SERIE_FISICO,
       IND_OTROMOV,
       FECHA,
       SUBTOTAL,
       MONTO,
       SALDO,
       GRAVADO,
       EXCENTOS,
       DESCUENTO,
       TOT_REFER,
       TOT_DB,
       TOT_CR,
       FECHA_VENCE,
       DESC_C,
       NO_ORDEN,
       DESC_P,
       PLAZO_C,
       PLAZO_P,
       BLOQUEADO,
       MOTIVO,
       MONEDA,
       TIPO_CAMBIO,
       MONTO_NOMINAL,
       SALDO_NOMINAL,
       TIPO_COMPRA,
       MONTO_BIENES,
       MONTO_SERV,
       MONTO_IMPORTAC,
       NO_CTA,
       NO_SECUENCIA,
       T_CAMB_C_V,
       DETALLE,
       IND_OTROS_MESES,
       FECHA_DOCUMENTO,
       FECHA_VENCE_ORIGINAL,
       CANT_PRORROGAS,
       ORIGEN,
       NUMERO_CTRL,
       ANULADO,
       USUARIO_ANULA,
       MOTIVO_ANULA,
       COD_ESTADO,
       IND_ESTADO_VENCIDO,
       ANO_ANULADO,
       MES_ANULADO,
       TOT_DPP,
       TOT_IMP,
       TOT_RET,
       TOT_IMP_ESPECIAL,
       COD_DIARIO,
       TOT_RET_ESPECIAL,
       N_DOCU_A,
       CONCEPTO,
       CODIGO_SUSTENTO,
       NO_AUTORIZACION,
       DERECHO_DEVOLUCION_IVA,
       FECHA_CADUCIDAD,
       FECHA_ACTUALIZACION,
       COMP_RET,
       IND_IMPRESION_RET,
       IND_REIMPRESION_RET,
       USUARIO,
       MONTO_FISICO,
       PEDIDO,
       NO_AUTORIZACION_COMP,
       FECHA_VALIDEZ,
       FECHA_VALIDEZ_COMP,
       TIPO_FACTURA,
       TIPO_HIST,
       FECHA_ANULA,
       USUARIO_ACTUALIZA,
       FACTURA_GASTO,
       COMPRA_ACTIVO,
       NO_RETENC_IVA,
       NO_RETENC_FUENTE,
       COMP_RET_SERIE,
       COMP_RET_ANULADA,
       EXCENTO_BIENES,
       EXCENTO_SERV,
       FACTURA_EVENTUAL,
       TIPO_RET,
       COD_VENDEDOR,
       TARJETA_CORP,
       PLAZO_C1,
       FECHA_VENCE1,
       DIRIGIDO,
       NUMERO_PAGOS,
       TIPO_COMPROBANTE,
       CODIGO_DESTINO,
       NO_AUTORIZACION_IMPRENTA,
       CENTRO,
       REFERENCIA,
       TOTAL_BRUTO_INVENTARIOS,
       DESCUENTO_INVENTARIO,
       SRI_RETIMP_RENTA,
       NO_EMBARQUE,
       VERIFICADOR,
       CORRELATIVO,
       CODIGO_REGIMEN,
       CODIGO_DISTRITO,
       ID_PRESUPUESTO,
       CLAVE_ACCESO,
       DETALLE_RECHAZO,
       NOMBRE_ARCHIVO,
       FECHA_RETENCION)
    VALUES
      (Pr_Documentos.NO_CIA,
       Pr_Documentos.NO_PROVE,
       Pr_Documentos.TIPO_DOC,
       Pr_Documentos.NO_DOCU,
       Pr_Documentos.IND_ACT,
       Pr_Documentos.NO_FISICO,
       Pr_Documentos.SERIE_FISICO,
       Pr_Documentos.IND_OTROMOV,
       Pr_Documentos.FECHA,
       Pr_Documentos.SUBTOTAL,
       Pr_Documentos.MONTO,
       Pr_Documentos.SALDO,
       Pr_Documentos.GRAVADO,
       Pr_Documentos.EXCENTOS,
       Pr_Documentos.DESCUENTO,
       Pr_Documentos.TOT_REFER,
       Pr_Documentos.TOT_DB,
       Pr_Documentos.TOT_CR,
       Pr_Documentos.FECHA_VENCE,
       Pr_Documentos.DESC_C,
       Pr_Documentos.NO_ORDEN,
       Pr_Documentos.DESC_P,
       Pr_Documentos.PLAZO_C,
       Pr_Documentos.PLAZO_P,
       Pr_Documentos.BLOQUEADO,
       Pr_Documentos.MOTIVO,
       Pr_Documentos.MONEDA,
       Pr_Documentos.TIPO_CAMBIO,
       Pr_Documentos.MONTO_NOMINAL,
       Pr_Documentos.SALDO_NOMINAL,
       Pr_Documentos.TIPO_COMPRA,
       Pr_Documentos.MONTO_BIENES,
       Pr_Documentos.MONTO_SERV,
       Pr_Documentos.MONTO_IMPORTAC,
       Pr_Documentos.NO_CTA,
       Pr_Documentos.NO_SECUENCIA,
       Pr_Documentos.T_CAMB_C_V,
       Pr_Documentos.DETALLE,
       Pr_Documentos.IND_OTROS_MESES,
       Pr_Documentos.FECHA_DOCUMENTO,
       Pr_Documentos.FECHA_VENCE_ORIGINAL,
       Pr_Documentos.CANT_PRORROGAS,
       Pr_Documentos.ORIGEN,
       Pr_Documentos.NUMERO_CTRL,
       Pr_Documentos.ANULADO,
       Pr_Documentos.USUARIO_ANULA,
       Pr_Documentos.MOTIVO_ANULA,
       Pr_Documentos.COD_ESTADO,
       Pr_Documentos.IND_ESTADO_VENCIDO,
       Pr_Documentos.ANO_ANULADO,
       Pr_Documentos.MES_ANULADO,
       Pr_Documentos.TOT_DPP,
       Pr_Documentos.TOT_IMP,
       Pr_Documentos.TOT_RET,
       Pr_Documentos.TOT_IMP_ESPECIAL,
       Pr_Documentos.COD_DIARIO,
       Pr_Documentos.TOT_RET_ESPECIAL,
       Pr_Documentos.N_DOCU_A,
       Pr_Documentos.CONCEPTO,
       Pr_Documentos.CODIGO_SUSTENTO,
       Pr_Documentos.NO_AUTORIZACION,
       Pr_Documentos.DERECHO_DEVOLUCION_IVA,
       Pr_Documentos.FECHA_CADUCIDAD,
       Pr_Documentos.FECHA_ACTUALIZACION,
       Pr_Documentos.COMP_RET,
       Pr_Documentos.IND_IMPRESION_RET,
       Pr_Documentos.IND_REIMPRESION_RET,
       Pr_Documentos.USUARIO,
       Pr_Documentos.MONTO_FISICO,
       Pr_Documentos.PEDIDO,
       Pr_Documentos.NO_AUTORIZACION_COMP,
       Pr_Documentos.FECHA_VALIDEZ,
       Pr_Documentos.FECHA_VALIDEZ_COMP,
       Pr_Documentos.TIPO_FACTURA,
       Pr_Documentos.TIPO_HIST,
       Pr_Documentos.FECHA_ANULA,
       Pr_Documentos.USUARIO_ACTUALIZA,
       Pr_Documentos.FACTURA_GASTO,
       Pr_Documentos.COMPRA_ACTIVO,
       Pr_Documentos.NO_RETENC_IVA,
       Pr_Documentos.NO_RETENC_FUENTE,
       Pr_Documentos.COMP_RET_SERIE,
       Pr_Documentos.COMP_RET_ANULADA,
       Pr_Documentos.EXCENTO_BIENES,
       Pr_Documentos.EXCENTO_SERV,
       Pr_Documentos.FACTURA_EVENTUAL,
       Pr_Documentos.TIPO_RET,
       Pr_Documentos.COD_VENDEDOR,
       Pr_Documentos.TARJETA_CORP,
       Pr_Documentos.PLAZO_C1,
       Pr_Documentos.FECHA_VENCE1,
       Pr_Documentos.DIRIGIDO,
       Pr_Documentos.NUMERO_PAGOS,
       Pr_Documentos.TIPO_COMPROBANTE,
       Pr_Documentos.CODIGO_DESTINO,
       Pr_Documentos.NO_AUTORIZACION_IMPRENTA,
       Pr_Documentos.CENTRO,
       Pr_Documentos.REFERENCIA,
       Pr_Documentos.TOTAL_BRUTO_INVENTARIOS,
       Pr_Documentos.DESCUENTO_INVENTARIO,
       Pr_Documentos.SRI_RETIMP_RENTA,
       Pr_Documentos.NO_EMBARQUE,
       Pr_Documentos.VERIFICADOR,
       Pr_Documentos.CORRELATIVO,
       Pr_Documentos.CODIGO_REGIMEN,
       Pr_Documentos.CODIGO_DISTRITO,
       Pr_Documentos.ID_PRESUPUESTO,
       Pr_Documentos.CLAVE_ACCESO,
       Pr_Documentos.DETALLE_RECHAZO,
       Pr_Documentos.NOMBRE_ARCHIVO,
       Pr_Documentos.FECHA_RETENCION);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_DOCUMENTO ' || SQLCODE || ' - ' || SQLERRM;
  END CGP_INSERTA_DOCUMENTO;
  --
  PROCEDURE CGP_INSERTA_DET_CONTABLE(Pr_DetalleContable IN ARCPDC%ROWTYPE,
                                     Pv_MensajeError    OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCPDC
      (NO_CIA,
       NO_PROVE,
       TIPO_DOC,
       NO_DOCU,
       CODIGO,
       TIPO,
       MONTO,
       MES,
       ANO,
       IND_CON,
       MONTO_DOL,
       MONEDA,
       TIPO_CAMBIO,
       NO_ASIENTO,
       CENTRO_COSTO,
       MODIFICABLE,
       CODIGO_TERCERO,
       MONTO_DC,
       GLOSA,
       EXCEDE_PRESUPUESTO)
    VALUES
      (Pr_DetalleContable.NO_CIA,
       Pr_DetalleContable.NO_PROVE,
       Pr_DetalleContable.TIPO_DOC,
       Pr_DetalleContable.NO_DOCU,
       Pr_DetalleContable.CODIGO,
       Pr_DetalleContable.TIPO,
       Pr_DetalleContable.MONTO,
       Pr_DetalleContable.MES,
       Pr_DetalleContable.ANO,
       Pr_DetalleContable.IND_CON,
       Pr_DetalleContable.MONTO_DOL,
       Pr_DetalleContable.MONEDA,
       Pr_DetalleContable.TIPO_CAMBIO,
       Pr_DetalleContable.NO_ASIENTO,
       Pr_DetalleContable.CENTRO_COSTO,
       Pr_DetalleContable.MODIFICABLE,
       Pr_DetalleContable.CODIGO_TERCERO,
       Pr_DetalleContable.MONTO_DC,
       Pr_DetalleContable.GLOSA,
       Pr_DetalleContable.EXCEDE_PRESUPUESTO);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_DET_CONTABLE ' || SQLCODE || ' - ' || SQLERRM;
  END CGP_INSERTA_DET_CONTABLE;
  PROCEDURE CGP_INSERTA_RETENCIONES(Pr_Retenciones  IN ARCPTI%ROWTYPE,
                                    Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCPTI
      (NO_CIA,
       NO_PROVE,
       TIPO_DOC,
       NO_DOCU,
       CLAVE,
       PORCENTAJE,
       MONTO,
       IND_IMP_RET,
       APLICA_CRED_FISCAL,
       BASE,
       CODIGO_TERCERO,
       COMPORTAMIENTO,
       ID_SEC,
       NO_REFE,
       SECUENCIA_RET,
       ANULADA,
       FECHA_IMPRIME,
       SRI_RETIMP_RENTA,
       SERVICIO_BIENES,
       AUTORIZACION,
       FECHA_ANULA,
       BASE_GRAVADA,
       BASE_EXCENTA)
    VALUES
      (Pr_Retenciones.NO_CIA,
       Pr_Retenciones.NO_PROVE,
       Pr_Retenciones.TIPO_DOC,
       Pr_Retenciones.NO_DOCU,
       Pr_Retenciones.CLAVE,
       Pr_Retenciones.PORCENTAJE,
       Pr_Retenciones.MONTO,
       Pr_Retenciones.IND_IMP_RET,
       Pr_Retenciones.APLICA_CRED_FISCAL,
       Pr_Retenciones.BASE,
       Pr_Retenciones.CODIGO_TERCERO,
       Pr_Retenciones.COMPORTAMIENTO,
       Pr_Retenciones.ID_SEC,
       Pr_Retenciones.NO_REFE,
       Pr_Retenciones.SECUENCIA_RET,
       Pr_Retenciones.ANULADA,
       Pr_Retenciones.FECHA_IMPRIME,
       Pr_Retenciones.SRI_RETIMP_RENTA,
       Pr_Retenciones.SERVICIO_BIENES,
       Pr_Retenciones.AUTORIZACION,
       Pr_Retenciones.FECHA_ANULA,
       Pr_Retenciones.BASE_GRAVADA,
       Pr_Retenciones.BASE_EXCENTA);
  
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_RETENCIONES ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_RETENCIONES;
  --
  PROCEDURE CGP_INSERTA_ARCKCE(Pr_Arckce       IN ARCKCE%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2) IS
  
  BEGIN
    INSERT INTO ARCKCE
      (NO_CIA,
       NO_CTA,
       TIPO_DOCU,
       NO_SECUENCIA,
       CHEQUE,
       SERIE_FISICO,
       FECHA,
       MONTO,
       BENEFICIARIO,
       IND_ACT,
       COM,
       IND_CON,
       NO_PROVE,
       ANULADO,
       FECHA_ANULADO,
       EMITIDO,
       TOT_REF,
       TOT_DIFE_CAM,
       TOT_DB,
       TOT_CR,
       SALDO,
       MONEDA_CTA,
       TIPO_CAMBIO,
       MONTO_NOMINAL,
       SALDO_NOMINAL,
       AUTORIZA,
       ORIGEN,
       T_CAMB_C_V,
       NO_ASIENTO,
       UBICACION,
       FECHA_VENCE,
       TOT_DPP,
       NUMERO_CTRL,
       TIPO_TRANSFE,
       BANCO_TRANSFE,
       CTA_BCO_TRANSFE,
       IND_NEGOCIABLE,
       IND_RETENCION,
       MONEDA_PAGO,
       USUARIO_CREACION,
       USUARIO_MODIFICACION,
       FECHA_ACTUALIZA,
       TIPO_D,
       IND_GEN_ARCH,
       ID_PRESUPUESTO,
       PAGO_ORDEN_COMPRA,
       ID_PROV_ORDEN)
    VALUES
      (Pr_Arckce.No_Cia,
       Pr_Arckce.NO_CTA,
       Pr_Arckce.TIPO_DOCU,
       Pr_Arckce.NO_SECUENCIA,
       Pr_Arckce.CHEQUE,
       Pr_Arckce.SERIE_FISICO,
       Pr_Arckce.FECHA,
       Pr_Arckce.MONTO,
       Pr_Arckce.BENEFICIARIO,
       Pr_Arckce.IND_ACT,
       Pr_Arckce.COM,
       Pr_Arckce.IND_CON,
       Pr_Arckce.NO_PROVE,
       Pr_Arckce.ANULADO,
       Pr_Arckce.FECHA_ANULADO,
       Pr_Arckce.EMITIDO,
       Pr_Arckce.TOT_REF,
       Pr_Arckce.TOT_DIFE_CAM,
       Pr_Arckce.TOT_DB,
       Pr_Arckce.TOT_CR,
       Pr_Arckce.SALDO,
       Pr_Arckce.MONEDA_CTA,
       Pr_Arckce.TIPO_CAMBIO,
       Pr_Arckce.MONTO_NOMINAL,
       Pr_Arckce.SALDO_NOMINAL,
       Pr_Arckce.AUTORIZA,
       Pr_Arckce.ORIGEN,
       Pr_Arckce.T_CAMB_C_V,
       Pr_Arckce.NO_ASIENTO,
       Pr_Arckce.UBICACION,
       Pr_Arckce.FECHA_VENCE,
       Pr_Arckce.TOT_DPP,
       Pr_Arckce.NUMERO_CTRL,
       Pr_Arckce.TIPO_TRANSFE,
       Pr_Arckce.BANCO_TRANSFE,
       Pr_Arckce.CTA_BCO_TRANSFE,
       Pr_Arckce.IND_NEGOCIABLE,
       Pr_Arckce.IND_RETENCION,
       Pr_Arckce.MONEDA_PAGO,
       Pr_Arckce.USUARIO_CREACION,
       Pr_Arckce.USUARIO_MODIFICACION,
       Pr_Arckce.FECHA_ACTUALIZA,
       Pr_Arckce.TIPO_D,
       Pr_Arckce.IND_GEN_ARCH,
       Pr_Arckce.ID_PRESUPUESTO,
       Pr_Arckce.PAGO_ORDEN_COMPRA,
       Pr_Arckce.ID_PROV_ORDEN);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKCE ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCKCE;
  ---
  PROCEDURE CGP_INSERTA_ARCKCL(Pr_Arckcl       IN ARCKCL%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCKCL
      (NO_CIA,
       NO_SECUENCIA,
       TIPO_DOCU,
       COD_CONT,
       CENTRO_COSTO,
       CODIGO_TERCERO,
       TIPO_MOV,
       MONTO,
       MONTO_DOL,
       MONEDA,
       NO_ASIENTO,
       TIPO_CAMBIO,
       MODIFICABLE,
       IND_CON,
       ANO,
       MES,
       MONTO_DC,
       GLOSA,
       EXCEDE_PRESUPUESTO)
    VALUES
      (Pr_Arckcl.NO_CIA,
       Pr_Arckcl.NO_SECUENCIA,
       Pr_Arckcl.TIPO_DOCU,
       Pr_Arckcl.COD_CONT,
       Pr_Arckcl.CENTRO_COSTO,
       Pr_Arckcl.CODIGO_TERCERO,
       Pr_Arckcl.TIPO_MOV,
       Pr_Arckcl.MONTO,
       Pr_Arckcl.MONTO_DOL,
       Pr_Arckcl.MONEDA,
       Pr_Arckcl.NO_ASIENTO,
       Pr_Arckcl.TIPO_CAMBIO,
       Pr_Arckcl.MODIFICABLE,
       Pr_Arckcl.IND_CON,
       Pr_Arckcl.ANO,
       Pr_Arckcl.MES,
       Pr_Arckcl.MONTO_DC,
       Pr_Arckcl.GLOSA,
       Pr_Arckcl.EXCEDE_PRESUPUESTO);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKCL ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCKCL;
  --
  --
  PROCEDURE CGP_INSERTA_ARCKRD(Pr_Arckrd       IN ARCKRD%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCKRD
      (NO_CIA,
       TIPO_DOCU,
       NO_SECUENCIA,
       TIPO_REFE,
       NO_REFE,
       NO_PROVE,
       MONTO,
       BCO_PROVE,
       CTA_BCO_PROVE,
       MONEDA_REFE,
       MONTO_REFE,
       DESCUENTO_PP,
       DESCUENTO_PP_REFE,
       ID_PRESUPUESTO)
    VALUES
      (Pr_Arckrd.NO_CIA,
       Pr_Arckrd.TIPO_DOCU,
       Pr_Arckrd.NO_SECUENCIA,
       Pr_Arckrd.TIPO_REFE,
       Pr_Arckrd.NO_REFE,
       Pr_Arckrd.NO_PROVE,
       Pr_Arckrd.MONTO,
       Pr_Arckrd.BCO_PROVE,
       Pr_Arckrd.CTA_BCO_PROVE,
       Pr_Arckrd.MONEDA_REFE,
       Pr_Arckrd.MONTO_REFE,
       Pr_Arckrd.DESCUENTO_PP,
       Pr_Arckrd.DESCUENTO_PP_REFE,
       Pr_Arckrd.ID_PRESUPUESTO);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKRD ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCKRD;
  PROCEDURE CGP_INSERTA_ARCKMM(Pr_Arckmm       IN ARCKMM%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCKMM
      (NO_CIA,
       NO_CTA,
       PROCEDENCIA,
       TIPO_DOC,
       NO_DOCU,
       FECHA,
       BENEFICIARIO,
       COMENTARIO,
       MONTO,
       DESCUENTO_PP,
       ESTADO,
       CONCILIADO,
       MES,
       ANO,
       FECHA_ANULADO,
       IND_BORRADO,
       IND_OTROMOV,
       MONEDA_CTA,
       TIPO_CAMBIO,
       TIPO_AJUSTE,
       IND_DIST,
       T_CAMB_C_V,
       IND_OTROS_MESES,
       MES_CONCILIADO,
       ANO_CONCILIADO,
       NO_FISICO,
       SERIE_FISICO,
       IND_CON,
       NUMERO_CTRL,
       ORIGEN,
       USUARIO_CREACION,
       USUARIO_ANULA,
       USUARIO_ACTUALIZA,
       FECHA_ACTUALIZA,
       FECHA_DOC,
       IND_DIVISION,
       COD_DIVISION,
       TIME_STAMP)
    VALUES
      (Pr_Arckmm.NO_CIA,
       Pr_Arckmm.NO_CTA,
       Pr_Arckmm.PROCEDENCIA,
       Pr_Arckmm.TIPO_DOC,
       Pr_Arckmm.NO_DOCU,
       Pr_Arckmm.FECHA,
       Pr_Arckmm.BENEFICIARIO,
       Pr_Arckmm.COMENTARIO,
       Pr_Arckmm.MONTO,
       Pr_Arckmm.DESCUENTO_PP,
       Pr_Arckmm.ESTADO,
       Pr_Arckmm.CONCILIADO,
       Pr_Arckmm.MES,
       Pr_Arckmm.ANO,
       Pr_Arckmm.FECHA_ANULADO,
       Pr_Arckmm.IND_BORRADO,
       Pr_Arckmm.IND_OTROMOV,
       Pr_Arckmm.MONEDA_CTA,
       Pr_Arckmm.TIPO_CAMBIO,
       Pr_Arckmm.TIPO_AJUSTE,
       Pr_Arckmm.IND_DIST,
       Pr_Arckmm.T_CAMB_C_V,
       Pr_Arckmm.IND_OTROS_MESES,
       Pr_Arckmm.MES_CONCILIADO,
       Pr_Arckmm.ANO_CONCILIADO,
       Pr_Arckmm.NO_FISICO,
       Pr_Arckmm.SERIE_FISICO,
       Pr_Arckmm.IND_CON,
       Pr_Arckmm.NUMERO_CTRL,
       Pr_Arckmm.ORIGEN,
       Pr_Arckmm.USUARIO_CREACION,
       Pr_Arckmm.USUARIO_ANULA,
       Pr_Arckmm.USUARIO_ACTUALIZA,
       Pr_Arckmm.FECHA_ACTUALIZA,
       Pr_Arckmm.FECHA_DOC,
       Pr_Arckmm.IND_DIVISION,
       Pr_Arckmm.COD_DIVISION,
       Pr_Arckmm.TIME_STAMP);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKMM ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCKMM;
  ---
  PROCEDURE CGP_INSERTA_ARCKML(Pr_Arckml       IN ARCKML%ROWTYPE,
                               Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    INSERT INTO ARCKML
      (NO_CIA,
       PROCEDENCIA,
       TIPO_DOC,
       NO_DOCU,
       COD_CONT,
       CENTRO_COSTO,
       TIPO_MOV,
       MONTO,
       MONTO_DOL,
       TIPO_CAMBIO,
       MONEDA,
       NO_ASIENTO,
       MODIFICABLE,
       CODIGO_TERCERO,
       IND_CON,
       ANO,
       MES,
       MONTO_DC,
       GLOSA,
       EXCEDE_PRESUPUESTO)
    VALUES
      (Pr_Arckml.NO_CIA,
       Pr_Arckml.PROCEDENCIA,
       Pr_Arckml.TIPO_DOC,
       Pr_Arckml.NO_DOCU,
       Pr_Arckml.COD_CONT,
       Pr_Arckml.CENTRO_COSTO,
       Pr_Arckml.TIPO_MOV,
       Pr_Arckml.MONTO,
       Pr_Arckml.MONTO_DOL,
       Pr_Arckml.TIPO_CAMBIO,
       Pr_Arckml.MONEDA,
       Pr_Arckml.NO_ASIENTO,
       Pr_Arckml.MODIFICABLE,
       Pr_Arckml.CODIGO_TERCERO,
       Pr_Arckml.IND_CON,
       Pr_Arckml.ANO,
       Pr_Arckml.MES,
       Pr_Arckml.MONTO_DC,
       Pr_Arckml.GLOSA,
       Pr_Arckml.EXCEDE_PRESUPUESTO);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKMM ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCKML;

  PROCEDURE CGP_CONSULTA_DESCUADRE(Pv_IdEmpresa    IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2) IS
    --
    CURSOR C_LeeFACT(Cv_IdEmpresa IN VARCHAR2) IS
      SELECT NVL(D.TOT_DB, 0) TOTAL_DEBITOS,
             NVL(D.TOT_CR, 0) TOTAL_CREDITOS,
             D.TIPO_DOC,
             D.NO_DOCU,
             d.no_prove
        FROM ARCPMD D
       WHERE NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeDistCont(Cv_IdEmpresa       IN VARCHAR2,
                         Cv_IdDocumento     IN VARCHAR2,
                         Cv_IdTipoDocumento IN VARCHAR2) IS
      SELECT NVL(SUM(DECODE(TIPO, 'D', MONTO, 0)), 0) DEBITO,
             NVL(SUM(DECODE(TIPO, 'C', 0, MONTO)), 0) CREDITO
        FROM ARCPDC
       WHERE NO_DOCU = Cv_IdDocumento
         AND TIPO_DOC = Cv_IdTipoDocumento
         AND NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeCheques(Cv_IdEmpresa IN VARCHAR2) IS
      SELECT NVL(CK.TOT_DB, 0) TOTAL_DEBITOS,
             NVL(CK.TOT_CR, 0) TOTAL_CREDITOS,
             CK.TIPO_DOCU,
             CK.NO_SECUENCIA
        FROM ARCKCE CK
       WHERE NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeDetCheques(Cv_IdEmpresa     IN VARCHAR2,
                           Cv_IdDocumento   IN VARCHAR2,
                           Cv_TipoDocumento IN VARCHAR2) IS
      SELECT NVL(SUM(DECODE(TIPO_MOV, 'D', MONTO, 0)), 0) DEBITO,
             NVL(SUM(DECODE(TIPO_MOV, 'C', 0, MONTO)), 0) CREDITO
        FROM ARCKCL
       WHERE NO_SECUENCIA = Cv_IdDocumento
         AND TIPO_DOCU = Cv_TipoDocumento
         AND NO_CIA = Cv_IdEmpresa;
    --
    Lr_TotalesDetFact C_LeeDistCont%ROWTYPE := NULL;
    Lr_TotalesDetChe  C_LeeDistCont%ROWTYPE := NULL;
    Le_Error EXCEPTION;
  BEGIN
    Pv_MensajeError := NULL;
    FOR A IN C_LeeFACT(Pv_IdEmpresa) LOOP
      IF C_LeeDistCont%ISOPEN THEN
        CLOSE C_LeeDistCont;
      END IF;
      OPEN C_LeeDistCont(Pv_IdEmpresa, --
                         A.NO_DOCU,
                         A.TIPO_DOC);
      FETCH C_LeeDistCont
        INTO Lr_TotalesDetFact;
      CLOSE C_LeeDistCont;
      --
      IF ROUND(NVL(Lr_TotalesDetFact.DEBITO, 0), 2) <> ROUND(NVL(Lr_TotalesDetFact.CREDITO, 0), 2) THEN
        Pv_MensajeError := '1.- Proveedor ' || A.NO_PROVE || 'El Detalle de Factura ' || A.NO_DOCU || ' difiere con Total Credito ' || ROUND(NVL(Lr_TotalesDetFact.CREDITO, 0), 2) || ' y Total Debido ' || ROUND(NVL(Lr_TotalesDetFact.DEBITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      --
      IF A.TOTAL_CREDITOS <> ROUND(NVL(Lr_TotalesDetFact.CREDITO, 0), 2) THEN
        Pv_MensajeError := '2.- Proveedor: ' || A.NO_PROVE || ' Cab. Creditos con Det. Creditos Error, La Factura ' || a.no_docu || ' con T. Credito ' || A.TOTAL_CREDITOS || ' y T. Debido del Detalle Difieren ' || ROUND(NVL(Lr_TotalesDetFact.CREDITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      ---
      IF A.TOTAL_DEBITOS <> ROUND(NVL(Lr_TotalesDetFact.DEBITO, 0), 2) THEN
        Pv_MensajeError := '3. Proveedor: ' || A.NO_PROVE || 'Cab. Debitos con Det. Debito Error, La Factura ' || a.no_docu || ' con T. Debito ' || A.TOTAL_DEBITOS || ' y T. Debido del Detalle Difieren ' || ROUND(NVL(Lr_TotalesDetFact.DEBITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      --
      IF Pv_MensajeError IS NOT NULL THEN
        DBMS_OUTPUT.put_line('Error CGP_CONSULTA_DESCUADRE ' || Pv_MensajeError);
      END IF;
    END LOOP;
    --
    FOR A IN C_LeeCheques(Pv_IdEmpresa) LOOP
      IF C_LeeDetCheques%ISOPEN THEN
        CLOSE C_LeeDetCheques;
      END IF;
      OPEN C_LeeDetCheques(Pv_IdEmpresa, --
                           A.NO_SECUENCIA,
                           A.TIPO_DOCU);
      FETCH C_LeeDetCheques
        INTO Lr_TotalesDetChe;
      CLOSE C_LeeDetCheques;
      --
      IF ROUND(NVL(Lr_TotalesDetChe.DEBITO, 0), 2) <> ROUND(NVL(Lr_TotalesDetChe.CREDITO, 0), 2) THEN
        Pv_MensajeError := 'El Detalle de Cheque ' || A.no_secuencia || 'difiere con Total Credito ' || ROUND(NVL(Lr_TotalesDetFact.CREDITO, 0), 2) || ' y Total Debido ' || ROUND(NVL(Lr_TotalesDetFact.DEBITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      --
      IF A.TOTAL_CREDITOS <> ROUND(NVL(Lr_TotalesDetChe.CREDITO, 0), 2) THEN
        Pv_MensajeError := 'Cab. Creditos con Det. Creditos, Error El Cheque ' || a.no_secuencia || ' con T. Credito' || A.TOTAL_CREDITOS || ' y T. Debido del Detalle Diefieren ' || ROUND(NVL(Lr_TotalesDetChe.CREDITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      ---
      IF A.TOTAL_DEBITOS <> ROUND(NVL(Lr_TotalesDetChe.DEBITO, 0), 2) THEN
        Pv_MensajeError := 'Cab Debitos con Det. Debitos, Error El Cheque ' || a.no_secuencia || ' con T. Debito' || A.TOTAL_DEBITOS || ' y T. Debido del Detalle Diefieren ' || ROUND(NVL(Lr_TotalesDetChe.DEBITO, 0), 2);
        --RAISE Le_Error;
      END IF;
      --
      IF Pv_MensajeError IS NOT NULL THEN
        DBMS_OUTPUT.put_line('Error CGP_CONSULTA_DESCUADRE ' || Pv_MensajeError);
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Error THEN
      --ROLLBACK;
      NULL;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_CONSULTA_DESCUADRE ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_CONSULTA_DESCUADRE;
  --
  PROCEDURE CGP_INICIALIZA(Pv_IdEmpresa    IN VARCHAR2,
                           Pv_Fecha        VARCHAR2,
                           Pv_Inicializa   IN VARCHAR2,
                           Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
    IF Pv_Inicializa IS NOT NULL THEN
      /*BEGIN
        DELETE FROM ARCPMD
          WHERE NO_CIA=Pv_IdEmpresa;
          
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPMD ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPMD '||SQLCODE||' - '||SQLERRM);
      END;*/
      BEGIN
        DELETE FROM ARCPDC
         WHERE NO_CIA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPDC ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPDC ' || SQLCODE || ' - ' || SQLERRM);
      END;
      BEGIN
        DELETE FROM ARCPTI
         WHERE NO_CIA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPTI ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPTI ' || SQLCODE || ' - ' || SQLERRM);
      END;
      BEGIN
        DELETE FROM ARCPRD
         WHERE NO_CIA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPRD  ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPRD ' || SQLCODE || ' - ' || SQLERRM);
      END;
      --
      BEGIN
        DELETE ARCKRD
         WHERE NO_CIA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCKRD ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCKRD ' || SQLCODE || ' - ' || SQLERRM);
      END;
      --
      BEGIN
      
        DELETE FROM CP_DETALLE_TRIBUTO_IVA
         WHERE ID_EMPRESA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en CP_DETALLE_TRIBUTO_IVA ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la CP_DETALLE_TRIBUTO_IVA ' || SQLCODE || ' - ' || SQLERRM);
      END;
      --
      BEGIN
      
        DELETE FROM ARCPMS
         WHERE NO_CIA = Pv_IdEmpresa;
      
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPMS ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPMS ' || SQLCODE || ' - ' || SQLERRM);
      END;
      --09851557149
      --2150535 maria del carmen gonzales..
      --
      BEGIN
        DELETE FROM ARCPMD
         WHERE NO_CIA = Pv_IdEmpresa;
        --
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCPMD ' || SQL%ROWCOUNT);
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCPMD ' || SQLCODE || ' - ' || SQLERRM);
      END;
      BEGIN
        DELETE FROM ARCGAL
         WHERE NO_CIA = Pv_IdEmpresa
           AND ANO = TO_CHAR(TO_DATE(Pv_Fecha, 'DD/MM/YYYY'), 'YYYY')
           AND MES = TO_CHAR(TO_DATE(Pv_Fecha, 'DD/MM/YYYY'), 'MM');
        --AND DESCRI LIKE '%-MIGRA%';
        --SELECT * FROM ARCGAL WHERE NO_ASIENTO='6401' --FOR UPDATE
        --   AND NO_CIA = '15' FOR UPDATE --02072012
        --   AND DESCRI LIKE '%-MIGRA%';--1739*/
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCGAL ' || SQL%ROWCOUNT);
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCGAL ' || SQLCODE || ' - ' || SQLERRM);
      END;
      BEGIN
        DELETE FROM ARCGAE
         WHERE NO_CIA = Pv_IdEmpresa
           AND ANO = TO_CHAR(TO_DATE(Pv_Fecha, 'DD/MM/YYYY'), 'YYYY')
           AND MES = TO_CHAR(TO_DATE(Pv_Fecha, 'DD/MM/YYYY'), 'MM');
        --  AND DESCRI1 LIKE '%-MIGRA%';
      
        /*SELECT C.*,
              (SELECT COUNT(*)
                 FROM ARCGAL D
                WHERE D.NO_CIA = C.NO_CIA
                  AND D.NO_ASIENTO = C.NO_ASIENTO)
         FROM ARCGAE C
        WHERE NO_CIA = '15'  AND ANO=2013 AND MES=1
          AND DESCRI1 LIKE '%-MIGRA%';*/
        IF SQL%ROWCOUNT > 0 THEN
          DBMS_OUTPUT.put_line('Registros borrados en ARCGAE ' || SQL%ROWCOUNT);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          Pv_MensajeError := SQLCODE || ' ' || SQLERRM;
          DBMS_OUTPUT.put_line('Error al Eliminar Registros de la ARCGAE ' || Pv_MensajeError);
      END;
    END IF;
  END CGP_INICIALIZA;

/* PROCEDURE CGP_INSERTA_ARCGAE(Pr_Arcgae       IN ARCGAE%ROWTYPE,
                             Pv_MensajeError OUT VARCHAR2) IS
  BEGIN
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en CGP_INSERTA_ARCKMM ' || SQLCODE || ' - ' || SQLERRM;
    
  END CGP_INSERTA_ARCGAE;*/

END CGK_MIGRACION_MEGA;
/
