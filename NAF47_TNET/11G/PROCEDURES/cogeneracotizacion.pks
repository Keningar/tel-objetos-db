create or replace procedure            cogeneracotizacion( pcia in  Varchar2,psolic in varchar2, msg_error out varchar2) is

--pmsg_error out Varchar2

--- Procedimiento para generar varias cotizaciones de una solicitud
--- Tomar en cuenta de llenar los campos de adjudicacion (Cantidad adjudicada,
--- empleado adjudicado, costo)


   VPROV     TAPICOTI.NO_PROVE%TYPE;
   VLINEA    NUMBER (2);
   LIN       TAPCOTID.NO_LINEA%TYPE;
   DUMMY     VARCHAR2(1);
   ART_PROV  TAPPRODU.COD_ART_PROV%TYPE;
   MEDIDA    TAPPRODU.MEDIDA%TYPE;
   PCOTI     NUMBER;


   CURSOR ENC IS
      SELECT DISTINCT NO_PROVE
      FROM TAPICOTI C, TAPBIENE E
      WHERE C.NO_CIA   = pCIA AND
            E.NO_CIA   = C.NO_CIA AND
            E.NO_SOLIC = C.NO_SOLIC AND
            E.ESTADO   = 'P' AND
            C.ELABORA_PEDIDO = 'S' AND
            TO_NUMBER(E.NO_SOLIC) = TO_NUMBER(psolic);

   CURSOR DET IS
     SELECT D.NO_ARTI,  D.CODIGO_NI,
            D.DESCRIPCION, D.CANTIDAD,  D.MEDIDA ,  D.NO_LINEA, D.NO_SOLIC,
            I.COSTO

     FROM   TAPICOTI I, TAPBIEND D, TAPBIENE E
     WHERE  I.NO_CIA   = PCIA AND
            I.NO_CIA   = D.NO_CIA    AND
            I.NO_PROVE = VPROV       AND
            I.NO_SOLIC = D.NO_SOLIC  AND
            E.NO_SOLIC = D.NO_SOLIC  AND
            I.NO_LINEA = D.NO_LINEA  AND
            E.ESTADO = 'P'           AND
            I.ELABORA_PEDIDO = 'S'   AND
            TO_NUMBER(E.NO_SOLIC) = TO_NUMBER(PSOLIC);




