CREATE OR REPLACE PACKAGE            CgOtros_Meses AS
   /**
   * Documentacion para NAF47_TNET.CgOtros_Meses 
   * El paquete CgOtros_Meses contiene una serie de procedimientos y
   * funciones necesarias para la ejecucion de mayorizacion de asientos
   * de Otros_Meses
   */
   --
   /**
   * Documentacion para Mayoriza_Asiento 
   * Procedimiento genera procesa mayorización de asientos contables de meses cerrados
   * @author yoveri <yoveri@yoveri.com>
   * @version 1.0 01/01/2007
   *
   * @author llindao <llindao@telconet.ec>
   * @version 1.1 31/08/2020 -  Se modifica para considerar nuevo campo que asocia la distribución de costo con el asiento contable.
   *
   * @param pAsiento IN VARCHAR2 Recibe Identificación de asiento contable
   * @param pCia     IN VARCHAR2 Recibe Identificación de compañía
   */
   PROCEDURE Mayoriza_Asiento (pCia Varchar2, pAsiento Varchar2);
   --
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20030);
   kNum_error      NUMBER := -20030;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
END; -- CgOtros_Meses;
/


CREATE OR REPLACE PACKAGE BODY            CgOtros_Meses AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   */
   gAno_Proce       Arcgmc.ano_proce%type;
   gMes_Proce       Arcgmc.mes_Proce%type;
   gMes_Cierre      Arcgmc.mes_cierre%type;
   gCta_Ajuste_Nom  Arcgms.cuenta%type;
   gCta_Ajuste_Dol  Arcgms.cuenta%type;
   gPeriodo_Proceso Arcghc.periodo%type;
   --
   gAno_Asiento     Arcgmc.ano_proce%type;
   gMes_Asiento     Arcgmc.mes_Proce%type;
   gPeriodo_Asiento Arcghc.periodo%type;
   --
   gIni_Periodo_Act Arcghc.periodo%type;
   gFin_Periodo_Act Arcghc.periodo%type;
   --
   gPeriodo_Actual  BOOLEAN;  -- Registra si el asiento pertenece al
                              -- periodo fiscal actual
   --
   vMensaje_error   VARCHAR2(160);
   vMensaje         VARCHAR2(160);
   --
   --
   PROCEDURE genera_error(
      msj_error IN VARCHAR2
   )IS
   BEGIN
      vMensaje_error := msj_error;
      vMensaje       := msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(
      msj IN VARCHAR2
   ) IS
   BEGIN
      vMensaje  := msj;
   END;
   -- --
   --
   PROCEDURE Inicializa(
     pCia Varchar2,
	 pAsiento Varchar2
   )IS
     --
     Cursor c_Cia IS
	    Select Ano_Proce,      Mes_Proce,    Mes_Cierre,
		       Cta_Ajuste_Nom, Cta_Ajuste_Dol
		  From Arcgmc
		 Where no_cia = pCia;
     --
	 Cursor c_asiento IS
	    Select Ano, Mes
		  From Arcgae
		 Where no_cia     = pCia
		   And no_Asiento = pAsiento;
     --
	 vReg_Cia     c_Cia%rowtype;
	 vReg_Asiento c_Asiento%rowtype;
     vExiste      BOOLEAN;
   BEGIN
      Open c_Cia;
	  Fetch c_cia into vReg_Cia;
	  vExiste := c_Cia%FOUND;
	  Close c_Cia;
	  IF NOT vExiste THEN
	     Genera_Error('Error Obteniendo datos de la compa?ia '|| pCia);
	  END IF;
      --
      Open c_Asiento;
	  Fetch c_asiento into vReg_Asiento;
	  vExiste := c_Asiento%FOUND;
	  Close c_Asiento;
	  IF NOT vExiste THEN
	     Genera_Error('Error Obteniendo datos del asiento '|| pAsiento || ' de la compa?ia ' ||pCia);
	  END IF;
	  -- Asigna datos obtenidos de la compa?ia
	  gAno_Proce       := vReg_cia.ano_proce;
	  gMes_Proce       := vReg_cia.mes_proce;
	  gMes_Cierre      := vReg_cia.mes_cierre;
	  gCta_ajuste_Nom  := vReg_Cia.cta_ajuste_nom;
	  gCta_ajuste_Dol  := vReg_Cia.cta_ajuste_dol;
	  gPeriodo_Proceso := (gAno_Proce*100)+gMes_Proce;
	  -- Asigna datos obtenidos del asiento
	  gAno_Asiento     := vReg_Asiento.ano;
	  gMes_Asiento     := vReg_Asiento.mes;
	  gPeriodo_Asiento := (gAno_Asiento*100)+gMes_Asiento;
	  --
      if gMes_Cierre = 12 then
         gIni_Periodo_Act := (gAno_Asiento*100) + 01;
         gFin_Periodo_Act := (gAno_Asiento*100) + 12;
      else
         if gMes_Asiento between 1 and gMes_Cierre then
            gIni_Periodo_Act :=((gAno_Asiento-1)*100) + gMes_Cierre+1;
            gFin_Periodo_Act :=( gAno_Asiento   *100) + gMes_Cierre;
         else
            gIni_Periodo_Act :=( gAno_Asiento   *100) + gMes_Cierre+1;
            gFin_Periodo_Act :=((gAno_Asiento+1)*100) + gMes_Cierre;
         end if;
      end if;
      -- se determina el periodo hasta el cual se actualizan los historicos
      gfin_periodo_act := LEAST(gfin_periodo_act, gPeriodo_Proceso);
      -- --
      -- Determina si el mes en proceso esta fuera del periodo fiscal
	  -- en el cual se registro el asiento
      -- --
      if gPeriodo_Proceso between gini_periodo_act and gfin_periodo_act then
         gPeriodo_Actual := TRUE;
      else
         gPeriodo_Actual := FALSE;
      end if;
   END;
   -- --
   --
   FUNCTION Obtiene_Cta_Utilidades(
      pCia                   Varchar2,
      pcta_usada_en_ajuste   boolean
   ) RETURN VARCHAR2
   IS
   -- --
   -- Devuelve la cuenta de utilidades que debe afectarse, de acuerdo
   -- a si la cuenta se utiliza como
   --
   Cursor c_Temp_Util(pajustable varchar2) IS
         Select cuenta
           from arcgms a
          where a.no_cia = pCia
            and a.clase   = '9'
            and a.nivel   = 2
            and a.ajustable = pAjustable;
    --
    vexiste     boolean;
    vajustable  arcgms.ajustable%type;
    vCuenta     Arcgms.cuenta%type;
    --
   BEGIN
	  if pcta_usada_en_ajuste then
		 vajustable := 'S';
  	  else
		 vajustable := 'N';
  	  end if;
  	  --
      open c_Temp_Util(vAjustable);
      fetch c_Temp_Util INTO vCuenta;
      vexiste := c_Temp_Util%found;
      close c_Temp_Util;
      --
      if NOT vexiste then
         Genera_error('No existe cuenta de utilidades de nivel 2, con ajustable = '||vajustable);
      end if;
      Return (vCuenta);
   END;
   -- --
   --
   PROCEDURE crear_historico
   (p_cia       Varchar2,
    p_cuenta    varchar2
	)IS
    -- Crea el registro historico de la cuenta contable desde el periodo
    -- del asiento, hasta el periodo en proceso
    CURSOR Cta_Existe (pAno Arcghc.ano%type, pMes Arcghc.mes%type) IS
           SELECT 'S'
             FROM ARCGhC
            WHERE NO_CIA = p_cia
              and ano    = pano
              and mes    = pmes
              and cuenta = p_cuenta;
    ano_control arcghc.ano%type := gAno_Asiento;
    mes_control arcghc.mes%type := gMes_Asiento;
    vDummy      varchar2(1);
	vExiste     Boolean;
	--
   BEGIN
      WHILE ano_control*100+mes_control <= gperiodo_proceso LOOP
         OPEN Cta_Existe (ano_control, mes_control);
         FETCH Cta_Existe into vDummy;
		 vExiste := Cta_Existe%FOUND;
         CLOSE Cta_Existe;
         --
         IF NOT vExiste THEN
            INSERT INTO ARCGHC
               ( NO_CIA,    ANO,     MES,        cuenta,
                MOVIMIENTO, MOV_DB,
                MOV_CR,    SALDO,   MOV_DB_DOL, MOV_CR_DOL,
                SALDO_DOL, periodo)
            VALUES
              ( p_cia,      ANO_CONTROL, MES_CONTROL, p_cuenta,
                    0,           0,
                    0,          0,           0,           0,
                    0,          ano_control*100+mes_control);
         END IF;
         --
         IF MES_CONTROL=12 THEN
            MES_CONTROL:=1;
            ANO_CONTROL:=ANO_CONTROL+1;
         ELSE
            MES_CONTROL:=MES_CONTROL+1;
         END IF;
      END LOOP;
   END;
