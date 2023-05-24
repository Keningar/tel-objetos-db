CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CONTABILIZAR_ANULARPAG
AS
  --
  /*
  * Documentaci�n para PROCESO 'PROCESA_ANULACION'.
  *
  * PROCEDIMIENTO QUE PROCESA LA ANULACION DEL ASIENTO CONTABLE DE UN PAGO
  *
  * @author Andres Montero amontero@telconet.ec
  * @version 1.0
  * @since 19/06/2016 
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 09-03-2017 - Se quita la validaci�n en el query principal de que el pago tenga en el campo 'CONTABILIZADO' el valor de 'S', es decir
  *                           se debe procesar la anulaci�n del pago sin importar si se ha contabilizado o no. Adicional se implementan los
  *                           procedimientos 'NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CG' y 'NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CK' para 
  *                           eliminar la informaci�n migrada al NAF.
  *
  * @Param in number        Pn_IdPago       (id del pago a anular)
  * @Param out varchar2     Pv_MensajeError (mensaje que retorna al finalizar proceso o cuando se produza un error) 
  */
  PROCEDURE PROCESA_ANULACION(
      Pn_IdPago       IN NUMBER,
      Pv_MensajeError OUT VARCHAR2);
  --
  /**
  * Documentacion para el procedimiento P_ANULA_MIGRACION
  * Procedimiento que anula documentos migrados migrado y procesados en NAF.
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 09-08-2017
  *
  * @param Pn_PagoDetId    IN NUMER        recibe numero de transaccion
  * @param Pv_UsrAnula     IN VARCHAR2     Recibe usuario que realiza anulaci�n
  * @param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje de errores
  */

  PROCEDURE P_ANULA_MIGRACION ( Pn_PagoDetId    IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                                Pv_UsrAnula     IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2 );
  --