begin
   --Para cada proveedor.
   FOR E IN ENC LOOP

       --Obtengo consecutivo de cotizacion.

      --PULT_COTI := LPAD(TO_CHAR(TO_NUMBER(PULT_COTI)+1),8,'0');

      Pcoti := consecutivo.co(pcia,
                                       to_number(to_char(sysdate,'MM')),
                                       to_number(to_char(sysdate,'RRRR')),
                                       'COTIZACION',
                                       'NUMERO');
      --Inserto encabezado de cotizacion.
      INSERT INTO TAPCOTIE (NO_CIA, NO_COTIZ, FECHA, NO_PROVE)
      VALUES (PCIA, PCOTI, SYSDATE, E.NO_PROVE);

      VPROV  := E.NO_PROVE;
      VLINEA := 1;

      --Para cada linea de la solicitud con ese proveedor:
      FOR D IN DET LOOP
        --Verifica si ya inserto una linea con ese articulo. Y si es asi,
        --aumenta la cantidad, de lo contrario, la inserta. En ambos,casos
        --inserto el registro en la tabla con la relacion de la  solicitud
        --con el documento (en este caso la cotizacion).

        -- selecciona el codigo del articulo del proveedor
        begin
          select cod_art_prov
            into art_prov
            from tapprodu
           where no_cia    = pcia     and
                 no_prove  = vprov       and
                 no_arti   = d.no_arti   and
                 (d.codigo_ni IS NULL OR codigo_ni = d.codigo_ni);
        exception
        	when no_data_found then
                art_prov := null;
          when too_many_rows then null;
        end;


        UPDATE TAPCOTID
        SET CANTIDAD = NVL(CANTIDAD,0) + D.CANTIDAD
        WHERE  no_cia   = pcia     AND
               NO_COTIZ = PCOTI  AND
             (
              (NO_ARTI   = D.NO_ARTI      AND
               UPPER(MEDIDA) = UPPER(D.MEDIDA)
              )
               OR
              (UPPER(DESCRIPCION) = UPPER(D.DESCRIPCION) AND
               UPPER(MEDIDA)      = UPPER(D.MEDIDA)
              )
             );


        IF SQL%NOTFOUND THEN
         Begin

         INSERT INTO TAPCOTID (NO_CIA, NO_COTIZ, NO_LINEA,  NO_ARTI, COD_ART_PROV,
                               CANTIDAD,DESCRIPCION,MEDIDA,ADJUDICADO, costo_uni)
                 VALUES (PCIA, PCOTI, VLINEA, D.NO_ARTI, ART_PROV,
                         D.CANTIDAD,D.DESCRIPCION,D.MEDIDA, D.CANTIDAD, d.costo);

         INSERT INTO TAPSOLDOC (NO_CIA, NO_SOLIC,
                                NO_LINEA_S, NO_DOCU, NO_LINEA_D, TIPO)
                    VALUES    (PCIA,D.NO_SOLIC,
                                D.NO_LINEA,PCOTI,VLINEA,'C');


         VLINEA := VLINEA + 1;


         End;


        ELSIF SQL%FOUND THEN
          BEGIN

           SELECT NO_LINEA
           INTO LIN
           FROM TAPCOTID
           WHERE NO_CIA   = PCIA    AND
                 NO_COTIZ = PCOTI AND
           (
            (NO_ARTI   = D.NO_ARTI      AND
             UPPER(MEDIDA) = UPPER(D.MEDIDA)
            )
             OR
            (UPPER(DESCRIPCION) = UPPER(D.DESCRIPCION) AND
             UPPER(MEDIDA)      = UPPER(D.MEDIDA)
            )
           );



          INSERT INTO TAPSOLDOC (NO_CIA, NO_SOLIC,
                                 NO_LINEA_S, NO_DOCU, NO_LINEA_D, TIPO)
                       VALUES (PCIA,D.NO_SOLIC ,
                               D.NO_LINEA,PCOTI,LIN, 'C');


          exception when NO_DATA_FOUND then
            -- message('ERROR: Inconsistencias ',acknowledge);
           null;
         END;
        END IF;


        -- Actualiza el Historico de fechas
        BEGIN
          SELECT 'X'
            INTO dummy
            FROM TAPHSOLI
           WHERE NO_CIA = PCIA AND
                 NO_SOLIC = D.NO_SOLIC AND
                 ESTADO = 'C';
          EXCEPTION WHEN No_Data_Found THEN
            INSERT INTO TAPHSOLI (NO_CIA,NO_SOLIC,FECHA_F,ESTADO)
            VALUES (PCIA,D.NO_SOLIC,SYSDATE,'C');
        END;

       END LOOP;

   END LOOP;

  --Cambio el estado de la solicitud.
      UPDATE TAPBIENE
      SET ESTADO = 'C'
      WHERE NO_CIA = PCIA  AND
            ESTADO = 'P' AND
            TO_NUMBER(NO_SOLIC) = TO_NUMBER(PSOLIC);

      --Borro los registros de TAPICOTI que ya se generaron.
   DELETE TAPICOTI
      WHERE NO_CIA = PCIA AND
      TO_NUMBER(NO_SOLIC) = TO_NUMBER(PSOLIC);

  EXCEPTION
  WHEN CONSECUTIVO.error THEN
     msg_error := 'Error al generar consecutivo de Cotizacion : '||msg_error;
     return;
  WHEN OTHERS THEN
     msg_error := 'Error al generar Cotizacion : '||sqlerrm;
     return;
END;