CREATE OR REPLACE package NAF47_TNET.CON_PROCESOS_CIERRE_MENSUAL is

/**
 * @author SUD Jimmy Gilces
 * @description Procesos llamados desde el Sistema NAF para el cierre mensual
 * @version 1.0
 * @fecha 20/06/2022 15:16:46
**/

  procedure cierra_contab(pno_cia     IN varchar2,
                          pano        IN number,
                          pmes        IN number,
                          pmes_cierre IN number,
                          pmsg_error  IN OUT varchar2);

  procedure cierra_centros(pno_cia     IN varchar2,
                           pano        IN number,
                           pmes        IN number,
                           pmes_cierre IN number,
                           pmsg_error  IN OUT varchar2);

  PROCEDURE inicia_ctas(pCia            Varchar2,
                        pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                        pMes_Cierre     Number,
                        pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                        pMes_Nuevo      Number,
                        pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                        );

  PROCEDURE inicia_ctas_cc(pCia            Varchar2,
                           pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                           pMes_Cierre     Number,
                           pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                           pMes_Nuevo      Number,
                           pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                           );

  PROCEDURE inicia_ctas_tercero(pCia            Varchar2,
                                pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                                pMes_Cierre     Number,
                                pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                                pMes_Nuevo      Number,
                                pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                                );

  PROCEDURE cierra_1_cc(pno_cia     IN VARCHAR2,
                        pano        IN NUMBER,
                        pmes        IN NUMBER,
                        pmes_cierre IN NUMBER,
                        pcc1        IN VARCHAR2,
                        pcc2        IN VARCHAR2,
                        pcc3        IN VARCHAR2,
                        pmsg_error  IN OUT VARCHAR2);

end CON_PROCESOS_CIERRE_MENSUAL;
/

