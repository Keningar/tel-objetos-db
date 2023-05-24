CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_FACTURACION_OFFLINE AS 

  /**
  * Documentacion para la funci�n 'F_VALIDA_SCHEMA'
  *
  * Funci�n que valida el XML versus el XSD registrado como esquema.
  *
  * @param Pxml_documento    IN XMLType    Documento XML con schema referencia
  *
  * @return VARCHAR2  Retorna 'VALIDO' en caso de pasar las condiciones del XSD, caso contrario retorna el mensaje de error encontrado.
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 16-01-2018
  */
  FUNCTION F_VALIDA_SCHEMA(Pxml_documento XMLType) RETURN VARCHAR2;

  /**
  * Documentacion para el procedimiento 'P_ASIGNA_SCHEMA'
  *
  * M�todo que modifica el XML y se asigna el XSD a validar.
  *
  * @param Pxml_DocumentoIn     IN XMLType    Variable de entrada con el documento XML
  * @param Pv_EtiquetaRaiz      IN VARCHAR2   Etiqueta raiz del XML donde se asignara la referencia del XSD
  * @param Pv_SchemaReferencia  IN VARCHAR2   Nombre que hace referencia al XSD
  * @param Pxml_DocumentoOut    OUT XMLType   Documento de salida, XML modificado con el XSD referenciado
  * @param Pv_Error             OUT VARCHAR2  Variable que devuelve detalles de los errores
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 16-01-2018
  */
  PROCEDURE P_ASIGNA_SCHEMA(
      Pxml_DocumentoIn IN XMLType,
      Pv_EtiquetaRaiz IN VARCHAR2,
      Pv_SchemaReferencia IN VARCHAR2,
      Pxml_DocumentoOut OUT XMLType,
      Pv_Error OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento 'P_VALIDA_COMPROBANTE'
  *
  * M�todo que modifica el XML y se asigna el XSD a validar.
  *
  * @param Pn_Document_Fin     IN NUMBER     ID del documento financiero
  * @param Pn_TipoDoc          IN NUMBER     Tipo de documento a validar
  * @param Pxml_Documento      IN XMLType    Documento en formato XML
  * @param Pv_Error            OUT VARCHAR2  Variable que devuelve detalles de los errores
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 23-01-2018
  */
  PROCEDURE P_VALIDA_COMPROBANTE(Pn_Document_Fin IN NUMBER,
                                 Pn_TipoDoc IN NUMBER,
                                 Pxml_Documento IN XMLType,
                                 Pv_Error OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DOCUMENTO'.
  * Procedure que me permite actualizar info_documento en DB_COMPROBANTES
  *
  * PARAMETROS:
  * @Param Prf_InfoDocumento    IN FNCK_COM_ELECTRONICO.Lr_InfoDocumento
  * @Param Pv_MsnError          OUT  VARCHAR2
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 25-01-2018
  */         
  PROCEDURE P_UPDATE_INFO_DOCUMENTO(Prf_InfoDocumento IN  DB_COMPROBANTES.INFO_DOCUMENTO%ROWTYPE,
                                    Pv_MsnError       OUT VARCHAR2 );

END FNCK_FACTURACION_OFFLINE;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_FACTURACION_OFFLINE
AS

  FUNCTION F_VALIDA_SCHEMA(
      Pxml_documento XMLType)
    RETURN VARCHAR2
  IS

    Lv_Result VARCHAR2(4000):='';
    Lxml_Doc XMLType;
    Le_DocVacio EXCEPTION;

  BEGIN

    Lxml_Doc:=Pxml_documento;
    IF Lxml_Doc IS NOT NULL THEN
      XMLTYPE.schemaValidate(Lxml_Doc);
      Lv_Result:='VALIDO';
    ELSE
      RAISE Le_DocVacio;
    END IF;
    RETURN Lv_Result;

  EXCEPTION
  WHEN Le_DocVacio THEN
    Lv_Result:='No se encontro documento para validar';
    RETURN Lv_Result;
  WHEN OTHERS THEN
    Lv_Result:=substr(SQLERRM,0,3000);
    RETURN Lv_Result;

  END F_VALIDA_SCHEMA;

  PROCEDURE P_ASIGNA_SCHEMA(
      Pxml_DocumentoIn IN XMLType,
      Pv_EtiquetaRaiz IN VARCHAR2,
      Pv_SchemaReferencia IN VARCHAR2,
      Pxml_DocumentoOut OUT XMLType,
      Pv_Error OUT VARCHAR2)
  IS

    Pxml_DocumentoAux XMLType;
    Lv_Documento_Var VARCHAR2(32767);
    Lv_Documento_Clob CLOB;
    Lv_XmlReferencia VARCHAR2(1000):='xsi:noNamespaceSchemaLocation="$SchemaReferencia" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';
    Ln_LengthXML NUMBER:=0;
    Ln_LengthVar NUMBER:=30000;
    Le_DocVacio EXCEPTION;

  BEGIN

    Pxml_DocumentoAux:=Pxml_DocumentoIn;

    Ln_LengthXML:=dbms_lob.getlength(Pxml_DocumentoAux.getclobval());

    Lv_XmlReferencia:=REPLACE(Lv_XmlReferencia,'$SchemaReferencia',Pv_SchemaReferencia);

    IF Ln_LengthXML < Ln_LengthVar THEN
      Lv_Documento_Var:=Pxml_DocumentoIn.getStringVal();
      Lv_Documento_Var:=REPLACE(Lv_Documento_Var,'<'||Pv_EtiquetaRaiz,'<'||Pv_EtiquetaRaiz||' '||Lv_XmlReferencia);
      Pxml_DocumentoOut:=xmltype(Lv_Documento_Var);
    ELSE
      Lv_Documento_Clob:=Pxml_DocumentoIn.getCLOBVal();
      Lv_Documento_Clob:=REPLACE(Lv_Documento_Clob,'<'||Pv_EtiquetaRaiz,'<'||Pv_EtiquetaRaiz||' '||Lv_XmlReferencia);
      Pxml_DocumentoOut:=xmltype(Lv_Documento_Clob);
    END IF;
    IF Pxml_DocumentoOut IS NULL THEN
      RAISE Le_DocVacio;
    END IF;

  EXCEPTION
  WHEN Le_DocVacio THEN
    Pv_Error:='No se encontro documento para validar Le_DocVacio';
  WHEN OTHERS THEN
    Pv_Error:=substr('OTHERS '||SQLERRM,0,3000);

  END P_ASIGNA_SCHEMA;

  PROCEDURE P_VALIDA_COMPROBANTE(Pn_Document_Fin IN NUMBER,
                                 Pn_TipoDoc IN NUMBER,
                                 Pxml_Documento IN XMLType,
                                 Pv_Error OUT VARCHAR2)
  IS

  CURSOR C_TagDocumento IS
  SELECT ATD.DESCRIPCION
  FROM DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO ATD
  WHERE ATD.ID_TIPO_DOC=Pn_TipoDoc;

  CURSOR C_Comprobante IS
  SELECT IDOC.ID_DOCUMENTO
  FROM DB_COMPROBANTES.INFO_DOCUMENTO IDOC
  WHERE IDOC.DOCUMENTO_ID_FINAN=Pn_Document_Fin
  AND IDOC.ESTADO_DOC_ID = 12;

  Lc_TagDocumento C_TagDocumento%ROWTYPE;
  Lc_Comprobante C_Comprobante%ROWTYPE;
  Lv_Schema VARCHAR2(1000):='';
  Lv_Error  VARCHAR2(32767);
  Lxml_Doc  XMLType;
  Lv_Valid  VARCHAR2(32767):='';
  Le_AsignaXSD EXCEPTION;

  Lr_InfoDocumento DB_COMPROBANTES.INFO_DOCUMENTO%ROWTYPE;
  Lr_InfoMensaje DB_COMPROBANTES.INFO_MENSAJE%ROWTYPE;

  BEGIN

    OPEN C_TagDocumento;
    FETCH C_TagDocumento INTO Lc_TagDocumento;
    CLOSE C_TagDocumento;

    Lv_Schema:=Lc_TagDocumento.DESCRIPCION||'.xsd';

    P_ASIGNA_SCHEMA(Pxml_Documento,
                    Lc_TagDocumento.DESCRIPCION,
                    Lv_Schema,
                    Lxml_Doc,
                    Lv_Error);

    IF Lv_Error IS NOT NULL THEN
      Pv_Error:=substr(Lv_Error,0,3000);
      RAISE Le_AsignaXSD;
    END IF;

   Lv_Valid:=F_VALIDA_SCHEMA(Lxml_Doc);

   IF Lv_Valid = 'VALIDO' THEN
     Lr_InfoDocumento.DOCUMENTO_ID_FINAN:=Pn_Document_Fin;
     Lr_InfoDocumento.ESTADO_DOC_ID:=10;
     P_UPDATE_INFO_DOCUMENTO(Lr_InfoDocumento,Lv_Error);
     IF Lv_Error IS NOT NULL THEN
      Pv_Error:=substr(Lv_Error,0,3000);
    END IF;
   ELSE

     OPEN C_Comprobante;
     FETCH C_Comprobante INTO Lc_Comprobante;
     CLOSE C_Comprobante;

     Lr_InfoDocumento.DOCUMENTO_ID_FINAN:=Pn_Document_Fin;
     Lr_InfoDocumento.ESTADO_DOC_ID:=0;
     P_UPDATE_INFO_DOCUMENTO(Lr_InfoDocumento,Lv_Error);
     IF Lv_Error IS NOT NULL THEN
      Pv_Error:=substr(Lv_Error,0,3000);
    END IF;

     Lr_InfoMensaje.IDENTIFICADOR:=0;
     Lr_InfoMensaje.MENSAJE:='EL DOCUMENTO NO CUMPLE CON EL FORMATO';
     Lr_InfoMensaje.INFOADICIONAL:=UPPER(REGEXP_REPLACE(Lv_Valid,'ORA-([0-9]*):\s|LSX-([0-9]*):\s'));
     Lr_InfoMensaje.TIPO:='ERROR';
     Lr_InfoMensaje.FE_CREACION:=SYSDATE;
     Lr_InfoMensaje.USR_CREACION:=USER;
     Lr_InfoMensaje.IP_CREACION:='127.0.0.1';
     Lr_InfoMensaje.DOCUMENTO_ID:=Lc_Comprobante.ID_DOCUMENTO;
     DB_COMPROBANTES.DCKG_TRANSACTION.P_INSERT_INFO_MENSAJE(Lr_InfoMensaje,Lv_Error);
     IF Lv_Error IS NOT NULL THEN
       Pv_Error:=substr(Pv_Error||Lv_Error,0,3000);
     END IF;

     IF Pv_Error IS NOT NULL THEN
       Pv_Error:=substr(Pv_Error||Lv_Error||Lv_Valid,0,3000);
     ELSE
       Pv_Error:=substr(Lv_Valid,0,3000);
     END IF;

   END IF;

  EXCEPTION
    WHEN Le_AsignaXSD THEN
      Pv_Error:=substr('Error en el procedimiento P_VALIDA_COMPROBANTE Le_AsignaXSD '|| Lv_Error,0,3000);
    WHEN OTHERS THEN
      Pv_Error:=substr('Error en el procedimiento P_VALIDA_COMPROBANTE OTHERS '|| SQLERRM,0,3000);

  END P_VALIDA_COMPROBANTE;

  PROCEDURE P_UPDATE_INFO_DOCUMENTO(
      Prf_InfoDocumento IN DB_COMPROBANTES.INFO_DOCUMENTO%ROWTYPE,
      Pv_MsnError OUT VARCHAR2 )
  IS
    Le_UpdateFinan EXCEPTION;
  BEGIN
  
    IF Prf_InfoDocumento.DOCUMENTO_ID_FINAN IS NOT NULL THEN
      UPDATE DB_COMPROBANTES.INFO_DOCUMENTO
      SET ESTADO_DOC_ID          = NVL(Prf_InfoDocumento.ESTADO_DOC_ID,ESTADO_DOC_ID)
      WHERE DOCUMENTO_ID_FINAN = Prf_InfoDocumento.DOCUMENTO_ID_FINAN;
    ELSE
      RAISE Le_UpdateFinan;
    END IF;
  EXCEPTION
  WHEN Le_UpdateFinan THEN
    Pv_MsnError:=' Error en FNCK_FACTURACION_OFFLINE.P_UPDATE_INFO_DOCUMENTO Le_UpdateFinan ' || 'Variable DOCUMENTO_ID_FINAN NULL, no se puede realizar actualizaci�n';
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION OFFLINE', ' Error en FNCK_FACTURACION_OFFLINE.P_UPDATE_INFO_DOCUMENTO Le_UpdateFinan', '' || 'Variable DOCUMENTO_ID_FINAN NULL, no se puede realizar actualizaci�n');
  WHEN OTHERS THEN
    Pv_MsnError:=substr(' Error en FNCK_FACTURACION_OFFLINE.P_UPDATE_INFO_DOCUMENTO OTHERS ' || SQLERRM,0,3000);
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION OFFLINE', ' Error en FNCK_FACTURACION_OFFLINE.P_UPDATE_INFO_DOCUMENTO OTHERS',substr(SQLERRM,0,3000));

  END P_UPDATE_INFO_DOCUMENTO;

END FNCK_FACTURACION_OFFLINE;
/