SET DEFINE OFF;
CREATE OR REPLACE TRIGGER DB_GENERAL.AFTER_DML_ADMI_PARAMETRO_DET
AFTER UPDATE ON DB_GENERAL.ADMI_PARAMETRO_DET REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
--
DECLARE 
/**
  * Documentacion para trigger DB_GENERAL.AFTER_DML_ADMI_PARAMETRO_DET
  * Inserta un registro en DB_GENERAL.AFTER_DML_ADMI_PARAMETRO_HIST cuando se actualizan registros 
  * de la tabla 'DB_GENERAL.AFTER_DML_ADMI_PARAMETRO_DET'
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 18-07-2017
  * 
  * Se validan parámetros NC_MOTIVOS_ORDEN_SERVICIO y MOTIVOS_ELIMINAR_ORDEN_SERVICIO_VENDEDOR
  * que muestran los registros actualizados en el grid historial de la pantalla Administración de Motivos PYL
  * Ingreso de Lr_AdmiParamtrosHist.DESCRIPCION := :NEW.DESCRIPCION
  * muestra la actualización del registro descripción 
  * en el grid historial de la pantalla Administración de Motivos PYL
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.1 20-03-2019
  *
  * Se valida parámetros 'PROM_PRECIO_INSTALACION' y 'RETIRO_EQUIPOS_SOPORTE'
  * que muestran los registros actualizados en el grid historial de la pantalla
  * Administrar Tablas de Amortización.
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.2 28-06-2019
  *
  * Se valida parámetros MOTIVOS_CAMBIO_FORMA_PAGO
  * que muestran los registros actualizados en el grid historial de las pantallas 
  * Descuento para Notas de Crédito Por Traslados, Administración Motivos de Formas de Pagos      
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.3 09-07-2019
  *
  * Se actualiza nuevo parámetro CARGO REACTIVACION SERVICIO
  * valor3 que indica si se debe cobrar rubro de reactivacion con nuevo flujo.
  * @author Javier Hidalgo <jihidalgo@telconet.ec>
  * @version 1.4 16-01-2023
  */  

  Lr_AdmiParamtrosHist          DB_GENERAL.ADMI_PARAMETRO_HIST%ROWTYPE;
  Lr_AdmiParamtroCab            DB_GENERAL.ADMI_PARAMETRO_CAB%ROWTYPE;
  Lv_Observacion                VARCHAR(1000) := '';
  --
  --
  BEGIN
      --
      Lr_AdmiParamtrosHist.ID_PARAMETRO_DET       := :OLD.ID_PARAMETRO_DET;
      Lr_AdmiParamtrosHist.PARAMETRO_ID           := :OLD.PARAMETRO_ID;
      Lr_AdmiParamtrosHist.DESCRIPCION            := :OLD.DESCRIPCION;
      Lr_AdmiParamtrosHist.VALOR1                 := :OLD.VALOR1;
      Lr_AdmiParamtrosHist.VALOR2                 := :OLD.VALOR2;
      Lr_AdmiParamtrosHist.VALOR3                 := :OLD.VALOR3;
      Lr_AdmiParamtrosHist.VALOR4                 := :OLD.VALOR4;
      Lr_AdmiParamtrosHist.ESTADO                 := :OLD.ESTADO;
      Lr_AdmiParamtrosHist.USR_CREACION           := :OLD.USR_CREACION;
      Lr_AdmiParamtrosHist.FE_CREACION            := :OLD.FE_CREACION;
      Lr_AdmiParamtrosHist.IP_CREACION            := :OLD.IP_CREACION;
      Lr_AdmiParamtrosHist.USR_ULT_MOD            := :NEW.USR_ULT_MOD;
      Lr_AdmiParamtrosHist.FE_ULT_MOD             := :NEW.FE_ULT_MOD;
      Lr_AdmiParamtrosHist.DESCRIPCION            := :NEW.DESCRIPCION;
      Lr_AdmiParamtrosHist.IP_ULT_MOD             := :OLD.IP_ULT_MOD;
      Lr_AdmiParamtrosHist.VALOR5                 := :OLD.VALOR5;
      Lr_AdmiParamtrosHist.EMPRESA_COD            := :OLD.EMPRESA_COD;
      Lr_AdmiParamtrosHist.USR_CREACION_HIST      := USER;
      Lr_AdmiParamtrosHist.FE_CREACION_HIST       := SYSDATE;
      Lr_AdmiParamtrosHist.IP_CREACION_HIST       := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
      Lr_AdmiParamtrosHist.HOST_CREACION_HIST     := NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos');

      --Obtiene la cabecera del parámetro modificado
      Lr_AdmiParamtroCab  := DB_GENERAL.GNRLPCK_UTIL.F_GET_ADMI_PARAMETRO_CAB(:OLD.PARAMETRO_ID);

      IF Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'CARGO REACTIVACION SERVICIO' THEN

        Lv_Observacion := 'Se actualizan parámetros: ';
      --
        IF UPDATING('ESTADO') THEN
          Lv_Observacion := Lv_Observacion || ' Estado anterior: '||:OLD.ESTADO||' estado nuevo: '||:NEW.ESTADO;
        END IF;

        IF UPDATING('VALOR1') THEN
          Lv_Observacion := Lv_Observacion || ' Valor de recargo anterior: '||:OLD.VALOR1||' valor de recargo nuevo: '||:NEW.VALOR1;
        END IF;

        IF UPDATING('VALOR2') THEN
          Lv_Observacion := Lv_Observacion || ' Fe.Act.Servicio anterior: '||:OLD.VALOR2||' Fe.Act.Servicio nueva: '||:NEW.VALOR2;
        END IF;

        IF UPDATING('VALOR3') THEN
          IF(:NEW.VALOR3 = '1') THEN 
            Lv_Observacion := Lv_Observacion || ' Generar Cobro por Reconexión a todos cambia de estado: Desactivado a estado Activado';
          ELSE
            Lv_Observacion := Lv_Observacion || ' Generar Cobro por Reconexión a todos cambia de estado: Activado a estado Desactivado';
          END IF;
        END IF;

        Lr_AdmiParamtrosHist.OBSERVACION :=  Lv_Observacion;
       
      --
      END IF;

      --   MOTIVOS RECHAZO QUE GENERAN NOTA DE CREDITO
      --   MOTIVOS PARA CAMBIO FORMA DE PAGO
      IF Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'NC_MOTIVOS_ORDEN_SERVICIO' 
      OR Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'MOTIVOS_ELIMINAR_ORDEN_SERVICIO_VENDEDOR'
      OR Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'MOTIVOS_CAMBIO_FORMA_PAGO'  THEN

         Lv_Observacion := 'Actualización de parámetros: ';
        --
        IF UPDATING('ESTADO') THEN
          Lv_Observacion := Lv_Observacion || ' Estado anterior: '||:OLD.ESTADO||' estado nuevo: '||:NEW.ESTADO;
        END IF;

        IF UPDATING('VALOR1') THEN
          Lv_Observacion := ' Motivo Actualizado: '||:OLD.VALOR2 || ' - Valor anterior: ' ||:OLD.VALOR1||' - Valor nuevo: ' ||:NEW.VALOR1;
        END IF;
        
        IF UPDATING('DESCRIPCION') THEN
          Lv_Observacion := ' Descripción Actualizada a: '||:NEW.DESCRIPCION ;
        END IF;
        
        IF UPDATING('DESCRIPCION') AND UPDATING('VALOR1') THEN
          Lv_Observacion := ' Descripción Actualizada a: '||:NEW.DESCRIPCION ||' Motivo Actualizado: '||:OLD.VALOR2 || ' - Valor anterior: ' ||:OLD.VALOR1||' - Valor nuevo: ' ||:NEW.VALOR1;
        END IF;
        Lr_AdmiParamtrosHist.OBSERVACION :=  Lv_Observacion;

      --
      END IF; 

      -- PORCENTAJE DE INSTALACIÓN.
      -- RETIRO DE EQUIPOS.
      IF Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'RETIRO_EQUIPOS_SOPORTE' 
      OR Lr_AdmiParamtroCab.NOMBRE_PARAMETRO = 'PROM_PRECIO_INSTALACION'
      THEN        
         Lv_Observacion := 'Actualización de parámetros: ';         
      --
        IF UPDATING('VALOR3') THEN
          Lv_Observacion :=  ' Valor de Instalación al 100% Actualizado: '|| ' - Valor anterior: ' ||:OLD.VALOR3||' - Valor nuevo: ' ||:NEW.VALOR3;
        END IF;
        
        IF UPDATING('VALOR4') THEN
          Lv_Observacion := ' Valor de Instalación al 50%  Actualizado: '|| ' - Valor anterior: ' ||:OLD.VALOR4||' - Valor nuevo: ' ||:NEW.VALOR4;
        END IF;
        
        IF UPDATING('VALOR5') THEN
          Lv_Observacion :=  'Valor de Cancelación Voluntaria modificado de: ' ||:OLD.VALOR5||' - Nuevo Valor: '||:NEW.VALOR5;
        END IF;
        
        IF UPDATING('VALOR6') THEN
          Lv_Observacion :=  'Equipo: ' ||:OLD.DESCRIPCION||' - Pecio Anterior: '||:OLD.VALOR6 ||' - Nuevo Precio: '||:NEW.VALOR6;
        END IF;
        
        IF UPDATING('VALOR5') AND UPDATING('VALOR6') THEN
          Lv_Observacion :=  'Valor de Cancelación Voluntaria modificado de: ' ||:OLD.VALOR5 ||' - Nuevo Valor: '  ||:NEW.VALOR5 ||
                             '- Equipo: ' ||:OLD.DESCRIPCION||' - Pecio Anterior: '||:OLD.VALOR6 ||' - Nuevo Pecio: '  ||:NEW.VALOR6;
                             
        END IF;
        
        IF UPDATING('VALOR3') AND  UPDATING('VALOR4') THEN
          Lv_Observacion := ' Valores de Instalación Actualizados: '|| ' - Valor 100% anterior: ' ||:OLD.VALOR3||' - Valor 100% nuevo: ' ||:NEW.VALOR3
                                                                    || ' - Valor 50% anterior: '  ||:OLD.VALOR4||' - Valor 50% nuevo: '  ||:NEW.VALOR4;
        END IF;
        
        IF UPDATING('DESCRIPCION') THEN
          Lv_Observacion := ' Descripción Actualizada a: '||:NEW.DESCRIPCION ;
        END IF;        
      -- 
        Lr_AdmiParamtrosHist.OBSERVACION :=  Lv_Observacion;
    END IF;

      --Se crea el historial con la información del último detalle.
      DB_GENERAL.GECK_TRANSACTION.P_INSERT_PARAMETRO_HIST(Lr_AdmiParamtrosHist);
    --
  END AFTER_DML_ADMI_PARAMETRO_DET;
/