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
 -- Lv_SufijoActualizacion	 VARCHAR2(100) := '_ANTERIOR_AL_CPM_AGOSTO_2022';
BEGIN
  T_PlanesInfoTecnica('EN_PLAN_30M') := '995';
  T_PlanesInfoTecnica('EN_PLAN_50M') := '994';
  T_PlanesInfoTecnica('EN_PLAN_100M') := '993';
  T_PlanesInfoTecnica('EN_PLAN_130M') := '992';
  T_PlanesInfoTecnica('EN_PLAN_150M') := '991';
  T_PlanesInfoTecnica('EN_PLAN_200M') := '990';

  /*DBMS_OUTPUT.PUT_LINE('ID_OLT|NOMBRE_OLT|ID_DET_ELEM_LINE-PROFILE-ID|LINE-PROFILE-ID|ID_DET_ELEM_LINE-PROFILE-NAME|LINE-PROFILE-NAME|ID_DET_ELEM_GEM-PORT|GEM-PORT|ID_DET_ELEM_TRAFFIC-TABLE|TRAFFIC-TABLE');*/
    DBMS_OUTPUT.PUT_LINE('ID_OLT|ID_DET_ELEM_LINE-PROFILE-ID|ID_DET_ELEM_LINE-PROFILE-NAME|ID_DET_ELEM_GEM-PORT|ID_DET_ELEM_TRAFFIC-TABLE');
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
                               
      ---------------LINE-PROFILE-ID-----------------------                                             
                               
      Ln_IdDetElemLineProfileId := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (
          ID_DETALLE_ELEMENTO,
          ELEMENTO_ID,
          DETALLE_NOMBRE,
          DETALLE_VALOR,
          DETALLE_DESCRIPCION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          REF_DETALLE_ELEMENTO_ID,
          ESTADO
        )
        VALUES
        (
          Ln_IdDetElemLineProfileId,
          Ln_IdElementoOlt,
          'LINE-PROFILE-ID',
          Lv_ValorLineGemTraffic,
          'LINE-PROFILE-ID',
          'jpiloso',
          CURRENT_TIMESTAMP,
          '127.0.0.1',
          NULL,
          'Activo'
        );
      
      ---------------LINE-PROFILE-NAME-----------------------    
      
      Ln_IdDetElemLineProfileName := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (
          ID_DETALLE_ELEMENTO,
          ELEMENTO_ID,
          DETALLE_NOMBRE,
          DETALLE_VALOR,
          DETALLE_DESCRIPCION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          REF_DETALLE_ELEMENTO_ID,
          ESTADO
        )
        VALUES
        (
          Ln_IdDetElemLineProfileName,
          Ln_IdElementoOlt,
          'LINE-PROFILE-NAME',
          Lv_ValorLineProfileName,
          Lv_ValorLineProfileName,
          'jpiloso',
          CURRENT_TIMESTAMP,
          '127.0.0.1',
          Ln_IdDetElemLineProfileId,
          'Activo'
        );
      
      
      ---------------GEM-PORT-----------------------

      Ln_IdDetElemGemPort := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (
          ID_DETALLE_ELEMENTO,
          ELEMENTO_ID,
          DETALLE_NOMBRE,
          DETALLE_VALOR,
          DETALLE_DESCRIPCION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          REF_DETALLE_ELEMENTO_ID,
          ESTADO
        )
        VALUES
        (
          Ln_IdDetElemGemPort,
          Ln_IdElementoOlt,
          'GEM-PORT',
          Lv_ValorLineGemTraffic,
          Lv_ValorLineGemTraffic,
          'jpiloso',
          CURRENT_TIMESTAMP,
          '127.0.0.1',
          Ln_IdDetElemLineProfileId,
          'Activo'
        );
      
      
      ---------------TRAFFIC-TABLE-----------------------
      
      Ln_IdDetElemTrafficTable := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        (
          ID_DETALLE_ELEMENTO,
          ELEMENTO_ID,
          DETALLE_NOMBRE,
          DETALLE_VALOR,
          DETALLE_DESCRIPCION,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          REF_DETALLE_ELEMENTO_ID,
          ESTADO
        )
        VALUES
        (
          Ln_IdDetElemTrafficTable,
          Ln_IdElementoOlt,
          'TRAFFIC-TABLE',
          Lv_ValorLineGemTraffic,
          Lv_ValorLineGemTraffic,
          'jpiloso',
          CURRENT_TIMESTAMP,
          '127.0.0.1',
          Ln_IdDetElemLineProfileName,
          'Activo'
        );
      
      DBMS_OUTPUT.PUT_LINE(Ln_IdElementoOlt || '|' ||
      			       Ln_IdDetElemLineProfileId || '|' ||
      			       Ln_IdDetElemLineProfileName || '|' ||
      			       Ln_IdDetElemGemPort || '|' ||
      			       Ln_IdDetElemTrafficTable);
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


