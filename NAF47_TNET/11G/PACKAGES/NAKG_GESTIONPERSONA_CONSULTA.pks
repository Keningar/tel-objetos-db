CREATE OR REPLACE PACKAGE            "NAKG_GESTIONPERSONA_CONSULTA" AS 

  /**
    * Documentación para el paquete NAKG_GESTIONPERSONA_CONSULTA
    *
    * Paquete que contiene procedimientos y funciones para consultar Información 
    * desde el sistema Gestión Personal.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    */

  /**
    * Documentación para el procedimiento 'P_INFORMACION_TIPO_DOCUMENTO'.
    *
    * Procedimiento que contiene información del tipo de documento.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para retornar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la consulta.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la consulta
    * @param Pcl_Response   OUT SYS_REFCURSOR Devuelve el cursor de la consulta.
    *
    */
  PROCEDURE P_INFORMACION_TIPO_DOCUMENTO(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR);

  /**
    * Documentación para el procedimiento 'P_INFORMACION_TIPO_SANCION'.
    *
    * Procedimiento que contiene información del tipo de sanción.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para retornar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la consulta.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la consulta
    * @param Pcl_Response   OUT SYS_REFCURSOR Devuelve el cursor de la consulta.
    *
    */
  PROCEDURE P_INFORMACION_TIPO_SANCION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);

  /**
    * Documentación para el procedimiento 'P_INFORMACION_HALLAZGO'.
    *
    * Procedimiento que contiene información del hallazgo.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para retornar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la consulta.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la consulta
    * @param Pcl_Response   OUT SYS_REFCURSOR Devuelve el cursor de la consulta.
    *
    */
  PROCEDURE P_INFORMACION_HALLAZGO(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR);
  /**
    * Documentación para el procedimiento 'P_INFORMACION_DOCUMENTO'.
    *
    * Procedimiento que contiene información del documento.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para retornar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la consulta.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la consulta
    * @param Pcl_Response   OUT SYS_REFCURSOR Devuelve el cursor de la consulta.
    *
    */
  PROCEDURE P_INFORMACION_DOCUMENTO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR);

END NAKG_GESTIONPERSONA_CONSULTA;
/


