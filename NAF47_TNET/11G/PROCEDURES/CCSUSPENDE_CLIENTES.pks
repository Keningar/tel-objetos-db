create or replace PROCEDURE            CCSUSPENDE_CLIENTES IS
BEGIN
DECLARE
LV_DOCS VARCHAR2(2000);
BEGIN
  FOR REG IN (
               SELECT MD.NO_CIA, MD.CENTRO, MD.GRUPO, MD.NO_CLIENTE, MD.SUB_CLIENTE,
                      SUC.ESTADO ESTADO_ANTERIOR, COUNT(*) NDOCS
                 FROM ARCC_DIVIDENDOS DV, ARCCMD MD, ARCCTD TD, ARCCLOCALES_CLIENTES SUC
                WHERE DV.SALDO>0 AND DV.FECHA_VENCE + 10 < TRUNC(SYSDATE)
                  AND DV.NO_CIA  = MD.NO_CIA
                  AND DV.NO_DOCU = MD.NO_DOCU
                  AND MD.NO_CIA   = TD.NO_CIA
                  AND MD.TIPO_DOC = TD.TIPO
                  AND MD.NO_CIA  = SUC.NO_CIA
                  AND MD.GRUPO   = SUC.GRUPO
                  AND MD.NO_CLIENTE = SUC.NO_CLIENTE
                  AND MD.SUB_CLIENTE = SUC.NO_SUB_CLIENTE
                  AND MD.GRUPO NOT IN ('06','07')
                  AND (MD.SALDO > md.m_original*0.01)
                  AND TD.TIPO_MOV = 'D'
                  GROUP BY MD.NO_CIA, MD.CENTRO, MD.GRUPO, MD.NO_CLIENTE, MD.SUB_CLIENTE,
                      SUC.ESTADO
                ) LOOP

      UPDATE ARCCLOCALES_CLIENTES
         SET ESTADO = 'S'
       WHERE NO_CIA      = REG.NO_CIA
         AND NO_CLIENTE  = REG.NO_CLIENTE
         AND NO_SUB_CLIENTE = REG.SUB_CLIENTE;
      LV_DOCS := NULL;
      FOR DAT IN (SELECT MD.SERIE_FISICO, MD.NO_FISICO, DV.DIVIDENDO
                    FROM ARCC_DIVIDENDOS DV, ARCCMD MD, ARCCTD TD
                   WHERE DV.SALDO>0 AND DV.FECHA_VENCE + 10 < TRUNC(SYSDATE)
                     AND DV.NO_CIA  = MD.NO_CIA
                     AND DV.NO_DOCU = MD.NO_DOCU
                     AND MD.NO_CIA   = TD.NO_CIA
                     AND MD.TIPO_DOC = TD.TIPO
                     AND MD.NO_CIA  = REG.NO_CIA
                     AND MD.GRUPO   = REG.GRUPO
                     AND MD.NO_CLIENTE = REG.NO_CLIENTE
                     AND MD.SUB_CLIENTE = REG.SUB_CLIENTE
                     AND MD.GRUPO NOT IN ('06','07')
                     AND (MD.SALDO > md.m_original*0.01)
                     AND TD.TIPO_MOV = 'D') LOOP

          LV_DOCS := LV_DOCS || DAT.NO_FISICO||'-'||DAT.DIVIDENDO||',';

      END LOOP;

      INSERT INTO arcc_histestadocli
       ( no_cia,
         no_cliente,
         no_subcliente,
         motivo,
         estado_actual,
         estado_nuevo,
         tipo_registro,
         fecha_cambio,
         observacion,
         usuario,
         t_stamp)
       VALUES
       ( REG.no_cia,
         REG.no_cliente,
         REG.sub_cliente,
         'CM',
         REG.ESTADO_ANTERIOR,
         'S',
         'A',
         SYSDATE,
         SUBSTR('PROC.REV.VENCTOS.AUT. '||SYSDATE||' DOCS.'||LV_DOCS,1,200),
         USER,
         SYSDATE);
  END LOOP;
END;
END CCSUSPENDE_CLIENTES;