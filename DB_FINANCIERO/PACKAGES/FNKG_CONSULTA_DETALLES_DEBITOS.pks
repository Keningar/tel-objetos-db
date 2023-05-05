CREATE EDITIONABLE PACKAGE               FNKG_CONSULTA_DETALLES_DEBITOS
AS
  PROCEDURE P_CONSULTA_DETALLE_DEBITO(
      lv_id_empresa IN varchar2, 
      ln_id_debito_cab IN number,
      lv_clave_desencriptar VARCHAR2, 
      lc_cursor_debitos OUT SYS_REFCURSOR); 
      
  FUNCTION F_DESENCRIPTA_NUMERO_TARJ_CTA(lv_numero_tarjeta VARCHAR2, lv_clave_desencriptar VARCHAR2)
    RETURN VARCHAR2 DETERMINISTIC;
  
  FUNCTION F_DATOS_TARJETA_CTA_CLIENTE(id_per number,campo varchar2) 
    return varchar2;     

  PROCEDURE P_PROCESA_DEBITO_GENERAL (Pv_Usuario IN  VARCHAR2,
                                      Pv_Mensaje OUT VARCHAR2);

  PROCEDURE P_UPDATE_INFODEBITOCAB_PARAM (Pv_Usuario     IN  VARCHAR2,
                                          Pv_EmpresaCod  IN  VARCHAR2,
                                          Pv_EstadoAct   IN  VARCHAR2,
                                          Pv_EstadoNuevo IN  VARCHAR2,
                                          Pn_ValorTotal  IN  NUMBER,
                                          Pn_Dias        IN  NUMBER,
                                          Pv_Mensaje     OUT VARCHAR2);

  PROCEDURE P_UPDATE_INFO_DEBITO_GENERAL (Pr_InfoDebitoGeneral IN  INFO_DEBITO_GENERAL%ROWTYPE,
                                          Pv_Mensaje           OUT VARCHAR2);

END FNKG_CONSULTA_DETALLES_DEBITOS;
/