CREATE OR REPLACE PACKAGE BODY            "NAKG_GESTIONPERSONA_CONSULTA" AS

  PROCEDURE P_INFORMACION_TIPO_DOCUMENTO(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR)

   AS 
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderBy            CLOB;
    Lv_EmpresaCod          VARCHAR2(2);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    Lcl_Select  := ' SELECT ATD.* ';

    Lcl_From    := ' FROM NAF47_TNET.ADMI_TIPO_DOCUMENTO ATD ';

    Lcl_Where   := ' WHERE ATD.COD_EMPRESA = '''||Lv_EmpresaCod||''' AND ATD.ESTADO=''Activo'' ';

    Lcl_OrderBy := ' ORDER BY ATD.TIPO_DOCUMENTO ASC ';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where || Lcl_OrderBy;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INFORMACION_TIPO_DOCUMENTO;

  PROCEDURE P_INFORMACION_TIPO_SANCION(Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)

   AS 
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderBy            CLOB;
    Lv_EmpresaCod          VARCHAR2(2);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod          := APEX_JSON.get_varchar2(p_path => 'empresaCod');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := '
              SELECT ATS.*';

    Lcl_From         := '
              FROM NAF47_TNET.ADMI_TIPO_SANCION ATS ';

    Lcl_Where := '
              WHERE ATS.COD_EMPRESA = '''||Lv_EmpresaCod||''' 
              AND ATS.ESTADO=''Activo'' ';

    Lcl_OrderBy := ' ORDER BY ATS.TIPO_SANCION ASC ';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where || Lcl_OrderBy;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INFORMACION_TIPO_SANCION;

  PROCEDURE P_INFORMACION_HALLAZGO(Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)

   AS 
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderBy            CLOB;
    Lv_EmpresaCod          VARCHAR2(2);
    Lv_IdTipoSancion       VARCHAR2(50);
    Lv_NombreDepartamento  VARCHAR2(50);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_EmpresaCod         := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_IdTipoSancion      := APEX_JSON.get_varchar2(p_path => 'idTipoSancion');
    Lv_NombreDepartamento := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_IdTipoSancion IS NULL THEN
       Pv_Mensaje := 'El parámetro nivel de sanción es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_NombreDepartamento IS NULL THEN
       Pv_Mensaje := 'El parámetro departamento es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    Lcl_Select       := ' SELECT AH.* ';

    Lcl_From         := ' FROM NAF47_TNET.ADMI_HALLAZGO AH ';

    Lcl_Where := ' WHERE AH.COD_EMPRESA = '''||Lv_EmpresaCod||''' 
                   AND AH.ESTADO =''Activo'' AND AH.TIPO_SANCION_ID ='''||Lv_IdTipoSancion||''' AND UPPER(AH.DEPARTAMENTO) ='''||Lv_NombreDepartamento||''' ';

    Lcl_OrderBy := ' ORDER BY AH.HALLAZGO ASC ';

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where || Lcl_OrderBy;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INFORMACION_HALLAZGO;

  PROCEDURE P_INFORMACION_DOCUMENTO(Pcl_Request  IN  CLOB,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2,
                                    Pcl_Response OUT SYS_REFCURSOR)

   AS 
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderBy            CLOB;
    Lv_IdDocumento         VARCHAR2(400);
    Lv_IdTipoDoc           VARCHAR2(400);
    Lv_IdTipoSancion       VARCHAR2(400);
    Lv_IdHallazgo          VARCHAR2(400);
    Lv_IdEmple             VARCHAR2(400);
    Lv_NombreDepartamento  VARCHAR2(400);
    Lv_IdTarea             VARCHAR2(400);
    Lv_Estado              VARCHAR2(50);
    Lv_EmpresaCod          VARCHAR2(3);
    Lv_FechaIni            VARCHAR2(100);
    Lv_FechaFin            VARCHAR2(100);
    Lv_FechaHallazgoIni    VARCHAR2(100);
    Lv_FechaHallazgoFin    VARCHAR2(100);
    Lv_NoEmpleado          VARCHAR2(400);
    Lv_UsrCreacion         VARCHAR2(400);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdDocumento        := APEX_JSON.get_varchar2(p_path => 'idDocumento');
    Lv_IdTipoDoc          := APEX_JSON.get_varchar2(p_path => 'idTipoDoc');
    Lv_IdTipoSancion      := APEX_JSON.get_varchar2(p_path => 'idTipoSancion');
    Lv_IdHallazgo         := APEX_JSON.get_varchar2(p_path => 'idHallazgo');
    Lv_IdEmple            := APEX_JSON.get_varchar2(p_path => 'idEmpleado');
    Lv_NombreDepartamento := APEX_JSON.get_varchar2(p_path => 'nombreDepartamento');
    Lv_IdTarea            := APEX_JSON.get_varchar2(p_path => 'idTarea');
    Lv_Estado             := APEX_JSON.get_varchar2(p_path => 'estado');
    Lv_EmpresaCod         := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_FechaIni           := APEX_JSON.get_varchar2(p_path => 'feCreacionIni');
    Lv_FechaFin           := APEX_JSON.get_varchar2(p_path => 'feCreacionFin');
    Lv_NoEmpleado         := APEX_JSON.get_varchar2(p_path => 'noEmpleado');
    Lv_FechaHallazgoIni   := APEX_JSON.get_varchar2(p_path => 'feHallazgoIni');
    Lv_FechaHallazgoFin   := APEX_JSON.get_varchar2(p_path => 'feHallazgoFin');
    Lv_UsrCreacion        := APEX_JSON.get_varchar2(p_path => 'usrCreacion');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    Lcl_Select := ' SELECT IDOC.ID_DOCUMENTO,
                           ATD.TIPO_DOCUMENTO,
                           ATS.TIPO_SANCION,
                           AH.HALLAZGO,
                           VEMP.NOMBRE AS EMPLEADO,
                           IDOC.DEPARTAMENTO,
                           IDOC.TAREA_ID,
                           IDOC.OBSERVACION,
                           IDOC.ESTADO,
                           IDOC.USR_CREACION,
                           TO_CHAR(IDOC.FE_HALLAZGO, ''DD/MM/YYYY'') AS FE_HALLAZGO,
                           TO_CHAR(IDOC.FE_CREACION, ''DD/MM/YYYY'') AS FE_CREACION';

    Lcl_From   := ' FROM NAF47_TNET.INFO_DOCUMENTO         IDOC
                    JOIN NAF47_TNET.ADMI_TIPO_DOCUMENTO    ATD ON ATD.ID_TIPO_DOCUMENTO = IDOC.TIPO_DOCUMENTO_ID
                                                              AND ATD.ESTADO = ''Activo''
                    JOIN NAF47_TNET.ADMI_TIPO_SANCION      ATS ON ATS.ID_TIPO_SANCION = IDOC.TIPO_SANCION_ID
                                                              AND ATS.ESTADO = ''Activo''
                    JOIN NAF47_TNET.ADMI_HALLAZGO          AH ON AH.ID_HALLAZGO = IDOC.HALLAZGO_ID
                                                              AND AH.ESTADO = ''Activo''
                    JOIN NAF47_TNET.V_EMPLEADOS_EMPRESAS   VEMP ON VEMP.NO_EMPLE = IDOC.NO_EMPLE_ID
                                                              AND VEMP.ESTADO = ''A''
                                                              AND VEMP.NO_CIA = '''||Lv_EmpresaCod||''' 
                  ';
    Lcl_Where  := ' WHERE IDOC.COD_EMPRESA = '''||Lv_EmpresaCod||''' ';

    Lcl_OrderBy := ' ORDER BY IDOC.FE_CREACION DESC ';

    IF Lv_NombreDepartamento IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND UPPER(AH.DEPARTAMENTO) = '''||Lv_NombreDepartamento||''' ';
    END IF;

    IF Lv_IdTipoDoc IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.TIPO_DOCUMENTO_ID = '''||Lv_IdTipoDoc||''' ';
    END IF;

    IF Lv_IdDocumento IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.ID_DOCUMENTO = '''||Lv_IdDocumento||''' ';
    END IF;

    IF Lv_IdTipoSancion IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.TIPO_SANCION_ID = '''||Lv_IdTipoSancion||''' ';
    END IF;

    IF Lv_IdHallazgo IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.HALLAZGO_ID = '''||Lv_IdHallazgo||''' ';
    END IF;

    IF Lv_IdEmple IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.NO_EMPLE_ID = '''||Lv_IdEmple||''' ';
    END IF;

    IF Lv_NombreDepartamento IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND UPPER(IDOC.DEPARTAMENTO) = '''||Lv_NombreDepartamento||''' ';
    END IF;

    IF Lv_IdTarea IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND IDOC.TAREA_ID = '''||Lv_IdTarea||''' ';
    END IF;

    IF Lv_Estado IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND UPPER(IDOC.ESTADO) = '''||Lv_Estado||''' ';
    END IF;

    IF Lv_FechaIni IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND TO_CHAR(IDOC.FE_CREACION, ''DD/MM/YYYY'') >= '''||Lv_FechaIni||''' ';
    END IF;

    IF Lv_FechaFin IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND TO_CHAR(IDOC.FE_CREACION, ''DD/MM/YYYY'') <= '''||Lv_FechaFin||''' ';
    END IF;

    IF Lv_FechaHallazgoIni IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND TO_CHAR(IDOC.FE_HALLAZGO, ''DD/MM/YYYY'') >= '''||Lv_FechaHallazgoIni||''' ';
    END IF;

    IF Lv_FechaHallazgoFin IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND TO_CHAR(IDOC.FE_HALLAZGO, ''DD/MM/YYYY'') <= '''||Lv_FechaHallazgoFin||''' ';
    END IF;

    IF Lv_NoEmpleado IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND UPPER(vemp.nombre) LIKE ''%'||Lv_NoEmpleado||'%'' ';
    END IF;

    IF Lv_UsrCreacion IS NOT NULL THEN
       Lcl_Where := Lcl_Where || ' AND LOWER(IDOC.USR_CREACION) = '''||Lv_UsrCreacion||''' ';
    END IF;

    Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where || Lcl_OrderBy;

    OPEN Pcl_Response FOR Lcl_Query;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INFORMACION_DOCUMENTO;

END NAKG_GESTIONPERSONA_CONSULTA;
/
