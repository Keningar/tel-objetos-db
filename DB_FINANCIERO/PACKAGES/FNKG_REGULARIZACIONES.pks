CREATE EDITIONABLE PACKAGE               FNKG_REGULARIZACIONES
AS 
  --
  /**
  * Documentaci�n para el procedure 'P_REGULARIZAR_ESTADOS_FACTURAS'.
  *
  * Procedimiento que verifica si existen facturas con estado Activo, saldo 0 y contiene un historial de estado Cerrado o Activo. A esas facturas
  * se las regulariza, actualizando el estado a cerrado e ingresando un historial .
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 15-02-2019
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 18-06-2020 Se elimina condici�n de consulta por fecha de emisi�n de la factura.
  * PARAMETROS:
  * @param Pn_CodEmpresa   IN   VARCHAR2  (Codigo de Empresa)
  */
  PROCEDURE P_REGULARIZAR_ESTADOS_FACTURAS(Pv_EmpresaCod        IN VARCHAR2,
                                           Pv_EstadoHistorial   IN VARCHAR2);


  /**
  * Documentaci�n para el procedure 'P_REGULARIZAR_NOTA_CREDITO'.
  *
  * Procedimiento que se utiliza para regularizar una nota de cr�dito que no fu� aplicada.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 21-02-2019
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 27-02-2019 - Se realiza la b�squeda en el query principal por notas de creditos emitidas en la fecha actual.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 23-06-2020 - Se elimina consulta por fecha de emisi�n, se agrega validaci�n por historiales de cierre y aplicaci�n de nota de cr�dito.
  *
  * PARAMETROS:
  * @param Pn_CodEmpresa   IN   VARCHAR2  (C�digo de Empresa)
  */
  PROCEDURE P_REGULARIZAR_NOTA_CREDITO(Pv_EmpresaCod   IN VARCHAR2);


  /*
  * Documentaci�n para TYPE 'T_DocumentoRegularizaNc'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 24-06-2020
  */
  TYPE T_DocumentoRegularizaNc IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_DocumentoRegularizaNc INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para el procedimiento P_GET_DOCUMENTOS_REGULA_NC
  *
  * Procedimiento que retorna cursor de documentos a regularizar.
  *
  * Costo del query 96216
  *
  * @param Pv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa.
  * @param Prf_GetDocumentos      OUT SYS_REFCURSOR  Retorna cursor de puntos no facturados.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>  JOB_REGULARIZA_NC_DIARIO
  * @version 1.00 15-08-2019
  */
  PROCEDURE P_GET_DOCUMENTOS_REGULA_NC(
    Pv_EmpresaCod         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_GetDocumentos     OUT SYS_REFCURSOR);

  /**
  * Documentaci�n para el procedure 'P_REGULARIZA_NOTA_CREDITO'.
  *
  * Procedimiento que se utiliza para regularizar una nota de cr�dito que no fu� aplicada.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 24-06-2020 - 
  *
  * PARAMETROS:
  * @param Pn_CodEmpresa   IN   VARCHAR2  (C�digo de Empresa)
  */
  PROCEDURE P_REGULARIZA_NOTA_CREDITO(Pv_EmpresaCod   IN VARCHAR2); --

  /**
  * Documentaci�n para el procedure 'P_REGULA_NUM_FACT_MIGRACION'.
  *
  * Procedimiento que se utiliza para regularizar el campo NUM_FACT_MIGRACION de las Facturas, debido a que los documentos financieros
  * FAC y FACP se estan actualizando a 1, debiendo tener el campo en NULL ya que dicho campo solo es usado para la migracion de facturas 
  * del sistema SIT al Telcos.
  * Se considera regularizar Facturas FAC y FACP de la empresa 18: Megadatos, con NUM_FACT_MIGRACION is not null, estado; Activo y electronica: S
  * Se actualiza campo NUM_FACT_MIGRACION en NULL en INFO_DOCUMENTO_FINANCIERO_CAB
  * Registra en INFO_DOCUMENTO_HISTORIAL la actualizaci�n realizada:
  *     - USR_CREACION: telcos_regula
  *     - OBSERVACION: Actualizacion del campo num_fac_migracion por regularizacion del Sistema. 
  * El proceso de regularizacion va a permitir que las Facturas regularizadas puedan ser consideradas en el proceso de Cruce de anticipos.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-08-2022
  *
  * PARAMETROS:
  * @param Pn_CodEmpresa   IN   VARCHAR2  (C�digo de Empresa)
  */
  PROCEDURE P_REGULA_NUM_FACT_MIGRACION(Pv_EmpresaCod   IN VARCHAR2);
  
 /*
  * Documentaci�n para TYPE 'T_DocumentoRegulariza'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-08-2022
  */
  TYPE T_DocumentoRegulariza IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_FacturasPto INDEX BY PLS_INTEGER;

