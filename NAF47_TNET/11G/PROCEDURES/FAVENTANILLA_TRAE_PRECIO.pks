create or replace procedure            FAVENTANILLA_TRAE_PRECIO (pno_cia       varchar2,
                                                      p_moneda      varchar2,
                                                      p_tipo_precio varchar2,
                                                      p_no_arti     varchar2,
                                                      p_tipo_cambio varchar2,
                                                      p_precio      out number,
                                                      p_error       out varchar2) IS

  vprecio           arfafl.precio%type;
  vmoneda_doc       arfafec.moneda%type;
  vmoneda_precio    arintp.moneda%type;
BEGIN
  p_error := '';
  vmoneda_doc := p_moneda;

  vprecio     := precio_venta(pno_cia, p_tipo_precio, p_no_arti);

  if vprecio is null then
    p_error := 'El articulo no tiene precios definidos';
  end if;

  if vmoneda_doc = 'D' and vmoneda_precio = 'P' then
     -- convierte precio a dolares
     vprecio := vprecio / p_tipo_cambio;

  elsif vmoneda_doc = 'P' and vmoneda_precio = 'D' then
     -- covierte precio a nominal
     vprecio := vprecio * p_tipo_cambio;
  end if;

  if nvl(vprecio, 0) <= 0 then
    p_error := 'El precio del articulo no puede ser 0 ni menor';
  end if;

  p_precio := vprecio;

end FAVENTANILLA_TRAE_PRECIO;