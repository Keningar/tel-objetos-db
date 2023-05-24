CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA AS 

  /**
   * Documentaci�n para proceso 'P_GET_CLASE_DOCUMENTO'
   *
   * Metodo encargado de consultar uno o varios documentos, segun los datos ingresados
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * [
   *  nombreClaseDocumento  Nombre de la Clase de documento,
   *  estado                Estado de la Clase de documento
   * ]
   *
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   25-10-2021
   */                               
  PROCEDURE P_GET_CLASE_DOCUMENTO(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Prf_Response OUT SYS_REFCURSOR);

  /**
   * Documentaci�n para proceso 'P_GET_DOCUMENTOS_RELACIONADOS'
   *
   * Metodo encargado de consultar uno o varios documentos relacionados seg�n la transacci�n: casos,tareas, etc.
   *
   * @param Pr_DocumentoRelacion    IN   INFO_DOCUMENTO_RELACION%ROWTYPE Recibe registro con los datos a consultar
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la consulta
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la consulta
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la consulta
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   15-11-2021
   */                                 
  PROCEDURE P_GET_DOCUMENTOS_RELACIONADOS(Pr_DocumentoRelacion  IN  INFO_DOCUMENTO_RELACION%ROWTYPE,
                                          Pv_Status             OUT VARCHAR2,
                                          Pv_Mensaje            OUT VARCHAR2,
                                          Prf_Response          OUT SYS_REFCURSOR);                                  

END CUKG_COMUNICACIONES_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA AS

  PROCEDURE P_GET_CLASE_DOCUMENTO(Pcl_Request  IN  CLOB,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2,
                                  Prf_Response OUT SYS_REFCURSOR) AS
    
    Lr_ClaseDocumento ADMI_CLASE_DOCUMENTO%ROWTYPE;
    Lcl_SelectFrom    CLOB;
    Lcl_Where         CLOB;
    Lcl_Query         CLOB;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lr_ClaseDocumento.Nombre_Clase_Documento := APEX_JSON.get_varchar2(p_path => 'nombreClaseDocumento');
    Lr_ClaseDocumento.Estado :=  APEX_JSON.get_varchar2(p_path => 'estado');

    DBMS_LOB.CREATETEMPORARY(Lcl_SelectFrom, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Where, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, true);

    DBMS_LOB.APPEND(Lcl_SelectFrom,'SELECT * FROM ADMI_CLASE_DOCUMENTO acd ');

    IF Lr_ClaseDocumento.Estado IS NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'WHERE acd.estado = ''Activo'' ');
    ELSE
      DBMS_LOB.APPEND(Lcl_Where,'WHERE acd.estado = '''||Lr_ClaseDocumento.Estado||''' ');
    END IF;

    IF Lr_ClaseDocumento.Nombre_Clase_Documento IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND acd.nombre_clase_documento = '''||Lr_ClaseDocumento.Nombre_Clase_Documento||''' ');
    END IF;

    DBMS_LOB.APPEND(Lcl_Query,Lcl_SelectFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_Where);

    OPEN Prf_Response FOR Lcl_Query;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Consulta exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_GET_CLASE_DOCUMENTO;

  PROCEDURE P_GET_DOCUMENTOS_RELACIONADOS(Pr_DocumentoRelacion  IN  INFO_DOCUMENTO_RELACION%ROWTYPE,
                                          Pv_Status             OUT VARCHAR2,
                                          Pv_Mensaje            OUT VARCHAR2,
                                          Prf_Response          OUT SYS_REFCURSOR) AS
    Lcl_SelectFrom          CLOB;
    Lcl_Where               CLOB;
    Lcl_Query               CLOB;
    Lb_TieneFiltroRelacion  boolean;
  BEGIN

    DBMS_LOB.CREATETEMPORARY(Lcl_SelectFrom, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Where, true); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, true);

    DBMS_LOB.APPEND(Lcl_SelectFrom,'SELECT Idr.Documento_Id FROM Db_Comunicacion.Info_Documento_Relacion Idr ');

    IF Pr_DocumentoRelacion.Estado IS NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'WHERE Idr.estado = ''Activo'' ');
    ELSE
      DBMS_LOB.APPEND(Lcl_Where,'WHERE Idr.estado = '''||Pr_DocumentoRelacion.Estado||''' ');
    END IF;

    IF Pr_DocumentoRelacion.Caso_Id IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND Idr.Caso_Id = '||Pr_DocumentoRelacion.Caso_Id||' ');
      Lb_TieneFiltroRelacion := true;
    END IF;

    IF Pr_DocumentoRelacion.Detalle_Id IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_Where,'AND Idr.Detalle_Id = '||Pr_DocumentoRelacion.Detalle_Id||' ');
      Lb_TieneFiltroRelacion := true;
    END IF;

    IF Lb_TieneFiltroRelacion THEN    
      DBMS_LOB.APPEND(Lcl_Query,'SELECT Ido.* FROM Db_Comunicacion.Info_Documento Ido WHERE Ido.Id_Documento IN ( ');    
      DBMS_LOB.APPEND(Lcl_Query,Lcl_SelectFrom);
      DBMS_LOB.APPEND(Lcl_Query,Lcl_Where);
      DBMS_LOB.APPEND(Lcl_Query,') '); 
      DBMS_LOB.APPEND(Lcl_Query,'ORDER BY Ido.fe_creacion DESC');
      OPEN Prf_Response FOR Lcl_Query;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Consulta exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;

  END P_GET_DOCUMENTOS_RELACIONADOS;

END CUKG_COMUNICACIONES_CONSULTA;
/