CREATE EDITIONABLE PACKAGE BODY                             FNKG_CONSULTA_DETALLES_DEBITOS
AS
    /*
    * Documentaci�n para FUNCION 'F_DESENCRIPTA_NUMERO_TARJ_CTA'.
    * FUNCION QUE OBTIENE EL NUMERO DE TARJETA O CUENTA DESENCRIPTADO
    * PARAMETROS:
    * @Param varchar2 lv_numero_tarjeta (numero de tarjeta o cuenta que se desea desencriptar)
    * @Param varchar2 lv_clave_desencriptar (secret para desencriptar el numero de tarjeta o cuenta)    
    * @return varchar2 lv_campo_retorna (campo desencriptado) se utiliza la cl�usa DETERMINISTIC debido a que se est� usando esta funci�n 
                                        dentro de una columna virtual basada en funci�n INFO_CONTRATO_FORMA_PAGO.BIN_VIRTUAL
    */
    FUNCTION F_DESENCRIPTA_NUMERO_TARJ_CTA(
        lv_numero_tarjeta VARCHAR2, lv_clave_desencriptar VARCHAR2)
      RETURN VARCHAR2 DETERMINISTIC
    IS
        lv_campo_retorna VARCHAR2(70);
    BEGIN
        DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(lv_numero_tarjeta,lv_clave_desencriptar,lv_campo_retorna);
        RETURN lv_campo_retorna;
    END;



  /*
  * Documentaci�n para FUNCION 'ULTIMO_CONTRATO_CLIENTE'.
  * FUNCION QUE OBTIENE datos de la tarjeta del cliente
  * PARAMETROS:
  * @Param number id_per (id_persona_empresa_rol del cliente)
  * @return varchar2 campo_retorna (es el anio_vencimiento, mes_vencimiento o el 
  *   codigo_verificacion de la tarjeta del cliente)
  */
  FUNCTION F_DATOS_TARJETA_CTA_CLIENTE(id_per number,campo varchar2) return varchar2 
  is
    campo_retorna varchar2(60):='';
  begin
      CASE 
      WHEN campo='anio_vencimiento' THEN
          SELECT anio_vencimiento INTO campo_retorna FROM  
          (SELECT cfp.ANIO_VENCIMIENTO FROM 
          DB_COMERCIAL.INFO_CONTRATO cont,
          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO cfp
          WHERE cont.id_contrato=cfp.contrato_id 
          AND cont.persona_empresa_rol_id=id_per 
          AND cont.estado not in ('Rechazado','Pendiente') 
          AND cfp.estado not in ('Inactivo')  
          ORDER BY cont.ID_CONTRATO DESC) WHERE rownum=1;
      WHEN campo='mes_vencimiento' THEN
          SELECT mes_vencimiento INTO campo_retorna FROM  
          (SELECT cfp.MES_VENCIMIENTO FROM 
          DB_COMERCIAL.INFO_CONTRATO cont,
          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO cfp
          WHERE cont.id_contrato=cfp.contrato_id 
          AND cont.persona_empresa_rol_id=id_per 
          AND cont.estado not in ('Rechazado','Pendiente') 
          AND cfp.estado not in ('Inactivo')  
          ORDER BY cont.ID_CONTRATO DESC) WHERE rownum=1;   
      WHEN campo='codigo_verificacion' THEN
          SELECT codigo_verificacion INTO campo_retorna FROM  
          (SELECT cfp.CODIGO_VERIFICACION FROM 
          DB_COMERCIAL.INFO_CONTRATO cont,
          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO cfp
          WHERE cont.id_contrato=cfp.contrato_id 
          AND cont.persona_empresa_rol_id=id_per 
          AND cont.estado not in ('Rechazado','Pendiente') 
          AND cfp.estado not in ('Inactivo')  
          ORDER BY cont.ID_CONTRATO DESC) WHERE rownum=1;            
      END CASE;
  
      return campo_retorna;
  END;

    /*
    * Documentaci�n para PROCEDIMIENTO 'CONSULTA_DETALLE_DEBITO'.
    * PROCEDIMIENTO QUE BUSCA LOS DETALLES DE DEBITO SEGUN ID CABECERA
    * INCLUYE LA DESENCRIPTACION DEL NUMERO DE TARJETA O CUENTA 
    * EL PROCEDIMIENTO RECIBE LOS PARAMETROS:
    * @Param lv_id_empresa          (id de la empresa)
    * @Param ln_id_debito_cab       (id de la cabecera del debito)
    * @Param lv_clave_desencriptar  (clave secreta para desencriptar)
    * @Param lv_cursor_debitos      (cursor donde se registra el resultado de la consulta)
    */
    PROCEDURE P_CONSULTA_DETALLE_DEBITO(lv_id_empresa IN varchar2, 
				                                ln_id_debito_cab IN number,
                                        lv_clave_desencriptar VARCHAR2, 
                                        lc_cursor_debitos OUT SYS_REFCURSOR)
    AS
    BEGIN
        open  
        lc_cursor_debitos for
        SELECT 
	    ddet.id_debito_det,ofi.nombre_oficina, ddet.valor_total, per.estado,
            F_DATOS_TARJETA_CTA_CLIENTE(ddet.persona_empresa_rol_id,'anio_vencimiento') as anio_vencimiento,
            F_DATOS_TARJETA_CTA_CLIENTE(ddet.persona_empresa_rol_id,'mes_vencimiento') as mes_vencimiento,
            F_DATOS_TARJETA_CTA_CLIENTE(ddet.persona_empresa_rol_id,'codigo_verificacion') as codigo_verificacion,
            FNKG_CONSULTA_DETALLES_DEBITOS.F_DESENCRIPTA_NUMERO_TARJ_CTA(
                ddet.numero_tarjeta_cuenta,lv_clave_desencriptar) as numero_cta_tarjeta ,            
            CASE WHEN p.razon_social IS NULL THEN  
                CONCAT(CONCAT(p.nombres,' '),p.apellidos) ELSE p.razon_social END as cliente            
        FROM 
            DB_FINANCIERO.INFO_DEBITO_DET ddet, 
            DB_COMERCIAL.Info_Persona_Empresa_Rol per,  
            DB_COMERCIAL.info_persona p,
            DB_COMERCIAL.Info_Oficina_Grupo ofi
        WHERE
            ddet.persona_empresa_rol_id=per.id_persona_rol	 
            AND p.id_persona=per.persona_id
            AND per.oficina_Id=ofi.ID_OFICINA 
            AND ddet.empresa_id=lv_id_empresa 
            AND ddet.debito_CAB_id=ln_id_debito_cab
        ORDER BY 
            ddet.id_debito_det;
