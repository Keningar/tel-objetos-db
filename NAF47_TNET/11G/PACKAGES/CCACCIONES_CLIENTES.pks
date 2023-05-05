CREATE OR REPLACE package            CCACCIONES_CLIENTES is

 -- Autor   : Miguel Guaranda
 -- Create  : 20/05/2009
 -- Purpose : Validador de las diferentes acciones que un cliente puede cambiar de estado.

PROCEDURE CC_PABONO(PV_CIA        IN VARCHAR2,
                    PV_CENTRO     IN VARCHAR2,
                    PV_CLIENTE    IN VARCHAR2,
                    PV_SUBCLIENTE IN VARCHAR2,
                    PV_GRUPO      IN VARCHAR2,
                    PV_DOCU       IN VARCHAR2,--ADD MLOPEZ 01/06/2010
                    PV_MOTIVO     IN VARCHAR2,
                    PV_RESULTADO  OUT VARCHAR2,
                    PV_ERROR      OUT VARCHAR2
                    );
--
PROCEDURE CC_PCKDESFASE(PV_CIA       IN VARCHAR2,
                        PV_CENTRO    IN VARCHAR2,
                        PV_CLIENTE   IN VARCHAR2,
                        PV_SUBCLIENTE IN VARCHAR2,
                        PV_GRUPO     IN VARCHAR2,
                        PV_MOTIVO    IN VARCHAR2,
                        PV_RESULTADO OUT VARCHAR2,
                        PV_ERROR     OUT VARCHAR2
                       );
--
PROCEDURE CC_PCKPROTESTO(PV_CIA       IN VARCHAR2,
                         PV_CLIENTE   IN VARCHAR2,
                         PV_SUBCLIENTE IN VARCHAR2,
                         PV_GRUPO     IN VARCHAR2,
                         PV_MOTIVO    IN VARCHAR2,
                         PV_RESULTADO OUT VARCHAR2,
                         PV_ERROR     OUT VARCHAR2
                        );
--
PROCEDURE CC_PACTUALIZACION(P_CIA          IN VARCHAR2,
                            P_CLIENTE      IN VARCHAR2,
                            P_SUBCLIENTE   IN VARCHAR2,
                            P_GRUPO        IN VARCHAR2,
                            P_NUEVOESTADO  IN VARCHAR2,
                            P_ERROR        OUT VARCHAR2
                           );
PROCEDURE CC_PINSERTA(P_CIA          IN VARCHAR2,
                      P_CLIENTE      IN VARCHAR2,
                      P_SUBCLIENTE   IN VARCHAR2,
                      P_MOTIVO       IN VARCHAR2,
                      P_ESTADOCLI    IN VARCHAR2,
                      P_NUEVOESTADO  IN VARCHAR2,
                      P_TIPOREGISTRO IN VARCHAR2,
                      P_OBSERVACION  IN VARCHAR2,
                      P_ERROR        OUT VARCHAR2
                      );
--
end CCACCIONES_CLIENTES;
/


CREATE OR REPLACE package body            CCACCIONES_CLIENTES is
 -- Autor   : Miguel Guaranda
 -- Create  : 20/05/2009
 -- Purpose : Validador de las diferentes acciones que un cliente puede cambiar de estado.

------------------------------------------------------------------------------------------------
-- Procedimiento que permite activar el cliente si realizo un abono a factura/as en los proximos
-- 7 dias,
------------------------------------------------------------------------------------------------
PROCEDURE CC_PABONO(PV_CIA        IN VARCHAR2,
                    PV_CENTRO     IN VARCHAR2,
                    PV_CLIENTE    IN VARCHAR2,
                    PV_SUBCLIENTE IN VARCHAR2,
                    PV_GRUPO      IN VARCHAR2,
                    PV_DOCU       IN VARCHAR2,--ADD MLOPEZ 01/06/2010
                    PV_MOTIVO     IN VARCHAR2,
                    PV_RESULTADO  OUT VARCHAR2,
                    PV_ERROR      OUT VARCHAR2
                    )IS

