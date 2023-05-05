CREATE EDITIONABLE package            INKG_RETIRO_EQUIPO is

  /**
  * Documentacion para NAF47_TNET.INK_PROCESA_PEDIDOS.Gr_ArticuloPedido
  * Variable Registro que permite pasar por parametro los datos necesarios para procesar despachos de pedidos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/09/2016
  */
  TYPE Gr_FiltroElemento is RECORD(
    ID_DETALLE_SOLICITUD           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    TXT_LOGIN_EMPLE                NAF47_TNET.LOGIN_EMPLEADO.LOGIN%TYPE,
    TXT_TECNICO                    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    TXT_NOCIA                      NAF47_TNET.ARINCD.NO_CIA%TYPE,
    TXT_CENTRO                     NAF47_TNET.ARINCD.CENTRO%TYPE,
    REF_ASIGNADO_ID                DB_SOPORTE.INFO_DETALLE_ASIGNACION.REF_ASIGNADO_ID%TYPE,
    LOGIN                          DB_INFRAESTRUCTURA.INFO_PUNTO.LOGIN%TYPE,
    TOTAL_ELEMENTO                 NUMBER);
  --
  TYPE Gr_DetalleElemento is RECORD(
    TXT_NO_DOCU                    NAF47_TNET.ARINME.NO_DOCU%TYPE,
    TXT_ESTADO                     VARCHAR2(30),
    SERIE_FISICA                   VARCHAR2(100),
    W_SERIE_FISICA                 VARCHAR2(100),
    MAC                            VARCHAR2(100),
    W_MAC                          VARCHAR2(100),
    ID_ELEMENTO                    DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_TIPO_ELEMENTO           DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE, --VARCHAR2(150),
    NOMBRE_MODELO_ELEMENTO         DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    CKB_IND_MAC                    VARCHAR2(1),
    TXT_ARTICULO                   NAF47_TNET.ARINDA.NO_ARTI%TYPE,
    TXT_DESC_ARTICULO              NAF47_TNET.ARINDA.DESCRIPCION%TYPE,
    TXT_CODIGO_BODEGA              NAF47_TNET.ARINBO.CODIGO%TYPE,
    TXT_DESC_BODEGA                NAF47_TNET.ARINBO.DESCRIPCION%TYPE,
    TXT_ASIGNADO_ARINME            NAF47_TNET.ARINME.EMPLE_SOLIC%TYPE,
    TXT_CEDULA_ASIGNADO_RESPONSABL NAF47_TNET.ARPLME.CEDULA%TYPE,
    TXT_NO_CIA_RESPONSABLE         NAF47_TNET.ARINME.NO_CIA_RESPONSABLE%TYPE,
    CKB_ASIGNADO_CLIENTE           VARCHAR2(1),
    DETALLE_ELEMENTO_ID            DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO.ID_DETALLE_ELEMENTO%TYPE
    );

  /**
  * Documentacion para NAF47_TNET.INK_PROCESA_PEDIDOS.Gt_Procesa_Pedido
  * Variable Tipo Tabla que permite pasar por parametro detalle de articulos para procesar despachos de pedidos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/09/2016
  */
  TYPE Gt_DetalleElemento IS TABLE of Gr_DetalleElemento;
  --
  /**
  * Documentacion para P_PROCESAR
  * Procedimiento procesa retiro de equipos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/11/2020
  *
  * @param Pr_FiltroElemento  IN VARCHAR2     Recibe parametro tipo registro con informaci�n filtro de busqueda de elementos
  * @param Pr_DetalleElemento IN VARCHAR2     Recibe parametro tipo registro con informacion detallada de elemento
  * @param Pv_MensajeError    IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_PROCESAR (Pr_FiltroElemento  IN OUT INKG_RETIRO_EQUIPO.Gr_FiltroElemento,
                        Pr_DetalleElemento IN OUT INKG_RETIRO_EQUIPO.Gt_DetalleElemento,
                        Pv_MensajeError    IN OUT VARCHAR2);


end INKG_RETIRO_EQUIPO;
/

CREATE EDITIONABLE package body            INKG_RETIRO_EQUIPO is
  --
  ASIGNADO CONSTANT VARCHAR2(08) := 'Asignado';
  --
  /**
  * Documentacion para P_PRE_REQUISITO_RETIRO
  * Procedimiento valida la informaci�n necesaria para procear retiro de equipos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/11/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 01/12/2021 - Se modifica para validar que los registros control custodio pertenezcan al nuevo flujo Instalaciones Nodos
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 17/01/2022 - Se modifica para considerar nuevo flujo Retiro/Cambio de equipos de Nodos
  *
  * @param Pr_FiltroElemento  IN VARCHAR2     Recibe parametro tipo registro con informaci�n filtro de busqueda de elementos
  * @param Pr_DetalleElemento IN VARCHAR2     Recibe parametro tipo registro con informacion detallada de elemento
  * @param Pv_MensajeError    IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_PRE_REQUISITO_RETIRO(Pr_FiltroElemento  IN OUT INKG_RETIRO_EQUIPO.Gr_FiltroElemento,
                                   Pr_DetalleElemento IN OUT INKG_RETIRO_EQUIPO.Gt_DetalleElemento,
                                   Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    CURSOR C_NUMERO_SERIE(Cv_Serie Varchar2) IS
      SELECT SERIE
      FROM INV_NUMERO_SERIE
      WHERE SERIE = Cv_Serie;
    --
    CURSOR C_VERIFICA_REPOSITORIO(Cv_Serie Varchar2) IS
      SELECT NUMERO_SERIE
      FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
      WHERE A.NUMERO_SERIE = Cv_Serie;
    --
    CURSOR C_SECUENCIA(Cv_IdCompania Varchar2) IS
      SELECT MAX(ID_INSTALACION) + 1
      FROM IN_ARTICULOS_INSTALACION
      WHERE ID_COMPANIA = Cv_IdCompania;
    --
    CURSOR C_CUSTODIO(Lv_Cedula Varchar2) IS
      SELECT NO_EMPLE,
             NO_CIA
      FROM ARPLME
      WHERE CEDULA = Lv_Cedula
      AND ESTADO = 'A';
    --
    CURSOR C_CUSTODIO_CONTRATISTA (Cv_Cedula VARCHAR2,
                                   Cv_NoCia  VARCHAR2) IS
      SELECT NO_CONTRATISTA,
             NO_CIA
      FROM ARINMCNT
      WHERE CEDULA = Cv_Cedula
      AND NO_CIA = Cv_NoCia
      AND ESTADO = 'A';
    --
    CURSOR C_CEDULA_EMPLEADO(Cv_IdPersona VARCHAR2) IS
      SELECT IDENTIFICACION_CLIENTE
      FROM DB_COMERCIAL.INFO_PERSONA
      WHERE ID_PERSONA = Cv_IdPersona;
    --
    CURSOR C_FECHA_PROCESO_IN(Cv_NoCia  VARCHAR2,
                              Cv_Centro VARCHAR2) IS
      SELECT DIA_PROCESO
      FROM ARINCD
      WHERE NO_CIA = Cv_NoCia
      AND CENTRO = Cv_Centro;
    --
   	CURSOR C_ID_PERSONA (Cv_IdentifCliente Varchar2)IS
		  SELECT ID_PERSONA
			FROM DB_COMERCIAL.INFO_PERSONA
			WHERE IDENTIFICACION_CLIENTE = Cv_IdentifCliente;
    --
    CURSOR C_CONTROL_CUSTODIO ( Cv_NumeroSerie VARCHAR2 ) IS
      SELECT ACC.TIPO_CUSTODIO,
             ACC.CUSTODIO_ID,
             IPER.PERSONA_ID,
             IP.IDENTIFICACION_CLIENTE,
             ACC.EMPRESA_ID
      FROM DB_COMERCIAL.INFO_PERSONA IP,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.ARTICULO_ID = Cv_NumeroSerie
      AND ACC.ESTADO = ASIGNADO
      AND ACC.CANTIDAD > 0
      AND ACC.ID_CONTROL_ORIGEN IS NOT NULL
      AND IPER.PERSONA_ID = IP.ID_PERSONA
      AND ACC.CUSTODIO_ID = IPER.ID_PERSONA_ROL;
    --
    Lv_Serie          NAF47_TNET.INV_NUMERO_SERIE.SERIE%TYPE := NULL;
    Lv_NumeroSerie    NAF47_TNET.IN_ARTICULOS_INSTALACION.NUMERO_SERIE%TYPE := NULL;
    Ln_IdSecuencia    NAF47_TNET.IN_ARTICULOS_INSTALACION.ID_INSTALACION%TYPE := 0;
    Ln_IdPersona      DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE := 0;
    Lv_CedulaEmple    DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE := NULL;
    Ld_Fecha          NAF47_TNET.ARINCD.DIA_PROCESO%TYPE := NULL;
    Lr_Custodio       C_CUSTODIO%ROWTYPE := NULL;
    Lv_AsignadoArinme VARCHAR2(100);
    Ln_Contador       NUMBER:=0;
    Lr_ControlCustodio C_CONTROL_CUSTODIO%ROWTYPE;
    --
    Le_Error          EXCEPTION;
    --
  BEGIN
    --
    -------------------------------------------
    -------------------------------------------
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'LOG-RETIRO-EQUIPO',
                                         'INICIA PROCESO P_PRE_REQUISITO_RETIRO: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                         SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    -------------------------------------------
    -------------------------------------------
    IF Pr_FiltroElemento.TXT_TECNICO IS NOT NULL THEN
      --
      Ln_IdPersona := Pr_FiltroElemento.TXT_TECNICO;
      --
      IF C_CEDULA_EMPLEADO%ISOPEN THEN
        CLOSE C_CEDULA_EMPLEADO;
      END IF;
      OPEN C_CEDULA_EMPLEADO(Ln_IdPersona);
      FETCH C_CEDULA_EMPLEADO
        INTO Lv_CedulaEmple;
      IF C_CEDULA_EMPLEADO%FOUND THEN
        IF C_CUSTODIO%ISOPEN THEN
          CLOSE C_CEDULA_EMPLEADO;
        END IF;
        OPEN C_CUSTODIO(Lv_CedulaEmple);
        FETCH C_CUSTODIO
          INTO Lr_Custodio;
        CLOSE C_CUSTODIO;
      ELSE
        Pv_MensajeError := SUBSTR('No existe Id Empleado con cedula: ' || Lv_CedulaEmple, 1, 500);
        RAISE Le_Error;
      END IF;
      CLOSE C_CEDULA_EMPLEADO;
      --
    END IF;
    --
    --
    IF C_FECHA_PROCESO_IN%ISOPEN THEN
      CLOSE C_FECHA_PROCESO_IN;
    END IF;
    OPEN C_FECHA_PROCESO_IN(Pr_FiltroElemento.TXT_NOCIA,
                            Pr_FiltroElemento.TXT_CENTRO);
    FETCH C_FECHA_PROCESO_IN INTO Ld_Fecha;
    CLOSE C_FECHA_PROCESO_IN;
    --

    -- apertura de arreglo
    FOR Li_Elemento IN 1 .. Pr_DetalleElemento.LAST LOOP
      --
      -- Se valida si el numero de serie esta asignado en control custodio
      IF C_CONTROL_CUSTODIO%ISOPEN THEN
        CLOSE C_CONTROL_CUSTODIO;
      END IF;
      OPEN C_CONTROL_CUSTODIO(Pr_DetalleElemento(Li_Elemento).SERIE_FISICA);
      FETCH C_CONTROL_CUSTODIO INTO Lr_ControlCustodio;
      IF C_CONTROL_CUSTODIO%NOTFOUND THEN
        Lr_ControlCustodio := NULL;
      END IF;
      CLOSE C_CONTROL_CUSTODIO;
      --
      -- si existe en control custodio se redefine el usuario responsable de Ingreso a bodega
      IF NVL(Lr_ControlCustodio.Tipo_Custodio,'@') = 'Empleado' THEN
        --
        Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL := Lr_ControlCustodio.IDENTIFICACION_CLIENTE;
        Pr_FiltroElemento.REF_ASIGNADO_ID := Lr_ControlCustodio.Persona_Id;
        --
        IF C_CUSTODIO%ISOPEN THEN 
          CLOSE C_CUSTODIO; 
        END IF;
        OPEN C_CUSTODIO (Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL);
        FETCH C_CUSTODIO INTO Lr_Custodio;
        IF C_CUSTODIO%NOTFOUND THEN
          Pv_MensajeError := SUBSTR('No existe custodio con cedula: '||Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL,1,500);
          RAISE Le_Error;
        END IF;
        CLOSE C_CUSTODIO;
        --
        Pr_DetalleElemento(Li_Elemento).TXT_ASIGNADO_ARINME := Lr_Custodio.No_Emple;
        Lv_AsignadoArinme := Lr_Custodio.No_Emple;
        --
      ELSIF NVL(Lr_ControlCustodio.Tipo_Custodio,'@') = 'Contratista' THEN
        --
        Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL := Lr_ControlCustodio.IDENTIFICACION_CLIENTE;
        Pr_FiltroElemento.REF_ASIGNADO_ID := Lr_ControlCustodio.Persona_Id;
        --
        IF C_CUSTODIO_CONTRATISTA%ISOPEN THEN 
          CLOSE C_CUSTODIO_CONTRATISTA; 
        END IF;
        OPEN C_CUSTODIO_CONTRATISTA (Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL, Lr_ControlCustodio.Empresa_Id);
        FETCH C_CUSTODIO_CONTRATISTA INTO Lr_Custodio;
        IF C_CUSTODIO_CONTRATISTA%NOTFOUND THEN
          Pv_MensajeError := SUBSTR('No existe contratista con RUC/CI: '||Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL,1,500);
          RAISE Le_Error;
        END IF;
        CLOSE C_CUSTODIO_CONTRATISTA;
        --
        Pr_DetalleElemento(Li_Elemento).TXT_ASIGNADO_ARINME := Lr_Custodio.No_Emple;
        Lv_AsignadoArinme := Lr_Custodio.No_Emple;
        --
      END IF;


      --
      IF Ln_contador=0 THEN
        --
        Lv_AsignadoArinme := Pr_DetalleElemento(Li_Elemento).TXT_ASIGNADO_ARINME;
        --
        IF Ln_IdPersona=0 THEN
          --
          Lv_CedulaEmple := Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL;
          --
          IF C_CUSTODIO%ISOPEN THEN 
            CLOSE C_CUSTODIO; 
          END IF;
          OPEN C_CUSTODIO (Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL);
          FETCH C_CUSTODIO INTO Lr_Custodio;
          IF C_CUSTODIO%NOTFOUND THEN
            Pv_MensajeError := SUBSTR('No existe custodio con cedula: '||Pr_DetalleElemento(Li_Elemento).TXT_CEDULA_ASIGNADO_RESPONSABL,1,500);
            RAISE Le_Error;
          END IF;
          CLOSE C_CUSTODIO;
          --
          IF C_ID_PERSONA%ISOPEN THEN CLOSE C_ID_PERSONA; END IF;
          OPEN C_ID_PERSONA (Lv_CedulaEmple);
          FETCH C_ID_PERSONA INTO Pr_FiltroElemento.REF_ASIGNADO_ID;
          CLOSE C_ID_PERSONA;
          --
        END IF;
        --
      ELSE
        --
        IF Lv_AsignadoArinme != Pr_DetalleElemento(Li_Elemento).TXT_ASIGNADO_ARINME THEN
          Pv_MensajeError := 'Se debe asignar un solo empleado responsable';
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
      Ln_Contador:=Ln_Contador+1;
      --
      IF (Pr_DetalleElemento(Li_Elemento).SERIE_FISICA IS NULL OR 
          Pr_DetalleElemento(Li_Elemento).SERIE_FISICA = '0000' OR 
          Pr_DetalleElemento(Li_Elemento).SERIE_FISICA = '00000' OR 
          Pr_DetalleElemento(Li_Elemento).SERIE_FISICA = '000000' OR
          Pr_DetalleElemento(Li_Elemento).DETALLE_ELEMENTO_ID IS NOT NULL) AND  -- Si es serie temporal debe actualizar registros en elemento
          NVL(Pr_DetalleElemento(Li_Elemento).SERIE_FISICA, '@') <> Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA THEN
        --
        UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
        SET SERIE_FISICA = Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA
        WHERE ID_ELEMENTO = Pr_DetalleElemento(Li_Elemento).ID_ELEMENTO;
        --

        IF Pr_DetalleElemento(Li_Elemento).DETALLE_ELEMENTO_ID IS NOT NULL THEN
          --
          -- Se inhabilita caracteristica que indica que se debe generar serie
          UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
          SET IDE.ESTADO = 'Inactivo'
          WHERE IDE.ID_DETALLE_ELEMENTO = Pr_DetalleElemento(Li_Elemento).DETALLE_ELEMENTO_ID;
          --
          -- Se actualiza serie temporal en control custodio
          UPDATE NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
          SET ACC.ARTICULO_ID = Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA,
              ACC.ANTERIOR_ARTICULO_ID = Pr_DetalleElemento(Li_Elemento).SERIE_FISICA
          WHERE ACC.ARTICULO_ID = Pr_DetalleElemento(Li_Elemento).SERIE_FISICA;
          --
        END IF;
        --
        INSERT INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO
          (ID_HISTORIAL,
           ELEMENTO_ID,
           ESTADO_ELEMENTO,
           CAPACIDAD,
           OBSERVACION,
           USR_CREACION,
           IP_CREACION)
        VALUES
          (DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
           Pr_DetalleElemento(Li_Elemento).ID_ELEMENTO,
           'Activo',
           NULL,
           'Se actualiza la serie del elemento: ' || Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA ||
           ' Serie Anterior: ' || Pr_DetalleElemento(Li_Elemento).SERIE_FISICA,
           USER,
           GEK_CONSULTA.F_RECUPERA_IP);
        --
        IF C_NUMERO_SERIE%ISOPEN THEN
          CLOSE C_NUMERO_SERIE;
        END IF;
        OPEN C_NUMERO_SERIE(Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA);
        FETCH C_NUMERO_SERIE INTO Lv_Serie;
        CLOSE C_NUMERO_SERIE;
        --
        IF Lv_Serie IS NULL THEN
          --
          IF NVL(Pr_DetalleElemento(Li_Elemento).MAC, '@') != Pr_DetalleElemento(Li_Elemento).W_MAC AND
             Pr_DetalleElemento(Li_Elemento).CKB_IND_MAC = 'S' THEN
            --
            INSERT INTO NAF47_TNET.INV_NUMERO_SERIE
              (COMPANIA,
               SERIE,
               NO_ARTICULO,
               ESTADO,
               USUARIO_CREA,
               FECHA_CREA,
               MAC)
            VALUES
              (Pr_FiltroElemento.TXT_NOCIA,
               Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA,
               Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO,
               'FB',
               USER,
               SYSDATE,
               Pr_DetalleElemento(Li_Elemento).W_MAC);
            --
          ELSE
            --
            INSERT INTO NAF47_TNET.INV_NUMERO_SERIE
              (COMPANIA,
               SERIE,
               NO_ARTICULO,
               ESTADO,
               USUARIO_CREA,
               FECHA_CREA)
            VALUES
              (Pr_FiltroElemento.TXT_NOCIA,
               Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA,
               Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO,
               'FB',
               USER,
               SYSDATE);
          END IF;
          --
        END IF;
        --
        --
        IF C_VERIFICA_REPOSITORIO%ISOPEN THEN
          CLOSE C_VERIFICA_REPOSITORIO;
        END IF;
        OPEN C_VERIFICA_REPOSITORIO(Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA);
        FETCH C_VERIFICA_REPOSITORIO
          INTO Lv_NumeroSerie;
        CLOSE C_VERIFICA_REPOSITORIO;
        --
        IF Lv_NumeroSerie IS NULL THEN
          --
          IF C_SECUENCIA%ISOPEN THEN
            CLOSE C_SECUENCIA;
          END IF;
          OPEN C_SECUENCIA(Pr_FiltroElemento.TXT_NOCIA);
          FETCH C_SECUENCIA INTO Ln_IdSecuencia;
          CLOSE C_SECUENCIA;
          --
          IF NVL(Pr_DetalleElemento(Li_Elemento).MAC, '@') != Pr_DetalleElemento(Li_Elemento).W_MAC AND
             Pr_DetalleElemento(Li_Elemento).CKB_IND_MAC = 'S' THEN
            --
            INSERT INTO NAF47_TNET.IN_ARTICULOS_INSTALACION
              (PRECIO_VENTA,
               FE_CREACION,
               CEDULA,
               FECHA,
               ID_CUSTODIO,
               ESTADO,
               USR_CREACION,
               ID_CENTRO,
               NOMBRE_BODEGA,
               ID_BODEGA,
               COSTO,
               SECUENCIA,
               ID_INSTALACION,
               TIPO_PROCESO,
               ID_ARTICULO,
               DESCRIPCION,
               CANTIDAD,
               SALDO,
               TIPO_ARTICULO,
               ID_EMPRESA_CUSTODIO,
               ID_COMPANIA,
               MAC,
               NUMERO_SERIE,
               MODELO)
            VALUES
              (0,
               SYSDATE,
               Lv_CedulaEmple,
               Ld_Fecha,
               Lr_Custodio.No_Emple,
               'IN',
               USER,
               Pr_FiltroElemento.TXT_CENTRO,
               Pr_DetalleElemento(Li_Elemento).TXT_DESC_BODEGA,
               Pr_DetalleElemento(Li_Elemento).TXT_CODIGO_BODEGA,
               0.01,
               1,
               Ln_IdSecuencia,
               'IN',
               Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO,
               Pr_DetalleElemento(Li_Elemento).TXT_DESC_ARTICULO,
               1,
               0,
               'AF',
               Lr_Custodio.No_Cia,
               Pr_FiltroElemento.TXT_NOCIA,
               Pr_DetalleElemento(Li_Elemento).W_MAC,
               Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA,
               Pr_DetalleElemento(Li_Elemento).NOMBRE_MODELO_ELEMENTO);
          ELSE
            --
            INSERT INTO NAF47_TNET.IN_ARTICULOS_INSTALACION
              (PRECIO_VENTA,
               FE_CREACION,
               CEDULA,
               FECHA,
               ID_CUSTODIO,
               ESTADO,
               USR_CREACION,
               ID_CENTRO,
               NOMBRE_BODEGA,
               ID_BODEGA,
               COSTO,
               SECUENCIA,
               ID_INSTALACION,
               TIPO_PROCESO,
               ID_ARTICULO,
               DESCRIPCION,
               CANTIDAD,
               SALDO,
               TIPO_ARTICULO,
               ID_EMPRESA_CUSTODIO,
               ID_COMPANIA,
               NUMERO_SERIE,
               MODELO)
            VALUES
              (0,
               SYSDATE,
               Lv_CedulaEmple,
               Ld_Fecha,
               Lr_Custodio.No_Emple,
               'IN',
               USER,
               Pr_FiltroElemento.TXT_CENTRO,
               Pr_DetalleElemento(Li_Elemento).TXT_DESC_BODEGA,
               Pr_DetalleElemento(Li_Elemento).TXT_CODIGO_BODEGA,
               0.01,
               1,
               Ln_IdSecuencia,
               'IN',
               Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO,
               Pr_DetalleElemento(Li_Elemento).TXT_DESC_ARTICULO,
               1,
               0,
               'AF',
               Lr_Custodio.No_Cia,
               Pr_FiltroElemento.TXT_NOCIA,
               Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA,
               Pr_DetalleElemento(Li_Elemento).NOMBRE_MODELO_ELEMENTO);
          END IF;
          --
        END IF;
        --
      ELSIF NVL(Pr_DetalleElemento(Li_Elemento).SERIE_FISICA, '@') = Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA AND
            NVL(Pr_DetalleElemento(Li_Elemento).MAC, '@') <> Pr_DetalleElemento(Li_Elemento).W_MAC AND
            Pr_DetalleElemento(Li_Elemento).CKB_IND_MAC = 'S' THEN
        --
        UPDATE NAF47_TNET.INV_NUMERO_SERIE
        SET MAC = Pr_DetalleElemento(Li_Elemento).W_MAC
        WHERE SERIE = Pr_DetalleElemento(Li_Elemento).SERIE_FISICA
        AND NO_ARTICULO = Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO
        AND COMPANIA = Pr_FiltroElemento.TXT_NOCIA;
        --
        UPDATE NAF47_TNET.IN_ARTICULOS_INSTALACION
        SET MAC = Pr_DetalleElemento(Li_Elemento).W_MAC
        WHERE NUMERO_SERIE = Pr_DetalleElemento(Li_Elemento).SERIE_FISICA
        AND ID_ARTICULO = Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO
        AND ID_COMPANIA = Pr_FiltroElemento.TXT_NOCIA
        AND ESTADO = 'IN';
        --
      END IF;
      --
      IF NVL(Pr_DetalleElemento(Li_Elemento).MAC, '@') <> Pr_DetalleElemento(Li_Elemento).W_MAC AND
         Pr_DetalleElemento(Li_Elemento).CKB_IND_MAC = 'S' THEN
        --
        INSERT INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
          (ID_DETALLE_ELEMENTO,
           ELEMENTO_ID,
           DETALLE_NOMBRE,
           DETALLE_VALOR,
           DETALLE_DESCRIPCION,
           USR_CREACION,
           IP_CREACION,
           ESTADO)
        VALUES
          (DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL,
           Pr_DetalleElemento(Li_Elemento).ID_ELEMENTO,
           'MAC',
           Pr_DetalleElemento(Li_Elemento).W_MAC,
           'MAC',
           USER,
           GEK_CONSULTA.F_RECUPERA_IP,
           'Activo');
        --
      END IF;
      --
    END LOOP;
    --
    -------------------------------------------
    -------------------------------------------
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'LOG-RETIRO-EQUIPO',
                                         'FINALIZA PROCESO P_PRE_REQUISITO_RETIRO: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                         SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    -------------------------------------------
    -------------------------------------------

  EXCEPTION
    WHEN Le_Error THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.HOST),
                                                user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.IP_ADRESS),
                                                '127.0.0.1'));
      --
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.HOST),
                                                user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,
                                                            GEK_VAR.Gr_Sesion.IP_ADRESS),
                                                '127.0.0.1'));
      --
      ROLLBACK;
  END P_PRE_REQUISITO_RETIRO;

  /**
  * Documentacion para P_CREA_INGRESO_BODEGA
  * Procedimiento que genera transaccion ingreso a bodega en m�dulo de inventarios.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/11/2020
  *
  * @param Pr_FiltroElemento  IN VARCHAR2     Recibe parametro tipo registro con informaci�n filtro de busqueda de elementos
  * @param Pr_DetalleElemento IN VARCHAR2     Recibe parametro tipo registro con informacion detallada de elemento
  * @param Pv_MensajeError    IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */  
  PROCEDURE P_CREA_INGRESO_BODEGA (Pr_FiltroElemento  IN OUT INKG_RETIRO_EQUIPO.Gr_FiltroElemento,
                                   Pr_DetalleElemento IN OUT INKG_RETIRO_EQUIPO.Gt_DetalleElemento,
                                   Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    CURSOR C_TIPO_DOC (Cv_NoCia  VARCHAR2) IS
      SELECT PARAMETRO
      FROM NAF47_TNET.GE_PARAMETROS
      WHERE ID_APLICACION = 'IN'
      AND ID_GRUPO_PARAMETRO = 'DOC_RETIRO_EQ'
      AND DESCRIPCION = 'ING.  EQUIP  RETIRADOS/CLIENTES'
      AND ID_EMPRESA = Cv_NoCia ;
    --
    CURSOR C_DATOS_PERIODO ( Cv_Centro VARCHAR2,
                             Cv_NoCia  VARCHAR2) IS
      SELECT P.ANO_PROCE,
             P.DIA_PROCESO,
             P.MES_PROCE,
             C.CLASE_CAMBIO
      FROM NAF47_TNET.ARINCD P,
           NAF47_TNET.ARCGMC C
      WHERE P.NO_CIA = C.NO_CIA
      AND P.CENTRO = Cv_Centro
      AND P.NO_CIA = Cv_NoCia;
    --
    CURSOR C_CODIGO_EMPLEADO(Cv_NoCia     VARCHAR2,
                             Cv_IdPersona VARCHAR2)IS
      SELECT NO_EMPLE 
      FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS
      WHERE CEDULA IN (SELECT IDENTIFICACION_CLIENTE
                       FROM DB_COMERCIAL.INFO_PERSONA
                       WHERE ID_PERSONA = Cv_IdPersona)
      AND NO_CIA = Cv_NoCia;     
    -- 
    CURSOR C_SEC_ARINML (Cv_NoDocumento VARCHAR2,
                       Cv_NoCia       VARCHAR2) IS
      SELECT MAX(A.LINEA)
      FROM NAF47_TNET.ARINML A
      WHERE A.NO_DOCU = Cv_NoDocumento
      AND A.NO_CIA = Cv_NoCia;
    --
    CURSOR C_SEC_NUMERO_SERIE (Cv_NoDocumento VARCHAR2,
                               Cv_NoCia       VARCHAR2) IS
      SELECT MAX(A.LINEA)
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
      WHERE A.NO_DOCUMENTO = Cv_NoDocumento
      AND A.COMPANIA = Cv_NoCia;
    --
    CURSOR C_MAC(ElementoId Number)IS
      SELECT UPPER(DETALLE_VALOR)
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID = ElementoId
      AND DETALLE_NOMBRE = 'MAC';     
    --
    CURSOR C_EXISTE_SOL(Cn_NoSolRetEq Number,
                        Cn_NoCia      Varchar2)IS 
      SELECT 'X' 
      FROM NAF47_TNET.ARINME
      WHERE NO_SOL_RET_EQ = Cn_NoSolRetEq
      AND NO_CIA = Cn_NoCia;
    --
    CURSOR C_DOCUMENTO (Cn_NoSolRetEq Number)IS
      SELECT * 
      FROM NAF47_TNET.ARINME
      WHERE NO_SOL_RET_EQ = Cn_NoSolRetEq;
    --
    CURSOR C_MONTODIGITADO (Cn_NoDocu  Number,
                            Cv_NoCia   Varchar2,
                            Cv_Centro  Varchar2,
                            Cv_TipoDoc Varchar2)IS
      SELECT SUM(MONTO) 
      FROM NAF47_TNET.ARINML 
      WHERE NO_DOCU  = Cn_NoDocu
      AND NO_CIA   = Cv_NoCia
      AND CENTRO   = Cv_Centro
      AND TIPO_DOC = Cv_TipoDoc;
    --
    Lr_Arinme                   NAF47_TNET.ARINME%ROWTYPE := NULL;
    Lr_Arinml                   NAF47_TNET.ARINML%ROWTYPE := NULL;
    Lr_InvPreIngresoNumeroSerie NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE := NULL;
    Lv_TipoDocumento            NAF47_TNET.GE_PARAMETROS.PARAMETRO%TYPE:= NULL;
    Lr_DatosPeriodo             C_DATOS_PERIODO%ROWTYPE := NULL;
    Ld_FechaAux                 DATE := NULL;
    Lv_NoEmple                  NAF47_TNET.V_EMPLEADOS_EMPRESAS.NO_EMPLE%TYPE:= NULL;
    Lv_DetalleValor             DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE:= NULL;
    Ln_MontoDigitadoCompra      NAF47_TNET.ARINME.MONTO_DIGITADO_COMPRA%TYPE := 0;
    Ln_NoDocumento              NAF47_TNET.ARINME.No_Docu%TYPE := 0;
    Lv_IdBodega                 NAF47_TNET.ARINME.Id_Bodega%TYPE := NULL;
    Ln_Nocia                    NAF47_TNET.ARINME.No_Cia%TYPE := 0;
    Ln_Centro                   NAF47_TNET.ARINME.Centro%TYPE := NULL;
    Lr_Documento                C_DOCUMENTO%ROWTYPE:= NULL;

    Lv_Existe                   Varchar2(1):= NULL;
    Le_Error                    EXCEPTION;


  BEGIN
    --
    -------------------------------------------
    -------------------------------------------
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'LOG-RETIRO-EQUIPO',
                                         'INICIA PROCESO P_CREA_INGRESO_BODEGA: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                         SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    -------------------------------------------
    -------------------------------------------
    --
    IF C_TIPO_DOC%ISOPEN THEN CLOSE C_TIPO_DOC; END IF;
    OPEN C_TIPO_DOC(Pr_FiltroElemento.TXT_NOCIA);
    FETCH C_TIPO_DOC INTO Lv_TipoDocumento;
    CLOSE C_TIPO_DOC;
    --      
    IF C_CODIGO_EMPLEADO%ISOPEN THEN CLOSE C_CODIGO_EMPLEADO; END IF;
    OPEN C_CODIGO_EMPLEADO (Pr_FiltroElemento.TXT_NOCIA,Pr_FiltroElemento.REF_ASIGNADO_ID);
    FETCH C_CODIGO_EMPLEADO INTO Lv_NoEmple;
    CLOSE C_CODIGO_EMPLEADO;
    --
    FOR Li_Elemento IN 1 .. Pr_DetalleElemento.LAST LOOP

      IF C_EXISTE_SOL%ISOPEN THEN CLOSE C_EXISTE_SOL; END IF;
      OPEN C_EXISTE_SOL(Pr_FiltroElemento.ID_DETALLE_SOLICITUD,Pr_FiltroElemento.TXT_NOCIA);
      FETCH C_EXISTE_SOL INTO Lv_Existe;
      CLOSE C_EXISTE_SOL;
      --
      IF NVL(Lv_Existe,'@') <> 'X' THEN
        --
        Lr_Arinme.No_Cia := Pr_FiltroElemento.TXT_NOCIA;
        Lr_Arinme.No_Cia_Responsable := Pr_DetalleElemento(Li_Elemento).TXT_NO_CIA_RESPONSABLE;
        Lr_Arinme.Centro := Pr_FiltroElemento.TXT_CENTRO;
        Lr_Arinme.Tipo_Doc := Lv_TipoDocumento;
        Lr_Arinme.Ruta := '0000';
        Lr_Arinme.Estado := 'P';
        Lr_Arinme.Origen := 'IN';
        Lr_Arinme.No_Sol_Ret_Eq := Pr_FiltroElemento.ID_DETALLE_SOLICITUD;
        Lr_Arinme.Id_Bodega := Pr_DetalleElemento(Li_Elemento).TXT_CODIGO_BODEGA;
        Lr_Arinme.Observ1 := 'INGRESO POR FINALIZACION DE RETIRO DE EQUIPOS #'|| Pr_FiltroElemento.ID_DETALLE_SOLICITUD|| ' LOGIN: '||Pr_FiltroElemento.LOGIN;

        IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
        OPEN C_DATOS_PERIODO (Pr_FiltroElemento.TXT_CENTRO,
                              Pr_FiltroElemento.TXT_NOCIA);
        FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
        IF C_DATOS_PERIODO%NOTFOUND THEN
          Pv_MensajeError := 'La definici\F3n del calendario del inventario es incorrecta.';
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PERIODO;

        Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lr_DatosPeriodo.Clase_Cambio,
                                             Lr_DatosPeriodo.Dia_Proceso,
                                             Ld_FechaAux,
                                             'C');
        --
        Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
        Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
        Lr_Arinme.Emple_Solic := Pr_DetalleElemento(Li_Elemento).TXT_ASIGNADO_ARINME;     

        Lr_Arinme.No_Docu := Transa_Id.Inv(Lr_Arinme.No_Cia);
        --:PARAMETER.No_Docu:=Lr_Arinme.No_Docu ;
        Lr_Arinme.No_Fisico := NAF47_TNET.SEQ_FRM_IM.NEXTVAL;--Consecutivo.INV(Lr_Arinme.No_Cia, Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'NUMERO');
        Lr_Arinme.Serie_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia,  Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'SERIE');
        --
        Ln_NoDocumento := Lr_Arinme.No_Docu;
        Ln_Nocia       := Lr_Arinme.No_Cia;
        Ln_Centro      := Lr_Arinme.Centro;
        Lv_IdBodega    := Lr_Arinme.Id_Bodega;
        --
        NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINME(Lr_Arinme,
                                                     Pv_MensajeError); 
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        Pr_DetalleElemento(Li_Elemento).TXT_NO_DOCU:= Ln_NoDocumento;
      --JXZURITA Inicio 12/04/2023
      --Si ya existe el movimiento de inventario obtener el numero de documento
      else
            begin
              SELECT a.no_docu into Ln_NoDocumento
              FROM NAF47_TNET.ARINME a
              WHERE NO_SOL_RET_EQ = Pr_FiltroElemento.ID_DETALLE_SOLICITUD
              AND NO_CIA = Pr_FiltroElemento.TXT_NOCIA
              and rownum <=1;
            exception
            when no_data_found then
              Ln_NoDocumento := null;
            when others then
              Ln_NoDocumento := null;
            end;
      --JXZURITA Fin 12/04/2023
      END IF;
      --
      Pr_DetalleElemento(Li_Elemento).TXT_NO_DOCU:= Ln_NoDocumento;
      --
      IF Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA IS NOT NULL  
        AND Pr_DetalleElemento(Li_Elemento).NOMBRE_TIPO_ELEMENTO <> 'ROSETA'
        AND Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO IS NOT NULL 
        AND Pr_DetalleElemento(Li_Elemento).TXT_ESTADO <> 'NO ENTREGADO' THEN
        --
        IF  Ln_Nocia = Pr_FiltroElemento.TXT_NOCIA THEN
          --
          Lr_Arinml.No_Arti := Pr_DetalleElemento(Li_Elemento).TXT_ARTICULO ;
          Lr_Arinml.No_Cia := Ln_Nocia;
          Lr_Arinml.Centro := Ln_Centro;
          Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
          Lr_Arinml.Periodo := Lr_Arinme.Periodo;
          Lr_Arinml.Ruta := Lr_Arinme.Ruta;
          Lr_Arinml.No_Docu := Ln_NoDocumento;
          Lr_Arinml.Bodega := Lv_IdBodega;
          Lr_Arinml.Unidades := 1;
          Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
          Lr_Arinml.Ind_Oferta := 'N';
          Lr_Arinml.Ind_IV := 'N';
          Lr_Arinml.Monto:=0.01;
          Lr_Arinml.Monto_Dol:=0.01;
          Lr_Arinml.Monto2:=0.01;
          Lr_Arinml.Monto2_Dol:=0.01;
          Lr_Arinml.Time_Stamp:= Sysdate;
          --

          -- se recupera la secuencia correspondiente
          IF C_SEC_ARINML%ISOPEN THEN CLOSE C_SEC_ARINML; END IF;
          OPEN C_SEC_ARINML( Lr_Arinml.No_Docu,
                             Lr_Arinml.No_Cia);
          FETCH C_SEC_ARINML INTO Lr_Arinml.Linea;
          CLOSE C_SEC_ARINML;
          --
          Lr_Arinml.Linea := nvl(Lr_Arinml.Linea,0) + 1;
          Lr_Arinml.Linea_Ext := Lr_Arinml.Linea;
          --
          -- insertar detalle documento inventario --
          NAF47_TNET.INKG_TRANSACCION.P_INSERTA_ARINML(Lr_Arinml,
                                                       Pv_MensajeError);   
          --
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --
          Lr_InvPreIngresoNumeroSerie.Compania     := Ln_Nocia;
          Lr_InvPreIngresoNumeroSerie.No_Documento := Ln_NoDocumento; 
          Lr_InvPreIngresoNumeroSerie.No_Articulo  := Lr_Arinml.No_Arti;
          Lr_InvPreIngresoNumeroSerie.Serie        := Pr_DetalleElemento(Li_Elemento).W_SERIE_FISICA;
          Lr_InvPreIngresoNumeroSerie.Mac          := Pr_DetalleElemento(Li_Elemento).W_MAC;
          Lr_InvPreIngresoNumeroSerie.Origen       := 'IN';
          Lr_InvPreIngresoNumeroSerie.Usuario_Crea := User;
          Lr_InvPreIngresoNumeroSerie.Fecha_Crea   := Sysdate;
          --
          IF C_MAC%ISOPEN THEN 
            CLOSE C_MAC; 
          END IF;
          OPEN C_MAC(Pr_DetalleElemento(Li_Elemento).ID_ELEMENTO);
          FETCH C_MAC INTO Lv_DetalleValor;
          IF Lv_DetalleValor IS NOT NULL THEN
             Lr_InvPreIngresoNumeroSerie.MAC   := Lv_DetalleValor;
          END IF;
          CLOSE C_MAC;            
          --
          IF C_SEC_NUMERO_SERIE%ISOPEN THEN CLOSE C_SEC_NUMERO_SERIE; END IF;
          OPEN C_SEC_NUMERO_SERIE( Lr_Arinml.No_Docu,
                             Lr_Arinml.No_Cia);
          FETCH C_SEC_NUMERO_SERIE INTO Lr_InvPreIngresoNumeroSerie.Linea;
          CLOSE C_SEC_NUMERO_SERIE;
          --
          Lr_InvPreIngresoNumeroSerie.Linea := nvl(Lr_InvPreIngresoNumeroSerie.Linea,0) + 1;    
          --
          NAF47_TNET.INKG_TRANSACCION.P_INSERTA_NUMERO_SERIE(Lr_InvPreIngresoNumeroSerie,
                                                             Pv_MensajeError);
          --
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --
        END IF;
        --
      END IF;                      
      --
      --          
  END LOOP;
  -------------------------------------------
  -------------------------------------------
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                       'LOG-RETIRO-EQUIPO',
                                       'P_CREA_INGRESO_BODEGA - INICIO ACTUALIZA DOCUMENTOS: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                       SYSDATE,
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  -------------------------------------------
  -------------------------------------------

  FOR Lr_Documento IN C_DOCUMENTO(Pr_FiltroElemento.ID_DETALLE_SOLICITUD) LOOP
    --
    IF C_MONTODIGITADO%ISOPEN THEN CLOSE C_MONTODIGITADO; END IF;
    OPEN C_MONTODIGITADO (Lr_Documento.No_Docu, Lr_Documento.No_Cia, Lr_Documento.Centro, Lr_Documento.Tipo_Doc);
    FETCH C_MONTODIGITADO INTO Ln_MontoDigitadoCompra;
    CLOSE C_MONTODIGITADO; 
    --
    UPDATE NAF47_TNET.ARINME
    SET MONTO_DIGITADO_COMPRA = NVL(Ln_MontoDigitadoCompra,0)
    WHERE NO_CIA   = Lr_Documento.No_Cia
    AND CENTRO   = Lr_Documento.Centro
    AND TIPO_DOC = Lr_Documento.Tipo_Doc
    AND NO_DOCU  = Lr_Documento.No_Docu;
    --
    INACTUALIZA(Lr_Documento.No_Cia, Lr_Documento.Tipo_Doc, Lr_Documento.No_Docu, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF; 
    --  
  END LOOP;
  --
  -------------------------------------------
  -------------------------------------------
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                       'LOG-RETIRO-EQUIPO',
                                       'FINALIZA PROCESO P_CREA_INGRESO_BODEGA Y ACTUALIZA DOCUMENTOS: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                       SYSDATE,
                                       NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  -------------------------------------------
  -------------------------------------------

  EXCEPTION
    WHEN Le_Error THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
      --
  END;

  /**
  * Documentacion para P_FINALIZA_SOLICITUD
  * Procedimiento que procesa la solicitud de retiro.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/11/2020
  *
  * @param Pr_FiltroElemento  IN VARCHAR2     Recibe parametro tipo registro con informaci�n filtro de busqueda de elementos
  * @param Pr_DetalleElemento IN VARCHAR2     Recibe parametro tipo registro con informacion detallada de elemento
  * @param Pv_MensajeError    IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */  
  PROCEDURE P_FINALIZA_SOLICITUD (Pr_FiltroElemento  IN OUT INKG_RETIRO_EQUIPO.Gr_FiltroElemento,
                                  Pr_DetalleElemento IN OUT INKG_RETIRO_EQUIPO.Gt_DetalleElemento,
                                  Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    CURSOR C_SERVICE (Cv_Parametro Varchar2)IS
      SELECT DESCRIPCION
      FROM NAF47_TNET.GE_PARAMETROS
      WHERE ID_EMPRESA         = Pr_FiltroElemento.TXT_NOCIA
      AND ID_APLICACION      = 'IN'
      AND ID_GRUPO_PARAMETRO = 'PARAM_SERVICE'
      AND PARAMETRO          = Cv_Parametro
      AND ESTADO             = 'A';
    --
     CURSOR C_CARACTERISTICA_RETIRO (Cv_Descripcion Varchar2) IS
       SELECT ID_CARACTERISTICA
       FROM DB_COMERCIAL.ADMI_CARACTERISTICA
       WHERE DESCRIPCION_CARACTERISTICA = Cv_Descripcion
       AND ESTADO = 'Activo';
    --
    CURSOR C_CEDULA_EMPLEADO(Cv_IdPersona VARCHAR2)IS
      SELECT IDENTIFICACION_CLIENTE
      FROM DB_COMERCIAL.INFO_PERSONA
      WHERE ID_PERSONA = Cv_IdPersona;
    --
    CURSOR C_ELEMENTO(Cv_SerieFisica Varchar2)IS
      SELECT ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE SERIE_FISICA = Cv_SerieFisica;
    --
    CURSOR C_INFO_DETALLE_SOL_CARACT(Cn_DetalleSolicitudId Number,
                                     Cv_Valor              Varchar2)IS
      SELECT ID_SOLICITUD_CARACTERISTICA 
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT 
      WHERE DETALLE_SOLICITUD_ID  = Cn_DetalleSolicitudId
      AND VALOR = Cv_Valor;
    --
    CURSOR C_ARTICULO (Cv_NoCia     VARCHAR2,
                       Cv_NoSerie   VARCHAR2)IS
      SELECT ID_ARTICULO
      FROM NAF47_TNET.IN_ARTICULOS_INSTALACION
      WHERE ID_COMPANIA = Cv_NoCia
      AND NUMERO_SERIE = Cv_NoSerie
      ORDER BY ID_INSTALACION DESC;  
    --
    CURSOR C_ARTI_USADO(Cv_NoCia     VARCHAR2,
                        Cv_NoArti    VARCHAR2)IS
      SELECT NO_ARTI_USADO
      FROM NAF47_TNET.ARINDA 
      WHERE NO_ARTI = Cv_NoArti
      AND NO_CIA  = Cv_NoCia;
    --
    CURSOR C_LOGIN (Cn_IdPersona Number)IS
      SELECT LOGIN 
      FROM DB_COMERCIAL.INFO_PERSONA
      WHERE ID_PERSONA =Cn_IdPersona;
    --
    Lv_UserName                  Varchar2(20)  := NULL;
    Lv_Password                  Varchar2(20)  := NULL;
    Lv_Name                      Varchar2(20)  := NULL;
    Lv_URLToken                  Varchar2(100) := NULL;
    Lv_URLRetiro                 Varchar2(100) := NULL;
    Ln_IdCaracteristicaEstado    DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE:=0;
    Ln_IdCaracteristicaCustodio  DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE:=0;
    Ln_IdPersona                 DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE:=0;
    Lv_CedulaEmple               DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE:=NULL;
    Ln_IdSolicitudCarac          DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE:=0;
    Ln_IdElemento                DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE:= 0;
    Ln_NoEntregado               Number        :=0;
    Lv_ObsInfoDetalle            Varchar2(500) := NULL;
    Lv_IdArticulo                NAF47_TNET.IN_ARTICULOS_INSTALACION.ID_ARTICULO%TYPE:=NULL;
    Lv_NoArtiUsado               NAF47_TNET.IN_ARTICULOS_INSTALACION.ID_ARTICULO%TYPE:=NULL;
    Lv_NoArticulo                NAF47_TNET.IN_ARTICULOS_INSTALACION.ID_ARTICULO%TYPE:=NULL;
    Lv_LoginEmple                DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE:=NULL;
    Lv_IdAplicacion              Varchar2(2)   := 'IN';
    Lv_IdGrupoParametro          Varchar2(20)  := 'TAREA_RET_EQUIPOS';
    Lv_NoCia                     Varchar2(2)   := '10';
    --
    Le_Error EXCEPTION;

  BEGIN  
    -------------------------------------------
    -------------------------------------------
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'LOG-RETIRO-EQUIPO',
                                         'INICIA PROCESO P_FINALIZA_SOLICITUD: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                         SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    -------------------------------------------
    -------------------------------------------
    --
    IF C_SERVICE%ISOPEN THEN CLOSE C_SERVICE; END IF;
    OPEN C_SERVICE ('NAME');
    FETCH C_SERVICE INTO Lv_Name;
    CLOSE C_SERVICE;
    --
    IF C_SERVICE%ISOPEN THEN CLOSE C_SERVICE; END IF;
    OPEN C_SERVICE ('PASSWORD');
    FETCH C_SERVICE INTO Lv_Password;
    CLOSE C_SERVICE;
    --
    IF C_SERVICE%ISOPEN THEN CLOSE C_SERVICE; END IF;
    OPEN C_SERVICE ('URL_RETIRO');
    FETCH C_SERVICE INTO Lv_URLRetiro;
    CLOSE C_SERVICE;
      --
    IF C_SERVICE%ISOPEN THEN CLOSE C_SERVICE; END IF;
    OPEN C_SERVICE ('URL_TOKEN');
    FETCH C_SERVICE INTO Lv_URLToken;
    CLOSE C_SERVICE;

    IF C_SERVICE%ISOPEN THEN CLOSE C_SERVICE; END IF;
    OPEN C_SERVICE ('USERNAME');
    FETCH C_SERVICE INTO Lv_UserName;
    CLOSE C_SERVICE;
    --
    IF C_CARACTERISTICA_RETIRO%ISOPEN THEN CLOSE C_CARACTERISTICA_RETIRO; END IF;
    OPEN C_CARACTERISTICA_RETIRO ('RETIRO_ID_CUSTODIO_ASIGNADO');
    FETCH C_CARACTERISTICA_RETIRO INTO Ln_IdCaracteristicaCustodio;
    CLOSE C_CARACTERISTICA_RETIRO;
    --
    IF C_CARACTERISTICA_RETIRO%ISOPEN THEN CLOSE C_CARACTERISTICA_RETIRO; END IF;
    OPEN C_CARACTERISTICA_RETIRO ('RETIRO_ESTADO_ELEMENTO');
    FETCH C_CARACTERISTICA_RETIRO INTO Ln_IdCaracteristicaEstado;
    CLOSE C_CARACTERISTICA_RETIRO;
    --
    IF Pr_FiltroElemento.TXT_TECNICO IS NULL THEN
      --
      Ln_IdPersona := Pr_FiltroElemento.REF_ASIGNADO_ID;
    ELSE
      Ln_IdPersona := Pr_FiltroElemento.TXT_TECNICO;
    END IF;
    --
    IF C_CEDULA_EMPLEADO%ISOPEN THEN CLOSE C_CEDULA_EMPLEADO; END IF;
    OPEN C_CEDULA_EMPLEADO (Ln_IdPersona);
    FETCH C_CEDULA_EMPLEADO INTO Lv_CedulaEmple;
    CLOSE C_CEDULA_EMPLEADO;
    --
    -- apertura de arreglo
    FOR Li_Elemento IN 1 .. Pr_DetalleElemento.LAST LOOP
      -----------------------------------------
      -----------------------------------------
      Ln_IdSolicitudCarac:=0;
      --
      IF Pr_DetalleElemento(Li_Elemento).CKB_ASIGNADO_CLIENTE = 'S' THEN
        --
        IF C_ELEMENTO%ISOPEN THEN 
          CLOSE C_ELEMENTO; 
        END IF;
        OPEN C_ELEMENTO(Pr_DetalleElemento(Li_Elemento).SERIE_FISICA);
        FETCH C_ELEMENTO INTO Ln_IdElemento;
        CLOSE C_ELEMENTO;
        --
        IF C_INFO_DETALLE_SOL_CARACT%ISOPEN THEN 
          CLOSE C_INFO_DETALLE_SOL_CARACT;
        END IF;
        OPEN C_INFO_DETALLE_SOL_CARACT(Pr_FiltroElemento.ID_DETALLE_SOLICITUD, Ln_IdElemento);
        FETCH C_INFO_DETALLE_SOL_CARACT INTO Ln_IdSolicitudCarac;
        CLOSE C_INFO_DETALLE_SOL_CARACT;
        --
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT 
          (ID_SOLICITUD_CARACTERISTICA,
           CARACTERISTICA_ID,
           VALOR,
           DETALLE_SOLICITUD_ID,
           ESTADO,
           USR_CREACION,
           DETALLE_SOL_CARACT_ID)
        VALUES 
          (DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
           Ln_IdCaracteristicaEstado, 
           Pr_DetalleElemento(Li_Elemento).TXT_ESTADO,
           Pr_FiltroElemento.ID_DETALLE_SOLICITUD,
           'Finalizada',
           USER,
           Ln_IdSolicitudCarac);   
        --      
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT 
          (ID_SOLICITUD_CARACTERISTICA,
           CARACTERISTICA_ID,
           VALOR,
           DETALLE_SOLICITUD_ID,
           ESTADO,
           USR_CREACION,
           DETALLE_SOL_CARACT_ID)
        VALUES 
          (DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
           Ln_IdCaracteristicaCustodio, 
           Ln_IdPersona,
           Pr_FiltroElemento.ID_DETALLE_SOLICITUD,
           'Finalizada',
           USER,
           Ln_IdSolicitudCarac); 
        --
        IF Pr_DetalleElemento(Li_Elemento).TXT_ESTADO = 'NO ENTREGADO' THEN
          Ln_NoEntregado:= Ln_NoEntregado+1;
          Lv_ObsInfoDetalle:= 'Equipo: '||Pr_DetalleElemento(Li_Elemento).NOMBRE_TIPO_ELEMENTO ||
                              ' Serie: '||Pr_DetalleElemento(Li_Elemento).SERIE_FISICA||
                              ' NO ENTREGADO en login: '||Pr_FiltroElemento.LOGIN||' '||Lv_ObsInfoDetalle;
        END IF;   
        --
      ELSE
        --
        IF C_ARTICULO%ISOPEN THEN 
          CLOSE C_ARTICULO; 
        END IF;
        OPEN C_ARTICULO(Pr_FiltroElemento.TXT_NOCIA,
                        Pr_DetalleElemento(Li_Elemento).SERIE_FISICA);
        FETCH C_ARTICULO INTO Lv_IdArticulo;
        CLOSE C_ARTICULO;
        --
        IF C_ARTI_USADO%ISOPEN THEN 
          CLOSE C_ARTI_USADO; 
        END IF;
        OPEN C_ARTI_USADO(Pr_FiltroElemento.TXT_NOCIA,
                          Lv_IdArticulo);
        FETCH C_ARTI_USADO INTO Lv_NoArtiUsado;
        IF Lv_NoArtiUsado IS NOT NULL THEN
         Lv_NoArticulo := Lv_NoArtiUsado;
        ELSE
         Lv_NoArticulo := Lv_IdArticulo ;
        END IF;
        CLOSE C_ARTI_USADO;

        NAF47_TNET.AFK_PROCESOS.IN_P_RETIRA_INSTALACION( Pr_FiltroElemento.TXT_NOCIA,
                                                         Lv_NoArticulo,
                                                         'AF',
                                                         Lv_CedulaEmple,
                                                         Pr_DetalleElemento(Li_Elemento).SERIE_FISICA,
                                                         1,
                                                         'RE',
                                                         Pv_MensajeError);  
        IF Pv_MensajeError IS NULL THEN
          INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST 
            (ID_SOLICITUD_HISTORIAL,
             DETALLE_SOLICITUD_ID,
             ESTADO,
             OBSERVACION,
             USR_CREACION,
             IP_CREACION)
       VALUES 
         (DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
          Pr_FiltroElemento.ID_DETALLE_SOLICITUD,
          'Finalizada',
          'Elemento no asignado a Cliente '||Pr_DetalleElemento(Li_Elemento).NOMBRE_TIPO_ELEMENTO||' '||Pr_DetalleElemento(Li_Elemento).SERIE_FISICA||' '||Pr_DetalleElemento(Li_Elemento).NOMBRE_MODELO_ELEMENTO,
          USER,
          GEK_CONSULTA.F_RECUPERA_IP);     
       ELSE
         RAISE Le_Error;          
       END IF;    
       --
     END IF;
     --
    END LOOP;
    --
    --
    IF Pr_FiltroElemento.TXT_LOGIN_EMPLE IS NULL THEN
      IF C_LOGIN%ISOPEN THEN 
        CLOSE C_LOGIN; 
      END IF;
      OPEN C_LOGIN(Pr_FiltroElemento.REF_ASIGNADO_ID);
      FETCH C_LOGIN INTO Lv_LoginEmple;
      CLOSE C_LOGIN;         
    ELSE 
      Lv_LoginEmple := Pr_FiltroElemento.TXT_LOGIN_EMPLE;
    END IF;

    IF Pr_FiltroElemento.TOTAL_ELEMENTO >= Ln_NoEntregado THEN 

       P_CREA_INGRESO_BODEGA (Pr_FiltroElemento,
                              Pr_DetalleElemento,
                              Pv_MensajeError);

      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;      
    END IF;

    INKG_TRANSACCION.P_FINALIZA_SOLICITUD_RETIROS(Pr_FiltroElemento.ID_DETALLE_SOLICITUD,
                                                  Pr_FiltroElemento.TXT_NOCIA,
                                                  Lv_LoginEmple,
                                                  Lv_URLToken,
                                                  Lv_UserName,
                                                  Lv_Password,
                                                  Lv_Name,
                                                  Lv_URLRetiro,
                                                  Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError:=SUBSTR('P_FINALIZA_SOLICITUD_RETIROS. '||Pv_MensajeError,1,500);
      RAISE Le_Error;
    ELSE
      --caso contrario

     IF Ln_NoEntregado >=1 THEN
        --        
        NAF47_TNET.GEKG_TRANSACCION.P_CREA_TAREA(Lv_IdAplicacion,
                                                 Lv_NoCia, --siempre se procesa como empresa telconet
                                                 Lv_IdGrupoParametro,
                                                 Lv_ObsInfoDetalle,
                                                 Pr_FiltroElemento.ID_DETALLE_SOLICITUD,
                                                 Pr_FiltroElemento.LOGIN,
                                                 Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
         Pv_MensajeError:=SUBSTR('Error en GEKG_TRANSACCION.P_CREA_TAREA. '||Pv_MensajeError,1,500);
              RAISE Le_Error;
        END IF;
     END IF;
    END IF;
    --
    -------------------------------------------
    -------------------------------------------
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                         'LOG-RETIRO-EQUIPO',
                                         'FINALIZA PROCESO P_FINALIZA_SOLICITUD: '||TO_CHAR(SYSTIMESTAMP, 'DD-MM-RRRR HH24:MI:SSxFF'),
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                         SYSDATE,
                                         NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    -------------------------------------------
    -------------------------------------------
  EXCEPTION
    WHEN Le_Error THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
  END;
  ----------------------------
  ----------------------------
  ----------------------------
  PROCEDURE P_PROCESAR (Pr_FiltroElemento  IN OUT INKG_RETIRO_EQUIPO.Gr_FiltroElemento,
                        Pr_DetalleElemento IN OUT INKG_RETIRO_EQUIPO.Gt_DetalleElemento,
                        Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    P_PRE_REQUISITO_RETIRO (Pr_FiltroElemento,
                            Pr_DetalleElemento,
                            Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    --
    P_FINALIZA_SOLICITUD (Pr_FiltroElemento,
                          Pr_DetalleElemento,
                          Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INKG_RETIRO_EQUIPO.P_PRE_REQUISITO_RETIRO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      ROLLBACK;
  END;
  --
end INKG_RETIRO_EQUIPO;

/