END FNKG_CONTABILIZAR_ANULARPAG;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_ANULARPAG
AS
   FUNCTION F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro IN VARCHAR2,
                                    Pv_Parametro       IN VARCHAR2)
   RETURN VARCHAR2 IS
   CURSOR C_OBTENER_PARAMETRO(Cv_NombreParametro VARCHAR2,
                              Cv_Parametro       VARCHAR2) IS
     select apd.valor2
       from db_general.admi_parametro_cab apc,
            db_general.admi_parametro_det apd
      where apc.id_parametro = apd.parametro_id
        and apc.estado = apd.estado
        and apc.estado = 'Activo'
        and apc.nombre_parametro = Cv_NombreParametro
        and apd.valor1 = Cv_Parametro;
 
   Lv_ValorParametro DB_GENERAL.Admi_Parametro_Det.VALOR2%type;
 BEGIN
   IF C_Obtener_Parametro%ISOPEN THEN
     CLOSE C_Obtener_Parametro;
   END IF;
 
   OPEN C_Obtener_Parametro(Pv_NombreParametro, Pv_Parametro);
   FETCH C_Obtener_Parametro
     INTO Lv_ValorParametro;
   CLOSE C_Obtener_Parametro;
 
   RETURN Lv_ValorParametro;
 END;
  --
  PROCEDURE PROCESA_ANULACION(
      Pn_IdPago       IN NUMBER,
      Pv_MensajeError OUT VARCHAR2)
  IS
    --
    --CURSOR QUE RETORNA LA INFORMACION CORRESPONDIENTE AL PAGO A ANULAR
    --Costo del query: 12
    CURSOR c_pagos (Cn_IdPago NUMBER)
    IS
      --
      SELECT
        pdet.id_pago_det,
        fp.descripcion_forma_pago,
        fp.codigo_forma_pago,
        pdet.valor_pago ,
        pdet.fe_creacion,
        pcab.numero_pago,
        pdet.numero_cuenta_banco,
        pto.login,
        pcab.usr_creacion,
        ofi.nombre_oficina,
        pdet.cuenta_contable_id,
        pdet.numero_referencia,
        ofi.id_oficina,
        emp.prefijo,
        tdf.codigo_tipo_documento,
        pdet.pago_id,
        fp.id_forma_pago,
        tdf.id_tipo_documento,
        emp.cod_empresa,
        pdet.fe_deposito,
        pcab.punto_id,
        pcab.estado_pago,
        0
      FROM
        DB_FINANCIERO.INFO_PAGO_DET pdet
      JOIN DB_COMERCIAL.ADMI_FORMA_PAGO fp
      ON
        pdet.forma_pago_id=fp.id_forma_pago
      JOIN DB_FINANCIERO.INFO_PAGO_CAB pcab
      ON
        pdet.pago_id=pcab.id_pago
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO pto
      ON
        pcab.punto_id=pto.id_punto
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO ofi
      ON
        pcab.oficina_id=ofi.id_oficina
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO emp
      ON
        ofi.empresa_id=emp.cod_empresa
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tdf
      ON
        tdf.id_tipo_documento=pcab.tipo_documento_id
      WHERE
        pcab.id_pago = Cn_IdPago;
    --
    tablas varchar2(50):='';

    lr_detalle_pago FNKG_TRANSACTION_CONTABILIZAR.TypeDetallePagos;

    c_admi_plantilla_contab_det SYS_REFCURSOR ;
    c_pagos_det                 SYS_REFCURSOR ;

    r_plantilla_contable_cab FNKG_TRANSACTION_CONTABILIZAR.TypePlantillaContableCab;
    
    l_MsnError varchar2(500);
    l_msn_debito_credito varchar2(500);
    
    l_numero_cuenta_banco varchar2(20) :='0000000000';    
    l_no_cta              varchar2(20) :='';
    l_no_docu             varchar2(50) :='';
    l_no_asiento          varchar2(50) :='';
    l_existen_datos       number       :=0;
    Lex_Exception         EXCEPTION;
    --
  BEGIN
    --
    OPEN c_pagos(Pn_IdPago);
    LOOP
      --
      Pv_MensajeError := '1000';
      --
      FETCH c_pagos INTO lr_detalle_pago;
      EXIT WHEN c_pagos%NOTFOUND;
      --
      --OBTIENE DATOS DE LA CABECERA DE LA PLANTILLA
      r_plantilla_contable_cab := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_PLANTILLA_CONTABLE_CAB(lr_detalle_pago.COD_EMPRESA,
                                                                                                         lr_detalle_pago.ID_FORMA_PAGO,
                                                                                                         lr_detalle_pago.TIPO_DOCUMENTO_ID,
                                                                                                         'INDIVIDUAL');
      --
      Pv_MensajeError:='1025';
      --
      IF r_plantilla_contable_cab.TABLA_CABECERA = 'MIGRA_ARCGAE' 
         AND r_plantilla_contable_cab.NOMBRE_PAQUETE_SQL = 'FNKG_CONTABILIZAR_PAGO_MANUAL' THEN
        --
        Pv_MensajeError:='1050';
        --
        l_no_asiento := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                                                                                           lr_detalle_pago.ID_PAGO_DET, 
                                                                                           lr_detalle_pago);
        --
        Pv_MensajeError:='1075';
        --
        --
        IF l_no_asiento IS NOT NULL THEN
          --
          Pv_MensajeError := NULL;
          --
          --ELIMINA REGISTRO DE LA MIGRA_ARCGAE
          NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CG ( NULL,
                                                        l_no_asiento,
                                                        r_plantilla_contable_cab.COD_DIARIO,
                                                        lr_detalle_pago.COD_EMPRESA,
                                                        Pv_MensajeError );
          --
          --
          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            --
            Pv_MensajeError := 'Hubo un inconveniente al eliminar la informaci�n del NAF del la MIGRA_ARCGAE del pago: ' || Pn_IdPago || ' - ' 
                               || Pv_MensajeError;
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
        ELSE
          --
          Pv_MensajeError := 'No se ha encontrado un n�mero de asiento v�lido para eliminar la informacion correspondiente al pago: ' || Pn_IdPago;
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        
        Pv_MensajeError:='1100';
        --
      ELSIF r_plantilla_contable_cab.TABLA_CABECERA = 'MIGRA_ARCKMM' 
            AND r_plantilla_contable_cab.NOMBRE_PAQUETE_SQL = 'FNKG_CONTABILIZAR_PAGO_MANUAL' THEN
        --
        Pv_MensajeError:='1125';
        --
        l_no_docu := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GENERA_NO_DOCU_ASIENTO(r_plantilla_contable_cab.FORMATO_NO_DOCU_ASIENTO,
                                                                                        lr_detalle_pago.ID_PAGO_DET,
                                                                                        lr_detalle_pago);
        --
        Pv_MensajeError:='1150';
        --
        IF l_no_docu IS NOT NULL THEN
          --
          Pv_MensajeError := NULL;
          --
          --ELIMINA REGISTRO DE LA MIGRA_ARCKMM
          NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CK( l_no_docu,
                                                       lr_detalle_pago.COD_EMPRESA,
                                                       Pv_MensajeError );

          --
          --
          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            --
            Pv_MensajeError := 'Hubo un inconveniente al eliminar la informaci�n del NAF del la MIGRA_ARCKMM del pago: ' || Pn_IdPago || ' - '
                               || Pv_MensajeError;
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
        ELSE
          --
          Pv_MensajeError := 'No se ha encontrado un n�mero de documento v�lido para eliminar la informacion correspondiente al pago: ' || Pn_IdPago;
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Pv_MensajeError:='1175';
        --
      END IF;
      --
      Pv_MensajeError:='1200';
      --
      --INSERTA HISTORIAL PARA PAGO
      INSERT
      INTO
        DB_FINANCIERO.INFO_PAGO_HISTORIAL 
      VALUES
      (
        SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
        lr_detalle_pago.PAGO_ID,
        NULL,
        sysdate,
        'telcos',
        lr_detalle_pago.ESTADO_PAGO,
        '[Proceso contable Anulado OK]'
      );
      --
      --
      l_existen_datos := l_existen_datos + 1;
      --
    END LOOP;
    --
    --
    COMMIT;
    --
    --
    IF l_existen_datos > 0 THEN
      --
      Pv_MensajeError := 'PROCESO OK';
      --
    ELSE
      --
      Pv_MensajeError := 'NOTDATAFOUND';
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_ANULARPAG.PROCESA_ANULACION', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensajeError := 'Error ' || Pv_MensajeError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_ANULARPAG.PROCESA_ANULACION', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END PROCESA_ANULACION;
  --
  --
  PROCEDURE P_ANULA_MIGRACION ( Pn_PagoDetId    IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                                Pv_UsrAnula     IN VARCHAR2,
                                Pv_MensajeError IN OUT VARCHAR2 )
  IS
    --
    CURSOR C_GetInfoDocumento(Cn_PagoDetId  DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    IS
    SELECT IPC.ID_PAGO,
           IPC.EMPRESA_ID, 
           IPC.TIPO_DOCUMENTO_ID,
           IPD.FORMA_PAGO_ID,
           AFP.DESCRIPCION_FORMA_PAGO
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
         DB_FINANCIERO.INFO_PAGO_DET IPD,
         DB_GENERAL.ADMI_FORMA_PAGO AFP
    WHERE IPC.ID_PAGO           = IPD.PAGO_ID
    AND   IPD.FORMA_PAGO_ID     = AFP.ID_FORMA_PAGO
    AND   IPD.ID_PAGO_DET       =  Cn_PagoDetId;
    --
    CURSOR C_GetDocumentoAsociadoNaf(Cv_NoCia            NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.NO_CIA%TYPE,
                                     Cn_TipoDocumentoId  NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.TIPO_DOCUMENTO_ID%TYPE,
                                     Cn_FormaPagoId      NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.FORMA_PAGO_ID%TYPE,
                                     Cv_EstadoMigrado    NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.ESTADO%TYPE,
                                     Cn_IdPagoDet        NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.DOCUMENTO_ORIGEN_ID%TYPE)
    IS
          SELECT  MDA.MIGRACION_ID, MDA.TIPO_MIGRACION, MDA.NO_CIA, MDA.TIPO_DOC_MIGRACION
          FROM  NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
          WHERE MDA.NO_CIA              =  Cv_NoCia
          AND   MDA.TIPO_DOCUMENTO_ID   =  Cn_TipoDocumentoId
          AND   MDA.FORMA_PAGO_ID       =  Cn_FormaPagoId
          AND   MDA.ESTADO              =  Cv_EstadoMigrado
          AND   MDA.DOCUMENTO_ORIGEN_ID =  Cn_IdPagoDet; 
    --
    Lr_PagoMigracionNafOriginal        DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePagoMigracionNaf;
    Lr_PagoMigracionNaf18        DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePagoMigracionNaf;
    Lr_PagoMigracionNaf        DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypePagoMigracionNaf;
    Lv_EstadoMigrado           NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.ESTADO%TYPE := 'M';
    Lr_MigraDocAsociado        NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE     := NULL;
    Lr_GetInfoDocumento        C_GetInfoDocumento%ROWTYPE := NULL;
    Lv_EmpresaId               VARCHAR2(100);
    Lex_Exception              EXCEPTION;
    Lv_Observacion             VARCHAR2(4000);
    --
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
    
    BEGIN
      
      Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
    --
    IF Pn_PagoDetId IS NOT NULL THEN
    --
        IF C_GetInfoDocumento%ISOPEN THEN
            CLOSE C_GetInfoDocumento;
        END IF;
        --
        OPEN C_GetInfoDocumento(Pn_PagoDetId);
        --
        FETCH C_GetInfoDocumento INTO Lr_GetInfoDocumento;
        --
        CLOSE C_GetInfoDocumento;
        --
        IF C_GetDocumentoAsociadoNaf%ISOPEN THEN
            CLOSE C_GetDocumentoAsociadoNaf;
        END IF;
        --
        --
        OPEN C_GetDocumentoAsociadoNaf( Lr_GetInfoDocumento.EMPRESA_ID, 
                                        Lr_GetInfoDocumento.TIPO_DOCUMENTO_ID,
                                        Lr_GetInfoDocumento.FORMA_PAGO_ID,
                                        Lv_EstadoMigrado,
                                        Pn_PagoDetId);
        --
        FETCH C_GetDocumentoAsociadoNaf INTO Lr_PagoMigracionNafOriginal;
        --
        CLOSE C_GetDocumentoAsociadoNaf;
        --
        --para 18 en caso de ser 33
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND lr_getInfodocumento.empresa_id = Lv_EmpresaOrigen then
            OPEN C_GetDocumentoAsociadoNaf( Lv_EmpresaDestino, 
                                            Lr_GetInfoDocumento.TIPO_DOCUMENTO_ID,
                                            Lr_GetInfoDocumento.FORMA_PAGO_ID,
                                            Lv_EstadoMigrado,
                                            Pn_PagoDetId);
            --
            FETCH C_GetDocumentoAsociadoNaf INTO Lr_PagoMigracionNaf18;
            --
            CLOSE C_GetDocumentoAsociadoNaf;
        end if;
        
        if nvl(Lv_BanderaReplicar,'N') = 'S' AND lr_getInfodocumento.empresa_id = Lv_EmpresaOrigen then
            Lr_PagoMigracionNaf := Lr_PagoMigracionNaf18;
        else
            Lr_PagoMigracionNaf := Lr_PagoMigracionNafOriginal;
        end if;
        
        IF Lr_PagoMigracionNaf.ID_MIGRACION IS NOT NULL THEN
          --
          --Si no esta contabilizado F_VALIDA_ELIMINAR_MIGRA devuelve TRUE
          IF NAF47_TNET.GEK_MIGRACION.F_VALIDA_ELIMINAR_MIGRA(Lr_PagoMigracionNaf.ID_MIGRACION,
                                                              Lr_PagoMigracionNaf.TIPO_MIGRACION,
                                                              Lr_PagoMigracionNaf.NO_CIA) THEN 
          
              NAF47_TNET.GEK_MIGRACION.P_ELIMINA_DOCUMENTO_MIGRADO(Lr_PagoMigracionNaf.ID_MIGRACION,
                                                                   Lr_PagoMigracionNaf.TIPO_MIGRACION,
                                                                   Lr_PagoMigracionNaf.NO_CIA,
                                                                   Pv_MensajeError	 );
              IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                --
                  Pv_MensajeError := 'Ocurrio un error al tratar de eliminar el pago en migracion ' ||Lr_PagoMigracionNaf.TIPO_MIGRACION || ' de NAF: '||Pv_MensajeError;
                  --
                  RAISE Lex_Exception;
                --
              END IF;
              
              if nvl(Lv_BanderaReplicar,'N') = 'S' AND lr_getInfodocumento.empresa_id = Lv_EmpresaOrigen then
                NAF47_TNET.GEK_MIGRACION.P_ELIMINA_DOCUMENTO_MIGRADO(Lr_PagoMigracionNafOriginal.ID_MIGRACION,
                                                                   Lr_PagoMigracionNafOriginal.TIPO_MIGRACION,
                                                                   Lr_PagoMigracionNafOriginal.NO_CIA,
                                                                   Pv_MensajeError	 );
                  IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                    --
                      Pv_MensajeError := 'Ocurrio un error al tratar de eliminar el pago en migracion ' ||Lr_PagoMigracionNafOriginal.TIPO_MIGRACION || ' de NAF: '||Pv_MensajeError;
                      --
                      RAISE Lex_Exception;
                    --
                  END IF;
              end if;
              --
              Lv_Observacion := 'Se elimino documeto migrado|' || Lr_GetInfoDocumento.DESCRIPCION_FORMA_PAGO;
              --
              --Actualizo el estado del documento migrado al valor de 'A' Anulado
              Lr_MigraDocAsociado.Usr_Ult_Mod          :=  Pv_UsrAnula;
              Lr_MigraDocAsociado.Documento_Origen_Id  :=  Pn_PagoDetId;
              Lr_MigraDocAsociado.Tipo_Doc_Migracion   :=  Lr_PagoMigracionNaf.TIPO_DOC_MIGRA; 
              Lr_MigraDocAsociado.Migracion_Id         :=  Lr_PagoMigracionNaf.ID_MIGRACION;
              Lr_MigraDocAsociado.Tipo_Migracion       :=  Lr_PagoMigracionNaf.TIPO_MIGRACION;
              Lr_MigraDocAsociado.No_Cia               :=  Lr_PagoMigracionNaf.NO_CIA;
              --
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO (Lr_MigraDocAsociado ,
                                                                     'E', 
                                                                     Pv_MensajeError);
               --
               IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                --
                  Pv_MensajeError := 'Ocurrio un error al tratar de actualizar el estado del documento migrador ' || Pn_PagoDetId || ' de NAF: '||Pv_MensajeError;
                  --
                  RAISE Lex_Exception;
                --
              END IF;
              
              if nvl(Lv_BanderaReplicar,'N') = 'S' AND lr_getInfodocumento.empresa_id = Lv_EmpresaOrigen then
                  Lr_MigraDocAsociado.Tipo_Doc_Migracion   :=  Lr_PagoMigracionNafOriginal.TIPO_DOC_MIGRA; 
                  Lr_MigraDocAsociado.Migracion_Id         :=  Lr_PagoMigracionNafOriginal.ID_MIGRACION;
                  Lr_MigraDocAsociado.Tipo_Migracion       :=  Lr_PagoMigracionNafOriginal .TIPO_MIGRACION;
                  Lr_MigraDocAsociado.No_Cia               :=  Lr_PagoMigracionNafOriginal.NO_CIA;
                  NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO (Lr_MigraDocAsociado ,
                                                                     'E', 
                                                                     Pv_MensajeError);
               --
                  IF TRIM(Pv_MensajeError) IS NOT NULL THEN 
                    Pv_MensajeError := 'Ocurrio un error al tratar de actualizar el estado del documento migrador ' || Pn_PagoDetId || ' de NAF: '||Pv_MensajeError;
                    RAISE Lex_Exception; 
                  END IF;
              end if;
            --
            --
            INSERT
              INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL VALUES
              (
                DB_FINANCIERO.SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
                Lr_GetInfoDocumento.ID_PAGO,
                NULL,
                sysdate,
                'telcos',
                'Anulado',
                Lv_Observacion
              );
            --
          --
          ELSE
          --
            Pv_MensajeError := 'No se puede Anular pago, ya se encuentra contabilizado';
            --
            Lv_Observacion  := 'No se puede Anular pago ya se encuentra contabilizado: ' || Pn_PagoDetId || '|' ||Pv_UsrAnula ;
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                'FNKG_CONTABILIZAR_ANULARPAG.P_ANULA_MIGRACION', 
                                                Lv_Observacion,
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );  
            
          --
          END IF;
        --
        END IF;
    --
    END IF;
    --
    EXCEPTION
      WHEN Lex_Exception THEN
        --
        ROLLBACK;
        --
        Pv_MensajeError :=  SUBSTR('Error ' || Pv_MensajeError,1,500);
        
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNKG_CONTABILIZAR_ANULARPAG.P_ANULA_MIGRACION', 
                                              Pv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        Pv_MensajeError :=  SUBSTR('Error ' || Pv_MensajeError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK,1,500);
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNKG_CONTABILIZAR_ANULARPAG.P_ANULA_MIGRACION', 
                                              Pv_MensajeError,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_ANULA_MIGRACION;
END FNKG_CONTABILIZAR_ANULARPAG;
/