-- Declaracion de cursores
 -- obtiene el valor si aplica o no el cambio de estado
 CURSOR C_VERIFICA_ACCION(CV_CIA    VARCHAR2,
                          CV_MOTIVO VARCHAR2
                          ) IS
  SELECT O.CAMBIO_ESTADO_CLI
   FROM ARCCMOTIVOS O
   WHERE O.NO_CIA = CV_CIA
   AND   O.MOTIVO = CV_MOTIVO
   AND   O.PROTESTO_CK = 'N';

 -- Obtiene los dias de abono que el cliente tiene.
 CURSOR C_DIASABONO(CV_CIA VARCHAR2
                   )IS
  SELECT CT.DIAS_ABONO,ct.dias_abono_adicional--add mlopez 01/06/2010
   FROM ARCCCT CT
   WHERE CT.no_cia = CV_CIA;

 -- Obtiene el dia de proceso de cxc
 CURSOR C_DIAPROCESO(CV_CIA    VARCHAR2,
                     CV_CENTRO VARCHAR2
                    )IS
  SELECT CD.DIA_PROCESO_CXC
   FROM  ARINCD CD
   WHERE CD.NO_CIA = CV_CIA
   AND   CD.CENTRO = CV_CENTRO;

 -- obtiene el estado si el cliente esta suspendido
 CURSOR C_ESTADOCLI(CV_CIA        VARCHAR2,
                    CV_CLIENTE    VARCHAR2,
                    CV_GRUPO      VARCHAR2,
                    CV_SUBCLIENTE VARCHAR2
                    ) IS
  SELECT LC.ESTADO
   FROM  ARCCLOCALES_CLIENTES LC
   WHERE LC.NO_CIA = CV_CIA
   AND   LC.GRUPO = CV_GRUPO
   AND   LC.NO_CLIENTE = CV_CLIENTE
   AND   LC.NO_SUB_CLIENTE = CV_SUBCLIENTE;

 -- obtiene las facturas vencidas
 CURSOR C_FACTVENCIDAS (CV_CIA        VARCHAR2,
                        CV_CLIENTE    VARCHAR2,
                        CV_GRUPO      VARCHAR2,
                        CV_SUBCLIENTE VARCHAR2
                       )IS
  SELECT A.NO_CIA,A.CENTRO,A.TIPO_DOC,A.GRUPO,
         A.NO_DOCU,A.NO_CLIENTE,A.FECHA,
         A.FECHA_VENCE,A.M_ORIGINAL,A.SALDO, A.SUB_CLIENTE,
         A.DESCUENTO, A.TOTAL_REF,A.NO_FISICO,A.SERIE_FISICO
   FROM  ARCCMD A,
         ARCCTD B
   WHERE A.NO_CIA = CV_CIA
   AND   B.TIPO_MOV = 'D'
   AND   A.SALDO > 0
   AND   A.GRUPO = CV_GRUPO
   AND   A.NO_CLIENTE = CV_CLIENTE
   AND   A.SUB_CLIENTE = CV_SUBCLIENTE
   AND   A.ESTADO != 'P'
   AND   A.NO_CIA = B.NO_CIA
   AND   A.TIPO_DOC = B.TIPO
   AND   EXISTS --TRAE SOLO LAS FACTURAS QUE PERTENEZCAN AL PAGO REALIZADO
   (SELECT X.NO_CIA FROM ARCCRD X,ARCCMD Y
    WHERE X.NO_CIA=Y.NO_CIA AND X.NO_DOCU=Y.NO_DOCU
     AND X.NO_DOCU=PV_DOCU AND X.NO_CIA=A.NO_CIA
     AND X.NO_REFE=A.NO_DOCU);

