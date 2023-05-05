CREATE OR REPLACE package            INCONSIGNACION is
-- Author  : MGUARANDA
-- Created : 18/11/2008 18:31:51
-- Purpose : Validacion de consignaciones

PROCEDURE PU_ACTUALIZA_CONSIGNACION(pv_noDocu    VARCHAR2,
                                    pv_noCia     VARCHAR2,
                                    pv_centro    VARCHAR2,
                                    pv_error OUT VARCHAR2);
--
PROCEDURE PU_ACTUALIZA_DEVOLUCION(pv_noDocu   VARCHAR2,
                                  pv_noCia     VARCHAR2,
                                  pv_centro    VARCHAR2,
                                  pv_error OUT VARCHAR2);
--
PROCEDURE PU_VALIDAR(pv_noDocu    VARCHAR2,
                     pv_noCia     VARCHAR2,
                     pv_centro    VARCHAR2,
                     pv_error OUT VARCHAR2);


end INCONSIGNACION;
/


CREATE OR REPLACE package body            INCONSIGNACION is
-- Author  : MGUARANDA
-- Created : 18/11/2008 18:31:51
-- Purpose : Validacion de consignaciones

procedure PU_ACTUALIZA_CONSIGNACION(pv_noDocu    VARCHAR2,
                                    pv_noCia     VARCHAR2,
                                    pv_centro    VARCHAR2,
                                    pv_error OUT VARCHAR2) is
 -- Declaracion de Cursores
 CURSOR C_detalleTransf(cv_noDocu varchar2,
                        cv_noCia  varchar2,
                        cv_centro varchar2) IS
  SELECT AD.NO_ARTI,AD.CANTIDAD,
        CO.NO_DOCU,CO.NO_CIA
  FROM  ARINENCCONSIGNACLI CO,
        ARINTE AR,
        ARINTL AD
  WHERE CO.NO_DOCU = AR.NO_DOCU_REF
  AND   CO.NO_DOCU_REF = AR.NO_DOCU
  AND   AR.NO_CIA = AD.NO_CIA
  AND   AR.NO_DOCU = AD.NO_DOCU
  AND   AR.NO_DOCU = cv_noDocu
  AND   AR.NO_CIA = cv_noCia
  AND   CO.NO_CIA = cv_noCia
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
     AND   CL.NO_DOCU = REG.NO_DOCU
     AND   CL.NO_CIA = REG.NO_CIA;
     --
     IF SQL%NOTFOUND THEN
      LV_ERROR := 'Error, registro no actualizado en Detalle de Consignaciones';
      EXIT;
     END IF;
   END;
 END LOOP;
 --
 IF LV_ERROR IS NOT NULL THEN
  raise le_error;
 END IF;
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

/**************************************************************************************--
--**************************************************************************************/
procedure PU_ACTUALIZA_DEVOLUCION(pv_noDocu    VARCHAR2,
                                  pv_noCia     VARCHAR2,
                                  pv_centro    VARCHAR2,
                                  pv_error OUT VARCHAR2) is
 -- Declaracion de Cursores
 CURSOR C_detalleDev(cv_noDocu varchar2,
                     cv_noCia  varchar2,
                     cv_centro varchar2) IS
  SELECT AD.NO_ARTI,AD.CANTIDAD,
        CO.NO_DOCU_CONSIG,CO.NO_CIA
  FROM  ARINENCCONSIGNACLI CO,
        ARINTE AR,
        ARINTL AD
  WHERE CO.NO_DOCU = AR.NO_DOCU_REF
  AND   CO.NO_DOCU_REF = AR.NO_DOCU
  AND   AR.NO_CIA = AD.NO_CIA
  AND   AR.NO_DOCU = AD.NO_DOCU
  AND   AR.NO_DOCU = cv_noDocu
  AND   AR.NO_CIA = cv_noCia
  AND   CO.NO_CIA = cv_noCia
  AND   AR.CENTRO = cv_centro
  AND   AR.ESTADO  = 'P';