-- --
--
PROCEDURE crear_historico_Centro
    (p_cia       Varchar2,
     p_cuenta    varchar2,
     pCentro     varchar2 )IS
-- Crea el registro historico de la cuenta contable por centro de costo
-- desde el periodo del asiento, hasta el periodo en proceso
   CURSOR Cta_Existe (pAno Arcghc.ano%type, pMes Arcghc.mes%type) IS
       SELECT 'S'
         FROM arcgHC_C
        WHERE NO_CIA  = p_cia
          and ano     = pAno
          and mes     = pMes
          and cc_1    = substr(pCentro,1,3)
          and cc_2    = substr(pCentro,4,3)
          and cc_3    = substr(pCentro,7,3)
          and cuenta  = p_cuenta ;
    --
    ano_control Arcghc.ano%type := gano_Asiento;
    mes_control Arcghc.mes%type := gmes_Asiento;
    vDummy      varchar2(1);
	vExiste     Boolean;
    --
BEGIN
   WHILE ano_control*100+mes_control <= gperiodo_proceso LOOP
     OPEN Cta_Existe (Ano_Control, Mes_Control);
     FETCH Cta_Existe into vDummy;
	 vExiste := Cta_Existe%FOUND;
     CLOSE Cta_Existe;
     IF NOT vExiste THEN
       INSERT INTO ARCGHC_C
          ( NO_CIA,    ANO,     MES,        cuenta,
            PRESU,     PRES_AC, MOVIMIENTO, MOV_DB,
            MOV_CR,    SALDO,   MOV_DB_DOL, MOV_CR_DOL,
            SALDO_DOL, cc_1,    cc_2,       cc_3,
            periodo)
          VALUES
           (p_cia,      ANO_CONTROL,         MES_CONTROL,         p_cuenta,
            0,          0,                   0,                   0,
            0,          0,                   0,                   0,
            0,          substr(pCentro,1,3), substr(pCentro,4,3), substr(pCentro,7,3),
            ano_control*100+mes_control);
     END IF;
     IF MES_CONTROL =12 THEN
        MES_CONTROL := 1;
        ANO_CONTROL := ANO_CONTROL + 1;
     ELSE
        MES_CONTROL := MES_CONTROL + 1;
     END IF;
  END LOOP;
END;
-- --
--
PROCEDURE crear_historico_Tercero
    (p_cia       Varchar2,
     p_cuenta    varchar2,
     pTercero    varchar2 )IS
-- Crea el registro historico de la cuenta contable por tercero
-- desde el periodo del asiento, hasta el periodo en proceso
   CURSOR Cta_Existe (pAno Arcghc.ano%type, pMes Arcghc.mes%type)IS
      SELECT 'S'
        FROM arcgHC_T
       WHERE NO_CIA          = p_cia
         and ano             = pAno
         and mes             = pMes
         and codigo_tercero  = pTercero
         and cuenta          = p_cuenta ;
    --
    ano_control Arcghc.ano%type := gano_Asiento;
    mes_control Arcghc.mes%type := gmes_Asiento;
    vDummy      varchar2(1);
	vExiste     Boolean;
BEGIN
   WHILE ano_control*100+mes_control <= gPeriodo_Proceso LOOP
     OPEN Cta_Existe(ano_control, mes_control);
     FETCH Cta_Existe into vDummy;
	 vExiste := Cta_Existe%FOUND;
	 Close Cta_Existe;
	 --
     IF NOT vExiste THEN
       INSERT INTO ARCGHC_t
          ( NO_CIA,     ANO,        MES,       cuenta,
            MOVIMIENTO, MOV_DB,     MOV_CR,    SALDO,
            MOV_DB_DOL, MOV_CR_DOL, SALDO_DOL, codigo_tercero,
            periodo)
          VALUES
           (p_cia,      ANO_CONTROL,         MES_CONTROL,         p_cuenta,
            0,          0,                   0,                   0,
            0,          0,                   0,                  pTercero,
            ano_control*100+mes_control);
     END IF;
     IF MES_CONTROL = 12 THEN
        MES_CONTROL := 1;
        ANO_CONTROL := ANO_CONTROL+1;
     ELSE
        MES_CONTROL := MES_CONTROL+1;
     END IF;
  END LOOP;
END;
   -- --
   --
PROCEDURE Aplicar_Terceros_Otros_Meses
    (pCia             Varchar2,
     pCta             Varchar2,
     pTercero         Varchar2,
     pMto             Number,
     pMto_Dol         Number,
     pTipo            Varchar2,
     pClase           Varchar2
    )IS
BEGIN
   Crear_Historico_Tercero(pCia,     pCta,   pTercero);
   -- Afecto los movimientos en el periodo del asiento.
   UPDATE ARCGHC_T SET
          Mov_Cr     = NVL(Mov_Cr,0)     + decode(pTipo, 'C', nvl(pMto,0), 0),
          Mov_Db_Dol = NVL(Mov_Db_Dol,0) + decode(pTipo, 'D', nvl(pMto_Dol,0), 0),
          Mov_Cr_Dol = NVL(Mov_Cr_Dol,0) + decode(pTipo, 'C', nvl(pMto_Dol,0), 0),
          Movimiento = NVL(Movimiento,0) + nvl(pMto,0)
    WHERE no_cia         = pCia
      AND cuenta         = pCta
      AND codigo_tercero = pTercero
      AND Periodo        = gPeriodo_Asiento;
	--
	IF NOT gPeriodo_Actual AND pClase IN ('I', 'G')THEN
       -- Si el asiento es de otro periodo y la cuenta es de resultados
       -- Debe afectar la cuenta desde el periodo del asiento al final
       -- del periodo contable
       UPDATE ARCGHC_T
          SET Saldo          = NVL(Saldo,0)      + nvl(pMto,0),
              Saldo_Dol      = NVL(Saldo_Dol,0)  + nvl(pMto_Dol, 0)
        WHERE no_cia         = pCia
          AND cuenta         = pCta
          AND codigo_tercero = pTercero
          AND Periodo BETWEEN gPeriodo_Asiento AND gFin_Periodo_Act;
  	ELSIF (NOT gPeriodo_Actual AND pClase NOT IN ('I', 'G')) OR
		     gPeriodo_Actual THEN
       -- Si la cuenta es de balance , debe aplicarlo desde el periodo
       -- del asiento hasta el periodo en proceso.
       UPDATE ARCGHC_T
          SET Saldo      = NVL(Saldo,0)      + nvl(pMto,0),
              Saldo_Dol  = NVL(Saldo_Dol,0)  + nvl(pMto_Dol, 0)
        WHERE no_cia         = pCia
          AND cuenta         = pCta
          AND codigo_tercero = pTercero
          AND Periodo BETWEEN gPeriodo_Asiento AND gPeriodo_Proceso;
   END IF;
END;
   -- --
   --