-- Obtiene el abono por la factura
--MLOPEZ 01/06/2010
--REVISO Q LOS VENCIMIENTOS DE LOS DIVIDENDOS PENDIENTES A LA FECHA DE PROCESO
--ESTEN DENTRO DEL TIEMPO DE GRACIA
--ES DECIR LA FECHA_VENCE + DIAS DE GRACIA NO PASEN DE LA FECHA DE PROCESO
--SI ESTE CURSOR TRAE REGISTROS Y EL CLIENTE ESTA SUSPENDIDO
--NO SE LO ACTIVA
 CURSOR C_ABONO_FACT (CV_CIA     VARCHAR2,
                      CV_CLIENTE VARCHAR2,
                      CV_GRUPO   VARCHAR2,
                      CV_SUBCLIENTE VARCHAR2,
                      CV_TDOC    VARCHAR2,
                      CV_NDOC    VARCHAR2,
                      CD_FECHA   DATE,
                      CN_DIAS_ABONO NUMBER
                      )IS
  SELECT A.NO_CLIENTE,A.SUB_CLIENTE, C.TIPO_DOC, C.NO_DOCU,
         C.MONTO_REFE, C.TIPO_REFE,
         C.NO_REFE,A.FECHA,D.FECHA_VENCE,D.FECHA_VENCE+20 FECHA_TOPE_VENCE,
         D.VALOR,D.VALOR_APLICA,D.SALDO
   FROM  ARCCMD A,
         ARCCTD B,
         ARCCRD C,
         ARCC_DIVIDENDOS D
   WHERE A.NO_CIA = CV_CIA
    AND   B.TIPO_MOV = 'C'
    AND   nvl(A.ind_cobro,'N') = 'S' --- Solo deben estar considerados documentos de cobro ANR 12/08/2009
    AND   A.GRUPO = CV_GRUPO
    AND   A.NO_CLIENTE = CV_CLIENTE
    AND   A.SUB_CLIENTE = CV_SUBCLIENTE
    AND   C.TIPO_REFE = CV_TDOC
    AND   C.NO_REFE = CV_NDOC
    AND   A.M_ORIGINAL != A.SALDO
    AND   A.ESTADO != 'P'
    AND   A.NO_CIA = B.NO_CIA
    AND   A.TIPO_DOC = B.TIPO
    AND   A.NO_CIA = C.NO_CIA
    AND   A.NO_DOCU = C.NO_DOCU
    AND   D.NO_CIA=C.NO_CIA
    AND   D.NO_DOCU=C.no_REFE
    AND   nvl(d.saldo,0)>0
    AND   d.FECHA_vence <= CD_FECHA
    AND   D.FECHA_VENCE+CN_DIAS_ABONO > CD_FECHA;

 -- Declaracion de variables locales.
 LE_ERROR       EXCEPTION;
 LV_ERROR       VARCHAR2(200);
 LV_INDICADOR   VARCHAR2(1);
 LV_ESTADOCLI   VARCHAR2(1);
 LB_EXISTE      VARCHAR2(1);
 LV_OBSERVACION VARCHAR2(100);
 LN_DIASABONO   NUMBER;
 LN_DIASABONO_ADICIONAL   NUMBER;--ADD MLOPEZ 01/06/2010
 LD_DIAPROCESO  DATE;
 LB_BAND BOOLEAN :=FALSE; --ADD MLOPEZ 01/06/2010

