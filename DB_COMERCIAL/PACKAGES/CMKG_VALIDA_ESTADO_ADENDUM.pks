CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_VALIDA_ESTADO_ADENDUM AS 
    /**
      * Documentaci�n para el procedimiento P_VALIDA_ESTADO
      *
      * M�todo que se encarga de actualizar el estado de los adendums a Activo cuando el servicio se encuentra PrePlanificada
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 02-12-2019
      */

   PROCEDURE P_VALIDA_ESTADO(Pv_Empresa         IN  VARCHAR2,
                            Pv_Estado_Adendum   IN  VARCHAR2,
                            Pd_Fecha            IN  DATE,
                            Pv_Estado_Activo    IN VARCHAR2,
                            Pv_Nombre_Parametro IN VARCHAR2,
                            Pv_Error            OUT VARCHAR2);     


    /**
      * Documentaci�n para el procedimiento P_VALIDA_ESTADO
      *
      * M�todo que se encarga de actualizar el estado de los adendums a Activo cuando el servicio se encuentra PrePlanificada cuando es contrato
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 02-12-2019
      */                              

    PROCEDURE P_UPDATE_CONTRATO(Pv_Tipo     IN VARCHAR2,
                                Pn_Numero   IN NUMBER,
                                Pv_Estado   IN VARCHAR2);
    /**
      * Documentaci�n para el procedimiento P_VALIDA_ESTADO
      *
      * M�todo que se encarga de actualizar el estado de los adendums a Activo cuando el servicio se encuentra PrePlanificada cuando es adendum
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 02-12-2019
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 se corrige el tipo de parametro en numero de adendum es varchar2
      */                              
    PROCEDURE P_UPDATE_ADENDUM(Pv_Tipo     IN VARCHAR2,
                               Pv_Numero   IN VARCHAR2,
                               Pv_Estado   IN VARCHAR2);


END CMKG_VALIDA_ESTADO_ADENDUM;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_VALIDA_ESTADO_ADENDUM AS

  PROCEDURE P_VALIDA_ESTADO(Pv_Empresa       IN  VARCHAR2,
                            Pv_Estado_Adendum IN  VARCHAR2,
                            Pd_Fecha         IN  DATE,
                            Pv_Estado_Activo IN VARCHAR2,
                            Pv_Nombre_Parametro IN VARCHAR2,
                            Pv_Error       OUT VARCHAR2) AS
    CURSOR C_GetAdendum
    IS
      SELECT SERVICIO_ID, NUMERO, TIPO, CONTRATO_ID
      FROM   DB_COMERCIAL.INFO_ADENDUM
      WHERE  ESTADO          = Pv_Estado_Adendum
      AND    FE_CREACION >= Pd_Fecha
      AND    CONTRATO_ID IS NOT NULL;

   CURSOR  C_Estados
   IS
   SELECT apd.VALOR1, apd.VALOR2 
   FROM DB_GENERAL.ADMI_PARAMETRO_CAB apc,
        DB_GENERAL.ADMI_PARAMETRO_DET apd
   WHERE apc.NOMBRE_PARAMETRO=Pv_Nombre_Parametro
   AND apd.PARAMETRO_ID = apc.ID_PARAMETRO
   AND apd.ESTADO = Pv_Estado_Activo
   AND apc.ESTADO = Pv_Estado_Activo;

      Lv_Resultado     VARCHAR2(400);
      Lv_Estado        VARCHAR2(30);             
      Lv_EstadoAdendum VARCHAR2(30);
      Le_error_estado  EXCEPTION;
      I                PLS_INTEGER;
      A                PLS_INTEGER;

  TYPE data_estados_rt IS RECORD(
    estado_valor1 VARCHAR2(4000),
    estado_valor2  VARCHAR2(300)
  );
  TYPE data_estados_tt IS TABLE OF data_estados_rt;
  array_estados data_estados_tt;

  TYPE data_adendum_rt IS RECORD(
    adendum_servicio_id NUMBER,
    adendum_numero      VARCHAR2(30),
    adendum_tipo        VARCHAR2(2),
    adendum_contrato_id NUMBER
  );
  TYPE data_adendum_tt IS TABLE OF data_adendum_rt;
  array_adendum data_adendum_tt;    
  BEGIN

      OPEN C_Estados;
        fetch C_Estados BULK COLLECT INTO array_estados LIMIT 1000;
      CLOSE C_Estados;  
      IF array_estados.count = 0 THEN
        Lv_resultado:= 'No se encontraron estados configurados';
        raise Le_error_estado;
      END IF;    

      OPEN C_GetAdendum;
         loop 
           array_adendum:= data_adendum_tt(NULL);
           fetch C_GetAdendum BULK COLLECT INTO array_adendum LIMIT 1000;
           exit when array_adendum.count = 0;
           A := array_adendum.FIRST;
           WHILE (A IS NOT NULL) 
           loop

            Lv_EstadoAdendum := NULL;

            SELECT estado into Lv_Estado
            FROM DB_COMERCIAL.INFO_SERVICIO
            WHERE id_servicio = array_adendum(A).adendum_servicio_id;

            I := array_estados.FIRST;

            WHILE (I IS NOT NULL) 
            loop
               IF (instr(array_estados(I).estado_valor1, Lv_Estado) > 0) then
                  Lv_EstadoAdendum := array_estados(I).estado_valor2;
               END IF;
               I := array_estados.NEXT(I);
            end loop;

            IF (Lv_EstadoAdendum IS NOT NULL) THEN 
                IF (array_adendum(A).adendum_TIPO  = 'C') THEN
                    CMKG_VALIDA_ESTADO_ADENDUM.P_UPDATE_CONTRATO(array_adendum(A).adendum_TIPO, array_adendum(A).adendum_contrato_id, Lv_EstadoAdendum);
                ELSE
                    CMKG_VALIDA_ESTADO_ADENDUM.P_UPDATE_ADENDUM(array_adendum(A).adendum_TIPO, array_adendum(A).adendum_NUMERO, Lv_EstadoAdendum);
                END IF;
            END IF;
            A := array_adendum.NEXT(A);
          END LOOP;
        end loop;  
      CLOSE C_GetAdendum;

  exception 
  when Le_error_estado then
     Pv_Error:= Lv_Resultado;
  when others then
     Pv_Error:= substr(SQLERRM,1,500);


  END P_VALIDA_ESTADO;

  PROCEDURE P_UPDATE_CONTRATO(Pv_Tipo     IN VARCHAR2,
                              Pn_Numero   IN NUMBER,
                              Pv_Estado   IN VARCHAR2) AS
  BEGIN
    UPDATE DB_COMERCIAL.INFO_ADENDUM
    SET estado      = Pv_Estado,
    fe_modifica     = sysdate,
    usr_modifica    = 'telcos_job'
    WHERE tipo      = Pv_Tipo
    AND contrato_id = Pn_Numero;
    COMMIT;
  END P_UPDATE_CONTRATO;

  PROCEDURE P_UPDATE_ADENDUM(Pv_Tipo     IN VARCHAR2,
                             Pv_Numero   IN VARCHAR2,
                             Pv_Estado   IN VARCHAR2) AS
  BEGIN
    UPDATE DB_COMERCIAL.INFO_ADENDUM
    SET estado   = Pv_Estado,
    fe_modifica  = sysdate,
    usr_modifica = 'telcos_job'
    WHERE tipo   = Pv_Tipo 
    AND numero   = Pv_Numero;
    COMMIT;
  END P_UPDATE_ADENDUM;

END CMKG_VALIDA_ESTADO_ADENDUM;
/
