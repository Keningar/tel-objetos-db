create or replace FUNCTION            PLSiguiente_accion_tmp(
  pNo_cia varchar2
) RETURN varchar2 IS
  --
  vno_accion	arplap.no_accion%type;
  --
  -- obtiene el ultimo numero de accion generada
  CURSOR c_cia IS
    SELECT nvl(no_accion_tmp,0) + 1
      FROM arplmc
     WHERE no_cia = pNo_cia
       FOR UPDATE OF no_accion_tmp;
BEGIN
  OPEN  c_cia;
  FETCH c_cia INTO vno_accion;
  CLOSE c_cia;

  vNo_accion := nvl(vNo_accion, 1);

  IF vNo_accion is not null THEN

    UPDATE arplmc
       SET no_accion_tmp = vNo_accion
     WHERE no_cia = pNo_cia;

  END IF;

  RETURN (vno_accion);
END;