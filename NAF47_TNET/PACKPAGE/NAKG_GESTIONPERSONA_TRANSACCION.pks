CREATE OR REPLACE PACKAGE "NAF47_TNET"."NAKG_GESTIONPERSONA_TRANSACC" AS 

  /**
    * Documentación para el paquete NAKG_GESTIONPERSONA_TRANSACC
    * Paquete que contiene procedimientos y funciones para transacciones.
    * desde el sistema Gestión Personal.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    */

  /**
    * Documentación para el procedimiento 'P_INGRESAR_DOCUMENTO'.
    * Procedimiento que ingresa información del documento.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para ingresar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la transacción.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la transacción
    *
    */
  PROCEDURE P_INGRESAR_DOCUMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2);

  /**
    * Documentación para el procedimiento 'P_ELIMINAR_DOCUMENTO'.
    * Procedimiento que elimina información del documento.
    *
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 15-05-2021
    *
    * @param Pcl_Request    IN  CLOB     Recibe los parámetros necesarios para eliminar la información.
    * @param Pv_Status      OUT VARCHAR2 Devuelve el estado de la transacción.
    * @param Pv_Mensaje     OUT VARCHAR2 Devuelve el mensaje de la transacción
    *
    */
  PROCEDURE P_ELIMINAR_DOCUMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2);

END NAKG_GESTIONPERSONA_TRANSACC;

/

CREATE OR REPLACE PACKAGE BODY "NAF47_TNET"."NAKG_GESTIONPERSONA_TRANSACC" AS

  PROCEDURE P_INGRESAR_DOCUMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2)

   AS 
    Lv_TipoDocumentoId     VARCHAR2(400);
    Lv_TipoSancionId       VARCHAR2(400);
    Lv_HallazgoId          VARCHAR2(400);
    Lv_NoEmpleId           VARCHAR2(400);
    Lv_Departamento        VARCHAR2(400);
    Lv_TareaId             VARCHAR2(400);
    Lv_Observacion         VARCHAR2(400);
    Lv_UsrCreacion         VARCHAR2(50);
    Lv_IpCreacion          VARCHAR2(50);
    Lv_EmpresaCod          VARCHAR2(3);
    Lv_FechaHallazgo       VARCHAR2(100);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_TipoDocumentoId    := APEX_JSON.get_varchar2(p_path => 'tipoDocumentoId');
    Lv_TipoSancionId      := APEX_JSON.get_varchar2(p_path => 'tipoSancionId');
    Lv_HallazgoId         := APEX_JSON.get_varchar2(p_path => 'hallazgoId');
    Lv_NoEmpleId          := APEX_JSON.get_varchar2(p_path => 'noEmpleId');
    Lv_Departamento       := APEX_JSON.get_varchar2(p_path => 'departamento');
    Lv_TareaId            := APEX_JSON.get_varchar2(p_path => 'tareaId');
    Lv_Observacion        := APEX_JSON.get_varchar2(p_path => 'observacion');
    Lv_EmpresaCod         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_UsrCreacion        := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_IpCreacion         := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_FechaHallazgo      := APEX_JSON.get_varchar2(p_path => 'feHallazgo');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_TipoDocumentoId IS NULL THEN
       Pv_Mensaje := 'El parámetro tipo de documento es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_TipoSancionId IS NULL THEN
       Pv_Mensaje := 'El parámetro nivel de sanción es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_HallazgoId IS NULL THEN
       Pv_Mensaje := 'El parámetro hallazgo es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_NoEmpleId IS NULL THEN
       Pv_Mensaje := 'El parámetro empleado es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_FechaHallazgo IS NULL THEN
       Pv_Mensaje := 'El parámetro fecha de hallazgo es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_UsrCreacion IS NULL THEN
       Pv_Mensaje := 'El parámetro usuario en sesión es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_IpCreacion IS NULL THEN
       Lv_IpCreacion := '127.0.0.1';
    END IF;

    INSERT
        INTO NAF47_TNET.INFO_DOCUMENTO (
            ID_DOCUMENTO,
            TIPO_DOCUMENTO_ID,
            TIPO_SANCION_ID,
            HALLAZGO_ID,
            NO_EMPLE_ID,
            DEPARTAMENTO,
            TAREA_ID,
            OBSERVACION,
            FE_HALLAZGO,
            ESTADO,
            COD_EMPRESA,
            USR_CREACION,
            IP_CREACION,
            FE_CREACION
        ) VALUES (
        NAF47_TNET.SEQ_INFO_DOCUMENTO.NEXTVAL,
        (
          Lv_TipoDocumentoId
        ),
        (
          Lv_TipoSancionId
        ),
        (
          Lv_HallazgoId
        ),
        Lv_NoEmpleId,
        Lv_Departamento,
        Lv_TareaId,
        Lv_Observacion,
        to_Date(Lv_FechaHallazgo,'dd/mm/yyyy'),
        'Activo',
        Lv_EmpresaCod,
        Lv_UsrCreacion,
        Lv_IpCreacion,
        SYSDATE);
    COMMIT; 

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_INGRESAR_DOCUMENTO;

  PROCEDURE P_ELIMINAR_DOCUMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2)

   AS 
    Lv_IdDocumento         VARCHAR2(50);
    Lv_UsrUltMod           VARCHAR2(50);
    Lv_IpUltMod            VARCHAR2(50);
    Lv_EmpresaCod          VARCHAR2(3);
    Le_Errors              EXCEPTION;

  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IdDocumento        := APEX_JSON.get_varchar2(p_path => 'idDocumento');
    Lv_EmpresaCod         := APEX_JSON.get_varchar2(p_path => 'empresaCod');
    Lv_UsrUltMod          := APEX_JSON.get_varchar2(p_path => 'usrUltMod');
    Lv_IpUltMod           := APEX_JSON.get_varchar2(p_path => 'ipUltMod');

    IF Lv_EmpresaCod IS NULL THEN
       Pv_Mensaje := 'El parámetro código de empresa es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_IdDocumento IS NULL THEN
       Pv_Mensaje := 'El parámetro identificador es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_UsrUltMod IS NULL THEN
       Pv_Mensaje := 'El parámetro usuario en sesión es obligatorio para realizar la acción.';
       RAISE Le_Errors;
    END IF;

    IF Lv_IpUltMod IS NULL THEN
       Lv_IpUltMod := '';
    END IF;

    UPDATE NAF47_TNET.INFO_DOCUMENTO IDOC 
          SET IDOC.ESTADO='Eliminada',IDOC.USR_ULT_MOD=Lv_UsrUltMod,IDOC.FE_ULT_MOD=SYSDATE,IDOC.IP_ULT_MOD=Lv_IpUltMod
    WHERE IDOC.ID_DOCUMENTO=''||Lv_IdDocumento||'' AND IDOC.COD_EMPRESA=''||Lv_EmpresaCod||'';

    COMMIT; 

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';

  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_ELIMINAR_DOCUMENTO;

END NAKG_GESTIONPERSONA_TRANSACC;

/

