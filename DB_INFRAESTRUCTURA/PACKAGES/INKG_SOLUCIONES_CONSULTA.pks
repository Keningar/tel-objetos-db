SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_SOLUCIONES_CONSULTA AS

  /**
   * Documentación para el procedimiento 'P_OBTENER_SERVIDOR_POR_SOLUC'.
   *
   * Método encargado de retornar lista servidores por solución.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 07-05-2020
   */
  PROCEDURE P_OBTENER_SERVIDOR_POR_SOLUC(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el procedimiento 'P_OBTENER_DISCO_POR_SERVICIO'.
   *
   * Método encargado de retornar lista de discos contratados por servicio.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 07-05-2020
   */
  PROCEDURE P_OBTENER_DISCO_POR_SERVICIO(Pcl_Request  IN  CLOB,
                                      Pv_Status    OUT VARCHAR2,
                                      Pv_Mensaje   OUT VARCHAR2,
                                      Pcl_Response OUT SYS_REFCURSOR);

  /**
   * Documentación para el procedimiento 'P_OBTENER_LICENCIA_POR_SOLUC'.
   *
   * Método encargado de retornar lista licencias por solución.
   *
   * @param Pcl_Request  IN  CLOB Recibe json request.
   * @param Pv_Status    OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje   OUT VARCHAR2 Retorna el mensaje de la transacción.
   * @param Pcl_Response OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 07-05-2020
   */
  PROCEDURE P_OBTENER_LICENCIA_POR_SOLUC(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR);

END INKG_SOLUCIONES_CONSULTA;

/
CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_SOLUCIONES_CONSULTA AS

 PROCEDURE P_OBTENER_SERVIDOR_POR_SOLUC(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS

    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_FromAndJoin   CLOB;
    Lcl_Where         CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_ServicioId     NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(2000);

  BEGIN

    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ServicioId := APEX_JSON.get_number(p_path => 'servicioId');

    -- VALIDACIONES
    IF Ln_ServicioId IS NULL THEN
      Lv_Mensaje := 'El parámetro servicioId esta vacío';
      RAISE Le_Exception;
    END IF;

    Lcl_Select := '
              SELECT ELEMENTO.ID_ELEMENTO IDELEMENTO, 
                     ELEMENTO.NOMBRE_ELEMENTO NOMBREELEMENTO,
                     SRC.DESCRIPCION_RECURSO MODELO ';

    Lcl_FromAndJoin := '
              FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET SRD
              JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
              ON ELEMENTO.ID_ELEMENTO = SRD.ELEMENTO_ID
              JOIN DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC
              ON SRC.ID_SERVICIO_RECURSO_CAB = SRD.SERVICIO_RECURSO_CAB_ID
              JOIN DB_COMERCIAL.INFO_SOLUCION_DET SOLUCION_DET
              ON SOLUCION_DET.SERVICIO_ID = SRC.SERVICIO_ID
              JOIN DB_COMERCIAL.INFO_SOLUCION_CAB SOLUCION_CAB
              ON SOLUCION_CAB.ID_SOLUCION_CAB = SOLUCION_DET.SOLUCION_CAB_ID ';

    Lcl_Where := '
              WHERE SOLUCION_CAB.NUMERO_SOLUCION = (SELECT SOLUCION_CAB2.NUMERO_SOLUCION
                                                    FROM  DB_COMERCIAL.INFO_SOLUCION_CAB SOLUCION_CAB2
                                                    JOIN DB_COMERCIAL.INFO_SOLUCION_DET SOLUCION_DET2
                                                    ON SOLUCION_CAB2.ID_SOLUCION_CAB = SOLUCION_DET2.SOLUCION_CAB_ID
                                                    WHERE SOLUCION_DET2.SERVICIO_ID  = '||Ln_ServicioId||') 
              AND SRC.TIPO_RECURSO = ''ALQUILER SERVIDOR''  ';

    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_FromAndJoin || Lcl_Where || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_OBTENER_SERVIDOR_POR_SOLUC;
----
----
 PROCEDURE P_OBTENER_DISCO_POR_SERVICIO(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS

    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_FromAndJoin   CLOB;
    Lcl_Where         CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_ServicioId     NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(2000);

  BEGIN

    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ServicioId := APEX_JSON.get_number(p_path => 'servicioId');

    -- VALIDACIONES
    IF Ln_ServicioId IS NULL THEN
      Lv_Mensaje := 'El parámetro servicioId esta vacío';
      RAISE Le_Exception;
    END IF;

    Lcl_Select := '
              SELECT SRC.ID_SERVICIO_RECURSO_CAB IDRECURSO,
                     ROWNUM || '' - '' ||SRC.DESCRIPCION_RECURSO || '' ('' || SRC.CANTIDAD || '' GB )'' NOMBRERECURSO,
                     SRC.CANTIDAD VALOR ';

    Lcl_FromAndJoin := '
              FROM  DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC ';

    Lcl_Where := '
              WHERE SRC.SERVICIO_ID   = '||Ln_ServicioId||'  
              AND   SRC.TIPO_RECURSO  = ''DISCO''  ';

    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_FromAndJoin || Lcl_Where || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_OBTENER_DISCO_POR_SERVICIO;
----
----
 PROCEDURE P_OBTENER_LICENCIA_POR_SOLUC(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS

    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_FromAndJoin   CLOB;
    Lcl_Where         CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_ServicioId     NUMBER;
    Le_Exception      EXCEPTION;
    Lv_Mensaje        VARCHAR2(2000);

  BEGIN

    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ServicioId := APEX_JSON.get_number(p_path => 'servicioId');

    -- VALIDACIONES
    IF Ln_ServicioId IS NULL THEN
      Lv_Mensaje := 'El parámetro servicioId esta vacío';
      RAISE Le_Exception;
    END IF;

    Lcl_Select := '
              SELECT SRC.ID_SERVICIO_RECURSO_CAB IDRECURSO,
                     ROWNUM || '' - '' ||SRC.DESCRIPCION_RECURSO NOMBRERECURSO ';

    Lcl_FromAndJoin := '
              FROM DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB SRC
              JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
              ON SERVICIO.ID_SERVICIO = SRC.SERVICIO_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
              ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
              JOIN DB_COMERCIAL.INFO_SOLUCION_DET SOLUCION_DET
              ON SOLUCION_DET.SERVICIO_ID = SRC.SERVICIO_ID
              JOIN DB_COMERCIAL.INFO_SOLUCION_CAB SOLUCION_CAB
              ON SOLUCION_CAB.ID_SOLUCION_CAB = SOLUCION_DET.SOLUCION_CAB_ID ';

    Lcl_Where := '
              WHERE SOLUCION_CAB.NUMERO_SOLUCION = (SELECT SOLUCION_CAB2.NUMERO_SOLUCION
                                      FROM  DB_COMERCIAL.INFO_SOLUCION_CAB SOLUCION_CAB2
                                      JOIN DB_COMERCIAL.INFO_SOLUCION_DET SOLUCION_DET2
                                      ON SOLUCION_CAB2.ID_SOLUCION_CAB = SOLUCION_DET2.SOLUCION_CAB_ID
                                      WHERE SOLUCION_DET2.SERVICIO_ID  = '||Ln_ServicioId||' ) 
              AND PRODUCTO.DESCRIPCION_PRODUCTO = ''CLOUD IAAS LICENCIAMIENTO SE''  ';

    Lcl_OrderAnGroup := '';

    Lcl_Query := Lcl_Select || Lcl_FromAndJoin || Lcl_Where || Lcl_OrderAnGroup;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );
    WHEN OTHERS THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  :=  SUBSTR(SQLERRM||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 0 , 3000 );

  END P_OBTENER_LICENCIA_POR_SOLUC;

END INKG_SOLUCIONES_CONSULTA;

/