PROCEDURE calcula_Utilidades (
    pCia            Varchar2,
    pPeriodo        Varchar2,
    pAjuste         Varchar2,
    pMto_Nom IN OUT ARCGHC.Saldo%type,
    pMto_Dol IN OUT ARCGHC.Saldo_Dol%type)IS
    Mto_Ingresos_Nom  Arcghc.Saldo%Type := 0;
    Mto_Gastos_Nom    Arcghc.Saldo%Type := 0;
    Mto_Ingresos_Dol  Arcghc.Saldo_Dol%Type := 0;
    Mto_Gastos_Dol    Arcghc.Saldo_Dol%Type := 0;
    Cursor c_IyG IS
      Select Sum(Decode(a.clase, 'I', Nvl(b.Saldo,0),0)),
             Sum(Decode(a.clase, 'G', Nvl(b.Saldo,0),0)),
             Sum(Decode(a.clase, 'I', Nvl(b.Saldo_Dol,0),0)),
             Sum(Decode(a.clase, 'G', Nvl(b.Saldo_dol,0),0))
        From Arcgms a, Arcghc b
       Where a.No_Cia    = pCia
         AND a.no_cia    = b.no_cia
         AND periodo     = pPeriodo
         AND a.cuenta    = b.cuenta
         AND a.ind_mov   = 'S'
         AND Clase       IN ('I', 'G')
         AND NOT Exists (select cta_correccion
	                       From arcgms c
	                      Where a.no_cia = c.no_cia
	                        AND a.cuenta = c.cta_correccion
	                     );
   Cursor c_IyG_Aj IS
     Select Sum(Decode(a.clase, 'I', Nvl(b.Saldo,0),0)),
            Sum(Decode(a.clase, 'G', Nvl(b.Saldo,0),0)),
            Sum(Decode(a.clase, 'I', Nvl(b.Saldo_Dol,0),0)),
            Sum(Decode(a.clase, 'G', Nvl(b.Saldo_dol,0),0))
       From Arcgms a, Arcghc b
      Where a.No_Cia    = pCia
        AND a.no_cia    = b.no_cia
        AND periodo     = pperiodo
        AND a.cuenta    = b.cuenta
        AND a.ind_mov   = 'S'
        AND Clase       IN ('I', 'G')
        AND Exists (select cta_correccion
	                   From arcgms c
	                  Where a.no_cia = c.no_cia
	                    AND a.cuenta = c.cta_correccion
	                  );
    -- Registra el saldo convertido para la cuenta temporal de utilidades
   BEGIN
   	 IF pAjuste = 'N' THEN
        Open  c_IyG;
        Fetch c_IyG Into Mto_Ingresos_Nom, Mto_Gastos_Nom, Mto_Ingresos_Dol, Mto_Gastos_Dol;
  	    IF c_IyG%NOTFOUND THEN
           Close c_IyG;
	     	   Genera_Error('ERROR '||'Error obteniendo total de ingresos y gastos');
        ELSE
           Close c_IyG;
        END IF;
  	 ELSE
        Open  c_IyG_Aj;
        Fetch c_IyG_Aj Into Mto_Ingresos_Nom, Mto_Gastos_Nom, Mto_Ingresos_Dol, Mto_Gastos_Dol;
  	    IF c_IyG_Aj%NOTFOUND THEN
           Close c_IyG_Aj;
	     	   Genera_Error('ERROR '||'Error obteniendo total de ingresos y gastos');
        ELSE
           Close c_IyG_Aj;
        END IF;
  	 END IF;
     pMto_Nom  := Mto_Ingresos_Nom + Mto_Gastos_Nom;
     pMto_Dol  := Mto_Ingresos_Dol + Mto_Gastos_Dol;
END;
-- --
--
  PROCEDURE Mayoriza_Util (
     pCia     Varchar2,
     pCta     Varchar2,
     pMto_Nom Arcghc.Saldo%type,
     pMto_dol Arcghc.Saldo_dol%type
  )IS
     vCta_Proceso Arcgms.cuenta%type;
  BEGIN
     vCta_Proceso := pCta;
     LOOP
      -- Actualiza ARCGMS_C
        update arcgms_c
       		 set saldo_mes_ant     = nvl(saldo_mes_ant,0)     + pMto_Nom,
		           saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + pMto_Dol
         where no_cia  = pCia
           and cuenta  = vCta_Proceso;
		--
        update arcgms
       		 set saldo_mes_ant     = nvl(saldo_mes_ant,0)     + pMto_Nom,
		           saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + pMto_dol
         where no_cia  = pCia
           and cuenta  = vCta_Proceso;
		--
           -- Actualiza ARCGHC_C
        update arcghc_c
           set saldo     = nvl(saldo,0)     + pMto_Nom,
  	  	       saldo_dol = nvl(saldo_dol,0) + pMto_dol
         WHERE no_cia  = pCia
           and cuenta  = vCta_Proceso
           and periodo > gfin_periodo_act;
		--
        update arcghc
           set saldo     = nvl(saldo,0)     + pMto_Nom,
  	  	       saldo_dol = nvl(saldo_dol,0) + pMto_dol
         WHERE no_cia  = pCia
           and cuenta  = vCta_Proceso
           and periodo > gfin_periodo_act;
		--
        IF Cuenta_Contable.Nivel(pCia, vCta_Proceso) = 1 THEN
           EXIT;
        ELSE
           vCta_Proceso := Cuenta_Contable.Padre(pCia, vCta_Proceso);
        END IF;
     END LOOP;
  END;
-- --
--
PROCEDURE Afectar_Resultados(
   pCia             Varchar2,
   p_monto         number,
   p_monto_dol     number,
   p_monto_aj      number,
   p_monto_dol_aj  number
) is
  Cursor c_Obtiene_Cuentas IS
     Select Cta_Und,      Cta_Und_Ajuste,
	        Cta_Perdidas, Cta_Perdidas_Ajuste
       From arcgmc
      Where no_cia = pCia;
  rCtas            c_Obtiene_Cuentas%RowType;
  vFound         BOOLEAN;
  vCta_Proceso   ARCGMS.cuenta%type;
  vMov_Nom      ARCGHC.movimiento%type;
  vMov_Dol      ARCGHC.movimiento%type;
  vMov_Anterior ARCGHC.movimiento%type;
  vMov_Ant_Dol  ARCGHC.movimiento%type;
  vMov_Nom_Aj      ARCGHC.movimiento%type;
  vMov_Dol_Aj      ARCGHC.movimiento%type;
  vMov_Anterior_Aj ARCGHC.movimiento%type;
  vMov_Ant_Dol_Aj  ARCGHC.movimiento%type;
BEGIN
   Open c_Obtiene_Cuentas;
   Fetch c_Obtiene_Cuentas Into rCtas;
   vFound := c_Obtiene_Cuentas%FOUND;
   Close c_Obtiene_Cuentas;
   IF NOT vFound THEN
   	  Genera_Error('Error obteniendo cuentas de utilidades/perdidas');
   END IF;
   -- Calculo la utilidad o perdida del periodo quedando en vMov_Nom y vMov_Dol
   -- Para las cuentas sin ajuste
   Calcula_Utilidades(pCia,     gfin_periodo_Act, 'N',
                      vMov_Nom, vMov_Dol);
   vMov_Anterior := vMov_Nom - p_Monto;
   vMov_Ant_Dol  := vMov_Dol - p_Monto_Dol;
   IF ( vMov_Nom < 0 AND vMov_Anterior < 0 ) THEN
   	   -- Hubo ganancias  y continua habiendo ganancias
 	   Mayoriza_Util(pCia, rctas.cta_UND, p_monto, p_monto_Dol );
   ELSIF( vMov_Nom > 0 AND vMov_Anterior > 0 ) THEN
   	   -- Hubo perdidas y continua habiendo perdidas
 	   Mayoriza_Util(pCia, rctas.cta_Perdidas, p_monto, p_monto_Dol );
   ELSIF( vMov_Nom < 0 AND vMov_Anterior > 0 ) THEN
   	   -- Hubo perdidas y luego de aplicado el movimiento hay ganancias
 	   Mayoriza_Util(pCia, rctas.cta_Perdidas, -vMov_Anterior, -vMov_Ant_Dol );
 	   Mayoriza_Util(pCia, rctas.cta_UND,      vMov_nom,       vMov_Dol);
   ELSIF( vMov_Nom < 0 AND vMov_Anterior > 0 ) THEN
   	   -- Hubo ganancias y luego de aplicado el movimiento hay perdidas
 	   Mayoriza_Util(pCia, rctas.cta_UND,      -vMov_Anterior, -vMov_Ant_Dol );
 	   Mayoriza_Util(pCia, rctas.cta_Perdidas, vMov_nom,       vMov_Dol);
   End IF;
   -- Calculo la utilidad o perdida del periodo quedando en vMov_Nom y vMov_Dol
   -- Para las cuentas de ajuste
   Calcula_Utilidades(pCia,        gfin_periodo_act, 'S',
                      vMov_Nom_Aj, vMov_Dol_Aj);
   vMov_Anterior_Aj := vMov_Nom_Aj - p_Monto_AJ;
   vMov_Ant_Dol_Aj  := vMov_Dol_Aj - p_Monto_Dol_AJ;
   IF ( vMov_Nom_Aj < 0 AND vMov_Anterior_Aj < 0 ) THEN
   	   -- Hubo ganancias  y continua habiendo ganancias
   	 Mayoriza_Util(pCia, rctas.cta_UND, p_monto_Aj, p_monto_Dol_Aj );
   ELSIF( vMov_Nom_Aj > 0 AND vMov_Anterior_Aj > 0 ) THEN
   	   -- Hubo perdidas y continua habiendo perdidas
   	 Mayoriza_Util(pCia, rctas.cta_Perdidas, p_monto, p_monto_Dol );
   ELSIF( vMov_Nom_Aj < 0 AND vMov_Anterior_Aj > 0 ) THEN
   	   -- Hubo perdidas y luego de aplicado el movimiento hay ganancias
   	 Mayoriza_Util(pCia,              rctas.cta_Perdidas,
	               -vMov_Anterior_Aj, -vMov_Ant_Dol_Aj );
   	 Mayoriza_Util(pCia,        rctas.cta_UND,
	               vMov_nom_Aj, vMov_Dol_Aj);
   ELSIF( vMov_Nom_Aj < 0 AND vMov_Anterior_Aj > 0 ) THEN
  	   -- Hubo ganancias y luego de aplicado el movimiento hay perdidas
   	 Mayoriza_Util(pCia,              rctas.cta_UND,
	               -vMov_Anterior_Aj, -vMov_Ant_Dol_Aj );
   	 Mayoriza_Util(pCia,        rctas.cta_Perdidas,
	               vMov_nom_Aj, vMov_Dol_Aj);
   End IF;
