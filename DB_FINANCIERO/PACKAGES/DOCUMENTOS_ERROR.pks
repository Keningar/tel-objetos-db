CREATE OR REPLACE PACKAGE DB_FINANCIERO.DOCUMENTOS_ERROR AS 

TYPE DocumentoErrorType IS RECORD (
      comentario_error    VARCHAR2(500), 
      origen_documento    VARCHAR2(500),
      login               DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE
      );

TYPE DocumentoErrorCur IS REF CURSOR RETURN DocumentoErrorType;

FUNCTION LOGIN_PARA_PAGO(punto IN NUMBER) RETURN VARCHAR2;
PROCEDURE PAGOS_FACTURA_ANULADA(id_punto IN NUMBER, listado OUT DocumentoErrorCur);
--
/**
  * Documentacion para el procedimiento INSERT_PAGO_HISTORIAL_DEPENCIA
  * Permite obtener los pagos dependientes del cliente por motivo 'ANULACION DEPENCIA' 
  * escritos en el historial del pago.
  *
  * Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * Pn_EmpresaId         IN VARCHAR2,
  * Pr_ListadoPagosDep   OUT DocumentoErrorCur
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 07-08-2017
*/
PROCEDURE P_PAGOS_DEPENDIENTES(
  Pn_IdPunto           IN NUMBER,
  Pn_EmpresaId         IN VARCHAR2,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
);

