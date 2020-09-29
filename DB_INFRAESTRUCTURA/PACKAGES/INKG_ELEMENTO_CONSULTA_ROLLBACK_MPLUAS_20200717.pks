create or replace package DB_INFRAESTRUCTURA.INKG_ELEMENTO_CONSULTA is
  /**
  * Documentación para el procedimiento P_ELEM_POR_TIPO
  *
  * Método encargado de retornar la lista de elementos por tipo.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   estado              := Estado Default 'Activo',
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_TIPO(Pcl_Request  IN  CLOB,
                            Pv_Status    OUT VARCHAR2,
                            Pv_Mensaje   OUT VARCHAR2,
                            Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_ELEM_POR_REGION_PARAMS
  *
  * Método encargado de retornar la lista de elementos por region y params.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   region              := Region (R1 o R2),
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   detalle             := Detalle de elemento,
  *   detalleValor        := Valor detalle de elemento,
  *   estado              := Estado Default 'Activo',
  *   empresaId           := Cod Empresa Default 10
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_REGION_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR);
                                 
  /**
  * Documentación para el procedimiento P_ELEM_POR_PROVINCIA_PARAMS
  *
  * Método encargado de retornar la lista de elementos por provincia y params.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   provinciaId         := Id de la provincia,
  *   nombreProvincia     := Nombre de la provincia,
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   detalle             := Detalle de elemento,
  *   detalleValor        := Valor detalle de elemento,
  *   estado              := Estado Default 'Activo',
  *   empresaId           := Cod Empresa Default 10
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_PROVINCIA_PARAMS(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_ELEM_POR_PARROQUIA_PARAMS
  *
  * Método encargado de retornar la lista de elementos por parroquia y params.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   parroquiaId         := Id de la parroquia,
  *   nombreParroquia     := Nombre de la parroquia,
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   detalle             := Detalle de elemento,
  *   detalleValor        := Valor detalle de elemento,
  *   estado              := Estado Default 'Activo',
  *   empresaId           := Cod Empresa Default 10
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_PARROQUIA_PARAMS(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_ELEM_POR_CANTON_PARAMS
  *
  * Método encargado de retornar la lista de elementos por canton y params.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   cantonId            := Id del canton,
  *   nombreCanton        := Nombre del canton,
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   detalle             := Detalle de elemento,
  *   detalleValor        := Valor detalle de elemento,
  *   estado              := Estado Default 'Activo',
  *   empresaId           := Cod Empresa Default 10
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_CANTON_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR);
                                 
  /**
  * Documentación para el procedimiento P_ELEM_POR_FILIAL
  *
  * Método encargado de retornar la lista de elementos por filial y params.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   filialId            := Id del filial,
  *   nombreFilial        := Nombre del filial,
  *   tipoId              := Tipo de elemento,
  *   nombreTipo          := Nombre de tipo de elemento,
  *   detalle             := Detalle de elemento,
  *   detalleValor        := Valor detalle de elemento,
  *   estado              := Estado Default 'Activo',
  *   empresaId           := Cod Empresa Default 10
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_FILIAL_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_ELEM_POR_MONITORIZADO
  *
  * Método encargado de retornar la lista de elementos por característica ES_MONITORIZADO.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   estado              := Estado Default 'Activo',
  *   idElemento          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_MONITORIZADO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);
       
  /**
  * Documentación para el procedimiento P_DATOS_VEHICULO
  *
  * Método encargado de retornar los datos de un vehículo vinculado a un elemento.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idElemento          := Id del elemento (Vehiculo),
  *   estado              := Estado Default 'Activo'
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_DATOS_VEHICULO(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Pcl_Response OUT SYS_REFCURSOR);
                                     
  /**
  * Documentación para el procedimiento P_DET_ELEM_POR_ELEM
  *
  * Método encargado de retornar la lista de detalles de elementos por elemento.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   detalle             := Nombre del detalle,
  *   estado              := Estado Default 'Activo',
  *   elementoId          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_DET_ELEM_POR_ELEM(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_HIS_ELEM_POR_ELEM
  *
  * Método encargado de retornar el historial por elemento.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   elementoId          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_HIS_ELEM_POR_ELEM(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);
  
  /**
  * Documentación para el procedimiento P_HIS_ELEM_POR_FECHA
  *
  * Método encargado de retornar el historial por elemento por rango de fecha.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   fechaInicio         := Fecha inicio,
  *   fechaFin            := Fecha fin,
  *   elementoId          := Id de elemento
  *   nombreElemento      := Nombre de elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */                                         
  PROCEDURE P_HIS_ELEM_POR_FECHA(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);
                                 
  /**
  * Documentación para el procedimiento P_ELEM_POR_GRUPO
  *
  * Método encargado de retornar los datos de un elemento por grupo de monitorización.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   grupoId             := Id del grupo de monitorización,
  *   estado              := Estado Default 'Activo'
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
  *
  * @author Marlon Plúas <mpluas@telconet.ec>
  * @version 1.0 02-03-2020
  */
  PROCEDURE P_ELEM_POR_GRUPO(Pcl_Request  IN  CLOB,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2,
                             Pcl_Response OUT SYS_REFCURSOR);

