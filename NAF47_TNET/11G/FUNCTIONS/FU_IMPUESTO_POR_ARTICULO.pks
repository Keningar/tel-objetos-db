create or replace FUNCTION            FU_IMPUESTO_POR_ARTICULO (
    pv_no_cia    VARCHAR2,
    pv_no_arti   VARCHAR2,
    pn_valor     NUMBER,
    pv_compra_venta VARCHAR2 default 'V') --C Por Compra, V Por Venta
    RETURN NUMBER IS
CURSOR c_calcula_impuestos IS
  SELECT b.porcentaje
    FROM arinia a,arcgimp b
   WHERE a.no_cia  = pv_no_cia
     AND a.no_arti = pv_no_arti
     AND decode(pv_compra_venta,'V',a.afecta_venta,'C',a.afecta_compra)='S'
     AND a.no_cia = b.no_cia
     AND a.clave  = b.clave;
ln_impuestos  NUMBER := 0;
BEGIN
  FOR i IN c_calcula_impuestos LOOP
      ln_impuestos:=ln_impuestos+((pn_valor*i.porcentaje)/100);
  END LOOP;
  RETURN(ln_impuestos);
END;