END;
-- --
--
PROCEDURE Afecta_util_HC(
  pcia             Varchar2,
  pCta_utilidades  Varchar2,
  pmto_nom         Number,
  pMto_dol         Number
) IS
BEGIN
   update arcghc
      set movimiento = decode(periodo, gPeriodo_Asiento,
                                  nvl(movimiento,0) + pMto_Nom,
				                          movimiento),
          mov_db     = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db,0)+nvl(mov_cr,0)+ pMto_Nom),
      		                               -1,0,
                                         nvl(mov_db,0) + nvl(mov_cr,0) + pMto_Nom ),
                                         mov_db),
          mov_cr     = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db,0)+ nvl(mov_cr,0)+ pmto_nom),
							                           1,0,
	            		                       nvl(mov_db,0) + nvl(mov_cr,0) + pmto_nom ),
                                         mov_cr),
          mov_db_dol = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db_dol,0)+nvl(mov_cr_dol,0)+ pmto_dol),
 			                                   -1,0,
                                         nvl(mov_db_dol,0) + nvl(mov_cr_dol,0) + pmto_dol ),
                                         mov_db_dol),
          mov_cr_dol = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db_dol,0)+ nvl(mov_cr_dol,0)+ pmto_dol),
							                           1,0,
			                                   nvl(mov_db_dol,0) + nvl(mov_cr_dol,0) + pMto_Dol ),
                                         mov_cr_dol),
          saldo      = nvl(saldo,0)     + pmto_nom,
          saldo_dol  = nvl(saldo_dol,0) + pmto_dol
    WHERE no_cia  = pCia
      and cuenta  = pcta_utilidades
      and periodo between gPeriodo_Asiento and gFin_Periodo_Act;
    If sql%rowcount = 0 then
       Genera_Error('No existe la cuenta :'||pcta_utilidades||' en arcghc,  Notifique al DBA');
    End If;
    --
   update arcghc_c
      set movimiento = decode(periodo, gPeriodo_Asiento,
                                  nvl(movimiento,0) + pMto_Nom,
				                          movimiento),
          mov_db     = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db,0)+nvl(mov_cr,0)+ pMto_Nom),
      		                               -1,0,
                                         nvl(mov_db,0) + nvl(mov_cr,0) + pMto_Nom ),
                                         mov_db),
          mov_cr     = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db,0)+ nvl(mov_cr,0)+ pmto_nom),
							                           1,0,
	            		                       nvl(mov_db,0) + nvl(mov_cr,0) + pmto_nom ),
                                         mov_cr),
          mov_db_dol = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db_dol,0)+nvl(mov_cr_dol,0)+ pmto_dol),
 			                                   -1,0,
                                         nvl(mov_db_dol,0) + nvl(mov_cr_dol,0) + pmto_dol ),
                                         mov_db_dol),
          mov_cr_dol = decode(periodo, gPeriodo_Asiento,
                                  decode(sign(nvl(mov_db_dol,0)+ nvl(mov_cr_dol,0)+ pmto_dol),
							                           1,0,
			                                   nvl(mov_db_dol,0) + nvl(mov_cr_dol,0) + pMto_Dol ),
                                         mov_cr_dol),
          saldo      = nvl(saldo,0)     + pmto_nom,
          saldo_dol  = nvl(saldo_dol,0) + pmto_dol
    WHERE no_cia  = pCia
      and cuenta  = pcta_utilidades
      and cc_1    = '000'
      and periodo between gPeriodo_Asiento and gFin_Periodo_Act;
    If sql%rowcount = 0 then
       Genera_Error('No existe la cuenta :'||pcta_utilidades||' en arcghc_c,  Notifique al DBA');
    End If;
END;
-- --
--
PROCEDURE Actualiza1CC(
          pCia       VARCHAR2,  pCtaLin     VARCHAR2,
          pCCaMayo   VARCHAR2,  pMnomi      number,
          pMdol      number,    pMone       VARCHAR2,
          pTipoLin   VARCHAR2
) IS
   --
   Cursor c_Clase IS
        select clase
        from arcgMS
        where no_cia  = pCia
          and cuenta  = pCtaLin;
   --
   vper            arcghc.periodo%type;
   vmes            arcghc.mes%type;
   vano            arcghc.ano%type;
   vCta_Proceso    ARCGMS.cuenta%type;
   vcc1            arcgal.cc_1%type;
   vcc2            arcgal.cc_2%type;
   vcc3            arcgal.cc_3%type;
   vmonto_nomi     arcgal.monto%type := 0;
   vmonto_dol      arcgal.monto%type := 0;
   vClase          varchar2(1);
   --
BEGIN
   Open  c_Clase;
   Fetch c_Clase  into vclase;
   Close c_Clase;
   -- determina la clase de cuenta (al.cuenta)
   vCta_Proceso := pCtaLin;
   vmonto_dol  := pMdol;
   vmonto_nomi := pMnomi;
    -- --
    -- Realiza el proceso de mayorizacion y actualizacion en el historico
    --
    LOOP
       vcc1:= substr(pCCaMayo,1,3);
       vcc2:= substr(pCCaMayo,4,3);
       vcc3:= substr(pCCaMayo,7,3);
       crear_Historico_Centro(pcia,    vCta_Proceso,   pCCaMayo);
       -- --
       -- Actualiza en arcghc el movimiento, mov_cr y mov_db para la
	   -- cuenta,ano y mes del asiento
       --
       update arcghc_c
                set movimiento = nvl(movimiento,0) + vmonto_nomi,
                    mov_db     = decode(ptipolin,'D',nvl(mov_db,0)    + vmonto_nomi, mov_db),
                    mov_cr     = decode(ptipolin,'C',nvl(mov_cr,0)    + vmonto_nomi, mov_cr),
 		            mov_db_dol = decode(ptipolin,'D',nvl(mov_db_dol,0)+ vmonto_dol , mov_db_dol),
                    mov_cr_dol = decode(ptipolin,'C',nvl(mov_cr_dol,0)+ vmonto_dol , mov_cr_dol)
             where no_cia  = pCia
               and ano     = gAno_Asiento
               and mes     = gMes_Asiento
               and CC_1    = vCC1
               and CC_2    = vCC2
               and CC_3    = vCC3
               and cuenta  = vCta_proceso;
       -- --
       -- Actualiza saldos de las cuentas a partir del ano y mes del
       -- del asiento
       --
       update arcghc_c
   		  set saldo      = nvl(saldo,0)     + vmonto_nomi,
		      saldo_dol  = nvl(saldo_dol,0) + vmonto_dol
        where no_cia  = pcia
          and periodo BETWEEN gPeriodo_asiento AND gfin_periodo_act
          and CC_1    = vCC1
          and CC_2    = vCC2
          and CC_3    = vCC3
          and cuenta  = vcta_proceso;
       -- --
       -- Actualiza en arcghc el saldo solamente para periodos posteriores
       -- y para cuentas de balance solamente
       --
        if vClase NOT IN ('I','G') then
             update arcghc_c
                set saldo     = nvl(saldo,0) + vmonto_nomi,
                    saldo_dol = nvl(saldo_dol,0) + vmonto_dol
                where no_cia  = pcia
                  and cuenta  = vCta_proceso
                  and CC_1    = vCC1
                  and CC_2    = vCC2
                  and CC_3    = vCC3
                  and periodo >  gfin_periodo_act;
        end if;
     -- --
     -- Falta ejecutar los ajustes en en el ARCGMS_C
     -- Si el asiento es del periodo en proceso, actualiza el saldo del
	 -- mes anterior directamente
	 -- Si el asiento no es del periodo en proceso
	 --     * Si la cuenta es de balance actualiza el saldo del
	 --       mes y del periodo anterior directamente,
     --     * Si la cuenta es de resultados solo actualiza el saldo
	 --       del periodo anterior ( debe tocar la cuenta de utilidades
	 --       no distribuidas)
     -- --
       IF gperiodo_actual THEN
          update arcgms_c
             set saldo_mes_ant  = nvl(saldo_mes_ant,0) + vmonto_nomi,
                 saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + vmonto_dol
           where no_cia   = pcia
             and CC_1    = vCC1
             and CC_2    = vCC2
             and CC_3    = vCC3
             and cuenta  = vCta_Proceso;
       ELSE
          IF vClase NOT IN ('I','G') THEN
              update arcgms_c
                 set saldo_mes_ant     = nvl(saldo_mes_ant,0)     + vmonto_nomi,
                     saldo_per_ant     = nvl(saldo_per_ant,0)     + vmonto_nomi,
	                 saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + vmonto_dol,
 	                 saldo_per_ant_dol = nvl(saldo_per_ant_dol,0) + vmonto_dol
               where no_cia   = pcia
                 and CC_1     = vCC1
                 and CC_2     = vCC2
                 and CC_3     = vCC3
                 and cuenta   = vcta_proceso;
		  ELSE
             update arcgms_c
                set saldo_per_ant     = nvl(saldo_per_ant,0) + vmonto_nomi,
                    saldo_per_ant_dol = nvl(saldo_per_ant_dol,0) + vmonto_dol
              where no_cia  = pcia
                and cuenta  = vCta_Proceso
                and CC_1    = vCC1
                and CC_2    = vCC2
                and CC_3    = vCC3 ;
          END IF;
       END IF;
       IF cuenta_contable.nivel(pcia, vCta_Proceso) = 1 THEN
          EXIT;
       ELSE
          vCta_Proceso := Cuenta_Contable.padre(pcia, vCta_Proceso);
       END IF;
   END LOOP; -- de la mayorizacion
