
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CONSULTA_CLIENTE AS
    -- Author  : David De La Cruz <ddelacruz@telconet.ec>
    -- Created : 21/10/2022
    -- Purpose : Paquete general de consultas sobre información de clientes

   /**
    * Documentación para el procedimiento P_CONSULTA_VENDEDOR_CLIENTE
    *
    * Método encargado de retornar el vendedor asignado a un cliente
    *
    * @param Pcl_Request    IN   CLOB Recibe json request
    * [
    *   estado              := Estado Default 'Activo',
    *   codEmpresa          := Codigo de empresa Defaul '10',
    *   idPersonaEmpresRol  := Id persona empresa rol del cliente
    * ]
    * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
    * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
    * @param Pcl_Response   OUT  CLOB Retorna datos de la transacción
    *
    * @author David De La Cruz <ddelacruz@telconet.ec>
    * @version 1.0 21-10-2022
    */
  PROCEDURE P_CONSULTA_VENDEDOR_CLIENTE (
    Pcl_Request  IN CLOB,
    Pv_Status    OUT VARCHAR2,
    Pv_Mensaje   OUT VARCHAR2,
    Pcl_Response OUT CLOB
  );

END CMKG_CONSULTA_CLIENTE;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CONSULTA_CLIENTE AS

  PROCEDURE P_CONSULTA_VENDEDOR_CLIENTE (
    Pcl_Request  IN CLOB,
    Pv_Status    OUT VARCHAR2,
    Pv_Mensaje   OUT VARCHAR2,
    Pcl_Response OUT CLOB
  ) AS

    CURSOR C_Vendedor_Cliente (
      Cn_IdPersona           NUMBER,
      Cv_CodEmpresa          VARCHAR2,
      Cv_Estado              VARCHAR2
    ) IS
    SELECT
      iper.ID_PERSONA_ROL , ip2.NOMBRES ,ip2.APELLIDOS , ip2.login, ip2.ID_PERSONA , ip2.IDENTIFICACION_CLIENTE 
    FROM
           Db_Comercial.Info_Persona Ip2
      INNER JOIN Db_Comercial.Info_Persona_Empresa_Rol Iper ON Ip2.Id_Persona = Iper.Persona_Id
      INNER JOIN Db_Comercial.Info_Empresa_Rol         Ier ON Iper.Empresa_Rol_Id = Ier.Id_Empresa_Rol
    WHERE
        Ip2.Login = (
          SELECT
            usr_vendedor
          FROM
            (
            SELECT
              ip.usr_vendedor
            FROM
              DB_COMERCIAL.INFO_PERSONA ip3
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper3 ON
              ip3.ID_PERSONA = iper3.PERSONA_ID
            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier2 ON
              iper3.EMPRESA_ROL_ID = ier2.ID_EMPRESA_ROL
            INNER JOIN DB_COMERCIAL.INFO_PUNTO ip ON
              iper3.ID_PERSONA_ROL = ip.persona_empresa_rol_id
            WHERE
              ip3.ID_PERSONA = Cn_IdPersona
              AND ip.ESTADO = Cv_Estado
              AND ier2.empresa_cod = Cv_CodEmpresa
            ORDER BY
              ip.FE_CREACION DESC)
          WHERE
            rownum = 1
                )
      AND Ier.Empresa_Cod = Cv_CodEmpresa
      AND Iper.Estado = Cv_Estado;

    Lv_CodEmpresa          Db_Comercial.Info_Empresa_Grupo.Cod_Empresa%TYPE;
    Lv_Estado              Db_Comercial.Info_Punto.Estado%TYPE;
    Ln_IdPersona           Db_Comercial.Info_Persona.Id_Persona%TYPE;
    Lc_VendedorCliente     C_Vendedor_Cliente%Rowtype;
  BEGIN
    Apex_Json.Parse(Pcl_Request);
    Lv_CodEmpresa := Apex_Json.Get_Varchar2(P_Path => 'codEmpresa');
    Ln_IdPersona := Apex_Json.Get_Number(P_Path => 'idPersona');
    Lv_Estado := Apex_Json.Get_Varchar2(P_Path => 'estado');

    IF Lv_CodEmpresa IS NULL THEN
      Lv_CodEmpresa := '10';
    END IF;

    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    OPEN C_Vendedor_Cliente(Ln_IdPersona, Lv_CodEmpresa, Lv_Estado);
    FETCH C_Vendedor_Cliente INTO Lc_VendedorCliente;
    CLOSE C_Vendedor_Cliente;    

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idPersonaEmpresaRol',Lc_VendedorCliente.Id_Persona_Rol);
    APEX_JSON.WRITE('nombres',Lc_VendedorCliente.Nombres);
    APEX_JSON.WRITE('apellidos',Lc_VendedorCliente.Apellidos);
    APEX_JSON.WRITE('usuarioLogin',Lc_VendedorCliente.Login);
    APEX_JSON.WRITE('idPersona',Lc_VendedorCliente.Id_Persona);
    APEX_JSON.CLOSE_OBJECT;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error al consultar vendedor del cliente';

  END P_CONSULTA_VENDEDOR_CLIENTE;

END CMKG_CONSULTA_CLIENTE;
/