--
BEGIN
 -- Seteo de variables
 LV_INDICADOR := NULL;
 LV_ERROR     := NULL;
 LB_EXISTE    := 'S';
 LV_OBSERVACION := 'CAMBIO DE ESTADO(ACTIVO) POR ABONO, RECIBO #'||PV_DOCU;

 -- Verifica si el motivo tiene configurado si cambia o no de estado el eliente.
 OPEN C_VERIFICA_ACCION(PV_CIA,PV_MOTIVO);
 FETCH C_VERIFICA_ACCION INTO LV_INDICADOR;
 CLOSE C_VERIFICA_ACCION;
 --
 IF LV_INDICADOR = 'S' THEN
    -- Verifica si el cliente tiene el estado de suspendido
    OPEN C_ESTADOCLI(PV_CIA,PV_CLIENTE,PV_GRUPO,PV_SUBCLIENTE);
    FETCH C_ESTADOCLI INTO LV_ESTADOCLI;
    CLOSE C_ESTADOCLI;
    --
    IF LV_ESTADOCLI = 'S' THEN
       --
       OPEN C_DIAPROCESO(PV_CIA,PV_CENTRO);
       FETCH C_DIAPROCESO INTO LD_DIAPROCESO;
       CLOSE C_DIAPROCESO;
       --
       OPEN C_DIASABONO(PV_CIA);
       FETCH C_DIASABONO INTO LN_DIASABONO,LN_DIASABONO_ADICIONAL;--ADD MLOPEZ 01/06/2010
       CLOSE C_DIASABONO;
       --
       FOR REG IN C_FACTVENCIDAS(PV_CIA,PV_CLIENTE,PV_GRUPO, PV_SUBCLIENTE) LOOP
           LB_BAND:=TRUE;--ADD MLOPEZ 01/06/2010 SI TIENE FACTURAS VENCIDAS
           -- Calcular la fecha de prorroga
           --SI HAY ALGUN DIVIDENDO VENCIDO (FECHA_VENCE + DIAS_DE GRACIA SOBREPASAN LA FECHA PROCESO)
           --NO ACTIVA EL CLIENTE
           FOR AB IN C_ABONO_FACT(REG.NO_CIA,REG.NO_CLIENTE,
                                  REG.GRUPO, REG.SUB_CLIENTE, REG.TIPO_DOC,
                                  REG.NO_DOCU,LD_DIAPROCESO,LN_DIASABONO + NVL(LN_DIASABONO_ADICIONAL,0)) LOOP
               LB_EXISTE:='N';--ADD MLOPEZ 01/06/2010
               EXIT;--ADD MLOPEZ 01/06/2010
           END LOOP;
           --
           IF LB_EXISTE = 'N' THEN
              EXIT;
           END IF;
           --
           --COMMENT MLOPEZ 01/06/2010 LD_FECHA_ABONO:= NULL;
       END LOOP;
       --
    END IF;
    --
    IF LB_EXISTE = 'S' AND LB_BAND=TRUE THEN
       /** Si el cliente es activado y tiene un pedido pendiente de
           aprobacion tambien debe autorizarse de manera automatica. ANR 12/08/2009 ***/
       --- Se va a estado de picking, cuando al pedido se le aprueba por estado suspendido
       Update Arfafec
        set    estado          = 'Z',
               aprobado        = 'S',
               fecha_aprueba   = sysdate,
               usuario_aprueba = user,
               observ1 = substr(observ1||' PEDIDO APROBADO AUTOMATICAMENTE POR CAMBIO DE ESTADO DEL SUBCLIENTE',1,500)
        where  no_cia    = Pv_cia
        and    grupo     = Pv_grupo
        and    no_cliente = Pv_cliente
        and    subcliente = Pv_subcliente
        and    estado = 'A';

       -- actualiza estado de cliente y registra en historicos de estados
       CC_PACTUALIZACION(P_CIA          => PV_CIA,
                         P_CLIENTE      => PV_CLIENTE,
                         P_SUBCLIENTE   => PV_SUBCLIENTE,
                         P_GRUPO        => PV_GRUPO,
                         P_NUEVOESTADO  => 'A',
                         P_ERROR        => LV_ERROR
                        );
       IF LV_ERROR IS NOT NULL THEN
          RAISE LE_ERROR;
       END IF;
       -- Inserta historico de estados de clientes.
       CC_PINSERTA(P_CIA          => PV_CIA,
                   P_CLIENTE      => PV_CLIENTE,
                   P_SUBCLIENTE   => PV_SUBCLIENTE,
                   P_MOTIVO       => PV_MOTIVO,
                   P_ESTADOCLI    => LV_ESTADOCLI,
                   P_NUEVOESTADO  => 'A',
                   P_TIPOREGISTRO => 'A',
                   P_OBSERVACION  => LV_OBSERVACION,
                   P_ERROR        => LV_ERROR
                  );

       IF LV_ERROR IS NOT NULL THEN
          RAISE LE_ERROR;
       END IF;
       --
       PV_RESULTADO := 'S';
       --
    END IF;
    --
 ELSE
    PV_RESULTADO := 'N';
 END IF;
 --
EXCEPTION
 WHEN LE_ERROR THEN
  PV_ERROR := LV_ERROR;
  PV_RESULTADO := 'N';
 WHEN OTHERS THEN
  PV_ERROR := SUBSTR(SQLERRM,1,100);
  PV_RESULTADO := 'N';
END;

----------------------------------------------------------------------------------------------
-- Procedimiento que permite suspender un cliente si realiza un pago a una factura con chueque
-- cuya fecha excede el limite de creditos concedido.
----------------------------------------------------------------------------------------------
PROCEDURE CC_PCKDESFASE(PV_CIA        IN VARCHAR2,
                        PV_CENTRO     IN VARCHAR2,
                        PV_CLIENTE    IN VARCHAR2,
                        PV_SUBCLIENTE IN VARCHAR2,
                        PV_GRUPO      IN VARCHAR2,
                        PV_MOTIVO     IN VARCHAR2,
                        PV_RESULTADO  OUT VARCHAR2,
                        PV_ERROR      OUT VARCHAR2
                       )IS

