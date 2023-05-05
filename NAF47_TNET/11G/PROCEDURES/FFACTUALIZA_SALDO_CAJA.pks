create or replace PROCEDURE            FFACTUALIZA_SALDO_CAJA
(
 pCia            in varchar2,
 pCaja           in varchar2,
 pMonto_nom      in number,
 pSaldo_nom      in number,
 pMonto_dol      in number,
 pSaldo_dol      in number,
 pTipo           in varchar2,   --Tipo de operacion Registro,Liquidacion, Devolucion
 pInd_pago_prove in varchar2,   --pInd_pago_prove = 'S' indica que es un comprobante que
                                --paga a proveedor
                                --pInd_pago_prove
                                   --  'S' indica que es un comprobante hacia CxP
                                   --  'N' indica que es un comprobante hacia CxC
                                   --  'X' indica que es un comprobante que no va a CxC ni a CxP
 pMsg_error      out varchar2

) IS

 CURSOR c_indicadores_caja IS
   SELECT permite_afectar_cxc, permite_pago_a_cxp
   FROM taffmc
   WHERE no_cia   = pCia
     AND cod_caja = pCaja;

    vPermite_afectar_cxc    taffmc.permite_afectar_cxc%type;
    vPermite_pago_a_cxp     taffmc.permite_pago_a_cxp%type;
    vMonto_liquidacion_nom  taffmm.monto_nom%type;
    vMonto_liquidacion_dol  taffmm.monto_dol%type;
    vMonto_devolucion_nom   taffmm.monto_nom%type;
    vMonto_devolucion_dol   taffmm.monto_dol%type;
    vMonto_anulacion_nom    taffmm.monto_nom%type;
    vMonto_anulacion_dol    taffmm.monto_dol%type;
    vEncontro               boolean;