-- Declaracion de variables
LV_ERROR     varchar2(100) := NULL;
le_error     exception;
--
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
 FOR reg IN C_detalleDev(pv_noDocu,pv_noCia,pv_centro) LOOP
   BEGIN
    --
    UPDATE ARINDETCONSIGNACLI CL
     SET   CL.UNI_DEVUELTAS = NVL(CL.UNI_DEVUELTAS,0) + NVL(REG.CANTIDAD,0)
     WHERE CL.NO_ARTI = REG.NO_ARTI
     AND   CL.NO_DOCU = (SELECT CC.NO_DOCU
                          FROM  ARINENCCONSIGNACLI CC
                          WHERE   CC.NO_DOCU = REG.NO_DOCU_CONSIG)
     AND   CL.NO_CIA = REG.NO_CIA;
     --
     IF SQL%NOTFOUND THEN
      LV_ERROR := 'Error, registro no actualizado en Detalle de Consignaciones';
      EXIT;
     END IF;
   END;
 END LOOP;
 --
 IF LV_ERROR IS NOT NULL THEN
  raise le_error;
 END IF;
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
end PU_ACTUALIZA_DEVOLUCION;

/****************************************************************************************************************************************************************************/
PROCEDURE PU_VALIDAR(pv_noDocu    VARCHAR2,
                     pv_noCia     VARCHAR2,
                     pv_centro    VARCHAR2,
                     pv_error OUT VARCHAR2)IS

--Declaracion de Cursoees
 CURSOR NO_DOCU_REF(cv_noCia     VARCHAR2,
                    cv_Centro    VARCHAR2,
                    cv_noDocuRef VARCHAR2
                    )IS
 SELECT CL.NO_DOCU
  FROM ARINENCCONSIGNACLI CL
  WHERE CL.NO_CIA = cv_noCia
  AND   CL.CENTRO = cv_Centro
  AND   CL.NO_DOCU_REF = cv_noDocuRef;
 --
 CURSOR C_TIPO_DOC (cv_noCia  VARCHAR2,
                    cv_Centro VARCHAR2,
                    cv_noDocu VARCHAR2
                   )IS
  SELECT VN.MOVIMI
   FROM ARINVTM VN
   WHERE VN.NO_CIA = cv_noCia
   AND  VN.INTERFACE = 'CS'
   AND  VN.TIPO_M = (SELECT CL.TIPO_DOC
                      FROM ARINENCCONSIGNACLI CL
                      WHERE CL.NO_CIA = cv_noCia
                      AND   CL.CENTRO = cv_Centro
                      AND   CL.NO_DOCU = cv_noDocu);

--Declaracion de variables
lv_movimi       VARCHAR2(1);
lb_existe       BOOLEAN;
lv_error        VARCHAR2(100);
le_error        EXCEPTION;
lv_noDocuRef    VARCHAR2(12);
lv_noDocu       VARCHAR2(12);
lv_noCia        VARCHAR2(2);
lv_centro       VARCHAR2(2);

BEGIN
 --
 lv_noCia  := pv_noCia;
 lv_centro := pv_centro;
 lv_noDocuRef := pv_noDocu;
 --
 OPEN  NO_DOCU_REF(lv_noCia,lv_centro,lv_noDocuRef);
 FETCH NO_DOCU_REF INTO lv_noDocu;
 CLOSE NO_DOCU_REF;
 --
 OPEN  C_TIPO_DOC(lv_noCia,lv_centro,lv_noDocu);
 FETCH C_TIPO_DOC INTO lv_movimi;
 lb_existe := C_TIPO_DOC%FOUND;
 CLOSE C_TIPO_DOC;
 --
 IF NOT lb_existe THEN
  lv_error := 'No existe el Movimiento E/S Asociado a el Numero de Documento';
  RAISE le_error;
 END IF;
 --
 IF lv_movimi = 'S' THEN
  --
  PU_ACTUALIZA_CONSIGNACION(pv_noDocu  => lv_noDocuRef,
                            pv_noCia   => lv_noCia,
                            pv_centro  => lv_centro,
                            pv_error   => lv_error
                            );
  --
  IF lv_error IS NOT NULL THEN
   RAISE le_error;
  END IF;
  --
 ELSIF lv_movimi = 'E' THEN
  --
  PU_ACTUALIZA_DEVOLUCION(pv_noDocu  => lv_noDocuRef,
                          pv_noCia   => lv_noCia,
                          pv_centro  => lv_centro,
                          pv_error   => lv_error
                          );
  --
  IF lv_error IS NOT NULL THEN
   RAISE le_error;
  END IF;
 --
 END IF;
 --
EXCEPTION
 WHEN le_error THEN
  pv_error:= lv_error;
 WHEN others THEN
  pv_error:= 'Error '||SQLERRM;
END;

end INCONSIGNACION;
/
