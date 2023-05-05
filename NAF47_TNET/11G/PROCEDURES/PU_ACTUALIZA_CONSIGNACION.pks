create or replace procedure            PU_ACTUALIZA_CONSIGNACION(pv_noDocu    VARCHAR2,
                                                      pv_noCia     VARCHAR2,
                                                      pv_centro    VARCHAR2,
                                                      pv_error OUT VARCHAR2) is
 -- Declaracion de Cursores
 CURSOR C_detalleTransf(cv_noDocu varchar2,
                        cv_noCia  varchar2,
                        cv_centro varchar2) IS
  SELECT AD.NO_ARTI,AD.CANTIDAD,
        CO.NO_SOLICITUD
  FROM  ARINENCCONSIGNACLI CO,
        ARINTE AR,
        ARINTL AD
  WHERE CO.NO_DOCU = AR.NO_DOCU_REF
  AND   CO.NO_DOCU_REF = AR.NO_DOCU
  AND   AR.NO_CIA = AD.NO_CIA
  AND   AR.NO_DOCU = AD.NO_DOCU
  AND   AR.NO_DOCU = cv_noDocu
  AND   AR.NO_CIA = cv_noCia
  AND   AR.CENTRO = cv_centro
  AND   AR.ESTADO  = 'P';

-- Declaracion de variables
LV_ERROR     varchar2(100) := NULL;
le_error     exception;

begin
 --
 IF pv_noDocu IS NULL THEN
  LV_ERROR := 'El numero de Transaccion no tiene valor';
  raise le_error;
 END IF;
 --
 IF pv_noCia IS NULL THEN
  LV_ERROR := 'La compamia no tiene valor';
  raise le_error;
 END IF;
 --
 IF pv_centro IS NULL THEN
  LV_ERROR := 'El centro no tiene valor';
  raise le_error;
 END IF;
 --
 FOR reg IN C_detalleTransf(pv_noDocu,pv_noCia,pv_centro) LOOP
   BEGIN
    --
    UPDATE ARINDETCONSIGNACLI CL
     SET   CL.UNI_TRANSFERIDA = REG.CANTIDAD
     WHERE CL.NO_ARTI = REG.NO_ARTI
     AND   CL.NO_DOCU = (SELECT CC.NO_DOCU
                          FROM  ARINENCCONSIGNACLI CC
                          WHERE   CC.NO_SOLICITUD = REG.NO_SOLICITUD);
     --
     IF SQL%NOTFOUND THEN
      LV_ERROR := 'Error, registro no actualizado en Detalle de Consignaciones';
      PV_ERROR := LV_ERROR;
      EXIT;
     END IF;
   END;
 END LOOP;
 --
 BEGIN
   UPDATE ARINENCCONSIGNACLI EC
    SET   EC.ESTADO = 'T'
    WHERE EC.NO_DOCU_REF = pv_noDocu
    AND   EC.NO_CIA = pv_noCia
    AND   EC.CENTRO = pv_centro;
   --
   IF SQL%NOTFOUND THEN
    LV_ERROR := 'Error registro no actualizado en el estado de Consignacion';
    PV_ERROR := LV_ERROR;
   END IF;
 END;
 --
 IF LV_ERROR IS NULL THEN
  commit;
 ELSE
  rollback;
 END IF;
--
EXCEPTION
 WHEN le_error THEN
  PV_ERROR := LV_ERROR;
 WHEN  OTHERS THEN
  LV_ERROR := 'Error General  '||SQLERRM;
  PV_ERROR := LV_ERROR;
  ROLLBACK;
end PU_ACTUALIZA_CONSIGNACION;