END;
-- --
--
PROCEDURE MayorizaxCCs (
          pnuciaAD    VARCHAR2,           pCta        VARCHAR2,
          pCentroC    VARCHAR2,           ptipo_linea VARCHAR2,
          pMnominal   number,             pMdolares   number,
          pMoneda     VARCHAR2) IS
    /*    actualiza (AD de Otros Meses) Centros de Costos,
          el 0-0-0 y el resto de mayor a menor               */
nivel_CC	number(1) := 1;
CCqMayo		varchar2(9):= '000000000';
BEGIN
/*  mayoriza el Centro 000-000-000, excepto p/ el Asiento de Dif Camb.
    pues este lo hace en dos partes, 1- para la cia (0-0-0) y otro
    para c/u de los Cent. de Costos                                      */
  Actualiza1CC(pNuciaAD,    pCta,         CCqMayo,
               pMnominal,   pMdolares,    pmoneda,
			   pTipo_linea);
  WHILE pCentroC <> CCqMayo LOOP
     CCqMayo := substr(pCentroC,1,nivel_cc*3) ||
                substr(CCqMayo,LEAST(nivel_cc*3+1,9),GREATEST(9-nivel_cc*3,0));
     Actualiza1CC( pNuciaAD,   pCta,       CCqMayo,
	               pMnominal,  pMdolares,  pmoneda,
				   pTipo_linea);
     nivel_cc := nivel_cc + 1;
  END LOOP;
END;
-- --
--
Procedure Afecta_Util_Mes(pCia Varchar2, pCta Varchar2,
                          pMto Number,   pMto_dol Number) IS
   BEGIN
      update arcgms
         set saldo_mes_ant     = nvl(saldo_mes_ant,0) + pMto,
             saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + pMto_dol
       where no_cia = pCia
         and cuenta = pCta;
  	  --
      update arcgms_c
         set saldo_mes_ant     = nvl(saldo_mes_ant,0) + pMto,
             saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + pMto_dol
       where no_cia = pCia
         and cuenta = pCta
         and cc_1   = '000';
   END;
   --
   --
   FUNCTION cta_usada_Ajuste_Inflacion (
      pCia Varchar2,
      pCta Varchar2
   ) RETURN BOOLEAN IS
     Cursor c_Ajusta IS
        select 'x'
        From arcgms
        Where no_cia         = pCia
          And cta_correccion = pCta
          and rownum         = 1;
      --
      vAjusta   BOOLEAN;
      vDummy    Varchar2(1);
   BEGIN
   	 Open c_ajusta;
   	 Fetch c_Ajusta  INTO vDummy;
   	 vAjusta := c_Ajusta%FOUND;
   	 Close c_Ajusta;
   	 RETURN (vAjusta);
   END;
  -- --
  --
  PROCEDURE verifica_presicion (
    pCia             varchar2,
    pAsiento         varchar2,
    pCta_Ajuste_Nom  varchar2,
    pCta_Ajuste_Dol  varchar2
  ) IS
    PerPresicionNom  arcgal.monto%type     :=0;
    PerPresicionDol  arcgal.monto_dol%type :=0;
    UltimaLinea      arcgal.no_linea%type  :=0;
    Fecha            date;
    cod_diario       arcgal.cod_Diario%type ;
    --
    CURSOR lineas_mov IS
      SELECT tipo, monto, moneda, tipo_cambio, monto_dol
        FROM arcgal
       WHERE no_cia     = pCia
         AND no_asiento = pAsiento;
    --
    CURSOR otros_datos IS
      SELECT fecha, cod_diario, ano, mes
        FROM arcgae
       WHERE no_cia     = pCia
         AND no_asiento = pAsiento;
    --
    vMonto_Nom number;
    vMonto_Dol number;
    vano       arcgae.ano%type;
    vMes       arcgae.mes%type;
  BEGIN
    vMonto_Nom := 0;
    vMonto_Dol := 0;
    FOR al IN lineas_mov LOOP
      ultimaLinea := ultimaLinea + 1;
      IF al.moneda = 'D' THEN
        -- La moneda es dolares
        vMonto_Nom := vMonto_Nom + al.monto;
      ELSE
        --  La moneda es nominal
        vMonto_Dol := vMonto_Dol + al.monto_dol;
      END IF;
    END LOOP;
    PerPresicionNom := moneda.redondeo(vMonto_Nom, 'P');
    PerPresicionDol := moneda.redondeo(vMonto_Dol, 'D');
    IF PerPresicionNom != 0 and pcta_ajuste_nom is null then
      genera_error('Cuenta de ajuste por presicion en moneda nominal debe ser definida');
    END IF;

    IF PerPresicionNom < 0 THEN
      OPEN  otros_datos;
      FETCH otros_datos INTO fecha,cod_diario, vano, vMes;
      CLOSE otros_datos;

      INSERT INTO arcgal (no_cia, ano,    mes,    no_asiento,    no_linea,
                          descri, cuenta, cod_diario, moneda,    tipo_cambio,
                          monto,  tipo,   fecha,  cc_1,   cc_2,  cc_3, linea_ajuste_precision)
                 VALUES  (pCia,   vAno,   vMes,   pAsiento,      UltimaLinea+1,
                          'Ajuste por Presicion', pcta_ajuste_nom,  cod_diario, 'P',  0,
                          -PerPresicionNom, 'D',   fecha, '000', '000', '000', 'S');

      ultimaLinea := ultimaLinea + 1;

    ELSIF PerPresicionNom > 0 THEN
      OPEN  otros_datos;
      FETCH otros_datos INTO fecha, cod_diario, vano, vmes;
      CLOSE otros_datos;

      INSERT INTO arcgal (no_cia,  ano,    mes,   no_asiento,   no_linea,
                          descri,  cuenta, cod_diario,  moneda, tipo_cambio,
                          monto,   tipo,   fecha, cc_1, cc_2,   cc_3, linea_ajuste_precision)
                  VALUES (pCia,    vAno,   vMes,  pAsiento,     UltimaLinea + 1,
                         'Ajuste por Presicion',  pcta_ajuste_nom, cod_diario,  'P', 0,
                          -PerPresicionNom, 'C',   fecha,  '000', '000', '000', 'S');

      ultimaLinea := ultimaLinea + 1;

    END IF;
    IF PerPresicionDol != 0 and pcta_ajuste_dol is null then
      genera_error('Cuenta de ajuste por presicion en dolares debe ser definida');
    END IF;

    IF PerPresicionDol < 0 THEN
      OPEN  otros_datos;
      FETCH otros_datos INTO fecha, cod_diario, vano, vmes;
      CLOSE otros_datos;

     INSERT INTO arcgal (no_cia,  ano,    mes,   no_asiento,   no_linea,
                         descri,  cuenta, cod_diario,  moneda, tipo_cambio,
                         monto,   tipo,   fecha, cc_1, cc_2,   cc_3, linea_ajuste_precision)
                 VALUES (pCia,    vAno,   vMes,  pAsiento,     ultimaLinea + 1,
                         'Ajuste por Presicion', pcta_ajuste_dol, cod_diario, 'D',  0,
                         -PerPresicionDol, 'D',   fecha, '000', '000', '000', 'S');

      ultimaLinea := ultimaLinea + 1;
    ELSIF PerPresicionDol > 0 THEN
      OPEN  otros_datos;
      FETCH otros_datos INTO fecha, cod_diario, vano, vmes;
      CLOSE otros_datos;

      INSERT INTO arcgal (no_cia,  ano,    mes,   no_asiento,   no_linea,
                          descri,  cuenta, cod_diario,  moneda, tipo_cambio,
                          monto,   tipo,   fecha, cc_1, cc_2,   cc_3, linea_ajuste_precision)
                  VALUES (pCia,    vAno,   vMes,  pAsiento,     UltimaLinea+1,
                         'Ajuste por Presicion',  pcta_ajuste_dol, cod_diario,  'D',  0,
                          -PerPresicionDol, 'C',  fecha, '000', '000', '000', 'S');

      ultimaLinea := ultimaLinea + 1;
    END IF;
  END;
  --
  -- --