-- Declaracion de cursores
 -- obtiene el valor si aplica o no el cambio de estado
 CURSOR C_VERIFICA_ACCION(CV_CIA    VARCHAR2,
                          CV_MOTIVO VARCHAR2
                          ) IS
  SELECT O.CAMBIO_ESTADO_CLI
   FROM ARCCMOTIVOS O
   WHERE O.NO_CIA = CV_CIA
   AND   O.MOTIVO = CV_MOTIVO
   AND   O.PROTESTO_CK = 'N';

 -- obtiene el valor si el cliente esta suspendido
  CURSOR C_ESTADOCLI(CV_CIA        VARCHAR2,
                     CV_CLIENTE    VARCHAR2,
                     CV_GRUPO      VARCHAR2,
                     CV_SUBCLIENTE VARCHAR2
                     ) IS
   SELECT LC.ESTADO
    FROM  ARCCLOCALES_CLIENTES LC
    WHERE LC.NO_CIA = CV_CIA
    AND   LC.GRUPO = CV_GRUPO
    AND   LC.NO_CLIENTE = CV_CLIENTE
    AND   LC.NO_SUB_CLIENTE = CV_SUBCLIENTE;

 --- Obtienes la factura con saldo
 CURSOR C_FACTSALDO(CV_CIA     VARCHAR2,
                    CV_CLIENTE VARCHAR2,
                    CV_GRUPO   VARCHAR2,
                    CV_SUBCLIENTE VARCHAR2
                    )IS
  SELECT A.NO_CIA,A.CENTRO,A.TIPO_DOC,A.GRUPO,
         A.NO_DOCU,A.NO_CLIENTE,A.FECHA,
         A.FECHA_VENCE,A.M_ORIGINAL,A.SALDO,
         A.DESCUENTO, A.TOTAL_REF,A.NO_FISICO,A.SERIE_FISICO, A.SUB_CLIENTE
   FROM ARCCMD A,
        ARCCTD B
   WHERE A.NO_CIA = CV_CIA
   AND   B.TIPO_MOV = 'D'
   AND   A.SALDO > 0
   AND   A.GRUPO = CV_GRUPO
   AND   A.NO_CLIENTE = CV_CLIENTE
   AND   A.SUB_CLIENTE = CV_SUBCLIENTE
   AND   A.ESTADO != 'P'
   AND   A.NO_CIA = B.NO_CIA
   AND   A.TIPO_DOC = B.TIPO;

 -- obtiene el cobro
 CURSOR C_COBRO (CV_CIA     VARCHAR2,
                 CV_CLIENTE VARCHAR2,
                 CV_GRUPO   VARCHAR2,
                 CV_SUBCLIENTE VARCHAR2,
                 CV_TDOC    VARCHAR2,
                 CV_NDOC    VARCHAR2
                 )IS
   SELECT C.TIPO_DOC, C.NO_DOCU,
          C.MONTO_REFE, C.TIPO_REFE,
          C.NO_REFE
    FROM  ARCCMD A,
          ARCCTD B,
          ARCCRD C
    WHERE A.NO_CIA = CV_CIA
    AND   B.TIPO_MOV = 'C'
    AND   A.GRUPO = CV_GRUPO
    AND   A.NO_CLIENTE = CV_CLIENTE
    AND   A.SUB_CLIENTE = CV_SUBCLIENTE
    AND   C.TIPO_REFE = CV_TDOC
    AND   C.NO_REFE = CV_NDOC
    AND   A.M_ORIGINAL != A.SALDO
    AND   A.ESTADO != 'P'
    AND   A.NO_CIA = B.NO_CIA
    AND   A.TIPO_DOC = B.TIPO
    AND   A.NO_CIA = C.NO_CIA
    AND   A.NO_DOCU = C.NO_DOCU;

 -- obtiene los pagos de un documento que sea de tipo cheque
 CURSOR PAGOS_CK(CV_CIA   VARCHAR2,
                 CV_NDOC  VARCHAR2
                )IS
  SELECT PA.*
   FROM  ARCCFPAGOS PA
   WHERE PA.NO_CIA = CV_CIA
   AND   PA.NO_DOCU = CV_NDOC
   AND   PA.ID_FORMA_PAGO = (SELECT P.FORMA_PAGO
                              FROM ARCCFORMA_PAGO P
                              WHERE P.NO_CIA = CV_CIA
                              AND   P.CHEQUE = 'S'
                             );

