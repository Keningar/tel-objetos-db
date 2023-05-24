CREATE OR REPLACE PACKAGE NAF47_TNET.INV_PK_RECU_MASTER AS

/*
 *
 * @author jxzurita <jxzurita@telconet.ec>
 * @version 1.2 17/05/2023
 * @modificaciones: Se modifica para el uso de pragma.
 * 
 */

  PROCEDURE PRC_GUARDA_HISTORICO(PN_COMPANIA       NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                 PV_COD_ARTICULO   NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE,
                                 PN_ID_REGION_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                 PV_COD_BODEGA_OLD NAF47_TNET.INV_ARTI_RECU_MASTER.BODEGA%TYPE,
                                 PV_REGLA_OLD      NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                 PV_REGLA_NEW      NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                 PN_STOCK_MIN_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                 PN_STOCK_MIN_NEW  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                 PN_STOCK_MAX_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                 PN_STOCK_MAX_NEW  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                 PV_ACCION         VARCHAR2,
                                 PV_MOTIVO         NAF47_TNET.INV_ARTI_RECU_MASTER_HIS.MOTIVO%TYPE,
                                 PV_USR_CREACION   NAF47_TNET.INV_ARTI_RECU_MASTER.USR_CREACION%TYPE,
                                 PD_FE_CREACION    NAF47_TNET.INV_ARTI_RECU_MASTER.FE_CREACION%TYPE);

  PROCEDURE PRC_GUARDA_ARTICULO(PN_COMPANIA     NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                PV_COD_ARTICULO NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE,
                                PN_ID_REGION    NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                PV_COD_BODEGA   NAF47_TNET.INV_ARTI_RECU_MASTER.BODEGA%TYPE,
                                PV_REGLA        NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                PN_STOCK_MIN    NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                PN_STOCK_MAX    NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                PV_MOTIVO       NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP.MOTIVO%TYPE,
                                PV_ERROR        OUT VARCHAR2);

  PROCEDURE PRC_GUARDA_ARTICULO_POST(PV_COMPANIA     NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_EMPRESA%TYPE,
                                     PV_COD_ARTICULO NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_ARTICULO%TYPE,
                                     PN_ID_REGION    NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_REGION%TYPE,
                                     PN_STOCK_MIN    NAF47_TNET.ARIN_ARTI_RECU_TMP.CANTIDAD_MINIMA%TYPE,
                                     PN_STOCK_MAX    NAF47_TNET.ARIN_ARTI_RECU_TMP.CANTIDAD_MAXIMA%TYPE,
                                     PV_MOTIVO       NAF47_TNET.ARIN_ARTI_RECU_TMP.MOTIVO%TYPE,
                                     PV_ERROR        OUT VARCHAR2);

  PROCEDURE PRC_ACTUALIZA_MODIF_ELIM(PV_USER_MODIFICA NAF47_TNET.INV_ARTI_RECU_MASTER.USR_CREACION%TYPE,
                                     PV_NO_CIA        NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                     PN_ID_REGION     NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                     PV_NO_ARTI       NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE);

  --post
  PROCEDURE PRC_REPLICA_RECU_TO_TMP(PV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE,
                                    PV_ACCION  VARCHAR2,
                                    PV_ERROR   OUT VARCHAR2);

  --PRE
  PROCEDURE PRC_REPLICA_RECU_TO_TMP_PRE(PV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE,
                                        PV_ACCION  VARCHAR2,
                                        PV_ERROR   OUT VARCHAR2);

  PROCEDURE PRC_REGISTRA_CAMBIO_POST(pv_cod_arti naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_articulo%type,
                                     pn_region   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_region%type,
                                     pv_empresa  naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_empresa%type,
                                     pn_minimo   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.cantidad_minima%type,
                                     pn_maximo   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.cantidad_maxima%type,
                                     pv_motivo   naf47_tnet.ARIN_ARTI_RECU_HIS.motivo%type);

  PROCEDURE PRC_NOTIFICAR_FINALIZADO(PN_ERROR OUT NUMBER,
                                     PV_ERROR OUT VARCHAR2);

  PROCEDURE PRC_REPROGRAMAR_JOB(PV_HORA_EJECUCION VARCHAR2,
                                PV_MSG            out varchar2,
                                pv_error          out varchar2);