PROCEDURE distribuir_cc_otros_meses (
   pCia          in varchar2,
   pCta          in varchar2,
   pAno_asiento  in varchar2,
   pMes_asiento  in varchar2,
   pTipo_dist     in varchar2
) IS
  vMoneda       arcgms.moneda%type;
  vTipo         arcgal.tipo%type;
  vMonto_nom    arcgd_cc.m_dist_nom%type  :=0;
  vMonto_dol    arcgd_cc.m_dist_dol%type  :=0;
  --
  CURSOR c_centros IS
    SELECT cuenta, centro_costo,
           m_dist_nom, m_dist_dol
       FROM arcghd_cc
      WHERE no_cia  = pCia
	    AND cuenta  = pCta
  	    AND ano     = pAno_asiento
        AND mes     = pMes_asiento
      ORDER BY  cuenta;

  PROCEDURE mayori_centros (
   pNuciaAD    varchar2,
   panoAD      number,
   pmesAD      number,
   pOrigenAD   varchar2,
   pCta        varchar2,
   pCentroC    varchar2,
   pMnominal   number,
   pMdolares   number,
   pTipo_linea varchar2
   ) IS
    -- Distribuye los costos por centro de costo, de mayor a menor
    -- mayorizando por centros
    nivel_cc   number(1)  := 1;
    CCqMayo    arcghd_cc.centro_costo%type := '000000000';
  BEGIN
    WHILE pCentroC <> CCqMayo LOOP
        CCqMayo := substr(pCentroC,1,nivel_cc*3) ||
                   substr(CCqMayo,least(nivel_cc*3+1,9),greatest(9-nivel_cc*3,0));
        Actualiza1CC( pNuciaAD,   pCta,       CCqMayo,
                      pMnominal,  pMdolares,  'P',
					  pTipo_linea);
        nivel_cc := nivel_cc + 1;
     END LOOP;
  END;

BEGIN
   FOR cen IN c_centros LOOP
       IF nvl(cen.m_dist_nom,0) >= 0 THEN
            vtipo := 'D';
       ELSE
            vtipo := 'C';
       END IF;
       IF pTipo_dist = 'REVERSAR' THEN
            vMonto_nom := nvl(cen.m_dist_nom,0)* -1;
            vMonto_dol := nvl(cen.m_dist_dol,0)* -1;
       ELSE
            vMonto_nom := nvl(cen.m_dist_nom,0);
            vMonto_dol := nvl(cen.m_dist_dol,0);
       END IF;
       IF vMonto_nom <> 0 THEN
           mayori_centros (pCia,       pAno_asiento,   pMes_asiento,
                           'CE',       cen.cuenta,     cen.centro_costo,
                           vMonto_nom, vMonto_dol,     vTipo);
       END IF;
   END LOOP;
END;

--
PROCEDURE actualiza_distribucion_om(
  pCia           in varchar2,
  pCuenta        in varchar2,
  pTasa          in number,
  pNetoNom       in number,
  pNetoDol       in number,
  vExcedido      in out boolean,
  pAno_asiento   in number,
  pMes_asiento   in number
) IS
  --
  vMonto_dist   arcgd_cc.m_dist_nom%type := 0;
  vMonto_nom    arcgd_cc.m_dist_nom%type := 0;
  vMonto_dol    arcgd_cc.m_dist_dol%type := 0;
  vDiferencia   arcgd_cc.monto_d_cc%type := 0;
  --
  CURSOR c_centro IS
       SELECT ind_como_dist, porcentaje_d_cc,
	            monto_d_cc, rowid
         FROM arcghd_cc
        WHERE no_cia         = pCia
          AND cuenta         = pCuenta
          AND ano            = pAno_asiento
          AND mes            = pMes_asiento
          AND ind_como_dist != 'R';

  BEGIN

  --Calcula los montos a distribuir
  FOR ctro IN c_centro LOOP
     IF ctro.ind_como_dist = 'G' THEN
        vMonto_nom := greatest(moneda.redondeo((Ctro.porcentaje_d_cc * pNetoNom/100), 'P'),
                               moneda.redondeo(ctro.monto_d_cc, 'P'));
        vMonto_dol := greatest(moneda.redondeo((Ctro.porcentaje_d_cc * pNetoDol/100),'D'),
                               moneda.redondeo(ctro.monto_d_cc/pTasa, 'D'));
     ELSIF ctro.ind_como_dist = 'P' THEN
        vMonto_nom := least(moneda.redondeo((Ctro.porcentaje_d_cc * pNetoNom/100),'P'),
                            moneda.redondeo(ctro.monto_d_cc,'P'));
        vMonto_dol := least(moneda.redondeo((Ctro.porcentaje_d_cc * pNetoDol/100), 'D'),
                            moneda.redondeo(ctro.monto_d_cc/pTasa, 'D'));
     ELSIF ctro.ind_como_dist = '%' THEN
        vMonto_nom := moneda.redondeo((ctro.porcentaje_d_cc * pNetoNom/100), 'P');
        vMonto_dol := moneda.redondeo((ctro.porcentaje_d_cc * pNetoDol/100),'D');
     ELSIF ctro.ind_como_dist = 'A' THEN
        vMonto_nom := moneda.redondeo(ctro.monto_d_cc,'P');
        vMonto_dol := moneda.redondeo(ctro.monto_d_cc/pTasa,'D');
     ELSE
        vMonto_nom := 0;
        vMonto_dol := 0;
     END IF;
     vMonto_dist := vMonto_dist + vMonto_nom;

     IF (vMonto_dist - pNetoNom) > 0 THEN
        vDiferencia := vMonto_dist - pNetoNom;
        vMonto_dist := vMonto_dist - nvl(vDiferencia,0);
        vMonto_nom  := vMonto_nom - nvl(vDiferencia,0);
     END IF;

     UPDATE arcghd_cc
        SET m_dist_nom = vMonto_nom,
            m_dist_dol = vMonto_dol
     WHERE rowid = ctro.rowid;
   END LOOP;
   --
   vMonto_nom := moneda.redondeo( pNetoNom - vMonto_dist,'P') ;
   vMonto_dol := moneda.redondeo((pNetoNom - vMonto_dist)/pTasa,'D');
   --
   -- calcula la fila con ind_como_dist=R
   UPDATE arcghd_cc
      SET m_dist_nom = vMonto_nom,
          m_dist_dol = vMonto_dol
    WHERE no_cia        = pCia
      AND cuenta        = pCuenta
      AND ano           = pAno_asiento
      AND mes           = pMes_asiento
      AND ind_como_dist = 'R';


   -- Retorna True cuando la distribucion NO sobrepasa el monto total
   -- a distribuir
   IF pNetoNom < vMonto_dist  THEN
      vExcedido := true;
   END IF;
END;
---

PROCEDURE  calcula_montos(
 pCia          in varchar2,
 pCta          in varchar2,
 pAno_asiento  in varchar2,
 pMes_asiento  in varchar2
)IS

  CURSOR c_cta IS
     SELECT nvl(mov_db,0)     +  nvl(mov_cr,0),
            nvl(mov_db_dol,0) +  nvl(mov_cr_dol,0)
       FROM arcghc
      WHERE no_cia  = pCia
        AND cuenta  = pCta
        AND ano     = pAno_asiento
        AND mes     = pMes_asiento;
  --
  vMov_neto_nom    arcgms.debitos%type     :=0;
  vMov_neto_dol    arcgms.debitos_dol%type :=0;
  vTipo_cambio     arcgae.tipo_cambio%type :=0;
  vMonto_excedido  boolean  := False;

