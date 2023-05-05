create or replace PROCEDURE            INActualiza_saldos_articulo (
  pNo_cia    varchar2,
  pBodega    varchar2,
  pNo_arti   varchar2,
  pTipo      varchar2,
  pUnidades  number,
  pMonto     number,
  pFecha     date,
  pMensaje   IN OUT varchar2
) IS
  --
  -- Realiza la actualizacion de los saldos (en monto y unidades) de un articulo en
  -- una bodega. El articulo DEBE estar creado en la bodega sino devuelve un error.
  -- El tipo de actualizacion se relaciona con el movimiento que esta se actualizando.
  -- Los posibles valores son :
  --                           COMPRA
  --                           PRODUCCION
  --                           DESPACHO, OBSEQUIOS/DONACIONES
  --                           RECEPCION
  --                           CONSUMO
  --                           TRASLADO
  --                           MANIFIESTO
  --                           AJUSTE
  --
  -- Devuelve en pmensaje cualquier error ocurrido durante la actualizacion de saldos.
  --
  vCompra_un    arinma.comp_un%type   := 0;
  vCompra_mon   arinma.comp_mon%type  := 0;
  vOtrs_un      arinma.otrs_un%type   := 0;
  vOtrs_mon     arinma.otrs_mon%type  := 0;
  vVenta_un     arinma.vent_un%type   := 0;
  vVenta_mon    arinma.vent_mon%type  := 0;
  vCons_un      arinma.cons_un%type   := 0;
  vCons_mon     arinma.cons_mon%type  := 0;
  vFecha        arinma.fec_u_ven%type := Null;
  --
  
  CURSOR C_VALIDA_STOCK ( Cn_Compra_un NUMBER,
                          Cn_Otrs_un NUMBER,
                          Cn_Venta_un NUMBER,
                          Cn_Cons_un NUMBER
                         ) IS
    SELECT ( nvl(SAL_ANT_UN,0) + 
            (nvl(COMP_UN,0)+Cn_Compra_un) + 
            (nvl(OTRS_UN,0)+Cn_Otrs_un)   - 
            (nvl(VENT_UN,0)+Cn_Venta_un)   - 
            (nvl(CONS_UN,0)+Cn_Cons_un)
            ) SALDO
      FROM ARINMA
     WHERE no_cia    = pNo_cia
	     AND bodega    = pBodega
	     AND no_arti   = pNo_arti;
  
  --
  Ln_Saldo NUMBER := 0;
  
  error_proceso exception;
BEGIN

	IF pTipo = 'COMPRA' THEN
		vCompra_un   := pUnidades;
		vCompra_mon  := pMonto;
	ELSIF pTipo IN ('PRODUCCION', 'TRASLADO', 'MANIFIESTO', 'AJUSTE') THEN
    vOtrs_un     := pUnidades;
    vOtrs_mon		 := pMonto;
  -- Se utiliza este pTipo para las ventas y los obsequios/donaciones
	ELSIF pTipo = 'DESPACHO' THEN
    vVenta_un    := pUnidades;
    vVenta_mon   := pMonto;
    vFecha       := pFecha;
	ELSIF pTipo = 'RECEPCION' THEN
    vVenta_un    := -pUnidades;
    vVenta_mon   := -pMonto;
	ELSIF pTipo = 'CONSUMO' THEN
		vCons_un     := pUnidades;
		vCons_mon    := pMonto;
	ELSE
		pMensaje := 'INACTUALIZA_SALDOS_ARTICULO : Parametro TIPO = '||pTipo||' no es valido';
		RAISE error_proceso;
	END IF;

  IF C_VALIDA_STOCK%ISOPEN THEN CLOSE C_VALIDA_STOCK; END IF;
  OPEN C_VALIDA_STOCK( vCompra_un,vOtrs_un,vVenta_un,vCons_un);
  FETCH C_VALIDA_STOCK INTO Ln_Saldo;
  IF C_VALIDA_STOCK%NOTFOUND THEN
    Ln_Saldo := 0;
  END IF;
  CLOSE C_VALIDA_STOCK;
    
  IF Ln_Saldo < 0 THEN
    pMensaje := 'Bod:'||pBodega||' Art:'||pNo_arti||'. saldo negativo';
    RAISE error_proceso;
  END IF;
  
	--
  UPDATE arinma
     SET comp_un   = nvl(comp_un,0)   + vCompra_un,   -- compras
         comp_mon  = nvl(comp_mon,0)  + vCompra_mon,
         vent_un   = nvl(vent_un, 0)  + vVenta_un,    -- despacho / recepcion
         vent_mon  = nvl(vent_mon, 0) + vVenta_mon,
         fec_u_ven = nvl(vFecha, fec_u_ven),
         otrs_un   = nvl(otrs_un, 0)  + vOtrs_un,     -- otros : produccion
         otrs_mon  = nvl(otrs_mon, 0) + vOtrs_mon,
         cons_un   = nvl(cons_un,0)   + vCons_un,     -- consumo interno
         cons_mon  = nvl(cons_mon,0)  + vCons_mon
   WHERE no_cia    = pNo_cia
	   AND bodega    = pBodega
	   AND no_arti   = pNo_arti;

   --
   -- si el articulo no existe devuelve error.
   IF sql%rowcount = 0 THEN
   	 pmensaje := 'El ariculo '||pNo_arti||' no esta definido en la bodega '||pBodega;
   	 RAISE error_proceso;
   END IF;

EXCEPTION
  WHEN error_proceso THEN
       return;
  WHEN others THEN
		   pMensaje := 'INACTUALIZA_SALDOS_ARTICULO : '||sqlerrm;
       return;
END;