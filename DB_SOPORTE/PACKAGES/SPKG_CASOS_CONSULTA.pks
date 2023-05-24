CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_CASOS_CONSULTA AS 

  /**
   * Documentacion para proceso 'P_GET_ADMI_TIPO_CASO'
   *
   * Procedimiento para consultar un tipo de caso
   *
   * @param Pv_NombreTipoCaso IN  ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE Recibe el nombre del tipo de caso
   * @param Pv_Estado         IN  ADMI_TIPO_CASO.ESTADO%TYPE Recibe el nombre del tipo de caso
   * @param Pr_AdmiTipoCaso   OUT ADMI_TIPO_CASO%ROWTYPE Retorna registro del tipo de caso
   * @param Pv_Status         OUT VARCHAR2 Retorna status de la consulta
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la consulta

   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   05-10-2021
   */
  PROCEDURE P_GET_ADMI_TIPO_CASO(Pv_NombreTipoCaso IN  ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                                 Pv_Estado         IN  ADMI_TIPO_CASO.ESTADO%TYPE,
                                 Pr_AdmiTipoCaso   OUT ADMI_TIPO_CASO%ROWTYPE,
                                 Pv_Status         OUT VARCHAR2,
                                 Pv_Mensaje        OUT VARCHAR2);

  /**
   * Documentacion para proceso 'P_GET_ADMI_NIVEL_CRITICIDAD'
   *
   * Procedimiento para consultar un nivel de criticidad
   *
   * @param Pv_NombreNivelCriticidad IN  ADMI_NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE Recibe el nombre de nivel de criticidad
   * @param Pv_Estado                IN  ADMI_NIVEL_CRITICIDAD.ESTADO%TYPE Recibe el estado de nivel de criticidad
   * @param Pr_AdmiNivelCriticidad   OUT ADMI_NIVEL_CRITICIDAD%ROWTYPE Retorna registro del nivel de criticidad
   * @param Pv_Status                OUT VARCHAR2 Retorna status de la consulta
   * @param Pv_Mensaje               OUT VARCHAR2 Retorna mensaje de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   05-10-2021
   */
  PROCEDURE P_GET_ADMI_NIVEL_CRITICIDAD(Pv_NombreNivelCriticidad IN  ADMI_NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE,
                                        Pv_Estado                IN  ADMI_NIVEL_CRITICIDAD.ESTADO%TYPE,
                                        Pr_AdmiNivelCriticidad   OUT ADMI_NIVEL_CRITICIDAD%ROWTYPE,
                                        Pv_Status                OUT VARCHAR2,
                                        Pv_Mensaje               OUT VARCHAR2);

  /**
   * Documentacion para proceso 'P_GET_CASOS'
   *
   * Procedimiento para consultar uno o varios casos segun los filtros ingresados
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  codEmpresa          C�digo empresa,
   *  fechaAperturaDesde  Fecha de apertura inicial para consultar por rango,
   *  fechaAperturaHasta  Fecha de apertura final para consultar por rango,
   *  fechaCierreDesde    Fecha de cierre inicial para consultar por rango,
   *  fechaCierreHasta    Fecha de cierre final para consultar por rango,
   *  estado              Estado del caso,
   *  nombreAfectado      Nombre del afectado por el cual se cre� el caso,
   *  idCaso              Id del caso,
   *  numeroCaso          N�mero del caso
   * ]
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response  OUT SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   21-10-2021
   */
  PROCEDURE P_GET_CASOS(Pcl_Request  IN  CLOB,
                        Pv_Status    OUT VARCHAR2,
                        Pv_Mensaje   OUT VARCHAR2,
                        Pcl_Response OUT CLOB);

  /**
   * Documentacion para proceso 'P_GET_CANT_CASOS_SEGUN_TAREAS'
   *
   * Procedimiento para consultar cantidad de casos seg�n criterio de tareas
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response  OUT SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since   10-03-2022
   */
  PROCEDURE P_GET_CANT_CASOS_SEGUN_TAREAS(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB);                        

END SPKG_CASOS_CONSULTA;

