CREATE OR REPLACE TRIGGER DB_FINANCIERO.AFTER_DML_INFO_DOC_FINAN_CAB
AFTER INSERT OR UPDATE ON DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW 
DECLARE
    --
    /**
    * Documentacion para trigger AFTER_DML_INFO_DOC_FINAN_CAB
    * Anula la actualizacion de estado de facturas y notas de credito
    * los casos de anulaciond de actualizacion son:
    * FAC- FACP : Si la factura se encuentra en estado Activo se debe permitir actualizar al siguiente estado que es Cerrado
    * FAC- FACP : Si la factura se encuentra en estado Cerrado no se debe permitir cambiar a ningun otro estado
    * NC : Si la nota de credito se encuentra en estado Aprobada se debe permitir actualizar al siguiente estado que es Activo
    * NC : Si la nota de credito se encuentra en estado Activo no se debe permitir cambiar a ningun otro estado
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 11-03-2015
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.1 16-03-2015
    * @since 1.0
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.2 27-03-2015
    * @since 1.1
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.3 27-03-2015
    * @since 1.2
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.4 27-04-2016 Se modifica el modo de validacion, cuando se encuentren los estados mapeados en las tablas de parametros
    *                         no permitira la actualizacion del registro
    * @since 1.3
    * @author Jorge Guerrero <jguerrerop@telconet.ec>
    * @version 1.5 05-10-2017 Se modifica el trigger para que se guarde el ciclo del documento en la tabla INFO_DOCUMENTO_CARACTERISTICA
    * @author Jorge Guerrero <jguerrerop@telconet.ec>
    * @version 1.6 24-10-2017 Se modifica el trigger para guardar las caracteristicas del mes y año de consumo de la factura.
    * @author Luis Cabrera <lcabrera@telconet.ec>
    * @version 1.7 - Se agrega validación cuando se actualiza la fecha de emisión. Se escribe el mes y año de consumo de la nueva fe_emision.
    *              - Aplican facturas y facturas proporcionales que no estén cerradas.
    *              - Se modifica la característica de mes y año de consumo según el mes de consumo actual del ciclo al insertarse.
    * @since 24-09-2018
    *
    * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
    * @version 1.8 -26-10-2018 -  Se agrega actualizacion de los meses restantes segun la frecuencia cuando la Factura pasa a estado
    *                             Activo, para facturas automaticas generadas por el proceso masivo de Facturación para la empresa TN.
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.9 - Se valida el nulo del campo :OLD.FE_EMISION al momento de ejecutar actualización del mismo campo.
    * @since 17-01-2019
    *
    * @author Andre Lazo <alazo@telconet.ec>
    * @version 2.0 - Se añade prefijo empresa 'EN' para que pueda recuperar la caracteristica CICLO_FACTURACION
    * @since 17-03-2023
    *
    */

  CURSOR C_BuscaCiclo(Pn_PuntoFact NUMBER,Pv_DescCaract VARCHAR2)
  IS
    select Iperc.Valor,
           Ac.Id_Caracteristica,
           1 As Bandera
    from DB_COMERCIAL.Info_Punto ip,
         DB_COMERCIAL.Info_Persona_Empresa_Rol iper,
         DB_COMERCIAL.Info_Persona_Empresa_Rol_Carac iperc,
         DB_COMERCIAL.Admi_Caracteristica ac,
         DB_COMERCIAL.Info_Empresa_Rol ier,
         DB_COMERCIAL.Info_Empresa_Grupo ieg
    where Id_Punto=Pn_PuntoFact
    and Ip.Persona_Empresa_Rol_Id=Iper.Id_Persona_Rol
    and Iper.Id_Persona_Rol=Iperc.Persona_Empresa_Rol_Id
    and Ac.Id_Caracteristica=Iperc.Caracteristica_Id
    and Ac.Descripcion_Caracteristica=Pv_DescCaract
    and Iper.Empresa_Rol_Id=Ier.Id_Empresa_Rol
    and Ier.Empresa_Cod=Ieg.Cod_Empresa
    and iperc.Estado='Activo'
    and Ieg.Prefijo IN ('MD','EN');
    
  CURSOR C_BuscaCaract(Pv_DescCaract VARCHAR2)
  IS
    select Ac.Id_Caracteristica,
           1 As Bandera
    from DB_COMERCIAL.Admi_Caracteristica ac
    where Ac.Descripcion_Caracteristica=Pv_DescCaract
    and ac.ESTADO='Activo';

  Lc_BuscaCiclo C_BuscaCiclo%ROWTYPE;
  Lc_BuscaCaract C_BuscaCaract%ROWTYPE;

    Lr_AdmiTipoDocFinanciero ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  Lr_Boolean    BOOLEAN;
  Lex_Exception EXCEPTION;

  Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
  Lv_Error VARCHAR2(3000);
  --
  --Costo del query 5
  CURSOR C_ObtieneDocumentoCaract  (Cn_DocumentoId       DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.DOCUMENTO_ID%TYPE,
                                    Cv_EstadoActivo      VARCHAR2,
                                    Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS
    SELECT IDC.ID_DOCUMENTO_CARACTERISTICA,
           AC.ID_CARACTERISTICA,
           IDC.VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC
     WHERE IDC.DOCUMENTO_ID              = Cn_DocumentoId
       AND IDC.ESTADO                    = Cv_EstadoActivo
       AND IDC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
       AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
       AND AC.ESTADO                     = Cv_EstadoActivo;

  --
  --Costo del query : 6
  CURSOR C_ObtieneDocumentoServicios (Cn_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                      Cv_EmpresaCod          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                            
                             )
  IS
  SELECT IDFD.DOCUMENTO_ID AS ID_DOCUMENTO,        
  IDFD.SERVICIO_ID         AS ID_SERVICIO,       
  IDFD.PUNTO_ID            AS ID_PUNTO_DETALLE, 
  IDFD.PRODUCTO_ID         AS ID_PRODUCTO,        
  SERV.FRECUENCIA_PRODUCTO AS FRECUENCIA,
  SERV.MESES_RESTANTES     AS MESES_RESTANTES
      
  FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD                     
  JOIN DB_COMERCIAL.INFO_SERVICIO SERV
  ON IDFD.SERVICIO_ID          = SERV.ID_SERVICIO
  WHERE 
  DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFD.PUNTO_ID, NULL) = Cv_EmpresaCod            
  AND IDFD.DOCUMENTO_ID                                                   = Cn_IdDocumento;
  --
  Lr_ObtieneDocumentoCaract  C_ObtieneDocumentoCaract%ROWTYPE;
  Lv_EstadoActivo            VARCHAR2(15) := 'Activo';
  Lv_FormatoFecha            VARCHAR2(4)  := 'MM';
  Lr_InfoDocumentoHistorial  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  Lv_CicloFacturadoMes       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CICLO_FACTURADO_MES';
  Lv_CicloFacturadoAnio      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CICLO_FACTURADO_ANIO';
  Lv_AccionCaracteristica    VARCHAR2(10);
  Ld_FeInicioConsumo         DATE;

  TYPE Lt_Caracteristicas IS VARRAY(2) OF DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;
  La_Caracteristicas      Lt_Caracteristicas := Lt_Caracteristicas(Lv_CicloFacturadoMes, Lv_CicloFacturadoAnio);
  Ln_Indice               PLS_INTEGER;

  BEGIN
    --
    --Pregunta si se actualiza el campo ESTADO_IMPRESION_FACT
    IF UPDATING('ESTADO_IMPRESION_FACT') THEN
      --Obtiene el registro del tipo de documento financiero
      Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(:OLD.TIPO_DOCUMENTO_ID, NULL);
      --
      --Obtiene respuesta de los estado a buscar segun los estados mapeados en las tablas de parametros
      Lr_Boolean := FNCK_CONSULTS.F_CAMBIO_ESTADO_PERMITIDO(:OLD.ID_DOCUMENTO, 
                                                            :OLD.ESTADO_IMPRESION_FACT, 
                                                            :NEW.ESTADO_IMPRESION_FACT, 
                                                            :OLD.OFICINA_ID, 
                                                            :OLD.TIPO_DOCUMENTO_ID, 
                                                            'CAMBIOS_ESTADOS_NO_PERMITIDOS', 
                                                            'Activo', 
                                                            'Activo');
      --
      --Si la variable es TRUE levanta la excepcion
      IF Lr_Boolean THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
      IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO = 'FAC'  
         AND :OLD.ESTADO_IMPRESION_FACT = 'Pendiente' AND :NEW.ESTADO_IMPRESION_FACT = 'Activo' 
         AND :OLD.USR_CREACION = 'telcos' AND :OLD.ES_AUTOMATICA = 'S' THEN
        FOR Lr_ObtieneDocumentoServicios in C_ObtieneDocumentoServicios(:NEW.ID_DOCUMENTO,'TN') LOOP
           --
           --Se actualiza los meses restantes segun la frecuencia
           UPDATE DB_COMERCIAL.INFO_SERVICIO SET MESES_RESTANTES=Lr_ObtieneDocumentoServicios.FRECUENCIA
           WHERE ID_SERVICIO=Lr_ObtieneDocumentoServicios.ID_SERVICIO;
        --
        END LOOP;
      --
      END IF;
      --
    END IF;
    --    
    --Si se actualiza la fecha de emisión, es una factura o proporcional y no se actualiza el estado a Cerrado.
    IF UPDATING('FE_EMISION') AND :NEW.TIPO_DOCUMENTO_ID IN (1,5) AND :NEW.ESTADO_IMPRESION_FACT <> 'Cerrado' AND
       :NEW.FE_EMISION <> NVL(:OLD.FE_EMISION,TO_DATE('01/01/1900','DD/MM/YYYY')) THEN

        OPEN  C_ObtieneDocumentoCaract (Cn_DocumentoId       => :NEW.ID_DOCUMENTO,
                                        Cv_EstadoActivo      => Lv_EstadoActivo,
                                        Cv_DescripcionCaract => 'CICLO_FACTURACION');
        FETCH C_ObtieneDocumentoCaract INTO Lr_ObtieneDocumentoCaract;
        CLOSE C_ObtieneDocumentoCaract;

        --SI NO TIENE CICLO (TN), SE FIJA POR DEFECTO EL CICLO 1 DE MD PARA REALIZAR EL CÁLCULO DE FECHA DE FACTURACIÓN.
        Lr_ObtieneDocumentoCaract.VALOR := NVL(Lr_ObtieneDocumentoCaract.VALOR, '5');
        DB_FINANCIERO.FNCK_FACTURACION.P_OBTIENE_FE_SIG_CICLO_FACT(Pn_IdCiclo       => TO_NUMBER(Lr_ObtieneDocumentoCaract.Valor),
                                                                   Pd_FeAValidar    => TRUNC(:NEW.FE_EMISION),
                                                                   Pd_FeFacturacion => Ld_FeInicioConsumo);
        --Se obtiene la fecha de la siguiente facturación del ciclo, por lo tanto resto un mes para obtener la actual.
        Ld_FeInicioConsumo := ADD_MONTHS(Ld_FeInicioConsumo, -1);

        --Se actualiza el mes y anio de consumo.
        Ln_Indice := La_Caracteristicas.FIRST;
        WHILE ( Ln_Indice IS NOT NULL )
        LOOP
            OPEN  C_ObtieneDocumentoCaract (Cn_DocumentoId       => :NEW.ID_DOCUMENTO,
                                            Cv_EstadoActivo      => Lv_EstadoActivo,
                                            Cv_DescripcionCaract => La_Caracteristicas(Ln_Indice));
            FETCH C_ObtieneDocumentoCaract INTO Lr_ObtieneDocumentoCaract;
            CLOSE C_ObtieneDocumentoCaract;

            IF Lv_CicloFacturadoMes = La_Caracteristicas(Ln_Indice) THEN
                Lv_FormatoFecha := 'MM';
            ELSE
                Lv_FormatoFecha := 'YYYY';
            END IF;
            Lr_InfoDocumentoCaracteristica       := NULL;
            Lr_InfoDocumentoCaracteristica.Valor := TO_CHAR(Ld_FeInicioConsumo, Lv_FormatoFecha);
            --Si es el mismo valor, no se actualiza/crea la característica.
            IF TO_CHAR(Lr_InfoDocumentoCaracteristica.Valor) = TO_CHAR(Lr_ObtieneDocumentoCaract.Valor) THEN
                Ln_Indice := La_Caracteristicas.NEXT(Ln_Indice);
                CONTINUE;
            END IF;

            Lr_InfoDocumentoCaracteristica.Id_Documento_Caracteristica := Lr_ObtieneDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA;
            Lr_InfoDocumentoCaracteristica.Documento_Id                := :NEW.ID_DOCUMENTO;
            Lr_InfoDocumentoCaracteristica.Caracteristica_Id           := Lr_ObtieneDocumentoCaract.ID_CARACTERISTICA;
            Lr_InfoDocumentoCaracteristica.Estado                      := Lv_EstadoActivo;

            --Si existe, se actualiza el valor de la característica.
            IF NVL(Lr_ObtieneDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA, 0) > 0 THEN
                Lr_InfoDocumentoCaracteristica.Fe_Ult_Mod  := SYSDATE;
                Lr_InfoDocumentoCaracteristica.Usr_Ult_Mod := NVL(:NEW.USR_CREACION, 'telcos');
                Lr_InfoDocumentoCaracteristica.Ip_Ult_Mod  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                Lv_Error                                   := NULL;
                Lv_AccionCaracteristica                    := 'actualiza';
                DB_FINANCIERO.FNCK_TRANSACTION.P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract => Lr_InfoDocumentoCaracteristica,
                                                                              Pv_MsnError            => Lv_Error);
                IF Lv_Error IS NOT NULL THEN
                  RAISE_APPLICATION_ERROR(-20003, 'Error al ' || Lv_AccionCaracteristica || 'r la carateristica '
                                                    || Lr_ObtieneDocumentoCaract.ID_CARACTERISTICA
                                                    || ' de la factura '
                                                    || :NEW.ID_DOCUMENTO 
                                                    || ': '
                                                    ||Lv_Error);
                END IF;
            ELSE
                --Si no existe, se busca la característica y luego se inserta.
                OPEN  C_BuscaCaract(La_Caracteristicas(Ln_Indice));
                FETCH C_BuscaCaract INTO Lc_BuscaCaract;
                CLOSE C_BuscaCaract;

                Lr_InfoDocumentoCaracteristica.Fe_Creacion       := SYSDATE;
                Lr_InfoDocumentoCaracteristica.Usr_Creacion      := NVL(:NEW.USR_CREACION, 'telcos');
                Lr_InfoDocumentoCaracteristica.Ip_Creacion       := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
                Lr_InfoDocumentoCaracteristica.Caracteristica_Id := Lc_BuscaCaract.ID_CARACTERISTICA;
                Lv_Error                                         := NULL;
                Lv_AccionCaracteristica                          := 'crea';
                DB_FINANCIERO.FNCK_FACTURACION.P_INSERT_INFO_DOC_CARACT(Pr_InfoDocCaract => Lr_InfoDocumentoCaracteristica,
                                                                        Pv_Error         => Lv_Error);
                IF Lv_Error IS NOT NULL THEN
                  RAISE_APPLICATION_ERROR(-20004, 'Error al ' || Lv_AccionCaracteristica || 'r la carateristica '
                                                  || Lr_InfoDocumentoCaracteristica.Caracteristica_Id
                                                  || ' de la factura '
                                                  || :NEW.ID_DOCUMENTO 
                                                  || ': '
                                                  ||Lv_Error);
                END IF;
            END IF;

            --Se actualiza el historial del documento.
            Lr_InfoDocumentoHistorial                           := NULL;
            Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL    := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL ;
            Lr_InfoDocumentoHistorial.DOCUMENTO_ID              := :NEW.ID_DOCUMENTO;
            Lr_InfoDocumentoHistorial.MOTIVO_ID                 := NULL;
            Lr_InfoDocumentoHistorial.FE_CREACION               := SYSDATE;
            Lr_InfoDocumentoHistorial.USR_CREACION              := NVL(:NEW.USR_CREACION, 'telcos');
            Lr_InfoDocumentoHistorial.ESTADO                    := :NEW.ESTADO_IMPRESION_FACT;
            Lr_InfoDocumentoHistorial.OBSERVACION               := 'Se ' || Lv_AccionCaracteristica ||
                                                                   ' la característica ' || La_Caracteristicas(Ln_Indice) || ':' ||
                                                                   Lr_InfoDocumentoCaracteristica.Valor;
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Lv_Error);
            IF Lv_Error IS NOT NULL THEN
              RAISE_APPLICATION_ERROR(-20005, 'Error al guardar el historial del documento '
                                              || ' de la factura '
                                              || :NEW.ID_DOCUMENTO 
                                              || ': '
                                              ||Lv_Error);
            END IF;
            Ln_Indice := La_Caracteristicas.NEXT(Ln_Indice);
        END LOOP;
    END IF;

    IF INSERTING THEN
    
      IF :NEW.TIPO_DOCUMENTO_ID = 1 OR :NEW.TIPO_DOCUMENTO_ID = 5 THEN

        OPEN C_BuscaCiclo(:NEW.PUNTO_ID,'CICLO_FACTURACION');
        FETCH C_BuscaCiclo INTO Lc_BuscaCiclo;
        CLOSE C_BuscaCiclo;
  
        IF Lc_Buscaciclo.Bandera = 1 THEN
  
          Lr_InfoDocumentoCaracteristica:=NULL;
          Lr_InfoDocumentoCaracteristica.Documento_Id:= :NEW.ID_DOCUMENTO;
          Lr_InfoDocumentoCaracteristica.Caracteristica_Id:= Lc_BuscaCiclo.Id_Caracteristica;
          Lr_InfoDocumentoCaracteristica.Valor:= Lc_BuscaCiclo.Valor;
          Lr_InfoDocumentoCaracteristica.Fe_Creacion:= :NEW.FE_CREACION;
          Lr_InfoDocumentoCaracteristica.Usr_Creacion:= :NEW.USR_CREACION;
          Lr_InfoDocumentoCaracteristica.Ip_Creacion:= NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
          Lr_InfoDocumentoCaracteristica.Estado:='Activo';
          Lv_Error:=NULL;
          DB_FINANCIERO.FNCK_FACTURACION.P_INSERT_INFO_DOC_CARACT(Lr_InfoDocumentoCaracteristica,Lv_Error);
  
          IF Lv_Error IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al guardar la carateristica '
                                            || Lc_BuscaCiclo.Id_Caracteristica
                                            || ' de la factura '
                                            || :NEW.ID_DOCUMENTO 
                                            || ': '
                                            ||Lv_Error);
          END IF;
  
        END IF;

        --SI NO TIENE CICLO (TN), SE FIJA POR DEFECTO EL CICLO 1 DE MD PARA REALIZAR EL CÁLCULO DE FECHA DE FACTURACIÓN.
        Lc_BuscaCiclo.Valor := NVL(Lc_BuscaCiclo.Valor, '5');
        DB_FINANCIERO.FNCK_FACTURACION.P_OBTIENE_FE_SIG_CICLO_FACT(Pn_IdCiclo       => TO_NUMBER(Lc_BuscaCiclo.Valor),
                                                                   Pd_FeAValidar    => TRUNC(:NEW.FE_CREACION),
                                                                   Pd_FeFacturacion => Ld_FeInicioConsumo);
        --Se obtiene la fecha de la siguiente facturación del ciclo, por lo tanto resto un mes para obtener la actual.
        Ld_FeInicioConsumo := ADD_MONTHS(Ld_FeInicioConsumo, -1);

        OPEN C_BuscaCaract('CICLO_FACTURADO_MES');
        FETCH C_BuscaCaract INTO Lc_BuscaCaract;
        CLOSE C_BuscaCaract;
  
        IF Lc_BuscaCaract.Bandera = 1 THEN
  
          Lr_InfoDocumentoCaracteristica:=NULL;
          Lr_InfoDocumentoCaracteristica.Documento_Id:= :NEW.ID_DOCUMENTO;
          Lr_InfoDocumentoCaracteristica.Caracteristica_Id:= Lc_BuscaCaract.Id_Caracteristica;
          Lr_InfoDocumentoCaracteristica.Valor:= TO_CHAR(Ld_FeInicioConsumo,'MM');
          Lr_InfoDocumentoCaracteristica.Fe_Creacion:= :NEW.FE_CREACION;
          Lr_InfoDocumentoCaracteristica.Usr_Creacion:= :NEW.USR_CREACION;
          Lr_InfoDocumentoCaracteristica.Ip_Creacion:= NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
          Lr_InfoDocumentoCaracteristica.Estado:='Activo';
          Lv_Error:=NULL;
          DB_FINANCIERO.FNCK_FACTURACION.P_INSERT_INFO_DOC_CARACT(Lr_InfoDocumentoCaracteristica,Lv_Error);
  
          IF Lv_Error IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al guardar la carateristica '
                                            || Lc_BuscaCiclo.Id_Caracteristica
                                            || ' de la factura '
                                            || :NEW.ID_DOCUMENTO 
                                            || ': '
                                            ||Lv_Error);
          END IF;
  
        END IF;
  
        OPEN C_BuscaCaract('CICLO_FACTURADO_ANIO');
        FETCH C_BuscaCaract INTO Lc_BuscaCaract;
        CLOSE C_BuscaCaract;
  
        IF Lc_BuscaCaract.Bandera = 1 THEN
  
          Lr_InfoDocumentoCaracteristica:=NULL;
          Lr_InfoDocumentoCaracteristica.Documento_Id:= :NEW.ID_DOCUMENTO;
          Lr_InfoDocumentoCaracteristica.Caracteristica_Id:= Lc_BuscaCaract.Id_Caracteristica;
          Lr_InfoDocumentoCaracteristica.Valor:= TO_CHAR(Ld_FeInicioConsumo,'YYYY');
          Lr_InfoDocumentoCaracteristica.Fe_Creacion:= :NEW.FE_CREACION;
          Lr_InfoDocumentoCaracteristica.Usr_Creacion:= :NEW.USR_CREACION;
          Lr_InfoDocumentoCaracteristica.Ip_Creacion:= NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
          Lr_InfoDocumentoCaracteristica.Estado:='Activo';
          Lv_Error:=NULL;
          DB_FINANCIERO.FNCK_FACTURACION.P_INSERT_INFO_DOC_CARACT(Lr_InfoDocumentoCaracteristica,Lv_Error);
  
          IF Lv_Error IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al guardar la carateristica '
                                            || Lc_BuscaCiclo.Id_Caracteristica
                                            || ' de la factura '
                                            || :NEW.ID_DOCUMENTO 
                                            || ': '
                                            ||Lv_Error);
          END IF;
  
        END IF;
        
      END IF;

    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    --Envia un correo de notificacion
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - AFTER_DML_INFO_DOC_FINAN_CAB en ' 
                                             || Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO 
                                             || ' ' 
                                             || :OLD.NUMERO_FACTURA_SRI 
                                             || ', ' 
                                             || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS'), 
                                            '<p>Error en INFO_DOCUMENTO_FINANCIERO_CAB cambios de estados no permitidos, <b>' 
                                             || SYS_CONTEXT ('USERENV', 'HOST') 
                                             || '</b> trato de cambiar los estados de <b><u>' 
                                             || :OLD.ESTADO_IMPRESION_FACT 
                                             || '</u></b> a <b><u>' 
                                             || :NEW.ESTADO_IMPRESION_FACT 
                                             || '</u></b></p> <p><b>ERROR_STACK:</b> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                             || '</small></p> <p><b>ERROR_BACKTRACE:</b> <small></p>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE 
                                             || '</small>', 'FACE');
    --
    --Cancela la transaccion y crea un codigo de error
    RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO_FINANCIERO_CAB cambios de estados no permitidos, ' 
                            || SYS_CONTEXT ('USERENV', 'HOST') 
                            || ' trato de cambiar los estados de ' 
                            || :OLD.ESTADO_IMPRESION_FACT 
                            || ' a ' 
                            || :NEW.ESTADO_IMPRESION_FACT 
                            || ' ' 
                            || DBMS_UTILITY.FORMAT_ERROR_STACK 
                            || ' ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
  WHEN OTHERS THEN
    --
    --Envia un correo de notificacion
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - AFTER_DML_INFO_DOC_FINAN_CAB en ' 
                                             || Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO 
                                             || ' ' 
                                             || :OLD.NUMERO_FACTURA_SRI 
                                             || ', ' 
                                             || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS'), 
                                             '<p>Existio el siguiente error:</p>  <p><b>ERROR_STACK:</b> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                             || '</small></p> <p><b>ERROR_BACKTRACE:</b> <small> ' 
                                             || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE 
                                             || '</small>', 'FACE');
                                                --
    --Cancela la transaccion y crea un codigo de error
    RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO_FINANCIERO_CAB ' 
                            || DBMS_UTILITY.FORMAT_ERROR_STACK 
                            || ' ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
END AFTER_DML_INFO_DOC_FINAN_CAB;
/