create or replace package DB_GENERAL.GNKG_PARAMETRO_CONSULTA is
  /**
  * Documentación para el procedimiento P_DETALLE_POR_PARAMETRO
  *
  * Método encargado de retornar la lista de detalles de un parametro.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   empresaCod          := Código empresa Default '10',
  *   estado              := Estado Default 'Activo',
  *   parametroId         := Id del parametro
  *   nombreParametro     := Nombre del parametro
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_DETALLE_POR_PARAMETRO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);
end GNKG_PARAMETRO_CONSULTA;
/
create or replace package body DB_GENERAL.GNKG_PARAMETRO_CONSULTA is
  PROCEDURE P_DETALLE_POR_PARAMETRO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Ln_EmpresaCod      NUMBER;
    Lv_Estado          VARCHAR2(500);
    Ln_ParametroId     NUMBER;
    Lv_NombreParametro VARCHAR2(1000);
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_EmpresaCod      := APEX_JSON.get_number(p_path => 'empresaCod');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_ParametroId     := APEX_JSON.get_number(p_path => 'parametroId');
    Lv_NombreParametro := APEX_JSON.get_varchar2(p_path => 'nombreParametro');
    
    -- VALIDACIONES
    IF Ln_ParametroId IS NULL AND Lv_NombreParametro IS NULL THEN
      Pv_Mensaje := 'El parámetro parametroId o nombreParametro esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_EmpresaCod IS NULL THEN
      Ln_EmpresaCod := 10;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    
    Lcl_Select       := '
              SELECT APD.*';
    Lcl_From         := '
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                   DB_GENERAL.ADMI_PARAMETRO_DET APD';
    Lcl_WhereAndJoin := '
              WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                AND APC.ESTADO = ''Activo''
                AND APD.EMPRESA_COD = '||Ln_EmpresaCod||'
                AND APD.ESTADO = '''||Lv_Estado||'''';
    IF Ln_ParametroId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND APC.ID_PARAMETRO = '||Ln_ParametroId;
    END IF;
    IF Lv_NombreParametro IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''';
    END IF;
    Lcl_OrderAnGroup := '';
    
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
  END P_DETALLE_POR_PARAMETRO;
end GNKG_PARAMETRO_CONSULTA;
/