/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_CASOS_CONSULTA AS

  PROCEDURE P_GET_ADMI_TIPO_CASO(Pv_NombreTipoCaso IN  ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                                 Pv_Estado         IN  ADMI_TIPO_CASO.ESTADO%TYPE,
                                 Pr_AdmiTipoCaso   OUT ADMI_TIPO_CASO%ROWTYPE,
                                 Pv_Status         OUT VARCHAR2,
                                 Pv_Mensaje        OUT VARCHAR2) AS

    /**
     * C_GetAdmiTipoCaso, obtiene un registro por el nombre del tipo de caso y estado
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 05-10-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetAdmiTipoCaso(Cv_NombreTipoCaso ADMI_TIPO_CASO.NOMBRE_TIPO_CASO%TYPE,
                             Cv_Estado         ADMI_TIPO_CASO.ESTADO%TYPE) IS
    SELECT
        ATC.*
    FROM
        ADMI_TIPO_CASO ATC
    WHERE
        ATC.NOMBRE_TIPO_CASO = Cv_NombreTipoCaso
    AND ATC.ESTADO = Cv_Estado;

    Le_NotFound EXCEPTION;
  BEGIN

    IF C_GetAdmiTipoCaso%ISOPEN THEN
        CLOSE C_GetAdmiTipoCaso;
    END IF;

    OPEN C_GetAdmiTipoCaso(Pv_NombreTipoCaso, Pv_Estado);
    FETCH C_GetAdmiTipoCaso INTO Pr_AdmiTipoCaso;
    IF C_GetAdmiTipoCaso%NOTFOUND THEN
        CLOSE C_GetAdmiTipoCaso;
        RAISE Le_NotFound;
    END IF;
    CLOSE C_GetAdmiTipoCaso;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
  EXCEPTION
    WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro tipo de caso';
    WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_ADMI_TIPO_CASO;

  PROCEDURE P_GET_ADMI_NIVEL_CRITICIDAD(Pv_NombreNivelCriticidad IN  ADMI_NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE,
                                        Pv_Estado                IN  ADMI_NIVEL_CRITICIDAD.ESTADO%TYPE,
                                        Pr_AdmiNivelCriticidad   OUT ADMI_NIVEL_CRITICIDAD%ROWTYPE,
                                        Pv_Status                OUT VARCHAR2,
                                        Pv_Mensaje               OUT VARCHAR2) AS

    /**
     * C_GetAdmiNivelCriticidad, obtiene un registro por el nombre del nivel de criticidad y estado
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 05-10-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetAdmiNivelCriticidad(Cv_NombreNivelCriticidad ADMI_NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD%TYPE,
                                    Cv_Estado                ADMI_NIVEL_CRITICIDAD.ESTADO%TYPE) IS
    SELECT
        ANC.*
    FROM
        ADMI_NIVEL_CRITICIDAD ANC
    WHERE
        ANC.NOMBRE_NIVEL_CRITICIDAD = Cv_NombreNivelCriticidad
    AND ANC.ESTADO = Cv_Estado;

    Le_NotFound EXCEPTION;
  BEGIN

    IF C_GetAdmiNivelCriticidad%ISOPEN THEN
        CLOSE C_GetAdmiNivelCriticidad;
    END IF;

    OPEN C_GetAdmiNivelCriticidad(Pv_NombreNivelCriticidad, Pv_Estado);
    FETCH C_GetAdmiNivelCriticidad INTO Pr_AdmiNivelCriticidad;
    IF C_GetAdmiNivelCriticidad%NOTFOUND THEN
        CLOSE C_GetAdmiNivelCriticidad;
        RAISE Le_NotFound;
    END IF;
    CLOSE C_GetAdmiNivelCriticidad;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Se encontro nivel de criticidad';
  EXCEPTION
    WHEN Le_NotFound THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'No se encontro nivel de criticidad';
    WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_ADMI_NIVEL_CRITICIDAD;

  PROCEDURE P_GET_CASOS(Pcl_Request  IN  CLOB,
                        Pv_Status    OUT VARCHAR2,
                        Pv_Mensaje   OUT VARCHAR2,
                        Pcl_Response OUT CLOB) AS

    /**
     * C_GetHistorialCaso, obtiene el historial de un caso
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   8, cardinalidad 2
     */
    CURSOR C_GetHistorialCaso(Cn_IdCaso Number) IS
      SELECT
        MAX(Fe_Creacion) Fe_Cambio_Estado,
        Ich.Estado
      FROM
        Info_Caso_Historial Ich
      WHERE
        Ich.Caso_Id = Cn_IdCaso
      GROUP BY
        Ich.Estado
      ORDER BY Fe_Cambio_Estado ASC;

    /**
     * C_GetAsignacionCaso, obtiene informaci�n de asignaci�n del caso
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   6, cardinalidad 1
     */
    CURSOR C_GetAsignacionCaso(Cn_IdCaso Number) IS
      SELECT
        Ica.*
      FROM
             Info_Detalle_Hipotesis Idh
        INNER JOIN Info_Caso_Asignacion Ica ON Idh.Id_Detalle_Hipotesis = Ica.Detalle_Hipotesis_Id
      WHERE
        Idh.Caso_Id = Cn_IdCaso;

    /**
     * C_GetAfectadosCaso, obtiene informaci�n de afectados del caso
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   29, cardinalidad 1
     */
    CURSOR C_GetAfectadosCaso(Cn_IdCaso Number, Cv_TipoAfectado Varchar2, Cv_NombreAfectado Varchar2) IS
      SELECT
        Ipa.Afectado_Id,
        Ipa.Afectado_Nombre,
        Ipa.Afectado_Descripcion,
        Ipa.Tipo_Afectado
      FROM
             Info_Caso Ic
        INNER JOIN Info_Detalle_Hipotesis  Idh ON Ic.Id_Caso = Idh.Caso_Id
        INNER JOIN Info_Detalle            Ide ON Idh.Id_Detalle_Hipotesis = Ide.Detalle_Hipotesis_Id
        INNER JOIN Info_Criterio_Afectado  Ica ON Ide.Id_Detalle = Ica.Detalle_Id
        INNER JOIN Info_Parte_Afectada     Ipa ON Ica.Detalle_Id = Ipa.Detalle_Id
                                              AND Ica.Id_Criterio_Afectado = Ipa.Criterio_Afectado_Id
      WHERE
          Ic.Id_Caso = Cn_IdCaso
        AND Initcap(Ipa.Tipo_Afectado) = Cv_TipoAfectado
        AND Ipa.Afectado_Nombre = NVL(Cv_NombreAfectado,Ipa.Afectado_Nombre);

    /**
     * C_GetAfectadosCasoCliente, obtiene informaci�n de afectados del caso por cliente
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   24, cardinalidad 1
     */
    CURSOR C_GetAfectadosCasoCliente(Cn_IdCaso Number, Cv_TipoAfectado Varchar2, Cv_NombreAfectado Varchar2, Cv_IdentCliente Varchar2) IS
      SELECT
        Ipa.Afectado_Id,
        Ipa.Afectado_Nombre,
        Ipa.Afectado_Descripcion,
        Ipa.Tipo_Afectado
      FROM
             Info_Caso Ic
        INNER JOIN Info_Detalle_Hipotesis  Idh ON Ic.Id_Caso = Idh.Caso_Id
        INNER JOIN Info_Detalle            Ide ON Idh.Id_Detalle_Hipotesis = Ide.Detalle_Hipotesis_Id
        INNER JOIN Info_Criterio_Afectado  Ica ON Ide.Id_Detalle = Ica.Detalle_Id
        INNER JOIN Info_Parte_Afectada     Ipa ON Ica.Detalle_Id = Ipa.Detalle_Id
                                              AND Ica.Id_Criterio_Afectado = Ipa.Criterio_Afectado_Id
        INNER JOIN Db_Comercial.Info_Punto               Ipu ON Ipa.Afectado_Nombre = Ipu.Login
        INNER JOIN Db_Comercial.Info_Persona_Empresa_Rol Iper ON Ipu.Persona_Empresa_Rol_Id = Iper.Id_Persona_Rol
        INNER JOIN Db_Comercial.Info_Persona             Ipe ON Iper.Persona_Id = Ipe.Id_Persona                                              
      WHERE
          Ic.Id_Caso = Cn_IdCaso
        AND Initcap(Ipa.Tipo_Afectado) = Cv_TipoAfectado
        AND Ipa.Afectado_Nombre = NVL(Cv_NombreAfectado,Ipa.Afectado_Nombre)
        AND Ipe.Identificacion_Cliente = Cv_IdentCliente;        

    /**
     * C_GetInfoPunto, obtiene informaci�n del punto afectado
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 11-11-2021
     * @costo   3, cardinalidad 1
     */
    CURSOR C_GetInfoPunto(Cn_IdPunto Number) IS
      SELECT
        Ipu.*
      FROM
        Db_Comercial.Info_Punto Ipu
      WHERE
        Ipu.Id_Punto = Cn_IdPunto;

    Lc_AsignacionCaso   C_GetAsignacionCaso%ROWTYPE;
    Lc_InfoPunto        C_GetInfoPunto%ROWTYPE;
    Lr_AdmiParametroDet DB_GENERAL.Admi_Parametro_Det%ROWTYPE;
    Lr_DocRelacion      DB_COMUNICACION.INFO_DOCUMENTO_RELACION%ROWTYPE;
    Lr_Caso             SPKG_TYPES.Ltr_Caso;
    Lr_Documento        SPKG_TYPES.Ltr_Documento;
    Lv_CodEmpresa       DB_COMERCIAL.Info_Empresa_Grupo.cod_Empresa%TYPE;
    Lv_Estado           Info_Caso_Historial.Estado%TYPE;
    Lv_NombreAfectado   Info_Parte_Afectada.Afectado_Nombre%TYPE;
    Ln_IdCaso           Info_Caso.Id_Caso%TYPE;           
    Lv_NumeroCaso       Info_Caso.Numero_Caso%TYPE;
    Lv_IdentCliente     DB_COMERCIAL.Info_Persona.Identificacion_Cliente%TYPE;
    Lv_FeAperturaDesde  VARCHAR2(25);
    Lv_FeAperturaHasta  VARCHAR2(25);
    Lv_FeCierreDesde    VARCHAR2(25);
    Lv_FeCierreHasta    VARCHAR2(25);
    Lv_WhereFeApertura  VARCHAR2(500);
    Lv_WhereFeCierre    VARCHAR2(500);
    Lv_Status           VARCHAR2(200);
    Lv_Mensaje          VARCHAR2(3000);
    Lcl_QuerySelect     CLOB;
    Lcl_QueryFrom       CLOB;
    Lcl_QueryWhere      CLOB;
    Lcl_Query           CLOB;
    Lcl_Response        CLOB;
    Lrf_Casos           SYS_REFCURSOR;
    Lrf_Documentos      SYS_REFCURSOR;
    Li_Cont             PLS_INTEGER;
    Li_Cont_Doc         PLS_INTEGER;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Lv_FeAperturaDesde := APEX_JSON.get_varchar2('fechaAperturaDesde');
    Lv_FeAperturaHasta := APEX_JSON.get_varchar2('fechaAperturaHasta');
    Lv_FeCierreDesde := APEX_JSON.get_varchar2('fechaCierreDesde');
    Lv_FeCierreHasta := APEX_JSON.get_varchar2('fechaCierreHasta');
    Lv_Estado := APEX_JSON.get_varchar2('estado');
    Lv_NombreAfectado := APEX_JSON.get_varchar2('nombreAfectado');
    Lv_IdentCliente := APEX_JSON.get_varchar2('identificacionCliente');
    Ln_IdCaso := APEX_JSON.get_number('idCaso');
    Lv_NumeroCaso := APEX_JSON.get_varchar2('numeroCaso');

    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 

    IF Ln_IdCaso IS NULL AND Lv_NumeroCaso IS NULL AND Lv_FeAperturaDesde IS NULL AND Lv_FeCierreDesde IS NULL THEN
      DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_SOPORTE', 
                                                                  Pv_Descripcion       => 'DIAS_DEFAULT_PARA_CONSULTAR_CASOS',
                                                                  Pv_Empresa_Cod       => Nvl(Lv_CodEmpresa,10),
                                                                  Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                                  Pv_Status            => Lv_Status,
                                                                  Pv_Mensaje           => Lv_Mensaje); 

      Lv_FeAperturaDesde := to_char(Sysdate - Lr_AdmiParametroDet.Valor1,'rrrr-mm-dd');
    END IF;

    DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT
                                    Ic.Id_Caso,
                                    Ic.Empresa_Cod,
                                    Ieg.Nombre_Empresa,
                                    Ieg.Prefijo,
                                    Ic.Tipo_Caso_Id,
                                    Atc.Nombre_Tipo_Caso,
                                    Ic.Forma_Contacto_Id,
                                    Afc.descripcion_Forma_Contacto,
                                    Ic.Nivel_Criticidad_Id,
                                    Anc.Nombre_Nivel_Criticidad,
                                    Ic.Numero_Caso,
                                    Ic.Titulo_Ini,
                                    Ic.Titulo_Fin,
                                    Ic.Version_Ini,
                                    Ic.Version_Fin,
                                    Ic.Fe_Apertura,
                                    Ic.Fe_Cierre,
                                    Ic.Usr_Creacion,
                                    Ic.Ip_Creacion,
                                    Ic.Fe_Creacion,
                                    Ic.Titulo_Fin_Hip,
                                    Ic.Tipo_Afectacion,
                                    Ic.Tipo_Backbone,
                                    Ic.Origen,
                                    (
                                      SELECT
                                        Ichi.Estado
                                      FROM
                                        Db_Soporte.Info_Caso_Historial Ichi
                                      WHERE
                                        Ichi.Id_Caso_Historial = (
                                          SELECT
                                            MAX(Ich.Id_Caso_Historial)
                                          FROM
                                            Db_Soporte.Info_Caso_Historial Ich
                                          WHERE
                                            Ich.Caso_Id = Ic.Id_Caso
                                        )
                                    )                           AS Estado ');
    DBMS_LOB.APPEND(Lcl_QueryFrom,'FROM Db_Soporte.Info_Caso Ic
                                  INNER JOIN Db_Comercial.Info_Empresa_Grupo  Ieg 
                                    ON Ic.Empresa_Cod = Ieg.Cod_Empresa
                                  INNER JOIN Db_Comercial.Admi_Forma_Contacto  Afc 
                                    ON Ic.Forma_Contacto_Id = Afc.Id_Forma_Contacto
                                  INNER JOIN Db_Soporte.Admi_Tipo_Caso        Atc 
                                    ON Ic.Tipo_Caso_Id = Atc.Id_Tipo_Caso
                                  INNER JOIN Db_Soporte.Admi_Nivel_Criticidad Anc 
                                    ON Ic.Nivel_Criticidad_Id = Anc.Id_Nivel_Criticidad ');

    IF (Ln_IdCaso IS NULL AND Lv_NumeroCaso IS NULL AND Lv_FeCierreDesde IS NULL) OR Lv_FeAperturaDesde IS NOT NULL THEN
      Lv_WhereFeApertura := 'WHERE Ic.Fe_Apertura >= To_Date('':feAperturaDesde'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeApertura := REPLACE(Lv_WhereFeApertura,':feAperturaDesde', Lv_FeAperturaDesde);
      DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeApertura);
    ELSIF Lv_FeCierreDesde IS NOT NULL THEN
      Lv_WhereFeCierre := 'WHERE Ic.Fe_Cierre >= To_Date('':feCierreDesde'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeCierre := REPLACE(Lv_WhereFeCierre, ':feCierreDesde', Lv_FeCierreDesde);
      DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeCierre);
    ELSE      
      IF Ln_IdCaso IS NOT NULL AND Lv_NumeroCaso IS NOT NULL THEN
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('WHERE Ic.Id_Caso = :idCaso ',':idCaso',Ln_IdCaso));
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ic.Numero_Caso = '':numeroCaso'' ',':numeroCaso',Lv_NumeroCaso));
      ELSE
        IF Ln_IdCaso IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('WHERE Ic.Id_Caso = :idCaso ',':idCaso',Ln_IdCaso));
        END IF;      
        IF Lv_NumeroCaso IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('WHERE Ic.Numero_Caso = '':numeroCaso'' ',':numeroCaso',Lv_NumeroCaso));
        END IF; 
      END IF;

      IF Lv_FeAperturaDesde IS NOT NULL THEN
        Lv_WhereFeApertura := 'AND Ic.Fe_Apertura >= To_Date('':feAperturaDesde'',''rrrr-mm-dd hh24:mi:ss'') ';
        Lv_WhereFeApertura := REPLACE(Lv_WhereFeApertura, ':feAperturaDesde', Lv_FeAperturaDesde);
        DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeApertura);
      END IF;
    END IF;

    IF Lv_FeAperturaHasta IS NOT NULL THEN
      Lv_WhereFeApertura := 'AND  Ic.Fe_Apertura <=  To_Date('':feAperturaHasta'',''rrrr-mm-dd hh24:mi:ss'') ';
      IF Length(Lv_FeAperturaHasta) = 10 THEN
        Lv_FeAperturaHasta := Lv_FeAperturaHasta || ' 23:59:59';
      END IF;
      Lv_WhereFeApertura := REPLACE(Lv_WhereFeApertura, ':feAperturaHasta', Lv_FeAperturaHasta);
      DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeApertura);
    END IF;

    IF Lv_FeAperturaDesde IS NOT NULL AND Lv_FeCierreDesde IS NOT NULL THEN
      Lv_WhereFeCierre := 'AND Ic.Fe_Cierre >= To_Date('':feCierreDesde'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeCierre := REPLACE(Lv_WhereFeCierre, ':feCierreDesde', Lv_FeCierreDesde);
      DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeCierre);      
    END IF;

    IF Lv_FeCierreHasta IS NOT NULL THEN
      Lv_WhereFeCierre := 'AND  Ic.Fe_Cierre <=  To_Date('':feCierreHasta'',''rrrr-mm-dd hh24:mi:ss'') ';
      Lv_WhereFeCierre := REPLACE(Lv_WhereFeCierre, ':feCierreHasta', Lv_FeCierreHasta);
      DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereFeCierre);
    END IF;

    IF Lv_CodEmpresa IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ic.Empresa_Cod = '':codEmpresa'' ',':codEmpresa',Lv_CodEmpresa));   
    END IF;

    DBMS_LOB.APPEND(Lcl_Query,'SELECT distinct tab.* FROM ( ');
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    DBMS_LOB.APPEND(Lcl_Query,') tab ');

    IF Lv_IdentCliente IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Query,'INNER JOIN Db_Soporte.Info_Detalle_Hipotesis Idh ON Tab.Id_Caso = Idh.Caso_Id
                                INNER JOIN Db_Soporte.Info_Detalle           Ide ON Idh.Id_Detalle_Hipotesis = Ide.Detalle_Hipotesis_Id
                                INNER JOIN Db_Soporte.Info_Parte_Afectada    Ipaf ON Ide.Id_Detalle = Ipaf.Detalle_Id
                                INNER JOIN Db_Comercial.Info_Punto           Ipu ON Ipaf.Afectado_Nombre = Ipu.Login
                                INNER JOIN DB_COMERCIAL.Info_Persona_Empresa_Rol Iper ON Ipu.persona_Empresa_Rol_Id = Iper.id_Persona_Rol
                                INNER JOIN DB_COMERCIAL.Info_Persona Ipe ON Iper.persona_Id = Ipe.Id_Persona ');
       DBMS_LOB.APPEND(Lcl_Query,'WHERE Ipe.identificacion_Cliente = '''||Lv_IdentCliente||''' ');
       IF Lv_NombreAfectado IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_Query,'AND Ipaf.Afectado_Nombre = '''||Lv_NombreAfectado||''' ');
       END IF;
    END IF;

    IF Lv_IdentCliente IS NULL AND Lv_NombreAfectado IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Query,'INNER JOIN Db_Soporte.Info_Detalle_Hipotesis Idh ON tab.Id_Caso = Idh.Caso_Id
                                INNER JOIN Db_Soporte.Info_Detalle           Ide ON Idh.Id_Detalle_Hipotesis = Ide.Detalle_Hipotesis_Id
                                INNER JOIN Db_Soporte.Info_Parte_Afectada    Ipaf ON Ide.Id_Detalle = Ipaf.Detalle_Id ');
       DBMS_LOB.APPEND(Lcl_Query,'WHERE Ipaf.Afectado_Nombre = '''||Lv_NombreAfectado||''' ');
    END IF;   


    IF Lv_Estado IS NOT NULL THEN
      IF Lv_NombreAfectado IS NULL AND Lv_IdentCliente IS NULL THEN
        DBMS_LOB.APPEND(Lcl_Query,'WHERE tab.estado = '''||Lv_Estado||''' ');
      ELSE
        DBMS_LOB.APPEND(Lcl_Query,'AND tab.estado = '''||Lv_Estado||''' ');
      END IF;      
    END IF;
    DBMS_LOB.APPEND(Lcl_Query,'ORDER BY tab.Fe_Apertura DESC');

    OPEN Lrf_Casos FOR Lcl_Query;

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_ARRAY();
    LOOP
      FETCH Lrf_Casos BULK COLLECT INTO Lr_Caso LIMIT 100;
        Li_Cont := Lr_Caso.FIRST;
        WHILE (Li_Cont IS NOT NULL) LOOP
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idCaso', Lr_Caso(Li_Cont).Id_Caso);
          APEX_JSON.WRITE('codEmpresa', Lr_Caso(Li_Cont).Cod_Empresa);
          APEX_JSON.WRITE('nombreEmpresa', Lr_Caso(Li_Cont).Nombre_Empresa);
          APEX_JSON.WRITE('prefijoEmpresa', Lr_Caso(Li_Cont).Prefijo);
          APEX_JSON.WRITE('idTipoCaso', Lr_Caso(Li_Cont).Id_Tipo_Caso);
          APEX_JSON.WRITE('tipoCaso', Lr_Caso(Li_Cont).Tipo_Caso);
          APEX_JSON.WRITE('idFormaContacto', Lr_Caso(Li_Cont).Id_Forma_Contacto);
          APEX_JSON.WRITE('formaContacto', Lr_Caso(Li_Cont).Forma_Contacto);
          APEX_JSON.WRITE('idNivelCriticidad', Lr_Caso(Li_Cont).Id_Nivel_Criticidad);
          APEX_JSON.WRITE('nivelCriticidad', Lr_Caso(Li_Cont).Nivel_Criticidad);                          
          APEX_JSON.WRITE('numeroCaso', Lr_Caso(Li_Cont).Numero_Caso); 
          APEX_JSON.WRITE('tituloInicial', Lr_Caso(Li_Cont).Titulo_Inicial); 
          APEX_JSON.WRITE('tituloFinal', Lr_Caso(Li_Cont).Titulo_Final); 
          APEX_JSON.WRITE('versionInicial', Lr_Caso(Li_Cont).Version_Inicial); 
          APEX_JSON.WRITE('versionFinal', Lr_Caso(Li_Cont).Version_Final); 
          APEX_JSON.WRITE('fechaApertura', Lr_Caso(Li_Cont).Fe_Apertura); 
          APEX_JSON.WRITE('fechaCierre', Lr_Caso(Li_Cont).Fe_Cierre); 
          APEX_JSON.WRITE('usuarioCreacion', Lr_Caso(Li_Cont).Usr_Creacion); 
          APEX_JSON.WRITE('ipCreacion', Lr_Caso(Li_Cont).Ip_Creacion); 
          APEX_JSON.WRITE('fechaCreacion', Lr_Caso(Li_Cont).Fe_Creacion); 
          APEX_JSON.WRITE('idHipotesisTituloFinal', Lr_Caso(Li_Cont).Id_Titulo_Fin_Hip);
          APEX_JSON.WRITE('tipoAfectacion', Lr_Caso(Li_Cont).Tipo_Afectacion); 
          APEX_JSON.WRITE('tipoBackbone', Lr_Caso(Li_Cont).Tipo_Backbone); 
          APEX_JSON.WRITE('origen', Lr_Caso(Li_Cont).Origen); 
          APEX_JSON.WRITE('estado', Lr_Caso(Li_Cont).Estado);

          APEX_JSON.OPEN_ARRAY('historial');
          FOR i in C_GetHistorialCaso(Lr_Caso(Li_Cont).Id_Caso) LOOP
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('fechaCambioEstado', i.Fe_Cambio_Estado);
            APEX_JSON.WRITE('estado', i.Estado);

            IF i.Estado = 'Asignado' THEN
              APEX_JSON.OPEN_OBJECT('detalleAsignacion');
              OPEN C_GetAsignacionCaso(Lr_Caso(Li_Cont).Id_Caso);
              FETCH C_GetAsignacionCaso INTO Lc_AsignacionCaso;
              CLOSE C_GetAsignacionCaso;
              APEX_JSON.WRITE('idAsignado', Lc_AsignacionCaso.Asignado_Id);
              APEX_JSON.WRITE('nombreAsignado', Lc_AsignacionCaso.Asignado_Nombre);
              APEX_JSON.WRITE('refIdAsignado', Lc_AsignacionCaso.Ref_Asignado_Id);
              APEX_JSON.WRITE('refNombreAsignado', Lc_AsignacionCaso.Ref_Asignado_Nombre);
              APEX_JSON.WRITE('idPersonaEmpresaRol', Lc_AsignacionCaso.Persona_Empresa_Rol_Id);
              APEX_JSON.WRITE('motivo', Lc_AsignacionCaso.Motivo);              
              APEX_JSON.CLOSE_OBJECT;
            END IF;

            APEX_JSON.CLOSE_OBJECT;
          END LOOP;
          APEX_JSON.CLOSE_ARRAY;

          APEX_JSON.OPEN_ARRAY('afectados');
          IF Lv_IdentCLiente IS NULL THEN
            FOR i in C_GetAfectadosCaso(Lr_Caso(Li_Cont).Id_Caso,'Cliente',Lv_NombreAfectado) LOOP
              APEX_JSON.OPEN_OBJECT;
              APEX_JSON.WRITE('tipoAfectado', i.Tipo_Afectado);
              APEX_JSON.WRITE('idAfectado', i.Afectado_Id);
              APEX_JSON.WRITE('nombreAfectado', i.Afectado_Nombre);
              APEX_JSON.WRITE('descripcionAfectado', i.Afectado_Descripcion);
                APEX_JSON.OPEN_OBJECT('detallePunto');
                OPEN C_GetInfoPunto(i.Afectado_Id);
                FETCH C_GetInfoPunto INTO Lc_InfoPunto;
                CLOSE C_GetInfoPunto;
                APEX_JSON.WRITE('direccion', Lc_InfoPunto.Direccion);
                APEX_JSON.WRITE('latitud', Lc_InfoPunto.Latitud);
                APEX_JSON.WRITE('longitud', Lc_InfoPunto.Longitud);
                APEX_JSON.WRITE('idPuntoCobertura', Lc_InfoPunto.Punto_Cobertura_Id);
                APEX_JSON.WRITE('idTipoUbicacion', Lc_InfoPunto.Tipo_Ubicacion_Id);
                APEX_JSON.WRITE('idSector', Lc_InfoPunto.Sector_Id);
                APEX_JSON.WRITE('idTipoNegocio', Lc_InfoPunto.Tipo_Negocio_Id);
                APEX_JSON.CLOSE_OBJECT;
              APEX_JSON.CLOSE_OBJECT;
            END LOOP;
          ELSE
            FOR i in C_GetAfectadosCasoCliente(Lr_Caso(Li_Cont).Id_Caso,'Cliente',Lv_NombreAfectado,Lv_IdentCLiente) LOOP
              APEX_JSON.OPEN_OBJECT;
              APEX_JSON.WRITE('tipoAfectado', i.Tipo_Afectado);
              APEX_JSON.WRITE('idAfectado', i.Afectado_Id);
              APEX_JSON.WRITE('nombreAfectado', i.Afectado_Nombre);
              APEX_JSON.WRITE('descripcionAfectado', i.Afectado_Descripcion);
                APEX_JSON.OPEN_OBJECT('detallePunto');
                OPEN C_GetInfoPunto(i.Afectado_Id);
                FETCH C_GetInfoPunto INTO Lc_InfoPunto;
                CLOSE C_GetInfoPunto;
                APEX_JSON.WRITE('direccion', Lc_InfoPunto.Direccion);
                APEX_JSON.WRITE('latitud', Lc_InfoPunto.Latitud);
                APEX_JSON.WRITE('longitud', Lc_InfoPunto.Longitud);
                APEX_JSON.WRITE('idPuntoCobertura', Lc_InfoPunto.Punto_Cobertura_Id);
                APEX_JSON.WRITE('idTipoUbicacion', Lc_InfoPunto.Tipo_Ubicacion_Id);
                APEX_JSON.WRITE('idSector', Lc_InfoPunto.Sector_Id);
                APEX_JSON.WRITE('idTipoNegocio', Lc_InfoPunto.Tipo_Negocio_Id);
                APEX_JSON.CLOSE_OBJECT;
              APEX_JSON.CLOSE_OBJECT;
            END LOOP;
          END IF;
          APEX_JSON.CLOSE_ARRAY;

          Lr_DocRelacion.Caso_Id := Lr_Caso(Li_Cont).Id_Caso;
          Lr_DocRelacion.Estado := 'Activo';

          DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA.P_GET_DOCUMENTOS_RELACIONADOS(Pr_DocumentoRelacion => Lr_DocRelacion,
                                                                                     Pv_Status            => Lv_Status,
                                                                                     Pv_Mensaje           => Lv_Mensaje,
                                                                                     Prf_Response         => Lrf_Documentos);

          APEX_JSON.OPEN_ARRAY('documentos');
          LOOP
            FETCH Lrf_Documentos BULK COLLECT INTO Lr_Documento LIMIT 100;
              Li_Cont_Doc := Lr_Documento.FIRST;
              WHILE (Li_Cont_Doc IS NOT NULL) LOOP
                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.WRITE('idDocumento',Lr_Documento(Li_Cont_Doc).Id_Documento);
                APEX_JSON.WRITE('nombreDocumento', Lr_Documento(Li_Cont_Doc).Ubicacion_Logica_Documento);
                APEX_JSON.WRITE('rutaDocumento', Lr_Documento(Li_Cont_Doc).Ubicacion_Fisica_Documento);
                APEX_JSON.CLOSE_OBJECT;
                Li_Cont_Doc:= Lr_Documento.NEXT(Li_Cont_Doc);
              END LOOP;
            EXIT WHEN Lrf_Documentos%NOTFOUND;
          END LOOP;              
          APEX_JSON.CLOSE_ARRAY;

          APEX_JSON.CLOSE_OBJECT;
          Li_Cont:= Lr_Caso.NEXT(Li_Cont);
        END LOOP;
      EXIT WHEN Lrf_Casos%NOTFOUND;
    END LOOP;
    APEX_JSON.CLOSE_ARRAY;
    Lcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';
    Pcl_Response := Lcl_Response;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_CASOS;

  PROCEDURE P_GET_CANT_CASOS_SEGUN_TAREAS(Pcl_Request  IN  CLOB,
                                          Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT CLOB) AS

    /**
     * C_GetCantCasosPorOrigen, obtiene la cantidad de casos segun tareas, 
     * filtrado por codigo de Forma de contacto y origen del caso
     * @author  David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0 10-03-2022
     * @costo   8, cardinalidad 1
     */
    CURSOR C_GetCantCasosPorOrigen(Cv_CodEmpresa Varchar2, Cv_Origen Varchar2, Cv_Codigo Varchar2) IS
      SELECT
      (
        SELECT
          COUNT(1) Casos_Contareas
        FROM
          (
            SELECT DISTINCT
              Ico.Caso_Id
            FROM
                   Db_Soporte.Info_Comunicacion Ico
              INNER JOIN Db_Soporte.Info_Detalle_Asignacion Ida ON Ico.Detalle_Id = Ida.Detalle_Id
            WHERE
              Ico.Caso_Id IN (
                SELECT
                  Ic.Id_Caso
                FROM
                       Db_Soporte.Info_Caso Ic
                  INNER JOIN Admi_Forma_Contacto Afc ON Ic.Forma_Contacto_Id = Afc.Id_Forma_Contacto
                WHERE
                    Ic.Empresa_Cod = Cv_CodEmpresa
                  AND Ic.Origen = Cv_Origen
                  AND Ic.Fe_Cierre IS NULL
                  AND Afc.Codigo = Cv_Codigo
              )
          )
      ) Cant_Casos_Tareas,
      (
        SELECT
          COUNT(Ica.Id_Caso) Casos_Sintareas
        FROM
               Db_Soporte.Info_Caso Ica
          INNER JOIN Admi_Forma_Contacto Afco ON Ica.Forma_Contacto_Id = Afco.Id_Forma_Contacto
        WHERE
            Ica.Empresa_Cod = Cv_CodEmpresa
          AND Ica.Origen = Cv_Origen
          AND Ica.Fe_Cierre IS NULL
          AND Ica.Id_Caso NOT IN (
            SELECT DISTINCT
              Ico.Caso_Id
            FROM
                   Db_Soporte.Info_Comunicacion Ico
              INNER JOIN Db_Soporte.Info_Detalle_Asignacion Ida ON Ico.Detalle_Id = Ida.Detalle_Id
            WHERE
              Ico.Caso_Id IN (
                SELECT
                  Ic.Id_Caso
                FROM
                       Db_Soporte.Info_Caso Ic
                  INNER JOIN Admi_Forma_Contacto Afc ON Ic.Forma_Contacto_Id = Afc.Id_Forma_Contacto
                WHERE
                    Ic.Empresa_Cod = Cv_CodEmpresa
                  AND Ic.Origen = Cv_Origen
                  AND Ic.Fe_Cierre IS NULL
                  AND Afc.Codigo = Cv_Codigo
              )
          )
          AND Afco.Codigo = Cv_Codigo
      ) Cant_Casos_Sintareas
    FROM
        Dual;

    Lv_CodEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lv_Origen           DB_SOPORTE.INFO_CASO.ORIGEN%TYPE;
    Lv_CodFormaContacto DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE;
    Lc_CantCasos        C_GetCantCasosPorOrigen%ROWTYPE;

  BEGIN   

    APEX_JSON.PARSE(Pcl_Request);
    BEGIN
      Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
      Lv_Origen := APEX_JSON.get_varchar2('origen');
      Lv_CodFormaContacto := APEX_JSON.get_varchar2('codigoFormaContacto');
    EXCEPTION
      WHEN OTHERS THEN
        Pv_Status := 'ERROR';
        Pv_Mensaje := 'Al menos un par�metro no tiene el valor correcto, por favor verificar.';
        RETURN;
    END;

    OPEN C_GetCantCasosPorOrigen(Lv_CodEmpresa,Lv_Origen,Lv_CodFormaContacto);
    FETCH C_GetCantCasosPorOrigen INTO Lc_CantCasos;
    CLOSE C_GetCantCasosPorOrigen;

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('casosSinTareas',Lc_CantCasos.Cant_Casos_Sintareas);
    APEX_JSON.WRITE('casosConTareas',Lc_CantCasos.Cant_Casos_Tareas);
    APEX_JSON.CLOSE_OBJECT;
    Pcl_Response := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error al consultar la cantidad de casos';
      DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Nvl(Lv_CodEmpresa,'10'),
                                           '1',
                                           'P_GET_CANT_CASOS_SEGUN_TAREAS',
                                           'DB_SOPORTE.SPKG_CASOS_CONSULTA',
                                           'P_GET_CANT_CASOS_SEGUN_TAREAS',
                                           'Ejecutando procedure principal P_GET_CANT_CASOS_SEGUN_TAREAS',
                                           'Fallido',
                                           SQLERRM,
                                           '',
                                           'telcos'
                                          ); 
  END P_GET_CANT_CASOS_SEGUN_TAREAS;                                          

END SPKG_CASOS_CONSULTA;

/