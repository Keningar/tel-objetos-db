create or replace FUNCTION            CPSector_impuesto(
  pCia         IN ARCGMC.no_cia%type,
  pNo_prove    IN ARCPMP.no_prove%type,
  pClave       IN ARCGIMP.clave%type,
  pmsg_error   IN OUT varchar2
) RETURN varchar2 IS
  -- En el caso de que el proveedor no tenga definida su ubicacion,
	-- la funcion devuelve el primer sector seleccionado
  vid_sec   arcgdisec.id_sec%type;
  vExiste   boolean;
  --
  CURSOR c_Imp_Sec IS
    SELECT a.id_sec
      FROM arcgdisec a, arcpmp b
     WHERE a.no_cia      = pCia
       AND a.Clave       = pClave
       AND a.No_Cia      = b.No_Cia
       AND b.No_prove    = pno_prove
       AND a.pais        = nvl(b.pais,      a.pais)
       AND nvl(a.provincia, b.provincia) = nvl(b.provincia, a.provincia)
       AND nvl(a.canton,    b.canton)    = nvl(b.canton,    a.canton)
       AND nvl(a.Sector,    b.Sector)    = nvl(b.sector,    a.sector)
       AND nvl(a.actividad, b.Actividad) = nvl(b.Actividad, a.Actividad);
BEGIN
  vid_sec := NULL;
  IF NOT impuesto.existe(pCia, pClave) THEN
    pmsg_error := 'Codigo de Impuesto: '||pClave||' no existe';
  ELSIF impuesto.Sectorizable (pCia, pClave) THEN
    OPEN  c_Imp_Sec;
    FETCH c_Imp_Sec INTO vid_sec;
    vExiste := c_Imp_Sec%FOUND;
    CLOSE c_Imp_Sec;
    IF not vexiste THEN
       vId_Sec := NULL;
    END IF;
  END IF;
  return( vid_sec );
END;