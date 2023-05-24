CREATE OR REPLACE TRIGGER DB_COMERCIAL.TRG_INFOSERV_SOLMIGRA
   AFTER UPDATE OF ESTADO
   ON DB_COMERCIAL.INFO_SERVICIO
   FOR EACH ROW
DECLARE
/**
  * Documentacion para trigger DB_COMERCIAL.TRG_INFOSERV_SOLMIGRA  
  * @since 1.0
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * Se agrega Cambio de estado y creacion de historial a nivel de las plantillas de comisionistas existentes para el servicio, si el
  * estado del servicio es modificado a Anulado, Eliminado, Cancel, Rechazada, Rechazado
  * @version 1.1 15-05-2017
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * Para el caso de servicios con el plan Netlifecam se agrega validaci�n para los servicios de clientes MD que pasan de estado 'In-Corte' a 'Activo'
  * de acuerdo a las solicitudes parametrizadas en TIPOS_SOLICITUDES_CAMBIO_ESTADO_SERVICIO
  * @version 1.2 06-04-2017
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * Se agrega IP por defecto al agregar historial de comisi�n cuando la sentencia se ejecuta desde el servidor
  * @version 1.3 24-10-2017
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * Se agrega proceso para dar de baja la caracteristica de alcance
  * @version 1.4 1-12-2017
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.5
  * @since 22-11-2018
  * Se agrega la validaci�n para crear facturas de instalaci�n.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * En el caso de Activacion del Servicio se verifica si existe solicitud de Facturacion unica por Detalle y se actualiza el estado de 
  * Creada a Pendiente, para que quede habilitado para la Facturaci�n y se genera registro de Historial por cambio de estado de la Solicitud.
  * @version 1.6 26-11-2018
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.0
  * @since 14-12-2018
  * Se agrega el flujo de limpiar cach� con Toolbox (Fox Premium) cuando se actualiza el estado del servicio.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.7 30-09-2019 
  * Se elimina llamada a procedimiento P_CREA_FACT_INS_PTO_ADICIONAL que genera Factura de Instalaci�n para el punto (Login) cuando el servicio pasa 
  * a estado Factible, el proceso es reemplazado por dos Jobs:
  * Se agrega al proceso actual de M�vil la generaci�n de Facturas de Instalaci�n para contratos WEB en estado Pendiente con servicio Factible 
  * el cual se ejecutar� mediante JOB_CREAR_FACTURA_INSTALACION.
  * Se crea Job JOB_FACT_INS_PTO_ADICIONAL para generar Facturas de Instalaci�n (origen WEB o MOVIL) a puntos adicionales o a clientes con contratos
  * Activos que han realizado rechazo de orden en P&L y realizan reingreso de Orden de servicio en el mismo Login.
  * Adicional se agreg� a los procesos de generaci�n de Fact. de Instalaci�n la verificaci�n de promociones en Instalaci�n.  
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.8 09-09-2020
  * Se agrega liberaci�n de beneficio por discapacidad, se Eliminan solicitudes de descuento fijo en caso de existir cuando el servicio pasa a
  * estados como Eliminado, Anulado, Rechazado, Trasladado, Reubicado, etc, 
  * (Estados parametrizados nombre parametro: PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD detalle: ESTADOS_SERVICIO_LIBERA_BENEFICIO)   
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.9 08-02-2021
  * Se agrega liberaci�n de beneficio por "Beneficio 3era Edad / Adulto Mayor", se Eliminan solicitudes de descuento fijo en caso de existir cuando 
  * el servicio pasa a estados como Eliminado, Anulado, Rechazado, Trasladado, Reubicado, etc,   
  *
  * Costo de query C_GetSolicitudDescuentoFijo: 11
  * Costo de query C_GetEstadoLiberaBeneficio: 3
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 2.0 17-08-2021
  * Se agrega sentencia de valor en la subconsulta del cursor C_GetSolicitudDescuentoFijo para obtener el valor de proceso parametrizado para  
  * la liberaci�n de beneficio por motivo de adulto mayor.
  *
  * @author Edgar Pin Villavicencio<epin@telconet.ec>
  * @version 2.1 01-03-2023
  * Se agrega empresa Ecuanet en las validaciones de Megadatos
  *
  * Costo de query C_GetSolicitudDescuentoFijo: 11 
  */
    --Obtengo si existe para el servicio SOLICITUD FACTURACION UNICA POR DETALLE
    CURSOR C_GetSolicitudFactUnica (Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS 
    SELECT DS.*
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS, DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS
    WHERE 
    DS.TIPO_SOLICITUD_ID         = TS.ID_TIPO_SOLICITUD
    AND TS.DESCRIPCION_SOLICITUD ='SOLICITUD FACTURACION UNICA POR DETALLE'
    AND DS.ESTADO                ='Creada'
    AND DS.SERVICIO_ID           =Cv_IdServicio
    AND ROWNUM                   =1;

    Lr_GetSolicitudFactUnica C_GetSolicitudFactUnica%ROWTYPE;

    --Obtengo el prefijo empresa al que pertenece el servicio
    CURSOR C_GetPrefijoEmpresa(Cv_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS       
    SELECT EMPGRUP.PREFIJO           
    FROM  DB_COMERCIAL.INFO_PUNTO PTO 
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL ON PTO.PERSONA_EMPRESA_ROL_ID=PEMPROL.ID_PERSONA_ROL
    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL ON PEMPROL.EMPRESA_ROL_ID=EMPROL.ID_EMPRESA_ROL
    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGRUP ON EMPROL.EMPRESA_COD=EMPGRUP.COD_EMPRESA
    WHERE PTO.ID_PUNTO=Cv_IdPunto; 

    --Obtengo Plantillas de Comisionistas Activas por servicio 
    CURSOR C_GetPlantillaComisionista(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
    SELECT SCOM.ID_SERVICIO_COMISION,
    SCOM.SERVICIO_ID,
    SCOM.COMISION_DET_ID,
    SCOM.PERSONA_EMPRESA_ROL_ID,
    SCOM.COMISION_VENTA,
    SCOM.COMISION_MANTENIMIENTO,
    SCOM.ESTADO    
    FROM DB_COMERCIAL.INFO_SERVICIO_COMISION SCOM,     
     DB_COMERCIAL.ADMI_COMISION_DET COMD,     
     DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
     DB_GENERAL.ADMI_PARAMETRO_DET PARD,
     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL,
     DB_COMERCIAL.INFO_PERSONA PER,
     DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGR
    WHERE
    SCOM.SERVICIO_ID                = Cv_IdServicio
    AND SCOM.COMISION_DET_ID        = COMD.ID_COMISION_DET
    AND COMD.PARAMETRO_DET_ID       = PARD.ID_PARAMETRO_DET
    AND PARD.PARAMETRO_ID           = PARC.ID_PARAMETRO 
    AND SCOM.PERSONA_EMPRESA_ROL_ID = PEMPROL.ID_PERSONA_ROL
    AND PEMPROL.PERSONA_ID          = PER.ID_PERSONA
    AND PARD.EMPRESA_COD            = EMPGR.COD_EMPRESA
    AND PARC.NOMBRE_PARAMETRO       = 'GRUPO_ROLES_PERSONAL'
    AND EMPGR.PREFIJO               = 'TN'
    AND SCOM.ESTADO                 = 'Activo';

   CURSOR C_GetSolicitudDescuentoFijo(Cv_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Cv_NomParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_DescEstadosSol  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                      Cv_DescMotivo      DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                      Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                      Cv_Valor           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE)
    IS 
    SELECT  MO.NOMBRE_MOTIVO, DS.ID_DETALLE_SOLICITUD, DS.MOTIVO_ID 
     FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS,
     DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS,
     DB_GENERAL.ADMI_MOTIVO MO      
    WHERE 
    DS.TIPO_SOLICITUD_ID         = TS.ID_TIPO_SOLICITUD    
    AND TS.DESCRIPCION_SOLICITUD ='SOLICITUD DESCUENTO'
    AND UPPER(DS.ESTADO)         IN (SELECT UPPER(PD.VALOR1)
                                       FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                       DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                       WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                       AND PC.NOMBRE_PARAMETRO = Cv_NomParametro
                                       AND PC.ESTADO           = Cv_Estado
                                       AND PD.ESTADO           = Cv_Estado
                                       AND PD.DESCRIPCION      = Cv_DescEstadosSol)
    AND DS.MOTIVO_ID             = MO.ID_MOTIVO
    AND UPPER(MO.NOMBRE_MOTIVO)  IN (SELECT UPPER(PD.VALOR1)
                                       FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                       DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                       WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                       AND PC.NOMBRE_PARAMETRO = Cv_NomParametro
                                       AND PC.ESTADO           = Cv_Estado
                                       AND PD.ESTADO           = Cv_Estado
                                       AND PD.DESCRIPCION      = Cv_DescMotivo
                                       AND PD.VALOR4           = Cv_Valor)
    AND DS.SERVICIO_ID           = Cv_IdServicio;    

    CURSOR C_GetEstadoLiberaBeneficio(Cv_EstadoServicio DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS 
      SELECT 'TRUE' AS LIBERA_BENEFICIO, UPPER(PD.VALOR1)
      FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
      DB_GENERAL.ADMI_PARAMETRO_CAB PC
      WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
      AND PC.NOMBRE_PARAMETRO = 'PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD'
      AND PC.ESTADO           = 'Activo'
      AND PD.ESTADO           = 'Activo'
      AND PD.DESCRIPCION      = 'ESTADOS_SERVICIO_LIBERA_BENEFICIO'
      AND UPPER(PD.VALOR1)    = UPPER(Cv_EstadoServicio);

   Lr_GetEstadoLiberaBeneficio       C_GetEstadoLiberaBeneficio%ROWTYPE;

   Tn_IdTipoSolicitud            ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
   Le_Exception                  EXCEPTION;
   Tn_IdDetalleSolicitud         INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
   Tv_Prefijo                    DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
   Lv_MsjError                   VARCHAR2(3000);
   Lb_ExisteSolDescFijo          BOOLEAN:=false;   
   Lv_NomParamDiscapac           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD';
   Lv_NomParamAdultMayor         DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_ADULTO_MAYOR';
   Lv_DescEstadosSolDiscap       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='ESTADOS_SOLICITUD';
   Lv_DescMotivoDiscap           DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='MOTIVO_DESC_DISCAPACIDAD';
   Lv_DescEstadosSolAdultMayor   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='ESTADOS_SOLICITUD';
   Lv_DescMotivoAdultMayor       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='MOTIVO_DESC_ADULTO_MAYOR';
   Lv_Estado                     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE:='Activo';
   Lv_Valor                      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE:='LIBERACION_BENEFICIO';

BEGIN
   IF C_GetPrefijoEmpresa%ISOPEN THEN
      CLOSE C_GetPrefijoEmpresa;
   END IF;

   IF C_GetEstadoLiberaBeneficio%ISOPEN THEN        
      CLOSE C_GetEstadoLiberaBeneficio;        
   END IF;

   OPEN  C_GetPrefijoEmpresa(:NEW.PUNTO_ID);
   FETCH C_GetPrefijoEmpresa INTO Tv_Prefijo;

   IF (C_GetPrefijoEmpresa%NOTFOUND) THEN 
      Tv_Prefijo :='';   
   END IF;
   CLOSE C_GetPrefijoEmpresa;

   SYS.DBMS_OUTPUT.PUT_LINE (Tv_Prefijo);      


   IF :OLD.ESTADO = 'In-Corte' AND :NEW.ESTADO = 'Activo' AND (Tv_Prefijo='MD' OR Tv_Prefijo='EN')
   THEN
      DB_COMERCIAL.COMEK_TRANSACTION.P_CAMBIO_ESTADO_SERVICIO( 
                                                            :OLD.ID_SERVICIO,
                                                            :OLD.PUNTO_ID,
                                                            :OLD.ESTADO,
                                                            :NEW.ESTADO,
                                                            :NEW.USR_CREACION,
                                                            Lv_MsjError );
   END IF;

   IF ((Tv_Prefijo='MD' OR Tv_Prefijo='EN') AND UPDATING('ESTADO') AND :NEW.ESTADO <> :OLD.ESTADO ) THEN
     --     
      OPEN C_GetEstadoLiberaBeneficio(:NEW.ESTADO);      
      FETCH C_GetEstadoLiberaBeneficio INTO Lr_GetEstadoLiberaBeneficio;      

      IF (C_GetEstadoLiberaBeneficio%FOUND AND Lr_GetEstadoLiberaBeneficio.LIBERA_BENEFICIO='TRUE') THEN             
        --
        FOR Lr_GetSolicitudDescuentoFijo IN C_GetSolicitudDescuentoFijo(:NEW.ID_SERVICIO,
                                                                        Lv_NomParamDiscapac,
                                                                        Lv_DescEstadosSolDiscap,
                                                                        Lv_DescMotivoDiscap,
                                                                        Lv_Estado,
                                                                        Lv_Valor) LOOP
          --   
          Lb_ExisteSolDescFijo := TRUE;   
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
          SET ESTADO = 'Eliminada' 
          WHERE ID_DETALLE_SOLICITUD=Lr_GetSolicitudDescuentoFijo.ID_DETALLE_SOLICITUD;

          INSERT
          INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
          (
           ID_SOLICITUD_HISTORIAL,
           DETALLE_SOLICITUD_ID,
           ESTADO,
           OBSERVACION,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           MOTIVO_ID
          )
          VALUES
          (
           DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
           Lr_GetSolicitudDescuentoFijo.ID_DETALLE_SOLICITUD ,
           'Eliminada',
           'Se realiza liberaci�n de Beneficio: ' || Lr_GetSolicitudDescuentoFijo.NOMBRE_MOTIVO,
           'telcos_pvulnera',
           SYSDATE,
           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),'127.0.0.1'),
           Lr_GetSolicitudDescuentoFijo.MOTIVO_ID    
          );
        END LOOP;
        --
        FOR Lr_GetSolicitudDescuentoFijo IN C_GetSolicitudDescuentoFijo(:NEW.ID_SERVICIO,
                                                                        Lv_NomParamAdultMayor,
                                                                        Lv_DescEstadosSolAdultMayor,
                                                                        Lv_DescMotivoAdultMayor,
                                                                        Lv_Estado,
                                                                        Lv_Valor) LOOP
          --   
          Lb_ExisteSolDescFijo := TRUE;   
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
          SET ESTADO = 'Eliminada' 
          WHERE ID_DETALLE_SOLICITUD=Lr_GetSolicitudDescuentoFijo.ID_DETALLE_SOLICITUD;

          INSERT
          INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
          (
           ID_SOLICITUD_HISTORIAL,
           DETALLE_SOLICITUD_ID,
           ESTADO,
           OBSERVACION,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           MOTIVO_ID
          )
          VALUES
          (
           DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
           Lr_GetSolicitudDescuentoFijo.ID_DETALLE_SOLICITUD ,
           'Eliminada',
           'Se realiza liberaci�n de Beneficio: ' || Lr_GetSolicitudDescuentoFijo.NOMBRE_MOTIVO ,
           'telcos_pvulnera',
           SYSDATE,
           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),'127.0.0.1'),
           Lr_GetSolicitudDescuentoFijo.MOTIVO_ID    
          );
        END LOOP;
        --
        IF Lb_ExisteSolDescFijo THEN
          INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL 
          (ID_SERVICIO_HISTORIAL,
           SERVICIO_ID,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION,
           ESTADO,
           MOTIVO_ID,
           OBSERVACION,
           ACCION
          )
          VALUES
          (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
           :NEW.ID_SERVICIO,
           'telcos_pvulnera',
           SYSDATE,
           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),'127.0.0.1'),
           :NEW.ESTADO,
           NULL,
           'Se realiza liberaci�n de Beneficio',
           'liberacionBeneficio'        
          ); 
        END IF; 
      END IF;   
      CLOSE C_GetEstadoLiberaBeneficio;           
   END IF;

   IF Tv_Prefijo='TN' AND :NEW.ESTADO <> :OLD.ESTADO AND :NEW.ESTADO IN ('Anulado','Eliminado','Cancel','Rechazada','Rechazado') THEN
      FOR Lr_GetPlantillaComisionista IN C_GetPlantillaComisionista(:NEW.ID_SERVICIO) LOOP
          --ACTUALIZO ESTADO DE LA PLANTILLA DE COMISIONISTAS 
          UPDATE DB_COMERCIAL.INFO_SERVICIO_COMISION 
          SET ESTADO      = :NEW.ESTADO,
              FE_ULT_MOD  = SYSDATE,
              USR_ULT_MOD = :NEW.USR_CREACION,
              IP_ULT_MOD  = SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
          WHERE ID_SERVICIO_COMISION= Lr_GetPlantillaComisionista.ID_SERVICIO_COMISION;

          --CREO HISTORIAL PARA LA PLANTILLA EDITADA
          INSERT INTO DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO 
          (ID_SERVICIO_COMISION_HISTO,
           SERVICIO_COMISION_ID,
           SERVICIO_ID,
           COMISION_DET_ID,
           PERSONA_EMPRESA_ROL_ID,
           COMISION_VENTA,
           COMISION_MANTENIMIENTO,
           ESTADO,
           OBSERVACION,
           USR_CREACION,
           FE_CREACION,
           IP_CREACION) 
           VALUES 
          (DB_COMERCIAL.SEQ_INFO_SERVICIO_COMI_HISTO.NEXTVAL,
          Lr_GetPlantillaComisionista.ID_SERVICIO_COMISION,
          Lr_GetPlantillaComisionista.SERVICIO_ID,
          Lr_GetPlantillaComisionista.COMISION_DET_ID,
          Lr_GetPlantillaComisionista.PERSONA_EMPRESA_ROL_ID,
          Lr_GetPlantillaComisionista.COMISION_VENTA,
          Lr_GetPlantillaComisionista.COMISION_MANTENIMIENTO,
          :NEW.ESTADO,
          'Se modifica Estado de la Plantilla de Comisionistas de: ['|| Lr_GetPlantillaComisionista.ESTADO || '] a [' || :NEW.ESTADO || ']',
          :NEW.USR_CREACION,
          SYSDATE,
          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),'127.0.0.1'));
      END LOOP;      
   END IF;

   IF :NEW.ESTADO = 'In-Corte' AND (Tv_Prefijo='MD' OR Tv_Prefijo='EN') THEN

     CMKG_CICLOS_FACTURACION.P_VALIDA_CARACT_ALCANCE( :NEW.PUNTO_ID,:NEW.ID_SERVICIO);

   END IF;

   --Solo cuando el servicio es Activado la primera vez obtengo si el servicio posee Solicitud de Facturaci�n Unica
   IF :NEW.ESTADO = 'Activo' AND :OLD.ESTADO <> 'In-Corte' THEN
   -- 
     IF C_GetSolicitudFactUnica%ISOPEN THEN
       CLOSE C_GetSolicitudFactUnica;
     END IF;

     OPEN  C_GetSolicitudFactUnica(:NEW.ID_SERVICIO);
     FETCH C_GetSolicitudFactUnica INTO Lr_GetSolicitudFactUnica;

     IF (C_GetSolicitudFactUnica%FOUND) THEN 
     --
       UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
       SET ESTADO = 'Pendiente' 
       WHERE ID_DETALLE_SOLICITUD=Lr_GetSolicitudFactUnica.ID_DETALLE_SOLICITUD;

       INSERT
       INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
       (
        ID_SOLICITUD_HISTORIAL,
        DETALLE_SOLICITUD_ID,
        ESTADO,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        MOTIVO_ID
       )
       VALUES
       (
        DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
        Lr_GetSolicitudFactUnica.ID_DETALLE_SOLICITUD ,
        'Pendiente',
        'Se pasa Solicitud de Facturacion a estado Pendiente de Facturar',
        Lr_GetSolicitudFactUnica.USR_CREACION,
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),'127.0.0.1'),
        Lr_GetSolicitudFactUnica.MOTIVO_ID    
       );
     --
     END IF;
     CLOSE C_GetSolicitudFactUnica;
   --
   END IF;

    --Flujo de FoxPremium para eliminar la cach� en Toolbox
    IF UPDATING('ESTADO') AND :NEW.ESTADO <> :OLD.ESTADO THEN
        --Si ocurren errores no debe afectar el flujo del cambio del estado del servicio.
        DB_COMERCIAL.CMKG_FOX_PREMIUM.P_PROCESA_CLEAR_CACHE_TOOLBOX (Pn_IdServicio     => :NEW.ID_SERVICIO,
                                                                     Pv_EstadoNuevo    => :NEW.ESTADO,
                                                                     Pv_EstadoAnterior => :OLD.ESTADO,
                                                                     Pn_ProductoId     => :NEW.PRODUCTO_ID,
                                                                     Pv_Mensaje        => Lv_MsjError);
    END IF;

  EXCEPTION
    WHEN Le_Exception THEN
        RAISE_APPLICATION_ERROR(-20002, Lv_MsjError);
  WHEN OTHERS THEN  
   IF C_GetPrefijoEmpresa%ISOPEN THEN
      CLOSE C_GetPrefijoEmpresa;
   END IF; 

   IF C_GetEstadoLiberaBeneficio%ISOPEN THEN        
      CLOSE C_GetEstadoLiberaBeneficio;        
   END IF;

    RAISE_APPLICATION_ERROR(-20001, 'No se encontro definido Prefijo_Empresa definido: '
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

END;
/