BEGIN
  -- Obtiene los montos debitos y creditos en nominal
  -- y dolares de la cuenta
  OPEN  c_cta;
  FETCH c_cta INTO vMov_neto_nom, vMov_neto_dol;
  IF c_cta%notfound THEN
     vMov_neto_nom  :=0;
     vMov_neto_dol  :=0;
  END IF;
  CLOSE c_cta;

  IF vMov_neto_nom = 0 THEN  -- No hay monto que distribuir
      UPDATE arcghd_cc
         SET m_dist_nom = 0,
             m_dist_dol = 0
       WHERE no_cia  = pCia
         AND cuenta  = pCta
         AND ano     = pAno_asiento
         AND mes     = pMes_asiento;
   ELSE
                            -- Si hay monto que distribuir
      vMonto_excedido := false;
      vTipo_cambio    := round(vMov_neto_nom/vMov_neto_dol,5);

      actualiza_distribucion_om (pCia,               pCta,
                                 vTipo_cambio,       abs(vMov_neto_nom),
                                 abs(vMov_neto_dol), vMonto_excedido,
                                 pAno_Asiento,       pMes_Asiento);

      IF vMonto_excedido THEN
      	 genera_error('El calculo de la distribucion es mayor que el saldo'
                      || 'de la cuenta: ' || pCta || Chr(13) ||
                     'Revise los porcentajes y montos absolutos');
      END IF;
   END IF;

   IF vMov_neto_nom < 0 THEN  --Si el monto a distribuir es negativo
      UPDATE arcghd_cc
         SET m_dist_nom = -1 * m_dist_nom,
             m_dist_dol = -1 * m_dist_dol
       WHERE no_cia  = pCia
         AND cuenta  = pCta
         AND ano     = pAno_asiento
         AND mes     = pMes_asiento;
   END IF;
END;


PROCEDURE redistribuye_cc (
  pCia            in  varchar2,
  pAsiento        in  varchar2,
  pAno_asiento    in  number,
  pMes_asiento    in  number
) IS

  --
  CURSOR c_cta_distribuida IS
    SELECT distinct hd.cuenta
      FROM arcghd_cc hd, arcgmm mm
     WHERE mm.no_cia     = pCia
	   AND mm.no_cia     = hd.no_cia
       AND mm.cuenta     = hd.cuenta
       AND mm.no_asiento = pAsiento
       AND mm.ano        = pAno_asiento
       AND mm.mes        = pMes_asiento;

BEGIN
  FOR i IN c_cta_distribuida  LOOP

	  --Reversa el movimiento que existia
      distribuir_cc_otros_meses(pCia,i.cuenta, pAno_asiento, pMes_asiento, 'REVERSAR');

	  --Obtiene nuevos monto a distruir
	  calcula_montos(pCia, i.cuenta, pAno_asiento, pMes_asiento);

	  --Realiza el proceso de redistribucion por centro de costo con los nuevos
	  --valores
      distribuir_cc_otros_meses(pCia, i.cuenta,pAno_asiento, pMes_asiento,'ACTUALIZAR');

  END LOOP;