CREATE or replace package body NAF47_TNET.CON_PROCESOS_CIERRE_MENSUAL is

  procedure cierra_contab(pno_cia     IN varchar2,
                          pano        IN number,
                          pmes        IN number,
                          pmes_cierre IN number,
                          pmsg_error  IN OUT varchar2) is
  
    error_proceso EXCEPTION;
    --
    CURSOR c_datos_cia IS
      SELECT indicador_utilidad FROM NAF47_TNET.arcgmc WHERE no_cia = pno_cia;
    --
    CURSOR CUENTAS IS
      SELECT cuenta,
             DEBITOS,
             CREDITOS,
             SALDO_MES_ANT,
             debitos_dol,
             creditos_dol,
             saldo_mes_ant_dol,
             ROWID
        FROM NAF47_TNET.ARCGMS A
       WHERE A.NO_CIA = pno_cia;
    --
    vind_util NAF47_TNET.arcgmc.indicador_utilidad%type;
    --
    vperiodo       NAF47_TNET.ARCGHC.PERIODO%TYPE;
    vind_c_fiscal  VARCHAR2(1);
    vind_c_periodo VARCHAR2(1);
    vnuevo_ano     NAF47_TNET.ARCGMC.Ano_Proce%type;
    vnuevo_mes     NAF47_TNET.ARCGMC.Mes_Proce%type;
  
  begin
    --:SYSTEM.MESSAGE_LEVEL := 5;
    --
    vperiodo := (pano * 100) + pmes;
    IF pmes >= 12 THEN
      vnuevo_mes := 1;
      vnuevo_ano := pano + 1;
    ELSE
      vnuevo_mes := pmes + 1;
      vnuevo_ano := pano;
    END IF;
  
    --
    OPEN c_datos_cia;
    FETCH c_datos_cia
      INTO vind_util;
    CLOSE c_datos_cia;
    --  
    if vind_util = 'N' then
      CGcalcula_utilidades(pno_cia, pano, pmes, pmsg_error);
      if pmsg_error is not null then
        raise error_proceso;
      end if;
    end if;
  
    --
    -- Actualiza o Crea segun corresponda en ARCGHC basandose en ARCGMS
    -- cuando la cuenta no tuvo movimiento
    FOR RC IN CUENTAS LOOP
      --
      -- Actualiza el Saldo de las cuentas que estan en ARCGHC      
      --
      UPDATE NAF47_TNET.ARCGHC A
         SET A.SALDO     = NVL(RC.SALDO_MES_ANT, 0) + NVL(RC.DEBITOS, 0) +
                         NVL(RC.CREDITOS, 0),
             A.saldo_dol = nvl(rc.saldo_mes_ant_dol, 0) +
                         nvl(rc.debitos_dol, 0) + nvl(rc.creditos_dol, 0)
       WHERE A.NO_CIA = pno_cia
         AND A.ANO = pano
         AND A.MES = pmes
         AND A.CUENTA = RC.CUENTA;
    
      /**************************************************************/
      /* Inserta en ARCGHC las cuentas que no tuvieron movimientos  */
      /**************************************************************/
    
      IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO NAF47_TNET.ARCGHC
          (NO_CIA,
           ANO,
           MES,
           PERIODO,
           CUENTA,
           SALDO,
           SALDO_DOL,
           MOV_DB,
           MOV_CR,
           MOVIMIENTO,
           MOV_DB_DOL,
           MOV_CR_DOL)
        VALUES
          (pno_cia,
           pano,
           pmes,
           vperiodo,
           RC.CUENTA,
           NVL(RC.SALDO_MES_ANT, 0) + NVL(RC.DEBITOS, 0) +
           NVL(RC.CREDITOS, 0),
           nvl(rc.saldo_mes_ant_dol, 0) + nvl(rc.debitos_dol, 0) +
           nvl(rc.creditos_dol, 0),
           NVL(rc.debitos, 0),
           NVL(rc.creditos, 0),
           NVL(RC.debitos, 0) + NVL(RC.creditos, 0),
           NVL(rc.debitos_dol, 0),
           NVL(rc.creditos_dol, 0));
      END IF;
    
      -- --
      -- Actualiza el saldo del mes anterior y limpia el movimiento  
      -- para el siguiente mes                                       
      --     
      UPDATE NAF47_TNET.ARCGMS
         SET saldo_mes_ant     = nvl(saldo_mes_ant, 0) + nvl(debitos, 0) +
                                 nvl(creditos, 0),
             debitos           = 0,
             creditos          = 0,
             saldo_mes_ant_dol = nvl(saldo_mes_ant_dol, 0) +
                                 nvl(debitos_dol, 0) + nvl(creditos_dol, 0),
             debitos_dol       = 0,
             creditos_dol      = 0
       WHERE rowid = rc.rowid;
    
      -- --
      -- Si estamos en el periodo de cierre fiscal tambien se debe
      -- respaldar el saldo del mes anterior como saldo del periodo
      --
      IF pmes = pmes_cierre THEN
        UPDATE NAF47_TNET.arcgms
           SET saldo_per_ant     = saldo_mes_ant,
               saldo_per_ant_dol = saldo_mes_ant_dol
         WHERE rowid = rc.rowid;
      END IF;
    END LOOP;
    --
    cierra_centros(pno_cia, pano, pmes, pmes_cierre, pmsg_error);
  
    if pmsg_error is not null then
      raise error_proceso;
    end if;
  
    -- --
    -- Actualiza el ano y mes en proceso hacia el sigte        
    -- periodo, Si el mes de proceso es igual al mes de ciere  
    -- el indicado de cierre fiscal debe ser actualizado       
    --
    IF pmes = pmes_cierre THEN
      vind_c_fiscal  := 'S';
      vind_c_periodo := 'N';
    ELSE
      -- Si no es el mes de cierre fiscal, no debe modificarse el 
      -- valor que tengan los indicadores para el mismo
      vind_c_fiscal  := NULL;
      vind_c_periodo := NULL;
    
    END IF;
    --
    -- cambia de mes
    UPDATE NAF47_TNET.arcgmc
       SET mes_proce          = vnuevo_mes,
           ano_proce          = vnuevo_ano,
           cierre_fiscal      = nvl(vind_c_fiscal, Cierre_fiscal),
           indicador_cierrep  = nvl(vind_c_periodo, indicador_cierrep),
           indicador_utilidad = 'N',
           indicador_dif_cam  = 'N'
     WHERE no_cia = pno_cia;
  
    --
    /*message('Preparando el nuevo mes ...', no_acknowledge);
    synchronize;*/
    --
    -- inicia el nuevo periodo
    Inicia_Ctas(pno_cia, pAno, pMes, vnuevo_ano, vnuevo_mes, pMes_Cierre);
    --        
    Inicia_Ctas_cc(pno_cia,
                   pAno,
                   pMes,
                   vnuevo_ano,
                   vnuevo_mes,
                   pMes_Cierre);
    --               
    Inicia_Ctas_Tercero(pno_cia,
                        pAno,
                        pMes,
                        vnuevo_ano,
                        vnuevo_mes,
                        pMes_Cierre);
    --
    IF pmes != pmes_cierre THEN
      -- Si la compa��a no entra a cierre anual, actualiza las utilidades para el 
      -- nuevo a�o y mes de proceso
      --
      CGcalcula_utilidades(pno_cia, vnuevo_ano, vnuevo_mes, pmsg_error);
      if pmsg_error is not null then
        raise error_proceso;
      end if;
    
    END IF;
  
    /*message('.', no_acknowledge);
    synchronize;*/
  
    --:SYSTEM.MESSAGE_LEVEL := 0;
  
  EXCEPTION
    WHEN error_proceso THEN
      pmsg_error := nvl(pmsg_error, 'CIERRE_CONTA');
    WHEN others THEN
      pmsg_error := nvl(sqlerrm, 'CIERRE_CONTA');
  end cierra_contab;

  procedure cierra_centros(pno_cia     IN varchar2,
                           pano        IN number,
                           pmes        IN number,
                           pmes_cierre IN number,
                           pmsg_error  IN OUT varchar2) is
    CURSOR c_centros IS
      SELECT cc_1, cc_2, cc_3, descrip_cc
        FROM NAF47_TNET.arcgCECO
       WHERE no_cia = pno_cia
       ORDER BY cc_1 desc, cc_2 desc, cc_3 desc;
  begin
    FOR cen IN c_centros LOOP
      cierra_1_cc(pno_cia,
                  pano,
                  pmes,
                  pmes_cierre,
                  cen.cc_1,
                  cen.cc_2,
                  cen.cc_3,
                  pmsg_error);
    END LOOP;
    --
    UPDATE NAF47_TNET.arcgd_cc
       SET m_dist_nom = 0, m_dist_dol = 0
     WHERE NO_CIA = pNo_cia;
    --
    UPDATE NAF47_TNET.ARCGMC SET INDICADOR_CC_distbs = 'N' WHERE NO_CIA = pNo_cia;
  
  EXCEPTION
    WHEN OTHERS THEN
      pmsg_error := nvl(sqlerrm, 'Error en CIERRA_CENTROS');
  end cierra_centros;

  PROCEDURE inicia_ctas(pCia            Varchar2,
                        pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                        pMes_Cierre     Number,
                        pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                        pMes_Nuevo      Number,
                        pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                        ) IS
  
    Cursor Cuentas IS
      Select no_cia, cuenta, clase, saldo_mes_ant, saldo_mes_ant_dol
        from NAF47_TNET.arcgms
       where no_cia = pCia
         and clase != '9';
    --
    vperiodo   NAF47_TNET.arcghc.periodo%type;
    vsaldo     Number;
    vSaldo_Dol Number;
  
  BEGIN
  
    vperiodo := (pano_nuevo * 100) + pmes_nuevo;
  
    For Cta in Cuentas LOOP
    
      IF pMes_Cierre = pCierre_Periodo THEN
      
        -- Se inicializan las cuentas de Resultados en cero, al iniciar un nuevo
        -- per�odo contable
      
        Update NAF47_TNET.ARCGHC
           Set Saldo     = decode(cta.clase,
                                  'I',
                                  0,
                                  'G',
                                  0,
                                  Cta.Saldo_mes_ant),
               Saldo_Dol = decode(cta.clase,
                                  'I',
                                  0,
                                  'G',
                                  0,
                                  Cta.Saldo_Mes_Ant_Dol)
         Where no_cia = Cta.No_Cia
           AND ano = pAno_Nuevo
           AND mes = pMes_Nuevo
           AND cuenta = Cta.cuenta;
      
        IF Sql%RowCount = 0 THEN
          IF cta.clase IN ('I', 'G') THEN
            vsaldo     := 0;
            vSaldo_Dol := 0;
          ELSE
            vSaldo     := cta.saldo_mes_ant;
            vSaldo_Dol := cta.saldo_mes_ant_dol;
          END IF;
        
          Insert INTO NAF47_TNET.ARCGHC
            (no_cia, ano, mes, periodo, cuenta, saldo, saldo_dol)
          VALUES
            (cta.no_cia,
             pAno_Nuevo,
             pMes_Nuevo,
             vperiodo,
             cta.cuenta,
             vsaldo,
             vsaldo_dol);
        
        END IF;
      ELSE
        Update NAF47_TNET.ARCGHC
           Set Saldo = Cta.Saldo_mes_ant, Saldo_Dol = Cta.Saldo_Mes_Ant_Dol
         Where no_cia = Cta.No_Cia
           AND ano = pAno_Nuevo
           AND mes = pMes_Nuevo
           AND cuenta = Cta.cuenta;
      
        IF Sql%RowCount = 0 THEN
        
          Insert INTO NAF47_TNET.ARCGHC
            (no_cia, ano, mes, periodo, cuenta, saldo, saldo_dol)
          VALUES
            (cta.no_cia,
             pAno_Nuevo,
             pMes_Nuevo,
             vperiodo,
             cta.cuenta,
             cta.saldo_mes_ant,
             cta.saldo_mes_ant_dol);
        END IF;
      
      END IF;
    END LOOP;
  
  END inicia_ctas;

  PROCEDURE inicia_ctas_cc(pCia            Varchar2,
                           pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                           pMes_Cierre     Number,
                           pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                           pMes_Nuevo      Number,
                           pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                           ) IS
  
    Cursor Cuentas IS
      Select no_cia,
             cuenta,
             clase,
             cc_1,
             cc_2,
             cc_3,
             saldo_mes_ant,
             saldo_mes_ant_dol
        from NAF47_TNET.arcgms_c
       where no_cia = pCia
         AND clase != '9';
  
    vperiodo   NAF47_TNET.arcghc_c.periodo%type;
    vsaldo     Number;
    vSaldo_Dol Number;
  
  BEGIN
  
    vperiodo := (pano_nuevo * 100) + pmes_nuevo;
  
    For Cta in Cuentas LOOP
    
      IF pMes_Cierre = pCierre_Periodo THEN
      
        -- Se inicializan las cuentas de Resultados en cero, al iniciar un nuevo
        -- per�odo contable
      
        Update NAF47_TNET.ARCGHC_c
           Set Saldo     = decode(cta.clase,
                                  'I',
                                  0,
                                  'G',
                                  0,
                                  Cta.Saldo_mes_ant),
               Saldo_Dol = decode(cta.clase,
                                  'I',
                                  0,
                                  'G',
                                  0,
                                  Cta.Saldo_Mes_Ant_Dol)
         Where no_cia = Cta.No_Cia
           AND ano = pAno_Nuevo
           AND mes = pMes_Nuevo
           AND cuenta = Cta.cuenta
           AND cc_1 = Cta.cc_1
           AND cc_2 = Cta.cc_2
           AND cc_3 = Cta.cc_3;
      
        IF Sql%RowCount = 0 THEN
          IF cta.clase IN ('I', 'G') THEN
            vsaldo     := 0;
            vSaldo_Dol := 0;
          ELSE
            vSaldo     := cta.saldo_mes_ant;
            vSaldo_Dol := cta.saldo_mes_ant_dol;
          END IF;
        
          Insert INTO NAF47_TNET.ARCGHC_c
            (no_cia,
             ano,
             mes,
             periodo,
             cuenta,
             saldo,
             saldo_dol,
             cc_1,
             cc_2,
             cc_3)
          VALUES
            (cta.no_cia,
             pAno_Nuevo,
             pMes_Nuevo,
             vperiodo,
             cta.cuenta,
             vsaldo,
             vsaldo_dol,
             cta.cc_1,
             cta.cc_2,
             cta.cc_3);
        
        END IF;
      ELSE
        Update NAF47_TNET.ARCGHC_c
           Set Saldo = Cta.Saldo_mes_ant, Saldo_Dol = Cta.Saldo_Mes_Ant_Dol
         Where no_cia = Cta.No_Cia
           AND ano = pAno_Nuevo
           AND mes = pMes_Nuevo
           AND cuenta = Cta.cuenta
           AND cc_1 = Cta.cc_1
           AND cc_2 = Cta.cc_2
           AND cc_3 = Cta.cc_3;
      
        IF Sql%RowCount = 0 THEN
        
          Insert INTO NAF47_TNET.ARCGHC_c
            (no_cia,
             ano,
             mes,
             periodo,
             cuenta,
             saldo,
             saldo_dol,
             cc_1,
             cc_2,
             cc_3)
          VALUES
            (cta.no_cia,
             pAno_Nuevo,
             pMes_Nuevo,
             vperiodo,
             cta.cuenta,
             cta.saldo_mes_ant,
             cta.saldo_mes_ant_dol,
             cta.cc_1,
             cta.cc_2,
             cta.cc_3);
        END IF;
      
      END IF;
    END LOOP;
  
  END;

  PROCEDURE inicia_ctas_tercero(pCia            Varchar2,
                                pAno_Cierre     Number, -- A�o y Mes que se esta cerrando
                                pMes_Cierre     Number,
                                pAno_Nuevo      Number, -- A�o y Mes que se debe inicializar
                                pMes_Nuevo      Number,
                                pCierre_Periodo Number -- Mes en que se hace el cierre fiscal
                                ) IS
  
    vperiodo NAF47_TNET.arcghc_t.periodo%type;
  
  BEGIN
  
    vperiodo := (pano_nuevo * 100) + pmes_nuevo;
  
    IF PMes_Cierre = pCierre_Periodo THEN
      -- Se inicializan las cuentas de Resultados en cero, al iniciar un nuevo
      -- per�odo contable
    
      Insert into NAF47_TNET.arcghc_t
        (NO_CIA,
         ANO,
         MES,
         PERIODO,
         CUENTA,
         CODIGO_TERCERO,
         SALDO,
         SALDO_DOL)
        Select a.NO_CIA,
               pAno_Nuevo,
               pMes_Nuevo,
               vperiodo,
               a.CUENTA,
               CODIGO_TERCERO,
               decode(clase, 'I', 0, 'G', 0, a.SALDO),
               decode(clase, 'I', 0, 'G', 0, a.SALDO_DOL)
          From NAF47_TNET.arcghc_t a, NAF47_TNET.arcgms b
         Where a.no_cia = pCia
           And a.no_cia = b.no_cia
           And a.cuenta = b.cuenta
           And ano = pAno_Cierre
           And mes = pMes_Cierre;
    
    ELSE
      -- Se inicializan los saldos de las cuentas, para el siguiente 
      -- mes de proceso 
    
      Insert into NAF47_TNET.arcghc_t
        (NO_CIA,
         ANO,
         MES,
         PERIODO,
         CUENTA,
         CODIGO_TERCERO,
         SALDO,
         SALDO_DOL)
        Select NO_CIA,
               pAno_Nuevo,
               pMes_Nuevo,
               vperiodo,
               CUENTA,
               CODIGO_TERCERO,
               SALDO,
               SALDO_DOL
          From NAF47_TNET.arcghc_t
         Where no_cia = pCia
           And ano = pAno_Cierre
           And mes = pMes_Cierre;
    
    END IF;
  
  END;

  PROCEDURE cierra_1_cc(pno_cia     IN VARCHAR2,
                        pano        IN NUMBER,
                        pmes        IN NUMBER,
                        pmes_cierre IN NUMBER,
                        pcc1        IN VARCHAR2,
                        pcc2        IN VARCHAR2,
                        pcc3        IN VARCHAR2,
                        pmsg_error  IN OUT VARCHAR2) IS
    --
    -- cierre mensual, cuentas de los centros de costos 
    --
    CURSOR CUENTAS IS
      SELECT CUENTA,
             DEBITOS,
             CREDITOS,
             SALDO_MES_ANT,
             debitos_dol,
             creditos_dol,
             saldo_mes_ant_dol,
             ROWID
        FROM NAF47_TNET.ARCGMS_c
       WHERE NO_CIA = pno_cia
         AND CC_1 = pcc1
         AND CC_2 = pcc2
         AND CC_3 = pcc3;
    --
    vperiodo      NAF47_TNET.ARCGHC_C.PERIODO%TYPE;
    IND_C_FISCAL  VARCHAR2(1);
    IND_C_PERIODO VARCHAR2(1);
  
  BEGIN
  
    vperiodo := (pano * 100) + pmes;
  
    /* Actualiza o Crea segun corresponda en ARCGHC basandose en ARCGMS*/
    /* cuando la cuenta no tuvo movimiento*/
  
    FOR RC IN CUENTAS LOOP
    
      /**************************************************************/
      /* Actualiza el Saldo de las cuentas que estan en ARCGHC_C    */
      /**************************************************************/
      UPDATE NAF47_TNET.ARCGHC_c
         SET SALDO     = NVL(RC.SALDO_MES_ANT, 0) + NVL(RC.DEBITOS, 0) +
                         NVL(RC.CREDITOS, 0),
             saldo_dol = nvl(rc.saldo_mes_ant_dol, 0) +
                         nvl(rc.debitos_dol, 0) + nvl(rc.creditos_dol, 0)
       WHERE NO_CIA = pno_cia
         AND ANO = pano
         AND MES = pmes
         AND cc_1 = pcc1
         AND cc_2 = pcc2
         AND cc_3 = pcc3
         AND CUENTA = RC.CUENTA;
    
      /**************************************************************/
      /* Inserta en ARCGHC las cuentas que no tuvieron movimientos  */
      /**************************************************************/
    
      IF SQL%ROWCOUNT = 0 THEN
      
        INSERT INTO NAF47_TNET.ARCGHC_c
          (NO_CIA,
           ANO,
           MES,
           PERIODO,
           CUENTA,
           CC_1,
           CC_2,
           CC_3,
           SALDO,
           SALDO_DOL,
           MOV_DB,
           MOV_CR,
           MOVIMIENTO,
           MOV_DB_DOL,
           MOV_CR_DOL)
        VALUES
          (pno_cia,
           pano,
           pmes,
           vperiodo,
           RC.CUENTA,
           pcc1,
           pcc2,
           pcc3,
           NVL(RC.SALDO_MES_ANT, 0) + NVL(RC.DEBITOS, 0) +
           NVL(RC.CREDITOS, 0),
           nvl(rc.saldo_mes_ant_dol, 0) + nvl(rc.debitos_dol, 0) +
           nvl(rc.creditos_dol, 0),
           NVL(rc.debitos, 0),
           NVL(rc.creditos, 0),
           NVL(RC.debitos, 0) + NVL(RC.creditos, 0),
           NVL(rc.debitos_dol, 0),
           NVL(rc.creditos_dol, 0));
      END IF;
    
      /**************************************************************/
      /*Actualiza el saldo del mes anterior y limpia el movimiento  */
      /*para el siguiente mes                                       */
      /**************************************************************/
    
      UPDATE NAF47_TNET.ARCGMS_C
         SET saldo_mes_ant     = nvl(saldo_mes_ant, 0) + nvl(debitos, 0) +
                                 nvl(creditos, 0),
             debitos           = 0,
             creditos          = 0,
             saldo_mes_ant_dol = nvl(saldo_mes_ant_dol, 0) +
                                 nvl(debitos_dol, 0) + nvl(creditos_dol, 0),
             debitos_dol       = 0,
             creditos_dol      = 0
       WHERE ROWID = RC.ROWID;
    
      /*************************************************************/
      /*Si estamos en el periodo de cierre fiscal tambien se debe  */
      /*respaldar el saldo del mes anterior como saldo del periodo */
      /* ********************************************************* */
      IF pmes = pmes_cierre THEN
        UPDATE NAF47_TNET.ARCGMS_C
           SET saldo_per_ant     = saldo_mes_ant,
               saldo_per_ant_dol = saldo_mes_ant_dol
         WHERE ROWID = RC.ROWID;
      END IF;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      pmsg_error := nvl(sqlerrm, 'Error en CIERRA_1_CC');
  END;

end CON_PROCESOS_CIERRE_MENSUAL;
/