-- obtiene el maximo de fecha_vence para ser validado.
 CURSOR DIVIDENDO(CV_CIA    VARCHAR2,
                  CV_CENTRO VARCHAR2,
                  CV_FACT   VARCHAR2
                 )IS
  SELECT  MAX(DV.FECHA_VENCE) FECHA_VENCE
   FROM  ARFADIVIDENDOS DV
   WHERE DV.NO_CIA = CV_CIA
   AND   DV.CENTROD = CV_CENTRO
   AND   DV.NO_FACTU = CV_FACT;

 -- Declaracion de variables locales.
 LE_ERROR       EXCEPTION;
 LV_ERROR       VARCHAR2(200);
 LV_INDICADOR   VARCHAR2(1);
 LV_ESTADOCLI   VARCHAR2(1);
 LB_EXISTE      VARCHAR2(1);
 LV_OBSERVACION VARCHAR2(100);
 LD_FECHA_CK    DATE;
 LD_FECHA_DIV   DATE;

--
BEGIN
 -- Seteo de variables
 LV_INDICADOR := NULL;
 LV_ERROR     := NULL;
 LB_EXISTE    := 'N';
 LV_OBSERVACION := 'CAMBIO DE ESTADO(SUSPENDIDO) POR CHEQUE DESFASADO';

 -- Verifica si el motivo tiene configurado si cambia o no de estado el eliente.
 OPEN C_VERIFICA_ACCION(PV_CIA,PV_MOTIVO);
 FETCH C_VERIFICA_ACCION INTO LV_INDICADOR;
 CLOSE C_VERIFICA_ACCION;
 --
 IF LV_INDICADOR = 'S' THEN
   -- Verifica si el cliente tiene el estado de activo
   OPEN C_ESTADOCLI(PV_CIA,PV_CLIENTE,PV_GRUPO,PV_SUBCLIENTE);
   FETCH C_ESTADOCLI INTO LV_ESTADOCLI;
   CLOSE C_ESTADOCLI;
   --
   IF LV_ESTADOCLI = 'A' THEN
   --
     FOR REG IN C_FACTSALDO(PV_CIA,PV_CLIENTE,PV_GRUPO, PV_SUBCLIENTE) LOOP
       FOR CO IN C_COBRO(REG.NO_CIA,REG.NO_CLIENTE,
                         REG.GRUPO, REG.SUB_CLIENTE, REG.TIPO_DOC,REG.NO_DOCU)LOOP

         FOR FG IN PAGOS_CK(REG.NO_CIA,CO.NO_DOCU) LOOP
           LD_FECHA_CK := FG.FECHA_CONFIRMACION;
           --
           OPEN DIVIDENDO(FG.NO_CIA,PV_CENTRO,FG.NO_DOCU);
           FETCH DIVIDENDO INTO LD_FECHA_DIV;
           CLOSE DIVIDENDO;
           --
           IF LD_FECHA_CK < LD_FECHA_DIV THEN
             LB_EXISTE:= 'S';
             EXIT;
           END IF;
           --
         END LOOP;
       END LOOP;
      --
     END LOOP;
   --
   ELSIF LV_ESTADOCLI = 'S' THEN
    LV_ERROR := 'No se puede cambiar el estado del cliente, tiene estado de suspendido';
    RAISE LE_ERROR;
   END IF;
   --
   IF LB_EXISTE = 'S' THEN
     -- actualiza estado de cliente y registra en historicos de estados
     CC_PACTUALIZACION(P_CIA          => PV_CIA,
                       P_CLIENTE      => PV_CLIENTE,
                       P_SUBCLIENTE   => PV_SUBCLIENTE,
                       P_GRUPO        => PV_GRUPO,
                       P_NUEVOESTADO  => 'S',
                       P_ERROR        => LV_ERROR
                       );
     IF LV_ERROR IS NOT NULL THEN
       RAISE LE_ERROR;
     END IF;
     -- Inserta historico de estados de clientes.
     CC_PINSERTA(P_CIA          => PV_CIA,
                 P_CLIENTE      => PV_CLIENTE,
                 P_SUBCLIENTE   => PV_SUBCLIENTE,
                 P_MOTIVO       => PV_MOTIVO,
                 P_ESTADOCLI    => LV_ESTADOCLI,
                 P_NUEVOESTADO  => 'S',
                 P_TIPOREGISTRO => 'A',
                 P_OBSERVACION  => LV_OBSERVACION,
                 P_ERROR        => LV_ERROR
                 );
     IF LV_ERROR IS NOT NULL THEN
       RAISE LE_ERROR;
     END IF;
   --
   PV_RESULTADO := 'S';
   END IF;
   --
 ELSE
  PV_RESULTADO := 'N';
 END IF;
