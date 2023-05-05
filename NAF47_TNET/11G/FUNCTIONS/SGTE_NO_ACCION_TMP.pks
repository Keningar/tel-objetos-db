create or replace FUNCTION SGTE_NO_ACCION_TMP
 (VNO_CIA CHAR
 )
 RETURN CHAR
 IS
-- PL/SQL Specification
vno_accion	ARPLAP.NO_ACCION_TMP%TYPE;
  CURSOR c_cia IS
    SELECT NVL(no_accion_tmp,0) + 1
    FROM arplmc
    WHERE no_cia = vno_cia;
   ---- FOR UPDATE OF no_accion_tmp;

-- PL/SQL Block
BEGIN
  OPEN c_cia;
  FETCH c_cia INTO vno_accion;
  IF c_cia%notfound then
   vno_accion := null;
   ClOSE c_cia;
  ELSE
   CLOSE c_cia;
  END IF;

  IF vno_accion IS NOT NULL THEN
     UPDATE arplmc
       SET no_accion_tmp = vno_accion
      --- WHERE CURRENT OF c_cia;
      WHERE no_cia = vno_cia;
     vno_accion := '1.'||vno_accion;
  END IF;
  RETURN (vno_accion);
END;