END;


   /*******[ PARTE: PUBLICOS ]
   * Declaracion de Procedimientos o funciones PUBLICOS
   */
   PROCEDURE Mayoriza_Asiento (pCia Varchar2, pAsiento Varchar2)IS
   --  actualizacion de asientos de OTROS MESES
   cursor c_encabezado is
      select no_asiento,    fecha,       cod_diario, origen,
             ano,           mes,         impreso,    descri1,
             estado,        autorizado,  t_debitos,  t_creditos,
             rowid,         tipo_cambio, t_camb_c_v, tipo_comprobante,
             no_comprobante
      from arcgae
      where no_cia     = pcia   and
            no_asiento = pasiento and
            anulado    = 'N' and
            estado     = 'O'
      for update of estado;
   cursor c_detalle is
      select l.cuenta,      no_linea,     no_docu,         monto,
             l.tipo,        l.descri,     clase,           l.moneda,
             l.tipo_cambio, L.Cod_Diario, CC_1,            CC_2,
             CC_3,          monto_dol,    l.codigo_tercero, l.linea_ajuste_Precision,
             l.no_distribucion
       from arcgms s, arcgal l
      where l.no_cia    = pcia
        and no_asiento  = pasiento
        and s.no_cia    = pCIA
        and s.cuenta    = l.cuenta;
   -- --
   -- Define las variables locales del procedimiento
   --
   vError            Varchar2(150);
   Error_Proceso     Exception;
   --
   vAfecta_Resultados BOOLEAN;        -- Indica si el asiento afecto cuentas de resultados
   --
   vCta_Proceso            Arcgms.cuenta%type;
   vCentroCosto            Arcgal.centro_costo%type;
   vmonto_nomi             Arcgal.monto%type := 0;
   vmonto_dol              Arcgal.monto%type := 0;
   vMto_Result             Arcgms.saldo_mes_ant%type := 0;
   vMto_Result_Dol         Arcgms.saldo_mes_ant_dol%type := 0;
   vMto_Result_Aj          Arcgms.saldo_mes_ant%type := 0;
   vMto_Result_Dol_aj      Arcgms.saldo_mes_ant_dol%type := 0;
   vCta_Temp_Util          ARCGMS.cuenta%type;
   vCtaMayor_Temp_Util     ARCGMS.cuenta%type;
   vcta_usada_para_ajuste  BOOLEAN;  -- indica si la cuenta se usa para ajuste de inflacion
   vmsg                    varchar2(400);
   -- --
   rEnc                    c_encabezado%rowtype;
   vExiste                 BOOLEAN;
   BEGIN
      Inicializa(pCia, pAsiento);
	  -- --
	  -- Obtiene los datos del encabezado del asiento
	  --
	  Open c_Encabezado;
	  Fetch c_Encabezado Into rEnc;
	  vExiste := c_Encabezado%Found;
	  Close c_Encabezado;
	  --
      IF vExiste THEN
	     -- --
         -- Realiza las validaciones del asiento, si encontro datos para el asiento
         IF NOT CG_CuadraAsiento(pcia, rEnc.no_asiento, rEnc.origen) THEN
            Genera_Error(' >> El asiento '||rEnc.no_asiento ||'  tiene inconsistencias. Favor Verifique !!! '||
                         chr(13)||'No esta cuadrado !!!');
         ELSIF nvl(rEnc.NO_COMPROBANTE,0) = '0' THEN
            Genera_Error(' >> El asiento '||rEnc.no_asiento ||'  NO tiene asignado No. Comprobante. Favor Verifique !!! ');
         ELSIF NOT CGValida_Fecha (rEnc.fecha, rEnc.ano, rEnc.mes )  THEN
            Genera_Error(' >> El asiento '||rEnc.no_asiento ||'  tiene inconsistencias. Favor Verifique !!! '||
                          Chr(13)||'Fecha no coincide con periodo en proceso');
         ELSIF NOT CGValida_Ctas_Asiento (pcia, rEnc.no_asiento )  THEN
            Genera_Error(' >> El asiento '||rEnc.no_asiento ||'  tiene inconsistencias. Favor Verifique !!! '||
                          Chr(13)||'Tiene Cuentas que NO reciben movimientos');
         ELSIF NOT CGValida_Precision(pcia, rEnc.no_asiento )  THEN
            Genera_Error(' >> El asiento '||rEnc.no_asiento ||'  tiene inconsistencias. Favor Verifique !!! '||
                         Chr(13)||'Error en calculo de precision');
         ELSE
            -- --
		    -- Si el asiento cumple con las validaciones, se inicia el proceso del mismo
            verifica_presicion (pCia,            rEnc.no_asiento,
		                        gCta_Ajuste_Nom, gCta_Ajuste_Dol);
            vAfecta_Resultados := FALSE;
            FOR al in c_detalle loop
			   -- --
			   -- Procesa cada una de las lineas del asiento
               vCta_Proceso := al.cuenta;
               IF al.clase IN ('I', 'G') THEN
                  vAfecta_Resultados     := TRUE;
                  vcta_usada_para_ajuste := cta_usada_Ajuste_Inflacion(pCia, vCta_Proceso);
             	  vCta_Temp_Util         := Obtiene_Cta_Utilidades(pCia, vcta_usada_para_ajuste);
                  vCtaMayor_Temp_Util    := Cuenta_Contable.Padre(pCia, vCta_Temp_Util);
               END IF;
               vCentroCosto := al.cc_1 || al.cc_2 ||al.cc_3;
			   -- --
               -- Se cargan los montos en dolares y nominal en variables, para el proceso.
               vmonto_nomi := nvl(al.monto,0);
               vmonto_dol  := nvl(al.monto_dol,0);
               -- --
               -- Realiza el proceso de mayorizacion y actualizacion en el historico
               LOOP
                  crear_historico(pcia,  vCta_Proceso);
                  -- --
                  -- Actualiza en arcghc el movimiento, mov_cr y mov_db para la
	              -- cuenta,ano y mes del asiento
                  update arcghc
                     set movimiento = nvl(movimiento,0) + vmonto_nomi,
                         mov_db     = decode(al.tipo,'D',nvl(mov_db,0)    + vmonto_nomi, mov_db),
                         mov_cr     = decode(al.tipo,'C',nvl(mov_cr,0)    + vmonto_nomi, mov_cr),
   	                     mov_db_dol = decode(al.tipo,'D',nvl(mov_db_dol,0)+ vmonto_dol , mov_db_dol),
                         mov_cr_dol = decode(al.tipo,'C',nvl(mov_cr_dol,0)+ vmonto_dol , mov_cr_dol)
                   where no_cia  = pcia
                     and ano     = gano_asiento
                     and mes     = gmes_Asiento
                     and cuenta  = vCta_Proceso;
                  -- --
                  -- Actualiza saldos de las cuentas a partir del ano y mes del
                  -- del asiento
                  update arcghc
                     set saldo      = nvl(saldo,0)     + vmonto_nomi,
		                 saldo_dol  = nvl(saldo_dol,0) + vmonto_dol
                   where no_cia = pcia
                     and cuenta = vCta_Proceso
                     and periodo between gperiodo_Asiento and gfin_periodo_act;
                  -- --
                  -- Actualiza en arcghc el saldo solamente para periodos posteriores
                  -- y para cuentas de balance solamente
                  If al.clase NOT IN ('I','G') then
                     update arcghc
                        set saldo   = nvl(saldo,0)     + vmonto_nomi,
	                        saldo_dol = nvl(saldo_dol,0) + vmonto_dol
                      where no_cia   = pcia
                        and cuenta   = vCta_Proceso
                        and periodo  > gfin_periodo_act;
                  End If;
                  -- --
                  -- Debe modificar la cuenta temporal de utilidades en el historico para que
                  -- refleje la verdadera utilidad o perdida segun los nuevos asientos
                  If (al.clase = 'I' OR al.clase = 'G') and vCta_Proceso = al.cuenta then
                     -- Aplica el movimiento a la cuenta temporal de utilidades
                     Afecta_util_hc(pCia,        vcta_temp_util,
  				                    vMonto_Nomi, vMonto_Dol);
                     Afecta_util_hc(pCia,        vctaMayor_temp_util,
	  				                vMonto_Nomi, vMonto_Dol);
                  End If; -- Si vt_clase = I o G
                  IF gPeriodo_Actual then
               	     -- --
                 	 -- el asiento esta dentro del periodo fiscal actual
                 	 --
                     update arcgms
                        set saldo_mes_ant     = nvl(saldo_mes_ant,0)     + vmonto_nomi,
                            saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + vmonto_dol
                      where no_cia   = pCia
                        and cuenta   = vCta_Proceso;
                     -- --
                     -- si es cuenta de ingresos o gastos afecta la cuenta temporal
                     -- de utilidades
                     --
                     if vCta_Proceso = al.cuenta and al.clase in ('I','G') then
                        Afecta_Util_Mes(pCia,        vCta_Temp_Util,
				  	                    vmonto_nomi, vmonto_dol);
                        Afecta_Util_Mes(pCia,        vCtaMayor_Temp_Util,
					                    vmonto_nomi, vmonto_dol);
                     end if;
				  ELSE
				     -- --
					 -- El asiento pertenece a un periodo fiscal anterior
					 --
					 -- Se afectan solo cuentas de balance, pues las de resultado
					 -- se inicializan en cero para el nuevo periodo
					 --
                     update arcgms
                        set saldo_mes_ant     = nvl(saldo_mes_ant,0)     + vmonto_nomi,
                            saldo_per_ant     = nvl(saldo_per_ant,0)     + vmonto_nomi,
	                        saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + vmonto_dol,
  	                        saldo_per_ant_dol = nvl(saldo_per_ant_dol,0) + vmonto_dol
                      where no_cia   = pCia
                        and cuenta   = vCta_Proceso
						and clase NOT IN ('I', 'G');
					 -- --
					 -- Si es una cuenta de resultado, se debe afectar la cuenta de
					 -- utilidades no distribuidas
                     IF (vCta_Proceso = al.cuenta and al.clase IN ('I','G') ) then
                   	    IF vcta_usada_para_ajuste THEN
                           vMto_Result_Aj     := vMto_Result_Aj     + nvl(vmonto_nomi,0);
                           vMto_Result_Dol_Aj := vMto_Result_Dol_Aj + nvl(vmonto_dol,0);
                        ELSE
                           vMto_Result     := vMto_Result     + nvl(vmonto_nomi,0);
                           vMto_Result_Dol := vMto_Result_Dol + nvl(vmonto_dol,0);
                        END IF;
                     END IF;
				  END IF; -- Del asiento pertenece al periodo actual
                  IF Cuenta_Contable.nivel(pCia, vCta_Proceso) = 1 THEN
                     EXIT;
                  ELSE
                	 vCta_Proceso := Cuenta_Contable.Padre(pCia, vCta_Proceso);
                  END IF;
               END LOOP;  -- de la mayorizacion
               -- ----------------------------------------------------------
               -- Inserta las lineas de los asientos que se estan procesando
               -- en la tabla historica de movimientos ARCGMM
               -- -----------------------------------------------------------
               insert into arcgmm
                    (no_cia,                 ano,            mes,
                     no_asiento,             no_linea,       cuenta,
                     CC_1,                   CC_2,           CC_3,
                     fecha,                  no_docu,        moneda,
                     monto,                  tipo_cambio,    monto_dol,
                     tipo,                   descri,         COD_DIARIO,
                     tipo_comprobante,       no_comprobante, codigo_tercero,
                     linea_ajuste_Precision, periodo,        no_distribucion)
                values
                    (pCia,                      gano_asiento,        gmes_asiento,
                     rEnc.no_asiento,           al.no_linea,         al.cuenta,
                     AL.CC_1,                   AL.CC_2,             AL.CC_3,
                     rEnc.fecha,                al.no_docu,          al.moneda,
                     al.monto,                  al.tipo_cambio,      al.monto_dol,
                     al.tipo,                   al.descri,           AL.COD_DIARIO,
                     rEnc.tipo_comprobante,     rEnc.no_comprobante, al.codigo_tercero,
                     al.linea_Ajuste_Precision, gPeriodo_Asiento,    al.no_distribucion );
               --  mayoriza por CCs
               MayorizaxCCs (pCia,      al.cuenta,   vCentroCosto,
                             al.tipo,   vMonto_nomi, vMonto_dol,
			  			     al.moneda);
               IF nvl(AL.codigo_tercero, '0') != '0' THEN
                  Aplicar_Terceros_Otros_Meses (pCia,        al.cuenta,   al.codigo_tercero,
                                                vMonto_Nomi, vMonto_Dol,  al.tipo,
					  						    al.clase);
               END IF;
            END LOOP;  -- de las lineas
            IF vAfecta_Resultados AND NOT gPeriodo_Actual THEN
               Afectar_Resultados(pCia,           vMto_Result,        vMto_Result_Dol,
         	                      vMto_Result_Aj, vMto_Result_Dol_Aj);
            END IF;
            -- --
            -- Crea el historico del movimiento y borra el movimiento actualizado
            --
            INSERT INTO ARCGAEH (NO_CIA,           NO_ASIENTO,   ANO,
                                 MES,              IMPRESO,      FECHA,
                                 DESCRI1,          ESTADO,       AUTORIZADO,
                                 ORIGEN,           T_DEBITOS,    T_CREDITOS,
                                 COD_DIARIO,       t_camb_c_v,   tipo_cambio,
                                 tipo_comprobante, no_comprobante,
                                 ind_otros_meses)
                        VALUES  (pCIA,                rEnc.NO_ASIENTO, rEnc.ANO,
                                 rEnc.MES,              rEnc.IMPRESO,    rEnc.FECHA,
                                 rEnc.DESCRI1,          'A',           'S',
                                 rEnc.ORIGEN,           rEnc.T_DEBITOS,  rEnc.T_CREDITOS,
                                 rEnc.COD_DIARIO,       rEnc.t_camb_c_v, rEnc.tipo_cambio,
                                 rEnc.tipo_comprobante, rEnc.no_comprobante,
                                 'S');
            --
            DELETE arcgal
             WHERE no_cia     = pcia
		   AND no_asiento = pasiento;
            --
            DELETE arcgae
             WHERE rowid = rEnc.rowid;
         END IF;
      END IF; -- Si existe el encabezado de asiento
      CGCalcula_Utilidades(pCia, gAno_Proce, gMes_Proce, vError);
      IF vError IS NOT NULL THEN
   	     Raise Error_Proceso;
      END IF;
     --Redistribuye por centro de costo
	  redistribuye_cc(pCia,pAsiento,gAno_asiento,gMes_asiento );
   EXCEPTION
      When Cuenta_Contable.Error THEN
           Genera_error(Cuenta_Contable.ultimo_Error);
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
   ---
END;   -- BODY CgOtros_Meses
/