END INV_PK_RECU_MASTER;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.INV_PK_RECU_MASTER AS

  LV_PAQUETE      varchar2(200) := 'INV_PK_RECU_MASTER'; 

  PROCEDURE PRC_GUARDA_HISTORICO(PN_COMPANIA       NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                 PV_COD_ARTICULO   NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE,
                                 PN_ID_REGION_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                 PV_COD_BODEGA_OLD NAF47_TNET.INV_ARTI_RECU_MASTER.BODEGA%TYPE,
                                 PV_REGLA_OLD      NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                 PV_REGLA_NEW      NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                 PN_STOCK_MIN_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                 PN_STOCK_MIN_NEW  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                 PN_STOCK_MAX_OLD  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                 PN_STOCK_MAX_NEW  NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                 PV_ACCION         VARCHAR2,
                                 PV_MOTIVO         NAF47_TNET.INV_ARTI_RECU_MASTER_HIS.MOTIVO%TYPE,
                                 PV_USR_CREACION   NAF47_TNET.INV_ARTI_RECU_MASTER.USR_CREACION%TYPE,
                                 PD_FE_CREACION    NAF47_TNET.INV_ARTI_RECU_MASTER.FE_CREACION%TYPE) IS
    LN_MAXIMO_SEC NUMBER;
  BEGIN
    BEGIN
      SELECT MAX(ID_HIST)
        INTO LN_MAXIMO_SEC
        FROM NAF47_TNET.INV_ARTI_RECU_MASTER_HIS;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        LN_MAXIMO_SEC := 0;
    END;

    IF LN_MAXIMO_SEC IS NULL THEN
      LN_MAXIMO_SEC := 0;
    END IF;

    INSERT INTO NAF47_TNET.INV_ARTI_RECU_MASTER_HIS
      (ID_HIST,
       NO_CIA,
       NO_ARTI,
       ID_REGION,
       BODEGA,
       STOCK_MINIMO,
       STOCK_MINIMO_OLD,
       STOCK_MAXIMO,
       STOCK_MAXIMO_OLD,
       REGLA,
       REGLA_OLD,
       ACCION,
       MOTIVO,
       usr_creacion,
       fe_creacion,
       usr_modifica,
       fe_modifica)
    VALUES
      (LN_MAXIMO_SEC + 1,
       PN_COMPANIA,
       PV_COD_ARTICULO,
       PN_ID_REGION_OLD,
       PV_COD_BODEGA_OLD,
       PN_STOCK_MIN_NEW,
       PN_STOCK_MIN_OLD,
       PN_STOCK_MAX_NEW,
       PN_STOCK_MAX_OLD,
       PV_REGLA_NEW,
       PV_REGLA_OLD,
       PV_ACCION,
       PV_MOTIVO,
       PV_USR_CREACION,
       Pd_fe_creacion,
       user,
       sysdate);

    COMMIT;
  END;

  PROCEDURE PRC_ACTUALIZA_MODIF_ELIM(PV_USER_MODIFICA NAF47_TNET.INV_ARTI_RECU_MASTER.USR_CREACION%TYPE,
                                     PV_NO_CIA        NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                     PN_ID_REGION     NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                     PV_NO_ARTI       NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE) IS

  BEGIN
    UPDATE NAF47_TNET.inv_arti_recu_master
       SET USR_MODIFICA = PV_USER_MODIFICA, FE_MODIFICA = SYSDATE
     WHERE NO_CIA = PV_NO_CIA
       AND ID_REGION = PN_ID_REGION
       AND NO_ARTI = PV_NO_ARTI;

    COMMIT;
  END;

  PROCEDURE PRC_GUARDA_ARTICULO(PN_COMPANIA     NAF47_TNET.INV_ARTI_RECU_MASTER.NO_CIA%TYPE,
                                PV_COD_ARTICULO NAF47_TNET.INV_ARTI_RECU_MASTER.NO_ARTI%TYPE,
                                PN_ID_REGION    NAF47_TNET.INV_ARTI_RECU_MASTER.ID_REGION%TYPE,
                                PV_COD_BODEGA   NAF47_TNET.INV_ARTI_RECU_MASTER.BODEGA%TYPE,
                                PV_REGLA        NAF47_TNET.INV_ARTI_RECU_MASTER.REGLA%TYPE,
                                PN_STOCK_MIN    NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MINIMO%TYPE,
                                PN_STOCK_MAX    NAF47_TNET.INV_ARTI_RECU_MASTER.STOCK_MAXIMO%TYPE,
                                PV_MOTIVO       NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP.MOTIVO%TYPE,
                                PV_ERROR        OUT VARCHAR2) IS

  BEGIN
    INSERT INTO NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP
      (ID_EMPRESA,
       ID_ARTICULO,
       ID_REGION,
       REGLA,
       BODEGA,
       STOCK_MINIMO,
       STOCK_MAXIMO,
       MOTIVO)
    VALUES
      (PN_COMPANIA,
       PV_COD_ARTICULO,
       PN_ID_REGION,
       PV_REGLA,
       PV_COD_BODEGA,
       PN_STOCK_MIN,
       PN_STOCK_MAX,
       PV_MOTIVO);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      PV_ERROR := 'Se present\F3 un error al registrar el art\EDculo. ' ||
                  sqlerrm;
  END;

  PROCEDURE PRC_GUARDA_ARTICULO_POST(PV_COMPANIA     NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_EMPRESA%TYPE,
                                     PV_COD_ARTICULO NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_ARTICULO%TYPE,
                                     PN_ID_REGION    NAF47_TNET.ARIN_ARTI_RECU_TMP.ID_REGION%TYPE,
                                     PN_STOCK_MIN    NAF47_TNET.ARIN_ARTI_RECU_TMP.CANTIDAD_MINIMA%TYPE,
                                     PN_STOCK_MAX    NAF47_TNET.ARIN_ARTI_RECU_TMP.CANTIDAD_MAXIMA%TYPE,
                                     PV_MOTIVO       NAF47_TNET.ARIN_ARTI_RECU_TMP.MOTIVO%TYPE,
                                     PV_ERROR        OUT VARCHAR2) IS

    LV_PROGRAMA varchar2(200) := LV_PAQUETE||'.'||'PRC_GUARDA_ARTICULO_POST';

    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN

    INSERT INTO NAF47_TNET.ARIN_ARTI_RECU_TMP
      (ID_EMPRESA,
       ID_ARTICULO,
       ID_REGION,
       CANTIDAD_MINIMA,
       CANTIDAD_MAXIMA,
       MOTIVO)
    VALUES
      (PV_COMPANIA,
       PV_COD_ARTICULO,
       PN_ID_REGION,
       PN_STOCK_MIN,
       PN_STOCK_MAX,
       PV_MOTIVO);

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      PV_ERROR := LV_PROGRAMA||'-Se present\F3 un error al registrar el art\EDculo. ' || substr(sqlerrm,1,200);
  END;

  PROCEDURE PRC_REPLICA_RECU_TO_TMP(PV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE,
                                    PV_ACCION  VARCHAR2,
                                    PV_ERROR   OUT VARCHAR2) IS
    CURSOR C_GET_DATA_RECURRENTES(CV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE) IS
      SELECT *
        FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP A
       WHERE A.ID_EMPRESA = CV_EMPRESA
         AND MES = (SELECT MAX(MES)
                      FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
                     WHERE ANIO = A.ANIO)
         AND ANIO =
             (SELECT MAX(ANIO) FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP)
         AND SEMANA = (SELECT MAX(SEMANA)
                         FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
                        WHERE ANIO = A.ANIO) --TO_CHAR(SYSDATE, 'WW')
         AND ESTADO = 'I';

    CURSOR C_EXISTE_INFO_TMP2 IS
      SELECT 'X'
        FROM NAF47_TNET.ARIN_ARTI_RECU_TMP
       WHERE MOTIVO != '**REVISION FINALIZADA**'
          OR MOTIVO IS NULL;

    CURSOR C_EXISTE_INFO_TMP3 IS
      SELECT 'X'
        FROM NAF47_TNET.ARIN_ARTI_RECU_TMP
       WHERE MOTIVO = '**REVISION FINALIZADA**';

    LV_RESP   VARCHAR2(1);
    LB_EXISTE BOOLEAN;
    L_RESP_C  C_GET_DATA_RECURRENTES%ROWTYPE;

    LV_PROGRAMA varchar2(200) := LV_PAQUETE||'.'||'PRC_REPLICA_RECU_TO_TMP';
    PRAGMA AUTONOMOUS_TRANSACTION;

  BEGIN
    IF PV_ACCION IS NULL THEN
      OPEN C_EXISTE_INFO_TMP2;
      FETCH C_EXISTE_INFO_TMP2
        INTO LV_RESP;
      LB_EXISTE := C_EXISTE_INFO_TMP2%FOUND;
      CLOSE C_EXISTE_INFO_TMP2;

      IF NOT LB_EXISTE THEN
        OPEN C_GET_DATA_RECURRENTES(PV_EMPRESA);
        FETCH C_GET_DATA_RECURRENTES
          INTO L_RESP_C;
        LB_EXISTE := C_GET_DATA_RECURRENTES%FOUND;
        CLOSE C_GET_DATA_RECURRENTES;

        IF LB_EXISTE THEN
          --SI EXISTE DATA PARA CARGAR, SE DEBE ELIMINAR LO QUE HAY EN LA TEMPORAL
          OPEN C_EXISTE_INFO_TMP3;
          FETCH C_EXISTE_INFO_TMP3
            INTO LV_RESP;
          LB_EXISTE := C_EXISTE_INFO_TMP3%FOUND;
          CLOSE C_EXISTE_INFO_TMP3;

          IF LB_EXISTE THEN
            DELETE FROM ARIN_ARTI_RECU_TMP;
            COMMIT;
          END IF;

          FOR ARTICULO IN C_GET_DATA_RECURRENTES(PV_EMPRESA) LOOP
            INSERT INTO NAF47_TNET.ARIN_ARTI_RECU_TMP
              (ID_EMPRESA,
               ID_ARTICULO,
               ID_REGION,
               CANTIDAD_MINIMA,
               CANTIDAD_MAXIMA,
               MOTIVO)
            VALUES
              (ARTICULO.ID_EMPRESA,
               ARTICULO.ID_ARTICULO,
               ARTICULO.ID_REGION,
               ARTICULO.CANTIDAD_MINIMA,
               ARTICULO.CANTIDAD_MAXIMA,
               null);
          END LOOP;
          COMMIT;
        ELSE
          PV_ERROR := LV_PROGRAMA||'-A\FAn no se ha generado una nueva etapa de revisi\F3n.';
        END IF;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      PV_ERROR := LV_PROGRAMA||'-Error al programar proceso de Generaci\F3n de Solicitudes de Pedido. Contactarse con Sistemas.'||substr(sqlerrm,1,200);
  END;

  --PRE
  PROCEDURE PRC_REPLICA_RECU_TO_TMP_PRE(PV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE,
                                        PV_ACCION  VARCHAR2,
                                        PV_ERROR   OUT VARCHAR2) IS
    CURSOR C_GET_DATA_RECURRENTES(CV_EMPRESA NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP.ID_EMPRESA%TYPE) IS
      SELECT *
        FROM NAF47_TNET.INV_ARTI_RECU_MASTER A
       WHERE A.NO_CIA = CV_EMPRESA
         AND ESTADO = 'I';

    CURSOR C_EXISTE_INFO_TMP2 IS
      SELECT 'X'
        FROM NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP
       WHERE MOTIVO != '**REVISION FINALIZADA**'
          OR MOTIVO IS NULL;

    CURSOR C_EXISTE_INFO_TMP3 IS
      SELECT 'X'
        FROM NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP
       WHERE MOTIVO = '**REVISION FINALIZADA**';

    LV_RESP   VARCHAR2(1);
    LB_EXISTE BOOLEAN;
    L_RESP_C  C_GET_DATA_RECURRENTES%ROWTYPE;

  BEGIN
    IF PV_ACCION IS NULL THEN
      OPEN C_EXISTE_INFO_TMP2;
      FETCH C_EXISTE_INFO_TMP2
        INTO LV_RESP;
      LB_EXISTE := C_EXISTE_INFO_TMP2%FOUND;
      CLOSE C_EXISTE_INFO_TMP2;

      IF NOT LB_EXISTE THEN
        OPEN C_GET_DATA_RECURRENTES(PV_EMPRESA);
        FETCH C_GET_DATA_RECURRENTES
          INTO L_RESP_C;
        LB_EXISTE := C_GET_DATA_RECURRENTES%FOUND;
        CLOSE C_GET_DATA_RECURRENTES;

        IF LB_EXISTE THEN
          --SI EXISTE DATA PARA CARGAR, SE DEBE ELIMINAR LO QUE HAY EN LA TEMPORAL
          OPEN C_EXISTE_INFO_TMP3;
          FETCH C_EXISTE_INFO_TMP3
            INTO LV_RESP;
          LB_EXISTE := C_EXISTE_INFO_TMP3%FOUND;
          CLOSE C_EXISTE_INFO_TMP3;

          IF LB_EXISTE THEN
            DELETE FROM ARIN_ARTI_RECU_PRE_TMP;
            COMMIT;
          END IF;

          FOR ARTICULO IN C_GET_DATA_RECURRENTES(PV_EMPRESA) LOOP
            INSERT INTO NAF47_TNET.ARIN_ARTI_RECU_PRE_TMP
              (ID_EMPRESA,
               ID_ARTICULO,
               ID_REGION,
               REGLA,
               BODEGA,
               STOCK_MINIMO,
               STOCK_MAXIMO,
               MOTIVO)
            VALUES
              (ARTICULO.NO_CIA,
               ARTICULO.NO_ARTI,
               ARTICULO.ID_REGION,
               ARTICULO.REGLA,
               ARTICULO.BODEGA,
               ARTICULO.STOCK_MINIMO,
               ARTICULO.STOCK_MAXIMO,
               NULL);
          END LOOP;
          COMMIT;
        ELSE
          PV_ERROR := 'No se ha realizado la carga de articulos al sistema.';
        END IF;
      END IF;
    END IF;
  END;

  PROCEDURE PRC_REGISTRA_CAMBIO_POST(pv_cod_arti naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_articulo%type,
                                     pn_region   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_region%type,
                                     pv_empresa  naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.id_empresa%type,
                                     pn_minimo   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.cantidad_minima%type,
                                     pn_maximo   naf47_tnet.ARIN_ARTICULO_RECURRENTE_TEMP.cantidad_maxima%type,
                                     pv_motivo   naf47_tnet.ARIN_ARTI_RECU_HIS.motivo%type) IS

  BEGIN
    if pn_minimo is not null and pn_maximo is null and pv_motivo is null then
      update naf47_tnet.ARIN_ARTI_RECU_HIS a
         set a.cantidad_minima = pn_minimo,
             a.usr_ult_mod     = user,
             a.fecha_ult_mod   = sysdate,
             A.ACCION          = 'M'
       where a.id_articulo = pv_cod_arti
         and a.id_empresa = pv_empresa
         and a.id_region = pn_region;
    elsif pn_minimo is null and pn_maximo is null and pv_motivo is null then
      update naf47_tnet.ARIN_ARTI_RECU_HIS a
         set a.cantidad_maxima = pn_maximo,
             a.usr_ult_mod     = user,
             a.fecha_ult_mod   = sysdate,
             A.ACCION          = 'M'
       where a.id_articulo = pv_cod_arti
         and a.id_empresa = pv_empresa
         and a.id_region = pn_region;
    elsif pn_minimo is null and pn_maximo is null and pv_motivo is not null then
      update naf47_tnet.ARIN_ARTI_RECU_HIS a
         set a.motivo = pv_motivo
       where a.id_articulo = pv_cod_arti
         and a.id_empresa = pv_empresa
         and a.id_region = pn_region;
    end if;
    COMMIT;
  END;

  PROCEDURE PRC_NOTIFICAR_FINALIZADO(PN_ERROR OUT NUMBER,
                                     PV_ERROR OUT VARCHAR2) IS
    CURSOR C_GET_PARAMETROS(CV_ID_PARAMETRO VARCHAR2) IS
      select B.VALOR1 as VALOR
        from DB_GENERAL.ADMI_PARAMETRO_CAB A,
             DB_GENERAL.ADMI_PARAMETRO_DET B
       WHERE A.NOMBRE_PARAMETRO = 'PARAMETROS_NOTIFICACION_NAF'
         AND A.ID_PARAMETRO = B.PARAMETRO_ID
         AND UPPER(A.ESTADO) = UPPER(B.ESTADO)
         AND B.DESCRIPCION = CV_ID_PARAMETRO
         AND UPPER(A.ESTADO) = 'ACTIVO';

    LV_ASUNTO_MAIL      VARCHAR2(2000);
    LV_REMITENTE        VARCHAR2(2000);
    LV_DESTINATARIOS_TO VARCHAR2(2000);
    LV_DESTINATARIOS_CC VARCHAR2(2000);
    LV_CUERPO_MAIL      VARCHAR2(2000);
    LB_EXISTE_PAR       BOOLEAN;

  BEGIN
    --OBTECION DE PARAMETROS
    OPEN C_GET_PARAMETROS('PLANTILLA_CUERPO_MAIL');
    FETCH C_GET_PARAMETROS
      INTO LV_CUERPO_MAIL;
    LB_EXISTE_PAR := C_GET_PARAMETROS%FOUND;
    CLOSE C_GET_PARAMETROS;

    IF NOT LB_EXISTE_PAR THEN
      PN_ERROR := -1;
      PV_ERROR := 'No se pudo obtener el cuerpo del mail.';
    END IF;
    --
    OPEN C_GET_PARAMETROS('REMITENTE_MAIL');
    FETCH C_GET_PARAMETROS
      INTO LV_REMITENTE;
    LB_EXISTE_PAR := C_GET_PARAMETROS%FOUND;
    CLOSE C_GET_PARAMETROS;

    IF NOT LB_EXISTE_PAR THEN
      PN_ERROR := -1;
      PV_ERROR := 'No se pudo obtener el remitente del mail.';
    END IF;
    --
    OPEN C_GET_PARAMETROS('LISTA_DESTINATARIOS_TO');
    FETCH C_GET_PARAMETROS
      INTO LV_DESTINATARIOS_TO;
    LB_EXISTE_PAR := C_GET_PARAMETROS%FOUND;
    CLOSE C_GET_PARAMETROS;

    IF NOT LB_EXISTE_PAR THEN
      PN_ERROR := -1;
      PV_ERROR := 'No se pudo obtener el destinatario principal.';
    END IF;
    --
    OPEN C_GET_PARAMETROS('LISTA_DESTINATARIOS_CC');
    FETCH C_GET_PARAMETROS
      INTO LV_DESTINATARIOS_CC;
    CLOSE C_GET_PARAMETROS;
    --
    OPEN C_GET_PARAMETROS('ASUNTO_MAIL');
    FETCH C_GET_PARAMETROS
      INTO LV_ASUNTO_MAIL;
    LB_EXISTE_PAR := C_GET_PARAMETROS%FOUND;
    CLOSE C_GET_PARAMETROS;

    IF NOT LB_EXISTE_PAR THEN
      PN_ERROR := -1;
      PV_ERROR := 'No se pudo obtener el asunto de mail.';
    END IF;

    --REEMPLAZO DE FECHAS
    LV_CUERPO_MAIL := REPLACE(REPLACE(LV_CUERPO_MAIL,
                                      '#FECHA#',
                                      TO_CHAR(SYSDATE, 'DD/MM/YYYY')),
                              '#HORA#',
                              TO_CHAR(SYSDATE, 'HH24:MI:SS'));

    IF LB_EXISTE_PAR THEN
      BEGIN
        SYS.UTL_MAIL.SEND(SENDER     => LV_REMITENTE, --
                          RECIPIENTS => LV_DESTINATARIOS_TO, --
                          CC         => LV_DESTINATARIOS_CC, --
                          SUBJECT    => LV_ASUNTO_MAIL, --
                          MIME_TYPE  => 'text/html; charset=us-ascii',
                          MESSAGE    => LV_CUERPO_MAIL);
        PN_ERROR := 0;
        PV_ERROR := 'La notificaci' || chr(243) || 'n ha sido enviado con ' ||
                    chr(233) || 'xito.';
      EXCEPTION
        WHEN OTHERS THEN
          PN_ERROR := -1;
          PV_ERROR := 'Se present\F3 un problema al enviar mail.';
      END;
    END IF;
  END;

  PROCEDURE PRC_REPROGRAMAR_JOB(PV_HORA_EJECUCION VARCHAR2,
                                PV_MSG            out varchar2,
                                pv_error          out varchar2) IS
    CURSOR C_GET_FECHA(CV_HORA VARCHAR2) IS
      SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' ' || CV_HORA || ':00' ||
             ' AMERICA/GUAYAQUIL'
        FROM DUAL;

    LV_FECHA VARCHAR2(60);
    lv_sql   varchar2(32000);

    ln_res   number;
    lv_msg   varchar2(4000);

    PRAGMA AUTONOMOUS_TRANSACTION;

    LV_PROGRAMA varchar2(200) := LV_PAQUETE||'.'||'PRC_REPROGRAMAR_JOB';

  BEGIN
    OPEN C_GET_FECHA(PV_HORA_EJECUCION);
    FETCH C_GET_FECHA
      INTO LV_FECHA;
    CLOSE C_GET_FECHA;
    /*
    lv_sql := 'declare begin ';

    lv_sql := lv_sql ||'DBMS_SCHEDULER.enable(name => ''"NAF47_TNET"."JOB_ARTICULO_RECURRENTE"'');'||chr(10);
    lv_sql := lv_sql ||'DBMS_SCHEDULER.set_attribute_null(name      => ''"NAF47_TNET"."JOB_ARTICULO_RECURRENTE"'', ';
    lv_sql := lv_sql ||'attribute => ''repeat_interval''); '||chr(10);
    lv_sql := lv_sql ||'DBMS_SCHEDULER.set_attribute(name      => ''"NAF47_TNET"."JOB_ARTICULO_RECURRENTE"'',';
    lv_sql := lv_sql ||'attribute => ''start_date'',';
    lv_sql := lv_sql ||'value     => TO_TIMESTAMP_TZ('''||LV_FECHA||''',';
    lv_sql := lv_sql ||'''YYYY-MM-DD HH24:MI:SS TZR'')); end;'; 
    insert into trace_dev_prueba values('PRC_REPROGRAMAR_JOB',sysdate, lv_sql);
    commit;*/

    lv_sql := 'declare'||chr(10);
    lv_sql := lv_sql ||'lv_job_name varchar2(50) := ''"NAF47_TNET"."JOB_ARTICULO_RECURRENTE"'';'||chr(10);
    lv_sql := lv_sql ||'lv_enable     varchar2(5) := ''FALSE'';'||chr(10);
    lv_sql := lv_sql ||'lv_state      varchar2(15);'||chr(10);
    lv_sql := lv_sql ||'ln_resultado  number := 0;'||chr(10);
    lv_sql := lv_sql ||'begin'||chr(10);
    lv_sql := lv_sql ||'DBMS_SCHEDULER.enable(name => lv_job_name);'||chr(10);
    lv_sql := lv_sql ||'DBMS_SCHEDULER.set_attribute_null(name      => lv_job_name,'||chr(10);
    lv_sql := lv_sql ||'attribute => ''repeat_interval'');'||chr(10);
    lv_sql := lv_sql ||'DBMS_SCHEDULER.set_attribute(name      => lv_job_name,'||chr(10);
    lv_sql := lv_sql ||'attribute => ''start_date'','||chr(10);
    lv_sql := lv_sql ||'value     => TO_TIMESTAMP_TZ('''||LV_FECHA||''',''YYYY-MM-DD HH24:MI:SS TZR''));'||chr(10);
    lv_sql := lv_sql ||'begin '||chr(10);
    lv_sql := lv_sql ||'select enabled, state, '||chr(10);
               lv_sql := lv_sql ||'case when '||chr(10);
               lv_sql := lv_sql ||'next_start_date = TO_TIMESTAMP_TZ('''||LV_FECHA||''',''YYYY-MM-DD HH24:MI:SS TZR'') then 1 else 0 end as resultado '||chr(10);
               lv_sql := lv_sql ||'into lv_enable, lv_state, ln_resultado'||chr(10);
               lv_sql := lv_sql ||'from all_scheduler_job_dests a where a.job_name = ''JOB_ARTICULO_RECURRENTE'';'||chr(10);


        lv_sql := lv_sql ||'exception'||chr(10);
        lv_sql := lv_sql ||'when no_data_found then'||chr(10);
             lv_sql := lv_sql ||':res := 777;'||chr(10);
             lv_sql := lv_sql ||':msg := ''No Data Found all_scheduler_job_dests'';'||chr(10);
             lv_sql := lv_sql ||'return;'||chr(10);
        lv_sql := lv_sql ||'when others then'||chr(10);
             lv_sql := lv_sql ||':res := -999;'||chr(10);
             lv_sql := lv_sql ||':msg := ''Error all_scheduler_job_dests->''||substr(sqlerrm,1,500);'||chr(10);
             lv_sql := lv_sql ||'return;'||chr(10);
        lv_sql := lv_sql ||'end;'||chr(10);
       lv_sql := lv_sql ||'if(lv_state = ''SCHEDULED'')then'||chr(10);
                   lv_sql := lv_sql ||'if(lv_enable = ''TRUE'')then'||chr(10);
                                lv_sql := lv_sql ||'if(ln_resultado = 1)then'||chr(10);
                                   lv_sql := lv_sql ||' :res := 1;'||chr(10);
                                   lv_sql := lv_sql ||' :msg := ''Job agendado correctamente'';'||chr(10);
                               lv_sql := lv_sql ||' else'||chr(10);
                                    lv_sql := lv_sql ||':res := 0;'||chr(10);
                                   lv_sql := lv_sql ||' :msg := ''Job no agendado a la hora correcta'';'||chr(10);
                                lv_sql := lv_sql ||'end if;'||chr(10);
                   lv_sql := lv_sql ||'else'||chr(10);
                                lv_sql := lv_sql ||' :res := 0;'||chr(10);
                                lv_sql := lv_sql ||' :msg := ''Job Deshabilitado'';'||chr(10);
                   lv_sql := lv_sql ||'end if;'||chr(10);
       lv_sql := lv_sql ||'else'||chr(10);
                   lv_sql := lv_sql ||' :res := 0;'||chr(10);
                   lv_sql := lv_sql ||' :msg := ''Job No Agendado'';'||chr(10);
       lv_sql := lv_sql ||'end if;'||chr(10);
       lv_sql := lv_sql ||'end;'||chr(10);

    execute immediate lv_sql using out ln_res, out lv_msg;

    commit;

    PV_MSG := 'Las Solicitudes de Pedidos se generaran el d\EDa ' ||
              to_char(sysdate, 'dd/mm/yyyy') || ' a las ' ||
              PV_HORA_EJECUCION||' Codigo: '||ln_res||' | '||lv_msg;
  EXCEPTION
    WHEN OTHERS THEN
      rollback;
      PV_ERROR := LV_PROGRAMA||'-Error al programar proceso de Generaci\F3n de Solicitudes de Pedido. Contactarse con Sistemas.'||substr(sqlerrm,1,200);
  END;
END;
/