BEGIN

  --Obtiene los indicadores a nivel de caja sobre
  --relacion fondo fijo con CxC
  --relacion fondo fijo con CxP

  OPEN  c_indicadores_caja;
  FETCH c_indicadores_caja INTO vPermite_afectar_cxc, vPermite_pago_a_cxp;
  vEncontro := c_indicadores_caja%found;
  CLOSE c_indicadores_caja;
  IF NOT vEncontro THEN
  	 pMsg_error := 'La caja '||pCaja||' no tiene los indicadores de afectar a CxC o pago a proveedores';
  END IF;


  IF pTipo = 'R' THEN  --Regitro de comprobantes
    --Los campos comprobante_nominal y comprobante_dolares acumulan el monto
    --total de los comprobantes cancelados en fondo fijo
    UPDATE taffmc
       SET saldo_nominal       = saldo_nominal - nvl(pMonto_nom,0),
           saldo_dolares       = saldo_dolares - nvl(pMonto_dol,0),
           comprobante_nominal = nvl(comprobante_nominal,0)  + nvl(pMonto_nom,0)
                                                             - nvl(pSaldo_nom,0),
           comprobante_dolares = nvl(comprobante_dolares,0)  + nvl(pMonto_dol,0)
                                                             - nvl(pSaldo_dol,0)
     WHERE no_cia   = pCia
       AND cod_caja = pCaja;

    IF  vPermite_afectar_cxc = 'S' AND pInd_pago_prove = 'N' THEN
    	  -- Se acumula el monto de los documentos que estan
    	  -- pendientes en CxC por concepto de Fondo Fijo
	     UPDATE taffmc
	        SET comp_cxc_nominal  = nvl(comp_cxc_nominal,0) + nvl(pSaldo_nom,0),
	            comp_cxc_dolares  = nvl(comp_cxc_dolares,0) + nvl(pSaldo_dol,0)
	     WHERE no_cia   = pCia
	       AND cod_caja = pCaja;
    END IF;

    IF  vPermite_pago_a_cxp = 'S' AND pInd_pago_prove = 'S' THEN
    	 --Se acumulan el monto total que se
    	 --paga a los proveedores por medio de Fondo Fijo
	     UPDATE taffmc
	        SET comp_cxp_nominal  = nvl(comp_cxp_nominal,0) + nvl(pMonto_nom,0),
              comp_cxp_dolares  = nvl(comp_cxp_dolares,0) + nvl(pMonto_dol,0)
        WHERE no_cia   = pCia
	       AND cod_caja = pCaja;
    END IF;

  ELSIF pTipo = 'L' THEN    --Liquidacion de comprobantes

     --Guarda los parametros en variables significativas
     vMonto_liquidacion_nom := nvl(pMonto_nom,0);
     vMonto_liquidacion_dol := nvl(pMonto_dol,0);

     UPDATE taffmc
        SET comprobante_nominal = nvl(comprobante_nominal,0) + vMonto_liquidacion_nom,
            comprobante_dolares = nvl(comprobante_dolares,0) + vMonto_liquidacion_dol
      WHERE no_cia   = pCia
	      AND cod_caja = pCaja;

     IF  vPermite_afectar_cxc = 'S' AND pInd_pago_prove = 'N' THEN
	     --Actualiza los campos que reflejan los comprobantes que se envian a CxC
             UPDATE taffmc
	        SET comp_cxc_nominal    = nvl(comp_cxc_nominal,0)    - vMonto_liquidacion_nom,
	            comp_cxc_dolares    = nvl(comp_cxc_dolares,0)    - vMonto_liquidacion_dol
	      WHERE no_cia   = pCia
	        AND cod_caja = pCaja;
     END IF;


  ELSIF pTipo = 'D' THEN  --Devolucion de comprobantes

  	--Guarda los parametros en variables significativas
     vMonto_devolucion_nom := nvl(pMonto_nom,0);
     vMonto_devolucion_dol := nvl(pMonto_dol,0);

    --Actualiza los campos afectados por la devolucion
    UPDATE taffmc
       SET saldo_nominal             = saldo_nominal + vMonto_devolucion_nom,
           saldo_dolares             = saldo_dolares + vMonto_devolucion_dol,
           devolucion_dinero_nominal = nvl(devolucion_dinero_nominal,0) + vMonto_devolucion_nom,
           devolucion_dinero_dolares = nvl(devolucion_dinero_dolares,0) + vMonto_devolucion_dol
     WHERE no_cia   = pCia
       AND cod_caja = pCaja;

    --
    IF vPermite_afectar_cxc = 'S' AND pInd_pago_prove = 'N' THEN
    	--Actualiza los campos que reflejan los comprobantes que se envian a CxC
	    UPDATE taffmc
	       SET comp_cxc_nominal          = nvl(comp_cxc_nominal,0) - vMonto_devolucion_nom,
	           comp_cxc_dolares          = nvl(comp_cxc_dolares,0) - vMonto_devolucion_dol
	     WHERE no_cia   = pCia
	       AND cod_caja = pCaja;
    END IF;


  ELSIF pTipo = 'A' THEN   --Anulacion de comprobantes

    --Guarda los parametros en variables significativas
     vMonto_anulacion_nom := nvl(pMonto_nom,0);
     vMonto_anulacion_dol := nvl(pMonto_dol,0);

      --Actualiza los campos afectados por la anulacion
    	UPDATE taffmc
         SET saldo_nominal       = Nvl(saldo_nominal,0) + vMonto_anulacion_nom,
             saldo_dolares       = Nvl(saldo_dolares,0) + vMonto_anulacion_dol
     WHERE no_cia  = pCia
      AND cod_caja = pCaja;

    IF  vPermite_afectar_cxc = 'S' AND pInd_pago_prove = 'N' THEN
    	--Actualiza los campos que reflejan los comprobantes que se envian a CxC
    	UPDATE taffmc
         SET comp_cxc_nominal    = Nvl(comp_cxc_nominal,0) - vMonto_anulacion_nom,
             comp_cxc_dolares    = Nvl(comp_cxc_dolares,0) - vMonto_anulacion_dol
     WHERE no_cia  = pCia
      AND cod_caja = pCaja;
    END IF;

  END IF;

END;