END FNKG_REGULARIZACIONES;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_REGULARIZACIONES
AS
  --
  PROCEDURE P_REGULARIZAR_ESTADOS_FACTURAS(Pv_EmpresaCod        IN VARCHAR2,
                                           Pv_EstadoHistorial   IN VARCHAR2)
  AS
    --
    Ln_Saldo            NUMBER;
    Lv_ReturnSaldo      NUMBER;
    Lv_EmpresaCod       VARCHAR2(5) := Pv_EmpresaCod;
    Lv_EstadoHistorial  VARCHAR2(10) := Pv_EstadoHistorial;
    Lv_MsnCabecera      CLOB := '<p>Estimados,</br> Se presenta la lista de los documentos regularizados.</br></p><table style="width:100%">
                                 <tr><th align="left">Identificaci'||chr(38)||'oacute;n</th><th align="left">Cliente</th><th align="left">Login</th>
                                 <th align="left"># Factura</th><th align="left">Estado Anterior</th><th align="left">Estado Actual</th>
                                 <th align="left">Saldo</th></tr>';
    Lv_Registro         CLOB := '';
    Lv_MsnCuerpo        CLOB := '';
    Lv_Mensaje          CLOB := '';
    Lv_MailDestino      VARCHAR2(200) := '';
    Ln_Contador         NUMBER := 0;
    --
    
    CURSOR C_GetIdDocumentoFinanciero
    IS
      SELECT  
        IDFC.ID_DOCUMENTO,
        IDFC.ESTADO_IMPRESION_FACT,
        IDFC.NUMERO_FACTURA_SRI,
        IP.LOGIN,
        IPE.IDENTIFICACION_CLIENTE,        
        CASE
        WHEN IPE.TIPO_IDENTIFICACION='RUC' THEN
        IPE.RAZON_SOCIAL ELSE CONCAT(IPE.NOMBRES,IPE.APELLIDOS) END AS NOMBRES
      FROM 
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC 
      JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO = IDFC.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
      WHERE IDFC.OFICINA_ID IN (SELECT ID_OFICINA FROM DB_COMERCIAL.INFO_OFICINA_GRUPO WHERE EMPRESA_ID = Lv_EmpresaCod)  
      AND   IDFC.TIPO_DOCUMENTO_ID IN (1,5) 
      AND   IDFC.ESTADO_IMPRESION_FACT IN ( 'Activo')  
      AND   IDFC.ID_DOCUMENTO IN (SELECT DOCUMENTO_ID FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL WHERE ESTADO = Lv_EstadoHistorial);
  
  BEGIN
    --
    IF C_GetIdDocumentoFinanciero%ISOPEN THEN
      CLOSE C_GetIdDocumentoFinanciero;
    END IF;
    --
    FOR I_GetIdDocumentoFinanciero IN C_GetIdDocumentoFinanciero()
  
    LOOP
      Lv_ReturnSaldo := DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(I_GetIdDocumentoFinanciero.ID_DOCUMENTO, '', '');
     
      IF Lv_ReturnSaldo = 0 THEN   
      
        Lv_Registro:='<tr><td>'||I_GetIdDocumentoFinanciero.IDENTIFICACION_CLIENTE ||'</td><td>'|| I_GetIdDocumentoFinanciero.NOMBRES ||'</td><td>'
                     ||I_GetIdDocumentoFinanciero.LOGIN ||'</td><td>'|| I_GetIdDocumentoFinanciero.NUMERO_FACTURA_SRI ||'</td><td>'
                     || I_GetIdDocumentoFinanciero.ESTADO_IMPRESION_FACT || '</td><td>Cerrado</td>' ||'<td>'|| Lv_ReturnSaldo ||'<td></tr>';
        
        --Actualiza estado a Cerrado de Facturas abiertas con saldo 0
        UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
        SET ESTADO_IMPRESION_FACT = 'Cerrado'
        WHERE ID_DOCUMENTO = I_GetIdDocumentoFinanciero.ID_DOCUMENTO;
     
        --Inserta Historial de Regularizaci�n
        INSERT 
        INTO DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
          (
            ID_DOCUMENTO_HISTORIAL,
            DOCUMENTO_ID,
            FE_CREACION,
            USR_CREACION,
            ESTADO,
            OBSERVACION,
            MOTIVO_ID
         )
         VALUES 
         (
           DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
           I_GetIdDocumentoFinanciero.ID_DOCUMENTO,
           SYSDATE,
           'telcos_regula', 
           'Cerrado',
           'Se actualiza el estado de la factura de "Activo" a "Cerrado" por saldo cero',
           null
         );
         
        Lv_MsnCuerpo:= Lv_Registro || Lv_MsnCuerpo ;
        Ln_Contador:= Ln_Contador + 1;
      --   
      END IF;
    
    END LOOP;
    --
    COMMIT;
    --
    IF Pv_EmpresaCod = '18' THEN
      Lv_MailDestino:='ssalazar@telconet.ec;dbravo@telconet.ec;ncolta@telconet.ec;soporte-sistemas@telconet.ec';
    ELSIF Pv_EmpresaCod = '10' THEN
      Lv_MailDestino:='ealvario@telconet.ec;soporte-sistemas@telconet.ec';
    END IF;
    --
    Lv_Mensaje:= Lv_MsnCabecera || Lv_MsnCuerpo || '</table>';

    IF Ln_Contador > 0 THEN
      UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', 
                     recipients => Lv_MailDestino, 
                     subject => 'Proceso Autom�tico de Regularizaci�n de Estados de Facturas', 
                     MESSAGE => Lv_Mensaje, 
                     mime_type => 'text/html; charset=UTF-8' 
                    );
    END IF;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'PROCESO_AUTOM�TICO_REGULARIZACI�N_ESTADO_FACTURA',
                                         'No se pudo actualizar el estado de la factura de "Activo" a "Cerrado" - ' || SQLCODE || ' -ERROR- '
                                         || SQLERRM || ' - ERROR_STACK: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' - ERROR_BACKTRACE: '
                                         ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
     
  
  END P_REGULARIZAR_ESTADOS_FACTURAS;

  
  PROCEDURE P_REGULARIZAR_NOTA_CREDITO(Pv_EmpresaCod   IN VARCHAR2)
  AS
    --
    Lv_EstadoActivo      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE := 'Activo';
    Lv_EstadoCerrado     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE := 'Cerrado';
    Ln_IdDocumentoNC     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_IdHistNcAplicada  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_Saldo             NUMBER;
    Ln_ReturnSaldo       NUMBER;
    Lv_MessageError      VARCHAR2(3000);
    --
    
    CURSOR C_GetDocumentosConPago(Cv_EstadoActivo  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                  Cv_EstadoCerrado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE)
    IS
      SELECT IDFC.ID_DOCUMENTO,      
        IDFC.OFICINA_ID,
        (SELECT COUNT(*) FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC
                WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                AND NC.ESTADO_IMPRESION_FACT = Cv_EstadoActivo) AS CANTIDAD_NC
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFCNC ON IDFCNC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        WHERE 
        IDFC.TIPO_DOCUMENTO_ID in (1,5) 
        AND IDFC.ESTADO_IMPRESION_FACT = Cv_EstadoActivo
        AND IDFC.OFICINA_ID IN (SELECT OFI.ID_OFICINA FROM DB_COMERCIAL.INFO_OFICINA_GRUPO OFI WHERE OFI.EMPRESA_ID = Pv_EmpresaCod)   
        AND (
           EXISTS (SELECT 1 FROM DB_FINANCIERO.INFO_PAGO_CAB PCAB,
                   DB_FINANCIERO.INFO_PAGO_DET PDET
                   WHERE PCAB.ID_PAGO=PDET.PAGO_ID
                   AND PDET.REFERENCIA_ID=IDFC.ID_DOCUMENTO
                  )        
           )
            AND NOT EXISTS (
                            SELECT 1 
                            FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
                            WHERE IDH.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                            AND IDH.ESTADO         = 'Cerrado'
                            AND IDH.USR_CREACION   = 'telcos_regAppNc'
                           )
            GROUP BY IDFC.ID_DOCUMENTO,      
                     IDFC.OFICINA_ID
            HAVING (SELECT COUNT(*) FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC
            WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
            AND   NC.ESTADO_IMPRESION_FACT   = 'Activo') = 1;
           
    CURSOR C_GetIdDocumentoNC(Cn_IdDocumento    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IDFCNC.ID_DOCUMENTO AS ID_DOCUMENTO_NC
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFCNC ON IDFCNC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        WHERE 
        IDFC.ID_DOCUMENTO = Cn_IdDocumento;

    CURSOR C_GetIdHistorialNCApp(Cn_IdDocumentoNc    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IDH.ID_DOCUMENTO_HISTORIAL AS ID_HISTORIAL_NC
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.DOCUMENTO_ID = Cn_IdDocumentoNc
      AND    IDH.ESTADO       = 'Aplicada';           
  
  BEGIN
    --
    FOR I_GetDocumentoFinanciero IN C_GetDocumentosConPago(Lv_EstadoActivo,Lv_EstadoCerrado)
    LOOP

      Ln_ReturnSaldo := ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(I_GetDocumentoFinanciero.ID_DOCUMENTO, '', 'saldo'),2);
      IF Ln_ReturnSaldo < 0 AND I_GetDocumentoFinanciero.CANTIDAD_NC = 1 THEN
    
        OPEN  C_GetIdDocumentoNC (Cn_IdDocumento => I_GetDocumentoFinanciero.ID_DOCUMENTO);
          FETCH C_GetIdDocumentoNC INTO Ln_IdDocumentoNC;  
        CLOSE C_GetIdDocumentoNC;

        OPEN  C_GetIdHistorialNCApp (Cn_IdDocumentoNc => Ln_IdDocumentoNC);
          FETCH C_GetIdHistorialNCApp INTO Ln_IdHistNcAplicada;  
        CLOSE C_GetIdHistorialNCApp;

        IF Ln_IdHistNcAplicada IS NOT NULL THEN
          DELETE FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL WHERE ID_DOCUMENTO_HISTORIAL = Ln_IdHistNcAplicada;
        END IF;
      
        DB_FINANCIERO.FNCK_CONSULTS.P_APLICA_NOTA_CREDITO(Ln_IdDocumentoNC,null,I_GetDocumentoFinanciero.OFICINA_ID,Lv_MessageError);
      
        --Inserta Historial de Regularizaci�n
        INSERT 
        INTO DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
          (
            ID_DOCUMENTO_HISTORIAL,
            DOCUMENTO_ID,
            FE_CREACION,
            USR_CREACION,
            ESTADO,
            OBSERVACION,
            MOTIVO_ID
         )
         VALUES 
         (
           DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
           I_GetDocumentoFinanciero.ID_DOCUMENTO,
           SYSDATE,
           'telcos_regAppNc', 
           'Cerrado',
           'Se aplica Nc al documento mediante regularizacion automatica',
           null
         );
      END IF;
    
    END LOOP;
    --
    COMMIT;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'PROCESO_AUTOM�TICO_REGULARIZACI�N_NOTA_CREDITO',
                                         'No se pudo regularizar nota de credito" - ' || SQLCODE || ' -ERROR- '
                                         || SQLERRM || ' - ERROR_STACK: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' - ERROR_BACKTRACE: '
                                         ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
     
  
  END P_REGULARIZAR_NOTA_CREDITO;

  PROCEDURE P_GET_DOCUMENTOS_REGULA_NC(
    Pv_EmpresaCod         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_GetDocumentos     OUT SYS_REFCURSOR)
  IS
    Lcl_Query             CLOB ;
    Lv_InfoError          VARCHAR2(3000);
  BEGIN

      Lcl_Query :='SELECT IDFC.ID_DOCUMENTO,      
        IDFC.OFICINA_ID,
        (SELECT COUNT(*) FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC
                WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                AND NC.ESTADO_IMPRESION_FACT = ''Activo'') AS CANTIDAD_NC
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFCNC ON IDFCNC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        WHERE 
        IDFC.TIPO_DOCUMENTO_ID in (1,5)    
        AND IDFC.ESTADO_IMPRESION_FACT IN (''Cerrado'')
        AND IDFC.OFICINA_ID IN (SELECT OFI.ID_OFICINA FROM DB_COMERCIAL.INFO_OFICINA_GRUPO OFI WHERE OFI.EMPRESA_ID = '''||Pv_EmpresaCod||''')   
        AND (
           EXISTS (SELECT 1 FROM DB_FINANCIERO.INFO_PAGO_CAB PCAB,
                   DB_FINANCIERO.INFO_PAGO_DET PDET
                   WHERE PCAB.ID_PAGO=PDET.PAGO_ID
                   AND PDET.REFERENCIA_ID=IDFC.ID_DOCUMENTO
                  )        
           )
            AND NOT EXISTS (
                            SELECT 1 
                            FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
                            WHERE IDH.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                            AND IDH.ESTADO         = ''Cerrado''
                            AND IDH.USR_CREACION   = ''telcos_regAppNc''
                           )
            GROUP BY IDFC.ID_DOCUMENTO,      
                     IDFC.OFICINA_ID
            HAVING (SELECT COUNT(*) FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC
            WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
            AND   NC.ESTADO_IMPRESION_FACT   = ''Activo'') = 1';

    OPEN Prf_GetDocumentos FOR Lcl_Query;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_REGULARIZACIONES.P_GET_DOCUMENTOS_REGULA_NC - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_REGULARIZACIONES.P_GET_DOCUMENTOS_REGULA_NC', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_DOCUMENTOS_REGULA_NC;


  PROCEDURE P_REGULARIZA_NOTA_CREDITO(Pv_EmpresaCod   IN VARCHAR2)
  AS
    --
    Lv_EstadoActivo      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE := 'Activo';
    Lv_EstadoCerrado     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE := 'Cerrado';
    Ln_IdDocumentoNC     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_IdHistNcAplicada  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_Saldo             NUMBER;
    Ln_ReturnSaldo       NUMBER;
    Ln_Indsx             NUMBER;
    Lv_MessageError      VARCHAR2(3000);
    Lrf_GetDocumentos    SYS_REFCURSOR;
    Lr_Documento         DB_FINANCIERO.FNKG_TYPES.Lr_DocumentoRegularizaNc;          
    Lr_GetDocumentos     T_DocumentoRegularizaNc;
           
    CURSOR C_GetIdDocumentoNC(Cn_IdDocumento    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IDFCNC.ID_DOCUMENTO AS ID_DOCUMENTO_NC
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFCNC ON IDFCNC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        WHERE 
        IDFC.ID_DOCUMENTO = Cn_IdDocumento;

    CURSOR C_GetIdHistorialNCApp(Cn_IdDocumentoNc    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IDH.ID_DOCUMENTO_HISTORIAL AS ID_HISTORIAL_NC
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.DOCUMENTO_ID = Cn_IdDocumentoNc
      AND    IDH.ESTADO       = 'Aplicada'; 
   
  BEGIN
    --
        IF Lrf_GetDocumentos%ISOPEN THEN
          CLOSE Lrf_GetDocumentos;
        END IF;

        DB_FINANCIERO.FNKG_REGULARIZACIONES.P_GET_DOCUMENTOS_REGULA_NC(Pv_EmpresaCod,
                                                                       Lrf_GetDocumentos);

        LOOP

          FETCH Lrf_GetDocumentos BULK COLLECT INTO Lr_GetDocumentos LIMIT 100;
          Ln_Indsx := Lr_GetDocumentos.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
            Lr_Documento:=Lr_GetDocumentos(Ln_Indsx);
            Ln_ReturnSaldo := ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(Lr_Documento.ID_DOCUMENTO, '', 'saldo'),2);
            IF Ln_ReturnSaldo < 0 AND Lr_Documento.CANTIDAD_NC = 1 THEN

                OPEN  C_GetIdDocumentoNC (Cn_IdDocumento => Lr_Documento.ID_DOCUMENTO);
                  FETCH C_GetIdDocumentoNC INTO Ln_IdDocumentoNC;  
                CLOSE C_GetIdDocumentoNC;

                OPEN  C_GetIdHistorialNCApp (Cn_IdDocumentoNc => Ln_IdDocumentoNC);
                  FETCH C_GetIdHistorialNCApp INTO Ln_IdHistNcAplicada;  
                CLOSE C_GetIdHistorialNCApp;

                IF Ln_IdHistNcAplicada IS NOT NULL THEN
                  DELETE FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL WHERE ID_DOCUMENTO_HISTORIAL = Ln_IdHistNcAplicada;
                END IF;

                DB_FINANCIERO.FNCK_CONSULTS.P_APLICA_NOTA_CREDITO(Ln_IdDocumentoNC,null,Lr_Documento.OFICINA_ID,Lv_MessageError);

                --Inserta Historial de Regularizaci�n
                INSERT 
                INTO DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
                  (
                    ID_DOCUMENTO_HISTORIAL,
                    DOCUMENTO_ID,
                    FE_CREACION,
                    USR_CREACION,
                    ESTADO,
                    OBSERVACION,
                    MOTIVO_ID
                 )
                 VALUES 
                 (
                   DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
                   Lr_Documento.ID_DOCUMENTO,
                   SYSDATE,
                   'telcos_regAppNc', 
                   'Cerrado',
                   'Se aplica Nc al documento mediante regularizacion automatica',
                   null
                 );
            END IF;
                Ln_Indsx := Lr_GetDocumentos.NEXT(Ln_Indsx);
              END LOOP;
              COMMIT;
              EXIT
                WHEN Lrf_GetDocumentos%notfound;
        END LOOP;
        CLOSE Lrf_GetDocumentos;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'P_REGULARIZA_NOTA_CREDITO',
                                         'No se pudo regularizar nota de credito" - ' || SQLCODE || ' -ERROR- '
                                         || SQLERRM || ' - ERROR_STACK: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' - ERROR_BACKTRACE: '
                                         ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
     
  
  END P_REGULARIZA_NOTA_CREDITO;

 PROCEDURE P_REGULA_NUM_FACT_MIGRACION(Pv_EmpresaCod   IN VARCHAR2)
 AS
    --
    Ln_Indsx                 NUMBER;
    Lv_MessageError          VARCHAR2(3000);
    Lrf_GetDocumentos        SYS_REFCURSOR;
    Lr_Documento             DB_FINANCIERO.FNKG_TYPES.Lr_FacturasPto;          
    Lr_GetDocumentos         T_DocumentoRegulariza;
    Lcl_Query                CLOB ;                     
    Lr_InfoDocumentoFinanCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;

  BEGIN
    --
       Lcl_Query:= 'SELECT 
       FAC.ID_DOCUMENTO
       FROM DB_COMERCIAL.INFO_PUNTO PTO 
       JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMROL ON PEMROL.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
       JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL ON PEMROL.EMPRESA_ROL_ID  = EMPROL.ID_EMPRESA_ROL AND EMPROL.EMPRESA_COD= '''||Pv_EmpresaCod||'''
       JOIN DB_COMERCIAL.INFO_PERSONA PERSO ON PERSO.ID_PERSONA=PEMROL.PERSONA_ID
       JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB FAC ON FAC.PUNTO_ID = PTO.ID_PUNTO
       JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC ON TDOC.ID_TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO_ID 
       WHERE TDOC.CODIGO_TIPO_DOCUMENTO IN (''FAC'',''FACP'')
       AND FAC.ESTADO_IMPRESION_FACT    = ''Activo''
       AND FAC.ES_ELECTRONICA           = ''S''
       AND NUM_FACT_MIGRACION           IS NOT NULL ';

        IF Lrf_GetDocumentos%ISOPEN THEN
          CLOSE Lrf_GetDocumentos;
        END IF;

        OPEN Lrf_GetDocumentos FOR Lcl_Query;
        LOOP

          FETCH Lrf_GetDocumentos BULK COLLECT INTO Lr_GetDocumentos LIMIT 100;
          Ln_Indsx := Lr_GetDocumentos.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
              Lr_Documento:=Lr_GetDocumentos(Ln_Indsx);
              --   
              --Busca la cabecera de la factura
              Lr_InfoDocumentoFinanCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Lr_Documento.ID_DOCUMENTO, NULL);

              UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB SET NUM_FACT_MIGRACION = NULL
              WHERE ID_DOCUMENTO = Lr_Documento.ID_DOCUMENTO;

              --Inserta Historial de Regularizaci�n
              INSERT 
              INTO DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
              (
                ID_DOCUMENTO_HISTORIAL,
                DOCUMENTO_ID,
                FE_CREACION,
                USR_CREACION,
                ESTADO,
                OBSERVACION,
                MOTIVO_ID
              )
              VALUES 
              (
                DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
                Lr_Documento.ID_DOCUMENTO,
                SYSDATE,
                'telcos_regula', 
                 Lr_InfoDocumentoFinanCab.ESTADO_IMPRESION_FACT,
                'Actualizacion del campo num_fac_migracion por regularizacion del Sistema',
                 null
              );
            
              Ln_Indsx := Lr_GetDocumentos.NEXT(Ln_Indsx);
            END LOOP;
            COMMIT;
            EXIT WHEN Lrf_GetDocumentos%notfound;
        END LOOP;
        CLOSE Lrf_GetDocumentos;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'P_REGULA_NUM_FACT_MIGRACION',
                                         'No se pudo regularizar el campo NUM_FACT_MIGRACION de las Facturas" - ' || SQLCODE || ' -ERROR- '
                                         || SQLERRM || ' - ERROR_STACK: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' - ERROR_BACKTRACE: '
                                         ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
     
  
  END P_REGULA_NUM_FACT_MIGRACION;

END FNKG_REGULARIZACIONES;
/