--
EXCEPTION
 WHEN LE_ERROR THEN
  PV_ERROR := LV_ERROR;
  PV_RESULTADO := 'N';
 WHEN OTHERS THEN
  PV_ERROR := SUBSTR(SQLERRM,1,100);
  PV_RESULTADO := 'N';
END;

----------------------------------------------------------------------------------------------
-- Procedimiento que permite suspender un cliente si realiza un pago a una factura con cheque
-- cuya fecha excede el limite de creditos concedido.
----------------------------------------------------------------------------------------------
PROCEDURE CC_PCKPROTESTO(PV_CIA        IN VARCHAR2,
                         PV_CLIENTE    IN VARCHAR2,
                         PV_SUBCLIENTE IN VARCHAR2, -- CREAR CAMPO NO_SUB_CLIENTE , CREAR FK CON LOCALESCLIENTES Y A?ADIR UNA LISTA DE VALORES AL MOMENTO DE CREAR UN REGISTRO EN DEVOLUCIOMES DE CHEQUE.
                         PV_GRUPO      IN VARCHAR2,
                         PV_MOTIVO     IN VARCHAR2,
                         PV_RESULTADO  OUT VARCHAR2,
                         PV_ERROR      OUT VARCHAR2
                        )IS

-- Declaracion de cursores
 CURSOR C_MOTIVOS (CV_CIA VARCHAR2,
                   CV_MOTIVO VARCHAR2
                   )IS
  SELECT S.CAMBIO_ESTADO_CLI
   FROM ARCCMOTIVOS S
   WHERE S.PROTESTO_CK = 'S'
   AND S.NO_CIA = CV_CIA
   AND S.MOTIVO = CV_MOTIVO;

 -- obtiene el valor si el cliente esta suspendido
 CURSOR C_ESTADOCLI(CV_CIA        VARCHAR2,
                    CV_CLIENTE    VARCHAR2,
                    CV_GRUPO      VARCHAR2,
                    CV_SUBCLIENTE VARCHAR2
                    ) IS
   SELECT LC.ESTADO
    FROM  ARCCLOCALES_CLIENTES LC
    WHERE LC.NO_CIA = CV_CIA
    AND   LC.GRUPO = CV_GRUPO
    AND   LC.NO_CLIENTE = CV_CLIENTE
    AND   LC.NO_SUB_CLIENTE = CV_SUBCLIENTE;

-- Declaracion de variables
 LV_CAMBIAESTADO VARCHAR2(1);
 LV_ESTADOCLI    VARCHAR2(1);
 LV_OBSERVACION  VARCHAR2(100);
 LE_ERROR        EXCEPTION;
 LV_ERROR        VARCHAR2(200);
--
BEGIN
 -- SETEAR VARIABLES
 LV_CAMBIAESTADO := NULL;
 --
 OPEN C_MOTIVOS(PV_CIA,PV_MOTIVO);
 FETCH C_MOTIVOS INTO LV_CAMBIAESTADO;
 CLOSE C_MOTIVOS;
 -- Verifica si el cliente tiene el estado de activo
 OPEN C_ESTADOCLI(PV_CIA,PV_CLIENTE,PV_GRUPO,PV_SUBCLIENTE);
 FETCH C_ESTADOCLI INTO LV_ESTADOCLI;
 CLOSE C_ESTADOCLI;
 --
 IF LV_CAMBIAESTADO = 'S' THEN
   -- actualiza estado de cliente y registra en historicos de estados
   CC_PACTUALIZACION(P_CIA          => PV_CIA,
                     P_CLIENTE      => PV_CLIENTE,
                     P_SUBCLIENTE   => PV_SUBCLIENTE,
                     P_GRUPO        => PV_GRUPO,
                     P_NUEVOESTADO  => 'S',
                     P_ERROR        => LV_ERROR
                     );
   IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
   END IF;
   -- Inserta historico de estados de clientes.
   CC_PINSERTA(P_CIA          => PV_CIA,
               P_CLIENTE      => PV_CLIENTE,
               P_SUBCLIENTE   => PV_SUBCLIENTE,
               P_MOTIVO       => PV_MOTIVO,
               P_ESTADOCLI    => LV_ESTADOCLI,
               P_NUEVOESTADO  => 'S',
               P_TIPOREGISTRO => 'A',
               P_OBSERVACION  => NVL(LV_OBSERVACION,'CAMBIO DE ESTADO POR PROTESTO DE CHEQUE'),
               P_ERROR        => LV_ERROR
               );
   IF LV_ERROR IS NOT NULL THEN
     RAISE LE_ERROR;
   END IF;
   --
   PV_RESULTADO := 'S';
 ELSE
   PV_RESULTADO := 'N';
 --
 END IF;
