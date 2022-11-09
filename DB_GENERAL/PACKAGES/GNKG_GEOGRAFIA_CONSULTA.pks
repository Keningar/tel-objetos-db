create or replace package DB_GENERAL.GNKG_GEOGRAFIA_CONSULTA is
  /**
  * Documentación para el procedimiento P_PROVINCIA_POR_PAIS
  *
  * Método encargado de retornar la lista de provincias por pais.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado Default 'Activo',
  *   paisId              := Id de pais
  *   nombrePais          := Nombre de pais
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_PROVINCIA_POR_PAIS(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
end GNKG_GEOGRAFIA_CONSULTA;
/
create or replace package body DB_GENERAL.GNKG_GEOGRAFIA_CONSULTA is
  PROCEDURE P_PROVINCIA_POR_PAIS(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_Estado         VARCHAR2(500);
    Lv_NombrePais     VARCHAR2(1000);
    Ln_paisId         NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado     := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_paisId     := APEX_JSON.get_number(p_path => 'paisId');
    Lv_NombrePais := APEX_JSON.get_varchar2(p_path => 'nombrePais');
    
    -- VALIDACIONES
    IF Ln_paisId IS NULL AND Lv_NombrePais IS NULL THEN
      Pv_Mensaje := 'El parámetro paisId o nombrePais está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    
    Lcl_Select       := '
              SELECT AP.*';
    Lcl_From         := '
              FROM DB_GENERAL.ADMI_PROVINCIA AP,
                   DB_GENERAL.ADMI_REGION AR,
                   DB_GENERAL.ADMI_PAIS AP2';
    Lcl_WhereAndJoin := '
              WHERE AP.REGION_ID = AR.ID_REGION
                AND AR.PAIS_ID = AP2.ID_PAIS
                AND AP.ESTADO = '''||Lv_Estado||'''';
    IF Ln_paisId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP2.ID_PAIS = '||Ln_paisId;
    END IF;
    IF Lv_NombrePais IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP2.NOMBRE_PAIS = '''||Lv_NombrePais||'''';
    END IF;
    Lcl_OrderAnGroup := ' ORDER BY AP.NOMBRE_PROVINCIA';
    
    Lcl_Query := Lcl_Select || Lcl_From || Lcl_WhereAndJoin || Lcl_OrderAnGroup;
    
    OPEN Pcl_Response FOR Lcl_Query;
    
    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_PROVINCIA_POR_PAIS;
end GNKG_GEOGRAFIA_CONSULTA;
/

