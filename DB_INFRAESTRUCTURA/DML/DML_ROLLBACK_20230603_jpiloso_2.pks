SET SERVEROUTPUT ON
DECLARE
TYPE T_ArrayAsocPlan
IS
  TABLE OF VARCHAR2(4) INDEX BY VARCHAR2(15);
  T_PlanesInfoTecnica T_ArrayAsocPlan;
  Lv_NombrePlanTecnico VARCHAR2(15);
  CURSOR Lc_GetOlts
  IS
    SELECT DISTINCT OLT.ID_ELEMENTO
    FROM DB_INFRAESTRUCTURA.VISTA_ELEMENTOS OLT
    WHERE OLT.NOMBRE_TIPO_ELEMENTO = 'OLT'
    AND OLT.EMPRESA_COD            = '18'
    AND OLT.NOMBRE_MARCA_ELEMENTO  = 'HUAWEI'
    AND EXISTS
      (SELECT IDE_MIDDLEWARE.ID_DETALLE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE_MIDDLEWARE
      WHERE OLT.ID_ELEMENTO             = IDE_MIDDLEWARE.ELEMENTO_ID
      AND IDE_MIDDLEWARE.DETALLE_NOMBRE = 'MIDDLEWARE'
      AND IDE_MIDDLEWARE.DETALLE_VALOR  = 'SI'
      AND IDE_MIDDLEWARE.ESTADO         = 'Activo'
      )
    AND (OLT.ESTADO = 'Activo' OR OLT.ESTADO = 'Modificado');
  Ln_IdElementoOlt               NUMBER;
  Ln_IdDetElemLineProfileId      NUMBER;
  Ln_IdDetElemLineProfileName    NUMBER;
  Ln_IdDetElemServiceProfileId   NUMBER;
  Ln_IdDetElemServiceProfileName NUMBER;
  Ln_IdDetElemGemPort            NUMBER;
  Ln_IdDetElemTrafficTable       NUMBER;
  Lv_ValorLineGemTraffic         VARCHAR2(4)  := '';
  Lv_ValorLineProfileName        VARCHAR2(15) := '';
BEGIN
  T_PlanesInfoTecnica('EN_PLAN_30M') := '995';
  T_PlanesInfoTecnica('EN_PLAN_50M') := '994';
  T_PlanesInfoTecnica('EN_PLAN_100M') := '993';
  T_PlanesInfoTecnica('EN_PLAN_130M') := '992';
  T_PlanesInfoTecnica('EN_PLAN_150M') := '991';
  T_PlanesInfoTecnica('EN_PLAN_200M') := '990';

 
  IF Lc_GetOlts%ISOPEN THEN
    CLOSE Lc_GetOlts;
  END IF;
  FOR I_GetOlts IN Lc_GetOlts
  LOOP
    Ln_IdElementoOlt     := I_GetOlts.ID_ELEMENTO;
    Lv_NombrePlanTecnico := T_PlanesInfoTecnica.first;
    WHILE (Lv_NombrePlanTecnico IS NOT NULL)
    LOOP
      Lv_ValorLineProfileName := Lv_NombrePlanTecnico;
      Lv_ValorLineGemTraffic  := T_PlanesInfoTecnica(Lv_NombrePlanTecnico);
     
     ---------------TRAFFIC-TABLE-----------------------
      DELETE 
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID = Ln_IdElementoOlt
      AND DETALLE_NOMBRE = 'TRAFFIC-TABLE'
      AND DETALLE_VALOR = Lv_ValorLineGemTraffic
      AND DETALLE_DESCRIPCION = Lv_ValorLineGemTraffic
      AND USR_CREACION = 'jpiloso';
      
       SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de TRAFFIC-TABLE'); 
     
     ---------------GEM-PORT-----------------------
     
      DELETE 
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID = Ln_IdElementoOlt
      AND DETALLE_NOMBRE = 'GEM-PORT'
      AND DETALLE_VALOR = Lv_ValorLineGemTraffic
      AND DETALLE_DESCRIPCION = Lv_ValorLineGemTraffic
      AND USR_CREACION = 'jpiloso';
      
      SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de GEM-PORT'); 
     
      ---------------LINE-PROFILE-NAME----------------------- 
      DELETE 
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID = Ln_IdElementoOlt
      AND DETALLE_NOMBRE = 'LINE-PROFILE-NAME'
      AND DETALLE_VALOR = Lv_ValorLineProfileName
      AND DETALLE_DESCRIPCION = Lv_ValorLineProfileName
      AND USR_CREACION = 'jpiloso';
      
      SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de -LINE-PROFILE-NAME'); 
                               
      ---------------LINE-PROFILE-ID-----------------------                                             
      DELETE 
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID = Ln_IdElementoOlt
      AND DETALLE_NOMBRE = 'LINE-PROFILE-ID'
      AND DETALLE_VALOR = Lv_ValorLineGemTraffic
      AND DETALLE_DESCRIPCION = 'LINE-PROFILE-ID'
      AND USR_CREACION = 'jpiloso';
      
      SYS.DBMS_OUTPUT.PUT_LINE('Eliminacion de -LINE-PROFILE-ID'); 
      
      COMMIT;
      Lv_NombrePlanTecnico := T_PlanesInfoTecnica.next(Lv_NombrePlanTecnico);
    END LOOP;
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;