--
EXCEPTION
 WHEN LE_ERROR THEN
  PV_ERROR := LV_ERROR;
  PV_RESULTADO := 'N';
 WHEN OTHERS THEN
  PV_ERROR := SUBSTR(SQLERRM,1,100);
  PV_RESULTADO := 'N';
END;

-------------------------------------------------------------------------
-- Procedimiento que permite realizar actualizacion de estado al cliente.
-- Cambiar la tabla y utilizar ARCCLOCALES_CLIENTES
-------------------------------------------------------------------------
PROCEDURE CC_PACTUALIZACION(P_CIA          IN VARCHAR2,
                            P_CLIENTE      IN VARCHAR2,
                            P_SUBCLIENTE   IN VARCHAR2,
                            P_GRUPO        IN VARCHAR2,
                            P_NUEVOESTADO  IN VARCHAR2,
                            P_ERROR        OUT VARCHAR2
                           )IS
-- Declaracion de variables
 LV_ERROR VARCHAR2(200);
--
BEGIN
 -- Se actualiza el estado del cliente
 UPDATE ARCCLOCALES_CLIENTES LC
   SET   LC.ESTADO = P_NUEVOESTADO
   WHERE LC.NO_CIA = P_CIA
   AND   LC.GRUPO = P_GRUPO
   AND   LC.NO_CLIENTE = P_CLIENTE
   AND   LC.NO_SUB_CLIENTE = P_SUBCLIENTE;
 --
 IF SQL%NOTFOUND THEN
  LV_ERROR := 'Registro no pudo ser modificado ';
  P_ERROR := LV_ERROR;
 END IF;
--
EXCEPTION
 WHEN  OTHERS THEN
  LV_ERROR := SUBSTR('Error: '||SQLERRM,1,180);
  P_ERROR := LV_ERROR;
 -- ROLLBACK; -- Verificar si despues se lo quita para trabajar con el roolback de las formas que lo llamaran.
END;

-----------------------------------------------------------------------------------
-- Procedimiento que permite realizar insertar un historico de estado del cliente.
-----------------------------------------------------------------------------------
PROCEDURE CC_PINSERTA(P_CIA          IN VARCHAR2,
                      P_CLIENTE      IN VARCHAR2,
                      P_SUBCLIENTE   IN VARCHAR2,
                      P_MOTIVO       IN VARCHAR2,
                      P_ESTADOCLI    IN VARCHAR2,
                      P_NUEVOESTADO  IN VARCHAR2,
                      P_TIPOREGISTRO IN VARCHAR2,
                      P_OBSERVACION  IN VARCHAR2,
                      P_ERROR        OUT VARCHAR2
                      )IS

 -- Declaracion de variables
 LV_ERROR VARCHAR2(200);
--
BEGIN
 --
 INSERT INTO ARCC_HISTESTADOCLI(NO_CIA,
                                NO_CLIENTE,
                                NO_SUBCLIENTE,
                                MOTIVO,
                                ESTADO_ACTUAL,
                                ESTADO_NUEVO,
                                TIPO_REGISTRO,
                                FECHA_CAMBIO,
                                OBSERVACION,
                                USUARIO,
                                T_STAMP
                                )
                         VALUES (P_CIA,
                                 P_CLIENTE,
                                 P_SUBCLIENTE,
                                 P_MOTIVO,
                                 P_ESTADOCLI,
                                 P_NUEVOESTADO,
                                 P_TIPOREGISTRO,
                                 SYSDATE,
                                 P_OBSERVACION,
                                 USER,
                                 SYSDATE
                                );

EXCEPTION
 WHEN  OTHERS THEN
  LV_ERROR := SUBSTR('Error: '||SQLERRM,1,180);
  P_ERROR  := LV_ERROR;
END;

end CCACCIONES_CLIENTES;
/