/**
  * Documentacion para el procedimiento P_PAGOS_ERROR_ESTADO_CTA
  * Permite obtener el total de pagos anulados del cliente.
  *
  * Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  * Pn_EmpresaId         IN VARCHAR2,
  * Pr_ListadoPagosDep   OUT DocumentoErrorCur
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 23-10-2018
*/
  PROCEDURE P_PAGOS_ERROR_ESTADO_CTA(
  Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  Pn_EmpresaId         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
);
--
END DOCUMENTOS_ERROR;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.DOCUMENTOS_ERROR AS 

  FUNCTION LOGIN_PARA_PAGO(punto IN NUMBER) RETURN VARCHAR2
  IS
   clogin VARCHAR2(1000);

   cursor cu1ogin is
   SELECT login
     FROM DB_COMERCIAL.INFO_PUNTO ip
     WHERE ip.id_punto=punto;
  BEGIN
      open cu1ogin;
      fetch cu1ogin into clogin;
      close cu1ogin;

    RETURN clogin;
  END;

  PROCEDURE PAGOS_FACTURA_ANULADA(id_punto IN NUMBER, listado OUT DocumentoErrorCur) 
  AS 
    BEGIN
    OPEN listado FOR 
      SELECT 
        'Pago [#'||ipc.NUMERO_PAGO||'] - [$'||ipd.VALOR_PAGO||'] asociado a Factura [#'||idfc.NUMERO_FACTURA_SRI||'] - [$'|| idfc.VALOR_TOTAL||'] en estado '|| idfc.ESTADO_IMPRESION_FACT as comentario_error,
        CASE 
        WHEN idfc.NUM_FACT_MIGRACION IS NOT NULL THEN 'Migrado'
        ELSE 'Telcos'
        END AS origen_documento,
        LOGIN_PARA_PAGO(ipc.PUNTO_ID) as login
      FROM 
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc,
        DB_FINANCIERO.INFO_PAGO_DET ipd,
        DB_FINANCIERO.INFO_PAGO_CAB ipc
      WHERE idfc.ESTADO_IMPRESION_FACT NOT IN ('Activo','Cerrado','Courier')
        AND ipd.REFERENCIA_ID=idfc.id_documento
        AND ipc.ID_PAGO=ipd.PAGO_ID
        AND ipc.ESTADO_PAGO NOT IN ('Anulado')
        AND idfc.PUNTO_ID=id_punto;
  END PAGOS_FACTURA_ANULADA;
  --
  PROCEDURE P_PAGOS_DEPENDIENTES(
  Pn_IdPunto           IN NUMBER,
  Pn_EmpresaId         IN VARCHAR2,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
  )
  IS
  --
  Lv_NombreMotivo               DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo               DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE            := 'Activo';
  Lv_EstadoPago                 DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';

  BEGIN
  --
    OPEN Pr_ListadoPagosDep FOR 
          SELECT TRIM('Numero Pago: '|| IPC.NUMERO_PAGO|| ' | '|| IPH.OBSERVACION) AS COMENTARIO_ERROR ,
                 'Telcos' AS ORIGEN_DOCUMENTO,
                 DOCUMENTOS_ERROR.LOGIN_PARA_PAGO(IPC.PUNTO_ID) AS LOGIN
          FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
               DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH
          WHERE IPC.ID_PAGO           =  IPH.PAGO_ID
          AND   IPC.PUNTO_ID          =  Pn_IdPunto
          AND   IPC.ESTADO_PAGO       <> Lv_EstadoPago  
          AND   IPC.EMPRESA_ID        =  Pn_EmpresaId  
          AND   IPH.MOTIVO_ID         =  (SELECT AM.ID_MOTIVO
                                         FROM  DB_GENERAL.ADMI_MOTIVO AM
                                         WHERE AM.NOMBRE_MOTIVO = Lv_NombreMotivo
                                         AND   AM.ESTADO        = Lv_EstadoMotivo);
      --
  END P_PAGOS_DEPENDIENTES;

  PROCEDURE P_PAGOS_ERROR_ESTADO_CTA(
  Pn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
  Pn_EmpresaId         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pr_ListadoPagosDep   OUT DocumentoErrorCur
  )
  IS
  --
  Lv_NombreMotivo               DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo               DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE            := 'Activo';
  Lv_EstadoPago                 DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';

  BEGIN
  --
    OPEN Pr_ListadoPagosDep FOR
      SELECT 
        'Pago [#'||ipc.NUMERO_PAGO||'] - [$'||ipd.VALOR_PAGO||'] asociado a Factura [#'||idfc.NUMERO_FACTURA_SRI||'] - [$'|| idfc.VALOR_TOTAL||'] en estado '|| idfc.ESTADO_IMPRESION_FACT AS COMENTARIO_ERROR,
        CASE 
        WHEN IDFC.NUM_FACT_MIGRACION IS NOT NULL THEN 'Migrado'
        ELSE 'Telcos'
        END AS ORIGEN_DOCUMENTO,
        IPT.LOGIN AS LOGIN
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IDFC.ID_DOCUMENTO = IPD.REFERENCIA_ID 
      LEFT JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC ON IPC.ID_PAGO       = IPD.PAGO_ID
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO     IPT ON IPT.ID_PUNTO      = IPC.PUNTO_ID
      WHERE IDFC.ESTADO_IMPRESION_FACT NOT IN ('Activo','Cerrado','Courier')
        AND IPC.ESTADO_PAGO <> Lv_EstadoPago
        AND IDFC.PUNTO_ID   =  Pn_IdPunto
      UNION ALL 
        SELECT TRIM('Numero Pago: '|| IPC.NUMERO_PAGO|| ' | '|| IPH.OBSERVACION) AS COMENTARIO_ERROR ,
               'Telcos' AS ORIGEN_DOCUMENTO,
              IPT.LOGIN AS LOGIN
        FROM  DB_FINANCIERO.INFO_PAGO_CAB       IPC
        LEFT JOIN  DB_COMERCIAL.INFO_PUNTO           IPT ON IPT.ID_PUNTO = IPC.PUNTO_ID
        LEFT JOIN  DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH ON IPC.ID_PAGO  =  IPH.PAGO_ID
        WHERE IPC.PUNTO_ID          =  Pn_IdPunto
        AND   IPC.ESTADO_PAGO       <> Lv_EstadoPago  
        AND   IPC.EMPRESA_ID        =  Pn_EmpresaId  
        AND   IPH.MOTIVO_ID         =  (
                                         SELECT AM.ID_MOTIVO
                                         FROM  DB_GENERAL.ADMI_MOTIVO AM
                                         WHERE AM.NOMBRE_MOTIVO = Lv_NombreMotivo
                                         AND   AM.ESTADO        = Lv_EstadoMotivo
                                       );
      --
  END P_PAGOS_ERROR_ESTADO_CTA;
  --
END DOCUMENTOS_ERROR;
/