END P_CONSULTA_DETALLE_DEBITO;

  /**
   * Documentaci�n para PROCEDIMIENTO 'P_PROCESA_DEBITO_GENERAL'.
   * PROCEDIMIENTO QUE CAMBIA DE ESTADO DE INFO_DEBITO_CAB E INFO_DEBITO_GENERAL EN BASE AL PAR�METRO: 'JOB_PROCESA_DEBITO_GENERAL'.
   * EL PROCEDIMIENTO RECIBE LOS PARAMETROS:
   * @Param Pv_Usuario  IN   (Usuario que ejecuta la transacci�n)
   * @Param Pv_Mensaje  OUT  (Mensaje de error)
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0 06-12-2017 - Versi�n inicial
   */
  PROCEDURE P_PROCESA_DEBITO_GENERAL (Pv_Usuario IN  VARCHAR2,
                                      Pv_Mensaje OUT VARCHAR2)
    AS
        Lv_Mensaje               VARCHAR2(500) := '';
        Lv_Observacion           VARCHAR2(800) := '';
        Le_Exception             EXCEPTION;
        Lv_NombreProceso         VARCHAR2(100);
        Lr_InfoDebitoGeneralHist DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL%ROWTYPE;
        Lr_AdmiParametroDet      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
        Lr_InfoDebitoGeneral     DB_FINANCIERO.INFO_DEBITO_GENERAL%ROWTYPE;
        Lrf_AdmiParametroDet     SYS_REFCURSOR;
        Ln_ContadorCabeceras     NUMBER;

        CURSOR C_BuscaDebitos (Cv_Estado VARCHAR2, Cv_EmpresaCod VARCHAR2, Cn_ValorTotal NUMBER, Cn_Dias NUMBER) IS
            SELECT
                CAB.DEBITO_GENERAL_ID, GEN.ESTADO, COUNT (*) CANTIDAD
            FROM
                DB_FINANCIERO.INFO_DEBITO_CAB CAB,
                DB_FINANCIERO.INFO_DEBITO_GENERAL GEN
            WHERE
                GEN.ID_DEBITO_GENERAL       = CAB.DEBITO_GENERAL_ID
                AND CAB.ESTADO              = NVL(Cv_Estado, CAB.ESTADO)
                AND NVL(CAB.VALOR_TOTAL, 0) = NVL(Cn_ValorTotal, CAB.VALOR_TOTAL)
                AND CAB.EMPRESA_ID          = Cv_EmpresaCod
                AND CAB.FE_CREACION        <= TO_TIMESTAMP(SYSDATE - Cn_Dias)
                AND GEN.ESTADO              = 'Activo'
            GROUP BY CAB.DEBITO_GENERAL_ID, GEN.ESTADO;

        CURSOR C_CabecerasDebitoGen (Cn_DebitoGeneralId NUMBER, Cv_Estado VARCHAR2, Cv_EmpresaCod VARCHAR2, Cn_ValorTotal NUMBER, Cn_Dias NUMBER) IS
            SELECT
                CAB.ID_DEBITO_CAB, CAB.DEBITO_GENERAL_ID, CAB.VALOR_TOTAL, CAB.ESTADO ESTADO_CAB
            FROM
                DB_FINANCIERO.INFO_DEBITO_CAB CAB
            WHERE
                CAB.DEBITO_GENERAL_ID       = Cn_DebitoGeneralId
                AND CAB.ESTADO              = NVL(Cv_Estado, CAB.ESTADO)
                AND NVL(CAB.VALOR_TOTAL, 0) = NVL(Cn_ValorTotal, CAB.VALOR_TOTAL)
                AND CAB.EMPRESA_ID          = Cv_EmpresaCod
                AND CAB.FE_CREACION        <= TO_TIMESTAMP(SYSDATE - Cn_Dias);
    BEGIN
        --OBTENGO LOS PAR�METROS CON LAS EMPRESAS QUE APLICAN AL PROCESO DEL JOB.
        Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS('JOB_PROCESA_DEBITO_GENERAL');
        LOOP
            FETCH Lrf_AdmiParametroDet INTO Lr_AdmiParametroDet;
            EXIT WHEN Lrf_AdmiParametroDet%NOTFOUND;

            --BUSCO LOS D�BITOS GENERALES CON CABECERAS SEG�N LOS PAR�METROS.
            FOR Lr_DebitoGeneral IN  C_BuscaDebitos (Lr_AdmiParametroDet.VALOR3,
                                                     Lr_AdmiParametroDet.EMPRESA_COD,
                                                     Lr_AdmiParametroDet.VALOR1,
                                                     Lr_AdmiParametroDet.VALOR2)
            LOOP
                Ln_ContadorCabeceras := 0;
                --BUSCO LAS CABECERAS SEG�N LOS PAR�METROS
                FOR Lr_CabecerasPorAnular IN  C_CabecerasDebitoGen (Lr_DebitoGeneral.DEBITO_GENERAL_ID,
                                                                    Lr_AdmiParametroDet.VALOR3,
                                                                    Lr_AdmiParametroDet.EMPRESA_COD,
                                                                    Lr_AdmiParametroDet.VALOR1,
                                                                    Lr_AdmiParametroDet.VALOR2)
                LOOP
                    Lv_Observacion := 'SE ACTUALIZA LA CABECERA DEL D�BITO: ' || Lr_CabecerasPorAnular.ID_DEBITO_CAB || ' | ESTADO ANTERIOR:'
                                      || Lr_CabecerasPorAnular.ESTADO_CAB || ' -> ESTADO ACTUAL:' || Lr_AdmiParametroDet.VALOR4
                                      || ' | VALOR_TOTAL= ' || NVL(Lr_CabecerasPorAnular.VALOR_TOTAL,0);

                    Lr_InfoDebitoGeneralHist.DEBITO_GENERAL_ID           := Lr_CabecerasPorAnular.DEBITO_GENERAL_ID;
                    Lr_InfoDebitoGeneralHist.OBSERVACION                 := Lv_Observacion;
                    Lr_InfoDebitoGeneralHist.FE_CREACION                 := SYSDATE;
                    Lr_InfoDebitoGeneralHist.USR_CREACION                := Pv_Usuario;
                    Lr_InfoDebitoGeneralHist.ESTADO                      := Lr_DebitoGeneral.ESTADO;
                    Lr_InfoDebitoGeneralHist.ID_DEBITO_GENERAL_HISTORIAL := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.
                                                                            F_INSERT_DEBITO_GENERAL_HIST(
                                                                                        Fr_InfoDebitoGeneralHist => Lr_InfoDebitoGeneralHist,
                                                                                        Fv_NombreProceso         => Lv_NombreProceso,
                                                                                        Fv_Error                 => Lv_Mensaje);

                    IF Lv_Mensaje IS NOT NULL THEN
                        Lv_Mensaje := Lv_Mensaje || ':' || Lv_NombreProceso;
                        RAISE Le_Exception;
                    END IF;

                    
                END LOOP;
                --END LOOP C_CabecerasDebitoGen
                --CUENTO TODAS LAS CABECERAS DEL D�BITO
                SELECT COUNT(*) INTO Ln_ContadorCabeceras
                  FROM DB_FINANCIERO.INFO_DEBITO_CAB
                 WHERE DEBITO_GENERAL_ID = Lr_DebitoGeneral.DEBITO_GENERAL_ID;

                --SI SE PROCESARON TODAS LAS CABECERAS DEL D�BITO, �STE CAMBIA A 'INACTIV0'.
                IF (Ln_ContadorCabeceras = Lr_DebitoGeneral.CANTIDAD) THEN
                    Lr_InfoDebitoGeneral.ID_DEBITO_GENERAL := Lr_DebitoGeneral.DEBITO_GENERAL_ID;
                    Lr_InfoDebitoGeneral.ESTADO            := 'Inactivo';
                    DB_FINANCIERO.FNKG_CONSULTA_DETALLES_DEBITOS.P_UPDATE_INFO_DEBITO_GENERAL (Pr_InfoDebitoGeneral => Lr_InfoDebitoGeneral,
                                                                                               Pv_Mensaje           => Lv_Mensaje);
                    IF Lv_Mensaje IS NOT NULL THEN
                        RAISE Le_Exception;
                    END IF;

                    --REGISTRO EN EL HISTORIAL LA ACTUALIZACI�N DEL CAMBIO DE ESTADO
                    Lr_InfoDebitoGeneralHist.DEBITO_GENERAL_ID           := Lr_DebitoGeneral.DEBITO_GENERAL_ID;
                    Lr_InfoDebitoGeneralHist.OBSERVACION                 := 'Se Inactiva el D�bito General por proceso autom�tico. ('
                                                                            || 'VALOR: ' || Lr_AdmiParametroDet.VALOR1
                                                                            || ' | DIAS: ' || Lr_AdmiParametroDet.VALOR2 || ')';
                    Lr_InfoDebitoGeneralHist.ESTADO                      := Lr_InfoDebitoGeneral.ESTADO;
                    Lr_InfoDebitoGeneralHist.ID_DEBITO_GENERAL_HISTORIAL := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.
                                                                            F_INSERT_DEBITO_GENERAL_HIST(
                                                                                            Fr_InfoDebitoGeneralHist => Lr_InfoDebitoGeneralHist,
                                                                                            Fv_NombreProceso         => Lv_NombreProceso,
                                                                                            Fv_Error                 => Lv_Mensaje);
                    IF Lv_Mensaje IS NOT NULL THEN
                        Lv_Mensaje := Lv_Mensaje || ':' || Lv_NombreProceso;
                        RAISE Le_Exception;
                    END IF;
                END IF;

            END LOOP;
            --END LOOP C_BuscaDebitos

            DB_FINANCIERO.FNKG_CONSULTA_DETALLES_DEBITOS.P_UPDATE_INFODEBITOCAB_PARAM (Pv_Usuario     => Pv_Usuario,
                                                                                       Pv_EmpresaCod  => Lr_AdmiParametroDet.EMPRESA_COD,
                                                                                       Pv_EstadoAct   => Lr_AdmiParametroDet.VALOR3,
                                                                                       Pv_EstadoNuevo => Lr_AdmiParametroDet.VALOR4,
                                                                                       Pn_ValorTotal  => Lr_AdmiParametroDet.VALOR1,
                                                                                       Pn_Dias        => Lr_AdmiParametroDet.VALOR2,
                                                                                       Pv_Mensaje     => Lv_Mensaje);
            IF Lv_Mensaje IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;
            COMMIT;
        END LOOP;
        --END LOOP Lrf_AdmiParametroDet
        CLOSE Lrf_AdmiParametroDet;
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'P_PROCESA_DEBITO_GENERAL',
                                             Lv_Mensaje || ' | Error: ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                 ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_PROCESA_DEBITO_GENERAL;

  /**
   * Documentaci�n para PROCEDIMIENTO 'P_UPDATE_INFODEBITOCAB_PARAM'.
   * PROCEDIMIENTO QUE ANULA LAS CABECERAS, APLICADO A LOS D�BITOS EN BASE A UN RANGO DE FECHAS PARAMETRIZADOS.
   * EL PROCEDIMIENTO RECIBE LOS PARAMETROS:
   * @Param Pv_Usuario      IN  (Usuario que ejecuta la transacci�n)
   * @Param Pv_EmpresaCod   IN  (C�digo de la empresa)
   * @Param Pv_EstadoAct    IN  (Estado antes de la actualizaci�n)
   * @Param Pv_EstadoNuevo  IN  (Nuevo estado)
   * @Param Pn_ValorTotal   IN  (Valor por el que se realiza el filtro)
   * @Param Pn_Dias         IN  (D�as que son restados de la fecha actual)
   * @Param Pv_Mensaje      OUT (Mensaje de error)
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0 03-12-2017 - Versi�n inicial.
   */
  PROCEDURE P_UPDATE_INFODEBITOCAB_PARAM (Pv_Usuario     IN  VARCHAR2,
                                          Pv_EmpresaCod  IN  VARCHAR2,
                                          Pv_EstadoAct   IN  VARCHAR2,
                                          Pv_EstadoNuevo IN  VARCHAR2,
                                          Pn_ValorTotal  IN  NUMBER,
                                          Pn_Dias        IN  NUMBER,
                                          Pv_Mensaje     OUT VARCHAR2)
    AS
    BEGIN
      UPDATE DB_FINANCIERO.INFO_DEBITO_CAB
        SET
            ESTADO      = Pv_EstadoNuevo,
            FE_ULT_MOD  = SYSDATE,
            USR_ULT_MOD = Pv_Usuario
        WHERE
            ESTADO                  = NVL(Pv_EstadoAct, ESTADO)
            AND NVL(VALOR_TOTAL, 0) = NVL(Pn_ValorTotal, VALOR_TOTAL)
            AND EMPRESA_ID          = Pv_EmpresaCod
            AND FE_CREACION        <= TO_TIMESTAMP(SYSDATE - Pn_Dias);
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        Pv_Mensaje := 'ERROR AL ACTUALIZAR LAS CABECERAS DE LOS D�BITOS. ';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'P_UPDATE_INFODEBITOCAB_PARAM',
                                             'Error: ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                 ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_UPDATE_INFODEBITOCAB_PARAM;

  /**
   * Documentaci�n para P_UPDATE_INFO_DEBITO_GENERAL.
   * Actualiza el registro por ID_DEBITO_GENERAL.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0 06-12-2017 - Versi�n inicial.
   */
  PROCEDURE P_UPDATE_INFO_DEBITO_GENERAL (Pr_InfoDebitoGeneral IN  INFO_DEBITO_GENERAL%ROWTYPE,
                                          Pv_Mensaje           OUT VARCHAR2)
  AS
  BEGIN
    UPDATE INFO_DEBITO_GENERAL
      SET
        OFICINA_ID      = NVL(Pr_InfoDebitoGeneral.OFICINA_ID, OFICINA_ID),
        ESTADO          = NVL(Pr_InfoDebitoGeneral.ESTADO, ESTADO),
        ARCHIVO         = NVL(Pr_InfoDebitoGeneral.ARCHIVO, ARCHIVO),
        EJECUTANDO      = NVL(Pr_InfoDebitoGeneral.EJECUTANDO, EJECUTANDO),
        GRUPO_DEBITO_ID = NVL(Pr_InfoDebitoGeneral.GRUPO_DEBITO_ID, GRUPO_DEBITO_ID),
        IMPUESTO_ID     = NVL(Pr_InfoDebitoGeneral.IMPUESTO_ID, IMPUESTO_ID),
        CICLO_ID        = NVL(Pr_InfoDebitoGeneral.CICLO_ID, CICLO_ID)
    WHERE
      ID_DEBITO_GENERAL = Pr_InfoDebitoGeneral.ID_DEBITO_GENERAL;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pv_Mensaje := 'ERROR AL ACTUALIZAR EL D�BITO GENERAL.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'P_UPDATE_INFO_DEBITO_GENERAL',
                                             'Error: ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                 ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_UPDATE_INFO_DEBITO_GENERAL;
END  FNKG_CONSULTA_DETALLES_DEBITOS;
/
