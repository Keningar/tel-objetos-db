create or replace FUNCTION            CCSector_impuesto(
  pCia         IN arcgmc.no_cia%type,
  pGrupo       IN arccmc.grupo%type,
  pCliente     IN arccmc.no_cliente%type,
  pClave       IN arcgimp.clave%type,
  pmsg_error   IN OUT varchar2
) RETURN varchar2 IS
  vid_sec   arcgdisec.id_sec%type;
  vExiste   boolean;
  --
  CURSOR c_Imp_Sec IS
    SELECT a.id_sec
      FROM arcgdisec a, arccmc b
     WHERE a.no_cia      = pCia
       AND a.Clave       = pClave
       AND a.No_Cia      = b.No_Cia
       AND b.Grupo       = pGrupo
       AND b.No_Cliente  = pCliente
       AND a.pais        = b.pais
       AND a.provincia   = b.provincia
       AND a.canton      = b.canton
       AND a.Sector      = b.sector
       AND a.actividad   = b.Actividad;
  --
BEGIN
  vid_sec := NULL;
  IF not impuesto.existe(pCia, pClave) THEN
    pmsg_error := 'Codigo de Impuesto: '||pClave||' no existe';
  ELSE
    IF impuesto.Sectorizable (pCia, pClave) THEN
      OPEN  c_Imp_Sec;
      FETCH c_Imp_Sec INTO vid_sec;
      vExiste := c_Imp_Sec%FOUND;
      CLOSE c_Imp_Sec;

      IF not vexiste THEN
        vid_sec := Null;
      END IF;
    END IF;
  END IF;
  return( vid_sec );
END;