end INKG_ELEMENTO_CONSULTA;
/
create or replace package body DB_INFRAESTRUCTURA.INKG_ELEMENTO_CONSULTA is
  PROCEDURE P_ELEM_POR_TIPO(Pcl_Request  IN  CLOB,
                            Pv_Status    OUT VARCHAR2,
                            Pv_Mensaje   OUT VARCHAR2,
                            Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_TipoId         NUMBER;
    Lv_NombreTipo     VARCHAR2(1000);
    Lv_Estado         VARCHAR2(500);
    Lv_NombreElemento VARCHAR2(1000);
    Ln_IdElemento     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_TipoId         := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo     := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');

    -- VALIDACIONES
    IF Ln_TipoId IS NULL AND Lv_NombreTipo IS NULL THEN
      Pv_Mensaje := 'El parámetro tipoId o nombreTipo está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    Lcl_WhereAndJoin := '
              WHERE IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO
                AND IE.ESTADO = '''||Lv_Estado||'''';
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_TIPO;

  PROCEDURE P_ELEM_POR_REGION_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_Region         VARCHAR2(100);
    Ln_TipoId         NUMBER;
    Lv_NombreTipo     VARCHAR2(1000);
    Lv_Detalle        VARCHAR2(1000);
    Lv_DetalleValor   VARCHAR2(1000);
    Lv_Estado         VARCHAR2(500);
    Ln_EmpresaId      NUMBER;
    Lv_NombreElemento VARCHAR2(1000);
    Ln_IdElemento     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Region         := APEX_JSON.get_varchar2(p_path => 'region');
    Ln_TipoId         := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo     := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId      := APEX_JSON.get_number(p_path => 'empresaId');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_Detalle        := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_DetalleValor   := APEX_JSON.get_varchar2(p_path => 'detalleValor');

    -- VALIDACIONES
    IF Lv_Region IS NULL THEN
      Pv_Mensaje := 'El parámetro region está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NULL THEN
       Pv_Mensaje := 'El parámetro detalleValor está vacío';
       RAISE Le_Errors;
    END IF;
    IF Lv_DetalleValor IS NOT NULL AND Lv_Detalle IS NULL THEN
       Pv_Mensaje := 'El parámetro detalle está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
                   DB_INFRAESTRUCTURA.INFO_UBICACION IU,
                   DB_GENERAL.ADMI_PARROQUIA AP,
                   DB_GENERAL.ADMI_CANTON AC';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    END IF;

    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IEEU.ELEMENTO_ID
                AND IEEU.UBICACION_ID = IU.ID_UBICACION
                AND IU.PARROQUIA_ID = AP.ID_PARROQUIA
                AND AP.CANTON_ID = AC.ID_CANTON
                AND IEEU.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IE.ESTADO = '''||Lv_Estado||'''
                AND AP.ESTADO = ''Activo''
                AND AC.ESTADO = ''Activo''
                AND AC.REGION = '''||Lv_Region||'''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IDE.ESTADO = ''Activo''';
    END IF;

    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''
                AND IDE.DETALLE_VALOR = '''||Lv_DetalleValor||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_REGION_PARAMS;

  PROCEDURE P_ELEM_POR_PROVINCIA_PARAMS(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Ln_ProvinciaId     NUMBER;
    Lv_NombreProvincia VARCHAR2(1000);
    Ln_TipoId          NUMBER;
    Lv_NombreTipo      VARCHAR2(1000);
    Lv_Detalle         VARCHAR2(1000);
    Lv_DetalleValor    VARCHAR2(1000);
    Lv_Estado          VARCHAR2(500);
    Ln_EmpresaId       NUMBER;
    Lv_NombreElemento  VARCHAR2(1000);
    Ln_IdElemento      NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ProvinciaId     := APEX_JSON.get_number(p_path => 'provinciaId');
    Lv_NombreProvincia := APEX_JSON.get_varchar2(p_path => 'nombreProvincia');
    Ln_TipoId          := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo      := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId       := APEX_JSON.get_number(p_path => 'empresaId');
    Ln_IdElemento      := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento  := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_Detalle         := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_DetalleValor    := APEX_JSON.get_varchar2(p_path => 'detalleValor');

    -- VALIDACIONES
    IF Ln_ProvinciaId IS NULL AND Lv_NombreProvincia IS NULL THEN
      Pv_Mensaje := 'El parámetro provinciaId o nombreProvincia está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NULL THEN
       Pv_Mensaje := 'El parámetro detalleValor está vacío';
       RAISE Le_Errors;
    END IF;
    IF Lv_DetalleValor IS NOT NULL AND Lv_Detalle IS NULL THEN
       Pv_Mensaje := 'El parámetro detalle está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,                                
                   DB_GENERAL.ADMI_CANTON AC,
                   DB_GENERAL.ADMI_PROVINCIA AP2,
                   DB_INFRAESTRUCTURA.INFO_UBICACION IU
                   LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OG ON IU.OFICINA_ID = OG.ID_OFICINA
                                                                AND IU.OFICINA_ID IS NOT NULL
                                                                AND OG.ESTADO = ''Activo''
                   LEFT JOIN DB_GENERAL.ADMI_PARROQUIA AP ON IU.PARROQUIA_ID = AP.ID_PARROQUIA
                                                          AND IU.OFICINA_ID IS NULL
                                                          AND AP.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    END IF;

    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IEEU.ELEMENTO_ID
                AND IEEU.UBICACION_ID = IU.ID_UBICACION
                AND ( AP.CANTON_ID = AC.ID_CANTON
                      OR OG.CANTON_ID = AC.ID_CANTON )
                AND AC.PROVINCIA_ID = AP2.ID_PROVINCIA
                AND IEEU.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IE.ESTADO = '''||Lv_Estado||'''              
                AND AC.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IDE.ESTADO = ''Activo''';
    END IF;

    IF Ln_ProvinciaId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP2.ID_PROVINCIA = '||Ln_ProvinciaId;
    END IF;
    IF Lv_NombreProvincia IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP2.NOMBRE_PROVINCIA = '''||Lv_NombreProvincia||'''';
    END IF;
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''
                AND IDE.DETALLE_VALOR = '''||Lv_DetalleValor||'''';
    END IF; 
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';
                
             

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
  END P_ELEM_POR_PROVINCIA_PARAMS;

  PROCEDURE P_ELEM_POR_PARROQUIA_PARAMS(Pcl_Request  IN  CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query          CLOB;
    Lcl_Select         CLOB;
    Lcl_From           CLOB;
    Lcl_WhereAndJoin   CLOB;
    Lcl_OrderAnGroup   CLOB;
    Ln_ParroquiaId     NUMBER;
    Lv_NombreParroquia VARCHAR2(1000);
    Ln_TipoId          NUMBER;
    Lv_NombreTipo      VARCHAR2(1000);
    Lv_Detalle         VARCHAR2(1000);
    Lv_DetalleValor    VARCHAR2(1000);
    Lv_Estado          VARCHAR2(500);
    Ln_EmpresaId       NUMBER;
    Lv_NombreElemento  VARCHAR2(1000);
    Ln_IdElemento      NUMBER;
    Le_Errors          EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ParroquiaId     := APEX_JSON.get_number(p_path => 'parroquiaId');
    Lv_NombreParroquia := APEX_JSON.get_varchar2(p_path => 'nombreParroquia');
    Ln_TipoId          := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo      := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado          := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId       := APEX_JSON.get_number(p_path => 'empresaId');
    Ln_IdElemento      := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento  := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_Detalle         := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_DetalleValor    := APEX_JSON.get_varchar2(p_path => 'detalleValor');

    -- VALIDACIONES
    IF Ln_ParroquiaId IS NULL AND Lv_NombreParroquia IS NULL THEN
      Pv_Mensaje := 'El parámetro parroquiaId o nombreParroquia está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NULL THEN
       Pv_Mensaje := 'El parámetro detalleValor está vacío';
       RAISE Le_Errors;
    END IF;
    IF Lv_DetalleValor IS NOT NULL AND Lv_Detalle IS NULL THEN
       Pv_Mensaje := 'El parámetro detalle está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
                   DB_INFRAESTRUCTURA.INFO_UBICACION IU,
                   DB_GENERAL.ADMI_PARROQUIA AP';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    END IF;

    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IEEU.ELEMENTO_ID
                AND IEEU.UBICACION_ID = IU.ID_UBICACION
                AND IU.PARROQUIA_ID = AP.ID_PARROQUIA
                AND IEEU.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IE.ESTADO = '''||Lv_Estado||'''
                AND AP.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IDE.ESTADO = ''Activo''';
    END IF;

    IF Ln_ParroquiaId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP.ID_PARROQUIA = '||Ln_ParroquiaId;
    END IF;
    IF Lv_NombreParroquia IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AP.NOMBRE_PARROQUIA = '''||Lv_NombreParroquia||'''';
    END IF;
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''
                AND IDE.DETALLE_VALOR = '''||Lv_DetalleValor||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_PARROQUIA_PARAMS;

  PROCEDURE P_ELEM_POR_CANTON_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_CantonId       NUMBER;
    Lv_NombreCanton   VARCHAR2(1000);
    Ln_TipoId         NUMBER;
    Lv_NombreTipo     VARCHAR2(1000);
    Lv_Detalle        VARCHAR2(1000);
    Lv_DetalleValor   VARCHAR2(1000);
    Lv_Estado         VARCHAR2(500);
    Ln_EmpresaId      NUMBER;
    Lv_NombreElemento VARCHAR2(1000);
    Ln_IdElemento     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_CantonId       := APEX_JSON.get_number(p_path => 'cantonId');
    Lv_NombreCanton   := APEX_JSON.get_varchar2(p_path => 'nombreCanton');
    Ln_TipoId         := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo     := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId      := APEX_JSON.get_number(p_path => 'empresaId');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_Detalle        := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_DetalleValor   := APEX_JSON.get_varchar2(p_path => 'detalleValor');

    -- VALIDACIONES
    IF Ln_CantonId IS NULL AND Lv_NombreCanton IS NULL THEN
      Pv_Mensaje := 'El parámetro cantonId o nombreCanton está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NULL THEN
       Pv_Mensaje := 'El parámetro detalleValor está vacío';
       RAISE Le_Errors;
    END IF;
    IF Lv_DetalleValor IS NOT NULL AND Lv_Detalle IS NULL THEN
       Pv_Mensaje := 'El parámetro detalle está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,                                      
                   DB_GENERAL.ADMI_CANTON AC,
                   DB_INFRAESTRUCTURA.INFO_UBICACION IU
                   LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OG ON IU.OFICINA_ID = OG.ID_OFICINA
                                                                AND IU.OFICINA_ID IS NOT NULL
                                                                AND OG.ESTADO = ''Activo''
                   LEFT JOIN DB_GENERAL.ADMI_PARROQUIA AP ON IU.PARROQUIA_ID = AP.ID_PARROQUIA
                                                          AND IU.OFICINA_ID IS NULL
                                                          AND AP.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    END IF;

    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IEEU.ELEMENTO_ID
                AND IEEU.UBICACION_ID = IU.ID_UBICACION
                AND ( AP.CANTON_ID    = AC.ID_CANTON
                      OR OG.CANTON_ID = AC.ID_CANTON )                
                AND IEEU.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IE.ESTADO = '''||Lv_Estado||'''               
                AND AC.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IDE.ESTADO = ''Activo''';
    END IF;

    IF Ln_CantonId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AC.ID_CANTON = '||Ln_CantonId;
    END IF;
    IF Lv_NombreCanton IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND AC.NOMBRE_CANTON = '''||Lv_NombreCanton||'''';
    END IF;
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''
                AND IDE.DETALLE_VALOR = '''||Lv_DetalleValor||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_CANTON_PARAMS;

  PROCEDURE P_ELEM_POR_FILIAL_PARAMS(Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Ln_FilialId       NUMBER;
    Lv_NombreFilial   VARCHAR2(1000);
    Ln_TipoId         NUMBER;
    Lv_NombreTipo     VARCHAR2(1000);
    Lv_Detalle        VARCHAR2(1000);
    Lv_DetalleValor   VARCHAR2(1000);
    Lv_Estado         VARCHAR2(500);
    Ln_EmpresaId      NUMBER;
    Lv_NombreElemento VARCHAR2(1000);
    Ln_IdElemento     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_FilialId       := APEX_JSON.get_number(p_path => 'filialId');
    Lv_NombreFilial   := APEX_JSON.get_varchar2(p_path => 'nombreFilial');
    Ln_TipoId         := APEX_JSON.get_number(p_path => 'tipoId');
    Lv_NombreTipo     := APEX_JSON.get_varchar2(p_path => 'nombreTipo');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_EmpresaId      := APEX_JSON.get_number(p_path => 'empresaId');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_Detalle        := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_DetalleValor   := APEX_JSON.get_varchar2(p_path => 'detalleValor');

    -- VALIDACIONES
    IF Ln_FilialId IS NULL AND Lv_NombreFilial IS NULL THEN
      Pv_Mensaje := 'El parámetro filialId o nombreFilial está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
    IF Ln_EmpresaId IS NULL THEN
      Ln_EmpresaId := 10;
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NULL THEN
       Pv_Mensaje := 'El parámetro detalleValor está vacío';
       RAISE Le_Errors;
    END IF;
    IF Lv_DetalleValor IS NOT NULL AND Lv_Detalle IS NULL THEN
       Pv_Mensaje := 'El parámetro detalle está vacío';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA IEEU,
                   DB_INFRAESTRUCTURA.INFO_UBICACION IU,
                   DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
                   DB_GENERAL.ADMI_CANTON AC';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_From := Lcl_From || ',
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    END IF;

    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IEEU.ELEMENTO_ID
                AND IEEU.UBICACION_ID = IU.ID_UBICACION
                AND IU.OFICINA_ID = IOG.ID_OFICINA
                AND IOG.CANTON_ID = AC.ID_CANTON
                AND AC.ID_CANTON = IOG.CANTON_ID
                AND IEEU.EMPRESA_COD = '||Ln_EmpresaId||'
                AND IE.ESTADO = '''||Lv_Estado||'''
                AND IOG.ESTADO = ''Activo''
                AND AC.ESTADO = ''Activo''
                AND IOG.EMPRESA_ID = '||Ln_EmpresaId||'
                AND IOG.ESTADO = ''Activo''';
    IF Ln_TipoId IS NOT NULL OR Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
                AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IDE.ESTADO = ''Activo''';
    END IF;

    IF Ln_FilialId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IOG.ID_OFICINA = '||Ln_FilialId;
    END IF;
    IF Lv_NombreFilial IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IOG.NOMBRE_OFICINA = '''||Lv_NombreFilial||'''';
    END IF;
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    IF Ln_TipoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.ID_TIPO_ELEMENTO = '||Ln_TipoId;
    END IF;
    IF Lv_NombreTipo IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND ATE.NOMBRE_TIPO_ELEMENTO = '''||Lv_NombreTipo||'''';
    END IF;
    IF Lv_Detalle IS NOT NULL AND Lv_DetalleValor IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || '
                AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''
                AND IDE.DETALLE_VALOR = '''||Lv_DetalleValor||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_FILIAL_PARAMS;

  PROCEDURE P_ELEM_POR_MONITORIZADO(Pcl_Request  IN  CLOB,
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
    Lv_NombreElemento VARCHAR2(1000);
    Ln_IdElemento     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');

    -- VALIDACIONES
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    Lcl_Select       := '
              SELECT DISTINCT IE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
                   DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE';
    Lcl_WhereAndJoin := '
              WHERE IE.ID_ELEMENTO = IDE.ELEMENTO_ID
                AND IE.ESTADO = '''||Lv_Estado||'''
                AND IDE.ESTADO = ''Activo''
                AND IDE.DETALLE_NOMBRE = ''ES_MONITORIZADO''
                AND IDE.DETALLE_VALOR = ''S''';
    IF Ln_IdElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_IdElemento;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IE.ID_ELEMENTO DESC';

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
  END P_ELEM_POR_MONITORIZADO;

  PROCEDURE P_DATOS_VEHICULO(Pcl_Request  IN  CLOB,
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
    Ln_IdElemento     NUMBER;
    Lv_detalleNombre  VARCHAR2(100);
    Lv_detalleValor   VARCHAR2(100);
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_IdElemento     := APEX_JSON.get_number(p_path => 'idElemento');
    Lv_detalleNombre  := APEX_JSON.get_varchar2(p_path => 'nombreDetalle');
    Lv_detalleValor   := APEX_JSON.get_varchar2(p_path => 'valorDetalle');   

    -- VALIDACIONES
    IF Ln_IdElemento IS NULL AND Lv_detalleNombre IS NULL
    THEN
      Pv_Mensaje := 'Debe agregar al menos un parámetro para su busqueda';    
      RAISE Le_Errors;
    END IF;
   
    IF Lv_detalleNombre IS NOT NULL AND Lv_detalleValor IS NULL THEN
      Pv_Mensaje := 'Debe agregar el valor para el detalle ingresado';     
      RAISE Le_Errors;
    END IF;
   
    IF Lv_detalleNombre IS NULL AND Lv_detalleValor IS NOT NULL THEN
      Pv_Mensaje := 'Debe agregar el nombre de detalle para la búsqueda';     
      RAISE Le_Errors;
    END IF;
   
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
   

    Lcl_Select       := '
              SELECT E.ID_ELEMENTO,
                     E.NOMBRE_ELEMENTO        AS PLACA,
                     E.DESCRIPCION_ELEMENTO,
                     M.NOMBRE_MODELO_ELEMENTO AS MODELO,
                     T.NOMBRE_TIPO_ELEMENTO   AS TIPO,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''DISCO''
                        AND ESTADO = ''Activo''
                     )                        AS DISCO,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''MOTOR''
                        AND ESTADO = ''Activo''
                     )                        AS MOTOR,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''CHASIS''
                        AND ESTADO = ''Activo''
                     )                        AS CHASIS,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''CUADRILLA''
                        AND ESTADO = ''Activo''
                     )                        AS CUADRILLA,
                     (SELECT NOMBRE_CUADRILLA
                      FROM DB_COMERCIAL.ADMI_CUADRILLA
                      WHERE ID_CUADRILLA = (SELECT DETALLE_VALOR
                                            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                            WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                              AND DETALLE_NOMBRE = ''CUADRILLA''
                                              AND ESTADO = ''Activo''
                                           )
                     )                        AS NOMBRE_CUADRILLA,
                     (SELECT NOMBRE_ELEMENTO
                      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                      WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                           FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                           WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                             AND DETALLE_NOMBRE = ''GPS''
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS GPS,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE DETALLE_NOMBRE = ''IMEI''
                        AND ELEMENTO_ID = (SELECT ID_ELEMENTO
                                           FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                                           WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                                                FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                                                WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                                                  AND DETALLE_NOMBRE = ''GPS''
                                                                  AND ESTADO = ''Activo''
                                                               )
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS IMEI,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE DETALLE_NOMBRE = ''CHIP''
                        AND ELEMENTO_ID = (SELECT ID_ELEMENTO
                                           FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                                           WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                                                FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                                                WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                                                  AND DETALLE_NOMBRE = ''GPS''
                                                                  AND ESTADO = ''Activo''
                                                               )
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS CHIP,
                     E.ESTADO';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO E,
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO M,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO T';
    Lcl_WhereAndJoin := '
              WHERE E.MODELO_ELEMENTO_ID = M.ID_MODELO_ELEMENTO
                AND M.TIPO_ELEMENTO_ID = T.ID_TIPO_ELEMENTO';
               
    IF Ln_IdElemento IS NOT NULL THEN   
        Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND E.ID_ELEMENTO = '||Ln_IdElemento||' AND E.ESTADO = '''||Lv_Estado||'''';
    ELSE --VALIDA DETALLE IMEI/CHIP
        IF Lv_detalleNombre = 'IMEI' OR Lv_detalleNombre = 'CHIP' THEN
            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND E.ID_ELEMENTO = (SELECT 
                                        DGPS.ELEMENTO_ID
                                    FROM
                                        DB_INFRAESTRUCTURA.info_detalle_elemento   d,
                                        DB_INFRAESTRUCTURA.info_elemento           e,
                                        DB_INFRAESTRUCTURA.info_detalle_elemento   dgps
                                    WHERE
                                        e.id_elemento = d.elemento_id
                                        AND d.detalle_nombre = '''||Lv_detalleNombre||'''
                                        AND d.detalle_valor  = '''||Lv_detalleValor||'''
                                        AND e.id_elemento    =  dgps.detalle_valor
                                        AND dgps.detalle_nombre = ''GPS''
                                        AND dgps.estado         = ''Activo''
                                        AND d.estado            = ''Activo'')
                                  AND E.ESTADO = '''||Lv_Estado||'''';
        ELSE IF Lv_detalleNombre = 'GPS' THEN
            Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND E.ID_ELEMENTO = (SELECT
                                        dgps.elemento_id
                                    FROM
                                        db_infraestructura.info_detalle_elemento dgps
                                    WHERE
                                        dgps.detalle_valor = (
                                            SELECT
                                                id_elemento
                                            FROM
                                                db_infraestructura.info_elemento
                                            WHERE
                                                nombre_elemento = '''||Lv_detalleValor||'''
                                        )
                                        AND dgps.detalle_nombre = '''||Lv_detalleNombre||'''
                                        AND dgps.estado = ''Activo'')
                                 AND E.ESTADO = '''||Lv_Estado||'''';             
             END IF;           
        END IF;
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
  END P_DATOS_VEHICULO;

  PROCEDURE P_DET_ELEM_POR_ELEM(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_Detalle        VARCHAR2(3000);
    Lv_Estado         VARCHAR2(500);
    Lv_NombreElemento VARCHAR2(1000);
    Ln_ElementoId     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Detalle        := APEX_JSON.get_varchar2(p_path => 'detalle');
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_ElementoId     := APEX_JSON.get_number(p_path => 'elementoId');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');

    -- VALIDACIONES
    IF Ln_ElementoId IS NULL AND Lv_NombreElemento IS NULL THEN
      Pv_Mensaje := 'El parámetro elementoId o nombreElemento está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;

    Lcl_Select       := '
              SELECT IDE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE,
                   DB_INFRAESTRUCTURA.INFO_ELEMENTO IE';
    Lcl_WhereAndJoin := '
              WHERE IDE.ELEMENTO_ID = IE.ID_ELEMENTO
                AND IDE.ESTADO = '''||Lv_Estado||'''';
    IF Lv_Detalle IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IDE.DETALLE_NOMBRE = '''||Lv_Detalle||'''';
    END IF;
    IF Ln_ElementoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_ElementoId;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IDE.ID_DETALLE_ELEMENTO DESC';

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
  END P_DET_ELEM_POR_ELEM;

  PROCEDURE P_HIS_ELEM_POR_ELEM(Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_NombreElemento VARCHAR2(1000);
    Ln_ElementoId     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ElementoId     := APEX_JSON.get_number(p_path => 'elementoId');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');

    -- VALIDACIONES
    IF Ln_ElementoId IS NULL AND Lv_NombreElemento IS NULL THEN
      Pv_Mensaje := 'El parámetro elementoId o nombreElemento está vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IHE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO IHE,
                   DB_INFRAESTRUCTURA.INFO_ELEMENTO IE';
    Lcl_WhereAndJoin := '
              WHERE IHE.ELEMENTO_ID = IE.ID_ELEMENTO';
    IF Ln_ElementoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_ElementoId;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IHE.ID_HISTORIAL DESC';

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
  END P_HIS_ELEM_POR_ELEM;

  PROCEDURE P_HIS_ELEM_POR_FECHA(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lcl_Query         CLOB;
    Lcl_Select        CLOB;
    Lcl_From          CLOB;
    Lcl_WhereAndJoin  CLOB;
    Lcl_OrderAnGroup  CLOB;
    Lv_NombreElemento VARCHAR2(1000);
    Lv_FechaInicio    VARCHAR2(500);
    Lv_FechaFin       VARCHAR2(500);
    Ln_ElementoId     NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Ln_ElementoId     := APEX_JSON.get_number(p_path => 'elementoId');
    Lv_NombreElemento := APEX_JSON.get_varchar2(p_path => 'nombreElemento');
    Lv_FechaInicio    := APEX_JSON.get_varchar2(p_path => 'fechaInicio');
    Lv_FechaFin       := APEX_JSON.get_varchar2(p_path => 'fechaFin');

    -- VALIDACIONES
    IF Lv_FechaInicio IS NULL THEN
      Pv_Mensaje := 'El parámetro fechaInicio está vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_FechaFin IS NULL THEN
      Pv_Mensaje := 'El parámetro fechaFin está vacío';
      RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT IHE.*';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO IHE,
                   DB_INFRAESTRUCTURA.INFO_ELEMENTO IE';
    Lcl_WhereAndJoin := '
              WHERE IHE.ELEMENTO_ID = IE.ID_ELEMENTO
              AND IHE.FE_CREACION BETWEEN TO_DATE('''||Lv_FechaInicio||' 00:00:00'', ''yyyy-MM-dd HH24:MI:SS'') 
              AND TO_DATE('''||Lv_FechaFin||' 23:59:59'', ''yyyy-MM-dd HH24:MI:SS'')';
    IF Ln_ElementoId IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.ID_ELEMENTO = '||Ln_ElementoId;
    END IF;
    IF Lv_NombreElemento IS NOT NULL THEN
      Lcl_WhereAndJoin := Lcl_WhereAndJoin || ' AND IE.NOMBRE_ELEMENTO = '''||Lv_NombreElemento||'''';
    END IF;
    Lcl_OrderAnGroup := '
              ORDER BY
                IHE.ID_HISTORIAL DESC';

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
  END P_HIS_ELEM_POR_FECHA;
  
  PROCEDURE P_ELEM_POR_GRUPO(Pcl_Request  IN  CLOB,
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
    Ln_GrupoId        NUMBER;
    Le_Errors         EXCEPTION;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_Estado         := APEX_JSON.get_varchar2(p_path => 'estado');
    Ln_GrupoId        := APEX_JSON.get_number(p_path => 'grupoId');  

    -- VALIDACIONES
    IF Ln_GrupoId IS NULL
    THEN
      Pv_Mensaje := 'El parámetro grupoId está vacío';    
      RAISE Le_Errors;
    END IF;
   
    IF Lv_Estado IS NULL THEN
      Lv_Estado := 'Activo';
    END IF;
   

    Lcl_Select       := '
              SELECT E.ID_ELEMENTO,
                     E.NOMBRE_ELEMENTO        AS PLACA,
                     E.DESCRIPCION_ELEMENTO,
                     M.NOMBRE_MODELO_ELEMENTO AS MODELO,
                     T.NOMBRE_TIPO_ELEMENTO   AS TIPO,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''DISCO''
                        AND ESTADO = ''Activo''
                     )                        AS DISCO,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''MOTOR''
                        AND ESTADO = ''Activo''
                     )                        AS MOTOR,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''CHASIS''
                        AND ESTADO = ''Activo''
                     )                        AS CHASIS,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE ELEMENTO_ID = E.ID_ELEMENTO
                        AND DETALLE_NOMBRE = ''CUADRILLA''
                        AND ESTADO = ''Activo''
                     )                        AS CUADRILLA,
                     (SELECT NOMBRE_CUADRILLA
                      FROM DB_COMERCIAL.ADMI_CUADRILLA
                      WHERE ID_CUADRILLA = (SELECT DETALLE_VALOR
                                            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                            WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                              AND DETALLE_NOMBRE = ''CUADRILLA''
                                              AND ESTADO = ''Activo''
                                           )
                     )                        AS NOMBRE_CUADRILLA,
                     (SELECT NOMBRE_ELEMENTO
                      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                      WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                           FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                           WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                             AND DETALLE_NOMBRE = ''GPS''
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS GPS,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE DETALLE_NOMBRE = ''IMEI''
                        AND ELEMENTO_ID = (SELECT ID_ELEMENTO
                                           FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                                           WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                                                FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                                                WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                                                  AND DETALLE_NOMBRE = ''GPS''
                                                                  AND ESTADO = ''Activo''
                                                               )
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS IMEI,
                     (SELECT DETALLE_VALOR
                      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                      WHERE DETALLE_NOMBRE = ''CHIP''
                        AND ELEMENTO_ID = (SELECT ID_ELEMENTO
                                           FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
                                           WHERE ID_ELEMENTO = (SELECT DETALLE_VALOR
                                                                FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                                                                WHERE ELEMENTO_ID = E.ID_ELEMENTO
                                                                  AND DETALLE_NOMBRE = ''GPS''
                                                                  AND ESTADO = ''Activo''
                                                               )
                                             AND ESTADO = ''Activo''
                                          )
                        AND ESTADO = ''Activo''
                     )                        AS CHIP,
                     E.ESTADO';
    Lcl_From         := '
              FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO E,
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO M,
                   DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO T,
                   DB_MONITOREO.INFO_GRUPO_DETALLE D';
    Lcl_WhereAndJoin := '
              WHERE E.MODELO_ELEMENTO_ID = M.ID_MODELO_ELEMENTO
                AND M.TIPO_ELEMENTO_ID = T.ID_TIPO_ELEMENTO
                AND D.ELEMENTO_ID = E.ID_ELEMENTO
		AND D.ESTADO = ''Activo''
                AND E.ESTADO = '''||Lv_Estado||'''
                AND D.GRUPO_ID = '||Ln_GrupoId||'';
                                    
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
  END P_ELEM_POR_GRUPO;
end INKG_ELEMENTO_CONSULTA;
/

