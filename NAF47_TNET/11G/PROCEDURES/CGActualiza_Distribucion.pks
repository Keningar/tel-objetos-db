create or replace PROCEDURE            CGActualiza_Distribucion(
  pCia       in varchar2,
  pCuenta    in varchar2,
  pTasa      in number,
  pNetoNom   in number,
  pNetoDol   in number,
  vExcedido  in out boolean,
  pMsg_error in out varchar2,
  pAnoproc   in number,
  pMesproc   in number,
  pReversion in varchar2
) IS

  --
  vMonto_dist     arcgd_cc.m_dist_nom%type := 0;
  vMonto_dist_dol arcgd_cc.m_dist_nom%type := 0;
  vMonto_nom      arcgd_cc.m_dist_nom%type := 0;
  vMonto_dol      arcgd_cc.m_dist_dol%type := 0;
  vDiferencia     arcgd_cc.monto_d_cc%type := 0;
  kTope_ajuste    constant number(2):= 0.5;
  --
  error_proceso  exception;
  --
  CURSOR c_Centro IS
    SELECT ind_como_dist, porcentaje_d_cc, monto_d_cc, RowID, CC_1,CC_2,CC_3, CUENTA
      FROM arcgD_Cc
     WHERE cuenta         = pcuenta
       AND no_cia         = pCia
       AND ind_como_dist != 'R';
  BEGIN

  IF pReversion = 'S' THEN

  	-- Es una reversion, debe borrar el historico generado en la ejecucion previa
  	-- para el ano y mes en proceso

  	DELETE arcghd_cc
  	 WHERE no_cia    = pCia
  	   AND cuenta    = pCuenta
       AND ano       = pAnoproc
       AND mes       = pMesproc;

  END IF;

  FOR ctro IN c_centro LOOP


    IF Ctro.ind_como_dist = 'G' THEN
      vMonto_nom := GREATEST(moneda.redondeo((ctro.porcentaje_d_cc * pNetoNom/100), 'P'),
                             moneda.redondeo(ctro.monto_d_cc, 'P'));
      vMonto_dol := GREATEST(moneda.redondeo((ctro.porcentaje_d_cc * pNetoDol/100),'D'),
                             moneda.redondeo(ctro.monto_d_cc/pTasa, 'D'));
    ELSIF ctro.ind_como_dist = 'P' THEN
      vMonto_nom := LEAST(moneda.redondeo((ctro.porcentaje_d_cc * pNetoNom/100),'P'),
                          moneda.redondeo(ctro.monto_d_cc,'P'));
      vMonto_dol := LEAST(moneda.redondeo((ctro.porcentaje_d_cc * pNetoDol/100), 'D'),
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

    vMonto_dist     := vMonto_dist + vMonto_nom;
    vMonto_dist_dol := vMonto_dist_dol + vMonto_dol;


    -- Ajuste en nominal, por problemas de redondeo
    IF (vMonto_dist - pNetoNom)> 0 AND (vMonto_dist - pNetoNom) < kTope_ajuste THEN
        vDiferencia := vMonto_dist - pNetoNom;
        vMonto_dist := vMonto_dist - nvl(vDiferencia,0);
        vMonto_nom  := vMonto_nom - nvl(vDiferencia,0);
    END IF;

    -- Ajuste en dolares, por problemas de redondeo
    IF (vMonto_dist_dol - pNetoDol)> 0 AND (vMonto_dist_dol - pNetoDol) < kTope_ajuste THEN
        vDiferencia     := vMonto_dist_dol - pNetoDol;
        vMonto_dist_dol := vMonto_dist_dol - nvl(vDiferencia,0);
        vMonto_dol      := vMonto_dol - nvl(vDiferencia,0);
    END IF;

    UPDATE arcgd_cc
       SET m_dist_nom = vMonto_nom,
           m_dist_dol = vMonto_dol
     WHERE ROWID = ctro.rowid;
  END LOOP;
  --
  vMonto_nom := moneda.Redondeo( pNetoNom - vMonto_Dist,'P') ;
  vMonto_dol := moneda.Redondeo((pNetoNom - vMonto_Dist)/pTasa,'D');
  --
  -- calcula la fila con ind_como_dist=R
  UPDATE arcgd_cc
     SET m_dist_nom = vMonto_nom,
         m_dist_dol = vMonto_dol
   WHERE no_cia        = pCia
     AND cuenta        = pCuenta
     AND ind_como_dist = 'R';

  --Valida que el monto distribuido sea menor al saldo de la cuenta
  --en nominal y en dolares
  IF pNetoNom < vMonto_dist  THEN
    vExcedido := TRUE;
  END IF;
  IF pNetoDol < vMonto_dist_dol THEN
    vExcedido := TRUE;
  END IF;

  -- Codigo que permite generar un historico de la regla y calculo de la distribucion
  -- por centro de costo

  -- Es una generacion nueva debe generar registro en el historico
  INSERT INTO arcghd_cc (no_cia,	 cuenta, 	 centro_costo,	 ano,  	 mes,
			 porcentaje_d_cc,	   monto_d_cc,		 ind_como_dist,
			 m_dist_nom,			   m_dist_dol)
                 SELECT no_cia,   cuenta,   cc_1||cc_2||cc_3, -- centro de costo
			 pAnoproc, pMesproc,
			 porcentaje_d_cc,	   monto_d_cc,	   ind_como_dist,
	 		 m_dist_nom,			   m_dist_dol
	            FROM arcgd_cc
	           WHERE no_cia    = pCia
	             AND cuenta    = pCuenta;

EXCEPTION
  WHEN error_proceso THEN
     pMsg_error := nvl(pMsg_error, 'CGActualiza_Distribucion');
  WHEN others THEN
     pMsg_error := nvl(sqlerrm, 'CGActualiza_Distribucion');
END;