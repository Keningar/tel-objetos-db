create or replace PROCEDURE            p_gen_ped_sugerido AS

 CURSOR c_producto IS
SELECT no_cia,
  no_prove,
  no_arti
FROM arimprodu FOR

UPDATE;

vno_cia arimprodu.no_cia%TYPE;

vno_prove arimprodu.no_prove%TYPE;

vno_arti arimprodu.no_arti%TYPE;

BEGIN
  OPEN C_PRODUCTO;
  LOOP
    FETCH C_PRODUCTO INTO vNO_CIA, vNO_PROVE, vNO_ARTI;
    EXIT WHEN C_PRODUCTO%NOTFOUND;
    UPDATE ARIMPRODU SET PEDIDO_SUGERIDO=0 WHERE CURRENT OF C_PRODUCTO;

  END LOOP;
  CLOSE C_PRODUCTO;
END;