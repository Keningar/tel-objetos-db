CREATE OR REPLACE package  DB_GENERAL.GNKG_PARAMETRO_CONSULTA is
  /**
  * Documentaci�n para el procedimiento P_DETALLE_POR_PARAMETRO
  *
  * M�todo encargado de retornar la lista de detalles de un parametro.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   empresaCod          := C�digo empresa Default '10',
  *   estado              := Estado Default 'Activo',
  *   parametroId         := Id del parametro
  *   nombreParametro     := Nombre del parametro
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci�n
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci�n
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci�n
  *
  * @author Marlon Pl�as <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_DETALLE_POR_PARAMETRO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);

  /**
  * Documentaci�n para proceso 'P_GET_DETALLE_PARAMETRO'
  * 
  * Permite consultar el detalle de un par�metro de acuerdo a la informaci�n ingresada
  *
  * @param  Pv_NombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.Nombre_Parametro%TYPE Recibe nombre del par�metro de la tabla cabecera
  * @param  Pv_Descripcion      IN DB_GENERAL.ADMI_PARAMETRO_DET.Descripcion%TYPE Recibe descripcion del par�metro de la tabla detalle
  * @param  Pv_Empresa_Cod      IN DB_GENERAL.ADMI_PARAMETRO_DET.Empresa_Cod%TYPE Recibe el identificador de la empresa
  * @param  Pr_AdmiParametroDet OUT DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE Retorna Registro del detalle del par�metro
  * @param  Pv_Status           OUT VARCHAR2 Retorna estatus de la consulta
  * @param  Pv_Mensaje          OUT VARCHAR2 Retorna mensaje de la consulta
  *
  * @author   David De La Cruz <ddelacruz@telconet.ec>
  * @version  1.0 
  * @since    29-10-2021
  */ 
  PROCEDURE P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   IN DB_GENERAL.ADMI_PARAMETRO_CAB.Nombre_Parametro%TYPE,
                                    Pv_Descripcion       IN DB_GENERAL.ADMI_PARAMETRO_DET.Descripcion%TYPE,
                                    Pv_Empresa_Cod       IN DB_GENERAL.ADMI_PARAMETRO_DET.Empresa_Cod%TYPE,
                                    Pr_AdmiParametroDet  OUT DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
                                    Pv_Status            OUT VARCHAR2,
                                    Pv_Mensaje           OUT VARCHAR2);   

end GNKG_PARAMETRO_CONSULTA;
/

CREATE OR REPLACE package body DB_GENERAL.GNKG_PARAMETRO_CONSULTA is
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
      Pv_Mensaje := 'El par�metro parametroId o nombreParametro esta vac�o';
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
    Pv_Mensaje    := 'Transacci�n exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
  END P_DETALLE_POR_PARAMETRO;

  PROCEDURE P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   IN DB_GENERAL.ADMI_PARAMETRO_CAB.Nombre_Parametro%TYPE,
                                    Pv_Descripcion       IN DB_GENERAL.ADMI_PARAMETRO_DET.Descripcion%TYPE,
                                    Pv_Empresa_Cod       IN DB_GENERAL.ADMI_PARAMETRO_DET.Empresa_Cod%TYPE,
                                    Pr_AdmiParametroDet  OUT DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
                                    Pv_Status            OUT VARCHAR2,
                                    Pv_Mensaje           OUT VARCHAR2) AS

    /**
     * C_GetAdmiDetalleParametro, obtiene el detalle del parametro segun los datos ingresados
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 
     * @since   29-10-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetAdmiDetalleParametro(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.Nombre_Parametro%TYPE,
                                     Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.Descripcion%TYPE,
                                     Cv_Empresa_Cod     DB_GENERAL.ADMI_PARAMETRO_DET.Empresa_Cod%TYPE) IS
      SELECT
        Apd.*
      FROM
             Db_General.Admi_Parametro_Cab Apc
        JOIN Db_General.Admi_Parametro_Det Apd ON Apc.Id_Parametro = Apd.Parametro_Id
      WHERE
        Apc.Nombre_Parametro = Cv_NombreParametro
        AND Apc.Estado = 'Activo'
        AND Apd.Descripcion = Cv_Descripcion
        AND Apd.Empresa_Cod = Cv_Empresa_Cod
        AND Apd.Estado = 'Activo';

    Le_NotFound EXCEPTION;
  BEGIN

    IF C_GetAdmiDetalleParametro%ISOPEN THEN
        CLOSE C_GetAdmiDetalleParametro;
    END IF;

    OPEN C_GetAdmiDetalleParametro(Pv_NombreParametro, Pv_Descripcion, Pv_Empresa_Cod);
    FETCH C_GetAdmiDetalleParametro INTO Pr_AdmiParametroDet;
    IF C_GetAdmiDetalleParametro%NOTFOUND THEN
        CLOSE C_GetAdmiDetalleParametro;
        RAISE Le_NotFound;
    END IF;
    CLOSE C_GetAdmiDetalleParametro;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
  EXCEPTION
    WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro detalle de parametro';
    WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_DETALLE_PARAMETRO;  

end GNKG_PARAMETRO_CONSULTA;
/
