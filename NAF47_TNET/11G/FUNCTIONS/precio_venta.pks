create or replace FUNCTION            precio_venta(
  no_cia_p   IN varchar2,
  tprecio_p  IN varchar2,
  no_arti_p  IN varchar2

) RETURN number IS
  --
  -- Obtiene el precio de venta del articulo en el segmento (tipo de precio) dado.
  -- En caso de no tener precio definido en el segmento, utiliza el precio base del
  -- articulo.
  -- Devuelve en pMoneda la moneda en que se encuentra definido el precio.
  --
  CURSOR c_precio_seg IS
    SELECT d.moneda_precioBase, d.precioBase, t.ind_precio_fijo,
                    t.porc_variacion, t.redondeo, t.precio, t.moneda
     FROM arintp t, arinda d
     WHERE t.no_cia    = no_cia_p
       AND t.codigo    = no_arti_p
       AND t.tipo      = tprecio_p
       AND t.no_cia    = d.no_cia
       AND t.codigo    = d.no_arti;
  --
   --
  vEncontrado   boolean;
  vprecio       arintp.precio%type;
  --
  rtp           c_precio_seg%rowtype;
BEGIN
  --
  -- recupera precio o variacion porcentual en el segmento de mercado
  OPEN  c_precio_seg;
  FETCH c_precio_seg INTO rtp;
  vEncontrado := c_precio_seg%FOUND;
  CLOSE c_precio_seg;
  --
  IF vEncontrado THEN
       vprecio := rtp.precio;
   ELSE
    vprecio := 0;
  END IF;

  return ( nvl(vprecio,0) );
END;